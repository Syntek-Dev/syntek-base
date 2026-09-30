# US004 — Manual Testing Guide

_The manual testing guide for US004: the steps a tester follows against the citation gate, and — once walked — whether each step passed._

**Last Updated**: 30/09/2026 · **Story**: US004 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US004.md` — The citation gate stops depending on the git index, and the PM tree becomes checkable
- **Story plan:** `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the code master this guide was authored beside
- **Branch:** `us004/citation-gate-git-index`
- **Surface:** Gate — `code/src/scripts/audits/doc-references.sh`, run in a terminal. Each action is the command a person runs or the file they open; each outcome is what the gate prints, the exit code it returns, or what the file says.
- **Authored from:** `../../02-STORIES/US004.md` · `../../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` · `../../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` · `../../15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md` · `../../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` (`Proposed`) · `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` · `../../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` · `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`. No stage-1 design, GDPR, security, SEO, API or logging artefact exists for this story — every one of those flags reads `N/A`. Never code.

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

- **Stack:** none. The gate reads the working tree and never contacts the dev stack, so no row
  needs `server.sh up`.
- **Base URL:** N/A — Gate surface.
- **Seed data:** none — the tree is the gate's input. Several rows create an untracked scratch file
  or make a temporary edit; each says how to put the tree back, and `git status --porcelain` shows
  nothing of it afterwards.
- **Index state:** record `git status --porcelain` and `HEAD` beside every figure. A count is
  comparable only against a run in the same index state (the QA plan, Section 6).
- **Counting:** count the finding lines, never grep hits over the whole output — the gate's
  explanatory footer repeats the class labels (`../../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`).
- **The build captures:** taken on the story branch **before its first edit** and filled under
  _Recorded during the build_ — the story makes that a criterion, and
  `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  which supersedes `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, records the baseline
  here "before editing begins". Every row below is walked at `22`, the baseline rows reading
  those captures back.
- **The detector at the baseline:** the script at the branch point already carries the 08/09/2026
  plan-prefix edit (`../../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md`), so
  the "before" starts from that detector.
- **Record paths:** since the 30/09/2026 split the per-story records the register rows bind live in
  `project-management/src/18-TESTS/MANUAL/` and `project-management/src/18-TESTS/AUTOMATED/`; the
  rows below use those paths.
- **Accounts / roles:** none — the gate runs with the developer's own file permissions.
- **Out of scope:**
  - **Permission and access** — no endpoint, view or protected action; the QA plan records `PA-01`
    as N/A for that reason. Section dropped.
  - **Accessibility and responsive behaviour** — no rendered surface; the output is terminal text in
    the existing `file:line [class] token` shape (QA plan Sections 3 and 4). Both sections dropped.
  - **`ES-03`** — a failure injected between the self-test probe creating its file and asserting on
    it needs the self-test itself edited. The `trap` is proved by the self-test and recorded in
    `../AUTOMATED/US004-TEST-STATUS.md`; SELFTEST-01 checks only that a passing run leaks nothing.
  - **`EC-01`, second half** — that the patterned register row does not make the shipped template's
    absence unreportable needs the shipped template removed from the tree. The `clean/` fixture
    `../../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026.md` names covers it
    (it supersedes `../../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`);
    CITER-01 walks the first half.
- **Open questions** — each awaits the developer's answer, and every row it holds carries
  `Awaiting answer` in `Notes` until it is answered and the row rewritten from it:
  1. **The A/B's file (`HP-02`) — BASELINE-04, AFTER-02.** The QA plan says to run `--path`
     against "an instance artefact", untracked and then with `git add --intent-to-add`, and names
     none; a tracked story cannot be measured untracked. Which file is measured — an untracked
     byte-for-byte copy of a real story under a scratch name, or another artefact — and how is
     the tree put back?
  2. **The probe citations' carrier (`HP-04`, `EC-05`, `HP-03`, `EC-03`, `EC-04`) —
     DEADPATH-01, DEADPATH-02, REGISTER-03 to REGISTER-05.** The citer must be an instance
     artefact for `EC-05`'s hand-over to be tested, and no spec names one. Is it a scratch story
     created for the walk and deleted after, or a temporary edit to a real one?
  3. **`HP-03`'s example — REGISTER-03** — answered 30/09/2026: `HP-03` is re-keyed to
     "project-management/src/18-TESTS/AUTOMATED/US997-TEST-STATUS.md", the record REGISTER-03
     already cites (`../../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`).
  4. **The 16 → 38 figure — MEASURE-01.** Measured before the 30/09/2026 backfill made nine of
     the cited `18-TESTS/MANUAL/` paths resolve, so it cannot recur as written. Does the row pass
     on the direction and make-up of the change — more `[dangling path]` findings, none a naming
     pattern — whatever figures the walk measures?

