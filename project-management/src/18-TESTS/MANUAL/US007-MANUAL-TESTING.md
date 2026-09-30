# US007 — Manual Testing Guide

_The manual testing guide for US007 — the checks a tester runs step by step, and, once walked, whether each passed. Authored from the specs at `17-story-plans` Step 7.2 as a backfill on 30/09/2026; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 30/09/2026 · **Story**: US007 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US007.md` — the story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits
- **Story plan:** `../../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the code master this guide was authored beside
- **Branch:** `us007/status-vocabulary-one-owner`
- **Surface:** Gate — five audit gates, two Markdown syntax legs and a `git grep`, plus read-acrosses of Markdown in an editor. No stack, no rendered page
- **Authored from:** `../../02-STORIES/US007.md` (Acceptance Criteria and its thirteen scenarios, QA Acceptance Criteria — Manual, QA Tasks — Manual, Verification Checks, Definition of Done); `../../11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` (Sections 1 to 8); `../../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` (Approach, Phases 0 to 6, Quality Gates, Testing, Documentation Write-Ups, Sprint Verification Checklist, Definition of Done); `../../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md`; `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` (Decision). No `04`–`14` artefact exists for this story: every flag but `QA` reads `N/A`. Never code.

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

- **Stack:** none — this story runs no container and renders nothing. Every row is a
  `code/src/scripts/**/*.sh` gate, a `git` query or an editor read (plan → _Quality Gates, Scripts
  & Local↔Docker Alignment_)
- **Base URL:** none — no rendered surface
- **Seed data:** none — the population under test is this repository's own tracked tree
- **Accounts / roles:** none — no role boundary exists (QA plan Section 2 → _Permission and access_)
- **Where the walk runs:** the story's checkout at the plan's Phase 6, every edit landed
- **The baseline:** captured at the plan's Phase 0, **before the first edit**, by QA plan Section 6
  steps 1 to 6, with the untracked artefacts staged first (plan → Phase 0, item 1), and pasted
  into _Recorded during the build_ below at capture. A baseline taken after an edit is void — row
  CAPTURE-01
- **The tester:** someone other than the author of the story's edits — the cold reads (SKILL-01,
  TRACE-01) and the sign-off depend on it
- **Out of scope:**
  - **Permission and access** — section dropped. The story adds no endpoint, screen, protected
    action or ownable identifier, and the QA plan has no `PA` scenario (Section 2). The travel
    rule, the one boundary that behaves like access control, is walked as TRACE-01
  - **Accessibility** — section dropped. No rendered screen or interactive component (QA plan
    Section 3); the story ships Markdown read in an editor
  - **Responsive behaviour** — section dropped. No rendered screen (QA plan Section 4)
  - **The automated record** — no row cross-checks it. "../AUTOMATED/US007-TEST-STATUS.md" is
    still written at `22`, carrying the generator's no-test block and, in Section 3, the reason:
    the story has no code path, so no suite and no coverage figure
    (`../AUTOMATED/CLAUDE.md` → _Guardrails_)
  - **The Definition of Done's register writes** — the `GAPS.md` closure and the one `DEFERRED.md`
    row are written by `22-implementation-documentation` and verified at `23-pr-and-review`, not
    walked here
  - Every `HP`, `ES` and `EC` scenario in the QA plan is exercised by a row below; none is out of
    scope
- **Open questions** — none open. Both were answered by the developer on 30/09/2026:
  1. **The automated record** — answered: every story gets one, a plan cannot decide it away
     (`../AUTOMATED/CLAUDE.md` → _Guardrails_); the story plan's write-up map and Definition of
     Done were corrected to match.
  2. **The manual register's status set — CASING-03** — answered: the story's enumeration is
     refreshed to the template's five values, "Authored — not yet walked / In progress / Passed /
     Failed / Blocked" (`../../02-STORIES/US007.md`). CASING-03's expected outcome is unchanged.

---

## Recorded during the build

