# US011 — Manual Testing Guide

_The manual testing guide for US011 — the reads, counts, CI runs and planted mutations a tester follows step by step across the four backfilled indexes, and, once walked, whether each passed. Authored from the specs at `17-story-plans` Step 7.2 on 03/10/2026, before any code and before US010, which creates the four files, is built; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 03/10/2026 · **Story**: US011 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US011.md` — the four indexes that shipped blank get a row per instance, and each register stops claiming it is empty
- **Story plan:** `../../17-STORY-PLANS/12-STORY-PLAN-US011-REGISTER-INDEX-BACKFILL.md` — the code master this guide was authored beside
- **Branch:** `us011/register-index-backfill`
- **Surface:** Gate — every row reads a file in the repository, runs a `git` or text reading over it, runs a `.github/scripts/` self-test or a `code/src/scripts/audits/` gate, or reads a CI run by its recorded ID. No stack, no browser
- **Authored from:** `../../02-STORIES/US011.md` (Acceptance Criteria and its eight scenarios, QA Acceptance Criteria — Automated and — Manual, Tasks, Verification Checks, Definition of Done); `../../11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md` (Sections 1 to 8, as corrected in place 03/10/2026); `../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (TM-02, TM-03, TM-09, TM-10, TM-11 and Section 3a) and `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (Sections 7.11 and 7.12) — US010's two signed-off security plans, the only security artefacts naming this story, whose own Security flag reads `N/A`; `../../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` (Decision); `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (Decision); `../../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` (Build order, the lane, Gate honesty, Sprint Verification Checklist, Sprint Definition of Done); `../../03-SPRINTS/SPRINT-07.md` (QA Acceptance Criteria — Manual, QA Tasks — Manual, Definition of Done); `../../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (P2's shape of the four files, the generated-tree grep and the link check — the index shapes this story fills); `../../17-STORY-PLANS/12-STORY-PLAN-US011-REGISTER-INDEX-BACKFILL.md` (Approach P0 to P5, Key Decisions, Testing, Status Propagation); `project-management/workflows/23-pr-and-review/STEPS.md` (Step 3's `In Review` commit) and `lefthook.yml` with `../../00-ASSETS/scripts/precommit-clickup.sh` (the ClickUp export hook), read for REACH-03 and the question it raised, answered 03/10/2026 (_Preconditions_ → _Open questions_). No `04`–`09`, `12`–`14` artefact exists for this story: those flags read `N/A`. Never code.

> **Authored before code, walked after it.** Which workflow writes which part of this file, and
> when, is `../CLAUDE.md` → _The record lifecycle_. Every rule for filling it — authoring, open
> questions, row IDs, the two citation columns, the build captures, marking, amendments and the
> browser contract — is this folder's `CLAUDE.md`. Neither is restated here.
>
> **What this file is, and is not.** This records **executing** the manual tests and their outcome.
> Whether the story met its specified scenarios is `../../11-QA/IMPLEMENTATION/`; whether the flow
> exists as designed is `../../05-USER-FLOW/IMPLEMENTATION/`. Three records, three questions.

---

## Preconditions and environment

- **Stack:** none — this story runs no container and renders nothing (plan → _Quality Gates,
  Scripts & Local↔Docker Alignment_)
- **Base URL:** none — no rendered surface
- **Seed data:** none — the population under test is this repository's own tracked tree
- **Accounts / roles:** none — no role boundary exists (QA plan Section 2 → _Permission and access_)
- **Where the walk runs:** the story's checkout with every phase of the plan landed and pushed, so
  that CI has run on the landing commit
- **The four files:** STORY-INDEX, SPRINT-INDEX, DECISION-INDEX and STORY-PLAN-INDEX, in
  `../../02-STORIES/`, `../../03-SPRINTS/`, `../../15-DECISIONS/` and `../../17-STORY-PLANS/`. US010
  creates them; none exists when this guide is authored
- **The instance test:** QA plan Section 6's command — each register's positive filename pattern
  over tracked files, `*TEMPLATE*` and the index excluded by exact filename, never by a suffix
- **The read rule:** the carrier value with bold markers, backticks, any trailing HTML comment and
  everything from the first space-middle-dot-space removed, then trimmed, applied to the value after
  the key (`../../15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md`). QA plan Section 6
  carries a sketch for checking rows
- **The CI runs:** a generated tree exists only in CI's `[3/4] Template Generation` job (QA plan
  Section 6). A row that reads one opens the run recorded under _Recorded during the build_ — never
  a local generation, and never a raw `copier` call (`.claude/CLAUDE.md` Section 6). **One project
  script is the exception, and only it:** `shipped-ai.sh` (SCRIPT-02) drives real Copier copies and
  updates over throwaway fixtures inside itself, through `uvx --offline` — the project's own wrapper,
  never a raw call, and never over this tree
- **The Copier cache:** the walker's host holds uv's cached Copier environment, or a Python
  environment with Copier that `bash .github/scripts/shipped-ai.sh --python PATH --self-test` can
  name. SCRIPT-02 needs one and downloads nothing; a walk on a host with neither is not complete
  until SCRIPT-02 has run on one that has
- **A scratch copy of this tree:** a separate checkout of the story branch, never this working
  tree, for the rows that plant a mutation. Each such row takes a fresh copy, or restores it before
  the next row. How the copy was made is recorded beside the result
- **The baseline:** captured at the plan's P0, **before the first edit**, and pasted into
  _Recorded during the build_ at capture. A baseline taken after an edit is void — START-05
- **The story's own diff:** every row that lists or diffs the change — STATUS-04, DEBT-01, REACH-01
  to REACH-05, SCRIPT-03 and MAP-01 — reads `git diff <recorded base> HEAD`, the base being
  `git merge-base main HEAD` recorded at the plan's P5, after its rebase onto `main`. Never a diff
  against the pre-edit SHA: once rebased, that diff also carries every commit `main` gained since
  P0 — US012's script edit, a renumbered plan, a map repair — and reports it as this story's. The
  pre-edit SHA anchors the start captures alone. Where the QA plan says "the recorded pre-edit SHA"
  (HP-11, Section 6's debt listing), this base is how it is read
- **The link counts:** where the QA plan compares links checked against rows (ES-02, Section 6),
  the count compared with rows is CELL-08's Instance-link count; CELL-01's total of link targets
  tested is recorded beside it, since the tail and out-of-table links make it exceed rows on a
  correct DECISION-INDEX
- **The legibility reader:** a fresh Claude session given only the index file it reads, its walk
  reviewed by <%DEVELOPER_NAME%> (settled 03/10/2026, 17-story-plans grilling round 1 Q3). One
  session per index: a session that has read one index has been given more than "only the index
  file" for the next
- **The tester:** someone other than the author of the story's edits
- **Every figure is counted at the walk.** No count in this guide is a target, and none is copied
  from the QA plan's dated readings (`../../02-STORIES/US011.md:309`)
- **Out of scope:**
  - **HP-10's and PA-01's direct read of a generated tree's four index files** — no project script
    generates a tree locally, and the CI run prints no file's contents. Both are walked through the
    two controls that read content: US010's generated-tree grep over every generated index (GEN-02)
    and US010's seed family proving every seed blank (SCRIPT-01), with `.copier/` untouched by the
    story's diff (REACH-04). `shipped-artefacts.sh` is not one of them: it admits each seeded index
    path by name and cannot read content (TM-09), so its green (GEN-03) is HP-12's evidence, never
    PA-01's
  - **Permission and access** — section dropped: no endpoint, screen or protected action (QA plan
    Section 2). PA-02 and PA-03 are walked as REACH-05 and REACH-02
  - **Accessibility** — section dropped: Markdown read in an editor (QA plan Section 3). Its one
    property, the Instance link's label, is CELL-02
  - **Responsive behaviour** — section dropped: no rendered screen (QA plan Section 4)
  - **The automated criteria** — `docs-length.sh`, `docs-pairing.sh`, `lint.sh`, `check.sh` and
    `tests/all.sh` are the automated record's. `shipped-artefacts.sh --self-test` reads a generated
    tree and runs in CI only; it is read once, as GEN-03, never run locally
  - **The register write** — the TM-10 window's `GAPS.md` entry is written by
    `22-implementation-documentation` and verified at `23-pr-and-review`, not walked here
  - **The implementation record's notes** — the rows the read rule normalised and the `Proposed`
    chain head — are written at `22`; CHAIN-02 and STATUS-04 walk the rows they describe
  - **The post-merge `Updated` re-check** — every row's `Updated` read again against the merged
    commit, in case a squash at promotion rewrote the dates. The merge follows the walk, so the
    re-check is `23-pr-and-review`'s (plan → _Risks_)
- **Open questions** — none open. The one raised at Step 7.2 was answered by the developer on
  03/10/2026 (17-story-plans grilling round 4), and the row it held is rewritten from its answer:
  1. **What US011.md, its `12-` plan and SPRINT-07 may carry in the story's diff, and in which
     commits — REACH-03** — answered (Q8), the recommended option of three (settled 03/10/2026,
     17-story-plans grilling round 4 Q8). The records had pulled two ways: QA plan HP-11 expected
     "no instance file of the four registers touched" and the story's Documentation Task recorded
     "that no instance file was edited", while the spine scenario (`../../02-STORIES/US011.md:317`)
     and QA plan EC-09 anticipate these files changing, the story's Tasks are marked complete before
     a PR (`:430`, "Mark each complete before a PR") and its Definition of Done checks them off
     (`:531`, "All tasks checked off"), and `23-pr-and-review` Step 3 commits the `In Review` flip
     on the branch. **The answer:** the three files carry only their status carriers and the task,
     checklist and Definition-of-Done ticks the story's Tasks and gate `23` require. Each status
     flip is a commit of its own, touching only that carrier; a US011.md flip carries
     `project-management/export/clickup/US011-CLIENT.md`, which the lefthook `clickup-export`
     pre-commit hook regenerates and re-stages whenever US011.md is staged. No tick rides in a
     backfill commit, and every other instance file of the four registers stays untouched. QA plan
     HP-11 and PA-03 and the story's Documentation Task were corrected in place the same day to
     name this exception (plan → Key Decision 11). Rejected: no instance file in the diff at all,
     at odds with `:430` and gate `23`'s branch commit; status carriers and the export only, every
     tick recorded elsewhere, at odds with `:430` and `:531`

---

## Recorded during the build

The captures the rows below read. The implementer fills the start slots at the plan's P0, before
the first edit — never reconstructed afterwards
(`../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` puts the
baseline in this file) — and each later slot at the moment it names; the walker fills the walk-time
slots. Each captured set is a fenced block beneath this table, with its date. Nothing here carries a
`Result`.

| Capture                                                                                                                                                                                         | Required by                                                                                   | Taken                                                | Value |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ----- |
| US010's landing — `main`'s SHA, and for each of the four files: present, its `Backfill owed — US011` line, its spine, its tail columns as named, its ordering sentence, its _How to read a row_ | SPRINT-07 → Definition of Done; the story's Dependencies; QA plan ES-09                       | Before the first edit                                |       |
| Pre-edit tree — `git rev-parse HEAD` and the `git status --porcelain` count                                                                                                                     | The plan's P0 — the anchor of the start captures; QA plan Section 6                           | Before the first edit                                |       |
| Whole-tree `doc-references.sh` set as `(file, kind, token)`, line dropped, multiplicity kept; the detector's `git hash-object`; HEAD; the index state                                           | The ADR above; the story's QA Acceptance Criteria — Automated                                 | Before the first edit                                |       |
| The same gate, same form, same index state                                                                                                                                                      | The same                                                                                      | At the walk                                          |       |
| The population at the start — the instance-test command, its per-register lists and counts, the date, HEAD                                                                                      | The story's Measurement Tasks; QA plan HP-01                                                  | Before the first edit                                |       |
| 20-FINDINGS and 21-BUGS counted under their patterns                                                                                                                                            | The story's Measurement Tasks; QA plan EC-12                                                  | Before the first edit                                |       |
| The carriers re-read — each register's carrier form, and every value the read rule changes beyond the plans' backticks and padding                                                              | The story's Measurement and Documentation Tasks; QA plan EC-10                                | Before the first edit                                |       |
| Whether US007 and US012 had landed on `main`                                                                                                                                                    | QA plan EC-13; the story's automated criterion on `shipped-artefacts.sh`                      | Before the first edit                                |       |
| The population at landing — the same command, its counts, the landing commit's HEAD                                                                                                             | QA plan EC-11 and EC-16; the plan's P5                                                        | At the commit that lands the story                   |       |
| The story's base — `git merge-base main HEAD` after the plan's P5 rebase onto `main`, and `git log --oneline <base>..HEAD`                                                                      | QA plan HP-11 and Section 6, read per _Preconditions_ → _The story's own diff_; the plan's P5 | At the commit that lands the story, after the rebase |       |
| The landing commit's workflow run — its ID, the commit SHA, and the `[3/4]` result on each render path                                                                                          | The story's QA Acceptance Criteria — Automated; QA plan HP-10                                 | When that run completes                              |       |
| Per index: rows, instances, link targets tested, and rows whose Instance cell holds a link — each with the command and HEAD                                                                     | The story's link-resolution criterion; QA plan ES-02 and Section 6                            | At the walk                                          |       |
| The legibility readers' readings — one per index, verbatim, the developer's review beside each, and the count of Summaries read beside the count of rows                                        | The story's QA Acceptance Criteria — Manual; QA plan HP-13; settled 03/10/2026, round 1 Q3    | At the walk                                          |       |
| The chain walk — each `Superseded` ADR, its replacement, the replacement's Status, and whether the two fields agree                                                                             | The story's QA Acceptance Criteria — Manual; QA Tasks — Manual                                | At the walk                                          |       |

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The start gate

| ID       | Action                                                                                    | Expected outcome                                                                                                                                                                                   | Flow | QA    | Result | Notes |
| -------- | ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| START-01 | Open _Recorded during the build_ → US010's landing                                        | US010 had landed on `main` before the first edit: all four files present, each with its debt line, spine, named tail, ordering sentence and _How to read a row_, and no row and no placeholder row | —    | ES-09 |        |       |
| START-02 | Compare that capture's date and SHA with the first commit on the story branch             | The capture precedes the first edit, and the branch's base contains `main`'s recorded SHA                                                                                                          | —    | ES-09 |        |       |
| START-03 | Read the 20-FINDINGS and 21-BUGS capture                                                  | Both zero — or, for a register that had gained an instance, a record that it was handed back to US010's presence clause and that no row for it was written by this story                           | —    | EC-12 |        |       |
| START-04 | Read the carriers capture                                                                 | Three bold `**Status:**` prose lines and one backticked `Status` table cell, each located by its key and never by a line number, and the values the read rule changes listed                       | —    | EC-10 |        |       |
| START-05 | Read the pre-edit tree and citation baseline slots against the first commit on the branch | Both taken before the first edit, the citation set by identity with the detector hash and the index state beside it                                                                                | —    | —     |        |       |

### The population

| ID       | Action                                                                                                                                                                                                                                       | Expected outcome                                                                                                                                                             | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| COUNT-01 | Run the instance-test command at the landing commit's HEAD and compare with the landing capture                                                                                                                                              | The same lists and counts; recorded beside the start count and the cut-time 43, with the date, so the drift between cutting and building is visible                          | —    | HP-01 |        |       |
| COUNT-02 | For each register, compare its list with its index's rows                                                                                                                                                                                    | Exactly one row per instance; no row for the index itself; no row for a file outside the pattern — CUT-PLAN.md in 02-STORIES has none                                        | —    | HP-01 |        |       |
| COUNT-03 | Find the row for `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` in STORY-PLAN-INDEX                                                                                                                                   | Present — the plan matches its register's pattern, and the index is excluded by its exact filename, never by an `-INDEX.md` suffix                                           | —    | EC-01 |        |       |
| COUNT-04 | Find US012's row in STORY-INDEX                                                                                                                                                                                                              | Present: US012.md is tracked, committed 27/09/2026, so the instance test counts it                                                                                           | —    | EC-02 |        |       |
| COUNT-05 | List every instance added since the cut — `git log --diff-filter=A --format= --name-only c8f4c4c^..HEAD` per register, filtered by the instance test, `c8f4c4c` being the commit that cut this story on 20/09/2026 — and find each one's row | Each has a row; the list is recorded with its command and HEAD, so every instance the cut-time 43 never counted is named — none is taken from a list written before the walk | —    | EC-03 |        |       |
| COUNT-06 | In a scratch copy, delete US005's row from STORY-INDEX and repeat COUNT-02 for 02-STORIES                                                                                                                                                    | Caught: rows fall one short of instances and the missing identifier is named — the walk counts, never reads by eye alone                                                     | —    | ES-01 |        |       |
| COUNT-07 | Compare STORY-PLAN-INDEX's rows with the plans on disk at the landing commit                                                                                                                                                                 | Every row's link names the plan's current filename; a plan renumbered since the start capture is renamed in its row in the same change                                       | —    | EC-11 |        |       |
| COUNT-08 | Compare the start and landing population captures                                                                                                                                                                                            | Any difference is named, and its rows were read against the tree the landing commit carries — never against a dirty tree                                                     | —    | EC-16 |        |       |

### Status cells

| ID        | Action                                                                                                                                                                                    | Expected outcome                                                                                                                                  | Flow | QA    | Result | Notes |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| STATUS-01 | For every row of STORY-INDEX and SPRINT-INDEX, apply the read rule to its file's first line beginning `**Status:**` and compare with the row                                              | String-equal on every row                                                                                                                         | —    | HP-03 |        |       |
| STATUS-02 | For every row of DECISION-INDEX, the same                                                                                                                                                 | String-equal on every row                                                                                                                         | —    | HP-03 |        |       |
| STATUS-03 | For every row of STORY-PLAN-INDEX, read its plan's first table row keyed `Status`, strip the backticks, trim, and compare                                                                 | String-equal on every row                                                                                                                         | —    | HP-04 |        |       |
| STATUS-04 | Read the row for `../../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`, then run `git diff --name-only <recorded base> HEAD -- project-management/src/15-DECISIONS/` | The row reads `Proposed`, string-equal to the file's value under the rule; the ADR is absent from the listing — not edited                        | —    | HP-05 |        |       |
| STATUS-05 | Read US005's row in STORY-INDEX beside its plan's row in STORY-PLAN-INDEX, and US011's beside this story's plan's                                                                         | Each row mirrors its own file — the plan's value and the story's value side by side wherever they differ — and neither is reconciled to the other | —    | EC-06 |        |       |
| STATUS-06 | In a scratch copy, replace one plan row's Status with its raw carrier value, backticks kept, and repeat STATUS-03 for that row                                                            | The comparison fails the row: a backticked value is not the value                                                                                 | —    | ES-03 |        |       |
| STATUS-07 | Read every Status cell in the four indexes against the US007 landing capture                                                                                                              | Each value mirrors its carrier as found; no value is translated into another register's vocabulary, whatever vocabulary US007 left                | —    | EC-13 |        |       |

### Updated cells

| ID         | Action                                                                                                                                          | Expected outcome                                                                                                                                                                                                                                    | Flow | QA    | Result | Notes |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| UPDATED-01 | For every row in the four indexes, run `git log -1 --format=%ad --date=format:%d/%m/%Y -- <the file>` and compare with `Updated`                | Equal on every row — every row read, never a sample                                                                                                                                                                                                 | —    | HP-07 |        |       |
| UPDATED-02 | Count the dated instances whose own header date differs from their last commit date, and read those rows                                        | Each carries the commit date, never the header's                                                                                                                                                                                                    | —    | ES-04 |        |       |
| UPDATED-03 | For each of US011.md, this story's plan and SPRINT-07 that the branch changed, read its row against the file as committed in the landing commit | The row mirrors the file as committed, and its `Updated` equals the date of the last commit to change it — written with the intended date and re-checked once the commit existed; an amend or a rebase keeps the author date, so the re-check holds | —    | EC-09 |        |       |

### Instance and Summary cells

| ID      | Action                                                                                                                                                                                                             | Expected outcome                                                                                                                                                                                             | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| CELL-01 | For each index, test every Markdown link target in the file — Instance, tail and any outside the table — for existence with `test -e` from the index's own folder (QA plan Section 6), and record the count tested | Every target exists                                                                                                                                                                                          | —    | HP-02 |        |       |
| CELL-08 | For each index, count the rows whose Instance cell holds a Markdown link, and record it beside the count of rows                                                                                                   | Equal in each index: one Instance link per row. The tail's links — DECISION-INDEX's `Supersedes` and `Superseded by` cells (CHAIN-03) — and any link outside the table are CELL-01's, never counted here     | —    | HP-02 |        |       |
| CELL-02 | Read every Instance label                                                                                                                                                                                          | The descriptor where the filename carries one — ADRs and plans — and the identifier where it does not — stories and sprints — as each file's _How to read a row_ says; never the filename with its extension | —    | HP-02 |        |       |
| CELL-03 | In a scratch copy, point one STORY-PLAN-INDEX row at a pre-renumber filename, and add an empty-register placeholder row to SPRINT-INDEX; repeat CELL-01, CELL-08 and COUNT-02 for both                             | The renamed row is caught by CELL-01 as an orphan; the placeholder is invisible to it and caught by the counts alone — rows exceed instances by one, and rows with an Instance link fall one short of rows   | —    | ES-02 |        |       |
| CELL-04 | Run `bash code/src/scripts/audits/doc-references.sh --path <index>` over each of the four indexes, and compare with the baseline                                                                                   | No new finding in any of the four — a bare backticked story, sprint or plan token in a row would be a new `[instance citation]`, this story's own                                                            | —    | ES-05 |        |       |
| CELL-05 | Run QA plan Section 6's cell-count command over each index                                                                                                                                                         | One value printed per index: every row of the register table has the header's cell count — no unescaped pipe in any Summary                                                                                  | —    | ES-12 |        |       |
| CELL-06 | In each index, read every line from the register table's header row down to the next heading                                                                                                                       | Every non-blank line from the header row to the first blank line begins with a pipe, and no non-blank line follows the table before the next heading — no Summary breaks its row across lines                | —    | ES-11 |        |       |
| CELL-07 | Search the four indexes for an empty-register placeholder row                                                                                                                                                      | None. The four were landed without one; had US010 landed one, it left in the commit that wrote the first real row                                                                                            | —    | EC-14 |        |       |

### Order

| ID       | Action                                                                                                                                    | Expected outcome                                                                                                                                                                                                                                                             | Flow | QA    | Result | Notes |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| ORDER-01 | Read STORY-INDEX's and SPRINT-INDEX's rows top to bottom against each file's ordering sentence                                            | Ascending by identifier; the stated rule and the actual order agree                                                                                                                                                                                                          | —    | HP-08 |        |       |
| ORDER-02 | Read STORY-PLAN-INDEX's rows against its ordering sentence                                                                                | Ascending by the build-order prefix; the stated rule and the actual order agree                                                                                                                                                                                              | —    | HP-08 |        |       |
| ORDER-03 | Read DECISION-INDEX's rows against its ordering sentence                                                                                  | By `US###`, then Date, ascending; the stated rule and the actual order agree                                                                                                                                                                                                 | —    | HP-08 |        |       |
| ORDER-04 | Count the groups of ADRs sharing both `US###` and Date, and read each group's rows against the tie-break                                  | Within each group a supersession predecessor precedes its successor, and filename ascending orders the rest — US010's unchained pair with INDEX-STATUS-READ-RULE first; every chain in the index reads predecessor before successor; the count is recorded beside the result | —    | EC-07 |        |       |
| ORDER-05 | Read where `../../15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md` sits, its Date line continuing after a middle dot | Ordered by the leading date, 05/09/2026                                                                                                                                                                                                                                      | —    | EC-08 |        |       |

