@./CONTEXT.md

# CLAUDE.md — workflows/11-qa-checks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The design-stage QA workflow — derive test scenarios, edge cases, and error states
from signed-off wireframes and user flows, producing a `QA-US###-*.md` plan per story
in `src/11-QA/` before any code is written.

## How to work here

- **Routing:** run `STEPS.md` in order; drive scenario generation with the
  `qa-tester` agent (Fable). Prerequisites: signed-off wireframes and
  completed security checks (`workflows/10-security-checks`). QA planning is pre-code,
  so **no hard safety gate applies** — `docs/QA-GUIDE.md` governs scenario format.
- **Model:** Fable for scenario design and edge-case discovery; Opus for
  mechanical touches (status flips, moving a file).
- **Concrete steps:** read `docs/QA-GUIDE.md` → map scenarios against
  `src/02-STORIES/` and wireframes → cover the security findings from
  `src/10-SECURITY/` and WCAG 2.2 AA checks → write `QA-US###-<DESCRIPTION>.md` into
  `src/11-QA/PLANNING/` → feed edge cases back into story acceptance criteria → satisfy
  `CHECKLIST.md`.
- **Definition of done:** every in-scope story has a QA plan; edge cases and error
  states fed into acceptance criteria; checklist satisfied; next step is
  `workflows/15-sprint-plans/`.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Documentation workflow — no code, no test files here.** QA plans written here are
  the _basis_ for the automated/manual tests written later in `code/`.
- **Scenarios are derived from designs, not from completed code** — never defer QA to
  post-implementation.
- WCAG 2.2 AA (`code/docs/ACCESSIBILITY.md`) and the coverage floors in
  `code/docs/TESTING.md` are the downstream targets QA scenarios must feed.
- Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; QA plans under `src/11-QA/PLANNING/`
  as `QA-US###-<DESCRIPTION>.md`, linked to their `US###`.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
