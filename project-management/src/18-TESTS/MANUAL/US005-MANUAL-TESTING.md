# US005 — Manual Testing Guide

_The manual testing guide for US005: the reads, recomputations and gate runs a tester works through against the retry doctrine, and — once walked — whether each step passed._

**Last Updated**: 30/09/2026 · **Story**: US005 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US005.md` — Exactly one layer decides to retry, and every budget says how long it may take
- **Story plan:** `../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — the code master this guide was authored beside
- **Branch:** `us005/retry-ownership-and-budgets`
- **Surface:** Gate — three documentation gates run in a terminal, and Markdown read in an editor. Each action is the command a person runs or the passage they open; each outcome is what the gate prints or what the passage states.
- **Authored from:** `../../02-STORIES/US005.md` · `../../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` · `../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` · `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` · `../../15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md` · `../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` · `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` · `../../16-SPRINT-PLANS/04-SPRINT-PLAN-04.md` · `../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`. No stage-1 design, GDPR, SEO, API or logging artefact exists for this story — every one of those flags reads `N/A`. Never code.

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

- **Stack:** none. The story ships Markdown only; no row needs `server.sh up`.
- **Base URL:** N/A — Gate surface.
- **Seed data:** none. Four rows make a temporary edit or an untracked scratch file to prove a gate
  still bites; each says how to put the tree back.
- **Blocker:** the reliability family `code/docs/reliability/` must exist before the first edit —
  US001 creates it and the story is `Blocked` until it lands (PRE-01).
- **The retry guide:** the story and its plan name it by **role** only. Its file is the one the
  family's `CONTEXT.md` assigns that role; the circuit-breaker deferral sits wherever that file
  assigns "the reliability family" role.
- **The build captures:** taken on the story branch **before its first edit** and filled under
  _Recorded during the build_ — the story requires the inventory captured before any statement is
  edited, and `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
  which supersedes `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, records a
  baseline "before editing begins". Every row below is walked at `22`, the first section reading
  those captures back.
- **Index state:** record `git status --porcelain` and `HEAD` beside every citation-gate figure — a
  figure is comparable only against a run in the same index state. Count finding lines, never grep
  hits over the whole output.
- **Line numbers:** every `file:line` below is the planning-time location. Re-read each passage
  where it now stands; US001 reduces one of these files before this story opens.
- **Accounts / roles:** none.
- **Out of scope:**
  - **Permission and access** — no endpoint, screen or protected action; the QA plan records no
    `PA` scenario for that reason. The story's security content is a set of constraints on the
    guide's wording, walked as RULES-12. Section dropped.
  - **Accessibility and responsive behaviour** — no rendered surface; the output is Markdown read
    in an editor (QA plan Sections 3 and 4). Both sections dropped.
  - **The `DEFERRED.md` unenforced-window entry** — `22`'s write, not a manual test of this story.
- **Open questions:** None.

---

## Recorded during the build

The story requires the before/after budget inventory and the gate figures recorded in this file
(_QA Tasks — Manual_), the inventory taken before any statement is edited, and
`ADR-US003-CITATION-GATE-BASELINE-DIFF` records a baseline here "before editing begins". The
implementer fills every before-edit value on the story branch before its first edit — never
reconstructed afterwards; the walker fills the after-the-change columns as XREAD-06 and the
_Gates_ rows run. The rows below read these; nothing here carries a `Result`.

### Before the first edit

| Capture                                                                                                                                                                                      | Value |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| The file the reliability family's own orientation file assigns the retry-guide role — or "absent", and the story stopped there, blocked on US001                                             |       |
| US001's landing state — whether it has merged, whether it has reduced the section that holds two of the four budgets, and whether it has already repointed `code/docs/NEGATIVE-SPACE.md:226` |       |

### Retry-statement inventory

Every retry statement in every file the story touches, taken before any is edited — at least `code/docs/api-design/WEBHOOKS.md:86`; `code/docs/performance/API-AND-MONITORING.md:46`, `:57`, `:69` and `:142`; the `project-management/docs/gdpr/COMPLIANCE.md:22-49` fence; `code/docs/TASK-AUTHORING.md:204`; `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md:252-257` and `:265`; `code/docs/mcp-server/TOOL-DESIGN.md:139-141`.

