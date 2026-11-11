# US003 — Test Status

_The automated-test record for US003: what each automated test checks and whether it passed. Written at `22-implementation-documentation` Step 4. This story ships Markdown, one regex row and three gate fixtures, so it has no suite of its own; the record states that rather than skipping the file (`CLAUDE.md` in this folder → Guardrails)._

**Last Updated**: 05/11/2026 · **Story**: US003 · **Status**: Partial

- **Story:** `../../02-STORIES/US003.md` — absence gets an owning guide, born under 270 with every clause's tier stated
- **Story plan:** `../../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the code master this record closes the loop on
- **Branch:** `us003/absence-guide`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US003
```

**Read Section 3 before this block.** No test declares US003, and none could, because the story
changes no code path. The coverage figures below come from the **whole-project** report artefacts
already on disk, not from anything this story ran or touched — the defect filed as
`../../21-BUGS/BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md`.

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

_Not run, or produced no artefact: E2E and accessibility. An absent suite is not a zero — say why in Section 3._

_No test declares `US003`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US003._

<!-- END GENERATED -->

---

## 2. How to reproduce

No suite exists for this story, so there is nothing to run before the generator. Regenerate the
block against whatever report artefacts are on disk:

```bash
bash code/src/scripts/tests/test-record.sh US003
```

The story's verification is the walk of its manual guide (`../MANUAL/US003-MANUAL-TESTING.md`,
walked at `01dd924` and re-walked at `0471087`: **47 Pass, 0 Fail**, one row amended) and the gates
below, each run through `code/src/scripts/**/*.sh`. The walk's own runs are its rows; the close
runs are this closeout's, on 05/11/2026 over the staged tree at `0471087`.

| Gate                                                                                | Result                                                                                                                                                                                                                                                                                                                                                                                     |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `bash code/src/scripts/audits/docs-length.sh --path code/docs --limit 1`            | `code/docs/ABSENCE.md` at **205** counted lines, 65 clear of 270 (born at 144). Exit 1 is the `--limit 1` probe, by design (LENGTH-01)                                                                                                                                                                                                                                                     |
| `bash code/src/scripts/audits/docs-length.sh --since testing`                       | Exit 0; 807 instructional files within 300, three approaching (291, 289, 287), none touched by the story (LENGTH-02, LENGTH-03)                                                                                                                                                                                                                                                            |
| `bash code/src/scripts/audits/doc-references.sh`                                    | Exit 1, read as a diff, never as a pass: baseline **564 findings / 269 identities** at `5baaac2`, walk run **499 / 251** at `01dd924`; **0 new** identities; **18 identities (65 findings) gone**, every one a dangling path to `code/docs/ABSENCE.md` (DOCREF-01, DOCREF-02). The walk-fail fix's one shipped file, scoped: exit 0; at HEAD the generated block adds one identity (F-025) |
| `bash code/src/scripts/audits/doctrine-drift.sh` · `--self-test`                    | Exit 0, 4 claims each with exactly one home; self-test exit 0. **Fenced code only** — never evidence about the guide's prose (DRIFT-01, DRIFT-02)                                                                                                                                                                                                                                          |
| `bash code/src/scripts/audits/routing-skills.sh`                                    | Exit 0, 612 names across 264 files (GUIDE-03)                                                                                                                                                                                                                                                                                                                                              |
| `bash code/src/scripts/audits/skill-conformance.sh`                                 | Exit 0, 65 skills; clause 14 discharged for `backend`, `frontend`, `code-reviewer` and `refactor` (RECIP-02)                                                                                                                                                                                                                                                                               |
| `bash code/src/scripts/audits/docs-pairing.sh`                                      | Exit 0 — regression only; the story creates no directory                                                                                                                                                                                                                                                                                                                                   |
| `bash .github/scripts/shipped-readme.sh`                                            | Exit 0 (red at `e1afd7b`, fixed `8a9e245` — finding F-020)                                                                                                                                                                                                                                                                                                                                 |
| `bash code/src/scripts/syntax/format.sh` and `bash code/src/scripts/syntax/lint.sh` | Prettier (two `--fix` passes, the second leaving the diff unchanged) and markdownlint clean on each file this closeout wrote or edited                                                                                                                                                                                                                                                     |
| `bash project-management/src/00-ASSETS/scripts/pm-board.sh --check`                 | Boards current, `archive/` untouched                                                                                                                                                                                                                                                                                                                                                       |

---

## 3. Outstanding gaps and flaky tests

| Item                                       | Type             | Reason / owner                                                                                                                                                                                                                                                                                   |
| ------------------------------------------ | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Every suite                                | Out of scope     | No code path. The story writes one guide, edits Markdown in its registration, reciprocity and vocabulary sites, adds one regex row to `code/src/scripts/audits/doctrine-drift.sh` and three fixtures its `--self-test` reads. Every FLAGS row but `QA` reads `N/A` (`../../02-STORIES/US003.md`) |
| The drift row and its fixtures             | Gate, not suite  | Exercised by `doctrine-drift.sh --self-test`, a gate run, not a pytest or Bruno test; it carries no story marker and cannot. Exit 0 above                                                                                                                                                        |
| Unit, integration, API, E2E, accessibility | Not run          | Not run for this story. The artefacts the generator read came from a whole-project run outside this closeout. None carries a US003 marker, and none could                                                                                                                                        |
| Coverage figures in Section 1.2            | Not attributable | The 100.0% line and branch figures, and the "Met? Yes", are the whole Django project's coverage, which the no-test block prints regardless. They say nothing about US003, which has no module in scope (the filed bug above)                                                                     |
| Auth-critical row                          | N/A              | No module in the authentication, session or permission path is in scope                                                                                                                                                                                                                          |
| Migration check                            | N/A              | No model and no migration                                                                                                                                                                                                                                                                        |
| Manual rows                                | None failing     | BOUNDARY-06 failed at `01dd924` and passes at `0471087` (finding F-002) — a prose read-across no automated test could perform. No manual `Fail` stands beside this record                                                                                                                        |

**Unmarked tests are invisible here.** `bash code/src/scripts/audits/story-markers.sh` was read on
05/11/2026. It found 9 test modules and 7 Bruno requests, with 72 unmarked and 0 marked, and it
exits 0 as a warning. None of the 72 is a US003 test, because the story wrote none.

---

## 4. Status line

**Partial**: 0 tests, no coverage attributable (no code path); every suite out of scope. The story's checks are the walked manual guide and the gates in Section 2. Verified 05/11/2026.

---

## Cross-references

- `../../02-STORIES/US003.md` — the story under test
- `../../17-STORY-PLANS/04-STORY-PLAN-US003-ABSENCE-GUIDE.md` — the implementation plan this record closes
- `../MANUAL/US003-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; it carries the story's only executed checks
- `../../11-QA/IMPLEMENTATION/QA-IMPL-US003-ABSENCE-GUIDE-05-11-2026.md` — whether the specified scenarios were met
- `../../19-REVIEWS/REVIEW-US003-ABSENCE-GUIDE.md` — the three review rounds and the QA breaker pass
- `../../20-FINDINGS/FINDING-US003-ABSENCE-GUIDE-05-11-2026.md` — the findings (F-025 for this record's generated line)
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
