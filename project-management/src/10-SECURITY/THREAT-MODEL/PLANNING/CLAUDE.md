@./CONTEXT.md

# CLAUDE.md — src/10-SECURITY/THREAT-MODEL/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(per-story model structure, when to write one — imported above) → this file.

## Purpose (one line)

Pre-implementation STRIDE threat models — one per story — identifying threats across the
story's trust boundaries and proposing a mitigation and a severity for each, before any
code is written.

## How to work here

- **Routing:** models are produced by `project-management/workflows/10-security-checks/`
  using the `security` agent (Fable), analysing a story in `../../../02-STORIES/` and its
  `../../../05-USER-FLOW/` and `../../../08-WIREFRAMES/` artefacts against
  `project-management/docs/SECURITY-GUIDE.md`. Read a story's model before implementing it.
- **Model:** Fable — STRIDE analysis (trust boundaries, threat identification, severity
  scoring) is substantive judgement; Opus only for a date-header bump or a rename.
- **Concrete steps:** copy `THREAT-MODEL-PLAN-US000-TEMPLATE.md` →
  `THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md` → complete scope, the `TB1..TBn` table, and
  the STRIDE threat table → escalate blocking CRITICAL/HIGH findings to
  `../../VULNERABILITIES/PLANNING/` → cross-link the `US###` and from
  `../../ASSESSMENTS/PLANNING/`.
- **Definition of done:** every threat carries STRIDE + OWASP + NIST columns, a severity,
  and a proposed mitigation; blocking findings escalated; British English; DD/MM/YYYY.

## Guardrails

- **Blocking CRITICAL/HIGH findings gate the story** — each must become an acceptance
  criterion or developer constraint and be re-assessed (with evidence) in the matching
  `../IMPLEMENTATION/` review before the story's code ships. Do not silently drop a threat.
- **Frozen once the sprint begins** — do not edit a planning model after story writing
  starts; the re-assessment belongs in `../IMPLEMENTATION/`.
- **Documentation only — never code, secrets, or live exploit payloads.** STRIDE is the
  primary categorisation; never omit the OWASP or NIST CSF column.
- One model per story; do not batch multiple stories into one file.

## Output & naming

- **Hand-written:** `THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Generated:** none.
- Filename descriptor `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
