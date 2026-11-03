# Code Review — US001 Reliability doctrine gets an owning guide

**Last Updated**: 03/11/2026 · **Story**: US001 · **Status**: In Progress

| Field        | Value                                                                                                    |
| ------------ | -------------------------------------------------------------------------------------------------------- |
| **Story**    | US001 — reliability doctrine gets an owning guide, and every pointer reaches it                          |
| **Branch**   | `us001/reliability-doctrine-home` (cut at `e1ab25a`, uncommitted at this record)                         |
| **PR**       | Not yet raised · target `testing`                                                                        |
| **Reviewer** | Claude — separate `code-reviewer` and `qa-tester` dispatches during the build, neither of which wrote it |
| **Date**     | 03/11/2026                                                                                               |
| **Verdict**  | Approve-with-fixes (code review) · Pass-with-fixes (QA breaker pass) — every fix landed in the build     |

**Codes from:** `../17-STORY-PLANS/02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`
→ _The one lane — documentation_ and _Key Decisions_ (Q1 to Q3, settled 03/11/2026).
**Story:** `../02-STORIES/US001.md` — the acceptance criteria this review
judges against.

---

## 1. Scope & files reviewed

Markdown only: the new reliability family, the two guides it was migrated out of, the pointers
repointed at it, and US001's own PM records. No Python, template, endpoint, migration or UI. The
pre-existing items in Section 6 were found by these passes and are out of this story's scope.

| File                                                                                | Change                                                                                         |
| ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `code/docs/RELIABILITY.md`                                                          | Created — the hub: the one rule seen twice (R-05), sub-documents, what the family does not own |
| `code/docs/reliability/IDEMPOTENCY.md`                                              | Created — the contract, the proof ladder, the run-twice acceptance test                        |
| `code/docs/reliability/RETRIES.md`                                                  | Created — classify first, jittered backoff, bounds, exhaustion, the failure record             |
| `code/docs/reliability/CONTEXT.md` · `code/docs/reliability/CLAUDE.md`              | Created — the family's pair, and why the split falls where it does                             |
| `code/docs/TASK-AUTHORING.md`                                                       | Ladder and retry bullets out, routes in; Celery specifics and the class table kept             |
| `code/docs/performance/API-AND-MONITORING.md`                                       | Celery section reduced to failed-job visibility plus a route; checklist line gains a route     |
| `code/docs/PROCESS-MODEL.md` · `code/docs/NEGATIVE-SPACE.md`                        | The plan's pointers repointed; NEGATIVE-SPACE's non-migrating citations left alone             |
| `code/docs/CONTEXT.md` · `code/CONTEXT.md` · `code/REFERENCES.md` · `REFERENCES.md` | Index rows for the family; `code/docs/CONTEXT.md`'s citation repointed                         |
| `code/docs/NOTIFICATIONS.md` · `code/docs/MANAGEMENT-COMMANDS.md`                   | Routes to the family (R-005, R-016)                                                            |
| `.claude/skills/backend/SKILL.md` · `.claude/skills/notifications/SKILL.md`         | Routes to the family (R-005)                                                                   |
| `code/src/django/apps/core/services/CLAUDE.md`                                      | Retry route repointed (R-011)                                                                  |
| `.copier/README.md`                                                                 | Tree line for the family (R-012)                                                               |
| US001's story, plan, manual guide; the two boards                                   | Status, Key Decisions Q1 to Q3, build captures and the walk; regenerated boards                |

---

## 2. Findings

Two independent passes. **R-001 to R-010** are the `code-reviewer` dispatch (verdict
approve-with-fixes); **R-011 to R-016** are the `qa-tester` breaker pass (verdict
pass-with-fixes), whose own IDs F-01 to F-06 are kept in the Issue column. Severity maps the
reviewer's grade onto this folder's scale: major → High, minor → Medium, nit → Low. The QA pass
graded only F-01; its other five are recorded as Medium, the scale's fix-now-or-ticket grade, and
each was fixed now.

