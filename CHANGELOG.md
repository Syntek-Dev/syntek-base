# Changelog

**Last Updated**: 24/04/2026 **Version**: 1.1.1 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

_No unreleased changes._

---

## [1.1.1] - 24/04/2026

### Fixed

- Removed hardcoded `pnpm` version pin from CI workflow setup steps (`fix(ci)`, 598a216)
- Resolved npm/pnpm peer dependency warnings, dependency audit vulnerabilities, and
  deprecated package references (`fix(deps)`, 1b6f53a)

### Changed

- Expanded `code/docs/RESPONSIVE-DESIGN.md` and `project-management/docs/RESPONSIVE-DESIGN.md`
  with additional media query and container query reference examples
  (`docs(responsive-design)`, 219735b)
- Committed all pending stack and documentation changes to bring the repository fully
  in sync (`chore`, ce0d5e1)

---

## [1.1.0] - 21/04/2026

### Added

- Figma MCP server registered in `CLAUDE.md` as a machine-global MCP with usage guidance
  for reading designs, generating FigJam diagrams, and managing Code Connect mappings
- `code/docs/RESPONSIVE-DESIGN.md` — breakpoint strategy, mobile-first patterns, Tailwind
  utility conventions for frontend and mobile layers
- `project-management/docs/RESPONSIVE-DESIGN.md` — same responsive design reference for
  the PM documentation layer
- `code/src/scripts/development/codegen.sh` — shell script for running GraphQL Code
  Generator inside the dev container
- PM src directories: `00-ASSETS/` (with `ERD-DIAGRAMS/`, `LOGOS/`, `USER-FLOW-DIAGRAMS/`
  subdirectories), `00-DECISIONS/`, `00-PLANS/`, `04-USER-FLOW/`, `05-BRAND-GUIDE/`,
  `06-COMPONENTS/`, `07-WIREFRAMES/` — all blank template placeholders with `CONTEXT.md`
- PM workflows: `04-user-flow-design/`, `05-brand-guides/`, `06-component-designs/`,
  `07-wireframes/`, `08-gdpr-compliance/`, `09-backend-code/`, `10-api-code/`,
  `11-frontend-code/`, `12-app-code/`, `13-pr-and-review/`, `14-release/` — each with
  `CONTEXT.md`, `STEPS.md`, and `CHECKLIST.md`

### Changed

- `project-management/src/` directories renamed from flat SCREAMING-SNAKE-CASE to
  numbered prefix scheme: `STORIES/` → `01-STORIES/`, `SPRINTS/` → `02-SPRINTS/`,
  `DATABASE/` → `03-DATABASE/`, `GDPR/` → `08-GDPR/`, `SECURITY/` → `09-SECURITY/`,
  `QA/` → `10-QA/`, `TESTS/` → `11-TESTS/`, `REVIEWS/` → `12-REVIEWS/`,
  `BUGS/` → `13-BUGS/`, `REFACTORING/` → `14-REFACTORING/`, `PLANS/` → `00-PLANS/`
- `.mcp.json` updated to invoke `code-review-graph` via `uvx` instead of `.venv/bin/`
- `CONTEXT.md` and `README.md` updated to reflect new PM src numbering and workflow count
- `project-management/CONTEXT.md`, `project-management/src/CONTEXT.md`, and
  `project-management/workflows/CONTEXT.md` updated to document the new structure
- All `code/workflows/*/CONTEXT.md` cross-references updated to new PM directory paths
  (e.g. `BUGS/` → `13-BUGS/`, `06-gdpr-compliance/` → `08-gdpr-compliance/`)
- `code/src/logs/CONTEXT.md` bug report path updated to `project-management/src/13-BUGS/`

### Removed

- PM source directories: `BUGS/`, `DATABASE/`, `GDPR/`, `PLANS/`, `QA/`, `REFACTORING/`,
  `REVIEWS/`, `SECURITY/`, `SPRINTS/`, `STORIES/`, `TESTS/`, `WIREFRAMES/` — superseded
  by the numbered directory scheme
- PM workflows: `04-wireframes/`, `05-pr-and-review/`, `06-gdpr-compliance/`,
  `07-release/` — superseded by renumbered counterparts (07, 13, 08, 14)

---

## [1.0.0] - 19/04/2026

### Added

- Expo React Native mobile scaffold (`code/src/mobile/`) with Expo Router app screens,
  NativeWind global CSS, Storybook config, Jest unit test setup, Detox E2E skeleton,
  GraphQL codegen config, and all supporting CONTEXT.md guides
