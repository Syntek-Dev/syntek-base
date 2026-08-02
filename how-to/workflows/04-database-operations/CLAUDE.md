@./CONTEXT.md

# CLAUDE.md — workflows/04-database-operations/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file.

## Purpose (one line)

The procedure for **operating** the development database — backup, restore, reset, seed,
user management, security verification — as distinct from changing its schema.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Delegate
  execution to the `database` agent (Opus). Read `CONTEXT.md` first; enter `STEPS.md` only
  when triggered. A schema change is **not** this workflow —
  `code/workflows/03-database-migration/` owns that.
- **Model:** Opus throughout; these are mechanical operations with sharp edges, not design.
- **Concrete steps:** confirm the target database → back up → run the operation → verify
  (`migrate.sh check`, `verify-db-security.sh`, the backend suite) → handle the artefacts.
- **Definition of done:** the `CHECKLIST.md` is satisfied; migrations current; security
  verification passes; no backup left staged, committed, or forgotten on disk.

## Guardrails

- **Back up before anything destructive.** `restore.sh` and `reset.sh` both destroy data;
  `reset.sh` is irreversible.
- **Confirm the target database first.** Inside a worktree the scripts resolve a different
  Compose project — this is exactly how the wrong data gets destroyed.
- **`--yes` is for CI, never for a person.** It removes the last check before a typo lands.
- **Never run `psql`, `pg_dump`, `docker exec`, or `manage.py` directly** — the scripts
  resolve container, credentials, database name, and worktree for you.
- **A dump of real user data is personal data** — retention and handling per
  `project-management/docs/GDPR-GUIDE.md`. A committed backup is a secrets incident.
- Editing these workflow `.md` files: keep each **≤ 300 code lines**.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Generated (never committed):** backups under `code/src/scripts/database/reports/`,
  named `backup-<ISO-timestamp>.<ext>` by the script and gitignored.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`.