### The supersession chain

| ID       | Action                                                                                                                                                                                   | Expected outcome                                                                                                                                                                                                         | Flow | QA    | Result | Notes |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| CHAIN-01 | From DECISION-INDEX alone, follow every row reading `Superseded` through its `Superseded by` cell to its replacement's row, and record each step in the chain-walk capture               | Every chain reaches a row present in the index; each replacement's `Supersedes` names its predecessor; the number of `Superseded` rows equals the number of ADRs reading `Superseded` in the folder, counted at the walk | —    | HP-06 |        |       |
| CHAIN-02 | Read the chain whose replacement reads `Proposed` — ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES to ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH, unless the walk finds that pair has moved | Both rows mirrored verbatim; the chain noted as ending on a record not in force — not dangling, and not reconciled                                                                                                       | —    | EC-04 |        |       |
| CHAIN-03 | Read every `Supersedes` and `Superseded by` cell in DECISION-INDEX                                                                                                                       | Each holds the link, or the register's empty value, and nothing else — no `doc-references: template-only` marker and no other comment carried from its source line                                                       | —    | EC-05 |        |       |
| CHAIN-04 | For each chain, check that the file it names exists and that the two ADRs' fields agree                                                                                                  | No chain dangles: a chain dangles only where a named file is absent or the two fields disagree, and neither happens                                                                                                      | —    | HP-06 |        |       |

