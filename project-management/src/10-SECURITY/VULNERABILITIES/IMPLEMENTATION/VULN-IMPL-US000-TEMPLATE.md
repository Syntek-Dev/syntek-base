# VULN Implementation — US000 {VULNERABILITY TITLE}

_Template — copy to `VULN-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`[EXAMPLE]` row and `{PLACEHOLDER}` with this story's verified outcome, and delete this
note once populated. This is the **post-implementation** closure record; it answers, with
evidence, the finding raised in `../PLANNING/VULN-PLAN-US000-TEMPLATE.md`._

| Field             | Value                                           |
| ----------------- | ----------------------------------------------- |
| **Vulnerability** | {short human-readable name — matches the plan}  |
| **Finding ID**    | {the same internal ref as the plan}             |
| **Story**         | US### — {short title}                           |
| **Plan doc**      | `../PLANNING/VULN-PLAN-US###-<DESCRIPTOR>.md`   |
| **Resolved in**   | {PR #} / {commit SHA} on `{branch}`             |
| **Verified by**   | {name / agent}                                  |
| **Date**          | {DD/MM/YYYY}                                    |
| **Status**        | Resolved — no unresolved Critical/High findings |

---

## 1. Classification (as raised)

Carried unchanged from the plan, for the closed record.

| Severity       | STRIDE                     | OWASP Top 10 (2025)              | NIST CSF 2.0 function |
| -------------- | -------------------------- | -------------------------------- | --------------------- |
| [EXAMPLE] High | I — Information Disclosure | A01:2025 — Broken Access Control | PR (Protect)          |

## 2. Original finding

One-paragraph restatement of the vulnerability the plan raised — the broken invariant,
the entry point, and the impact — so this record stands alone.

- {What the finding was, and why it was a sprint blocker.}

## 3. Resolution

What shipped, and where. The fix lives in `code/`; cite it. Close **every** control from
the plan's Section 5 recommendation — each with a code reference, never a bare tick.

| Control (plan Section 5) | Resolution                        | Evidence (file · symbol)      | Status   |
| ------------------------ | --------------------------------- | ----------------------------- | -------- |
| [EXAMPLE] {control}      | {what was implemented}            | `{path/to/file}` · `{symbol}` | Resolved |
| [EXAMPLE] {control}      | {tracked, not shipped this story} | `GAPS.md` / US### — {reason}  | Deferred |

_A control is Resolved only when a code reference proves it; anything not shipped is
Deferred with a `GAPS.md` or story owner, never silently dropped._

## 4. Verification

How the fix was confirmed — the exploit path is now closed. Name the tests or manual
steps; state expected vs actual.

- [EXAMPLE] {Unit: `{path/to/test}` — asserts the exploit path returns denied/not-found.}
- [EXAMPLE] {Integration: `{path/to/test}` — asserts the cross-boundary request is blocked
  and a WARNING audit entry is written.}

## 5. Residual / deferred risk

Any remaining exposure or accepted risk, with its owner. "None" is a valid entry.

| Item                 | Severity | Disposition                                                      |
| -------------------- | -------- | ---------------------------------------------------------------- |
| [EXAMPLE] {residual} | Low      | {accepted under {model} / tracked in `GAPS.md` / owned by US###} |

## 6. Deviations from plan

Any departure from `../PLANNING/VULN-PLAN-US###-<DESCRIPTOR>.md`, with justification.
"None" is a valid entry.

- {Deviation and why it was necessary — or "None."}

---

## Cross-references

- `../PLANNING/VULN-PLAN-US###-<DESCRIPTOR>.md` — the finding this record closes
- `../../ASSESSMENTS/IMPLEMENTATION/` · `../../AUDITS/IMPLEMENTATION/` — the sibling
  categories (post-implementation assessment and verification audit) that reference this
  closure
- `code/docs/SECURITY.md` — the code-side enforcement these claims must stay consistent with
- `project-management/workflows/21-implementation-documentation/` — where this record is written
