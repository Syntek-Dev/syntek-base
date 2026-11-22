# Handoff — US010 fix round 5 (stopped mid-round) — 20/11/2026

## Goal

Finish US010 (`project-management/src/02-STORIES/US010.md`) on branch
`us010/seeded-register-indexes`. To do that, complete fix round 5 and get a clean
three-reviewer pass. Then record Sam's countersignature, push the branch, and give Sam the PR
command.

## Done

- **Branch:** 95 commits on top of `testing`. **Not pushed.** HEAD is `1fe46f26`.
- **Re-cut against the 7.7.0 boards:**
  - The settled design is in `US010.md` → `## Re-cut — 19/11/2026` (`:1735`).
  - The plan is `project-management/src/17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md`.
  - The decision record is `project-management/src/15-DECISIONS/ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md`, plus a dated D1 status note.
- **Built:**
  - decisions, findings and bugs boards, with their archive support (`project-management/src/00-ASSETS/scripts/pm-lib.sh`, `pm-board.sh`, `pm-archive.sh`);
  - the three vocabularies in `.claude/skills/completion/SKILL.md`, with findings using `Open | Resolved`;
  - status lines normalised across every ADR, finding and bug;
  - three `.copier/` board seeds and their `mv` lines in the copy-gated task;
  - `SEEDED` at 10, and `.github/scripts/shipped-boards.sh` covering eight boards;
  - the update probe in `.github/scripts/shipped-ai.py`;
  - `.github/scripts/register-index-routes.sh`, wired into `[3/4]`;
  - the map index-row box removed and the `Umbrella ADRs` rows swept;
  - the guide edits: seed counts, plus the TM-14 and TM-18 statements.