### Debt lines

| ID      | Action                                                                                                                                                      | Expected outcome                                                                                                                                                         | Flow | QA    | Result | Notes |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| DEBT-01 | Run QA plan Section 6's debt-line listing over the story's own commits — `git diff -U0 <recorded base> HEAD` in place of its pre-edit SHA (_Preconditions_) | Exactly four removed lines, one in each of the four indexes; FINDING-INDEX and BUG-INDEX absent from it                                                                  | —    | HP-09 |        |       |
| DEBT-02 | Search the seven register indexes, and only them, for the phrase "Backfill owed"                                                                            | None in any of the seven                                                                                                                                                 | —    | ES-07 |        |       |
| DEBT-03 | Search the whole tree for the same phrase, and compare with DEBT-02                                                                                         | Hits remain in PM records that discuss the debt, and none of them is an index — the check of record is DEBT-02's, scoped to the index files, never this tree-wide search | —    | ES-08 |        |       |

### The change's reach

| ID       | Action                                                                                                                                                                                                                                                                                                                  | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Flow | QA    | Result | Notes                                                                                                                                                                                       |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| REACH-01 | Run `git diff --name-only <recorded base> HEAD`                                                                                                                                                                                                                                                                         | Nothing under `.copier/`; `copier.yml` absent; nothing under `.github/` — no workflow and no script, the generated-tree grep being US010's step (settled 03/10/2026, 17-story-plans grilling round 1 Q2)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | —    | HP-11 |        |                                                                                                                                                                                             |
| REACH-02 | Read the same listing for instance files of the four registers                                                                                                                                                                                                                                                          | No instance file other than US011.md, this story's plan and SPRINT-07, the three REACH-03 reads — no other story, no other sprint, no ADR, no other plan, and neither US005 nor its plan: every other instance file of the four registers untouched (settled 03/10/2026, 17-story-plans grilling round 4 Q8)                                                                                                                                                                                                                                                                                                                                                                                                            | —    | PA-03 |        |                                                                                                                                                                                             |
| REACH-03 | Read the same listing for US011.md, this story's plan, SPRINT-07 and `project-management/export/clickup/US011-CLIENT.md`, and each one's diff; then list the story's commits with the files each touches — `git log --format=%h --name-only <recorded base>..HEAD` — and read every commit that touches any of the four | Each of the three changes only in its status carrier — the first line beginning `**Status:**` in US011.md and in SPRINT-07, the plan's `Status` row — and in ticks, `[ ]` to `[x]`, on the task, checklist and Definition-of-Done lines the story's Tasks and gate `23` require; no other line. Every commit that moves a status carrier touches that one carrier and nothing else, bar a US011.md flip, which also carries the export as the hook regenerated it, its only change the Status cell. The export is in no other commit: it carries no task line (measured 03/10/2026), so a tick leaves it unchanged. No backfill commit touches any of the four (settled 03/10/2026, 17-story-plans grilling round 4 Q8) | —    | HP-11 |        | Covers transitions 1 and 2 only: the `In Review` pair lands at `23-pr-and-review` Step 3, after this walk, and no recorded check reads it (story plan, _Status Propagation & ClickUp Sync_) |
| REACH-04 | Run `git diff <recorded base> HEAD -- .copier/`                                                                                                                                                                                                                                                                         | Empty: no seed touched                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | —    | ES-06 |        |                                                                                                                                                                                             |
| REACH-05 | Run `git diff <recorded base> HEAD -- copier.yml`                                                                                                                                                                                                                                                                       | Empty: no `_exclude` line, and so no negation re-including an index path, added by this story                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | —    | PA-02 |        |                                                                                                                                                                                             |

