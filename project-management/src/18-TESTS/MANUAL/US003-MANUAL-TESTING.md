# US003 — Manual Testing Guide

_The manual testing guide for US003 — the journey a tester follows step by step, and — once walked — whether each step passed. Authored on 30/09/2026 at `17-story-plans` Step 7.2, as a backfill for a story planned before authorship moved to that step: written from the specs below, before any of the story's work exists._

**Last Updated**: 30/09/2026 · **Story**: US003 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US003.md` — Absence gets an owning guide, born under 270 with every clause's tier stated
- **Story plan:** `../../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the code master this guide was authored beside
- **Branch:** `us003/absence-guide`
- **Surface:** Gate — every row runs a `code/src/scripts/audits/*.sh` gate or reads a file in the repository
- **Authored from:** the story; `../../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md`; the story plan; `../../16-SPRINT-PLANS/02-SPRINT-PLAN-02.md`; `../../15-DECISIONS/ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH-02-09-2026.md`, `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` and `../../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`. No stage-1 design (`04`–`08`) and no `09`, `10`, `12`, `13` or `14` planning artefact exists for this story — every one of those flags reads N/A. Never code.

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
- **Build order:** US003 is worked in SPRINT-02, **ahead of** US004, so the `doc-references.sh`
  baseline applies and DOCREF-01 is walked as written. Only in the carry case — the story slips to
  SPRINT-03 and is worked there after US004 has landed — does the story plan's _The citation gate,
  corrected_ replace the baseline with a plain pass.
- **Seed data:** none. No fixture, no seeded user, no credential, no personal data.
- **Accounts / roles:** none — the story introduces no permission boundary. The tester is someone
  other than the story's author (the story's _QA Acceptance Criteria — Manual_).
- **Out of scope:**
  - **Permission and access** — the QA plan's `PA` table reads _None_: no runtime surface, endpoint
    or protected action, so there is no role boundary to cross and no ID to own.
  - **Accessibility** — the QA plan's Section 3 is N/A, and the story's _Verification Checks_ agree:
    no rendered screen or interactive component; the guide is Markdown read in an editor.
  - **Responsive behaviour** — the QA plan's Section 4 is N/A, for the same reason.
  - **User flow** — the story's `User Flow` flag reads N/A, so no consolidated flow covers it: every
    `Flow` cell is `—`, and `18-consolidate-design-work` has none to set.
  - **`docs-pairing.sh`** — regression only in the story's _Verification Checks_; the story creates
    no directory and owes no new pair.
  - **Markdown lint and format** (`code/src/scripts/syntax/lint.sh`) — a line in the story's
    _Verification Checks_, run before the PR, not a manual acceptance criterion.
  - **The test suites and `migrate.sh check`** — N/A in the story: no code path, no model.
- **Open questions** — each awaits the developer's answer, and every row it holds carries
  `Awaiting answer` in `Notes` until it is answered and the row rewritten from it:
  1. **BITE-04 (`ES-04`).** `doctrine-drift.sh` reads fenced code only — DRIFT-02 says so, after
     `ADR-US001-PROSE-DOCTRINE-VERIFICATION` — so a `TYPES-*` H2 restated in prose is invisible to
     it, and the gate cannot exit non-zero on it. Is `ES-04`'s set-up a fenced claim the drift
     table pins, restated in a second fence, or is the restated heading caught by the read-across
     BOUNDARY-05 already walks, and `ES-04` re-worded to match?

---

## Recorded during the build

The story requires the `doc-references.sh` baseline in this file (Scenario _The citation gate is
read against a recorded baseline_), captured before any file is edited, as
`ADR-US003-CITATION-GATE-BASELINE-DIFF` also requires; its QA tasks add the after-run. Two more are
kept beside it without a home named for them: the four skills' figures, which the story plan's
_Risks_ re-measures before committing, and the Codd primary-source check, which Scenario 9 requires
before either the row or the fallback sentence is written. The implementer fills these during the
build, the baseline half before the first edit — never reconstructed afterwards. The journeys below
check them at the walk. Not a journey: nothing here carries a `Result`.

