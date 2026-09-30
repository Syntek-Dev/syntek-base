# US006 — Manual Testing Guide

_The manual testing guide for US006: the enumerated proof-case list walked by hand against the six guarded scripts, and — once walked — whether each step passed._

**Last Updated**: 30/09/2026 · **Story**: US006 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US006.md` — The destructive dev scripts read the deployment posture, and refuse to run above development
- **Story plan:** `../../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — the code master this guide was authored beside
- **Branch:** `us006/posture-guard`
- **Surface:** CLI — the six guarded scripts under `code/src/scripts/`, run in a terminal. Each action is the command a person runs; each outcome is what it prints, the exit code it returns, and what it did or did not destroy.
- **Authored from:** `../../02-STORIES/US006.md` — its bound-set table and its enumerated proof-case list, cited below as "case N" · `../../11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` · `../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` · `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US006-POSTURE-GUARD.md` · `../../15-DECISIONS/ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` · `../../15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md` · `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` · `../../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` · `../../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`. No stage-1 design, GDPR, SEO, API or logging artefact exists for this story — every one of those flags reads `N/A`. Never code.

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

- **Stack:** dev stack running — `bash code/src/scripts/development/server.sh up` — for the
  permitting rows. A refusal needs no stack, and the _Stack down_ rows stop it on purpose.
- **Base URL:** N/A — CLI surface; no page is opened.
- **Seed data:** the dev users `bash code/src/scripts/database/seed-dev.sh` creates, from the sample
  values in the gitignored "code/src/docker/.env.dev" — never live credentials. Before the walk,
  take a backup with `bash code/src/scripts/database/backup.sh`; the restore rows use it.
- **The real answers file:** before the first scratch row, copy `.copier-answers.yml` aside. Each
  section names the scratch carrier it writes in its place — a file holding one
  `DEPLOYMENT_POSTURE:` line with the value given. PERM-08 puts the original back.
- **Two walk locations:**
  - **This repository**, with `copier.yml` at its root. The guard reads the carrier first, so a
    scratch carrier holding a legal posture decides the verdict here (case 12), and the real
    answers file, which holds no legal posture, takes the template proof (case 11).
  - **A checkout with no `copier.yml` at its root**, for _Damaged carrier_. In this repository the
    template proof permits every carrier holding no legal posture, so those states can refuse only
    where the root has no `copier.yml`. **Which checkout that is, the records do not say** — open
    question 1.
- **The build captures:** taken on the story branch **before its first edit** and filled under
  _Recorded during the build_ — the story's _Verification Checks_ and the plan's P0 require it,
  and `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  which supersedes `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, records a baseline
  here "before editing begins". Every row below is walked at `22`, the first section reading
  those captures back.
- **Recording a refusal:** `Notes` carries the observed exit code and the message's first line for
  every refusal — the story's manual criterion for the carrier states.
- **No terminal:** rows marked "no terminal" feed stdin from `/dev/null`.
- **Accounts / roles:** the developer's own shell. No application role is involved.
- **Out of scope:**
  - **Accessibility and responsive behaviour** — no rendered surface; the refusal is read in a
    terminal (QA plan Sections 3 and 4). The message's readability, the one thing the QA plan sets
    beside accessibility, is walked as OVR-01 and the _Damaged carrier_ rows. Both sections dropped.
  - **ShellCheck over the helper and the six callers** — the story records it in
    `../AUTOMATED/US006-TEST-STATUS.md`; this guide records only whether the host carries it
    (BASE-03).
  - **The self-test's own twenty-one verdicts** — the automated half, recorded in
    `../AUTOMATED/US006-TEST-STATUS.md`. This guide walks the same list by hand.
