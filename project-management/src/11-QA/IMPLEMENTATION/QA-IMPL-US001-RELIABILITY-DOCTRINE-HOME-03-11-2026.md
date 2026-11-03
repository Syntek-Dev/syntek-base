# QA Implementation Review — US001 Reliability doctrine gets an owning guide

| Field        | Value                                                                                              |
| ------------ | -------------------------------------------------------------------------------------------------- |
| **Story**    | US001 — reliability doctrine gets an owning guide, and every pointer reaches it                    |
| **Date**     | 03/11/2026                                                                                         |
| **Sprint**   | SPRINT-01                                                                                          |
| **Reviewer** | Claude (a `22-implementation-documentation` subagent that made none of the edits), on Sam's behalf |
| **Branch**   | `us001/reliability-doctrine-home`, cut at `e1ab25a`; uncommitted at this record                    |
| **Plan doc** | `../PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`                                           |
| **Outcome**  | Pass with deviations                                                                               |

---

## 1. Scope

**What shipped:** Markdown only. A new reliability family — the hub `code/docs/RELIABILITY.md` and
`code/docs/reliability/` (`code/docs/reliability/IDEMPOTENCY.md`, `code/docs/reliability/RETRIES.md` and the `CONTEXT.md` + `CLAUDE.md` pair) —
with the idempotency and retry doctrine migrated into it out of `code/docs/TASK-AUTHORING.md` and
`code/docs/performance/API-AND-MONITORING.md`, and every pointer to the old homes repointed. There is
no backend, API or frontend.

**Matches the plan's scope, with one widening.** The plan named three pointers (PROCESS-MODEL,
NEGATIVE-SPACE, `code/docs/CONTEXT.md`). The review and QA passes found five more — the core
services `CLAUDE.md`, `.copier/README.md`, `code/docs/NOTIFICATIONS.md`, the `notifications` and
`backend` skills — plus a missing route from `code/docs/MANAGEMENT-COMMANDS.md`. All were fixed in
the build (`../../19-REVIEWS/REVIEW-US001-RELIABILITY-DOCTRINE-HOME.md` R-005,
R-011, R-012, R-016; finding F-008).

**No other spec applies.** Listing every PLANNING folder for US001 on 03/11/2026 found only this
QA plan: `project-management/src/09-GDPR/PLANNING/`, the four 10-SECURITY category PLANNING folders,
`project-management/src/12-SEO/PLANNING/`, `project-management/src/13-API-DESIGN/PLANNING/` and
`project-management/src/14-LOGGING/PLANNING/` hold nothing for US001, matching the story's
FLAGS, where every row but `QA` reads N/A. No other IMPLEMENTATION record is owed.

## 2. Acceptance-criteria gaps closed

The plan closed all six gaps into the story on 01/09/2026, before code. Each is checked here
against what shipped.

