# Code Review — US007 The story status vocabulary gets one owner

**Last Updated**: 02/11/2026 · **Story**: US007 · **Status**: In Review

| Field        | Value                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------ |
| **Story**    | US007 — the story status vocabulary gets one owner                                               |
| **Branch**   | `us007/status-vocabulary-one-owner` (cut at `777595f`, rebased onto `a9378ec`, PR #19)           |
| **PR**       | Raised by Sam · target `testing`                                                                 |
| **Reviewer** | Claude — separate `code-reviewer` and `qa-tester` dispatches, at the build and at `23` Steps 1–2 |
| **Date**     | 02/11/2026                                                                                       |
| **Verdict**  | Approve-with-nits                                                                                |

**Codes from:** `../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` →
_Re-cut — 02/11/2026_.
**Story:** `../02-STORIES/US007.md` → _Re-cut criteria — 02/11/2026_ (RC-1 to RC-6), the bar
this review judges against; the original criteria are superseded.

---

## 1. Scope & files reviewed

Markdown only: the shipped PR and release workflows, three shipped templates, the manual-guide
template, and US007's own planning records. No Python, template, endpoint, migration or UI. Out of
scope and recorded: the follow-up findings F-015 to F-018 (`GAPS.md`), and the two tooling bugs
F-002 and F-012 (`../21-BUGS/`), filed for a later fix on Sam's instruction.

| File                                                                    | Change                                                                      |
| ----------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `project-management/workflows/23-pr-and-review/CHECKLIST.md`            | RC-1 — _Story status_ block, one box per transition Steps 3 and 5 order     |
| `project-management/workflows/23-pr-and-review/STEPS.md`                | RC-1, RC-5 — Step 3 through `completion`; ClickUp clauses clickup-only      |
| `project-management/workflows/24-release/CHECKLIST.md`                  | RC-1 — the release sets no story's status                                   |
| `project-management/workflows/24-release/STEPS.md`                      | RC-5 — ClickUp clause clickup-only                                          |
| `project-management/src/16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`  | RC-2 — DoD names the sprint record's `Done`                                 |
| `project-management/src/03-SPRINTS/SPRINT-00-TEMPLATE.md`               | RC-2 (widened) — stories `Accepted` or later; sprint `Done` by `completion` |
| `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` | RC-5 — clickup-only markers; export guarded `if … fi`; still 822 lines      |
| `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md`        | RC-4 — `In Progress` casing                                                 |
| `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`        | RC-3 — `:228` pointer and a dated end note; no cited line moves             |
| `CHANGELOG.md` · `RELEASES.md`                                          | Unreleased notes                                                            |
| US007's story, plan, guide, QA-IMPL, TEST-STATUS, FINDING; two bugs     | Records; `GAPS.md` and `DEFERRED.md` rows                                   |

---

## 2. Findings

| ID    | Severity | File:line                                                                   | Issue                                                                                                                       | Resolution/Status                                                             |
| ----- | -------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| R-001 | High     | `../18-TESTS/MANUAL/US007-MANUAL-TESTING.md` DOCREF-01/02; QA-IMPL; FINDING | Records claimed RC-6's "gain no line" held; the walk predated the generated TEST-STATUS block                               | Fixed — rows re-walked as Fail, routed to F-012 and F-014                     |
| R-002 | High     | `project-management/src/03-SPRINTS/SPRINT-00-TEMPLATE.md:345,:351`          | Shipped template still marked stories **Done** and the sprint "closed in the project board"; re-cut had dropped them        | Fixed — RC-2 widened; F-019                                                   |
| R-003 | Medium   | QA-IMPL header; guide CAPTURE-02, DOCREF-04                                 | Base recorded as `777595f`; branch was rebased onto `a9378ec` (PR #19) before the first commit                              | Fixed — PR #19 recorded as moving no finding                                  |
| R-004 | Medium   | `FINDING-US007-…`; `DEFERRED.md`                                            | F-007 and F-013 dispositioned `Next story` with no register row                                                             | Fixed — three `DEFERRED.md` rows; the SPRINT-01 Definition of Done reconciled |
| R-005 | Low      | `00-STORY-PLAN-US000-TEMPLATE.md:750`                                       | `[ -f … ] &&` as a block's last line exits 1 without ClickUp                                                                | Fixed — `if [ -f … ]; then …; fi`                                             |
| R-006 | Low      | `BUG-TEST-RECORD-…`                                                         | Root cause named one of three leak sites; repro would overwrite the record                                                  | Fixed — widened; repro uses `--dry-run`                                       |
| R-007 | Medium   | `completion/SKILL.md`; `24-release/*`; `23` Steps 1–3                       | Sprint `Done` move ordered nowhere; `In Review` timing against its meaning; `N/A` skip ignored in 24 Step 5; Step 3 wording | Deferred — `GAPS.md`, F-015 to F-018                                          |
| R-008 | Low      | `../21-BUGS/BUG-*-02-11-2026.md`                                            | No target story named, which the folder's DoD asks for                                                                      | Won't-fix now — filed for a later fix on Sam's instruction                    |
| R-009 | Info     | `GAPS.md` US007 entry                                                       | Finding path in double quotes rather than backticks                                                                         | No action — keeps it out of the template-only citation regime                 |

Build-phase review and QA findings (two Minor; one Medium, six Low) were fixed before the
closeout and are recorded in `../11-QA/IMPLEMENTATION/QA-IMPL-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md`.

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- N/A — no endpoint, permission, secret or setting is touched.

### 3.2 GDPR / PII

- N/A — no personal data processed. The story's GDPR flag reads `N/A`.

### 3.3 Test coverage vs floors

- N/A for the code floors — no source changed and no automated test declares US007. The automated
  record's coverage figure is the project's, disowned in its Section 3 (F-012).
- [x] Every re-cut criterion has at least one manual row, walked: 27 Pass, 3 Fail, 39 retired.

### 3.4 Quality, DRY & file length

- [x] No duplication — every new block routes to `completion/SKILL.md` rather than restating it.
- [x] Instructional files within 300 lines — `docs-length.sh` exit 0.
- [x] Lint clean on every changed file (`lint.sh --path`). The whole-tree Markdown leg fails only
      on the gitignored `graphify-out/` (F-002).

### 3.5 Performance

- N/A — no runtime path.

### 3.6 Accessibility (WCAG 2.2 AA)

- N/A — no user-facing UI in this story.

---

## 4. Required actions before merge

None — every High and Medium raised before the PR is fixed or deferred with a register row.
The known reds are listed in Section 6 for the PR body.

---

## 5. Verdict & status transition

- **Verdict:** Approve-with-nits.
- **Reasoning:** RC-1 to RC-5 hold on disk; RC-6 holds but for one generated citation line that
  only the filed `test-record.sh` fix can remove. The three manual Fails are tooling defects, filed.
- **Status transition:** none recorded here. `In Review` → `Accepted` is recorded through the
  `completion` skill once Sam accepts this review and the PR's CI (`23` Step 5).

---

## 6. Notes

### Gate evidence — durable copy

Captured from `/tmp/us007-baseline/` and `/tmp/us007-fix/`, which do not survive a reboot. The
baseline is reproducible by checking out `777595f`; the closeout re-ran it there and matched it
byte for byte.

| Gate                                        | Before (`777595f`) | At close (branch head) | Reading                                                         |
| ------------------------------------------- | ------------------ | ---------------------- | --------------------------------------------------------------- |
| `audits/doc-references.sh`                  | exit 1, 609        | exit 1, 610            | Identity diff: 0 `<`, 1 `>` — the generated TEST-STATUS line    |
| `audits/skill-conformance.sh`               | exit 0             | exit 0                 | Unchanged                                                       |
| `audits/docs-pairing.sh`                    | exit 0             | exit 0                 | Unchanged                                                       |
| `audits/doctrine-drift.sh`                  | exit 0             | exit 0                 | Unchanged                                                       |
| `audits/docs-length.sh`                     | exit 0             | exit 0                 | Unchanged                                                       |
| `pm-board.sh --check` / `--warn`            | pass / none        | pass / none            | Boards current; no stale status                                 |
| `syntax/lint.sh --path` (each changed file) | —                  | exit 0                 | Whole-tree Markdown leg: exit 1, all in `graphify-out/` (F-002) |

The identity diff compares `(file, kind, token)` with line numbers stripped and multiplicity kept,
per `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`.
PR #19 (`a9378ec`), which landed between capture and close, moved no finding.

### Known reds for the PR body

- `Audit — Doc References` / `Citations resolve` — 609 pre-existing findings owned by US004, plus
  the one generated line above (F-012).

---

## Cross-references

- `../02-STORIES/US007.md` — the story under review
- `../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the plan
- `../18-TESTS/AUTOMATED/US007-TEST-STATUS.md` · `../18-TESTS/MANUAL/US007-MANUAL-TESTING.md` — the test records
- `../11-QA/IMPLEMENTATION/QA-IMPL-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` — the paired QA review
- `../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` — the findings
- `../21-BUGS/` — the two tooling bugs
- `project-management/workflows/23-pr-and-review/` — the workflow this record is written in
