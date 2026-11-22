@./CONTEXT.md

# CLAUDE.md — src/20-FINDINGS/archive/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `../CONTEXT.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

The frozen archive of findings records that reached `Resolved`, written only by `pm-archive.sh`.
<!-- Resolved from 19/11/2026; it read Triaged before. -->

## How to work here

- **Routing:** read here freely; write here never. To archive, run
  `bash project-management/src/00-ASSETS/scripts/pm-archive.sh <ID> --dry-run` — the ID is the
  filename stem — then without `--dry-run` once it reports the record eligible. Status meanings
  and the archive trigger belong to the `completion` skill.
- **Model:** Opus — archiving is a mechanical touch through the script.
- **Concrete steps:** dry-run → archive → review the move and the reference rewrites it prints →
  commit them with the regenerated board.
- **Definition of done:** the record sits under `archive/` with its end status unchanged, and
  `pm-board.sh --check` passes.

## Guardrails

- **Frozen.** `pm-board.sh --check` fails on any change to a file here other than the archive
  rename and the reference-path rewrites `pm-archive.sh` makes. New work about an archived record
  is a new record, never an edit to this one.
- **Never move a file in or out by hand** — the reference rewrites and the board regeneration
  only happen through the script.
- **Look records up by ID across the live folder and this one** — never glob the live folder alone.

## Output & naming

- **Hand-written:** none — every file arrives through `pm-archive.sh`.
- **Generated:** none; the folder's board is one level up.
- Files keep the name they had in the live folder: `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (or the story-less fallback).
