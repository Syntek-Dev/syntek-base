---
name: wayfinder
description: >-
  Chart a large, ambiguous body of work — bigger than one session can hold — into a shared
  markdown map of open decisions, then resolve them one at a time across sessions. Invoke by
  typing /wayfinder chart <epic> to map an epic's decision frontier, /wayfinder resolve <map>
  to settle its next open decision, or when a body of work is too big to hold in a single
  grilling pass.
---

# Skill: wayfinder ({{PROJECT_SLUG}})

Wayfinder takes on work too big to hold in one head — a whole epic, a cross-cutting migration,
an ambiguous programme — and turns the fog into a navigable **map** of open decisions resolved
incrementally across sessions. Instead of charging at an unclear **destination**, it charts the
route first: surface the decisions, order them, then settle one at a time until the way is clear.

**Scope, versus grilling.** Grilling sharpens **one** design surface in a single sitting.
Wayfinder maps a whole epic's decision **frontier** and dispatches each **decision node** to
grilling to settle. Wayfinder is the cartographer; grilling is the per-node engine. Reach for
wayfinder when the work spans several stories and cannot be resolved in one grilling pass; reach
straight for `/grill-with-docs` when it is a single surface.

**The map is a markdown artefact** — `the project's plans folderMAP-<EPIC>.md`. It is a
low-resolution index, never a storage vault: detail lives in the ADR, plan, or story each entry
links to. The decisions it graduates land in their existing homes (ADRs, plans, stories,
`GAPS.md`, `DEFERRED.md`); the stories it spawns sync to ClickUp through the existing
`clickup-sync` workflow — wayfinder writes markdown only, never to ClickUp directly.

Facts are looked up, not asked: `code-review-graph` MCP → Read/Grep/Glob → `.claude/plugins/*.py`
(and `context7` for library docs). Only genuine decisions with a real trade-off go to {{DEVELOPER_NAME}}.

Wayfinder runs in one of two modes per session: **CHART** (one session — pin the destination,
map the frontier, write the map) or **RESOLVE** (later sessions — settle the next frontier node,
graduate it, redraw the frontier). A live worked example of this shape is the Design Studio epic:
`the project's plans folderPLAN-US207-DESIGN-STUDIO.md` (umbrella → US208–US214, the relevant decision records,
with its cross-story blocker recorded in `GAPS.md`).

Locale: {{LOCALE}} · {{TIMEZONE}} · {{CURRENCY}}.

## Steps — CHART (one session)

1. **Pin the destination.** Open a `/grill-with-docs` pass to name what "done" looks like in one
   or two lines, and the epic's bounds — what is in, what is consciously out. Look the repo up
   before asking (`code-review-graph` → Read/Grep/Glob → `.claude/plugins/*.py`). _Done when the
   Destination and Out-of-scope bounds are written and {{DEVELOPER_NAME}} has confirmed them._
2. **Map the frontier breadth-first.** Explore the epic's surface with the `code-review-graph`
   explore playbook (`code/docs/CODE-REVIEW-GRAPH.md`) plus the target `CONTEXT.md`, surfacing
   every currently-knowable open decision. Anything still too vague to state as a decision goes to
   **Fog of war**. _Done when every knowable decision is either captured as a node or parked in
   Fog of war._
3. **Wire the blocking edges.** In a second pass, write each node's blockers as prose links to the
   nodes it depends on, so the takeable edge — the unblocked nodes — is visible at a glance.
   _Done when every Frontier node names its blockers (or "none") and at least one node is unblocked._
4. **Write the map.** Create `MAP-<EPIC>.md` in the project's plans folder with the six
   sections below; tag each Frontier node with its type (research / tracer / grilling / task).
   Add the map to the plans index in the plans folder's `CONTEXT.md`. _Done when the
   map exists, is indexed, and reads as a low-resolution route rather than a storage vault._
5. **Fire the research nodes, then stop.** Dispatch any research nodes (facts, not decisions) in
   parallel now — they need no human. Charting is one session: do **not** settle grilling, tracer,
   or task nodes here. _Done when the research nodes are dispatched and the session ends with the
   frontier drawn but unresolved._

## Steps — RESOLVE (each later session)

1. **Load the map.** Read `MAP-<EPIC>.md` for the low-resolution view; pull the linked ADRs,
   plans, and closed nodes only as you need them. _Done when the Destination and current Frontier
   are in view._
2. **Take the next node.** Pick the node {{DEVELOPER_NAME}} names, or the first unblocked Frontier node, and
   confirm it is genuinely unblocked. _Done when one Frontier node is chosen and confirmed takeable._
3. **Settle it by its type.** A **grilling** node opens `/grill-with-docs` (one surface, one
   sitting); a **research** node is looked up; a **tracer** builds a rough spike to raise fidelity
   on a foggy area; a **task** does the manual unblocking work. _Done when the node's decision is
   made and confirmed._
