# US012 — Manual Testing Guide

_The manual testing guide for US012 — the reads a tester follows step by step over the story's CI runs and its one changed script, and, once walked, whether each step passed. Authored from the specs at `17-story-plans` Step 7.2 on 03/10/2026, before any code; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 03/10/2026 · **Story**: US012 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US012.md` — a seeded file that never lands is reported, and the gate's header claim becomes true
- **Story plan:** `../../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` — the code master this guide was authored beside
- **Branch:** `us012/seed-presence-gate`
- **Surface:** Gate — every row reads a run of CI's `[3/4] Template Generation` job; reads or diffs `.github/scripts/shipped-artefacts.sh`, or runs that script's `--help`; reads the job's two steps in `.github/workflows/audit-template.yml`; lists the files the story's commits change; or reads the story's slice row in `../../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md`. Each outcome is what the log, the file, the list or the command shows. No stack, no rendered page
- **Authored from:** `../../02-STORIES/US012.md` (Acceptance Criteria and its eight scenarios with the negation comment beneath them, QA Acceptance Criteria — Automated, Tasks, Verification Checks, Definition of Done, Dependencies); `../../11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md` (Sections 1 to 8); `../../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` (Approach P0 to P3, the landing order with US010, What the gate can and cannot see, Key Decisions, Testing, Quality Gates, Scripts & Local↔Docker Alignment, Status Propagation); `../../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` (the lane, Decisions binding this sprint, Gate honesty, Sprint Verification Checklist); `../../03-SPRINTS/SPRINT-07.md` (QA Acceptance Criteria — Manual, QA Tasks — Automated and — Manual); `../../02-STORIES/US010.md` (Dependencies — the comment above `SEEDED` both stories write); `../../01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` (the `S-02` Slices row and Gate to stories); `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` (Decision — read to confirm no baseline is owed). The story records no ADR of its own and has no _QA Acceptance Criteria — Manual_ section, so the bar is the QA plan's scenarios and the review-time reads the story already requires. No `04` to `10` or `12` to `14` artefact exists for this story: those flags read `N/A`. Never code.

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

- **Stack:** none — the story runs no container, and every generated tree is made by CI (story plan
  -> _Quality Gates, Scripts & Local↔Docker Alignment_)
- **Base URL:** none — no rendered surface
- **Working tree:** the `us012/seed-presence-gate` branch checked out at its head, with no other
  change in the tree. **The pre-edit commit** is the parent of the red commit — the commit that adds
  the probe alone. Its `.github/` is the branch's cut point's, or its base's after a rebase: the one
  commit the story plan puts before the red commit moves the story's status and touches nothing
  outside `project-management/` (story plan -> _Status Propagation_)
- **The three runs:** the red, green and branch-head runs of `[3/4] Template Generation` on that
  branch, by the run IDs recorded in "../AUTOMATED/US012-TEST-STATUS.md", which `22` writes before
  this walk. The red run belongs to the commit that adds the probe alone, the green run to the
  commit that adds the loop, and the branch-head run to the last commit before the pull request,
  after the closing guidance, header and comments (story plan -> _Approach_, P1 to P3). The
  self-test is the job's step at `.github/workflows/audit-template.yml:225`, and the full run its
  step at `:228`
- **Seed data:** none. No fixture, no credential, no personal data
- **Accounts / roles:** read access to the repository's Actions runs. No role boundary is under test
- **Never make a generated tree** to walk a row: no project script generates one, and a raw
  `uvx copier copy` is what `.claude/CLAUDE.md` Section 6 bans. No row below needs one