- Mobile Docker test container (`code/src/docker/mobile/Dockerfile.test`) and mobile
  service definitions in all Docker Compose environment files
- `test-mobile.yml` GitHub Actions workflow for Jest and Detox E2E CI
- Mobile shell scripts: `mobile.sh`, `mobile-coverage.sh` (test runner/coverage), and
  `new-expo-screen.sh` (screen scaffolding) in `code/src/scripts/`
- Mobile test report directories: `code/src/scripts/tests/reports/mobile/` and
  `mobile-coverage/`
- Frontend Storybook configuration (`code/src/frontend/.storybook/`)
- Nine contributor guides in `how-to/src/`: `GETTING-STARTED.md`, `BRANCH-GUIDE.md`,
  `COMMIT-GUIDE.md`, `PR-GUIDE.md`, `CODE-REVIEW.md`, `ISSUE-REPORTING.md`,
  `ENV-SETUP.md`, `CUSTOMISING-TEMPLATE.md`, and `CLAUDE-MULTILAYER.md`
- `CONTRIBUTING.md` and `LICENSE` (MIT) at project root

### Changed

- `CLAUDE.md` updated to include mobile layer, all key locations, and finalised global
  rules; pre-scaffold config removed
- All Docker Compose files updated to include mobile service and aligned env var naming
- `code/CONTEXT.md` and all `code/src/` CONTEXT.md files updated to reflect mobile layer
- `how-to/docs/CLI-TOOLING.md` and `DEVELOPMENT.md` updated for mobile commands
- `project-management/docs/` reference guides updated to align with three-layer scaffold
- All `project-management/src/*/CONTEXT.md` files updated with final artefact structure
- `how-to/workflows/01-first-time-setup/STEPS.md` updated for full three-layer setup
- Root `package.json`, `pnpm-workspace.yaml`, `eslint.config.mjs`, `pyproject.toml`,
  `uv.lock`, and `install.sh` updated to match finalised monorepo structure
- `CONTEXT.md` repository state updated to reflect 1.0.0 stable release
- Backend Django `base.py` settings updated; nginx `dev.conf` and `test.conf` refined

---

## [0.1.0] - 18/04/2026 (finalised 19/04/2026)

### Added

- Initial project scaffold with three-layer context system (`code/`, `how-to/`,
  `project-management/`)
- Root configuration files: `.editorconfig`, `.gitignore`, `.npmrc`, `.nvmrc`,
  `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`, `.dockerignore`,
  `.mcp.json`, `.python-version`
- Root package manager config: `package.json`, `pnpm-workspace.yaml`, `pnpm-lock.yaml`,
  `pyproject.toml`, `uv.lock`
- Git hook runner `lefthook.yml` with Ruff, basedpyright, ESLint, Prettier, and
  markdownlint pre-commit checks
- ESLint configuration `eslint.config.mjs` for TypeScript and React
- GitHub Actions CI workflow suite (lint, type-check, test — backend, frontend, e2e)
- Claude Code agent configuration: `CLAUDE.md`, slash commands, and Python plugin tools
- Project `README.md` with full orientation guide
- Root `CONTEXT.md` router and `GAPS.md` tracking file
- `code/` layer: technical documentation (13 guides), Docker Compose stacks for all four
  environments, backend/frontend Dockerfiles and entrypoints, utility scripts, and ten
  development workflows
- `how-to/` layer: CLI tooling, development, and Syntek guides; three operational workflows
- `project-management/` layer: GDPR, git, SEO, and versioning guides; twelve PM source
  directories; seven PM workflows
- `VERSION`, `CHANGELOG.md`, `VERSION-HISTORY.md`, and `RELEASES.md` version tracking files
- Django project scaffold: `apps/core`, `apps/users`, `config/settings/` (base, dev,
  staging, production, test), `manage.py`, `wsgi.py`, `asgi.py`, `urls.py`
- Next.js 16 frontend scaffold: App Router layout, `src/components/`, `src/graphql/`,
  `src/lib/` (Apollo wrapper), `src/test/` (Vitest + MSW), `e2e/` (Playwright), and
  `codegen.ts` for GraphQL Code Generator
- `@syntek/shared` internal TypeScript package for cross-frontend shared utilities and
  components (`code/src/shared/`)
- Shell scripts for running tests (`backend.sh`, `frontend.sh`, `e2e.sh`,
  `backend-coverage.sh`, `frontend-coverage.sh`, `open-coverage.sh`, `all.sh`),
  scaffolding new Django apps and Next.js routes, and per-reporter report directories
- `install.sh` project setup entry point
