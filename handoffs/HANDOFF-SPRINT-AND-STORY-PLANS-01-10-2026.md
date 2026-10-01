# Handoff — SPRINT-06/07 sprint plans, then US010/US012/US011 story plans and manual guides — 01/10/2026

## Goal

Write `06-SPRINT-PLAN-06.md` and `07-SPRINT-PLAN-07.md` (workflow `16-sprint-plans`), then the
story plans `10-` (US010), `11-` (US012) and `12-` (US011) with their manual testing guides
(workflow `17-story-plans`, guides at Step 7.2). <%DEVELOPER_NAME%>'s order: sprint plans, then
story plans, then manual testing guides.

## Done

- `90600c9` (unpushed, tree clean): gate-10 and gate-11 sign-offs for US008–US012, the records
  catch-up (SPRINT-05/06/07, `05-SPRINT-PLAN-05`, US008–US012, story plans 08/09), the other
  session's 18-TESTS MANUAL/AUTOMATED split, and three ADRs superseded by `-AFTER-TESTS-SPLIT-30-09-2026`
  successors in `project-management/src/15-DECISIONS/`. Commit message lists rounds 1–8 (Q1–Q19).
- Read-only mapping of both gates (workflow run `wf_31f7a609-20c`): every standing Step 0 question
  for both sprint plans is answered by a record except Q20–Q22 below.

## Settled for the sprint plans (cite these; full list in the mapping journal)

- Write both now, by call not fill (SPRINT-06 8/11, SPRINT-07 10/11) — settled 28/09/2026,
  16-sprint-plans grilling round 1 Q1 (`project-management/src/03-SPRINTS/SPRINT-06.md:428-431`).
- Goals verbatim from each record's `Goal:` line; template `00-SPRINT-PLAN-00-TEMPLATE.md`, no
  per-story depth (`project-management/src/16-SPRINT-PLANS/CLAUDE.md:26`, `:46-48`); shape after
  `05-SPRINT-PLAN-05.md`. Each plan's commit amends its own SPRINT record's stale "not written yet"
  lines (precedent commits `c6df520`, `8a03e3f`, `1a9da7c`).
- SPRINT-06: US010 sole Must (8 SP); Should holds only US009's reserved 5 SP carry; carry case
  swaps prefixes `09-`/`10-` and revises the plan (`SPRINT-06.md:1106-1110`).
- SPRINT-07: US012 Must (2 SP) builds first, US011 Should (8 SP); US011 hard-blocked by US010 —
  a DoD row, never a cleared dependency (`SPRINT-07.md:1345-1349`).
- Security/GDPR read by flag (R1 Q2); gate 11 closes at Signed off (R3 Q9); all gates met or N/A.
- Reserved story-plan rows are no-file rows; write reserved names in double quotes, not backticks
  (doc-references reads backticks). Report the checklist's "committed and pushed" as committed only.

## In-flight

Nothing is half-written. Round 9 of the 16-sprint-plans grilling was asked and is unanswered.

## Open Questions (asked, unanswered — round 9)

- **Q20 — What else does the SPRINT-06 plan commit touch?** US010's reserved `10-` was never
  recorded in `project-management/src/02-STORIES/US010.md` (US011.md:239 and US012.md:207-208
  record theirs); `SPRINT-07.md:743-748` goes half-stale after it. (1) plan + SPRINT-06 only, the
  plan notes it, US010's story-plan commit records it — **recommended**; (2) also a dated line in
  US010.md now; (3) option 2 plus re-tense SPRINT-07 in this commit.
- **Q21 — Does US012 owe a manual testing guide?** `SPRINT-07.md:1048-1049`, `:1190-1191` say no
  (unit-only QA); since `90600c9`, `project-management/workflows/17-story-plans/STEPS.md:182-185`
  and gate 23 make it unconditional. (1) yes, correct those lines in the 07 commit —
  **recommended**; (2) yes, plan names the disagreement, fix rides with US012's story plan;
  (3) no guide, route to GAPS.
- **Q22 — When are the guides written?** (1) each straight after its plan, same commit (US010 +
  US012, then US011) — **recommended**, follows Step 7.2/9/10; (2) all plans first, then all
  guides as a separate pass.

## Next

Put Q20–Q22 to <%DEVELOPER_NAME%> (in the grilling format), then write `06-SPRINT-PLAN-06.md`
with an independent adversarial review, and commit it as C3 before starting `07`.

## Commit plan (settled)

C3 `06-SPRINT-PLAN-06.md` (+ SPRINT-06 amendments) → C4 `07-SPRINT-PLAN-07.md` (+ SPRINT-07) →
C5/C6 story plans US010 and US012 after one round of 17 grilling (guides with them if Q22 = 1) →
C7 US011's plan alone, after US010's plan is committed. Stage by explicit path; nothing pushed.

## Carry into the 17 round (contrary evidence found by the mapping)

- US011's tracked population: "47 tracked on 27/09/2026" (`SPRINT-07.md:925`, `:1248-1249`,
  `:1259`; `US011.md:94`) now measures 53 after the ADR supersessions; superseded ADRs 3 → 6
  against `US011.md:72-73`.
- `US012.md:320` and `:325` still cite `copier.yml:973-984` / `:967-972` (now `:994-1005` /
  `:988-993`).
- `SPRINT-07.md:1230-1233` overstates the self-test's reach (`audit-template.yml:225` runs
  `--self-test` on gen-false only); use `US012.md:458-462`'s wording.
- Stale doc-references figures in SPRINT-06/07 (dated 20–27/09) — re-measure or quote as dated.
- 14 open questions (28 `Awaiting answer` rows) in the backfilled guides under
  `project-management/src/18-TESTS/MANUAL/`, incl. US008 `PREVIEW-04` (how the copy is made to fail).

## Next skills

`sprint` + `grill-with-docs` (16), then `planner` + `grill-with-docs` (17, incl. Step 7.2 guides),
`qa-tester` for the guides, `git` for each commit.

## Artefacts

- Records: `project-management/src/03-SPRINTS/SPRINT-06.md`, `SPRINT-07.md`
- Stories: `project-management/src/02-STORIES/US010.md`, `US011.md`, `US012.md`, `CUT-PLAN.md`
- Gate artefacts: `project-management/src/10-SECURITY/*/PLANNING/*US010*`,
  `project-management/src/11-QA/PLANNING/QA-PLAN-US010-*`, `-US011-*`, `-US012-*`; ADRs
  `project-management/src/15-DECISIONS/ADR-US010-*`, `ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`
- Templates and precedents: `project-management/src/16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`,
  `05-SPRINT-PLAN-05.md`; `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`,
  `08-`/`09-` plans; `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md`, US008/US009 guides
- Procedures: `project-management/workflows/16-sprint-plans/`, `17-story-plans/`,
  `project-management/docs/planning/CADENCE.md`, `SPRINTS.md`
- Mapping results (this machine only):
  `~/.claude/projects/-mnt-archive-OldRepos-syntek-syntek-base/27d70fb0-9213-473d-ba64-775e6fa7fd4b/subagents/workflows/wf_31f7a609-20c/journal.jsonl`
  — full Settled lists, procedure maps and risks for SPRINT-06, SPRINT-07 and the three story plans.