### The three scripts

| ID        | Action                                                                                                        | Expected outcome                                                                                                   | Flow | QA           | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ---- | ------------ | ------ | ----- |
| SCRIPT-01 | Run `bash .github/scripts/shipped-registers.sh`, then `bash .github/scripts/shipped-registers.sh --self-test` | Both exit 0: US010's family still proves every index seed blank, wired and never re-included                       | —    | HP-12, PA-01 |        |       |
| SCRIPT-02 | Run `bash .github/scripts/shipped-ai.sh --self-test` on a host meeting _Preconditions_ → _The Copier cache_   | Exit 0                                                                                                             | —    | HP-12        |        |       |
| SCRIPT-03 | Run `git diff --name-only <recorded base> HEAD -- .github/scripts/`                                           | Empty: none of the four files — the three scripts and the `shipped-ai.py` the wrapper execs — edited by this story | —    | HP-12        |        |       |

### Generation job

Open the landing commit's workflow run, by the ID under _Recorded during the build_.

| ID     | Action                                                                 | Expected outcome                                                                                                                                                                                                                                                                                                     | Flow | QA                  | Result | Notes |
| ------ | ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------------- | ------ | ----- |
| GEN-01 | Read the run's commit and the `[3/4] Template Generation` job          | The run is the landing commit's, every row committed in it; green on every render path the template offers (today: `INCLUDE_MOBILE` true and false)                                                                                                                                                                  | —    | HP-10               |        |       |
| GEN-02 | Read US010's generated-tree grep step on each render path              | It ran over all seven index files and printed nothing — no story, sprint, ADR or plan identifier from this repository in any generated index, the `000` template identifiers excepted. This story's criterion is read against it, this story adding no step (settled 03/10/2026, 17-story-plans grilling round 1 Q2) | —    | EC-15, HP-10, PA-01 |        |       |
| GEN-03 | Read the `shipped-artefacts.sh` self-test step and the full-check step | Both green, no leak reported — HP-12's evidence, never PA-01's: the script admits each seeded index path by name and cannot read content (TM-09)                                                                                                                                                                     | —    | HP-12               |        |       |
| GEN-04 | Read US010's link-check step                                           | Green over the in-tree indexes, which now carry this story's rows                                                                                                                                                                                                                                                    | —    | —                   |        |       |

