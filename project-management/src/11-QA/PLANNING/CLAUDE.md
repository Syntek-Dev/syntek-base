@./CONTEXT.md

# CLAUDE.md — src/11-QA/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(per-story plan structure, when to write one — imported above) → this file.

## Purpose (one line)

Pre-development QA plans — one per user story — deriving test scenarios, accessibility,
and GDPR/security expectations from the wireframe before any code is written.

## How to work here

- **Routing:** plans are produced by `project-management/workflows/11-qa-checks/` (after
  security checks and wireframe sign-off) using the `qa-tester` skill, against a story in
  `../../02-STORIES/` and its wireframe, governed by `project-management/docs/QA-GUIDE.md`.
  Read a story's plan before implementing it.
- **Model:** Fable — deriving scenarios, edge cases, and acceptance-criteria gaps is
  substantive QA reasoning; Opus only for a date-header bump or a rename.
- **Concrete steps:** copy `QA-PLAN-US000-TEMPLATE.md` → `QA-PLAN-US###-<DESCRIPTOR>.md`
  → complete every section (AC gaps, the four scenario tables, accessibility, responsive,
  GDPR/security) → feed each `[OPEN]` AC gap back into `US###.md` → cross-link the `US###`
  and the paired `../IMPLEMENTATION/` review.
- **Definition of done:** the four scenario categories are covered; every `[OPEN]` gap is
  resolved in the story before sprint planning; accessibility and GDPR/security
  constraints named; British English; DD/MM/YYYY dates.

## Guardrails

- **AC gaps gate sprint planning** — do not proceed to a sprint plan while a story carries
  an unresolved `[OPEN]` acceptance-criteria gap; resolve it in `US###.md` first.
- These are **pre-development** plans derived from wireframes and flows — the scenarios
  are _specified_ here and _verified_ against the build in `../IMPLEMENTATION/`; keep them
  consistent with `docs/QA-GUIDE.md`, `code/docs/ACCESSIBILITY.md`, and `code/docs/SECURITY.md`.
- **Documentation only — no source, secrets, or `.env` content.** Automated results and
  manual guides live downstream in `../../17-TESTS/`; do not duplicate them here.
- One plan per story; do not batch multiple stories into one file.

## Output & naming

- **Hand-written:** `QA-PLAN-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Generated:** none.
- Filename descriptor SCREAMING-KEBAB-CASE; story `US###`; dates DD/MM/YYYY.
