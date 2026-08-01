# Changelog

**Last Updated**: {{DATE}} **Version**: 0.11.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.11.0] - 01/08/2026

### Added

- Root `CONTEXT.md` — the project overview: directory tree, layer map, starting points, conventions, and repository state. Reinstates the orientation file retired in 0.10.0.

### Fixed

- `.claude/CLAUDE.md` line 6 imports `@../CONTEXT.md`, which resolved to nothing after 0.10.0 removed the file. The import now loads on every session as intended.

---

## [0.10.0] - 01/08/2026

### Added

- `REFERENCES.md` — the root reference index covering every layer entry point, guide, workflow, and external standard.
- `DEFERRED.md` — the register of work deliberately deferred, alongside `GAPS.md` for active blockers.
- `setup.sh` and a rewritten `install.sh` — resolve the template placeholders and prepare a scaffolded project.
- `skills-lock.json` — installed Claude Code skills with their versions and hashes.
- `.github/workflows/audit-css-tokens.yml`, `audit-css-gradients.yml`, `audit-copy-emdash.yml`, `audit-secrets.yml`, and `audit-deps.yml` — CI wiring for the audit scripts added in 0.4.0.
- `.github/workflows/claude.yml` and `clickup-sync.yml` — the Claude Code review pipeline and the ClickUp story export sync.
- `.zed/settings.json` — editor configuration shipped as part of the template's tooling surface.
- `handoffs/`, `learning/`, and `research/` — session sandboxes for the handoff, teach, and research skills, each with `CONTEXT.md` and `CLAUDE.md`.

### Changed

- Hardcoded project identifiers replaced with substitution placeholders throughout the root files — `{{PROJECT_NAME}}`, `{{PROJECT_SLUG}}`, `{{ORG_NAME}}`, `{{ORG_SLUG}}`, `{{DEVELOPER_NAME}}`, `{{LOCALE}}`, `{{TIMEZONE}}`, `{{CURRENCY}}`, `{{LICENCE}}`, and `{{DATE}}`.
- `README.md` rewritten for the Django-only monolith; the version badge and footer set to `0.10.0`.
- `DESIGN.md` and `GAPS.md` rewritten around the token-first design system and the template's open items.
- `package.json`, `pnpm-workspace.yaml`, and `pnpm-lock.yaml` reduced to the tooling dependencies that survive without a JavaScript application.
- `eslint.config.mjs`, `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`, and `.npmrc` re-scoped to the remaining file types.
- `lefthook.yml` — pre-commit hooks re-pointed at the Django tree, with a self-gating ClickUp export step and an advisory code-review-graph pass.
- The six surviving CI workflows re-pointed at `code/src/django/` and the rewritten script surface.

### Removed

- Root `CONTEXT.md` — superseded by `REFERENCES.md` as the root index.
- `LICENCE` — a base template does not choose a licence on behalf of the project scaffolded from it; the placeholder `{{LICENCE}}` is resolved at setup.
- `CONTRIBUTING.md` — superseded by the PM layer's git, PR, and review workflows.

---

## [0.9.0] - 01/08/2026

### Added

- `how-to/docs/AI-DICTIONARY.md` with `ai-dictionary/` — plain-English definitions across `THE-MODEL.md`, `SESSIONS-CONTEXT-AND-TURNS.md`, `TOOLS-AND-ENVIRONMENT.md`, `MEMORY-AND-STEERING.md`, `PATTERNS-OF-WORK.md`, `HANDOFFS.md`, and `FAILURE-MODES.md`.
- `how-to/docs/TOOLING-GUIDE.md` with `tooling-guide/` — `COMMANDS.md`, `CONFIGURATION.md`, and `WORKFLOW.md` covering the internal agents and skills.
- `how-to/docs/GIT-WORKTREES.md`, `SKILL-AUTHORING.md`, `CELERY-FIRST-RUN.md`, and `FEATURE-DEPLOY.md`.
- `how-to/workflows/04-worktree-setup/` — a complete workflow (`CONTEXT.md`, `STEPS.md`, `CHECKLIST.md`, `CLAUDE.md`) for running parallel stories in isolated worktrees and Docker stacks.
- `how-to/src/SCALE-ARCHITECTURE/` — `OVERVIEW.md`, `LOAD-PROFILES.md`, `SIZING-ENVELOPE.md`, `READINESS.md`, and `TOPOLOGY.md` for sizing a deployment against a target user count.
- `how-to/src/SERVER-ARCHITECTURE/` — `OVERVIEW.md`, `COMPUTE-ALLOCATION.md`, `EDGE-REQUIREMENTS.md`, and `NIXOS-HANDOFF.md`, the interface to the NixOS deployment repository.
- `how-to/src/NIXOS-SETUP.md`, `how-to/src/TEMPLATE-TOKENS.md`, `how-to/REFERENCES.md`, and `CLAUDE.md` operating-rules files throughout the layer.

