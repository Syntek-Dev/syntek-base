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

When no test declares a story, `code/src/scripts/tests/test-record.sh` still fills its generated
block from whatever `coverage.xml` is on disk. The project-wide figure lands in three places: the
1.1 **Totals** coverage cell, the 1.2 _Coverage vs floors_ row under **This story** with
**Met? Yes**, and the 1.2 per-module table, which lists every measured module in the project. The
record then claims a floor met, and a module list, for a story with no module in scope, and only
hand-written prose outside the generated block can disown it.

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
3. Run `bash code/src/scripts/tests/test-record.sh US007 --dry-run`. `--dry-run` prints the
   generated block to stdout and writes nothing, so the committed record is not overwritten.
4. Observe: the 1.1 **Totals** row shows **100.0%** coverage over **0** tests; the block then says
   no test declares the story; 1.2 prints the whole-project line and branch rate (100.0% on
   02/11/2026) under **This story**, with **Met? Yes**, followed by a per-module table of the
   project's ten measured modules under `apps.core` and `apps.health`.

## 4. Expected vs Actual

|              | Behaviour                                                                                                                         |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| **Expected** | With no test declaring the story, every coverage cell reads N/A — no test declares this story, and no module table is printed     |
| **Actual**   | The Totals cell, the floor row and the module table all report the project's coverage as the story's, and the floor is marked met |

## 5. Root-cause analysis

Every coverage output branches only on whether a `coverage.xml` exists (`line_rate is None`),
never on whether the story has any declared test. `read_coverage()` (`:327`) returns project-wide
`line_rate`, `branch_rate` and `coverage_modules`, and nothing narrows them to the story. So the
1.1 **Totals** cell (`:383-385`) prints `line_rate`; the "no test declares" note (`:391-393`) is
printed; and then the 1.2 floor table (`:395-406`) and the per-module table (`:411-415`) are built
from the same project-wide values regardless.

A second, smaller fault sits on the same line: the no-test note wraps the story ID in backticks
(`` `{STORY}` `` at `:392`), so `code/src/scripts/audits/doc-references.sh` reads it as an instance
citation. Because it is generated text, no hand edit may clear it.

| File                                    | Lines   | Issue                                                             |
| --------------------------------------- | ------- | ----------------------------------------------------------------- |
| `code/src/scripts/tests/test-record.sh` | 383-385 | Totals coverage cell filled from the project rate with 0 tests    |
| `code/src/scripts/tests/test-record.sh` | 391-393 | Notes the absence of tests but does not change what follows       |
| `code/src/scripts/tests/test-record.sh` | 395-406 | Coverage row filled from project totals with no story-scope check |
| `code/src/scripts/tests/test-record.sh` | 411-415 | Per-module table lists every project module, none in scope        |
| `code/src/scripts/tests/test-record.sh` | 392     | Story ID backticked in generated text — trips the citation audit  |

## 6. The fix

**Approach:** compute the no-test condition (`not story_map and not bruno_rows`) once, before the
1.1 table is built, and use it at every coverage output:

- the 1.1 **Totals** coverage cell reads `—` rather than the project rate;
- the 1.2 floor row carries `N/A — no test declares this story` in the **This story** and
  **Met?** cells instead of the project figures;
- the 1.2 per-module table is omitted, with a one-line note that no module is in scope;
- the story ID in the no-test note is written without backticks.

**Files touched:** `code/src/scripts/tests/test-record.sh` (not yet changed).

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                   | Location                                                                                          | Asserts                                                                                        |
| -------------------------------------- | ------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| No-test story gets no project coverage | `test-record.sh` self-test, if one exists; otherwise a `--dry-run` on a story with no marked test | Totals cell `—`; floor row N/A; no module table; no backticked story ID in the generated block |

- **Red:** the project-wide figure appears in the Totals cell and under **This story** with
  `Yes`, and the project's module table follows (observed 02/11/2026, `--dry-run`).
- **Green:** none of the three carries a project figure, and `doc-references.sh` raises no
  instance citation from the block.

## 8. Impact & related stories

- **Impact:** every automated test record for a story with no declared test — documentation-only
  stories in particular. The record's headline coverage claim is wrong for them, in three
  places.
- **Related stories:** US007 (surfaced it).
- **Related records:** `../18-TESTS/AUTOMATED/US007-TEST-STATUS.md` (its Section 3 disowns the
  figure) · `../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` F-012.

## 9. Verification

- `bash code/src/scripts/tests/test-record.sh US007 --dry-run` — the Totals cell reads `—`, the
  floor row reads N/A, and no module table is printed. Then run it without `--dry-run` to
  regenerate `../18-TESTS/AUTOMATED/US007-TEST-STATUS.md`.
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
