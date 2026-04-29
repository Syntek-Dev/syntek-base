# Security Guide — project-name

> **Agent hints — Model:** Opus · **MCP:** `docfork` + `context7` (OWASP, STRIDE)

**Last Updated**: 28/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Table of Contents

- [Overview](#overview)
- [When to Run Security Checks](#when-to-run-security-checks)
- [STRIDE Threat Modelling](#stride-threat-modelling)
- [Severity Levels](#severity-levels)
- [What to Document](#what-to-document)
- [Security Requirements for Development](#security-requirements-for-development)
- [Quick Checklist](#quick-checklist)

---

## Overview

Security is reviewed at **design stage** — before code is written. Catching a structural
vulnerability in a wireframe costs nothing to fix; catching it after implementation costs a
sprint. This guide supports the `workflows/09-security-checks` workflow.

The framework used is **STRIDE**, applied to the user flows and wireframes produced in
`src/04-USER-FLOW/` and `src/07-WIREFRAMES/`.

---

## When to Run Security Checks

Security checks run once per sprint cycle, after wireframes are signed off and before sprint
plans are written:

```text
07-wireframes  →  08-gdpr-compliance  →  09-security-checks  →  10-qa-checks  →  11-sprint-plans
```

Any `HIGH` or `CRITICAL` findings must be resolved (by updating the design or adding explicit
developer constraints) before proceeding to sprint planning.

---

## STRIDE Threat Modelling

STRIDE is a classification scheme for threat categories. For each user flow and wireframe, work
through each category and determine whether the threat applies.

| Category                   | Abbr | Core question                                                           | Example in context                                             |
| -------------------------- | ---- | ----------------------------------------------------------------------- | -------------------------------------------------------------- |
| **Spoofing**               | S    | Can an attacker impersonate a legitimate user or system?                | JWT not validated on a protected route; no CSRF token          |
| **Tampering**              | T    | Can data be modified in transit or at rest without detection?           | Missing input validation; no DB integrity constraints          |
| **Repudiation**            | R    | Can an actor deny performing an action without audit trail?             | No audit log on a destructive action; no event timestamping    |
| **Information Disclosure** | I    | Can sensitive data be exposed to unauthorised parties?                  | PII returned in list endpoints; verbose error messages         |
| **Denial of Service**      | D    | Can an attacker degrade or block availability?                          | No rate limiting on login; no pagination on list endpoints     |
| **Elevation of Privilege** | E    | Can a lower-privileged user gain access to higher-privileged functions? | Missing role check on admin mutation; IDOR on object ownership |

### How to apply STRIDE to a wireframe

For each screen or action in the wireframe, ask:

1. **Who triggers this action?** (Authenticated user, admin, anonymous visitor, external service)
2. **What data does it read or write?** (PII, credentials, financial data, audit records)
3. **What are the trust boundaries?** (Frontend → backend, backend → database, backend → third party)
4. **What happens if each STRIDE category is exploited here?**

Document each finding as a row in the threat model table (see [What to Document](#what-to-document)).

---

## Severity Levels

| Severity   | Meaning                                                                   | Action required before sprint planning                 |
| ---------- | ------------------------------------------------------------------------- | ------------------------------------------------------ |
| `CRITICAL` | Exploitable without authentication; data exfiltration or full compromise  | **Blocking** — design must change                      |
| `HIGH`     | Exploitable with low-privilege access; significant data or integrity risk | **Blocking** — design must change                      |
| `MEDIUM`   | Exploitable under specific conditions; moderate impact                    | Document mitigation requirements in the sprint plan    |
| `LOW`      | Minor impact; defence-in-depth measure                                    | Document and address in the relevant development phase |
| `INFO`     | Observation with no immediate exploitability                              | Log for awareness; no action required                  |

Only `CRITICAL` and `HIGH` block sprint planning. `MEDIUM` and below must be documented and
addressed during development, with explicit acceptance criteria added to the relevant story.

---

## What to Document

All security review output goes into `project-management/src/09-SECURITY/`.

### Threat Model — `THREAT-MODEL/<NAME>-DD-MM-YYYY.md`

```markdown
# Threat Model — <Feature Name>

**Date**: DD/MM/YYYY **Sprint**: ## **Reviewed by**: <name>

## Scope

- User flows: <list>
- Wireframes: <list>

## Threat Table

| ID  | Category | Trust Boundary         | Threat Description                         | Severity | Mitigation                                     |
| --- | -------- | ---------------------- | ------------------------------------------ | -------- | ---------------------------------------------- |
| T01 | E        | Frontend → Backend     | Admin route accessible without role check  | HIGH     | Add `@permission_required('admin')` check      |
| T02 | I        | Backend → API Response | User list endpoint returns email addresses | MEDIUM   | Filter PII from list responses; add pagination |
| T03 | D        | Anonymous → Login      | No rate limit on login attempts            | HIGH     | Add rate limiting middleware to login endpoint |
```

### Assessment — `ASSESSMENTS/ASSESSMENT-<NAME>-DD-MM-YYYY.md`

```markdown
# Security Assessment — <Feature Name>

**Date**: DD/MM/YYYY **Sprint**: ## **Reviewed by**: <name>

## Summary

<One paragraph: what was reviewed, what was found, overall posture>

## Findings

### CRITICAL / HIGH (blocking)

- **T01** — <description> — resolved by: <design change made>

### MEDIUM (addressed in development)

- **T02** — <description> — developer constraint: <what the developer must do>

## Design Changes Made

<List any wireframes or user flows updated as a result of this review>

## Developer Constraints

<Explicit requirements carried forward into the sprint plan>
```

---

## Security Requirements for Development

Security findings feed forward into the sprint plan and story acceptance criteria. For each
non-`INFO` finding, the developer constraint must be explicit and testable:

| Instead of…                 | Write…                                                                        |
| --------------------------- | ----------------------------------------------------------------------------- |
| "Add proper validation"     | "All `user_id` parameters verified against `request.user` — no IDOR"          |
| "Handle errors properly"    | "Error responses return generic messages; no stack traces in production"      |
| "Secure the admin endpoint" | "`/admin/` mutations require `is_staff=True`; enforced in permission class"   |
| "Rate limit login"          | "Login endpoint: max 5 attempts per IP per minute; 429 returned beyond limit" |

These constraints appear verbatim in the sprint plan's **Developer Constraints** section and as
acceptance criteria in the relevant `US###.md`.

---

## Quick Checklist

Before closing the security checks workflow:

- [ ] All user flows and wireframes reviewed against STRIDE
- [ ] Threat model document saved in `src/09-SECURITY/THREAT-MODEL/`
- [ ] Assessment document saved in `src/09-SECURITY/ASSESSMENTS/`
- [ ] No unresolved `CRITICAL` or `HIGH` findings
- [ ] All `MEDIUM` and `LOW` findings have explicit developer constraints documented
- [ ] Developer constraints added to relevant `US###.md` acceptance criteria
- [ ] Wireframes or user flows updated if structural changes were required
- [ ] Findings ready to feed into `workflows/11-sprint-plans`
