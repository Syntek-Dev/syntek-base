# project-management/src/10-SECURITY/THREAT-MODEL

STRIDE threat models — **one per user story**. The base repo ships this as a per-story
scaffold: a pre-implementation plan template and a post-implementation review template.
A new project copies the templates once per story that adds a feature surface worth
modelling, mirroring the 09-GDPR split.

## Directory Tree

```text
project-management/src/10-SECURITY/THREAT-MODEL/
├── CONTEXT.md                              ← this file
├── CLAUDE.md                               ← operating rules for this folder
├── PLANNING/                               ← pre-implementation models, one per story
│   ├── CONTEXT.md · CLAUDE.md
│   └── THREAT-MODEL-PLAN-US000-TEMPLATE.md
└── IMPLEMENTATION/                         ← post-implementation reviews, one per story
    ├── CONTEXT.md · CLAUDE.md
    └── THREAT-MODEL-IMPL-US000-TEMPLATE.md
```

## What a threat model records

A scoped STRIDE analysis of one story's feature surface. Each model keeps three parts —
this reusable structure is the value; every project-specific value is a `[EXAMPLE]` row
or `{PLACEHOLDER}` to replace:

- **Scope** — the routes, mutations, queries, models, and components in play, plus a
  four-level severity scale.
- **Trust boundaries** — a `TB1..TBn` table of every point where data crosses a
  privilege level.
- **STRIDE threat table** — one row per threat, mapped to STRIDE, OWASP, NIST CSF, a
  trust boundary, a severity, a status, and a mitigation.

## Frameworks

Three complementary frameworks are applied to every threat:

| Framework        | Role                                                    | Reference                             |
| ---------------- | ------------------------------------------------------- | ------------------------------------- |
| **STRIDE**       | Primary categorisation of each threat                   | `docs/SECURITY-GUIDE.md#stride`       |
| **OWASP Top 10** | Web vulnerability category (A01–A10) per threat         | `docs/SECURITY-GUIDE.md#owasp-top-10` |
| **NIST CSF 2.0** | Risk-management function (GV/ID/PR/DE/RS/RC) per threat | `docs/SECURITY-GUIDE.md#nist-csf-20`  |

## PLANNING ↔ IMPLEMENTATION — per story

Threat modelling is tied to a user story at both ends: a **plan** before implementation
and a **review** after, mirroring each other.

- `PLANNING/THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md` — the pre-implementation model:
  threats identified, severities scored, mitigations proposed (Status = `Proposed`).
  Blocking CRITICAL/HIGH findings escalate to `../VULNERABILITIES/PLANNING/`.
- `IMPLEMENTATION/THREAT-MODEL-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` — the
  post-implementation review: each threat re-assessed as `Mitigated` / `Residual` /
  `New` against the shipped code, plus a sign-off block.

## Cross-references

- `PLANNING/CONTEXT.md` · `IMPLEMENTATION/CONTEXT.md` — the two per-story sub-folders
- `../CONTEXT.md` — the security folder overview and its four categories
- `../ASSESSMENTS/` — the posture assessments that consume these models
- `../VULNERABILITIES/` — where blocking CRITICAL/HIGH findings are escalated
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `project-management/workflows/10-security-checks/` — the workflow that produces these
- `code/docs/SECURITY.md` — the code-side enforcement these models specify

**Last Updated**: <%DATE%>
