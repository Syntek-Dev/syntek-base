# US009 — Manual Testing Guide

_The manual testing guide for US009 — the walks a tester follows step by step in a scratch clone, and, once walked, whether each step passed. Authored from the specs at `17-story-plans` Step 7.2 as a backfill on 30/09/2026; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 30/09/2026 · **Story**: US009 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US009.md` — the git hooks arm on purpose at install, and the README claim that they already do becomes true
- **Story plan:** `../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the code master this guide was authored beside
- **Branch:** `us009/hook-arming`
- **Surface:** CLI — `bash install.sh`, the extracted hook step and `git` in a scratch clone; each outcome is what the terminal prints or what the clone then holds. No stack, no rendered page
- **Authored from:** `../../02-STORIES/US009.md` (Acceptance Criteria and its eight scenarios, Security Acceptance Criteria, QA Acceptance Criteria — Automated and — Manual, Tasks, Verification Checks, Definition of Done); `../../11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md` (Sections 1 to 8); `../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` (Approach P0 to P5, the fixtures, PA-01 and PA-02, Quality Gates, Testing, Documentation Write-Ups, Measured divergences, Sprint Verification Checklist, Definition of Done); `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` (Section 7); `../../15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` (Decision); `../../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` (the lane, Phase 4, Sprint Verification Checklist); `../../03-SPRINTS/SPRINT-05.md` (QA Acceptance Criteria — Manual, QA Tasks — Manual). No `04`–`09`, `12`–`14` artefact exists for this story: those flags read `N/A`. Never code.

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

- **Stack:** none — this story runs no container (plan → _Quality Gates, Scripts & Local↔Docker
  Alignment_)
- **Base URL:** none — no rendered surface
- **Seed data:** none. The secrets `install.sh` generates land in the scratch clone's `.env.dev`
  and are never copied into this file
- **Accounts / roles:** a user who can `sudo` — `install.sh` appends to `/etc/hosts` with it and
  runs `sudo rm -rf` from the clone's root (QA plan Section 6). No role boundary is under test
- **The scratch clone:** a `git clone` of this repository at the story branch, into a scratch
  directory outside this working tree. A fresh clone has no `.git/hooks/pre-commit`, which is the
  starting state INSTALL-01 needs. **Never run `install.sh` against this working tree**, and never
  clear this working tree's own hook (plan P0). A row that stages a state takes a fresh clone, or
  restores the clone before the next row
- **The extracted step:** the story moves the arming logic into
  "code/src/scripts/development/install-hooks.sh" (plan P1), which `install.sh` calls as its last
  Phase 1 step. Rows that run _the step on its own_ run that script from the clone's root
- **Never plant a file named `log` or `Removed.`** at a clone's root to probe
  `install-frontend.sh`'s `sudo rm -rf` defect: it would be deleted as root (ST08; QA plan
  Section 5)
- **The tester:** someone other than the author of the story's edits
- **Out of scope:**
  - **HP-08, ES-06, EC-09, EC-10, EC-11, EC-12 and EC-14** — the `postinstall` notice's printing
    case, its failure mode, its silences, its worktree case and a checkout whose hook is not
    lefthook's. Each needs a `pnpm install`, and one typed at a terminal is what
    `.claude/CLAUDE.md` Section 6 bars. QA plan Section 6 homes them in the probe script,
    "code/src/scripts/tests/hook-arming.sh", whose results are the automated record's. EC-13
    needs none and is walked as INSTALL-02
  - **PA-01** — the notice on `gh pr create`, which raises a real pull request; the probe carries
    it (plan → _P4_)
  - **PA-02** — the notice on a CI runner; the probe carries it
  - **Permission and access** — section dropped: no endpoint, screen or protected action (QA plan
    Section 2). PA-03, the `postinstall` body's own boundary, is read in the diff as SUPPLY-03
  - **Accessibility** — section dropped: the story's whole output is terminal text (QA plan
    Section 3). The one property that section names — no output line relies on colour alone — is
    INSTALL-06
  - **Responsive behaviour** — section dropped: no rendered screen (QA plan Section 4)
  - **The implementation record's readings** — the sixteen-invocation `pnpm install` sweep re-run
    at close, and what this working tree's hook held at P0 (plan → _Documentation Write-Ups_)
  - **The automated criteria** — the probes, the generation grep and `lint.sh` / `check.sh` are the
    automated record's; the generation job's result is read once, as CI-01
- **Open questions** — each awaits the developer's answer, and every row it holds carries
  `Awaiting answer` in `Notes` until it is answered and the row rewritten from it:
  1. **A `lefthook install` that cannot complete — FAIL-01 to FAIL-03.** `ES-01` to `ES-03` name
     the state and not how to make it. What makes `lefthook install` fail in a fresh clone while
     steps 5 to 8 still run first — and in a way the clone survives?
  2. **A hook last written by `code-review-graph install` — STAGE-02.** `EC-05` names the state
     only. Is it staged by running `code-review-graph install` in the scratch clone, or by writing
     that tool's hook body by hand — and from which source?
  3. **A host-global `lefthook` of a different major — STAGE-03.** The QA plan calls `EC-02`
     "cheap to stage" and does not say how. Which major, obtained from where, and put on `PATH`
     how — without a raw package-manager invocation?

