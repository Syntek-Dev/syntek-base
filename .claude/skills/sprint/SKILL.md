---
name: sprint
description: >-
  Slice a backlog of already-written user stories into balanced, dependency-ordered sprints for
  <%PROJECT_NAME%> — the MoSCoW mix, the capacity ceiling and its grace, tracer-bullet vertical
  slices, and the `SPRINT-##.md` record that tracks them. Load when the question is what goes
  into the next sprint and in what order, or when a detailed sprint plan is wanted. Not writing
  or refining the stories being sliced (`story`), not the per-story implementation plan
  (`planner`), not marking a sprint complete (`completion`), and not syncing it to the external
  PM tool (`pm-tool-sync`).
model: fable
metadata:
  skills: global-workflow grilling
---

# Sprint Planning (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — three of its inputs are not derivable from the repository and
have to be asked for). The backlog supplies points and dependencies; it never supplies the
sprint goal, and a fork that cannot ask would invent one.

**Model.** `model: fable` above applies to the turn that loads this skill and is not a
guarantee. The durable carrier for the planning tier is the `model: fable` routing frontmatter
on `project-management/workflows/03-sprint-planning/` and `16-sprint-plans/`.

---

## Open with a grilling pass

Name what must be settled and wait — the round shape and question format belong to the
`grilling` skill (`.claude/CLAUDE.md` Section 10).

**Read first, ask second.** Points, MoSCoW, dependencies and existing sprints are all in
`project-management/src/02-STORIES/` and `03-SPRINTS/`; capacity and velocity are in
`project-management/docs/PLANNING-GUIDE.md` and `.claude/MEMORY.md`. Three inputs are genuinely
not there and must be asked for: the **sprint goal or theme**, any **release deadline**, and
**carry-over** from an in-flight sprint.

**A body of work too large to slice in one pass is charted first** — load the `wayfinder` skill
and resolve its decision frontier before decomposing it.

## Story validation — a hard gate before a story enters a sprint

Each candidate carries all six of: the role/goal/benefit statement, MoSCoW priority, at least
one Given/When/Then scenario, dependencies (or "None"), at least one implementation task, and a
Fibonacci estimate. **A story missing one is flagged in the sprint record and handed back** to
the `story` skill — never padded here, because a gap filled by the planner is a requirement
nobody agreed.

## Planning rules

`project-management/docs/PLANNING-GUIDE.md` → _Sprint Capacity_ owns every number and wins on
any disagreement. Applied here:

- **The ceiling is a trigger, not a target.** Stories are planned one at a time; each that
  clears `15-decisions` is slotted into the open `SPRINT-##.md` with its points. At
  `<%SPRINT_CAPACITY_SP%>` SP planning pauses and `16-sprint-plans` + `17-story-plans` run for
  that sprint before the next story is picked up.
- **Grace is `<%SPRINT_GRACE_SP%>` SP**, for the one case where the next story would otherwise
  split badly. A sprint habitually running to grace means the ceiling is wrong — never split a
  story along an artificial seam to hit a number.
- **Selection order:** dependency-unblockers → Must Haves → blocking tech debt → Should Haves →
  Could Haves (only under capacity). Won't Have is documented, never scheduled.
- Keep the MoSCoW mix Must-Have led, reserve buffer, group related stories so the sprint
  delivers a coherent slice, and track affected areas per story — this is a monorepo.

## Slicing model — tracer-bullet vertical slices

Order the backlog as slices that each cut a **narrow but complete** path through every layer —
model, service, Ninja endpoint, template/HTMX — so each is demoable on its own, fits one focused
session, and is sequenced by dependency. Prefer a thin end-to-end slice over a horizontal layer
that demos nothing.

**Wide-change escape hatch.** A mechanical change with a large blast radius — renaming a column,
retyping a shared symbol — is sequenced **expand → migrate-in-batches → contract**: add the new
form alongside the old, move call sites in per-slice batches (each batch its own slice), remove
the old form last. The old form survives until the contract slice, so CI stays green throughout.

## Steps

1. Gather every story from `02-STORIES/`; extract points, MoSCoW and dependencies; run the
   validation gate.
2. Build the dependency order and assign stories within the ceiling and the MoSCoW mix.
3. Write the sprint record from `project-management/src/03-SPRINTS/SPRINT-00-TEMPLATE.md`, and
   the detailed plan — when one is asked for — from
   `project-management/src/16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`.
4. Record any new velocity or planning insight in `.claude/MEMORY.md`; log blockers and sprint
   dependencies in `GAPS.md`, never in `MEMORY.md`.

## Definition of done

Every scheduled story passed the validation gate and every flagged gap was handed back; the
sprint sits within the capacity ceiling and the guide's MoSCoW targets; no story is scheduled
before its blocker; the record — and the plan, if asked for — is written from its template,
correctly numbered and dated; British English, DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/03-sprint-planning/` — **the procedure of record** for the
  high-level `SPRINT-##.md`
- `project-management/workflows/16-sprint-plans/` — the detailed sprint plan
- `project-management/workflows/17-story-plans/` — the per-story plans a planned sprint unlocks

## Cross-references

- `project-management/docs/PLANNING-GUIDE.md` — capacity, velocity, MoSCoW, the cadence
- `project-management/docs/planning/STORIES.md` — the estimation scale a candidate is judged on
- `.claude/MEMORY.md` — velocity history and prior planning decisions
