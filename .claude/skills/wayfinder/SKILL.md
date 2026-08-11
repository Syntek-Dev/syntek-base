---
name: wayfinder
description: >-
  Chart a large, ambiguous body of work — bigger than one session can hold — into a shared
  markdown map of open decisions, then resolve them in sensibly grouped batches across sessions.
  Invoke by
  typing /wayfinder suggest to mine GAPS.md and DEFERRED.md for candidate features,
  /wayfinder chart <epic> to map an epic's decision frontier, /wayfinder resolve <map>
  to settle its next batch of related decisions, or when a body of work is too big to hold in
  a single grilling pass.
---

# Skill: wayfinder (<%PROJECT_SLUG%>)

Wayfinder takes on work too big to hold in one head — a whole epic, a cross-cutting migration,
an ambiguous programme — and turns the fog into a navigable **map** of open decisions resolved
incrementally across sessions. Instead of charging at an unclear **destination**, it charts the
route first: surface the decisions, order them, then settle them in related batches until the way is
clear.

**Scope, versus grilling.** Grilling sharpens **one** design surface in a single sitting.
Wayfinder maps a whole epic's decision **frontier** and dispatches **batches of related decision
nodes** to grilling to settle. Wayfinder is the cartographer; grilling is the per-node engine. Reach for
wayfinder when the work spans several stories and cannot be resolved in one grilling pass; reach
straight for `/grill-with-docs` when it is a single surface.

**The map is a markdown artefact** — `project-management/src/01-FEATURE/MAP-<FEATURE>.md`. It is a
low-resolution index, never a storage vault: detail lives in the ADR, plan, or story each entry
links to. The decisions it graduates land in their existing homes (ADRs, plans, stories,
`GAPS.md`, `DEFERRED.md`); the stories it spawns sync to ClickUp through the existing
`clickup-sync` workflow — wayfinder writes markdown only, never to ClickUp directly.

Facts are looked up, not asked: `code-review-graph` MCP → Read/Grep/Glob → `.claude/plugins/*.py`
(and `context7` for library docs). Only genuine decisions with a real trade-off go to <%DEVELOPER_NAME%>.

**The standing register is read, not only written.** `GAPS.md` (active gaps, blockers, sprint
dependencies) and `DEFERRED.md` (work explicitly deferred from a shipped story to a named future
one) are where earlier work recorded its unfinished business. Wayfinder reads them at both ends:
they **suggest** what the next feature should be, and they are **claimed** by the feature that
will close them, so the map records the debt it retires. Treating them as write-only destinations
is what lets a register accumulate for a year while features are chosen from memory.

Wayfinder runs in one of three modes per session: **SUGGEST** (optional, before there is a
feature — mine the register for candidates), **CHART** (one session — read the register, pin the
destination, map the frontier, write the map) or **RESOLVE** (later sessions — settle the next
frontier node, graduate it, redraw the frontier). A charted epic reads as one
`project-management/src/01-FEATURE/MAP-<FEATURE>.md` whose resolved nodes fan out into the ADRs
they became, the stories they were sliced into, and any cross-story blocker left in `GAPS.md`.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## Steps — SUGGEST (optional, before a feature exists)

Run when the next feature is not obvious, or on a cadence — after a release, or at the start of a
planning cycle — to see what the register has accumulated.

1. **Read the whole register.** `GAPS.md` (every open entry, ignoring `✅ CLOSED` rows) and
   `DEFERRED.md` (every row whose target story has not shipped). Read `project-management/src/`
   for the `IMPLEMENTATION/` and `19-FINDINGS/` records behind them — a gap's one-line summary is
   rarely the whole story. _Done when every open entry is in view with its origin._
2. **Cluster into candidate features.** Group entries that share a cause, a surface, or a
   dependency: five deferrals all waiting on the same missing table are **one** feature, not five.
   A single entry that is genuinely a whole body of work is a candidate on its own; an entry that
   is a one-story fix is not a feature and routes to `02-story-creation` instead.
3. **Put the candidates to <%DEVELOPER_NAME%>, ranked.** For each: what it closes (entry by entry), why the
   cluster hangs together, and what stays open if it is not taken. Rank by how much of the
   register each retires against its size. **Suggest only — never chart one without confirmation.**
   _Done when <%DEVELOPER_NAME%> has picked a candidate, deferred them all, or redirected to something else._

A candidate that is picked becomes the input to CHART. Nothing is written to the repo in this
mode — no map, and no edit to the register.

## Steps — CHART (one session)

1. **Read the standing register.** `GAPS.md` and `DEFERRED.md`, before the destination is pinned.
   Two questions: which open entries does this feature **close**, and which are **blockers on it**
   that must become frontier nodes. A gap this feature retires is part of what "done" means; a gap
   that blocks it is a node, not a footnote. _Done when every open entry is triaged closes /
   blocks / unrelated._
