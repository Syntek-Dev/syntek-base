# US001 — Manual Testing Guide

_The manual testing guide for US001 — the journey a tester follows step by step, and — once walked — whether each step passed. Authored on 30/09/2026 at `17-story-plans` Step 7.2, as a backfill for a story planned before authorship moved to that step: written from the specs below, before any of the story's work exists._

**Last Updated**: 30/09/2026 · **Story**: US001 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US001.md` — Reliability doctrine gets an owning guide, and every pointer reaches it
- **Story plan:** `../../17-STORY-PLANS/02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — the code master this guide was authored beside
- **Branch:** `us001/reliability-doctrine-home`
- **Surface:** Gate — every row runs a `code/src/scripts/audits/*.sh` gate or reads a Markdown file in the repository
- **Authored from:** the story; `../../11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md`; the story plan; `../../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md`; `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`, `../../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` (and the record it supersedes, `../../15-DECISIONS/ADR-US001-INSTANCE-CITATION-FULL-PATHS-02-09-2026.md`) and `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`. No stage-1 design (`04`–`08`) and no `09`, `10`, `12`, `13` or `14` planning artefact exists for this story — every one of those flags reads N/A. Never code.

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
  - **Permission and access** — the QA plan's `PA` table reads _None_: the story adds no runtime
    surface, endpoint or protected action, so there is no role boundary to cross and no ID to own.
  - **Accessibility** — the QA plan's Section 3 is N/A: no rendered screen or interactive component;
    the output is Markdown read in an editor or on a repository host.
  - **Responsive behaviour** — the QA plan's Section 4 is N/A, for the same reason.
  - **User flow** — the story's `User Flow` flag reads N/A, so no consolidated flow covers it: every
    `Flow` cell is `—`, and `18-consolidate-design-work` has none to set.
  - **Markdown lint and format** (`code/src/scripts/syntax/lint.sh`) — a line in the story's
    _Verification Checks_, run before the PR, not a manual acceptance criterion.
  - **The test suites and `migrate.sh check`** — N/A in the story: no code path, no model.
- **Open questions** — each awaits the developer's answer, and every row it holds carries
  `Awaiting answer` in `Notes` until it is answered and the row rewritten from it:
  1. **BITE-02 (`ES-02`).** The rule's old location is a section of `code/docs/TASK-AUTHORING.md`,
     and that file still exists after the move, so a pointer re-aimed at it cites a path that
     resolves — `doc-references.sh` tests paths, not sections — and the gate is non-zero on the
     baseline before any set-up. Is `ES-02`'s "exits non-zero naming the dangling citation"
     walked as a finding beyond the baseline for a citation of a path that no longer exists, as a
     section-level check no gate makes, or dropped from the QA plan?

---

## Recorded during the build

The story requires the rule inventory in this file (Scenario _The migration loses nothing_), and
`ADR-US003-CITATION-GATE-BASELINE-DIFF` requires the `doc-references.sh` baseline here. The
implementer fills both **before the first edit to any source section** — the story plan's Step A;
neither is reconstructible once editing starts. The journeys below check them at the walk. Not a
journey: nothing here carries a `Result`.

### Rule inventory — captured before the first edit

Not yet captured. One row per rule stated in the four source sections as they stood before the
edit: `code/docs/TASK-AUTHORING.md` → _Idempotency_, _Retries and backoff_ and _The error taxonomy
on this surface_ (the fourth section, story plan Step E2), and
`code/docs/performance/API-AND-MONITORING.md` → _Background Jobs and Queues (Celery)_.

| #   | Rule, as stated before the edit | Source section | Disposition — moved / kept / deleted | Home after the story | Reason (deleted only) |
| --- | ------------------------------- | -------------- | ------------------------------------ | -------------------- | --------------------- |

### The `doc-references.sh` baseline — captured before the first edit

Not yet captured. The date and commit of the run, then every finding by identity — file, line and
class, as the gate printed it — or `None.`

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### Rule inventory

| ID           | Action                                                                                                                  | Expected outcome                                                                                                                                                             | Flow | QA    | Result | Notes |
| ------------ | ----------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| INVENTORY-01 | Open _Recorded during the build_ → the rule inventory above                                                             | Every row names a rule, its source section and a disposition of moved, kept or deleted; no cell a row needs is blank                                                         | —    | HP-06 |        |       |
| INVENTORY-02 | Read the four source sections as they stood where the story branch was cut, ticking each rule off against the inventory | Every rule stated there has an inventory row — none is missing                                                                                                               | —    | HP-06 |        |       |
| INVENTORY-03 | For each rule marked moved, open the home the inventory names                                                           | The rule is stated there, and is no longer stated in its source section                                                                                                      | —    | HP-06 |        |       |
| INVENTORY-04 | For each rule marked kept, open its source section                                                                      | The rule is still stated where it was                                                                                                                                        | —    | HP-06 |        |       |
| INVENTORY-05 | For each rule marked deleted, read its reason                                                                           | Each reason names the home that still states the rule — a duplicate of `code/docs/TASK-AUTHORING.md` — so no rule present before the move is absent from every home after it | —    | HP-06 |        |       |
| INVENTORY-06 | Total the inventory by disposition                                                                                      | Moved plus kept plus deleted equals the number of rules captured before the edit — the inventory balances                                                                    | —    | HP-06 |        |       |

