# US010 — Test Status

_The automated-test record for US010: what each automated check proves and whether it passed. Written at `22-implementation-documentation` Step 4 on 21/11/2026, on `testing` at `7d54df26`, after PR 38 merged US010 into `testing`. US010 is a **Gate** surface: it ships Bash gates, a Python reader of `copier.yml`, `.copier/` seeds, CI wiring and documentation, and the story plan's Testing section records no pytest, no coverage figure and no migration check because there is no application Python in the diff. So no pytest or Bruno test declares US010, and its automated proof is the `.github/scripts/` self-tests, the probe runners `pm-boards.sh`, `template-hooks.sh` and `hook-arming.sh`, and the CI jobs that run them. The generator cannot see any of those, so Sections 2 and 3 carry their results by hand (this folder's `CLAUDE.md`, Guardrails)._

**Last Updated**: 21/11/2026 · **Story**: US010 · **Status**: Green

- **Story:** `../../02-STORIES/US010.md` — the seven register indexes are born seeded, and the map index leaves the file that ships
- **Story plan:** `../../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the code master this record closes the loop on
- **Branch:** `us010/seeded-register-indexes` (merged into `testing` by PR 38 at `7e88b9b3`; this record's runs are on `testing` at `7d54df26`)

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US010
```

**Read Section 2 before this block. A zero-row table here is not a small suite.** No pytest or
Bruno test declares US010, and none could: the story's tests are Bash self-tests and probe runners,
and `test-record.sh` reads only pytest JUnit XML, `story-map.json`, Bruno JSON, axe JSON and
`coverage.xml` (its header, "Reads"). The **1,000-plus probe results** that are this story's real
automated evidence are in Section 2. The coverage figures below are **whole-project** backend
figures from `backend-coverage.sh`, run for this record at 21:25 GMT on 21/11/2026 (71 unit + 22
integration passed). This story changes no module in that table, so they measure nothing it did —
the existing defect
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`. The
auth-critical row is left as the generator writes it: no Python module in the authentication,
session or permission path is in scope.

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

_No test declares `US010`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US010._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest, Bruno, E2E or axe suite exists for this story. The proof is Bash, run on the host from
the repository root. Every command below is a project script, a `.github/scripts/` gate or a
`code/src/scripts/tests/` runner; none edits the checkout. `template-integrity.sh --self-tests`
runs each self-test in a `git archive` copy of the commit, and `hook-arming.sh` builds every
fixture in its own `mktemp -d` with its own `pnpm install`.

```bash
# The nine self-tests the pre-push leg and CI [1/4] run, each in a copy of the commit
bash .github/scripts/template-integrity.sh --self-tests HEAD

# The two probe runners the ledger above includes, on their own
bash code/src/scripts/tests/pm-boards.sh          # the board, archive and freeze scripts
bash code/src/scripts/tests/template-hooks.sh     # the template's lefthook legs

# Any one gate's own self-test, e.g. the eight-board check
bash .github/scripts/shipped-boards.sh --self-test

# The hook-arming probes, with a private evidence directory (US009's runner; it still gates here)
bash code/src/scripts/tests/hook-arming.sh --output "$(mktemp -d)"
# or one fixture at a time, as this record's run was:
bash code/src/scripts/tests/hook-arming.sh --fixture hook-paths --output "$(mktemp -d)"

