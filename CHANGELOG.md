# Changelog

**Last Updated**: {{DATE}} **Version**: 0.2.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.2.0] - 01/08/2026

### Removed

- `code/src/frontend/**` — the Next.js/React web application (34 files), including its App Router pages, components, hooks, and TypeScript configuration.
- `code/src/mobile/**` — the Expo React Native application (45 files), including its screens, navigation, native configuration, and Expo tooling.
- `code/src/docker/frontend/**` — the frontend container images and configuration for dev, test, staging, and production (5 files).
- `code/src/docker/mobile/Dockerfile.test` — the React Native test image.
- `.github/workflows/test-frontend.yml` and `.github/workflows/test-mobile.yml` — the CI pipelines for the two removed layers.

---

## [0.1.0] - 01/08/2026

### Added

- Initial scaffold from the base template — Django · Django Ninja · django-components · HTMX · Alpine · vanilla token CSS · Celery · PostgreSQL · Valkey · Nginx · Docker.
- `.gitignore` rules for the template surface — generated test reports under `code/src/scripts/tests/reports/`, the resolved Python lockfile, git worktree checkouts under `.claude/worktrees/`, and local Claude Code overrides.

### Changed

- Root version track reset from `1.11.0` to `0.1.0` — this repository is now the reusable base template rather than a single delivered project.
- `CHANGELOG.md`, `RELEASES.md`, and `VERSION-HISTORY.md` truncated to the template baseline; the pre-template 1.x history is retained in git history only and is not back-filled.

### Removed

- `uv.lock` — the resolved Python lockfile is no longer tracked. The template's `pyproject.toml` carries unsubstituted placeholders, so the lockfile is resolved per scaffolded project rather than shipped.
