@./CONTEXT.md

# CLAUDE.md — src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each review — imported above) → this file.

## Purpose (one line)

Post-implementation STRIDE reviews — one per story, re-assessing each planned threat as
Mitigated / Residual / New against the shipped code and closing the `../PLANNING/` model
with evidence and a sign-off.

## How to work here

- **Routing:** written during `project-management/workflows/10-security-checks/` once a
  story's implementation is complete, using the `security` agent (Fable) against the
  story's model in `../PLANNING/THREAT-MODEL-PLAN-US###-*.md`.
- **Model:** Fable — re-assessing each threat against shipped code is substantive
  judgement, not a mechanical touch; Opus only for a status flip or a rename.
- **Concrete steps:** copy `THREAT-MODEL-IMPL-US000-TEMPLATE.md` →
  `THREAT-MODEL-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the story's plan →
  re-assess every threat (Mitigated / Residual / New) with code evidence → document any
  new threat, escalating CRITICAL/HIGH to `../../VULNERABILITIES/IMPLEMENTATION/` →
  complete the sign-off block.
- **Definition of done:** every planning-phase threat has a final status; a `Mitigated`
  row cites the shipped code; new threats documented and escalated; sign-off present;
  the `US###`, plan-doc link, and date present; British English; DD/MM/YYYY.

## Guardrails

- **Mark a threat Mitigated only with evidence** — never claim a control is in place
  without pointing at the shipped code (or a `GAPS.md` entry for a tracked residual).
- **Never rewrite the planning-phase model** — reviews are additive; the `../PLANNING/`
  model is frozen once the sprint begins. Reuse its exact `<DESCRIPTOR>`, with the
  `IMPL` prefix.
- **Documentation only — no code, secrets, or live exploit payloads.** Keep claims
  consistent with `code/docs/SECURITY.md`.
- One review per story; do not batch multiple stories into a single file.

## Output & naming

- **Hand-written:** one `THREAT-MODEL-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per reviewed
  story, from the template.
- **Generated:** none.
- Filename descriptor `SCREAMING-KEBAB-CASE`; date `DD-MM-YYYY`; story `US###`.