2. **Pin the destination.** Open a `/grill-with-docs` pass to name what "done" looks like in one
   or two lines, and the epic's bounds — what is in, what is consciously out. Look the repo up
   before asking (`code-review-graph` → Read/Grep/Glob → `.claude/plugins/*.py`). _Done when the
   Destination and Out-of-scope bounds are written and <%DEVELOPER_NAME%> has confirmed them._
3. **Map the frontier breadth-first.** Explore the epic's surface with the `code-review-graph`
   explore playbook (`code/docs/CODE-REVIEW-GRAPH.md`) plus the target `CONTEXT.md`, surfacing
   every currently-knowable open decision. Anything still too vague to state as a decision goes to
   **Fog of war**. _Done when every knowable decision is either captured as a node or parked in
   Fog of war._
4. **Wire the blocking edges.** In a second pass, write each node's blockers as prose links to the
   nodes it depends on, so the takeable edge — the unblocked nodes — is visible at a glance.
   _Done when every Frontier node names its blockers (or "none") and at least one node is unblocked._
5. **Write the map.** Create `MAP-<FEATURE>.md` in `project-management/src/01-FEATURE/` with the
   sections below; tag each Frontier node with its type (research / tracer / grilling / task), and
   record the triaged register entries under **Register claimed**. Add the map to the index in
   `src/01-FEATURE/CONTEXT.md`. _Done when the map exists, is indexed, and reads as a
   low-resolution route rather than a storage vault._
6. **Fire the research nodes, then stop.** Dispatch any research nodes (facts, not decisions) in
   parallel now — they need no human. Charting is one session: do **not** settle grilling, tracer,
   or task nodes here. _Done when the research nodes are dispatched and the session ends with the
   frontier drawn but unresolved._

## Steps — RESOLVE (each later session)

1. **Load the map.** Read `MAP-<FEATURE>.md` for the low-resolution view; pull the linked ADRs,
   plans, and closed nodes only as you need them. _Done when the Destination and current Frontier
   are in view._
2. **Take the next batch, not the next node.** Start from <%DEVELOPER_NAME%>'s pick, or the unblocked
   Frontier, and gather the nodes that genuinely belong together into **one batch** — settled in a
   single sitting because deciding them apart would mean deciding them twice.

   Group by, in order of strength:
   - **Shared subject** — the same surface, schema, or document. Three nodes that turn out to be
     one question about three guides are rightly grilled once.
   - **Mutual dependence** — B's sensible answer changes with A's, so answering A alone forces a
     revisit.
   - **Shared evidence** — the same lookup, measurement, or file read settles all of them.

   **Split** where a node has its own blockers still open, is a different type (below), or would
   push the batch past what one sitting can hold honestly. **Order** batches by what unblocks the
   most downstream nodes; within a batch, parents before dependants.
   _Done when the batch is named, every member confirmed unblocked, and the reason they belong
   together is stated in one line._

3. **Settle the batch by type.** **Grilling** nodes go to `/grill-with-docs` as **one pass** — the
   skill's frontier rounds are exactly this shape one level down, so a batch of related nodes
   becomes the first round rather than N sequential interviews. **Research** nodes are looked up
   (dispatch them in parallel); a **tracer** builds a rough spike to raise fidelity on a foggy area;
   a **task** does the manual unblocking work. Mixed-type batches run their research legs first, so
   the grilling round opens with the facts already in hand.
   _Done when every node in the batch has a decision, made and confirmed._
4. **Graduate each outcome.** Record every settled decision in its real home via the graduation
   table — an ADR, a story-plus-plan, a `GAPS.md` entry, a `DEFERRED.md` row, or a glossary term —
   never leaving an answer only on the map. A batch settled together may still graduate to
   different artefacts. _Done when each outcome lives in the correct artefact and every
   Resolved-decisions entry links to it._
5. **Redraw the frontier once.** Move the whole batch from Frontier to Resolved decisions; graduate
   any Fog-of-war items the outcomes sharpened into new nodes; re-wire the blocking edges. _Done when
   the Frontier reflects the new takeable edge and no resolved node remains open on it._

## Reference

### The map artefact

```text
# MAP-<FEATURE> — <title>
## Destination           one or two lines: the spec / change the epic reaches
## Notes                 domain, skills to load, standing preferences, the umbrella PLAN/ADRs
## Register claimed      GAPS.md / DEFERRED.md entries this feature closes or is blocked by
## Resolved decisions    settled — each links to the ADR-### / STORY-PLAN-US### / US### it became
## Frontier              open decisions in dependency order; blocking edges as prose links
## Fog of war            in-scope but not yet sharp enough to be a node
## Out of scope          consciously ruled out, plus why
```

