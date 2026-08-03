# Security Audit Plan — US000 {STORY TITLE}

_Template — copy to `AUDIT-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]` row
and `{PLACEHOLDER}` with this story's own analysis, and delete this note once populated.
This is the **pre-implementation** audit scope and checklist for a single story; its
post-implementation counterpart is `../IMPLEMENTATION/AUDIT-IMPL-US000-TEMPLATE.md`._

| Field              | Value                                               |
| ------------------ | --------------------------------------------------- |
| **Story**          | US### — {short title}                               |
| **Date**           | {DD/MM/YYYY}                                        |
| **Author**         | {name / agent}                                      |
| **Sprint**         | SPRINT-## — {name}                                  |
| **Status**         | Draft / Reviewed / Signed off                       |
| **Attack surface** | {one line: the endpoints or pages this story ships} |

> If the story ships no authenticated endpoint and no user-input surface (e.g. a static
> marketing page), record that in the attack-surface row, complete controls **C3–C5**
> below, note the reduced scope, and stop. The remaining sections apply to stories with a
> server-side surface.

---

## 1. Audit scope

The code surface this story introduces or materially changes, which the implementation
audit will walk once it lands. One row per endpoint, view, service, or migration.

| Surface / file             | Type                          | Why in scope                       |
| -------------------------- | ----------------------------- | ---------------------------------- |
| [EXAMPLE] `{path/to/file}` | Ninja endpoint / view / model | {handles user input / writes data} |

_List every file that touches authentication, authorisation, user input, or persistence._

## 2. Frameworks

Every finding this audit raises carries all three classifications plus a severity:

- **STRIDE** — threat category (Spoofing, Tampering, Repudiation, Information disclosure,
  Denial of service, Elevation of privilege).
- **OWASP Top 10** — vulnerability category (A01–A10).
- **NIST CSF 2.0** — risk-management function (GV / ID / PR / DE / RS / RC).
- **Severity** — Critical / High / Medium / Low / Info.

Reference tables: `project-management/docs/SECURITY-GUIDE.md`.

## 3. Audit checklist

The reusable control checklist to run against the shipped code. Mark each **Applicable**
or **N/A** for this story now; the implementation record returns each with a result and
code evidence. This checklist is the durable scaffold — keep every row.

| #   | Control                                                                                        | Applicable? | Notes                |
| --- | ---------------------------------------------------------------------------------------------- | ----------- | -------------------- |
| C1  | Every state-changing Django Ninja endpoint has an explicit, named permission check (OWASP A01) | Yes / N/A   | {which endpoints}    |
| C2  | User-supplied IDs verified against the caller's ownership — no IDOR                            | Yes / N/A   | {which lookups}      |
| C3  | `CORS_ALLOWED_ORIGINS` is an explicit allowlist — never `*` in production                      | Yes / N/A   | {origins touched}    |
| C4  | `DEBUG=False` in every non-local environment                                                   | Yes / N/A   | {settings affected}  |
| C5  | All secrets read from environment variables — none hardcoded                                   | Yes / N/A   | {keys / tokens used} |
| C6  | Input validated and typed at the boundary (UUIDs, length, allowlists)                          | Yes / N/A   | {inputs accepted}    |
| C7  | Injection defence — ORM / parameterised queries, output escaping, no raw SQL                   | Yes / N/A   | {query sites}        |
| C8  | Sensitive data kept out of error payloads and logs (no enumeration / leakage)                  | Yes / N/A   | {error surfaces}     |
| C9  | Multi-write paths are transactional and audit-logged where security-relevant                   | Yes / N/A   | {write paths}        |

_Add a story-specific row only where the story introduces a control not covered above._

## 4. Anticipated threats & focus areas

The threats a STRIDE pass over the attack surface flags for the implementation audit to
confirm or clear. A fresh plan carries no real findings — replace the example row.

| ID  | STRIDE | OWASP | NIST CSF | Trust boundary     | Threat description                                                            | Severity | Mitigation to verify                     |
| --- | ------ | ----- | -------- | ------------------ | ----------------------------------------------------------------------------- | -------- | ---------------------------------------- |
| T01 | E      | A01   | PR       | Frontend → Backend | [EXAMPLE] {endpoint without a role check reachable by any authenticated user} | HIGH     | {named permission check on the endpoint} |

_One row per hypothesis the code audit must resolve; map each to STRIDE + OWASP + NIST CSF._

## 5. Blocking criteria & developer constraints

Concrete, testable requirements the shipped code must satisfy. Critical/High items block
the sprint and escalate to `../../VULNERABILITIES/PLANNING/`; each becomes a checklist
item the implementation record closes with evidence.

- [ ] [EXAMPLE] {Every admin endpoint calls the named permission check before any DB write.}
- [ ] [EXAMPLE] {IDOR test: a non-owner token receives 403 (not 404) from `{endpoint}`.}
- [ ] [EXAMPLE] {No secret literal in the diff — all read via environment.}

---

## Cross-references

- `../IMPLEMENTATION/AUDIT-IMPL-US000-TEMPLATE.md` — the post-implementation record answering this plan
- `../../ASSESSMENTS/PLANNING/` — the posture assessment this audit feeds
- `../../VULNERABILITIES/PLANNING/` · `../../THREAT-MODEL/PLANNING/` — sibling sub-areas for escalated findings and the STRIDE baseline
- `../../../02-STORIES/` — the story being audited
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` — the code-side controls these findings must stay consistent with
