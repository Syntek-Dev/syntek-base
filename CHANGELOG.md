# Changelog

**Last Updated**: <%DATE%> **Version**: 0.13.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.13.0] - 02/08/2026

### Added

- **The opt-in React Native mobile surface.** `INCLUDE_MOBILE` (default `false`) gates a bootable Expo application at `code/src/mobile/` — Expo SDK 57 with Continuous Native Generation, expo-router, TypeScript, one placeholder route, and no binary assets. Answering no produces a repository functionally identical to 0.12.0's output.
- `MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID` Copier questions, asked only when the mobile surface is included; the bundle ID defaults to the primary domain, label-reversed.
- `code/src/scripts/mobile/` — `install.sh`, `server.sh`, `lint.sh`, `typecheck.sh`, `test.sh` and `bundle.sh`, plus a shared `_common.sh`. Metro runs on the **host**, the one dev operation that is not containerised, because Expo Go on a physical device cannot reach a loopback alias.
- Four mobile CI jobs — `jest-expo + coverage` and `Bundle export` in `test.yml`, `ESLint (mobile surface)` and `TypeScript (mobile surface)` in `syntax-js-ts.yml` — each guarded at **step** level so a web-only project reports green rather than skipped.
- `.claude/agents/mobile.md` and `.claude/skills/stack-react-native/` — the mobile governance pair, excluded with the tree.
- `code/docs/design-tokens/MOBILE.md` — the design-token bridge: six colour forms with OKLCH canonical and five derived on write, CSS Color 4 gamut mapping, 8-digit hex for mobile, the `render_tokens_ts()` emitter, and which three preference axes collapse to BASE.
- `code/docs/accessibility/MOBILE.md` — the React Native technique set for the unchanged WCAG 2.2 AA standard, including why verification here is manual.
- `code/src/scripts/audits/mobile-tokens.sh` and `.github/workflows/audit-mobile-tokens.yml` — the mobile half of the token-first law. Self-guarding: exits 0 with a note when there is no mobile surface.
- `code/src/mobile/CHANGELOG.md`, `VERSION-HISTORY.md` and `RELEASES.md` — the mobile application is a third independent semver track, starting at 0.1.0.
- Mobile-flagged steps in `project-management/workflows/18-frontend-code/` (Step 4M), `code/workflows/01-new-feature/` (Step 7M) and `code/workflows/02-tdd-cycle/`, plus the mobile wireframe convention in `project-management/src/07-WIREFRAMES/`.

### Changed

- **Five documented invariants narrowed in scope, not in force**, to "the web surface" — `code/src/CLAUDE.md`, `code/src/CONTEXT.md`, `eslint.config.mjs`, `project-management/src/CONTEXT.md` and `code/docs/RENDERING.md`. A mobile app is a separate deployable, not a bundler for Django pages, so `RENDERING.md`'s "there is no fourth row" survives verbatim.
- **"Surface" became load-bearing vocabulary**, defined once in `code/src/CONTEXT.md` → _Surfaces_. Silence still means the web surface.
- `test-backend.yml` renamed **`test.yml`** to hold both surfaces' test jobs, and its path filters dropped — a path-filtered required check never reports and would silently stop gating mobile.
- `audit-template.yml` now runs **both** `INCLUDE_MOBILE` values through every assertion, plus two new ones: the opt-in is obeyed in both directions, and every shared file is byte-identical across the render paths.
- Jinja comment delimiters moved from the vertical-bar pair to a tilde pair, because the old opening sequence collided with TypeScript union types and would have swallowed a generated declaration. No committed file used it as a real comment, so nothing behavioural changed. The sequences themselves are quoted in `how-to/src/TEMPLATE-GUIDE/`, which is excluded from rendering and is the only place they can appear literally.
- `VERSIONING-GUIDE.md` documents the mobile track and its **two-files-one-number** rule (`package.json` and `app.json`); the `version` agent learned it, and its stale `backend`/`frontend`/`shared` sub-package list was corrected.
- `code/docs/testing/COVERAGE.md` reworded from "one floor, not one per layer" to **one standard, enforced once per runtime** — `coverage.py` and Jest share no accumulator.
- **Hard agent counts removed rather than incremented** across `.claude/CLAUDE.md`, `CONTEXT.md`, `.claude/CONTEXT.md`, `how-to/docs/TOOLING-GUIDE.md` and `TEMPLATE-GUIDE/08-CLAUDE-CODE.md` — a count differs between two correct projects once the roster is conditional, and one was already stale.
- `project-management/workflows/07-wireframes/` corrected to match the artefact folder it drives: self-contained HTML screens named `WF-###-<Screen-Name>.html`, not `WF-US###-<DESCRIPTOR>.md`, and Figma/Excalidraw are no longer offered as alternative media.

### Fixed

- `@jest/reporters>glob` repinned from `^7.1.6` to `^9.3.5`, removing `inflight@1.0.6` from the tree. The constraint is an interop shape, not a version floor: glob 10 and 11 set `__esModule` with no `default` export, so `.default.sync` is undefined and the Jest 29 coverage reporter dies. glob 9 is the newest version that still works.

### Security

- `inflight@1.0.6` — an unbounded-memory-leak package — no longer appears anywhere in the dependency tree.

---

## [0.12.0] - 02/08/2026

### Added