The captured sets and the figures the rows below read. Story Scenario 13 and
`../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
which supersedes `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, put the baseline in this
file, so the implementer pastes its half here at the plan's Phase 0, before the first edit —
never reconstructed afterwards; the walker pastes the close half at the walk. Each set is a fenced
block beneath this table — an empty set as an empty block with the gate's own zero-count line
above it (QA plan Section 6). Every figure carries its date. Nothing here carries a `Result`.

| Evidence                                                                 | Baseline — Phase 0 | Close — the walk | Read by                          |
| ------------------------------------------------------------------------ | ------------------ | ---------------- | -------------------------------- |
| Pre-edit tree — HEAD, porcelain count, stash SHA                         |                    | —                | CAPTURE-01, CAPTURE-02           |
| Detector hashes — the five gates                                         |                    |                  | DETECTOR-01, DETECTOR-02         |
| `doc-references.sh` — normalised `(file, kind, token)` set, and the diff |                    |                  | DOCREF-01 to DOCREF-09           |
| `skill-conformance.sh` — whole-line set, and the diff                    |                    |                  | CONFORM-01 to CONFORM-04         |
| `docs-pairing.sh` and `doctrine-drift.sh` — finding lines, and the diffs |                    |                  | GATES-01 to GATES-03             |
| `docs-length.sh --limit 1` — the three files' readings                   |                    |                  | CAPTURE-04, GATES-04, GATES-05   |
| Source-`**Status:**` population — before and after                       |                    |                  | CAPTURE-03, SOURCE-01, SOURCE-02 |
| Sprint-plan mirror cells — before and after, and the backtick choice     |                    |                  | SOURCE-03                        |
| Concurrent-change `>` lines, each with its file                          | —                  |                  | DOCREF-03, DOCREF-04             |
| The casing `git grep`, verbatim, and its output                          | —                  |                  | CASING-01, CASING-02             |
| The named-site inventory, with its role column                           | —                  |                  | INVENTORY-01                     |

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### Baseline capture

| ID         | Action                                                                                                        | Expected outcome                                                                                                                                                                                                                                                                   | Flow | QA    | Result | Notes |
| ---------- | ------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CAPTURE-01 | Open _Recorded during the build_ → the baseline half, and read its date against the story branch's first edit | The baseline exists, dated before the first edit: the pre-edit tree, the five detector hashes and the four diff-read gates' finding sets, an empty set recorded as empty. Had no baseline been captured first, the story stopped and captured at the recorded pre-edit SHA instead | —    | ES-01 |        |       |
| CAPTURE-02 | Read the pre-edit tree's record                                                                               | `git rev-parse HEAD`, the `git status --porcelain` count and, on a dirty tree, a `git stash create` SHA — so the tree is re-materialisable. A finding whose file entered or left the index between capture and close is the index move's, not the story's                          | —    | EC-01 |        |       |
| CAPTURE-03 | Read the captured source-`**Status:**` population                                                             | Re-counted from the tree at capture — every story, sprint record and story plan existing that day — never inherited from a figure in the story or the plan                                                                                                                         | —    | EC-07 |        |       |
| CAPTURE-04 | Read the captured `docs-length.sh --limit 1` figures for `STORIES.md`, `SPRINTS.md` and `completion/SKILL.md` | The gate's own readings at capture. The story's 97 and 88 of 07/09/2026 are not the criterion; the gate's before-and-after reading is                                                                                                                                              | —    | EC-08 |        |       |

### Detector

| ID          | Action                                                                                                                        | Expected outcome                                                                                                                                                                                                                | Flow | QA    | Result | Notes |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| DETECTOR-01 | Re-take `git hash-object` of the five gates the QA flag names — QA plan Section 6, step 2 — and compare each with its capture | Each hash is recorded beside its captured value, and each comparison is stated                                                                                                                                                  | —    | HP-01 |        |       |
| DETECTOR-02 | For any gate whose hash differs, read how its result is reported                                                              | That gate's diff is reported **detector-confounded**, never as the story's; the current detector is re-run over the recorded pre-edit tree in a scratch worktree and that set is diffed instead. Where none differs, it says so | —    | ES-04 |        |       |

