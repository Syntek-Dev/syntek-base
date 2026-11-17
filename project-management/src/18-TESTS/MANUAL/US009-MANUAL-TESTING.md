# US009 — Manual Testing Guide

_The manual testing guide for US009 — the walks a tester follows step by step in a scratch clone, and, once walked, whether each step passed. Authored from the specs at `17-story-plans` Step 7.2 as a backfill on 30/09/2026; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 17/11/2026 · **Story**: US009 · **Status**: Walked in part 17/11/2026 — 22 of 36 rows Pass, 0 Fail, 14 not yet walked (the real-install, CI-only and sign-off rows) — corrected 17/11/2026: walked and signed 17/11/2026, 33 Pass, 0 Fail, 3 awaiting CI (FAIL-01 to FAIL-03), per the _Outcome_ row; those three walked from CI 17/11/2026 — 36 Pass, 0 Fail

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
- **Recorded answers — 09/10/2026:** FAIL-01 to FAIL-03 use a regular-file obstruction at the
  effective hook directory in a disposable clone; STAGE-02 runs the actual graph installer;
  STAGE-03 uses separately pinned lefthook 1.13.0 and project 2.x with captured provenance.
  Follow the plan's _Approved fixture answers and verification boundary — 09/10/2026_ through
  the planned "code/src/scripts/tests/hook-arming.sh" runner. It is a build deliverable, not
  an available tool today. A missing runner or dependency is unmeasured, not an unanswered choice.
- **Effective hook:** resolve from the clone/worktree root with
  `git rev-parse --path-format=absolute --git-path hooks/pre-commit`; all hook reads and writes
  below use this path. Literal `.git/hooks/` describes the default clone only. A readable executable
  regular file bearing lefthook's marker is armed; use the same predicate as installer and notice.

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

**Walk provenance, 17/11/2026.** Branch head `97821a8`. The fixture rows ran through one
`bash code/src/scripts/tests/hook-arming.sh --fixture all --output /tmp/us009-qa-walk-17-11/reports`,
which snapshots the working tree into its own scratch fixtures, each with its own install; nothing
from this checkout was linked into them, and the tripwire did not fire. Summary: 371 passed,
0 failed, 1 unmeasured (`[ES-01]`, CI-only). FLAGS-01 ran in a scratch `git clone` of the branch
under `/tmp`. The evidence directory is scratch and not kept.

**The clean-clone `install.sh` output, and the commit's pre-commit legs** — not yet captured:
INSTALL-01 and INSTALL-04 have not been walked.

**How each staged state was made** — FAIL-01 not yet captured (CI-only) — captured 17/11/2026: the CI fixture's disposable clone with a regular file at the hooks path (CI run `44171354359`, job `134351075213`, PR #37, 17/11/2026). FAIL-04: fixture A with
the project `lefthook` removed from the snapshot's `node_modules` and a fake first on `PATH`.
STAGE-01 not walked. STAGE-02 and STAGE-03, as the runner recorded them:

```text
graph-reclaim      invocation: uvx --from code-review-graph==2.3.9 code-review-graph
                   version: code-review-graph 2.3.9
                   hook sha256 before 0f1317667c83822bcec01f962401f42ad95b40906444d484fe9f62e60214df3b
                   hook sha256 after  577e8d704d3bf5f180e3292e9aa0c83cfe6e5e0d0ba61e366d8bf0f217edb5a6
binary-provenance  fixture lefthook 1.13.0 executable sha256 44b49b62674b93a97880921572977a230f1f19bb2d2b36d8e970e5b8621c30b5
                   project lefthook 2.2.2 executable sha256 7771d6243018b445bb83dd3c9b12dffd92a6067a3958f21d984bb389d8dbbc58
                   host lefthook on PATH before: none
```

**The failing run's output and its exit code** — not yet captured: FAIL-01 and FAIL-02 are
CI-only and `audit-hook-arming.yml` has not run. Captured 17/11/2026 from CI run `44171354359`, job `134351075213`, PR #37, 17/11/2026: an err line
naming `lefthook install`; the child `install.sh` exited `2`; Steps 5 to 8 had run (`.env.dev` present
and differing from its example, the sentinel script executable, `MACHINE-SPEC.md` written).

