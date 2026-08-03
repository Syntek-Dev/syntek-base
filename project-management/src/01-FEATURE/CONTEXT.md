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

| Section                | Holds                                                             |
| ---------------------- | ----------------------------------------------------------------- |
| **Destination**        | One or two lines: what "done" looks like                          |
| **Notes**              | Domain, skills to load, standing preferences, umbrella plans/ADRs |
| **Resolved decisions** | Settled nodes, each linking to the ADR / plan / story it became   |
| **Frontier**           | Open decisions in dependency order, with blocking edges           |
| **Fog of war**         | In scope, not yet sharp enough to state as a decision             |
| **Out of scope**       | Consciously ruled out, and why                                    |

**The map is an index, not a vault.** Detail lives in the artefact each node graduates to.

## Map index

| Map                                   | Feature | Status | Frontier open | Charted |
| ------------------------------------- | ------- | ------ | ------------- | ------- |
| _(none yet — base template scaffold)_ |         |        |               |         |

Add a row on charting; keep the status and open-node count current as nodes resolve.

## The map is not finished when stories start

Stories may begin once every **blocking** node is resolved. Fog of war and non-blocking nodes
routinely stay open — a map is a living route, and a feature that must be fully known before any
story is written is a feature that never starts.

## Cross-references

- `MAP-000-TEMPLATE.md` — the map template
- `.claude/skills/wayfinder/SKILL.md` — CHART and RESOLVE, node types, the graduation table
- `../14-DECISIONS/` — where hard-to-reverse resolutions graduate
- `../02-STORIES/` — the stories cut from a resolved map
- `../16-STORY-PLANS/` — per-story plans, which cite the ADRs this map produced
- `project-management/workflows/01-feature/` — the workflow that produces these

**Last Updated**: <%DATE%>