| Measurement                                                                                                                     | Value |
| ------------------------------------------------------------------------------------------------------------------------------- | ----- |
| Baseline — date, commit and git-index state of the capture; a baseline is comparable only against a run in the same index state |       |
| The four named skills' counted lines before and after the edit — 169, 155, 220 and 148 in the story                             |       |
| `code/docs/ABSENCE.md`, counted lines at birth                                                                                  |       |
| The Codd primary-source check — the source read, the date, and whether it found derivation or convergence                       |       |

**The `doc-references.sh` baseline.** Not yet captured. Every finding by identity — file, line and
class, as the gate printed it — or `None.` The forward references to `code/docs/ABSENCE.md` among
them are marked as this story's own.

**The `doc-references.sh` run after the build.** Not yet captured. Same form, same index state.

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The guide and its frontmatter

| ID       | Action                                               | Expected outcome                                                                                                                                                                         | Flow | QA           | Result | Notes |
| -------- | ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| GUIDE-01 | Open `code/docs/ABSENCE.md`                          | It exists, and opens with the standard header block, its Claude Model line included                                                                                                      | —    | HP-01        |        |       |
| GUIDE-02 | Read its frontmatter                                 | Routing frontmatter — `type: guide`, `skills:` and `model:` — whose `skills:` names `backend`, `frontend`, `code-reviewer` and `refactor` and no other; `stack-django` is not among them | —    | HP-01, EC-04 |        |       |
| GUIDE-03 | Run `bash code/src/scripts/audits/routing-skills.sh` | Exits 0, with every frontmatter name resolved — including through the wrapped-array form Prettier forces at `printWidth: 100`                                                            | —    | HP-01        |        |       |

### Registration

| ID          | Action                                                                                                        | Expected outcome                                                                           | Flow | QA    | Result | Notes |
| ----------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| REGISTER-01 | Open the root `REFERENCES.md`, `code/REFERENCES.md` and `code/docs/CONTEXT.md`, and re-read each row in place | Each carries an index row for `code/docs/ABSENCE.md`, and each row reads true of the guide | —    | HP-01 |        |       |
| REGISTER-02 | Read `code/docs/CONTEXT.md`'s directory tree                                                                  | It carries an entry for `ABSENCE.md`                                                       | —    | —     |        |       |
| REGISTER-03 | Open `code/CONTEXT.md`                                                                                        | No row for `ABSENCE.md` — it carries none for either guide born since charting             | —    | —     |        |       |

### Length and the ratchet

| ID        | Action                                                                                                           | Expected outcome                                                                                     | Flow | QA    | Result | Notes |
| --------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| LENGTH-01 | Run `bash code/src/scripts/audits/docs-length.sh --path code/docs --limit 1`                                     | `code/docs/ABSENCE.md` is listed at under 270 counted lines, matching the figure recorded above      | —    | HP-02 |        |       |
| LENGTH-02 | Run `bash code/src/scripts/audits/docs-length.sh` with `--since` set to the commit the story branch was cut from | The ratchet fails nothing: no file the story edited that sat at or above 270 counted lines has grown | —    | HP-02 |        |       |
| LENGTH-03 | Run `bash code/src/scripts/audits/docs-length.sh`                                                                | No new file is reported at or above the warn tier                                                    | —    | HP-02 |        |       |
| LENGTH-04 | Compare the four named skills' before and after figures recorded above                                           | No skill that sat at or above 270 counted lines before its reciprocity edit has grown                | —    | —     |        |       |

### The six kinds and the crib