- **Open questions** — each awaits the developer's answer, and every row it holds carries
  `Awaiting answer` in `Notes` until it is answered and the row rewritten from it:
  1. **The damaged-carrier checkout — DAMAGED-01 to DAMAGED-09.** In this repository the template
     proof permits every carrier holding no legal posture, so those refusals can show only where
     the root carries no Copier template file. Which checkout is that — a generated project, a copy
     of this tree with that file removed, or another — and how is it made without a raw `copier`
     invocation? Raised at authoring, 30/09/2026; to be settled before the walk.

---

## Recorded during the build

The story's _Verification Checks_ and the plan's P0 require these before the first edit, and
`ADR-US003-CITATION-GATE-BASELINE-DIFF` puts the citation baseline in this file "before editing
begins". The implementer fills them on the story branch before its first edit — never
reconstructed afterwards. The rows below read them; nothing here carries a `Result`.

| Capture                                                                                                  | Value |
| -------------------------------------------------------------------------------------------------------- | ----- |
| `git status --porcelain`, `HEAD`, and whether US004 has landed                                           |       |
| `doc-references.sh` findings in every file the story edits, per its _Tasks_ — never the story file alone |       |
| `docs-length.sh` — its figure for `code/src/scripts/audits/CONTEXT.md`, as that gate measures it         |       |
| ShellCheck on the host — present, with its version, or absent                                            |       |

---

## Journeys

One `###` section per journey **area**, rows in the order a person works through them.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### The baseline, read back

| ID      | Action                                                   | Expected outcome                                                                                                                                                                                                                                                        | Flow | QA  | Result | Notes |
| ------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| BASE-01 | Open _Recorded during the build_ → the citation baseline | Captured before the first edit over every file the story edits — never the story file alone — with the index state, `HEAD` and whether US004 had landed beside it. If US004 had landed the closing run is read as a plain pass; if not, as a diff against this baseline | —    | —   |        |       |
| BASE-02 | Read the `docs-length.sh` capture                        | Its figure for `code/src/scripts/audits/CONTEXT.md` is recorded as that gate measures it — never `wc -l`                                                                                                                                                                | —    | —   |        |       |
| BASE-03 | Read the ShellCheck capture                              | Recorded as present, with its version, or absent — found before the first edit rather than at close                                                                                                                                                                     | —    | —   |        |       |

### The template checkout — this repository, the real answers file

| ID      | Action                                                                                                                         | Expected outcome                                                                                  | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| TMPL-01 | Run `git status --porcelain -- .copier-answers.yml`                                                                            | Prints nothing — the real answers file is unmodified before the walk                              | —    | —     |        |       |
| TMPL-02 | Run `bash code/src/scripts/database/migrate.sh show`                                                                           | Not refused; it proceeds and exits 0 (case 11)                                                    | —    | HP-02 |        |       |
| TMPL-03 | Run `bash code/src/scripts/database/reset.sh` and confirm at its prompt                                                        | Not refused; the reset completes and exits 0                                                      | —    | HP-02 |        |       |
| TMPL-04 | Run `bash code/src/scripts/database/restore.sh` with the backup taken under _Preconditions_, and confirm at its prompt         | Not refused; the restore completes and exits 0                                                    | —    | HP-02 |        |       |
| TMPL-05 | Run `bash code/src/scripts/database/seed-dev.sh`                                                                               | Not refused; seeding completes and exits 0                                                        | —    | HP-02 |        |       |
| TMPL-06 | Run `bash code/src/scripts/tests/server.sh down --volumes`                                                                     | Not refused; the test stack's volumes are removed and it exits 0                                  | —    | HP-02 |        |       |
| TMPL-07 | Run `bash code/src/scripts/development/server.sh down --volumes`, then `bash code/src/scripts/development/server.sh up --seed` | Neither is refused; the dev volumes are removed, then the stack comes back up seeded; both exit 0 | —    | HP-02 |        |       |
| TMPL-08 | Run `git status --porcelain -- .copier-answers.yml` again                                                                      | Prints nothing — all six scripts ran and the answers file is unmodified                           | —    | HP-02 |        |       |