- **Out of scope:**
  - **ES-01 and ES-03's state — a generated tree lacking a seeded file.** It cannot be made
    lawfully, and none of the story's CI runs makes one: the new probe deletes the seed inside the
    self-test's own copy and prints only its pass line. The finding ES-01 would print is read in the
    source (FINDING-01, FINDING-02) and proved in CI by the probe's single finding (GREEN-01); the
    refusal ES-03 reads is read as unchanged (LOOP-05)
  - **ES-02's state** — the same tree, run in full. Its Then, the closing guidance, is read in the
    source (FINDING-03), because no run of this story prints it
  - **EC-01, EC-03 and EC-04** — a three-entry `SEEDED` with its middle entry absent, a retargeted
    `mv`, and a seed that lands as a directory. No generated tree carries any of these states
    lawfully, and the hand-built fixture that does is indicative only and never the proof of record
    (QA plan Section 6), so no walk of it could mark the shipped change `Pass` or `Fail`; the QA
    plan recorded each as a fixture reading (Section 2, on its Section 7 fixture), and the story
    plan's Key Decision 7 keeps them off this guide. EC-01's any-position claim is LOOP-01's read,
    and the last-entry probe's in CI once `SEEDED` holds more than one entry
  - **EC-07's positive half** — the bash string test of the probe's substring against the named-file
    message, the story's fourth automated criterion, recorded in the automated record. Its negative
    half is FINDING-02
  - **EC-08** — an emptied `SEEDED`, which aborts the probe's subscript under `set -u`. The QA plan
    records it as a known limitation, not fixed: retiring the last seed removes the probe in the same
    change, so the state never exists in a script the story ships, and a walk of it would test a
    script nobody ships (story plan, Key Decision 7)
  - **The automated criteria** — the run IDs and probe lines, the string test, the parse check and
    the ShellCheck reading are the automated record's: the first by the story (_QA Acceptance
    Criteria — Automated_, its second criterion), the rest by the story plan (_Testing_), the story asking only that the string test be shown and the ShellCheck result recorded; the parse check is the story plan's own addition (P3). The rows below read the runs; they do not re-record them
  - **The map's _Register claimed_ `S-02` row** — retired by `22` against the shipped change, a write
    rather than a walk. The Slices row is MAP-01
  - **Permission and access** — section dropped: the QA plan's `PA` table reads N/A — no endpoint,
    view or protected action
  - **Accessibility** — section dropped: the QA plan's Section 3 reads N/A, the output being terminal
    text. The one property it names — colour is never the only signal — is RED-03
  - **Responsive behaviour** — section dropped: no rendered screen (QA plan Section 4)
  - **User flow** — the `User Flow` flag reads N/A, so every `Flow` cell is `—` and
    `18-consolidate-design-work` has none to set
- **Open questions:** None.

---

## Recorded during the build

None required. No spec asks this file to hold a capture:

