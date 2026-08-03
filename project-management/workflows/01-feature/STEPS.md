---
workflow: 01-feature
phase: discovery
agent: planner
skills: [wayfinder, grill-with-docs, codebase-design, global-workflow]
model: fable
---

# Feature — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

| Step   | Reference                                                                 |
| ------ | ------------------------------------------------------------------------- |
| All    | `.claude/skills/wayfinder/SKILL.md` — CHART, RESOLVE, the map, node types |
| Step 1 | This folder's `CONTEXT.md` → _Reading order_                              |
| Step 3 | `code/docs/CODE-REVIEW-GRAPH.md` — the explore playbook                   |
| Step 7 | The graduation table in the wayfinder skill                               |

---

## Prerequisites

- [ ] A feature idea exists as prose or a conversation, not yet as stories
- [ ] `.claude/skills/wayfinder/SKILL.md` read
- [ ] No stories written for this feature yet

---

## CHART — one session

### Step 1 — Load the ground truth

> **Model:** fable

Load in order, each layer narrowing the next:

1. `CONTEXT.md` then `CLAUDE.md`, root down to the areas in play
2. The relevant `**/docs/` guides for the constraints a decision must respect
3. **The whole of `project-management/src/`** — stories, specs, decisions, plans, and records
4. The codebase, via the `code-review-graph` explore playbook

`src/` is the living state, not an archive: the `IMPLEMENTATION/` records say what shipped **and
where it diverged from the plan**. Map against that, not against intentions.

### Step 2 — Pin the destination

> **Model:** fable

Open a `/grill-with-docs` pass to name, in one or two lines, what "done" looks like — and the
bounds: what is consciously **out**. Look the repo up before asking.

_Done when the destination and out-of-scope bounds are written and confirmed._

### Step 3 — Map the frontier breadth-first

> **Model:** fable

Explore the feature's surface and surface **every currently-knowable open decision**. Breadth
first — do not follow one branch to the bottom. Anything in scope but not yet sharp enough to
state as a decision goes to **fog of war**, honestly.

_Done when every knowable decision is a node or parked in fog of war._

### Step 4 — Wire the blocking edges

> **Model:** fable

Second pass: write each node's blockers as links to the nodes it depends on, so the **takeable
edge** — the unblocked nodes — is visible at a glance.

_Done when every frontier node names its blockers (or "none") and at least one is unblocked._

### Step 5 — Write the map

> **Model:** fable

Copy `src/01-FEATURE/MAP-000-TEMPLATE.md` → `MAP-<FEATURE>.md`. Tag each frontier node with its
type: **research** (looked up, no human), **tracer** (spike to raise fidelity), **grilling**
(one `/grill-with-docs` surface), **task** (manual unblocking work). Add the map to the index in
`src/01-FEATURE/CONTEXT.md`.

_Done when the map exists, is indexed, and reads as a route rather than a vault._

### Step 6 — Fire the research nodes, then stop

> **Model:** fable

Dispatch research nodes now — they need no human. **Do not settle grilling, tracer, or task
nodes in this session.** Charting ends with the frontier drawn and unresolved.

---

## RESOLVE — one node per later session

### Step 7 — Take a node, settle it, graduate it

> **Model:** fable

Per session:

1. **Load the map** — destination and current frontier in view.
2. **Take the next node** — the one <%DEVELOPER_NAME%> names, or the first unblocked one; confirm it is
   genuinely takeable.
3. **Settle it by type** — grilling → `/grill-with-docs`; research → look it up; tracer →
   `/prototype`; task → do the unblocking work.
4. **Graduate the outcome** to its real home via the graduation table — an ADR in
   `src/14-DECISIONS/`, a `GAPS.md` entry, a `DEFERRED.md` row, or a glossary term. Never leave
   the answer only on the map.
5. **Redraw the frontier** — move the node to resolved, sharpen any fog the outcome clarified
   into new nodes, re-wire the blocking edges.

_Repeat until no **blocking** node remains open._

### Step 8 — Close out

> **Model:** opus

- Confirm every resolved node links to the artefact it became
- Confirm no story has been written yet — that is `02-story-creation`
- Satisfy `CHECKLIST.md`

Next: `02-story-creation/`, cutting stories from the resolved map.
