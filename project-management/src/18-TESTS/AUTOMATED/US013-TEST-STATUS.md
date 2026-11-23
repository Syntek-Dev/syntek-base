# US013 — Test Status

_The automated-test record for US013: what each automated check proves and whether it passed. Rewritten at `22-implementation-documentation` Step 4 on 23/11/2026, on `us013/log-debug-workflow-seam` at `275e2548`. US013 began as a documentation-only change to workflow `09-debugging-with-logs` and was **widened at build** to run graphify beside code-review-graph in the per-edit graph hook, `.claude/hooks/graph-update.sh`, and in lefthook's pre-commit leg. That widening brought an automated suite: `code/src/scripts/tests/graph-update.sh`, 27 probe groups over the hook, plus edits to two sibling suites, `template-hooks.sh` and `hook-arming.sh`. All three are shell probe suites. None writes a JUnit, Bruno or axe artefact, and none can carry a story marker, so the generated block below stays empty and Sections 2 and 3 carry the suites by hand (this folder's `CLAUDE.md`, Guardrails)._

**Last Updated**: 23/11/2026 · **Story**: US013 · **Status**: Green — one CI-only case unmeasured on the host and measured in CI (Section 3)

- **Story:** `../../02-STORIES/US013.md`. The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause; widened 23/11/2026 to cover graphify beside code-review-graph
- **Story plan:** `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`, the code master this record closes the loop on (P0 to P6 for the workflow seam, P7 to P13 for graphify)
- **Manual guide:** `../MANUAL/US013-MANUAL-TESTING.md`. The render counts, the doc gates, the live walk (WALK-01 to WALK-06) and the graphify rows (GRAPH-01 to GRAPH-10) are read there. It also holds the P8 red-run capture this record cites
- **Bug report:** `../../21-BUGS/archive/BUG-US013-GRAPHIFY-HOOK-HUNG-RUN-SILENT-23-11-2026.md`, the hung-run fix (`a3a4f86d`) and its two red loops
- **Branch:** `us013/log-debug-workflow-seam`, cut from `dev` at `e306f48e`; pushed closeout head `aae0b8c0` (the host suite figures below were taken at `275e2548`)

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts. **Never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US013
```

**Read Section 2 before this block. A zero-row table here is not a small suite.** US013's suites
are shell probes, and the generator reads only pytest JUnit, Bruno JSON, axe JSON and
`coverage.xml`. `story-markers.sh` scans only pytest modules and Bruno requests. So the 199 + 69 +
432 checks US013 runs (Section 2) are invisible to both tools by construction. This is not a
missing marker. The coverage figures below are **whole-project** backend figures from the
`coverage.xml` already on disk (written 09:06 GMT, 23/11/2026, by a run that was not this
story's). They measure nothing US013 did: see the open defect
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`. The
auth-critical row is left as the generator writes it, because no module in the authentication,
session or permission path is in scope.

The floors are **one floor, not one per layer**. Template, django-component and HTMX-partial
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

Every figure below was read on the host on 23/11/2026, from runs started for this record at
`275e2548`. The working tree differed from it only in `GAPS.md` and the findings record, and
neither is read by any suite. Every check that has no suite of its own is a **manual** row in
`../MANUAL/US013-MANUAL-TESTING.md`. That covers the per-site render counts, the Sentry sentence,
the four doc gates against their P0 baselines, the live walk and the graphify reads. Those rows
are not restated here.

```bash
# The three suites US013 adds or touches (each exits 0 pass, 1 fail, 2 script error;
# hook-arming.sh also exits 3 when a case could not look)
bash code/src/scripts/tests/graph-update.sh
bash code/src/scripts/tests/template-hooks.sh
bash code/src/scripts/tests/hook-arming.sh

# Read before trusting the empty table in Section 1, then rewrite the generated block
bash code/src/scripts/audits/story-markers.sh
bash code/src/scripts/tests/test-record.sh US013

# CI (read-only): the Template Integrity run on the pushed head and its [3/4] log
gh run view 45259596605 --log --job 137990480404
```

### 2.1 The suites, run on the host

| Suite                     | What US013 did to it                                                                                                                                             | Exit  | Result                                                                                                                                  |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `tests/graph-update.sh`   | **New** (`e6f18b76`, then extended by `5b622651`, `933df1e8` and `a3a4f86d`): 27 probe groups over `.claude/hooks/graph-update.sh`, each in its own scratch copy | **0** | **199 passed, 0 failed**                                                                                                                |
| `tests/template-hooks.sh` | Adds `graph-update.sh` to the self-tests the pre-push leg must run, and stubs it in the push fixture                                                             | **0** | **69 passed, 0 failed**                                                                                                                 |
| `tests/hook-arming.sh`    | Hides `graphify` (and its `graphify-*` siblings) from `PATH` for the whole suite, so no commit fixture starts a real refresh (`5b622651`)                        | **3** | **432 passed, 0 failed, 1 unmeasured**: `[ES-01]` is CI-only, because root `install.sh` needs Docker, `uv` and `sudo tee -a /etc/hosts` |