### The reliability family

| ID        | Action                                                                                                 | Expected outcome                                                                                                                    | Flow | QA    | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| FAMILY-01 | List `code/docs/reliability/`                                                                          | It exists, holding a `CONTEXT.md`, a `CLAUDE.md` and at least one guide file beside them                                            | —    | HP-01 |        |       |
| FAMILY-02 | Open the family's `CONTEXT.md`                                                                         | It records why the family's files are named and split as they are — names decided in this story, not inherited from the feature map | —    | —     |        |       |
| FAMILY-03 | Open each guide file in the family                                                                     | Each opens with routing frontmatter — `type: guide`, `skills:` and `model:`                                                         | —    | HP-01 |        |       |
| FAMILY-04 | Read each guide file against the rule inventory                                                        | Each states at least one rule the inventory marks as moved into it                                                                  | —    | —     |        |       |
| FAMILY-05 | Open the root `REFERENCES.md`, `code/REFERENCES.md` and `code/CONTEXT.md`                              | Each carries an index row for the family, and the row reads true of it                                                              | —    | —     |        |       |
| FAMILY-06 | Run `bash code/src/scripts/audits/docs-pairing.sh`                                                     | Exits 0; neither half of the family's pair carries the other's headings                                                             | —    | HP-01 |        |       |
| FAMILY-07 | Look in `code/docs/`, as it stood where the story branch was cut, for a directory of the family's name | None existed — the name was free before any rule left its old home                                                                  | —    | EC-05 |        |       |

### The idempotency proof ladder

| ID        | Action                                             | Expected outcome                                                                                                                                                           | Flow | QA    | Result | Notes |
| --------- | -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| LADDER-01 | Open `code/docs/TASK-AUTHORING.md` → _Idempotency_ | The proof ladder — database constraint, conditional state transition, idempotency key for an external effect — is not stated; a citation of the family stands in its place | —    | HP-02 |        |       |
| LADDER-02 | Read on through the same section                   | `task_acks_late`, broker eviction and signature drift are still stated there                                                                                               | —    | HP-02 |        |       |
| LADDER-03 | Follow that citation                               | It lands on the family guide that states all three rungs of the ladder                                                                                                     | —    | HP-02 |        |       |

### Retries and backoff

| ID       | Action                                                                    | Expected outcome                                                   | Flow | QA    | Result | Notes |
| -------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| RETRY-01 | Open `code/docs/TASK-AUTHORING.md` where _Retries and backoff_ stood      | None of that section's doctrine bullets is stated there any longer | —    | HP-03 |        |       |
| RETRY-02 | Open the family guide the inventory names for those bullets               | Each bullet is stated there                                        | —    | HP-03 |        |       |
| RETRY-03 | Open `code/docs/TASK-AUTHORING.md` → _The error taxonomy on this surface_ | The task-surface class table is still there, unchanged             | —    | HP-03 |        |       |

### Background jobs and queues

| ID         | Action                                                                                     | Expected outcome                                                                                                                                                                                     | Flow | QA    | Result | Notes |
| ---------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| MONITOR-01 | Open `code/docs/performance/API-AND-MONITORING.md` → _Background Jobs and Queues (Celery)_ | It states only failed-job visibility, plus a pointer to the reliability family                                                                                                                       | —    | HP-04 |        |       |
| MONITOR-02 | Check each rule the inventory lists from that section                                      | Every rule that duplicated `code/docs/TASK-AUTHORING.md` is marked deleted, not moved; every rule that was neither failed-job monitoring nor a duplicate is marked moved and is stated in the family | —    | HP-04 |        |       |

### The three pointers

