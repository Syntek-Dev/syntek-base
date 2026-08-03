# project-management/docs/planning

The planning standard, split into three sub-documents behind
[`../PLANNING-GUIDE.md`](../PLANNING-GUIDE.md) — the thin index over this folder.

## Directory Tree

```text
project-management/docs/planning/
├── CONTEXT.md    ← this file
├── CLAUDE.md     ← operating rules for this folder
├── CADENCE.md    ← the loop, the sprint-fill trigger, the point ceiling
├── STORIES.md    ← story format, statuses, estimation, per-story plans
└── SPRINTS.md    ← MoSCoW, sequencing, development phases, sprint plans
```

## Which file owns what

| File         | Owns                                                                         | Serves                                     |
| ------------ | ---------------------------------------------------------------------------- | ------------------------------------------ |
| `CADENCE.md` | The per-story loop, the fill trigger, `SPRINT_CAPACITY_SP`/`SPRINT_GRACE_SP` | Every workflow `01`–`17`                   |
| `STORIES.md` | Connextra format, statuses, Fibonacci estimation, the story plan             | `src/02-STORIES/` · `src/16-STORY-PLANS/`  |
| `SPRINTS.md` | MoSCoW, exec-order vs sprint-number, the four phases, the sprint plan        | `src/03-SPRINTS/` · `src/15-SPRINT-PLANS/` |

**The capacity figure is stated once**, in `CADENCE.md`. `SPRINTS.md` points at it rather than
repeating it — two copies of a tunable number is how they drift apart.

## Why the split

This was one file (`SPRINT-PLANNING-GUIDE.md`) until the cadence outgrew its name: the per-story
loop governs workflows `01`–`17`, not sprint planning, and nobody looking for "how does planning
work here" would have opened a sprint guide.

Same pattern as `../GDPR-GUIDE.md` over `../gdpr/`: a thin index, sub-documents by audience.

## Cross-references

- `../PLANNING-GUIDE.md` — the index
- `project-management/workflows/CONTEXT.md` — the workflow index and cadence diagram
- `project-management/workflows/01-feature/` — the map the loop is cut from

**Last Updated**: <%DATE%>
