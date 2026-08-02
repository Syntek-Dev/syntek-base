---
type: guide
agent: setup
skills: [global-workflow]
model: opus
---

# CLI Tooling — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Docker Compose dev commands run via project shell scripts

> **Rule:** All development commands run through the project shell scripts in `code/src/scripts/**/*.sh`.
> Never invoke `docker compose`, `python`, `pytest`, `pnpm`, or `uv` directly — always use the scripts.

---

## Overview

There is one app process family: the Django ASGI server. It serves the public site
(django-components + templates + HTMX + Alpine + token CSS) and the Django Ninja
`/api/` routers. There is no client build step.

| Target    | Runtime / Build                           | Toolchain                                   |
| --------- | ----------------------------------------- | ------------------------------------------- |
| `backend` | Django ASGI — serves the site and `/api/` | Python 3.14, uv, ruff, basedpyright, pytest |

---

## Starting and Stopping Services

```bash
# Start all services
bash code/src/scripts/development/server.sh up

# Start with image rebuild
bash code/src/scripts/development/server.sh up --build

# Start a single service
bash code/src/scripts/development/server.sh up --service backend

# Stop all services
bash code/src/scripts/development/server.sh down

# Stop and remove volumes (resets the database)
bash code/src/scripts/development/server.sh down --volumes

# Restart a single service
bash code/src/scripts/development/server.sh restart --service backend

# Stream all service logs
bash code/src/scripts/development/logs.sh --follow

# Stream logs for a single service
bash code/src/scripts/development/logs.sh --service backend --follow
```

The site is served by Django — with the stack up, visit `http://localhost:8000`.

---

## Backend Commands

### Django Management

```bash
# Apply pending migrations
bash code/src/scripts/database/migrate.sh run

# Create new migration files
bash code/src/scripts/database/migrate.sh make

# Create migrations for a specific app
bash code/src/scripts/database/migrate.sh make --app <app_label>

# Open the Django interactive shell
bash code/src/scripts/development/shell.sh

# Create a superuser account
bash code/src/scripts/database/manageusers.sh create-superuser
```

### Backend Testing

```bash
# Full test suite
bash code/src/scripts/tests/backend.sh

# Run only unit-marked tests
bash code/src/scripts/tests/backend.sh -m unit

# Run only integration-marked tests
bash code/src/scripts/tests/backend.sh -m integration

# Run tests matching a keyword pattern
bash code/src/scripts/tests/backend.sh -k <pattern>

# Run a specific test file
bash code/src/scripts/tests/backend.sh apps/<app>/tests/test_<module>.py

# Stop on first failure
bash code/src/scripts/tests/backend.sh -x

# Coverage report
bash code/src/scripts/tests/backend-coverage.sh

# Django Ninja API integration tests
bash code/src/scripts/tests/api.sh
```

### Backend Lint, Type-check, and Format

```bash
# Lint (ruff)
bash code/src/scripts/syntax/lint.sh --file-type python

# Format check
bash code/src/scripts/syntax/format.sh --file-type python

# Type analysis (basedpyright)
bash code/src/scripts/syntax/check.sh --file-type python

# Auto-fix lint errors
bash code/src/scripts/syntax/lint.sh --fix --file-type python

# Apply formatting
bash code/src/scripts/syntax/format.sh --fix --file-type python
```

---

## Frontend Commands

The frontend is Django-served — there is no separate dev server, no bundler, and no
build step. Templates re-render on every request and Django's `--reload` picks up
Python changes, so **there is nothing to rebuild after a frontend edit**: save the
template and refresh.

### Frontend testing

Frontend tests are pytest tests — templates, django-components, and HTMX partials are
all exercised through the Django test client
(`code/docs/testing/FRONTEND-TESTING.md`):

```bash
# The whole suite, including template and partial tests
bash code/src/scripts/tests/backend.sh

# Just one app's tests
bash code/src/scripts/tests/backend.sh code/src/django/apps/marketing/
```

For the checks that genuinely need a browser — colour contrast, real layout overflow, an HTMX
swap actually landing — use the playwright-python suite. It runs on the host against a live dev
stack:

```bash
bash code/src/scripts/development/server.sh up
bash code/src/scripts/tests/e2e-py.sh
bash code/src/scripts/tests/e2e-py.sh --headed   # watch it drive the browser
```

### CSS lint, format, and the token guards

