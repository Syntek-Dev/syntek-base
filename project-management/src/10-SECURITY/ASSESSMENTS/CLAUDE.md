@./CONTEXT.md

# CLAUDE.md — 10-SECURITY/ASSESSMENTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(frameworks, per-story split, severity levels — imported above) → this file → the
target `PLANNING/` or `IMPLEMENTATION/` `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

Broad security **posture assessments** — one per story — mapping OWASP A01–A10 and NIST
CSF 2.0 coverage over a STRIDE base, with a `PLANNING/` baseline and an `IMPLEMENTATION/`
verification.

## How to work here

- **Routing:** produced by `project-management/workflows/10-security-checks/`
  (`STEPS.md` + `CHECKLIST.md`) via the `security` skill (Fable), against
  `project-management/docs/SECURITY-GUIDE.md`. Write a story's `PLANNING/` baseline
  before implementing it; the `IMPLEMENTATION/` review follows once the code ships.
- **Model:** Fable — mapping posture across OWASP/NIST and judging finding severity is
  substantive analysis; Opus only for a date-header bump, a status flip, or a rename.
- **Concrete steps:** copy the phase folder's `US000-TEMPLATE.md` →
  `ASSESSMENT-<PLAN|IMPL>-US###-<DESCRIPTOR>.md` → complete the OWASP A01–A10 and NIST
  CSF tables → tag every finding with STRIDE + OWASP + NIST + severity → list the
  security tasks that gate implementation (plan) or close them with code evidence
  (implementation) → cross-link the `US###`, the paired artefact, and the STRIDE model.
- **Definition of done:** OWASP and NIST tables complete; every finding carries STRIDE +
  OWASP + NIST + severity; CRITICAL/HIGH escalated to `../VULNERABILITIES/`; the `US###`
  and paired-artefact link present; British English; DD/MM/YYYY.

## Guardrails

- **Documentation only — never code, secrets, credentials, or live exploit payloads.**
  Obligations are _specified_ here and _enforced_ in `code/`; keep them consistent with
  `code/docs/SECURITY.md` (permission checks, IDOR, CORS, `DEBUG`).
- **PLANNING precedes IMPLEMENTATION** — the baseline must exist before its review; the
  `IMPLEMENTATION/` record closes the plan with evidence and marks each finding
  Resolved / Residual / New.
- **Per story** — one assessment per `US###`; do not batch multiple stories into one file.
- **Severity discipline** — classify each finding CRITICAL / HIGH / MEDIUM / LOW per the
  `CONTEXT.md` criteria; CRITICAL/HIGH are blockers and must be escalated.

## Output & naming

- **Hand-written:** every assessment, from the per-story templates.
- **Generated:** none here.
- `ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md` in `PLANNING/`;
  `ASSESSMENT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` in `IMPLEMENTATION/`; `<DESCRIPTOR>`
  in `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
