@./CONTEXT.md

# CLAUDE.md — src/09-GDPR/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(per-story plan structure, when to write one — imported above) → this file.

## Purpose (one line)

Pre-implementation GDPR plans — one per PII-handling story — analysing personal data,
lawful basis, retention, rights impact, and processors before any code is written.

## How to work here

- **Routing:** plans are produced by `project-management/workflows/09-gdpr-compliance/`
  using the `gdpr` agent (Fable), analysing a story in `../../02-STORIES/` against
  `project-management/docs/GDPR-GUIDE.md`. Read a story's plan before implementing it.
- **Model:** Fable — per-story gap analysis (lawful basis, retention, rights paths) is
  substantive judgement; Opus only for a date-header bump or a rename.
- **Concrete steps:** copy `GDPR-PLAN-US000-TEMPLATE.md` →
  `GDPR-PLAN-US###-<DESCRIPTOR>.md` → complete every section for that story → list the
  GDPR tasks that gate implementation → cross-link the `US###` and the registers.
- **Definition of done:** the plan names each field's lawful basis, retention period,
  and erasure path; open GDPR tasks are itemised as a checklist; British English;
  DD/MM/YYYY.

## Guardrails

- **The plan's GDPR-task checklist gates code** — its open items must be resolved (and
  closed with evidence in the matching `../IMPLEMENTATION/` record) before the story's
  PII code ships. Do not silently drop a task.
- These are _analysis_ documents — the fixes land in `code/` and roll up into the live
  registers one level up; keep all three consistent with `code/docs/SECURITY.md`.
- **Documentation only — never real personal data, secrets, or `.env` content.**
- One plan per story; do not batch multiple stories into one file. Every processing
  activity needs a lawful basis and a retention period — no orphaned PII.

## Output & naming

- **Hand-written:** `GDPR-PLAN-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Generated:** none.
- Filename descriptor `SCREAMING-SNAKE-CASE`; story `US###`; dates DD/MM/YYYY.
