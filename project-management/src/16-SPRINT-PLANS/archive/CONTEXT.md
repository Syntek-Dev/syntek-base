# project-management/src/16-SPRINT-PLANS/archive

The frozen end of the sprint plan lifecycle. An item lands here only when it is finished, and only
through `00-ASSETS/scripts/pm-archive.sh`, which sets it `Closed`, moves it, and rewrites the
references to its old path in the other PM artefacts and in `GAPS.md` and `DEFERRED.md`. It carries no status; the board shows its sprint's. The folder ships empty; a generated project fills it.

## Directory Tree

```text
project-management/src/16-SPRINT-PLANS/archive/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
└── ##-SPRINT-PLAN-##.md  ← the plan of a `Closed` sprint, moved with its sprint
```

## Why a sub-folder rather than a status alone

A `Closed` item stops being work, and leaving it beside live ones makes every listing, numbering
step and agent read wade through history. Moving it keeps the live folder the current backlog
while the record stays one level down, still found by ID — every script resolves an ID across
the folder and this `archive/`, so nothing that cites it breaks.

## Cross-references

- `../CONTEXT.md` — the live folder and its board, `../*-BOARD.md`, which lists archived items
  under Closed
- `../../00-ASSETS/scripts/CONTEXT.md` — `pm-archive.sh` and `pm-board.sh`
- `.claude/skills/completion/SKILL.md` — the status vocabulary and when an item is ready to
  archive
