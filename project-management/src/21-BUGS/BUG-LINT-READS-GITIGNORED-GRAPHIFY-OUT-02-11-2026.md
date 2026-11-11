# BUG: Markdown lint reads the gitignored `graphify-out/` and fails on a file nobody ships

| Field            | Value                                                                                                              |
| ---------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Story**        | N/A — cross-cutting (surfaced by US007)                                                                            |
| **Story doc**    | N/A — surfaced in `../02-STORIES/US007.md`'s walk                                                                  |
| **Story plan**   | N/A — cross-cutting                                                                                                |
| **Severity**     | Low                                                                                                                |
| **Date found**   | 02/11/2026                                                                                                         |
| **Last Updated** | 02/11/2026                                                                                                         |
| **Status**       | Open                                                                                                               |
| **Found during** | Manual walk — `../18-TESTS/MANUAL/US007-MANUAL-TESTING.md` row GATES-09                                            |
| **Reporter**     | Claude, on Sam's behalf; finding F-002 in `../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` |

Filed for a later fix (Sam, 02/11/2026). No target story is named yet; the fix is unscheduled.

---

## 1. Summary

`bash code/src/scripts/syntax/lint.sh --file-type markdown` exits 1 on any machine that has run
graphify, because markdownlint-cli2 lints the gitignored `graphify-out/GRAPH_REPORT.md`. A local
run of the gate therefore fails on a file that is never committed, and cannot isolate the Markdown
a change actually ships.

## 2. Environment

| Aspect      | Value                                                       |
| ----------- | ----------------------------------------------------------- |
| **Surface** | Tooling — `code/src/scripts/syntax/lint.sh`, Markdown leg   |
| **Route**   | N/A                                                         |
| **Env**     | local, where `graphify-out/` exists (CI has no such folder) |
| **Build**   | `us007/status-vocabulary-one-owner` on `a9378ec`            |

## 3. Reproduction steps

1. Have a `graphify-out/` folder at the repository root (any graphify run writes one; it is
   listed in `.gitignore`).
2. Run `bash code/src/scripts/syntax/lint.sh --file-type markdown`.
3. Observe: exit 1, with every reported error inside `graphify-out/GRAPH_REPORT.md` (330 on
   02/11/2026).

## 4. Expected vs Actual

|              | Behaviour                                                                 |
| ------------ | ------------------------------------------------------------------------- |
| **Expected** | The Markdown leg lints tracked and committable Markdown only, and exits 0 |
| **Actual**   | It lints a gitignored local tool output and exits 1                       |

## 5. Root-cause analysis

markdownlint-cli2 takes its file set from the config's `globs` plus the CLI arguments, and drops
only what the config's `ignores` names. `.gitignore` is not consulted. `graphify-out/` is in
`.gitignore` (`:116-117`) but absent from `.markdownlint-cli2.jsonc` → `ignores` (`:30-43`), which
already excludes other generated output (`code/src/scripts/**/reports/**`,
`code/src/rust/target/**`) for the same reason.

| File                       | Lines   | Issue                                                  |
| -------------------------- | ------- | ------------------------------------------------------ |
| `.markdownlint-cli2.jsonc` | 30-43   | `ignores` has no `graphify-out/**` entry               |
| `.gitignore`               | 116-117 | `graphify-out/` is ignored for git, not for the linter |

## 6. The fix

**Approach:** add `"graphify-out/**"` to `.markdownlint-cli2.jsonc` → `ignores`, with a comment
naming it as local regenerated output. The wider alternative — have `lint.sh` select tracked files
only — is a larger change and is not needed to close this defect.

**Files touched:** `.markdownlint-cli2.jsonc` (not yet changed).

## 7. Regression test (write the failing test FIRST — TDD)

There is no test harness for the lint configuration. The regression check is a scripted run.

| Test                                | Location                                               | Asserts                                                         |
| ----------------------------------- | ------------------------------------------------------ | --------------------------------------------------------------- |
| Lint with a `graphify-out/` present | `code/src/scripts/syntax/lint.sh --file-type markdown` | With a `graphify-out/GRAPH_REPORT.md` that breaks rules, exit 0 |

- **Red:** exit 1 with errors in `graphify-out/GRAPH_REPORT.md` (observed 02/11/2026).
- **Green:** exit 0, with `graphify-out/` unread.

## 8. Impact & related stories

- **Impact:** every local `lint.sh` run on a machine that uses graphify; any manual-guide row that
  asks for the Markdown leg to exit 0. CI is unaffected.
- **Related stories:** US007 (surfaced it).
- **Related records:** `../18-TESTS/MANUAL/US007-MANUAL-TESTING.md` row GATES-09 ·
  `../20-FINDINGS/FINDING-US007-STATUS-VOCABULARY-ONE-OWNER-02-11-2026.md` F-002.

## 9. Verification

- `bash code/src/scripts/syntax/lint.sh --file-type markdown` — exit 0 with `graphify-out/` present.

**Sign-off:**

- [ ] Regression check run red first, now green
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged under its story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US007.md` — the story whose walk surfaced it
- `code/workflows/10-debug/` — the TDD debug procedure
- `../18-TESTS/MANUAL/US007-MANUAL-TESTING.md` — the walk, row GATES-09
