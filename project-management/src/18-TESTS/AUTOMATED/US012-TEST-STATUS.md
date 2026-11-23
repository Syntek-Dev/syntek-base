# US012 — Test Status

_The automated-test record for US012: what each automated check proves and whether it passed. Written at `22-implementation-documentation` Step 4 on 22/11/2026, on `us012/seed-presence-gate` at `4dc043c8`. US012 is a **Gate** surface: it changes one Bash script, `.github/scripts/shipped-artefacts.sh`, and the story plan's Testing section records no pytest, no coverage figure and no migration check, because there is no Python in the diff. So no pytest or Bruno test declares US012, and its automated proof is the script's own `--self-test` and full run in CI's `[3/4] Template Generation` job, plus four readings taken by hand. The generator cannot see any of those, so Sections 2 and 3 carry them (this folder's `CLAUDE.md`, Guardrails)._

**Last Updated**: 22/11/2026 · **Story**: US012 · **Status**: Green

- **Story:** `../../02-STORIES/US012.md` — a seeded file that never lands is reported, and the gate's header claim becomes true
- **Story plan:** `../../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` — the code master this record closes the loop on
- **Branch:** `us012/seed-presence-gate`, cut from `dev` at `8e0da02b`; landing head `4dc043c8`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US012
```

**Read Section 2 before this block. A zero-row table here is not a small suite.** No pytest or
Bruno test declares US012, and none could: the story's test is a Bash `--self-test` probe, and
`test-record.sh` reads only pytest JUnit XML, `story-map.json`, Bruno JSON, axe JSON and
`coverage.xml`. The coverage figures below are **whole-project** backend figures from the
`coverage.xml` already on disk (written 17:39 GMT, 22/11/2026, by a run that was not this story's).
This story changes no Python module, so they measure nothing it did — the existing defect
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

_No test declares `US012`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US012._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest, Bruno, E2E or axe suite exists for this story. The self-test and the full run assert on
a **generated project**, which only CI's `[3/4]` job renders here (`template-render.sh`, scratch
only); run locally without one, `--self-test` exits 2 as a usage error, which is not a result. The
local readings need no tree:

```bash
# Local — needs no generated tree
bash .github/scripts/shipped-artefacts.sh --help
bash -n .github/scripts/shipped-artefacts.sh
shellcheck .github/scripts/shipped-artefacts.sh   # host tool; no project script runs it
bash code/src/scripts/audits/doc-references.sh --path .github/scripts/shipped-artefacts.sh

# CI — the [3/4] Template Generation job on the pushed us012/ branch runs these
#   bash .github/scripts/shipped-artefacts.sh --self-test "$RUNNER_TEMP/gen-false"            # audit-template.yml:269
#   bash .github/scripts/shipped-artefacts.sh "$RUNNER_TEMP/gen-false" "$RUNNER_TEMP/gen-true" # audit-template.yml:272