**The two setup claims, re-read 17/11/2026** against `install.sh` at `97821a8`, whose Step 9
(`:536-542`) calls `install-hooks.sh`, which runs `pnpm exec lefthook install` (corrected
17/11/2026, review QA-01, workflow 23: it now runs `node_modules/.bin/lefthook install` directly,
not through `pnpm exec`; the claim re-read below is unaffected):

```text
.copier/README.md:450-452
This installs all root dev dependencies and runs `lefthook install`, which registers the
pre-commit hooks. From this point on, every `git commit` automatically runs linting and
type-checking across both layers.

how-to/src/CONTRIBUTING.md:155
Hooks are installed by `bash install.sh`.
```

Both are true of the changed script.

---

### Walk captures — 17/11/2026, scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`

INSTALL-01 / INSTALL-04 — the clean-clone install's Step 9 and the commit's pre-commit legs
(colour stripped; no `.env.*` value is reproduced anywhere here):

```text
── Host profile (code/docs/MACHINE-SPEC.md)
  ✓  Host profile written → code/docs/MACHINE-SPEC.md  (gitignored — refresh with: bash install.sh --spec)
── Git hooks (lefthook)
  ✓  Git hooks armed → /tmp/us009-walk.0bjc/c/.git/hooks/pre-commit (lefthook 2.2.2)
✓ Phase 1 complete.
install.sh exit=0

summary: (done in 14.27 seconds)
✔️ template-docs-readonly · clickup-export · pm-boards · code-review-graph · sync-trees
✔️ prettier · markdownlint · docs-length · template-integrity
[us009/hook-arming bd4fcc9] chore: walk probe (c)
```

STAGE-01 — how the staged state was made: `printf '#!/bin/sh\necho mine\n' > "$h" && chmod +x "$h"`,
then `bash install.sh`:

```text
  ⚠  Replaced a hook lefthook does not manage at /tmp/us009-walk.0bjc/c/.git/hooks/pre-commit (kept as pre-commit.old)
  ✓  Git hooks armed → /tmp/us009-walk.0bjc/c/.git/hooks/pre-commit (lefthook 2.2.2)
```

Every run also printed `⚠ Could not write to /etc/hosts` — on NixOS `/etc/hosts` is generated
read-only; the step is non-fatal by design (finding F-032).

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### Clean-clone install

