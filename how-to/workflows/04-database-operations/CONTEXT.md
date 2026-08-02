# Workflow: Database Operations

## Directory Tree

```text
how-to/workflows/04-database-operations/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow for **operating** the development database — taking a backup, restoring
one, resetting to a clean state, loading seed data, creating users, or verifying the
security configuration.

**This is not the migration workflow.** Changing the schema — new models, altered fields,
anything producing a migration file — is `code/workflows/03-database-migration/`. This one
never changes what the database _is_, only what state it holds.

| You want to                          | Go to                                              |
| ------------------------------------ | -------------------------------------------------- |
| Add a model or alter a field         | `code/workflows/03-database-migration/`            |
| Take or restore a backup             | here                                               |
| Get back to a clean dev database     | here                                               |
| Design the schema in the first place | `project-management/workflows/03-database-schema/` |

## Prerequisites

- [ ] The dev stack is running (`code/src/scripts/development/server.sh`)
- [ ] `code/src/docker/.env.dev` exists and holds the dev credentials
- [ ] For a restore: the backup file is present and you know its format

## Key concepts

- **Every operation runs through a script.** Never `psql`, `pg_dump`, `docker exec`, or
  `manage.py` directly — the scripts resolve the container, the credentials and the
  database name for you, and they behave correctly inside a worktree.
- **Three scripts are destructive** and say so in their own headers: `restore.sh` replaces
  the database content, `reset.sh` drops and recreates it, and `manageusers.sh` can
  overwrite a password. Each takes an explicit confirmation; `--yes` skips the prompt and
  exists for CI, not for you.
- **Back up before anything destructive.** `backup.sh` is cheap; a lost afternoon is not.
- **Seeding is project-defined.** `seed-dev.sh` creates the dev accounts from `.env.dev`,
  then runs whatever `SEED_COMMANDS` names — **nothing at baseline**. A generated project
  fills that in.
- **Backups land in `code/src/scripts/database/reports/`**, which is gitignored. A backup
  you want to keep must be moved somewhere durable — and a production dump is personal
  data (see the guardrails).

## Cross-references

### Hard gates — read before executing Step 1

- `code/src/scripts/database/CONTEXT.md` — the scripts, their flags, and their exit codes
- `code/docs/DATABASE.md` — the data-layer rules any state change must not violate

### Soft references — consult during execution

- `how-to/docs/CLI-TOOLING.md` — the command reference for every dev operation
- `how-to/docs/DEVELOPMENT.md` — environment variables and Compose services
- `code/workflows/03-database-migration/` — when the schema itself must change
- `project-management/docs/GDPR-GUIDE.md` — obligations that attach to real user data
