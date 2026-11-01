# Handoff — SPRINT-08 is full and specified; its sprint plan and two story plans are next — 01/11/2026

## Goal

SPRINT-08 (US013 then US014, 11 / 11, at the fill trigger) has finished the specify and decide
tiers. Next, write its sprint plan through `project-management/workflows/16-sprint-plans/`, then
the two story plans with their manual testing guides through `17-story-plans/`.

## Done (committed on `pm/story-creation`, not pushed)

| Commit    | What                                                                                                                                                                                                                                                                                                                                             |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ef54532` | `pm-board.sh --boards-for <paths>` (`project-management/src/00-ASSETS/scripts/pm-board.sh`): names the boards a staged PM edit moves, so one `git add` carries them. It stages nothing, and the hook re-stages nothing. The `git` skill's commit step 1 uses it. The scripts `CLAUDE.md` names the ClickUp guard as the one re-staging exception |
| `f2c9638` | `project-management/src/02-STORIES/US014.md` cut from MAP-RULE-OWNERSHIP S-07: the map row is back-filled and its stale N-020 cites are dated; CUT-PLAN flips S-07 to `Cut`                                                                                                                                                                      |
| `5d7077e` | SPRINT-08 admits US014: `project-management/src/03-SPRINTS/SPRINT-08.md`, the register row in SPRINT-01 to 08                                                                                                                                                                                                                                    |
| `66eb725` | SPRINT-08 now states that US013's gate 11 is closed (its QA plan was signed off 31/10, `c4a5245`)                                                                                                                                                                                                                                                |
| `7a789c3` | US014's gates 09, 10, 11 and 14: five plans written over three grilling rounds, each reviewed by its gate skill, plus the qa-tester run and its scoped re-check                                                                                                                                                                                  |
| `5441954` | Sam signed off all five plans; gates 09 to 14 are closed for US014                                                                                                                                                                                                                                                                               |
| `7f09c03` | `project-management/src/15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md` is **Accepted**; gate 15 is closed                                                                                                                                                                                                                         |

US014 is Must and 8 SP. The estimate was reconfirmed after the gates grew its edit set
(`US014.md` → Story Points). US013's gates closed on 31/10/2026.

## In-flight

- **Nothing is mid-edit.** The tree is clean except the untracked
  `handoffs/HANDOFF-US014-GRILLED-AND-GRAPHIFY-31-10-2026.md`. This file supersedes it; its graphify
  findings are carried below. Delete it, or keep it, at Sam's call.
- **`project-management/src/03-SPRINTS/SPRINT-08.md` Notes, capacity paragraph:** it says both plans are owed
  "once every member has cleared the specify tier". **Both now have** (US013 on 31/10, US014 on
  01/11), so `16` can start.
- **Reserved story-plan prefixes:** `13-` for US013 and `14-` for US014 (SPRINT-08 Dependencies;
  US014 Dependencies). Both are numbers only, not plans, until `17` writes them.

## Next

Run `project-management/workflows/16-sprint-plans/` for SPRINT-08: grill first, then write
`project-management/src/16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` from `00-SPRINT-PLAN-00-TEMPLATE.md`.
Check the execution-order prefix against `16-SPRINT-PLANS/CLAUDE.md`, which owns the two-number rule.

## Next skills

`sprint` (16), then `planner` (17: story plan plus manual testing guide), each opening with
`grill-with-docs`. Use `git` to commit, staging with `pm-board.sh --boards-for`.

## Artefacts

- Sprint: `project-management/src/03-SPRINTS/SPRINT-08.md`. Precedent plan: `project-management/src/16-SPRINT-PLANS/07-SPRINT-PLAN-07.md`.
- Stories: `project-management/src/02-STORIES/US013.md`, `project-management/src/02-STORIES/US014.md`.
- US013 gate: `project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`.
- US014 gates: `project-management/src/09-GDPR/PLANNING/GDPR-PLAN-US014-STRUCTURED-JSON-LOGGING.md`,
  `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md`,
  `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US014-JSON-LOGGING-REQUEST-ID.md`,
  `project-management/src/11-QA/PLANNING/QA-PLAN-US014-STRUCTURED-JSON-LOGGING.md`,
  `project-management/src/14-LOGGING/PLANNING/LOGGING-PLAN-US014-STRUCTURED-JSON-REQUEST-ID.md`.
- Decision: `project-management/src/15-DECISIONS/ADR-US014-STRUCTURED-LOG-CONTRACT-01-11-2026.md`.
- Map and cut plan: `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` (S-07 row,
  N-020), `project-management/src/02-STORIES/CUT-PLAN.md` (next cut: S-02 → US015, map-order row 2).
- Grilling record for the gates: rounds R1 to R3 are cited inside the five plans and in US014's
  FLAGS comment. The `/tmp` brief files are not durable.

## Open questions

- **The ClickUp export is not staged by the hook in a real commit.** In `f2c9638` the
  `clickup-export` lefthook leg regenerated `US014-CLIENT.md` but did not stage it, although a
  direct `lefthook run pre-commit` passed. The suspected cause, a race with lefthook's parallel
  run, is unconfirmed. **Workaround used since:** run `export-clickup-stories.sh` before staging and
  add `project-management/export/clickup/` explicitly. It is not filed in `GAPS.md`; Sam decides.
- **graphify findings are deferred by Sam** (scope `code/` + `project-management/`, graph at
  `graphify-out/graph.json`, report `graphify-out/GRAPH_REPORT.md`, both gitignored):
  - **Possible split-doctrine defect, unverified:** GDPR audit logging
    (`project-management/docs/gdpr/COMPLIANCE.md`) resembles the security audit trail
    (`code/docs/security/AUDIT-TRAIL.md`) but has no structural link to it. The graph edge is
    inferred.
  - **Split candidates (weak cohesion):** "Database Pre-flight Rules" and "Code-Review-Graph & Arch
    Reports".
  - **Offered, not run:** trace why `NEGATIVE-SPACE.md` bridges 16 communities.