| ID    | Severity | File:line                                                                                                                                        | Issue                                                                                                                                                                 | Resolution/Status                                                                                                     |
| ----- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| R-001 | High     | `code/docs/TASK-AUTHORING.md` _The error taxonomy on this surface_ · `code/docs/reliability/RETRIES.md` _Classify the failure first_             | "The class decides retryability" was stated in two homes                                                                                                              | Fixed — RETRIES.md owns it; TA keeps the class table as its input; inventory row E-03 re-dispositioned to moved       |
| R-002 | High     | `code/docs/performance/API-AND-MONITORING.md` (the deleted A-07 sample) · the story plan                                                         | Scenario 4 ("moves rather than dropped") against deleting the `send_order_confirmation` code sample; the build's grilling answers Q2 and Q3 were not durably recorded | Fixed — Q1 to Q3 recorded in the plan's _Key Decisions_; manual row INVENTORY-05 amended at the walk (finding F-001)  |
| R-003 | Medium   | Manual guide inventory rows A-04, A-05, A-06                                                                                                     | The deletion reasons cited the wrong home                                                                                                                             | Fixed — each cites `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`                                                 |
| R-004 | Medium   | `code/docs/performance/API-AND-MONITORING.md` _Background Jobs and Queues (Celery)_ · `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` _Rules_ | Failed-job monitoring is stated in both; AM claimed to own it                                                                                                         | Fixed in part — AM's ownership claim softened. The duplicate itself is pre-existing: Deferred — US005 (finding F-005) |
| R-005 | Medium   | `code/docs/NOTIFICATIONS.md` · `.claude/skills/notifications/SKILL.md` · `.claude/skills/backend/SKILL.md`                                       | Each described `TASK-AUTHORING.md` as the home of idempotency and retries                                                                                             | Fixed — each routes to `code/docs/RELIABILITY.md`                                                                     |
| R-006 | Medium   | `code/docs/performance/API-AND-MONITORING.md` _Performance Checklist_ (inventory A-12)                                                           | The checklist line had been reworded                                                                                                                                  | Fixed — wording reverted; the line gains a route only                                                                 |
| R-007 | Low      | `code/docs/RELIABILITY.md`                                                                                                                       | The hub carried a new imperative that no inventoried rule stated                                                                                                      | Fixed — removed                                                                                                       |
| R-008 | Low      | `code/docs/api-design/WEBHOOKS.md` retry policy                                                                                                  | Contradicts R-01 (retries a class R-01 calls permanent)                                                                                                               | Deferred — US005 (map slice S-02) scope; the hub now states that WEBHOOKS is not yet reduced to a route               |
| R-009 | Low      | The family's guides                                                                                                                              | Prose wrap                                                                                                                                                            | Fixed                                                                                                                 |
| R-010 | Low      | `code/docs/RELIABILITY.md` _What this family does not own_                                                                                       | Omitted argument freshness, which Q2 kept in `code/docs/TASK-AUTHORING.md`                                                                                            | Fixed — row now names it                                                                                              |
| R-011 | High     | `code/src/django/apps/core/services/CLAUDE.md:37`                                                                                                | QA F-01: still pointed retries at `code/docs/TASK-AUTHORING.md` — a pointer outside the plan's three                                                                  | Fixed — routes to `code/docs/RELIABILITY.md`                                                                          |
| R-012 | Medium   | `.copier/README.md:218`                                                                                                                          | QA F-02: the shipped tree lacked the family                                                                                                                           | Fixed                                                                                                                 |
| R-013 | Medium   | Manual guide inventory row A-05                                                                                                                  | QA F-03: the Cloudinary half of the deleted rule had no cited home                                                                                                    | Fixed — cites AM's own _Performance Checklist_ ("Images are delivered via Cloudinary")                                |
| R-014 | Medium   | Manual guide row FAMILY-02                                                                                                                       | QA F-04: the expected outcome asked a shipped `CONTEXT.md` to state PM provenance, which `code/docs/FORWARD-VOICE.md` forbids                                         | Fixed — row amended at the walk (finding F-002)                                                                       |
| R-015 | Medium   | `code/docs/RELIABILITY.md:19-21`                                                                                                                 | QA F-05: the hub claimed single ownership while WEBHOOKS and the SERVICE-AND-MIDDLEWARE job table still state retry rules                                             | Fixed — the hub states that both still carry rules of their own and are not yet reduced                               |
| R-016 | Medium   | `code/docs/MANAGEMENT-COMMANDS.md:176`                                                                                                           | QA F-06: no route from the CLI guide to the family                                                                                                                    | Fixed — cross-reference added                                                                                         |

Build-time reading that both passes found a pointer the plan's three named pointers missed
(R-005, R-011, R-012) is recorded as finding F-008.

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- N/A — no endpoint, permission, secret or setting is touched. The story's Security flag reads N/A.

### 3.2 GDPR / PII

- N/A — no personal data processed. RETRIES.md _What a failure record carries_ keeps the existing
  rule that a failure record names identifiers, never contents or personal data (inventory R-06).

### 3.3 Test coverage vs floors

- N/A for the code floors — no source changed and no automated test declares US001
  (`../18-TESTS/AUTOMATED/US001-TEST-STATUS.md`).
- [x] Every manual QA acceptance criterion has at least one manual row, walked: 36 of 36 Pass,
      three amended (F-001 to F-003).

### 3.4 Quality, DRY & file length

- [x] No rule stated in two homes across the family, TASK-AUTHORING and API-AND-MONITORING — by
      human read-across (READ-01 to READ-03), because `code/src/scripts/audits/doctrine-drift.sh` reads fenced code only
      (`../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`).
- [x] Instructional files within 300 lines and every new file under 270 at birth — `code/src/scripts/audits/docs-length.sh`
      exit 0 (LENGTH-01, LENGTH-02).
- [x] Pairing intact — `code/src/scripts/audits/docs-pairing.sh` exit 0 (FAMILY-06).
- [x] Skill conformance — `code/src/scripts/audits/skill-conformance.sh` exit 0 after the two skill edits.
- [x] Prettier and markdownlint clean on the story's files; the whole-tree Markdown leg fails only
      in the gitignored `graphify-out/`, pre-existing and filed.