| ID         | Action                                                                                                                                              | Expected outcome                                                                                                                                                                                                                                                                             | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| INSTALL-01 | In the fresh scratch clone, run `bash install.sh`                                                                                                   | The **last** step of Phase 1 is the git-hooks step, run after every other Phase 1 step; it runs `lefthook install`, prints its own `ok` line and says it wrote `.git/hooks/pre-commit`                                                                                                       | —    | HP-01 | Pass   | Not walked by the agent 17/11/2026 — needs the real `bash install.sh` in a clean clone (sudo `/etc/hosts`, docker, uv); handed to the developer. The step alone: fixture A `[HP-01]` Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: `── Git hooks (lefthook)` is the last section, after `── Host profile` (Step 8): `✓ Git hooks armed → …/c/.git/hooks/pre-commit (lefthook 2.2.2)`; run exit 0.                                                                                                                                                                                                                                                                                                                                                             |
| INSTALL-02 | Read the same run's output for the JavaScript dependencies step                                                                                     | No `postinstall` notice prints there — the hooks are armed later in the same run                                                                                                                                                                                                             | —    | EC-13 | Pass   | Not walked by the agent 17/11/2026 — read from INSTALL-01's run, which has not happened Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: no notice anywhere in the run (a `grep` for `not armed` and for `run: bash install.sh` found nothing);`install-frontend.sh --local`installs with`--ignore-scripts`.                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| INSTALL-03 | Read the resolved effective pre-commit hook and its mode                                                                                            | Readable executable regular file with lefthook generated marker; a stale unused default-path hook is insufficient                                                                                                                                                                            | —    | HP-02 | Pass   | Corrected 09/10/2026 — approved plan/QA correction; result remains unexecuted. Not walked by the agent 17/11/2026 — reads the hook INSTALL-01 writes. The step alone: fixture A `[HP-02]` Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: `-rwxr-xr-x` regular file at the effective path; line 1 `#!/bin/sh`; last line `call_lefthook run "pre-commit" "$@"`; 4 `LEFTHOOK` lines; `install-hooks.sh --notice` silent, exit 0.                                                                                                                                                                                                                                                                                                                                 |
| INSTALL-04 | Make a throwaway change in the clone and `git commit` it                                                                                            | The `lefthook.yml` pre-commit legs run, observably; their output is recorded in _Recorded during the build_                                                                                                                                                                                  | —    | HP-03 | Pass   | Not walked by the agent 17/11/2026 — needs INSTALL-01's clone and a person's commit. The step alone: fixture A `[HP-03]` Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: first attempt stopped at git's "Author identity unknown" (the clone had no identity — environment, not the story); re-run with a scratch identity: every `lefthook.yml` pre-commit leg ran and passed, commit `bd4fcc9` (_Recorded during the build_).                                                                                                                                                                                                                                                                                                                                 |
| INSTALL-05 | Run `bash code/src/scripts/tests/hook-arming.sh --fixture write-boundary` and inspect the complete before/after manifests around the extracted step | Outside the resolved hook directory and lefthook's own `.git/info/lefthook.checksum`, all path/type/mode/symlink-target/file-hash entries agree, including ignored entries. Synthetic ignored-file content changes fail the oracle even with unchanged Git status; no file contents recorded | —    | —     | Pass   | Corrected 09/10/2026 — approved plan/QA correction. Amended 17/11/2026 — was: "Outside the resolved hook directory, all path/type/mode/symlink-target/file-hash entries agree, including ignored entries"; why: the red-phase answers widened the boundary by lefthook's own `.git/info/lefthook.checksum`, which every `lefthook install` writes; evidence: `../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` _Red-phase answers — 17/11/2026_; finding: F-027 (owed to `../../20-FINDINGS/FINDING-US009-HOOK-ARMING-17-11-2026.md`). Walked: `[ST05]` default and redirected pass; the default case changed only `.git/hooks/pre-commit` and `.git/info/lefthook.checksum`; `[EC-17]` negative control fails the oracle with Git status identical; manifests hold path, type, mode, target and SHA-256 only |
| INSTALL-06 | Read the git-hooks step's output lines as if colour were absent                                                                                     | Each carries a glyph and a word, as `install.sh`'s other `ok`, `warn` and `err` lines do                                                                                                                                                                                                     | —    | —     | Pass   | Not walked by the agent 17/11/2026 — a reading of INSTALL-01's output, left to the developer. Observed in the probe transcripts with colour stripped: `✓ Git hooks armed`, `⚠ Replaced …`, `error: lefthook not found …` — `err` carries the word without a glyph, as `install.sh`'s own `err` does Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: each Step 9 line pairs a glyph with a word: `✓ Git hooks armed`, `⚠ Replaced a hook…`, `⚠ Skipped git hook installation…`.                                                                                                                                                                                                                                                                                  |

### Re-running the install

| ID       | Action                                                                                             | Expected outcome                                                                         | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                                         |
| -------- | -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| RERUN-01 | Copy the clone's `.git/hooks/pre-commit` aside, then run `bash install.sh` again in the same clone | The git-hooks step completes; no error anywhere in the run; the hook is still lefthook's | —    | HP-04 | Pass   | Not walked by the agent 17/11/2026 — a second real `bash install.sh` in INSTALL-01's clone. The step alone: fixture A `[HP-04]` Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: second `bash install.sh`: `✓ Git hooks already armed — refreshed …`; no `error`/`✗` line; `✓ Phase 1 complete`; exit 0. |
| RERUN-02 | Compare the hook with the copy taken in RERUN-01, byte for byte (`cmp`)                            | Identical — no duplication and no appended second block                                  | —    | EC-06 | Pass   | Not walked by the agent 17/11/2026 — follows RERUN-01. The step alone: fixture A `[EC-06]` byte-identical Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: `cmp` of the hook against the copy taken in RERUN-01 printed `IDENTICAL`.                                                                     |

### The script's flags

