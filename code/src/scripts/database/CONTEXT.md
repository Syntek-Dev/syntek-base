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
├── _migrate-self-test.sh    ← migrate.sh --self-test's harness; sourced by that arm only
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

| Script                  | Purpose                                                                                                                                                                                                                         |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `migrate.sh`            | Django migrations — `run`, `make`, `show`, `check`, `fake`, `fake-initial`                                                                                                                                                      |
| `_migrate-self-test.sh` | The `migrate.sh --self-test` harness — proves `_lib/posture-guard.sh`, reads its six callers' wiring, and runs them against a fixture repository on a recording `docker` stub; never reaches a daemon. Sourced only by that arm |
| `reset.sh`              | Drop + recreate dev DB, run all migrations, optionally seed fixtures                                                                                                                                                            |
| `seed-dev.sh`           | Idempotently seed dev users (superuser + staff), then each command in `SEED_COMMANDS`; above `development` refuses at exit `4` unless `--force-posture <posture>` names the live posture                                        |
| `backup.sh`             | `pg_dump` to a timestamped file in `reports/` (custom or plain format)                                                                                                                                                          |
| `restore.sh`            | Drop + recreate dev DB and restore from a backup file                                                                                                                                                                           |
| `shell.sh`              | DB shell — Django `dbshell` by default, raw `psql` in the db container with `--psql`                                                                                                                                            |
| `manageusers.sh`        | Create, update, or delete Django users via `manage.py`                                                                                                                                                                          |
| `verify-db-security.sh` | Django system check + PostgreSQL `log_statement` — no RLS or role-permission check                                                                                                                                              |

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

# Seed dev users, then any project seed commands (idempotent — safe to re-run).
# Above development the posture guard refuses (exit 4) unless the run names the live posture:
bash code/src/scripts/database/seed-dev.sh
bash code/src/scripts/database/seed-dev.sh --force-posture <posture>

# Backup the dev database
bash code/src/scripts/database/backup.sh

# Restore from a backup file
bash code/src/scripts/database/restore.sh code/src/scripts/database/reports/backup-2026-04-18T10-00-00Z.dump

# Open a psql session against the dev database
bash code/src/scripts/database/shell.sh --psql
```

## Environment Variables

| Variable        | Default                | Purpose                                                                                                   |
| --------------- | ---------------------- | --------------------------------------------------------------------------------------------------------- |
| `POSTGRES_DB`   | `<%PROJECT_SLUG%>_dev` | Database name — a shell override for backup/restore/reset/verify-db-security; `shell.sh` reads `.env.dev` |
| `POSTGRES_USER` | `<%PROJECT_SLUG%>`     | PostgreSQL user for backup/restore/reset/shell/verify-db-security                                         |
| `SEED_COMMANDS` | _(empty)_              | Space-separated `manage.py` commands `seed-dev.sh` runs                                                   |

`POSTGRES_USER` (the shell's first) and `SEED_COMMANDS` (the file's first — its line wins even when
empty, and only a file with no `SEED_COMMANDS` line falls back to the shell's) are read from
`code/src/docker/.env.dev`, parsed through `_lib/env-file.sh` and never sourced; the defaults match
`docker-compose.dev.yml`. `backup.sh`, `restore.sh`, `reset.sh` and `verify-db-security.sh` never
read `POSTGRES_DB` from `.env.dev`: `docker-compose.dev.yml` fixes the dev database name and ignores
one set there, so they use that literal unless the shell overrides it.

No AI-run script here prints a value from `.env.dev` — `reset.sh --seed` and `seed-dev.sh` close
with the key names (`DJANGO_SUPERUSER_*`, `SEED_STAFF_*`), not the accounts, and a failed upsert or
`SEED_COMMANDS` entry is named by exception class or position with its stderr withheld, then exits
`1`. **`shell.sh` is the exception, by rule:** it is developer-run (denied to an AI in
`.claude/settings.json`, `code/src/scripts/CLAUDE.md`), reads `POSTGRES_DB` and `POSTGRES_USER`
from `.env.dev`, and its `--psql` banner prints both.

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
