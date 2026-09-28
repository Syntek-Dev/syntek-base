# Handoff — SPRINT-06 and SPRINT-07 sprint plans, gate-10 sign-off, records catch-up — 28/09/2026

## Goal

Run `project-management/workflows/16-sprint-plans` for SPRINT-06 (US010) and SPRINT-07 (US012,
US011), then `17-story-plans` for US010 (`10-`), US012 (`11-`) and US011 (`12-`). Before the plans
can be written, <%DEVELOPER_NAME%>'s gate-10 sign-off (C1) and the records catch-up (C2) must be
committed.

## Commit plan (settled)

| Commit | Content                                                                             | State                   |
| ------ | ----------------------------------------------------------------------------------- | ----------------------- |
| D      | Grilling doctrine: "A decision already recorded is a fact"                          | **Committed `ceb2d70`** |
| C1     | Gate-10 sign-off, six security plans corrected in place                             | Drafted, uncommitted    |
| C2     | Records catch up (SPRINT-05/06/07, `05-SPRINT-PLAN-05`, US008–US012, QA-PLAN-US009) | Drafted, uncommitted    |
| C3, C4 | `06-SPRINT-PLAN-06.md`, `07-SPRINT-PLAN-07.md` (one workflow, two commits)          | Not started             |
| C5, C6 | `10-STORY-PLAN-US010-*`, `11-STORY-PLAN-US012-*` (one round of 17 grilling)         | Not started             |
| C7     | `12-STORY-PLAN-US011-*` (alone: needs C5 committed)                                 | Not started             |

Order is D → C1 → C2 → C3 … C7. **C2 must never land before C1**: the records state the sign-off
as fact. Stage by explicit path only. Nothing is pushed.

## Done

- `ceb2d70` — the grilling rule lives once in `.claude/skills/grilling/SKILL.md`; workflows
  `02`–`18` and the `sprint`, `story`, `planner` skills point at it; `03`, `10`, `17`, `18`–`21`
  read before they grill; `16` names `<exec-order>-SPRINT-PLAN-<sprint-number>.md`; v7.0.0
  renumber leftovers fixed. Two independent reviews, all findings applied, all pre-commit hooks
  green. `.ai/skills/` and `.agents/skills/` are symlinks and need nothing.
