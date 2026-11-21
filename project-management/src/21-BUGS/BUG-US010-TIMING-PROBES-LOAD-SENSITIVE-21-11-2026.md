# BUG: US010 — `shipped-boards.sh`'s three 2 s timing probes fail under load

| Field            | Value                                                                             |
| ---------------- | --------------------------------------------------------------------------------- |
| **Story**        | US010 — the register indexes become generated boards (re-cut 19/11/2026)          |
| **Story doc**    | `../02-STORIES/US010.md`                                                          |
| **Story plan**   | `../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md`                |
| **Target story** | N/A — not yet assigned; an open report, its fixing story is chosen at triage      |
| **Severity**     | Low                                                                               |
| **Date found**   | 21/11/2026                                                                        |
| **Last Updated** | 21/11/2026                                                                        |
| **Found during** | Build — fix round 10 replay; recorded at `22-implementation-documentation` Step 5 |
| **Reporter**     | Claude (fix round 10 session); filed by the gate-22 Step 5 subagent               |

**Status:** Open
**Status note:** Filed from finding F-038 in `../20-FINDINGS/FINDING-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md`. Not reproduced on demand; which probe failed is unmeasured

---

## 1. Summary

The self-test of `.github/scripts/shipped-boards.sh` holds three probes that give check 2 a
wall-clock budget of 2 s. On a loaded host one of them can fail, so the gate's self-test goes red
with no defect in the check.

## 2. Environment

| Aspect      | Value                                                                                                 |
| ----------- | ----------------------------------------------------------------------------------------------------- |
| **Surface** | Gate (`.github/scripts/`), run by `template-integrity.sh --self-tests` and the pre-push leg           |
| **Route**   | N/A — no route                                                                                        |
| **Env**     | local, 16 cores, four concurrent `--self-tests` runs (36 self-tests at once)                          |
| **Build**   | `05751282` (fix round 10), on `us010/seeded-register-indexes`; the probes are unchanged at `7d54df26` |

## 3. Reproduction steps

As recorded in `../18-TESTS/MANUAL/US010-MANUAL-TESTING.md` → _Fix round 10 — 21/11/2026_,
_Deviations_:

1. In a scratch copy, start four `bash .github/scripts/template-integrity.sh --self-tests <sha>`
   runs at once on a 16-core host.
2. Observe: `05751282`'s replay read red once among them, and green when run alone.
3. Two load runs did not reproduce it: eight concurrent `shipped-boards.sh --self-test`, then
   three `--self-tests HEAD` with four self-tests beside them.

## 4. Expected vs Actual

|              | Behaviour                                                                                                      |
| ------------ | -------------------------------------------------------------------------------------------------------------- |
| **Expected** | The self-test passes or fails on what check 2 does, independent of host load                                   |
| **Actual**   | One replay went red under load, green alone. The failing probe is outside the logged tail, so it is unmeasured |

## 5. Root-cause analysis

Inferred, not confirmed (TODO(verify)): each timing probe starts check 2 in the background and
polls `kill -0` twenty times at 0.1 s. If the process is still alive after that, it is killed
and the probe is recorded as failing. The budget is wall-clock time, so CPU contention counts
against the check. The shape of the one red points at one of these three probes, but no log
names it.

| File                                | Lines    | Issue                                                                         |
| ----------------------------------- | -------- | ----------------------------------------------------------------------------- |
| `.github/scripts/shipped-boards.sh` | ~546-559 | "check 2 reads a 500-separator word inside 2 s" — wall-clock poll budget      |
| `.github/scripts/shipped-boards.sh` | ~562-579 | "check 2 reads 300 brace spans inside 2 s and reports the cap" — the same     |
| `.github/scripts/shipped-boards.sh` | ~582-599 | "check 2 reads a 16 KB word inside 2 s and reports the length cap" — the same |

## 6. The fix

Not applied; this record does not fix anything. The fix lands in a later story.

**Approach (proposed):** bound the work rather than the wall clock (for example, a cap on the
steps or comparisons check 2 performs, asserted directly), or widen the budget. Either option is a
probe edit and so a TM-15 event, and it must be reviewed as one. The fix round 10 record left it
unrepaired for that reason.

**Files touched:** to be named by the fixing story.

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                        | Location                                                            | Asserts                                                           |
| ------------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------- |
| A load harness over the three timing probes | `.github/scripts/shipped-boards.sh` self-test, or a scratch harness | Each probe's verdict is the same under N concurrent runs as alone |

- **Red:** to be recorded by the fixing story. A red that cannot be made to fail on demand is a
  guard, and must be recorded as one.
- **Green:** to be recorded.

## 8. Impact & related stories

- **Impact:** a flaky red in a required gate's self-test (`[1/4]` and the pre-push leg). It
  trains people to re-run rather than read. Nothing ships wrong.
- **Related stories:** US012 extends the `.github/scripts` gates next.
- **Related records:** `../20-FINDINGS/FINDING-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md`
  F-038 (and F-037, the 750-line limit) · `../18-TESTS/AUTOMATED/US010-TEST-STATUS.md` Section 3.

## 9. Verification

- `bash .github/scripts/shipped-boards.sh --self-test` — green alone and under load.
- `bash .github/scripts/template-integrity.sh --self-tests HEAD` — `0 red`.

**Sign-off:**

- [ ] Regression test written **first**, seen to fail, now passing
- [ ] `bash code/src/scripts/tests/all.sh` green
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged under the story branch; **Status** flipped to `Fixed`, then `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US010.md` — the story this defect belongs to
- `../17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the code master
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `../18-TESTS/MANUAL/US010-MANUAL-TESTING.md` → _Fix round 10 — 21/11/2026_ — where it was recorded