| File and line | Statement | Disposition before the first edit | State after the change (XREAD-06) |
| ------------- | --------- | --------------------------------- | --------------------------------- |

### Gate figures

| Gate                                                                  | Before the first edit | After the change (_Gates_) | Index state and `HEAD` |
| --------------------------------------------------------------------- | --------------------- | -------------------------- | ---------------------- |
| `doc-references.sh` — findings by class, and whether US004 has landed |                       |                            |                        |
| `docs-length.sh` — its figure for `code/docs/TASK-AUTHORING.md`       |                       |                            |                        |
| `doctrine-drift.sh` — exit code and registered claims                 |                       |                            |                        |

---

## Journeys

One `###` section per journey **area**, rows in the order a person works through them.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### Before the first edit, read back

| ID     | Action                                                                                  | Expected outcome                                                                                                                                                                                                                                                        | Flow | QA    | Result | Notes |
| ------ | --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| PRE-01 | Open _Recorded during the build_ → the retry-guide role, captured before the first edit | It names the file `code/docs/reliability/CONTEXT.md` assigned the role — the family existed when the story opened. Had it read "absent", the story was blocked on US001 and not started, and no later row is walked                                                     | —    | EC-07 |        |       |
| PRE-02 | Read US001's landing state, captured before the first edit                              | Recorded: whether US001 had merged, whether it had reduced the section that holds two of the four budgets, and whether it had already repointed `code/docs/NEGATIVE-SPACE.md:226` — the disposition of two of the four budgets turns on it, and COLD-03 reads it        | —    | —     |        |       |
| PRE-03 | Read the retry-statement inventory's before column                                      | Every retry statement in every file the story touches was listed before any was edited — the files named above it at least — and each marked resolved-here, resolved-by-US001 or `S-04`'s, with none unaccounted for                                                    | —    | HP-06 |        |       |
| PRE-04 | In that inventory, find `code/docs/performance/API-AND-MONITORING.md:142`               | It is caught as a retry statement that survives outside the section US001 reduces, in a home other than the family, and it is dispositioned                                                                                                                             | —    | EC-06 |        |       |
| PRE-05 | Read the gate figures' before column                                                    | Each was captured before the first edit with the index state and `HEAD` beside it: the citation gate's findings by class and whether US004 had landed; the length gate's figure for `code/docs/TASK-AUTHORING.md`; the drift gate's exit code and its registered claims | —    | —     |        |       |

### The retry guide — the rules, read in place

