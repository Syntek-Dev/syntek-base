@./CONTEXT.md

# CLAUDE.md — src/11-QA/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each review — imported above) → this file.

## Purpose (one line)

Post-implementation QA reviews — one per user story, verifying its `../PLANNING/` QA plan
against the shipped code, recording deviations and new edge cases, and carrying the
sign-off before merge.

## How to work here

- **Routing:** written during `project-management/workflows/22-implementation-documentation/`, once the
  feature is implemented and before the story closes, using the `qa-tester` skill (Fable)
  against the story's plan in `../PLANNING/QA-PLAN-US###-*.md`; governed by
  `project-management/docs/QA-GUIDE.md`.
- **Model:** Fable — verifying scenarios, deviations, and edge cases against a running
  build is substantive judgement, not a mechanical touch; Opus only to file, rename, or
  date-stamp.
- **Concrete steps:** copy `QA-IMPL-US000-TEMPLATE.md` →
  `QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the story's plan → mark each
  HP / ES / EC / PA scenario Pass / Fail / Deviation with evidence → close the plan's
  acceptance-criteria gaps → record deviations, new edge cases, and a11y / GDPR
  observations → complete the sign-off checklist.
- **Definition of done:** every plan scenario addressed or justified; deviations recorded;
  the `US###`, plan-doc link, sprint, and date present; sign-off checklist complete;
  British English; DD/MM/YYYY.

## Guardrails

- **Verify against the real implementation, never restate the plan** — mark a scenario
  Pass only with evidence (a test name, file, or observed behaviour). If the plan is
  missing, flag it; do not invent one.
- **The sign-off blocks the merge** — an unresolved Fail or an unjustified deviation is a
  blocker, not a footnote.
- One review per story; do not batch multiple stories into one file.
- **Documentation only — no source, secrets, or `.env` content.** Keep accessibility,
  GDPR, and security claims consistent with `project-management/docs/QA-GUIDE.md` and
  `code/docs/SECURITY.md`.
- Downstream automated status and manual guides live in `../../18-TESTS/`; code-review
  notes in `../../19-REVIEWS/` — do not duplicate them here.

## Output & naming

- **Hand-written:** one `QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per reviewed story,
  from the template.
- **Generated:** none.
- Filename descriptor `SCREAMING-KEBAB-CASE`; date `DD-MM-YYYY`; story `US###`.