---

## Recorded during the build

The story's _QA Acceptance Criteria — Manual_ require the whole-tree run and the
tracked-versus-untracked A/B recorded before any edit and again after, and
`ADR-US003-CITATION-GATE-BASELINE-DIFF` puts the baseline in this file "before editing begins".
The implementer fills the before-edit slots on the story branch before its first edit — never
reconstructed afterwards; the walker fills the two walk-time slots as AFTER-01 and AFTER-02 run.
Every figure carries `git status --porcelain` and `HEAD` beside it. The rows below read these;
nothing here carries a `Result`.

| Capture                                                                                                                                                                                            | Required by                                                                            | Taken                  | Value |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------- | ----- |
| Whole-tree `doc-references.sh` run, timed — the finding count by class, the exit code, the summary line's files read, exempt by rule, backticked tokens and path tests, and the wall-clock runtime | the story's _QA Acceptance Criteria — Manual_; `ADR-US003-CITATION-GATE-BASELINE-DIFF` | Before the first edit  |       |
| `doc-references.sh --self-test` — the exit code and the probe count                                                                                                                                | `HP-05`, whose rise is counted from it                                                 | Before the first edit  |       |
| `doc-references.sh --path research/CONTEXT.md` — the summary line                                                                                                                                  | `HP-01`, whose reverse EXEMPT-01 walks                                                 | Before the first edit  |       |
| The tracked-versus-untracked A/B — the file measured, its findings by class untracked and then with `git add --intent-to-add`, and `git status --porcelain` after `git reset`                      | the story's _QA Acceptance Criteria — Manual_; `HP-02`                                 | Before the first edit  |       |
| `docs-length.sh` — its figure for `code/src/scripts/audits/CONTEXT.md`                                                                                                                             | `AC-GAP-9`, which GATES-01 checks                                                      | Before the first edit  |       |
| The whole-tree run again, same form                                                                                                                                                                | the story's _QA Acceptance Criteria — Manual_                                          | At the walk — AFTER-01 |       |
| The A/B again, on the same file                                                                                                                                                                    | the story's _QA Acceptance Criteria — Manual_                                          | At the walk — AFTER-02 |       |

---

## Journeys

One `###` section per journey **area**, rows in the order a person works through the gate.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The baseline, read back

| ID          | Action                                                                      | Expected outcome                                                                                                                                                                                                                                                              | Flow | QA    | Result | Notes                             |
| ----------- | --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| BASELINE-01 | Open _Recorded during the build_ → the whole-tree run before the first edit | Captured before the first edit, beside the index state and `HEAD`: the finding count by class, the exit code, the summary line's files read, exempt by rule, backticked tokens and path tests, and the wall-clock runtime. Every finding line reads `file:line [class] token` | —    | —     |        |                                   |
| BASELINE-02 | Read the `--self-test` capture                                              | Its exit code and probe count are recorded — the count SELFTEST-01 is compared against                                                                                                                                                                                        | —    | —     |        |                                   |
| BASELINE-03 | Read the `research/CONTEXT.md` capture                                      | The summary line counted the file as exempt by rule, not as read — one of the nine shipped files the exempt trees hid before the change                                                                                                                                       | —    | —     |        |                                   |
| BASELINE-04 | Read the A/B capture                                                        | The untracked run reported one or more `[template-only citation]` findings and the intent-to-add run none; the `[dangling path]` findings were identical in both; after the reset the file showed as it did before the A/B, so the index was restored                         | —    | HP-02 |        | Awaiting answer — open question 1 |
| BASELINE-05 | Read the `docs-length.sh` capture                                           | Its figure for `code/src/scripts/audits/CONTEXT.md` is recorded as that gate measures it — the figure GATES-01 is compared against                                                                                                                                            | —    | —     |        |                                   |

### Self-test

| ID          | Action                                                                                          | Expected outcome                                                                                                                                                       | Flow | QA    | Result | Notes |
| ----------- | ----------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SELFTEST-01 | Run `bash code/src/scripts/audits/doc-references.sh --self-test`, then `git status --porcelain` | Exits 0; its probe count is higher than BASELINE-02's by the cases the repairs added, one per repair; the self-test has left no new untracked file in the working tree | —    | HP-05 |        |       |

