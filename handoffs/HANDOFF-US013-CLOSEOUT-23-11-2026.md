# Handoff — US013 closeout (workflow 22 → 23) — 23/11/2026

## Goal

Close US013 on `us013/log-debug-workflow-seam`. The story is built and reviewed: the original
09-workflow seam plus graphify beside code-review-graph, which <%DEVELOPER_NAME%> widened it to
include at build. What remains is to finish `22-implementation-documentation` for the widened
scope and raise the PR through `23-pr-and-review` into `dev`.

## Done (this session)

- **Branch:** cut from `dev` at `e306f48e`; no worktree. Head is `933df1e8`, 4 commits ahead of
  `origin`. The last pushed head is `58f3c78e`.
- **Status:** US013 `In Progress`; SPRINT-08 `In Progress` at 16 / 11 SP, over grace and approved
  23/11/2026. US013 was re-estimated 3 → 8 SP.
- **Original scope (P0–P6):** built in `9afc4e44`, then review fixes in `552c3fc4` and QA fixes in
  `58f3c78e`. CI run `45161301722` on `58f3c78e` is green, with both `INCLUDE_MOBILE` lines at
  0 unrendered tokens.
- **Workflow 22, first pass (original scope):**
  - The mechanical walk passed 39 of 39 rows.
  - `doc-references` closed identical to the P0 baseline of 21 findings.
  - Draft records written:
    - `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md`
    - `project-management/src/18-TESTS/AUTOMATED/US013-TEST-STATUS.md`
    - `project-management/src/20-FINDINGS/FINDING-US013-LOG-DEBUG-WORKFLOW-SEAM-23-11-2026.md` (F-001 to F-016)
  - `DEFERRED.md` holds three `S-04` rows. Four untargeted deferrals went to `GAPS.md` as
    "four US013 deferrals no slice owns".
- **graphify widening:**
  - Spec in `f1a79ec5`; QA addendum signed off in `4837e2af`; P7 inventory in `83aafd23`.
  - Red suite in `e6f18b76`; build in `b04b278b`; review fixes in `5b622651`; QA fixes in `933df1e8`.
  - `code/src/scripts/tests/graph-update.sh` passes 146/146, `template-hooks.sh` 69/0, and
    `hook-arming.sh` 432/0 with 1 unmeasured (CI-only).
  - `mcp-parity`, `docs-length`, `docs-pairing`, `doctrine-drift`, lint and format are all green.
- **Decisions:** the graphify decisions (implement-story grilling rounds 1–3) are recorded in the
  story plan's second CORRECTED block and in `US013.md`'s WIDENED comment.

## In-flight

- **Manual guide, `project-management/src/18-TESTS/MANUAL/US013-MANUAL-TESTING.md`:**
  - `:334` WALK-01 to WALK-06 are unmarked. <%DEVELOPER_NAME%> walks them in **one pass**,
    marking each row as it runs; the commands are in the guide. WALK-05's truncate is typed inside
    the same `shell.sh` session. WALK-06 is his reading of whether the text sent him past Step 2.
  - `:421` GRAPH-01 to GRAPH-10 are unwalked and need a walker other than the author.
  - `:432` _Failures_ is empty.
  - `:443` the sign-off is empty.
  - `:5` the header still reads "Authored — not yet walked".
- **QA implementation record:** `:63-65` marks HP-02/03/04 `Pass` before the WALK rows are marked,
  and `:86` marks ES-06 N/A on the same basis. This is the verifier's M1. Re-read these after the
  walk, and add the graphify addendum scenarios (HP-15 to HP-20, ES-10 to ES-13, EC-08 to EC-10).
  The verifier's smaller defects are still open: the template status values, the findings-ID column
  and the cites that line drift has moved.
- **Findings record:**
  - Align F-003, F-009 and F-016 with the routing: F-003 and F-016 went to `GAPS.md`, F-009 to
    `S-04`.
  - Add the new findings: the graphify widening itself; review M1–M3 and QA 1–7, 9–13 (resolved);
    QA 8 (deferred: a read-only `.code-review-graph/` repeats its notice); the `kill_run` suite race;
    the D1 `template-hooks` fixture break; and the process breaches (a raw `python3 -I` edit by the
    test writer, and the author's `python3` heredoc file edits all session — report these, never
    excuse them).
  - Fix the verifier's defects 8–12.
- **Automated test record:** `US013-TEST-STATUS.md` still says "documentation only". Add the probe
  suite, regenerate the record with `bash code/src/scripts/tests/test-record.sh US013`, and use the
  CI run on the new head.
- **Dated length allowances, expiring 23/12/2026:**
  - `.claude/CLAUDE.md:6` is at 276 lines.
  - `code/src/scripts/tests/CONTEXT.md:10` is at 274 lines.
  - Both are owed a split at this closeout; move detail out to the owning guides.
- **Live graphify:** the local graph refuses AST updates because two semantic nodes are stale. Each
  edit to the tree triggers one refused, reported run. <%DEVELOPER_NAME%> may run
  `! graphify update . --force` once; the hook never forces.

## Next

Ask <%DEVELOPER_NAME%> to push `933df1e8` (pushing is his call). Then hand him the WALK-01 to
WALK-06 command block from the guide, and dispatch a fresh walker for GRAPH-01 to GRAPH-10.

## Next skills

- `doc-writer` for the record extensions and the two allowance splits.
- `qa-tester` / `general-purpose` as the GRAPH-row walker, not the author.
- `completion` for status moves.
- `pr` and `git` for `23-pr-and-review`.

Procedure of record: `project-management/workflows/22-implementation-documentation/STEPS.md`
Steps 4–9, then `project-management/workflows/23-pr-and-review/`. Use the Workflow tool (ultracode).

## Artefacts

- **Story:** `project-management/src/02-STORIES/US013.md`
- **QA plan:** `project-management/src/11-QA/PLANNING/QA-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`
  (the original scope plus the addendum)
- **Plan:** `project-management/src/17-STORY-PLANS/13-STORY-PLAN-US013-LOG-DEBUG-WORKFLOW-SEAM.md`
  (two CORRECTED blocks)
- **Sprint:** `project-management/src/03-SPRINTS/SPRINT-08.md`,
  `project-management/src/16-SPRINT-PLANS/08-SPRINT-PLAN-08.md`
- **Hook and suite:** `.claude/hooks/graph-update.sh`, `code/src/scripts/tests/graph-update.sh`,
  `lefthook.yml` (the `graphify` step runs `--commit`)
- **Doctrine:** `.claude/CLAUDE.md` Sections 3.1–3.3 and 6, `code/docs/CODE-REVIEW-GRAPH.md`
- **Full diff:** `git diff e306f48e...933df1e8`

## Open Questions

- Whether <%DEVELOPER_NAME%> clears the standing graphify refusal with a one-off
  `graphify update . --force`. It is his call, and nothing else blocks on it.