| ID       | Action                                    | Expected outcome                                                                                                                                                                       | Flow | QA    | Result | Notes                                                                                                                                                                                                                                  |
| -------- | ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| FLAGS-01 | Run `bash install.sh --help` in the clone | Phase 1 lists steps 1 to 9, the git-hooks step ninth and last; Phase 2 lists steps 10 and 11; the printed sequence is contiguous. The script's own Phase 2 step headers read 10 and 11 | —    | EC-08 | Pass   | Run 17/11/2026 in a scratch `git clone` of the branch at `97821a8`: Phase 1 lists 1 to 9, Step 9 "Arm the lefthook git hooks (install-hooks.sh)"; Phase 2 lists 10 and 11; body headers read `Phase 2 · Step 10` and `Step 11`; exit 0 |
| FLAGS-02 | Run `bash install.sh --spec` in the clone | It exits after regenerating the machine spec, and the git-hooks step does not run                                                                                                      | —    | EC-07 | Pass   | Fixture A `[EC-07]`: `install.sh --spec` exits 0, the hook stays unarmed, and the `--spec` short-circuit precedes Step 9; the `machine-spec` fixture passes all 17 cases                                                               |

### A failing hook install

| ID      | Action                                                                                                                  | Expected outcome                                                                                                                                                                               | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                                                  |
| ------- | ----------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| FAIL-01 | Run `bash code/src/scripts/tests/hook-arming.sh --fixture install-failure` and read the captured scratch install output | The actual lefthook invocation fails on the regular-file hooks obstruction after steps 5 to 8; the house err message names lefthook install. An earlier prerequisite failure is not this proof | —    | ES-01 | Pass   | Corrected 09/10/2026 — approved plan/QA correction; result remains unexecuted. Not walked 17/11/2026 — `install-failure` is CI-only and reported `[ES-01]` UNMEASURED locally; `audit-hook-arming.yml` has never run (F-005) — walked 17/11/2026 from CI run `44171354359`, job `134351075213`, PR #37, 17/11/2026: `install-failure` 7 passed, 0 failed, 0 unmeasured |
| FAIL-02 | Read the child `install.sh` exit code separately captured and reported by the fixture runner                            | The child installer exits `2`, as its header declares; the runner reports its own exit separately and never substitutes it for the installer result                                            | —    | ES-02 | Pass   | Corrected 09/10/2026 — approved plan/QA correction; result remains unexecuted. Not walked 17/11/2026 — as FAIL-01 — walked 17/11/2026 from CI run `44171354359`, job `134351075213`, PR #37, 17/11/2026: `install-failure` 7 passed, 0 failed, 0 unmeasured                                                                                                            |
| FAIL-03 | Inspect the clone after that run                                                                                        | Steps 5 to 8 had already run: the `.env.*` files, the generated dev secrets, the executable bits on the project scripts and the machine spec are all present                                   | —    | ES-03 | Pass   | Corrected 09/10/2026 — approved plan/QA correction; result remains unexecuted. Not walked 17/11/2026 — as FAIL-01 — walked 17/11/2026 from CI run `44171354359`, job `134351075213`, PR #37, 17/11/2026: `install-failure` 7 passed, 0 failed, 0 unmeasured                                                                                                            |
| FAIL-04 | With `lefthook` absent from the clone's `node_modules` and from `PATH`, run the step on its own                         | It fails with a message naming the missing binary — not a bare "command not found"                                                                                                             | —    | ES-04 | Pass   | Fixture A `[ES-04]`: exit 1, `error: lefthook not found in node_modules — … is missing; a lefthook on PATH is never used`; `[S-M2]`: a PATH lefthook is never executed                                                                                                                                                                                                 |

### Staged hook states