```bash
# Format CSS (Prettier, host)
bash code/src/scripts/syntax/format.sh --file-type css

# Apply formatting
bash code/src/scripts/syntax/format.sh --fix --file-type css

# Every var(--token) must resolve in the token layer
bash code/src/scripts/audits/css-tokens.sh

# No inline gradients — brand gradients are tokens
bash code/src/scripts/audits/css-gradients.sh
```

---

## Database Management

```bash
# Apply migrations
bash code/src/scripts/database/migrate.sh run

# Create new migrations
bash code/src/scripts/database/migrate.sh make

# Check migration plan without applying
bash code/src/scripts/database/migrate.sh check

# Show unapplied migrations
bash code/src/scripts/database/migrate.sh show

# Open psql shell
bash code/src/scripts/database/shell.sh --psql

# Reset the database
bash code/src/scripts/database/reset.sh
bash code/src/scripts/database/migrate.sh run
bash code/src/scripts/database/manageusers.sh create-superuser
```

---

## Running CI Checks Locally

Run in order before every push — all steps must pass:

```bash
bash code/src/scripts/syntax/lint.sh --file-type python
bash code/src/scripts/syntax/format.sh --file-type python
bash code/src/scripts/syntax/check.sh --file-type python
bash code/src/scripts/tests/backend-coverage.sh
bash code/src/scripts/tests/api.sh
bash code/src/scripts/syntax/lint.sh --file-type markdown
bash code/src/scripts/syntax/format.sh --file-type css
bash code/src/scripts/audits/css-tokens.sh
```

To run the full suite (backend + API) in one go:

```bash
bash code/src/scripts/tests/all.sh --api
```

---

## Common Shortcuts

| Task                         | Command                                                           |
| ---------------------------- | ----------------------------------------------------------------- |
| Start all services           | `bash code/src/scripts/development/server.sh up`                  |
| Stop all services            | `bash code/src/scripts/development/server.sh down`                |
| Tail all logs                | `bash code/src/scripts/development/logs.sh --follow`              |
| Apply migrations             | `bash code/src/scripts/database/migrate.sh run`                   |
| Make migrations              | `bash code/src/scripts/database/migrate.sh make`                  |
| Django shell                 | `bash code/src/scripts/development/shell.sh`                      |
| psql shell                   | `bash code/src/scripts/database/shell.sh --psql`                  |
| Run backend tests            | `bash code/src/scripts/tests/backend.sh`                          |
| Run backend tests (coverage) | `bash code/src/scripts/tests/backend-coverage.sh`                 |
| Run API tests                | `bash code/src/scripts/tests/api.sh`                              |
| Backend lint                 | `bash code/src/scripts/syntax/lint.sh --file-type python`         |
| Backend type-check           | `bash code/src/scripts/syntax/check.sh --file-type python`        |
| Backend format               | `bash code/src/scripts/syntax/format.sh --fix --file-type python` |
| Markdown lint                | `bash code/src/scripts/syntax/lint.sh --file-type markdown`       |
| CSS format                   | `bash code/src/scripts/syntax/format.sh --fix --file-type css`    |
| CSS token guard              | `bash code/src/scripts/audits/css-tokens.sh`                      |
| CSS gradient guard           | `bash code/src/scripts/audits/css-gradients.sh`                   |

---

## Troubleshooting

### Container not running

```bash
# Check container state
bash code/src/scripts/development/server.sh status

# Start the specific service
bash code/src/scripts/development/server.sh up --service backend

# Inspect exit logs
bash code/src/scripts/development/logs.sh --service backend
```

### pnpm lockfile mismatch

`pnpm` carries repo tooling only (markdownlint, Prettier, lefthook, Bruno) — nothing
ships to the browser. If a tooling command fails with `ERR_PNPM_OUTDATED_LOCKFILE`,
reinstall on the host:

```bash
bash code/src/scripts/development/install-frontend.sh
```

To regenerate the lockfile after updating `package.json`:

```bash
bash code/src/scripts/development/install.sh
```

Commit the updated `pnpm-lock.yaml`.

### Migration drift

```bash
bash code/src/scripts/database/migrate.sh run
```

For conflicting migrations (two branches created a migration for the same app), merge them:

```bash
bash code/src/scripts/database/migrate.sh make  # review conflicts manually
```

Always review the merged migration file before committing.

### Port conflicts

```bash
lsof -i :8000
```

Override ports temporarily with a `docker-compose.override.yml` — do not commit host-specific
port overrides to the main `docker-compose.yml`.

### Rebuilding after dependency changes

When `pyproject.toml` or `pnpm-lock.yaml` changes after pulling from main:

```bash
bash code/src/scripts/development/server.sh build --service backend
bash code/src/scripts/development/server.sh up
```
