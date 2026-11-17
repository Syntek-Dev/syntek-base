# US009 — Test Status

_The automated-test record for US009: what each automated check proves and whether it passed. Written at `22-implementation-documentation` Step 4. The story ships Bash, manifest lines, a CI workflow and documentation, with no Python in the diff (the story plan's Testing section). So no pytest or Bruno test declares it, and its automated proof is the probe runner `code/src/scripts/tests/hook-arming.sh`. The generator has no source for that runner. Sections 2 and 3 carry its results instead of leaving the record empty (the Guardrails of this folder's `CLAUDE.md`)._

**Last Updated**: 17/11/2026 · **Story**: US009 · **Status**: Green

- **Story:** `../../02-STORIES/US009.md` — the git hooks arm on purpose at install, and the README claim that they already do becomes true
- **Story plan:** `../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the code master this record closes the loop on
- **Branch:** `us009/hook-arming`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US009
```

**Read Section 3 before this block.** No test declares US009, and none could. The story's suite is
the Bash probe runner `hook-arming.sh`, and `test-record.sh` reads only pytest JUnit XML,
`story-map.json`, Bruno JSON, axe JSON and `coverage.xml` (its header, lines 46 to 51). The 371
probe results are therefore in Section 2, not in this block. The coverage figures below are
**whole-project** backend figures read from a `coverage.xml` dated 16/11/2026, **before this
record's run and from another story's regression run**. This story changes no module in the
table, so they measure nothing it did (the same defect US008 recorded:
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`). The
auth-critical row is left as the generator writes it, because no Python module is in scope.

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

_No test declares `US009`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US009._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest, Bruno, E2E or axe suite exists for this story. The proof is one Bash runner, run on the
host from the repository root. Every fixture is a snapshot copied into its own `mktemp -d` scratch
tree with **its own** `pnpm install`. Nothing from the checkout is symlinked or shared into a
fixture, and a tripwire exits 2 if the checkout's `node_modules` changed during the run. It never
runs the root `install.sh` beyond `--spec` against a scratch copy, and it never arms this working
tree.

```bash
# The full suite (every fixture, default --fixture all); exit 0 pass, 1 fail, 2 error, 3 unmeasured
bash code/src/scripts/tests/hook-arming.sh

# One fixture: manifest, A, B, C, notice, notice-streams, hook-paths, old-backup, repo-shapes,
# change-filter, machine-spec, write-boundary, graph-reclaim, binary-provenance, install-failure
bash code/src/scripts/tests/hook-arming.sh --fixture hook-paths

# A private evidence directory, needed whenever another run may be in flight (Section 3)
bash code/src/scripts/tests/hook-arming.sh --output "$(mktemp -d)"

# CI's change filter for the install-failure job: prints true or false for BASE..HEAD
bash code/src/scripts/tests/hook-arming.sh --needs-install-failure origin/testing

# Read before trusting the empty table in Section 1, then rewrite the generated block
bash code/src/scripts/audits/story-markers.sh
bash code/src/scripts/tests/test-record.sh US009
```

`binary-provenance` needs registry access and `strace`. `install-failure` is **CI-only**, because
the root `install.sh` needs a Docker daemon, `uv` and `sudo tee -a /etc/hosts`. Locally that
fixture refuses unless `--allow-install-sh` is given, and reports itself unmeasured. The default
evidence directory is `code/src/scripts/tests/reports/hook-arming/`, which is gitignored.

ShellCheck has **no project script** (`syntax/lint.sh` has no shell leg). It was run by hand and is
recorded as run, never as a `lint.sh` pass:

```bash
shellcheck code/src/scripts/development/install-hooks.sh code/src/scripts/tests/hook-arming.sh install.sh
```

**The run of record: 17/11/2026, at workflow 23**, on `us009/hook-arming` at `160c730` with a
clean working tree and a private `--output` directory, and the CI re-run on the same commit.
This replaces the closeout's run of record (17:20:15 to 17:29:20 GMT at `fd11604` plus parallel
sessions' uncommitted edits, 371 / 0 / 1); the review fixes between them added the QA-01, QA-02,
CR-01 to CR-05 probes.

> **Summary (local, `160c730`, 17/11/2026): 429 passed · 0 failed · 1 unmeasured** (runner exit 3;
> the one unmeasured is `install-failure`, CI-only). **In CI (CI run `44174073751` on PR #37 at `160c730`): 429 passed · 0 failed ·
> 0 unmeasured in the probes job, and `install-failure` 7 passed · 0 failed · 0 unmeasured** — every
> fixture measured. The tripwire did not fire. Re-run at workflow 23 after the review fixes; the
> closeout reading at `fd11604` was 371 / 0 / 1.

| Fixture             | Pass               | Fail | Unmeasured     | Covers                                                                                                       |
| ------------------- | ------------------ | ---- | -------------- | ------------------------------------------------------------------------------------------------------------ |
| `manifest`          | 39                 | 0    | 0              | ST01 to ST03, ST02b, ST07, the `install.sh` numbering, the README edits; CR-01, CR-03, CR-05, QA-01 manifest |
| `A`                 | 26                 | 0    | 0              | HP-02, HP-03, HP-04 / EC-06, EC-03, EC-07 (`--spec`), EC-01 worktree, ES-04, S-M2 (never a `PATH` lefthook)  |
| `B`                 | 3                  | 0    | 0              | EC-04, unborn HEAD                                                                                           |
| `C`                 | 4                  | 0    | 0              | ES-05, no `.git`                                                                                             |
| `notice`            | 16                 | 0    | 0              | HP-08, EC-09 to EC-12, ES-06, through a real `pnpm install`                                                  |
| `notice-streams`    | 9                  | 0    | 0              | `--notice` stdout only, no write, no network or credential read; EC-18 control; T-n2                         |
| `hook-paths`        | 78                 | 0    | 0              | EC-14 to EC-16, the `core.hooksPath` states, the `/dev/null` opt-out (S-m2); CR-04 scoped remedies           |
| `old-backup`        | 81                 | 0    | 0              | The `.old` move, SEC-02 / QA-01 symlinked hook, R4-QA-01 / 03, R5-QA-01 / 02 tails; QA-02 / QA-02b restore   |
| `repo-shapes`       | 91                 | 0    | 0              | Hooks dir outside the git common dir refused by every route; nested, bare, broken; the round-6 items         |
| `change-filter`     | 10                 | 0    | 0              | The install-failure job's `--needs-install-failure` filter (R4-SEC-03)                                       |
| `machine-spec`      | 42                 | 0    | 0              | `generate_machine_spec` best-effort under each failing or absent host probe                                  |
| `write-boundary`    | 11                 | 0    | 0              | Full-tree manifests around the arming step; EC-17 control; QA-01 stale `node_modules` and its control        |
| `graph-reclaim`     | 13                 | 0    | 0              | EC-05 with the real pinned `code-review-graph` 2.3.9; S-M1 appended block removed                            |
| `binary-provenance` | 6                  | 0    | 0              | EC-02, lefthook 1.13.0 first on `PATH`, the project's 2.x proven by `strace`                                 |
| `install-failure`   | 7 (CI)             | 0    | 1 (local)      | ES-01 to ES-03 — measured in CI only (Section 3)                                                             |
| **Total**           | 429 local · 436 CI | 0    | 1 local · 0 CI |                                                                                                              |

Other readings from this pass:

| Run                          | Result                                                                                                                                                                                                                                                                                                                  |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `hook-arming.sh` (contended) | A first full run, 17:16:22 to 17:27:31 GMT, default evidence directory: **370 passed, 1 failed, 1 unmeasured, exit 1.** The failure was EC-15 `absolute` (`sed: can't read …/hook-paths/absolute.commit`). A second full run by another session started at 17:17:16 into the same directory. Not counted; see Section 3 |
| ShellCheck 0.11.0            | `install-hooks.sh` and `hook-arming.sh` **exit 0, no findings**. `install.sh` **exit 1, 8 findings, all info**: 3 `SC1091`, 5 `SC2016`. TODO(verify): these are taken as pre-existing, as the closeout brief says; this pass did not `git blame` them                                                                   |
| actionlint                   | **Not installed on this host**, so `audit-hook-arming.yml` is not measured by it                                                                                                                                                                                                                                        |
| `audits/story-markers.sh`    | Exit 0 (warn-only): "Scanned 10 test module(s) and 7 Bruno request(s). 8 carry a story marker; 72 do not." The audit scans pytest and Bruno only, so it cannot see `hook-arming.sh`. None of the 72 is a US009 test                                                                                                     |
| `tests/test-record.sh US009` | Exit 0, `wrote 0 test rows`, reading `code/src/scripts/tests/reports`. The block in Section 1 is its output, unedited                                                                                                                                                                                                   |

Earlier full runs during the build, from the closeout brief (evidence not re-read here): 141 / 1 /
1, 171 / 1 / 1, 226 / 1 / 1, 297 / 1 / 1, 328 / 1 / 1 (pass / fail / unmeasured; the one failure
each time was EC-07, the `df` defect fixed at `fd11604`), then 371 / 0 / 1 at `fd11604`.

---

## 3. Outstanding gaps and flaky tests

| Item                                                       | Type                  | Reason / owner                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------------------------------------------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| pytest / Bruno attribution                                 | Out of scope          | No Python or API surface in the diff (story plan, _Testing_), so the generated table is empty and correctly so                                                                                                                                                                                                                                                                                    |
| Bash probe results absent from the generated block         | Tooling gap           | `test-record.sh` has no source for a Bash runner, and `story-markers.sh` cannot see one. A Bash-only story's automated proof is invisible to the generator and the audit, so it is written by hand in Section 2. Finding candidate for workflow 22 Step 5                                                                                                                                         |
| Coverage figures in Section 1                              | Misleading by design  | Whole-project figures from a 16/11/2026 `coverage.xml`, unrelated to this story. Existing defect `../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`                                                                                                                                                                                                         |
| ES-01 to ES-03 (`install-failure`)                         | Measured in CI        | Refused locally (Docker, `uv`, `sudo`); **passed in CI, 7 / 0 / 0**, on both runs of PR #37 (CI run `44174073751` on PR #37 at `160c730`; first run `44171354359`)                                                                                                                                                                                                                                |
| `.github/workflows/audit-hook-arming.yml`                  | Measured              | First run on PR #37 (`44171354359`): every fixture passed but the QA-01 control was unmeasured — under `CI` pnpm's verify-deps install runs frozen and refuses before any postinstall; fixed at `160c730`, and the re-run (CI run `44174073751` on PR #37 at `160c730`) is fully green. The `changes` job's BASE expression worked on both runs (F-014)                                           |
| actionlint over both changed workflows                     | Unmeasured            | Not installed on this host                                                                                                                                                                                                                                                                                                                                                                        |
| Other CI on PR #37                                         | Red, not this story   | Dependency audit and `[8/8] Security`: GHSA-fc5q-39xc-vjpf (`picomatch`, no patched version, via `markdownlint-cli2`), published after `main` last passed; ClickUp sync: US001's `Customer Accepted` is not a status on the ClickUp list; Citations resolve: the 18 pre-existing dangling citations, none in US009. Each routed to Sam. Template Integrity (incl. HP-07) is green since `97821a8` |
| Shared evidence directory under concurrent runs            | Flaky (environmental) | Two full runs into the default `reports/hook-arming/` overlap. One reads a file the other is rewriting, and EC-15 `absolute` failed once (Section 2). Alone, with a private `--output`, the same tree passed 371 / 0. TODO(verify): the clobber mechanism is inferred from timing and the missing-file message, not traced. Finding candidate: no lock, and no per-run default directory          |
| macOS / Windows `generate_machine_spec`, `/etc/os-release` | Unmeasured            | Only the Linux branch runs on this host                                                                                                                                                                                                                                                                                                                                                           |
| Accepted residuals                                         | Documented limit      | The armed check is tied to lefthook 2.2.2's template (a bump fails loudly, exit 2; re-measure then); timestamped `.old` copies are never pruned; `--notice` hides its own errors by design; npm and yarn unsupported. The full list and its dispositions: `../../20-FINDINGS/FINDING-US009-HOOK-ARMING-17-11-2026.md`                                                                             |
| HP-01, HP-04 / EC-06, HP-06 end to end                     | Manual                | Need a real clone through `bash install.sh`; owned by `../MANUAL/US009-MANUAL-TESTING.md`, not this record                                                                                                                                                                                                                                                                                        |
| API (Bruno), E2E, accessibility suites                     | Out of scope          | No endpoint, route or rendered screen                                                                                                                                                                                                                                                                                                                                                             |

**No flaky test inside a single isolated run is known.** The one non-deterministic result seen is
the concurrent-run interference above.

**Unmarked tests are invisible here.** `story-markers.sh` was read (Section 2). It scans pytest
and Bruno only, so its silence says nothing about the Bash suite.

---

## 4. Status line

**Green**: 0 attributed tests (none possible); `hook-arming.sh` 429 passed, 0 failed locally (1
unmeasured, `install-failure`, CI-only) and 436 passed, 0 failed, 0 unmeasured in CI (CI run `44174073751` on PR #37 at `160c730`).
ShellCheck clean on both scripts. actionlint absent locally; the failing PR checks are not this
story (Section 3) · verified 17/11/2026.

---

## Cross-references

- `../../02-STORIES/US009.md`: the story under test
- `../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`: the implementation plan this record closes, with its closing answer sections
- `../MANUAL/US009-MANUAL-TESTING.md`: the paired manual testing guide. A manual `Fail` beside a green suite is a missing test
- `../../11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md`: owns the HP / ES / EC / PA scenario IDs cited above
- `../../15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`: install is the sole arming path
- `code/src/scripts/tests/hook-arming.sh`: the probe runner, its fixtures and exit codes
- `code/src/scripts/development/install-hooks.sh`: the arming step under test
- `.github/workflows/audit-hook-arming.yml`: the CI workflow that runs the probes (first run on PR #37, 17/11/2026)
- `code/docs/GATE-REPORTING.md`: why an unmeasured result is never reported as a pass
- `code/src/scripts/tests/CLAUDE.md`: the runners, their exit-code contract, and the generator
