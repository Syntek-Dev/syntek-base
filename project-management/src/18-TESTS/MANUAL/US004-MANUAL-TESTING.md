# US004 — Manual Testing Guide

_The manual testing guide for US004: the steps a tester follows against the citation gate, and — once walked — whether each step passed._

**Last Updated**: 09/10/2026 · **Story**: US004 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US004.md` — The citation gate stops depending on the git index, and the PM tree becomes checkable
- **Story plan:** `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the code master this guide was authored beside
- **Branch:** `us004/citation-gate-git-index`
- **Surface:** Gate — `code/src/scripts/audits/doc-references.sh`, run in a terminal. Each action is the command a person runs or the file they open; each outcome is what the gate prints, the exit code it returns, or what the file says.
- **Authored from:** `../../15-DECISIONS/ADR-US004-PATTERNED-REGISTRATION-PRESERVES-SHIPPED-TEMPLATES-09-10-2026.md` (approved remediation, 09/10/2026) · `../../02-STORIES/US004.md` · `../../11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` · `../../15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md` · `../../15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-02-09-2026.md` · `../../15-DECISIONS/ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL-08-09-2026.md` (`Proposed`) · `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` · `../../16-SPRINT-PLANS/03-SPRINT-PLAN-03.md` · `../../17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`. No stage-1 design, GDPR, security, SEO, API or logging artefact exists for this story — every one of those flags reads `N/A`. Never code.

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
- **Open questions — resolved 09/10/2026**, user-approved remediation:
  1. **Q1 — A/B file:** in a disposable clone, copy US003.md byte for byte from the recorded
     baseline commit to "project-management/src/02-STORIES/US998.md". Preserve those bytes for
     both detector versions; run untracked, then intent-to-add, then restore only that index entry
     with `git restore --staged -- project-management/src/02-STORIES/US998.md`. Confirm unchanged
     bytes and an untracked US998 after each A/B. Historical five-to-zero is not a threshold.
  2. **Q2 — carrier:** separate scratch "project-management/src/02-STORIES/US999.md", never
     edits to a real story. Its absent unregistered target is "project-management/src/02-STORIES/US997.md";
     its absent registered target is "project-management/src/18-TESTS/AUTOMATED/US997-TEST-STATUS.md".
     Each ordinary citation has its own line without naming-row wording. Verify absence first.
  3. **Q3 — HP-03:** the 30/09/2026 US997 automated-record answer stands.
  4. **Q4 — counts:** 16 to 38 is historical only. Compare current stock and arm-only scripts
     on one frozen tree with US999's missing US997 story planted; require that target's new
     dangling-path finding and no naming-pattern additions. Record every addition by identity.
- **Fixture isolation:** check US998 and US999 names are free before setup. Every mutation
  below happens in disposable clones, including temporary template removal. Move each US000
  target outside the clone root, retain its class row, run the case, then restore it and confirm
  the finding clears. Discard the clones after restoring index and targets; no real story is edited.
- **Template roles:** CITER-01/02 exercise citer policing; TARGET-01/02 separately exercise
  missing-target detection. EC-01's target half is now in scope, alongside EC-06.

---

## Recorded during the build

The story's _QA Acceptance Criteria — Manual_ require the whole-tree run and the
tracked-versus-untracked A/B recorded before any edit and again after, and
`ADR-US003-CITATION-GATE-BASELINE-DIFF` puts the baseline in this file "before editing begins".
The implementer fills the before-edit slots on the story branch before its first edit — never
reconstructed afterwards; the walker fills the two walk-time slots as AFTER-01 and AFTER-02 run.
Every figure carries `git status --porcelain` and `HEAD` beside it. The rows below read these;
nothing here carries a `Result`. The fixture identity and restoration evidence below are also blank until execution.

