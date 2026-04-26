# Releases — project-name

**Last Updated**: 26/04/2026 **Version**: 1.2.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v1.2.0 — 26/04/2026

**Status:** Feature release — Bruno API integration testing

### Summary

Adds a complete API integration test suite powered by Bruno, covering authentication,
user management, orders, and performance scenarios. Tests can be run locally against
the Docker test stack via a new shell script, and automatically on CI via a new GitHub
Actions workflow. The `@usebruno/cli` package is added to the root dev dependencies so
no additional global installs are required.

### What's new since v1.1.2

- **Bruno API test collection:** A full set of `.bru` request files under
  `code/src/tests/api/` covering four domains: auth (login, refresh, invalid password),
  users (list, get, create), orders (list, get, create, update, delete), and performance
  (load and stress tests). Four environment configs are included: `local`, `docker`,
  `staging`, and `production`
- **Local test runner:** `code/src/scripts/tests/api.sh` — run the full Bruno collection
  against the Docker test stack with a single command; results are written to
  `code/src/scripts/tests/reports/api/results.json`
- **CI workflow:** `.github/workflows/test-api.yml` triggers the Bruno suite automatically
  on push or pull request when API or backend files change, and supports manual dispatch
  with environment and folder options; results are uploaded as a CI artefact (30-day retention)
- **API testing guide:** `how-to/docs/API-TESTING.md` documents Bruno setup, the
  environment split, `api.sh` usage, the `API_TEST_PASSWORD` CI secret, and CORS
  configuration implications

---

## v1.1.2 — 24/04/2026

**Status:** Documentation release — expanded user preference media query reference

### Summary

A documentation-only release expanding the responsive design and accessibility guides.
No source code, configuration, or tests were changed.

### What's changed since v1.1.1

- **User preference media queries:** Both `code/docs/RESPONSIVE-DESIGN.md` and
  `project-management/docs/RESPONSIVE-DESIGN.md` now contain a complete guide to all six
  OS/browser preference signals — dark mode (`prefers-color-scheme`), reduced motion
  (`prefers-reduced-motion`), high contrast and forced colours (`prefers-contrast` /
  `forced-colors`), reduced transparency (`prefers-reduced-transparency`), and reduced
  data (`prefers-reduced-data`). Each query is documented with a CSS pattern, Tailwind
  variant, and a reusable React hook
- **React Native accessibility patterns:** A `useAccessibilityPreferences` hook wrapping
  the React Native `AccessibilityInfo` API is documented alongside the web patterns for
  cross-platform consistency
- **Accessibility cross-reference:** `code/docs/ACCESSIBILITY.md` has been updated in the
  Motion and Animation section to direct developers to the expanded RESPONSIVE-DESIGN.md
  content rather than duplicating guidance

---

## v1.1.1 — 24/04/2026

**Status:** Maintenance release — CI fixes, dependency health, and documentation improvements

### Summary

A routine maintenance release addressing dependency health and documentation quality.
No new features or breaking changes are included. The project is fully up to date
and safe to use.

### What's changed since v1.1.0

- **Improved CI reliability:** The continuous integration pipeline no longer pins a
  hardcoded package manager version, ensuring setup steps remain compatible with the
  latest tooling automatically
- **Cleaner dependencies:** Resolved a set of peer dependency warnings and removed
  outdated package references to keep the project free from known vulnerabilities
- **Expanded responsive design guide:** The responsive design reference documentation
  has been extended with additional examples covering media queries and container queries,
  making it easier for developers to apply consistent responsive patterns

---

## v1.1.0 — 21/04/2026

**Status:** PM layer restructure and scaffold improvements

### Summary

Restructures the project-management source directories from flat SCREAMING-SNAKE-CASE
names to a numbered prefix scheme (00–14) for deterministic ordering and clearer
navigation. Expands the PM workflow set from 7 to 14 step-by-step guides, covering the
full delivery pipeline from user flow design through to release. Also adds Figma as a
registered MCP server, a responsive design reference guide for both layers, and a
GraphQL codegen shell script for the development workflow.

### What's new since v1.0.0