| ID       | Action                                                                                                                                 | Expected outcome                                                                                                                                                      | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| STAGE-01 | Write a hand-written hook into the clone's `.git/hooks/pre-commit`, then run `bash install.sh`                                         | The step's output tells the developer the existing hook was replaced — it is not lost silently                                                                        | —    | EC-03 | Pass   | Not walked by the agent 17/11/2026 — the row runs `bash install.sh`. The step alone: fixture A `[EC-03]` reports "Replaced a hook lefthook does not manage … (kept as pre-commit.old)" Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: `⚠ Replaced a hook lefthook does not manage at …/pre-commit (kept as pre-commit.old)` then `✓ Git hooks armed`; `pre-commit.old` holds the hand-written `echo mine`. |
| STAGE-02 | Run `bash code/src/scripts/tests/hook-arming.sh --fixture graph-reclaim`; read graph version/origin, hook hash and arming output       | The actual graph tool stages the prior hook; lefthook reclaims the effective path and reports replacement. No hand-written approximation                              | —    | EC-05 | Pass   | Corrected 09/10/2026 — approved plan/QA correction; result remains unexecuted. `graph-reclaim`: `uvx --from code-review-graph==2.3.9`, hook SHA-256 `0f131766…` before, `577e8d70…` after; the step reports "Replaced the raw code-review-graph hook … (reclaimed; kept as pre-commit.old)"; `[EC-05]` 4 pass, `[S-M1]` 9 pass                                                                                                                                    |
| STAGE-03 | Run `bash code/src/scripts/tests/hook-arming.sh --fixture binary-provenance`; read the two locked versions/hashes and invocation trace | Fixture 1.13.0 is first on the child PATH, but the arming command invokes the project lockfile-resolved 2.x executable; host globals and story lockfile are unchanged | —    | EC-02 | Pass   | Corrected 09/10/2026 — approved plan/QA correction; result remains unexecuted. `binary-provenance`: fixture 1.13.0 and project 2.2.2 integrities and executable hashes recorded; `execve` trace shows only the 2.2.2 executable ran; story lockfile and host resolution unchanged (`[EC-02]` 6 pass)                                                                                                                                                              |

### Checkouts without an ordinary `.git` directory

| ID      | Action                                                                                                                                 | Expected outcome                                                                                                                                               | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| REPO-01 | Export a copy of the clone without `.git`, and run `bash install.sh` there                                                             | The step reports that hook installation was skipped because there is no git repository; the install continues; the overall exit code is unaffected by the skip | —    | ES-05 | Pass   | Not walked by the agent 17/11/2026 — the row runs `bash install.sh` and reads its overall exit code. The step alone: fixture C `[ES-05]` Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: `git archive` export with no `.git`: `⚠ Skipped git hook installation — …/nogit is not inside a git repository`; `✓ Phase 1 complete`; exit 0.                                                                                                                                                    |
| REPO-02 | From the clone, `git worktree add` a checkout — where `.git` is a file — and run `bash install.sh` in it                               | The guard resolves the real git directory and the step runs and reports arming rather than a skip; a throwaway commit in the worktree runs the lefthook legs   | —    | EC-01 | Pass   | Not walked by the agent 17/11/2026 — the row runs `bash install.sh` in a worktree. The step alone, with a commit: fixture A `[EC-01]` Walked: walked 17/11/2026 by <%DEVELOPER_NAME%> in scratch clone `/tmp/us009-walk.0bjc` at `6420d4a`: `.git` is a `gitdir:` file; `✓ Git hooks already armed — refreshed` (armed, not skipped); a worktree commit ran every lefthook leg, `74394f7`. Arming from the worktree rewrote the shared hook's absolute lefthook path to the worktree's `node_modules` — lefthook's own behaviour, finding F-031. |
| REPO-03 | Copy the tree without `.git`, `git init` it fresh with no commits, and run the step on its own                                         | `lefthook install` succeeds against the unborn HEAD                                                                                                            | —    | EC-04 | Pass   | Fixture B `[EC-04]`: unborn HEAD, the step exits 0 and the hooks arm                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| REPO-04 | Run `bash code/src/scripts/tests/hook-arming.sh --fixture hook-paths` for relative and absolute core.hooksPath in clones and worktrees | Installation verifies the effective hook and a commit runs its legs; a stale marked default hook does not silence an absent effective hook                     | —    | EC-15 | Pass   | `hook-paths` `[EC-15]` 33 pass: ordinary, unborn, worktree, relative and absolute `core.hooksPath`, worktree common dir; each throwaway commit ran its legs; the stale marked default hook never silenced an absent effective hook                                                                                                                                                                                                                                                                                                               |
| REPO-05 | Read that fixture's marked non-executable effective-hook case                                                                          | Notice prints until the effective readable executable lefthook hook is installed                                                                               | —    | EC-16 | Pass   | `hook-paths` `[EC-16]` 4 pass: the marked non-executable hook is unarmed and the notice prints until the step restores an executable hook                                                                                                                                                                                                                                                                                                                                                                                                        |

### The supply-chain boundary