| Capture                                                                                                                                                                                            | Required by                                                                            | Taken                  | Value |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | ---------------------- | ----- |
| Whole-tree `doc-references.sh` run, timed — the finding count by class, the exit code, the summary line's files read, exempt by rule, backticked tokens and path tests, and the wall-clock runtime | the story's _QA Acceptance Criteria — Manual_; `ADR-US003-CITATION-GATE-BASELINE-DIFF` | Before the first edit  |       |
| `doc-references.sh --self-test` — the exit code and the probe count                                                                                                                                | `HP-05`, whose rise is counted from it                                                 | Before the first edit  |       |
| `doc-references.sh --path research/CONTEXT.md` — the summary line                                                                                                                                  | `HP-01`, whose reverse EXEMPT-01 walks                                                 | Before the first edit  |       |
| The tracked-versus-untracked A/B — the file measured, its findings by class untracked and then with `git add --intent-to-add`, and `git status --porcelain` after the scoped index restore         | the story's _QA Acceptance Criteria — Manual_; `HP-02`                                 | Before the first edit  |       |
| `docs-length.sh` — its figure for `code/src/scripts/audits/CONTEXT.md`                                                                                                                             | `AC-GAP-9`, which GATES-01 checks                                                      | Before the first edit  |       |
| The whole-tree run again, same form                                                                                                                                                                | the story's _QA Acceptance Criteria — Manual_                                          | At the walk — AFTER-01 |       |
| The A/B again, on the same US998 bytes                                                                                                                                                             | the story's _QA Acceptance Criteria — Manual_                                          | At the walk — AFTER-02 |       |

Additional approved capture slots, 09/10/2026 (all unfilled):

- **Fixture provenance:** clone HEAD, baseline source commit, US998 byte identity, both index states and restoration.
- **Controlled comparison:** stock and arm-only detector revisions, frozen target tree, current counts and every added finding identity.
- **Separate target proofs:** US999 citation content, required target absences, retained register rows and both US000 restoration runs.

---

## Journeys

One `###` section per journey **area**, rows in the order a person works through the gate.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The baseline, read back

| ID          | Action                                                                      | Expected outcome                                                                                                                                                                                                                                                              | Flow | QA    | Result | Notes                                                                          |
| ----------- | --------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------ |
| BASELINE-01 | Open _Recorded during the build_ → the whole-tree run before the first edit | Captured before the first edit, beside the index state and `HEAD`: the finding count by class, the exit code, the summary line's files read, exempt by rule, backticked tokens and path tests, and the wall-clock runtime. Every finding line reads `file:line [class] token` | —    | —     |        |                                                                                |
| BASELINE-02 | Read the `--self-test` capture                                              | Its exit code and probe count are recorded — the count SELFTEST-01 is compared against                                                                                                                                                                                        | —    | —     |        |                                                                                |
| BASELINE-03 | Read the `research/CONTEXT.md` capture                                      | The summary line counted the file as exempt by rule, not as read — one of the nine shipped files the exempt trees hid before the change                                                                                                                                       | —    | —     |        |                                                                                |
| BASELINE-04 | Read the US998 A/B capture and byte-identity/source-commit evidence         | Before-edit capture records current index-dependent template-only findings; other finding identities match. Scoped index restore returns US998 to untracked with unchanged bytes. Historical five-to-zero is not required.                                                    | —    | HP-02 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |
| BASELINE-05 | Read the `docs-length.sh` capture                                           | Its figure for `code/src/scripts/audits/CONTEXT.md` is recorded as that gate measures it — the figure GATES-01 is compared against                                                                                                                                            | —    | —     |        |                                                                                |

### Self-test

| ID          | Action                                                                                          | Expected outcome                                                                                                                                                       | Flow | QA    | Result | Notes |
| ----------- | ----------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SELFTEST-01 | Run `bash code/src/scripts/audits/doc-references.sh --self-test`, then `git status --porcelain` | Exits 0; its probe count is higher than BASELINE-02's by the cases the repairs added, one per repair; the self-test has left no new untracked file in the working tree | —    | HP-05 |        |       |

### After the change — the same measurements

