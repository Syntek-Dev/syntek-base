@./CONTEXT.md

# CLAUDE.md — src/09-SECURITY/AUDITS/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file-naming, what belongs in each record — imported above) → this file.

## Purpose (one line)

Post-implementation security audit records — one per story — walking the shipped code
against the plan's checklist, raising findings mapped to STRIDE / OWASP / NIST CSF, and
closing each planned constraint with evidence.

## How to work here

- **Routing:** written during `project-management/workflows/20-pr-and-review/` (or on
  `workflows/09-security-checks/` verification) for any story that shipped a security
  surface, using the `security` agent (Fable) against the story's plan in
  `../PLANNING/AUDIT-PLAN-US###-*.md` and the shipped code.
- **Model:** Fable — judging findings and control results against shipped code is
  substantive; Opus only for a status flip, a date-header bump, or a file move.
- **Concrete steps:** copy `AUDIT-IMPL-US000-TEMPLATE.md` →
  `AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → open the story's plan → verdict each
  audited file → raise findings with STRIDE + OWASP + NIST columns and a severity →
  return each checklist control with code evidence → close every plan constraint → escalate
  new Critical/High to `../../VULNERABILITIES/IMPLEMENTATION/` → note deferrals and deviations.
- **Definition of done:** every finding fully classified and statused; every control has a
  result and evidence; every plan constraint answered; deviations justified; the `US###`,
  plan-doc link, and date present; British English; DD/MM/YYYY.

## Guardrails

- **Close a constraint only with evidence** — never mark a permission check, IDOR guard,
  or secret-handling control done without pointing at the shipped code (or a `GAPS.md`
  entry) that does it.
- **Documentation only** — no code, secrets, credentials, or live exploit payloads. Keep
  claims consistent with `code/docs/SECURITY.md`.
- Must reference the corresponding `../PLANNING/` plan and reuse its `<DESCRIPTOR>`. Keep
  the full threat-table columns and control checklist. One record per story.

## Output & naming

- **Hand-written:** one `AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per audited story,
  from the template.
- **Generated:** none.
- `<DESCRIPTOR>` in `SCREAMING-KEBAB-CASE`; date `DD-MM-YYYY`; story `US###`.
