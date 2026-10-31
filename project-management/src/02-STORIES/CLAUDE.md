@./CONTEXT.md

# CLAUDE.md — src/02-STORIES/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(story format + naming, imported above) → this file.

## Purpose (one line)

The user-story store — one `US###.md` per story (role, goal, benefit, acceptance
criteria) plus the `US000-TEMPLATE.md` scaffold.

## How to work here

- **Routing:** never write a story free-hand — start from
  `project-management/workflows/02-story-creation/` (`STEPS.md` + `CHECKLIST.md`), or
  drive it with `story`. Slicing the written stories into sprints belongs to `sprint`.
- **Model:** Opus throughout — authoring or re-scoping a story is substantive judgement; status
  flips, version-header bumps and renames are mechanical touches.
- **Concrete steps:** copy `US000-TEMPLATE.md` → next free `US###` number (gaps are
  intentional, never backfilled) → write role / goal / benefit / acceptance criteria →
  set the authoritative `**Epic:**` line → satisfy the workflow `CHECKLIST.md` →
  `bash project-management/src/00-ASSETS/scripts/pm-board.sh --write`.
- **Status changes:** `**Status:** <Title>` with an optional `— <note>` tail the parser
  ignores; every transition appends a `## Status history` row. The vocabulary, transitions and
  completion clock are the `completion` skill's — never restated here.
- **Definition of done:** story named `US###.md`, carries an `**Epic:**` line, acceptance
  criteria present; cross-links to `../18-TESTS/MANUAL/US###-*`, `../18-TESTS/AUTOMATED/US###-*`
  and `../11-QA/PLANNING/QA-PLAN-US###-*` where they exist; British English throughout.

## Guardrails

- **Numeric gaps are deliberate** — only files that exist are listed; never renumber to
  close a gap.
- **The `**Epic:**` line is authoritative** — every story carries one; it drives any
  downstream epic grouping.
- **`Closed` is the archive step, never a hand edit.** `pm-archive.sh US###` sets it, only from
  `Completed`, and moves the story and its plan into `archive/`.
- **`archive/` is frozen.** `pm-board.sh --check` fails on any edit there other than the
  archive rename and `pm-archive.sh`'s reference rewrites. Look a story up by ID across this
  folder and `archive/`; take the next number across both.
- **Documentation only** — no code, secrets, or `.env` content; obligations are
  _specified_ here and _enforced_ in `code/`.
- Every new directory needs a `CONTEXT.md`.

## Output & naming

- **Hand-written:** `US###.md` stories and `US000-TEMPLATE.md`.
- **Hand-written:** `CUT-PLAN.md` — the cut plan (which map slice becomes which story, in what
  order). Not a story, and not an index row. A generated project receives it blank from
  `.copier/CUT-PLAN.md`; the template's own copy never ships.
- **Template:** `US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** `STORIES-BOARD.md` (committed) and `stories-board.json` / `.html`
  (gitignored), by `pm-board.sh --write` — never hand-edit. `archive/` is written only by
  `pm-archive.sh`.
- Stories `US###.md` — 3-digit zero-padded (`US043.md`); dates DD/MM/YYYY.