`graph-update.sh`'s fixture is a `git archive HEAD` extraction with the **working-tree** hook
copied over its committed one, plus `git init`. `graphify` and `code-review-graph` are stubs
that record their argv, and the real tools are hidden from `PATH` and never invoked. No `.env.*`
file is read. The suite's own header lists the probes. What each group checks:

| Probe group                                                        | Source of the probe               | Checks                                                                                                                                                                                                                                                                                                         |
| ------------------------------------------------------------------ | --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `absent`, `refuse`, `fail`                                         | P8, QA plan HP-16, ES-10 to ES-13 | An absent graphify, a refusal to overwrite and a failed run are each reported **unmeasured**, with their reason, once per change of state. Exit is always 0 and no line carries `--force`                                                                                                                      |
| `lock`, `success`, `detached`                                      | P8                                | A run in flight stops a second run, and only the lock can stop it. A run starts as `graphify update .` at the root and says nothing on success. The hook returns inside 2 s with its streams closed, and the stub was still started                                                                            |
| `regression`, `one-json`                                           | P8                                | code-review-graph's `update --skip-flows` and the untracked notice are unchanged. Two notices in one call are still **one** JSON object                                                                                                                                                                        |
| `fp`, `commit`, `nolock`, `rc`, `atomic`                           | Review M1, M2, m5, n1, n2         | A finished run on an unchanged tree is never restarted. `--commit` (lefthook) reports a not-ok outcome on every commit and never calls code-review-graph. A missing `flock` is unmeasured. A non-numeric code still gives one valid JSON line. The outcome and exit code are one file, written with one rename |
| `env-force`, `git-locks`, `killed`, `content`, `newline`, `setsid` | QA Q1, Q3 to Q7, Q12              | An exported `GRAPHIFY_FORCE` is unset before the run. No hook git call takes `.git/index.lock`. A killed run reads unmeasured and retries the same tree. The fingerprint is content, not HEAD. The trailer is its own line. `setsid` is used when present and not required                                     |
| `timeout`, `notimeout`, `mktemp`, `lockwait`                       | Bugfix loop 1                     | A hung run is bounded and reported as timed out, never `ok`. A missing `timeout` is unmeasured and starts nothing. A failed `mktemp` records a failure and does not loop. A brief lock does not cancel a run                                                                                                   |
| `timeout-kill`, `timeout-reader`, `rc124`, `timeout-env`           | Bugfix loop 2                     | A TERM-ignoring run is SIGKILLed after the grace (`exit=137`). A reader with no override reports the bound recorded at the time. graphify's own exit 124 is a failure, not a timeout. Malformed bounds fall back to 600 s                                                                                      |

### 2.2 Red runs: each probe seen failing before its fix

| Probes                                                       | Run against                                                              | Result                                                                                                                                                                     | Where recorded                                           |
| ------------------------------------------------------------ | ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| P8: the first 8 groups                                       | The **unedited hook at `83aafd23`**, suite by a dispatched `test-writer` | **Exit 1, 33 passed, 18 failed.** Every graphify probe failed because that hook never starts or reports graphify. `regression` passed 7 of 7, as it should before the edit | Manual guide, _Recorded during the build_ (row GRAPH-02) |
| Review fixes: `fp` to `atomic`                               | The hook at `b04b278b`, as built                                         | 19 checks red; green 102 passed, 0 failed                                                                                                                                  | Commit message of `5b622651` only                        |
| QA fixes: `env-force` to `setsid`, and a strengthened `lock` | The hook at `5b622651`                                                   | 17 checks red. Mutants show the `lock`, `setsid` and untracked probes catch a broken hook. Green 146 passed, 0 failed, twice                                               | Commit message of `933df1e8` only                        |
| Bugfix loop 1                                                | The hook before `a3a4f86d`                                               | 151 passed, 14 failed                                                                                                                                                      | BUG report Section 7                                     |
| Bugfix loop 2                                                | The loop-1 fix                                                           | 187 passed, 12 failed                                                                                                                                                      | BUG report Section 7                                     |

**Only the P8 groups were ever seen red against the unedited hook.** Every group added after
P8 — by the review fixes, the QA fixes and bugfix loops 1 and 2, nineteen in all — was seen red
only against the hook as it stood at that moment, never against `83aafd23`. Each still failed before its fix and
passes after it, so the red-first discipline held. But the claim "this probe fails on the hook
before US013" has been measured for P8 alone (Section 3). The review and QA reds are recorded
only in commit messages, not under the manual guide's _Recorded during the build_.

