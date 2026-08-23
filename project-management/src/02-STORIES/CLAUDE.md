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
- **Model:** Fable for authoring or re-scoping a story; Opus for mechanical touches —
  status flips, version-header bumps, a rename.
- **Concrete steps:** copy `US000-TEMPLATE.md` → next free `US###` number (gaps are
  intentional, never backfilled) → write role / goal / benefit / acceptance criteria →
  set the authoritative `**Epic:**` line → satisfy the workflow `CHECKLIST.md`.
- **Definition of done:** story named `US###.md`, carries an `**Epic:**` line, acceptance
  criteria present; cross-links to `../18-TESTS/US###-*` and `../11-QA/PLANNING/QA-PLAN-US###-*`
  where they exist; British English throughout.

## Guardrails

- **Numeric gaps are deliberate** — only files that exist are listed; never renumber to
  close a gap.
- **The `**Epic:**` line is authoritative** — every story carries one; it drives any
  downstream epic grouping.
- **Documentation only** — no code, secrets, or `.env` content; obligations are
  _specified_ here and _enforced_ in `code/`.
- Every new directory needs a `CONTEXT.md`.

## Output & naming

- **Hand-written:** `US###.md` stories and `US000-TEMPLATE.md`.
- **Template:** `US000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- Stories `US###.md` — 3-digit zero-padded (`US043.md`); dates DD/MM/YYYY.
