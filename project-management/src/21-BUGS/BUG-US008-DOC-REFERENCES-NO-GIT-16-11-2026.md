# BUG: US008 — `doc-references.sh` outside a git work tree reports "Nothing to check" and exits 0

| Field            | Value                                                                                          |
| ---------------- | ---------------------------------------------------------------------------------------------- |
| **Story**        | US008 — host-only `__Host-` cookies (surfaced by its walk; **not caused by it**)               |
| **Story doc**    | `../02-STORIES/US008.md`                                                                       |
| **Story plan**   | `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`                                   |
| **Severity**     | Low — a false green, but only off the normal path (CI and the hooks run inside a repository)   |
| **Date found**   | 16/11/2026                                                                                     |
| **Last Updated** | 16/11/2026                                                                                     |
| **Status**       | Open                                                                                           |
| **Found during** | Manual walk — CITE-05 of `../18-TESTS/MANUAL/US008-MANUAL-TESTING.md`, in a `git archive` copy |
| **Reporter**     | Claude (`22-implementation-documentation` Step 5), from finding F-035                          |

---

## 1. Summary

Run in a directory that is not a git work tree, `code/src/scripts/audits/doc-references.sh` prints
two `fatal: not a git repository` errors, reads **0 files**, and exits **0** with "Nothing to check"
— a could-not-look reported as an absent surface (`code/docs/GATE-REPORTING.md`).

## 2. Environment

| Aspect      | Value                                                    |
| ----------- | -------------------------------------------------------- |
| **Surface** | Audit gate — `code/src/scripts/audits/doc-references.sh` |
| **Route**   | N/A                                                      |
| **Env**     | local — any tree without `.git` (a `git archive` export) |
| **Build**   | `us008/host-only-cookies` at `43acdf5`                   |

## 3. Reproduction steps

Reproduced 16/11/2026 in a scratch copy:

1. `T=$(mktemp -d) && git archive HEAD | tar -x -C "$T" && cd "$T"`
2. `bash code/src/scripts/audits/doc-references.sh --path project-management/src/21-BUGS`
3. Observe: two `fatal: not a git repository (or any parent up to mount point /)` lines on stderr,
   then `read 0 file(s)`, `checked 0 backticked token(s)`, and
   **"Nothing to check — nothing eligible to read under project-management/src/21-BUGS."**
4. Exit status **0**. The same scope inside the repository reads every file in the folder.

The walk met the same at CITE-05 and worked around it with `git init` and a scratch commit
(_Walk provenance_).

## 4. Expected vs Actual

|              | Behaviour                                                                                                                    |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| **Expected** | No index to read is an absent **tool**, not an absent surface: exit **2** with "not a git repository — could not list files" |
| **Actual**   | Exit **0** with the absent-surface verdict "Nothing to check" over a tree full of citations                                  |

## 5. Root-cause analysis

The file population comes from git alone, and the failure is swallowed.

| File                                        | Lines     | Issue                                                                                                                         |
| ------------------------------------------- | --------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/audits/doc-references.sh` | 428-431   | `repo_files()` pipes `git ls-files` (tracked and untracked) through `sort -u \|\| true` — a git failure becomes an empty list |
| `code/src/scripts/audits/doc-references.sh` | 3705-3709 | `scanned_files -eq 0` is read as a legitimately empty population and printed as "Nothing to check", exit 0                    |

The script already distinguishes a scope that does not exist (exit 2, `:365-368`) and a scope git
never writes; it has no guard for git itself being unable to answer. The comment at `:3706-3708`
states the very rule this breaks: exit 0 is honest only while the population was genuinely empty.

## 6. The fix

Not applied — recorded only.

**Approach (smallest):** before building the population, test `git rev-parse --is-inside-work-tree`
and `die` with exit 2 and "not a git repository — no index to read, nothing was checked" when it
fails. Leave the `|| true` for the genuinely-empty case, or drop it once the guard precedes it.

**Files touched (expected):**

- `code/src/scripts/audits/doc-references.sh` — the work-tree guard, and a `--self-test` case for it
- `code/src/scripts/audits/CONTEXT.md` — only if its row restates the exit codes (`TODO(verify)`)

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                   | Location                                                  | Asserts                                                                                             |
| -------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| A `--self-test` case: no git work tree | `code/src/scripts/audits/doc-references.sh` `--self-test` | Run in a `git archive` scratch with no `.git`, the gate exits 2 and never prints "Nothing to check" |

- **Red:** exit 0 with "Nothing to check", as in Section 3.
- **Green:** exit 2 with the not-a-repository message.

## 8. Impact & related stories

- **Impact:** anyone running the citation gate on an exported tree — a manual walk's scratch copy,
  a release tarball, a container build context. CI and lefthook run inside a repository and are not
  affected, which is why it is Low.
- **Related stories:** US008 (where it surfaced).
- **Related records:** `../20-FINDINGS/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` F-035 ·
  `../18-TESTS/MANUAL/US008-MANUAL-TESTING.md` CITE-05 and _Walk provenance_.

## 9. Verification

- The Section 3 commands exit 2 with the new message; the same scope in the repository is unchanged.
- `bash code/src/scripts/audits/doc-references.sh --self-test` — green, including the new case.
- `bash code/src/scripts/tests/all.sh` — green.

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing
- [ ] `bash code/src/scripts/tests/all.sh` green
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../20-FINDINGS/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` — finding F-035
- `code/docs/GATE-REPORTING.md` — absent tool versus absent surface
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
