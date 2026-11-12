# US005 — Test Status

_The automated-test record for US005: what each automated test checks and whether it passed. Written at `22-implementation-documentation` Step 4. This story ships Markdown only, so it has no suite; its stand-in checks are three documentation gates, gate runs that no story marker can attribute. The record states that rather than skipping the file (the Guardrails of this folder's `CLAUDE.md`)._

**Last Updated**: 12/11/2026 · **Story**: US005 · **Status**: Partial

- **Story:** `../../02-STORIES/US005.md` — exactly one layer decides to retry, and every budget says how long it may take
- **Story plan:** `../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — the code master this record closes the loop on
- **Branch:** `us005/retry-ownership-and-budgets`

> **Half this file is generated.** Everything between the `BEGIN GENERATED` and `END GENERATED`
> markers is written by `code/src/scripts/tests/test-record.sh` from the suites' own report
> artefacts — **never edit it by hand**, because the next run silently discards the edit. The
> sections after it are yours. The script's contract and the story marker it filters on are in
> this folder's `CLAUDE.md`.

---

## 1. Results

Regenerate after any suite run, green or red:

```bash
bash code/src/scripts/tests/test-record.sh US005
```

**Read Section 3 before this block.** No test declares US005, and none could, because the story
changes no Python or Bruno path. The coverage figures below come from the **whole-project** report
artefacts already on disk (`code/src/scripts/tests/reports/`, last written 11/11/2026 by a run this
story did not make), not from anything this story ran or touched — the defect filed as
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

_No test declares `US005`. Either none has been written yet, or the marker is missing — `bash code/src/scripts/audits/story-markers.sh` tells you which._

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

_No attributed tests to list for US005._

<!-- END GENERATED -->

---

## 2. How to reproduce

No pytest, Bruno, E2E or axe suite exists for this story, so there is nothing to run before the
generator. Regenerate the block against whatever report artefacts are on disk:

```bash
bash code/src/scripts/tests/test-record.sh US005
```

**Generator run, 12/11/2026,** on the working tree at `eb902ea` with nothing staged: exit 0,
`wrote 0 test rows into project-management/src/18-TESTS/AUTOMATED/US005-TEST-STATUS.md`, reading
`code/src/scripts/tests/reports`. The block above is its output, unedited.

The story's stand-in checks are the three documentation gates its QA flag names
(`../../02-STORIES/US005.md` FLAGS, the `QA` row; _Verification Checks_), run through their
project scripts:

```bash
bash code/src/scripts/audits/docs-length.sh
bash code/src/scripts/audits/doc-references.sh --self-test
bash code/src/scripts/audits/doc-references.sh
bash code/src/scripts/audits/doctrine-drift.sh
```

**Current figures, measured by the closeout orchestrator 12/11/2026** on the final tree (index
unstaged, `HEAD` `eb902ea`). They were not re-run by this records pass; they are transcribed here
with the scope each gate actually has:

| Gate                            | Result                                                     | What it proves — and what it does not                                                                                                                                                                                                                                                                                                                                                         |
| ------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `docs-length.sh`                | Exit 0                                                     | Every instructional file is within the 300-code-line limit and the 270 ratchet. As the gate counts them: `code/docs/TASK-AUTHORING.md` 245 before the first edit and 263 after; `code/docs/reliability/RETRIES.md` 216; `code/docs/reliability/BUDGETS.md` 127. Proves length only, nothing about content                                                                                     |
| `doc-references.sh --self-test` | Exit 0, 228 probes                                         | The detector still separates its `broken/` and `clean/` fixtures, including the tightened `[template artefact]` class this branch added (plan, _Added 12/11/2026_). Proves the gate, not the tree                                                                                                                                                                                             |
| `doc-references.sh`             | **Exit 1**, 28 `[dangling path]` (29 before the F-001 fix) | 0 `[template artefact]` and 0 of every other class. Before the first edit (11/11/2026, clean index, `eb902ea`): exit 1 on 28 `[dangling path]`. **This is not the gate passing** (`code/docs/GATE-REPORTING.md`): it exits 1, and the one finding added is this story's own (Section 3)                                                                                                       |
| `doctrine-drift.sh`             | Exit 0, 4 claims                                           | No registered claim is restated outside its owner, unowned or reintroduced after retirement. **It reads fenced code only** (`code/src/scripts/audits/CONTEXT.md`, the `doctrine-drift.sh` row), so it checked the doctrine's examples and **never its prose**; the prose read-across is manual work (`../../02-STORIES/US005.md` _QA Tasks — Manual_), recorded in the manual guide, not here |

The walk's own gate runs, the hand recomputation of the worst-case column and the before/after
budget inventory are rows in `../MANUAL/US005-MANUAL-TESTING.md`, not figures in this record.

---

## 3. Outstanding gaps and flaky tests

| Item                                      | Type             | Reason / owner                                                                                                                                                                                                                                                                                                                            |
| ----------------------------------------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Every pytest, Bruno, E2E and axe suite    | Out of scope     | No code path. The story ships the reliability doctrine and its repaired guides, plus three side changes (the `format.sh` `yaml`/`json` legs, the tightened `doc-references.sh`, the template-only reference sweep with its `copier.yml` exclusion). `tests/all.sh --coverage` is **N/A** in the story's _Verification Checks_             |
| `format.sh` and `doc-references.sh` edits | Gate, not suite  | Bash, not Python: no pytest test can declare them. `doc-references.sh` is proved by its own `--self-test` (Section 2); the `format.sh` legs by the plan's dated probe run (_Added 11/11/2026_, "Verified 11/11/2026"), which has no self-test of its own                                                                                  |
| `doc-references.sh` whole tree            | Red, exit 1      | 28 named `[dangling path]` survivors below, identical to the 28-finding baseline, so the _Verification Checks_ row "no new finding against the recorded baseline" is **met**. First measured at 29 (`RETRIES.md:68` backticked the unwritten register); Sam ruled 12/11/2026 to mention it in plain prose (F-001), and the re-run gave 28 |
| `doctrine-drift.sh` prose blind spot      | Not measured     | Exit 0 covers fenced code only. Whether a rule is restated in prose was not machine-checked; it rests on the manual read-across                                                                                                                                                                                                           |
| Coverage figures in Section 1.2           | Not attributable | The 100.0% line and branch figures, and the "Met? Yes", are the whole Django project's coverage, which the no-test block prints regardless. They say nothing about US005, which has no module in scope (the filed bug above)                                                                                                              |
| Auth-critical row                         | N/A              | No module in the authentication, session or permission path is in scope                                                                                                                                                                                                                                                                   |
| Migration check                           | N/A              | No model and no migration (`migrate.sh check` is N/A in the story's _Verification Checks_)                                                                                                                                                                                                                                                |

### Whole-tree survivors — every one named with its owner

`bash code/src/scripts/audits/doc-references.sh` over the whole tree, as measured by the
orchestrator 12/11/2026: **exit 1, 28 findings, every one `[dangling path]`** (29 before the F-001 fix), 0 `[template
artefact]`, 0 of every other class.

| Target, quoted because it does not exist yet  | Findings | Owner        | Note                                                                                                                                                                  |
| --------------------------------------------- | -------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "how-to/src/OUTBOUND-TIMEOUTS.md"             | 11       | slice `S-09` | 10 carried from the baseline; **1 added** by `code/docs/reliability/RETRIES.md`, _The delegation escape hatch_, which names it as a forward reference in its own text |
| "code/src/scripts/\_lib/posture-guard.sh"     | 10       | US006        | Carried from the baseline, unchanged                                                                                                                                  |
| `observability` (US014's module and its test) | 6        | US014        | Carried from the baseline, unchanged                                                                                                                                  |
| "project-management/src/21-BUGS/BUG-INDEX.md" | 2        | US010        | Carried from the baseline, unchanged                                                                                                                                  |

The plan expected the register's survivors to be named with `S-09`, not cleared
(`../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md`, the
`doc-references.sh` row of its verification table, and the _Forward-looking claims_ row, "a
dangling path is fixed, not marked"). Whether the one added in a **shipped** guide is acceptable
under the baseline-diff regime is a Step 5 judgement, not this record's.

**Unmarked tests are invisible here.** `bash code/src/scripts/audits/story-markers.sh` was read on
12/11/2026: exit 0 as a warning, "Scanned 9 test module(s) and 7 Bruno request(s). 0 carry a story
marker; 72 do not." — 65 pytest cases and 7 `.bru` requests. None of the 72 is a US005 test,
because the story wrote none.

---

## 4. Status line

**Partial**: 0 attributed tests, no coverage attributable (no Python path); the story's stand-in checks are `docs-length.sh` exit 0, `doc-references.sh --self-test` 228 probes at exit 0 and `doctrine-drift.sh` exit 0 on 4 claims (fenced code only, prose unchecked), while the whole-tree `doc-references.sh` exits 1 on 29 named `[dangling path]` survivors, one more than its baseline of 28. Verified 12/11/2026.

---

## Cross-references

- `../../02-STORIES/US005.md` — the story under test
- `../../17-STORY-PLANS/06-STORY-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — the implementation plan this record closes
- `../MANUAL/US005-MANUAL-TESTING.md` — the paired manual testing guide, authored before code and walked after it; it carries the walk's gate runs and the budget inventory
- `../../11-QA/PLANNING/QA-PLAN-US005-RETRY-OWNERSHIP-AND-BUDGETS.md` — the scenarios the QA record closes
- `../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` — the threat model the doctrine's wording answers
- `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` — the assessment whose Section 7 constraints the doctrine's wording satisfies
- `code/src/scripts/audits/CONTEXT.md` — what each documentation gate checks, and what it cannot
- `code/docs/GATE-REPORTING.md` — why an exit 1 with named survivors is not reported as a pass
- `code/docs/TESTING.md` — coverage floors, test structure, and mocking strategy
- `code/src/scripts/tests/CLAUDE.md` — the runners, their exit-code contract, and the generator
