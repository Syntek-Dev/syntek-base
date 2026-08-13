---
workflow: 01-feature
phase: discovery
skills: [planner, wayfinder, grill-with-docs, codebase-design, global-workflow]
model: fable
---

# Feature — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

| Step   | Reference                                                                          |
| ------ | ---------------------------------------------------------------------------------- |
| All    | `.claude/skills/wayfinder/SKILL.md` — SUGGEST, CHART, RESOLVE, the map, node types |
| Step 0 | `GAPS.md` · `DEFERRED.md` — the standing register                                  |
| Step 1 | This folder's `CONTEXT.md` → _Reading order_                                       |
| Step 2 | The claiming-versus-closing boundary in the wayfinder skill                        |
| Step 4 | `code/docs/CODE-REVIEW-GRAPH.md` — the explore playbook                            |
| Step 8 | The graduation table in the wayfinder skill                                        |

---

## Prerequisites

- [ ] A feature idea exists as prose or a conversation, not yet as stories — **or** Step 0 is
      being run to find one
- [ ] `.claude/skills/wayfinder/SKILL.md` read
- [ ] No stories written for this feature yet

---

## SUGGEST — optional, when there is no feature yet

### Step 0 — Mine the register for candidates

> **Model:** fable

Skip if <%DEVELOPER_NAME%> already has the feature in mind. Run it when the next feature is not obvious, or
on a cadence — after a release, at the start of a planning cycle.

1. Read every open `GAPS.md` entry (ignore `✅ CLOSED`) and every `DEFERRED.md` row whose target
   story has not shipped, then the `IMPLEMENTATION/` and `19-FINDINGS/` records behind them — a
   one-line summary is rarely the whole story.
2. **Cluster by shared cause, surface, or dependency.** Five deferrals waiting on the same missing
   table are one feature, not five. An entry that is a one-story fix is not a feature — route it
   to `02-story-creation` and say so.
3. Put the candidates to <%DEVELOPER_NAME%> **ranked**: what each closes entry by entry, why the cluster hangs
   together, what stays open if it is not taken.

**Suggest only.** Nothing is written — no map, and no edit to the register. Charting begins only
once <%DEVELOPER_NAME%> picks a candidate.

_Done when every open entry is clustered and the ranked candidates are put to <%DEVELOPER_NAME%>._

---

## CHART — one session

### Step 1 — Load the ground truth

> **Model:** fable

Load in order, each layer narrowing the next:

1. **The root `CONTEXT.md` → _What this project is_** — the brief the feature is scoped against
2. The rest of `CONTEXT.md` then `CLAUDE.md`, root down to the areas in play
3. **`how-to/src/SCALE-ARCHITECTURE/`** — the size the project is designed for, and therefore
   what it does **not** need. A feature that quietly assumes a different size is a scope defect,
   not an implementation detail
4. The relevant `**/docs/` guides for the constraints a decision must respect
5. **`GAPS.md` and `DEFERRED.md`** — the standing register of unfinished business
6. **The whole of `project-management/src/`** — stories, specs, decisions, plans, and records
7. The codebase, via the `code-review-graph` explore playbook

`src/` is the living state, not an archive: the `IMPLEMENTATION/` records say what shipped **and
where it diverged from the plan**. Map against that, not against intentions.

### Step 2 — Triage the register against this feature

> **Model:** fable

Every open entry in `GAPS.md` and `DEFERRED.md` gets exactly one verdict:

| Verdict       | Meaning                                                 | Where it goes                              |
| ------------- | ------------------------------------------------------- | ------------------------------------------ |
| **closes**    | This feature retires the entry                          | **Register claimed** on the map            |
| **blocks**    | The entry stands in this feature's way                  | A **frontier node**, typed and wired       |
| **unrelated** | Neither — recorded so the triage is provably exhaustive | Nothing; note the count in the map's Notes |

A gap this feature retires is **part of what "done" means** — it belongs in the destination, not
as a footnote discovered at implementation. A gap that blocks it is a decision node, never an
assumption.

**Claim, never close.** Do not edit `GAPS.md` or `DEFERRED.md` here. Closing an entry is
`21-implementation-documentation`'s job, against shipped code — a claim is a promise, a close is
evidence.

_Done when every open entry carries a verdict and the closes/blocks entries are on the map._

### Step 3 — Pin the destination

> **Model:** fable

Open a `/grill-with-docs` pass to name, in one or two lines, what "done" looks like — and the
bounds: what is consciously **out**. Look the repo up before asking.

_Done when the destination and out-of-scope bounds are written and confirmed._

### Step 4 — Map the frontier breadth-first

> **Model:** fable

Explore the feature's surface and surface **every currently-knowable open decision**. Breadth
first — do not follow one branch to the bottom. Anything in scope but not yet sharp enough to
state as a decision goes to **fog of war**, honestly.

_Done when every knowable decision is a node or parked in fog of war._

### Step 5 — Wire the blocking edges

> **Model:** fable

Second pass: write each node's blockers as links to the nodes it depends on, so the **takeable
edge** — the unblocked nodes — is visible at a glance.

_Done when every frontier node names its blockers (or "none") and at least one is unblocked._

### Step 6 — Write the map

> **Model:** fable

Copy `src/01-FEATURE/MAP-000-TEMPLATE.md` → `MAP-<FEATURE>.md`. Tag each frontier node with its
type: **research** (looked up, no human), **tracer** (spike to raise fidelity), **grilling**
(one `/grill-with-docs` surface), **task** (manual unblocking work). Fill **Register claimed**
from the Step 2 triage. Add the map to the index in `src/01-FEATURE/CONTEXT.md`.

_Done when the map exists, is indexed, carries its claimed register entries, and reads as a route
rather than a vault._

### Step 7 — Fire the research nodes, then stop

> **Model:** fable

Dispatch research nodes now — they need no human. **Do not settle grilling, tracer, or task
nodes in this session.** Charting ends with the frontier drawn and unresolved.

---

## RESOLVE — one node per later session

### Step 8 — Take a node, settle it, graduate it

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
6. **Re-triage the register if the outcome moved it** — a settled node that retires a further
   entry adds a **Register claimed** row; one that raises a new blocker appends to `GAPS.md`.

_Repeat until no **blocking** node remains open._

### Step 9 — Close out

> **Model:** opus

- Confirm every resolved node links to the artefact it became
- Confirm every claimed register entry names the node or story that will retire it, and that
  neither `GAPS.md` nor `DEFERRED.md` was closed here
- Confirm no story has been written yet — that is `02-story-creation`
- Satisfy `CHECKLIST.md`

Next: `02-story-creation/`, cutting stories from the resolved map.