### 2.3 CI: workflow "Audit — Template Integrity" and "Audit — Hook Arming"

Read 23/11/2026 with read-only `gh run list` and `gh run view`. `graph-update.sh` and
`template-hooks.sh` run as template self-tests inside the `[1/4] Template Tokens` job.
`[3/4] Template Generation` renders a generated project with `INCLUDE_MOBILE=false` and `true`
and fails on any unrendered token. Times are each run's creation time, UTC.

| Commit     | Role                                                         | Run ID        | Event          | Created  | Conclusion  | Reading                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ---------- | ------------------------------------------------------------ | ------------- | -------------- | -------- | ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `aae0b8c0` | **Of record**: the pushed closeout head                      | `45259596605` | `push`         | 20:27:41 | **success** | `[3/4]` job `137990480404`: `INCLUDE_MOBILE=false — 0 unrendered tokens` and `INCLUDE_MOBILE=true — 0 unrendered tokens`. All four jobs success                                                                                                                                                                                                                                                                                                                      |
| `aae0b8c0` | The same head, as PR #43 into `dev` (merge commit `c35409e`) | `45259607288` | `pull_request` | 20:27:45 | **success** | `[3/4]` job `137990516078`: the same two lines, 0 unrendered tokens each. All four jobs success                                                                                                                                                                                                                                                                                                                                                                      |
| `aae0b8c0` | Hook Arming: the CI half of `hook-arming.sh`                 | `45259607098` | `pull_request` | 20:27:45 | **success** | Job "Hook-install failure stops install.sh (ES-01 to ES-03)" `137990611580`: `[ES-01]` PASS. This is where the host's unmeasured `[ES-01]` is measured                                                                                                                                                                                                                                                                                                               |
| `aae0b8c0` | **Known red**: Audit — Doc References                        | `45259607225` | `pull_request` | 20:27:45 | **failure** | Job `137990515362`: 24 `[dangling path]` findings — the 21 P0-baseline findings (US004 open, read as a diff) plus 3 from `DEFERRED.md`:50, a row added at `aae0b8c0` that quoted three of the baseline's paths (F-038). The row has since been rewritten with the paths unquoted, and `doc-references.sh --path DEFERRED.md` is clean (uncommitted), so the next head returns to the 21 baseline findings. The baseline itself is deferred to US014 in `DEFERRED.md` |
| `275e2548` | Superseded: the earlier pushed head                          | `45247839004` | `push`         | 19:20:06 | **success** | `[3/4]` job `137949216724`: 0 unrendered tokens under both values. `[1/4]` job `137949217154` logs `69 passed, 0 failed` and `199 passed, 0 failed`                                                                                                                                                                                                                                                                                                                  |
| `275e2548` | Superseded: the same head, as the PR                         | `45247933958` | `pull_request` | 19:20:35 | **success** | `[3/4]` job `137949533219`: the same two lines                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `275e2548` | Superseded: Hook Arming                                      | `45247933816` | `pull_request` | 19:20:35 | **success** | Job `137949790663`: 7 passed, 0 failed, 0 unmeasured                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `90399980` | Superseded: the walk commit                                  | `45247290781` | `push`         | 19:16:59 | **success** | `[3/4]` job `137947302870`: 0 unrendered tokens under both values                                                                                                                                                                                                                                                                                                                                                                                                    |

`aae0b8c0`'s 27 runs: 26 success, 1 failure (the Doc References run above). Earlier runs, all success and all superseded: `45204954080`
(`26d7237c`), `45161301722` (`58f3c78e`), `45158695645` (`9afc4e44`).

### 2.4 Readings taken by hand

| Reading                      | Where / when                             | Result                                                                                                                                                                                                     |
| ---------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `audits/story-markers.sh`    | Host, 23/11/2026, `275e2548`             | Warn-only, exit 0: "Scanned 10 test module(s) and 7 Bruno request(s)"; "8 carry a story marker; 72 do not". `US013` occurs 0 times in its report. It scans no shell suite, so it cannot see US013's probes |
| `tests/test-record.sh US013` | Host, 23/11/2026, after the three suites | Exit 0, `wrote 0 test rows`. The block in Section 1 is its output, unedited                                                                                                                                |

**Why no test is marked US013.** A story marker attributes a pytest test or a Bruno request to a
story. US013 adds neither. Its tests are shell probes, which have no marker syntax
(`code/docs/testing/TAXONOMY.md`), and the 72 unmarked tests the audit lists predate the story
and exercise none of its files. The empty block is therefore the correct reading. Section 2.1 is
the record of what ran.

