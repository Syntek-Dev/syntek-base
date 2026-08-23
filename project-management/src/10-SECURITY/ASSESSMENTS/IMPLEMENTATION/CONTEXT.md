# project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION

Post-implementation security posture assessments — **one per user story**. Each verifies,
with code evidence, that the controls targeted in the story's `../PLANNING/` baseline
shipped and the posture improved, re-evaluating OWASP A01–A10 and NIST CSF 2.0 coverage
and confirming no regressions.

## Directory Tree

```text
project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── ASSESSMENT-IMPL-US000-TEMPLATE.md   ← copy this to record a story's verification
└── ASSESSMENT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md  ← one record per story
```

## When to create a file here

Write a record during `project-management/workflows/22-implementation-documentation/` (or the
`workflows/10-security-checks/` review step) once a story's code has shipped and the
code-level audit in `../../AUDITS/IMPLEMENTATION/` is complete. Copy
`ASSESSMENT-IMPL-US000-TEMPLATE.md`, open the story's baseline in
`../PLANNING/ASSESSMENT-PLAN-US###-*.md`, and verify each targeted control against the code.

## What belongs in each record

- Story reference (US###), date, and a link to the pre-implementation baseline
- OWASP A01–A10 coverage re-evaluated against shipped code, with evidence per row
- NIST CSF 2.0 function coverage re-evaluated, with evidence
- Findings from this review, each tagged STRIDE + OWASP + NIST + severity
- Each planning finding marked Resolved / Residual / New **with evidence**
- Plan gaps closed or deferred, any justified deviation, and sign-off

## Cross-references

- `ASSESSMENT-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../PLANNING/` — the baselines these records verify
- `../CONTEXT.md` — the ASSESSMENTS overview and framework tables
- `../../AUDITS/IMPLEMENTATION/` · `../../VULNERABILITIES/IMPLEMENTATION/` — the code audit
  consumed and any new CRITICAL/HIGH escalated
- `project-management/workflows/22-implementation-documentation/` — where these records are written
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards

**Last Updated**: <%DATE%>