### 3.5 Performance

- N/A — no runtime path.

### 3.6 Accessibility (WCAG 2.2 AA)

- N/A — no user-facing UI in this story.

---

## 4. Required actions before merge

None — every High and Medium raised by either pass is fixed. The two deferred items are
R-004's pre-existing duplicate (a `DEFERRED.md` row, finding F-005) and R-008, which US005's own
story already claims. The known red is listed in Section 6 for the PR body.

---

## 5. Verdict & status transition

- **Verdict:** Approve-with-fixes (code review) and Pass-with-fixes (QA), every fix applied in the
  build and re-walked.
- **Reasoning:** the family exists, the inventory balances (13 moved, 10 kept, 10 deleted, 33
  captured), the read-across finds no rule in two homes, and the citation gate gains no identity
  the story wrote. The remaining retry statements outside the family are recorded as not yet
  reduced, in the hub itself, and are scheduled successors' work.
- **Status transition:** none recorded here. `In Progress` → `In Review` and onward are recorded
  through the `completion` skill at `23-pr-and-review`.

---

## 6. Notes

### Pre-existing, found by these passes, not this story's

| Item                                                                                                                                                                                    | Owner / disposition                                                                                                                                                   |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/api-design/WEBHOOKS.md` retry policy and the _Retry_ column of the job-classification table in `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`                            | US005 (map slice S-02); US005's story names both. The map's N-017 also folds the job table's columns into slice S-04's sweep — whichever story lands first reduces it |
| SERVICE-AND-MIDDLEWARE _Rules_ "Failed jobs must be monitored" duplicating AM's kept residue (A-10)                                                                                     | No slice schedules it — finding F-005, `DEFERRED.md` row to US005, which already edits that list                                                                      |
| RETRIES "a 4xx is permanent" (R-01) against 429 with `Retry-After`, and against `code/docs/MOBILE-CODING-PRINCIPLES.md`'s 408                                                           | Map node N-009, slice S-02 — US005. Moved verbatim by this story; not reworded here                                                                                   |
| TA _Testing without a broker_: "Retry behaviour is tested by classification, not by waiting" — a cross-surface rule outside the four inventoried sections, in one home, unaccounted for | Finding F-006 — `DEFERRED.md` row to US005                                                                                                                            |
| Surface idempotency mentions in `code/docs/api-design/REST-CONVENTIONS.md`, EVENT-TRACKING, `code/docs/testing/TAXONOMY.md`, `code/docs/DATABASE.md` and SCHEMA-MIGRATIONS              | Surface expressions, not doctrine — no action. The idempotency-key contract is map slice S-03's                                                                       |

### Gate evidence

| Gate                                           | Before (`e1ab25a`) | At close (working tree) | Reading                                                                                                           |
| ---------------------------------------------- | ------------------ | ----------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/doc-references.sh`    | exit 1, 610 / 295  | exit 1, 578 / 279       | Identity diff: 0 new; 16 identities (32 findings) resolved, all `dangling path` on the family. A diff, not a pass |
| `code/src/scripts/audits/docs-length.sh`       | exit 0             | exit 0                  | No touched file in the warn tier                                                                                  |
| `code/src/scripts/audits/docs-pairing.sh`      | exit 0             | exit 0                  | Split intact                                                                                                      |
| `code/src/scripts/audits/doctrine-drift.sh`    | exit 0             | exit 0                  | Three API-envelope claims, one home each. Says nothing about prose                                                |
| `code/src/scripts/audits/skill-conformance.sh` | exit 0             | exit 0                  | Unchanged after the two skill edits                                                                               |
| `pm-board.sh --check`                          | —                  | pass                    | Boards current                                                                                                    |

Findings over identities, compared as a multiset with line numbers stripped, per
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`.
The close figures predate this closeout's records; the automated record's generated block is
expected to add one identity of its own (finding F-009).

### Known reds for the PR body

- `Audit — Doc References` / `Citations resolve` — 578 pre-existing findings owned outside this
  story, plus any line the generated test record adds (F-009).

---

## Cross-references

- `../02-STORIES/US001.md` — the story under review
- `../17-STORY-PLANS/02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — the plan, and its Key Decisions Q1 to Q3
- `../18-TESTS/AUTOMATED/US001-TEST-STATUS.md` · `../18-TESTS/MANUAL/US001-MANUAL-TESTING.md` — the test records
- `../11-QA/IMPLEMENTATION/QA-IMPL-US001-RELIABILITY-DOCTRINE-HOME-03-11-2026.md` — the paired QA review
- `../20-FINDINGS/FINDING-US001-RELIABILITY-DOCTRINE-HOME-03-11-2026.md` — the findings
- `../01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` — slices S-02 to S-04, the successors named above
- `project-management/workflows/22-implementation-documentation/` — the workflow this record is written in; `23-pr-and-review` verifies it