4. **Graduate the outcome.** Record the settled decision in its real home via the graduation table
   — an ADR, a story-plus-plan, a `GAPS.md` entry, a `DEFERRED.md` row, or a glossary term — never
   leaving the answer only on the map. _Done when the outcome lives in the correct artefact and the
   map's Resolved-decisions entry links to it._
5. **Redraw the frontier.** Move the node from Frontier to Resolved decisions; graduate any Fog-of-war
   items the outcome sharpened into new nodes; re-wire the blocking edges. _Done when the Frontier
   reflects the new takeable edge and no resolved node remains open on it._

## Reference

### The map artefact

```text
# MAP-<EPIC> — <title>
## Destination           one or two lines: the spec / change the epic reaches
## Notes                 domain, skills to load, standing preferences, the umbrella PLAN/ADRs
## Resolved decisions    settled — each links to the ADR-### / PLAN-US### / US### it became
## Frontier              open decisions in dependency order; blocking edges as prose links
## Fog of war            in-scope but not yet sharp enough to be a node
## Out of scope          consciously ruled out, plus why
```

### Decision-node types

- **Research** (agent works alone) — surface facts from the codebase, docs, or APIs; looked up,
  never asked.
- **Tracer** — a rough prototype or spike that raises fidelity on a foggy area before it can be
  decided.
- **Grilling** (human in the loop) — a decision settled by a single `/grill-with-docs` surface.
- **Task** (human in the loop or alone) — manual unblocking work: provision infra, run a migration
  script, seed data.

### Graduation table (RESOLVE step 4)

| A settled decision that is…                                                   | Graduates to…                                                                                                             |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| architectural, hard to reverse, a genuine trade-off (the three-test ADR gate) | a new ADR — the project's decision register (next free number is the project's decision register)                         |
| a buildable slice of the epic                                                 | a story + plan — `…/01-STORIES/US###.md` + `…/15-STORY-PLANS/STORY-PLAN-US###-*.md` (copy `STORY-PLAN-US000-TEMPLATE.md`) |
| an active blocker or cross-repo dependency                                    | a `GAPS.md` entry                                                                                                         |
| deferred to a named future story                                              | a `DEFERRED.md` row, targeting the future `US###`                                                                         |
| terminology (one canonical word per concept)                                  | the glossary of the nearest `CONTEXT.md` (reference: `code/docs/data-structures/DOMAIN-MODELLING.md`)                     |

The ADR three-test gate and the glossary-into-`CONTEXT.md` move are exactly `grill-with-docs` —
that skill owns which artefact a resolved decision lands in; wayfinder only decides that it lands.
A slice's `US###` is pushed to the ClickUp board by the `clickup-sync` workflow, not by wayfinder.

### Completion criteria

- A **chart** session is done when every currently-knowable decision is on the map and the frontier
  is ordered.
- A **resolve** session is done when the chosen node is settled, recorded in the right artefact, and
  the frontier is redrawn.
- The **map** is done when Frontier and Fog of war are both empty — the route to the destination is
  fully charted.

### Anti-patterns

- **Resolving during a chart session** — charting draws the frontier; it settles nothing.
- **Storing decision detail in the map** — the map is a low-resolution index; detail lives in the
  ADR, plan, or story it links to.
- **Asking what the repo can answer** — look facts up before putting a question to {{DEVELOPER_NAME}}.
- **Grilling the whole epic in one sitting** — that is what the frontier is for; each node gets its
  own grilling.
- **Writing to ClickUp directly** — spawn the `US###` markdown and let the `clickup-sync` workflow
  push it.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/01-story-creation/` — charting an epic before decomposing it into stories
- `project-management/workflows/02-sprint-planning/` — charting before sprint candidates are picked

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the per-node engine wayfinder dispatches to.
- `.claude/skills/grill-with-docs/SKILL.md` — how a grilling node records its decision (the
  three-test ADR gate + glossary-into-`CONTEXT.md`).
- `.claude/skills/grill-me/SKILL.md` — the stateless twin, for thinking a node through without recording.
- `the project's plans folderCONTEXT.md` — the plans index, where the map is registered.
- `the project's plans folderPLAN-US000-TEMPLATE.md` — the plan a buildable slice graduates into.
- `the project's plans folderPLAN-US207-DESIGN-STUDIO.md` — a live worked example of an epic-shaped map.
- the project's decision register — ADR home (next free number the scale-planning contract).
- `project-management/src/01-STORIES/US###.md` — the story a slice becomes; synced to ClickUp by `.github/workflows/clickup-sync.yml`.
- `GAPS.md` · `DEFERRED.md` — where blockers and named-future-story deferrals graduate.
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore playbook used to map the frontier.
- `code/docs/data-structures/DOMAIN-MODELLING.md` — the domain-modelling reference for terminology nodes.
- `.claude/plugins/*.py` — the read-only helpers for looking project facts up.
- `.claude/worktrees/` + `how-to/docs/GIT-WORKTREES.md` — where the graduated slices build in parallel.