### Citation gate

Run `bash code/src/scripts/audits/doc-references.sh`, normalise its output to `(file, kind, token)`
with multiplicity kept, and `diff` it against the baseline — QA plan Section 6, step 3 and the close
block, run as written. Every `>` line is classified by one question: is its file in
`git diff --name-only <recorded pre-edit SHA>`?

| ID        | Action                                                                                            | Expected outcome                                                                                                                                                                             | Flow | QA    | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| DOCREF-01 | Run the gate and the identity diff                                                                | No `>` line in any file the story edits. The pre-existing set is reported as standing — **never as a pass** while it is non-empty                                                            | —    | HP-01 |        |       |
| DOCREF-02 | Classify each `>` line whose file is in the edit set                                              | It is the story's: fixed, or — where the citation is right and merely unprovable downstream — marked. Never suppressed to clear the diff, and the gate is not reported as passing either way | —    | ES-02 |        |       |
| DOCREF-03 | Classify each `>` line whose file is outside the edit set                                         | A concurrent change's — named in _Recorded during the build_ with its file, neither cleared, inherited nor reported as the story's; the story's verdict is unaffected                        | —    | ES-03 |        |       |
| DOCREF-04 | Look among the outside-set lines for any from another story that landed between capture and close | Each is classified as DOCREF-03; the story's verdict does not move                                                                                                                           | —    | EC-02 |        |       |
| DOCREF-05 | Read the count column of the normalised diff                                                      | A `(file, kind, token)` whose count changed shows as removed-and-added — caught, because multiplicity is kept                                                                                | —    | EC-03 |        |       |
| DOCREF-06 | Find the pre-existing findings in files the story edited above them                               | None appears in the diff — identity dropped the line number, so a shifted line is not a false removal and a false addition                                                                   | —    | EC-04 |        |       |
| DOCREF-07 | Look for any `[plan prefix]` line from a file the story edits                                     | Each is the story's: repointed to the plan's on-disk prefixed name, or — where a superseded name is deliberately quoted — moved from backticks to double quotes                              | —    | ES-11 |        |       |
| DOCREF-08 | Read the lines for `../../02-STORIES/US007.md` itself                                             | Its pre-existing findings stand in the baseline and are not the story's to clear. Any the story repointed show as `<` lines, recorded as a clearance, not a requirement                      | —    | EC-10 |        |       |
| DOCREF-09 | Find every `doc-references: template-only` marker the story added                                 | Each marks a path that resolves here and that copier excludes (`code/docs/FORWARD-VOICE.md` Section 4) — never a dangling path or an instance citation, which are corrected or dropped       | —    | EC-11 |        |       |

### Skill gate

Run `bash code/src/scripts/audits/skill-conformance.sh`, sort its finding lines whole and `diff`
them against the baseline — QA plan Section 6, step 4 and the close block.

| ID         | Action                                                                                                   | Expected outcome                                                                                                                                                | Flow | QA    | Result | Notes |
| ---------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CONFORM-01 | Run the gate and the whole-line diff                                                                     | Against an empty baseline: exit 0 and no finding on `.claude/skills/completion/SKILL.md` — reported as a plain pass, the empty baseline cited. Otherwise a diff | —    | HP-02 |        |       |
| CONFORM-02 | Read any finding on a skill other than `completion`                                                      | Neither the story's nor a pass: an attributed diff whose story side is empty, the other skill named as a concurrent change's                                    | —    | ES-05 |        |       |
| CONFORM-03 | Read any `[house 14]` line on `completion/SKILL.md` and the guide it names                               | Where the guide is outside the edit set: a concurrent change's, the guide named — attribution is by path **and** cause                                          | —    | ES-06 |        |       |
| CONFORM-04 | Read any line on `completion/SKILL.md` whose cause is in the story's edit set, against an empty baseline | The story's, full stop — the empty-baseline-with-exit-0 path is this gate's only pass for this story                                                            | —    | EC-05 |        |       |