### After the change — the same measurements

| ID       | Action                                                                                                                                             | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                | Flow | QA    | Result | Notes                             |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| AFTER-01 | Record `git status --porcelain` and `git rev-parse HEAD`, then run `bash code/src/scripts/audits/doc-references.sh` over the whole tree, timing it | Recorded under _Recorded during the build_ beside the before-edit run, with both counts, both exit codes, the delta and both runtimes. No finding remains of the three classes the story owns — the git-index class, the instance-citer class and the dangling `project-management/src/` class. Every survivor is attributable to the story that owns it, and while one stands the result is never reported as the gate passing (`code/docs/GATE-REPORTING.md`) | —    | —     |        |                                   |
| AFTER-02 | Repeat the A/B on the same file — untracked, then intent-to-add, then `git reset` — and record it under _Recorded during the build_                | Both runs report zero `[template-only citation]` findings; the `[dangling path]` findings are identical in both; after the reset `git status --porcelain` shows the file as it was before the A/B                                                                                                                                                                                                                                                               | —    | HP-02 |        | Awaiting answer — open question 1 |

### Classify what the widened gate exposes

| ID          | Action                                                                                            | Expected outcome                                                                                                                      | Flow | QA  | Result | Notes |
| ----------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| CLASSIFY-01 | For every finding in AFTER-01 that BASELINE-01 did not carry, write its class in this row's Notes | Every one is classified — genuine, generic-noun false positive, or another story's (naming the story) — and none is left unclassified | —    | —   |        |       |

### Repaired shipped files, re-read in place

| ID        | Action                                                                                                                                                        | Expected outcome                                                                                                                                                                                   | Flow | QA  | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| REPAIR-01 | Open `project-management/src/02-STORIES/CONTEXT.md` and `project-management/src/03-SPRINTS/CONTEXT.md` at each repaired sentence                              | Each sentence still reads true and no longer cites a per-project instance artefact; AFTER-01 reports no finding in either file                                                                     | —    | —   |        |       |
| REPAIR-02 | Open `how-to/src/TEMPLATE-GUIDE/10-FIRST-FEATURE.md`, and every other shipped file the implementation's re-measured sweep repaired, at each repaired sentence | The same, file by file. The set is the one re-measured at implementation, not only the three the story names                                                                                       | —    | —   |        |       |
| REPAIR-03 | Open `research/CLAUDE.md` at its backticked `LICENSE`                                                                                                         | The line carries the `doc-references: ignore` marker with its reason on the line — the licence file belongs to an upstream source, not to this repository — and AFTER-01 reports no finding for it | —    | —   |        |       |

### The exempt trees — shipped files inside them are policed

| ID        | Action                                                                                                                 | Expected outcome                                                                                                                  | Flow | QA    | Result | Notes |
| --------- | ---------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| EXEMPT-01 | Run `bash code/src/scripts/audits/doc-references.sh --path research/CONTEXT.md`                                        | The summary line counts the file among those read, not among those exempt by rule — the reverse of BASELINE-03                    | —    | HP-01 |        |       |
| EXEMPT-02 | Run `bash code/src/scripts/audits/doc-references.sh --path research/HTTP-QUERY-METHOD.md`                              | The summary line still counts the note as exempt by rule — the tree arm stands for a file copier does not lift back out           | —    | HP-01 |        |       |
| EXEMPT-03 | Run `bash code/src/scripts/audits/doc-references.sh --path project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md` | The summary line counts the template among the files read — the fall-through arm admits a `*TEMPLATE*` file inside an exempt tree | —    | EC-02 |        |       |

### A dead citation into the PM tree is caught

| ID          | Action                                                                                                                                                                                                   | Expected outcome                                                                                                                                                                                  | Flow | QA    | Result | Notes                             |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| DEADPATH-01 | In the instance artefact open question 2 settles, add one line citing, in backticks, "project-management/src/02-STORIES/US998.md" — a story that does not exist. Run the gate with `--path` on that file | A `[dangling path]` finding for that citation — reported for the first time, by Check 1's new `project-management/src/*` arm                                                                      | —    | HP-04 |        | Awaiting answer — open question 2 |
| DEADPATH-02 | Read the same run for Check 2                                                                                                                                                                            | No `[instance citation]` finding — the citer is an instance artefact, so Check 2 stands down and Check 1 catches the dead citation instead: the two clauses hand over, neither both standing down | —    | EC-05 |        | Awaiting answer — open question 2 |