### Claiming versus closing — the ownership line

Wayfinder **claims** a register entry: it records on the map that this feature will retire it, so
the intent survives into the stories cut from the map. It never edits `GAPS.md` or `DEFERRED.md`
to mark anything done. **Closing belongs to
`project-management/workflows/21-implementation-documentation/`**, which owns register routing and
marks an entry `✅ CLOSED <date>` (or removes the `DEFERRED.md` row) against shipped code. A claim
is a promise; a close is evidence. Crossing that line puts a gap in the closed state with nothing
built behind it.

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
| architectural, hard to reverse, a genuine trade-off (the three-test ADR gate) | a new `ADR-###-<TITLE>.md` in `…/14-DECISIONS/`, taking the next free number                                              |
| a buildable slice of the epic                                                 | a story + plan — `…/02-STORIES/US###.md` + `…/16-STORY-PLANS/STORY-PLAN-US###-*.md` (copy `STORY-PLAN-US000-TEMPLATE.md`) |
| an active blocker or cross-repo dependency                                    | a `GAPS.md` entry                                                                                                         |
| deferred to a named future story                                              | a `DEFERRED.md` row, targeting the future `US###`                                                                         |
| terminology (one canonical word per concept)                                  | the glossary of the nearest `CONTEXT.md` (reference: `code/docs/data-structures/DOMAIN-MODELLING.md`)                     |

The ADR three-test gate and the glossary-into-`CONTEXT.md` move are exactly `grill-with-docs` —
that skill owns which artefact a resolved decision lands in; wayfinder only decides that it lands.
A slice's `US###` is pushed to the ClickUp board by the `clickup-sync` workflow, not by wayfinder.

### Completion criteria

- A **suggest** session is done when every open register entry has been clustered and the
  candidates put to <%DEVELOPER_NAME%> — whether or not one is picked.
- A **chart** session is done when every currently-knowable decision is on the map, the frontier
  is ordered, and every open register entry is triaged closes / blocks / unrelated.
- A **resolve** session is done when the chosen node is settled, recorded in the right artefact, and
  the frontier is redrawn.
- The **map** is done when Frontier and Fog of war are both empty — the route to the destination is
  fully charted.

### Anti-patterns

- **Resolving during a chart session** — charting draws the frontier; it settles nothing.
- **Storing decision detail in the map** — the map is a low-resolution index; detail lives in the
  ADR, plan, or story it links to.
- **Asking what the repo can answer** — look facts up before putting a question to <%DEVELOPER_NAME%>.
- **Grilling the whole epic in one sitting** — that is what the frontier is for; each node gets its
  own grilling.
- **Writing to ClickUp directly** — spawn the `US###` markdown and let the `clickup-sync` workflow
  push it.
- **Treating the register as write-only** — a feature charted without reading `GAPS.md` and
  `DEFERRED.md` re-decides what a past story already deferred, and leaves the debt it happens to
  retire unrecorded and therefore unclosed.
- **Closing a register entry from here** — wayfinder claims; `21-implementation-documentation`
  closes, against shipped code.
- **Suggesting a feature that is one story** — a single small gap is a story, not a feature; route
  it to `02-story-creation` rather than inflating it into a map.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/02-story-creation/` — charting an epic before decomposing it into stories
- `project-management/workflows/03-sprint-planning/` — charting before sprint candidates are picked

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the per-node engine wayfinder dispatches to.
- `.claude/skills/grill-with-docs/SKILL.md` — how a grilling node records its decision (the
  three-test ADR gate + glossary-into-`CONTEXT.md`).
- `.claude/skills/grill-me/SKILL.md` — the stateless twin, for thinking a node through without recording.
- `project-management/src/01-FEATURE/CONTEXT.md` — the map index, where a new map is registered.
- `project-management/src/16-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` — the plan a buildable
  slice graduates into.
- `project-management/src/14-DECISIONS/` — ADR home; take the next free `ADR-###`.
- `project-management/src/02-STORIES/US###.md` — the story a slice becomes; synced to ClickUp by `.github/workflows/clickup-sync.yml`.
- `GAPS.md` · `DEFERRED.md` — read at both ends: the standing register that SUGGEST mines for
  candidate features and CHART triages, and where blockers and named-future-story deferrals
  graduate. Closed by `project-management/workflows/21-implementation-documentation/`, never here.
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore playbook used to map the frontier.
- `code/docs/data-structures/DOMAIN-MODELLING.md` — the domain-modelling reference for terminology nodes.
- `.claude/plugins/*.py` — the read-only helpers for looking project facts up.
- `.claude/worktrees/` + `how-to/docs/GIT-WORKTREES.md` — where the graduated slices build in parallel.