### The CI teardown — this repository, the real answers file

| ID    | Action                                                                                                                                                                | Expected outcome                                                                                                                                                                                                                                                                  | Flow | QA  | Result | Notes |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| CI-01 | Open `.github/workflows/test-e2e.yml` at its teardown step and at its `up --build` step                                                                               | The teardown passes `--force-posture` with a literal posture and carries no `\|\| true`; a comment beside the literal names the developer as its owner and the commit that raises `DEPLOYMENT_POSTURE` as its trigger. The `up --build` step is unchanged and carries no override | —    | —   |        |       |
| CI-02 | Run the teardown command exactly as the workflow writes it, from the repository root; then bring the stack back with `bash code/src/scripts/development/server.sh up` | Not refused — the template proof permits the template's own teardown — and it exits 0                                                                                                                                                                                             | —    | —   |        |       |

### At `development` — scratch carrier `development`

| ID     | Action                                                                                                                         | Expected outcome                                                                                     | Flow | QA    | Result | Notes |
| ------ | ------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| DEV-01 | Run `bash code/src/scripts/database/migrate.sh show`                                                                           | Prints the posture `development` and the expand-then-contract obligation, proceeds, and exits 0      | —    | HP-01 |        |       |
| DEV-02 | Run `bash code/src/scripts/database/reset.sh` and confirm at its prompt                                                        | Not refused; the reset completes and exits 0 (case 1)                                                | —    | HP-01 |        |       |
| DEV-03 | Run `bash code/src/scripts/database/restore.sh` with the backup, and confirm at its prompt                                     | Not refused; the restore completes and exits 0                                                       | —    | HP-01 |        |       |
| DEV-04 | Run `bash code/src/scripts/database/seed-dev.sh`                                                                               | Not refused; seeding completes and exits 0                                                           | —    | HP-01 |        |       |
| DEV-05 | Run `bash code/src/scripts/tests/server.sh down --volumes`                                                                     | Completes as an ordinary teardown — no refusal, no added prompt, no override asked for — and exits 0 | —    | HP-01 |        |       |
| DEV-06 | Run `bash code/src/scripts/development/server.sh down --volumes`, then `bash code/src/scripts/development/server.sh up --seed` | Both complete with no refusal, no added prompt and no override asked for, and both exit 0            | —    | HP-01 |        |       |
| DEV-07 | Run each of the six guarded scripts with `--help`                                                                              | Each one's usage text declares exit code 4                                                           | —    | —     |        |       |

### Above `development` — scratch carrier `staging`, no override

| ID        | Action                                                                                                                    | Expected outcome                                                                                                                                                                    | Flow | QA    | Result | Notes |
| --------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| REFUSE-01 | Run `bash code/src/scripts/database/reset.sh`                                                                             | Exits 4; stderr begins `posture-guard: refused —`, names `staging` and the exact command to re-run with, and prints nothing else from the answers file; nothing is dropped (case 2) | —    | ES-01 |        |       |
| REFUSE-02 | Run `bash code/src/scripts/database/restore.sh` with the backup                                                           | Exits 4 with the same refusal; nothing is restored over the database                                                                                                                | —    | ES-01 |        |       |
| REFUSE-03 | Run `bash code/src/scripts/database/seed-dev.sh`                                                                          | Exits 4 with the same refusal; no fixture is loaded                                                                                                                                 | —    | ES-01 |        |       |
| REFUSE-04 | Run `bash code/src/scripts/development/server.sh down --volumes`                                                          | Exits 4 with the same refusal; the stack and its volumes are untouched                                                                                                              | —    | ES-01 |        |       |
| REFUSE-05 | Run `bash code/src/scripts/development/server.sh up --seed`                                                               | Exits 4 with the same refusal; nothing is seeded                                                                                                                                    | —    | ES-01 |        |       |
| REFUSE-06 | Run `bash code/src/scripts/tests/server.sh down --volumes`                                                                | Exits 4 with the same refusal; the test volumes are untouched                                                                                                                       | —    | ES-01 |        |       |
| REFUSE-07 | Write the scratch carrier as `production`, run `bash code/src/scripts/database/reset.sh`, then write it back as `staging` | Exits 4; the refusal names `production` (case 3)                                                                                                                                    | —    | ES-01 |        |       |

