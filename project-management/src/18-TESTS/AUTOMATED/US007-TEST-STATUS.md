# US007 — Test Status

_The automated-test record for US007: what each automated test checks and whether it passed. Written at `22-implementation-documentation` Step 4. This story ships Markdown only, so it has no suite; the record states that rather than skipping the file (`CLAUDE.md` in this folder → Guardrails)._

**Last Updated**: 02/11/2026 · **Story**: US007 · **Status**: Partial

- **Story:** `../../02-STORIES/US007.md` — the story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits
- **Story plan:** `../../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the code master this record closes the loop on
- **Branch:** `us007/status-vocabulary-one-owner`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US007
```

**Read Section 3 before this block.** No test declares US007, and none could, because the story
changes no code path. The coverage figures below come from the **whole-project** report artefacts
already on disk, not from anything this story ran or touched.

<!-- BEGIN GENERATED: test-record -->

### 1.1 Suite summary

| Suite      | Report artefact | Tests | Result              | Coverage   |
| ---------- | --------------- | ----- | ------------------- | ---------- |
| **Totals** |                 | **0** | **0 Pass / 0 Fail** | **100.0%** |

_Not run, or produced no artefact: E2E and accessibility. An absent suite is not a zero — say why in Section 3._

_No test declares `US007`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US007._

<!-- END GENERATED -->

---

## 2. How to reproduce

No suite exists for this story, so there is nothing to run before the generator. Regenerate the
block against whatever report artefacts are on disk:

```bash
bash code/src/scripts/tests/test-record.sh US007
```

The story's verification is the walk of its manual guide: the five audit gates,
`pm-board.sh --check` and the Markdown syntax legs, each run through `code/src/scripts/**/*.sh`
(`../MANUAL/US007-MANUAL-TESTING.md`).

---

## 3. Outstanding gaps and flaky tests

| Item                                       | Type             | Reason / owner                                                                                                                                                                                                            |
| ------------------------------------------ | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Every suite                                | Out of scope     | No code path. The story edits Markdown only: workflows, templates, a map and its own PM records. Every FLAGS row but `QA` reads `N/A` (`../../02-STORIES/US007.md`)                                                       |
| Unit, integration, API, E2E, accessibility | Not run          | Not run for this story. The unit, integration and API artefacts the generator read (dated 02/11/2026) and `coverage.xml` came from a whole-project run outside this closeout. None carries a US007 marker, and none could |
| Coverage figures in Section 1.2            | Not attributable | The 100.0% line and branch figures, and the "Met? Yes", are the whole Django project's coverage, which the no-test block prints regardless. They say nothing about US007, which has no module in scope (finding F-012)    |
| Auth-critical row                          | N/A              | No module in the authentication, session or permission path is in scope; this story has no module in scope at all                                                                                                         |

**Unmarked tests are invisible here.** `bash code/src/scripts/audits/story-markers.sh` was read on
02/11/2026. It found 9 test modules and 7 Bruno requests, with 72 unmarked and 0 marked, and it
exits 0 as a warning. None of the 72 is a US007 test, because the story wrote none.

---

## 4. Status line

**Partial**: 0 tests, no coverage attributable (no code path); every suite out of scope. Verified 02/11/2026.

---

## Cross-references

- `../../02-STORIES/US007.md` — the story under test; _Re-cut criteria — 02/11/2026_ is its bar
- `../../17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md` — the implementation plan this record closes
- `../MANUAL/US007-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; it carries the story's only executed checks
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` — whether the specified scenarios were met
- `../../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` — F-012, the no-test block's coverage figures
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