---

## Recorded during the build

The output the rows below ask to be kept. No spec asks for a capture before the first edit, so
every slot here is a walk-time one: the walker pastes each as a fenced block beneath this table,
with its date, as the row that produces it runs. Nothing from a clone's `.env.dev` is pasted, and
nothing here carries a `Result`.

| Evidence                                                                | Read by                |
| ----------------------------------------------------------------------- | ---------------------- |
| The clean-clone `install.sh` output, and the commit's pre-commit legs   | INSTALL-01, INSTALL-04 |
| How each staged state was made — FAIL-01, FAIL-04, STAGE-01 to STAGE-03 | FAIL-01 to STAGE-03    |
| The failing run's output and its exit code                              | FAIL-01, FAIL-02       |
| The two setup claims, re-read                                           | CLAIM-01, CLAIM-03     |

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### Clean-clone install

| ID         | Action                                                                                                     | Expected outcome                                                                                                                                                                       | Flow | QA    | Result | Notes |
| ---------- | ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| INSTALL-01 | In the fresh scratch clone, run `bash install.sh`                                                          | The **last** step of Phase 1 is the git-hooks step, run after every other Phase 1 step; it runs `lefthook install`, prints its own `ok` line and says it wrote `.git/hooks/pre-commit` | —    | HP-01 |        |       |
| INSTALL-02 | Read the same run's output for the JavaScript dependencies step                                            | No `postinstall` notice prints there — the hooks are armed later in the same run                                                                                                       | —    | EC-13 |        |       |
| INSTALL-03 | Open the clone's `.git/hooks/pre-commit`                                                                   | It exists and is lefthook's generated hook — not another tool's, and not a stub                                                                                                        | —    | HP-02 |        |       |
| INSTALL-04 | Make a throwaway change in the clone and `git commit` it                                                   | The `lefthook.yml` pre-commit legs run, observably; their output is recorded in _Recorded during the build_                                                                            | —    | HP-03 |        |       |
| INSTALL-05 | List the clone's state with `git status --porcelain --ignored`, run the step on its own, and list it again | No path outside `.git/hooks/` appears or changes                                                                                                                                       | —    | —     |        |       |
| INSTALL-06 | Read the git-hooks step's output lines as if colour were absent                                            | Each carries a glyph and a word, as `install.sh`'s other `ok`, `warn` and `err` lines do                                                                                               | —    | —     |        |       |

### Re-running the install

| ID       | Action                                                                                             | Expected outcome                                                                         | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| RERUN-01 | Copy the clone's `.git/hooks/pre-commit` aside, then run `bash install.sh` again in the same clone | The git-hooks step completes; no error anywhere in the run; the hook is still lefthook's | —    | HP-04 |        |       |
| RERUN-02 | Compare the hook with the copy taken in RERUN-01, byte for byte (`cmp`)                            | Identical — no duplication and no appended second block                                  | —    | EC-06 |        |       |

### The script's flags

| ID       | Action                                    | Expected outcome                                                                                                                                                                       | Flow | QA    | Result | Notes |
| -------- | ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| FLAGS-01 | Run `bash install.sh --help` in the clone | Phase 1 lists steps 1 to 9, the git-hooks step ninth and last; Phase 2 lists steps 10 and 11; the printed sequence is contiguous. The script's own Phase 2 step headers read 10 and 11 | —    | EC-08 |        |       |
| FLAGS-02 | Run `bash install.sh --spec` in the clone | It exits after regenerating the machine spec, and the git-hooks step does not run                                                                                                      | —    | EC-07 |        |       |

### A failing hook install

| ID      | Action                                                                                          | Expected outcome                                                                                                                                             | Flow | QA    | Result | Notes                             |
| ------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | --------------------------------- |
| FAIL-01 | In a fresh scratch clone where `lefthook install` cannot complete, run `bash install.sh`        | The failure is reported in the house `err` idiom, naming `lefthook install`                                                                                  | —    | ES-01 |        | Awaiting answer — open question 1 |
| FAIL-02 | Read the exit code of that run (`echo $?`)                                                      | `2` — the "install failed" code the script's header declares — never swallowed as a warning                                                                  | —    | ES-02 |        | Awaiting answer — open question 1 |
| FAIL-03 | Inspect the clone after that run                                                                | Steps 5 to 8 had already run: the `.env.*` files, the generated dev secrets, the executable bits on the project scripts and the machine spec are all present | —    | ES-03 |        | Awaiting answer — open question 1 |
| FAIL-04 | With `lefthook` absent from the clone's `node_modules` and from `PATH`, run the step on its own | It fails with a message naming the missing binary — not a bare "command not found"                                                                           | —    | ES-04 |        |                                   |

### Staged hook states