### Changed

- `how-to/docs/DEVELOPMENT.md`, `CLI-TOOLING.md`, and the three existing workflows rewritten for the Django-only stack and the rewritten script surface.
- `how-to/CONTEXT.md` updated for the new document set and workflow `04`.

### Removed

- `how-to/docs/SYNTEK-GUIDE.md` and `how-to/docs/API-TESTING.md` — project-specific or superseded by the code-layer testing guides.
- Nine narrow contributor guides under `how-to/src/` — `BRANCH-GUIDE.md`, `COMMIT-GUIDE.md`, `PR-GUIDE.md`, `CODE-REVIEW.md`, `ISSUE-REPORTING.md`, `ENV-SETUP.md`, `GETTING-STARTED.md`, `CLAUDE-MULTILAYER.md`, and `API-TESTING.md` — each duplicated an authoritative guide in the code or PM layer.

---

## [0.8.0] - 01/08/2026

### Added

- `project-management/src/` renumbered to `00`–`20` across three tiers — specify (`01-STORIES` … `12-API-DESIGN`), decide and plan (`13-DECISIONS`, `14-SPRINT-PLANS`, `15-STORY-PLANS`), and record (`16-TESTS` … `20-REFACTORING`).
- `project-management/workflows/` extended to `01`–`21`, adding `12-api-design`, `13-decisions`, `14-sprint-plans`, `15-story-plans`, the `16`–`18` implementation phases, `19-implementation-documentation`, `20-pr-and-review`, and `21-release`.
- `project-management/docs/gdpr/` — `COMPLIANCE.md` and `DATA-RIGHTS.md`, with `GDPR-GUIDE.md` reduced to a thin index over them.
- `project-management/export/clickup/` and `clickup-task-map.json` — the read-only client export surface regenerated from source stories by the pre-commit hook.
- `project-management/src/00-ASSETS/scripts/` — the export and sync family: `export-clickup-stories.sh`, `export-design-docs.sh`, `export-pm-files.sh`, `export-wireframes.sh`, `sync-clickup.sh`, and the self-gating `precommit-clickup.sh`.
- `CLAUDE.md` operating-rules files for the layer root, `docs/`, every `src/` artefact folder, and every numbered workflow.

### Changed

- All eight PM guides rewritten for the Django-only stack — `GIT-GUIDE.md`, `VERSIONING-GUIDE.md` (now a two-tier scheme with the django sub-package), `SEO-CHECKLIST.md`, `SECURITY-GUIDE.md`, `QA-GUIDE.md`, `SPRINT-PLANNING-GUIDE.md`, `GDPR-GUIDE.md`, and the `RESPONSIVE-DESIGN.md` redirect stub.
- `project-management/CONTEXT.md` and `REFERENCES.md` rewritten around the three-tier structure and the cross-layer workflow pairing map.
- Story, sprint, and plan templates re-expressed with template placeholders in place of project-specific content.

### Removed

- The pre-renumbering artefact folders `00-DECISIONS/`, `00-PLANS/`, `13-SPRINT-PLANS/`, `14-TESTS/`, `15-REVIEWS/`, `16-BUGS/`, and `17-REFACTORING/` — superseded by their renumbered equivalents.
- The organisation's logo exports (`00-ASSETS/LOGOS/` at 8k, HD, and SVG) and the project's twelve ERD diagrams (`00-ASSETS/ERD-DIAGRAMS/`) — a template ships the asset pipeline, not one organisation's brand or one project's schema.

---

## [0.7.0] - 01/08/2026

### Added

- `code/docs/DATABASE.md` — scope columns, database-level invariants, lock-safe migration patterns, search, and the deferred-infrastructure register.
- `code/docs/DESIGN-TOKENS.md` with `design-tokens/` (`MODEL.md`, `CASCADE.md`, `EDITOR.md`) — the database-canonical token system that component CSS may only consume through `var(--token)`.
- `code/docs/RENDERING.md` with `rendering/` — where each interaction runs: server template, HTMX, or Alpine.
- `code/docs/VISUAL-DESIGN.md`, `BACKEND-CODING-PRINCIPLES.md`, and `FRONTEND-CODING-PRINCIPLES.md`.
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore, debug, review, and refactor playbooks for the code-review-graph MCP server.
- Sub-folders splitting every oversized guide: `accessibility/`, `api-design/`, `architecture/`, `coding-principles/`, `data-structures/`, `encryption/`, `logging/`, `performance/`, `responsive/`, `rls/`, `security/`, and `testing/`.
- `code/docs/cloudinary/` — the Cloudinary Python SDK and cross-SDK reference index.
- `code/REFERENCES.md` and `CLAUDE.md` operating-rules files for the code layer root, `code/workflows/`, and all ten numbered workflows.

