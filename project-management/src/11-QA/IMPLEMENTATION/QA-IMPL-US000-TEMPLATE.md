# QA Implementation Review — US000 {STORY TITLE}

_Template — copy to `QA-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`, replace every `[EXAMPLE]`
row and `{PLACEHOLDER}` with this story's own analysis, and delete this note once
populated. This is the **post-implementation** QA review; it verifies, with evidence, the
plan in `../PLANNING/QA-PLAN-US000-TEMPLATE.md`._

| Field        | Value                                       |
| ------------ | ------------------------------------------- |
| **Story**    | US### — {short title}                       |
| **Date**     | {DD/MM/YYYY}                                |
| **Sprint**   | {SPRINT}                                    |
| **Reviewer** | {name / agent}                              |
| **Branch**   | `us###/{short-description}`                 |
| **Plan doc** | `../PLANNING/QA-PLAN-US###-<DESCRIPTOR>.md` |
| **Outcome**  | Pass / Pass with deviations / Blocked       |

---

## 1. Scope

One or two lines: what this PR actually built and reviewed (backend / API / frontend),
and anything explicitly deferred to a follow-on story. Confirm it matches the plan's
scope; flag any addition.

## 2. Acceptance-criteria gaps closed

Each `AC-GAP-n` raised in the plan's _Acceptance Criteria Gaps_ list, resolved **only
with evidence** (a shipped behaviour, a merged AC change, or a tracked deferral).

| Gap                        | Status                     | Evidence                        |
| -------------------------- | -------------------------- | ------------------------------- |
| [EXAMPLE] AC-GAP-1 — {gap} | Resolved / Open / Deferred | {clarified AC / `GAPS.md` link} |

_Every gap the plan marked `[OPEN]` must be closed or carried forward here — no silent drops._

## 3. Scenario verification

Mark each scenario from the plan **Pass / Fail / Deviation / Deferred / N/A** against the
running build, with evidence (test name, file, or observed behaviour). Keep the plan's IDs.

### Happy Path

| ID              | Scenario (from plan) | Result | Evidence                          |
| --------------- | -------------------- | ------ | --------------------------------- |
| [EXAMPLE] HP-01 | {expected outcome}   | Pass   | `test_{name}` / observed in build |

_One row per HP-nn in the plan; anything not Pass needs a reason in Section 4 or Section 6._

### Error States

| ID              | Scenario (from plan) | Result | Evidence      |
| --------------- | -------------------- | ------ | ------------- |
| [EXAMPLE] ES-01 | {handled error}      | Pass   | `test_{name}` |

_One row per ES-nn; confirm the user sees the intended message, not a stack trace._

### Edge Cases

| ID              | Scenario (from plan) | Result | Evidence      |
| --------------- | -------------------- | ------ | ------------- |
| [EXAMPLE] EC-01 | {boundary case}      | Pass   | `test_{name}` |

_One row per EC-nn; boundary and empty/max states._

### Permission and Access

| ID              | Scenario (from plan)         | Result | Evidence      |
| --------------- | ---------------------------- | ------ | ------------- |
| [EXAMPLE] PA-01 | {unauthorised caller denied} | Pass   | `test_{name}` |

_One row per PA-nn; every mutation/query gate and IDOR check verified against the build._

## 4. Deviations from plan

Any departure from `../PLANNING/QA-PLAN-US###-*.md`, with justification. "None." is a
valid entry.

| Deviation                | Justification                                   |
| ------------------------ | ----------------------------------------------- |
| [EXAMPLE] {what changed} | {why it was necessary — or delete row: "None."} |

## 5. New edge cases discovered

Failure paths or boundary conditions found during implementation that were **not** in the
plan. Note whether each should be folded back into the plan/AC.

| ID              | Scenario           | Result | Evidence      | Fold back? |
| --------------- | ------------------ | ------ | ------------- | ---------- |
| [EXAMPLE] EC-0n | {newly found case} | Pass   | `test_{name}` | Yes / No   |

## 6. Deferred scenarios

Planned scenarios not covered in this PR, each with a reason and the owning story.

| Scenario             | Reason                    | When to address        |
| -------------------- | ------------------------- | ---------------------- |
| [EXAMPLE] {scenario} | {infra not yet available} | {US### / named sprint} |

## 7. Accessibility observations

WCAG 2.2 AA against the running build — confirm or flag each expectation from the plan.

- **axe-core** — {zero violations on the affected route(s) — evidence / CI job}
- **Keyboard & focus** — {focus order logical; visible focus ring; focus trap in any modal}
- **Equal-weight actions** — {primary/secondary actions equally prominent — no dark patterns}
- **Other** — {contrast, labels, reduced-motion, screen-reader announcements — as applicable}

## 8. GDPR & security observations

Where the story touches personal data, evidence that the shipped code protects it.
"N/A — no personal data processed." is a valid entry.

- **PII at rest** — {sensitive fields encrypted; no plaintext in the store — evidence}
- **PII in responses** — {no personal data leaked in a query/response type — evidence}
- **Rights paths** — {access/export and erasure behave as planned — evidence / N/A}
- **Security gate** — {permission check, ownership/IDOR, rate limit — evidence}

## Sign-off checklist

- [ ] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [ ] Acceptance-criteria gaps closed or carried forward with evidence
- [ ] Deviations from the plan justified
- [ ] New edge cases recorded (and folded back into the plan/AC where needed)
- [ ] Accessibility observations confirmed against the build
- [ ] GDPR & security observations confirmed (or N/A recorded)
- [ ] Coverage floors met for all modules in scope
- [ ] Manual testing sign-off (see `../../18-TESTS/US###-MANUAL-TESTING.md`)
- [ ] Reviewer approval — **blocks merge until complete**

---

## Cross-references

- `../PLANNING/QA-PLAN-US###-<DESCRIPTOR>.md` — the pre-development plan verified here
- `../../02-STORIES/US###.md` — the story under review
- `../../18-TESTS/US###-TEST-STATUS.md` · `US###-MANUAL-TESTING.md` — downstream test records
- `../../19-REVIEWS/` — code-review notes from the same PR
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