### Legibility

| ID         | Action                                                                                                                                                                                                                  | Expected outcome                                                                                                                                                                          | Flow | QA    | Result | Notes |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| LEGIBLE-01 | Give each of the four indexes, alone, to its own fresh legibility reader, ask what each Summary's artefact is, and record each reading verbatim under _Recorded during the build_ with the developer's review beside it | Every Summary conveys what its artefact is to a reader who has opened none of them; the count of Summaries read equals the count of rows in each index; the reader is named in the record | —    | HP-13 |        |       |
| LEGIBLE-02 | Compare every Summary with its Instance's filename                                                                                                                                                                      | None restates the filename in prose — "the ADR on the cited plan prefix being optional" for ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL is the shape that fails                               | —    | ES-10 |        |       |

### The map row

| ID     | Action                                                                                                                       | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                            | Flow | QA  | Result | Notes |
| ------ | ---------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| MAP-01 | Read the `S-05` row of `../../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md`, and run `git diff <recorded base> HEAD -- <the map>` | The row reads as `02-story-creation` left it on 20/09/2026 — US011 in its Story cell, its Nodes and its Acceptance. The map is unchanged by the story's commits, or every changed cell is one of `S-05`'s Story, Nodes or Acceptance cells and is named in the implementation record, the repair the story's Map Task permits. Its "42 at cutting" is known-stale and routed to `01-feature-map`, not a failed verification | —    | —   |        |       |

