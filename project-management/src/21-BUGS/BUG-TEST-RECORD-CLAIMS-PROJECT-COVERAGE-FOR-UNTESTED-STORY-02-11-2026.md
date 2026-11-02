# BUG: `test-record.sh` reports project-wide coverage as a story's own when no test declares the story

| Field            | Value                                                                                                              |
| ---------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Story**        | N/A — cross-cutting (surfaced by US007)                                                                            |
| **Story doc**    | N/A — surfaced in `../02-STORIES/US007.md`'s closeout                                                              |
| **Story plan**   | N/A — cross-cutting                                                                                                |
| **Severity**     | Low                                                                                                                |
| **Date found**   | 02/11/2026                                                                                                         |
| **Last Updated** | 02/11/2026                                                                                                         |
| **Status**       | Open                                                                                                               |
| **Found during** | `22-implementation-documentation` Step 4 — writing `../18-TESTS/AUTOMATED/US007-TEST-STATUS.md`                    |
| **Reporter**     | Claude, on Sam's behalf; finding F-012 in `../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` |

Filed for a later fix (Sam, 02/11/2026). No target story is named yet; the fix is unscheduled.

---

## 1. Summary

When no test declares a story, `code/src/scripts/tests/test-record.sh` still fills the generated
_Coverage vs floors_ row from whatever `coverage.xml` is on disk, printing the project-wide figure
under **This story** with **Met? Yes**. The record then claims a floor met by a story with no
module in scope, and only hand-written prose outside the generated block can disown it.

## 2. Environment

| Aspect      | Value                                             |
| ----------- | ------------------------------------------------- |
| **Surface** | Tooling — `code/src/scripts/tests/test-record.sh` |
| **Route**   | N/A                                               |
| **Env**     | local                                             |
| **Build**   | `us007/status-vocabulary-one-owner` on `a9378ec`  |

## 3. Reproduction steps

1. Have a `coverage.xml` on disk from any earlier backend coverage run.
2. Pick a story no test carries `@pytest.mark.story` for (US007, a Markdown-only story).
3. Run `bash code/src/scripts/tests/test-record.sh US007`.
4. Observe: the generated block says no test declares the story, then prints the whole-project
   line and branch rate (100.0% on 02/11/2026) under **This story**, with **Met? Yes**.

## 4. Expected vs Actual

|              | Behaviour                                                                                  |
| ------------ | ------------------------------------------------------------------------------------------ |
| **Expected** | With no test declaring the story, the coverage row reads N/A — no test declares this story |
| **Actual**   | It reads the project's coverage as the story's and marks the floor met                     |

## 5. Root-cause analysis

The coverage section branches only on whether a `coverage.xml` exists (`line_rate is None`), never
on whether the story has any declared test. The "no test declares" note at `:391-393` is printed,
and then the coverage table at `:395-406` is built from the project-wide `line_rate` and
`branch_rate` regardless.

A second, smaller fault sits on the same line: the no-test note wraps the story ID in backticks
(`` `{STORY}` `` at `:392`), so `code/src/scripts/audits/doc-references.sh` reads it as an instance
citation. Because it is generated text, no hand edit may clear it.

| File                                    | Lines   | Issue                                                             |
| --------------------------------------- | ------- | ----------------------------------------------------------------- |
| `code/src/scripts/tests/test-record.sh` | 391-393 | Notes the absence of tests but does not change what follows       |
| `code/src/scripts/tests/test-record.sh` | 395-406 | Coverage row filled from project totals with no story-scope check |
| `code/src/scripts/tests/test-record.sh` | 392     | Story ID backticked in generated text — trips the citation audit  |

## 6. The fix

**Approach:** when `not story_map and not bruno_rows`, emit the coverage table with
`N/A — no test declares this story` in the **This story** and **Met?** cells instead of the
project figures, and write the story ID in the note without backticks.

**Files touched:** `code/src/scripts/tests/test-record.sh` (not yet changed).

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                   | Location                                                                                           | Asserts                                                               |
| -------------------------------------- | -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| No-test story gets an N/A coverage row | `test-record.sh` self-test, if one exists; otherwise a scripted run on a story with no marked test | Coverage row reads N/A; no backticked story ID in the generated block |

- **Red:** the project-wide figure and `Yes` appear under **This story** (observed 02/11/2026).
- **Green:** the row reads N/A, and `doc-references.sh` raises no instance citation from the block.

## 8. Impact & related stories

- **Impact:** every automated test record for a story with no declared test — documentation-only
  stories in particular. The record's headline coverage claim is wrong for them.
- **Related stories:** US007 (surfaced it).
- **Related records:** `../18-TESTS/AUTOMATED/US007-TEST-STATUS.md` (its Section 3 disowns the
  figure) · `../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` F-012.

## 9. Verification

- `bash code/src/scripts/tests/test-record.sh US007` — the coverage row reads N/A.
- `bash code/src/scripts/audits/doc-references.sh` — no instance citation from a generated block.

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged under its story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US007.md` — the story whose closeout surfaced it
- `code/workflows/10-debug/` — the TDD debug procedure
- `../18-TESTS/AUTOMATED/` — the record the generator writes
