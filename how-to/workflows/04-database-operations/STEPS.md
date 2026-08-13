---
workflow: 04-database-operations
phase: operate
skills: [database, global-workflow]
model: opus
---

# Database Operations — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                                 |
| ---- | ----------------------------------------------------------------------- |
| 1    | **Reference guides** → DEVELOPMENT.md (services, environment variables) |
| 2–3  | **Reference guides** → CLI-TOOLING.md (the database script flags)       |
| 4    | **Cross-layer references** → `code/docs/DATABASE.md`                    |
| 5    | **Cross-layer references** → `project-management/docs/GDPR-GUIDE.md`    |

Pick the branch that matches your task. Step 1 always runs; Step 5 always closes.

---

## Step 1 — Confirm what you are about to touch

> **Model:** opus

Know which database the scripts will reach before you run anything destructive. Inside a
worktree the scripts resolve a _different_ Compose project — that is the point of
`_lib/worktree-detect.sh`, and it is also how people destroy the wrong data.

```bash
bash code/src/scripts/development/server.sh status
bash code/src/scripts/database/shell.sh --command "SELECT current_database();"
```

If the stack is not running, start it (`server.sh up`) — every script below runs inside the
container and will fail fast otherwise.

---

## Step 2 — Back up (always, before anything in Step 3)

> **Model:** opus

```bash
bash code/src/scripts/database/backup.sh
bash code/src/scripts/database/backup.sh --output-dir /path/to/keep --format plain
```

Default output is `code/src/scripts/database/reports/backup-<timestamp>.<ext>`, which is
**gitignored** — a backup you intend to keep must be written or moved somewhere durable.
Use `--format custom` (the default) for a restore through `pg_restore`; `--format plain` for
a readable SQL file you intend to inspect or diff.

Confirm the file exists and is non-empty before continuing. A zero-byte backup is the
failure mode that only reveals itself when you need it.

---

## Step 3 — Run the operation

> **↳ New dispatch:** `general-purpose` · **Skill:** `database` · **Model:** opus

**Restore from a backup** — destructive; replaces current content:

```bash
bash code/src/scripts/database/restore.sh <backup-file> --format custom
```

**Reset to a clean database** — destructive; drops, recreates, and migrates:

```bash
bash code/src/scripts/database/reset.sh          # empty
bash code/src/scripts/database/reset.sh --seed   # then load seed data
```

**Load seed data** — dev accounts from `.env.dev`, then whatever `SEED_COMMANDS` names:

```bash
bash code/src/scripts/database/seed-dev.sh
```

**Create or promote a user:**

```bash
bash code/src/scripts/database/manageusers.sh create-superuser
bash code/src/scripts/database/manageusers.sh create-staff --email <e> --username <u>
```

Answer the confirmation prompt by hand. **Do not reach for `--yes`** — it exists so CI can
run unattended, and using it interactively removes the one check standing between a typo
and the wrong database.

---

## Step 4 — Verify the result

> **Model:** opus

Never assume the operation did what it said:

```bash
bash code/src/scripts/database/migrate.sh check          # no unapplied migrations
bash code/src/scripts/database/verify-db-security.sh     # config + log_statement
bash code/src/scripts/database/shell.sh                  # spot-check the data
```

After a restore or reset, run the test suite before trusting the environment:
`bash code/src/scripts/tests/backend.sh` (workflow `05-testing-and-coverage`).

---

## Step 5 — Handle the artefacts

> **Model:** opus

- **Delete backups you no longer need.** They sit in a gitignored directory, which makes
  them easy to forget and easy to leave on disk indefinitely.
- **A dump of real user data is personal data.** It inherits every retention and handling
  obligation in `project-management/docs/GDPR-GUIDE.md` — do not copy one onto a laptop,
  into a ticket, or anywhere outside its lawful basis.
- **Never commit a backup.** If one lands in a commit, it is a secrets incident, not a
  tidy-up: follow `project-management/docs/SECURITY-GUIDE.md`.
- If the operation revealed a schema problem rather than a data problem, stop here and
  enter `code/workflows/03-database-migration/`.
