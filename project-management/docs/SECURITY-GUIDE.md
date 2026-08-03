---
type: guide
agent: security
skills: [stack-django, stack-htmx-templates]
model: fable
---

# Security Guide — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** fable — Security threat modelling, STRIDE analysis, OWASP review, cross-layer security design
**MCP Servers:** code-review-graph (security pattern analysis, vulnerability detection)

---

## Table of Contents

- [Overview](#overview)
- [When to Run Security Checks](#when-to-run-security-checks)
- [STRIDE Threat Modelling](#stride-threat-modelling)
- [OWASP Top 10](#owasp-top-10)
- [NIST CSF 2.0](#nist-csf-20)
- [Severity Levels](#severity-levels)
- [What to Document](#what-to-document)
- [Security Requirements for Development](#security-requirements-for-development)
- [Shared Security Services](#shared-security-services)
- [Quick Checklist](#quick-checklist)

---

## Overview

Security is reviewed at **design stage** — before code is written. Catching a structural
vulnerability in a wireframe costs nothing to fix; catching it after implementation costs a
sprint. This guide supports the `workflows/10-security-checks` workflow.

Three complementary frameworks are applied at each review:

- **STRIDE** — threat modelling per user flow and wireframe (design stage)
- **OWASP Top 10** — web application vulnerability categories (A01–A10) mapped to each finding
- **NIST CSF 2.0** — risk management function mapped to each finding (Govern, Identify, Protect,
  Detect, Respond, Recover)

All three are applied to the user flows and wireframes produced in `src/05-USER-FLOW/` and
`src/08-WIREFRAMES/`.

---

## When to Run Security Checks

Security checks run once per sprint cycle, after wireframes are signed off and before sprint
plans are written:

```text
08-wireframes  →  09-gdpr-compliance  →  10-security-checks  →  11-qa-checks  →  13-api-design  →  14-decisions  →  15-sprint-plans  →  16-story-plans
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
| **Elevation of Privilege** | E    | Can a lower-privileged user gain access to higher-privileged functions? | Missing role check on admin endpoint; IDOR on object ownership |

### How to apply STRIDE to a wireframe

For each screen or action in the wireframe, ask:

1. **Who triggers this action?** (Authenticated user, admin, anonymous visitor, external service)
2. **What data does it read or write?** (PII, credentials, financial data, audit records)
3. **What are the trust boundaries?** (Frontend → backend, backend → database, backend → third party)
4. **What happens if each STRIDE category is exploited here?**

Document each finding as a row in the threat model table (see [What to Document](#what-to-document)).

---

## OWASP Top 10

Map each finding to the most relevant OWASP category. This makes findings actionable during code
review and provides a standard vocabulary for developers and reviewers.

| ID  | Category                                   | Common in this project                                   |
| --- | ------------------------------------------ | -------------------------------------------------------- |
| A01 | Broken Access Control                      | Missing role checks, IDOR on object IDs                  |
| A02 | Cryptographic Failures                     | PII stored unencrypted, weak session tokens              |
| A03 | Injection                                  | Unparameterised queries, unsanitised Django Ninja inputs |
| A04 | Insecure Design                            | Missing rate limiting, no abuse-case modelling           |
| A05 | Security Misconfiguration                  | `DEBUG=True` in non-local env, permissive CORS           |
| A06 | Vulnerable and Outdated Components         | Unpinned dependencies with known CVEs                    |
| A07 | Identification and Authentication Failures | Weak password policy, no MFA on admin paths              |
| A08 | Software and Data Integrity Failures       | No input validation on imports, unsigned artefacts       |
| A09 | Security Logging and Monitoring Failures   | Missing audit log on destructive actions                 |
| A10 | Server-Side Request Forgery (SSRF)         | Unvalidated URLs passed to backend HTTP clients          |

---

## NIST CSF 2.0

Map each finding to the NIST CSF 2.0 function it falls under. This positions the finding within
the organisation's broader risk management posture and makes remediation responsibilities clear.

| Function     | Abbr | Core question                                               | Design-stage relevance                                  |
| ------------ | ---- | ----------------------------------------------------------- | ------------------------------------------------------- |
| **Govern**   | GV   | Are policies, roles, and risk tolerances defined?           | Missing ownership, undefined access policy              |
| **Identify** | ID   | Do we know what assets, data, and risks exist?              | Undocumented data flows, unclassified PII               |
| **Protect**  | PR   | Are controls in place to limit impact of an incident?       | Missing authentication, no encryption, no rate limiting |
| **Detect**   | DE   | Can we identify when an adverse event has occurred?         | No audit logging, missing monitoring hooks              |
| **Respond**  | RS   | Do we have a plan to act when an incident is detected?      | No incident response path defined for the feature       |
| **Recover**  | RC   | Can we restore normal operation and learn from an incident? | No data recovery plan, no rollback path in the design   |

### How to apply NIST CSF to a finding

For each threat or vulnerability identified during a STRIDE pass, ask:

1. Which CSF function is most affected if this threat is exploited?
2. Is the gap in policy (GV), visibility (ID), controls (PR), monitoring (DE), response (RS), or
   recovery (RC)?
3. Record the function abbreviation alongside the STRIDE category and OWASP mapping in the threat
   table.

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

All security review output goes into `project-management/src/10-SECURITY/`.

### Threat Model — `THREAT-MODEL/<NAME>-DD-MM-YYYY.md`

```markdown
# Threat Model — <Feature Name>

**Date**: DD/MM/YYYY **Sprint**: ## **Reviewed by**: <name>

## Scope

- User flows: <list>
- Wireframes: <list>

## Threat Table

| ID  | STRIDE | OWASP | NIST CSF | Trust Boundary         | Threat Description                         | Severity | Mitigation                                     |
| --- | ------ | ----- | -------- | ---------------------- | ------------------------------------------ | -------- | ---------------------------------------------- |
| T01 | E      | A01   | PR       | Frontend → Backend     | Admin route accessible without role check  | HIGH     | Add `@permission_required('admin')` check      |
| T02 | I      | A01   | PR       | Backend → API Response | User list endpoint returns email addresses | MEDIUM   | Filter PII from list responses; add pagination |
| T03 | D      | A04   | PR       | Anonymous → Login      | No rate limit on login attempts            | HIGH     | Add rate limiting middleware to login endpoint |
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
| "Secure the admin endpoint" | "`/admin/` endpoints require `is_staff=True`; enforced in permission class"   |
| "Rate limit login"          | "Login endpoint: max 5 attempts per IP per minute; 429 returned beyond limit" |

These constraints appear verbatim in the sprint plan's **Developer Constraints** section and as
acceptance criteria in the relevant `US###.md`.

---

## Shared Security Services

Some controls are delivered as a **shared service** that many stories depend on — a
document-protection service, an encryption service, an integration gateway. Three rules
govern how these are planned and reviewed.

### Sequence the shared service before its consumers

A shared security service must land **before or alongside** the stories that call it — never
after. Model the dependency as a chain in the sprint plan so the ordering is explicit:

```text
<US###>  Shared Security Service (Must Have)
  ├── <US###>  consumer story that calls the service
  ├── <US###>  consumer story that calls the service
  └── <US###>  downstream integration (Should / Could Have)
```

Scheduling a consumer ahead of the service it depends on is a blocking planning error.

### Protect generated documents

Any story that emits a downloadable document (invoice, contract, statement) must route it
through the shared document-protection service rather than emitting the raw file:

- **Encrypt and sign** it (e.g. AES-256 encryption plus a PKCS#7 digital signature) so a
  recipient cannot silently alter it and any tampering stays detectable.
- **Load signing keys from environment variables** — never the database or the codebase
  (see `gdpr/COMPLIANCE.md`, Article 32 — Encryption at Rest).

### Integrations blocked on infrastructure

A story that depends on an external service or gateway not yet provisioned is **blocked on
infrastructure** — flag it in the sprint plan and coordinate provisioning separately. Any
outbound integration must define an explicit allow-list of permitted endpoints or flow paths,
never an open passthrough.

---

## Quick Checklist

Before closing the security checks workflow:

- [ ] All user flows and wireframes reviewed against STRIDE
- [ ] OWASP A01–A10 category mapped to each finding
- [ ] NIST CSF 2.0 function mapped to each finding (GV / ID / PR / DE / RS / RC)
- [ ] Threat model document saved in `src/10-SECURITY/THREAT-MODEL/`
- [ ] Assessment document saved in `src/10-SECURITY/ASSESSMENTS/`
- [ ] Individual vulnerability reports created for all `CRITICAL` and `HIGH` findings in `src/10-SECURITY/VULNERABILITIES/`
- [ ] No unresolved `CRITICAL` or `HIGH` findings
- [ ] All `MEDIUM` and `LOW` findings have explicit developer constraints documented
- [ ] Developer constraints added to relevant `US###.md` acceptance criteria
- [ ] Wireframes or user flows updated if structural changes were required
- [ ] Findings ready to feed into `workflows/13-api-design`
