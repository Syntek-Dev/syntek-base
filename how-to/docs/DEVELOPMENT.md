# Development Workflow — project-name

**Last Updated**: 18/04/2026\
**Version**: 1.0.0\
**Language**: British English (en_GB)\
**Timezone**: Europe/London

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Daily Workflow](#daily-workflow)
- [Code Quality](#code-quality)
- [Git Workflow](#git-workflow)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)

---

## Overview

`project-name` is a two-layer full-stack web application — a **deployable product**, not a library.
All development work runs inside Docker containers. Never invoke `python`, `pytest`, `pnpm`, or
`next` directly on the host machine.

| Layer        | Technology                                    | Container  | Dev URL                     |
| ------------ | --------------------------------------------- | ---------- | --------------------------- |
| **Backend**  | Django 6.0.4, Python 3.14, Strawberry GraphQL | `backend`  | http://localhost:8000       |
| **Frontend** | Next.js 16.2.4, TypeScript 6.0.3, React 19.2  | `frontend` | http://localhost:3000       |
| **Database** | PostgreSQL 18                                 | `db`       | `localhost:5432` (internal) |
| **Cache**    | Valkey (latest stable)                        | `valkey`   | `localhost:6379` (internal) |

Additional endpoints:

| Endpoint           | URL                            |
| ------------------ | ------------------------------ |
| GraphQL API        | http://localhost:8000/graphql/ |
| GraphQL Playground | http://localhost:8000/graphql/ |
| Django Admin       | http://localhost:8000/admin/   |

---

## Prerequisites

The following must be installed on your host machine before you begin:

- **Docker** (latest stable) — [docs.docker.com/get-docker](https://docs.docker.com/get-docker/)
- **Docker Compose** v2.x (bundled with Docker Desktop, or `docker compose` plugin for Linux)
- **Git** 2.x
No host-level Python, Node.js, or Rust installation is required. All runtimes live inside the
containers.

---

## Getting Started

### 1. Clone the repository

```bash
git clone git@github.com:Syntek-Dev/project-name.git
cd project-name
```

### 2. Copy the environment file

```bash
cp .env.example .env
```

Open `.env` and fill in any values marked `CHANGE_ME`. See [Environment Variables](#environment-variables)
for a full reference.

### 3. Build and start all containers

```bash
docker compose up -d --build
```

The `--build` flag is only needed on first run or after a `Dockerfile` change. Subsequent starts
can omit it:

```bash
docker compose up -d
```

### 4. Apply database migrations

```bash
docker compose exec backend python manage.py migrate
```

### 5. Create a superuser (first time only)

```bash
docker compose exec backend python manage.py createsuperuser
```

### 6. Verify everything is running

Open the following URLs in your browser:

- Frontend: http://localhost:3000
- GraphQL Playground: http://localhost:8000/graphql/
- Django Admin: http://localhost:8000/admin/

Check container health at any time:

```bash
docker compose ps
```

---

## Daily Workflow

Follow these steps at the start of each development session.

### 1. Pull latest changes

```bash
git checkout main
git pull origin main
```

### 2. Create a feature branch

```bash
git checkout -b us###/short-description
```

See [Git Workflow](#git-workflow) for branch naming rules.

### 3. Start containers

```bash
docker compose up -d
```

Apply any new migrations if `git pull` brought in migration files:

```bash
docker compose exec backend python manage.py migrate
```

### 4. Write tests first (TDD)

Backend tests live in `code/src/backend/`. Frontend tests live alongside their components in
`code/src/frontend/src/`. Always write a failing test before implementing the feature.

### 5. Run the test suite

**Backend:**

```bash
docker compose exec backend pytest
```

Run a specific file or test:

```bash
docker compose exec backend pytest apps/users/tests/test_auth.py
docker compose exec backend pytest -k "test_login"
```

**Frontend:**

```bash
docker compose exec frontend pnpm test
```

Run in watch mode during development:

```bash
docker compose exec frontend pnpm test:watch
```

### 6. Commit and open a PR

Commit using Conventional Commits format (see [Git Workflow](#git-workflow)) and open a pull
request on GitHub targeting `main`.

---

## Code Quality

Run all checks before committing. CI enforces the same checks — failures locally mean failures in
CI.

### Backend — ruff (lint + format)

```bash
# Lint
docker compose exec backend ruff check .

# Auto-fix safe issues
docker compose exec backend ruff check --fix .

# Format
docker compose exec backend ruff format .

# Check formatting without writing changes
docker compose exec backend ruff format --check .
```

### Backend — basedpyright (type checking)

```bash
docker compose exec backend basedpyright
```

### Frontend — ESLint

```bash
docker compose exec frontend pnpm lint
```

### Frontend — Prettier

```bash
# Check
docker compose exec frontend pnpm format:check

# Write changes
docker compose exec frontend pnpm format
```

### Frontend — TypeScript type checking

```bash
docker compose exec frontend pnpm type-check
```

### Markdown lint

All Markdown files must pass `markdownlint`. Every fenced code block must declare its language
(bare ` ``` ` blocks are a lint error per MD040):

```bash
docker compose exec frontend pnpm lint:md
```

### Run everything at once

```bash
# Backend: lint, format check, type check, tests
docker compose exec backend ruff check . && \
  docker compose exec backend ruff format --check . && \
  docker compose exec backend basedpyright && \
  docker compose exec backend pytest

# Frontend: lint, format check, type check, tests
docker compose exec frontend pnpm lint && \
  docker compose exec frontend pnpm format:check && \
  docker compose exec frontend pnpm type-check && \
  docker compose exec frontend pnpm test
```

---

## Git Workflow

### Branch naming

```text
us###/short-description

Examples:
  us001/user-registration
  us042/graphql-portfolio-query
  fix/missing-csrf-token
  chore/upgrade-strawberry-0.315
```

The `us###` prefix must match a story ID in `project-management/src/STORIES/`.

### Commit messages (Conventional Commits)

```text
<type>(<scope>): <subject>

Types: feat, fix, refactor, test, docs, chore, perf, style

Examples:
  feat(auth): add JWT refresh token rotation
  fix(graphql): correct IDOR check on portfolio query
  test(users): add coverage for password reset flow
  docs(api): document rate-limiting headers
  chore(deps): upgrade strawberry-graphql to 0.315.0
```

**Rules:**

- Subject line under 72 characters
- Imperative mood: "Add feature" not "Added feature"
- Body explains _why_, not _what_
- Reference the story ID in the body: `Closes US-042`

### Pull requests

Every PR must include:

1. A clear title summarising the change
2. A description explaining what changed and why
3. Story ID reference (e.g., `Closes US-042`)
4. A testing section describing how to verify the change
5. Passing CI (tests, lint, type checking)

Full branching rules: `project-management/docs/GIT-GUIDE.md`

---

## Environment Variables

All configuration is provided via a `.env` file at the project root. This file is never committed —
only `.env.example` is tracked in version control.

Copy the example file on first setup:

```bash
cp .env.example .env
```

### Key variables

```bash
# Django
DJANGO_SECRET_KEY=CHANGE_ME
DJANGO_DEBUG=True                        # Must be False in all non-local environments
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ALLOWED_ORIGINS=http://localhost:3000

# Database
POSTGRES_DB=project_name_dev
POSTGRES_USER=syntek
POSTGRES_PASSWORD=CHANGE_ME
POSTGRES_HOST=db
POSTGRES_PORT=5432

# Valkey / cache
VALKEY_URL=redis://valkey:6379/0

# Next.js
NEXT_PUBLIC_GRAPHQL_URL=http://localhost:8000/graphql/

```

**Security rules (non-negotiable):**

- Never hardcode secrets — always use environment variables.
- `DJANGO_DEBUG` must be `False` in staging and production.
- `CORS_ALLOWED_ORIGINS` must be an explicit allowlist — never `*` in production.

---

## Troubleshooting

### A container won't start

Check the logs for the specific service:

```bash
docker compose logs backend
docker compose logs frontend
docker compose logs db
```

Rebuild the image if a `Dockerfile` or dependency file changed:

```bash
docker compose up -d --build backend
```

### Database connection errors

Ensure the `db` container is healthy before the `backend` container tries to connect:

```bash
docker compose ps db
```

If the database container is still initialising, wait a moment and retry:

```bash
docker compose restart backend
```

Verify that `POSTGRES_HOST` in `.env` is set to `db` (the Docker Compose service name), not
`localhost`.

### Migration errors

If `migrate` reports conflicting migrations:

```bash
# Show current migration state
docker compose exec backend python manage.py showmigrations

# If a migration is stuck, check for unapplied squashed migrations
docker compose exec backend python manage.py migrate --run-syncdb
```

For a clean local reset (destroys all data — never run in production):

```bash
docker compose down -v          # removes volumes including the database
docker compose up -d
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py createsuperuser
```

### Node module issues / missing packages

If the frontend reports missing packages after a `git pull`:

```bash
docker compose exec frontend pnpm install
```

If that does not resolve it, rebuild the frontend image to reinstall from scratch:

```bash
docker compose up -d --build frontend
```

### GraphQL schema out of date

After adding or modifying Strawberry types, regenerate the TypeScript types:

```bash
docker compose exec frontend pnpm codegen
```

The generated files are written to `code/src/frontend/src/graphql/generated/`. Commit them
alongside the schema changes.

### Port already in use

If port 3000 or 8000 is occupied by another process:

```bash
# Find what is using port 8000
sudo lsof -i :8000

# Kill the process or stop the conflicting service, then:
docker compose up -d
```