### The override — scratch carrier `staging`

| ID     | Action                                                                                                | Expected outcome                                                                                                                                                           | Flow | QA    | Result | Notes |
| ------ | ----------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| OVR-01 | Paste, verbatim, the re-run command REFUSE-01 printed, and confirm at the prompt                      | It works as pasted: the guard permits, the confirmation prompt still runs, and the reset completes (case 15)                                                               | —    | HP-03 |        |       |
| OVR-02 | Run `bash code/src/scripts/database/reset.sh --force-posture staging --yes` and decline at the prompt | The guard permits and the confirmation prompt still appears — `--yes` is inert above `development`; declining drops nothing                                                | —    | HP-03 |        |       |
| OVR-03 | Run `bash code/src/scripts/database/reset.sh --force-posture development`                             | Exits 4 with the guard prefix — an override naming any posture but the live one is refused, so an invocation pasted from history dies once the posture has risen (case 16) | —    | ES-03 |        |       |
| OVR-04 | Run `bash code/src/scripts/database/reset.sh --force-posture prod`                                    | Exits 4; the refusal names the three legal values — the flag is validated against the literal set before the carrier is read                                               | —    | —     |        |       |

### No terminal — scratch carrier `staging`

| ID       | Action                                                                                                    | Expected outcome                                                                                                                          | Flow | QA    | Result | Notes |
| -------- | --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| NOTTY-01 | Run `bash code/src/scripts/database/reset.sh` with no terminal                                            | Exits 4 with the guard prefix — never the exit-0 abort (case 18)                                                                          | —    | ES-02 |        |       |
| NOTTY-02 | Run `bash code/src/scripts/database/reset.sh --force-posture staging` with no terminal                    | The guard permits, the prompt reads nothing, and the run ends at exit 4 with the guard prefix — never exit 0 — with nothing dropped       | —    | ES-02 |        |       |
| NOTTY-03 | Run `bash code/src/scripts/development/server.sh down --volumes --force-posture staging` with no terminal | The teardown proceeds and exits 0 — the override, not the terminal, carries the authorisation (case 19). Leave the stack down for SEED-01 | —    | HP-04 |        |       |

### The seed path — scratch carrier `staging`

| ID      | Action                                                                              | Expected outcome                                                                                                                              | Flow | QA    | Result | Notes |
| ------- | ----------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SEED-01 | Run `bash code/src/scripts/development/server.sh up --seed --force-posture staging` | The flag crosses into `seed-dev.sh` — no unknown-option error, no exit 2, no second refusal — and the stack comes up seeded, exit 0 (case 20) | —    | HP-05 |        |       |
| SEED-02 | Run `bash code/src/scripts/database/seed-dev.sh --force-posture staging`            | Not refused; seeding completes and exits 0 — a direct run is satisfiable on the same terms                                                    | —    | —     |        |       |
| SEED-03 | Run `bash code/src/scripts/development/server.sh up --build` with no override       | Proceeds and exits 0 — `up` is bound on `--seed` only (case 21)                                                                               | —    | HP-07 |        |       |

### `migrate.sh` warns — scratch carrier `production`

| ID     | Action                                              | Expected outcome                                                                                                                             | Flow | QA    | Result | Notes |
| ------ | --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| MIG-01 | Run `bash code/src/scripts/database/migrate.sh run` | Warns, naming `production` and the expand-then-contract obligation; proceeds with no override; exits 0 — a warning never moves the exit code | —    | HP-06 |        |       |

