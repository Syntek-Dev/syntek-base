# BUG: US014 — the test-record generator writes a record Prettier rewrites, so every regeneration fails the format gate

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
| **Reporter**     | Claude (US014 F-001 fix session; fixed on Sam's instruction, 24/11/2026)                             |

**Status:** Open
**Status note:** Fixed on `us014/structured-json-logging`, 24/11/2026 — flips to `Fixed` once merged

---

## 1. Summary

`code/src/scripts/tests/test-record.sh` copies each test's docstring verbatim into the record's
**Why** column. Docstrings in this repository are RST, so they carry ` ``literal`` ` spans and
`*emphasis*`, which Prettier rewrites (` ``x`` ` becomes `` `x` ``, `*x*` becomes `_x_`). A freshly
written record therefore failed `syntax/format.sh` every time, and each regeneration needed a
formatting pass run by hand before it could be committed.

## 2. Environment

| Aspect      | Value                                                     |
| ----------- | --------------------------------------------------------- |
| **Surface** | Test tooling (`code/src/scripts/tests/test-record.sh`)    |
| **Route**   | N/A                                                       |
| **Env**     | local                                                     |
| **Build**   | `us014/structured-json-logging` at `e2dfde22`, 24/11/2026 |

## 3. Reproduction steps

1. Have the suite's reports under `code/src/scripts/tests/reports/` (`bash code/src/scripts/tests/all.sh --coverage`).
2. `bash code/src/scripts/tests/test-record.sh US014`.
3. `bash code/src/scripts/syntax/format.sh --file-type markdown --path project-management/src/18-TESTS/AUTOMATED/US014-TEST-STATUS.md`.
4. Observe: "Formatting issues found", and `git diff --stat` on the record shows 134 lines
   changed against the formatted copy committed in `e2dfde22`.

## 4. Expected vs Actual

|              | Behaviour                                                                                |
| ------------ | ---------------------------------------------------------------------------------------- |
| **Expected** | The generator's output is already formatted: the format gate passes straight after a run |
| **Actual**   | The record fails the format gate until `format.sh --fix` is run on it by hand            |

## 5. Root-cause analysis

The generator writes Markdown but nothing makes that Markdown the formatter's fixed point.
`escape()` handles only what breaks a table row (pipes, newlines); every other construct a
docstring can hold reaches the file as written. Prettier is the gate's arbiter of Markdown form,
so any construct it normalises makes the output unstable. RST inline literals were the first such
construct seen; RST emphasis and others would follow.

| File                                    | Lines     | Issue                                                       |
| --------------------------------------- | --------- | ----------------------------------------------------------- |
| `code/src/scripts/tests/test-record.sh` | ~438, end | Docstring copied verbatim; the written file never formatted |

## 6. The fix

**Approach:** after the generated block is written, `test-record.sh` runs the project's own
Markdown formatter on the record (`syntax/format.sh --fix --file-type markdown --path <record>`).
The written file is then the formatter's fixed point whatever a docstring holds. A failed format
step exits `1`, naming the record, so the script never reports success on an unformatted file.
`--dry-run` still prints the raw block and formats nothing; a `--record` path outside the
repository is written but not formatted, and the script says so.

**Rejected:** converting ` ``x`` ` in `escape()` — it fixes one construct and breaks again on the
next, chasing Prettier rule by rule.

**Files touched:**

- `code/src/scripts/tests/test-record.sh` — the format step after the heredoc, and the exit-code
  header

## 7. Regression test (write the failing test FIRST — TDD)

**There is no automated regression test**, for the reason the sibling record gives: the generator's
Python is an inline heredoc nothing can import, and no probe script for `test-record.sh` exists.
The probe that record leaves open (a `pm-boards.sh`-style run against a fixture `--reports`
directory, then format-check and lint the result) would cover both defects; moving the heredoc
into an importable `_lib` module is the larger follow-up that would make them unit-testable.

The red and green are the reproduction in section 3:

- **Red (24/11/2026, before the fix):** `test-record.sh US014` exit `0` ("wrote 160 test rows"),
  then `format.sh --file-type markdown --path …/US014-TEST-STATUS.md` — "Formatting issues found";
  the record differed from the committed formatted copy by 134 lines.
- **Green (24/11/2026, after the fix):** `test-record.sh US014` exit `0`, printing "formatted
  …/US014-TEST-STATUS.md"; the same format check exit `0`, "All files are correctly formatted";
  `lint.sh --file-type markdown --path` on the record exit `0`; and a second regeneration left the
  record byte-identical to the committed copy (`git status` on it empty).

## 8. Impact & related stories

- **Impact:** every story with marked pytest tests whose docstrings use RST markup. The record could
  not be committed straight from the generator, and a hand formatting pass is a step a person
  forgets.
- **Related stories:** US014 (its record).
- **Related records:** `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` ·
  `BUG-US014-TEST-RECORD-ESCAPED-PIPE-SPLITS-CELL-24-11-2026.md` (the same generator, the same
  missing probe) · `BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md`.

## 9. Verification

- `bash code/src/scripts/tests/test-record.sh US014`: exit `0`, "wrote 160 test rows", "formatted
  project-management/src/18-TESTS/AUTOMATED/US014-TEST-STATUS.md".
- `bash code/src/scripts/syntax/format.sh --file-type markdown --path project-management/src/18-TESTS/AUTOMATED/US014-TEST-STATUS.md`: exit `0`.
- `bash code/src/scripts/tests/all.sh` was not re-run for this fix: the script changes no suite's
  outcome and is never a step inside a runner (`code/src/scripts/tests/CLAUDE.md`).

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing. A reproduction command was
      seen red then green; there is no automated test (section 7)
- [ ] `bash code/src/scripts/tests/all.sh` green — not re-run for this script-only change (section 9)
- [x] Root cause identified (symptom fix rejected: a hand formatting pass, or a per-construct rewrite)
- [ ] Fix merged under the story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US014.md` — the story this defect belongs to
- `../17-STORY-PLANS/14-STORY-PLAN-US014-STRUCTURED-JSON-LOGGING.md` — the code master the fix closes the loop on
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `code/src/scripts/tests/CLAUDE.md` — the generator's contract
- `../18-TESTS/AUTOMATED/US014-TEST-STATUS.md` — the record this defect affected
