# US013 — Test Status

_The automated-test record for US013: what each automated check proves and whether it passed. Written at `22-implementation-documentation` Step 4 on 23/11/2026, on `us013/log-debug-workflow-seam` at `79a22cb7`. US013 is **documentation only**: it edits workflow `09-debugging-with-logs`, the `code/src/logs/` pair, a `copier.yml` comment and help line, `TEMPLATE-TOKENS.md`, `05-ANSWERS.md` and a note on `MAP-RULE-OWNERSHIP.md`, and no `.py` or `.bru` file. The story plan's Testing section records every automated suite `N/A` — no pytest (no code path), no coverage floor (nothing instruments), no `migrate.sh check` (no model), no Bruno, no e2e (no page). So no test declares US013, and its automated proof is CI's `[3/4] Template Generation` job rendering every token. The generator cannot see that job, so Sections 2 and 3 carry it (this folder's `CLAUDE.md`, Guardrails)._

**Last Updated**: 23/11/2026 · **Story**: US013 · **Status**: Green

- **Story:** `../../02-STORIES/US013.md` — the 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause
- **Story plan:** `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the code master this record closes the loop on (read its CORRECTED 23/11/2026 block: cut from `dev` at `e306f48e`, no worktree)
- **Manual guide:** `../MANUAL/US013-MANUAL-TESTING.md` — where the render counts, the doc gates and the live walk are read
- **Branch:** `us013/log-debug-workflow-seam`, cut from `dev` at `e306f48e`; pushed head `58f3c78e`, local head `79a22cb7`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US013
```

**Read Section 2 before this block. A zero-row table here is not a small suite.** No pytest or
Bruno test declares US013, and none could: the story changes no Python module and no API request.
`story-map.json` on disk is `[]`. The coverage figures below are **whole-project** backend figures
from the `coverage.xml` already on disk (written 09:06 GMT, 23/11/2026, by a run that was not this
story's), so they measure nothing it did — the open defect
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`. The
auth-critical row is left as the generator writes it: no module in the authentication, session or
permission path is in scope.

The floors are **one floor, not one per layer** — template, django-component and HTMX-partial
tests are pytest tests and count towards the same number as the rest of the backend. On
`staging` and `main` the pre-PR gate raises every floor to **80%**, so a story green locally can
still block the PR if a module in scope sits between its floor and 80%. **Auth-critical** means
any module in the authentication, session or permission path.

<!-- BEGIN GENERATED: test-record -->

### 1.1 Suite summary

| Suite      | Report artefact | Tests | Result              | Coverage   |
| ---------- | --------------- | ----- | ------------------- | ---------- |
| **Totals** |                 | **0** | **0 Pass / 0 Fail** | **100.0%** |

_No test declares `US013`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

### 1.2 Coverage vs floors

| Scope                       | Floor | This story                                       | Met? |
| --------------------------- | ----- | ------------------------------------------------ | ---- |
| All modules — line + branch | 75%   | 100.0% line / 100.0% branch                      | Yes  |
| Auth-critical modules       | 90%   | _{state the modules in scope and their figures}_ | _{}_ |

_The line floor above is read from `pyproject.toml`; the 90% auth floor is not machine-readable and is stated by `code/docs/testing/COVERAGE.md`, which owns both. The auth-critical row is not derivable either — which modules sit in the authentication, session and permission path is a judgement. Name them and read their figures from the per-module table below._

| Module                                           | Statements | Missed | Branch | Cover  |
| ------------------------------------------------ | ---------- | ------ | ------ | ------ |
| `code/src/django/apps/core/apps.py`              | 4          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/management/base.py`   | 17         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/middleware.py`        | 23         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/schemas.py`           | 8          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/services/errors.py`   | 20         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/core/templatetags/core.py` | 7          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/apps.py`            | 3          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/checks.py`          | 51         | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/urls.py`            | 5          | 0      | 100.0% | 100.0% |
| `code/src/django/apps/health/views.py`           | 24         | 0      | 100.0% | 100.0% |

### 1.3 Tests by module

_No attributed tests to list for US013._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest, Bruno, E2E or axe suite exists for this story, so none was run. The one automated check
that reads US013's change is CI's `[3/4] Template Generation` job, which renders a generated
project with `template-render.sh` (scratch only) under `INCLUDE_MOBILE=false` and `true` in one
shell loop, and fails on any token left unrendered. It runs on every push; nothing here starts it
locally. The local readings:

```bash
# Read before trusting the empty table in Section 1, then rewrite the generated block
bash code/src/scripts/audits/story-markers.sh
bash code/src/scripts/tests/test-record.sh US013

# CI — read-only, the [3/4] job's log for the pushed head
gh run view 45161301722 --log --job 137647123206
```

The per-site render counts (Bugsink 18, Fluent Bit 12, `glitchtip` 0, `sentry` 0, `loki` 10), the
Sentry sentence, the four doc gates against their P0 baselines and the live walk are **manual**
rows, read in `../MANUAL/US013-MANUAL-TESTING.md` (story plan, _Testing_ → _Where each criterion
is read_). They are not restated here.

### 2.1 CI — workflow "Audit — Template Integrity", job `[3/4] Template Generation`

Read 23/11/2026 with read-only `gh run view`. Both runs are `push` events on
`us013/log-debug-workflow-seam`; timestamps are the run's own creation time, 23/11/2026 UTC.

| Commit     | Role                                                   | Run ID        | `[3/4]` job ID | Created  | Result      | Reading                                                                                                                                                                                 |
| ---------- | ------------------------------------------------------ | ------------- | -------------- | -------- | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `9afc4e44` | **Superseded** — build P1 to P5, before review and QA  | `45158695645` | `137638184563` | 10:43:31 | **success** | `INCLUDE_MOBILE=false — 0 unrendered tokens` and `INCLUDE_MOBILE=true — 0 unrendered tokens`; all four jobs success. Superseded when review fixes F-1, F-4 and QA fixes moved the head  |
| `58f3c78e` | **Of record** — pushed head, after review and QA fixes | `45161301722` | `137647123206` | 11:01:07 | **success** | `INCLUDE_MOBILE=false — 0 unrendered tokens` and `INCLUDE_MOBILE=true — 0 unrendered tokens`; `[1/4]` Template Tokens, `[2/4]` Shipped Documentation, `[4/4]` Parser Probes all success |

**The run of record rendered `58f3c78e`, not the local head `79a22cb7`.** The one commit between
them changes only the manual guide, whose only added tokens (`DEVELOPER_NAME`, `PROJECT_SLUG`) are
defined `copier.yml` questions (the walk's RENDER-01 Notes). Re-read the `[3/4]` job once the
closeout head is pushed; until then this record's CI evidence is for `58f3c78e`.

### 2.2 Readings taken by hand

| Reading                      | Where / when                              | Result                                                                                                                                                                                               |
| ---------------------------- | ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/story-markers.sh`    | Host, 23/11/2026, `79a22cb7`              | Warn-only, exit 0: "Scanned 10 test module(s) and 7 Bruno request(s)"; "8 carry a story marker; 72 do not". `US013` occurs 0 times in its report, and 0 times as a marker in `code/src` (`git grep`) |
| `tests/test-record.sh US013` | Host, 23/11/2026, `79a22cb7`              | Exit 0, `wrote 0 test rows`; the block in Section 1 is its output, unedited                                                                                                                          |
| Diff scope                   | `git diff --name-only e306f48e..79a22cb7` | 19 files, all Markdown or `copier.yml`; no `.py`, no `.bru`, no template, no migration                                                                                                               |

**Why no test is marked US013, and why that is correct.** A story marker attributes a pytest test
or a Bruno request to a story. US013 adds neither and changes no code either could exercise: its
whole diff is documentation and one Copier comment and help line. The 72 unmarked tests the audit
lists predate this story and belong to none of its files, so marking any of them US013 would claim
a test of a change it does not exercise. The audit's silence about US013 is therefore the correct
reading, not a missing marker — and it says nothing about the CI render, which no marker can
reach.

---

## 3. Outstanding gaps and flaky tests

Every suite is `N/A`, named here with its reason rather than omitted (`code/docs/GATE-REPORTING.md`;
story plan, _Testing_).

| Item                                          | Type        | Reason / owner                                                                                                                                                                  |
| --------------------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Unit and integration (pytest)                 | `N/A`       | No code path: the diff carries no Python module                                                                                                                                 |
| Coverage figure against the floors            | `N/A`       | Nothing instruments; `code/docs/TESTING.md`'s floor has nothing to bind. The Section 1 figures are whole-project and unrelated (open bug cited in Section 1)                    |
| Migration check (`database/migrate.sh check`) | `N/A`       | No model, no migration                                                                                                                                                          |
| API (Bruno)                                   | `N/A`       | No API surface                                                                                                                                                                  |
| E2E and accessibility (axe)                   | `N/A`       | No page, route or rendered screen                                                                                                                                               |
| The `[3/4]` render absent from the block      | Tooling gap | `test-record.sh` has no source for a CI job's log, and `story-markers.sh` scans only pytest and Bruno — the gap US009, US010 and US012 recorded. Written by hand in Section 2.1 |
| CI evidence for the local head `79a22cb7`     | Pending     | The run of record rendered `58f3c78e`; re-read `[3/4]` on the pushed closeout head (Section 2.1)                                                                                |
| Rows a person walks                           | Manual      | Owned by `../MANUAL/US013-MANUAL-TESTING.md`: the 39 mechanical rows walked Pass at `79a22cb7`; WALK-01 to WALK-05 walked live by the developer; **WALK-06 pending**            |

**No flaky test is known.** Both `[3/4]` runs gave the result their commit was meant to.

**Unmarked tests are invisible here.** `story-markers.sh` was read (Section 2.2): 72 unmarked
tests, none of them US013's, and its silence says nothing about the CI render.

---

## 4. Status line

**Green**: 0 attributed tests (none possible); every automated suite `N/A` with its reason; CI
`[3/4] Template Generation` green on the pushed head `58f3c78e` (run `45161301722`, job
`137647123206`, 0 unrendered tokens under both `INCLUDE_MOBILE` values), superseding run
`45158695645` on `9afc4e44`; re-read pending on the closeout head · verified 23/11/2026.

---

## Cross-references

- `../../02-STORIES/US013.md` — the story under test
- `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the implementation plan this record closes; its _Testing_ section sets every suite `N/A`
- `../MANUAL/US013-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; its _Recorded during the build_ section holds the CI capture this record cites
- `../../11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the scenarios (HP-05, ES-04) the CI render reads
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md` — whether the specified scenarios were met
- `../../20-FINDINGS/FINDING-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md` — what shipping the story revealed
- `.github/workflows/audit-template.yml` — the `[3/4]` job, unchanged by this story
- `code/docs/GATE-REPORTING.md` — why a suite not run is named, never omitted
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