# Read before trusting the empty table in Section 1, then rewrite the generated block
bash code/src/scripts/audits/story-markers.sh
bash code/src/scripts/tests/backend-coverage.sh   # only to refresh the whole-project figures
bash code/src/scripts/tests/test-record.sh US010
```

`shipped-artefacts.sh` and `shipped-boards.sh` in plain mode assert on a **generated project**,
so they need a render from `template-render.sh`, which runs copier — scratch only, and measured in
CI's `[3/4]` (below). A red commit's self-test is replayed with
`template-integrity.sh --self-tests <sha>` from a checkout whose `origin/main` is fetched; the
red-then-green pairs are tabulated per round in `../MANUAL/US010-MANUAL-TESTING.md` under
_Recorded during the build_, and are not repeated here.

**The run of record: 21/11/2026, 21:16 to 21:26 GMT**, on `testing` at `7d54df26`, the tracked
tree clean (three untracked gate-22 records from parallel sessions, none read by any suite, and
this file). Every suite was run alone, one after another.

| Suite                                                              | Exit | Reading                                                                                                           |
| ------------------------------------------------------------------ | ---- | ----------------------------------------------------------------------------------------------------------------- |
| `template-integrity.sh --self-tests HEAD`                          | 0    | `9 run, 0 red, 0 absent and skipped`, 64 s                                                                        |
| `tests/pm-boards.sh`                                               | 0    | 112 probes passed                                                                                                 |
| `tests/template-hooks.sh`                                          | 0    | 69 passed, 0 failed                                                                                               |
| `check-template-tokens.sh --self-test`                             | 0    | 10 probes                                                                                                         |
| `shipped-readme.sh --self-test`                                    | 0    | 28 probes                                                                                                         |
| `shipped-memory.sh --self-test`                                    | 0    | 5 probes                                                                                                          |
| `shipped-registers.sh --self-test`                                 | 0    | 12 probes                                                                                                         |
| `shipped-boards.sh --self-test`                                    | 0    | 100 probes, 30 s                                                                                                  |
| `register-index-routes.sh --self-test`                             | 0    | passed (the script prints no count)                                                                               |
| `shipped-ai.sh --self-test`                                        | 0    | passed, 63 s (the script prints no count)                                                                         |
| `check-template-parsers.sh --self-test`                            | 0    | the probe separates a legal manifest from a tokenised one                                                         |
| `shipped-artefacts.sh --self-test`                                 | 2    | **not a result**: called without a generated project, a usage error. Measured in CI `[3/4]` only (8 probes)       |
| `tests/hook-arming.sh`, 15 fixtures one by one, private `--output` | 0/3  | **432 passed · 0 failed · 1 unmeasured**: 14 fixtures exit 0; `install-failure` exit 3, CI-only — never a pass    |
| `audits/story-markers.sh`                                          | 0    | warn-only: "Scanned 10 test module(s) and 7 Bruno request(s). 8 carry a story marker; 72 do not." None is US010's |
| `tests/backend-coverage.sh`                                        | 0    | 71 unit + 22 integration passed, 100% whole-project; no US010 module                                              |
| `tests/test-record.sh US010`                                       | 0    | `wrote 0 test rows`; the block in Section 1 is its output, unedited                                               |

`hook-arming.sh` by fixture: `manifest` 39, `A` 29, `B` 3, `C` 4, `notice` 16, `notice-streams` 9,
`hook-paths` 78, `old-backup` 81, `repo-shapes` 91, `change-filter` 10, `machine-spec` 42,
`write-boundary` 11, `graph-reclaim` 13, `binary-provenance` 6 — all 0 failed, 0 unmeasured — and
`install-failure` 0 / 0 / 1. The total matches the round-10 closing reading (432 / 0 / 1).

**CI — the automated evidence a local run cannot give.** Read on 21/11/2026 with read-only `gh run
view` and `gh pr view 38`. The push run is on `us010/seeded-register-indexes` at `6554cf9e`; PR 38's
checks ran on the same head, which merged as `7e88b9b3`.

| Workflow — job                                             | Run ID        | Result      | Reading                                                                                                                                                                                          |
| ---------------------------------------------------------- | ------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Audit — Template Integrity, push (`[1/4]` to `[4/4]`)      | `44949084218` | **success** | all four jobs green on the push — closes R7-8, pending since round 7                                                                                                                             |
| Audit — Template Integrity, PR (`[1/4]` to `[4/4]`)        | `44949241651` | **success** | `[1/4]`: tokens 10 probes, `template-hooks.sh` 69 / 0, `pm-boards.sh` 112; `[2/4]`: 28, 5, 12 and 100 probes; `[3/4]`: 8 probes, `register-index-routes.sh` passed; `[4/4]`: parser probe passed |
| PM Boards — Boards current, archive frozen; Stale statuses | `44949241388` | **success** | `pm-boards.sh: 112 probes passed`; `pm-board.sh --warn`: no stale statuses                                                                                                                       |
| Audit — Hook Arming — probes; install-failure              | `44949241529` | **success** | 15 fixture summaries, 439 passed · 0 failed · 0 unmeasured, `install-failure` 7 / 0 / 0 among them — every fixture measured                                                                      |
| Audit — Doc References — Citations resolve                 | `44949241539` | **failure** | 18 dangling-path findings, the same count as the P0 baseline and the final pass's local reading. Not this story's; see Section 3                                                                 |
| Every other check on PR 38                                 | various       | success     | incl. `test` pytest + jest-expo, Python and JS lint, markdownlint, TruffleHog, Claude Code `[1/8]` to `[8/8]`; `Claude AI` skipped                                                               |

---

## 3. Outstanding gaps and flaky tests

| Item                                                    | Type                  | Reason / owner                                                                                                                                                                                                                                                                                                                                                     |
| ------------------------------------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| pytest / Bruno attribution                              | Out of scope          | No application Python and no API surface (story plan, _Testing_), so the generated table is empty and correctly so                                                                                                                                                                                                                                                 |
| Gate self-tests and probe runners absent from the block | Tooling gap           | `test-record.sh` has no source for a Bash runner and `story-markers.sh` scans only pytest and Bruno. A Gate story's whole automated proof is invisible to both, so it is written by hand in Section 2 — the same gap US009 recorded. Finding candidate for workflow 22 Step 5                                                                                      |
| Coverage figures in Section 1                           | Misleading by design  | Whole-project figures, current (21:25 GMT, 21/11/2026) but unrelated to this story. Existing defect `../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`                                                                                                                                                                       |
| `story-map.json` written as `[]`                        | Observation           | After `backend-coverage.sh` the map is an empty list, and `test-record.sh US008 --dry-run` lists no US008 test although `config/tests/test_dev_settings.py` carries `story("US008")`. TODO(verify): not traced — whether that module is outside the run's selection or the map loses entries. Not US010's; routed to workflow 22 Step 5 for triage                 |
| `install-failure` fixture (ES-01 to ES-03)              | Measured in CI        | Refused locally (Docker, `uv`, `sudo`), exit 3 — unmeasured, never a pass. **Passed in CI, 7 / 0 / 0**, run `44949241529`                                                                                                                                                                                                                                          |
| `shipped-artefacts.sh` and plain `shipped-boards.sh`    | Measured in CI        | Need a generated project; not rendered locally for this record (copier, scratch only). Both green in CI `[2/4]`/`[3/4]`, run `44949241651`; locally they were last read at round 10 (both renders, scratch)                                                                                                                                                        |
| actionlint over the changed workflows                   | Unmeasured            | Not installed on this host, and no `code/src/scripts/**` script runs it. The workflows ran green in CI, which is not a lint                                                                                                                                                                                                                                        |
| Citations resolve (run `44949241539`)                   | Red, not this story   | 18 pre-existing dangling paths (US005's `OUTBOUND-TIMEOUTS.md`, US011's `BUG-INDEX.md`, US014's test module, …), count identical to US010's P0 baseline. TODO(verify): the CI list was counted, not diffed line by line against P0; the final pass's local `diff` was                                                                                              |
| The 2 s timing probes in `shipped-boards.sh`            | Flaky (load)          | Round 10: `05751282` replayed red once among four concurrent `--self-tests` runs (36 self-tests on 16 cores) and green alone; which probe failed is unmeasured, the shape points at one of the three 2 s timing probes (rounds 8, 9, 10). Not reproduced in two load runs, and green in this record's run alone and in CI. Widening a budget is a probe edit, left |
| Planning-time "no merge-strategy rule exists" lines     | Documented, untouched | In US010's plan (_Risks_) and twice in US011's; now untrue, flagged for Sam (manual guide, round 10 and final pass)                                                                                                                                                                                                                                                |
| Every valid offered configuration (72 cases)            | Moved out of scope    | Moved 19/11/2026 to `../../01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md`; not a US010 criterion, unmeasured until that slice lands                                                                                                                                                                                                                                   |
| API (Bruno), E2E, accessibility suites                  | Out of scope          | No endpoint, route or rendered screen                                                                                                                                                                                                                                                                                                                              |
| Rows a person walks                                     | Manual                | Owned by `../MANUAL/US010-MANUAL-TESTING.md`, walked at this gate, not this record                                                                                                                                                                                                                                                                                 |

**No other flaky test is known.** The one non-deterministic result seen is the load-sensitive
timing probe above; every suite in Section 2 was run alone.

**Unmarked tests are invisible here.** `story-markers.sh` was read (Section 2): 72 unmarked tests,
none of them US010's, and its silence says nothing about the Bash suites.

---

## 4. Status line

**Green**: 0 attributed tests (none possible); `template-integrity.sh --self-tests HEAD` 9 run, 0
red; `pm-boards.sh` 112, `template-hooks.sh` 69 / 0, `shipped-boards.sh` 100 probes;
`hook-arming.sh` 432 / 0 locally with 1 unmeasured (`install-failure`, CI-only) and 439 / 0 / 0 in
CI. CI green on push run `44949084218` and PR 38's template, boards and hook-arming runs; Citations
resolve red on 18 pre-existing findings, not this story's; actionlint unmeasured · verified
21/11/2026.

---

## Cross-references

- `../../02-STORIES/US010.md` — the story under test
- `../../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the implementation plan this record closes
- `../MANUAL/US010-MANUAL-TESTING.md` — the paired manual testing guide, with every fix round's red-then-green table; a manual `Fail` beside a green suite is a missing test
- `../../11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — owns the scenario IDs the guide cites
- `../../15-DECISIONS/ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md` — the re-cut decision the boards implement
- `.github/scripts/template-integrity.sh` — the self-test ledger and its `--self-tests <sha>` replay
- `.github/workflows/audit-template.yml` · `.github/workflows/pm-boards.yml` · `.github/workflows/audit-hook-arming.yml` — the CI jobs cited above
- `code/docs/GATE-REPORTING.md` — why an unmeasured result is never reported as a pass
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