### The register — one patterned row binds a class

| ID          | Action                                                                                                                                                                                                                                                                     | Expected outcome                                                                                                                                                                                                                                                                                                                                             | Flow | QA    | Result | Notes                             |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | --------------------------------- |
| REGISTER-01 | Open `how-to/src/PROJECT-PATHS.md`                                                                                                                                                                                                                                         | Under `## Registered paths`, exactly two new rows, each written with `###` — the per-story manual guide in `project-management/src/18-TESTS/MANUAL/` and the per-story automated record in `project-management/src/18-TESTS/AUTOMATED/` — each naming what creates it and when; no row for a story-plan class; the header states that a row may be patterned | —    | —     |        |                                   |
| REGISTER-02 | Open `code/docs/FORWARD-VOICE.md` Section 3                                                                                                                                                                                                                                | It states that a register row may be patterned and carries the duty to add one when a citation first needs it; no workflow `CHECKLIST.md` restates that duty                                                                                                                                                                                                 | —    | —     |        |                                   |
| REGISTER-03 | Add, to the same file, a line citing, in backticks, "project-management/src/18-TESTS/AUTOMATED/US997-TEST-STATUS.md" — a record that does not exist. Run the gate with `--path` on it                                                                                      | No finding for that citation — the patterned row registers it                                                                                                                                                                                                                                                                                                | —    | HP-03 |        | Awaiting answer — open question 2 |
| REGISTER-04 | Add lines citing, in backticks, "project-management/src/18-TESTS/MANUAL/US1234-MANUAL-TESTING.md" and "project-management/src/18-TESTS/MANUAL/USxyz-MANUAL-TESTING.md". Run the gate again                                                                                 | A `[dangling path]` finding for each — the pattern stands for exactly three digits, so neither over-matches                                                                                                                                                                                                                                                  | —    | EC-03 |        | Awaiting answer — open question 2 |
| REGISTER-05 | Add a line that contains "e.g." and cites, in backticks, "project-management/src/02-STORIES/US996.md". Run the gate again; then undo every line added since DEADPATH-01 — or delete the file, if open question 2 makes it a scratch one — and run `git status --porcelain` | No finding for that line — the line-level naming guard suppresses a real dangling path sharing a line with a naming pattern. A known limitation the story records and does not fix, not a regression it introduced. Afterwards the tree is as it was before DEADPATH-01                                                                                      | —    | EC-04 |        | Awaiting answer — open question 2 |

### The citer test — shipped instance-shaped files stay policed

| ID       | Action                                                                                                                                                                                                                                                   | Expected outcome                                                                                                                                        | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CITER-01 | Temporarily add a line to `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md` citing the bare filename "US001.md" in backticks. Run the gate with `--path` on the template; remove the line and confirm `git diff` on the template is empty | An `[instance citation]` finding for "US001.md" — the shipped template is instance-shaped but excluded from the citer test, so Check 2 still polices it | —    | EC-01 |        |       |
| CITER-02 | Do the same in `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md`                                                                                                                                                                              | An `[instance citation]` finding — the fall-through admits the template, and the citer test does not exempt a `*TEMPLATE*` file                         | —    | EC-02 |        |       |

### The gate fails loudly

| ID      | Action                                                                                                                                                                                                             | Expected outcome                                                                                                                                                                                                  | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| LOUD-01 | Temporarily rename the `## Registered paths` heading in `how-to/src/PROJECT-PATHS.md` and run the whole tree; restore the heading and confirm `git diff` on the file is empty                                      | Every citation the register normally covers is reported as a finding and the run exits non-zero — the gate fails loudly rather than passing silently                                                              | —    | ES-01 |        |       |
| LOUD-02 | Run the gate with `--path project-management/src` and note its `[instance citation]` findings. Note the mode of `copier.yml`, remove its read permission, run the same command again, then restore the mode        | The second run reports no `[template-only citation]` finding at all, and its `[instance citation]` findings match the first run's — the citer test holds with no readable `copier.yml`, as in a generated project | —    | ES-02 |        |       |
| LOUD-03 | Temporarily add two malformed rows under `## Registered paths` — one with no backticks, one whose pattern carries no digits — and run the whole tree; remove both rows and confirm `git diff` on the file is empty | The run completes with no shell error, and no finding AFTER-01 reported disappears — the malformed rows neither crash the parser nor register everything                                                          | —    | ES-04 |        |       |