### Pairing, drift, length and syntax gates

| ID       | Action                                                                                                                 | Expected outcome                                                                                                                                                                                                  | Flow | QA    | Result | Notes |
| -------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| GATES-01 | Run `bash code/src/scripts/audits/docs-pairing.sh` and diff its finding lines against the baseline (Section 6, step 5) | No new finding line — two empty sets where the capture was empty — and the record says the gate decided nothing here, because the story creates, splits and moves no pair                                         | —    | HP-04 |        |       |
| GATES-02 | Run `bash code/src/scripts/audits/doctrine-drift.sh` and diff its finding lines against the baseline                   | The same claims as captured, one home each. Reported as a regression guard over the six files it can open — the skill, three `STEPS.md`, two `CHECKLIST.md` — fenced code only, never as having read a definition | —    | HP-05 |        |       |
| GATES-03 | Read any claim reported with two homes                                                                                 | The story's only if its fenced block sits in one of those six files and the story wrote it; otherwise a concurrent change's. Either way the record says the gate examined fenced code only                        | —    | ES-08 |        |       |
| GATES-04 | Run `bash code/src/scripts/audits/docs-length.sh --path project-management/docs/planning --limit 1`                    | `STORIES.md` and `SPRINTS.md` each under 270 counted lines, by the gate's own figure — never `wc -l`                                                                                                              | —    | HP-03 |        |       |
| GATES-05 | Run `bash code/src/scripts/audits/docs-length.sh --path .claude/skills/completion --limit 1`                           | `SKILL.md` under 270 counted lines, by the gate's own figure                                                                                                                                                      | —    | HP-03 |        |       |
| GATES-06 | Read the exit codes of GATES-04 and GATES-05                                                                           | Non-zero by construction — everything exceeds a one-line limit. Recorded as measurements, never as a pass or a fail                                                                                               | —    | EC-09 |        |       |
| GATES-07 | Run `bash code/src/scripts/audits/docs-length.sh`                                                                      | Exit 0 tree-wide, and no file the story edits newly in the warn band — this is the pass/fail leg                                                                                                                  | —    | HP-03 |        |       |
| GATES-08 | Where `STORIES.md` or `SPRINTS.md` reads 270 or more in GATES-04                                                       | The gate warns; the story trimmed the file or took a dated allowance under `code/docs/DOCUMENTATION-LENGTH.md` before close. Where neither did, it says so                                                        | —    | ES-07 |        |       |
| GATES-09 | Run `bash code/src/scripts/syntax/lint.sh --file-type markdown`                                                        | Exit 0 — markdownlint-cli2 over the Markdown the story ships                                                                                                                                                      | —    | —     |        |       |
| GATES-10 | Run `bash code/src/scripts/syntax/format.sh --file-type markdown` (a dry run — no `--fix`)                             | Exit 0 with no file reported as needing a format change                                                                                                                                                           | —    | —     |        |       |

### The two owning documents

| ID        | Action                                                                      | Expected outcome                                                                                                                                                                                                                 | Flow | QA  | Result | Notes |
| --------- | --------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| OWNERS-01 | Open `project-management/docs/planning/STORIES.md` → _Story statuses_       | The eleven story statuses, a meaning against each. The defining sentence names no board: the set is this repository's story lifecycle and a board is mapped onto it                                                              | —    | —   |        |       |
| OWNERS-02 | In the same section, read the scoping declaration                           | The rule comes first — a `Status` value is scoped to the register whose template declares it, and the eleven bind `US###.md` and its story plan and nothing else — with the sibling registers given "for example", count omitted | —    | —   |        |       |
| OWNERS-03 | In the same section, find the pointer and any mention of the export or push | A one-line pointer at the writer declaration in `.claude/skills/completion/SKILL.md`; the export and push appear only as consumers of the set, under the bold clickup-only marker                                                | —    | —   |        |       |
| OWNERS-04 | Open `project-management/docs/planning/SPRINTS.md` → _Sprint statuses_      | `Planned` · `In Progress` · `Done`, one meaning each                                                                                                                                                                             | —    | —   |        |       |
| OWNERS-05 | Open `project-management/docs/PLANNING-GUIDE.md`                            | No _Story Statuses_ section — the guide stays a thin index and routes statuses on to `planning/STORIES.md`                                                                                                                       | —    | —   |        |       |

