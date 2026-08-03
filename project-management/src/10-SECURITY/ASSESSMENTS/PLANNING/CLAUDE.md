@./CONTEXT.md

# CLAUDE.md — ASSESSMENTS/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(per-story baseline structure, when to write one — imported above) → this file.

## Purpose (one line)

Pre-implementation posture baselines — one per story — mapping OWASP A01–A10 and NIST
CSF 2.0 targets over a STRIDE base before any code is written.

## How to work here

- **Routing:** produced by `project-management/workflows/10-security-checks/` via the
  `security` agent (Fable), synthesising the story's STRIDE model in
  `../../THREAT-MODEL/PLANNING/`. Read a story's baseline before implementing it.
- **Model:** Fable — the posture mapping and severity judgement are substantive; Opus
  only for a date-header bump or a rename.
- **Concrete steps:** copy `ASSESSMENT-PLAN-US000-TEMPLATE.md` →
  `ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md` → complete the OWASP and NIST tables → tag
  every finding STRIDE + OWASP + NIST + severity → list the security tasks that gate
  implementation → escalate CRITICAL/HIGH to `../../VULNERABILITIES/PLANNING/` →
  cross-link the `US###` and the `../IMPLEMENTATION/` counterpart.
- **Definition of done:** OWASP and NIST tables complete; findings carry all framework
  columns and a severity; blocking findings listed with a recommended `US###`; British
  English; DD/MM/YYYY.

## Guardrails

- **Documentation only** — no code, secrets, or live exploit payloads; consistent with
  `code/docs/SECURITY.md`.
- **Blocker discipline:** sprint planning cannot begin while a CRITICAL/HIGH finding
  remains open — surface each one explicitly and escalate it.
- One baseline per story; do not batch stories. Must synthesise the story's
  `../../THREAT-MODEL/PLANNING/` model.

## Output & naming

- **Hand-written:** every baseline, from the template.
- **Generated:** none.
- `ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md`; `<DESCRIPTOR>` in `SCREAMING-KEBAB-CASE`; story
  `US###`; dates DD/MM/YYYY.
