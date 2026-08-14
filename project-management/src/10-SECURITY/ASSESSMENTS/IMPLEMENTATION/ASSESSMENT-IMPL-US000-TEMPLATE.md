# Security Posture Assessment (Implementation) — US000 {STORY TITLE}

_Template — copy to `ASSESSMENT-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`[EXAMPLE]` row and `{PLACEHOLDER}` with this story's verified outcome, and delete this
note once populated. This is the **post-implementation** record — it answers, with code
evidence, the baseline in `../PLANNING/ASSESSMENT-PLAN-US000-TEMPLATE.md`, re-evaluating
OWASP A01–A10 and NIST CSF 2.0 coverage and confirming no regressions._

| Field           | Value                                               |
| --------------- | --------------------------------------------------- |
| **Story**       | US### — {short title}                               |
| **Date**        | {DD/MM/YYYY}                                        |
| **Verified by** | {name / agent}                                      |
| **Sprint**      | SPRINT-##                                           |
| **Plan doc**    | `../PLANNING/ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md` |
| **Outcome**     | PASS / PASS with deferred items / BLOCKED           |

---

## 1. Scope

_What the shipped code covers, and the files assessed. Confirm this matches the plan;
flag any addition._

| File                       | Purpose                  |
| -------------------------- | ------------------------ |
| [EXAMPLE] `{path/to/file}` | {what was assessed here} |

_List every file that carries a control this assessment verifies._

## 2. OWASP Top 10 — coverage

Re-evaluate each category against the shipped code. Status ∈ PASS / PARTIAL / DEFERRED /
N/A. Point at the evidence.

| ID  | Category                                   | Status         | Evidence / Notes                           |
| --- | ------------------------------------------ | -------------- | ------------------------------------------ |
| A01 | Broken Access Control                      | [EXAMPLE] PASS | {Policy check + IDOR ownership — evidence} |
| A02 | Cryptographic Failures                     | {status}       | {evidence}                                 |
| A03 | Injection                                  | {status}       | {evidence}                                 |
| A04 | Insecure Design                            | {status}       | {evidence}                                 |
| A05 | Security Misconfiguration                  | {status}       | {evidence}                                 |
| A06 | Vulnerable and Outdated Components         | {status}       | {evidence}                                 |
| A07 | Identification and Authentication Failures | {status}       | {evidence}                                 |
| A08 | Software and Data Integrity Failures       | {status}       | {evidence}                                 |
| A09 | Security Logging and Monitoring Failures   | {status}       | {evidence}                                 |
| A10 | Server-Side Request Forgery                | {status}       | {evidence}                                 |

_Every row needs a status and evidence (file · symbol). A DEFERRED row must name what
blocks it and where it is tracked._

## 3. NIST CSF 2.0 — coverage

| Fn  | Function | Status         | Evidence                                   |
| --- | -------- | -------------- | ------------------------------------------ |
| GV  | Govern   | [EXAMPLE] PASS | {policy / allowlist documented — evidence} |
| ID  | Identify | {status}       | {evidence}                                 |
| PR  | Protect  | {status}       | {evidence}                                 |
| DE  | Detect   | {status}       | {evidence}                                 |
| RS  | Respond  | {status}       | {evidence}                                 |
| RC  | Recover  | {status}       | {evidence}                                 |

## 4. Findings

Findings identified during this review of the shipped code. One row each, with STRIDE,
OWASP, NIST CSF, severity, recommendation, and status.

| ID              | STRIDE | OWASP | NIST CSF | Severity | Finding                              | Recommendation     | Status   |
| --------------- | ------ | ----- | -------- | -------- | ------------------------------------ | ------------------ | -------- |
| [EXAMPLE] F-001 | R      | A09   | DE       | MEDIUM   | {what was found in the shipped code} | {fix or follow-up} | Deferred |

_State explicitly whether any CRITICAL or HIGH findings were identified. Escalate each new
CRITICAL/HIGH to `../../VULNERABILITIES/IMPLEMENTATION/`._

## 5. Planning-phase findings — status update

Each finding from the plan's Section 6/Section 7, re-evaluated against the shipped code. Mark
**only with evidence** — never Resolved without pointing at the code that does it.

| Plan finding           | Status                    | Evidence / Notes                    |
| ---------------------- | ------------------------- | ----------------------------------- |
| [EXAMPLE] {finding ID} | Resolved / Residual / New | `{path/to/file}` — {what closed it} |

## 6. Plan gaps closed & deferred items

| Item                                    | Status   | Evidence / Blocked by           |
| --------------------------------------- | -------- | ------------------------------- |
| [EXAMPLE] {control from plan Section 7} | Closed   | `{path/to/file}`                |
| [EXAMPLE] {control from plan Section 7} | Deferred | tracked in `GAPS.md` — {reason} |

## 7. Deviations from plan

Any departure from `../PLANNING/ASSESSMENT-PLAN-US###-*.md`, with justification. "None"
is a valid entry.

- {Deviation and why it was necessary — or "None."}

## 8. Sign-off

| Reviewer | Role   | Date         |
| -------- | ------ | ------------ |
| {name}   | {role} | {DD/MM/YYYY} |

**Overall verdict:** {PLACEHOLDER — one-line statement of whether the story meets the
posture targets from the baseline, and that no CRITICAL/HIGH was introduced.}

---

## Cross-references

- `../PLANNING/ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md` — the baseline answered here
- `../../AUDITS/IMPLEMENTATION/` · `../../THREAT-MODEL/IMPLEMENTATION/` — the code audit and
  updated threat model consumed by this review
- `../../VULNERABILITIES/IMPLEMENTATION/` — any newly found CRITICAL/HIGH escalated here
- `../../../02-STORIES/` — the source story
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/workflows/21-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
