# project-management/src/10-SECURITY/ASSESSMENTS/PLANNING

Pre-implementation security posture assessments — **one baseline per user story**. Each
sets the security baseline for a story before any code is written: scope and methodology,
OWASP A01–A10 and NIST CSF 2.0 coverage targets, STRIDE-tagged findings, and the security
tasks that gate implementation.

## Directory Tree

```text
project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── ASSESSMENT-PLAN-US000-TEMPLATE.md   ← copy this to start a story's baseline
└── ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md  ← one baseline per story
```

## How it works

A baseline is tied to a story, mirroring its post-implementation counterpart in
`../IMPLEMENTATION/`. Copy `ASSESSMENT-PLAN-US000-TEMPLATE.md` to
`ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md` and complete it: the scope, the OWASP A01–A10 and
NIST CSF 2.0 coverage tables, the findings (each tagged STRIDE + OWASP + NIST + severity),
and a checklist of security tasks. Those tasks are then closed — with code evidence — in
the matching `../IMPLEMENTATION/ASSESSMENT-IMPL-US###-*.md` record.

The baseline synthesises the story's STRIDE model in `../../THREAT-MODEL/PLANNING/` and
escalates any CRITICAL/HIGH finding to `../../VULNERABILITIES/PLANNING/`.

## When to write one

- Before implementing any story that touches a security-relevant surface
- When running `project-management/workflows/10-security-checks/`, after wireframes are
  signed off and the GDPR review is complete, before sprint planning

Open CRITICAL/HIGH findings are blockers — sprint planning cannot begin until addressed.

## Cross-references

- `ASSESSMENT-PLAN-US000-TEMPLATE.md` — the per-story baseline template
- `../IMPLEMENTATION/` — the post-implementation records that close these baselines
- `../CONTEXT.md` — the ASSESSMENTS overview and framework tables
- `../../THREAT-MODEL/PLANNING/` — the STRIDE models these baselines synthesise
- `project-management/workflows/10-security-checks/` — the workflow that produces these
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards

**Last Updated**: <%DATE%>