---

## 3. Outstanding gaps and flaky tests

Every suite not run, and every claim not measured, is named here with its reason rather than
omitted (`code/docs/GATE-REPORTING.md`).

| Item                                                                        | Type        | Reason / owner                                                                                                                                                               |
| --------------------------------------------------------------------------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Unit and integration (pytest)                                               | `N/A`       | No code path. The diff carries no Python module                                                                                                                              |
| Coverage figure against the floors                                          | `N/A`       | Nothing instruments a shell hook. The Section 1 figures are whole-project and unrelated (open bug cited in Section 1)                                                        |
| Migration check, API (Bruno), E2E and axe                                   | `N/A`       | No model, no API surface, no page                                                                                                                                            |
| `hook-arming.sh` `[ES-01]` on the host                                      | Unmeasured  | CI-only by design (Docker, `uv`, `/etc/hosts`). Measured green in CI run `45259607098` at `aae0b8c0`, job `137990611580` (Section 2.3), so it is unmeasured on the host only |
| Probes added after P8 (review, QA, bugfix loops 1 and 2) against `83aafd23` | Unmeasured  | Seen red only against the hook as it stood before each fix, never against the unedited hook. Section 2.2 explains why the red-first discipline still held                    |
| Review and QA red runs outside the manual guide                             | Record gap  | 19 and 17 red checks are recorded in commit messages only (`5b622651`, `933df1e8`), with no capture under _Recorded during the build_ and no full counts for the red runs    |
| Shell suites absent from the generated block                                | Tooling gap | `test-record.sh` reads no shell suite output and `story-markers.sh` scans none, so the suites are written by hand in Section 2.1                                             |
| Rows a person walks                                                         | Manual      | Owned by `../MANUAL/US013-MANUAL-TESTING.md`: WALK-01 to WALK-06 Pass, GRAPH-01 to GRAPH-10 Pass; GRAPH-05 walked from the closeout commit `aae0b8c0`'s pre-commit output    |
| Two Low defects left open by the bugfix                                     | Deferred    | Findings F-018 and F-019, routed to `GAPS.md` (BUG report Section 8). Neither is probed                                                                                      |

**No flaky test is known.** `graph-update.sh` gave 199 of 199 on this run, as it did on the
fixer's three runs and the independent QA pass's three (BUG report Section 7). The slow
`timeout-kill` probe waits on the hook's real 10 s kill grace, and that grace is its only timing
margin.

---

## 4. Status line

**Green**: 0 attributed tests (shell probes carry no marker). `graph-update.sh` exit 0 with 199
passed and 0 failed; `template-hooks.sh` exit 0 with 69 passed and 0 failed; `hook-arming.sh`
exit 3 with 432 passed, 0 failed and 1 unmeasured (`[ES-01]`, CI-only, green in CI run
`45259607098`, job `137990611580`). CI Template Integrity is green on the pushed closeout head
`aae0b8c0` (push run `45259596605`, `[3/4]` job `137990480404`; PR run `45259607288`, `[3/4]` job
`137990516078`; 0 unrendered tokens under both `INCLUDE_MOBILE` values). Audit — Doc References
is a known red on that head (run `45259607225`: the 21 baseline findings plus 3 from
`DEFERRED.md`:50, since corrected; the baseline deferred to US014). Red-first was
seen against the unedited hook for P8 only (Section 3) · verified 23/11/2026.

---

## Cross-references

- `../../02-STORIES/US013.md`: the story under test
- `../../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`: the implementation plan this record closes
- `../MANUAL/US013-MANUAL-TESTING.md`: the paired manual testing guide, authored before code and walked after it. Its _Recorded during the build_ section holds the P8 red capture
- `../../21-BUGS/archive/BUG-US013-GRAPHIFY-HOOK-HUNG-RUN-SILENT-23-11-2026.md`: the hung-run bug, its two red loops and the green re-runs
- `../../11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`: the scenarios the probes cite (HP-16, ES-10 to ES-13) and the CI render reads (HP-05, ES-04)
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md`: whether the specified scenarios were met
- `../../20-FINDINGS/archive/FINDING-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md`: what shipping the story revealed
- `code/src/scripts/tests/graph-update.sh`: the probe suite; its header lists every group
- `.claude/hooks/graph-update.sh`: the hook under test
- `.github/workflows/audit-template.yml` · `.github/workflows/audit-hook-arming.yml`: the CI jobs read in Section 2.3
- `code/docs/GATE-REPORTING.md`: why a suite not run is named, never omitted
- `code/src/scripts/tests/CLAUDE.md`: the runners, their exit-code contract, and the generator