| ID       | Action                                                                                                                                           | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Flow | QA    | Result | Notes |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| RULES-01 | Open the retry guide at its owner rule                                                                                                           | It states once that exactly one layer decides to repeat an operation and every layer beneath makes a single attempt; that SDK transport retries are clamped off by default, naming `retries={"total_max_attempts": 1}` as the worked form and never `max_attempts: 1`; that the same identifier counts differently by configuration source — `AWS_MAX_ATTEMPTS` and the AWS config file include the initial request, a `Config` object does not; and it cites `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md` by full path                                | —    | HP-01 |        |       |
| RULES-02 | Read on through the owner rule                                                                                                                   | It states the escape hatch — a client keeping transport retries does so through a row in the outbound timeout register naming the delegation and its reason, on the `DICT-OK:` pattern; that served surfaces never retry inbound work, naming FastMCP's `RetryMiddleware` as deliberately unwired and exit 75 as the CLI expression; the caller's own obligation to bound the repeat it now owns, naming inbound rate limiting as a dependency this tree does not yet have; and, in a form a later script could check, that every SDK or HTTP client constructor sets its attempt count explicitly | —    | —     |        |       |
| RULES-03 | Read the idempotency precondition on the owner rule                                                                                              | A layer may repeat only an operation it can show is idempotent — by the family's idempotency rule once slice `S-03` ships, by the proof ladder in `code/docs/TASK-AUTHORING.md` until then. No passage licenses a repeat without it, the HTTP-client and CLI surfaces included                                                                                                                                                                                                                                                                                                                     | —    | —     |        |       |
| RULES-04 | Read the `Retry-After` rule                                                                                                                      | The retry owner waits `max(backoff, Retry-After)` and never past the row's total-age ceiling, the clamp stated in the same breath as the honouring rather than as a later caveat; `Retry-After` is named as untrusted input, so the clamp is a control; the one sanctioned manual form is named — `autoretry_for` cannot read a response header, so honouring it on Celery takes the manual call, with `retry_backoff_max` still capping the interval                                                                                                                                              | —    | —     |        |       |
| RULES-05 | Read what the rule says when a `Retry-After` exceeds the remaining budget                                                                        | The work is parked as exhausted — the wait is never extended past the bound                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | —    | EC-03 |        |       |
| RULES-06 | Read the failure classification where a 4xx is called permanent                                                                                  | 429 and 503 are carved out of the permanent class explicitly, so no reader can satisfy both rules and still be wrong                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | —    | EC-02 |        |       |
| RULES-07 | Read the budget table                                                                                                                            | Its defaults are Celery's own, taken declaratively — the `autoretry_for` path, 3 attempts, exponential from 1 s, a 600 s interval cap, jitter on. _Attempt_ is defined once, and the table says which parameter carries which count: `max_retries=3` is four attempts, and three attempts is `max_retries=2`. The worst-case total-age column is a formula, not a copied number, and states its assumption that inner-layer attempts are one                                                                                                                                                       | —    | HP-02 |        |       |
| RULES-08 | Read the rules beside the table                                                                                                                  | Manual `self.retry` is banned as the routine environment-error path, not outright. The webhook 5 attempts over 24 hours is a recorded per-row override that states every parameter it changes and what makes an override legitimate, and states that a repeat reuses the original delivery identifier and does not refresh the signature timestamp. The staleness escape hatch — a timestamp argument or a per-message `expires` — is stated with the condition that makes it mandatory, not merely available                                                                                      | —    | —     |        |       |
| RULES-09 | Read the rule for a row that delegates transport retries                                                                                         | It records the delegated attempt count and interval as numbers, never as "the vendor default", so the worst case still resolves                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | —    | EC-05 |        |       |
| RULES-10 | Read the attempt-log rule                                                                                                                        | It names what an attempt log records — attempt number, elapsed budget, error class — and names as excluded, not merely unmentioned, the exception message, the request URL and the provider's body                                                                                                                                                                                                                                                                                                                                                                                                 | —    | —     |        |       |
| RULES-11 | Open the family's circuit-breaker deferral                                                                                                       | It is in the house deferral-with-trigger form with both triggers — the first incident where bounded retries against a live provider degrade service, or the story integrating a second rate-limited external API — and names the disable-after-N-failures rule in `code/docs/api-design/WEBHOOKS.md` as the partial mechanism already in the tree                                                                                                                                                                                                                                                  | —    | HP-04 |        |       |
| RULES-12 | Read the retry guide against items 1 to 11 of Section 7 in `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` | Each of the eleven is satisfied by the guide's wording. Item 12, the `DEFERRED.md` entry, is `22`'s write and is not judged here                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | —    | —     |        |       |

### The worst case, recomputed by hand

| ID        | Action                                                                                                                                                         | Expected outcome                                                                                                     | Flow | QA    | Result | Notes |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| RECOMP-01 | Pick a default row of the budget table and recompute its worst-case total age by hand from that row's own parameters, writing the arithmetic string in `Notes` | The result matches what the column claims, reached without opening a second document                                 | —    | HP-02 |        |       |
| RECOMP-02 | Do the same on the webhook override row                                                                                                                        | It resolves from the row alone — every parameter the override changes is stated — and matches what the column claims | —    | EC-04 |        |       |

### Read-across — no budget in two homes

