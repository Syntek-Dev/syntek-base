# Handoff — planning is on main; the advisory sweep, the chain branches, then US007 — 02/11/2026

## Goal

Build the planned backlog (US001 to US014) one story at a time, under
`project-management/src/02-STORIES/CUT-PLAN.md` P14. Cutting stays paused until all fourteen are on
`main`. Order: the advisory sweep, then the `staging` / `dev` / `testing` branches, then each story
off `testing` in story-plan build order, `01-` to `14-`.

## Done

The planning is complete and merged.

- **PR #16 merged** at `0316f77`. All of `pm/story-creation` is on `main`, and `VERSION` reads
  7.7.0. No `v7.6.0` or `v7.7.0` tag exists yet.
- **SPRINT-08 is fully planned:**
  - Sprint plan: `project-management/src/16-SPRINT-PLANS/08-SPRINT-PLAN-08.md` (`5234a27`).
  - Story plans `13-` and `14-` with their manual testing guides (`5ba12ea`). Their citations
    were cleaned in `9a2cabb`.
- **US014 start rule:** US013 and US008 are **hard start gates** (17-story-plans grilling round 2
  Q3). The rule is recorded in `US014.md`, `SPRINT-08.md` and `08-SPRINT-PLAN-08.md`.
- **Completion pass** (`fb68fed`, exports in `63398f2`):
  - **Pending:** US001, US003, US004, US006, US007, US008, US009, US010, US012, US013.
  - **Blocked:** US002 on US007, US005 on US001, US011 on US010, US014 on US013 and US008.
- **Cutting is paused.** P14 is in `CUT-PLAN.md` (`3d84df7`); the next cut once building is done
  is RULE-OWNERSHIP S-02 (provisional US015).
- **US008's plan** passes `hosts-story-add.sh` the numeric story number (`4c22e5a`).
- **`handoffs/HANDOFF-SPRINT-08-PLANS-01-11-2026.md` is pruned.** Its parked items are under
  _Open questions_ below.

## In-flight

Nothing is mid-edit. The local branch is `pm/story-creation`, already merged. This handoff is
committed on it and is **not pushed**.

The pre-PR gate (`.claude/hooks/pre-pr-check.sh`) blocks every PR until the following are dealt
with. The causes were recorded in PR #16's _Known reds_ table.

| Check                         | State                                                                                                                                                      |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `security`, Python            | 17 advisories: `brotli` 1.2.0→1.2.1, `msgpack` 1.2.1→1.2.3, `certifi` 2026.7.22→2026.10.18, `filelock` 3.32.3→4.2.1 (a major bump)                         |
| `security`, JS                | 40 `pnpm audit` findings, including high-severity `follow-redirects` via `@usebruno/cli`                                                                   |
| `audits`, `doc-references.sh` | About 650 baseline findings (ADR-US003 baseline-diff regime). These retire with **US004** (`05-`) and are not fixed by the sweep                           |
| `audits`, `shipped-ai.sh`     | Local only: `uvx --offline --from copier python` picks up a cached Python older than 3.11 (no `tomllib`). This is a host fix, e.g. `uv cache clean copier` |

## Next

**Cut `pm/dependency-advisory-sweep-2` from an updated `main` and clear the Python and JS
advisories through `how-to/workflows/07-dependency-updates/`, following PR #15's precedent.**

After the sweep merges:

1. Create `staging` from `main`, `dev` from `staging` and `testing` from `dev`, one at a time.
   **Each needs Sam's go-ahead before it is created or pushed.**
2. Build US007 on `us007/status-vocabulary-one-owner`, off `testing`, through
   `code/workflows/01-implement-story/`. Its **first step re-cuts its criteria** against
   `.claude/skills/completion/SKILL.md` (completion pass round 1 Q3; `US007.md` → _Scope note —
   31/10/2026_).

## Standing rules from Sam this session

- Push, PR and branch creation each need Sam's explicit go-ahead.
- Stale references in any plan get fixed **when that story is built**, not beforehand. Examples:
  - `US001.md:83-85` cites a superseded ADR.
  - `ADR-US004-CITED-PLAN-PREFIX-IS-OPTIONAL` still reads `Proposed`.
  - `US002.md`'s Dependencies still say "none".
  - US008's P5 condition on the `v7.6.0` tag.
  - Plans `01-` to `12-` carry legacy `Status` header cells; each build deletes its own plan's
    cell.
- Another chat may be editing the same tree. Stage explicit paths only, and never commit another
  writer's hunks.

## Next skills

- **Sweep:** `cicd` (the dependency set), `git`, `security` for triage, and `pr`.
- **Branches:** `git`.
- **Building:** `implement-story`, plus the story's layer skills (US007 is PM docs: `doc-writer`,
  `completion`), `review`, `qa-tester` and `pr`.

## Artefacts

- Programme: `project-management/src/02-STORIES/CUT-PLAN.md` (P1, P14, _Cut order_).
- Build order: `project-management/src/17-STORY-PLANS/01-` to `14-`.
  - The first plan is `project-management/src/17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md`.
  - Boards: `project-management/src/02-STORIES/STORIES-BOARD.md` and
    `project-management/src/17-STORY-PLANS/STORY-PLANS-BOARD.md`.
- Branch chain: `project-management/docs/git/BRANCHES-AND-WORKTREES.md:40` and
  `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md`.
- Worktrees: `how-to/workflows/02-worktree-setup/` (isolation files per story, numeric
  `hosts-story-add.sh <NNN>`).
- Sweep precedent: PR #15 (`pm/dependency-advisory-sweep`) and
  `how-to/workflows/07-dependency-updates/`.
- Citation regime:
  `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`
  and `code/docs/FORWARD-VOICE.md`.

## Open questions

These are carried over from the pruned handoff, and both are still Sam's call.

- **The ClickUp export is not staged by the hook in a real commit.** The `clickup-export`
  lefthook leg regenerates `project-management/export/clickup/*-CLIENT.md` but doesn't stage it.
  The suspected cause, a race in lefthook's parallel run, is unconfirmed. **Workaround:** run
  `bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh` before staging, then
  add `project-management/export/clickup/` explicitly. There is no `GAPS.md` row for it.
- **graphify findings, put on hold by Sam.** The graph is at `graphify-out/graph.json` and the
  report at `graphify-out/GRAPH_REPORT.md`, both gitignored.
  - Possible split-doctrine defect: GDPR audit logging
    (`project-management/docs/gdpr/COMPLIANCE.md`) versus the security audit trail
    (`code/docs/security/AUDIT-TRAIL.md`).
  - Two weak-cohesion split candidates.
  - **Markdown lint scans `graphify-out/`** and reports errors there. They are noise in every
    `lint.sh` run; the fix is to exclude it or delete the folder.
