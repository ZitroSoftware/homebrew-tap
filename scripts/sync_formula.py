#!/usr/bin/env python3
"""Generate the Homebrew formula from verified releases on ZITRO's servers."""
import hashlib
from pathlib import Path
import re
import tempfile
import urllib.request

BASE = "https://zitro.sh/dl"
ROOT = Path(__file__).resolve().parents[1]
PLATFORMS = ("darwin", "linux")
ARCHITECTURES = ("amd64", "arm64")


class NoRedirects(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise ValueError("Release downloads must stay on zitro.sh; redirects are rejected")


OPENER = urllib.request.build_opener(NoRedirects)


def fetch(path, limit):
    with OPENER.open(f"{BASE}/{path}", timeout=60) as response:
        data = response.read(limit + 1)
        if len(data) > limit:
            raise ValueError(f"Release file exceeds size limit: {path}")
        return data


def version_tuple(version):
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise ValueError("Expected a stable major.minor.patch release")
    return tuple(int(part) for part in version.split("."))


def read_latest():
    version = fetch("latest.txt", 128).decode("ascii").strip()
    version_tuple(version)
    return version


def read_manifest(version, text):
    expected = {f"zitro_{version}_{system}_{arch}.tar.gz"
                for system in PLATFORMS for arch in ARCHITECTURES}
    expected |= {f"zitro_{version}_windows_{arch}.zip" for arch in ARCHITECTURES}
    expected |= {f"zitro_{version}_{arch}.{ext}"
                 for arch in ARCHITECTURES for ext in ("deb", "rpm")}
    hashes = {}
    for line in text.splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})  ([A-Za-z0-9_.-]+)", line)
        if not match or match[2] in hashes:
            raise ValueError("Malformed or duplicate checksum entry")
        hashes[match[2]] = match[1]
    if set(hashes) != expected:
        raise ValueError("Release manifest must contain all six archives and four Linux packages")
    return hashes


def render(version, hashes, template):
    formula = template.replace("@VERSION@", version).replace("@BASE@", BASE)
    for system in PLATFORMS:
        for arch in ARCHITECTURES:
            name = f"zitro_{version}_{system}_{arch}.tar.gz"
            formula = formula.replace(f"@SHA_{system}_{arch}@", hashes[name])
    if re.search(r"@[A-Za-z0-9_]+@", formula):
        raise ValueError("Unresolved formula placeholder")
    return formula


def sync(root=ROOT):
    version = read_latest()
    hashes = read_manifest(version, fetch(f"{version}/SHA256SUMS", 4096).decode("ascii"))
    formula = render(version, hashes, (root / "templates/zitro.rb.tmpl").read_text())
    target = root / "Formula/zitro.rb"
    current = target.read_text() if target.exists() else ""
    if current == formula:
        print(f"Already up to date: zitro {version}")
        return False
    if current:
        previous = re.search(r'^  version "([^"]+)"$', current, re.MULTILINE)
        if not previous or version_tuple(version) < version_tuple(previous[1]):
            raise ValueError("Release rollback is not permitted")
        if version == previous[1]:
            raise ValueError("Published release changed; immutable checksums must not be replaced")
    for system in PLATFORMS:
        for arch in ARCHITECTURES:
            name = f"zitro_{version}_{system}_{arch}.tar.gz"
            data = fetch(f"{version}/{name}", 64 * 1024 * 1024)
            if hashlib.sha256(data).hexdigest() != hashes[name]:
                raise ValueError(f"Checksum mismatch: {name}")
    if read_latest() != version:
        raise ValueError("Latest changed during verification; retry on the next run")
    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile("w", dir=target.parent, delete=False) as temporary:
        temporary.write(formula)
        temporary_path = Path(temporary.name)
    temporary_path.chmod(0o644)
    temporary_path.replace(target)
    print(f"Verified and updated: zitro {version}; downloads remain on zitro.sh")
    return True


if __name__ == "__main__":
    sync()
