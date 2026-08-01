# ClickUp Story Export

Client-friendly, ClickUp-ready exports — **one `US###-CLIENT.md` per user story**.

> **Generated output — read-only. Do not hand-edit.** These files are produced from the
> source stories in `project-management/src/01-STORIES/`. Change the source story, then
> regenerate — never edit a `US###-CLIENT.md` directly (`README.md` is the only editable file here).

## Read-only enforcement

Only the export script may write these files. Three layers enforce it:

1. **Claude Code** — a `deny` rule in `.claude/settings.json` blocks the Edit/Write tools on
   `US*-CLIENT.md`.
2. **Commits** — a lefthook pre-commit (`precommit-clickup.sh`) regenerates from source and
   re-stages, so any hand-edit is overwritten before it can land.
3. **Working tree** — files are written `0444`; the script flips them writable only to rewrite.

## What each file contains

Only the client-facing fields that go to ClickUp:

- **Title** — `# US### — …`
- **Status · MoSCoW · Story Points** — a single metadata table (mirrors the ClickUp fields)
- **Client Summary** — the plain-English summary
- **User Story** — the "As a … I want … so that …" statement

Acceptance Criteria, Tasks, Dependencies, DB schema, and all technical sections are
**deliberately excluded** — those are internal only and never leave for ClickUp.

## Regenerate

```bash
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh        # all stories
bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh US014  # one story
```

A full run removes stale `US###-CLIENT.md` files (e.g. for deleted stories) and rewrites
the rest. `README.md` is preserved.

## Sync to ClickUp

The `clickup-sync` GitHub workflow (`.github/workflows/clickup-sync.yml`) pushes these files to
ClickUp on push/PR to `main`, `staging`, `dev`, and `testing` (and on manual dispatch). It runs
`project-management/src/00-ASSETS/scripts/sync-clickup.sh`, which upserts one ClickUp task per
story — task status mirrors the story status; the Status/MoSCoW/SP table, Client Summary, and
User Story become the task description.

Re-runs are idempotent: a durable `story -> task id` map at
`project-management/export/clickup-task-map.json` (one level up, outside this folder) prevents
duplicate tasks and is committed back by the workflow.

Required repo secrets to apply (otherwise the workflow runs a harmless **dry run**):

- `CLICKUP_API_TOKEN` — personal/OAuth token
- `CLICKUP_BACKLOG_LIST_ID` — preferred target List id (the Backlog list)
- `CLICKUP_FOLDER_ID` — fallback: if the list id is unreachable, the script resolves the
  `Backlog` list (or the first list) under this folder

Optional: `CLICKUP_STATUS_MAP` (JSON `{repo status -> ClickUp status}`; defaults to identity
since the source stories already use ClickUp's status vocabulary). `CLICKUP_TEAM_ID` and
`CLICKUP_SPACE_ID` are passed through as context but unused by the upsert.

Preview locally without writing to ClickUp:

```bash
bash project-management/src/00-ASSETS/scripts/sync-clickup.sh --dry-run
```