### The skill

| ID       | Action                                                                       | Expected outcome                                                                                                                                                                                                                                                                                                                                                       | Flow | QA    | Result | Notes |
| -------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SKILL-01 | As a cold reader, open `.claude/skills/completion/SKILL.md` and nothing else | They can name the five story values it writes — `Pending` · `Open` · `Blocked` · `In Review` · `Completed` — the one sprint value, `Done`, and who writes the other six; and can say from the file's own words that its writer table is a declaration of authority, not a definition. The "never straight from `Pending` or `Open` to `Completed`" rule is still there | —    | HP-07 |        |       |
| SKILL-02 | Read the writer table's rows                                                 | `Accepted` and `Accepted Customer` — `23-pr-and-review` Step 5; `Closed` — `24-release` Step 5; `Rejected` — the review record's transition surface; `In Progress` — the board-side sync only; `Rejected Customer` — no writer in this repository. Sprint side: `Planned` — the template copy; `Done` — this skill; `In Progress` — writer-less                        | —    | —     |        |       |

### Routes

Each route is opened in place and read past the arrow — `doc-references.sh` tests only the path
before it.

| ID       | Action                                                                                                                                                         | Expected outcome                                                                                                                                             | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| ROUTE-01 | Follow the skill's two routes                                                                                                                                  | One lands on `STORIES.md` → _Story statuses_, one on `SPRINTS.md` → _Sprint statuses_; each target states the set it names                                   | —    | HP-06 |        |       |
| ROUTE-02 | Open the three repointed routes in `02-story-creation/STEPS.md`, `23-pr-and-review/STEPS.md` and `24-release/STEPS.md`, under `project-management/workflows/`  | Each cites `project-management/docs/planning/STORIES.md` → _Story statuses_, `statuses` lower-case, and its target states the eleven                         | —    | HP-06 |        |       |
| ROUTE-03 | For every route in this section, compare the heading it names with the target's heading, character for character                                               | Every one matches. A mistyped or moved heading fails here and is repaired — the citation gate passing it proves only the path                                | —    | ES-09 |        |       |
| ROUTE-04 | Count the sprint ownership comments — the comment beneath `**Status:** Planned` in `SPRINT-00-TEMPLATE.md` and in every live sprint record — and open each     | The count is taken now, not inherited. Each routes to `SPRINTS.md` → _Sprint statuses_, and the live sprint records carry no other edit from this story      | —    | HP-06 |        |       |
| ROUTE-05 | Open the `.copier/README.md` lines found by quoted text beneath the "ClickUp story sync — client-facing exports" heading                                       | They route to `STORIES.md` and attribute no value to ClickUp; the heading itself is unchanged                                                                | —    | HP-06 |        |       |
| ROUTE-06 | Open `../../17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` at its header `Status` pick-list, its status-definition comment and its Dependencies `Status` cell | The comment and the cell route to `STORIES.md` → _Story statuses_, the cell with no board attribution; the header pick-list is unchanged, the field's legend | —    | HP-06 |        |       |
| ROUTE-07 | Open `../../16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md` → _Story Plans — the code master_, the `Status` column header                                       | The legend is a route to `STORIES.md` → _Story statuses_                                                                                                     | —    | HP-06 |        |       |
| ROUTE-08 | Follow the pointer in `STORIES.md` → _Story statuses_                                                                                                          | It lands on the skill's writer declaration itself                                                                                                            | —    | HP-06 |        |       |
| ROUTE-09 | Open `../../19-REVIEWS/REVIEW-US000-TEMPLATE.md` at its citation of `PLANNING-GUIDE.md`                                                                        | Unchanged — it names no section and resolves in one hop                                                                                                      | —    | —     |        |       |

