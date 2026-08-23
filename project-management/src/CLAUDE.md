@./CONTEXT.md

# CLAUDE.md — project-management/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the three tiers, full tree, naming table, PLANNING/IMPLEMENTATION pattern — imported
above) → this file → the target numbered folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The live PM artefact store — every story, sprint, spec, decision, and plan that gates a
feature into code, plus the post-implementation records, filed under numbered `NN-…/`
folders that run in three tiers: specify (02–14), decide & plan (15–17), record (18–22) —
plus `23-INCIDENTS`, the one record that is not anchored to a story.

## How to work here

- **Routing:** never write here free-hand — start from the matching
  `project-management/workflows/NN-…/` procedure (`STEPS.md` + `CHECKLIST.md`), which
  names the folder, the naming pattern, and the governing `docs/` guide. Heavier
  artefacts go through the matching skills (`story`, `sprint`, `planner`,
  `gdpr-mechanics`, `security`, `qa-tester`, `seo`).
- **Model:** Fable for substantive artefacts (stories, decisions/ADRs, sprint & story
  plans, GDPR / security / QA / SEO / API specs); Opus for mechanical touches — status
  flips, version-header bumps, moving or renaming a file.
- **Concrete steps:** read the workflow `STEPS.md` → copy the target folder's per-story
  template — the stage folder for 04–08, `PLANNING/` vs `IMPLEMENTATION/` for 09–13 — using its fixed
  naming pattern → cross-link the `US###` (and, for a story plan, its sprint plan and the
  decisions it rests on) → satisfy the workflow `CHECKLIST.md`.
- **Definition of done:** artefact in the right numbered folder and phase, named to
  convention, linked to its `US###`; British English; DD/MM/YYYY dates.

## Guardrails

- **Documentation only — never code, secrets, or `.env` content lands here.** GDPR,
  security, and IDOR obligations are _specified_ in these artefacts and _enforced_ in
  `code/`; keep them consistent with `code/docs/SECURITY.md`.
- **Respect the tiers** — `00-ASSETS` is pre-workflow reference; `02–14` specify; `15–17`
  decide (ADRs) then plan sprints then plan stories, all before code; `18–22` record
  tests, reviews, findings, bugs, and refactoring after code. The **story plan (17) is the master
  the developer codes from**; it references its sprint plan (16) and the decisions (15).
  Do not invent a new top-level folder without a matching workflow — **with one shipped
  exception, `23-INCIDENTS`, and the reason generalises**: an incident is _unplanned_, so it has
  no gate to pass through, and its procedure is a guide plus the `/incident` skill
  (`how-to/docs/INCIDENT-PRACTICE.md`). A folder may go workflow-less only when the work that
  fills it cannot be scheduled; everything schedulable still needs its gate.
- **`USER-STORY-IDEAS/` is frozen once workflow `18` runs.** In folders `04–08` the per-story
  design is the audit trail of what each story asked for — never rewritten. Corrections go to
  `CONSOLIDATED-IDEAS/`, which is also **what gets built**: an artefact traced back to a
  stage-1 design instead of the consolidated one reintroduces the drift `18` removed.
- **The `NN-` numbers here are frozen — append only.** These folders hold artefacts a developer
  wrote, which the template has never seen. Renumbering one is a schema migration Copier cannot
  perform: on update it moves its own scaffolding to the new path and leaves every
  developer-created file behind, with no conflict and no error. A new artefact folder takes the
  next free number at the end, even where that breaks the workflow↔`src` mirroring — that
  mirroring is a convenience, the developer's work is not. **One exception:** a release may
  renumber if it ships a migration in the same commit that moves the developer's files
  (`.copier/migrations/`) — exercised at v2.0.0 and v7.0.0, and never because one merely could <!-- doc-references: template-only -->
  be written. Enforced by `code/src/scripts/audits/template-orphans.sh`.
- **Every new directory needs a `CONTEXT.md` and a `CLAUDE.md`.**
- Instructional `.md` under `src/` (the `CONTEXT.md`/`CLAUDE.md` files) stay ≤ 300 code
  lines; the artefacts and templates themselves are exempt.
- Version bumps only via `docs/VERSIONING-GUIDE.md` / the `version` skill; branches and
  PRs only via `docs/GIT-GUIDE.md`.

## Output & naming

- **Hand-written:** all artefacts under every numbered folder, from the per-story templates.
- **Generated:** none here — client-facing PDFs and zips live one level up in
  `project-management/export/` and are regenerated from these sources, never hand-edited.
- Numbered folders `NN-SCREAMING-SNAKE-CASE/`; artefacts follow their fixed patterns —
  `US###.md`, `SPRINT-##.md`, `ADR-###-<TITLE>.md`, `##-SPRINT-PLAN-##.md`,
  `STORY-PLAN-US###-*.md`, `<TYPE>-PLAN-US###-*.md` / `<TYPE>-IMPL-US###-*.md`,
  `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; dates DD/MM/YYYY.