| ID       | Action                                                                                                                                             | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                | Flow | QA    | Result | Notes                                                                          |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------ |
| AFTER-01 | Record `git status --porcelain` and `git rev-parse HEAD`, then run `bash code/src/scripts/audits/doc-references.sh` over the whole tree, timing it | Recorded under _Recorded during the build_ beside the before-edit run, with both counts, both exit codes, the delta and both runtimes. No finding remains of the three classes the story owns — the git-index class, the instance-citer class and the dangling `project-management/src/` class. Every survivor is attributable to the story that owns it, and while one stands the result is never reported as the gate passing (`code/docs/GATE-REPORTING.md`) | —    | —     |        |                                                                                |
| AFTER-02 | In the disposable clone, repeat US998's A/B using the same baseline bytes — untracked, intent-to-add, scoped index restore — and record the output | Both states report zero template-only findings and identical other finding identities; US998 is untracked again with unchanged bytes after restoration.                                                                                                                                                                                                                                                                                                         | —    | HP-02 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |

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

| ID          | Action                                                                                                                                                                                                                                                            | Expected outcome                                                                                                                                                                    | Flow | QA    | Result | Notes                                                                          |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------ |
| DEADPATH-01 | In scratch US999, cite "project-management/src/02-STORIES/US997.md" in backticks on its own plain line; verify the target is absent and unregistered, then run `bash code/src/scripts/audits/doc-references.sh --path project-management/src/02-STORIES/US999.md` | Check 1 adds a `[dangling path]` finding for the absent US997 story. US998 is the separate existing A/B copy and is not used as the missing target.                                 | —    | HP-04 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |
| DEADPATH-02 | Read DEADPATH-01's output for the same citation                                                                                                                                                                                                                   | No `[instance citation]` finding: Check 2 exempts the US999 citer while Check 1 catches its missing target. This proves the hand-over, independently of the registered-record case. | —    | EC-05 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |

### The register — one patterned row binds a class

| ID          | Action                                                                                                                                                                                                         | Expected outcome                                                                                                                                                                                                                                                                                                                                             | Flow | QA    | Result | Notes                                                                          |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ------------------------------------------------------------------------------ |
| REGISTER-01 | Open `how-to/src/PROJECT-PATHS.md`                                                                                                                                                                             | Under `## Registered paths`, exactly two new rows, each written with `###` — the per-story manual guide in `project-management/src/18-TESTS/MANUAL/` and the per-story automated record in `project-management/src/18-TESTS/AUTOMATED/` — each naming what creates it and when; no row for a story-plan class; the header states that a row may be patterned | —    | —     |        |                                                                                |
| REGISTER-02 | Open `code/docs/FORWARD-VOICE.md` Section 3                                                                                                                                                                    | It states that a register row may be patterned and carries the duty to add one when a citation first needs it; no workflow `CHECKLIST.md` restates that duty                                                                                                                                                                                                 | —    | —     |        |                                                                                |
| REGISTER-03 | In US999, add a separate ordinary line citing "project-management/src/18-TESTS/AUTOMATED/US997-TEST-STATUS.md" in backticks; verify the target is absent, then run the gate with `--path` on US999             | No finding for that absent automated record: its patterned row registers it. DEADPATH-01's absent US997 story still reports.                                                                                                                                                                                                                                 | —    | HP-03 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |
| REGISTER-04 | In US999, add separate lines citing "project-management/src/18-TESTS/MANUAL/US1234-MANUAL-TESTING.md" and "project-management/src/18-TESTS/MANUAL/USxyz-MANUAL-TESTING.md" in backticks; run the gate on US999 | Each invalid target reports `[dangling path]`: the class matches exactly three digits, never four digits or letters.                                                                                                                                                                                                                                         | —    | EC-03 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |
| REGISTER-05 | In US999, add a line containing "e.g." and a backticked citation of "project-management/src/02-STORIES/US996.md"; run the gate, then remove the scratch citer and confirm its clone index is restored          | The known line-level naming limitation suppresses that story-target finding. The target is not a required shipped template; template-presence checks remain independent. No scratch citer or index entry remains.                                                                                                                                            | —    | EC-04 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |

