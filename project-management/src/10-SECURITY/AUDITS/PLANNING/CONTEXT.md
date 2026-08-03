# project-management/src/10-SECURITY/AUDITS/PLANNING

Pre-implementation security audit plans — **one per user story**. Each plan sets the
audit scope and the control checklist to run against a story's code before it is written:
the code surface, the anticipated STRIDE threats, and the testable developer constraints
the shipped code must satisfy.

## Directory Tree

```text
project-management/src/10-SECURITY/AUDITS/PLANNING/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules for this folder
├── AUDIT-PLAN-US000-TEMPLATE.md   ← copy this to start a story's audit plan
└── AUDIT-PLAN-US###-<DESCRIPTOR>.md  ← one plan per story
```

## How it works

A plan is tied to a story, mirroring its post-implementation counterpart in
`../IMPLEMENTATION/`. Copy `AUDIT-PLAN-US000-TEMPLATE.md` to
`AUDIT-PLAN-US###-<DESCRIPTOR>.md` and complete it: the audit scope (files, resolvers,
migrations in play), the reusable control checklist (permission checks on every mutation,
IDOR / ownership verification, `CORS_ALLOWED_ORIGINS` allowlist, `DEBUG=False`, secrets
via environment, input validation, injection defence), the anticipated STRIDE threats,
and the blocking criteria. Critical/High items escalate to `../../VULNERABILITIES/PLANNING/`
as sprint blockers; each developer constraint is then closed — with evidence — in the
matching `../IMPLEMENTATION/AUDIT-IMPL-US###-*.md` record.

## When to write one

- Before implementing any story with a server-side attack surface
- When running `project-management/workflows/10-security-checks/`, after wireframes are
  signed off and the GDPR review is complete, before sprint planning begins

A story that ships no authenticated mutation or user-input surface records that fact and
completes only the CORS / `DEBUG` / secrets checklist rows.

## Naming

| Pattern                            | Example                               |
| ---------------------------------- | ------------------------------------- |
| `AUDIT-PLAN-US###-<DESCRIPTOR>.md` | `AUDIT-PLAN-US000-ADMIN-MUTATIONS.md` |

`<DESCRIPTOR>` in `SCREAMING-KEBAB-CASE`.

## Cross-references

- `AUDIT-PLAN-US000-TEMPLATE.md` — the per-story audit plan template
- `../IMPLEMENTATION/` — the post-implementation records that close these plans
- `../CONTEXT.md` — the AUDITS overview, frameworks, and checklist
- `../../ASSESSMENTS/PLANNING/` · `../../VULNERABILITIES/PLANNING/` — the assessment this feeds and the escalation target
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF reference tables

**Last Updated**: <%DATE%>
