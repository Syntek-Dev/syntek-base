# Handoff — US006 posture guard: workflow 23 (review and PR) — 15/11/2026

## Goal

Take US006 (the destructive dev scripts read the deployment posture and refuse above
`development`) through `project-management/workflows/23-pr-and-review/`: the content review,
the hostile QA pass and the security pass, then raise the PR from `us006/posture-guard` into
`testing`. Build, closeout (`22`) and the developer's countersignature are done.

## Done (all on `us006/posture-guard`, pushed; HEAD `4de483b`)

- P0 baselines captured before the first edit — `project-management/src/18-TESTS/MANUAL/US006-MANUAL-TESTING.md` → _Recorded during the build_ (`fc10bcc`).
- P1 helper and self-test — `code/src/scripts/_lib/posture-guard.sh`; harness body in `code/src/scripts/database/_migrate-self-test.sh`, run by `bash code/src/scripts/database/migrate.sh --self-test` (`27954fd`).
- P2 six callers wired (5 refuse, `migrate.sh` warns) — `database/{reset,restore,seed-dev,migrate}.sh`, `development/server.sh`, `tests/server.sh` (`5ee5d5b`).
- P3 CI teardown `--force-posture development`, no `|| true` — `.github/workflows/test-e2e.yml` (`8cf0236`).
- P4 docs, map S-01 re-cut, assessment Section 7 (`fbd9dbc`).
- F-001 (guard before `up -d` on `--seed`) and F-018 (compose names compared as Compose normalises them; interpolated or non-ASCII declared names fail closed) — `0a6db24`. Self-test **186/186**, docker never invoked; ShellCheck clean (4 pre-existing SC2015 infos).
- Closeout records — threat-model, assessment and QA `IMPLEMENTATION/` records, automated record, findings F-001 to F-019, bug report for F-019 (`b173cba`).
- Plan errata in `project-management/src/17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`: `DOCKER_HOST` wins over `DOCKER_CONTEXT` (measured on Docker 29.9.2; the CLI reference still says the opposite); the self-test's sourced file; the guard's `up --seed` position; the normalised name comparison.
- `testing` merged in (PR #31 and the deps PR #32 — pnpm 12.18.0, action pins) — `d463d6b`; `_lib/CONTEXT.md` conflict resolved keeping both helpers.
- Manual walk **70/70 Pass**, PERM-07 walked by Sam on a provisioned us006 worktree and amended under F-018; Sam's countersignature recorded — `4de483b`.
- Story status `In Progress` (`195414c`).

## In-flight

Nothing is mid-edit; the working tree is clean. Open items the next session decides or completes:

- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US006-POSTURE-GUARD-15-11-2026.md:183` — "Reviewer approval" unticked; it is the `23` merge gate.
- `project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US006-POSTURE-GUARD-15-11-2026.md:143` and `project-management/src/10-SECURITY/THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US006-POSTURE-GUARD-15-11-2026.md:149` — a closeout agent replaced "Independent review is outstanding" with Sam's countersignature. Sam has not yet confirmed that counts as the independent review; `23`'s security pass may be what should close it.
- `audits/doc-references.sh` stands at 18 findings tree-wide, all owned by US005, US011 and US014 (baseline-diff mode per `ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026`); none in a US006 file.

## Next

Run `project-management/workflows/23-pr-and-review/` (read `STEPS.md` and `CHECKLIST.md` and their frontmatter first): dispatch `code/workflows/07-review/` with the content review, the hostile QA pass and the security pass, each finding adversarially verified; then write the PR body to a file and give Sam the `gh pr create --base testing --head us006/posture-guard` command (he asked to run PR commands himself).

## Next skills

`pr` · `review` · `code-reviewer` · `qa-tester` · `security` · `git` · `completion` (status move to `In Review` after the PR).

## Artefacts

- Story `project-management/src/02-STORIES/US006.md` · plan `project-management/src/17-STORY-PLANS/07-STORY-PLAN-US006-POSTURE-GUARD.md`
- ADRs `project-management/src/15-DECISIONS/ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` · `project-management/src/15-DECISIONS/ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026.md`
- Sprint `project-management/src/03-SPRINTS/SPRINT-04.md` · sprint plan `project-management/src/16-SPRINT-PLANS/04-SPRINT-PLAN-04.md`
- Records `project-management/src/18-TESTS/MANUAL/US006-MANUAL-TESTING.md` · `project-management/src/18-TESTS/AUTOMATED/US006-TEST-STATUS.md` · `project-management/src/20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` · `project-management/src/21-BUGS/BUG-TEST-SERVER-WORKTREE-URL-PORT-15-11-2026.md`
- Diff for review: `git diff origin/testing...us006/posture-guard` — the merge base is after `d463d6b`, so the deps changes drop out.

## Open questions

- Does Sam's countersignature stand as the independent review in the two security `IMPLEMENTATION/` records (In-flight above), or should `23`'s security pass close it?
- Unanswered offer from this session: add celery's soft 3.15 target (v5.7.1, celery PR #10636) and django-components issue #1737 to the `GAPS.md` "Python 3.15" held row.
- Reminders outside US006: TruffleHog 3.99.9 clears the cooldown 19/11/2026 and `claude-code-action` 1.0.270+ on 16/11/2026 (rows in `GAPS.md`); the deps worktree `../syntek-base-deps-ci-pins-15-11-2026` is merged and can be removed.