| ID       | Action                                                                                                                        | Expected outcome                                                                               | Flow | QA    | Result | Notes                             |
| -------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| STAGE-01 | Write a hand-written hook into the clone's `.git/hooks/pre-commit`, then run `bash install.sh`                                | The step's output tells the developer the existing hook was replaced — it is not lost silently | —    | EC-03 |        |                                   |
| STAGE-02 | With the clone's `.git/hooks/pre-commit` last written by `code-review-graph install`, run `bash install.sh`                   | lefthook reclaims the hook, and the reclaim is reported                                        | —    | EC-05 |        | Awaiting answer — open question 2 |
| STAGE-03 | With a host-global `lefthook` of a different major on `PATH` and the project's own in `node_modules`, run the step on its own | The project's own binary is the one used                                                       | —    | EC-02 |        | Awaiting answer — open question 3 |

### Checkouts without an ordinary `.git` directory

| ID      | Action                                                                                                   | Expected outcome                                                                                                                                               | Flow | QA    | Result | Notes |
| ------- | -------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| REPO-01 | Export a copy of the clone without `.git`, and run `bash install.sh` there                               | The step reports that hook installation was skipped because there is no git repository; the install continues; the overall exit code is unaffected by the skip | —    | ES-05 |        |       |
| REPO-02 | From the clone, `git worktree add` a checkout — where `.git` is a file — and run `bash install.sh` in it | The guard resolves the real git directory and the step runs and reports arming rather than a skip; a throwaway commit in the worktree runs the lefthook legs   | —    | EC-01 |        |       |
| REPO-03 | Copy the tree without `.git`, `git init` it fresh with no commits, and run the step on its own           | `lefthook install` succeeds against the unborn HEAD                                                                                                            | —    | EC-04 |        |       |

### The supply-chain boundary

| ID        | Action                                                                                                                                                       | Expected outcome                                                                                                                                                                                  | Flow | QA    | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SUPPLY-01 | Read `code/src/scripts/development/install-frontend.sh` at each of its three `pnpm install` lines, one line at a time (`:67`, `:84` and `:93` on 30/09/2026) | `--ignore-scripts` is on each of the three lines. Recorded as three invocations of the repository's sixteen — not a statement of its lifecycle-script posture                                     | —    | HP-05 |        |       |
| SUPPLY-02 | Read the `scripts` of `package.json`                                                                                                                         | No `prepare` script, and no lifecycle script writes anywhere under `.git/`                                                                                                                        | —    | HP-05 |        |       |
| SUPPLY-03 | Read the `postinstall` body in the diff                                                                                                                      | It prints the not-armed notice, naming `bash install.sh`, and does nothing else — no file write, no network call, no credential read. Which output stream carries the notice is not asserted here | —    | PA-03 |        |       |
| SUPPLY-04 | Read the three `--ignore-scripts` assertions in the probe script, "code/src/scripts/tests/hook-arming.sh"                                                    | Each names its own single line and asserts the flag on that line only; none treats the lines from `:79` to `:93` as one block it has validated                                                    | —    | —     |        |       |
| SUPPLY-05 | Diff `code/src/scripts/development/install-frontend.sh` against the pre-edit commit                                                                          | No change                                                                                                                                                                                         | —    | —     |        |       |

### The setup claims

| ID       | Action                                                                                                                                                                                                            | Expected outcome                                                                          | Flow | QA    | Result | Notes |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CLAIM-01 | Find, by its quoted text, the `.copier/README.md` sentence that `install.sh` "runs `lefthook install`, which registers the pre-commit hooks" (`:442` on 30/09/2026), and read it against the changed `install.sh` | It describes what the script does; the re-read is recorded in _Recorded during the build_ | —    | HP-06 |        |       |
| CLAIM-02 | Diff `.copier/README.md` against the pre-edit commit                                                                                                                                                              | The line holding that sentence is unchanged                                               | —    | HP-06 |        |       |
| CLAIM-03 | Read "Hooks are installed by `bash install.sh`." in `how-to/src/CONTRIBUTING.md` against the changed `install.sh`, then diff that file against the pre-edit commit                                                | True, and the file is unmodified                                                          | —    | —     |        |       |

### Generation job

| ID    | Action                                                  | Expected outcome                                                                                                                   | Flow | QA    | Result | Notes |
| ----- | ------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CI-01 | Open the pull request's `[3/4] Template Generation` job | Green on both answer sets — `INCLUDE_MOBILE` false and true — and its grep finds the git-hooks step in each generated `install.sh` | —    | HP-07 |        |       |

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

| Field        | Value                                   |
| ------------ | --------------------------------------- |
| **Tester**   |                                         |
| **Date**     |                                         |
| **Browsers** | N/A — CLI surface; no browser is opened |
| **Outcome**  |                                         |
| **Blockers** |                                         |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against `../AUTOMATED/US009-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US009.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US009-TEST-STATUS.md` — the paired automated-test record; it does not exist until `22-implementation-documentation` writes it
- `../../11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` — the fourteen security constraints the supply-chain rows read against
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — why a scenario this guide cannot walk is named out of scope rather than reported as passed
