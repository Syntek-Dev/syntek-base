# <%PROJECT_NAME%>

> <%PROJECT_DESCRIPTION%>

Built as a Django monolith — Django + Django Ninja JSON API, server-rendered Django templates +
django-components + HTMX + Alpine throughout, vanilla token CSS, deployed via Docker Compose.

![Version](https://img.shields.io/badge/version-0.1.0-blue)
![Licence](https://img.shields.io/badge/licence-see%20LICENSE-lightgrey)
![Status](https://img.shields.io/badge/status-in%20development-brightgreen)

---

## Table of Contents

1. [Welcome](#welcome)
2. [Purpose](#purpose)
3. [Generated from a template](#generated-from-a-template)
4. [Project Tree](#project-tree)
5. [Prerequisites](#prerequisites)
6. [Getting Started](#getting-started)
7. [Multi-Layer Context System](#multi-layer-context-system)
8. [Project Management](#project-management)
9. [Coding Principles](#coding-principles)
10. [Writing Code — Workflows](#writing-code--workflows)
11. [Claude Code Tooling](#claude-code-tooling)
12. [Docker](#docker)
13. [Project Scripts](#project-scripts)
14. [TDD and BDD](#tdd-and-bdd)
15. [Backend and API Guide](#backend-and-api-guide)
16. [Frontend Guide](#frontend-guide)
17. [Influences and Attribution](#influences-and-attribution)

---

## Welcome

Welcome to the <%PROJECT_NAME%> repository. Whether you are a developer, designer, or Claude Code
agent reading this for the first time — you are in the right place.

The three-layer structure (`code/`, `how-to/`, `project-management/`) is designed to make it easy
to find exactly what you need without reading everything at once. When in doubt, start with the
`CONTEXT.md` for your layer and let it guide you to the right reference or workflow.

If you encounter a workflow folder that is missing `STEPS.md` or `CHECKLIST.md`, record it in
`GAPS.md` at the project root and proceed using `CONTEXT.md` alone. Do not silently generate
missing files.

For questions, issues, or contributions, reach out to the <%ORG_NAME%> development team.

---

## Purpose

**<%PROJECT_NAME%>** is the source repository for the <%PROJECT_NAME%> public website. It is a
full-stack monorepo — one repository containing the Django application (backend and
server-rendered frontend), all supporting infrastructure, and every documentation and
project-management artefact needed to develop, test, and deploy the product.

### Stack

| Layer                      | Technology                                                            |
| -------------------------- | --------------------------------------------------------------------- |
| **Backend language**       | Python 3.14                                                           |
| **Backend framework**      | Django 6                                                              |
| **API**                    | Django Ninja — JSON at `/api/`, OpenAPI at `/api/docs`                |
| **Database**               | PostgreSQL 18                                                         |
| **Cache / broker**         | Valkey (latest stable)                                                |
| **Background tasks**       | Celery (worker + beat) — declared, not wired                          |
| **Backend server**         | Gunicorn + Uvicorn / Nginx                                            |
| **Frontend**               | Django templates + django-components + HTMX + Alpine (every surface)  |
| **Styling**                | Vanilla CSS (design tokens / custom properties)                       |
| **Client build**           | None — no bundler, no client-side framework                           |
| **Public media**           | Cloudinary                                                            |
| **Node runtime**           | Node.js 24 — repo tooling only (see `.nvmrc`)                         |
| **JS package manager**     | pnpm — repo tooling only                                              |
| **Python package manager** | uv                                                                    |
| **Tests**                  | pytest, pytest-django (services, endpoints, templates, HTMX partials) |
| **Browser e2e / a11y**     | pytest-playwright + axe-core-python                                   |
| **API integration tests**  | Bruno                                                                 |
| **Container**              | Docker Compose                                                        |

### Licence notice

This project is licensed **<%LICENCE%>**, held by <%ORG_NAME%>. Add a `LICENSE` file at the
repository root carrying the full terms — it is authoritative, and this notice is a summary.

Third-party dependencies must carry a licence compatible with that choice. Where <%LICENCE%> is
commercial or proprietary, MIT / Apache 2.0 / ISC are safe and GPL/AGPL requires written approval
before use.

**Third-party work redistributed inside this repository** — vendored skills and generated
playbook cards that arrived with the template — carries its own notices in
[`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md). That file is not optional paperwork: it is the
condition on which those files may be redistributed at all. Adding an outside file to this project
adds its row there in the same change.

> Generated from the [syntek-base](https://github.com/Syntek-Dev/syntek-base) template, which is
> MIT licensed. That imposes no obligation on this codebase — the licence above is this
> project's own.

---

## Generated from a template

This repository was generated from
[syntek-base](https://github.com/Syntek-Dev/syntek-base) with
[Copier](https://copier.readthedocs.io/), which means it stays connected to that template. When
syntek-base gains a fix worth having:

```bash
copier update
```

Copier three-way-merges the change against your edits, using the answers recorded in
`.copier-answers.yml` — **keep that file committed**, it is what makes updates possible.

Two things to do on a freshly generated project:

1. **Commit `uv.lock`.** Every Dockerfile builds with `uv sync --frozen`, so the build fails
   without it. If `uv` was not installed at generation time, run `uv lock` now.
2. **Run `/scale-planning`.** The two architecture snapshots
   (`how-to/src/SCALE-ARCHITECTURE/` and `SERVER-ARCHITECTURE/`) ship as skeletons full of
   `TBD — regenerate via /scale-planning` markers and are not meaningful until you do.

---

## Project Tree

```text
<%PROJECT_SLUG%>/
├── .claude/                             ← Claude Code configuration
│   ├── CLAUDE.md                        ← authoritative operating manual: read-order, skills, plugins, rules
│   ├── MEMORY.md                        ← project memory store (always read second, after CLAUDE.md)
│   ├── settings.json                    ← Claude Code settings (permissions, model, disabled marketplace plugins)
│   ├── settings.local.json              ← local overrides (gitignored)
│   ├── skills/                          ← internalised skills (stack, workflow, document standards)
│   ├── hooks/                           ← pre-PR quality gates (fired via PreToolUse hook on gh pr create)
│   │   ├── lib/                         ← gate scripts: format, lint, typecheck, tests, security, stubs, cloc, lockfiles
│   │   ├── pre-pr-check.sh              ← runs all 8 gates; blocks PR creation on failure
│   │   └── post-pr-comment.sh           ← posts gate results as a GitHub PR comment
│   └── plugins/                         ← helper scripts a skill calls (project/env/db/git/log/pm inspection)
│       ├── db-tool.py
│       ├── env-tool.py
│       ├── git-tool.py
│       ├── log-tool.py
│       ├── pm-tool.py
│       └── project-tool.py
├── .github/
│   └── workflows/                       ← CI: syntax, test, and audit checks
│       ├── audit-cloc.yml               ← fails if any source file exceeds 800 lines
│       ├── audit-conflict-markers.yml   ← unresolved conflict markers in any text file — no path filter
│       ├── audit-copy-emdash.yml        ← bans em dashes in public marketing copy
│       ├── audit-copy-slop.yml          ← the AI-slop family, prose half
│       ├── audit-css-gradients.yml      ← bans raw inline gradients in component and page CSS
│       ├── audit-css-slop.yml           ← the AI-slop family, CSS half
│       ├── audit-css-tokens.yml         ← every var(--x) must resolve in the token layer
│       ├── audit-deps.yml               ← scheduled CVE sweep (pnpm audit + pip-audit) and lockfile drift
│       ├── audit-dict-discipline.yml    ← a dictionary used as a record where a named type belongs
│       ├── audit-doc-references.yml     ← every citation in a shipped file must resolve
│       ├── audit-docs-length.yml        ← the 300-line instructional-document limit
│       ├── audit-docs-pairing.yml       ← the CONTEXT.md / CLAUDE.md split
│       ├── audit-doctrine-drift.yml     ← one rule, one home — restated, dropped, or revived
│       ├── audit-mobile-tokens.yml      ← token-first on the mobile surface; self-skips without one
│       ├── audit-negative-space.yml     ← the invariant register against the code, both directions
│       ├── audit-render-slop.yml        ← the AI-slop family, rendered half
│       ├── audit-routing-skills.yml     ← every skill named in routing frontmatter must exist
│       ├── audit-seam-contract.yml      ← the build/operate seam in the server contract
│       ├── audit-secrets.yml            ← scans for accidentally committed secrets
│       ├── audit-skill-conformance.yml  ← every skill against the Agent Skills specification
│       ├── audit-static-analysis.yml    ← the Opengrep leg — Django template XSS and cross-file taint
│       ├── audit-stubs.yml              ← detects hard stubs and TODO/FIXME/HACK markers
│       ├── audit-template-orphans.yml   ← artefacts a `copier update` stranded
│       ├── audit-template-slop.yml      ← the AI-slop family, markup half
│       ├── claude.yml                   ← Claude Code GitHub Actions integration
│       ├── clickup-sync.yml             ← CLICKUP-ONLY — pushes story exports to ClickUp (push/PR)
│       ├── syntax-js-ts.yml
│       ├── syntax-markdown.yml
│       ├── syntax-python.yml
│       ├── test-api.yml
│       ├── test-e2e.yml                 ← playwright-python browser suite
│       └── test.yml                     ← pytest + coverage, and the mobile suite and bundle
├── code/                                ← source code, coding standards, tests
│   ├── CONTEXT.md                       ← coding layer index
│   ├── docs/                            ← coding reference guides; each oversized guide has a matching sub-directory
│   │   ├── ACCESSIBILITY.md             (+ accessibility/ — HTML-AND-ARIA, INTERACTION, TESTING-AND-COMPONENTS)
│   │   ├── API-DESIGN.md                (+ api-design/ — NINJA-CONVENTIONS, REST-CONVENTIONS, AUTH-AND-ERRORS, …)
│   │   ├── ARCHITECTURE-PATTERNS.md     (+ architecture/ — CORE-AND-SCALING, AUTH-CONTRACT, SERVICE-AND-MIDDLEWARE, …)
│   │   ├── BACKEND-CODING-PRINCIPLES.md
│   │   ├── CLAUDE.md
│   │   ├── CODE-REVIEW-GRAPH.md         ← the graph MCP playbooks: explore, debug, review, refactor
│   │   ├── CODING-PRINCIPLES.md         (+ coding-principles/ — DESIGN-PRINCIPLES, PRACTICAL-RULES, STYLE-AND-PROCESS)
│   │   ├── CONTEXT.md
│   │   ├── DATABASE.md                  ← scope columns, database-level constraints, lock-safe migrations, search
│   │   ├── DATA-STRUCTURES.md           (+ data-structures/ — FUNDAMENTALS, SCHEMA-DESIGN, DOMAIN-MODELLING, …)
│   │   ├── DESIGN-TOKENS.md             (+ design-tokens/ — MODEL, CASCADE, EDITOR)
│   │   ├── DISCOVERABILITY.md           (+ discoverability/ — WEB-METADATA, STRUCTURED-DATA, ROOT-SURFACE, …)
│   │   ├── DOCUMENTATION-LENGTH.md      ← the 300-line instructional limit and the 270 ratchet
│   │   ├── DOCUMENTATION-PAIRING.md     ← the CONTEXT.md / CLAUDE.md split and its decision test
│   │   ├── ENCRYPTION-GUIDE.md          (+ encryption/ — FIELD-ENCRYPTION, LOOKUP-TOKENS)
│   │   ├── EXPORTS.md                   ← downloadable file exports (declared, not wired)
│   │   ├── FORWARD-VOICE.md             ← what a shipped doc may claim about the tree it is read in
│   │   ├── FRONTEND-CODING-PRINCIPLES.md
│   │   ├── GATE-REPORTING.md            ← what a gate may claim it looked at; absent tool vs absent surface
│   │   ├── LOGGING.md                   (+ logging/ — DJANGO-LOGGING, FRONTEND-LOGGING, OBSERVABILITY, CLOUDINARY)
│   │   ├── MANAGEMENT-COMMANDS.md       ← the CLI surface: untrusted arguments, blast radius, exit codes
│   │   ├── MCP-SERVER.md                (+ mcp-server/ — MOUNTING, TOOL-DESIGN, AUTH-AND-THREATS, TESTING-AND-OPS)
│   │   ├── NEGATIVE-SPACE.md            ← what the code must never allow: invariants and the error taxonomy
│   │   ├── NOTIFICATIONS.md             ← the send boundary and PII per channel (declared, not wired)
│   │   ├── OBJECT-STORAGE.md            ← private documents over the S3 API (declared, not wired)
│   │   ├── PERFORMANCE.md               (+ performance/ — FRONTEND-PERFORMANCE, DATABASE-PERFORMANCE, API-AND-MONITORING)
│   │   ├── PROCESS-MODEL.md             ← worker class, event loop, and the ORM's sync boundary
│   │   ├── RENDERING.md                 (+ rendering/ — TEMPLATES-AND-INTERACTIVITY, PITFALLS-AND-EXAMPLES)
│   │   ├── RESPONSIVE-DESIGN.md         (+ responsive/ — BREAKPOINTS, MEDIA-QUERIES, CONTAINER-QUERIES, …)
│   │   ├── RLS-GUIDE.md                 (+ rls/ — FUNDAMENTALS, POLICY-TEMPLATES, MIDDLEWARE-AND-NINJA, …)
│   │   ├── SECURITY.md                  (+ security/ — AUTH-AND-AUTHZ, OWASP-AND-CHECKLIST, AUDIT-TRAIL, …)
│   │   ├── TASK-AUTHORING.md            ← background tasks: enqueue boundary, idempotency, retries (declared, not wired)
│   │   ├── TESTING.md                   (+ testing/ — BACKEND-TESTING, FRONTEND-TESTING, API-TESTING, COVERAGE, …)
│   │   ├── URL-STRATEGY.md
│   │   ├── VISUAL-DESIGN.md             (+ visual-design/ — WEB)
│   │   └── cloudinary/                  ← vendored Cloudinary SDK reference (PYTHON_SDK, CROSS_SDK_INFO)
│   ├── src/
│   │   ├── django/                      ← Django 6 + Django Ninja (apps, config, templates, components, static)
│   │   ├── docker/                      ← Dockerfiles and Compose files
│   │   ├── improvement-architecture/    ← /improve-codebase-architecture reports
│   │   ├── logs/                        ← runtime log files (dev/test; gitignored)
│   │   ├── scripts/                     ← audits, database, deployment, development, syntax, tests (+ shared _lib/)
│   │   └── tests/                       ← Bruno API test collections (one collection per domain)
│   └── workflows/                       ← 11 coding workflows in three families
│       ├── 01-implement-story/          ← build
│       ├── 02-tdd-cycle/
│       ├── 03-database-migration/
│       ├── 04-api-design/
│       ├── 05-mcp-server/
│       ├── 06-gdpr-enforcement/
│       ├── 07-review/                   ← verify
│       ├── 08-security-hardening/
│       ├── 09-debugging-with-logs/      ← diagnose & improve
│       ├── 10-debug/
│       └── 11-refactor/
├── how-to/                              ← setup, daily dev, and debugging guides
│   ├── CONTEXT.md
│   ├── docs/                            ← operational reference guides
│   │   ├── CLI-TOOLING.md               ← Claude Code MCP servers, hooks, and dev-script reference
│   │   ├── DEVELOPMENT.md               ← environment variables, Docker setup, and dev tooling catalogue
│   │   ├── GIT-WORKTREES.md             ← worktree-based parallel story development
│   │   ├── TOOLING-GUIDE.md             ← internal skills reference (index)
│   │   └── tooling-guide/               ← detailed tooling guide sub-documents
│   │       ├── COMMANDS.md
│   │       ├── CONFIGURATION.md
│   │       └── WORKFLOW.md
│   ├── REFERENCES.md
│   ├── src/                             ← contributing, code-quality guide, architecture snapshots
│   │   ├── CONTEXT.md
│   │   ├── CONTRIBUTING.md              ← contributing, testing, and code-quality standards
│   │   ├── NIXOS-SETUP.md               ← pointer stub → NixOS deploy repo + SERVER-ARCHITECTURE/
│   │   ├── PROJECT-PATHS.md             ← the path register: what a shipped doc may promise, and what creates it
│   │   ├── SCALE-ARCHITECTURE/          ← how the app scales (scale-planning snapshot)
│   │   └── SERVER-ARCHITECTURE/         ← app→server contract (feeds the NixOS deploy repo)
│   └── workflows/                       ← 9 operational workflows in four families
│       ├── 01-first-time-setup/         ← set up
│       ├── 02-worktree-setup/
│       ├── 03-daily-development/        ← run
│       ├── 04-database-operations/
│       ├── 05-testing-and-coverage/
│       ├── 06-quality-gates/
│       ├── 07-dependency-updates/
│       ├── 08-debugging/                ← diagnose
│       └── 09-write-operator-guide/     ← author
├── project-management/                  ← stories, sprints, plans, GDPR, security
│   ├── CONTEXT.md
│   ├── docs/                            ← PM reference guides
│   │   ├── gdpr/                        ← GDPR sub-documents
│   │   │   ├── COMPLIANCE.md
│   │   │   └── DATA-RIGHTS.md
│   │   ├── GDPR-GUIDE.md                ← GDPR obligations, data flows, and legal bases (index)
│   │   ├── git/                         ← git sub-documents
│   │   │   ├── BRANCHES-AND-WORKTREES.md
│   │   │   ├── COMMITS.md
│   │   │   ├── MIGRATION-GATES.md
│   │   │   └── PR-AND-REQUIRED-CHECKS.md
│   │   ├── GIT-GUIDE.md                 ← branch, commit, PR and migration gates (index)
│   │   ├── QA-GUIDE.md                  ← QA process, test plans, and sign-off criteria
│   │   ├── RESPONSIVE-DESIGN.md         ← breakpoints, fluid layout, and mobile-first rules
│   │   ├── SECURITY-GUIDE.md            ← security sprint dependencies and hardening checklist
│   │   ├── SEO-CHECKLIST.md             ← per-page SEO requirements for marketing pages
│   │   ├── planning/                    ← planning sub-documents
│   │   │   ├── CADENCE.md
│   │   │   ├── SPRINTS.md
│   │   │   └── STORIES.md
│   │   ├── PLANNING-GUIDE.md            ← sprint format, capacity, and MoSCoW conventions
│   │   └── VERSIONING-GUIDE.md          ← semver rules, VERSION file, and CHANGELOG format
│   ├── export/                          ← PDF/ZIP exports for client review + clickup/ (read-only ClickUp story exports)
│   ├── REFERENCES.md
│   ├── src/                             ← live PM artefacts (numbered to mirror workflows)
│   │   ├── 00-ASSETS/
│   │   ├── 01-FEATURE-MAPS/             ← MAP-<FEATURE>.md decision maps (wayfinder)
│   │   ├── 02-STORIES/
│   │   ├── 03-SPRINTS/
│   │   ├── 04-DATABASE/
│   │   ├── 05-USER-FLOW/
│   │   ├── 06-BRAND-GUIDE/
│   │   ├── 07-COMPONENTS/
│   │   ├── 08-WIREFRAMES/
│   │   ├── 09-GDPR/
│   │   ├── 10-SECURITY/
│   │   ├── 11-QA/
│   │   ├── 12-SEO/
│   │   ├── 13-API-DESIGN/
│   │   ├── 14-LOGGING/
│   │   ├── 15-DECISIONS/
│   │   ├── 16-SPRINT-PLANS/
│   │   ├── 17-STORY-PLANS/
│   │   ├── 18-TESTS/
│   │   ├── 19-REVIEWS/
│   │   ├── 20-FINDINGS/
│   │   ├── 21-BUGS/
│   │   ├── 22-REFACTORING/
│   │   └── 23-INCIDENTS/               ← the PII-free incident register; no story, no workflow
│   └── workflows/                       ← 24 step-by-step PM workflows
│       ├── 01-feature-map/              ← chart the feature's decision frontier (wayfinder)
│       ├── 02-story-creation/
│       ├── 03-sprint-planning/
│       ├── 04-database-schema/
│       ├── 05-user-flow-design/
│       ├── 06-brand-guides/
│       ├── 07-component-designs/
│       ├── 08-wireframes/
│       ├── 09-gdpr-compliance/
│       ├── 10-security-checks/
│       ├── 11-qa-checks/
│       ├── 12-seo-checks/
│       ├── 13-api-design/
│       ├── 14-logging-checks/          ← the story's log surface and its exclusion list
│       ├── 15-decisions/               ← ADRs
│       ├── 16-sprint-plans/
│       ├── 17-story-plans/             ← the per-story plan a developer codes from
│       ├── 18-consolidate-design-work/ ← unify per-story design before any code
│       ├── 19-backend-code/
│       ├── 20-api-code/
│       ├── 21-frontend-code/
│       ├── 22-implementation-documentation/ ← docs closeout + graph refresh
│       ├── 23-pr-and-review/
│       └── 24-release/
├── .agents/                             ← vendored third-party skills (Cloudinary) — see THIRD-PARTY-NOTICES.md
├── .zed/                                ← Zed editor settings
├── handoffs/                            ← session handoff documents (the auto-compaction replacement)
├── questionnaires/                      ← /to-questionnaire — outbound discovery questionnaires
├── research/                            ← /research — primary-source-cited notes that feed decisions
├── learning/                            ← /teach sandbox — throwaway learning workspace
├── CHANGELOG.md                         ← human-readable changelog
├── CONTEXT.md                           ← project overview and layer map
├── DEFERRED.md                          ← items explicitly deferred to future stories (checked at sprint planning)
├── DESIGN.md                            ← design entry point: standards, constraints, and workflows
├── GAPS.md                              ← knowledge staging area: gaps, blockers, and architectural notes
├── README.md                            ← this file
├── REFERENCES.md                        ← curated external reference links for development
├── RELEASES.md                          ← release notes archive
├── THIRD-PARTY-NOTICES.md               ← licence notices for third-party work redistributed here
├── VERSION                              ← current semver string
├── VERSION-HISTORY.md                   ← full version bump history
├── eslint.config.mjs
├── install.sh                           ← one-shot setup: installs root deps and git hooks
├── lefthook.yml                         ← pre-commit hook runner
├── package.json                         ← root pnpm workspace
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
├── pyproject.toml                       ← Python tooling (ruff, basedpyright, uv)
├── skills-lock.json                     ← vendored Claude Code skills — source, version, content hash
├── .mcp.json                            ← project MCP servers (code-review-graph, context7, mcp-mermaid)
├── .copier-answers.yml                  ← your generation answers — keep committed, `copier update` needs it
└── uv.lock                              ← generated at project creation; commit it (Dockerfiles build --frozen)
```

**The tree above is the web baseline every project gets.** Each optional surface adds its own
directories on top, and they are absent unless this project opted in: **mobile** adds
`code/src/mobile/` and `code/src/scripts/mobile/`, **rust** adds `code/src/rust/` and
`code/src/scripts/rust/`, and **desktop** adds `code/src/rust/crates/desktop/` and
`code/src/scripts/desktop/`. Each also brings the guides, skill and workflow named for it.

---

## Prerequisites

The application itself runs entirely inside Docker containers — you never run `python`, `pytest`,
or `pnpm` directly on the host. The following tools are only needed for root-level tooling and
local quality checks.

| Tool                                  | Version                      | Purpose                                      |
| ------------------------------------- | ---------------------------- | -------------------------------------------- |
| **Git**                               | any recent                   | version control                              |
| **Docker Engine** (or Docker Desktop) | 27+                          | run all application services                 |
| **Docker Compose plugin**             | v2+                          | orchestrate local containers                 |
| **Node.js**                           | 24 (see `.nvmrc`)            | root pnpm scripts and git hooks              |
| **pnpm**                              | 11+                          | JS package manager (root workspace only)     |
| **Python**                            | 3.14 (see `.python-version`) | root pyproject tooling (ruff, basedpyright)  |
| **uv**                                | 0.11+                        | Python environment and dependency management |

### Supported platforms

Every development operation runs through a `code/src/scripts/**/*.sh` script, so the shell is
part of the contract rather than a preference.

| Platform    | Supported         | What you use                                                                                                                                                              |
| ----------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Linux**   | Natively          | Docker Engine and the Compose v2 plugin, with your user in the `docker` group so `docker compose` needs no `sudo`. Your normal shell.                                     |
| **macOS**   | Natively          | Docker Desktop, or Colima if you prefer no GUI. bash or zsh, Apple silicon or Intel.                                                                                      |
| **Windows** | **Through WSL 2** | Docker Desktop on the **WSL 2 backend**, the repository cloned **inside** the WSL 2 filesystem (`~/projects/…`, never `/mnt/c/…`), and every command run from that shell. |

**On Windows, WSL 2 is required, not a fallback.** PowerShell, `cmd.exe` and Git Bash are not
supported: Git Bash's MSYS path translation rewrites the arguments these scripts pass to
`docker compose`, and working from `/mnt/c/…` puts every bind mount across the Windows filesystem
boundary, which is slow enough to make the dev loop unpleasant. Docker Desktop already installs
WSL 2 to run its own engine, so this asks for no component you would not have.

---

## Getting Started

### Clone the repository

```bash
git clone git@github.com:<%ORG_SLUG%>/<%PROJECT_SLUG%>.git
cd <%PROJECT_SLUG%>
```

### Install root tooling and git hooks

Make the install script executable, then run it:

```bash
chmod +x install.sh
./install.sh
```

This installs all root dev dependencies and runs `lefthook install`, which registers the
pre-commit hooks. From this point on, every `git commit` automatically runs linting and
type-checking across both layers.

### Configure environment variables

The install script copies the example env files for you. Open each one and fill in the required
values before starting Docker:

```text
code/src/docker/.env.dev
code/src/docker/.env.test
code/src/docker/.env.staging
code/src/docker/.env.production
```

See `how-to/docs/DEVELOPMENT.md` for a full list of environment variables and their defaults.

Never commit `.env.dev` or any file containing real secrets.

### Start the development environment

```bash
./code/src/scripts/development/server.sh up
```

This starts:

Four services, and no more:

- **django** — Django ASGI (Uvicorn `--reload` directly, for reliable hot-reload of `.py` and templates), serving templates, HTMX, and the `/api/` JSON API (port 8000). Staging and prod run Gunicorn + Uvicorn workers instead
- **db** — PostgreSQL 18 (port 5432)
- **cache** — Valkey (port 6379)
- **nginx** — reverse proxy routing all traffic (port 80)

There is no Celery `worker` or `beat` container. `celery[redis]` is a declared dependency in `pyproject.toml`, but no Compose file defines those services and no `CELERY_*` setting exists under `code/src/django/config/settings/` — see `how-to/docs/CELERY-FIRST-RUN.md` before wiring it.

**There is no mail catcher.** Dev uses Django's console email backend (`config/settings/dev.py`), so outbound mail is printed to the `django` container's stdout — read it with `bash code/src/scripts/development/logs.sh --service django --follow`. Test uses the in-memory backend. Adding Mailpit is a deliberate change, like any other service.

### Apply database migrations

```bash
./code/src/scripts/database/migrate.sh run
```

### Create a superuser (optional)

```bash
./code/src/scripts/database/manageusers.sh create-superuser
```

### Verify

| URL                                              | Description                           |
| ------------------------------------------------ | ------------------------------------- |
| `http://dev.<%PROJECT_SLUG%>.localhost`          | Public site (Django templates + HTMX) |
| `http://dev.<%PROJECT_SLUG%>.localhost/api/docs` | OpenAPI docs (Django Ninja; dev)      |
| `http://dev.<%PROJECT_SLUG%>.localhost/control/` | Django admin (non-obvious path)       |

---

## Multi-Layer Context System

The repository is organised into three domain layers, each with its own `CONTEXT.md` index. This
design allows Claude Code (and human contributors) to load only the context relevant to the current
task, keeping responses fast and token-efficient.

### Layers

| Layer                  | Path                  | Purpose                                                 |
| ---------------------- | --------------------- | ------------------------------------------------------- |
| **Code**               | `code/`               | Source code, coding standards, tests, quality workflows |
| **How-To**             | `how-to/`             | Setup guides, daily development commands, debugging     |
| **Project management** | `project-management/` | User stories, sprints, plans, GDPR, security audits     |
| **Design**             | `DESIGN.md`           | Design standards, constraints, and UI workflows         |
| **Claude config**      | `.claude/`            | Operating manual, skills, hooks, and helper scripts     |

### Routing — read only the layer you need

| Task type                                          | Read first                      |
| -------------------------------------------------- | ------------------------------- |
| Writing, reviewing, or testing code                | `code/CONTEXT.md`               |
| Stories, sprints, PRs, releases, GDPR, SEO         | `project-management/CONTEXT.md` |
| Setup, daily dev, CLI usage, debugging             | `how-to/CONTEXT.md`             |
| Component design, wireframes, brand, responsive UI | `DESIGN.md`                     |

Always-applicable guides: `project-management/docs/GIT-GUIDE.md` ·
`project-management/docs/VERSIONING-GUIDE.md`

### How Claude Code uses this structure

When you open a session, Claude Code reads `.claude/CLAUDE.md` then `.claude/MEMORY.md` first —
always, before any work. `CLAUDE.md` is the operating manual: the read-order, when to load each
skill, the `.claude/plugins/` helper scripts, and the routing frontmatter that every
`docs/`/`workflows/` file carries. It deliberately holds no layer-specific detail — that lives in
each layer's own `CONTEXT.md`, which Claude reads only when the task is within that layer's
domain.

Each `CONTEXT.md` links to the `docs/` guides and `workflows/` step-by-step processes relevant to
that layer. This keeps the active context window small and ensures Claude always reads the right
reference material rather than everything at once.

### Quick-start by role

| You are…                                   | Start here                      |
| ------------------------------------------ | ------------------------------- |
| First time in this repository              | `how-to/CONTEXT.md`             |
| Writing or reviewing code                  | `code/CONTEXT.md`               |
| Planning, writing stories, or PM work      | `project-management/CONTEXT.md` |
| Doing design work (wireframes, brand, UI)  | `DESIGN.md`                     |
| Configuring Claude Code, skills, and hooks | `.claude/CLAUDE.md`             |

---

## Project Management

All project management artefacts live in `project-management/`. The folder is structured to make
the right document easy to find, and every file type follows a strict naming convention so nothing
gets lost.

### User stories

Stories live in `project-management/src/02-STORIES/` and follow the naming convention `US###.md`
(three-digit zero-padded: `US001.md`, `US042.md`).

Each story should define acceptance criteria, the affected layer (backend / frontend / both), and
any GDPR or accessibility considerations. Use the PM workflow
`project-management/workflows/02-story-creation/` to write stories consistently.

### ClickUp story sync — client-facing exports

Until the site is deployed, scrum boards are tracked in **ClickUp**. Each story's `**Status:**`
header uses the ClickUp status vocabulary: `Open`, `Pending`, `In Progress`, `In Review`,
`Accepted`, `Accepted Customer`, `Rejected`, `Rejected Customer`, `Blocked`, `Completed`, `Closed`.

Only client-facing fields go to ClickUp. A generator produces **one read-only Markdown file per
story** in `project-management/export/clickup/US###-CLIENT.md`, containing just the title, a
Status · MoSCoW · Story Points table, the Client Summary, and the User Story. Acceptance criteria,
tasks, and all technical detail stay internal.

**Flow:** edit the status (or other client-facing field) in the source story under `02-STORIES/`,
then regenerate the export:

```bash
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh        # all stories
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US014  # one story
```

The exports are **generated and read-only — never hand-edit them.** Enforcement is layered: a
`.claude/settings.json` deny rule blocks Claude's edit tools, a lefthook pre-commit
(`precommit-clickup.sh`) regenerates and re-stages them on every commit, and the files are written
`0444`. `README.md` is the only editable file in that folder — see
`project-management/export/clickup/README.md` for detail.

**Push to ClickUp — clickup-only.** The `clickup-sync` GitHub workflow
(`.github/workflows/clickup-sync.yml`) runs `sync-clickup.sh` on push/PR to `main`, `staging`,
`dev`, and `testing`, upserting one ClickUp task per story. A durable `story → task id` map
(`project-management/export/clickup-task-map.json`) keeps it idempotent — the map starts absent
and the first applying run creates it. It runs as a **dry run** until the `CLICKUP_API_TOKEN` and
`CLICKUP_LIST_ID` repo secrets are set.

This whole sync — the workflow, the three scripts and the generated `export/clickup/` tree — is
present only if this project was generated with `INCLUDE_CLICKUP`. ClickUp is the only board the
template can write to; on any other tool the sync is yours to write, starting from the
`pm-tool-sync` skill and `.claude/plugins/pm-tool.py`, which ship either way. The repository is
the source of truth regardless: the board mirrors `02-STORIES/`, never the reverse.

### Sprint planning

Sprint work follows a two-stage process:

**Stage 1 — Early sprint record** (`project-management/src/03-SPRINTS/`, `SPRINT-##.md`):
A high-level record capturing the sprint goal and candidate stories. Written at the start of a
cycle using `project-management/workflows/03-sprint-planning/`.

**Stage 2 — Detailed sprint plan** (`project-management/src/16-SPRINT-PLANS/`, `SPRINT-PLAN-##.md`):
Written _after_ GDPR, security, and QA checks are complete. Records the definitive story
assignments, per-phase breakdown (backend → API → frontend → PR), developer constraints from the
checks, and the sprint definition of done. Use `project-management/workflows/16-sprint-plans/`.

Both use **MoSCoW** prioritisation (Must / Should / Could / Won't). See
`project-management/docs/PLANNING-GUIDE.md` for the full format and conventions.

### Database ERDs with mcp-mermaid

Database schemas and entity-relationship diagrams are documented in
`project-management/src/04-DATABASE/` using Mermaid diagrams.

The `mcp-mermaid` MCP server renders Mermaid diagrams inside Claude Code sessions. Install it once
on your machine:

```bash
npx -y @anthropic-ai/mcp-install mcp-mermaid
```

Full installation guide: [github.com/hustcc/mcp-mermaid](https://github.com/hustcc/mcp-mermaid)

Once installed, use the `mcp__mcp-mermaid__generate_mermaid_diagram` tool inside Claude Code to
render diagrams from Mermaid syntax. Schema design is formalised before any migration is written —
use `project-management/workflows/04-database-schema/` to go through the sign-off process.

Example ERD syntax committed to `04-DATABASE/`:

```text
erDiagram
    USER {
        uuid id PK
        string email
        string display_name
    }
    PROFILE {
        uuid id PK
        uuid user_id FK
        string bio
    }
    USER ||--|| PROFILE : has
```

### Wireframes

UI wireframes are self-contained HTML screens committed under
`project-management/src/08-WIREFRAMES/` — no CDN, no framework, no external fonts, so a screen
opens over `file://` and diffs like any other file. Each records the story it belongs to and its
sign-off status. No frontend work begins on a feature until the wireframe is signed off — use
`project-management/workflows/08-wireframes/`.

### User flow diagrams

User flows are documented as Mermaid flowcharts in `project-management/src/05-USER-FLOW/`. They capture the end-to-end journey through a feature before implementation
begins.

### QA and testing documentation

| Document type                   | Naming convention                | Location                                       |
| ------------------------------- | -------------------------------- | ---------------------------------------------- |
| QA gap analysis report          | `QA-REPORT-<AREA>.md`            | `project-management/src/11-QA/PLANNING/`       |
| QA plan (pre-development)       | `QA-US###-<DESCRIPTION>.md`      | `project-management/src/11-QA/PLANNING/`       |
| QA review (post-implementation) | `QA-IMPL-US###-<DESCRIPTION>.md` | `project-management/src/11-QA/IMPLEMENTATION/` |
| Sprint plan                     | `SPRINT-PLAN-##.md`              | `project-management/src/16-SPRINT-PLANS/`      |
| Test status tracker             | `US###-TEST-STATUS.md`           | `project-management/src/18-TESTS/`             |
| Manual testing guide            | `US###-MANUAL-TESTING.md`        | `project-management/src/18-TESTS/`             |
| Bug report                      | `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` | `project-management/src/21-BUGS/`              |

Automated tests are written first (TDD) and their status is tracked in `TEST-STATUS.md`. Manual
tests are documented in `MANUAL-TESTING.md` and run before any PR is promoted to `staging`.

### PM workflows — when to use each

| Workflow                | Trigger                                                      |
| ----------------------- | ------------------------------------------------------------ |
| `02-story-creation/`    | Writing a new user story                                     |
| `03-sprint-planning/`   | Creating the initial high-level sprint record                |
| `04-database-schema/`   | Designing a new model or schema change                       |
| `05-user-flow-design/`  | Mapping user journeys before wireframing                     |
| `06-brand-guides/`      | Establishing or updating the visual brand identity           |
| `07-component-designs/` | Designing reusable UI components before frontend work        |
| `08-wireframes/`        | Creating or updating wireframes before frontend work         |
| `09-gdpr-compliance/`   | Reviewing a feature for GDPR compliance                      |
| `10-security-checks/`   | Threat modelling and security review of designs              |
| `11-qa-checks/`         | QA planning from wireframes before any code is written       |
| `12-seo-checks/`        | SEO review and metadata checks before frontend work          |
| `13-api-design/`        | Designing the Django Ninja API surface                       |
| `16-sprint-plans/`      | Writing the detailed sprint plan after all pre-sprint checks |
| `19-backend-code/`      | Implementing Django models, services, and business logic     |
| `20-api-code/`          | Implementing the Django Ninja API layer                      |
| `21-frontend-code/`     | Implementing Django templates, components, and HTMX partials |
| `23-pr-and-review/`     | Raising a PR and moving it through the promotion chain       |
| `24-release/`           | Cutting a release (version bump, changelog, deploy)          |

---

## Coding Principles

The full principles reference is in `code/docs/CODING-PRINCIPLES.md`. These are the rules that
apply to every line of code in this project.

### Data structures are king

> _"Show me your tables, and I won't usually need your flowcharts."_ — Linus Torvalds

Design your data model first. A clear, well-named schema eliminates the need for complex
algorithms. The logic follows naturally from the structure.

### File length limit

Each coding file has a hard maximum of **750 lines** (800 with grace). If a file exceeds this,
split it into focused modules and import them. A file that is hard to scroll is a file that needs
to be broken up.

### Short, focused functions

Each function does exactly one thing. Short functions are easier to test, easier to name, and
easier to reason about. If a function needs a comment to explain what it does, consider whether
renaming it or splitting it would make the comment unnecessary.

### Comments explain _why_, not _what_

Do not comment what the code does — well-named identifiers already do that. Only add a comment
when the WHY is non-obvious: a hidden constraint, a subtle invariant, a workaround for a specific
bug. If removing the comment would not confuse a future reader, do not write it.

### Comments never point outside the code file

The reason travels in the comment. Never cite a story (`US###`), sprint, ADR, plan, bug record,
ticket, issue, PR, commit, documentation path, URL, person, or date — a reader who cannot open the
reference still has to understand why. The developer documentation carries all of that; a code
file never repeats it. Deferred work goes to `DEFERRED.md` or `GAPS.md`, never a `TODO`/`FIXME`
left in committed code.

### Doc strings — one line maximum

A public function's doc string is one short line saying **why** the function exists. No
multi-paragraph blocks, and no `Args:`/`Returns:`/`Raises:` block — the typed signature already
carries them. If the function is complex enough to need a paragraph, split it into smaller
functions first.

The exception is a doc string that is _published_: a Django Ninja endpoint doc string and
`summary` render on the OpenAPI page, and a FastMCP tool doc string is the prompt a model reads
when choosing a tool. Those are interface documentation, not comments, and state the full what.

### Error handling

Always use parenthesised tuple syntax when catching multiple exception types:

```python
# CORRECT
except (ValueError, TypeError):
    ...

# WRONG — Python 2 syntax, causes SyntaxError in Python 3
except ValueError, TypeError:
    ...
```

Log at `ERROR` or `WARNING` before swallowing any exception. Silent failures are the hardest class
of bug to diagnose.

### Atomic transactions

Every service method that performs two or more database writes must use `transaction.atomic()`.
Without it, a failure partway through leaves the database in an inconsistent state:

```python
# CORRECT
with transaction.atomic():
    BackupCode.objects.filter(user=user).delete()
    BackupCode.objects.bulk_create([...])
```

### Imports at the top

All imports belong at the top of the file. No imports inside functions, methods, or classes unless
a narrow justified exception applies (circular import resolution, optional dependency, lazy loading
for performance). Document the reason with a comment when an exception is used.

### Key principles at a glance

| Principle          | Rule                                                                                     |
| ------------------ | ---------------------------------------------------------------------------------------- |
| **SOLID**          | Single responsibility, open/closed, Liskov, interface segregation, dependency inversion  |
| **CUPID**          | Composable, Unix-like, predictable, idiomatic, domain-based                              |
| **YAGNI**          | Do not build for hypothetical future requirements                                        |
| **DRY / WET**      | Don't Repeat Yourself — but use the Rule of Three: abstract only on the third occurrence |
| **KISS**           | The simplest solution that works correctly is almost always the best one                 |
| **Law of Demeter** | Do not reach through chains of objects; talk only to immediate collaborators             |
| **Twelve-Factor**  | Config in env vars, stateless processes, build/release/run separation                    |

Full detail with examples → `code/docs/CODING-PRINCIPLES.md`

---

## Writing Code — Workflows

All coding work follows one or more of the eleven workflows in `code/workflows/`. Each workflow
folder contains four files:

- `CONTEXT.md` — when to use it and prerequisites
- `CLAUDE.md` — the operating rules for that workflow
- `STEPS.md` — the ordered steps to execute
- `CHECKLIST.md` — verification checklist before marking the work complete

**Rule:** read `CONTEXT.md` first for decision-making context. Only enter `STEPS.md` when the
workflow is explicitly triggered.

### The eleven coding workflows

Grouped in three families. The numbers are stable identifiers, not a sequence — you never run
`01` through `11`. Two more exist behind the optional surfaces and are absent here unless this
project opted in: **`12-rust-extension/`** (rust-only) and **`13-desktop-app/`** (desktop-only).

| Family                 | #   | Workflow                  | Purpose                                                                  |
| ---------------------- | --- | ------------------------- | ------------------------------------------------------------------------ |
| **Build**              | 01  | `01-implement-story/`     | Add a full-stack feature (backend + frontend) from story to commit       |
|                        | 02  | `02-tdd-cycle/`           | Test-driven development — Red → Green → Refactor                         |
|                        | 03  | `03-database-migration/`  | The data layer — create and run a new Django migration                   |
|                        | 04  | `04-api-design/`          | The JSON layer at `/api/` — Django Ninja routers, Schemas, endpoints     |
|                        | 05  | `05-mcp-server/`          | The agent layer at `/mcp/` — FastMCP tools over the service layer        |
|                        | 06  | `06-gdpr-enforcement/`    | Cross-cutting — encryption, consent, deletion in code                    |
| **Verify**             | 07  | `07-review/`              | Code quality review before raising a PR (security, principles, coverage) |
|                        | 08  | `08-security-hardening/`  | OWASP A01–A10 security review and hardening                              |
| **Diagnose & improve** | 09  | `09-debugging-with-logs/` | **Find** the cause — local logs, Glitchtip, Loki, Grafana                |
|                        | 10  | `10-debug/`               | **Fix** it — isolate in code, write a regression test, apply the fix     |
|                        | 11  | `11-refactor/`            | **Improve** it — restructure without changing behaviour                  |

`09` and `10` are two halves of one activity: `09` locates a fault and hands over, `10` fixes it
and proves the fix with a test.

### Documentation hard gate

Every workflow includes a **"Update Context and Documentation"** step placed immediately before
the commit step. This is a hard gate — do not commit until it is complete:

1. Update directory trees in every affected `CONTEXT.md` to reflect new files or folders
2. Update the `**Last Updated**` date in every `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. Create a `CONTEXT.md` inside every new directory introduced by the workflow

For feature workflows, implementation records must also be written before the commit: GDPR,
security assessment, security audit, threat model, QA, SEO (if public pages), API design (if
schema changed), code review record, and test records. See
`code/workflows/01-implement-story/STEPS.md` Step 10 for the full table.

Open issues that cannot be resolved in the current PR go to `/GAPS.md`. Items explicitly
deferred to a named future story go to `/DEFERRED.md`. Both files must be current before any
PR is opened.

### Typical feature development sequence

```text
01-implement-story  →  02-tdd-cycle  →  04-api-design  →  06-gdpr-enforcement  →  07-review  →  PM: 23-pr-and-review
```

- Start with `01-implement-story` to plan the feature scope.
- Work in `02-tdd-cycle` — write failing tests first, then implement.
- If the feature exposes a new Django Ninja API, follow `04-api-design` in parallel.
- If the feature touches PII, run `06-gdpr-enforcement` before raising a PR.
- Before opening the PR, run `07-review` to verify OWASP coverage, coding principles, and
  coverage floors.
- Hand off to the PM layer with `project-management/workflows/23-pr-and-review/`.

### Bug fix sequence

```text
how-to/08-debugging  →  10-debug  →  07-review  →  PM: 23-pr-and-review
```

Start with the operational debugging workflow to confirm the environment is healthy, then use
`10-debug` to isolate and fix the logic. Never refactor and fix a bug in the same commit — if the
fix reveals a design problem, open a separate refactoring task using `11-refactor`.

---

## Claude Code Tooling

### Skills

Everything Claude Code does here runs from a skill under `.claude/skills/` (register of record:
`.claude/skills/CONTEXT.md`), internalised from the now-disabled `<%ORG_SLUG%>-dev-suite` /
`<%ORG_SLUG%>-doc-writer` plugins. A skill is loaded when its trigger matches, not read up front:
a **reference skill** states conventions and runs inline; a **task skill** is a procedure, and
dispatches `general-purpose` through the Agent tool — naming the skill to load — when a step
needs a fresh context. Each phase dispatches separately, so no skill reviews its own work, and
the multi-phase ones carry a **Documentation phase** as a hard gate before their commit phase.
Skills run `opus` by default; the planning set (`story`, `sprint`, `planner`, `scale-planning`)
runs `fable`. `sonnet` and `haiku` are never used.

| Skill                                               | Load when                                                                    |
| --------------------------------------------------- | ---------------------------------------------------------------------------- |
| `implement-story` · `bugfix` · `refactor`           | Build something new · fix something broken · reshape something that works    |
| `review` · `security`                               | Check a change before it ships · audit and harden against OWASP and CE       |
| `pr` · `release`                                    | Raise the pull request · cut the release                                     |
| `story` · `sprint` · `planner`                      | Write the story · slice the sprint · architect the implementation plan       |
| `syntax` · `completion`                             | Clear the lint, format and type gates · record a story or sprint complete    |
| `backend` · `frontend` · `database`                 | Build the server side · build the pages · work the data layer                |
| `authentication` · `notifications`                  | The credential and session layer · sending email, SMS, push and in-app       |
| `gdpr-mechanics` · `data-analysis` · `pm-tool-sync` | UK GDPR in the stack · ask the data · the external PM-tool sync              |
| `setup` · `scaffold`                                | Stand up code structure · stand up the docs and workflow layer               |
| `doc-writer` · `support-articles`                   | Developer documentation · end-user help content                              |
| `version` · `git` · `cicd`                          | Move the version set · the git surface · pipeline, deploys and dependencies  |
| `test-writer` · `qa-tester` · `code-reviewer`       | Write the red tests · break it · review it, Standards and Spec separately    |
| `reporting` · `logging` · `seo`                     | Report data · log instrumentation · the head, JSON-LD and crawler wiring     |
| `stack-django`                                      | Backend — models, migrations, services, Django Ninja endpoints, pytest       |
| `stack-htmx-templates`                              | Public frontend — templates, django-components, HTMX, Alpine, token CSS      |
| `stack-fastmcp`                                     | The MCP tool surface at `/mcp/`                                              |
| `stack-react-native` · `stack-rust` · `stack-slint` | The optional mobile, Rust and desktop surfaces — absent unless opted in      |
| `global-workflow`                                   | Branches, commits, PRs, version bumps, docs, code comments                   |
| `grilling` · `grill-me` · `grill-with-docs`         | Any substantial design work — the interview that precedes the artefact       |
| `codebase-design` · `domain-modelling`              | Architecture vocabulary; recording a new concept or decision                 |
| `improve-codebase-architecture`                     | `/improve-codebase-architecture` — find shallow modules, report, then grill  |
| `scale-planning`                                    | `/scale-planning` — size the deployment and prove it scales                  |
| `wayfinder`                                         | Charting an epic too big for one session into a decision map                 |
| `handoff`                                           | `/handoff` — the auto-compaction replacement; write the doc, then stop       |
| `prototype` · `research` · `teach`                  | A throwaway spike · a primary-source note · a learning sandbox               |
| `incident`                                          | Something is broken in staging or production and the response needs a scribe |
| `to-questionnaire`                                  | A decision is blocked on someone outside the session — client, DPO, vendor   |
| `wait-what`                                         | `/wait-what` — the last reply did not land; re-pitch it                      |
| `resolving-merge-conflicts`                         | A merge, rebase, or `copier update` has left conflict markers                |
| `wizard`                                            | Authoring an interactive bash wizard for steps only a human can perform      |
| `runbook`                                           | Writing an operator guide someone will execute under pressure                |
| `export`                                            | Getting data out as a file — CSV, Excel, PDF or JSON, with PII gated         |
| `legal-documents` · `msp-scp-documents`             | Drafting a legal document or a security/compliance policy                    |
| `cloudinary-*`                                      | Cloudinary upload, delivery, and transformation work                         |

**Grilling is the one to understand first.** Substantial work does not begin with the work — it
begins with an interview, asked in **rounds**: every question whose prerequisites are already
settled goes out together, numbered, each with brief options and an explicit recommendation. You
answer the set; the answers unblock the next round. Facts are looked up rather than asked, and
nothing is built until you confirm. The shape lives in `.claude/skills/grilling/SKILL.md` and is
deliberately stated **nowhere else** — every skill and workflow routes to it.

### Helper scripts

Scripts in `.claude/plugins/` are Python helpers a skill calls (`python3 .claude/plugins/x.py`) to
inspect the local environment for context. They do **not** run dev operations — those go through
`code/src/scripts/**/*.sh`.

| Helper            | Purpose                                                                 |
| ----------------- | ----------------------------------------------------------------------- |
| `project-tool.py` | Project structure detection and technology stack identification         |
| `env-tool.py`     | Read, compare, and validate environment files across environments       |
| `db-tool.py`      | Database detection and connection info for backend and setup skills     |
| `git-tool.py`     | Repository status, branch info, remote detection, and commit history    |
| `log-tool.py`     | Log file discovery, logging config detection, and recent log extraction |
| `pm-tool.py`      | Detect project management tool configs (Linear, ClickUp, Jira, etc.)    |

### MCP servers

| Server              | Scope              | Always available                       |
| ------------------- | ------------------ | -------------------------------------- |
| `code-review-graph` | Repo — `.mcp.json` | Yes — auto-loaded for all contributors |
| `context7`          | Machine-global     | Only if installed locally              |
| `claude-in-chrome`  | Machine-global     | Only if installed locally              |
| `mcp-mermaid`       | Machine-global     | Only if installed locally              |

---

## Docker

All application services run inside Docker. Never run `python`, `pytest`, or `pnpm` directly on the
host — always use `docker compose exec`.

Full Docker reference: `code/src/docker/CONTEXT.md`

### Environments

| Environment | Compose file                 | Who uses it             |
| ----------- | ---------------------------- | ----------------------- |
| `dev`       | `docker-compose.dev.yml`     | Developer locally       |
| `test`      | `docker-compose.test.yml`    | CI / developer          |
| `staging`   | `docker-compose.staging.yml` | GitHub Actions → server |
| `prod`      | `docker-compose.prod.yml`    | GitHub Actions → server |

**Worktree isolation:** each `us###` feature branch has a matching
`docker-compose.us###.dev.yml` and `docker-compose.us###.test.yml` override. The
`server.sh` and test scripts auto-detect the active branch and apply the override so
containers are namespaced as `<%PROJECT_SLUG%>-dev-us###-*` and served at
`http://dev-us###.<%PROJECT_SLUG%>.localhost:3080`. Full guide: `how-to/docs/GIT-WORKTREES.md`.

### Services per environment

| Service     | dev | test | staging | prod | Notes                                  |
| ----------- | --- | ---- | ------- | ---- | -------------------------------------- |
| `django`    | ✅  | ✅   | ✅      | ✅   | Django ASGI — Gunicorn + Uvicorn       |
| `worker`    | ❌  | ❌   | ❌      | ❌   | Celery worker — declared, not wired    |
| `beat`      | ❌  | ❌   | ❌      | ❌   | Celery beat — declared, not wired      |
| `db`        | ✅  | ✅   | ❌      | ❌   | PostgreSQL 18 — server-managed in prod |
| `cache`     | ✅  | ✅   | ❌      | ❌   | Valkey — server-managed in prod        |
| `seaweedfs` | ❌  | ❌   | ❌      | ❌   | S3 storage — `boto3` declared, unwired |
| `nginx`     | ✅  | ✅   | ❌      | ❌   | Reverse proxy (port 80)                |

### Common commands

```bash
# Start / stop dev stack
bash code/src/scripts/development/server.sh up
bash code/src/scripts/development/server.sh down

# View logs
bash code/src/scripts/development/logs.sh --follow
bash code/src/scripts/development/logs.sh --service django --follow

# Open a shell in a container
bash code/src/scripts/development/shell.sh                   # django (default)
bash code/src/scripts/development/shell.sh --service db      # any service in the dev compose file

# Run backend tests
bash code/src/scripts/tests/backend.sh
```

For the full script catalogue see [Project Scripts](#project-scripts).

### Staging and production images

Staging and prod images are pushed to GHCR by GitHub Actions and pulled on the server:

```text
ghcr.io/<%ORG_SLUG%>/<%PROJECT_SLUG%>/django:<tag>
```

Tags: `staging`, `prod`, or a git SHA. Set `IMAGE_TAG` in the server environment.

### Observability (staging / prod)

| Tool       | Purpose                                          |
| ---------- | ------------------------------------------------ |
| Glitchtip  | Exception and error tracking (Sentry-compatible) |
| Alloy      | Log shipping: server host → Loki (Grafana Alloy) |
| Loki       | Log aggregation and storage                      |
| Prometheus | Django metrics scraped from `/metrics/`          |
| Grafana    | Dashboards querying Loki + Prometheus            |

Full observability guide: `code/docs/LOGGING.md`

---

## Project Scripts

All scripts live under `code/src/scripts/` and are made executable by `install.sh`. Run any
script with `--help` for full usage details. Reports are written to the script group's own
`reports/` subdirectory (gitignored).

### Root scripts (run on host via pnpm)

These run on the host machine and cover root-level JS/TS config files and Markdown documentation.

```bash
pnpm lint:md          # markdownlint — checks every Markdown file
pnpm lint:md          # markdownlint-cli2 — checks all Markdown files
pnpm format:check     # Prettier — dry-run format check
pnpm format           # Prettier — apply formatting
pnpm prepare          # Install Lefthook git hooks (runs automatically after install.sh)
```

### Development scripts (`code/src/scripts/development/`)

| Script                  | Purpose                                                               |
| ----------------------- | --------------------------------------------------------------------- |
| `server.sh`             | Manage the dev stack: `up`, `down`, `restart`, `build`, `status`      |
| `logs.sh`               | View and tail container logs; filter by service, time, or count       |
| `shell.sh`              | Open an interactive shell in any dev container                        |
| `new-django-app.sh`     | Scaffold a new Django app with per-model-file structure               |
| `new-django-view.sh`    | Scaffold a new public marketing page (Django view + template + URL)   |
| `install-backend.sh`    | Update `uv.lock` and optionally sync Python backend dependencies      |
| `install-frontend.sh`   | Update `pnpm-lock.yaml` and optionally sync frontend dependencies     |
| `install.sh`            | Compatibility shim — forwards to `install-frontend.sh`                |
| `pnpm-update.sh`        | Self-update pnpm and pin the new version across project files         |
| `hosts-story-add.sh`    | Add `/etc/hosts` entries for a story worktree (worktree dev setup)    |
| `hosts-story-remove.sh` | Remove `/etc/hosts` entries for a story worktree                      |
| `sync-trees.sh`         | Reconcile every `CONTEXT.md` Directory Tree against disk (pre-commit) |

```bash
./code/src/scripts/development/server.sh up
./code/src/scripts/development/server.sh down
./code/src/scripts/development/server.sh status
./code/src/scripts/development/logs.sh --service django --follow
./code/src/scripts/development/shell.sh
./code/src/scripts/development/new-django-app.sh <app_name>
./code/src/scripts/development/new-django-view.sh <route_path>
./code/src/scripts/development/install-backend.sh --sync
./code/src/scripts/development/install-frontend.sh --local
./code/src/scripts/development/hosts-story-add.sh <story-number>
./code/src/scripts/development/hosts-story-remove.sh <story-number>
```

### Database scripts (`code/src/scripts/database/`)

| Script                  | Purpose                                                                |
| ----------------------- | ---------------------------------------------------------------------- |
| `migrate.sh`            | Django migrations: `run`, `make`, `show`, `check`, `fake`              |
| `manageusers.sh`        | Create or promote users: `create-superuser`, `create-staff`, `promote` |
| `seed-dev.sh`           | Seed the dev database with the pre-defined dev accounts and fixtures   |
| `reset.sh`              | Drop and recreate the dev database, then re-migrate (destructive)      |
| `backup.sh`             | Create a `pg_dump` backup of the dev database                          |
| `restore.sh`            | Restore the dev database from a backup file (destructive)              |
| `shell.sh --psql`       | Open a `psql` session in the db container (connects as the superuser)  |
| `verify-db-security.sh` | Verify database security config (Django checks + PostgreSQL settings)  |

```bash
./code/src/scripts/database/migrate.sh run
./code/src/scripts/database/migrate.sh make --app <app_name>
./code/src/scripts/database/migrate.sh check
./code/src/scripts/database/manageusers.sh create-superuser
./code/src/scripts/database/manageusers.sh create-staff --email <email> --username <username>
./code/src/scripts/database/manageusers.sh promote --email <email> --superuser
./code/src/scripts/database/reset.sh
./code/src/scripts/database/backup.sh
./code/src/scripts/database/restore.sh <backup-file>
./code/src/scripts/database/shell.sh --psql
```

### Test scripts (`code/src/scripts/tests/`)

The test stack (`docker-compose.test.yml`) must be running before executing backend or E2E tests.

| Script                | Purpose                                                                    |
| --------------------- | -------------------------------------------------------------------------- |
| `all.sh`              | Run the backend suite; `--api` adds Bruno; `--coverage` enforces the floor |
| `backend.sh`          | Run Django/pytest suite in the test container                              |
| `backend-coverage.sh` | Run Django/pytest with coverage report                                     |
| `api.sh`              | Run Bruno API integration tests against the test stack                     |
| `mutmut.sh`           | Python mutation testing via mutmut inside the backend container            |
| `open-coverage.sh`    | Open the latest coverage report in the browser                             |
| `server.sh`           | Manage the test Docker Compose stack: `up`, `down`, `restart`, `status`    |

```bash
./code/src/scripts/tests/all.sh
./code/src/scripts/tests/all.sh --coverage
./code/src/scripts/tests/backend.sh
./code/src/scripts/tests/backend-coverage.sh
./code/src/scripts/tests/api.sh
./code/src/scripts/tests/mutmut.sh run
./code/src/scripts/tests/open-coverage.sh
./code/src/scripts/tests/server.sh up
```

Full testing guide: `code/docs/TESTING.md` · TDD workflow: `code/workflows/02-tdd-cycle/`

### Syntax scripts (`code/src/scripts/syntax/`)

| Script      | Purpose                                                             |
| ----------- | ------------------------------------------------------------------- |
| `lint.sh`   | Lint with ruff (Python) and markdownlint (Markdown)                 |
| `check.sh`  | Type-check with basedpyright (Python only — there is no TypeScript) |
| `format.sh` | Format with ruff and Prettier; dry-run by default, `--fix` to apply |

```bash
./code/src/scripts/syntax/lint.sh
./code/src/scripts/syntax/lint.sh --fix
./code/src/scripts/syntax/check.sh
./code/src/scripts/syntax/format.sh
./code/src/scripts/syntax/format.sh --fix
```

All three support `--file-type`, `--output`, `--quiet`, and `--path` flags.

### Dependency scripts (`code/src/scripts/dependencies/`)

| Script      | Purpose                                                                                   |
| ----------- | ----------------------------------------------------------------------------------------- |
| `update.sh` | Report or apply dependency updates across Python (uv), JavaScript (pnpm) and Rust (cargo) |

```bash
./code/src/scripts/dependencies/update.sh                            # what is out of date
./code/src/scripts/dependencies/update.sh --apply --package django   # narrowest upgrade
./code/src/scripts/dependencies/update.sh --apply --ecosystem rust   # one ecosystem
./code/src/scripts/dependencies/update.sh --apply                    # everything
```

**A floor is not a pin.** Raising `redis>=5.0.0` to `redis>=6.0` forbids redis 5; it does not
install redis 6. What you get is decided by the lockfile, so raise a floor deliberately and
re-resolve in the same change — then run the suites before committing. Manifest and lockfile
are one change, never two.

Latest is also bounded by the rest of your graph rather than by the registry: `celery[redis]`
excludes `redis>=6.5`, so a floor above that does not fail loudly — it quietly drags celery
backwards to satisfy itself.

### Audit scripts (`code/src/scripts/audits/`)

The register of record is `code/src/scripts/audits/CONTEXT.md` — it is authoritative if this
table ever falls behind it.

| Script                 | Purpose                                                                                  |
| ---------------------- | ---------------------------------------------------------------------------------------- |
| `cloc.sh`              | Count lines per file (warns at 750, fails at 800) and produce a language breakdown       |
| `stubs.sh`             | Detect hard stubs (`NotImplementedError`, `// STUB`) and soft markers (TODO/FIXME/HACK)  |
| `conflict-markers.sh`  | Unresolved git conflict markers in any text file, raw or reformatted by Prettier         |
| `css-tokens.sh`        | Verify component CSS only consumes resolvable `var(--token)` design tokens               |
| `security.sh`          | Dependency CVE audit (`pip-audit`, `pnpm audit`)                                         |
| `static-analysis.sh`   | In-house Opengrep rules — Django template XSS, taint to sink, secrets in source          |
| `dict-discipline.sh`   | A dictionary used as a record in domain code, where a named type belongs                 |
| `css-slop.sh`          | Machine-authored CSS tells — inline gradients, uniform radius/shadow, flat backgrounds   |
| `template-slop.sh`     | Markup tells — emoji chrome, pill-above-heading, whole-sentence bold                     |
| `copy-slop.sh`         | Prose tells in rendered user-facing copy (`BRAND-VOICE.md` Section 4)                    |
| `render-slop.sh`       | Repeated-device tells that need a viewport — one row signature recurring across screens  |
| `copy-emdash.sh`       | Em dashes in user-facing copy                                                            |
| `css-gradients.sh`     | Raw gradient literals outside the token layer                                            |
| `seam-contract.sh`     | Every `**Source:**` in the server contract resolves (`BUILD-OPERATE-SEAM.md`)            |
| `dependency-drift.sh`  | What a template update would change about your dependencies, before it changes them      |
| `doc-references.sh`    | Every citation resolves, and no per-project instance is cited as real                    |
| `docs-pairing.sh`      | `CONTEXT.md` orients, `CLAUDE.md` instructs (`DOCUMENTATION-PAIRING.md`)                 |
| `docs-length.sh`       | Instructional `.md` within 300 cloc code lines (`.claude/CLAUDE.md` Section 8)           |
| `doctrine-drift.sh`    | Each rule in the claims table has exactly one home — not restated, dropped, or revived   |
| `negative-space.sh`    | `INVARIANTS.md` and the code agree, by name, on both surfaces                            |
| `skill-conformance.sh` | Every skill matches the Agent Skills spec and the six keys this project authors          |
| `routing-skills.sh`    | Every skill named in routing frontmatter exists, and gated names co-vary with their flag |
| `template-orphans.sh`  | Artefacts left in a directory the current template no longer defines                     |
| `mobile-tokens.sh`     | **Mobile-only.** StyleSheet values resolve to generated tokens                           |

```bash
./code/src/scripts/audits/cloc.sh
./code/src/scripts/audits/cloc.sh --output md
./code/src/scripts/audits/stubs.sh --strict
./code/src/scripts/audits/css-tokens.sh
./code/src/scripts/audits/security.sh
./code/src/scripts/audits/static-analysis.sh
```

Rows flagged **mobile-only** are absent unless the project opted into that surface; the desktop
surface adds `code/src/scripts/desktop/style-check.sh`, which lives beside the app it checks
because the slop family splits by **input language** and a Slint build file is neither CSS,
markup, nor prose.

### Pre-commit hooks

Hooks are configured in `lefthook.yml` and run automatically on every `git commit`. They execute
in parallel:

| Hook           | Tool              | Files checked                                          |
| -------------- | ----------------- | ------------------------------------------------------ |
| `eslint`       | ESLint            | `.js`, `.jsx`, `.ts`, `.tsx`, `.mjs`, `.cjs`           |
| `prettier`     | Prettier          | `.js`, `.ts`, `.json`, `.yaml`, `.css`, `.html`, `.md` |
| `ruff-lint`    | ruff              | `.py`                                                  |
| `ruff-format`  | ruff format       | `.py`                                                  |
| `basedpyright` | basedpyright      | `.py`                                                  |
| `markdownlint` | markdownlint-cli2 | `.md`                                                  |

A commit is rejected if any lint hook fails. Fix the reported issues and recommit — do not use
`--no-verify`.

A separate non-blocking pre-commit step — `clickup-export` (`precommit-clickup.sh`) — regenerates
and re-stages the read-only `export/clickup/` ClickUp story exports whenever a source story or a
generated file is staged, keeping them in sync with `02-STORIES/`.

---

## TDD and BDD

> The test suite is pytest — services, Django Ninja endpoints, templates, django-components, and
> HTMX partials all run in one two-phase pytest run, plus Bruno for the HTTP layer and a small
> playwright-python browser suite for what needs a real browser — via the scripts in
> `code/src/scripts/tests/` (see `code/docs/TESTING.md`).

### Principles

This project follows test-driven development (TDD). Tests are written before the implementation
they cover. The cycle is:

1. **Red** — write a failing test that describes the desired behaviour
2. **Green** — write the minimal implementation that makes the test pass
3. **Refactor** — clean up the code without changing behaviour; all tests must remain green

Use `code/workflows/02-tdd-cycle/` for the full step-by-step process.

### Coverage floors

| Layer                | Minimum coverage | Auth-related code |
| -------------------- | ---------------- | ----------------- |
| **Backend (pytest)** | 75%              | 90%               |

Green means a real implementation passing. Stubs written purely to reach the coverage floor are not
acceptable.

### BDD guidelines

BDD (Behaviour-Driven Development) using Gherkin scenarios is planned for user-facing features.
Scenarios will be linked from each `US###.md` story file. Full BDD setup will be documented here
once the testing infrastructure is in place.

### Useful references

- Full testing guide → `code/docs/TESTING.md`
- TDD workflow → `code/workflows/02-tdd-cycle/`

---

## Backend and API Guide

> The backend is implemented under `code/src/django/` (Django 6 + Django Ninja).
> See `code/src/django/CONTEXT.md` and `code/docs/API-DESIGN.md` for the live structure.

### Planned structure

```text
code/src/django/
├── apps/
│   ├── core/
│   │   └── api.py           ← root NinjaAPI + router registration (mounted at /api/)
│   ├── users/
│   │   └── api.py           ← per-app router module
│   └── content/
├── config/
│   ├── settings/
│   │   ├── base.py
│   │   ├── dev.py
│   │   ├── staging.py
│   │   └── production.py
│   └── urls.py
└── manage.py
```

### API design principles

- **Contract-first:** design the Ninja Schema (Pydantic) request/response models before writing endpoints
- **Business logic in services:** endpoints coordinate, services compute
- **Explicit permissions:** every state-changing endpoint has an explicit permission check (OWASP A01)
- **No IDOR:** user-supplied IDs are always verified against the caller's ownership

### Useful references

- API design guide → `code/docs/API-DESIGN.md`
- API design workflow → `code/workflows/04-api-design/`
- Architecture patterns → `code/docs/ARCHITECTURE-PATTERNS.md`
- Security guide → `code/docs/SECURITY.md`

---

## Frontend Guide

> Every surface — public, portal, and admin — is Django templates + django-components + HTMX +
> Alpine. There is no client-side framework, no bundler, and no build step: Django renders the
> HTML and the browser receives it. See `code/src/django/CONTEXT.md` and `code/docs/RENDERING.md`.

### Planned structure

```text
code/src/django/
├── templates/               ← Django templates (pages, layouts, and _partial.html swap targets)
├── components/              ← django-components (server-rendered UI components)
├── static/                  ← CSS, versioned HTMX/Alpine vendor scripts, any per-page JS
└── apps/marketing/          ← public marketing pages (views + URLs)
```

### Key rules

- **Three tiers, and only three:** a full template for navigation and content, HTMX for server
  operations, Alpine for rapid local interactions. Anything that appears to need a fourth is an
  ADR-level stack change — see `code/docs/RENDERING.md`
- A page never calls the JSON API; the Ninja endpoints serve machine clients only
- Every non-instant HTMX request shows feedback (`hx-indicator` / `hx-disabled-elt`);
  `hx-boost` is banned
- Pages must work with JavaScript disabled — every link is a real `<a href>`
- **WCAG 2.2 AA** compliance is required on all interactive components — see
  `code/docs/ACCESSIBILITY.md`
- SEO metadata is required on every public page — see `project-management/docs/SEO-CHECKLIST.md`
- Design values are DB-canonical tokens: component CSS only ever consumes `var(--token)`

### Useful references

- Accessibility guide → `code/docs/ACCESSIBILITY.md`
- Performance guide → `code/docs/PERFORMANCE.md`
- Architecture patterns → `code/docs/ARCHITECTURE-PATTERNS.md`

---

## Influences and Attribution

This project was generated from **syntek-base**, and inherits its conventions — the layered
context system, the design and anti-slop doctrine, the audit scripts, the agent and workflow
routing. Those conventions are not original to the template. They are named here so anyone
working in this repository can check the primary sources and form their own view, rather than
following a rule because a `CLAUDE.md` said so.

### Practitioners

| Who                                                                                                                                                                                                                                                                                                                                                                                                                     | What it shaped                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Matt Pocock** — [AI Hero](https://www.aihero.dev/) · [mattpocock.com](https://www.mattpocock.com/) · [skills](https://github.com/mattpocock/skills) · [dictionary-of-ai-coding](https://github.com/mattpocock/dictionary-of-ai-coding)                                                                                                                                                                                | The engineering process for working _with_ coding agents: context gathering, planning before code, steering, feedback loops, spec-driven workflows, human-in-the-loop review. Two of his repositories are adapted directly — see below                                                                                                                                                                                                                                                                                                                                                                                                                |
| **Jake Van Clief** — [_Interpretable Context Methodology_](https://arxiv.org/abs/2603.16021) with David McDermott (arXiv:2603.16021v2, CC BY 4.0) · [ICM protocol](https://github.com/RinDig/Interpretable-Context-Methodology) · [icm-architect](https://github.com/RinDig/icm-architect) (both MIT) · [Clief Notes](https://www.skool.com/cliefnotes/about) · [LinkedIn](https://www.linkedin.com/in/jake-van-clief/) | File organisation and folder architecture as the substrate for AI work, reusable prompt frameworks, and building durable structure rather than chasing tool releases. The `CONTEXT.md` / `CLAUDE.md` layering you are reading owes this its shape — the paper states it as a five-layer hierarchy in which the stage contract, not the root file, is the control point. **Read as primary sources, never derived into shipped text.** Check the evidence before borrowing the claims: the paper is candid that its figures are practitioner self-report and that **no controlled comparison against monolithic prompting has been run** (Section 4.6) |

### Design and anti-slop craft

The visual-design doctrine (`code/docs/VISUAL-DESIGN.md`), the copy rules, and the audit scripts
under `code/src/scripts/audits/` derive from the open skill ecosystem below. **Rule text is
derived and re-authored, never copied** — so no upstream licence obligation attaches to this
codebase — but the thinking is theirs.

| Source                                                                                                               | Contributed                                                                       | Licence    |
| -------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ---------- |
| [Impeccable](https://github.com/pbakaus/impeccable) — Paul Bakaus                                                    | The craft floor, deterministic detectors, and the native/mobile audit taxonomy    | Apache-2.0 |
| [Taste Skill](https://github.com/Leonxlnx/taste-skill) — Leon                                                        | Named visual directions as a commitment device instead of a default               | MIT        |
| [`skills/frontend-design`](https://github.com/anthropics/skills) — Anthropic                                         | The original banned-defaults framing for machine-authored UI                      | —          |
| [emilkowalski/skills](https://github.com/emilkowalski/skills) — Emil Kowalski                                        | The numeric motion standard: frequency-first, duration ceilings, easing hierarchy | MIT        |
| [stop-slop](https://github.com/hardikpandya/stop-slop) — Hardik Pandya                                               | The structural taxonomy of AI prose tells behind the copy rules                   | MIT        |
| [hallmark](https://github.com/nutlope/hallmark) — Hassan El Mghari                                                   | Macrostructure-first generation and slop-test gating                              | MIT        |
| [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)                                             | Treating design knowledge as a searchable reference, not a prescription           | MIT        |
| [Web Interface Guidelines](https://github.com/vercel-labs/agent-skills) — Vercel Labs                                | Auditing interface rules with `file:line` output a reviewer can act on            | —          |
| [awesome-claude-design](https://github.com/VoltAgent/awesome-claude-design) — VoltAgent                              | The nine-section `DESIGN.md` brief format                                         | MIT        |
| [claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) — OneRedOak                              | The design-review subagent pattern over a driven browser                          | MIT        |
| [Playwright](https://playwright.dev/) · [chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) | Verifying the rendered result rather than trusting the source                     | Apache-2.0 |

### Adapted directly, and tooling

Where the design sources above are _derived from_, these are **adapted or run as-is** — the
dependency is direct and the credit is owed accordingly.

| Source                                                                                      | How it is used here                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Licence |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------- |
| [mattpocock/skills](https://github.com/mattpocock/skills) — Matt Pocock                     | Skill authoring patterns behind `.claude/skills/` and the standard in `how-to/docs/SKILL-AUTHORING.md`. **Two files are adapted text, not derived** — both of `.claude/skills/improve-codebase-architecture/`; MIT notice in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md). Four skills (`resolving-merge-conflicts`, `wizard`, `to-questionnaire`, `wait-what`) and grilling's frontier-round method are **derived** from his set and re-authored. The same-named skills (`grilling`, `wayfinder`, `codebase-design`, `prototype`, `research`, `teach`, `handoff`, …) are independently authored | MIT     |
| [mattpocock/dictionary-of-ai-coding](https://github.com/mattpocock/dictionary-of-ai-coding) | `how-to/docs/AI-DICTIONARY.md` is adapted from it — sixty-nine terms re-authored in British English, credited in the file itself                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | none    |
| [tirth8205/code-review-graph](https://github.com/tirth8205/code-review-graph) — Tirth Patel | The MCP server in `.mcp.json` is **run as-is**; the four generated playbook cards under `.claude/skills/` are **committed upstream-authored text** — MIT notice in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md). Graph-refresh gate: `code/docs/CODE-REVIEW-GRAPH.md`                                                                                                                                                                                                                                                                                                                            | MIT     |
| [cloudinary-devs/skills](https://github.com/cloudinary-devs/skills) — Cloudinary            | **Vendored verbatim** — 15 files under `.agents/skills/`, installed via `skills-lock.json` and symlinked into `.claude/skills/`. Not derived, not adapted: copied. MIT notice in [`THIRD-PARTY-NOTICES.md`](THIRD-PARTY-NOTICES.md)                                                                                                                                                                                                                                                                                                                                                                    | MIT     |

### Platform and engineering craft

The backend, background-job, observability and security doctrine this project inherits draws on
these. As above, **rules are derived and re-authored, never copied**.

| Source                                                                                | Contributed                                                                                                                                                                                                        | Licence      |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------ |
| [wshobson/agents](https://github.com/wshobson/agents) — Seth Hobson                   | Background-job discipline (idempotency under at-least-once delivery, retry policy, DLQ) and async/sync patterns                                                                                                    | MIT          |
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) — Addy Osmani   | Spec-driven and doubt-driven development, context engineering                                                                                                                                                      | MIT          |
| [trailofbits/skills](https://github.com/trailofbits/skills) — Trail of Bits           | The security-review agenda: Rust review, constant-time analysis, insecure defaults, Semgrep rule authoring. **Read as a checklist of concerns only** — its share-alike licence is incompatible with redistribution | CC-BY-SA-4.0 |
| [agentskills/agentskills](https://github.com/agentskills/agentskills)                 | The published Agent Skills specification, which `how-to/docs/SKILL-AUTHORING.md` follows                                                                                                                           | Apache-2.0   |
| [Claude Code — Agent Skills docs](https://code.claude.com/docs/en/skills) — Anthropic | The runtime behaviour behind the fork rubric and the reference-versus-task split in `how-to/docs/skill-authoring/`. No LICENCE upstream — facts used, every rule re-authored                                       | none         |
| [alibaba/open-code-review](https://github.com/alibaba/open-code-review)               | Code-review architecture at scale, alongside the code-review-graph                                                                                                                                                 | Apache-2.0   |

Everything above is free to read. **Reuse is narrower than that**, in two directions: an
unlicensed row grants nothing at all, and a share-alike row cannot travel into anything this
project redistributes — which is why both are taken as facts and never as wording. If a rule in
this repository looks wrong to you, the original is one click away — read it and decide for
yourself.

---

_Maintained by <%ORG_NAME%> · British English (en_GB) · <%TIMEZONE%>_