### Checklists

| ID           | Action                                                               | Expected outcome                                                                                                                                            | Flow | QA  | Result | Notes |
| ------------ | -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| CHECKLIST-01 | Open `project-management/workflows/23-pr-and-review/CHECKLIST.md`    | A box for the `In Review` write its Step 3 orders, and one for the `Completed` / `Accepted` write its Step 5 orders                                         | —    | —   |        |       |
| CHECKLIST-02 | Open `project-management/workflows/24-release/CHECKLIST.md`          | A box for the `Closed` write its Step 5 orders                                                                                                              | —    | —   |        |       |
| CHECKLIST-03 | Read both workflows' `STEPS.md` and `CHECKLIST.md` against the skill | No shipped instruction contradicts the skill, and the three ordering steps still order what they ordered. Recorded as a read-across, never as gate-verified | —    | —   |        |       |

### Shipped templates

| ID          | Action                                                                                       | Expected outcome                                                                                                                                                                                                                                                            | Flow | QA  | Result | Notes |
| ----------- | -------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| TEMPLATE-01 | Open `../../03-SPRINTS/SPRINT-00-TEMPLATE.md` → _Definition of Done_                         | The row that read "marked **Done**" reads `Completed`; the row "Sprint `**Status:**` set to `Done`" stands where the project-board clause stood                                                                                                                             | —    | —   |        |       |
| TEMPLATE-02 | Open `../../16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md` → _Sprint Definition of Done_     | The "Sprint closed on the board" clause is gone; the sprint record's `**Status:**` set to `Done` stands in its place                                                                                                                                                        | —    | —   |        |       |
| TEMPLATE-03 | Open `../../16-SPRINT-PLANS/01-SPRINT-PLAN-01.md` → _Sprint Definition of Done_              | Its board clause is still standing — left to that sprint's own close                                                                                                                                                                                                        | —    | —   |        |       |
| TEMPLATE-04 | Open `../../17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` → the status propagation section | The H2 and its comment read board-neutrally, the board sync a clickup-only consumer; the table's rows are neither removed nor renumbered; the ClickUp export row and the regenerate block carry the bold clickup-only marker; the example transition survives as an example | —    | —   |        |       |
| TEMPLATE-05 | In the same template, read the Definition of Done line on status propagation                 | It names the final **canonical** value, not the final ClickUp value, and its export-regeneration clause is marked clickup-only                                                                                                                                              | —    | —   |        |       |

### Generated without ClickUp

| ID       | Action                                                                                                                                                                                                          | Expected outcome                                                                                                                                                                                    | Flow | QA    | Result | Notes |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| TRACE-01 | Re-resolve `copier.yml`'s `INCLUDE_CLICKUP: false` exclusion list by its quoted text, then, as a cold reader, trace `STORIES.md` and `.copier/README.md` as a project generated without ClickUp would hold them | The eleven values, the per-register rule and — through the pointer — the writer of each value are all reached; no value is attributed to a board; no instruction on the path names a removed script | —    | HP-08 |        |       |

### Source fields and mirror cells

| ID        | Action                                                                                                                                                  | Expected outcome                                                                                                                                                                                                                                                        | Flow | QA    | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SOURCE-01 | Take the after-list of every source `**Status:**` field — stories, sprint records, story plans — and set it beside the captured list                    | Every field but US007's own holds its captured value. The search, its population and its exclusions — the three registers, the counted fields, the sibling registers and `pm-tool-sync` — are stated with the figures, so zero is a measurement with a scope            | —    | HP-09 |        |       |
| SOURCE-02 | Read US007's own field on that list                                                                                                                     | It lies on the trajectory `Open` → `In Review` → `Completed`; `In Review` between the PR being raised and the merge is predicted, not a regression                                                                                                                      | —    | EC-06 |        |       |
| SOURCE-03 | Open every former `Not started` cell under _Story Plans — the code master_ in the live sprint plans, counted at capture, beside the plan each row names | Each reads the value in its plan's `\| Status \|` header row, backticked consistently, the choice recorded; they are the only live cells that changed; no story plan's own `Status` field was edited; `../../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md`'s rows are unchanged | —    | HP-09 |        |       |

