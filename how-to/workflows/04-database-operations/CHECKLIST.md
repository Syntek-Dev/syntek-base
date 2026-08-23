---
workflow: 04-database-operations
phase: operate
skills: [database, global-workflow]
model: opus
---

# Database Operations — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Reference guides** (CLI-TOOLING.md, DEVELOPMENT.md) · **Cross-layer references** (`code/docs/DATABASE.md`, `project-management/docs/GDPR-GUIDE.md`).

## Before

- [ ] Confirmed **which** database the scripts resolve to — worktrees reach a different Compose project · _opus_
- [ ] Dev stack running; `server.sh status` clean · _opus_
- [ ] A fresh backup exists and is **non-empty** · _opus_
- [ ] Task confirmed as state-only — a schema change belongs in `code/workflows/03-database-migration/` · _opus_

## During

- [ ] Every command ran through `code/src/scripts/database/*.sh` — no raw `psql`, `pg_dump`, `docker exec`, or `manage.py` · _opus_
- [ ] Destructive confirmations answered by hand; `--yes` not used interactively · _opus_
- [ ] Seed run understood: dev accounts from `.env.dev`, plus whatever `SEED_COMMANDS` names (nothing at baseline) · _opus_

## After

- [ ] `migrate.sh check` reports no unapplied migrations · _opus_
- [ ] `verify-db-security.sh` passes · _opus_
- [ ] Backend suite green against the restored/reset database · _opus_
- [ ] Backups no longer needed have been deleted; any kept backup moved somewhere durable · _opus_
- [ ] No backup file staged or committed · _opus_
- [ ] Any dump of real user data handled under `project-management/docs/GDPR-GUIDE.md` · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`

---

## Definition of Done

- [ ] The database holds the state the operation was run to produce, and that was checked by
      querying it — not inferred from the script exiting 0 · _opus_
- [ ] `migrate.sh check` and `verify-db-security.sh` both clean against that state · _opus_
- [ ] Backend suite green, so the environment is trustworthy for the next piece of work · _opus_
- [ ] No dump left on disk that nobody has decided to keep, and none in the index · _opus_
- [ ] Schema was not touched — anything that turned out to need one is now an entry into
      `code/workflows/03-database-migration/`, not a hand-applied DDL statement · _opus_
