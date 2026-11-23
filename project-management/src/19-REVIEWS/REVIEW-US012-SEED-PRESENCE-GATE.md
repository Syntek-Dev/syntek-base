# Code Review — US012 A seeded file that never lands is reported, and the gate's header claim becomes true

**Last Updated**: 23/11/2026 · **Story**: US012 · **Status**: In Review

| Field        | Value                                                                                                                                                          |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US012 — a seeded file that never lands is reported, and the gate's header claim becomes true                                                                   |
| **Branch**   | `us012/seed-presence-gate` (cut from `dev` at `8e0da02b`; head `25740d72`)                                                                                     |
| **PR**       | Not yet raised · target `dev` — this record is `23-pr-and-review` Step 2, before Step 3 opens it                                                               |
| **Reviewer** | Claude (Opus), `code-reviewer` skill under `review`, 23/11/2026 — an independent dispatch that wrote none of the story's code and none of the records it reads |
| **Date**     | 23/11/2026                                                                                                                                                     |
| **Verdict**  | **Approve-with-nits.** No Critical, High or Medium finding. Four Low record corrections (R-001 to R-004), none blocking                                        |

**Codes from:** `../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` — its CORRECTED
22/11/2026 block is the reading where the body disagrees.
**Story:** `../02-STORIES/US012.md` — the acceptance criteria the code must satisfy.

---

## 0. What this review covers

The branch has two parts, reviewed separately.

1. **The story's own change** (22/11/2026, up to `4dc043c8`): `.github/scripts/shipped-artefacts.sh`
   — check 4's loop over `"${SEEDED[@]}"`, the `4b` self-test probe on the last seed, and the
   header, `--help`, exit-code and closing-guidance wording. It already had a build-time review
   (CR-US012-01 to -05) and a QA pass (QA-01 to -04), recorded in
   `../20-FINDINGS/archive/FINDING-US012-SEED-PRESENCE-GATE-22-11-2026.md`. This record checks only that
   nothing regressed since, and does not re-report those items.
2. **The 23/11/2026 changes made under Sam's explicit rulings** (`532f47ac`, `40d55481`, `da345bc5`,
   `25740d72`): fix the three manual-guide remedies in-story, drop the sprint-plan _Story Plans_
   Status column, accept REMEDY-03 as a non-blocking Fail, and countersign.

---

## 1. Scope & files reviewed

`git diff origin/dev...HEAD` — 30 files. Outside `project-management/`:

| File                                               | Change                                                                                                               |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `.github/scripts/shipped-artefacts.sh`             | Check-4 seed loop (`:283-287`), `4b` probe (`:351-360`), header, `--help`, exit codes, closing guidance (`:437-439`) |
| `code/workflows/01-implement-story/STEPS.md`       | Transition moved from _Prerequisites_ to the end of Step 1 (`:76-88`); documentation-only N/A; board-adapter rule    |
| `code/workflows/01-implement-story/CHECKLIST.md`   | Captures, then the move, then the documentation-only N/A line (`:28-31`)                                             |
| `.claude/skills/implement-story/SKILL.md`          | _Start the clock_ re-ordered to match Step 1 (`:35-40`)                                                              |
| `.claude/skills/completion/SKILL.md`               | Story-transition step 5: an enabled adapter publishes, never writes a status (`:179-180`)                            |
| `.claude/skills/pm-tool-sync/SKILL.md`             | _CI sync_: the workflow publishes the committed status and never moves one (`:112-115`)                              |
| `GAPS.md`                                          | 21/11/2026 build-start entry updated (closes on merge); three 23/11/2026 entries added                               |
| `handoffs/HANDOFF-US010-FIX-ROUND-5-20-11-2026.md` | Deleted (Sam). US012's own handoff was added at `532f47ac` and deleted at `25740d72`, so it nets out of the diff     |

Inside `project-management/`: the column drop in `16-SPRINT-PLANS/01..07`, `US012.md`, `SPRINT-07.md`,
the US012 and US013 plans, the manual guide, `QA-IMPL-US012-…`, `US012-TEST-STATUS.md`, the findings
record, `MAP-SCRIPT-GUARDS.md`, the export and the regenerated boards.

**Out of scope:** GDPR, SEO, API design, accessibility of a rendered page — no personal data, no
route, no Ninja surface, no UI. Accepted and recorded, not re-reported: the 18 dangling
`doc-references.sh` citations and the pre-PR hook calling two `.github/scripts` checks without
arguments (`GAPS.md` 23/11/2026).

