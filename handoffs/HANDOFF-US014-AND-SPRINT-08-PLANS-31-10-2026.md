# Handoff — cut US014, then the SPRINT-08 sprint plan and the US013 / US014 story plans — 31/10/2026

## Goal

Fill SPRINT-08 under `project-management/src/02-STORIES/CUT-PLAN.md` P8: cut MAP-RULE-OWNERSHIP
S-07 into US014, admit it, run its gates 04-15, then write SPRINT-08's sprint plan (16) and the
story plans plus manual testing guides for US013 and US014 (17). <%DEVELOPER_NAME%>'s order, 31/10/2026.

## Done (this session, all on `pm/story-creation`, committed, 5 commits ahead of origin, unpushed)

- `942a546` — P10 amended: the index-row gate box gates nothing (`CUT-PLAN.md:46-54`, P10 row);
  the 01/10 handoff pruned.
- `39b9fcf` — `project-management/src/02-STORIES/US013.md` cut from S-01 (Must, 3 SP, QA manual,
  12 flags N/A); `MAP-RULE-OWNERSHIP.md` S-01 row back-filled with its first-cut fixes;
  `CUT-PLAN.md` row 1 `Cut`.
- `9ee3ea7` — `project-management/src/03-SPRINTS/SPRINT-08.md` opened with US013 alone at
  3 / 11 — open; backlog register row added byte-identical to SPRINT-01..08; goal names the
  US013 + US014 pair (03-sprint-planning round 1, Q1-Q2).
- `e4b7c0f` — gates 04-15 for US013: every N/A held under adversarial triage; 15-decisions yields
  no ADR (US013 Decisions section); `project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`
  written over four 11-qa grilling rounds (Q1-Q18), qa-tester run plus a scoped re-check; US013
  now 17 tasks, 7 scenarios; SPRINT-08's roll-up matches.
- `c4a5245` — QA plan **Signed off** by <%DEVELOPER_NAME%> 31/10/2026; gate 11 closed for US013;
  SPRINT-08:263 box ticked.
- Verified, no change: every GitHub workflow already runs Node 24 (setup-node pins `24`; all 14
  pinned actions declare `node24` or are composite). Four tag-pinned `@v7` refs in
  `audit-mcp-parity.yml` / `audit-playwright-pin.yml` are PIN-DETECT-MOVE S-01's (`CUT-PLAN.md:477`).

## In-flight

Nothing half-written. The tree is clean.

## Next

Run `/grill-with-docs` to cut US014 from MAP-RULE-OWNERSHIP S-07 via
`project-management/workflows/02-story-creation/`, starting from its settled row and scope calls
(`CUT-PLAN.md:257`, `:277`).

## The sequence after that (P1: one story at a time)

1. **US014 cut** — S-07 (N-020), "Structured JSON logging with a `request_id` on every entry",
   Must, 8 SP. Its per-story row `CUT-PLAN.md:277` carries the confirm-at-cut calls and map fixes
   (Flags gain QA and Security; `apps/core/CONTEXT.md` and `dev.py` re-cites). US013 hands it the
   code/src/logs host-path reads, the 09 `CONTEXT.md:34` test tick, and the LogQL mismatch note on
   the S-07 map row (US013 Out of Scope). Expect GDPR/Security/Logging flags — unlike US013, gates
   09/10/14 likely run.
2. **03-sprint-planning** — admit US014 to SPRINT-08 (3 + 8 = 11 / 11); register row in all eight
   records, byte-identical; SPRINT-08 Notes' P8 reservation discharged.
3. **Gates 04-15 for US014** per its flags (`project-management/docs/planning/CADENCE.md` -> the
   flags are the gate entry conditions).
4. **16-sprint-plans** — `project-management/src/16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` (exec-order
   vs sprint number per that folder's `CLAUDE.md`).
5. **17-story-plans** — US013 at reserved prefix `13-`, then US014 at `14-`, each with
   `project-management/src/18-TESTS/MANUAL/US0##-MANUAL-TESTING.md` citing its QA plan's IDs.

## Working pattern that held this session

- Grill first (frontier rounds, `Settled` lines before questions); write only after answers.
- Each artefact: one writer agent -> independent reviewer(s) -> fixer, via the Workflow tool;
  then check the diff and commit with explicit paths.
- **Two traps hit:** (a) `.github/scripts/check-template-tokens.sh` (the `template-integrity`
  pre-commit hook) fails on quoted example tokens or Jinja delimiters in any tracked `.md` — write
  "an unresolved token", never a literal example; (b) a writer agent edited with a raw `python3`
  script once — tell agents "Edit tool only" explicitly.

## Open items (not for the next step; route when convenient)

- `project-management/src/11-QA/PLANNING/QA-PLAN-US011-REGISTER-INDEX-BACKFILL.md:363` still says
  no SPRINT-08 exists — conclusion still holds under P8; a dated note in a later change.
- Procedure defects found at US013's cut, unrouted: `02-story-creation` sends status and format
  questions to `PLANNING-GUIDE.md`, now an index (`STEPS.md:86-87`, `CONTEXT.md:38`); its Step 1
  dispatch contradicts the `story` skill's inline rule; `US000-TEMPLATE.md:496` says "merged to
  `main`" against STORIES.md's `testing`. Candidate home: `GAPS.md` via 22, or S-04 (US020).

## Next skills

`grill-with-docs` + `story` (02), `sprint` (03, 16), the gate skills US014's flags name
(`gdpr-mechanics`, `security`, `qa-tester`, `logging`), `planner` (17), `git`.

## Artefacts

- Plan of record: `project-management/src/02-STORIES/CUT-PLAN.md` (v0.2.3; P1, P8, RULE-OWNERSHIP
  section `:206-300`)
- Map: `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` (S-07 row, N-020)
- Story and gate record: `project-management/src/02-STORIES/US013.md`,
  `project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`
- Sprint: `project-management/src/03-SPRINTS/SPRINT-08.md`; precedents
  `project-management/src/16-SPRINT-PLANS/07-SPRINT-PLAN-07.md`,
  `project-management/src/17-STORY-PLANS/11-STORY-PLAN-US012-SEED-PRESENCE-GATE.md`,
  `project-management/src/18-TESTS/MANUAL/US012-MANUAL-TESTING.md`
- Procedures: `project-management/workflows/{02-story-creation,03-sprint-planning,16-sprint-plans,17-story-plans}/`
