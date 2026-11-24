# BUG: `story-map.json` reads `[]` after a coverage run, so a marked story's tests cannot be attributed

> A **cross-cutting** defect: not owned by one story. It was found while recording US010, which
> has no pytest tests, so the story fields read `N/A — cross-cutting`.

| Field            | Value                                                                             |
| ---------------- | --------------------------------------------------------------------------------- |
| **Story**        | N/A — cross-cutting (found at US010's `22-implementation-documentation` Step 4)   |
| **Story doc**    | N/A — cross-cutting                                                               |
| **Story plan**   | N/A — cross-cutting                                                               |
| **Target story** | US014 — fixed on its branch before its PR (its finding F-001 hit the same defect) |
| **Severity**     | Low                                                                               |
| **Date found**   | 21/11/2026                                                                        |
| **Last Updated** | 24/11/2026                                                                        |
| **Found during** | Automated-record generation (`tests/test-record.sh`)                              |
| **Reporter**     | Claude (US010 automated-record session); filed by the gate-22 Step 5 subagent     |

**Status:** Fixed
**Status note:** Filed from finding F-034 in `../20-FINDINGS/archive/FINDING-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md`; hit again as F-001 in `../20-FINDINGS/archive/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md`. Fix `1d35ae29` and its four regression tests (`code/src/django/tests/unit/test_story_map.py`) merged into `dev` via PR #44 at `94db8f02`, 24/11/2026; `Verified` once seen to hold after the merge

---

## 1. Summary

After `code/src/scripts/tests/backend-coverage.sh`, the gitignored
`code/src/scripts/tests/reports/story-map.json` reads `[]`. `test-record.sh US008 --dry-run` then
lists no US008 tests, although `code/src/django/config/tests/test_dev_settings.py` carries
`pytest.mark.story("US008")`. A story's automated record may therefore not be regenerable.

## 2. Environment

| Aspect      | Value                                                          |
| ----------- | -------------------------------------------------------------- |
| **Surface** | Test tooling (`code/src/django/conftest.py`, `test-record.sh`) |
| **Route**   | N/A                                                            |
| **Env**     | local                                                          |
| **Build**   | `testing` at `7d54df26`, 21/11/2026                            |

## 3. Reproduction steps

1. `bash code/src/scripts/tests/backend-coverage.sh` (exit 0: 71 unit and 22 integration tests
   passed).
2. Read `code/src/scripts/tests/reports/story-map.json`: `[]` (confirmed 21/11/2026).
3. `bash code/src/scripts/tests/test-record.sh US008 --dry-run`.
4. Observe: no US008 test is listed.

## 4. Expected vs Actual

|              | Behaviour                                                                                  |
| ------------ | ------------------------------------------------------------------------------------------ |
| **Expected** | The map lists every test carrying a `story` marker in the run, including US008's unit test |
| **Actual**   | The map is empty                                                                           |

## 5. Root-cause analysis

**Traced 24/11/2026** (it was inferred on 21/11/2026):

- `backend.sh` and `backend-coverage.sh` both run pytest as two sessions, `-m unit` then
  `-m integration`.
- `pytest_collection_finish` in `conftest.py` built the map from that session's own
  `session.items` — the post-deselection selection — and `write_text` replaced the file.
- So the integration session erased every unit-phase entry. Every story-marked `.py` test so far
  is unit-tier (US008's `config/tests/test_dev_settings.py`, all of US014's), so the map always
  ended `[]`.

**Evidence.** Before the fix, `story-map.json` read `[]` after US014's full coverage run (finding
F-001). The regression test (section 7) drives the hook with a unit-phase session then an
integration-phase session and reproduces it: `assert [] == ['apps/core/t...:test_marked']`. The
alternative named on 21/11/2026 — the module falling outside the run's selection — is excluded:
the marked tests ran in the unit phase's JUnit XML.

| File                          | Lines   | Issue                                                       |
| ----------------------------- | ------- | ----------------------------------------------------------- |
| `code/src/django/conftest.py` | ~91-115 | The map is rebuilt from one session's items and overwritten |

