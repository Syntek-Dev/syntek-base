# BUG: `story-map.json` reads `[]` after a coverage run, so a marked story's tests cannot be attributed

> A **cross-cutting** defect: not owned by one story. It was found while recording US010, which
> has no pytest tests, so the story fields read `N/A — cross-cutting`.

| Field            | Value                                                                           |
| ---------------- | ------------------------------------------------------------------------------- |
| **Story**        | N/A — cross-cutting (found at US010's `22-implementation-documentation` Step 4) |
| **Story doc**    | N/A — cross-cutting                                                             |
| **Story plan**   | N/A — cross-cutting                                                             |
| **Target story** | N/A — not yet assigned; an open report, its fixing story is chosen at triage    |
| **Severity**     | Low                                                                             |
| **Date found**   | 21/11/2026                                                                      |
| **Last Updated** | 21/11/2026                                                                      |
| **Found during** | Automated-record generation (`tests/test-record.sh`)                            |
| **Reporter**     | Claude (US010 automated-record session); filed by the gate-22 Step 5 subagent   |

**Status:** Open
**Status note:** Filed from finding F-034 in `../20-FINDINGS/archive/FINDING-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md`. Root cause inferred, not traced

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

Inferred from reading the code, not traced (TODO(verify)):

- `backend-coverage.sh` runs pytest in two phases, `-m unit` then `-m integration`.
- `conftest.py` writes the map at the end of each session from that session's own
  `session.items`, and `write_text` overwrites the file each time.
- So the second phase would replace the unit phase's entries. If no integration test carries a
  marker, the map is `[]`.

The alternative the automated record named is that the module falls outside the run's selection.
That alternative has not been excluded.

| File                          | Lines   | Issue                                                       |
| ----------------------------- | ------- | ----------------------------------------------------------- |
| `code/src/django/conftest.py` | ~91-115 | The map is rebuilt from one session's items and overwritten |

## 6. The fix

Not applied; this record does not fix anything.

**Approach (proposed):** merge the map across the phases of one run (for example, keyed on
`nodeid`), or have the coverage script write it once per run.

**Files touched:** to be named by the fixing story.

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                                 | Location                  | Asserts                                                             |
| ---------------------------------------------------- | ------------------------- | ------------------------------------------------------------------- |
| A two-phase run keeps the unit phase's story entries | the fixing story's choice | After unit then integration phases, US008's unit test is in the map |

- **Red:** to be recorded.
- **Green:** to be recorded.

## 8. Impact & related stories

- **Impact:** every story whose marked tests run in a phase other than the last cannot have its
  automated record regenerated. US010 is unaffected, because it has no pytest tests.
- **Related stories:** US008 (its record).
- **Related records:** `../18-TESTS/AUTOMATED/US010-TEST-STATUS.md` Section 3 ·
  `BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md` (the same generator).

## 9. Verification

- `bash code/src/scripts/tests/backend-coverage.sh`, then
  `bash code/src/scripts/tests/test-record.sh US008 --dry-run` lists US008's tests.
- `bash code/src/scripts/tests/all.sh` green.

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing
- [ ] `bash code/src/scripts/tests/all.sh` green
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `../18-TESTS/AUTOMATED/` — the records this generator writes