| ID       | Action                                                                                                                                                                                                                                                                                    | Expected outcome                                                                                                                                                                                                                                                                                           | Flow | QA    | Result | Notes |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| XREAD-01 | Read the retry guide against `code/docs/TASK-AUTHORING.md`, `code/docs/performance/API-AND-MONITORING.md`, `code/docs/api-design/WEBHOOKS.md`, `project-management/docs/gdpr/COMPLIANCE.md`, `code/docs/mcp-server/TOOL-DESIGN.md` and `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` | No retry budget is stated in two homes; no guide states a budget the table does not sanction; no guide states the inverse of the owner rule without a citation naming the surface it is the exception for                                                                                                  | —    | HP-03 |        |       |
| XREAD-02 | Compare the two sites that wrote `max_retries=3` — in `code/docs/performance/API-AND-MONITORING.md` and `project-management/docs/gdpr/COMPLIANCE.md`                                                                                                                                      | They no longer land on different worst cases, roughly 3 minutes against roughly 9 — each agrees with the table or cites it instead of restating it — and the total-age requirement reads in a form Celery can satisfy: `retry_backoff_max` caps the interval between attempts, not the length of the chain | —    | HP-03 |        |       |
| XREAD-03 | Open the code fence in `project-management/docs/gdpr/COMPLIANCE.md` that sat at lines 22–49                                                                                                                                                                                               | It demonstrates the declarative `autoretry_for` shape with a budget the table sanctions; its exception tuple names specific transient types and excludes permanent failures — `autoretry_for=(Exception,)` does not pass; no bare `except Exception` with a manual `self.retry` remains                    | —    | HP-07 |        |       |
| XREAD-04 | Open `project-management/src/01-FEATURE-MAPS/MAP-RETRY-AND-IDEMPOTENCY.md` at its slice table                                                                                                                                                                                             | `S-04` records that its example count has dropped to three; `S-02` records this story's number and describes the doctrine half only; `S-09` carries `N-012` and the outbound timeout register with its own flag manifest                                                                                   | —    | —     |        |       |
| XREAD-05 | Open `code/docs/mcp-server/TOOL-DESIGN.md` at the passage that sat at lines 139–141                                                                                                                                                                                                       | Either it states the rule the retry guide states, or the map records the named slice that owns its repair — never neither                                                                                                                                                                                  | —    | —     |        |       |
| XREAD-06 | After the change, re-take PRE-03's inventory over the same files                                                                                                                                                                                                                          | Every statement in the before-inventory is accounted for — resolved here, by US001, or `S-04`'s — and all four budget contradictions resolve against the table. The after-state is recorded beside the before-state under _Recorded during the build_                                                      | —    | HP-06 |        |       |

### Cold reads — the two repointed lines

| ID      | Action                                                                                                                                              | Expected outcome                                                                                                                                                 | Flow | QA    | Result | Notes |
| ------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| COLD-01 | Open `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` at the line that mandated circuit breakers (`:265` at planning), reading nothing else first | It is a pointer, not a mandate, and following it reaches the breaker deferral in one hop                                                                         | —    | HP-04 |        |       |
| COLD-02 | Open `code/docs/NEGATIVE-SPACE.md` at the environment-error pointer (`:226` at planning) and the environment-error row (`:211` at planning)         | The pointer names the reliability family and its sentence reads true; the row carries its retry-owner pointer in prose, and the table has gained no sixth column | —    | HP-05 |        |       |
| COLD-03 | Compare the story branch's diff of `code/docs/NEGATIVE-SPACE.md` with PRE-02's landing state                                                        | If US001 had already repointed that line, the branch makes no second repoint — the line was read and verified, not assumed                                       | —    | EC-01 |        |       |

### Gates