### The citer test — shipped instance-shaped files stay policed

| ID       | Action                                                                                                                                                                                                                                                   | Expected outcome                                                                                                                                        | Flow | QA    | Result | Notes |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CITER-01 | Temporarily add a line to `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md` citing the bare filename "US001.md" in backticks. Run the gate with `--path` on the template; remove the line and confirm `git diff` on the template is empty | An `[instance citation]` finding for "US001.md" — the shipped template is instance-shaped but excluded from the citer test, so Check 2 still polices it | —    | EC-01 |        |       |
| CITER-02 | Do the same in `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md`                                                                                                                                                                              | An `[instance citation]` finding — the fall-through admits the template, and the citer test does not exempt a `*TEMPLATE*` file                         | —    | EC-02 |        |       |

### Required shipped templates as missing targets

| ID        | Action                                                                                                                                                                                                                       | Expected outcome                                                                                                                                                                                  | Flow | QA    | Result | Notes                                                                         |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----------------------------------------------------------------------------- |
| TARGET-01 | In a disposable clone, move the manual US000 template outside the root, keep the manual class row, and cite its literal repo-relative path from US999 on a plain line. Run the gate on US999, restore the target and repeat. | Missing target produces `[dangling path]` despite class registration; restoring it clears that target finding. The literal presence check precedes seeded, registered and naming-row suppression. | —    | EC-01 |        | Added before build 09/10/2026 — approved template-presence successor.         |
| TARGET-02 | Repeat TARGET-01 for the automated US000 template with its automated class row retained; restore the target after the run.                                                                                                   | Missing target produces `[dangling path]`; restoration clears it. Neither US000 test template can use patterned registration, and `*TEMPLATE*` targets also require literal presence.             | —    | EC-06 |        | Added before build 09/10/2026 — target proof is distinct from citer policing. |

### The gate fails loudly

| ID      | Action                                                                                                                                                                                                             | Expected outcome                                                                                                                                                                                                  | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| LOUD-01 | Temporarily rename the `## Registered paths` heading in `how-to/src/PROJECT-PATHS.md` and run the whole tree; restore the heading and confirm `git diff` on the file is empty                                      | Every citation the register normally covers is reported as a finding and the run exits non-zero — the gate fails loudly rather than passing silently                                                              | —    | ES-01 |        |       |
| LOUD-02 | Run the gate with `--path project-management/src` and note its `[instance citation]` findings. Note the mode of `copier.yml`, remove its read permission, run the same command again, then restore the mode        | The second run reports no `[template-only citation]` finding at all, and its `[instance citation]` findings match the first run's — the citer test holds with no readable `copier.yml`, as in a generated project | —    | ES-02 |        |       |
| LOUD-03 | Temporarily add two malformed rows under `## Registered paths` — one with no backticks, one whose pattern carries no digits — and run the whole tree; remove both rows and confirm `git diff` on the file is empty | The run completes with no shell error, and no finding AFTER-01 reported disappears — the malformed rows neither crash the parser nor register everything                                                          | —    | ES-04 |        |       |

### The Check 1 arm, measured alone

| ID         | Action                                                                                                                                                                                                                                   | Expected outcome                                                                                                                                                                      | Flow | QA    | Result | Notes                                                                          |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------ |
| MEASURE-01 | In a fresh frozen disposable clone, plant US999's plain missing-US997-story citation; run a branch-point stock detector copy and a copy with only the PM Check 1 arm added against that same tree; record counts and every added finding | The arm-only copy adds US997's `[dangling path]` finding; every addition is recorded by identity and class, with no naming-pattern additions. Historical 16 to 38 is not a threshold. | —    | HP-06 |        | Corrected before build 09/10/2026 — approved remediation in story and QA plan. |

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