## 6. The fix

**Approach:** the writer merges instead of overwriting. Each session reads the previous map back
and replaces only the entries for node ids it collected itself: a re-marked test takes its new
stories, a test whose marker was removed leaves the map, and every other entry stays. A test
that no longer exists can leave a stale entry, which is harmless — `test-record.sh` joins on the
run's JUnit XML, so a test that did not run gets no row. An unreadable map (absent, truncated, not
a list) counts as empty and is rewritten, never raised. Entries are written sorted by `nodeid`.

The runner-side alternative (one map per phase, read by `test-record.sh`) was rejected: it touches
three scripts to fix what one hook got wrong, and every future runner would have to repeat it.

**Files touched:**

- `code/src/django/conftest.py` — `_read_previous_map()` and the merge in
  `pytest_collection_finish`
- `code/src/django/tests/unit/test_story_map.py` — the regression tests (new package, with its
  `CONTEXT.md` + `CLAUDE.md`; `tests/CONTEXT.md` and `tests/CLAUDE.md` name it)

## 7. Regression test (write the failing test FIRST — TDD)

All four in `code/src/django/tests/unit/test_story_map.py`, marked `unit` and `story("US014")`:

| Test                                                                  | Asserts                                                                        |
| --------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| `test_a_later_session_keeps_an_earlier_sessions_story_entries`        | A unit session's marked test survives an integration session that selects none |
| `test_a_rerun_test_replaces_its_own_entry_rather_than_duplicating_it` | The same node id written twice is one entry with the latest stories            |
| `test_a_test_that_loses_its_marker_leaves_the_map`                    | A session is authoritative for the tests it collected                          |
| `test_an_unreadable_previous_map_is_replaced_not_fatal`               | A corrupt map from an interrupted run is rewritten, not raised                 |

- **Red (24/11/2026, before the fix):** `bash code/src/scripts/tests/backend.sh code/src/django/tests/unit/test_story_map.py`
  — `1 failed`, the first test, `assert [] == ['apps/core/tests/unit/test_x.py::test_marked']`.
- **Green (24/11/2026, after the fix):** the same command — `4 passed`; integration phase "no
  tests collected", and the real `story-map.json` still listed the four tests afterwards.

## 8. Impact & related stories

- **Impact:** every story whose marked tests run in a phase other than the last cannot have its
  automated record regenerated. US010 is unaffected, because it has no pytest tests. US014's
  record wrote 0 rows for 156 passing tests until the fix.
- **Related stories:** US008 (its record) · US014 (finding F-001; the fixing story).
- **Related records:** `../18-TESTS/AUTOMATED/US010-TEST-STATUS.md` Section 3 ·
  `BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md` (the same generator).

## 9. Verification

Run 24/11/2026 on `us014/structured-json-logging` (base `b1705408`, fix uncommitted):

| Command                                                      | Exit | Result                                                                                           |
| ------------------------------------------------------------ | ---- | ------------------------------------------------------------------------------------------------ |
| `bash code/src/scripts/tests/all.sh --coverage`              | 0    | unit "231 passed"; integration "22 passed"; total coverage 94.50%; "all.sh — all suites passed." |
| `story-map.json` after that run                              | —    | 181 entries, 160 of them `US014` — no longer `[]`                                                |
| `bash code/src/scripts/tests/test-record.sh US014`           | 0    | "wrote 160 test rows" (0 before the fix)                                                         |
| `bash code/src/scripts/tests/test-record.sh US008 --dry-run` | 0    | Lists `config/tests/test_dev_settings.py` — "21 Pass / 0 Fail"; the original repro, now green    |

**Sign-off:**

- [x] Regression test written **first**, seen to fail, now passing
- [x] `bash code/src/scripts/tests/all.sh` green (`--coverage`, 24/11/2026)
- [x] Root cause identified (symptom fix rejected)
- [ ] Fix merged; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `../18-TESTS/AUTOMATED/` — the records this generator writes
