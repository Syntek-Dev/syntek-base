# BUG: US013 — a hung graphify run leaves the graph hook reporting the last success indefinitely

| Field            | Value                                                                                                              |
| ---------------- | ------------------------------------------------------------------------------------------------------------------ |
| **Story**        | US013 — the 09 debugging workflow runs through the scripts (widened 23/11/2026: graphify beside code-review-graph) |
| **Story doc**    | `../02-STORIES/US013.md`                                                                                           |
| **Story plan**   | `../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`                                                 |
| **Target story** | US013 — fixed on its own branch before its PR                                                                      |
| **Severity**     | Medium (with two Low defects in the same run path, fixed together)                                                 |
| **Date found**   | 23/11/2026                                                                                                         |
| **Last Updated** | 23/11/2026                                                                                                         |
| **Found during** | Manual walk — an out-of-scope observation by the independent GRAPH-row walker's `qa-tester` pass                   |
| **Reporter**     | Claude (independent walker, `qa-tester`); fixed through `bugfix` at <%DEVELOPER_NAME%>'s instruction               |

**Status:** Open
**Status note:** Fix committed on `us013/log-debug-workflow-seam`; `Fixed` when the US013 PR merges, `Verified` once seen to hold after it

---

## 1. Summary

`.claude/hooks/graph-update.sh` ran `graphify update .` with no time limit, so a hung run held the
lock and its `graphify.running` marker for as long as it hung, and both the per-edit hook and
lefthook's `--commit` step went on reporting the previous run's `ok`. That is "could not look"
reported as "looked, and it was clean", which `code/docs/GATE-REPORTING.md` forbids. Two Low
defects sat in the same run path: a failed `mktemp` left the marker behind, and the reader's
lock probe could make a new run give up.

## 2. Environment

| Aspect      | Value                                                                              |
| ----------- | ---------------------------------------------------------------------------------- |
| **Surface** | Claude Code `PostToolUse` hook and the lefthook pre-commit `graphify` step (shell) |
| **Route**   | N/A — `.claude/hooks/graph-update.sh`, per edit and `--commit`                     |
| **Env**     | local (any host with `graphify` and `flock` on PATH)                               |
| **Build**   | `us013/log-debug-workflow-seam` at `26d7237c`                                      |

## 3. Reproduction steps

Each was reproduced in a scratch git repository with stub tools on PATH, never the real
graphify and never `--force`.

1. **Medium.** Stub `graphify` to sleep indefinitely. Let one run succeed first (`exit=0` in
   `.code-review-graph/graphify.last`), then edit so the hook starts the hanging run.
2. Edit again, and commit: the per-edit hook says nothing and `--commit` prints nothing.
3. Observe: the hung run holds the lock indefinitely; every later run fails `flock -n` and exits;
   the last `ok` stands for as long as the hang lasts.
4. **Low 1.** Put a failing `mktemp` first on PATH and trigger a run: `graphify.running` is left
   behind, every later call reports "did not finish (killed or interrupted)" and starts the
   same tree again.
5. **Low 2.** Hold `graphify.lock` for an instant as a run starts (what `lock_free` does on every
   call): the run's `flock -n` fails and it exits without running.

## 4. Expected vs Actual

|              | Behaviour                                                                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Expected** | A run that cannot finish is bounded and reported unmeasured with its cause; a run that cannot record its output says so once; a reader's probe never stops a run |
| **Actual**   | A hung run is silent indefinitely behind the last `ok`; a `mktemp` failure reads as "killed" and restarts on every call; a probe can cancel a run                |

## 5. Root-cause analysis

The run took the lock and wrote its marker, then ran graphify unbounded. While it ran, the reader
saw the marker with the lock held — "in flight" — and fell through to the last recorded outcome.
Nothing bounded "in flight", so a hang was indistinguishable from a long run, for ever. The
marker was written before the run's one fallible step, so a failure there left an orphan marker
that the reader correctly took for a killed run. And `lock_free` tests the lock by taking it,
which an immediate `flock -n` cannot tell apart from a live run.

Line numbers are those at `26d7237c`, before the fix.

| File                            | Lines        | Issue                                                                                |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------------ |
| `.claude/hooks/graph-update.sh` | 125          | `graphify update .` with no time limit                                               |
| `.claude/hooks/graph-update.sh` | 174-177      | marker plus held lock read as "in flight", falling through to the last `exit=0`      |
| `.claude/hooks/graph-update.sh` | 122, 124     | marker written before `mktemp`; on failure the run exits and leaves it               |
| `.claude/hooks/graph-update.sh` | 104-106, 119 | `lock_free` briefly takes the lock; the run's `flock -n 9` gives up if it lands then |

## 6. The fix

**Approach:** decided with <%DEVELOPER_NAME%> in a `bugfix` grilling round, 23/11/2026 (Q1 to
Q5), then widened after the first QA pass (M1, M2, L1):

- graphify runs as `timeout -k 10 <bound> graphify update .` with the lock descriptor closed for
  it, so no descendant of a stopped graphify keeps the lock. The bound is 600 s, or
  `GRAPH_UPDATE_GRAPHIFY_TIMEOUT` (a positive integer without a leading zero, else 600).