| ID       | Action                                                                                     | Expected outcome                                                                                                                                                                                                                                                                                                | Flow | QA  | Result | Notes |
| -------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| GATES-01 | Run `bash code/src/scripts/audits/docs-length.sh`                                          | No file the story creates is at or above 270 counted lines at birth, and no file it edits crosses 270 without a dated allowance — `code/docs/TASK-AUTHORING.md` is the one to watch                                                                                                                             | —    | —   |        |       |
| GATES-02 | Record `git status --porcelain`, then run `bash code/src/scripts/audits/doc-references.sh` | No new dangling citation against PRE-05's figure in the same index state. Every surviving finding is named with its owner — the outbound timeout register's forward references to slice `S-09`, and US003's guide "code/docs/ABSENCE.md" if it has not landed. A plain pass is recorded only if the run exits 0 | —    | —   |        |       |
| GATES-03 | Run `bash code/src/scripts/audits/doctrine-drift.sh`                                       | Exits 0 — the registered claims still resolve to one home each. Recorded as a regression check only: it reads fenced code, so it has not checked this story's prose                                                                                                                                             | —    | —   |        |       |
| GATES-04 | Run `bash code/src/scripts/syntax/lint.sh --file-type markdown`                            | Passes over the Markdown the story edits                                                                                                                                                                                                                                                                        | —    | —   |        |       |

### The gates still bite

| ID      | Action                                                                                                                                                                                                              | Expected outcome                                                                                                               | Flow | QA    | Result | Notes |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ---- | ----- | ------ | ----- |
| BITE-01 | Create an untracked scratch Markdown file under `code/docs/` holding one backticked citation of a path that does not exist. Run `bash code/src/scripts/audits/doc-references.sh`; delete the scratch file           | The findings rise above GATES-02's by that citation, reported against the scratch file                                         | —    | ES-01 |        |       |
| BITE-02 | Temporarily pad a file the story edited past 270 counted lines, run `bash code/src/scripts/audits/docs-length.sh`, then remove the padding and confirm `git diff` on the file shows only the story's own change     | The padded file is reported in the warn tier                                                                                   | —    | ES-02 |        |       |
| BITE-03 | Temporarily copy one fenced-code claim registered with the drift gate into a second guide, run `bash code/src/scripts/audits/doctrine-drift.sh`, then remove the copy and confirm `git diff` on that guide is empty | It exits non-zero, naming the forked claim                                                                                     | —    | ES-03 |        |       |
| BITE-04 | In a scratch file as BITE-01's, cite a path that does not exist on a line carrying the `doc-references: template-only` marker. Run the citation gate; delete the scratch file                                       | No finding for it — the marker suppresses the check, which is why the story removes the marker rather than relying on the gate | —    | ES-04 |        |       |

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
- [ ] Both arithmetic strings written out in `Notes` — a recomputation whose working is not recorded is indistinguishable from one nobody did
- [ ] Every scratch file deleted and every temporary edit reverted — `git status --porcelain` shows only the story's own changes
- [ ] Cross-checked against `../AUTOMATED/US005-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US005.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US005-TEST-STATUS.md` — the paired automated-test record, written at `22-implementation-documentation` Step 4 and absent until then
- `../../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — the QA implementation review, written at `22`: whether the specified scenarios were met
- `../../05-USER-FLOW/` — no consolidated flow covers this story; its User Flow flag reads `N/A`, so every `Flow` cell is `—`
- `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` — Section 7, the constraints RULES-12 reads the guide against
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — how a gate result with survivors, or a check that reads no prose, is reported

<!-- AUTHORED 30/09/2026 as a backfill, when this folder split and authorship of the manual guide
     moved to 17-story-plans Step 7.2. The story, its plan and its QA plan predate that change, so
     the guide was written from them after the fact rather than beside the plan; no code for this
     story existed to be read, and the reliability family it writes into does not exist yet. The
     rows fold in the manual checks the story and its plan already described for this file: the
     before/after budget inventory with US001's landing state, the three gates with the index
     state beside each figure, the hand recomputation on a default row and the webhook override
     row, the six-guide read-across, and the two cold reads. The capture section exists because
     the story names this file as where the inventory and the figures are recorded. Revised the
     same day by the change's review: the rows once run before the first edit became captures
     under "Recorded during the build", read back by rows walked at 22, and the walk-time
     evidence section folded into it. -->
