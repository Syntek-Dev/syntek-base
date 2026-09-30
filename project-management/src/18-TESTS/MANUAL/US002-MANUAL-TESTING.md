# US002 — Manual Testing Guide

_The manual testing guide for US002 — the journey a tester follows step by step, and — once walked — whether each step passed. Authored on 30/09/2026 at `17-story-plans` Step 7.2, as a backfill for a story planned before authorship moved to that step: written from the specs below, before any of the story's work exists._

**Last Updated**: 30/09/2026 · **Story**: US002 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US002.md` — The audits register regains the headroom nine new gates need
- **Story plan:** `../../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — the code master this guide was authored beside
- **Branch:** `us002/audits-register-headroom`
- **Surface:** Gate — every row runs a `code/src/scripts/audits/*.sh` gate or reads a file in the repository
- **Authored from:** the story; `../../11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`; the story plan; `../../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`; `../../15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md` (and the record it supersedes, `../../15-DECISIONS/ADR-US002-REGISTER-SPLITS-RATHER-THAN-RELOCATES-02-09-2026.md`), `../../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`, `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, `../../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` and `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`. No stage-1 design (`04`–`08`) and no `09`, `10`, `12`, `13` or `14` planning artefact exists for this story — every one of those flags reads N/A. Never code.

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

- **Stack:** not needed — no row opens a page, and no row touches a database. Every command is a
  `code/src/scripts/audits/*.sh` gate run from the repository root.
- **Base URL:** N/A — the story renders nothing.
- **Working tree:** the story branch checked out at the commit under review, with no other change
  in the tree — the gates read the whole tree, so a stray edit reaches their output.
- **Seed data:** none. No fixture, no seeded user, no credential, no personal data.
- **Accounts / roles:** none — the story introduces no permission boundary. The tester is someone
  other than the story's author (the story's _QA Acceptance Criteria — Manual_).
- **Out of scope:**
  - **`doctrine-drift.sh`** — declared blind, not run: its scan roots exclude `code/src/scripts/**`,
    so it cannot open either file the story edits. Removed from the story's `QA` flag and recorded
    N/A with that cause (`ADR-US002-BLIND-GATE-LEAVES-THE-FLAG`); a run would report green having
    examined nothing.
  - **Permission and access** — the QA plan's `PA` table reads _None_: no runtime surface, endpoint
    or protected action, so there is no role boundary to cross and no ID to own.
  - **Accessibility** — the QA plan's Section 3 is N/A: no rendered screen or interactive component.
  - **Responsive behaviour** — the QA plan's Section 4 is N/A, for the same reason.
  - **User flow** — the story's `User Flow` flag reads N/A, so no consolidated flow covers it: every
    `Flow` cell is `—`, and `18-consolidate-design-work` has none to set.
  - **EC-01's three trial shrinks** are not re-run: the walk has one landing figure, not three.
    LENGTH-02 applies EC-01's rule — and EC-02's — to the figure the build landed on.
  - **Markdown lint and format** (`code/src/scripts/syntax/lint.sh`) — a line in the story's
    _Verification Checks_, run before the PR, not a manual acceptance criterion.
  - **The test suites and `migrate.sh check`** — N/A in the story: no code path, no model.
- **Open questions:** None.

---

## Recorded during the build

The story names this file as the home of most of these — Scenarios 1 to 4, 6 and 8 — and
`ADR-US003-CITATION-GATE-BASELINE-DIFF` puts the `doc-references.sh` baseline here too. Scenarios 5,
7 and 9 require a record without naming its home; the story plan's _Documentation Write-Ups_ lists
the dry run among this file's contents, and the other two are kept beside it. The implementer fills
them during the build: the **before** half before the first edit, the story
plan's Step A, because none of it can be reconstructed once a line is cut. The journeys below check
them at the walk. Not a journey: nothing here carries a `Result`.

### Before the first edit

| Measurement                                                                                                                         | Value |
| ----------------------------------------------------------------------------------------------------------------------------------- | ----- |
| Date, commit and git-index state of the capture — a baseline is comparable only against a run in the same index state               |       |
| `code/src/scripts/audits/CONTEXT.md`, counted lines by `docs-length.sh --path code/src/scripts/audits --limit 1` — 298 in the story |       |
| `code/src/scripts/audits/CLAUDE.md`, counted lines, same run — 165 in the story                                                     |       |
| Scripts · Directory Tree rows · inventory rows · Dependencies rows — 24 · 26 · 24 · 20 in the story                                 |       |

**The `doc-references.sh` baseline.** Not yet captured. Every finding by identity — file, line and
class, as the gate printed it — or `None.`

### After the build

| Measurement                                                                                               | Value |
| --------------------------------------------------------------------------------------------------------- | ----- |
| `code/src/scripts/audits/CONTEXT.md`, counted lines, with the date of the run                             |       |
| If it landed between 231 and 269: the reason, and a statement of what the next registering story inherits |       |
| `code/src/scripts/audits/CLAUDE.md`, counted lines                                                        |       |
| `code/src/scripts/audits/slop-family/CONTEXT.md`, counted lines                                           |       |
| Scripts · Directory Tree rows · inventory rows · Dependencies rows                                        |       |
| The file each argument of the split rationale landed in — (a), (b) and (c) of Scenario 3                  |       |
| The operating rules moved from `CONTEXT.md` to `CLAUDE.md`                                                |       |
| The reduction paid by deletion, and the reduction paid by relocation — recorded separately                |       |
| The `docs-length-allow` comment — deleted, or the figure, date and run it was rewritten to                |       |
| The eight inbound citations Scenario 7 names — each with the target it now reaches                        |       |
| The 27-row dry run — the counted figure the file reached                                                  |       |

### What was cut, kept, routed or relocated

Not yet captured. One row per passage of `code/src/scripts/audits/CONTEXT.md` the story touched,
classed as the story's _Documentation Tasks_ class it — a restatement, an operating rule, or a fact
this file is the sole owner of.

| Passage, as it stood | Class — restatement / operating rule / sole-owner fact | Disposition — routed / relocated / kept / deleted | Owner routed to, or new home | Reason (deleted only) |
| -------------------- | ------------------------------------------------------ | ------------------------------------------------- | ---------------------------- | --------------------- |

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The target

| ID        | Action                                                                                     | Expected outcome                                                                                                                                                                                           | Flow | QA           | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| LENGTH-01 | Run `bash code/src/scripts/audits/docs-length.sh --path code/src/scripts/audits --limit 1` | `code/src/scripts/audits/CONTEXT.md` is listed, and its figure matches the one recorded under _After the build_                                                                                            | —    | HP-01        |        |       |
| LENGTH-02 | Compare that figure with the target                                                        | At 230 or fewer the target is met. From 231 to 269 the gate passes and the target does not, and _After the build_ records the reason and what the next registering story inherits — recorded, not inferred | —    | EC-01, EC-02 |        |       |
| LENGTH-03 | In the same output, read `code/src/scripts/audits/CLAUDE.md`                               | 200 counted lines or fewer                                                                                                                                                                                 | —    | —            |        |       |
| LENGTH-04 | In the same output, look for `code/src/scripts/audits/slop-family/CONTEXT.md`              | It is listed — the rationale's new home is a path the gate measures                                                                                                                                        | —    | —            |        |       |
| LENGTH-05 | Run `bash code/src/scripts/audits/docs-length.sh`                                          | Neither `code/src/scripts/audits/CONTEXT.md` nor `code/src/scripts/audits/CLAUDE.md` is reported in the warn tier                                                                                          | —    | —            |        |       |

### The registers

| ID          | Action                                                                                                                                                                                                                               | Expected outcome                                                                         | Flow | QA    | Result | Notes |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| REGISTER-01 | Open `code/src/scripts/audits/CONTEXT.md` and find each register — the Directory Tree, the script inventory, the self-guard list, the `--path` behaviour, the Reports filenames, the Dependencies table, Common Flags and Exit Codes | Each is still present                                                                    | —    | HP-02 |        |       |
| REGISTER-02 | Count the Directory Tree's script rows against the `*.sh` files in `code/src/scripts/audits/`                                                                                                                                        | One row per script, plus the `slop-family/` sub-folder and its pair                      | —    | HP-02 |        |       |
| REGISTER-03 | Count the Dependencies table's rows against the same scripts                                                                                                                                                                         | A row for every script — the four the table lacked when the story was written are filled | —    | HP-02 |        |       |
| REGISTER-04 | Compare the register counts under _Before the first edit_ and _After the build_                                                                                                                                                      | Both are recorded, and every difference between them is accounted for                    | —    | HP-02 |        |       |
| REGISTER-05 | Open `code/src/scripts/audits/CONTEXT.md` cold, as a developer who has not seen the change, and pick any audit script                                                                                                                | You can find which concern it covers and what it depends on                              | —    | —     |        |       |

### The split rationale

| ID           | Action                                                                     | Expected outcome                                                                                                                                                           | Flow | QA    | Result | Notes |
| ------------ | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| RATIONALE-01 | Open the file _After the build_ names for argument (a)                     | It states, whole, why the AI-slop family is four scripts split by input language and not one                                                                               | —    | EC-05 |        |       |
| RATIONALE-02 | Open the file _After the build_ names for argument (b)                     | It states why `render-slop.sh` splits on a second axis — its clause does not exist until the input is rendered — and why the browser dependency stays in that script alone | —    | EC-05 |        |       |
| RATIONALE-03 | Open the file _After the build_ names for argument (c)                     | It states why `08-WIREFRAMES/CONSOLIDATED-IDEAS` and its `SHARED/` sibling are in scope while `USER-STORY-IDEAS/` is not                                                   | —    | EC-05 |        |       |
| RATIONALE-04 | Compare the three files named                                              | All three are `code/src/scripts/audits/slop-family/CONTEXT.md`; any argument that landed in `audits/CONTEXT.md` or `audits/CLAUDE.md` instead has its reason recorded      | —    | —     |        |       |
| RATIONALE-05 | List `code/src/scripts/audits/slop-family/`, then open its `CONTEXT.md`    | The directory holds a `CONTEXT.md` and a `CLAUDE.md`; the `CONTEXT.md` carries routing frontmatter and the `slop-allow` annotation table                                   | —    | —     |        |       |
| RATIONALE-06 | Open `code/src/scripts/audits/CONTEXT.md` where _The AI-slop family_ stood | A short route naming the family, its four members and `slop-family/CONTEXT.md` — not a summary restating the argument                                                      | —    | —     |        |       |

### Restatements become routes

| ID       | Action                                                                                                                                                                                                               | Expected outcome                                                                                                                                                       | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| ROUTE-01 | Find each passage the cut-line table classes as a restatement — of `code/docs/VISUAL-DESIGN.md` Section 6, `code/docs/DOCUMENTATION-LENGTH.md`, `code/docs/GATE-REPORTING.md` or `code/src/scripts/audits/CLAUDE.md` | Each is replaced by a route naming its owner — none by silence                                                                                                         | —    | HP-03 |        |       |
| ROUTE-02 | Open `code/src/scripts/audits/CONTEXT.md` where _Markdown: two limits, two scripts, and the gap that existed between them_ stood                                                                                     | A route naming `code/docs/DOCUMENTATION-LENGTH.md`, not a restatement of it                                                                                            | —    | HP-03 |        |       |
| ROUTE-03 | Follow each route to its target and read the section it names                                                                                                                                                        | The section states the rule the route claims                                                                                                                           | —    | —     |        |       |
| ROUTE-04 | Check every passage the cut-line table classes as a sole-owner fact                                                                                                                                                  | Each is still stated — in `code/src/scripts/audits/CONTEXT.md` or at the new home the table names; none is deleted                                                     | —    | —     |        |       |
| ROUTE-05 | Read the deletion share and the relocation share under _After the build_                                                                                                                                             | Recorded separately, per `code/docs/DOCUMENTATION-LENGTH.md` Section 6, and the relocation into `audits/CLAUDE.md` leaves it at or under 200 counted lines (LENGTH-03) | —    | EC-04 |        |       |
| ROUTE-06 | Total the cut-line table                                                                                                                                                                                             | Every cut line is accounted for as restatement removed, content relocated, or fact deliberately deleted with a reason — the inventory balances                         | —    | —     |        |       |

### Operating rules move to the operating half

| ID     | Action                                                                                                                                                                   | Expected outcome                                                                                                                                                             | Flow | QA    | Result | Notes |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| OPS-01 | Read `code/src/scripts/audits/CONTEXT.md` for any operating rule — how to work here, rather than what is here — and check each passage the cut-line table classes as one | None remains in `CONTEXT.md`                                                                                                                                                 | —    | HP-04 |        |       |
| OPS-02 | Open `code/src/scripts/audits/CLAUDE.md` and find each rule _After the build_ lists as moved                                                                             | Each is stated there                                                                                                                                                         | —    | HP-04 |        |       |
| OPS-03 | Run `bash code/src/scripts/audits/docs-pairing.sh`                                                                                                                       | Exits 0, and neither half of either pair carries the other's headings. It exited 0 before the story too: it confirms the pairs are intact and decides nothing about the move | —    | HP-04 |        |       |

### The dated allowance

| ID       | Action                                                                                                                  | Expected outcome                                                                                                                                                                                                        | Flow | QA           | Result | Notes |
| -------- | ----------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| ALLOW-01 | Open `code/src/scripts/audits/CONTEXT.md` at the top, where the `docs-length-allow` comment stood (line 8 in the story) | Deleted — the file no longer needs an allowance. Were it kept, its figure and date match a `docs-length.sh` run recorded under _After the build_ on that date, never 298, and it claims no remedy the story did not use | —    | HP-05, EC-06 |        |       |

### The eight citations no gate checks

| ID      | Action                                                                                                                                                                                                                            | Expected outcome                                                                                                    | Flow | QA    | Result | Notes |
| ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CITE-01 | Open `.github/workflows/audit-css-slop.yml`, `.github/workflows/audit-render-slop.yml` and `.github/workflows/audit-style-check.yml` at line 2, and `code/src/scripts/desktop/CONTEXT.md` at its citation of _The AI-slop family_ | Each points at where the rationale now lives, and what it points at states the rationale                            | —    | HP-06 |        |       |
| CITE-02 | Open `code/src/scripts/audits/CLAUDE.md` at its citations of `CONTEXT.md` → _Common Flags_, _Markdown: two limits, two scripts_ and _Reports_                                                                                     | Each lands on a section that exists and states what it is cited for — repointed where its target moved              | —    | HP-06 |        |       |
| CITE-03 | Open `project-management/src/01-FEATURE-MAPS/MAP-PROGRESSIVE-ENHANCEMENT.md` at its line anchor into `code/src/scripts/audits/CONTEXT.md`                                                                                         | The anchor names the line the `css-tokens.sh` inventory row now sits on                                             | —    | HP-06 |        |       |
| CITE-04 | Read the re-resolution list under _After the build_                                                                                                                                                                               | All eight are listed with the target each now reaches — closed by this read-across, never reported as gate-verified | —    | HP-06 |        |       |

### The citation gate, as a diff

| ID        | Action                                                                                                                                                            | Expected outcome                                                                                                                                                                                                           | Flow | QA  | Result | Notes |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| DOCREF-01 | Run `bash code/src/scripts/audits/doc-references.sh` in the git-index state the baseline recorded, and compare its findings with the baseline, finding by finding | No finding is absent from the baseline — no new unresolved citation from any file the story wrote or edited, compared by identity, never by count. Recorded as a diff, never as the gate passing while the baseline stands | —    | —   |        |       |

### The headroom

| ID        | Action                                                                                                                                                                                                                                                                     | Expected outcome                                                                                                                                                            | Flow | QA           | Result | Notes |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| DRYRUN-01 | Add 27 placeholder rows to `code/src/scripts/audits/CONTEXT.md` — nine each to the Directory Tree, the script inventory and the Dependencies table — measure with `bash code/src/scripts/audits/docs-length.sh --path code/src/scripts/audits --limit 1`, then remove them | The file stays under 270 counted lines, and the figure matches the dry run recorded under _After the build_ — a landing at 243 or above would have reached the 270 boundary | —    | HP-07, EC-03 |        |       |

### The gates still bite

Each row sets up its failure on the finished change, runs the gate, then undoes the set-up; a
clean re-run of the same gate confirms the undo before the next row.

| ID      | Action                                                                                                                                      | Expected outcome                                                          | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| BITE-01 | Move `code/src/scripts/audits/slop-family/CLAUDE.md` aside, run `bash code/src/scripts/audits/docs-pairing.sh`, then put it back            | Exits non-zero, naming `code/src/scripts/audits/slop-family/` as unpaired | —    | ES-01 |        |       |
| BITE-02 | Break one backticked path in `code/src/scripts/audits/CONTEXT.md`, run `bash code/src/scripts/audits/doc-references.sh`, then undo the edit | A finding appears with that path — one more than the baseline             | —    | ES-02 |        |       |
| BITE-03 | Pad `code/src/scripts/audits/CONTEXT.md` to 271 counted lines, run `bash code/src/scripts/audits/docs-length.sh`, then undo                 | The file is reported in the warn tier, with no dated allowance            | —    | ES-03 |        |       |
| BITE-04 | Pad `code/src/scripts/audits/CLAUDE.md` past 270 counted lines, run `bash code/src/scripts/audits/docs-length.sh`, then undo                | The sibling enters the warn tier — the wall moved rather than removed     | —    | ES-04 |        |       |

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

| Field        | Value                                         |
| ------------ | --------------------------------------------- |
| **Tester**   |                                               |
| **Date**     |                                               |
| **Browsers** | N/A — Gate surface; no browser is opened      |
| **Outcome**  | Passed / Passed with notes / Failed / Blocked |
| **Blockers** |                                               |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against `../AUTOMATED/US002-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test
- [ ] The tester is not the story's author — the story's _QA Acceptance Criteria — Manual_

---

## Cross-references

- `../../02-STORIES/US002.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US002-TEST-STATUS.md` — the paired automated-test record; written at `22-implementation-documentation` Step 4, so absent until then
- `../../11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — the QA implementation record, written at `22`: whether the specified scenarios were met
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `../../15-DECISIONS/ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md` — why the rationale lands in a `slop-family/` sub-folder
- `../../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` — why `doctrine-drift.sh` is out of scope here
- `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — why `doc-references.sh` is read as a diff against the baseline; superseded 30/09/2026 by `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`, which restates it unchanged and names this file as where the baseline is recorded
- No `05-USER-FLOW` citation: the story's `User Flow` flag is N/A, so no consolidated flow or flow implementation record exists for it