- **The run IDs and the red run's probe line** are homed in the automated record by the story
  (_QA Acceptance Criteria — Automated_, its second criterion, the green run's beside them) and by
  the QA plan (AC-GAP-4). **The string test, the parse check and the ShellCheck reading** are homed
  there by the story plan (_Testing_), the story asking only that the string test be shown and the ShellCheck result recorded; the parse check is the story plan's own addition (P3). `22` writes
  that record before this walk, and the rows below read it there.
- **No citation baseline is owed.**
  `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md` puts a
  baseline here for a story's citation criterion, and this story has none — its criteria run no
  citation gate (`../../16-SPRINT-PLANS/07-SPRINT-PLAN-07.md` -> _Decisions binding this sprint_).
- **The build's starting state** — how many entries `SEEDED` held, and whether US010 had landed — is
  re-readable from the pre-edit commit at any time, so it is read at the walk rather than captured.

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The red run

| ID     | Action                                                                | Expected outcome                                                                                                                                                                                       | Flow | QA    | Result | Notes |
| ------ | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| RED-01 | Diff the red commit against the pre-edit commit                       | The commit changes `.github/scripts/shipped-artefacts.sh` alone, and in it adds the new `--self-test` probe and nothing else — check 4, its finding, the closing guidance and the header are untouched | —    | —     |        |       |
| RED-02 | Open the red run and read the log of its self-test step               | The new probe's own line fails reporting zero findings — "produced 0 finding(s): (none);" — while the other five probe lines pass                                                                      | —    | ES-04 |        |       |
| RED-03 | Read that failing probe line as if colour were absent                 | It carries the cross glyph and the words "produced 0 finding(s)" — colour is not the only signal                                                                                                       | —    | —     |        |       |
| RED-04 | Read the same step's result, and search its log for `mv: cannot stat` | The step fails with exit 1, and no `mv: cannot stat` line appears — the run reached the probe rather than aborting on a missing seed, so the exit 1 is the probe's and not the wrong-reason red        | —    | ES-05 |        |       |

### The green run

| ID       | Action                                                                                                                     | Expected outcome                                                                                                                                                                                                                    | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| GREEN-01 | Open the green run and read the log of its self-test step                                                                  | The step passes; the new probe's line passes; the success line counts **6 probes** where it counted 5 before the story — a 5 means the probe was never added, a 7 that something else was                                           | —    | HP-02 |        |       |
| GREEN-02 | In the same log, read the line of the check-5 probe, the probe that runs straight after the new one                        | It passes, seeing exactly its own one finding — the moved seed was restored, so no later probe inherits the deletion                                                                                                                | —    | HP-04 |        |       |
| GREEN-03 | In the same log, read check 3's feature-map leak probe line                                                                | It passes — still exactly one finding with the seeded map beside the planted one                                                                                                                                                    | —    | HP-05 |        |       |
| GREEN-04 | In the same run, read the log of the full-run step                                                                         | For every render path the template offers (today: `INCLUDE_MOBILE` false and true): no check-4 finding for any seeded file, and check 3 admits every seed rather than reporting it as leaked. The step exits 0                      | —    | HP-01 |        |       |
| GREEN-05 | Read the commands of the self-test step and the full-run step in `.github/workflows/audit-template.yml`                    | The self-test names the `INCLUDE_MOBILE` false tree alone; the full run names every generated tree (today: the false and true trees). The six probes are proof over one tree, and only the full run is proof over every render path | —    | EC-09 |        |       |
| GREEN-06 | Diff the new probe between the red commit and the green commit                                                             | No change — the loop turned the same probe green                                                                                                                                                                                    | —    | —     |        |       |
| GREEN-07 | Open the branch-head run, the last commit before the pull request, and read its self-test step and its full-run step apart | Two claims, read separately: the self-test passes at **6 probes** over the one tree it reads, and the full run exits 0 over every render path the template offers (today: `INCLUDE_MOBILE` true and false)                          | —    | —     |        |       |

### The seed finding and the closing guidance

| ID         | Action                                                                                                                                                                                                 | Expected outcome                                                                                                                                                                                                  | Flow | QA    | Result | Notes |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| FINDING-01 | At the branch head, read the message check 4's new loop gives for a seeded file that did not land                                                                                                      | The seeded path first; directly after it, that the path was seeded and did not land; then a pointer to its `mv .copier/...` line in the copy-gated `_tasks` entry of `copier.yml`                                 | —    | HP-03 |        |       |
| FINDING-02 | Read the same message for the repair it advises                                                                                                                                                        | No advice to add a `!` negation in `copier.yml` or to edit the allowlist, and no `.copier/` source path computed from the entry — the pointer is to the `mv` line, generically                                    | —    | EC-07 |        |       |
| FINDING-03 | Read the closing guidance the full run prints beneath its findings — the paragraph that read "Fix the allowlist there" before the story (`:340-343` on 03/10/2026) — and the condition it prints under | It does not direct a seed finding to the `copier.yml` allowlist: either it names the seed's repair beside the allowlist's, or the allowlist paragraph prints only when an allowlist finding is among the findings | —    | ES-02 |        |       |

### The loop and the probe

| ID      | Action                                                                                                              | Expected outcome                                                                                                                                                                                                                                                                           | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| LOOP-01 | Read the new loop in check 4                                                                                        | It iterates `"${SEEDED[@]}"` — every entry — never the unsubscripted `"${SEEDED}"`, which reads the first alone; it asserts each entry is a file under the generated `project-management/src/`                                                                                             | —    | EC-02 |        |       |
| LOOP-02 | Read where the loop sits                                                                                            | Beside the `NAMED_SHIPPED` loop, inside check 3's `else` — so a generated tree with no `project-management/src/` at all yields one finding, not one per seed                                                                                                                               | —    | EC-05 |        |       |
| LOOP-03 | Compare the entries of `SEEDED` with those of `NAMED_SHIPPED`                                                       | No path appears in both arrays                                                                                                                                                                                                                                                             | —    | EC-06 |        |       |
| LOOP-04 | Read the new probe in the self-test                                                                                 | It follows the check-4 named-file probe; it moves the last entry of `SEEDED`, addressed as `${SEEDED[${#SEEDED[@]}-1]}` — never a literal path, never `${SEEDED[-1]}`; it matches a substring running from that path into the seed's wording; it moves the file back before the next probe | —    | HP-03 |        |       |
| LOOP-05 | Diff the self-test's baseline check — the clean-tree check that runs before any probe — against the pre-edit commit | Unchanged: a seed finding in the real tree takes the same refusal as any other finding — the finding printed, no probe run, exit 2                                                                                                                                                         | —    | ES-03 |        |       |
| LOOP-06 | Diff the entries of `SEEDED` against the pre-edit commit                                                            | No entry added, removed or reordered by this story — growing the array is US010's                                                                                                                                                                                                          | —    | —     |        |       |
| LOOP-07 | List the files this story's commits change outside `project-management/`                                            | `.github/scripts/shipped-artefacts.sh` alone — `.github/workflows/audit-template.yml` is not edited, the job already running the self-test and the full check                                                                                                                              | —    | —     |        |       |

### The header contract

| ID        | Action                                                                                              | Expected outcome                                                                                                                                                                                                                                                                                                    | Flow | QA    | Result | Notes |
| --------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| HEADER-01 | From the repository root at the branch head, run `bash .github/scripts/shipped-artefacts.sh --help` | It prints the script's usage; its `--self-test` line names the seeded-file deletion among the mutations, and its exit-code line names a seeded file that did not land under exit 1                                                                                                                                  | —    | HP-06 |        |       |
| HEADER-02 | Read the header's numbered list of checks                                                           | Check 4's entry names seeded files beside the named shipped files                                                                                                                                                                                                                                                   | —    | HP-06 |        |       |
| HEADER-03 | Read the paragraph beneath the list on the allowlist's two failure modes                            | It names a seed that did not land as a failure check 4 catches — a copy-gated move that did not happen, distinct from a tight allowlist                                                                                                                                                                             | —    | HP-06 |        |       |
| HEADER-04 | Read the header's `SELF-TEST` paragraph and its exit-code lines                                     | `SELF-TEST` names the seeded-file deletion among the mutations; exit 1 names a seeded file that did not land                                                                                                                                                                                                        | —    | HP-06 |        |       |
| HEADER-05 | Read the comment above check 4                                                                      | It no longer describes check 4's failures as dropped `!` negations alone — a seed that did not land is named                                                                                                                                                                                                        | —    | HP-06 |        |       |
| HEADER-06 | Read the comment above `SEEDED`                                                                     | It states the array is read twice — by check 3 as an allowlist, by check 4 for presence; that a seed which fails to land is repaired at its `.copier/` file or its `mv` line; and that an entry leaves `SEEDED` only when the seed is retired on purpose, with its `.copier/` file and its `mv` line, in one change | —    | HP-06 |        |       |
| HEADER-07 | Read the same comment against the pre-edit commit's                                                 | Extended, not contradicted: if US010's rewrite of the comment is in the pre-edit commit — at the cut, or in the base after a rebase — its account, the allowlist check 3 reads covering the seven index seeds, survives beside this story's                                                                         | —    | —     |        |       |
| HEADER-08 | Diff the header's "What it CANNOT check" paragraph against the pre-edit commit                      | Byte-identical — presence is asserted, content is not                                                                                                                                                                                                                                                               | —    | HP-06 |        |       |

### The map

| ID     | Action                                                                                 | Expected outcome                                                                                                                                  | Flow | QA  | Result | Notes |
| ------ | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| MAP-01 | Open `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` at its Slices table | The `S-02` row's Story cell names US012, and the Status line and the Gate to stories sentence record the cut of 21/09/2026 — verified, not re-cut | —    | —   |        |       |

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

| Field        | Value                                                                                  |
| ------------ | -------------------------------------------------------------------------------------- |
| **Tester**   |                                                                                        |
| **Date**     |                                                                                        |
| **Browsers** | N/A — Gate surface; no product page is rendered. The CI run pages are read, not tested |
| **Outcome**  |                                                                                        |
| **Blockers** |                                                                                        |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against "../AUTOMATED/US012-TEST-STATUS.md" — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US012.md` — the story under test. It has no _QA Acceptance Criteria — Manual_; the bar here is the QA plan's scenarios and the reads the story requires at review
- `../../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` — the implementation plan this guide was authored beside
- "../AUTOMATED/US012-TEST-STATUS.md" — the paired automated-test record, holding the run IDs these rows read; it does not exist until `22-implementation-documentation` writes it
- `../../11-QA/PLANNING/QA-PLAN-US012-SEED-PRESENCE-GATE.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../02-STORIES/US010.md` — Dependencies: the comment above `SEEDED` both stories write, which HEADER-07 reads
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — why a scenario this guide cannot walk is named out of scope rather than reported as passed
