# BUG: US002 — `docs-pairing.sh` mis-reports an unstaged deletion of a tracked half

| Field            | Value                                                                                                                             |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **Story**        | US002 — the audits register regains the headroom nine new gates need (surfaced by; the defect predates it)                        |
| **Story doc**    | `../02-STORIES/US002.md`                                                                                                          |
| **Story plan**   | `../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` → _Verification corrections, 03/11/2026 (QA triage)_, BITE-01 |
| **Severity**     | Low                                                                                                                               |
| **Date found**   | 03/11/2026                                                                                                                        |
| **Last Updated** | 03/11/2026                                                                                                                        |
| **Status**       | Open                                                                                                                              |
| **Found during** | QA breaker pass (M-3, L-7) and the manual walk — `../18-TESTS/MANUAL/US002-MANUAL-TESTING.md` row BITE-01                         |
| **Reporter**     | Claude, on Sam's behalf; finding F-014 in `../20-FINDINGS/FINDING-US002-AUDITS-REGISTER-HEADROOM-03-11-2026.md`                   |

Filed, not fixed: US002 is a docs-only story and its plan files this rather than changing the
script. No target story is named yet; the fix is unscheduled.

---

## 1. Summary

`bash code/src/scripts/audits/docs-pairing.sh` builds its population from the git index but opens
each file from disk, so a tracked `CONTEXT.md` or `CLAUDE.md` deleted in the working tree and not
yet staged breaks the run: a missing `CLAUDE.md` exits **2** with `grep` errors and **no finding**;
a missing `CONTEXT.md` exits 1 with the true finding plus **two false ones** against a file that
does not exist.

## 2. Environment

| Aspect      | Value                                                                |
| ----------- | -------------------------------------------------------------------- |
| **Surface** | Tooling — `code/src/scripts/audits/docs-pairing.sh`                  |
| **Route**   | N/A                                                                  |
| **Env**     | local (any checkout; CI checks out a clean tree and never sees this) |
| **Build**   | `us002/audits-register-headroom` at `43fe621`                        |

## 3. Reproduction steps

Run in a throwaway worktree so the real tree is untouched (reproduced this way 03/11/2026):

1. `git worktree add --detach /tmp/pairing-repro HEAD`, then work from `/tmp/pairing-repro`.
2. **Case A — a missing `CLAUDE.md`.** `mv code/src/scripts/audits/slop-family/CLAUDE.md /tmp/`
   (do not stage), then `bash code/src/scripts/audits/docs-pairing.sh`.
3. Observe: exit **2**; stderr carries
   `grep: code/src/scripts/audits/slop-family/CLAUDE.md: No such file or directory` three times;
   no finding names the folder, and no summary line prints.
4. Restore the file. **Case B — a missing `CONTEXT.md`.** `mv` the folder's `CONTEXT.md` aside the
   same way and run the gate again.
5. Observe: exit 1 with three findings — the true "slop-family/CLAUDE.md: no CONTEXT.md beside it",
   and two against the absent file: "slop-family/CONTEXT.md: no `## Directory Tree` fence" and the
   warning "no prose between the title and the first section", preceded by `grep` and `awk`
   "cannot open file" errors.
6. Restore it, confirm `docs-pairing.sh` exits 0, then `git worktree remove --force /tmp/pairing-repro`.

For contrast, the forms the walk found that behave: a **staged** deletion with the file gone from
disk (`git rm --cached` then remove it) exits 1 with exactly "no CLAUDE.md beside it"; `git rm
--cached` with the file left on disk exits 0, because the gate also collects untracked files.

## 4. Expected vs Actual

|              | Behaviour                                                                                                                                                                                   |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Expected** | Whatever the index state, a half missing from disk is reported once by Check 1 ("no CLAUDE.md beside it" / "no CONTEXT.md beside it"), exit 1, and no clause reads a file that is not there |
| **Actual**   | Case A: exit 2, `grep` errors, no finding. Case B: exit 1, the true finding plus two false findings against the missing file                                                                |

