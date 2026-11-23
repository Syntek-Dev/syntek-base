# Handoff — US012 seed presence gate — 22/11/2026

## Goal

Ship US012 on branch `us012/seed-presence-gate`. Check 4 of `.github/scripts/shipped-artefacts.sh`
now asserts every `SEEDED` file landed, with its own `--self-test` probe shown red before green.
The build and review are done. What is left: close gate `22`, commit its records, and raise the PR
to `dev`, which then goes up the chain `dev` -> `testing` -> `staging` -> `main`.

## Done (committed and pushed to `origin/us012/seed-presence-gate`)

- `e004d23f`: plan corrected at build start. See the `CORRECTED 22/11/2026` block near the top of
  `project-management/src/17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md`. The story
  amendment "probe count 8 -> 9" is in `project-management/src/02-STORIES/US012.md`.
- `66c9607f`: US012 moved `Pending` -> `In Progress`, and SPRINT-07 moved `Planned` -> `In Progress`.
  The boards and the ClickUp export were regenerated.
- `81cc0079`: the red probe, on its own. Its CI run, `45058050943`, failed for the right reason (the
  probe line showed "produced 0 finding(s): (none)").
- `17a20ed7`: the green check-4 loop. Its CI run, `45058371338`, shows 9 probes and a clean full run.
- `c75c7972`: P3 prose — header, `--help`, comments and closing guidance. CI run `45058856280` is
  green.
- `4dc043c8`: review fixes, comment only; the TM-15 check passed. CI run `45060223669` is green.
  This is the landing HEAD.
- Review and QA passes, run as separate dispatches: both returned approve-with-notes and found
  nothing blocking. Sam ruled to keep the "named beside" closing guidance (QA-01).
- Landing-HEAD capture, taken on a clean checkout at `4dc043c8`. It is saved outside the repo at
  `/home/sam-desktop/.claude/tmp/us012-landing-capture.txt`, and the guide's capture slot is filled
  from it.

## In-flight (uncommitted in the working tree)

These are the gate `22` records, written by a dispatch, plus one fix made by hand:

- `project-management/src/18-TESTS/AUTOMATED/US012-TEST-STATUS.md`: new.
- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US012-SEED-PRESENCE-GATE-22-11-2026.md`:
  new. Its sign-off boxes are left for Sam.
- `project-management/src/20-FINDINGS/FINDING-US012-SEED-PRESENCE-GATE-22-11-2026.md`: new, holding
  F-001 to F-010.
- `project-management/src/18-TESTS/MANUAL/US012-MANUAL-TESTING.md:5`: walked, with 31 Pass, 3 Fail
  (REMEDY-01/02/03) and 6 rows amended. The countersignature is still pending, and the Failures
  table is at `:233`.
- `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md:55`: the S-02 claim is marked
  discharged.
- `project-management/src/16-SPRINT-PLANS/07-SPRINT-PLAN-07.md:274`: the mirror cell is fixed to
  `In Progress` (REMEDY-02). The row stays a Fail; record the fix in F-009.
- `project-management/src/20-FINDINGS/FINDINGS-BOARD.md`: regenerated.

## Open questions (asked and unanswered; wait for Sam)

- **Q1, the three Fails.** The recommendation is to accept all three as non-blocking: REMEDY-01 is
  already in `GAPS.md` (F-008), REMEDY-02 is fixed (F-009), and REMEDY-03 belongs to
  MAP-GENERATION-COVERAGE S-01 (F-003). The alternative is to hold the story on REMEDY-01.
- **Q2, routing F-007** (the template's `hosts-story-add.sh us###` exits 1). The recommendation is
  to also add a dated `GAPS.md` entry; the alternative is to leave it to the next `17-story-plans`
  pass only.
- **Sam's countersignature** on the manual walk, and on the QA-IMPL sign-off boxes.

## Next

Put Q1, Q2 and the countersignature to Sam and wait for the answers. Then:

1. Apply the answers: the `GAPS.md` row if Q2 is 2, and the sign-offs.
2. Stage the `22` records, refresh the code-review-graph after staging, and commit them as
   `docs(us012): …`.
3. Move the story to `In Review` through `completion`, and re-mirror the sprint-plan cell in the
   same change.
4. Raise the PR to `dev` through `pr` / `23-pr-and-review`.

## Next skills

`completion`, `git`, `pr` (which runs `project-management/workflows/23-pr-and-review/`), and
`doc-writer` if a record needs an edit.

## Artefacts

- The story, plan, QA plan and guide named above.
- `.github/scripts/shipped-artefacts.sh`.
- `git log dev..us012/seed-presence-gate`.
- `project-management/workflows/22-implementation-documentation/CHECKLIST.md`.