### Citation gate

Run `bash code/src/scripts/audits/doc-references.sh` in the recorded index state, normalise it to
`(file, kind, token)` with multiplicity kept, and `diff` it against the baseline.

| ID      | Action                                                                                           | Expected outcome                                                                                                                                                         | Flow | QA  | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | --- | ------ | ----- |
| CITE-01 | Re-take `git hash-object code/src/scripts/audits/doc-references.sh` and compare with the capture | Recorded beside the captured value. Had it moved, the diff is reported **detector-confounded**, never as this story's                                                    | —    | —   |        |       |
| CITE-02 | Run the gate and the identity diff                                                               | No new line in any file this story edits; a line outside the edit set is a concurrent change's, named with its file. Never reported as passing while the baseline stands | —    | —   |        |       |
| CITE-03 | Read whether US004 has landed and the gate gone green                                            | If so, the plain-pass reading applies and is stated; otherwise CITE-02's diff is the result                                                                              | —    | —   |        |       |

### Close

| ID       | Action                                            | Expected outcome                                            | Flow | QA  | Result | Notes |
| -------- | ------------------------------------------------- | ----------------------------------------------------------- | ---- | --- | ------ | ----- |
| CLOSE-01 | Read _Tester sign-off_ against the story's author | The tester who signs is not the author of the story's edits | —    | —   |        |       |

---

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID  | What happened | Blocks the story? | Routed to |
| --- | ------------- | ----------------- | --------- |

---

## Tester sign-off

Filled at the walk.

| Field        | Value                                    |
| ------------ | ---------------------------------------- |
| **Tester**   |                                          |
| **Date**     |                                          |
| **Browsers** | N/A — Gate surface; no browser is opened |
| **Outcome**  |                                          |
| **Blockers** |                                          |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against the automated record — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US011.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/12-STORY-PLAN-US011-REGISTER-INDEX-BACKFILL.md` — the implementation plan this guide was authored beside
- "../AUTOMATED/US011-TEST-STATUS.md" — the paired automated-test record; it does not exist until `22-implementation-documentation` writes it
- `../../11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the shape of the four files this story fills, and the grep and link-check steps GEN-02 and GEN-04 read
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — why a scenario this guide cannot walk is named out of scope rather than reported as passed
