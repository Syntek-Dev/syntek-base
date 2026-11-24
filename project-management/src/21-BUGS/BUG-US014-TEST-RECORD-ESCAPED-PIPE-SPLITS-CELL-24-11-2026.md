# BUG: US014 — the test-record generator splits a table cell on an escaped pipe, so the regenerated record fails lint

| Field            | Value                                                                                                |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| **Story**        | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label |
| **Story doc**    | `../02-STORIES/US014.md`                                                                             |
| **Story plan**   | `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md`                                   |
| **Target story** | US014 — fixed on its branch before its PR                                                            |
| **Severity**     | Low                                                                                                  |
| **Date found**   | 24/11/2026                                                                                           |
| **Last Updated** | 24/11/2026                                                                                           |
| **Found during** | Debug session — regenerating `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` after the story-map fix    |
| **Reporter**     | Claude (US014 F-001 fix session, `bugfix`)                                                           |

**Status:** Open
**Status note:** Fixed on `us014/structured-json-logging`, 24/11/2026, uncommitted — flips to `Fixed` once merged. No automated regression test yet (section 7)

---

## 1. Summary

`align_tables` in `code/src/scripts/tests/test-record.sh` split rows on every `|`, including the
`\|` that `escape()` writes for a literal pipe in a docstring. A docstring holding a pipe, such as
US014's "LogQL's `| json`", became one extra cell. The row stopped matching its table's column
count, so the generated block failed markdownlint MD060 and rendered with a broken column.

## 2. Environment

| Aspect      | Value                                                     |
| ----------- | --------------------------------------------------------- |
| **Surface** | Test tooling (`code/src/scripts/tests/test-record.sh`)    |
| **Route**   | N/A                                                       |
| **Env**     | local                                                     |
| **Build**   | `us014/structured-json-logging` at `b1705408`, 24/11/2026 |

## 3. Reproduction steps

1. Run `bash code/src/scripts/tests/all.sh --coverage` with US014's tests marked. The story-map
   fix in `BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md` is needed, or no row
   is written.
2. `bash code/src/scripts/tests/test-record.sh US014`.
3. `bash code/src/scripts/syntax/lint.sh --path project-management/src/18-TESTS/AUTOMATED/US014-TEST-STATUS.md`.
4. Observe: exit `1` with 13 MD060 errors, all on generated rows of
   `test_observability_settings`, in the `test_a_non_finite_float_is_text_so_the_line_stays_json[*]` cells.

## 4. Expected vs Actual

|              | Behaviour                                                                   |
| ------------ | --------------------------------------------------------------------------- |
| **Expected** | An escaped pipe stays inside its cell. The block is aligned and lints clean |
| **Actual**   | The cell is cut at `\|`. The row gains a column and lint fails on the block |

## 5. Root-cause analysis

`escape()` (line ~351) turns `|` into `\|` correctly. But `align_tables` then rebuilt each row with
`stripped[1:-1].split("|")`, which cannot tell `\|` from a cell boundary. It cut the cell at the
escape and left a stray `\` at the end of the first piece. A row with a different cell count also
ends the current table run in `align_tables`, so the rows around it were padded as a separate table.

| File                                    | Lines    | Issue                                          |
| --------------------------------------- | -------- | ---------------------------------------------- |
| `code/src/scripts/tests/test-record.sh` | ~497-499 | Row split on every pipe, escaped ones included |

## 6. The fix

**Approach:** split on unescaped pipes only, with `re.split(r"(?<!\\)\|", ...)`. `re` is already
imported by the script. A literal `\` followed by `|` that should end a cell cannot occur, because
`escape()` writes every pipe in cell text as `\|`.

**Files touched:**

- `code/src/scripts/tests/test-record.sh` — the row split in `align_tables`

## 7. Regression test (write the failing test FIRST — TDD)

**There is no automated regression test.** The generator's Python is an inline heredoc that
nothing can import, and no probe script for `test-record.sh` exists yet. A probe in the style of
`pm-boards.sh` would run the generator against a fixture `--reports` directory and lint the
result. It is the follow-up this record leaves open.

The red and green are the reproduction command in section 3:

- **Red (24/11/2026, before the fix):** `lint.sh --path …/US014-TEST-STATUS.md`. Exit `1`,
  13 × "MD060/table-column-style … extra space … for style compact".
- **Green (24/11/2026, after the fix and a regeneration):** the same command, exit `0`. The
  escaped pipe before `json` stays inside its one cell.

## 8. Impact & related stories

- **Impact:** any story whose test docstring contains a `|` gets a lint-red, mis-rendered generated
  block. A hand-edit cannot fix it, because the next run discards the edit. US014 is the first
  story with rows to show it.
- **Related stories:** US014 (its record).
- **Related records:** `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` ·
  `BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md` (the same generator, fixed in
  the same session) · `../20-FINDINGS/FINDING-US014-STRUCTURED-JSON-LOGGING-24-11-2026.md` F-001.

## 9. Verification

- `bash code/src/scripts/tests/all.sh --coverage`: exit `0`, "all.sh — all suites passed."
  (24/11/2026, before this fix. The script changes no suite's outcome.)
- `bash code/src/scripts/tests/test-record.sh US014`: exit `0`, "wrote 160 test rows".
- `bash code/src/scripts/syntax/lint.sh --path project-management/src/18-TESTS/AUTOMATED/US014-TEST-STATUS.md`: exit `0`.

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing. A reproduction command was
      seen red then green; there is no automated test (section 7)
- [x] `bash code/src/scripts/tests/all.sh` green
- [x] Root cause identified (symptom fix rejected: hand-editing the block, or rewording the docstring)
- [ ] Fix merged under the story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US014.md` — the story this defect belongs to
- `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the code master the fix closes the loop on
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `code/src/scripts/tests/CLAUDE.md` — the generator's contract
- `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` — the record this defect broke
