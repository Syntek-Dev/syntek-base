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

| File         | Owns                                                                                        | Serves                                     |
| ------------ | ------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `CADENCE.md` | The per-story loop, the fill trigger, `SPRINT_CAPACITY_SP`/`SPRINT_GRACE_SP`                | Every workflow `01`–`17`                   |
| `STORIES.md` | Connextra format, statuses, Fibonacci estimation, the story plan and its build-order prefix | `src/02-STORIES/` · `src/17-STORY-PLANS/`  |
| `SPRINTS.md` | MoSCoW, the sprint plan's exec-order/sprint-number pair, the four phases                    | `src/03-SPRINTS/` · `src/16-SPRINT-PLANS/` |

**The capacity figure is stated once**, in `CADENCE.md`. `SPRINTS.md` points at it rather than
repeating it — two copies of a tunable number is how they drift apart.

**"Exec-order" is not one rule, and the two halves are not shared.** Each plan artefact prefixes
its filename with an execution order, and each file owns the rule for its own artefact:
`SPRINTS.md` owns the sprint plan's `{exec-order}`/`{sprint-number}` **pair**, where the two
numbers disagreeing is deliberate; `STORIES.md` owns the story plan's **single** prefix, which
tracks build order across the whole backlog and is renumbered whenever that order changes. They
are opposites, so each states the contrast rather than assuming the reader has met the other, and
neither may be generalised into a rule about prefixed plan filenames. Above them both,
`src/16-SPRINT-PLANS/CLAUDE.md` and `src/17-STORY-PLANS/CLAUDE.md` are authoritative.

## Why the split

This was one file (`SPRINT-PLANNING-GUIDE.md`) until the cadence outgrew its name: the per-story
loop governs workflows `01`–`17`, not sprint planning, and nobody looking for "how does planning
work here" would have opened a sprint guide.

Same pattern as `../GDPR-GUIDE.md` over `../gdpr/`: a thin index, sub-documents by audience.

## Cross-references

- `../PLANNING-GUIDE.md` — the index
- `project-management/workflows/CONTEXT.md` — the workflow index and cadence diagram
- `project-management/workflows/01-feature-map/` — the map the loop is cut from

**Last Updated**: <%DATE%>

<!-- CORRECTED 08/09/2026. The _Which file owns what_ table assigned "exec-order vs
     sprint-number" to `SPRINTS.md` as though it were the folder's only rule about an execution
     order. That was true when written and stopped being true the same day, when the plans in
     `src/17-STORY-PLANS/` were renamed to carry an `<exec-order>` prefix and `STORIES.md` gained
     its own rule for it — a different artefact, and the opposite rule. Both rows were rewritten
     to name the rule each file actually owns, and the paragraph below the table added to state
     the split, because a reader who found only one of the two would reasonably have taken it for
     the convention. Previous rows: "Connextra format, statuses, Fibonacci estimation, the story
     plan" and "MoSCoW, exec-order vs sprint-number, the four phases, the sprint plan". -->