| ID       | Action                                                                                             | Expected outcome                                                                                                                                        | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| KINDS-01 | Read the guide's six kinds                                                                         | Expected miss, not-yet, empty, failure, not-supplied and not-applicable are each named and distinguished from the other five                            | —    | HP-03 |        |       |
| KINDS-02 | Look for the guide's claim of exhaustiveness and mutual exclusion, and for its tie-breaks          | Stated: the six cover the absences this stack produces and any absence maps to exactly one; wherever two could plausibly apply, the tie-break is stated | —    | HP-03 |        |       |
| KINDS-03 | Using only the guide, classify an absence that could read as either not-supplied or not-applicable | The stated tie-break resolves it to exactly one kind                                                                                                    | —    | EC-01 |        |       |
| KINDS-04 | Read the crib's surfaces                                                                           | Python, Rust, Alpine, HTMX and mobile TypeScript, mapped against all six kinds — those five surfaces and no others                                      | —    | HP-03 |        |       |
| KINDS-05 | Read every cell of the crib                                                                        | Each names a concrete expression, or states why that kind cannot arise on that surface; no cell is blank, a bare dash, or the word "varies"             | —    | HP-03 |        |       |
| KINDS-06 | Find a cell for a kind that cannot arise on its surface                                            | The cell says so, and gives the reason                                                                                                                  | —    | EC-02 |        |       |
| KINDS-07 | Check every crib cell for a citation                                                               | No cell cites anything that does not yet exist — each is self-contained at birth                                                                        | —    | —     |        |       |

### The boundary with the `TYPES-*` family

| ID          | Action                                                                                             | Expected outcome                                                                                                                                                                            | Flow | QA    | Result | Notes |
| ----------- | -------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| BOUNDARY-01 | Read the crib's Rust entry                                                                         | It cites `code/docs/data-structures/TYPES-RUST.md` → _Option and Result, never sentinels_ rather than restating it                                                                          | —    | HP-04 |        |       |
| BOUNDARY-02 | Find the absence-enum rule                                                                         | Stated in this guide: an absence with more than one meaning is modelled as an enum rather than a null                                                                                       | —    | HP-04 |        |       |
| BOUNDARY-03 | Find the never-overload rule                                                                       | Stated in this guide, citing `code/docs/rls/MIDDLEWARE-AND-NINJA.md` → _Row locking_ — the guard paragraph, where "No row" has two causes that look identical — as its one shipped instance | —    | —     |        |       |
| BOUNDARY-04 | Read the guide's _What this is not_                                                                | `GATE-REPORTING.md`, `FORWARD-VOICE.md` and `NEGATIVE-SPACE.md` are named there as siblings, and none of them appears as a crib row                                                         | —    | —     |        |       |
| BOUNDARY-05 | Compare the guide's headings with the H2s of the six `code/docs/data-structures/TYPES-*.md` guides | No `TYPES-*` H2 is restated                                                                                                                                                                 | —    | —     |        |       |
| BOUNDARY-06 | Read the guide against the six `TYPES-*` guides, rule by rule                                      | No rule is stated in two homes, and every shape rule is left where it already lived                                                                                                         | —    | —     |        |       |

### Enforcement tiers

| ID      | Action                                                                                                                                                      | Expected outcome                                                                              | Flow | QA    | Result | Notes |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| TIER-01 | Read the guide clause by clause — every sentence or bullet stating a rule a reader is expected to obey, and not the headings, worked examples or crib cells | Each clause carries an inline marker — `[gate: fail]`, `[judgement]` or `[gate: prose]`       | —    | HP-05 |        |       |
| TIER-02 | Read each `[gate: fail]` marker                                                                                                                             | Each names the gate that enforces it, and says so where that gate's workflow is path-filtered | —    | HP-05 |        |       |
| TIER-03 | Search the guide for `[gate: warn]`                                                                                                                         | No clause carries it                                                                          | —    | HP-05 |        |       |
| TIER-04 | Look for a single document-level marker, then read the crib's cells for markers                                                                             | No document-level marker stands in for the per-clause ones, and no crib cell carries a marker | —    | HP-05 |        |       |