### Stack down — scratch carrier `staging`

| ID      | Action                                                                                                                                          | Expected outcome                                                                                     | Flow | QA    | Result | Notes |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| DOWN-01 | Stop the dev stack with `bash code/src/scripts/development/server.sh down` (no `--volumes`), then run `bash code/src/scripts/database/reset.sh` | The posture refusal is what shows — exit 4 with the guard prefix — not a container-not-running error | —    | —     |        |       |
| DOWN-02 | Move "code/src/docker/.env.dev" aside, run `bash code/src/scripts/development/server.sh down --volumes`, then put the env file back             | The posture refusal — exit 4 with the guard prefix — not the env-file error at exit 2                | —    | EC-08 |        |       |
| DOWN-03 | With the stack still down, run `bash code/src/scripts/database/migrate.sh --self-test`                                                          | It runs and exits 0 — dispatched ahead of the container check, invoking no Docker                    | —    | EC-09 |        |       |

### Damaged carrier — a checkout with no `copier.yml` at its root

Each row writes the carrier state named, then runs `bash code/src/scripts/database/reset.sh` unless
the row says otherwise. Which checkout these rows run in is open question 1 under
_Preconditions_.

| ID         | Action                                                                                          | Expected outcome                                                                                                                                                                                                       | Flow | QA    | Result | Notes                             |
| ---------- | ----------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| DAMAGED-01 | Carrier `DEPLOYMENT_POSTURE: live` — a value outside the three                                  | Exits 4 with the guard prefix; names no posture; gives the reason and the repair, as the story words it: set `DEPLOYMENT_POSTURE` in `.copier-answers.yml` to one of `development`, `staging` or `production` (case 4) | —    | —     |        | Awaiting answer — open question 1 |
| DAMAGED-02 | Carrier with no `DEPLOYMENT_POSTURE` line                                                       | Exits 4; the reason the carrier cannot be read and the same repair; no posture named (case 5)                                                                                                                          | —    | —     |        | Awaiting answer — open question 1 |
| DAMAGED-03 | Carrier whose only posture line is commented — `# DEPLOYMENT_POSTURE: development`              | Exits 4 with the reason and the repair — a commented key is not a posture (case 6)                                                                                                                                     | —    | EC-01 |        | Awaiting answer — open question 1 |
| DAMAGED-04 | Carrier carrying the key twice, with different values                                           | Exits 4 — a duplicate key is a refuse state, not a precedence question (case 7)                                                                                                                                        | —    | EC-02 |        | Awaiting answer — open question 1 |
| DAMAGED-05 | Carrier with the key between conflict markers, as a `copier update` three-way merge leaves it   | Exits 4 — its own refuse state, not the absent-key one (case 8)                                                                                                                                                        | —    | EC-03 |        | Awaiting answer — open question 1 |
| DAMAGED-06 | Carrier present but unreadable — its read permission removed, or a directory in its place       | Exits 4, exactly as for an absent file (case 9)                                                                                                                                                                        | —    | EC-04 |        | Awaiting answer — open question 1 |
| DAMAGED-07 | No `.copier-answers.yml` at all                                                                 | Exits 4 with the reason and the repair (case 10)                                                                                                                                                                       | —    | —     |        | Awaiting answer — open question 1 |
| DAMAGED-08 | Carrier as DAMAGED-02; run `bash code/src/scripts/database/reset.sh --force-posture production` | Still exits 4 — the override is not honoured where no posture can be read; the refusal names the repair and no posture (case 17)                                                                                       | —    | EC-05 |        | Awaiting answer — open question 1 |
| DAMAGED-09 | Carrier as DAMAGED-02; run `bash code/src/scripts/database/migrate.sh show`                     | Warns that the posture is unknown and proceeds, exit 0 — `migrate.sh` never refuses                                                                                                                                    | —    | —     |        | Awaiting answer — open question 1 |

### Removing a guard call is noticed

