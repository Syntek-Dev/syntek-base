@./CONTEXT.md

# CLAUDE.md — 10-SECURITY/VULNERABILITIES/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(finding structure, when to write one, the frameworks — imported above) → this file.

## Purpose (one line)

Pre-implementation vulnerability findings — one per Critical/High vulnerability, each a
sprint blocker classifying the threat and listing the controls the remediation must ship.

## How to work here

- **Routing:** produced by `project-management/workflows/10-security-checks/` using the
  `security` agent (Fable). Each finding originates in a planning-phase audit
  (`../../AUDITS/PLANNING/`) or threat model (`../../THREAT-MODEL/PLANNING/`) and is
  referenced from the assessment in `../../ASSESSMENTS/PLANNING/`. Standards:
  `project-management/docs/SECURITY-GUIDE.md`.
- **Model:** Fable — classifying the threat, judging severity, and specifying controls is
  substantive; Opus only for a status flip or a filename/date touch-up.
- **Concrete steps:** copy `VULN-PLAN-US000-TEMPLATE.md` →
  `VULN-PLAN-US###-<DESCRIPTOR>.md` → complete every section for that finding → ensure a
  remediation `US###` enters the sprint plan (this is a blocker) → cross-link the
  originating audit/threat model and the `US###`.
- **Definition of done:** the finding carries STRIDE + OWASP + NIST + severity; the safe
  PoC is non-working; the required controls are itemised; a remediation story is in the
  plan; British English; DD/MM/YYYY dates.

## Guardrails

- **Sprint blocker** — a finding here means implementation cannot proceed until a
  remediation story is in the plan; do not silently defer.
- **Documentation only** — the fix lives in `code/`, verified against
  `code/docs/SECURITY.md`; no live secrets or exploit payloads in `src/`, only a safe,
  non-working PoC description.
- **One file per vulnerability, per story**; the `<DESCRIPTOR>` carries through to the
  closure in `../IMPLEMENTATION/`.

## Output & naming

- **Hand-written:** `VULN-PLAN-US###-<DESCRIPTOR>.md`, one per finding, from the template.
- **Generated:** none.
- `<DESCRIPTOR>` `SCREAMING-KEBAB-CASE`, naming the vuln class/location; story `US###`;
  dates DD/MM/YYYY.
