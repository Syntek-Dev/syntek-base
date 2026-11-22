# project-management/src/21-BUGS/archive

The frozen end of the bug record's life. A record lands here only when it has reached its end
state — `Verified` — and only through `00-ASSETS/scripts/pm-archive.sh`, which moves it, leaves its
status as it was, and rewrites the references to its old path in the other PM artefacts and in
`GAPS.md` and `DEFERRED.md`. The folder ships empty; a generated project fills it.

## Directory Tree

```text
project-management/src/21-BUGS/archive/
├── CONTEXT.md  ← this file
├── CLAUDE.md   ← operating rules
└── BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md ← a bug report read `Verified` — its fix seen to hold when it was archived
```

## Why a sub-folder rather than a status alone

A verified defect stops being work, and leaving it beside the open ones makes every listing and triage pass wade through history. Moving it keeps the live folder current while the record stays one level down, still found
by ID — every script resolves an ID across the folder and this `archive/`, so nothing that cites it
breaks.

## Cross-references

- `../CONTEXT.md` — the live folder and its board, `../BUGS-BOARD.md`, which lists archived records
  under the status they were archived from
- `../../00-ASSETS/scripts/CONTEXT.md` — `pm-archive.sh` and `pm-board.sh`
- `.claude/skills/completion/SKILL.md` — the status vocabulary and when a record is ready to
  archive