### The Check 1 arm, measured alone

| ID         | Action                                                                                                                                                                                                                                                                                            | Expected outcome                                                                                                                                                                                                                            | Flow | QA  | Result | Notes                             |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | --------------------------------- |
| MEASURE-01 | Write the branch-point script (`git show` of the branch point) to an untracked scratch "code/src/scripts/audits/doc-references-stock.sh", and a second scratch copy with only the Check 1 `project-management/src/*` arm added. Run each with `--path project-management/src`; delete both copies | The arm-only copy reports more `[dangling path]` findings than the stock copy; both counts and every addition are recorded; not one addition is a naming pattern. The story's planning figure, 16 → 38, is reproduced here, never inherited | —    | —   |        | Awaiting answer — open question 4 |

### Gates

| ID       | Action                                                                                                 | Expected outcome                                                                                                                                                                                                                                                                   | Flow | QA  | Result | Notes |
| -------- | ------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| GATES-01 | Run `bash code/src/scripts/audits/docs-length.sh`                                                      | No failure; `how-to/src/PROJECT-PATHS.md` and `code/docs/FORWARD-VOICE.md` are not in the warn tier without a dated allowance; `code/src/scripts/audits/CONTEXT.md` reads BASELINE-05's figure — the `doc-references.sh` row's text was replaced within the row, and no line added | —    | —   |        |       |
| GATES-02 | Run `bash code/src/scripts/audits/doctrine-drift.sh`                                                   | Exits 0 — a regression check only; the story adds no claims row                                                                                                                                                                                                                    | —    | —   |        |       |
| GATES-03 | Run `bash code/src/scripts/audits/docs-pairing.sh`                                                     | Exits 0 — a regression check only; the story creates no directory                                                                                                                                                                                                                  | —    | —   |        |       |
| GATES-04 | Run `bash code/src/scripts/syntax/lint.sh --file-type markdown`                                        | Passes over the Markdown the story edits. `syntax/check.sh` is N/A — it has no shell or Markdown leg                                                                                                                                                                               | —    | —   |        |       |
| GATES-05 | Run ShellCheck by hand over `code/src/scripts/audits/doc-references.sh` — no project script carries it | Clean. If the host has no ShellCheck, `Notes` records "not run" and the row is not marked `Pass` — never recorded as a `lint.sh` pass (`code/docs/GATE-REPORTING.md`)                                                                                                              | —    | —   |        |       |

---

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID  | What happened | Blocks the story? | Routed to |
| --- | ------------- | ----------------- | --------- |

---

## Tester sign-off

Filled at the walk. The story requires a tester **other than the author** to sign the walk off
(_QA Acceptance Criteria — Manual_).

| Field        | Value                                  |
| ------------ | -------------------------------------- |
| **Tester**   |                                        |
| **Date**     |                                        |
| **Browsers** | N/A — Gate surface; no browser is used |
| **Outcome**  |                                        |
| **Blockers** |                                        |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Every scratch file deleted and every temporary edit reverted — `git status --porcelain` shows only the story's own changes
- [ ] Cross-checked against `../AUTOMATED/US004-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US004.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US004-TEST-STATUS.md` — the paired automated-test record, written at `22-implementation-documentation` Step 4 and absent until then
- `../../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — the QA implementation review, written at `22`: whether the specified scenarios were met
- `../../05-USER-FLOW/` — no consolidated flow covers this story; its User Flow flag reads `N/A`, so every `Flow` cell is `—`
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — how a gate result with survivors, or a check not run, is reported

<!-- AUTHORED 30/09/2026 as a backfill, when this folder split and authorship of the manual guide
     moved to 17-story-plans Step 7.2. The story, its plan and its QA plan predate that change, so
     the guide was written from them after the fact rather than beside the plan; no code for this
     story existed to be read. The rows fold in the manual checks the story and its plan already
     described for this file: the before/after whole-tree run, the tracked/untracked A/B, the
     classification of every exposed finding, the re-read of each repaired file, and the ShellCheck
     run recorded as run or not run. Paths the gate would test that do not exist, or exist only as
     a walker's scratch file, are written in double quotes rather than backticks, as the sibling
     story plans do. Revised the same day by the change's review: the rows once run before the
     first edit became captures under "Recorded during the build", read back by rows walked at 22,
     and the scratch-story method no spec states became open questions 1 and 2 rather than a
     guess. -->
