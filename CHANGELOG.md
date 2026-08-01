# Changelog

**Last Updated**: {{DATE}} **Version**: 0.4.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.4.0] - 01/08/2026

### Added

- `code/src/scripts/_lib/` — shared shell helpers, including `worktree-detect.sh` for resolving the active worktree and its Docker project name.
- `code/src/scripts/audits/` — `css-tokens.sh` (enforces that component CSS only consumes resolvable `var(--token)` values), `css-gradients.sh`, `copy-emdash.sh`, and `security.sh`.
- `code/src/scripts/development/new-django-view.sh` — scaffolds a public page as a Django view, template, and URL entry; the only supported way to add a page route.
- `code/src/scripts/development/hosts-story-add.sh` and `hosts-story-remove.sh` — manage per-story loopback host entries for parallel worktrees.
- `code/src/scripts/development/install.sh`, `install-backend.sh`, `install-frontend.sh`, and `pnpm-update.sh` — dependency installation and update runners.
- `code/src/scripts/database/seed-dev.sh` and `verify-db-security.sh` — development seeding and a row-level-security and grant verification pass.
- `code/src/scripts/tests/e2e-py.sh` (Playwright driven from the Django tree), `server.sh`, and `mutmut.sh` for mutation testing.
- `CLAUDE.md` operating-rules files for the script root and every script sub-directory.

### Changed

- Every runner under `database/`, `deployment/`, `development/`, `syntax/`, and `tests/` re-pointed from `code/src/backend/` to `code/src/django/`.
- `code/src/scripts/CONTEXT.md` rewritten around the Django-only script inventory.

### Removed

- `code/src/scripts/tests/frontend.sh`, `frontend-coverage.sh`, `mobile.sh`, `mobile-coverage.sh`, and `e2e.sh` — superseded by `e2e-py.sh` or removed with their layer.
- `code/src/scripts/development/codegen.sh`, `new-next-route.sh`, and `new-expo-screen.sh` — scaffolding for the removed JavaScript layers.
- `code/src/scripts/tests/reports/**` — generated report directories are no longer tracked; `.gitignore` now excludes them and a single `reports/.gitignore` keeps the directory self-managing.

---

## [0.3.0] - 01/08/2026

### Added

- `code/src/django/` — the Django project bundle: `config/` (ASGI and WSGI entry points, root URL conf, and the four-environment settings split), `apps/`, `templates/`, `static/`, `tests/e2e/` with accessibility and marketing-overflow suites, plus `conftest.py`, `manage.py`, and `pyrightconfig.json`.
- `code/src/django/CHANGELOG.md`, `code/src/django/VERSION-HISTORY.md`, and `code/src/django/RELEASES.md` — sub-package version files at the `0.1.0` baseline, as required for every package manifest by `project-management/docs/VERSIONING-GUIDE.md`.
- `code/src/docker/django/` — the Django container images and entrypoints for dev, test, staging, and production.
- `code/src/docker/postgres/` — PostgreSQL container configuration, including `postgresql.dev.conf`.
- `code/src/docker/docker-compose.usXXX.dev.yml.example` and `docker-compose.usXXX.test.yml.example` — per-worktree Compose overlays for parallel story development.
- `CLAUDE.md` operating-rules files alongside every `CONTEXT.md` in the `code/src`, `docker`, and `django` trees, per the directory pairing rule.

### Changed

- `code/src/backend/` → `code/src/django/` — the Python package root is renamed to reflect that Django now serves the entire application, not just an API.
- `code/src/docker/backend/` → `code/src/docker/django/` — image names, build contexts, and entrypoints follow the rename.
- Compose files, the Nginx dev and test configurations, and the four `.env.*.example` templates re-pointed at the `django` service.
- `pyproject.toml` — project name templatised to `{{PROJECT_SLUG}}`, version set to the django sub-package `0.1.0` baseline, and the dependency set narrowed to the Django-only stack.

### Removed

- `code/src/backend/**` — superseded in full by `code/src/django/**`.
- `code/src/shared/**` — the TypeScript package shared between the web and mobile clients, obsolete now that neither client exists.

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
