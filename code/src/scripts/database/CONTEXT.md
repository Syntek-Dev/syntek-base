# code/src/scripts/database

Scripts for Django and PostgreSQL database management in the development environment.
All commands run inside Docker containers via `docker compose exec`.

## Directory Tree

```text
code/src/scripts/database/
├── backup.sh                ← pg_dump the dev database to a backup file
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── manageusers.sh           ← create, update, or delete Django users
├── migrate.sh               ← Django migration management (run/make/show/check/fake)
├── reset.sh                 ← drop and recreate the dev database + migrate
├── restore.sh               ← restore the dev database from a backup file
├── seed-dev.sh              ← idempotently seed dev users, then any SEED_COMMANDS
├── shell.sh                 ← DB shell — Django dbshell by default, psql with --psql
├── verify-db-security.sh    ← Django system check + PostgreSQL log_statement
└── reports/                 ← backup files and generated reports (gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script                  | Purpose                                                                               |
| ----------------------- | ------------------------------------------------------------------------------------- |
| `migrate.sh`            | Django migrations — `run`, `make`, `show`, `check`, `fake`, `fake-initial`            |
| `reset.sh`              | Drop + recreate dev DB, run all migrations, optionally seed fixtures                  |
| `seed-dev.sh`           | Idempotently seed dev users (superuser + staff), then each command in `SEED_COMMANDS` |
| `backup.sh`             | `pg_dump` to a timestamped file in `reports/` (custom or plain format)                |
| `restore.sh`            | Drop + recreate dev DB and restore from a backup file                                 |
| `shell.sh`              | DB shell — Django `dbshell` by default, raw `psql` in the db container with `--psql`  |
| `manageusers.sh`        | Create, update, or delete Django users via `manage.py`                                |
| `verify-db-security.sh` | Django system check + PostgreSQL `log_statement` — no RLS or role-permission check    |

## Quick Reference

```bash
# Apply all pending migrations
bash code/src/scripts/database/migrate.sh run

# Create migrations for an app (<app> is a package under code/src/django/apps/)
bash code/src/scripts/database/migrate.sh make --app <app> --name add_slug

# Show migration status
bash code/src/scripts/database/migrate.sh show

# Check for unapplied migrations (exit 1 if any pending)
bash code/src/scripts/database/migrate.sh check

# Full database reset (destructive — asks for confirmation)
bash code/src/scripts/database/reset.sh

# Reset and load fixtures
bash code/src/scripts/database/reset.sh --seed

# Seed dev users, then any project seed commands (idempotent — safe to re-run)
bash code/src/scripts/database/seed-dev.sh

# Backup the dev database
bash code/src/scripts/database/backup.sh

# Restore from a backup file
bash code/src/scripts/database/restore.sh code/src/scripts/database/reports/backup-2026-04-18T10-00-00Z.dump

# Open a psql session against the dev database
bash code/src/scripts/database/shell.sh --psql
```

## Environment Variables

| Variable        | Default                | Purpose                                                 |
| --------------- | ---------------------- | ------------------------------------------------------- |
| `POSTGRES_DB`   | `<%PROJECT_SLUG%>_dev` | Database name used by backup/restore/reset/shell        |
| `POSTGRES_USER` | `<%PROJECT_SLUG%>`     | PostgreSQL user for backup/restore/reset/shell          |
| `SEED_COMMANDS` | _(empty)_              | Space-separated `manage.py` commands `seed-dev.sh` runs |

These are read from `code/src/docker/.env.dev`; the defaults match
`docker-compose.dev.yml`. Set them there if your local config differs.

`POSTGRES_USER` is the cluster's **bootstrap superuser** — the db image creates it with
`initdb --username="$POSTGRES_USER"` — so a `shell.sh --psql` session holds `rolsuper` and
`rolbypassrls`, and nothing sets a read-only default. It is not a scoped session and what it
sees is not what an application user sees.

`shell.sh` without `--psql` runs Django's `dbshell`, which execs a `psql` binary the shipped
django image does not carry (`Dockerfile.dev` installs `libpq-dev`, the client library, not
`postgresql-client`, the binary). The script probes for it and exits `2` naming the cause; add
`postgresql-client` to that image if the project wants the mode.

## Compose file

`code/src/docker/docker-compose.dev.yml` — all scripts resolve this automatically.

## Dependencies

Every script here reaches PostgreSQL through the running dev stack — there is no host-side
database — so none of them does anything useful until it is up:

```bash
bash code/src/scripts/development/server.sh up
```

## Backup Files

Backups are written to `reports/` and gitignored by default. Use `--output-dir` to write
to a persistent location outside the repo if needed.

| Format             | Extension | Restore tool                           |
| ------------------ | --------- | -------------------------------------- |
| `custom` (default) | `.dump`   | `pg_restore` via `restore.sh`          |
| `plain`            | `.sql`    | `psql` via `restore.sh --format plain` |
