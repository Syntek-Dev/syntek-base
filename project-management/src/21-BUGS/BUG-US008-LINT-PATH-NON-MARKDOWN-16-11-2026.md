# BUG: US008 — `lint.sh --path` runs markdownlint over a non-Markdown file

| Field            | Value                                                                                                 |
| ---------------- | ----------------------------------------------------------------------------------------------------- |
| **Story**        | US008 — host-only `__Host-` cookies (surfaced during its build; **not caused by it**)                 |
| **Story doc**    | `../02-STORIES/US008.md`                                                                              |
| **Story plan**   | `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`                                          |
| **Severity**     | Low — a false red on a scoped run; the unscoped run is unaffected                                     |
| **Date found**   | 16/11/2026                                                                                            |
| **Last Updated** | 16/11/2026                                                                                            |
| **Found during** | Build and closeout tooling (findings record Section 2.3) — scoping the lint to one shell or YAML file |
| **Reporter**     | Claude (`22-implementation-documentation` Step 5), from finding F-033                                 |

**Status:** Open

---

## 1. Summary

`code/src/scripts/syntax/lint.sh --path <file>` hands any single **file** to markdownlint whatever
its extension, so a `.sh` or `.yml` path is linted as Markdown and the run fails on hundreds of
bogus errors (every `#` comment read as a heading).

## 2. Environment

| Aspect      | Value                                                         |
| ----------- | ------------------------------------------------------------- |
| **Surface** | Dev tooling — `code/src/scripts/syntax/lint.sh`, Markdown leg |
| **Route**   | N/A                                                           |
| **Env**     | local (host markdownlint via pnpm)                            |
| **Build**   | `us008/host-only-cookies` at `43acdf5`                        |

## 3. Reproduction steps

Reproduced 16/11/2026 in the working tree (read-only — no `--fix`):

1. `bash code/src/scripts/syntax/lint.sh --path code/src/scripts/syntax/lint.sh --file-type markdown`
2. Observe: exit 1, `Summary: 223 issues in 1 file` — MD022, MD023 and MD026 on shell comments.
3. `bash code/src/scripts/syntax/lint.sh --path code/src/docker/docker-compose.dev.yml --file-type markdown`
4. Observe: exit 1, 18 markdownlint errors on a YAML file.

Without `--file-type`, the same paths still run the Markdown leg, so the default invocation fails
the same way.

## 4. Expected vs Actual

|              | Behaviour                                                                                                          |
| ------------ | ------------------------------------------------------------------------------------------------------------------ |
| **Expected** | A non-`.md` file is not a Markdown target: the leg says "no .md files under '<path>' — nothing to lint" and passes |
| **Actual**   | The file is passed to markdownlint as a literal target and every comment line is judged as Markdown                |

## 5. Root-cause analysis

The directory branch filters by extension; the file branch does not.

| File                              | Lines   | Issue                                                                                          |
| --------------------------------- | ------- | ---------------------------------------------------------------------------------------------- |
| `code/src/scripts/syntax/lint.sh` | 303-305 | Directory `--path`: `find … -name '*.md'` — correctly narrowed to Markdown                     |
| `code/src/scripts/syntax/lint.sh` | 306-307 | File `--path`: `md_targets+=(":$TARGET_PATH")` with no `*.md` test — any file becomes a target |

The empty-scope guard at `:316-317` already prints the honest "nothing to lint" line when
`md_targets` is empty; the file branch simply never leaves it empty.

`TODO(verify)`: with `--fix`, markdownlint-cli2 would presumably **rewrite** the non-Markdown file
to satisfy MD022 and friends — not run, because it would mutate a tracked file.

## 6. The fix

Not applied — recorded only.

**Approach (smallest):** in the file branch, add the target only when it ends in `.md`, so a
non-Markdown file falls through to the existing "no .md files" line. Apply the same per-extension
routing to the other `--path` legs that take a single file, if any lack it (`TODO(verify)` — the
Python leg narrows by directory prefix at `:262`, not by extension).

**Files touched (expected):**

- `code/src/scripts/syntax/lint.sh` — `*.md` test on the single-file `--path` branch

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                            | Location                                                 | Asserts                                                                              |
| ----------------------------------------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `--path` on a shell file `TODO(verify)` harness | a script self-test or a bats-style case beside `lint.sh` | `lint.sh --path <some>.sh --file-type markdown` exits 0 and prints "nothing to lint" |

- **Red:** exit 1 with markdownlint errors, as in Section 3.
- **Green:** exit 0, "no .md files under '<path>' — nothing to lint".

## 8. Impact & related stories

- **Impact:** anyone scoping the lint to one non-Markdown file — the documented `format.sh` /
  `lint.sh --path <f>` closeout loop. The unscoped and directory-scoped runs are unaffected.
- **Related stories:** US008 (where it surfaced).
- **Related records:** `../20-FINDINGS/archive/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` F-033 ·
  `BUG-LINT-READS-GITIGNORED-GRAPHIFY-OUT-02-11-2026.md` (another scoping defect in the same leg).

## 9. Verification

- The two commands in Section 3 exit 0 with the "nothing to lint" line.
- `bash code/src/scripts/syntax/lint.sh` — the unscoped run unchanged.
- `bash code/src/scripts/tests/all.sh` — green.

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing
- [ ] `bash code/src/scripts/tests/all.sh` green
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../20-FINDINGS/archive/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` — finding F-033
- `code/src/scripts/syntax/lint.sh` — the script at fault
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
