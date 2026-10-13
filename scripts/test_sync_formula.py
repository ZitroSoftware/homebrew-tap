import hashlib
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import sync_formula as sync


class SyncFormulaTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        (self.root / "templates").mkdir()
        (self.root / "templates/zitro.rb.tmpl").write_text(
            (sync.ROOT / "templates/zitro.rb.tmpl").read_text())
        self.version = "0.4.2"
        self.archive = b"isolated test payload"
        self.digest = hashlib.sha256(self.archive).hexdigest()
        names = [f"zitro_{self.version}_{system}_{arch}.tar.gz"
                 for system in sync.PLATFORMS for arch in sync.ARCHITECTURES]
        names += [f"zitro_{self.version}_windows_{arch}.zip" for arch in sync.ARCHITECTURES]
        names += [f"zitro_{self.version}_{arch}.{ext}"
                  for arch in sync.ARCHITECTURES for ext in ("deb", "rpm")]
        self.manifest = "".join(f"{self.digest}  {name}\n" for name in names)

    def fetch(self, path, limit):
        if path == "latest.txt":
            return self.version.encode()
        if path.endswith("SHA256SUMS"):
            return self.manifest.encode()
        return self.archive

    def existing_formula(self, version):
        target = self.root / "Formula/zitro.rb"
        target.parent.mkdir(exist_ok=True)
        target.write_text(f'class Zitro < Formula\n  version "{version}"\nend\n')
        return target

    def test_first_release_checks_archives_and_updates_atomically(self):
        with patch.object(sync, "fetch", side_effect=self.fetch) as reader:
            self.assertTrue(sync.sync(self.root))
            self.assertEqual(sum(call.args[0].endswith("tar.gz") for call in reader.call_args_list), 4)
        text = (self.root / "Formula/zitro.rb").read_text()
        self.assertIn('version "0.4.2"', text)
        self.assertEqual(text.count('url "https://zitro.sh/dl/'), 4)
        self.assertNotIn("@SHA", text)

    def test_unchanged_release_does_not_redownload_archives(self):
        with patch.object(sync, "fetch", side_effect=self.fetch):
            sync.sync(self.root)
        with patch.object(sync, "fetch", side_effect=self.fetch) as reader:
            self.assertFalse(sync.sync(self.root))
            self.assertEqual(reader.call_count, 2)

    def test_corrupt_archive_preserves_previous_formula(self):
        target = self.existing_formula("0.4.1")
        previous = target.read_bytes()
        valid_reader = self.fetch
        def corrupted(path, limit):
            return b"corrupt" if path.endswith("tar.gz") else valid_reader(path, limit)
        with patch.object(sync, "fetch", side_effect=corrupted):
            with self.assertRaisesRegex(ValueError, "Checksum mismatch"):
                sync.sync(self.root)
        self.assertEqual(target.read_bytes(), previous)

    def test_incomplete_release_is_rejected(self):
        self.manifest = "\n".join(self.manifest.splitlines()[:-1])
        with patch.object(sync, "fetch", side_effect=self.fetch):
            with self.assertRaisesRegex(ValueError, "all six archives"):
                sync.sync(self.root)
        self.assertFalse((self.root / "Formula/zitro.rb").exists())

    def test_duplicate_manifest_entry_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "duplicate"):
            sync.read_manifest(self.version, self.manifest + self.manifest.splitlines()[0])

    def test_changed_immutable_release_is_rejected(self):
        self.existing_formula(self.version)
        with patch.object(sync, "fetch", side_effect=self.fetch):
            with self.assertRaisesRegex(ValueError, "immutable"):
                sync.sync(self.root)

    def test_rollback_is_rejected(self):
        self.existing_formula("0.4.3")
        with patch.object(sync, "fetch", side_effect=self.fetch):
            with self.assertRaisesRegex(ValueError, "rollback"):
                sync.sync(self.root)

    def test_invalid_version_is_rejected_before_archive_requests(self):
        self.version = "../private"
        with patch.object(sync, "fetch", side_effect=self.fetch) as reader:
            with self.assertRaisesRegex(ValueError, "stable"):
                sync.sync(self.root)
            self.assertEqual(reader.call_count, 1)

    def test_latest_change_during_download_preserves_previous_formula(self):
        target = self.existing_formula("0.4.1")
        previous = target.read_bytes()
        with patch.object(sync, "fetch", side_effect=self.fetch), \
                patch.object(sync, "read_latest", side_effect=["0.4.2", "0.4.3"]):
            with self.assertRaisesRegex(ValueError, "Latest changed"):
                sync.sync(self.root)
        self.assertEqual(target.read_bytes(), previous)

    def test_redirects_are_rejected(self):
        with self.assertRaisesRegex(ValueError, "redirects"):
            sync.NoRedirects().redirect_request(None, None, 302, "Found", {}, "https://example.test/binary")


if __name__ == "__main__":
    unittest.main()
