# ZITRO Homebrew tap

Install the ZITRO Cloud CLI on macOS or Linux:

```sh
brew install ZitroSoftware/tap/zitro
```

Update an existing installation:

```sh
brew update
brew upgrade ZitroSoftware/tap/zitro
```

The command is `zitro`. Documentation, API access and alternative installers:
[zitro.sh](https://zitro.sh).

All CLI archives and Linux packages remain hosted on ZITRO's own servers at
`https://zitro.sh/dl/`. This repository contains the Homebrew formula, its template,
release-validation script, tests and the synchronization workflow.

## Automatic updates

The `Sync ZITRO release` workflow checks the stable release metadata on zitro.sh
twice an hour and can also be started manually from the Actions tab. GitHub may
delay scheduled runs. Before updating the formula, it requires a complete
ten-file manifest and verifies the four macOS/Linux archives against SHA256.
It rejects rollbacks, modified immutable releases, redirects and incomplete or
corrupt downloads. The formula is generated from the template in this repository;
downloaded code is never executed by synchronization.

The workflow commits to `main` using GitHub's short-lived repository token. No
credentials for ZITRO's hosting infrastructure are stored on GitHub. The workflow
does not build or publish CLI binaries or create GitHub release downloads.

Scheduled workflows can be disabled by GitHub after prolonged repository
inactivity. Check the Actions tab and re-enable the workflow if needed.

## Existing self-hosted tap

The previous `zitro-sh/tap` remains available at `https://zitro.sh/tap` and continues
to receive releases. Existing installations can keep using that tap. Use the
GitHub command above for new installations; do not install both taps' formulae
side by side.

For support, contact [support@zitro.services](mailto:support@zitro.services).