---

## 2. Findings

Most severe first. `R-0NN` are this record's; `F-0NN` the findings record's; `QA-F*` the final QA
pass's.

| ID    | Severity | File:line                                                                              | Issue                                                                                                                                                                                                                                                                                                                                                                                                     | Resolution/Status                                                                                |
| ----- | -------- | -------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| R-001 | Low      | `../18-TESTS/MANUAL/US012-MANUAL-TESTING.md:201` (LOOP-07 `Notes`, amendment evidence) | The Expected outcome is right and the `Pass` holds, but the evidence misdescribes the diff. "At the head after `da345bc5`" lists `pm-tool-sync/SKILL.md` (unchanged until `25740d72`) and "the two `handoffs/` deletions". At `da345bc5` the diff shows US012's handoff **added**; at `25740d72` it shows **one** deletion (US010's), because US012's handoff nets out                                    | Open — re-word the evidence to the `25740d72` reading: seven files plus one `handoffs/` deletion |
| R-002 | Low      | `../18-TESTS/MANUAL/US012-MANUAL-TESTING.md:152` (REMEDY-01 re-walk note)              | The note quotes Step 1 as marking "Steps 3 to 7" N/A, with `532f47ac` line numbers. QA-F2 widened the rule to Steps 2 to 8 (3a and 7M) at `25740d72`. The `Pass` still holds, because the expected outcome only asks that code phases read N/A. But the note no longer describes the text at HEAD, and it says nothing to show that                                                                       | Open — append "QA-F2, `25740d72`: widened to Steps 2 to 8 (3a, 7M); the Pass holds"              |
| R-003 | Low      | `/GAPS.md:1654` (23/11/2026, `hosts-story-add.sh` entry)                               | QA-F3 removed US012 from the list of plans carrying the failing `us###` form. US014 is the same error: `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md:715` and `:933` give the numeric `014`. Only US006, US007 and US010 still carry `us###`                                                                                                                                          | Open — drop US014 from the list                                                                  |
| R-004 | Low      | `../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md:9`, `:765-766`            | `\| Status \| In Progress` is stale (the story is `In Review`, `40d55481`). It also contradicts `../17-STORY-PLANS/CLAUDE.md:59` ("A plan carries no status"), which is the same reasoning Sam applied to drop the sprint-plan column. `:765-766` still promises the row and a sprint-plan Status cell. The CORRECTED block does not supersede either. The legacy row is also in the US001 to US009 plans | Open — remove the row with a dated note, as US010's plan did at `:10`, or record it beside F-009 |
| R-005 | Info     | `/GAPS.md:1509-1519`                                                                   | The 21/11/2026 build-start entry says it "closes when that branch merges". Nothing on the branch marks it `✅ CLOSED`. `.claude/CLAUDE.md` Section 9 gives that edit to `22-implementation-documentation`, so it needs a post-merge touch                                                                                                                                                                 | Owner: `22`, after merge                                                                         |
| R-006 | Info     | CI                                                                                     | `shipped-artefacts.sh`, `copier.yml`, `.copier/` and `.github/workflows/` are unchanged since `4dc043c8`. Template Integrity was green there (9 probes; both rendered trees clean). The four later commits are instruction and record files that the job's path filter never triggers. Its CI reading is the landing head's, and the later commits are **unmeasured** rather than green                   | No action — `code/docs/GATE-REPORTING.md`                                                        |
| R-007 | Info     | Inherited                                                                              | The two accepted gaps keep this PR's _Audit — Doc References_ check and the local pre-PR gate red, whatever the branch holds (`GAPS.md` 23/11/2026, both entries)                                                                                                                                                                                                                                         | Recorded, not this branch's defect                                                               |

---

## 3. Dimension checklists

### 3.1 Standards axis

- [x] **Part 1 has not regressed.** `git diff 4dc043c8 HEAD -- .github copier.yml .copier` is
      empty. `bash -n` and `shellcheck` are clean on the host, 23/11/2026. The CR-US012 and QA-0N
      items stand as recorded.
- [x] **Build-start reorder.** In `STEPS.md` the transition leaves _Prerequisites_ (`:31`) and
      follows the due captures (`:72-74`, then `:81-88`). The documentation-only rule names Steps 2
      to 8 with 3a and 7M, and "Step 9 onward still runs". `CHECKLIST.md:28-31` and
      `implement-story/SKILL.md:35-40` agree. No carrier in `code/`, `how-to/`,
      `project-management/workflows/` or `.claude/skills/` still puts the move at branch creation.