| ID         | Action                                                                                                                              | Expected outcome                                                                                                                                                                                  | Flow | QA           | Result | Notes |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| POINTER-01 | Open `code/docs/PROCESS-MODEL.md` at its pointer to the old home, and re-read the sentence around it                                | It points at the reliability family, and the sentence still reads true                                                                                                                            | —    | HP-05        |        |       |
| POINTER-02 | Open `code/docs/NEGATIVE-SPACE.md` and read each of its `TASK-AUTHORING.md` citations in place                                      | Each citation naming a migrated rule points at the family; those naming the enqueue boundary and the error taxonomy still point at `code/docs/TASK-AUTHORING.md`; every sentence still reads true | —    | HP-05        |        |       |
| POINTER-03 | Open `code/docs/CONTEXT.md`                                                                                                         | Its pointer reaches the family and its index row for the family is present — both edits landed, and neither reverted the other                                                                    | —    | HP-05, EC-04 |        |       |
| POINTER-04 | Run `bash code/src/scripts/audits/doc-references.sh`, and compare its findings with the baseline recorded above, finding by finding | No finding is absent from the baseline: nothing the story wrote or edited left a dangling citation. Recorded as a diff against the baseline, never as the gate passing while the baseline stands  | —    | HP-05        |        |       |

### Length at birth

| ID        | Action                                                                       | Expected outcome                                                                          | Flow | QA  | Result | Notes |
| --------- | ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| LENGTH-01 | Run `bash code/src/scripts/audits/docs-length.sh --path code/docs --limit 1` | Every file under `code/docs/reliability/` is listed at under 270 counted lines            | —    | —   |        |       |
| LENGTH-02 | Run `bash code/src/scripts/audits/docs-length.sh`                            | No file the story created or edited is reported at or above 270 without a dated allowance | —    | —   |        |       |

### The read-across

| ID      | Action                                                                                                                                       | Expected outcome                                                                                                                                                                       | Flow | QA    | Result | Notes |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| READ-01 | Read the reliability family against `code/docs/TASK-AUTHORING.md`, rule by rule                                                              | No rule is stated in both                                                                                                                                                              | —    | —     |        |       |
| READ-02 | Read the family against `code/docs/performance/API-AND-MONITORING.md`, rule by rule                                                          | No rule is stated in both                                                                                                                                                              | —    | —     |        |       |
| READ-03 | Find each rule that is both cross-surface doctrine and a Celery specific                                                                     | It is stated in exactly one home, and the other cites it — never both, never neither                                                                                                   | —    | EC-01 |        |       |
| READ-04 | Open `code/docs/TASK-AUTHORING.md` cold, as a reader who has not seen the change, and look for the idempotency ladder and the retry doctrine | Each is reached in one hop, by the citation left where it used to be                                                                                                                   | —    | —     |        |       |
| READ-05 | Run `bash code/src/scripts/audits/doctrine-drift.sh`                                                                                         | Its three registered API-envelope claims each still resolve to exactly one home — no new drift. A regression guard only: it reads fenced code, and READ-01 and READ-02 check the prose | —    | EC-03 |        |       |

### The gates still bite

Each row sets up its failure on the finished change, runs the gate, then undoes the set-up; a
clean re-run of the same gate confirms the undo before the next row.

| ID      | Action                                                                                                                                                                            | Expected outcome                                                                                   | Flow | QA    | Result | Notes                             |
| ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| BITE-01 | Move the family's `CLAUDE.md` aside, run `bash code/src/scripts/audits/docs-pairing.sh`, then put it back                                                                         | Exits non-zero, naming `code/docs/reliability/` as unpaired                                        | —    | ES-01 |        |                                   |
| BITE-02 | Re-aim one repointed pointer at the rule's old location, run `bash code/src/scripts/audits/doc-references.sh`, then undo the edit                                                 | Exits non-zero, with a finding naming that dangling citation                                       | —    | ES-02 |        | Awaiting answer — open question 1 |
| BITE-03 | Grow a scratch guide file in the family to 269 counted lines and run `bash code/src/scripts/audits/docs-length.sh`; grow it to 270 and run it again; then delete the scratch file | At 269 the file is not reported; at 270 it enters the warn tier — the boundary is inclusive at 270 | —    | EC-02 |        |                                   |
| BITE-04 | Grow one of the family's guide files to 270 counted lines or more, run `bash code/src/scripts/audits/docs-length.sh`, then undo                                                   | The file is reported in the warn tier, and no dated allowance covers it                            | —    | ES-03 |        |                                   |

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
- [ ] Cross-checked against `../AUTOMATED/US001-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test
- [ ] The tester is not the story's author — the story's _QA Acceptance Criteria — Manual_

---

## Cross-references

- `../../02-STORIES/US001.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US001-TEST-STATUS.md` — the paired automated-test record; written at `22-implementation-documentation` Step 4, so absent until then
- `../../11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — the QA implementation record, written at `22`: whether the specified scenarios were met
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` — why the read-across, not `doctrine-drift.sh`, checks the prose
- `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — why `doc-references.sh` is read as a diff against the baseline; superseded 30/09/2026 by `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`, which restates it unchanged and names this file as where the baseline is recorded
- No `05-USER-FLOW` citation: the story's `User Flow` flag is N/A, so no consolidated flow or flow implementation record exists for it
