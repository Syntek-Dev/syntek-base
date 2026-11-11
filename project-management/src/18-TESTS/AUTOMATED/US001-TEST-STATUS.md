# US001 — Test Status

_The automated-test record for US001: what each automated test checks and whether it passed. Written at `22-implementation-documentation` Step 4. This story ships Markdown only, so it has no suite; the record states that rather than skipping the file (`CLAUDE.md` in this folder → Guardrails)._

**Last Updated**: 03/11/2026 · **Story**: US001 · **Status**: Partial

- **Story:** `../../02-STORIES/US001.md` — reliability doctrine gets an owning guide, and every pointer reaches it
- **Story plan:** `../../17-STORY-PLANS/02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — the code master this record closes the loop on
- **Branch:** `us001/reliability-doctrine-home`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US001
```

**Read Section 3 before this block.** No test declares US001, and none could, because the story
changes no code path. The coverage figures below come from the **whole-project** report artefacts
already on disk (dated 02/11/2026), not from anything this story ran or touched — the defect filed as
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`.

<!-- BEGIN GENERATED: test-record -->

### 1.1 Suite summary

| Suite      | Report artefact | Tests | Result              | Coverage   |
| ---------- | --------------- | ----- | ------------------- | ---------- |
| **Totals** |                 | **0** | **0 Pass / 0 Fail** | **100.0%** |

_Not run, or produced no artefact: E2E and accessibility. An absent suite is not a zero — say why in Section 3._

_No test declares `US001`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US001._

<!-- END GENERATED -->

---

## 2. How to reproduce

No suite exists for this story, so there is nothing to run before the generator. Regenerate the
block against whatever report artefacts are on disk:

```bash
bash code/src/scripts/tests/test-record.sh US001
```

The story's verification is the walk of its manual guide
(`../MANUAL/US001-MANUAL-TESTING.md`, 36 of 36 rows Pass) and the
gates below, each run through `code/src/scripts/**/*.sh` on 03/11/2026:

| Gate                                                                                | Result                                                                                                                                                                                                                                                                                               |
| ----------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bash code/src/scripts/audits/docs-length.sh`                                       | Exit 0. The four warn-tier files are none the story touched (manual row LENGTH-02)                                                                                                                                                                                                                   |
| `bash code/src/scripts/audits/docs-pairing.sh`                                      | Exit 0, split intact (FAMILY-06)                                                                                                                                                                                                                                                                     |
| `bash code/src/scripts/audits/doctrine-drift.sh`                                    | Exit 0, its three API-envelope claims one home each (READ-05). A regression guard only: it reads fenced code, so its green says nothing about the prose this story moved (`../../15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md`)                                                  |
| `bash code/src/scripts/audits/skill-conformance.sh`                                 | Exit 0 (two skills edited by the build: `backend`, `notifications`)                                                                                                                                                                                                                                  |
| `bash code/src/scripts/audits/doc-references.sh`                                    | Exit 1, read as a diff, never as a pass: baseline 610 findings / 295 identities at `e1ab25a`, close 578 / 279; 0 new identities; 16 identities (32 findings) resolved, all `dangling path` on `code/docs/reliability/`. The 578 survivors are pre-existing and owned outside this story (POINTER-04) |
| `bash code/src/scripts/syntax/format.sh` and `bash code/src/scripts/syntax/lint.sh` | Prettier and markdownlint clean on the story's files. The whole-tree Markdown leg fails only in the gitignored `graphify-out/`, pre-existing (`../../21-BUGS/BUG-LINT-READS-GITIGNORED-GRAPHIFY-OUT-02-11-2026.md`)                                                                                  |
| `bash project-management/src/00-ASSETS/scripts/pm-board.sh --check`                 | Boards current                                                                                                                                                                                                                                                                                       |

---

## 3. Outstanding gaps and flaky tests

| Item                                       | Type             | Reason / owner                                                                                                                                                                                                               |
| ------------------------------------------ | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Every suite                                | Out of scope     | No code path. The story edits Markdown only: the reliability family, the guides it migrated out of, their pointers and its own PM records. Every FLAGS row but `QA` reads `N/A` (`../../02-STORIES/US001.md`)                |
| Unit, integration, API, E2E, accessibility | Not run          | Not run for this story. The unit and integration artefacts and the coverage report the generator read (dated 02/11/2026) came from a whole-project run outside this closeout. None carries a US001 marker, and none could    |
| Coverage figures in Section 1.2            | Not attributable | The 100.0% line and branch figures, and the "Met? Yes", are the whole Django project's coverage, which the no-test block prints regardless. They say nothing about US001, which has no module in scope (the filed bug above) |
| Auth-critical row                          | N/A              | No module in the authentication, session or permission path is in scope; this story has no module in scope at all                                                                                                            |
| Migration check                            | N/A              | No model and no migration                                                                                                                                                                                                    |

**Unmarked tests are invisible here.** `bash code/src/scripts/audits/story-markers.sh` was read on
03/11/2026. It found 9 test modules and 7 Bruno requests, with 72 unmarked and 0 marked, and it
exits 0 as a warning. None of the 72 is a US001 test, because the story wrote none.

---

## 4. Status line

**Partial**: 0 tests, no coverage attributable (no code path); every suite out of scope. The story's checks are the walked manual guide and the gates in Section 2. Verified 03/11/2026.

---

## Cross-references

- `../../02-STORIES/US001.md` — the story under test
- `../../17-STORY-PLANS/02-STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` — the implementation plan this record closes
- `../MANUAL/US001-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; it carries the story's only executed checks
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US001-RELIABILITY-DOCTRINE-HOME-03-11-2026.md` — whether the specified scenarios were met
- `../../20-FINDINGS/FINDING-US001-RELIABILITY-DOCTRINE-HOME-03-11-2026.md` — the findings
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