### Reciprocity

| ID       | Action                                                                                                                                                     | Expected outcome                                   | Flow | QA    | Result | Notes |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- | ---- | ----- | ------ | ----- |
| RECIP-01 | Open `.claude/skills/backend/SKILL.md`, `.claude/skills/frontend/SKILL.md`, `.claude/skills/code-reviewer/SKILL.md` and `.claude/skills/refactor/SKILL.md` | Each cites `code/docs/ABSENCE.md`                  | —    | HP-06 |        |       |
| RECIP-02 | Run `bash code/src/scripts/audits/skill-conformance.sh`                                                                                                    | Exits 0 — clause 14 discharged for all four skills | —    | HP-06 |        |       |

### The drift row

| ID       | Action                                                              | Expected outcome                                                                                                                            | Flow | QA           | Result | Notes |
| -------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| DRIFT-01 | Open the drift table in `code/src/scripts/audits/doctrine-drift.sh` | It carries one new `owned` row pinning the absence-enum rule to `code/docs/ABSENCE.md`                                                      | —    | HP-07        |        |       |
| DRIFT-02 | Run `bash code/src/scripts/audits/doctrine-drift.sh`                | Exits 0: the new row is green and no existing claim forks. A regression guard only — it reads fenced code, and BOUNDARY-06 checks the prose | —    | HP-04, HP-07 |        |       |

### The boundary-vocabulary ban

| ID     | Action                                                                                          | Expected outcome                                                      | Flow | QA           | Result | Notes |
| ------ | ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| BAN-01 | Open `.claude/skills/codebase-design/SKILL.md` at its ban on substituting "boundary" for "seam" | The ban is scoped to architectural contexts, not the whole repository | —    | HP-08        |        |       |
| BAN-02 | Check each of that file's four uses of "boundary" against the new scope                         | Each is compliant — any that still violated has been reworded         | —    | HP-08, EC-06 |        |       |
| BAN-03 | Find the commit that scoped the ban                                                             | It is the commit that adds `code/docs/ABSENCE.md`, not a follow-up    | —    | —            |        |       |

### Attribution

| ID        | Action                                                                                                                      | Expected outcome                                                                                                                                                                                                                                                                               | Flow | QA           | Result | Notes |
| --------- | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------ | ------ | ----- |
| CREDIT-01 | Open `README.md` → _Influences_                                                                                             | A row for Robert Harper's Boolean Blindness, credited for the absence-enum rule, stating its licence — not share-alike                                                                                                                                                                         | —    | HP-09        |        |       |
| CREDIT-02 | Look for E. F. Codd's applicable/inapplicable null marks — a row in the same table, or a sentence in `code/docs/ABSENCE.md` | Exactly one of the two. A row crediting them for the not-supplied and not-applicable kinds, its licence stated and not share-alike; or — where the primary-source check found convergence — no row, and a guide sentence stating that the split parallels Codd's marks, claiming no derivation | —    | HP-09, EC-05 |        |       |
| CREDIT-03 | Compare the outcome of CREDIT-02 with the primary-source check recorded above                                               | The check is recorded, and done before the row or sentence was written; derivation produced the row, convergence the sentence                                                                                                                                                                  | —    | —            |        |       |
| CREDIT-04 | Find the commits that added each _Influences_ row and the rule it credits                                                   | Each row landed in the same commit as its rule                                                                                                                                                                                                                                                 | —    | —            |        |       |

### The citation gate, as a diff