| ID          | Action                                                                                                                                                                                                                                                         | Expected outcome                                                                                                    | Flow | QA    | Result | Notes |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| PRESENCE-01 | Delete the line that calls the guard from `code/src/scripts/database/reset.sh` and run `bash code/src/scripts/database/migrate.sh --self-test`; put the line back, confirm `git diff` on the script shows only the story's change, and run the self-test again | The first run fails on the line-order comparison for `reset.sh`; with the line restored the self-test exits 0 again | —    | ES-05 |        |       |

### Gates

| ID       | Action                                                                                                                                                                                                    | Expected outcome                                                                                                                                                                               | Flow | QA    | Result | Notes |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| GATES-01 | Record `git status --porcelain`, then run `bash code/src/scripts/audits/doc-references.sh`                                                                                                                | Read per BASE-01's branch: a plain pass only if the run exits 0; otherwise no finding BASE-01 did not carry in the files the story edits, and every survivor named with the story that owns it | —    | —     |        |       |
| GATES-02 | Create an untracked scratch Markdown file under `code/docs/` holding one backticked citation of a path that does not exist; run `bash code/src/scripts/audits/doc-references.sh`; delete the scratch file | The findings rise above GATES-01's by that citation, reported against the scratch file                                                                                                         | —    | ES-06 |        |       |
| GATES-03 | Run `bash code/src/scripts/audits/docs-length.sh`                                                                                                                                                         | `code/src/scripts/audits/CONTEXT.md` reads BASE-02's figure, unchanged; nothing the story creates or edits enters the warn tier without a dated allowance                                      | —    | —     |        |       |
| GATES-04 | Run `bash code/src/scripts/audits/docs-pairing.sh`                                                                                                                                                        | Passes — both halves of the `code/src/scripts/_lib/` pair were edited, and no directory was created                                                                                            | —    | —     |        |       |
| GATES-05 | Run `bash code/src/scripts/audits/doctrine-drift.sh`                                                                                                                                                      | Exits 0 — a regression check only; the guard's contract is prose and adds no claims row                                                                                                        | —    | —     |        |       |
| GATES-06 | Run `bash code/src/scripts/syntax/lint.sh --file-type markdown`                                                                                                                                           | Passes over the Markdown the story edits                                                                                                                                                       | —    | —     |        |       |

---

## Permission and access

No endpoint, screen or protected action in the web sense — the story's `API`, `Backend` and
`Frontend` flags read `N/A`. The authorisation boundary is the shell, and the posture **is** the
authorisation input: these rows walk which environment a destructive command may reach, including
the two scenarios the QA plan names as behaving like access-control ones (`EC-06`, `ES-04`).