### Changed

- All fourteen existing `code/docs/*.md` guides rewritten for the Django-only stack and reduced to thin indexes over their sub-folders where they exceeded the 300-code-line instructional limit.
- All ten `code/workflows/` procedures re-pointed at the Django tree, the rewritten script surface, and the paired project-management workflows.
- `code/CONTEXT.md` — directory tree and layer map updated for the single-stack monolith and the 750-line source file limit.

---

## [0.6.0] - 01/08/2026

### Added

- `.claude/agents/` — 50 agent definitions in two tiers: 8 orchestrators (`bugfix`, `feature`, `pr`, `refactor`, `release`, `review`, `security`, `story`) plus the specialists and document writers they delegate to.
- `.claude/skills/` — the internalised skill library: `stack-django`, `stack-htmx-templates`, `global-workflow`, the `grilling` engine with its `grill-me` and `grill-with-docs` wrappers, `codebase-design`, `domain-modelling`, `improve-codebase-architecture`, `scale-planning`, `teach`, `wayfinder`, `handoff`, `prototype`, `research`, `legal-documents`, and `msp-scp-documents`.
- `.claude/MEMORY.md` — the project memory store that replaces the global auto-memory system.
- `.claude/CONTEXT.md` — orientation for the configuration directory.
- `.claude/hooks/pre-pr-check.sh` — the eight-gate quality check run before a pull request is marked ready; `post-pr-comment.sh` posts the structured result summary.
- `.claude/hooks/pre-compact-handoff.sh` — intercepts auto-compaction so a session writes an explicit handoff document instead of silently compacting.
- `.agents/skills/cloudinary-docs`, `cloudinary-react`, and `cloudinary-transformations` — Cloudinary SDK skill references.
- `CONTEXT.md` and `CLAUDE.md` pairs for the hooks and plugins directories.

### Changed

- `.claude/CLAUDE.md` — rewritten around the Django-only stack, the two-tier agent model, the Fable/Opus model allocation, the templatised project placeholders, and the non-negotiable rules (token-first CSS, database-enforced invariants, lock-safe migrations, and the docs hard gate).
- `.claude/settings.json` — auto-compaction disabled, dynamic workflows enabled, the Opus model and extra-high effort level pinned, and both marketplace plugins disabled.
- `.claude/hooks/lib/check-*.sh` — the eight shared check scripts re-pointed at the Django tree and the rewritten script surface.

### Removed

- `.claude/commands/` — seven slash commands (`codegen`, `dev`, `migrate`, `production`, `schema`, `staging`, `test`) superseded by the runners under `code/src/scripts/`.
- `.claude/hooks/pr-gate.sh` and `pr-comment.sh` — replaced by `pre-pr-check.sh` and `post-pr-comment.sh`.
- `.claude/plugins/chrome-tool.py`, `ddev-tool.py`, `docker-tool.py`, and `quality-tool.py` — plugins that ran dev operations; those now belong exclusively to the shell scripts.

---

## [0.5.0] - 01/08/2026

### Added

- `code/src/tests/api/environments/*.bru` — native Bruno environment files for `local`, `host`, `docker`, `staging`, and `production`, alongside the retained JSON definitions.
- `code/src/tests/api/environments/host.json` — the host-machine environment, for running the suite outside the Docker network.
- `code/src/tests/template-test.bru` — a single annotated request template that every new Bruno suite is copied from, relocated from `api/template-test.bru`.
- `code/src/improvement-architecture/` — scratch area for architecture improvement reports; contents are git-ignored, orientation files are tracked.
- `CLAUDE.md` operating-rules files for `code/src/tests/`, `code/src/tests/api/`, `code/src/tests/api/environments/`, and `code/src/logs/`.

### Changed

- `code/src/tests/api/bruno.json` and the `docker`, `staging`, `production`, and `variables` JSON environments re-pointed at the Django service and its `/api/` prefix.
- `code/src/tests/CONTEXT.md`, `api/CONTEXT.md`, and `logs/CONTEXT.md` rewritten for the template layout.

### Removed

- The illustrative Bruno collections — `api/auth/`, `api/orders/`, `api/users/`, and `api/performance/` — a template ships no domain fixtures.
- `code/src/tests/api/template-test.bru` — relocated up one level to `code/src/tests/template-test.bru`.

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
