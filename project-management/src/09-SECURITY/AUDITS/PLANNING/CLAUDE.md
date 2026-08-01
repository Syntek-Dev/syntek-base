@./CONTEXT.md

# CLAUDE.md — src/09-SECURITY/AUDITS/PLANNING/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(per-story plan structure, the control checklist, when to write one — imported above) →
this file.

## Purpose (one line)

Pre-implementation security audit plans — one per story — fixing the audit scope, the
control checklist to run, and the testable developer constraints before any code is written.

## How to work here

- **Routing:** plans are produced by `project-management/workflows/09-security-checks/`
  using the `security` agent (Fable), scoping a story in `../../../01-STORIES/` against
  `project-management/docs/SECURITY-GUIDE.md` and `code/docs/SECURITY.md`. Read a story's
  plan before implementing it.
- **Model:** Fable — scoping the attack surface and running STRIDE / OWASP / NIST CSF over
  it is substantive judgement; Opus only for a date-header bump or a rename.
- **Concrete steps:** copy `AUDIT-PLAN-US000-TEMPLATE.md` →
  `AUDIT-PLAN-US###-<DESCRIPTOR>.md` → record the code surface in scope → mark each
  control Applicable / N/A → run a STRIDE pass for anticipated threats → list the blocking
  criteria and testable developer constraints → escalate Critical/High to
  `../../VULNERABILITIES/PLANNING/` → cross-link the `US###` and the assessment.
- **Definition of done:** the audit scope names every file in play; every control is
  marked; each anticipated finding carries STRIDE + OWASP + NIST columns and a severity;
  constraints are testable and carried into the sprint plan; British English; DD/MM/YYYY.

## Guardrails

- **The plan's blocking criteria gate code** — Critical/High constraints must be resolved
  (and closed with evidence in the matching `../IMPLEMENTATION/` record) before the story
  ships. Do not silently drop a constraint.
- **Documentation only** — no code, secrets, credentials, or live exploit payloads.
- Keep the full control checklist and the full STRIDE / OWASP / NIST CSF threat-table
  columns — do not drop rows. One plan per story.

## Output & naming

- **Hand-written:** `AUDIT-PLAN-US###-<DESCRIPTOR>.md`, one per story, from the template.
- **Generated:** none.
- `<DESCRIPTOR>` in `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