- `copier.yml` — the executable template contract: twenty-one questions with derived defaults and validators, custom Jinja delimiters, exclusion rules, and four post-generation tasks. Replaces `setup.sh`.
- `.copier-answers.yml` — rendered into every generated project so `copier update` can three-way-merge later template improvements into live projects.
- `.copier/README.md` — the generated project's README, moved out of the repository root so the root README can describe the template itself.
- `LICENSE` — MIT. The template no longer withholds a licence; `<%LICENCE%>` remains a token so a generated project still chooses its own.
- `SECURITY.md` — private vulnerability disclosure policy, scoped to the realistic risk of an insecure default propagating into every generated project.
- `CONTRIBUTING.md` at the root — the external contributor front door, distinct from `how-to/src/CONTRIBUTING.md` which holds the standards applying inside a generated project.
- `.github/CODEOWNERS`, `.github/PULL_REQUEST_TEMPLATE.md`, and `.github/ISSUE_TEMPLATE/` (bug report, template improvement, config).
- `.github/workflows/audit-template.yml` and `.github/scripts/check-template-tokens.sh` — two unconditional CI gates: token-syntax integrity, and a full generation smoke test asserting zero surviving tokens, no template-only leakage, and intact `${{ }}` / `[[ ]]` syntax.
- `how-to/src/TEMPLATE-GUIDE/` — fourteen numbered guides plus a `CONTEXT.md`/`CLAUDE.md` pair, covering overview, stack, prerequisites, quickstart, answers, generation, repository tour, Claude Code, first story, customising, extending, deployment, updating, and troubleshooting.
- `how-to/src/CONTRIBUTING.md` — the contributing and code-quality standard, lifted out of `how-to/src/CONTEXT.md`.
- Host platform and container-runtime detection in `install.sh` — distinguishes Linux, macOS, WSL and native Windows, accepts Docker Desktop or Colima on macOS, rejects non-WSL Windows shells, and warns on WSL 1 and on repositories living under `/mnt/c`.

### Changed

- **Token delimiters replaced** — swept across 433 files. Jinja's default double-brace delimiters collide with GitHub Actions expressions (`${{ }}`), Django template syntax, and Bruno variables; double-square-bracket was rejected in turn because it is bash test syntax. The replacement variable, block and comment delimiters were each verified absent from the tree before adoption — see `how-to/src/TEMPLATE-TOKENS.md` for the set and the reasoning.
- `README.md` rewritten template-facing and literal — 1160 lines to 140 — describing syntek-base rather than impersonating a shipped product, and indexing the guide set.
- `how-to/src/CONTEXT.md` is now a genuine orientation index rather than a 239-line guide.
- `how-to/src/TEMPLATE-TOKENS.md` rewritten as the contract `copier.yml` implements, including the delimiter rationale.
- Licence language in `how-to/src/CONTEXT.md`, `how-to/src/CLAUDE.md` and the project README now keys off `<%LICENCE%>` instead of asserting proprietary.
- `how-to/CONTEXT.md` and `how-to/REFERENCES.md` corrected — the tree had drifted, omitting every `CLAUDE.md`, `CELERY-FIRST-RUN.md`, `FEATURE-DEPLOY.md`, and `TEMPLATE-TOKENS.md`.
- Deployment documentation made provider-neutral: any Linux host with Docker will serve the application; Hetzner, NixOS and Cloudflare are named as the target the runbooks are written against, not a requirement.
- The Claude Code guide now distinguishes grilling from wayfinder, and the plan requirement (Fable tier) is stated in the README, prerequisites and Claude Code guides.

### Removed

- `setup.sh` — superseded by Copier. Its literal string substitution had no update path, which is the capability the migration exists to gain.

### Fixed

- Two tokens corrupted by Prettier's Markdown formatter, which pairs the underscore inside a token name with nearby `_emphasis_` and rewrites both. A corrupted token renders as an undefined variable and vanishes silently from every generated project.
- Literal token delimiters written in prose inside `how-to/src/CLAUDE.md`, a rendered file — Jinja parsed them and generation failed outright with `TemplateSyntaxError`.
- `_exclude` patterns anchored to the repository root. They use gitignore semantics, so an unanchored `README.md` also matched `.copier/README.md`, and `CONTRIBUTING.md` would have swallowed `how-to/src/CONTRIBUTING.md`.

### Security

- Branch protection on `main` via a repository ruleset — pull request required, conversation resolution required, force-push and deletion blocked, and eleven required status checks. Administrators may bypass, so solo merges still work.
- Private vulnerability reporting enabled on the repository, matching the disclosure route `SECURITY.md` documents.

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

- Hardcoded project identifiers replaced with substitution placeholders throughout the root files — `<%PROJECT_NAME%>`, `<%PROJECT_SLUG%>`, `<%ORG_NAME%>`, `<%ORG_SLUG%>`, `<%DEVELOPER_NAME%>`, `<%LOCALE%>`, `<%TIMEZONE%>`, `<%CURRENCY%>`, `<%LICENCE%>`, and `<%DATE%>`.
- `README.md` rewritten for the Django-only monolith; the version badge and footer set to `0.10.0`.
- `DESIGN.md` and `GAPS.md` rewritten around the token-first design system and the template's open items.
- `package.json`, `pnpm-workspace.yaml`, and `pnpm-lock.yaml` reduced to the tooling dependencies that survive without a JavaScript application.
- `eslint.config.mjs`, `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`, and `.npmrc` re-scoped to the remaining file types.
- `lefthook.yml` — pre-commit hooks re-pointed at the Django tree, with a self-gating ClickUp export step and an advisory code-review-graph pass.
- The six surviving CI workflows re-pointed at `code/src/django/` and the rewritten script surface.

### Removed

- Root `CONTEXT.md` — superseded by `REFERENCES.md` as the root index.
- `LICENCE` — a base template does not choose a licence on behalf of the project scaffolded from it; the placeholder `<%LICENCE%>` is resolved at setup.
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
- `pyproject.toml` — project name templatised to `<%PROJECT_SLUG%>`, version set to the django sub-package `0.1.0` baseline, and the dependency set narrowed to the Django-only stack.

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
