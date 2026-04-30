# Changelog

**Last Updated**: 30/04/2026 **Version**: 1.5.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

_No unreleased changes._

---

## [1.5.0] - 30/04/2026

### Changed

- `code/docs/TESTING.md` — major expansion: added Compilation & Type-Checking section
  (basedpyright and tsc), Mobile (Expo/React Native) test section, Bruno API Tests
  (HTTP layer) section, and Test Output & Readability section; updated the Testing Matrix
  with mobile and API rows; replaced all mypy references with basedpyright; rewrote the
  BDD section with real-world scenario examples and human-readability rules; added
  Rules 21–24 covering pragmatic TDD, realistic test data, contract-level assertions,
  and structured-for-growth organisation; fixed MD032 lint errors
- `code/workflows/02-tdd-cycle/CONTEXT.md` — key concepts updated to cover pragmatic TDD
  (tests evolve during Green phase), contract-level assertions, realistic test data, and
  refactor-safety; prerequisites and cross-references refreshed
- `code/workflows/02-tdd-cycle/STEPS.md` — fully rewritten: Phase 0 added for basedpyright
  and tsc compile checks before any test run; Phase 1 expanded with contract-level and
  realistic-data guidance; Phase 2 extended with user-observable vs internal edge case
  routing and BDD branching; fixed MD032 lint error
- `code/workflows/02-tdd-cycle/CHECKLIST.md` — fully rewritten as a four-phase checklist
  covering basedpyright compile check, realistic test data, contract-level assertion
  validation, BDD scenario coverage, and the zero-test-changes-in-Refactor rule

---

## [1.4.0] - 29/04/2026

### Added

- `code/docs/URL-STRATEGY.md` — new reference document covering path-based routing (Phase 1)
  and the planned subdomain migration for admin and portal surfaces (Phase 2)
- `code/docs/CODING-PRINCIPLES.md` — two new sections: **Class vs Function** (when to use each
  in Python/Django and TypeScript/React, with worked examples) and **Decision Structuring:
  Boolean, Policy, and Strategy** (formalising the three named patterns for access rules and
  variant algorithms)
- `project-management/src/03-DATABASE/ERD-DIAGRAMS/CONTEXT.md` — placeholder directory with
  conventions for storing PNG ERD exports generated from Mermaid source
- `project-management/src/04-USER-FLOW/DIAGRAMS/CONTEXT.md` — placeholder directory with
  conventions for storing PNG user flow diagram exports from Mermaid or Figma

### Changed

- `project-management/docs/VERSIONING-GUIDE.md` — rewritten to document the **two-tier
  versioning strategy**: root project semver (covering the full monorepo) and independent
  sub-package semver for `backend`, `frontend`, `mobile`, and `shared`; file tables for both
  tiers updated and the sub-package isolation rule made explicit
- `code/docs/SECURITY.md` — NIST SP 800-63B added as the governing standard for
  authentication, password policy, and MFA in the Authentication section; OWASP A07 table
  row updated to cite the full standard name
- `how-to/src/CLAUDE-MULTILAYER.md` — significantly expanded from a brief table to full
  installation and usage instructions for all six MCP servers (`code-review-graph`,
  `claude-in-chrome`, `docfork`, `context7`, `figma`, `mcp-mermaid`), including JSON
  definitions, usage guidance, and example sessions for each
- `README.md` — MCP server table updated to list all six servers with correct scope
  classification; descriptive paragraphs added for each server group
- All `code/workflows/` CHECKLIST and STEPS files updated: numbered artefact folder paths
  corrected (`src/PLANS/` → `src/00-PLANS/`, `src/SECURITY/` → `src/09-SECURITY/`,
  `src/GDPR/` → `src/08-GDPR/`, `src/BUGS/` → `src/14-BUGS/`, `src/REVIEWS/` →
  `src/13-REVIEWS/`, `src/REFACTORING/` → `src/15-REFACTORING/`)
- `code/workflows/03-security-hardening/CONTEXT.md` and `code/workflows/06-review/CONTEXT.md`
  — NIST SP 800-63B added to key concepts alongside OWASP A01–A10
