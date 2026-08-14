---
type: guide
skills: [setup, global-workflow]
model: opus
---

# Development Workflow — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Language**: British English (en_GB)
**Timezone**: <%TIMEZONE%>
**Claude Model:** opus — First-time setup, Docker Compose dev commands, env vars, troubleshooting

> All development commands run through shell scripts in `code/src/scripts/**/*.sh`.
> Never invoke `docker compose`, `python`, `pytest`, or `pnpm` directly — always use the scripts.

---

## Overview

| Layer                 | Technology                                                                                                                                     | Container | Dev URL                                           |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------- | ------------------------------------------------- |
| **App (Django ASGI)** | Django 6.0.6, Python 3.14, Django Ninja API; django-components + Django templates + HTMX + Alpine + vanilla token CSS                          | `backend` | http://dev.<%PROJECT_SLUG%>.localhost:8000        |
| **Admin area**        | The `/admin/` surface — Django templates + django-components + HTMX + Alpine, same as every other surface (Django admin itself is `/control/`) | `django`  | http://dev.<%PROJECT_SLUG%>.localhost:8000/admin/ |
| **Database**          | PostgreSQL 18                                                                                                                                  | `db`      | `localhost:5432` (internal)                       |
| **Cache**             | Valkey (latest stable)                                                                                                                         | `valkey`  | `localhost:6379` (internal)                       |

One app process family (Django ASGI) serves the public site, the `/admin/` surface, and the
Django Ninja API at `http://dev.<%PROJECT_SLUG%>.localhost:8000/api/`. Django admin is mounted at
`/control/`, never `/admin/`.

---

## Prerequisites

- **Docker** (latest stable)
- **Docker Compose** v2.x (bundled with Docker Desktop, or `docker compose` plugin for Linux)
- **Git** 2.x
- **SSH key** registered with `git.<%PRIMARY_DOMAIN%>`

No host-level Python, Node.js, or Rust installation required — all runtimes live inside containers.

---

## Getting Started

```bash
# 1. Clone
git clone git@git.<%PRIMARY_DOMAIN%>:<%ORG_SLUG%>/<%PROJECT_SLUG%>.git
cd <%PROJECT_SLUG%>

# 2. Run installer (copies .env.dev.example → .env.dev, installs dependencies)
bash code/src/scripts/development/install.sh

# 3. Fill in CHANGE_ME values in code/src/docker/.env.dev
#    Set seed credentials: DJANGO_SUPERUSER_*, SEED_STAFF_*

# 4. Build and start
bash code/src/scripts/development/server.sh up --build

# 5. Reset database and seed dev accounts
bash code/src/scripts/database/reset.sh --seed --yes
```

`--seed` creates both accounts from `.env.dev` automatically. See **Dev Accounts** below.

To create accounts interactively instead (e.g. for a custom password):

```bash
bash code/src/scripts/database/manageusers.sh create-superuser
bash code/src/scripts/database/manageusers.sh create-staff --email your@email.com --username you
```

Verify at http://dev.<%PROJECT_SLUG%>.localhost:8000 and the API at
http://dev.<%PROJECT_SLUG%>.localhost:8000/api/.

---

## Dev Accounts

`reset.sh --seed` creates two accounts from `.env.dev` every time. Credentials are set
under the `Seed users` block in `.env.dev` (gitignored — never committed).

| Account    | Username    | Role                      | Purpose                                   |
| ---------- | ----------- | ------------------------- | ----------------------------------------- |
| Superuser  | `superuser` | `is_superuser + is_staff` | Full admin access, all module permissions |
| Staff user | `staffuser` | `is_staff` only           | Test ABAC permission boundaries           |

The superuser password is set via `DJANGO_SUPERUSER_PASSWORD` in `.env.dev`.
The staff user password is set via `SEED_STAFF_PASSWORD` in `.env.dev`.

Both accounts are idempotent — running `reset.sh --seed` again after a reset recreates them;
running it on an existing database skips accounts that already exist.

---

## Daily Workflow

```bash
# Pull latest (feature branches always cut from and target `testing` — see GIT-GUIDE.md)
git checkout testing && git pull origin testing

# Create feature branch (us### must match a story ID)
git checkout -b us###/short-description

# Start containers
bash code/src/scripts/development/server.sh up

# Apply any new migrations from pulled changes
bash code/src/scripts/database/migrate.sh run
```

Write a failing test before implementing the feature (TDD). For all test and quality commands
see `how-to/docs/CLI-TOOLING.md`.

---

## Code Quality

Run before every commit — CI enforces the same checks.

```bash
# Backend
bash code/src/scripts/syntax/lint.sh --file-type python
bash code/src/scripts/syntax/format.sh --file-type python
bash code/src/scripts/syntax/check.sh --file-type python
bash code/src/scripts/tests/backend.sh

# CSS
bash code/src/scripts/syntax/format.sh --file-type css

# Markdown (all .md files must declare code block languages — MD040)
bash code/src/scripts/syntax/lint.sh --file-type markdown
```

---

## Git Workflow

### Branch naming

```text
us###/short-description    (e.g. us001/user-registration)
fix/short-description
chore/short-description
```

### Commit messages (Conventional Commits)

```text
<type>(<scope>): <subject>

Types: feat, fix, refactor, test, docs, chore, perf, style
Subject line under 72 characters, imperative mood.
Body explains why, not what. Reference story: Closes US-042
```

