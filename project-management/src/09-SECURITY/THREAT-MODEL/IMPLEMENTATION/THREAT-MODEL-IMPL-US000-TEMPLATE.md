# Threat Model Review — US000 {STORY TITLE}

_Template — copy to `THREAT-MODEL-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every
`[EXAMPLE]` row and `{PLACEHOLDER}` with this story's own analysis, and delete this note
once populated. This is the **post-implementation** review; it re-assesses, against the
shipped code, the plan in `../PLANNING/THREAT-MODEL-PLAN-US000-TEMPLATE.md`._

| Field           | Value                                                 |
| --------------- | ----------------------------------------------------- |
| **Story**       | US### — {short title}                                 |
| **Date**        | {DD/MM/YYYY}                                          |
| **Verified by** | {name / agent}                                        |
| **Plan doc**    | `../PLANNING/THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md` |
| **Outcome**     | PASS / PASS with deferred items / Blocked             |

---

## 1. Scope

Confirm the surface that actually shipped, and list the files re-assessed. Flag any
surface that changed from the plan.

| File                          | Purpose                               |
| ----------------------------- | ------------------------------------- |
| [EXAMPLE] `{path/to/file.py}` | {model / service / resolver reviewed} |

_List the shipped files this review inspected — the models, services, resolvers,
components, and tasks named in the plan's scope._

## 2. Trust boundaries — confirmed

Confirm each planned trust boundary still holds in the shipped code, and note any new
one introduced during implementation.

| ID  | Boundary                         | Change since plan           |
| --- | -------------------------------- | --------------------------- |
| TB1 | [EXAMPLE] {Anonymous ↔ frontend} | Unchanged / {new / altered} |

## 3. STRIDE threat re-assessment

Re-assess **every** threat from the plan against the shipped code. Set Status to
**Mitigated** (control in place — cite it), **Residual** (accepted / deferred — say why
and where tracked), or **New** (found during implementation). Keep the same STRIDE /
OWASP / NIST mapping as the plan.

| ID              | STRIDE   | OWASP | NIST CSF | Trust Boundary | Threat description      | Severity | Status    | Mitigation (as shipped)                                                                                            |
| --------------- | -------- | ----- | -------- | -------------- | ----------------------- | -------- | --------- | ------------------------------------------------------------------------------------------------------------------ |
| [EXAMPLE] TM-01 | Spoofing | A01   | PR.AC    | TB1            | {IDOR on the mutation.} | HIGH     | Mitigated | {No user-supplied ID accepted; resolver scopes to `request.user`; ownership check — evidence `{path/to/file.py}`.} |

_One row per planning-phase threat, plus any new one. Status ∈ Mitigated / Residual /
New. A `Mitigated` row must cite the shipped code that mitigates it — never mark
Mitigated without evidence._

## 4. New threats identified during implementation

Threats not in the plan, found while reviewing the shipped code. "None" is a valid entry.

- [EXAMPLE] **TM-N1 ({LOW})** — {new threat}; {mitigation or escalation}. — or "None."

_Any new CRITICAL/HIGH is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`._

## 5. Residual & deferred items

Threats accepted as residual, or deferred to a later story, with where each is tracked.

| Item                      | Threat IDs | Severity | Tracked in / when              |
| ------------------------- | ---------- | -------- | ------------------------------ |
| [EXAMPLE] {Rate limiting} | TM-0x      | MEDIUM   | `GAPS.md` / {hardening sprint} |

_Deferring a threat is legitimate only if it is a known, tracked residual — never a
silently dropped mitigation._

## 6. Sign-off

| Reviewer | Role             | Date         |
| -------- | ---------------- | ------------ |
| {name}   | {security / dev} | {DD/MM/YYYY} |

**Overall verdict:** {one line — all CRITICAL/HIGH mitigated; any deferred item is a
known, tracked residual, not a regression.}

---

## Cross-references

- `../PLANNING/THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md` — the pre-implementation model
  re-assessed here
- `../../ASSESSMENTS/IMPLEMENTATION/` — the posture assessment that consumes this review
- `../../VULNERABILITIES/IMPLEMENTATION/` — where new CRITICAL/HIGH findings are escalated
- `../../../01-STORIES/` — the story reviewed
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `project-management/workflows/09-security-checks/` — where this review is written
- `code/docs/SECURITY.md` — the code-side enforcement these claims must stay consistent with