- [x] **Skill edits against `how-to/docs/SKILL-AUTHORING.md`.** Each edit is prose inside an
      existing section and routes to `STEPS.md` Step 1 or `clickup-sync.yml` rather than restating
      either. `bash code/src/scripts/audits/skill-conformance.sh`: "Every skill conforms", 65 skills.
- [x] **Column drop.** No `Status` header remains in the _Story Plans_ table of plans 01 to 08
      (08 never had one) or of the template. Each of 01 to 07 carries a dated `STATUS COLUMN
DROPPED 23/11/2026` note. `16-SPRINT-PLANS/CLAUDE.md:51`, `workflows/16-sprint-plans/` and
      `workflows/17-story-plans/` already say "no status cell", so the rule and the files now agree.
- [x] **Writing conventions** (`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2).
      There is no U+00A7 and no curly quotes or en dashes in added lines. The only `…` sits inside
      quoted CI log output. British spelling throughout.
- [x] **Length.** `bash code/src/scripts/audits/docs-length.sh`: all 818 instructional files are
      within 300 lines, and none touched here is among the three approaching it.
- [x] **Lint.** `bash code/src/scripts/syntax/lint.sh --file-type markdown`: 0 issues in 1177 files.
- [x] **Boards.** `bash project-management/src/00-ASSETS/scripts/pm-board.sh --check`: all 8 current,
      `archive/` untouched.
- [x] **Records internally consistent**, bar R-001 to R-004.

**Standards verdict: Pass with minor changes** (R-001 to R-004, all Low).

### 3.2 Spec axis

- [x] **Check 4 reports a seed that never lands.** The loop over every `SEEDED` entry is at
      `shipped-artefacts.sh:283-287`. The finding names the `.copier/` file or `mv` line, never a `!`.
- [x] **The self-test proves it.** The `4b` probe moves the last seed by index expression
      (`:351-360`). The self-test counts **9** probes where it counted 8 (CORRECTED block; the
      story's amendment of 22/11/2026). Red at `81cc0079`, green at `17a20ed7` and at the landing
      head.
- [x] **The header claim is true.** The header, `--help`, exit codes and closing guidance name the
      seed presence check.
- [ ] **The 72-case matrix** is unmeasured and its criterion unticked. Sam accepted REMEDY-03 as a
      non-blocking Fail on 23/11/2026, owned by `MAP-GENERATION-COVERAGE.md` S-01. It is not a
      Spec gap of this branch.
- [x] **Sam's 23/11/2026 rulings are carried out as ruled.** The remedies are fixed in-story and
      REMEDY-01 re-walked Pass. The column is dropped and REMEDY-02 superseded. REMEDY-03 stays a
      non-blocking Fail, and Sam's countersignature is recorded in the guide's sign-off.

**Spec verdict: Meets spec**, with the accepted REMEDY-03 deviation.

### 3.3 The final QA pass — 23/11/2026

`23-pr-and-review` Step 1 found no Critical or High issue. Its fixes landed in `25740d72`. The
verification below is this review's.

| ID    | Fix                                                                             | Verified                                                                                                                                                                                                                                       |
| ----- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| QA-F1 | `pm-tool-sync` _CI sync_ no longer says PR events move statuses, or uses `Done` | **Landed correctly.** `:112-115` match `clickup-sync.yml`: it runs on pushes and PRs to the chain branches, publishes the exported committed status, and moves none                                                                            |
| QA-F2 | The documentation-only N/A rule covers Steps 2 to 8                             | **Landed correctly** in `STEPS.md:85-86`, `CHECKLIST.md:31` and `implement-story/SKILL.md:39-40`, with 3a and 7M named in the first two. The REMEDY-01 note was not updated (R-002)                                                            |
| QA-F3 | The `GAPS.md` `hosts-story-add` list no longer names US012's plan               | **Landed**, but the same error remains for US014 (R-003)                                                                                                                                                                                       |
| QA-F4 | `US012.md` records that one `GAPS.md` entry now closes on merge                 | **Landed correctly**, both at the "NO LIVE GAPS.md ROW" comment (`:37-38`) and in the Definition of Done row (`:576-578`), citing F-008 and F-009                                                                                              |
| QA-F5 | LOOP-07 amended with its trail, plus F-011                                      | **Landed — Expected outcome correct, evidence imprecise (R-001).** The amended outcome matches `git diff --name-only origin/dev...HEAD` outside `project-management/`. The trail has was / why / evidence, and F-011 is in the findings record |
| QA-F6 | REMEDY-01 note: "landed 23/11/2026 in `532f47ac`"                               | **Landed correctly** as a fact. The rest of the note pre-dates QA-F2 (R-002)                                                                                                                                                                   |
| QA-F7 | F-007's carry wording                                                           | **Landed correctly.** The findings record says "noted … as already met there (it gives `013`)", and the US013 plan's CARRIED block (`:31-38`) agrees: `13-STORY-PLAN-US013:419` and `:574` give `013`                                          |

The QA pass's own verified checks, as reported to this review:

- the self-test passes with **9 probes**;
- the full run on **two rendered trees** (`INCLUDE_MOBILE` false and true) exits 0;
- `pm-board.sh --check` is green;
- the pre-PR gate is **BLOCKED**, but only by the two recorded inherited failures (R-007), a host
  lockfile environment gap, and a typecheck leg it could not measure. None of those is caused by
  this branch, and neither the lockfile gap nor the typecheck leg is a pass.

### 3.4 Security, GDPR, coverage, performance, accessibility

- [x] **Security:** no endpoint, no secret, no `.env` read. The script reads a generated tree
      with `-f` tests and an `mv` inside its own `$tmpdir`.
- [x] **GDPR/PII:** N/A — no personal data.
- [x] **Coverage:** the proof is the Bash self-test (F-010). Neither `test-record.sh` nor
      `story-markers.sh` can see it, so the automated record is hand-written, as recorded.
- [x] **Performance:** one loop over ten paths. N/A otherwise.
- [x] **Accessibility:** N/A — no UI. RED-03 confirms the probe's failure line does not rely on
      colour.

---

## 4. Required actions before merge

None — approved as-is. R-001 to R-004 are Low record corrections, cheap enough to fix before the
PR. If left, they need no re-review.

**Resolved 23/11/2026, before the PR was raised** (main session, no re-review needed per the line
above):

- **R-001** Done. LOOP-07's evidence is restated at `25740d72`: `pm-tool-sync` dated, and one
  `handoffs/` deletion.
- **R-002** Done. The REMEDY-01 note records QA-F2's widening to Steps 2 to 8.
- **R-003** Done. The `GAPS.md` list now reads US006, US007 and US010, and names the US012, US013
  and US014 plans as numeric.
- **R-004** Done. The plan's `| Status |` row was removed and the `:765-766` promise superseded,
  each with a dated note, as US010's plan did.

---

## 5. Verdict & status transition

- **Verdict:** Approve-with-nits.
- **Reasoning:** The story's script change is unchanged since its reviewed and CI-green landing
  head. The 23/11/2026 changes carry out Sam's rulings as ruled, and every QA-F fix landed. What
  remains is four Low record inaccuracies, none of which changes a verdict, a status or a rule.
- **Status transition:** none from this step. US012 stays `In Review`. `In Review` → `Accepted`
  follows the PR through `23-pr-and-review`, recorded by `completion`.

---

## 6. Notes

- The branch widened beyond the story's write set by Sam's ruling (F-011). The widening is all
  instruction and register files, and it is the fix US010's REMEDY-01 routed to `GAPS.md`. Fixing
  it here was cheaper than a separate story, and the US012 re-walk proves it.
- Dropping the column rather than re-mirroring it removes a status copy that three carriers already
  said should not exist. R-004 is the last instance of that copy on this story's own plan.
- After merge, `22` marks the 21/11/2026 `GAPS.md` entry `✅ CLOSED` (R-005).

---

## Cross-references

- `../02-STORIES/US012.md` — the story under review
- `../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` — the plan this code was written from
- `../18-TESTS/AUTOMATED/US012-TEST-STATUS.md` · `../18-TESTS/MANUAL/US012-MANUAL-TESTING.md` — the
  test records this review reads against
- `../11-QA/IMPLEMENTATION/QA-IMPL-US012-SEED-PRESENCE-GATE-22-11-2026.md` — the paired QA review
- `../20-FINDINGS/archive/FINDING-US012-SEED-PRESENCE-GATE-22-11-2026.md` — findings F-001 to F-011
- `project-management/workflows/23-pr-and-review/` — the PM workflow where this review is written
- `code/workflows/07-review/` — the code-review workflow the reviewer runs