| ID        | Action                                                                                                                                                       | Expected outcome                                                                                                                                                                          | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                                     |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SUPPLY-01 | Read `code/src/scripts/development/install-frontend.sh` at each of its three `pnpm install` lines, one line at a time (`:67`, `:84` and `:93` on 30/09/2026) | `--ignore-scripts` is on each of the three lines. Recorded as three invocations of the repository's sixteen — not a statement of its lifecycle-script posture                             | —    | HP-05 | Pass   | Read 17/11/2026 by content: the three lines are now `:71`, `:104` and `:113` (moved by `8dceffb`, before this story), each carrying `--ignore-scripts`. The repository-wide count has moved from sixteen: measured 18 invocations, 6 suppressed, 12 not, counting the new `.github/workflows/audit-hook-arming.yml:78` — see the QA implementation record |
| SUPPLY-02 | Read the `scripts` of `package.json`                                                                                                                         | No `prepare` script, and no lifecycle script writes anywhere under `.git/`                                                                                                                | —    | HP-05 | Pass   | `scripts` holds `postinstall`, `lint:js`, `lint:md`, `format:check`, `format`; no `prepare`; `postinstall` only runs `install-hooks.sh --notice \|\| true`. Probe `[ST02]` 3 pass                                                                                                                                                                         |
| SUPPLY-03 | Read the postinstall body, then run `bash code/src/scripts/tests/hook-arming.sh --fixture notice-streams`                                                    | The notice names bash install.sh on stdout only; its separately captured stderr is empty. No file write, network call or credential read. A stderr-only notice fails the negative control | —    | PA-03 | Pass   | Corrected 09/10/2026 — approved plan/QA correction; result remains unexecuted. Body: `bash code/src/scripts/development/install-hooks.sh --notice \|\| true`. `notice-streams` `[PA-03]` 5 pass: stdout names `bash install.sh`, stderr empty, no file write, no network connection, no credential file opened (strace); `[EC-18]` negative control fails |
| SUPPLY-04 | Read the three `--ignore-scripts` assertions in the probe script, "code/src/scripts/tests/hook-arming.sh"                                                    | Each names its own single line and asserts the flag on that line only; none treats the lines from `:79` to `:93` as one block it has validated                                            | —    | —     | Pass   | `fx_manifest` finds each `pnpm install` line by content and runs one `check ST01 "install-frontend.sh:$ln — this line alone carries --ignore-scripts"` per line; no assertion spans a block                                                                                                                                                               |
| SUPPLY-05 | Diff `code/src/scripts/development/install-frontend.sh` against the pre-edit commit                                                                          | No change                                                                                                                                                                                 | —    | —     | Pass   | `git diff a0ca304 HEAD -- code/src/scripts/development/install-frontend.sh` is empty                                                                                                                                                                                                                                                                      |
| SUPPLY-06 | Read the manifest oracle's ignored synthetic file mutation case                                                                                              | The content change fails the oracle even with identical Git status                                                                                                                        | —    | EC-17 | Pass   | `write-boundary` `[EC-17]`: ignored-file content and mode changes fail the oracle while Git status is identical                                                                                                                                                                                                                                           |
| SUPPLY-07 | Read the notice oracle's stderr-only mutation case                                                                                                           | It fails; the valid notice requires stdout and empty stderr                                                                                                                               | —    | EC-18 | Pass   | `notice-streams` `[EC-18]`: a stderr-only notice fails the stream oracle; stdout-only passes                                                                                                                                                                                                                                                              |

### The setup claims

