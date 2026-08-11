# project-management/src/01-FEATURE

Feature decision maps — one `MAP-<FEATURE>.md` per feature or epic, produced by
`workflows/01-feature/` using wayfinder. The map charts the feature's decision frontier and
records each decision as it is settled. **It is the foundation every later planning gate reads.**

## Directory Tree

```text
project-management/src/01-FEATURE/
├── CONTEXT.md            ← this file (also the map index)
├── CLAUDE.md             ← operating rules for this folder
├── MAP-000-TEMPLATE.md   ← copy this to chart a feature
└── MAP-<FEATURE>.md      ← one map per feature or epic
```

**Naming:** `MAP-<FEATURE>.md` — `<FEATURE>` in `SCREAMING-KEBAB-CASE`.

## Why this exists

Everything from `02-story-creation` to `14-decisions` is a **per-story loop**. Without a map, each
story rediscovers the same cross-cutting questions — the auth model, the tenancy boundary, where
state lives — and answers them slightly differently, because each story sees only its own slice.
The consolidation gate at `17` then has to unpick five inconsistent answers.

Charting first inverts that. The questions are asked once, before any story exists, and every
story is cut from the settled answers.

## What a map holds

| Section                | Holds                                                                  |
| ---------------------- | ---------------------------------------------------------------------- |
| **Destination**        | One or two lines: what "done" looks like                               |
| **Notes**              | Domain, skills to load, standing preferences, umbrella plans/ADRs      |
| **Register claimed**   | `GAPS.md` / `DEFERRED.md` entries this feature closes or is blocked by |
| **Resolved decisions** | Settled nodes, each linking to the ADR / plan / story it became        |
| **Frontier**           | Open decisions in dependency order, with blocking edges                |
| **Fog of war**         | In scope, not yet sharp enough to state as a decision                  |
| **Out of scope**       | Consciously ruled out, and why                                         |

**The map is an index, not a vault.** Detail lives in the artefact each node graduates to.

## Map index

| Map                | Feature | Status | Frontier open | Charted |
| ------------------ | ------- | ------ | ------------- | ------- |
| _None charted yet_ | —       | —      | —             | —       |

Add a row on charting; keep the status and open-node count current as nodes resolve.

**One map arrives before any feature does.** `MAP-SCALE-PLANNING.md` is seeded into this folder at
generation, every row reading `TBD`, because six shipped guides route to it. It is **seeded, not
charted** — which is why it has no row above. `/scale-planning` charts it, and charting it is the
gate on the first feature: a feature cannot be judged against a size nobody has written down.

**Node numbers are scoped per map** — each map runs its own `N-001…`. A cross-map dependency is
written with its map name (`N-019 on MAP-<FEATURE>`), never as a bare node number.

## The map is not finished when stories start

Stories may begin once every **blocking** node is resolved. Fog of war and non-blocking nodes
routinely stay open — a map is a living route, and a feature that must be fully known before any
story is written is a feature that never starts.

## Cross-references

- `MAP-000-TEMPLATE.md` — the map template
- `.claude/skills/wayfinder/SKILL.md` — SUGGEST, CHART and RESOLVE, node types, the graduation
  table, and the claiming-versus-closing line
- `GAPS.md` · `DEFERRED.md` — the standing register a map claims from; closed by
  `project-management/workflows/21-implementation-documentation/`, never here
- `../14-DECISIONS/` — where hard-to-reverse resolutions graduate
- `../02-STORIES/` — the stories cut from a resolved map
- `../16-STORY-PLANS/` — per-story plans, which cite the ADRs this map produced
- `project-management/workflows/01-feature/` — the workflow that produces these

**Last Updated**: <%DATE%>
