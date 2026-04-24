# code/src/scripts/database

Scripts for Django and PostgreSQL database management in the development environment.
All commands run inside Docker containers via `docker compose exec`.

## Directory Tree

```text
code/src/scripts/database/
├── backup.sh                ← pg_dump the dev database to a backup file
├── CONTEXT.md               ← this file
├── migrate.sh               ← Django migration management (run/make/show/check/fake)
├── reset.sh                 ← drop and recreate the dev database + migrate
├── restore.sh               ← restore the dev database from a backup file
├── shell.sh                 ← Django dbshell or direct psql session
└── reports/                 ← backup files and generated reports (gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script       | Purpose                                                                    |
| ------------ | -------------------------------------------------------------------------- |
| `migrate.sh` | Django migrations — `run`, `make`, `show`, `check`, `fake`, `fake-initial` |
| `reset.sh`   | Drop + recreate dev DB, run all migrations, optionally seed fixtures       |
| `backup.sh`  | `pg_dump` to a timestamped file in `reports/` (custom or plain format)     |
| `restore.sh` | Drop + recreate dev DB and restore from a backup file                      |
| `shell.sh`   | Django `dbshell` (default) or raw `psql` in the db container               |

## Quick Reference

```bash
# Apply all pending migrations
bash code/src/scripts/database/migrate.sh run

# Create migrations for an app
bash code/src/scripts/database/migrate.sh make --app content --name add_slug

# Show migration status
bash code/src/scripts/database/migrate.sh show

# Check for unapplied migrations (exit 1 if any pending)
bash code/src/scripts/database/migrate.sh check

# Full database reset (destructive — asks for confirmation)
bash code/src/scripts/database/reset.sh

# Reset and load fixtures
bash code/src/scripts/database/reset.sh --seed

# Backup the dev database
bash code/src/scripts/database/backup.sh

# Restore from a backup file
bash code/src/scripts/database/restore.sh code/src/scripts/database/reports/backup-2026-04-18T10-00-00Z.dump

# Django dbshell
bash code/src/scripts/database/shell.sh

# Direct psql
bash code/src/scripts/database/shell.sh --psql
```

## Environment Variables

| Variable        | Default            | Purpose                                          |
| --------------- | ------------------ | ------------------------------------------------ |
| `POSTGRES_DB`   | `project_name_dev` | Database name used by backup/restore/reset/shell |
| `POSTGRES_USER` | `postgres`         | PostgreSQL user for backup/restore/reset/shell   |

Set these in your `.env` file or shell if your local config differs from the defaults.

## Compose file

`code/src/docker/docker-compose.dev.yml` — all scripts resolve this automatically.

## Prerequisites

The development stack must be running before any database script will work:

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
