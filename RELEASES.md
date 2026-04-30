# Releases — project-name

**Last Updated**: 30/04/2026 **Version**: 1.5.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

User-facing release notes for each published version.

---

## v1.5.0 — 30/04/2026

**Status:** Feature release — testing strategy expansion and TDD workflow rewrite

### Summary

Significantly expands the testing documentation and TDD workflow to cover all test tiers
in the monorepo. The testing reference guide (`TESTING.md`) has been augmented with new
sections on mobile (Expo/React Native), Bruno HTTP API tests, compile-time type checking,
and human-readable test output. The TDD cycle workflow (`02-tdd-cycle`) has been fully
rewritten to reflect a pragmatic, scalable, real-world TDD approach covering all four
phases: compile check, Red, Green, and Refactor.

### What's new since v1.4.0

- **Compile & Type-Checking section:** `TESTING.md` now opens with a dedicated section on
  pre-test compile checks using basedpyright (Python) and tsc (TypeScript/React), making
  type errors first-class failures in the TDD loop
- **Mobile test section:** Complete guidance for Expo/React Native testing — Jest unit
  tests with React Native Testing Library, Detox E2E with BDD scenarios, and coverage
  configuration specific to the mobile layer
- **Bruno API Tests section:** Documents the HTTP layer test tier: running the Bruno
  collection against the Docker test stack, when API tests replace unit tests, and how
  Bruno fits into the full testing matrix
- **Test Output & Readability section:** New rules for naming tests in plain English,
  using `describe`/`it` blocks that read as sentences, and structuring output so failures
  are immediately actionable without reading source code
- **Rules 21–24:** Four new numbered rules appended to the coding standards within
  TESTING.md — pragmatic TDD (tests evolve during Green), realistic test data (no
  `foo`/`bar` fixtures), contract-level assertions (test observable behaviour not
  internals), and structured-for-growth (organise tests to survive refactoring)
- **Phase 0 in TDD STEPS:** The TDD cycle now begins with a compile check phase (basedpyright
  - tsc) before any test is written, surface type errors before they become test failures
- **BDD branching in STEPS:** Phase 2 now explicitly routes user-observable scenarios to
  Detox/Playwright BDD and internal edge cases to unit tests, replacing an ambiguous
  single path

### What's improved since v1.4.0

- **mypy replaced throughout:** All references to mypy in `TESTING.md` have been replaced
  with basedpyright, aligning the documentation with the actual type-checker configured
  in the project
- **Testing Matrix extended:** The matrix in `TESTING.md` now includes rows for mobile
  (Jest + Detox) and API tests (Bruno), giving a complete view of all test tiers
- **BDD section rewritten:** The BDD guidance now includes real-world scenario examples
  with concrete Given/When/Then steps, readability rules for scenario names, and
  anti-patterns to avoid
- **TDD CONTEXT refreshed:** `02-tdd-cycle/CONTEXT.md` key concepts updated to document
  pragmatic TDD, contract-level assertions, realistic data, and refactor-safety with
  clear definitions and rationale
- **Four-phase CHECKLIST:** `02-tdd-cycle/CHECKLIST.md` rewritten as four independent
  checklists (Compile, Red, Green, Refactor) so developers can validate each phase
  independently without re-reading the full document
- **MD032 lint errors fixed:** Two markdown lint errors in TESTING.md and STEPS.md
  (bare list items adjacent to code blocks) have been corrected

---

## v1.4.0 — 29/04/2026

**Status:** Feature release — Coding standards expansion, MCP server documentation, and two-tier versioning

### Summary

Expands coding standards with two new authoritative sections (Class vs Function and Decision
Structuring), adds a URL routing strategy document, documents all six MCP servers with full
installation and usage instructions, rewrites the versioning guide to cover the two-tier semver
strategy, and introduces placeholder directories for ERD and user flow diagram exports.
Workflow and reference files are also updated to cite NIST SP 800-63B alongside OWASP and to
use correct numbered artefact folder paths throughout.

### What's new since v1.3.0

- **Class vs Function guidance:** A new section in `code/docs/CODING-PRINCIPLES.md` gives
  definitive rules for when to choose a class over a function in both Python/Django and
  TypeScript/React, with worked examples covering stateless utilities, service objects,
  Protocol implementations, and React hooks
