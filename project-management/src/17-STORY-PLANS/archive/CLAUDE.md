@./CONTEXT.md

# CLAUDE.md — src/17-STORY-PLANS/archive/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `../CONTEXT.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

The frozen archive of `Closed` story plan files, written only by `pm-archive.sh`.

## How to work here

- **Routing:** read here freely; write here never. To archive, run
  `bash project-management/src/00-ASSETS/scripts/pm-archive.sh <ID> --dry-run`, then without
  `--dry-run` once it reports the item eligible. Status meanings and the archive trigger belong to
  the `completion` skill.
- **Model:** Opus — archiving is a mechanical touch through the script.
- **Concrete steps:** dry-run → archive → review the moves and reference rewrites it prints →
  commit them with the regenerated boards.
- **Definition of done:** the item and its plans sit under `archive/`, read `Closed`, and
  `pm-board.sh --check` passes.

## Guardrails

- **Frozen.** `pm-board.sh --check` fails on any change to a file here other than the archive
  rename and the reference-path rewrites `pm-archive.sh` makes. New work about an archived item
  is a new item, never an edit to this one.
- **Never move a file in or out by hand** — the reference rewrites and the board regeneration
  only happen through the script.
- **Look items up by ID across the live folder and this one** — never glob the live folder alone.

## Output & naming

- **Hand-written:** none — every file arrives through `pm-archive.sh`.
- **Generated:** none; the folder's board is one level up.
- Files keep the name they had in the live folder: `<exec-order>-STORY-PLAN-US###-<DESCRIPTOR>.md`.
