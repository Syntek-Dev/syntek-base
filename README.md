# {{PROJECT_NAME}}

> Full-stack monorepo for the {{PROJECT_NAME}} website — Django + Django Ninja JSON API backend,
> server-rendered Django templates + django-components + HTMX + Alpine throughout, vanilla token
> CSS, deployed via Docker Compose.

![Version](https://img.shields.io/badge/version-0.11.0-blue)
![Licence](https://img.shields.io/badge/licence-{{LICENCE}}-red)
![Status](https://img.shields.io/badge/status-in%20development-brightgreen)

---

## Table of Contents

1. [Purpose](#purpose)
2. [Instantiating from this template](#instantiating-from-this-template)
3. [Project Tree](#project-tree)
4. [Prerequisites](#prerequisites)
5. [Getting Started](#getting-started)
6. [Multi-Layer Context System](#multi-layer-context-system)
7. [Project Management](#project-management)
8. [Coding Principles](#coding-principles)
9. [Writing Code — Workflows](#writing-code--workflows)
10. [Claude Code Tooling](#claude-code-tooling)
11. [Docker](#docker)
12. [Project Scripts](#project-scripts)
13. [TDD and BDD](#tdd-and-bdd)
14. [Backend and API Guide](#backend-and-api-guide)
15. [Frontend Guide](#frontend-guide)
16. [Welcome](#welcome)

---

## Purpose

**{{PROJECT_NAME}}** is the source repository for the {{PROJECT_NAME}} public website. It is a
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
| **Background tasks**       | Celery (worker + beat)                                                |
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

All source code and documentation in this repository is proprietary and confidential. All rights
reserved — {{ORG_NAME}}. Explicit written permission is required before using, copying, or
distributing any part of this codebase. Third-party dependencies must carry licences compatible
with commercial proprietary use (MIT, Apache 2.0, ISC). GPL/AGPL requires written approval before
use. See `{{LICENCE}}` for the full licence terms.

---

## Instantiating from this template

This repository is a **reusable base template**. Project-, organisation-, and deployment-specific
values are written as `{{…}}` placeholders. To turn a fresh clone into a real project, run the
setup script from the repository root:

```bash
bash setup.sh
```

`setup.sh` prompts for each token (project and org names and slugs, primary domain, locale,
licence, developer identity), substitutes every `{{…}}` across the documentation and
configuration, stamps the baseline date, and verifies that none remain. The full token contract —
what each token means, its format, and what deliberately stays fixed — is in
`how-to/src/TEMPLATE-TOKENS.md`. After setup, run `/scale-planning` to regenerate the two
architecture snapshots against the new project's live code.

---

## Project Tree

```text
{{PROJECT_SLUG}}/
├── .claude/                             ← Claude Code configuration
│   ├── CLAUDE.md                        ← authoritative operating manual: read-order, agents, skills, plugins, rules
│   ├── MEMORY.md                        ← project memory store (always read second, after CLAUDE.md)
│   ├── settings.json                    ← Claude Code settings (permissions, model, disabled marketplace plugins)
│   ├── settings.local.json              ← local overrides (gitignored)
│   ├── agents/                          ← agent definitions (orchestrators, specialists, doc-writers)
│   ├── skills/                          ← internalised skills (stack, workflow, document standards)
│   ├── hooks/                           ← pre-PR quality gates (fired via PreToolUse hook on gh pr create)
│   │   ├── lib/                         ← gate scripts: format, lint, typecheck, tests, security, stubs, cloc, lockfiles
│   │   ├── pre-pr-check.sh              ← runs all 8 gates; blocks PR creation on failure
│   │   └── post-pr-comment.sh           ← posts gate results as a GitHub PR comment
│   └── plugins/                         ← agent helper scripts (project/env/db/git/log/pm inspection)
│       ├── db-tool.py
│       ├── env-tool.py
│       ├── git-tool.py
│       ├── log-tool.py
│       ├── pm-tool.py
│       └── project-tool.py
├── .github/
│   └── workflows/                       ← CI: syntax, test, and audit checks
│       ├── audit-cloc.yml               ← fails if any source file exceeds 800 lines
│       ├── audit-secrets.yml            ← scans for accidentally committed secrets
│       ├── audit-stubs.yml              ← detects hard stubs and TODO/FIXME/HACK markers
│       ├── claude.yml                   ← Claude Code GitHub Actions integration
│       ├── clickup-sync.yml             ← pushes ClickUp story exports to ClickUp (push/PR)
│       ├── syntax-js-ts.yml
│       ├── syntax-markdown.yml
│       ├── syntax-python.yml
│       ├── test-api.yml
│       ├── test-backend.yml
│       └── test-e2e.yml               ← playwright-python browser suite
├── code/                                ← source code, coding standards, tests
│   ├── CONTEXT.md                       ← coding layer index
│   ├── docs/                            ← coding reference guides; each oversized guide has a matching sub-directory
│   │   ├── ACCESSIBILITY.md             (+ accessibility/ — HTML-AND-ARIA, INTERACTION, TESTING-AND-COMPONENTS)
│   │   ├── API-DESIGN.md               (+ api-design/ — NINJA-CONVENTIONS, REST-CONVENTIONS, AUTH-AND-ERRORS, …)
│   │   ├── ARCHITECTURE-PATTERNS.md    (+ architecture/ — CORE-AND-SCALING, AUTH-CONTRACT, SERVICE-AND-MIDDLEWARE, …)
│   │   ├── BACKEND-CODING-PRINCIPLES.md
│   │   ├── CODING-PRINCIPLES.md        (+ coding-principles/ — DESIGN-PRINCIPLES, PRACTICAL-RULES, STYLE-AND-PROCESS)
│   │   ├── CONTEXT.md
│   │   ├── DATA-STRUCTURES.md          (+ data-structures/ — FUNDAMENTALS, SCHEMA-DESIGN, DOMAIN-MODELLING, …)
│   │   ├── DESIGN-TOKENS.md
│   │   ├── ENCRYPTION-GUIDE.md         (+ encryption/ — FIELD-ENCRYPTION, LOOKUP-TOKENS)
│   │   ├── FRONTEND-CODING-PRINCIPLES.md
│   │   ├── LOGGING.md                  (+ logging/ — DJANGO-LOGGING, FRONTEND-LOGGING, OBSERVABILITY, CLOUDINARY)
│   │   ├── PERFORMANCE.md              (+ performance/ — FRONTEND-PERFORMANCE, DATABASE-PERFORMANCE, API-AND-MONITORING)
│   │   ├── RENDERING.md                (+ rendering/ — TEMPLATES-AND-INTERACTIVITY, PITFALLS-AND-EXAMPLES)
│   │   ├── RESPONSIVE-DESIGN.md        (+ responsive/ — BREAKPOINTS, MEDIA-QUERIES, CONTAINER-QUERIES, …)
│   │   ├── RLS-GUIDE.md               (+ rls/ — FUNDAMENTALS, POLICY-TEMPLATES, MIDDLEWARE-AND-NINJA, …)
│   │   ├── SECURITY.md                 (+ security/ — AUTH-AND-AUTHZ, OWASP-AND-CHECKLIST, CRYPTO-AND-DATA, …)
│   │   ├── TESTING.md                  (+ testing/ — BACKEND-TESTING, FRONTEND-TESTING, API-TESTING, …)
│   │   └── URL-STRATEGY.md
│   ├── src/
│   │   ├── django/                      ← Django 6 + Django Ninja (apps, config, templates, components, static)
│   │   ├── docker/                      ← Dockerfiles and Compose files
│   │   ├── logs/                        ← runtime log files (dev/test; gitignored)
│   │   ├── scripts/                     ← dev, database, test, syntax, and audit scripts
│   │   └── tests/                       ← Bruno API test collections (one collection per domain)
│   └── workflows/                       ← 10 step-by-step coding workflows
│       ├── 01-new-feature/
│       ├── 02-tdd-cycle/
│       ├── 03-security-hardening/
│       ├── 04-api-design/
│       ├── 05-gdpr-enforcement/
│       ├── 06-review/
│       ├── 07-debug/
│       ├── 08-refactor/
│       ├── 09-database-migration/
│       └── 10-debugging-with-logs/
├── how-to/                              ← setup, daily dev, and debugging guides
│   ├── CONTEXT.md
│   ├── docs/                            ← operational reference guides
│   │   ├── CLI-TOOLING.md               ← Claude Code MCP servers, hooks, and dev-script reference
│   │   ├── DEVELOPMENT.md               ← environment variables, Docker setup, and dev tooling catalogue
│   │   ├── GIT-WORKTREES.md             ← worktree-based parallel story development
│   │   ├── TOOLING-GUIDE.md             ← internal agents and skills reference (index)
│   │   └── tooling-guide/               ← detailed tooling guide sub-documents
│   │       ├── COMMANDS.md
│   │       ├── CONFIGURATION.md
│   │       └── WORKFLOW.md
│   ├── REFERENCES.md
│   ├── src/                             ← contributing, code-quality guide, architecture snapshots
│   │   ├── CONTEXT.md
│   │   ├── TEMPLATE-TOKENS.md           ← base-template manifest: the {{…}}, what to fill, what stays fixed
│   │   ├── NIXOS-SETUP.md               ← pointer stub → NixOS deploy repo + SERVER-ARCHITECTURE/
│   │   ├── SCALE-ARCHITECTURE/          ← how the app scales (scale-planner snapshot)
│   │   └── SERVER-ARCHITECTURE/         ← app→server contract (feeds the NixOS deploy repo)
│   └── workflows/                       ← 4 step-by-step operational workflows
│       ├── 01-first-time-setup/
│       ├── 02-daily-development/
│       ├── 03-debugging/
│       └── 04-worktree-setup/
├── project-management/                  ← stories, sprints, plans, GDPR, security
│   ├── CONTEXT.md
│   ├── docs/                            ← PM reference guides
│   │   ├── gdpr/                        ← GDPR sub-documents
│   │   │   ├── COMPLIANCE.md
│   │   │   └── DATA-RIGHTS.md
│   │   ├── GDPR-GUIDE.md                ← GDPR obligations, data flows, and legal bases (index)
│   │   ├── GIT-GUIDE.md                 ← branch strategy, PR flow, and commit conventions
│   │   ├── QA-GUIDE.md                  ← QA process, test plans, and sign-off criteria
│   │   ├── RESPONSIVE-DESIGN.md         ← breakpoints, fluid layout, and mobile-first rules
│   │   ├── SECURITY-GUIDE.md            ← security sprint dependencies and hardening checklist
│   │   ├── SEO-CHECKLIST.md             ← per-page SEO requirements for marketing pages
│   │   ├── SPRINT-PLANNING-GUIDE.md     ← sprint format, capacity, and MoSCoW conventions
│   │   └── VERSIONING-GUIDE.md          ← semver rules, VERSION file, and CHANGELOG format
│   ├── export/                          ← PDF/ZIP exports for client review + clickup/ (read-only ClickUp story exports)
│   ├── REFERENCES.md
│   ├── src/                             ← live PM artefacts (numbered to mirror workflows)
│   │   ├── 00-ASSETS/
│   │   ├── 01-STORIES/
│   │   ├── 02-SPRINTS/
│   │   ├── 03-DATABASE/
│   │   ├── 04-USER-FLOW/
│   │   ├── 05-BRAND-GUIDE/
│   │   ├── 06-COMPONENTS/
│   │   ├── 07-WIREFRAMES/
│   │   ├── 08-GDPR/
│   │   ├── 09-SECURITY/
│   │   ├── 10-QA/
│   │   ├── 11-SEO/
│   │   ├── 12-API-DESIGN/
│   │   ├── 13-DECISIONS/
│   │   ├── 14-SPRINT-PLANS/
│   │   ├── 15-STORY-PLANS/
│   │   ├── 16-TESTS/
│   │   ├── 17-REVIEWS/
│   │   ├── 18-FINDINGS/
│   │   ├── 19-BUGS/
│   │   └── 20-REFACTORING/
│   └── workflows/                       ← 21 step-by-step PM workflows
│       ├── 01-story-creation/
│       ├── 02-sprint-planning/
│       ├── 03-database-schema/
│       ├── 04-user-flow-design/
│       ├── 05-brand-guides/
│       ├── 06-component-designs/
│       ├── 07-wireframes/
│       ├── 08-gdpr-compliance/
│       ├── 09-security-checks/
│       ├── 10-qa-checks/
│       ├── 11-seo-checks/
│       ├── 12-api-design/
│       ├── 14-sprint-plans/
│       ├── 16-backend-code/
│       ├── 17-api-code/
│       ├── 18-frontend-code/
│       ├── 20-pr-and-review/
│       └── 21-release/
├── CHANGELOG.md                         ← human-readable changelog
├── CONTEXT.md                           ← project overview and layer map
├── DEFERRED.md                          ← items explicitly deferred to future stories (checked at sprint planning)
├── DESIGN.md                            ← design entry point: standards, constraints, and workflows
├── GAPS.md                              ← knowledge staging area: gaps, blockers, and architectural notes
├── README.md                            ← this file
├── REFERENCES.md                        ← curated external reference links for development
├── RELEASES.md                          ← release notes archive
├── VERSION                              ← current semver string
├── VERSION-HISTORY.md                   ← full version bump history
├── eslint.config.mjs
├── install.sh                           ← one-shot setup: installs root deps and git hooks
├── lefthook.yml                         ← pre-commit hook runner
├── package.json                         ← root pnpm workspace
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
├── pyproject.toml                       ← Python tooling (ruff, basedpyright, uv)
├── setup.sh                             ← base-template instantiation: fills {{…}} from TEMPLATE-TOKENS.md
└── uv.lock                              ← not shipped: generated by setup.sh, commit it after instantiation
```

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

**macOS / Linux:** install Docker Desktop or Docker Engine. On Linux, add your user to the
`docker` group so you can run `docker compose` without `sudo`.

**Windows:** Docker Desktop with WSL 2 backend. All shell commands in this README assume a bash or
zsh shell (Git Bash or WSL 2 terminal).

---

## Getting Started

### Clone the repository

```bash
git clone git@github.com:{{ORG_SLUG}}/{{PROJECT_SLUG}}.git
cd {{PROJECT_SLUG}}
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

- **django** — Django ASGI (Gunicorn + Uvicorn) with hot-reload, serving templates, HTMX, and the `/api/` JSON API (port 8000)
- **worker / beat** — Celery worker and beat scheduler
- **db** — PostgreSQL 18 (port 5432)
- **cache** — Valkey (port 6379)
- **mailpit** — local mail catcher UI (port 8025)
- **nginx** — reverse proxy routing all traffic (port 80)

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
| `http://dev.{{PROJECT_SLUG}}.localhost`          | Public site (Django templates + HTMX) |
| `http://dev.{{PROJECT_SLUG}}.localhost/api/docs` | OpenAPI docs (Django Ninja; dev)      |
| `http://dev.{{PROJECT_SLUG}}.localhost/control/` | Django admin (non-obvious path)       |
| `http://dev.{{PROJECT_SLUG}}.localhost:8027`     | Mailpit — local mail catcher          |

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
| **Design**             | `DESIGN.md`           | Design standards, constraints, Figma and UI workflows   |
| **Claude config**      | `.claude/`            | Operating manual, agents, skills, and helper scripts    |

### Routing — read only the layer you need

| Task type                                                 | Read first                      |
| --------------------------------------------------------- | ------------------------------- |
| Writing, reviewing, or testing code                       | `code/CONTEXT.md`               |
| Stories, sprints, PRs, releases, GDPR, SEO                | `project-management/CONTEXT.md` |
| Setup, daily dev, CLI usage, debugging                    | `how-to/CONTEXT.md`             |
| Figma, component design, wireframes, brand, responsive UI | `DESIGN.md`                     |

Always-applicable guides: `project-management/docs/GIT-GUIDE.md` ·
`project-management/docs/VERSIONING-GUIDE.md`

### How Claude Code uses this structure

When you open a session, Claude Code reads `.claude/CLAUDE.md` then `.claude/MEMORY.md` first —
always, before any work. `CLAUDE.md` is the operating manual: the read-order, the two-tier agent
model (orchestrators delegate to specialists and document-writers), when to load each skill, the
`.claude/plugins/` helper scripts, and the routing frontmatter that every `docs/`/`workflows/`
file carries. It deliberately holds no layer-specific detail — that lives in each layer's own
`CONTEXT.md`, which Claude reads only when the task is within that layer's domain.

Each `CONTEXT.md` links to the `docs/` guides and `workflows/` step-by-step processes relevant to
that layer. This keeps the active context window small and ensures Claude always reads the right
reference material rather than everything at once.

### Quick-start by role

| You are…                                   | Start here                      |
| ------------------------------------------ | ------------------------------- |
| First time in this repository              | `how-to/CONTEXT.md`             |
| Writing or reviewing code                  | `code/CONTEXT.md`               |
| Planning, writing stories, or PM work      | `project-management/CONTEXT.md` |
| Doing design work (Figma, wireframes, UI)  | `DESIGN.md`                     |
| Configuring Claude Code, agents, or skills | `.claude/CLAUDE.md`             |

---

## Project Management

All project management artefacts live in `project-management/`. The folder is structured to make
the right document easy to find, and every file type follows a strict naming convention so nothing
gets lost.

### User stories

Stories live in `project-management/src/01-STORIES/` and follow the naming convention `US###.md`
(three-digit zero-padded: `US001.md`, `US042.md`).

Each story should define acceptance criteria, the affected layer (backend / frontend / both), and
any GDPR or accessibility considerations. Use the PM workflow
`project-management/workflows/01-story-creation/` to write stories consistently.

### ClickUp story sync — client-facing exports

Until the site is deployed, scrum boards are tracked in **ClickUp**. Each story's `**Status:**`
header uses the ClickUp status vocabulary: `Open`, `Pending`, `In Progress`, `In Review`,
`Accepted`, `Accepted Customer`, `Rejected`, `Rejected Customer`, `Blocked`, `Completed`, `Closed`.

Only client-facing fields go to ClickUp. A generator produces **one read-only Markdown file per
story** in `project-management/export/clickup/US###-CLIENT.md`, containing just the title, a
Status · MoSCoW · Story Points table, the Client Summary, and the User Story. Acceptance criteria,
tasks, and all technical detail stay internal.

**Flow:** edit the status (or other client-facing field) in the source story under `01-STORIES/`,
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

**Push to ClickUp:** the `clickup-sync` GitHub workflow (`.github/workflows/clickup-sync.yml`)
runs `sync-clickup.sh` on push/PR to `main`, `staging`, `dev`, and `testing`, upserting one
ClickUp task per story. A durable `story → task id` map
(`project-management/export/clickup-task-map.json`) keeps it idempotent. It runs as a **dry run**
until the `CLICKUP_API_TOKEN` and `CLICKUP_BACKLOG_LIST_ID` repo secrets are set.

### Sprint planning

Sprint work follows a two-stage process:

**Stage 1 — Early sprint record** (`project-management/src/02-SPRINTS/`, `SPRINT-##.md`):
A high-level record capturing the sprint goal and candidate stories. Written at the start of a
cycle using `project-management/workflows/02-sprint-planning/`.

**Stage 2 — Detailed sprint plan** (`project-management/src/14-SPRINT-PLANS/`, `SPRINT-PLAN-##.md`):
Written _after_ GDPR, security, and QA checks are complete. Records the definitive story
assignments, per-phase breakdown (backend → API → frontend → PR), developer constraints from the
checks, and the sprint definition of done. Use `project-management/workflows/14-sprint-plans/`.

Both use **MoSCoW** prioritisation (Must / Should / Could / Won't). See
`project-management/docs/SPRINT-PLANNING-GUIDE.md` for the full format and conventions.

### Database ERDs with mcp-mermaid

Database schemas and entity-relationship diagrams are documented in
`project-management/src/03-DATABASE/` using Mermaid diagrams.

The `mcp-mermaid` MCP server renders Mermaid diagrams inside Claude Code sessions. Install it once
on your machine:

```bash
npx -y @anthropic-ai/mcp-install mcp-mermaid
```

Full installation guide: [github.com/hustcc/mcp-mermaid](https://github.com/hustcc/mcp-mermaid)

Once installed, use the `mcp__mcp-mermaid__generate_mermaid_diagram` tool inside Claude Code to
render diagrams from Mermaid syntax. Schema design is formalised before any migration is written —
use `project-management/workflows/03-database-schema/` to go through the sign-off process.

Example ERD syntax committed to `03-DATABASE/`:

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

### Wireframes with Figma

UI wireframes are designed in Figma and linked (not embedded) from
`project-management/src/07-WIREFRAMES/`. Each wireframe entry records the Figma URL, the story it
belongs to, and the sign-off status. No frontend work begins on a feature until the wireframe is
signed off — use `project-management/workflows/07-wireframes/`.

### User flow diagrams

User flows are documented as Mermaid flowcharts in `project-management/src/04-USER-FLOW/`. They capture the end-to-end journey through a feature before implementation
begins.

### QA and testing documentation

| Document type                   | Naming convention                | Location                                       |
| ------------------------------- | -------------------------------- | ---------------------------------------------- |
| QA gap analysis report          | `QA-REPORT-<AREA>.md`            | `project-management/src/10-QA/PLANNING/`       |
| QA plan (pre-development)       | `QA-US###-<DESCRIPTION>.md`      | `project-management/src/10-QA/PLANNING/`       |
| QA review (post-implementation) | `QA-IMPL-US###-<DESCRIPTION>.md` | `project-management/src/10-QA/IMPLEMENTATION/` |
| Sprint plan                     | `SPRINT-PLAN-##.md`              | `project-management/src/14-SPRINT-PLANS/`      |
| Test status tracker             | `US###-TEST-STATUS.md`           | `project-management/src/16-TESTS/`             |
| Manual testing guide            | `US###-MANUAL-TESTING.md`        | `project-management/src/16-TESTS/`             |
| Bug report                      | `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` | `project-management/src/19-BUGS/`              |

Automated tests are written first (TDD) and their status is tracked in `TEST-STATUS.md`. Manual
tests are documented in `MANUAL-TESTING.md` and run before any PR is promoted to `staging`.

### PM workflows — when to use each

| Workflow                | Trigger                                                      |
| ----------------------- | ------------------------------------------------------------ |
| `01-story-creation/`    | Writing a new user story                                     |
| `02-sprint-planning/`   | Creating the initial high-level sprint record                |
| `03-database-schema/`   | Designing a new model or schema change                       |
| `04-user-flow-design/`  | Mapping user journeys before wireframing                     |
| `05-brand-guides/`      | Establishing or updating the visual brand identity           |
| `06-component-designs/` | Designing reusable UI components before frontend work        |
| `07-wireframes/`        | Creating or updating wireframes before frontend work         |
| `08-gdpr-compliance/`   | Reviewing a feature for GDPR compliance                      |
| `09-security-checks/`   | Threat modelling and security review of designs              |
| `10-qa-checks/`         | QA planning from wireframes before any code is written       |
| `11-seo-checks/`        | SEO review and metadata checks before frontend work          |
| `12-api-design/`        | Designing the Django Ninja API surface                       |
| `14-sprint-plans/`      | Writing the detailed sprint plan after all pre-sprint checks |
| `16-backend-code/`      | Implementing Django models, services, and business logic     |
| `17-api-code/`          | Implementing the Django Ninja API layer                      |
| `18-frontend-code/`     | Implementing Django templates, components, and HTMX partials |
| `20-pr-and-review/`     | Raising a PR and moving it through the promotion chain       |
| `21-release/`           | Cutting a release (version bump, changelog, deploy)          |

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

### Doc strings — one line maximum

A public function's doc string is one short line describing its purpose. No multi-paragraph blocks.
No restating the parameter list in prose. If the function is complex enough to need a paragraph,
split it into smaller functions first.

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

All coding work follows one or more of the ten workflows in `code/workflows/`. Each workflow
folder contains three files:

- `CONTEXT.md` — when to use it and prerequisites
- `STEPS.md` — the ordered steps to execute
- `CHECKLIST.md` — verification checklist before marking the work complete

**Rule:** read `CONTEXT.md` first for decision-making context. Only enter `STEPS.md` when the
workflow is explicitly triggered.

### The ten coding workflows

| #   | Workflow                  | Purpose                                                                  |
| --- | ------------------------- | ------------------------------------------------------------------------ |
| 01  | `01-new-feature/`         | Add a full-stack feature (backend + frontend) from story to commit       |
| 02  | `02-tdd-cycle/`           | Test-driven development — Red → Green → Refactor                         |
| 03  | `03-security-hardening/`  | OWASP A01–A10 security review and hardening                              |
| 04  | `04-api-design/`          | Design and implement a new Django Ninja API surface                      |
| 05  | `05-gdpr-enforcement/`    | Implement GDPR requirements in code (encryption, consent, deletion)      |
| 06  | `06-review/`              | Code quality review before raising a PR (security, principles, coverage) |
| 07  | `07-debug/`               | Isolate a code logic bug, write a regression test, apply the minimal fix |
| 08  | `08-refactor/`            | Systematic refactoring without behaviour change                          |
| 09  | `09-database-migration/`  | Create and run a new Django database migration                           |
| 10  | `10-debugging-with-logs/` | Debug using local logs, Glitchtip, Loki, and Grafana                     |

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
`code/workflows/01-new-feature/STEPS.md` Step 10 for the full table.

Open issues that cannot be resolved in the current PR go to `/GAPS.md`. Items explicitly
deferred to a named future story go to `/DEFERRED.md`. Both files must be current before any
PR is opened.

### Typical feature development sequence

```text
01-new-feature  →  02-tdd-cycle  →  04-api-design  →  05-gdpr-enforcement  →  06-review  →  PM: 20-pr-and-review
```

- Start with `01-new-feature` to plan the feature scope.
- Work in `02-tdd-cycle` — write failing tests first, then implement.
- If the feature exposes a new Django Ninja API, follow `04-api-design` in parallel.
- If the feature touches PII, run `05-gdpr-enforcement` before raising a PR.
- Before opening the PR, run `06-review` to verify OWASP coverage, coding principles, and
  coverage floors.
- Hand off to the PM layer with `project-management/workflows/20-pr-and-review/`.

### Bug fix sequence

```text
how-to/03-debugging  →  07-debug  →  06-review  →  PM: 20-pr-and-review
```

Start with the operational debugging workflow to confirm the environment is healthy, then use
`07-debug` to isolate and fix the logic. Never refactor and fix a bug in the same commit — if the
fix reveals a design problem, open a separate refactoring task using `08-refactor`.

---

## Claude Code Tooling

### Agents

The project carries **internal agent definitions** in `.claude/agents/` (registry:
`.claude/agents/CONTEXT.md`), internalised from the now-disabled `{{ORG_SLUG}}-dev-suite` /
`{{ORG_SLUG}}-doc-writer` plugins. They run in two tiers: **8 orchestrators** (the entry points below)
delegate to **specialists + document-writers**. Each orchestrator runs a multi-phase
workflow, spawning specialist sub-agents and enforcing separation (no agent reviews its own
work), with an explicit **Documentation phase** as a hard gate before its commit phase.

| Agent         | Model    | Trigger                                           |
| ------------- | -------- | ------------------------------------------------- |
| `feature.md`  | opus     | New full-stack feature, end-to-end capability     |
| `bugfix.md`   | opus     | Bug, regression, or broken behaviour              |
| `review.md`   | opus     | Code quality pass, QA before PR                   |
| `security.md` | **opus** | OWASP audit, hardening, auth or permissions scope |
| `refactor.md` | opus     | Restructure without behaviour change              |
| `story.md`    | fable    | User story creation, sprint planning              |
| `pr.md`       | opus     | Raise PR, merge feature branch → `testing`        |
| `release.md`  | opus     | Version bump, changelog, deploy to production     |

Agents are invoked by Claude Code automatically when a task matches the agent's description.
Orchestrator agents run `opus` by default; the `story` orchestrator and the planning
specialists (`sprint`, `planner`, `user-story`) run `fable`. `sonnet` and `haiku` are never used.

### Agent helper scripts

Scripts in `.claude/plugins/` are Python helpers agents call (`python3 .claude/plugins/x.py`) to
inspect the local environment for context. They do **not** run dev operations — those go through
`code/src/scripts/**/*.sh`.

| Helper            | Purpose                                                                 |
| ----------------- | ----------------------------------------------------------------------- |
| `project-tool.py` | Project structure detection and technology stack identification         |
| `env-tool.py`     | Read, compare, and validate environment files across environments       |
| `db-tool.py`      | Database detection and connection info for backend and setup agents     |
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
| `figma`             | Machine-global     | Only if installed locally              |

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
containers are namespaced as `{{PROJECT_SLUG}}-dev-us###-*` and served at
`http://dev-us###.{{PROJECT_SLUG}}.localhost:3080`. Full guide: `how-to/docs/GIT-WORKTREES.md`.

### Services per environment

| Service     | dev | test | staging | prod | Notes                                  |
| ----------- | --- | ---- | ------- | ---- | -------------------------------------- |
| `django`    | ✅  | ✅   | ✅      | ✅   | Django ASGI — Gunicorn + Uvicorn       |
| `worker`    | ✅  | ✅   | ✅      | ✅   | Celery worker                          |
| `beat`      | ✅  | ✅   | ✅      | ✅   | Celery beat scheduler                  |
| `db`        | ✅  | ✅   | ❌      | ❌   | PostgreSQL 18 — server-managed in prod |
| `cache`     | ✅  | ✅   | ❌      | ❌   | Valkey — server-managed in prod        |
| `seaweedfs` | ✅  | ✅   | ❌      | ❌   | SeaweedFS S3 (private documents)       |
| `mailpit`   | ✅  | ✅   | ❌      | ❌   | Local mail catcher (port 8025)         |
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
bash code/src/scripts/development/shell.sh --service worker

# Run backend tests
bash code/src/scripts/tests/backend.sh
```

For the full script catalogue see [§ Project Scripts](#project-scripts).

### Staging and production images

Staging and prod images are pushed to GHCR by GitHub Actions and pulled on the server:

```text
ghcr.io/{{ORG_SLUG}}/{{PROJECT_SLUG}}/django:<tag>
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

| Script                  | Purpose                                                             |
| ----------------------- | ------------------------------------------------------------------- |
| `server.sh`             | Manage the dev stack: `up`, `down`, `restart`, `build`, `status`    |
| `logs.sh`               | View and tail container logs; filter by service, time, or count     |
| `shell.sh`              | Open an interactive shell in any dev container                      |
| `new-django-app.sh`     | Scaffold a new Django app with per-model-file structure             |
| `new-django-view.sh`    | Scaffold a new public marketing page (Django view + template + URL) |
| `install-backend.sh`    | Update `uv.lock` and optionally sync Python backend dependencies    |
| `install-frontend.sh`   | Update `pnpm-lock.yaml` and optionally sync frontend dependencies   |
| `install.sh`            | Compatibility shim — forwards to `install-frontend.sh`              |
| `pnpm-update.sh`        | Self-update pnpm and pin the new version across project files       |
| `hosts-story-add.sh`    | Add `/etc/hosts` entries for a story worktree (worktree dev setup)  |
| `hosts-story-remove.sh` | Remove `/etc/hosts` entries for a story worktree                    |

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
| `shell.sh`              | Open Django `dbshell` or a direct `psql` session                       |
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
./code/src/scripts/database/shell.sh
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

### Audit scripts (`code/src/scripts/audits/`)

| Script          | Purpose                                                                                 |
| --------------- | --------------------------------------------------------------------------------------- |
| `cloc.sh`       | Count lines per file (warns at 750, fails at 800) and produce language breakdown        |
| `stubs.sh`      | Detect hard stubs (`NotImplementedError`, `// STUB`) and soft markers (TODO/FIXME/HACK) |
| `css-tokens.sh` | Verify component CSS only consumes resolvable `var(--token)` design tokens              |
| `security.sh`   | Static security audit (secrets, dependency, and config checks)                          |

```bash
./code/src/scripts/audits/cloc.sh
./code/src/scripts/audits/cloc.sh --output md
./code/src/scripts/audits/stubs.sh
./code/src/scripts/audits/stubs.sh --strict
./code/src/scripts/audits/css-tokens.sh
./code/src/scripts/audits/security.sh
```

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
generated file is staged, keeping them in sync with `01-STORIES/`.

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

## Welcome

Welcome to the {{PROJECT_NAME}} repository. Whether you are a developer, designer, or Claude Code
agent reading this for the first time — you are in the right place.

The three-layer structure (`code/`, `how-to/`, `project-management/`) is designed to make it easy
to find exactly what you need without reading everything at once. When in doubt, start with the
`CONTEXT.md` for your layer and let it guide you to the right reference or workflow.

If you encounter a workflow folder that is missing `STEPS.md` or `CHECKLIST.md`, record it in
`GAPS.md` at the project root and proceed using `CONTEXT.md` alone. Do not silently generate
missing files.

For questions, issues, or contributions, reach out to the {{ORG_NAME}} development team.

---

_Maintained by {{ORG_NAME}} · v0.11.0 · British English (en_GB) · {{TIMEZONE}}_
