# project-management/src/10-SECURITY/AUDITS

Security **code audits** — a checklist audit of a story's shipped code against the
project's security controls. The base repo ships this as a **per-story scaffold**: a
pre-implementation `PLANNING/` template (the audit scope + checklist to run) and a
post-implementation `IMPLEMENTATION/` template (the findings + verified fixes), each tied
to a user story and mirroring the 09-GDPR split.

## Directory Tree

```text
project-management/src/10-SECURITY/AUDITS/
├── CONTEXT.md                       ← this file
├── CLAUDE.md                        ← operating rules for this folder
├── PLANNING/                        ← pre-implementation audit scope + checklist, one per story
│   ├── CONTEXT.md · CLAUDE.md
│   └── AUDIT-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/                  ← post-implementation findings + verified fixes, one per story
    ├── CONTEXT.md · CLAUDE.md
    └── AUDIT-IMPL-US000-TEMPLATE.md
```

Each phase folder ships one `US000-TEMPLATE.md`; a project copies it per story.

## Frameworks

Every finding an audit raises carries all three classifications plus a severity
(Critical / High / Medium / Low / Info). Guide: `project-management/docs/SECURITY-GUIDE.md`.

| Framework        | What it covers                                         | Abbrevs used      |
| ---------------- | ------------------------------------------------------ | ----------------- |
| **STRIDE**       | Threat category per attack surface                     | S T R I D E       |
| **OWASP Top 10** | Web vulnerability category per finding                 | A01–A10           |
| **NIST CSF 2.0** | Risk-management function most affected by each finding | GV ID PR DE RS RC |

## The reusable checklist

The audit walks the story's code against the project's non-negotiable controls: an
explicit named permission check on every mutation, IDOR / ownership verification on
user-supplied IDs, an explicit `CORS_ALLOWED_ORIGINS` allowlist, `DEBUG=False` outside
local, secrets read from the environment, boundary input validation, and injection
defence. The `PLANNING/` template carries this checklist as the scope to run; the
`IMPLEMENTATION/` template returns each control with a result and code evidence.

## PLANNING/ and IMPLEMENTATION/ — per story

An audit is tied to a user story at both ends: a **plan** before implementation and a
**record** after, mirroring each other.

- `PLANNING/AUDIT-PLAN-US###-*.md` — the audit scope and control checklist for one story:
  the code surface, the anticipated STRIDE threats, and the testable developer constraints.
- `IMPLEMENTATION/AUDIT-IMPL-US###-*.md` — the findings against the shipped code, each
  mapped to OWASP/NIST with a severity, closing every planned constraint with evidence.

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `../CONTEXT.md` — the 10-SECURITY overview and the four categories
- `../VULNERABILITIES/` — where Critical/High audit findings escalate
- `project-management/workflows/10-security-checks/` — the workflow that produces these
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF reference tables
- `code/docs/SECURITY.md` — the coding-layer security controls these audits verify

**Last Updated**: <%DATE%>
