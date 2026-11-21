# BUG: `tests/server.sh up` prints the worktree test URL on the wrong port

| Field            | Value                                                                                                                  |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Story**        | N/A — cross-cutting (surfaced by US006)                                                                                |
| **Story doc**    | N/A — surfaced in `../02-STORIES/US006.md`'s walk                                                                      |
| **Story plan**   | N/A — cross-cutting                                                                                                    |
| **Severity**     | Low                                                                                                                    |
| **Date found**   | 15/11/2026                                                                                                             |
| **Last Updated** | 15/11/2026                                                                                                             |
| **Found during** | Manual walk — the stack-dependent rows of `../18-TESTS/MANUAL/US006-MANUAL-TESTING.md`, on a us006 stack               |
| **Reporter**     | Claude, on the developer's behalf; finding F-019 in `../20-FINDINGS/archive/FINDING-US006-POSTURE-GUARD-15-11-2026.md` |

**Status:** Open

Filed for a later fix (developer decision, 15/11/2026): **not fixed in US006**. The defect is in
the worktree tooling, which predates US006 and which the story's posture guard does not touch, so
it takes the cross-cutting filename. No target story is named yet; the fix is unscheduled.

---

## 1. Summary

On a worktree branch with a per-story test override, `bash code/src/scripts/tests/server.sh up`
prints the site and API URLs on port `<story number>081` — `6081` for us006 — while the override
publishes nginx on `3081`. An operator following the printed URL reaches nothing.

## 2. Environment

| Aspect      | Value                                                                                 |
| ----------- | ------------------------------------------------------------------------------------- |
| **Surface** | Tooling — `code/src/scripts/tests/server.sh`, the `up` success message                |
| **Route**   | N/A — the printed `test-usNNN.` host URL                                              |
| **Env**     | local, a `us###/` branch with `code/src/docker/docker-compose.us###.test.yml` present |
| **Build**   | `us006/posture-guard` on `fbd9dbc`; the line dates from `ee5c2bb` (01/08/2026)        |

## 3. Reproduction steps

Reproducible by reading the two files; no stack needs starting.

1. Open `code/src/docker/docker-compose.usXXX.test.yml.example`: nginx publishes
   `"127.0.0.NNN:3081:80"`, and the header gives the test URL as `test-usNNN.<slug>.localhost:3081`.
2. Open `code/src/scripts/tests/server.sh`, the `up)` branch (lines 150 to 153): with an override
   detected it sets `_n=$((10#$WORKTREE_US_NUM))` and prints `…localhost:${_n}081`.
3. On branch `us006/…`, `WORKTREE_US_NUM` is `006` (`_lib/worktree-detect.sh`), so `_n` is `6` and
   the printed port is `6081`.
4. Observe: the printed URL names port 6081; the stack listens on `127.0.0.6:3081`. Seen live
   during the US006 walk on a disposable us006 test stack.

## 4. Expected vs Actual

|              | Behaviour                                                                                       |
| ------------ | ----------------------------------------------------------------------------------------------- |
| **Expected** | `Site: http://test-us006.<slug>.localhost:3081` — the port the override publishes               |
| **Actual**   | `Site: http://test-us006.<slug>.localhost:6081` — and `42081` for us042; above us065 not a port |

## 5. Root-cause analysis

The port is built from the story number instead of the override's fixed `3081`. Isolation per
story is by loopback IP (`127.0.0.NNN`), not by port, so the story number has no place in the port.
The dev-stack counterpart had the same class of fault and was corrected on 23/08/2026
(`development/server.sh` now prints `:3080`, with a comment explaining why); the test script was
not changed with it. `how-to/docs/GIT-WORKTREES.md` already documents `:3081`.

| File                               | Lines   | Issue                                             |
| ---------------------------------- | ------- | ------------------------------------------------- |
| `code/src/scripts/tests/server.sh` | 151-153 | `${_n}081` derives the port from the story number |

## 6. The fix

**Approach:** print the port the override publishes — `:3081`, mirroring the dev script's
`:3080` and its explanatory comment — or derive it from the override's `ports:` binding so the two
cannot drift again. Drop `_n`, which then has no use.

**Files touched:** `code/src/scripts/tests/server.sh` (not yet changed).

## 7. Regression test (write the failing test FIRST — TDD)

No harness renders the `up` message without a stack. The nearest seam is a structural check of
the script's text, in the style of the US006 self-test's structural cases.

| Test                   | Location                                                   | Asserts                                                                                  |
| ---------------------- | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Worktree test URL port | a structural check over `code/src/scripts/tests/server.sh` | The override branch prints the port the `.example` override publishes, and no `${_n}081` |

- **Red:** the check fails against the current line 152 (`${_n}081`).
- **Green:** the check passes once the script prints `3081`.

## 8. Impact & related stories

- **Impact:** every worktree test stack: the printed URL is wrong, though the stack itself is fine.
  `.claude/CLAUDE.md` Section 7 names `server.sh up` as the place a URL is read from, so a wrong
  line misleads by design. No manual row in US006 asserts the URL, so no row failed.
- **Related stories:** US006 (surfaced it; does not fix it).
- **Related records:** `../20-FINDINGS/archive/FINDING-US006-POSTURE-GUARD-15-11-2026.md` F-019 ·
  `../18-TESTS/MANUAL/US006-MANUAL-TESTING.md` _Failures_.

## 9. Verification

- The structural check above, red then green.
- `bash code/src/scripts/tests/server.sh up` on a worktree branch with its test override: the
  printed URL answers.

**Sign-off:**

- [ ] Regression check written **first**, seen to fail, now passing
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged under its story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US006.md` — the story whose walk surfaced it
- `../20-FINDINGS/archive/FINDING-US006-POSTURE-GUARD-15-11-2026.md` — F-019
- `code/src/docker/docker-compose.usXXX.test.yml.example` — the binding the URL must match
- `how-to/docs/GIT-WORKTREES.md` — the documented worktree URLs
- `code/workflows/10-debug/` — the TDD debug procedure
