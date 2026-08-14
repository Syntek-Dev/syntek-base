---
name: story
description: >-
  Write or refine a user story for <%PROJECT_NAME%> — one testable `US###` file carrying the
  role/goal/benefit statement, MoSCoW priority, Gherkin acceptance criteria, dependencies,
  tasks and a Fibonacci estimate. Load when a requirement, a feature idea or a rough note has
  to become the story that implementation is planned from. Not slicing already-written stories
  into a sprint (`sprint`), not the phased implementation plan built from a story (`planner`),
  not flipping a finished story to Completed (`completion`), and not pushing it to the
  external PM tool (`pm-tool-sync`).
model: fable
metadata:
  skills: global-workflow grilling
---

# Write a User Story (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the requirement arrives in the conversation and is sharpened
there, so a fork would start without the thing it is meant to work on).

**Model.** `model: fable` above applies to the turn that loads this skill and is not a
guarantee. The durable carrier for the planning tier is the `model: fable` routing frontmatter
on `project-management/workflows/02-story-creation/`, which is how story work is normally
entered.

---

## Open with a grilling pass

A story written from an unexamined request is a story the implementer has to re-derive. Open by
naming what must be settled, and take no action until <%DEVELOPER_NAME%> confirms — the round
shape, the question format and the recommendation rule are the `grilling` skill's
(`.claude/CLAUDE.md` §10).

What must be settled here: the specific **user role**, the measurable **goal and value**, the
**success signal**, **constraints and dependencies**, **priority**, and at least one **edge or
error case**. Make reasonable calls on minor gaps; always grill where the feature touches
personal data, permissions, or money.

**A requirement too large for one grilling pass is charted first.** Load the `wayfinder` skill,
map its decision frontier, resolve it across sessions, and cut stories from the settled answers.

## Steps

1. **Read the layer, then the neighbours.** `project-management/CONTEXT.md` for story numbering
   and current state, then the existing `project-management/src/02-STORIES/US###.md` files —
   match the house format and take the next free number.
2. **Copy the template.** `project-management/src/02-STORIES/US000-TEMPLATE.md` is the shape of
   record; it is not restated here, because a second copy drifts the moment the template moves.
3. **Write the acceptance criteria from the resolved grilling answers**, in Gherkin, in business
   language, covering a happy path **and** at least one edge or error case.
4. **Surface the non-negotiables the feature implies as acceptance criteria** — a state-changing
   endpoint needs an explicit permission check, a user-supplied ID is verified against the
   caller's ownership, personal data implies a lawful basis. State the requirement; leave the
   mechanism to the implementer.
5. **Size it against `project-management/docs/planning/STORIES.md`** — that guide owns the
   Fibonacci scale and both thresholds, and it is the one place they are written.
6. **Consult `project-management/docs/GDPR-GUIDE.md` and `SECURITY-GUIDE.md`** only to surface
   criteria the feature implies — never to design the solution.

## Definition of done

The story is INVEST-shaped; every acceptance criterion is specific, measurable and testable;
MoSCoW, dependencies, tasks, estimate and definition of done are all present; the file is named
`US###.md` with the next free zero-padded number; British English and DD/MM/YYYY throughout.

## What this skill does not do

No implementation code, no schema, no architecture decision, no sprint assignment or capacity
planning, and no commit — those are `planner`, `sprint` and `git`, dispatched separately.

## Dispatch

The commit is a separate dispatch, not a step here: an Agent tool call to `general-purpose`
naming the `git` skill, with the message `docs(pm): add US### <short title>`. Each phase
dispatches separately because a phase that reviews its own output has nothing left to check —
this is a convention the caller holds, not something the runtime enforces.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/02-story-creation/` — **the procedure of record for this skill**
- `project-management/workflows/01-feature/` — when the requirement is an epic that must be
  charted before any story is cut
- `project-management/workflows/16-story-plans/` — the per-story plan this story feeds

## Cross-references

- `project-management/docs/planning/STORIES.md` — the estimation scale and both split thresholds
- `project-management/src/02-STORIES/US000-TEMPLATE.md` — the story template
- `project-management/docs/PLANNING-GUIDE.md` — MoSCoW rules and the planning cadence
- `.claude/skills/global-workflow/` — British English, Markdown style, branch naming
