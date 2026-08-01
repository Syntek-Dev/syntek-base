@./CONTEXT.md

# CLAUDE.md — project-management/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the three tiers, full tree, naming table, PLANNING/IMPLEMENTATION pattern — imported
above) → this file → the target numbered folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The live PM artefact store — every story, sprint, spec, decision, and plan that gates a
feature into code, plus the post-implementation records, filed under numbered `NN-…/`
folders that run in three tiers: specify (01–12), decide & plan (13–15), record (16–20).

## How to work here

- **Routing:** never write here free-hand — start from the matching
  `project-management/workflows/NN-…/` procedure (`STEPS.md` + `CHECKLIST.md`), which
  names the folder, the naming pattern, and the governing `docs/` guide. Heavier
  artefacts go through the internal agents (`user-story`, `sprint`, `planner`, `gdpr`,
  `security`, `qa-tester`, `seo`).
- **Model:** Fable for substantive artefacts (stories, decisions/ADRs, sprint & story
  plans, GDPR / security / QA / SEO / API specs); Opus for mechanical touches — status
  flips, version-header bumps, moving or renaming a file.
- **Concrete steps:** read the workflow `STEPS.md` → copy the target folder's per-story
  template (`PLANNING/` vs `IMPLEMENTATION/` where the folder splits) using its fixed
  naming pattern → cross-link the `US###` (and, for a story plan, its sprint plan and the
  decisions it rests on) → satisfy the workflow `CHECKLIST.md`.
- **Definition of done:** artefact in the right numbered folder and phase, named to
  convention, linked to its `US###`; British English; DD/MM/YYYY dates.

## Guardrails

- **Documentation only — never code, secrets, or `.env` content lands here.** GDPR,
  security, and IDOR obligations are _specified_ in these artefacts and _enforced_ in
  `code/`; keep them consistent with `code/docs/SECURITY.md`.
- **Respect the tiers** — `00-ASSETS` is pre-workflow reference; `01–12` specify; `13–15`
  decide (ADRs) then plan sprints then plan stories, all before code; `16–20` record
  tests, reviews, findings, bugs, and refactoring after code. The **story plan (15) is the master
  the developer codes from**; it references its sprint plan (14) and the decisions (13).
  Do not invent a new top-level folder without a matching workflow.
- **Every new directory needs a `CONTEXT.md` and a `CLAUDE.md`.**
- Instructional `.md` under `src/` (the `CONTEXT.md`/`CLAUDE.md` files) stay ≤ 300 code
  lines; the artefacts and templates themselves are exempt.
- Version bumps only via `docs/VERSIONING-GUIDE.md` / the `version` agent; branches and
  PRs only via `docs/GIT-GUIDE.md`.

## Output & naming

- **Hand-written:** all artefacts under every numbered folder, from the per-story templates.
- **Generated:** none here — client-facing PDFs and zips live one level up in
  `project-management/export/` and are regenerated from these sources, never hand-edited.
- Numbered folders `NN-SCREAMING-SNAKE-CASE/`; artefacts follow their fixed patterns —
  `US###.md`, `SPRINT-##.md`, `ADR-###-<TITLE>.md`, `##-SPRINT-PLAN-##.md`,
  `STORY-PLAN-US###-*.md`, `<TYPE>-PLAN-US###-*.md` / `<TYPE>-IMPL-US###-*.md`,
  `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; dates DD/MM/YYYY.
