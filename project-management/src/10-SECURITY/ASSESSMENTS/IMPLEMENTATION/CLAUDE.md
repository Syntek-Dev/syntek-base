@./CONTEXT.md

# CLAUDE.md — ASSESSMENTS/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each record — imported above) → this file.

## Purpose (one line)

Post-implementation posture records — one per story — re-evaluating OWASP A01–A10 and
NIST CSF 2.0 coverage against shipped code and closing the `../PLANNING/` baseline with
evidence.

## How to work here

- **Routing:** written during `project-management/workflows/22-implementation-documentation/` (or the
  `workflows/10-security-checks/` review step) via the `security` skill (Fable), once the
  code audit in `../../AUDITS/IMPLEMENTATION/` is complete, against the story's
  `../PLANNING/ASSESSMENT-PLAN-US###-*.md` baseline.
- **Model:** Fable — verifying OWASP/NIST coverage and finding status against shipped
  code is substantive judgement; Opus only for a status flip or a file move.
- **Concrete steps:** copy `ASSESSMENT-IMPL-US000-TEMPLATE.md` →
  `ASSESSMENT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the baseline →
  re-evaluate the OWASP and NIST tables with code evidence → mark each planning finding
  Resolved / Residual / New → escalate any new CRITICAL/HIGH to
  `../../VULNERABILITIES/IMPLEMENTATION/` → note any justified deviation → sign off.
- **Definition of done:** every OWASP/NIST row has a status and evidence; every baseline
  finding has an updated status; new findings escalated; reviewer and date recorded;
  British English; DD/MM/YYYY.

## Guardrails

- **Close a finding only with evidence** — never mark a control Resolved/PASS without
  pointing at the shipped code (file · symbol), or a `GAPS.md` entry, that does it.
- **Documentation only** — no code, secrets, or live exploit payloads; consistent with
  `code/docs/SECURITY.md`.
- Must reference the corresponding `../PLANNING/` baseline and the
  `../../AUDITS/IMPLEMENTATION/` run it consumes. Reuse the baseline's `<DESCRIPTOR>`.
- One record per story; do not batch stories into a single file.

## Output & naming

- **Hand-written:** every review record, from the template.
- **Generated:** none.
- `ASSESSMENT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; `<DESCRIPTOR>` in
  `SCREAMING-KEBAB-CASE`; date `DD-MM-YYYY`; story `US###`.