- `code/workflows/01-new-feature/STEPS.md`, `code/workflows/04-api-design/STEPS.md`,
  `code/workflows/06-review/CHECKLIST.md`, and `code/workflows/08-refactor/CHECKLIST.md` —
  explicit requirement for named Policy classes on all auth/permission checks, linking to the
  new Decision Structuring section in CODING-PRINCIPLES.md
- `how-to/workflows/03-debugging/` CHECKLIST and STEPS — bug report path corrected to
  `project-management/src/14-BUGS/`

---

## [1.3.0] - 29/04/2026

### Added

- `DESIGN.md` — root-level entry point for UI/UX, component, brand, and wireframe work;
  maps all relevant standards, guides, and workflows across all four documentation layers
- Three new pre-development PM workflows: `09-security-checks` (threat modelling),
  `10-qa-checks` (QA scenario definition), and `11-sprint-plans` (MoSCoW sprint planning
  with definition of done)
- Three new PM reference guides: `project-management/docs/QA-GUIDE.md`,
  `project-management/docs/SECURITY-GUIDE.md`, and
  `project-management/docs/SPRINT-PLANNING-GUIDE.md`
- `project-management/src/11-SPRINT-PLANS/` — new artefact folder for sprint plan documents
- Agent hint headers added to all `code/docs/`, `code/workflows/`, `how-to/docs/`,
  `how-to/workflows/`, and `project-management/` CONTEXT and reference files; each header
  declares the recommended model and relevant MCP servers

### Changed

- `project-management/src/` folders renumbered: TESTS 11→12, REVIEWS 12→13, BUGS 13→14,
  REFACTORING 14→15 to accommodate the new 11-SPRINT-PLANS folder
- `project-management/workflows/` renumbered: six coding workflows shifted from 09–14 to
  12–17 to accommodate the three new pre-development workflows (09–11)
- `.claude/CLAUDE.md` updated: Layer Routing table gains UI/UX row, MCP server table adds
  `docfork` entry with user scope, dual-tool docfork+context7 documentation lookup
  instructions expanded, `mcp-mermaid` usage note added, Design section added, GAPS.md
  rule added
- `CONTEXT.md` and `README.md` updated to reflect new `DESIGN.md`, renumbered src folders,
  and expanded workflow count (01–17)

---

## [1.2.0] - 26/04/2026

### Added

- Bruno API integration test collection (`code/src/tests/api/`) covering auth, users,
  orders, and performance scenarios — with environments for local, Docker, staging, and
  production
- `code/src/scripts/tests/api.sh` — shell script to run the Bruno collection locally
  against the Docker test stack; validates the container is running and writes results
  to `code/src/scripts/tests/reports/api/`
- `.github/workflows/test-api.yml` — GitHub Actions workflow triggering the Bruno suite
  on push/PR to `main` when API or backend files change, and on manual dispatch with
  optional environment and folder inputs; uploads `results.json` as an artefact
- `how-to/docs/API-TESTING.md` and `how-to/src/API-TESTING.md` — contributor guide
  covering Bruno desktop/CLI setup, environment split, `api.sh` usage, and CI
  configuration

### Changed

- `@usebruno/cli ^3.3.0` added as a dev dependency; `protobufjs` added to pnpm nohoist
  list (required by the Bruno CLI)
- `code/src/docker/.env.test.example` updated with `BRUNO_VAR_test_password` documentation
- `code/CONTEXT.md`, `code/src/CONTEXT.md`, `code/src/scripts/tests/CONTEXT.md`,
  `code/src/scripts/tests/reports/CONTEXT.md`, `how-to/CONTEXT.md`,
  `how-to/docs/CONTEXT.md`, and `how-to/src/CONTEXT.md` updated to reflect new
  directories and guides

---

## [1.1.2] - 24/04/2026

### Changed

- Expanded user preference media query guidance in `code/docs/RESPONSIVE-DESIGN.md`
  and `project-management/docs/RESPONSIVE-DESIGN.md` — all six OS/browser preference
  signals now documented (dark mode, reduced motion, high contrast, forced colours,
  reduced transparency, reduced data) with CSS patterns, Tailwind variants, React hooks,
  and a React Native `AccessibilityInfo` hook
- Added cross-reference in `code/docs/ACCESSIBILITY.md` Motion and Animation section
  pointing to the expanded RESPONSIVE-DESIGN.md content

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
