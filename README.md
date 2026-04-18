# syntek-website

> Full-stack monorepo for the Syntek Studio website — Django + Strawberry GraphQL backend,
> Next.js + Tailwind CSS frontend, deployed via Docker Compose.

![Version](https://img.shields.io/badge/version-0.1.0-blue)
![Licence](https://img.shields.io/badge/licence-Proprietary-red)
![Status](https://img.shields.io/badge/status-scaffolded%20%E2%80%94%20pre--implementation-yellow)

---

## Table of Contents

1. [Purpose](#purpose)
2. [Project Tree](#project-tree)
3. [Prerequisites](#prerequisites)
4. [Getting Started](#getting-started)
5. [Multi-Layer Context System](#multi-layer-context-system)
6. [Project Management](#project-management)
7. [Coding Principles](#coding-principles)
8. [Writing Code — Workflows](#writing-code--workflows)
9. [Claude Code Tooling](#claude-code-tooling)
10. [Docker](#docker)
11. [Project Scripts](#project-scripts)
12. [TDD and BDD](#tdd-and-bdd)
13. [Backend and API Guide](#backend-and-api-guide)
14. [Frontend Guide](#frontend-guide)
15. [Welcome](#welcome)

---

## Purpose

**syntek-website** is the source repository for the Syntek Studio public website. It is a
full-stack monorepo — one repository containing the Django backend, the Next.js frontend, all
supporting infrastructure, and every documentation and project-management artefact needed to
develop, test, and deploy the product.

### Stack

| Layer                      | Technology                    |
| -------------------------- | ----------------------------- |
| **Backend language**       | Python 3.14                   |
| **Backend framework**      | Django 6.0.4                  |
| **API**                    | Strawberry GraphQL 0.314.3    |
| **Database**               | PostgreSQL 18                 |
| **Cache / Queue**          | Valkey (latest stable)        |
| **Backend server**         | Gunicorn + Uvicorn / Nginx    |
| **Frontend framework**     | Next.js 16.2.4 (App Router)   |
| **Frontend language**      | TypeScript 6.0.3              |
| **UI library**             | React 19.2                    |
| **Styling**                | Tailwind CSS 4.2              |
| **GraphQL client**         | Apollo Client                 |
| **Code generation**        | GraphQL Code Generator        |
| **Node runtime**           | Node.js 24.15.0               |
| **JS package manager**     | pnpm 10.33.0                  |
| **Python package manager** | uv 0.11.7                     |
| **Backend tests**          | pytest, pytest-django         |
| **Frontend tests**         | Vitest, React Testing Library |
| **Container**              | Docker Compose                |

### Proprietary notice

All source code and documentation in this repository is proprietary and confidential. All rights
reserved — Syntek Studio. Explicit written permission is required before using, copying, or
distributing any part of this codebase. Third-party dependencies must carry licences compatible
with commercial proprietary use (MIT, Apache 2.0, ISC). GPL/AGPL requires written approval before
use.

---

## Project Tree

```text
syntek-website/
├── .claude/                             ← Claude Code configuration
│   ├── CLAUDE.md                        ← global rules, routing, model selection
│   ├── settings.local.json              ← local Claude Code permission settings
│   ├── commands/                        ← slash commands (/dev, /test, /migrate, …)
│   │   ├── codegen.md
│   │   ├── dev.md
│   │   ├── migrate.md
│   │   ├── production.md
│   │   ├── schema.md
│   │   ├── staging.md
│   │   └── test.md
│   └── plugins/                         ← MCP tool plugins for Claude agents
│       ├── chrome-tool.py
│       ├── db-tool.py
│       ├── ddev-tool.py
│       ├── docker-tool.py
│       ├── env-tool.py
│       ├── git-tool.py
│       ├── log-tool.py
│       ├── pm-tool.py
│       ├── project-tool.py
│       └── quality-tool.py
├── .github/
│   └── workflows/                       ← CI: syntax checks (JS/TS, Python, Markdown)
│       ├── syntax-js-ts.yml
│       ├── syntax-markdown.yml
│       └── syntax-python.yml
├── code/                                ← source code, coding standards, tests
│   ├── CONTEXT.md                       ← coding layer index
│   ├── docs/                            ← 12 coding reference guides
│   │   ├── ACCESSIBILITY.md
│   │   ├── API-DESIGN.md
│   │   ├── ARCHITECTURE-PATTERNS.md
│   │   ├── CODING-PRINCIPLES.md
│   │   ├── DATA-STRUCTURES.md
│   │   ├── ENCRYPTION-GUIDE.md
│   │   ├── LOGGING.md
│   │   ├── PERFORMANCE.md
│   │   ├── RLS-GUIDE.md
│   │   ├── SECURITY.md
│   │   └── TESTING.md
│   ├── src/
│   │   ├── backend/                     ← Django 6.0.4 + Strawberry GraphQL
│   │   ├── docker/                      ← Dockerfiles and Compose files
│   │   ├── frontend/                    ← Next.js 16.2.4 App Router
│   │   ├── logs/                        ← runtime log files (dev/test; gitignored)
│   │   └── scripts/                     ← quality scripts (lint.sh, check.sh, format.sh)
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
│   ├── docs/                            ← DEVELOPMENT.md, CLI-TOOLING.md, SYNTEK-GUIDE.md
│   ├── src/                             ← contributing and code-quality guide
│   └── workflows/                       ← 3 step-by-step operational workflows
│       ├── 01-first-time-setup/
│       ├── 02-daily-development/
│       └── 03-debugging/
├── project-management/                  ← stories, sprints, plans, GDPR, security
│   ├── CONTEXT.md
│   ├── docs/                            ← GIT-GUIDE.md, VERSIONING-GUIDE.md, SEO-CHECKLIST.md, GDPR-GUIDE.md
│   ├── src/                             ← live PM artefacts
│   │   ├── BUGS/
│   │   ├── DATABASE/
│   │   ├── GDPR/
│   │   ├── PLANS/
│   │   ├── QA/
│   │   ├── REFACTORING/
│   │   ├── REVIEWS/
│   │   ├── SECURITY/
│   │   ├── SPRINTS/
│   │   ├── STORIES/
│   │   ├── TESTS/
│   │   └── WIREFRAMES/
│   └── workflows/                       ← 7 step-by-step PM workflows
│       ├── 01-story-creation/
│       ├── 02-sprint-planning/
│       ├── 03-database-schema/
│       ├── 04-wireframes/
│       ├── 05-pr-and-review/
│       ├── 06-gdpr-compliance/
│       └── 07-release/
├── CONTEXT.md                           ← project overview and layer map
├── GAPS.md                              ← missing workflow files flagged by Claude
├── README.md                            ← this file
├── eslint.config.mjs
├── lefthook.yml                         ← pre-commit hook runner
├── package.json                         ← root pnpm workspace
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
├── pyproject.toml                       ← Python tooling (ruff, basedpyright, uv)
└── uv.lock
```

---

## Prerequisites

The application itself runs entirely inside Docker containers — you never run `python`, `pytest`,
`pnpm`, or `next` directly on the host. The following tools are only needed for root-level tooling
and local quality checks.

| Tool                                  | Version                      | Purpose                                      |
| ------------------------------------- | ---------------------------- | -------------------------------------------- |
| **Git**                               | any recent                   | version control                              |
| **Docker Engine** (or Docker Desktop) | 27+                          | run all application services                 |
| **Docker Compose plugin**             | v2+                          | orchestrate local containers                 |
| **Node.js**                           | 24 (see `.nvmrc`)            | root pnpm scripts and git hooks              |
| **pnpm**                              | 10.33.0                      | JS package manager (root workspace only)     |
| **Python**                            | 3.14 (see `.python-version`) | root pyproject tooling (ruff, basedpyright)  |
| **uv**                                | 0.11.7+                      | Python environment and dependency management |

**macOS / Linux:** install Docker Desktop or Docker Engine. On Linux, add your user to the
`docker` group so you can run `docker compose` without `sudo`.

**Windows:** Docker Desktop with WSL 2 backend. All shell commands in this README assume a bash or
zsh shell (Git Bash or WSL 2 terminal).

---

## Getting Started

### Clone the repository

```bash
git clone git@github.com:syntek-studio/syntek-website.git
cd syntek-website
```

### Install root tooling and git hooks

```bash
pnpm install
```

This installs all root dev dependencies and runs `lefthook install`, which registers the
pre-commit hooks. From this point on, every `git commit` automatically runs linting and
type-checking across both layers.

### Configure environment variables

```bash
cp code/src/backend/.env.example code/src/backend/.env.local
cp code/src/frontend/.env.example code/src/frontend/.env.local
```

Edit both `.env.dev` files and fill in any required values. See
`how-to/docs/DEVELOPMENT.md` for a full list of environment variables and their defaults.

Never commit `.env.dev` or any file containing real secrets.

### Start the development environment

```bash
docker compose -f code/src/docker/docker-compose.dev.yml up -d
```

This starts:

- **backend** — Django + Gunicorn + Uvicorn with hot-reload (port 8000)
- **frontend** — Next.js dev server with HMR (port 3000)
- **db** — PostgreSQL 18 (port 5432)
- **cache** — Valkey (port 6379)
- **maildev** — local mail catcher UI (port 1080)
- **nginx** — reverse proxy routing all traffic (port 80)

### Apply database migrations

```bash
docker compose -f code/src/docker/docker-compose.dev.yml exec backend python manage.py migrate
```

### Create a superuser (optional)

```bash
docker compose -f code/src/docker/docker-compose.dev.yml exec backend python manage.py createsuperuser
```

### Verify

| URL                              | Description                   |
| -------------------------------- | ----------------------------- |
| `http://localhost:3000`          | Next.js frontend              |
| `http://localhost:8000/graphql/` | GraphQL playground (dev only) |
| `http://localhost:8000/admin/`   | Django admin                  |

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
| **Claude config**      | `.claude/`            | Global rules, routing, commands, MCP plugins            |

### Routing — read only the layer you need

| Task type                                  | Read first                      |
| ------------------------------------------ | ------------------------------- |
| Writing, reviewing, or testing code        | `code/CONTEXT.md`               |
| Stories, sprints, PRs, releases, GDPR, SEO | `project-management/CONTEXT.md` |
| Setup, daily dev, CLI usage, debugging     | `how-to/CONTEXT.md`             |

Always-applicable guides: `project-management/docs/GIT-GUIDE.md` ·
`project-management/docs/VERSIONING-GUIDE.md`

### How Claude Code uses this structure

When you open a session, Claude Code reads `.claude/CLAUDE.md` first. This file contains the
global rules, routing table, MCP server configuration, model selection rules, and naming
conventions. It deliberately does not contain layer-specific detail — that lives in each layer's
own `CONTEXT.md`, which Claude reads only when the task is within that layer's domain.

Each `CONTEXT.md` links to the `docs/` guides and `workflows/` step-by-step processes relevant to
that layer. This keeps the active context window small and ensures Claude always reads the right
reference material rather than everything at once.

### Quick-start by role

| You are…                                    | Start here                      |
| ------------------------------------------- | ------------------------------- |
| First time in this repository               | `how-to/CONTEXT.md`             |
| Writing or reviewing code                   | `code/CONTEXT.md`               |
| Planning, writing stories, or PM work       | `project-management/CONTEXT.md` |
| Configuring Claude Code or adding a command | `.claude/CLAUDE.md`             |

---

## Project Management

All project management artefacts live in `project-management/`. The folder is structured to make
the right document easy to find, and every file type follows a strict naming convention so nothing
gets lost.

### User stories

Stories live in `project-management/src/STORIES/` and follow the naming convention `US###.md`
(three-digit zero-padded: `US001.md`, `US042.md`).

Each story should define acceptance criteria, the affected layer (backend / frontend / both), and
any GDPR or accessibility considerations. Use the PM workflow
`project-management/workflows/01-story-creation/` to write stories consistently.

### Sprint planning

Sprint plans live in `project-management/src/SPRINTS/` as `SPRINT-##.md` (two-digit:
`SPRINT-01.md`). Each sprint is organised using **MoSCoW** prioritisation:

- **Must have** — critical for the sprint goal
- **Should have** — high value, included if capacity allows
- **Could have** — nice to have, deferred if time is tight
- **Won't have** — explicitly out of scope this sprint

Use `project-management/workflows/02-sprint-planning/` to plan sprints.

### Database ERDs with mcp-mermaid

Database schemas and entity-relationship diagrams are documented in
`project-management/src/DATABASE/` using Mermaid diagrams.

The `mcp-mermaid` MCP server renders Mermaid diagrams inside Claude Code sessions. Install it once
on your machine:

```bash
npx -y @anthropic-ai/mcp-install mcp-mermaid
```

Full installation guide: [github.com/hustcc/mcp-mermaid](https://github.com/hustcc/mcp-mermaid)

Once installed, use the `mcp__mcp-mermaid__generate_mermaid_diagram` tool inside Claude Code to
render diagrams from Mermaid syntax. Schema design is formalised before any migration is written —
use `project-management/workflows/03-database-schema/` to go through the sign-off process.

Example ERD syntax committed to `DATABASE/`:

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
`project-management/src/WIREFRAMES/`. Each wireframe entry records the Figma URL, the story it
belongs to, and the sign-off status. No frontend work begins on a feature until the wireframe is
signed off — use `project-management/workflows/04-wireframes/`.

### User flow diagrams

User flows are documented as Mermaid flowcharts in `project-management/src/PLANS/` alongside
architectural plans. They capture the end-to-end journey through a feature before implementation
begins.

### QA and testing documentation

| Document type        | Naming convention                | Location                        |
| -------------------- | -------------------------------- | ------------------------------- |
| QA test file         | `QA-US###-<DESCRIPTION>.md`      | `project-management/src/QA/`    |
| Test status tracker  | `US###-TEST-STATUS.md`           | `project-management/src/TESTS/` |
| Manual testing guide | `US###-MANUAL-TESTING.md`        | `project-management/src/TESTS/` |
| Bug report           | `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` | `project-management/src/BUGS/`  |

Automated tests are written first (TDD) and their status is tracked in `TEST-STATUS.md`. Manual
tests are documented in `MANUAL-TESTING.md` and run before any PR is promoted to `staging`.

### PM workflows — when to use each

| Workflow              | Trigger                                                |
| --------------------- | ------------------------------------------------------ |
| `01-story-creation/`  | Writing a new user story                               |
| `02-sprint-planning/` | Planning a new sprint                                  |
| `03-database-schema/` | Designing a new model or schema change                 |
| `04-wireframes/`      | Creating or updating wireframes before frontend work   |
| `05-pr-and-review/`   | Raising a PR and moving it through the promotion chain |
| `06-gdpr-compliance/` | Reviewing a feature for GDPR compliance                |
| `07-release/`         | Cutting a release (version bump, changelog, deploy)    |

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
| 04  | `04-api-design/`          | Design and implement a new Strawberry GraphQL API surface                |
| 05  | `05-gdpr-enforcement/`    | Implement GDPR requirements in code (encryption, consent, deletion)      |
| 06  | `06-review/`              | Code quality review before raising a PR (security, principles, coverage) |
| 07  | `07-debug/`               | Isolate a code logic bug, write a regression test, apply the minimal fix |
| 08  | `08-refactor/`            | Systematic refactoring without behaviour change                          |
| 09  | `09-database-migration/`  | Create and run a new Django database migration                           |
| 10  | `10-debugging-with-logs/` | Debug using local logs, Glitchtip, Loki, and Grafana                     |

### Typical feature development sequence

```text
01-new-feature  →  02-tdd-cycle  →  04-api-design  →  05-gdpr-enforcement  →  06-review  →  PM: 05-pr-and-review
```

- Start with `01-new-feature` to plan the feature scope.
- Work in `02-tdd-cycle` — write failing tests first, then implement.
- If the feature exposes a new GraphQL API, follow `04-api-design` in parallel.
- If the feature touches PII, run `05-gdpr-enforcement` before raising a PR.
- Before opening the PR, run `06-review` to verify OWASP coverage, coding principles, and
  coverage floors.
- Hand off to the PM layer with `project-management/workflows/05-pr-and-review/`.

### Bug fix sequence

```text
how-to/03-debugging  →  07-debug  →  06-review  →  PM: 05-pr-and-review
```

Start with the operational debugging workflow to confirm the environment is healthy, then use
`07-debug` to isolate and fix the logic. Never refactor and fix a bug in the same commit — if the
fix reveals a design problem, open a separate refactoring task using `08-refactor`.

---

## Claude Code Tooling

### Slash commands

Slash commands are defined in `.claude/commands/` and can be invoked inside any Claude Code
session with `/command-name`.

| Command       | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| `/dev`        | Start the full-stack development environment                 |
| `/test`       | Run backend and frontend test suites                         |
| `/migrate`    | Run Django database migrations                               |
| `/codegen`    | Generate TypeScript types from the Strawberry GraphQL schema |
| `/schema`     | Generate or export the Strawberry GraphQL schema             |
| `/staging`    | Deploy to the staging environment                            |
| `/production` | Deploy to the production environment                         |

### MCP tool plugins

Plugins in `.claude/plugins/` are Python scripts that Claude Code agents load as MCP tools to
inspect the local environment without running arbitrary shell commands.

| Plugin            | Purpose                                                                 |
| ----------------- | ----------------------------------------------------------------------- |
| `docker-tool.py`  | Container and Compose status — lists running services and image info    |
| `db-tool.py`      | Database detection and connection info for backend and setup agents     |
| `git-tool.py`     | Repository status, branch info, remote detection, and commit history    |
| `env-tool.py`     | Read, compare, and validate environment files across environments       |
| `quality-tool.py` | Run linters and report code quality metrics before and after changes    |
| `log-tool.py`     | Log file discovery, logging config detection, and recent log extraction |
| `project-tool.py` | Project structure detection and technology stack identification         |
| `pm-tool.py`      | Detect project management tool configs (Linear, ClickUp, Jira, etc.)    |
| `chrome-tool.py`  | Detect Chrome binary path for browser automation agents                 |
| `ddev-tool.py`    | DDEV project status and service configuration (if DDEV is used)         |

### MCP servers

| Server              | Scope              | Always available                       |
| ------------------- | ------------------ | -------------------------------------- |
| `code-review-graph` | Repo — `.mcp.json` | Yes — auto-loaded for all contributors |
| `context7`          | Machine-global     | Only if installed locally              |
| `claude-in-chrome`  | Machine-global     | Only if installed locally              |
| `mcp-mermaid`       | Machine-global     | Only if installed locally              |

---

## Docker

All application services run inside Docker. Never run `python`, `pytest`, `pnpm`, or `next`
directly on the host — always use `docker compose exec`.

Full Docker reference: `code/src/docker/CONTEXT.md`

### Environments

| Environment | Compose file                 | Who uses it             |
| ----------- | ---------------------------- | ----------------------- |
| `dev`       | `docker-compose.dev.yml`     | Developer locally       |
| `test`      | `docker-compose.test.yml`    | CI / developer          |
| `staging`   | `docker-compose.staging.yml` | GitHub Actions → server |
| `prod`      | `docker-compose.prod.yml`    | GitHub Actions → server |

### Services per environment

| Service    | dev | test | staging | prod | Notes                             |
| ---------- | --- | ---- | ------- | ---- | --------------------------------- |
| `backend`  | ✅  | ✅   | ✅      | ✅   | Django + Gunicorn + Uvicorn       |
| `frontend` | ✅  | ✅   | ✅      | ✅   | Next.js (dev/test) / Nginx static |
| `db`       | ✅  | ✅   | ❌      | ❌   | PostgreSQL 18 — server-managed    |
| `cache`    | ✅  | ✅   | ❌      | ❌   | Valkey — server-managed           |
| `maildev`  | ✅  | ✅   | ❌      | ❌   | Local mail catcher (port 1080)    |
| `nginx`    | ✅  | ✅   | ❌      | ❌   | Reverse proxy (port 80)           |

### Common commands

```bash
# Start dev stack
docker compose -f code/src/docker/docker-compose.dev.yml up -d

# Stop dev stack
docker compose -f code/src/docker/docker-compose.dev.yml down

# View logs
docker compose -f code/src/docker/docker-compose.dev.yml logs -f backend

# Django management
docker compose -f code/src/docker/docker-compose.dev.yml exec backend python manage.py <command>

# Run pytest
docker compose -f code/src/docker/docker-compose.test.yml exec backend pytest

# pnpm / Next.js
docker compose -f code/src/docker/docker-compose.dev.yml exec frontend pnpm <command>
```

### Staging and production images

Staging and prod images are pushed to GHCR by GitHub Actions and pulled on the server:

```text
ghcr.io/syntek-studio/syntek-website/backend:<tag>
ghcr.io/syntek-studio/syntek-website/frontend:<tag>
```

Tags: `staging`, `prod`, or a git SHA. Set `IMAGE_TAG` in the server environment.

### Observability (staging / prod)

| Tool       | Purpose                                          |
| ---------- | ------------------------------------------------ |
| Glitchtip  | Exception and error tracking (Sentry-compatible) |
| Loki       | Log aggregation via Promtail on the server       |
| Prometheus | Django metrics scraped from `/metrics/`          |
| Grafana    | Dashboards querying Loki + Prometheus            |

Full observability guide: `code/docs/LOGGING.md`

---

## Project Scripts

### Root scripts (run on host via pnpm)

These scripts run on the host machine against the root workspace. They are used for linting and
formatting the repository's JS/TS configuration files and Markdown documentation.

```bash
pnpm lint:js          # ESLint — checks JS, TS, and React files
pnpm lint:md          # markdownlint-cli2 — checks all Markdown files
pnpm format:check     # Prettier — dry-run format check
pnpm format           # Prettier — apply formatting
pnpm prepare          # Install Lefthook git hooks (runs automatically after pnpm install)
```

### Quality scripts (run inside containers via docker compose exec)

The scripts in `code/src/scripts/` run inside the Docker containers and cover both the backend
and frontend layers.

```bash
# Lint — Python (ruff), TS/JS/React (ESLint), Markdown (markdownlint-cli2)
docker compose -f code/src/docker/docker-compose.dev.yml exec backend bash /scripts/lint.sh

# Type-check — Python (basedpyright), TypeScript (tsc --noEmit)
docker compose -f code/src/docker/docker-compose.dev.yml exec backend bash /scripts/check.sh

# Format — Python (ruff format), TS/JS/CSS/MD (Prettier)
docker compose -f code/src/docker/docker-compose.dev.yml exec backend bash /scripts/format.sh --fix
```

All three scripts support flags: `--fix`, `--quiet`, `--output`, `--path`. Run any script with
`--help` for usage details. Generated reports are written to `code/src/scripts/reports/`
(gitignored).

### Logging and debugging commands

```bash
# Tail the live Django log (dev/test — written to code/src/logs/django.log)
tail -f code/src/logs/django.log

# Grep for errors in the local log
grep -i "error\|critical" code/src/logs/django.log

# Stream container logs (all services)
docker compose -f code/src/docker/docker-compose.dev.yml logs -f

# Stream backend container logs only
docker compose -f code/src/docker/docker-compose.dev.yml logs -f backend

# Run Django management commands (migrations, shell, etc.)
docker compose -f code/src/docker/docker-compose.dev.yml exec backend python manage.py <command>
```

Full observability and debugging guide: `code/docs/LOGGING.md`
Step-by-step debugging workflow: `code/workflows/10-debugging-with-logs/`

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

A commit is rejected if any hook fails. Fix the reported issues and recommit — do not use
`--no-verify`.

---

## TDD and BDD

> **This section is a stub.** The full test suite has not yet been implemented.
> It will be fleshed out when testing infrastructure is in place.

### Principles

This project follows test-driven development (TDD). Tests are written before the implementation
they cover. The cycle is:

1. **Red** — write a failing test that describes the desired behaviour
2. **Green** — write the minimal implementation that makes the test pass
3. **Refactor** — clean up the code without changing behaviour; all tests must remain green

Use `code/workflows/02-tdd-cycle/` for the full step-by-step process.

### Coverage floors

| Layer                 | Minimum coverage | Auth-related code |
| --------------------- | ---------------- | ----------------- |
| **Backend (pytest)**  | 75%              | 90%               |
| **Frontend (Vitest)** | 70%              | —                 |

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

> **This section is a stub.** Backend source code has not yet been implemented.
> It will be expanded once Django and Strawberry are initialised via `/syntek-dev-suite:setup`.

### Planned structure

```text
code/src/backend/
├── apps/
│   ├── core/
│   │   └── schema.py        ← root Strawberry GraphQL schema
│   ├── users/
│   └── content/
├── config/
│   ├── settings/
│   │   ├── base.py
│   │   ├── local.py
│   │   ├── staging.py
│   │   └── production.py
│   └── urls.py
└── manage.py
```

### API design principles

- **Schema-first:** design the GraphQL schema before writing resolvers
- **Business logic in services:** resolvers coordinate, services compute
- **Explicit permissions:** every mutation has an explicit permission check (OWASP A01)
- **No IDOR:** user-supplied IDs are always verified against the caller's ownership

### Useful references

- API design guide → `code/docs/API-DESIGN.md`
- API design workflow → `code/workflows/04-api-design/`
- Architecture patterns → `code/docs/ARCHITECTURE-PATTERNS.md`
- Security guide → `code/docs/SECURITY.md`

---

## Frontend Guide

> **This section is a stub.** Frontend source code has not yet been implemented.
> It will be expanded once Next.js is initialised via `/syntek-dev-suite:setup`.

### Planned structure

```text
code/src/frontend/
└── src/
    ├── app/                 ← Next.js App Router pages and layouts
    ├── components/          ← React components
    └── graphql/
        ├── queries/         ← GraphQL query documents
        ├── mutations/       ← GraphQL mutation documents
        └── generated/       ← auto-generated TypeScript types and hooks (never edit by hand)
```

### Key rules

- Run `/codegen` after any backend schema change to regenerate TypeScript types
- **WCAG 2.2 AA** compliance is required on all interactive components — see
  `code/docs/ACCESSIBILITY.md`
- SEO metadata is required on every page — see `project-management/docs/SEO-CHECKLIST.md`
- Apollo Client is the GraphQL client; never write raw fetch calls to the GraphQL endpoint

### Useful references

- Accessibility guide → `code/docs/ACCESSIBILITY.md`
- Performance guide → `code/docs/PERFORMANCE.md`
- Architecture patterns → `code/docs/ARCHITECTURE-PATTERNS.md`

---

## Welcome

Welcome to the syntek-website repository. Whether you are a developer, designer, or Claude Code
agent reading this for the first time — you are in the right place.

The three-layer structure (`code/`, `how-to/`, `project-management/`) is designed to make it easy
to find exactly what you need without reading everything at once. When in doubt, start with the
`CONTEXT.md` for your layer and let it guide you to the right reference or workflow.

If you encounter a workflow folder that is missing `STEPS.md` or `CHECKLIST.md`, record it in
`GAPS.md` at the project root and proceed using `CONTEXT.md` alone. Do not silently generate
missing files.

For questions, issues, or contributions, reach out to the Syntek Studio development team.

---

_Maintained by Syntek Studio · v0.1.0 · British English (en_GB) · Europe/London_