### Casing

| ID        | Action                                                                                                                                                                                                                                                                           | Expected outcome                                                                                                                                   | Flow | QA    | Result | Notes |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CASING-01 | Run `git grep -nw "In progress" -- '*.md' '*.sh' '*.yml' ':!handoffs/' ':!project-management/src/02-STORIES/US007.md' ':!project-management/src/11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md' ':!project-management/src/18-TESTS/MANUAL/US007-MANUAL-TESTING.md'` | Zero lines, and the command with its pathspecs is recorded verbatim in _Recorded during the build_                                                 | —    | HP-10 |        |       |
| CASING-02 | Where CASING-01 returns any line, read each                                                                                                                                                                                                                                      | Each is recorded with its file and its disposition — a site the story missed or a concurrent addition — and the criterion is not ticked until zero | —    | ES-10 |        |       |
| CASING-03 | Open `US000-MANUAL-TESTING.md` in this folder at its header `Status` legend                                                                                                                                                                                                      | `In Progress` where the lower-case form stood; no other word of the line changed                                                                   | —    | —     |        |       |

### Named-site inventory

| ID           | Action                                                                                                                                                | Expected outcome                                                                                                                                                                                                                                                          | Flow | QA    | Result | Notes |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| INVENTORY-01 | Build the inventory of every site that states a status value, with a role beside each, into _Recorded during the build_, and read its definition rows | Exactly one definition row per set — `STORIES.md` for the eleven, `SPRINTS.md`'s section for the three — and every other site carries legend, writer declaration, example, order, route, mapping or excluded; every `In Progress` and `Rejected Customer` site has a role | —    | HP-11 |        |       |

### The map

| ID     | Action                                                                                                                                      | Expected outcome                                                                                                                                                                                                | Flow | QA  | Result | Notes |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| MAP-01 | Open `../../01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` at the clause, found by quoted text, that said the skill "owns both" vocabularies      | Corrected to the fact — one story set owned by `STORIES.md`, of which the skill writes five; one sprint set owned by `SPRINTS.md`, of which it writes one — and recorded as a stated exception, with its reason | —    | —   |        |       |
| MAP-02 | In the same map, open the `SPRINT-00-TEMPLATE.md` status assertion, the struck-through graduated entry and the "Fog of war, not a node" row | All three unchanged; the one edit and the three non-edits recorded with their reasons                                                                                                                           | —    | —   |        |       |

### Divergences recorded

| ID         | Action                                                                                                                                                        | Expected outcome                                                                                                                          | Flow | QA  | Result | Notes |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| DIVERGE-01 | Compare the `\| Status \|` row of `../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` with `**Status:**` in `../../02-STORIES/US005.md` | Where they still differ, the divergence is recorded as pre-existing, unexplained by any artefact, and routed to whoever owns US005's plan | —    | —   |        |       |

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
- [ ] "../AUTOMATED/US007-TEST-STATUS.md" exists and its Section 3 says there is no suite (no code path) — so no manual row has a test to cross-check against

---

## Cross-references

- `../../02-STORIES/US007.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the implementation plan this guide was authored beside
- "../AUTOMATED/US007-TEST-STATUS.md" — the paired automated record, written at `22`; it records that the story has no suite
- `../../11-QA/PLANNING/QA-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — where the `QA` column's scenario IDs are defined, and Section 6, the capture-and-diff procedure the gate rows run
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` — the baseline-diff regime the gate rows run under; superseded 30/09/2026 by `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`, which restates it unchanged and names this file as where the baseline is recorded
- `code/docs/GATE-REPORTING.md` — why a gate that could not decide is never reported as a pass
