@./CONTEXT.md

# CLAUDE.md — src/09-GDPR/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each record — imported above) → this file.

## Purpose (one line)

Post-implementation GDPR verification records — one per PII-handling story, confirming
its GDPR requirements were met in code and closing its `../PLANNING/` plan with evidence.

## How to work here

- **Routing:** written during `project-management/workflows/21-implementation-documentation/` for any
  story that processes personal data, using the `gdpr` agent (Fable) against the
  story's plan in `../PLANNING/GDPR-PLAN-US###-*.md`.
- **Model:** Fable — verifying data flows, lawful bases, retention, and erasure paths
  against shipped code is substantive judgement, not a mechanical touch.
- **Concrete steps:** copy `GDPR-IMPL-US000-TEMPLATE.md` →
  `GDPR-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the story's plan → document data
  flows and lawful bases, retention configured, rights verified, processor DPA status,
  and each plan gap closed with code evidence → note any justified deviation.
- **Definition of done:** every task from the plan is answered; deviations justified;
  the `US###`, plan-doc link, and date are present; British English; DD/MM/YYYY.

## Guardrails

- **Close a plan gap only with evidence** — never mark an erasure path, retention task,
  HMAC companion, or DPA done without pointing at the shipped code (or a `GAPS.md`
  entry) that does it.
- **Documentation only — no real personal data, secrets, or `.env` content.** Keep
  claims consistent with `code/docs/SECURITY.md` and the schema.
- One record per story; do not batch multiple stories into a single file.

## Output & naming

- **Hand-written:** one `GDPR-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per verified story,
  from the template.
- **Generated:** none.
- Filename descriptor `SCREAMING-SNAKE-CASE`; date `DD-MM-YYYY`; story `US###`.