| Gap                                                                       | Status   | Evidence                                                                                                                                                                                                                                                                                    |
| ------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-GAP-1 — `code/src/scripts/audits/doctrine-drift.sh` cannot check prose | Resolved | READ-05 records the gate as a regression guard only; the duplicate check is the human read-across, READ-01 to READ-03 (`../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`). See Section 4                                                                             |
| AC-GAP-2 — nothing asserted the migration was lossless                    | Resolved | The rule inventory, captured 03/11/2026 at `e1ab25a` before the first edit, balances: 13 moved + 10 kept + 10 deleted = 33 (INVENTORY-01 to INVENTORY-06). The fourth source section (TA's error taxonomy) was inventoried per plan Step E2, and one checklist restatement (A-12) was added |
| AC-GAP-3 — the routing-frontmatter task had no criterion                  | Resolved | FAMILY-03: the hub and both sub-guides open with `type: guide`, `skills:` and `model: opus`                                                                                                                                                                                                 |
| AC-GAP-4 — an undefined destination for a residual rule                   | Resolved | MONITOR-02: no AM rule needed routing to the family. The one rule that was neither monitoring nor a duplicate, the A-07 code sample, was deleted under decision Q3 — a deviation, Section 4                                                                                                 |
| AC-GAP-5 — an untestable naming criterion                                 | Resolved | FAMILY-04: each guide states at least one moved rule. FAMILY-02: `code/docs/reliability/CONTEXT.md` → _Why the family is split this way_ gives three reasons; the provenance half moved to the plan (Section 4)                                                                             |
| AC-GAP-6 — the QA flag under-counted its gates                            | Resolved | All four flagged gates ran at close: docs-length, docs-pairing, doc-references and doctrine-drift (`../../18-TESTS/AUTOMATED/US001-TEST-STATUS.md` Section 2)                                                                                                                               |

## 3. Scenario verification

All evidence is manual: the story has no suite
(`../../18-TESTS/AUTOMATED/US001-TEST-STATUS.md`). Each row ID refers to
`../../18-TESTS/MANUAL/US001-MANUAL-TESTING.md`, walked 03/11/2026 by an agent
that authored neither the change, its review nor its QA pass: 36 of 36 rows Pass, three amended.

### Happy Path

| ID    | Scenario (from plan)                                                                                   | Result    | Evidence                                                                                                                                                                     |
| ----- | ------------------------------------------------------------------------------------------------------ | --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | The family exists with its pair, routing frontmatter, `code/src/scripts/audits/docs-pairing.sh` exit 0 | Pass      | FAMILY-01, FAMILY-03, FAMILY-06                                                                                                                                              |
| HP-02 | The ladder is in the family and absent from TA, which cites it                                         | Pass      | LADDER-01 to LADDER-03; the Celery specifics stay (LADDER-02)                                                                                                                |
| HP-03 | The retry bullets are in the family; the class table stays                                             | Pass      | RETRY-01 to RETRY-03; the class table is byte-identical to `e1ab25a`. RETRY-01's route wording is F-004                                                                      |
| HP-04 | AM's Celery section states only failed-job visibility plus a pointer                                   | Deviation | MONITOR-01 Pass. MONITOR-02 amended at the walk (F-003) for the Q3 reading of Scenario 4, then Pass — Section 4                                                              |
| HP-05 | The three pointers reach the family; no new citation finding                                           | Pass      | POINTER-01 to POINTER-03. POINTER-04: 0 new identities against the baseline — a diff, not a gate pass (below)                                                                |
| HP-06 | The rule inventory balances                                                                            | Deviation | INVENTORY-01 to INVENTORY-06 Pass; INVENTORY-05 amended at the walk (F-001), because deletion reasons cite three homes, not TA alone, and A-07 is deleted as a contradiction |

**The citation gate, read as a diff (HP-05).** `code/src/scripts/audits/doc-references.sh` exits 1 at both ends and is
reported per `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`.
Baseline at `e1ab25a`: 610 findings, 295 distinct identities. Close: 578 findings, 279 identities.
0 new identities; 16 identities (32 findings) resolved, every one a `dangling path` on
`code/docs/reliability/` that resolved when the family was created. The 578 survivors are
pre-existing and owned outside this story. This is not a pass: the gate is red, and the story
neither caused nor cleared those findings. The figures predate this closeout's own records,
and the automated record's generated block is expected to add one identity (F-009).

### Error States

| ID    | Scenario (from plan)                                    | Result | Evidence                                                                                                                                             |
| ----- | ------------------------------------------------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| ES-01 | The family ships a `CONTEXT.md` without its `CLAUDE.md` | Pass   | BITE-01: in a disposable copy, exit 1 naming `code/docs/reliability/CONTEXT.md`; exit 0 once restored                                                |
| ES-02 | A stale-section route and a nonexistent path            | Pass   | BITE-02: the read-across rejects the re-aimed route (R-04 and R-02's reasoning absent); the probe path adds one finding beyond baseline; both undone |
| ES-03 | A new guide born at or above 270                        | Pass   | BITE-04: RETRIES.md padded to 270 is reported in the warn tier, with no allowance; restored                                                          |

### Edge Cases

| ID    | Scenario (from plan)                                                   | Result | Evidence                                                           |
| ----- | ---------------------------------------------------------------------- | ------ | ------------------------------------------------------------------ |
| EC-01 | A rule both cross-surface and Celery-specific                          | Pass   | READ-03: I-03, E-03 and R-06 each in one home, the other citing it |
| EC-02 | 269 against 270 counted lines                                          | Pass   | BITE-03: 269 silent, 270 listed "(30 left)"; inclusive at 270      |
| EC-03 | `code/src/scripts/audits/doctrine-drift.sh`'s three claims undisturbed | Pass   | READ-05: "All 3 claim(s) have exactly one home"                    |
| EC-04 | `code/docs/CONTEXT.md` takes an index row and a repointed citation     | Pass   | POINTER-03: both landed, neither reverted the other                |
| EC-05 | The family's name collides with an existing directory                  | Pass   | FAMILY-07: no path matching the name at `e1ab25a`                  |

### Permission and Access

N/A. The plan has no `PA` scenario: the story adds no runtime surface, endpoint or protected
action (plan Section 2).

## 4. Deviations from plan

| Deviation                                                                                                                                                                                                                        | Justification                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Scenario 4 read under Q3.** The `send_order_confirmation` sample (A-07) was neither monitoring nor a duplicate, and was deleted rather than moved. Scenario 4 says such a rule "moves to the family rather than being dropped" | Sam's grilling answer Q3, 03/11/2026, recorded in the plan's _Key Decisions_: a sample showing retry policy is retry doctrine, and this one retries a permanent failure (contradicting R-01) on an unjittered fixed delay (contradicting R-02). Moving it would plant a contradiction in the family. Scenario 4's clause is read as not applying to a rule that contradicts a moved one. Manual rows INVENTORY-05 and MONITOR-02 amended at the walk (F-001, F-003) |
| **FAMILY-02's provenance clause moved to the plan.** The family's `CONTEXT.md` records why the split falls where it does, not that the names were decided in this story                                                          | A shipped file may cite only what every generated project holds (`code/docs/FORWARD-VOICE.md`). The provenance is in the plan's _Key Decisions_ (Q1). Row amended at the walk (F-002)                                                                                                                                                                                                                                                                               |
| **`code/src/scripts/audits/doctrine-drift.sh` green does not cover prose.** Its exit 0 is reported as a regression guard on three API-envelope JSON claims, never as "no duplication"                                            | `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`. The gate reads fenced code; every rule this story moved is prose. Duplication was checked by human read-across only (READ-01 to READ-03)                                                                                                                                                                                                                                                  |
| **Inventory row E-03 re-dispositioned from kept to moved** during the build                                                                                                                                                      | Review finding R-001: "the class decides retryability" was stated in two homes. RETRIES.md now owns it; TA keeps the class table as its input. The inventory still balances                                                                                                                                                                                                                                                                                         |
| **Five pointers beyond the plan's three**                                                                                                                                                                                        | Found by the review and QA passes, not by the plan's enumeration (F-008)                                                                                                                                                                                                                                                                                                                                                                                            |
| **Build capture arithmetic corrected.** The baseline's expected change was written "33" findings at capture; the identity list sums to 32                                                                                        | Corrected in place with its trail, 03/11/2026; the identity list itself was unchanged (F-007)                                                                                                                                                                                                                                                                                                                                                                       |

## 5. New edge cases discovered

| ID                              | Scenario                                                                                                                                  | Result | Evidence                        | Fold back?                                           |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------------------------- | ---------------------------------------------------- |
| FAMILY-02, FAMILY-04, FAMILY-05 | The story's naming, content-floor and index criteria, which have no QA-plan ID                                                            | Pass   | The manual rows of the same IDs | No — the story owns them                             |
| LENGTH-01, LENGTH-02            | Every new file under 270 at birth; no edited file in the warn tier                                                                        | Pass   | The manual rows of the same IDs | No — plan Step I                                     |
| READ-01, READ-02, READ-04       | The read-across and the one-hop reach from TA                                                                                             | Pass   | The manual rows of the same IDs | No — the story's manual criteria                     |
| —                               | A pointer to the old home outside the plan's named three                                                                                  | Fixed  | Review R-005, R-011, R-012      | Yes — F-008: a pointer sweep greps, never enumerates |
| —                               | A cross-surface rule outside the four inventoried sections — TA _Testing without a broker_, "Retry behaviour is tested by classification" | Open   | QA pass, pre-existing; F-006    | Yes — US005, `DEFERRED.md`                           |

## 6. Deferred scenarios

None. Every plan scenario was walked. The out-of-scope rules the passes found are pre-existing and
routed by the findings record (F-005, F-006).

## 7. Accessibility observations

- **axe-core:** N/A. No rendered route (plan Section 3).
- **Keyboard & focus:** N/A. No interactive component.
- **Equal-weight actions:** N/A.
- **Other:** N/A. The story ships Markdown read in an editor or on a repository host.

## 8. GDPR & security observations

- **PII at rest:** N/A. No personal data is processed.
- **PII in responses:** N/A.
- **Rights paths:** N/A.
- **Security gate:** N/A. No endpoint and no permission surface. The moved failure-record rule
  (inventory R-06) still forbids contents and personal data in an error-tracker event.

## Sign-off checklist

- [x] Every plan scenario (HP/ES/EC/PA) addressed — Pass, or a reason recorded in Section 4/Section 6
- [x] Acceptance-criteria gaps closed or carried forward with evidence
- [x] Deviations from the plan justified
- [x] New edge cases recorded (and folded back into the plan/AC where needed)
- [x] Accessibility observations confirmed against the build (N/A, no rendered surface)
- [x] GDPR & security observations confirmed (or N/A recorded)
- [x] Coverage floors met for all modules in scope (no module in scope)
- [x] Manual testing sign-off (see `../../18-TESTS/MANUAL/US001-MANUAL-TESTING.md`).
      Passed with notes: 36 Pass, 0 Fail, 3 amended (F-001 to F-003); Sam's countersign outstanding
- [ ] Reviewer approval — **blocks merge until complete**. Pending Sam, verified at `23-pr-and-review`

---

## Cross-references

- `../PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — the pre-development plan verified here
- `../../02-STORIES/US001.md` — the story under review
- `../../17-STORY-PLANS/02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — the plan, and its Key Decisions Q1 to Q3
- `../../18-TESTS/AUTOMATED/US001-TEST-STATUS.md` · `../../18-TESTS/MANUAL/US001-MANUAL-TESTING.md` — downstream test records
- `../../20-FINDINGS/FINDING-US001-RELIABILITY-DOCTRINE-HOME-03-11-2026.md` — the findings this review cites
- `../../19-REVIEWS/REVIEW-US001-RELIABILITY-DOCTRINE-HOME.md` — the code review and QA breaker pass
- `project-management/docs/QA-GUIDE.md` — QA planning and test documentation standards
- `project-management/workflows/22-implementation-documentation/` — where this review is written