# Read before trusting the empty table in Section 1, then rewrite the generated block
bash code/src/scripts/audits/story-markers.sh
bash code/src/scripts/tests/test-record.sh US012
```

The two trees are rendered by `template-render.sh --ref HEAD --data INCLUDE_MOBILE=<false|true>`
with that script's default answers (`audit-template.yml`, _Generate a project both ways_). The
self-test reads `gen-false` alone.

### 2.1 CI — workflow "Audit — Template Integrity", job `[3/4] Template Generation`

Read 22/11/2026 with read-only `gh run view <run> --log --job <job>`. Every timestamp is the log's
own, 22/11/2026 UTC.

| Commit     | Role                                    | Run ID        | Job ID         | Result      | Reading                                                                                                                                                                                                                                                                       |
| ---------- | --------------------------------------- | ------------- | -------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `81cc0079` | **Red** — the probe alone               | `45058050943` | `137317593803` | **failure** | Self-test step: the baseline and eight probes `✓`; the new probe `✗ check 4 fires when a seeded file does not land produced 0 finding(s): (none);` (18:59:42); "the detector no longer separates a clean generation from a leaking one"; `Process completed with exit code 1` |
| `17a20ed7` | **Green** — the loop                    | `45058371338` | `137318560851` | **success** | `✓ check 4 fires when a seeded file does not land` (19:02:59); `✓ Self-test passed — 9 probes: every check fires on its own mutation.`; full run: both trees `✓`, `✓ A generated project receives empty artefact trees.`                                                      |
| `c75c7972` | Header, `--help`, closing guidance      | `45058856280` | `137320033628` | **success** | As green: 9 probes, both trees clean                                                                                                                                                                                                                                          |
| `4dc043c8` | **Landing head** — review comment fixes | `45060223669` | `137324247539` | **success** | As green: `✓ Self-test passed — 9 probes …` (19:22:36); full run both trees `✓` (19:22:37-38); `✓ A generated project receives empty artefact trees.`                                                                                                                         |

**The red is the probe's, not the wrong-reason red.** No `mv: cannot stat` line appears in any of
the four logs (counted: 0 in each), so the red run reached the probe with every seed present
(QA plan ES-05, AC-GAP-3). The probe count is the amended **9 where it counted 8** (story,
amendment of 22/11/2026): the red run's eight passing probes are checks 2, 3, 3b, 4, 5, 6 and two
for check 1. The probe's text is identical in the red and green commits — `17a20ed7` touches
`run_checks()` alone, and `4dc043c8` changes comment lines only in `self_test()`.

### 2.2 Readings taken by hand

| Reading                                                                                  | Where / when                                   | Result                                                                                                                                                                                   |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Parse check, `bash -n .github/scripts/shipped-artefacts.sh`                              | Host, at `c75c7972`, `4dc043c8` and 22/11/2026 | Clean — the one reading that parses the closing guidance, which no green run prints                                                                                                      |
| ShellCheck 0.11.0 (`/run/current-system/sw/bin/shellcheck`) over the script              | Host, at `c75c7972`, `4dc043c8` and 22/11/2026 | Clean, no findings. **A host-tool reading, not a `lint.sh` pass** — no project script runs ShellCheck                                                                                    |
| String test (EC-07 positive half)                                                        | Host, 22/11/2026                               | `[[ "project-management/src/21-BUGS/BUGS-BOARD.md did NOT ship — …" == *"21-BUGS/BUGS-BOARD.md was seeded but did not land"* ]]` does **not** match: the named-file copy fails the probe |
| No-negation read (EC-07 negative half; the finding and the closing guidance)             | Code review, `4dc043c8`                        | **Read, not asserted** (story AC-GAP-2): neither advises a `!` negation for a seed                                                                                                       |
| Scoped citations, `audits/doc-references.sh --path .github/scripts/shipped-artefacts.sh` | Host, P3                                       | Clean — hygiene over a file that never ships, not the ADR-US003 citation regime (story plan, _Testing_)                                                                                  |
| `--help` (HEADER-01)                                                                     | Host, 22/11/2026                               | Exit 0; `--self-test` line names "move a seeded file away"; exit line names "a seeded file that did not land"                                                                            |
| `audits/story-markers.sh`                                                                | Host, 22/11/2026                               | Warn-only, exit 0: "Scanned 10 test module(s) and 7 Bruno request(s)"; "8 carry a story marker; 72 do not". None is US012's, and none could be                                           |
| `tests/test-record.sh US012`                                                             | Host, 22/11/2026                               | Exit 0, `wrote 0 test rows`; the block in Section 1 is its output, unedited                                                                                                              |

---

## 3. Outstanding gaps and flaky tests

| Item                                             | Type                | Reason / owner                                                                                                                                                                                                                                                                                              |
| ------------------------------------------------ | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Every valid offered configuration (72 cases)     | **Unmeasured**      | Moved 19/11/2026 to `../../01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md` slice S-01, uncut. CI renders two trees (`INCLUDE_MOBILE` false and true); the nine-probe self-test is proof over one, the full run over two, and neither stands in for the 72. Items stay unticked (story, amendment of 19/11/2026) |
| Coverage figure                                  | `N/A`               | No Python in the diff; `code/docs/TESTING.md`'s floor has nothing to bind (story plan, _Testing_). The Section 1 figures are whole-project and unrelated                                                                                                                                                    |
| Migration check (`database/migrate.sh check`)    | `N/A`               | No model, no migration (`DB: N/A`)                                                                                                                                                                                                                                                                          |
| pytest / Bruno attribution                       | Out of scope        | No application Python and no API surface, so the generated table is empty and correctly so                                                                                                                                                                                                                  |
| The self-test and full run absent from the block | Tooling gap         | `test-record.sh` has no source for a Bash runner, and `story-markers.sh` scans only pytest and Bruno — the gap US009 and US010 recorded. Written by hand in Section 2                                                                                                                                       |
| Self-test or full run on the host                | Unmeasured locally  | Both need a generated project, rendered only in CI here. Measured in CI (Section 2.1), never on the host                                                                                                                                                                                                    |
| Probe blind spots (QA-02)                        | Known limit         | A check-4 loop reading only the last `SEEDED` entry, or testing `-e` instead of `-f` (missing EC-04's seed-as-directory), still passes the self-test; caught at review only. `../../20-FINDINGS/archive/FINDING-US012-SEED-PRESENCE-GATE-22-11-2026.md` F-005                                               |
| A seed landing as a symlink to a file (QA-03)    | Known limit         | Passes checks 3 and 4; pre-existing, and Copier's `mv` cannot produce one. F-006                                                                                                                                                                                                                            |
| EC-08, an emptied `SEEDED`                       | Accepted limitation | The probe's subscript aborts under `set -u`; retiring the last seed removes the probe in the same change (QA plan, story plan _Deferred Items_)                                                                                                                                                             |
| API (Bruno), E2E, accessibility suites           | Out of scope        | No endpoint, route or rendered screen                                                                                                                                                                                                                                                                       |
| Rows a person walks                              | Manual              | Owned by `../MANUAL/US012-MANUAL-TESTING.md`, walked at this gate                                                                                                                                                                                                                                           |

**No flaky test is known.** Each of the four `[3/4]` runs gave the result its commit was meant to.

**Unmarked tests are invisible here.** `story-markers.sh` was read (Section 2.2): 72 unmarked
tests, none of them US012's, and its silence says nothing about the Bash self-test.

---

## 4. Status line

**Green**: 0 attributed tests (none possible); `shipped-artefacts.sh --self-test` red at
`81cc0079` (run `45058050943`, the probe's own zero-finding line) then green at `17a20ed7` (run
`45058371338`, 9 probes), and green at the landing head `4dc043c8` (run `45060223669`, 9 probes,
full run clean over both trees); `bash -n` and ShellCheck clean; string test passes; coverage and
migration `N/A`; exhaustive 72-case generation **unmeasured** · verified 22/11/2026.

---

## Cross-references

- `../../02-STORIES/US012.md` — the story under test, with its amendments of 19/11/2026 (72 cases) and 22/11/2026 (probe count 8 -> 9)
- `../../17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md` — the implementation plan this record closes
- `../MANUAL/US012-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; a manual `Fail` beside a green suite is a missing test
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US012-SEED-PRESENCE-GATE-22-11-2026.md` — whether the specified scenarios were met
- `../../20-FINDINGS/archive/FINDING-US012-SEED-PRESENCE-GATE-22-11-2026.md` — what shipping the story revealed
- `.github/scripts/shipped-artefacts.sh` — the one changed file · `.github/workflows/audit-template.yml` — the `[3/4]` job, unchanged
- `code/docs/GATE-REPORTING.md` — why an unmeasured result is never reported as a pass
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
