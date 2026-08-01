# Security Audit — US000 {STORY TITLE}

_Template — copy to `AUDIT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`[EXAMPLE]` row and `{PLACEHOLDER}` with this story's verified outcome, and delete this
note once populated. This is the **post-implementation** record; it answers, with
evidence, the plan in `../PLANNING/AUDIT-PLAN-US000-TEMPLATE.md`._

| Field          | Value                                          |
| -------------- | ---------------------------------------------- |
| **Story**      | US### — {short title}                          |
| **Date**       | {DD/MM/YYYY}                                   |
| **Audited by** | {name / agent}                                 |
| **Plan doc**   | `../PLANNING/AUDIT-PLAN-US###-<DESCRIPTOR>.md` |
| **Verdict**    | Pass / Pass with notes / Fail — remediate      |

---

## 1. Scope audited

The files actually walked in this run. Confirm against the plan's §1 audit scope; flag
any file added or dropped.

| File                       | Verdict                | Notes      |
| -------------------------- | ---------------------- | ---------- |
| [EXAMPLE] `{path/to/file}` | Pass / Pass with notes | {one line} |

_One row per file; a `Pass with notes` verdict must map to a finding below._

## 2. Findings

Every issue found, one row each, mapped to all three frameworks with a severity and a
status. A clean audit carries **no findings** — delete the example row and record "None".

| ID    | STRIDE | OWASP | NIST CSF | Trust boundary     | Finding                                             | Severity | Mitigation / fix               | Status                         |
| ----- | ------ | ----- | -------- | ------------------ | --------------------------------------------------- | -------- | ------------------------------ | ------------------------------ |
| F-001 | E      | A01   | PR       | Frontend → Backend | [EXAMPLE] {endpoint reachable without a role check} | HIGH     | {named permission guard added} | Resolved / Residual / Deferred |

_Escalate any new Critical/High to `../../VULNERABILITIES/IMPLEMENTATION/` and reference it here._

## 3. Checklist results

The plan's §3 control checklist, each returned with a result and code evidence. Keep
every row — this is the durable scaffold.

| #   | Control                                                                        | Result            | Evidence (file · symbol)    |
| --- | ------------------------------------------------------------------------------ | ----------------- | --------------------------- |
| C1  | Explicit, named permission check on every state-changing Django Ninja endpoint | Pass / N/A / Fail | [EXAMPLE] `{path}:{symbol}` |
| C2  | User-supplied IDs verified against the caller's ownership — no IDOR            | Pass / N/A / Fail | {evidence}                  |
| C3  | `CORS_ALLOWED_ORIGINS` is an explicit allowlist — never `*` in production      | Pass / N/A / Fail | {evidence}                  |
| C4  | `DEBUG=False` in every non-local environment                                   | Pass / N/A / Fail | {evidence}                  |
| C5  | All secrets read from environment variables — none hardcoded                   | Pass / N/A / Fail | {evidence}                  |
| C6  | Input validated and typed at the boundary (UUIDs, length, allowlists)          | Pass / N/A / Fail | {evidence}                  |
| C7  | Injection defence — ORM / parameterised queries, output escaping, no raw SQL   | Pass / N/A / Fail | {evidence}                  |
| C8  | Sensitive data kept out of error payloads and logs                             | Pass / N/A / Fail | {evidence}                  |
| C9  | Multi-write paths transactional and audit-logged where security-relevant       | Pass / N/A / Fail | {evidence}                  |

## 4. OWASP Top 10 coverage

A compact pass over the ten categories — mark each Pass / N/A or the finding ID that
covers it. A fresh record replaces the example row.

| #   | Category              | Result          |
| --- | --------------------- | --------------- |
| A01 | Broken Access Control | [EXAMPLE] F-001 |

_Record one line per category actually in scope for this story; the rest are N/A._

## 5. Plan constraints closed

Each blocking criterion / developer constraint from the plan's §5, closed **only with
evidence** (never mark done without pointing at the shipped code that does it).

| Plan constraint                          | Status   | Evidence                        |
| ---------------------------------------- | -------- | ------------------------------- |
| [EXAMPLE] {Permission check on endpoint} | Closed   | `{path/to/file}:{symbol}`       |
| [EXAMPLE] {IDOR test non-owner → 403}    | Deferred | tracked in `GAPS.md` — {reason} |

## 6. Deferred / residual items

Items not closed in this story, each with a tracking reference. "None" is a valid entry.

- [EXAMPLE] {Guard for a future endpoint} — blocked by {reason}; tracked as
  `../../VULNERABILITIES/IMPLEMENTATION/VULN-IMPL-US###-{DESCRIPTOR}-DD-MM-YYYY.md`.

## 7. Deviations from plan

Any departure from `../PLANNING/AUDIT-PLAN-US###-<DESCRIPTOR>.md`, with justification.

- {Deviation and why it was necessary — or "None."}

## 8. Sign-off

| Auditor          | Role   | Date         |
| ---------------- | ------ | ------------ |
| [EXAMPLE] {name} | {role} | {DD/MM/YYYY} |

---

## Cross-references

- `../PLANNING/AUDIT-PLAN-US###-<DESCRIPTOR>.md` — the pre-implementation plan answered here
- `../../ASSESSMENTS/IMPLEMENTATION/` — the posture assessment this audit feeds
- `../../VULNERABILITIES/IMPLEMENTATION/` · `../../THREAT-MODEL/IMPLEMENTATION/` — sibling sub-areas for closed findings and the re-assessed STRIDE model
- `../../../01-STORIES/` — the story audited
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `project-management/workflows/20-pr-and-review/` — where this record is written
- `code/docs/SECURITY.md` — the code-side controls these findings must stay consistent with