| ID        | Action                                                                                                                                                            | Expected outcome                                                                                                                                                                                                                                                               | Flow | QA    | Result | Notes |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| DOCREF-01 | Run `bash code/src/scripts/audits/doc-references.sh` in the git-index state the baseline recorded, and compare its findings with the baseline, finding by finding | No finding is absent from the baseline: no shipped file the story wrote or edited — the guide, the four skills, `README.md` and the drift table among them — adds an unresolved citation of any class. Recorded as a diff, never as the gate passing while the baseline stands | —    | EC-07 |        |       |
| DOCREF-02 | In the same output, look for the forward references to `code/docs/ABSENCE.md` the baseline recorded                                                               | All have cleared — the guide they name now exists                                                                                                                                                                                                                              | —    | EC-07 |        |       |

### The cold read

| ID      | Action                                                                                                           | Expected outcome                                                                                                                   | Flow | QA  | Result | Notes |
| ------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| COLD-01 | Open `code/docs/ABSENCE.md` cold, as a developer who has not seen the change, with a given `return None` in mind | You can name which of the six kinds it means, and read its expression for your surface off the crib, without opening a second file | —    | —   |        |       |

### The gates still bite

Each row sets up its failure on the finished change, runs the gate, then undoes the set-up; a
clean re-run of the same gate confirms the undo before the next row.

| ID      | Action                                                                                                                                                                       | Expected outcome                                                                                                     | Flow | QA    | Result | Notes                             |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| BITE-01 | Pad `code/docs/ABSENCE.md` to 270 counted lines or more, run `bash code/src/scripts/audits/docs-length.sh`, then undo                                                        | The guide is reported in the warn tier, with no allowance                                                            | —    | ES-01 |        |                                   |
| BITE-02 | Remove the `code/docs/ABSENCE.md` citation from one of the four named skills, run `bash code/src/scripts/audits/skill-conformance.sh`, then restore it                       | Exits non-zero, naming the undischarged clause 14                                                                    | —    | ES-02 |        |                                   |
| BITE-03 | Misspell one skill name in the guide's routing frontmatter, run `bash code/src/scripts/audits/routing-skills.sh`, then restore it                                            | Exits non-zero, naming the unresolved skill                                                                          | —    | ES-03 |        |                                   |
| BITE-04 | In `code/docs/ABSENCE.md`, restate a `TYPES-*` H2 that the drift table pins, run `bash code/src/scripts/audits/doctrine-drift.sh`, then undo                                 | Exits non-zero, naming the forked claim                                                                              | —    | ES-04 |        | Awaiting answer — open question 1 |
| BITE-05 | In one crib cell, cite a per-surface clause no slice has written yet, run `bash code/src/scripts/audits/doc-references.sh`, then undo                                        | Exits non-zero, with a dangling-path finding for that citation beyond the baseline                                   | —    | ES-05 |        |                                   |
| BITE-06 | With the story committed, pad `code/docs/ABSENCE.md` until it measures at least 270 counted lines, run `bash code/src/scripts/audits/docs-length.sh --since HEAD`, then undo | The ratchet fires on the uncommitted growth — the change that grew the file — and not on the story's committed guide | —    | EC-03 |        |                                   |

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
- [ ] Cross-checked against `../AUTOMATED/US003-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test
- [ ] The tester is not the story's author — the story's _QA Acceptance Criteria — Manual_

---

## Cross-references

- `../../02-STORIES/US003.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US003-TEST-STATUS.md` — the paired automated-test record; written at `22-implementation-documentation` Step 4, so absent until then
- `../../11-QA/PLANNING/QA-PLAN-US003-ABSENCE-GUIDE.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — the QA implementation record, written at `22`: whether the specified scenarios were met
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `../../15-DECISIONS/ADR-US003-CRIB-SELF-CONTAINED-AT-BIRTH-02-09-2026.md` — why no crib cell cites forward
- `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` — why the read-across, not `doctrine-drift.sh`, checks the prose
- `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — why `doc-references.sh` is read as a diff against the baseline; superseded 30/09/2026 by `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`, which restates it unchanged and names this file as where the baseline is recorded
- No `05-USER-FLOW` citation: the story's `User Flow` flag is N/A, so no consolidated flow or flow implementation record exists for it
