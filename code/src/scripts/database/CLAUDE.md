@./CONTEXT.md

# CLAUDE.md — scripts/database/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script inventory, quick reference, env vars — imported above) → this file →
`reports/`.

## Purpose (one line)

Django and PostgreSQL management for the dev environment — migrations, backup /
restore / reset, seeding, user management, dbshell, and DB-security verification —
all run inside Docker via `docker compose exec`.

## How to work here

- **Routing:** these scripts back the `03-database-migration` workflow. **The dev
  stack must be up first** (`development/server.sh up`). Migrations always go through
  `migrate.sh` (`run` / `make` / `show` / `check` / `fake`) — **never**
  `manage.py makemigrations` or `migrate` directly.
- **Model:** Opus to change a script or design a migration workflow and to
  run `migrate.sh run`/`check` or a backup.
- **Concrete steps:** author the model in `django/apps/<name>/` → generate with
  `migrate.sh make --app <name> --name <desc>` → apply with `migrate.sh run` → verify
  no drift with `migrate.sh check` → back up before any destructive `reset.sh`/
  `restore.sh`.
- **Definition of done:** `migrate.sh check` clean (used in CI); destructive commands
  confirmed; `seed-dev.sh` stays idempotent.

## Guardrails

- **`reset.sh` and `restore.sh` are destructive** — they drop and recreate the dev
  database; confirm the target and take a `backup.sh` first.
- **`reset.sh`, `restore.sh`, `seed-dev.sh` and `migrate.sh` call the posture guard** — what it
  permits, refuses or warns at each posture is the contract block in `_lib/posture-guard.sh`,
  and the caller rules are `code/src/scripts/_lib/CLAUDE.md`'s. Never pass `--force-posture` to
  get past a refusal you did not expect. After a change to any guarded script, run
  `bash code/src/scripts/database/migrate.sh --self-test`; it needs no stack.
- **Never hand-edit or rewrite an applied migration** — squash, never rewrite
  history.
- `verify-db-security.sh` guards role permissions — treat a failure as a real
  finding, not noise.
- Secrets and DB credentials (`POSTGRES_DB`/`POSTGRES_USER`) via environment only.

## Output & naming

- **Hand-written:** the `*.sh` scripts here.
- **Generated / gitignored:** `backup-<TIMESTAMP>.dump` / `.sql` under `reports/`;
  use `--output-dir` to persist outside the repo.
- Scripts `kebab-case.sh`; backups timestamped ISO-8601.
