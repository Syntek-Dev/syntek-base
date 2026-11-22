# project-management/src/15-DECISIONS/archive

The frozen end of the decision record's life. A record lands here only when it has reached its end
state — `Superseded` or `Deprecated` — and only through `00-ASSETS/scripts/pm-archive.sh`, which moves it, leaves its
status as it was, and rewrites the references to its old path in the other PM artefacts and in
`GAPS.md` and `DEFERRED.md`. The folder ships empty; a generated project fills it.

## Directory Tree

```text
project-management/src/15-DECISIONS/archive/
├── CONTEXT.md  ← this file
├── CLAUDE.md   ← operating rules
└── ADR-US###-<DECISION>-DD-MM-YYYY.md ← an ADR read `Superseded` or `Deprecated` — the status it was archived from
```

## Why a sub-folder rather than a status alone

A replaced or withdrawn decision stops being one a plan may rest on, and leaving it beside the live ones makes every reader weigh it again. Moving it keeps the live folder current while the record stays one level down, still found
by ID — every script resolves an ID across the folder and this `archive/`, so nothing that cites it
breaks.

## Cross-references

- `../CONTEXT.md` — the live folder and its board, `../DECISIONS-BOARD.md`, which lists archived records
  under the status they were archived from
- `../../00-ASSETS/scripts/CONTEXT.md` — `pm-archive.sh` and `pm-board.sh`
- `.claude/skills/completion/SKILL.md` — the status vocabulary and when a record is ready to
  archive
