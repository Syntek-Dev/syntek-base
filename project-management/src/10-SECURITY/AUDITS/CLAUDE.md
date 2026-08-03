@./CONTEXT.md

# CLAUDE.md — src/10-SECURITY/AUDITS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(frameworks, the reusable checklist, per-story naming — imported above) → this file →
the target `PLANNING/` or `IMPLEMENTATION/` `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

Per-story security code audits — a `PLANNING/` scope + control checklist and an
`IMPLEMENTATION/` findings-and-fixes record — that walk a story's shipped code with
STRIDE, OWASP Top 10, and NIST CSF 2.0 before it merges.

## How to work here

- **Routing:** produced by `project-management/workflows/10-security-checks/`
  (`STEPS.md` + `CHECKLIST.md`) via the `security` agent (Fable). Write a story's
  `PLANNING/` plan before implementing it; write the `IMPLEMENTATION/` record after the
  PR. `docs/SECURITY-GUIDE.md` holds the framework tables; `code/docs/SECURITY.md` is
  the code-side control set being verified.
- **Model:** Fable — scoping an attack surface and judging findings against shipped code
  is substantive; Opus only for a status flip, a date-header bump, or a file move.
- **Concrete steps:** copy `PLANNING/AUDIT-PLAN-US000-TEMPLATE.md` →
  `AUDIT-PLAN-US###-<DESCRIPTOR>.md` → record the scope, run the control checklist, and
  list the testable developer constraints → after the PR, copy
  `IMPLEMENTATION/AUDIT-IMPL-US000-TEMPLATE.md` → return each control with code evidence,
  raise findings mapped to STRIDE/OWASP/NIST, and close every plan constraint.
- **Definition of done:** every finding carries all three framework columns, a severity,
  and a status; every checklist control has a result and evidence; Critical/High
  escalated to `../VULNERABILITIES/`; the `US###` and paired plan↔record cross-linked;
  British English; DD/MM/YYYY.

## Guardrails

- **Documentation only — never code, secrets, credentials, or live exploit payloads.**
  Findings are _recorded_ here and _fixed_ in `code/`; keep both consistent with
  `code/docs/SECURITY.md`.
- **PLANNING/ precedes IMPLEMENTATION/** — the audit scope + checklist must exist before
  the findings record that answers it; the record closes each constraint with evidence.
- **Per story** — one plan and one record per `US###`; do not batch stories into a file.
  Keep the full STRIDE / OWASP / NIST CSF threat-table columns and the whole control
  checklist — do not drop rows.

## Output & naming

- **Hand-written:** every audit plan and record, from the two per-story templates.
- **Generated:** none.
- `AUDIT-PLAN-US###-<DESCRIPTOR>.md` in `PLANNING/`;
  `AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` in `IMPLEMENTATION/`; `<DESCRIPTOR>` in
  `SCREAMING-KEBAB-CASE`; story `US###`; dates DD/MM/YYYY.