- **Fix rounds 1–4:** recorded in `project-management/src/18-TESTS/MANUAL/US010-MANUAL-TESTING.md`. Fix round 3 is at `:653` and fix round 4 at `:732`. The P0 captures are in the same file, under _Recorded during the build_.
- **Sam's rulings, all recorded:**
  - US011 goes `Blocked` → `Completed` in the change that completes US010, then `pm-archive.sh US011` sets `Closed` (`US011.md`, and US010's Definition of Done).
  - `MAP-GENERATION-COVERAGE.md` is charted for the 72-case matrix. US021 is withdrawn (reverted), so **US015 is the next free number**.
  - The formatters skip archived records.
  - SPRINT-04 and SPRINT-05 are `Done`.
  - US005, US006 and US009 are `Accepted`.
  - 25 records are archived.
- **Memory:** two entries in `.claude/MEMORY.md` (19/11/2026): chart a map before cutting a story; a status vocabulary belongs to `completion`.

## In-flight

- **Uncommitted, and not reviewed:** `project-management/src/00-ASSETS/scripts/pm-board.sh`, +79/−20. This is round 5's half-written Q2 fix, which makes the archive freeze see deletions and renames inside merge commits. It spans `archive_events()` (from about `:357`) and `frozen_breaches()` (`:390`–`:470`), plus a helper at `:298`.
  - **Status:** the stopped agent wrote it, and it has not been tested.
  - **Next step for it:** run `code/src/scripts/tests/pm-boards.sh`, then keep it if green, or discard it.
- **`1fe46f26`:** round 5's red probes for the merge gap and for mode and type changes, in `code/src/scripts/tests/pm-boards.sh`. They should be red until the fix above lands.
- **Q1 is not started:**
  - Remove the planned-red allowance: `PLANNED_RED`, the token, the `Planned-Red:` trailer, the commit-msg leg (`lefthook.yml:274`, `:315`), and the extra rules in `.github/scripts/template-integrity.sh`. Remove `code/src/scripts/tests/planned-red.sh`, or reduce it to what remains.
  - Self-tests move from pre-commit to a pre-push leg and CI.
  - Keep: the ledger's crash → exit 2 (`.github/scripts/self-test-ledger.sh`), the plain checks, the archive freeze and `register-index-routes.sh`.
  - Red-first and never-weaken become review rules, with the replay command in `code/workflows/02-tdd-cycle/STEPS.md`.
  - Leave the existing `Planned-Red:` commits as history, with one dated note.
- **`stash@{0}`** (from `543054d6`): WIP left by the first fix agent, which was stopped. It is superseded: inspect it, then drop it.

## Next

Run `code/src/scripts/tests/pm-boards.sh` against the uncommitted `pm-board.sh`. If it is green, commit it as the Q2 fix. Then run Q1 and the rest of round 5 from the brief below.

## Round 5 brief (Sam's decisions, 20/11/2026)

- **Q1:** remove the planned-red allowance, as described under In-flight.
- **Q2:** close the archive merge-commit gap, probe-first.
- **Also fix every round-4 finding the removal doesn't make moot,** including pinning git config wherever a surviving check reads `git diff`. List each finding in the guide as "Fix round 5 — 20/11/2026", marked moot, fixed with its SHA, or answered with evidence.
- **Make every doc claim match the code:** the `template-integrity.sh` header, `lefthook.yml`, `project-management/docs/git/COMMITS.md`, `code/workflows/02-tdd-cycle/`, `code/docs/TESTING.md`, the tests `CONTEXT.md`/`CLAUDE.md`, `src/CLAUDE.md`, and the US010 records. Round 2's D4 is now superseded by Q1.
- **Record round 4's TM-15 firings in the guide.** The implementation record itself is gate 22's.
- **The full brief is in the workflow script,** which is outside the repo and so not synced: `~/.claude/projects/-home-sam-desktop-Repos-syntek-syntek-base/b620cdc0-c1ad-4600-8752-d672b51aa8b8/workflows/scripts/us010-fix-round-5-wf_cb9f9e64-682.js`.
- **The round-4 review reports it fixes from** are `~/.cache/us010-reviews/r4-02.txt` (code-reviewer), `r4-03.txt` (security) and `r4-04.txt` (qa-tester), also not synced.

## After round 5

1. **Fresh reviews:** `code-reviewer`, `qa-tester` and `security`, each run separately and read-only. If any reports a critical or high issue, stop and report to Sam.
2. **If clean:**
   - Record **Sam's countersignature of all US010 work**, dated in the records. He gave it on 19/11/2026, on condition that the work lands clean.
   - **Push** the branch.
   - **Give Sam the `gh pr create` command** to open the PR into `testing`. He runs it himself, because the PR hook's `doc-references.sh` fails on the 18 findings that predate this branch.
3. **Then:** read the CI `[3/4]` run and record its ID, then run gate 22 (`project-management/workflows/22-implementation-documentation/`). Gate 22 writes the TM-10 `GAPS.md` entry and the four routed entries, and walks the manual guide.

## Next skills

`implement-story`, `cicd` and `test-writer` for round 5. Then `code-reviewer`, `qa-tester` and `security`, each dispatched separately, `git` for the push and PR command, and `completion`.

## Open questions for Sam

- **`MAP-GENERATION-COVERAGE.md`:** confirm its destination, and answer its F-02 (whether its slice takes item F-025 of the `GAPS.md` 12/11/2026 entry).
- **`MAP-REGISTER-INDEXES.md`:** whether to record the matrix split there; that is the map owner's call.

## Artefacts

- **Story:** `project-management/src/02-STORIES/US010.md`
- **Plan:** `project-management/src/17-STORY-PLANS/10-STORY-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
- **Manual guide:** `project-management/src/18-TESTS/MANUAL/US010-MANUAL-TESTING.md`
- **QA plan:** `project-management/src/11-QA/PLANNING/QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
- **Threat model and assessment:** `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` and `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
- **Map:** `project-management/src/01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md`
- **US011:** `project-management/src/02-STORIES/US011.md`
- **Commit range:** `git log --oneline testing..us010/seeded-register-indexes`
