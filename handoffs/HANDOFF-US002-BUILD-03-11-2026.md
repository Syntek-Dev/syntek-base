# Handoff — US002 build (audits register headroom) — 03/11/2026

## Goal

Implement US002: get `code/src/scripts/audits/CONTEXT.md` from 299 counted lines down to 230 or
fewer. The method is to split the AI-slop rationale into a paired `slop-family/` sub-folder, route
the passages that restate another guide, fill the five missing Dependencies rows and retire the
`docs-length-allow` comment. Run it through `/implement-story` (docs-only: phases 2–8 are N/A),
then `22`, then `23`.

## Done this session

- **US001 shipped.**
  - Built, reviewed, QA'd and walked (36/36, countersigned).
  - Merged to `testing` in PR #21 (`0d32a1d`), then marked `Accepted` in `d231f9d`. Status row is in
    `project-management/src/02-STORIES/US001.md`.
  - The new family is `code/docs/RELIABILITY.md` plus `code/docs/reliability/`.
  - Records: `project-management/src/19-REVIEWS/REVIEW-US001-RELIABILITY-DOCTRINE-HOME.md`,
    `project-management/src/20-FINDINGS/FINDING-US001-RELIABILITY-DOCTRINE-HOME-03-11-2026.md`.
  - Six deferrals to US005 are in `DEFERRED.md`.
- **SPRINT-01 ticks both stories** (`project-management/src/03-SPRINTS/SPRINT-01.md`). It stays
  `In Progress`, because its own Definition of Done needs both stories at `Completed` and merged to `main`.
- **US002's pre-build grilling is settled and recorded** in `11f0f3b`:
  - Q1–Q5 plus the re-measured figures are in the US002 plan, `## Key Decisions`, starting at
    `project-management/src/17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md:242`.
  - US002 moved `Blocked` → `Pending`.

## In-flight

- **`testing` is not pushed.** It is two commits ahead of `origin/testing` (`d231f9d`, `11f0f3b`).
  Sam has not yet said whether to push.
- **US002 has no branch yet.** It is `Pending`, and nothing has been edited for it.
- **The plan's figures are stale on purpose until Q1 runs.** The approach is at
  `...03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md:149` and the arithmetic table at `:206`. Story
  scenarios begin at `project-management/src/02-STORIES/US002.md:199` and still assert "298",
  "24 scripts" and "four missing". Q1 re-cuts all of these at the build's first step, with dated trails.

## Next

Confirm the push with Sam. Then run `/implement-story` on
`project-management/src/17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`.

The grilling is already settled, so open with the "Settled" lines only. Then:

1. Cut `us002/audits-register-headroom` from `testing`.
2. Move US002 `Pending` → `In Progress` through `completion`.
3. Run Step A: the baseline captures go into
   `project-management/src/18-TESTS/MANUAL/US002-MANUAL-TESTING.md` → _Recorded during the build_.
4. Run the Q1 re-cut, before any edit to the audits folder.

## Next skills

- `implement-story`, which drives the work.
- `completion` for status moves.
- `doc-writer` for the split and the routes.
- Independent `code-reviewer` and `qa-tester` dispatches, and a separate walk agent at `22`.
- `git` at commit and PR.

## Lessons from US001 that save time

- **`doc-references.sh` takes about 15 minutes.** Run it in the background, and **edit nothing while
  it runs**: an edit mid-run invalidates the result.
- **Take the closing citation run with the story's new files staged.** An untracked new file reads to
  the gate as _shipping_, which produced 37 false `template-only citation` findings (US001 F-009).
- **Compare citation runs by `(file, kind, token)` multiset.**
  - The normalising pipeline: `sed` strip ANSI → `grep -E '^  \S+:[0-9]+  \['` → `sed -E` to
    `file\tkind\ttoken` → `sort | uniq -c`.
  - US001's baseline files in `/tmp/us001-baseline/` show the method. `/tmp` may be gone.
- **Citations in PM records:**
  - Cite PM artefacts **relative** (`../02-STORIES/US002.md`), as US007's records do.
  - Never backtick a `MAP-*` / `US###` filename or a nonexistent path. Use "double quotes".
  - `slop-family/` does not exist until Step B, so do not backtick it before then.
- **Prettier re-pads tables.** Match table rows with whitespace-tolerant regexes.
- **Never run `pkill -f` with a pattern that matches your own shell command.** It kills the shell.
- **`pre-pr-check.sh` blocked `gh pr create` from inside the session.** Sam ran the PR command himself.

## Artefacts

- **Story:** `project-management/src/02-STORIES/US002.md`
- **Plan:** `project-management/src/17-STORY-PLANS/03-STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`
- **QA plan:** `project-management/src/11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`
- **Manual guide:** `project-management/src/18-TESTS/MANUAL/US002-MANUAL-TESTING.md`
- **ADRs, in `project-management/src/15-DECISIONS/`:**
  - `ADR-US002-SPLIT-TARGET-IS-A-BOUND-PATH-02-09-2026.md` (Accepted)
  - `ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` (Accepted)
  - `ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`
- **Target files:** `code/src/scripts/audits/CONTEXT.md` (allowance comment at `:8`; slop section
  `:62-149`), and `code/src/scripts/audits/CLAUDE.md` (178 counted lines, ceiling 200).
- **Sprint:** `project-management/src/03-SPRINTS/SPRINT-02.md` (Planned). US002 opens it.
- **Commits:** `0d32a1d` (PR #21 merge), `d231f9d` (US001 Accepted), `11f0f3b` (US002 decisions).