### Pull requests

Every PR must have: a clear title, description (what + why), story ID reference, testing steps,
and passing CI. Full branching rules: `project-management/docs/GIT-GUIDE.md`.

---

## Environment Variables

Configuration is provided via `.env` at the project root. Never commit this file — only
`.env.example` is tracked.

```bash
# Seed users (reset.sh --seed reads these from the container environment)
DJANGO_SUPERUSER_USERNAME=superuser
DJANGO_SUPERUSER_EMAIL=superuser@example.com
DJANGO_SUPERUSER_PASSWORD=CHANGE_ME
SEED_STAFF_USERNAME=staffuser
SEED_STAFF_EMAIL=staffuser@example.com
SEED_STAFF_PASSWORD=CHANGE_ME

# Django
SECRET_KEY=CHANGE_ME           # generate: python -c "import secrets; print(secrets.token_urlsafe(50))"
DEBUG=true
ENCRYPTION_KEY=CHANGE_ME       # generate: python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
PASSWORD_PEPPER=CHANGE_ME      # generate: python -c "import secrets; print(secrets.token_hex(32))"

# Database
POSTGRES_USER=<%PROJECT_SLUG%>
POSTGRES_PASSWORD=CHANGE_ME

# Media (Cloudinary public delivery)
CLOUDINARY_CLOUD_NAME=CHANGE_ME

# Trusted proxies — REMOTE_ADDR values allowed to set X-Forwarded-For /
# X-Real-IP. Leave UNSET in local dev (no Nginx → REMOTE_ADDR is already the
# client IP). In staging/production set to the Nginx container IP(s), comma-separated.
TRUSTED_PROXIES=
```

Full var list with generation commands: `code/src/docker/.env.dev.example`.

Non-negotiable rules: never hardcode secrets; `DJANGO_DEBUG=False` in all non-local environments;
`CORS_ALLOWED_ORIGINS` must be an explicit allowlist; off-local `TRUSTED_PROXIES` must list the
Nginx container IP(s) (default `[]` = no X-Forwarded-For trust — fail-safe).

---

## Script Catalogue

| Script                           | Purpose                                                    |
| -------------------------------- | ---------------------------------------------------------- |
| `development/install.sh`         | Install project dependencies                               |
| `development/server.sh`          | Start / stop / rebuild the dev stack                       |
| `development/shell.sh`           | Open a shell inside a container                            |
| `development/logs.sh`            | Tail container logs                                        |
| `development/new-django-app.sh`  | Scaffold a new Django app                                  |
| `development/new-django-view.sh` | Scaffold a new Django-served page (view + template + URL)  |
| `database/migrate.sh`            | Run Django migrations                                      |
| `database/reset.sh`              | Reset the database; `--seed` also creates dev accounts     |
| `database/shell.sh`              | Open a psql shell                                          |
| `database/backup.sh`             | Back up the database                                       |
| `database/restore.sh`            | Restore a database backup                                  |
| `database/manageusers.sh`        | Create superusers and manage DB users                      |
| `database/verify-db-security.sh` | Verify DB security settings (RLS, roles)                   |
| `tests/backend.sh`               | Run backend tests                                          |
| `tests/backend-coverage.sh`      | Backend tests with coverage report                         |
| `tests/api.sh`                   | Run Django Ninja API integration tests                     |
| `tests/all.sh`                   | Run all tests (backend, `--api` adds Bruno)                |
| `tests/mutmut.sh`                | Python mutation testing (local only)                       |
| `tests/open-coverage.sh`         | Open the backend coverage HTML report                      |
| `syntax/lint.sh`                 | Lint code (Python, Markdown)                               |
| `syntax/check.sh`                | Type-check Python (basedpyright)                           |
| `syntax/format.sh`               | Format code (ruff, Prettier)                               |
| `audits/cloc.sh`                 | Source file length — warn at 750, fail at 800              |
| `audits/docs-length.sh`          | Instructional `.md` length — fail over 300 cloc code lines |
| `audits/stubs.sh`                | Audit type stubs                                           |

If a required operation has no script, raise a task to create one — do not run the underlying
tool directly.

---

## Troubleshooting

### Container won't start

```bash
bash code/src/scripts/development/logs.sh --service backend
bash code/src/scripts/development/server.sh up --build --service backend
```

### Database connection errors

Ensure `POSTGRES_HOST=db` (the Docker Compose service name, not `localhost`). Check container
health with `server.sh status`. If the `db` container is still initialising:

```bash
bash code/src/scripts/development/server.sh restart --service backend
```

### Migration errors

```bash
bash code/src/scripts/database/migrate.sh show
bash code/src/scripts/database/migrate.sh run
```

For a clean local reset (destroys all data — never run in production):

```bash
bash code/src/scripts/database/reset.sh --seed
```

### Stale image after a dependency change

```bash
bash code/src/scripts/development/server.sh up --build --service django
```

### Port already in use

```bash
sudo lsof -i :8000
```

Use a `docker-compose.override.yml` for host-specific port overrides — do not commit to
`docker-compose.yml`.

### Docker data-root location

If your Docker daemon is configured with a custom `--data-root` (images, containers, and volumes
stored off the default `/var/lib/docker`), and Docker appears to lose images after a reboot,
check that the backing disk is mounted before starting the stack:

```bash
docker info | grep "Docker Root Dir"
```