- **PM src restructure:** All source directories renamed from flat SCREAMING-SNAKE-CASE
  (e.g. `STORIES/`, `BUGS/`) to numbered prefixes (`01-STORIES/`, `13-BUGS/`) for
  consistent ordering; 15 new directories added covering assets, decisions, plans,
  user flows, brand guides, components, and wireframes
- **PM workflows expanded:** Seven new workflows added (04–14) covering user flow design,
  brand guides, component designs, wireframes, GDPR compliance, backend/API/frontend/app
  code, PR and review, and release; superseded workflows 04–07 removed
- **Figma MCP:** Registered as a machine-global MCP server in `CLAUDE.md` with full
  usage guidance for reading designs, generating FigJam diagrams, and Code Connect
- **Responsive design guide:** Added `RESPONSIVE-DESIGN.md` to both `code/docs/` and
  `project-management/docs/` covering breakpoints, mobile-first strategy, and Tailwind
  utility conventions
- **Codegen script:** Added `code/src/scripts/development/codegen.sh` for running
  GraphQL Code Generator inside the dev container
- **MCP config:** Switched `code-review-graph` invocation from `.venv/bin/` to `uvx`
- **Path references:** All cross-layer references in code workflow CONTEXT files updated
  to the new PM directory paths

---

## v1.0.0 — 19/04/2026

**Status:** First stable scaffold release — ready for feature development

### Summary

Completes the full three-layer monorepo scaffold for the Syntek Studio website. This
release adds the Expo React Native mobile layer, a comprehensive contributor guide suite,
complete CI coverage for all three layers (backend, frontend, mobile), and all supporting
documentation. The scaffold is now fully ready for user story implementation.

### What's new since v0.1.0

- **Mobile layer:** Full Expo React Native scaffold with NativeWind, Storybook, Jest unit
  tests, Detox E2E skeleton, GraphQL codegen config, and Expo Router app screens
- **Mobile Docker:** Dedicated `Dockerfile.test` and mobile service in all Docker Compose configs
- **Mobile CI:** `test-mobile.yml` GitHub Actions workflow for Jest and Detox
- **Mobile scripts:** `mobile.sh`, `mobile-coverage.sh`, `new-expo-screen.sh` shell scripts
- **Frontend Storybook:** `.storybook/` config added to the Next.js layer
- **Contributor guides:** Nine new guides in `how-to/src/` covering getting started,
  branching, committing, PRs, code review, issue reporting, environment setup,
  template customisation, and Claude multilayer usage
- **Repository meta:** `CONTRIBUTING.md` and `LICENSE` (MIT) added to project root
- **Documentation updates:** All CONTEXT.md files, PM guides, CI workflows, Docker configs,
  and script files updated to reflect the complete three-layer structure

---

## v0.1.0 — 18/04/2026 (finalised 19/04/2026)

**Status:** Scaffold complete — ready for feature development

### Summary

Full project scaffold for the Syntek Studio website. No public-facing features are
included. The scaffold establishes the complete project structure, tooling, CI pipelines,
Docker environments, agent guidance system, and initial source scaffolds for both
backend and frontend, ready for user story implementation to begin.

### What's included

- Full project directory structure with three-layer context system (`code/`, `how-to/`,
  `project-management/`)
- Docker Compose environments for development, testing, staging, and production
- Automated lint, type-check, and test CI pipelines via GitHub Actions (backend, frontend,
  e2e)
- Pre-commit quality gates (Ruff, basedpyright, ESLint, Prettier, markdownlint)
- Claude Code agent configuration with slash commands and plugin tools
- Reference documentation covering architecture, security, GDPR, testing, and API design
- Development, how-to, and project-management workflow guides
- Django 6 project scaffold: `apps/core`, `apps/users`, environment-split settings,
  ASGI/WSGI/URL entry points
- Next.js 16 (App Router) scaffold: source structure, Apollo client wrapper, Vitest and
  MSW test setup, Playwright e2e, GraphQL Code Generator config
- `@syntek/shared` internal TypeScript package for shared utilities and components
- Shell script suite for running tests, generating coverage, scaffolding apps and routes
- `install.sh` single-command project setup entry point