- A run the bound stopped (exit 124, or 137 after the kill grace, and at least the bound
  elapsed) writes `timeout=<bound>` immediately before its `exit=` trailer. The reader reports
  `timed out after <N> s` from that line alone, so graphify's own 124 or 137 is an ordinary
  failure and the bound shown is the run's, not the reader's.
- `timeout` missing from PATH is a new unmeasured state, `notimeout`, that starts no run — as a
  missing `flock` already was.
- A failed `mktemp` writes its failure straight to `graphify.last` and clears the marker; if
  even that write fails, the marker stays and "killed" is honest.
- The run takes the lock with `flock -w 1`, outlasting any reader's probe while a genuinely held
  lock still ends a second run.

**Files touched:**

- `.claude/hooks/graph-update.sh` — the fix and its header comment
- `code/src/scripts/tests/graph-update.sh` — the regression probes (below)
- `.claude/hooks/CONTEXT.md` · `.claude/hooks/CLAUDE.md` · `code/docs/CODE-REVIEW-GRAPH.md` ·
  `how-to/src/TEMPLATE-GUIDE/03-PREREQUISITES.md` · `.github/workflows/audit-template.yml` —
  `timeout` as a host prerequisite, and timed out among the unmeasured states

## 7. Regression test (write the failing test FIRST — TDD)

Written by a dispatched `test-writer`, separate from the fixer, in two loops; each seen red
against the hook as it then stood, before its fix.

| Test (probe group) | Location                                 | Asserts                                                                                                                 |
| ------------------ | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `timeout`          | `code/src/scripts/tests/graph-update.sh` | a 5 s graphify under a 1 s bound ends `timeout=1` then `exit=124`, reported timed out once per edit and on every commit |
| `timeout-kill`     | same                                     | a TERM-ignoring graphify killed after the grace ends `timeout=1` / `exit=137` and reads as timed out, never failed      |
| `timeout-reader`   | same                                     | a timeout recorded under a 1 s bound is reported as 1 s by a reader with no override, never 600 s                       |
| `rc124`            | same                                     | graphify's own exit 124 is reported as a failure, never as timed out                                                    |
| `timeout-env`      | same                                     | `1.5`, `10m`, `010`, `0`, empty and a leading-space `5` each run with the 600 s bound                                   |
| `notimeout`        | same                                     | no `timeout` on PATH: reported unmeasured, and no run starts                                                            |
| `mktemp`           | same                                     | a failing `mktemp` records a failure, leaves no marker, is reported failed (never killed), and restarts nothing         |
| `lockwait`         | same                                     | a lock held 0.7 s as a run starts does not stop it; one held 2.5 s still starts no second graphify                      |

- **Red:** loop 1, 151 passed and 14 failed (the four groups above from `notimeout` down, plus
  `timeout`); loop 2, 187 passed and 12 failed (`timeout`'s marker check, `timeout-kill`,
  `timeout-reader`, `rc124`). Every existing probe stayed green both times.
- **Green:** 199 passed, 0 failed, on every run after the fix — the fixer's three, and three
  more by the independent QA pass.

## 8. Impact & related stories

- **Impact:** every developer session and every commit on a host with graphify. graphify is
  advisory and never blocks, so nothing was corrupted; the harm was a stale cross-artefact graph
  presented as current, against the story's own gate-reporting doctrine.
- **Related stories:** US013 introduced the hook's graphify run (P9 to P13, `b04b278b`).
- **Related records:** `../18-TESTS/MANUAL/US013-MANUAL-TESTING.md` rows GRAPH-03 and GRAPH-04
  (walked before the fix) · `../18-TESTS/AUTOMATED/US013-TEST-STATUS.md` ·
  `../20-FINDINGS/FINDING-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md`.
- **Left open, Low — findings F-018 and F-019, routed to `GAPS.md`:** graphify printing a `timeout=<N>` line of
  its own as the penultimate line, with an ordinary failure exit, reads as timed out — still
  unmeasured, never `ok`; and the `mktemp`-failure branch writes `graphify.last` in place rather
  than by rename, so a reader landing in that instant sees no outcome for one call.

## 9. Verification

- `bash code/src/scripts/tests/graph-update.sh` — 199 passed, 0 failed.
- `bash code/src/scripts/tests/template-hooks.sh` — 69 passed, 0 failed.
- `bash code/src/scripts/tests/hook-arming.sh` — 432 passed, 0 failed, 1 unmeasured (`[ES-01]`,
  the CI-only `install.sh` step).
- `shellcheck` on the hook and the suite — clean.
- `bash code/src/scripts/tests/all.sh` — all suites passed, 23/11/2026, on the fixed working
  tree. It touches no Django code; the three hook suites above are the ones that exercise it.

**Sign-off:**

- [x] Regression test written **first**, seen to fail, now passing
- [x] `bash code/src/scripts/tests/all.sh` green
- [x] Root cause identified (symptom fix rejected)
- [ ] Fix merged under the story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US013.md` — the story this defect belongs to
- `../17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md` — the code master the fix closes the loop on
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `code/docs/GATE-REPORTING.md` — the rule the defect broke
- `../18-TESTS/MANUAL/` · `../18-TESTS/AUTOMATED/` — the walked manual testing guide and the automated test record from the same PR