| ID      | Action                                                                                                                                                                                                                                     | Expected outcome                                                                                                                                                             | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| PERM-01 | In this repository, with `copier.yml` at its root, write the scratch carrier as `production` and run `bash code/src/scripts/development/server.sh down --volumes`                                                                          | Exits 4 naming `production` — the carrier is read before the template proof, so a present `copier.yml` does not disarm the guard (case 12)                                   | —    | EC-06 |        |       |
| PERM-02 | Same carrier; run `bash code/src/scripts/database/reset.sh` with `DEPLOYMENT_POSTURE=development` exported into its environment                                                                                                            | Exits 4 naming `production` — the exported variable is ignored; there is no second channel (case 13)                                                                         | —    | EC-07 |        |       |
| PERM-03 | Write the scratch carrier as `development`; run `bash code/src/scripts/database/reset.sh` with `DOCKER_CONTEXT` set to a context other than `default`                                                                                      | Exits 4 with the guard prefix at `development` — Docker pointed elsewhere is not a posture question — decided from the environment alone, with no daemon contacted (case 14) | —    | ES-04 |        |       |
| PERM-04 | Same carrier and the same `DOCKER_CONTEXT`; run `bash code/src/scripts/database/migrate.sh show`                                                                                                                                           | The guard warns and does not refuse — no `posture-guard: refused —` line and no exit 4 from the guard; any failure after the warning is Docker's own (case 14)               | —    | ES-04 |        |       |
| PERM-05 | Same carrier; run `bash code/src/scripts/tests/server.sh down --volumes` with `DOCKER_HOST` set to the local socket `unix:///var/run/docker.sock`                                                                                          | Not refused — a local socket is on the allowlist — and it exits 0                                                                                                            | —    | —     |        |       |
| PERM-06 | Put the real answers file back in this checkout. In a git worktree of this repository, write that worktree's own carrier as `staging` and run `bash code/src/scripts/database/reset.sh` from the worktree                                  | Exits 4 naming `staging` — the root resolves from `BASH_SOURCE` to the worktree and reads its carrier, never the main checkout's or the working directory's                  | —    | EC-10 |        |       |
| PERM-07 | In the same worktree, with its own stack up and its carrier written as `development`, set `COMPOSE_PROJECT_NAME` to the name the worktree's compose override declares and run `bash code/src/scripts/development/server.sh down --volumes` | Not refused — the allowlist compares against the last compose file's declared name, so a correctly named worktree stack passes                                               | —    | —     |        |       |
| PERM-08 | Restore the worktree's own answers file; in this checkout run `git status --porcelain -- .copier-answers.yml`; bring the dev stack back with `bash code/src/scripts/development/server.sh up`                                              | Prints nothing — the real answers file is back, unmodified — and the stack comes up                                                                                          | —    | —     |        |       |

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

| Field        | Value                                 |
| ------------ | ------------------------------------- |
| **Tester**   |                                       |
| **Date**     |                                       |
| **Browsers** | N/A — CLI surface; no browser is used |
| **Outcome**  |                                       |
| **Blockers** |                                       |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every refusal row records its observed exit code and the message's first line in `Notes`
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] The real answers file, the env file and every script restored — `git status --porcelain` shows only the story's own changes
- [ ] Cross-checked against `../AUTOMATED/US006-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US006.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against, and its proof-case list numbers the cases cited above
- `../../17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md` — the implementation plan this guide was authored beside; its proof-case table marks which cases are walked by hand
- `../AUTOMATED/US006-TEST-STATUS.md` — the paired automated-test record, written at `22-implementation-documentation` Step 4 and absent until then
- `../../11-QA/PLANNING/QA-PLAN-US006-POSTURE-GUARD.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — the QA implementation review, written at `22`: whether the specified scenarios were met
- `../../05-USER-FLOW/` — no consolidated flow covers this story; its User Flow flag reads `N/A`, so every `Flow` cell is `—`
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `how-to/workflows/02-worktree-setup/` — how the worktree PERM-06 and PERM-07 need is created

<!-- AUTHORED 30/09/2026 as a backfill, when this folder split and authorship of the manual guide
     moved to 17-story-plans Step 7.2. The story, its plan and its QA plan predate that change, so
     the guide was written from them after the fact rather than beside the plan; the guard helper
     does not exist yet and no code was read. The story's QA flag reads "manual — that same list
     walked by hand", so every one of its twenty-one proof cases has a row here, cited as "case N".
     The rows also fold in the manual checks the story and plan already described for this file:
     the per-file citation baseline before the first edit, the template case with the answers file
     confirmed unmodified, the seed shell-out walked end to end, the refusal read and its suggested
     command pasted, both teardown paths at development, and the damaged-carrier refusal naming a
     repair and no posture. The guard helper and the gitignored env file are written in double
     quotes where named, as the sibling story plan does, because the citation gate tests
     backticked tokens. Revised the same day by the change's review: the rows once run before the
     first edit became captures under "Recorded during the build", read back by rows walked at 22,
     and the damaged-carrier checkout became open question 1, flagged on every row it holds. -->
