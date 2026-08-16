# Security Posture Assessment (Plan) — US000 {STORY TITLE}

_Template — copy to `ASSESSMENT-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]`
row and `{PLACEHOLDER}` with this story's own analysis, and delete this note once
populated. This is the **pre-implementation** baseline posture assessment for a single
story — it sets the OWASP A01–A10 and NIST CSF 2.0 targets the shipped code must meet;
its post-implementation counterpart is
`../IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md`._

| Field          | Value                                                              |
| -------------- | ------------------------------------------------------------------ |
| **Story**      | US### — {short title}                                              |
| **Date**       | {DD/MM/YYYY}                                                       |
| **Author**     | {name / agent}                                                     |
| **Sprint**     | SPRINT-## — {phase}                                                |
| **Status**     | Draft / Reviewed / Signed off                                      |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC) |

> This assessment establishes the security **baseline** for the story before any code is
> written. It synthesises the story's STRIDE threat model and maps overall posture against
> OWASP Top 10 and NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or
> HIGH finding — those are release blockers.

---

## 1. Summary

_One short paragraph: the story's design-stage posture, the count of findings by severity,
where risk concentrates, and which blocking findings gate sprint planning._

{PLACEHOLDER — e.g. "The story is soundly designed for the planning stage; N findings were
identified (X CRITICAL, Y HIGH, Z MEDIUM, W LOW). Risk concentrates in {surface}. No sprint
planning may proceed while any CRITICAL or HIGH finding is open."}

## 2. Scope

| Dimension  | Coverage                                                 |
| ---------- | -------------------------------------------------------- |
| Story      | US### — {short title}                                    |
| User flow  | `{path/to/user-flow}`                                    |
| Schema     | `{path/to/schema}` — {tables / RLS / PII classification} |
| Decisions  | {ADR-### references, if any}                             |
| Frameworks | STRIDE · OWASP Top 10 · NIST CSF 2.0                     |

_State exactly what surface this story introduces or changes; flag anything not yet
produced (e.g. wireframes pending) as a deviation to re-validate on landing._

## 3. Threat models referenced

The STRIDE model(s) this posture assessment synthesises. Cross-check
`../../THREAT-MODEL/PLANNING/` and adopt its trust boundaries and findings.

- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md` — {N findings,
  M trust boundaries}

## 4. OWASP Top 10 — baseline coverage

Design-stage posture for each category. Status ∈ Addressed / Partial / Open / N/A.

| ID       | Category                              | Status            | Notes (open findings, controls relied on)        |
| -------- | ------------------------------------- | ----------------- | ------------------------------------------------ |
| A01:2025 | Broken Access Control (incl. SSRF)    | [EXAMPLE] Partial | {controls in place; open finding IDs + severity} |
| A02:2025 | Security Misconfiguration             | {status}          | {notes}                                          |
| A03:2025 | Software Supply Chain Failures        | {status}          | {notes}                                          |
| A04:2025 | Cryptographic Failures                | {status}          | {notes}                                          |
| A05:2025 | Injection                             | {status}          | {notes}                                          |
| A06:2025 | Insecure Design                       | {status}          | {notes}                                          |
| A07:2025 | Authentication Failures               | {status}          | {notes}                                          |
| A08:2025 | Software and Data Integrity Failures  | {status}          | {notes}                                          |
| A09:2025 | Security Logging & Alerting Failures  | {status}          | {notes}                                          |
| A10:2025 | Mishandling of Exceptional Conditions | {status}          | {notes}                                          |

_Record a status and a one-line note for every row — a blank row is an incomplete
assessment. Cite each open finding by ID against the category it belongs to._

## 5. NIST CSF 2.0 — function summary

| Fn  | Function | Design-stage posture                                    |
| --- | -------- | ------------------------------------------------------- |
| GV  | Govern   | [EXAMPLE] {ownership / policy / sign-off dependencies}  |
| ID  | Identify | {assets, data flows, and risk concentration identified} |
| PR  | Protect  | {the controls: Policy checks, IDOR, RLS, encryption…}   |
| DE  | Detect   | {audit logging, monitoring, failure signalling}         |
| RS  | Respond  | {revocation, rate limiting, incident hooks}             |
| RC  | Recover  | {rollback, versioning, backup / retention}              |

_One line per function — what the design provides and which findings weaken it._

## 6. Findings

One row per finding. Every row carries STRIDE, OWASP, NIST CSF, a trust boundary, a
severity, and the planned mitigation. Group by severity in the populated document.

| ID             | STRIDE      | OWASP | NIST CSF | Trust Boundary     | Threat Description                        | Severity | Planned Mitigation                                    |
| -------------- | ----------- | ----- | -------- | ------------------ | ----------------------------------------- | -------- | ----------------------------------------------------- |
| [EXAMPLE] {ID} | S/T/R/I/D/E | A0x   | PR       | {boundary crossed} | {what the weakness is and why it matters} | HIGH     | {control to add; owning US### / acceptance criterion} |

_Severity legend — CRITICAL: exploitable with no auth, direct breach risk; HIGH:
exploitable with low-privilege access, significant impact; MEDIUM: needs specific
conditions, moderate impact; LOW: informational or minor hardening. Escalate every
CRITICAL/HIGH to `../../VULNERABILITIES/PLANNING/`._

## 7. Security tasks & open gaps

Concrete controls to satisfy **before or during** implementation. Each becomes a
checklist item; the implementation assessment closes it with evidence.

- [ ] [EXAMPLE] {Add named Policy permission check to the {mutation} resolver (A01).}
- [ ] [EXAMPLE] {Enforce IDOR ownership: caller ID from session verified against target (A01).}

_CRITICAL/HIGH items are sprint-planning blockers — do not silently drop one._

---

## Cross-references

- `../IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record
  that verifies this baseline
- `../../THREAT-MODEL/PLANNING/` — the STRIDE model this assessment synthesises
- `../../AUDITS/PLANNING/` · `../../VULNERABILITIES/PLANNING/` — the sibling code audit and
  the escalated CRITICAL/HIGH findings
- `../../../02-STORIES/` — the story being assessed
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` — the code-side enforcement these targets must stay consistent with
