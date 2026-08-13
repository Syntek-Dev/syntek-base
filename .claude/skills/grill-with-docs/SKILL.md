---
name: grill-with-docs
description: >-
  Grill a design and record what it settles — a relentless interview in frontier rounds that
  sharpens a design AND writes each decision into the repo as it resolves (plan Open Questions,
  glossary terms, story acceptance criteria). Invoke by typing /grill-with-docs, or as the
  opening move of architecture, database, API or story design, where the answers have to
  outlive the session. Where they do not — a half-formed idea being stress-tested, or an
  explicit "don't write this down" — that is `grill-me`.
---

# Skill: grill-with-docs (<%PROJECT_NAME%>)

Run a grilling session that leaves a paper trail. Load `.claude/skills/grilling/SKILL.md`
and follow it — **it owns the round shape, the question format and the recommendation rule;
do not restate them here.** As each decision resolves, record it in the right **existing**
artefact — never invent a new format:

| When a decision…                                                        | Record it in                                                                                                         |
| ----------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| shapes scope, a requirement, or a still-open question in a feature plan | the `### Requirements` / `### Open Questions` sections of the story plan in `project-management/src/16-STORY-PLANS/` |
| is hard to reverse, surprising without context, and a real trade-off    | a new `ADR-###-*.md`, sequentially numbered, following the project's existing ADR convention                         |
| pins domain terminology (one canonical word per concept)                | the glossary of the nearest `CONTEXT.md` — add an _Avoid_ note listing the rejected synonyms                         |
| sets observable behaviour for a story                                   | the Gherkin `## Acceptance Criteria` of `project-management/src/02-STORIES/US###.md`                                 |

Write each decision inline the moment it resolves, not batched at the end. Offer an ADR
**only** when all three tests hold together — hard to reverse **and** surprising without
context **and** a genuine trade-off — so the decision record stays signal-dense.

This is the design-work default: the `planner`, `database`, `backend` and `story`
skills open architecture / schema / API / story work with a grill-with-docs pass before
producing the plan, migration, resolver, or story.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/04-database-schema/` — schema design
- `project-management/workflows/13-api-design/` — API contract design
- `project-management/workflows/14-decisions/` — ADR options
- `project-management/workflows/16-story-plans/` — story approach and phasing

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the engine this runs.
- `.claude/skills/grill-me/SKILL.md` — the stateless twin that saves nothing.
- `.claude/skills/{planner,database,backend,story}/SKILL.md` — the callers.
