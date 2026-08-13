@./CONTEXT.md

# CLAUDE.md — docker/postgres/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the single dev config file — imported above) → this file.

## Purpose (one line)

PostgreSQL 18 tuning for the local development stack — the sole file, `postgresql.dev.conf`;
staging and prod run Postgres on the server, not in Docker.

## How to work here

- **Routing:** database-infra tuning → `database` skill (Opus). This is
  dev-only tuning; do not add staging/prod Postgres config here (those live on the server).
- **Model:** Opus for tuning decisions and a one-line parameter tweak.
- **Concrete steps:** edit `postgresql.dev.conf` → restart the dev `db` service via the
  compose stack → confirm Postgres starts and the value took. **Never run `psql` or
  `docker` ad hoc for schema work — use `code/src/scripts/database/*.sh`.**
- **Definition of done:** dev database starts cleanly with the new setting; `CONTEXT.md`
  updated if a file is added.

## Guardrails

- **Dev-only** — never encode production credentials, memory sizing, or host paths here.
- Database passwords and secrets come from environment variables, never this file.

## Output & naming

- **Hand-written:** `postgresql.dev.conf`.
- The `.dev.` infix marks it dev-scoped; documentation `SCREAMING-SNAKE-CASE.md`.
