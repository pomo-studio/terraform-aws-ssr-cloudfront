# Changelog

All notable changes to this module are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and versions follow [Semantic Versioning](https://semver.org/).

## [v0.3.0] - 2026-09-06

### Added

- `static_root_path_patterns` — path patterns served from the static assets origin instead of the SSR Lambda. Root-level files such as `robots.txt`, `sitemap.xml` and `apple-touch-icon.png` ship with the static assets but previously resolved against the Lambda and returned 404, since only `/favicon.ico` was routed. Defaults to `["/favicon.ico"]`, preserving existing behaviour.

### Fixed

- terraform-docs drift check passed an unsupported `--check` flag and failed on every run without comparing anything; it now uses the action's `fail-on-diff`.

## [0.2.2] - 2026-09-05

### Added

- terraform-docs-generated interface documentation in README (Requirements/Providers/Inputs/Outputs) with a CI drift check.

## [0.2.1] - 2026-09-05

### Added

- CHANGELOG.md.

## [0.2.0] - 2026-09-04

### Added

- CI (terraform.yml) and release (release.yml) workflows.
- `.tflint.hcl` linting configuration.
- MIT LICENSE file.
- README badges and example `terraform` configuration block.
- Committed `.terraform.lock.hcl` lock files.

### Changed

- AWS provider constraint relaxed to `>= 5.0, < 7.0`.

> Historical releases are documented in [GitHub Releases](https://github.com/pomo-studio/terraform-aws-ssr-cloudfront/releases).
