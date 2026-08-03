# project-management/src/10-SECURITY/AUDITS/IMPLEMENTATION

Post-implementation security audit records — **one per user story**. Each record walks a
story's shipped code against the checklist from its `../PLANNING/` plan, raises any
findings mapped to STRIDE / OWASP / NIST CSF with a severity, and closes each planned
constraint with code evidence.

## Directory Tree

```text
project-management/src/10-SECURITY/AUDITS/IMPLEMENTATION/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── AUDIT-IMPL-US000-TEMPLATE.md        ← copy this to record a story's audit
└── AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md  ← one record per story
```

## File naming

```text
AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md
```

Example: `AUDIT-IMPL-US000-ADMIN-MUTATIONS-01-01-2026.md`. Use the same `<DESCRIPTOR>` as
the corresponding planning plan; `<DESCRIPTOR>` in `SCREAMING-KEBAB-CASE`.

## When to create a file here

Write a record during `project-management/workflows/21-implementation-documentation/` (or on completing
`workflows/10-security-checks/` verification) for any story that shipped a security
surface. Copy `AUDIT-IMPL-US000-TEMPLATE.md`, open the story's plan in
`../PLANNING/AUDIT-PLAN-US###-*.md`, and document the audit outcome.

## What belongs in each record

- Story reference (US###) and date, and a link to the pre-implementation plan
- The files audited and a verdict per file
- Findings, each mapped to STRIDE + OWASP + NIST CSF with a severity and a status
- The plan's control checklist returned with a result and code evidence per control
- A compact OWASP Top 10 coverage pass
- Each plan constraint closed **with evidence**, deferred/residual items, and any deviation
- Newly discovered Critical/High escalated to `../../VULNERABILITIES/IMPLEMENTATION/`

## Cross-references

- `AUDIT-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../PLANNING/` — the pre-implementation plans these records answer
- `../CONTEXT.md` — the AUDITS overview, frameworks, and checklist
- `../../ASSESSMENTS/IMPLEMENTATION/` · `../../VULNERABILITIES/IMPLEMENTATION/` — the assessment this feeds and the escalation target
- `project-management/workflows/21-implementation-documentation/` — where these records are written
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF reference tables
- `code/docs/SECURITY.md` — the coding-layer security controls these audits verify

**Last Updated**: <%DATE%>