- Settled with <%DEVELOPER_NAME%> (cite as "settled 28/09/2026, 16-sprint-plans grilling round N
  QM"):
  - R1 Q1: sign off the US010, US008 and US009 security plans; write both sprint plans.
  - R1 Q2: Security is read by its flag; the unconditional-prerequisite wording in
    `16-sprint-plans` Step 1 / CHECKLIST and `CADENCE.md` is routed to `GAPS.md` through US010's
    gate-22 pass.
  - R1 Q3: records corrected in their own commit before any plan; ADRs superseded, never amended.
  - R1 Q4: chain into `17-story-plans` for US010, US012, US011.
  - R2 Q5: correct stale text in the six security plans in place in the sign-off commit.
  - R2 Q6: the two ADRs promising a never-written `GAPS.md` row stay untouched; each row becomes a
    gate-22 task on its own story (US008, US009).
  - R2 Q7: SPRINT-05 gets the full gate-10 write-back.
  - R2 Q8: QA-PLAN-US009 HP-01/HP-05 corrected in place, status stays `Reviewed`.

## In-flight

The 16 uncommitted files (`git status --short`), drafted by workflow run `wf_d2236850-914` and
fixed after two adversarial reviews:

- C1 — `project-management/src/10-SECURITY/{THREAT-MODEL,ASSESSMENTS}/PLANNING/*-US00{8,9}-*.md`
  and `*-US010-*.md`. All six Status rows read `Signed off · **corrected in place 28/09/2026** —
see below`; counts unchanged (US008 0/0/9/4/2, US009 0/0/7/4/1, US010 0/0/4/12/2).
- C2 — `project-management/src/03-SPRINTS/SPRINT-0{5,6,7}.md`,
  `project-management/src/16-SPRINT-PLANS/05-SPRINT-PLAN-05.md`,
  `project-management/src/02-STORIES/US00{8,9}.md`, `US01{0,1,2}.md`,
  `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md`. SPRINT-06 plan count now 8,
  SPRINT-07's 10; backlog register byte-identical across SPRINT-01–07.

Still to apply before committing C1 and C2 (Claude's announced calls, not objected to):

1. Remove the remaining U+00A7 signs: `ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` (8) and
   `ASSESSMENT-PLAN-US009-HOOK-ARMING.md` (11).
2. Widen US010's gate-22 `GAPS.md` task (in `US010.md` and `SPRINT-06.md`) to cover the
   unconditional GDPR bullet in `project-management/docs/planning/CADENCE.md` too.
3. Reword SPRINT-07's Definition of Done row "The Security row is re-asked at gate `10`" to R1
   Q2: Security `N/A` by flag; US010's gate-10 plans (TM-09, TM-10) raised nothing that overturns
   it for US011.
4. The owed `GAPS.md` entries (US008, US009 task rows and SPRINT-05) are dated when written and
   cite the ADR's 17/09/2026 claim — never backdated.
5. Stale lines: `SPRINT-06.md` coverage row's "Unlike SPRINT-05 …" (~~:769); SPRINT-05's 7.13 row
   names only the keyed migration entry and its 7.5 row omits the client-supplied-header condition
   (~~:755-776); a SPRINT-05 Security AC row gives a reason false under `install.sh --full`
   (~~:792); `US010.md` says "Three things this story routes to `GAPS.md`" — now four (~~:423).
6. **Re-measure every `path:line`** in the six security plans and in `US010.md` against the final
   tree: D moved lines in `project-management/workflows/16-sprint-plans/` and `17-story-plans/`
   that `US010.md` cites (~:1049-1051, ~:1076, and the Gherkin ~:665), and C2 edits stories the
   security plans cite.

## Next

Get <%DEVELOPER_NAME%>'s answers to Q9–Q11 below, then run one fix-and-verify pass over the 16
files (items 1–6 plus whatever Q9–Q11 decide), show the C1 diff, and commit C1 then C2.

## Open questions (asked, unanswered)

- **Q9** — Does a `Reviewed` QA plan close gate 11? (1) sign off all five QA plans now, US008–US012,
  so gate 11 means `Signed off` as gate 10 now does — recommended; (2) `Reviewed` with no open gap
  closes it, and SPRINT-06/07 are reworded. SPRINT-05 (new text) and SPRINT-06 (new text) currently
  disagree.
- **Q10** — SPRINT-05's gate-11 write-back (QA criteria and tasks from QA-PLAN-US008/US009: the
  worktree probe, postinstall probe, preview proof) in C2? (1) yes — recommended; (2) defer.
- **Q11** — Fix the story-level contradictions in C2? (1) all — recommended; (2) factual only.
  The list: US008 Definition of Done says its `GAPS.md` rows are "never closed by this story";
  a US008 scenario still reads as accepting the preview blindness the Accepted ADR reversed;
  `US008.md:757` cites a nonexistent `GAPS.md` entry; "77 tags" in `US008.md:678` and
  `QA-PLAN-US008:61` (72 measured); `US009.md:426` wires probes into the generation job, not the
  separate job; the TM-06 criterion is only a sentence in US009; US008's QA flag omits the preview
  proof; QA-PLAN-US009 has no `postinstall` scenario.

Noted, not raised as questions: `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/CLAUDE.md`
says a planning model is "frozen … after story writing starts", which the correct-in-place
sign-off (R2 Q5) and every earlier gate write-back contradict literally.

## Next skills

`sprint` + `grill-with-docs` (for 16), then `planner` + `grill-with-docs` (for 17), `git` for
each commit. For the C1/C2 fix pass: `security` for the six plans, `completion` vocabulary for
record status words.

## Artefacts

- Records: `project-management/src/03-SPRINTS/SPRINT-05.md`, `SPRINT-06.md`, `SPRINT-07.md`
- Stories: `project-management/src/02-STORIES/US008.md` – `US012.md`;
  `project-management/src/02-STORIES/CUT-PLAN.md` (P8, P9)
- ADRs: `project-management/src/15-DECISIONS/ADR-US008-*`, `ADR-US009-*`, `ADR-US010-*`
- QA plans: `project-management/src/11-QA/PLANNING/QA-PLAN-US00{8,9}-*`, `QA-PLAN-US01{0,1,2}-*`
- Plan templates and precedent: `project-management/src/16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`,
  `05-SPRINT-PLAN-05.md`; `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`
- Procedures: `project-management/workflows/16-sprint-plans/`, `17-story-plans/`,
  `project-management/docs/planning/CADENCE.md`, `SPRINTS.md`
- Commit: `ceb2d70`. Workflow journals (this machine only):
  `~/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/866e3525-13ba-4e7a-9623-92e103bfca16/subagents/workflows/wf_d2236850-914/journal.jsonl`
  (C1/C2 edits, reviews, fixes) and `wf_1a7d74aa-e4f/journal.jsonl` (readiness inventory).
