# project-management/src/09-SECURITY/THREAT-MODEL/PLANNING

Pre-implementation STRIDE threat models — **one per user story**. Each model analyses a
single story's feature surface against `project-management/docs/SECURITY-GUIDE.md` before
any code is written: the scope, the trust boundaries, and a STRIDE threat table with a
proposed mitigation and a severity per threat.

## Directory Tree

```text
project-management/src/09-SECURITY/THREAT-MODEL/PLANNING/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── THREAT-MODEL-PLAN-US000-TEMPLATE.md ← copy this to start a story's threat model
└── THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md  ← one model per story under review
```

## How it works

A model is tied to a story, mirroring its post-implementation review in
`../IMPLEMENTATION/`. Copy `THREAT-MODEL-PLAN-US000-TEMPLATE.md` to
`THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md` and complete it: the scope and severity scale,
the `TB1..TBn` trust-boundary table, and the STRIDE threat table — each threat mapped to
STRIDE, an OWASP Top 10 category, a NIST CSF 2.0 function, a trust boundary, a severity,
and a proposed mitigation (Status = `Proposed`). Blocking CRITICAL/HIGH findings drive
the story's acceptance criteria and are escalated to `../../VULNERABILITIES/PLANNING/`.
Those threats are then re-assessed — with code evidence — in the matching
`../IMPLEMENTATION/THREAT-MODEL-IMPL-US###-*.md` review.

## When to write one

- Before implementing a story that adds a feature surface worth modelling
- When running `project-management/workflows/09-security-checks/`, after wireframes are
  signed off and the GDPR review is complete, before sprint planning

## Frameworks

STRIDE (primary), OWASP Top 10 (A01–A10), and NIST CSF 2.0 (GV/ID/PR/DE/RS/RC) are
applied to every threat. Full guidance: `project-management/docs/SECURITY-GUIDE.md`.

## Cross-references

- `THREAT-MODEL-PLAN-US000-TEMPLATE.md` — the per-story plan template
- `../IMPLEMENTATION/` — the post-implementation reviews that close these models
- `../CONTEXT.md` — the threat-model overview and the three frameworks
- `../../ASSESSMENTS/PLANNING/` — assessments that consume these models
- `../../VULNERABILITIES/PLANNING/` — escalated CRITICAL/HIGH findings
- `project-management/workflows/09-security-checks/` — the workflow that produces these

**Last Updated**: <%DATE%>