| ID       | Action                                                                                                                                                                                                            | Expected outcome                                                                          | Flow | QA    | Result | Notes                                                                                                                                                                                 |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---- | ----- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CLAIM-01 | Find, by its quoted text, the `.copier/README.md` sentence that `install.sh` "runs `lefthook install`, which registers the pre-commit hooks" (`:442` on 30/09/2026), and read it against the changed `install.sh` | It describes what the script does; the re-read is recorded in _Recorded during the build_ | —    | HP-06 | Pass   | The sentence is at `:450` now. `install.sh` Step 9 (`:536-542`) calls `install-hooks.sh`, which runs `pnpm exec lefthook install`; re-read recorded under _Recorded during the build_ |
| CLAIM-02 | Diff `.copier/README.md` against the pre-edit commit                                                                                                                                                              | The line holding that sentence is unchanged                                               | —    | HP-06 | Pass   | The diff against `a0ca304` has three hunks (`:171`, `:1126`, `:1140`); none touches the sentence                                                                                      |
| CLAIM-03 | Read "Hooks are installed by `bash install.sh`." in `how-to/src/CONTRIBUTING.md` against the changed `install.sh`, then diff that file against the pre-edit commit                                                | True, and the file is unmodified                                                          | —    | —     | Pass   | `how-to/src/CONTRIBUTING.md:155` true against the changed `install.sh`; `git diff a0ca304 HEAD` of that file is empty                                                                 |
| CLAIM-04 | Read the README setup command and compare its diff                                                                                                                                                                | The removed pnpm prepare command is replaced with bash install.sh                         | —    | HP-06 | Pass   | Diff hunk at `:1126`: `pnpm prepare` replaced by `bash install.sh       # Install everything and arm the Lefthook git hooks (Phase 1 Step 9)`                                         |
| CLAIM-05 | Read the README Development-scripts table                                                                                                                                                                         | An install-hooks.sh row describes the explicit arming script                              | —    | HP-06 | Pass   | Diff hunk at `:1140` adds the `install-hooks.sh` row: "Arm the Lefthook git hooks (`install.sh` runs it); `--notice` reminds"                                                         |

### Generation job

| ID    | Action                                                  | Expected outcome                                                                                                                   | Flow | QA    | Result | Notes                                                                                                                                                                                                                                                                                                                                              |
| ----- | ------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CI-01 | Open the pull request's `[3/4] Template Generation` job | Green on both answer sets — `INCLUDE_MOBILE` false and true — and its grep finds the git-hooks step in each generated `install.sh` | —    | HP-07 | Pass   | No pull request exists yet; read the push run of the same job at the branch head `97821a8` (run `44135924803`, 17/11/2026): `[3/4] Template Generation` success; "INCLUDE_MOBILE=false — the generated install.sh carries the git-hooks step" and the same for `true`. The push of `fd11604` failed on F-004, not US009. Re-read on the PR at `23` |

### Close

| ID       | Action                                            | Expected outcome                                            | Flow | QA  | Result | Notes                                                                                                                                                                                                                          |
| -------- | ------------------------------------------------- | ----------------------------------------------------------- | ---- | --- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| CLOSE-01 | Read _Tester sign-off_ against the story's author | The tester who signs is not the author of the story's edits | —    | —   | Pass   | Signed 17/11/2026 by <%DEVELOPER_NAME%>, who walked INSTALL-01 to REPO-02 and made none of the story's edits (those were made by dispatched agents); the agent-walked rows were walked by an agent that authored none of them. |

---

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID  | What happened | Blocks the story? | Routed to |
| --- | ------------- | ----------------- | --------- |

None — no row failed on 17/11/2026. Fourteen rows are not yet walked; they are listed under
_Tester sign-off_ → **Blockers**, and an unwalked row is never a pass.

---

## Tester sign-off

Filled at the walk.

| Field        | Value                                                                                                                                                                                                              |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Tester**   | <%DEVELOPER_NAME%> (rows INSTALL-01 to REPO-02 and CLOSE-01); the rows marked earlier on 17/11/2026 by an independent Claude agent (`qa-tester` skill, workflow 22 Step 4) that authored none of the story's edits |
| **Date**     | 17/11/2026                                                                                                                                                                                                         |
| **Browsers** | N/A — CLI surface; no browser is opened                                                                                                                                                                            |
| **Outcome**  | 36 Pass, 0 Fail (FAIL-01 to FAIL-03 walked from CI 17/11/2026; was: 33 Pass, 0 Fail, 3 awaiting CI); one row amended (INSTALL-05, finding F-027)                                                                   |
| **Blockers** | None (was: FAIL-01 to -03, CI-only — cleared 17/11/2026 from CI run `44171354359`, job `134351075213`, PR #37, 17/11/2026)                                                                                         |

- [x] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [x] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [x] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [x] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against `../AUTOMATED/US009-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US009.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US009-TEST-STATUS.md` — the paired automated-test record, written at `22-implementation-documentation` Step 4 on 17/11/2026
- `../../11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` — the fourteen security constraints the supply-chain rows read against
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — why a scenario this guide cannot walk is named out of scope rather than reported as passed

<!-- Corrected 09/10/2026 from the approved story/QA/plan; permanent row IDs kept. No result or sign-off filled. -->
