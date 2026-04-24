# CLI Tooling — project-name

**Last Updated**: 18/04/2026
**Version**: 1.0.0
**Language**: British English (en_GB)
**Timezone**: Europe/London

> **Rule:** All development commands run inside Docker containers.
> Use `docker compose exec backend` for Django/Python and `docker compose exec frontend` for
> Next.js/TypeScript. Never invoke `python`, `pytest`, `pnpm`, or `next` directly on the host.

---

## Table of Contents

- [Overview](#overview)
- [Starting and Stopping Services](#starting-and-stopping-services)
- [Backend Commands](#backend-commands)
  - [Django Management](#django-management)
  - [Testing](#backend-testing)
  - [Lint and Type-check](#backend-lint-and-type-check)
  - [Auto-fix](#backend-auto-fix)
- [Frontend Commands](#frontend-commands)
  - [Testing](#frontend-testing)
  - [Lint and Type-check](#frontend-lint-and-type-check)
  - [Auto-fix](#frontend-auto-fix)
  - [GraphQL Codegen](#graphql-codegen)
- [Database Management](#database-management)
- [Running CI Checks Locally](#running-ci-checks-locally)
- [Common Shortcuts](#common-shortcuts)
- [Troubleshooting](#troubleshooting)

---

## Overview

All development tasks for project-name run through Docker Compose. There are two primary service
targets:

| Target     | Container | Toolchain                                        |
| ---------- | --------- | ------------------------------------------------ |
| `backend`  | Django    | Python 3.14, uv, ruff, basedpyright, pytest      |
| `frontend` | Next.js   | Node.js 24, pnpm, TypeScript, Vitest, Playwright |

Every command in this guide is prefixed with either `docker compose exec backend` or
`docker compose exec frontend`. Never run `python`, `pytest`, `pnpm`, or `next` directly on the
host machine — doing so will use host-level binaries and environment variables that differ from the
container, producing inconsistent results and breaking CI parity.

---

## Starting and Stopping Services

### Start all services

```bash
docker compose up
```

Add `-d` to detach and run in the background:

```bash
docker compose up -d
```

### Start a single service

```bash
docker compose up backend
docker compose up frontend
```

### Stop all services

```bash
docker compose down
```

Stop and remove volumes (resets the database):

```bash
docker compose down -v
```

### Restart a single service

```bash
docker compose restart backend
docker compose restart frontend
```

### View logs

Stream all service logs:

```bash
docker compose logs -f
```

Stream logs for a single service:

```bash
docker compose logs -f backend
docker compose logs -f frontend
```

---

## Backend Commands

All backend commands are prefixed with `docker compose exec backend`.

### Django Management

Apply pending migrations:

```bash
docker compose exec backend python manage.py migrate
```

Create new migration files:

```bash
docker compose exec backend python manage.py makemigrations
```

Create migrations for a specific app:

```bash
docker compose exec backend python manage.py makemigrations <app_label>
```

Open the Django interactive shell:

```bash
docker compose exec backend python manage.py shell
```

Create a superuser account:

```bash
docker compose exec backend python manage.py createsuperuser
```

Show all available management commands:

```bash
docker compose exec backend python manage.py help
```

### Backend Testing

Run the full test suite:

```bash
docker compose exec backend pytest
```

Run only unit-marked tests:

```bash
docker compose exec backend pytest -m unit
```

Run only integration-marked tests:

```bash
docker compose exec backend pytest -m integration
```

Run tests matching a keyword pattern:

```bash
docker compose exec backend pytest -k <pattern>
```

Run a specific test file:

```bash
docker compose exec backend pytest apps/<app>/tests/test_<module>.py
```

Run tests with HTML coverage report (output to `htmlcov/`):

```bash
docker compose exec backend pytest --cov=apps --cov-report=html
```

Run tests with terminal coverage summary:

```bash
docker compose exec backend pytest --cov=apps --cov-report=term-missing
```

Stop on first failure:

```bash
docker compose exec backend pytest -x
```

### Backend Lint and Type-check

Check for linting errors (ruff):

```bash
docker compose exec backend ruff check .
```

Check formatting without writing changes:

```bash
docker compose exec backend ruff format --check .
```

Run static type analysis (basedpyright):

```bash
docker compose exec backend basedpyright
```

### Backend Auto-fix

Apply all auto-fixable lint errors:

```bash
docker compose exec backend ruff check --fix .
```

Apply code formatting:

```bash
docker compose exec backend ruff format .
```

---

## Frontend Commands

All frontend commands are prefixed with `docker compose exec frontend`.

The Next.js dev server starts automatically when `docker compose up` is run — there is no separate
command to start it. Visit `http://localhost:3000` once the container is healthy.

### Frontend Testing

Run the full Vitest test suite:

```bash
docker compose exec frontend pnpm test
```

Run tests in watch mode:

```bash
docker compose exec frontend pnpm test -- --watch
```

Run tests with coverage report:

```bash
docker compose exec frontend pnpm test -- --coverage
```

Run end-to-end tests (Playwright):

```bash
docker compose exec frontend pnpm test:e2e
```

### Frontend Lint and Type-check

Run ESLint:

```bash
docker compose exec frontend pnpm lint
```

Run TypeScript type-checking:

```bash
docker compose exec frontend pnpm type-check
```

Check formatting without writing changes (Prettier):

```bash
docker compose exec frontend pnpm format:check
```

### Frontend Auto-fix

Apply auto-fixable ESLint errors:

```bash
docker compose exec frontend pnpm lint --fix
```

Apply Prettier formatting:

```bash
docker compose exec frontend pnpm format
```

### GraphQL Codegen

Regenerate TypeScript types and Apollo hooks from the GraphQL schema:

```bash
docker compose exec frontend pnpm codegen
```

Run codegen in watch mode (useful during active API development):

```bash
docker compose exec frontend pnpm codegen --watch
```

Generated output lands in `code/src/frontend/src/graphql/generated/`. Commit these files alongside
any schema or query changes.

---

## Database Management

### Apply migrations

```bash
docker compose exec backend python manage.py migrate
```

### Create new migrations

```bash
docker compose exec backend python manage.py makemigrations
```

### Check for migration drift

Show the current migration plan without applying it:

```bash
docker compose exec backend python manage.py migrate --plan
```

Detect unapplied migrations:

```bash
docker compose exec backend python manage.py showmigrations
```

### Open a raw psql shell

Connect directly to the development database:

```bash
docker compose exec db psql -U postgres project_name_dev
```

Useful psql commands once connected:

```text
\dt          — list all tables
\d <table>   — describe a table
\q           — quit
```

### Reset the database

Stop services, remove the database volume, restart, and re-apply migrations:

```bash
docker compose down -v
docker compose up -d db
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py createsuperuser
```

---

## Running CI Checks Locally

Run these steps in order before every push. All steps must pass.

**Step 1 — Backend lint:**

```bash
docker compose exec backend ruff check .
```

**Step 2 — Backend format check:**

```bash
docker compose exec backend ruff format --check .
```

**Step 3 — Backend type-check:**

```bash
docker compose exec backend basedpyright
```

**Step 4 — Backend tests with coverage:**

```bash
docker compose exec backend pytest --cov=apps --cov-report=term-missing
```

**Step 5 — Frontend lint:**

```bash
docker compose exec frontend pnpm lint
```

**Step 6 — Frontend format check:**

```bash
docker compose exec frontend pnpm format:check
```

**Step 7 — Frontend type-check:**

```bash
docker compose exec frontend pnpm type-check
```

**Step 8 — Frontend tests with coverage:**

```bash
docker compose exec frontend pnpm test -- --coverage
```

**Step 9 — GraphQL codegen drift check (no uncommitted diff):**

```bash
docker compose exec frontend pnpm codegen
git diff --exit-code code/src/frontend/src/graphql/generated/
```

If step 9 produces a diff, commit the regenerated files before pushing.

---

## Common Shortcuts

| Task                          | Command                                                                   |
| ----------------------------- | ------------------------------------------------------------------------- |
| Start all services            | `docker compose up`                                                       |
| Stop all services             | `docker compose down`                                                     |
| Tail all logs                 | `docker compose logs -f`                                                  |
| Apply migrations              | `docker compose exec backend python manage.py migrate`                    |
| Make migrations               | `docker compose exec backend python manage.py makemigrations`             |
| Django shell                  | `docker compose exec backend python manage.py shell`                      |
| psql shell                    | `docker compose exec db psql -U postgres project_name_dev`                |
| Run backend tests             | `docker compose exec backend pytest`                                      |
| Run backend tests (coverage)  | `docker compose exec backend pytest --cov=apps --cov-report=term-missing` |
| Backend lint                  | `docker compose exec backend ruff check .`                                |
| Backend type-check            | `docker compose exec backend basedpyright`                                |
| Backend format                | `docker compose exec backend ruff format .`                               |
| Run frontend tests            | `docker compose exec frontend pnpm test`                                  |
| Run frontend tests (coverage) | `docker compose exec frontend pnpm test -- --coverage`                    |
| Run E2E tests                 | `docker compose exec frontend pnpm test:e2e`                              |
| Frontend lint                 | `docker compose exec frontend pnpm lint`                                  |
| Frontend type-check           | `docker compose exec frontend pnpm type-check`                            |
| Frontend format               | `docker compose exec frontend pnpm format`                                |
| GraphQL codegen               | `docker compose exec frontend pnpm codegen`                               |

---

## Troubleshooting

### Container not running

If `docker compose exec` fails with `no such service` or `container is not running`:

```bash
# Check current container state
docker compose ps

# Start the specific service
docker compose up -d backend
docker compose up -d frontend
```

If a container exits immediately after starting, inspect its logs:

```bash
docker compose logs backend
docker compose logs frontend
```

### pnpm lockfile mismatch

If the frontend container fails to start with a lockfile error (e.g.
`ERR_PNPM_OUTDATED_LOCKFILE`), the `pnpm-lock.yaml` is out of sync with `package.json`. Fix by
rebuilding the frontend image after updating dependencies:

```bash
docker compose down frontend
docker compose build frontend
docker compose up -d frontend
```

If you have intentionally updated `package.json` on the host and need to regenerate the lockfile:

```bash
docker compose exec frontend pnpm install
```

Commit the updated `pnpm-lock.yaml`.

### Migration drift

If Django reports unapplied migrations on startup, apply them:

```bash
docker compose exec backend python manage.py migrate
```

If there are conflicting migrations (two branches both created a migration for the same app),
merge them:

```bash
docker compose exec backend python manage.py makemigrations --merge
```

Always review the merged migration file before committing.

### Port conflicts

The default ports are `3000` (frontend) and `8000` (backend). If another process is using these
ports, find and stop it:

```bash
# Find the process using port 8000
lsof -i :8000

# Find the process using port 3000
lsof -i :3000
```

Alternatively, override the ports temporarily using a `docker-compose.override.yml` file — do not
commit host-specific port overrides to the main `docker-compose.yml`.

### Rebuilding after dependency changes

When `pyproject.toml` or `pnpm-lock.yaml` changes (e.g. after pulling from main), rebuild the
affected image so the container picks up the new dependencies:

```bash
docker compose build backend
docker compose build frontend
docker compose up -d
```
