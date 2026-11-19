# project-management/src/20-FINDINGS/archive

The frozen end of the findings record's life. A record lands here only when it has reached its end
state — `Resolved` — and only through `00-ASSETS/scripts/pm-archive.sh`, which moves it, leaves its
status as it was, and rewrites the references to its old path in the other PM artefacts and in
`GAPS.md` and `DEFERRED.md`. The folder ships empty; a generated project fills it.
<!-- End state Resolved from 19/11/2026; it read Triaged before. -->

## Directory Tree

```text
project-management/src/20-FINDINGS/archive/
├── CONTEXT.md  ← this file
├── CLAUDE.md   ← operating rules
└── FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md ← a findings record read `Resolved` — every row dispositioned when it was archived
```

## Why a sub-folder rather than a status alone

A resolved record has handed every row on to its route, and leaving it beside the open ones makes the next plan re-read what is already carried. Moving it keeps the live folder current while the record stays one level down, still found
by ID — every script resolves an ID across the folder and this `archive/`, so nothing that cites it
breaks.

## Cross-references

- `../CONTEXT.md` — the live folder and its board, `../FINDINGS-BOARD.md`, which lists archived records
  under the status they were archived from
- `../../00-ASSETS/scripts/CONTEXT.md` — `pm-archive.sh` and `pm-board.sh`
- `.claude/skills/completion/SKILL.md` — the status vocabulary and when a record is ready to
  archive