## 5. Root-cause analysis

The population is `git ls-files` (tracked) unioned with `git ls-files --others --exclude-standard`
(untracked) at `:250-253`. A tracked file deleted on disk but not in the index is still listed by
the first call. Check 1 tests the **sibling's** existence with `-f`, but never the listed file's
own, and Checks 2–9 then open the listed path directly.

| File                                      | Lines   | Issue                                                                                                                                                                                                                                                                          |
| ----------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `code/src/scripts/audits/docs-pairing.sh` | 250-253 | Population read from the index; a deleted-but-unstaged file survives into it                                                                                                                                                                                                   |
| `code/src/scripts/audits/docs-pairing.sh` | 297-316 | Checks 2–5 `grep` each listed `CLAUDE.md`. Under `set -euo pipefail` (`:44`), the unguarded pipeline at `:310` returns `grep`'s exit 2 and aborts the run before any finding is printed — Case A. The three stderr lines are `:299`, `:307` and `:310`, the last of them fatal |
| `code/src/scripts/audits/docs-pairing.sh` | 323-364 | Checks 6–9 and the warn tier read each listed `CONTEXT.md`; their failed-match guards turn a missing file into an empty match, which reads as "no tree fence" and "no prose" — Case B's false findings                                                                         |

## 6. The fix

**Approach:** after collecting, drop every listed path that does not exist on disk
(`[[ -f "$f" ]]`), so the checks only ever open real files and Check 1 alone reports the missing
half from the sibling's side. The wider alternative — collect from the filesystem rather than the
index — changes what the gate means by "tracked" and is not needed to close this defect.

**Files touched:** `code/src/scripts/audits/docs-pairing.sh` (not yet changed).

## 7. Regression test (write the failing test FIRST — TDD)

The audits have no test harness beyond `--self-test`, which `docs-pairing.sh` does not carry. The
regression check is the scripted run above.

| Test                                        | Location                                                     | Asserts                                                                                          |
| ------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| Unstaged deletion of a tracked `CLAUDE.md`  | `bash code/src/scripts/audits/docs-pairing.sh` in a worktree | Exit 1, exactly one finding naming the orphaned `CONTEXT.md`, no `grep` error on stderr          |
| Unstaged deletion of a tracked `CONTEXT.md` | Same                                                         | Exit 1, exactly one finding naming the orphaned `CLAUDE.md`, no finding against the missing file |

- **Red:** Case A exit 2 with no finding; Case B three findings (observed 03/11/2026).
- **Green:** exit 1 with one finding each, stderr clean.

## 8. Impact & related stories

- **Impact:** any local run of the gate mid-edit, and any manual-guide row that proves the gate
  bites by moving a file aside. CI is unaffected: it checks out a clean tree. A pre-commit run with
  an unstaged deletion is where an author meets it.
- **Related stories:** US002 (surfaced it; BITE-01 was amended to stage the deletion). US004 changes
  `doc-references.sh`'s dependence on the git index — the same class, a different script.
- **Related records:** `../18-TESTS/MANUAL/US002-MANUAL-TESTING.md` row BITE-01 ·
  `../19-REVIEWS/REVIEW-US002-AUDITS-REGISTER-HEADROOM.md` R-022, R-030 ·
  `../20-FINDINGS/FINDING-US002-AUDITS-REGISTER-HEADROOM-03-11-2026.md` F-004, F-014.

## 9. Verification

- `bash code/src/scripts/audits/docs-pairing.sh` — both reproduction cases as in Section 7, and
  exit 0 on the restored tree.

**Sign-off:**

- [ ] Regression check run red first, now green
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged under its story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US002.md` — the story whose QA pass and walk surfaced it
- `../17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — the plan that files it rather than fixing it
- `code/workflows/10-debug/` — the TDD debug procedure
- `code/docs/GATE-REPORTING.md` — why a gate that cannot read its input must not report as though it had
- `../18-TESTS/MANUAL/US002-MANUAL-TESTING.md` — the walk, row BITE-01