- **Decision Structuring patterns:** A second new section in `CODING-PRINCIPLES.md`
  formalises three named patterns — Boolean predicate, Policy class (named access rule),
  and Strategy class (variant algorithm) — so agents and developers have a consistent
  vocabulary and a clear guide for shaping business logic
- **URL Strategy document:** `code/docs/URL-STRATEGY.md` documents the Phase 1 path-based
  routing plan (`/`, `/admin/`, `/portal/`) and the planned Phase 2 migration to dedicated
  subdomains, giving the team a single reference for routing decisions
- **Full MCP server guide:** `how-to/src/CLAUDE-MULTILAYER.md` now provides complete
  installation commands and usage guidance for all six MCP servers, including the
  auto-loaded `code-review-graph`, the built-in `claude-in-chrome`, and the four user-scoped
  servers (`docfork`, `context7`, `figma`, `mcp-mermaid`)
- **Two-tier versioning guide:** `project-management/docs/VERSIONING-GUIDE.md` rewritten to
  document the root project semver (covering the entire monorepo) and independent sub-package
  semver for `backend`, `frontend`, `mobile`, and `shared`, with explicit file update tables
  for both tiers
- **ERD diagram directory:** `project-management/src/03-DATABASE/ERD-DIAGRAMS/` created as a
  dedicated home for PNG entity-relationship diagram exports from Mermaid source
- **User flow diagram directory:** `project-management/src/04-USER-FLOW/DIAGRAMS/` created as
  a dedicated home for PNG user flow diagram exports from Mermaid or Figma

### What's improved since v1.3.0

- **NIST SP 800-63B referenced throughout:** `code/docs/SECURITY.md`, security-hardening and
  review workflow CONTEXT files now cite NIST SP 800-63B as the governing standard for
  authentication, password policy, and MFA requirements alongside OWASP
- **Policy classes enforced in workflows:** All relevant workflow CHECKLIST and STEPS files
  now explicitly require named Policy classes for authentication and permission checks,
  linking to the new Decision Structuring section
- **Correct artefact folder paths:** All workflow files that referenced old unnumbered folder
  paths (`src/PLANS/`, `src/BUGS/`, etc.) have been corrected to their current numbered
  equivalents
- **README MCP table:** Updated to list all six servers with accurate scope classification
  and added descriptive paragraphs for each group

---

## v1.3.0 — 29/04/2026

**Status:** Feature release — Pre-development workflow phase, DESIGN.md, and agent hint system

### Summary

Expands the project management layer with three new pre-development workflows (security checks,
QA scenario planning, and sprint planning), adds a root-level `DESIGN.md` entry point for
all UI/UX and brand work, and rolls out a consistent agent hint system across every reference
document and workflow context file.

### What's new since v1.2.0

- **DESIGN.md entry point:** A new root-level `DESIGN.md` maps all design-related standards,
  guides, and workflows across the full documentation stack — a single place to start any
  UI/UX, component, brand, or wireframe task
- **Security checks workflow (`09-security-checks`):** Threat-model planned features before
  sprint planning to surface risks early; includes CHECKLIST, CONTEXT, and STEPS
- **QA checks workflow (`10-qa-checks`):** Define QA scenarios for each user story before
  development begins, ensuring testability is built in from the start
- **Sprint plans workflow (`11-sprint-plans`):** Write sprint plans with MoSCoW
  prioritisation, phased delivery, and a clear definition of done
- **Sprint plans folder (`project-management/src/11-SPRINT-PLANS/`):** Dedicated artefact
  folder for sprint plan documents alongside stories, QA, and reviews
- **Three new PM reference guides:** `QA-GUIDE.md`, `SECURITY-GUIDE.md`, and
  `SPRINT-PLANNING-GUIDE.md` added to `project-management/docs/`
- **Agent hint system:** Every `code/docs/`, `code/workflows/`, `how-to/docs/`,
  `how-to/workflows/`, and `project-management/` reference file now carries a hint line
  naming the right model and MCP servers — agents self-configure on first read
- **docfork MCP guidance:** `.claude/CLAUDE.md` now documents the `docfork` MCP server and
  dual-tool `docfork` + `context7` lookup pattern for library documentation

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
