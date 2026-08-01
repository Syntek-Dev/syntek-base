@./CONTEXT.md

# CLAUDE.md — 09-SECURITY/VULNERABILITIES/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the frameworks, the per-story PLANNING/IMPLEMENTATION split — imported above) → this
file → the target `PLANNING/` or `IMPLEMENTATION/` `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

Individual Critical/High vulnerability records — a `PLANNING/` finding that blocks the
sprint and an `IMPLEMENTATION/` closure that proves the fix, one pair per vulnerability,
each tied to a user story.

## How to work here

- **Routing:** produced by `project-management/workflows/09-security-checks/` using the
  `security` agent (Fable). Every finding originates in a sibling category — an audit
  under `../AUDITS/` or a threat model under `../THREAT-MODEL/`. Standards:
  `project-management/docs/SECURITY-GUIDE.md`.
- **Model:** Fable for the finding and the closure write-up (severity, framework
  mapping, controls, verification are substantive judgement); Opus only for a status
  flip or a filename/date touch-up.
- **Concrete steps:** copy `PLANNING/VULN-PLAN-US000-TEMPLATE.md` →
  `PLANNING/VULN-PLAN-US###-<DESCRIPTOR>.md`, fill every section (classification,
  description, affected code, safe PoC, controls) → ensure a remediation `US###` enters
  the sprint plan (this is a blocker) → after the fix, copy
  `IMPLEMENTATION/VULN-IMPL-US000-TEMPLATE.md` →
  `IMPLEMENTATION/VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, close each control with
  code evidence, and flip the planning record to Resolved.
- **Definition of done:** the finding carries STRIDE + OWASP + NIST + severity; the plan
  and closure share the same `<DESCRIPTOR>` and `US###`; every control is closed with a
  code reference; British English; DD/MM/YYYY dates.

## Guardrails

- **Documentation only** — the fix lives in `code/`, verified against
  `code/docs/SECURITY.md`; this folder raises and closes the finding, it never patches.
- **PLANNING/ precedes IMPLEMENTATION/** — the finding must exist before the closure;
  the closure answers the plan with evidence and never marks a control done without
  pointing at the shipped code (or a `GAPS.md` / story owner) that satisfies it.
- **One file per vulnerability, per story** — never bundle findings; the same
  `<DESCRIPTOR>` carries from the plan to the closure.
- **Only safe-to-document PoCs** — a non-working description, never a live exploit
  payload, secret, or token.
- Every Critical/High from an audit, assessment, or threat model **must** produce a
  record here.

## Output & naming

- **Hand-written:** `PLANNING/VULN-PLAN-US###-<DESCRIPTOR>.md` and
  `IMPLEMENTATION/VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, from the templates.
- **Generated:** none.
- `<DESCRIPTOR>` `SCREAMING-KEBAB-CASE`, naming the vuln class/location (e.g.
  `IDOR-CROSS-CLIENT`, `STORED-XSS-KWARGS`); story `US###`; dates DD/MM/YYYY.
