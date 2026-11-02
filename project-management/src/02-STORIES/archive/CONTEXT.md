# project-management/src/02-STORIES/archive

The frozen end of the story lifecycle. An item lands here only when it is finished, and only
through `00-ASSETS/scripts/pm-archive.sh`, which sets it `Closed`, moves it, and rewrites the
references to its old path in the other PM artefacts and in `GAPS.md` and `DEFERRED.md`. Its story plans move to `../../17-STORY-PLANS/archive/` in the same command. The folder ships empty; a generated project fills it.

## Directory Tree

```text
project-management/src/02-STORIES/archive/
├── CONTEXT.md  ← this file
├── CLAUDE.md   ← operating rules
└── US###.md    ← a `Closed` story — archived from `Completed`, its `## Status history` ending in the `Closed` row
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
