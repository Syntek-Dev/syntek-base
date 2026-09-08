---
type: guide
skills: [sprint, global-workflow]
model: fable
---

# Planning Guide — <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** fable — planning cadence, story and sprint conventions
**MCP Servers:** code-review-graph (scope and dependency impact analysis)

---

A thin index. The planning standard is split across three sub-documents, each serving a
different pair of `src/` folders — read the one that matches the artefact you are writing.

| Sub-document                                 | Governs                                                                  | Serves                                     |
| -------------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------ |
| [`planning/CADENCE.md`](planning/CADENCE.md) | The loop, the sprint-fill trigger, the point ceiling                     | Every workflow `01`–`17`                   |
| [`planning/STORIES.md`](planning/STORIES.md) | Story format, statuses, and the story plan with its build-order prefix   | `src/02-STORIES/` · `src/17-STORY-PLANS/`  |
| [`planning/SPRINTS.md`](planning/SPRINTS.md) | MoSCoW, phases, sprint records, and the sprint plan with its number pair | `src/03-SPRINTS/` · `src/16-SPRINT-PLANS/` |

---

## Which one do I need?

- **"How does planning actually run here?"** → `CADENCE.md`. Start here if you are new; the
  per-story loop is the thing most likely to be assumed wrong.
- **Writing or refining a `US###`, or its `STORY-PLAN-US###`** → `STORIES.md`.
- **Opening a `SPRINT-##` record, or writing its `SPRINT-PLAN`** → `SPRINTS.md`.
- **"What number goes in front of this plan filename?"** → the sub-document for that artefact,
  and only that one. Both plans carry an execution-order prefix and the two rules are opposites —
  a sprint plan's prefix has a sprint number to disagree with and may, a story plan's stands
  alone and must track build order. Do not read either across; the folder `CLAUDE.md` files under
  `src/16-SPRINT-PLANS/` and `src/17-STORY-PLANS/` are authoritative.

## The one-paragraph version

Stories are planned **one at a time**, each running the whole specify tier (`02`–`13`) and
finishing at `15-decisions` before the next one starts. Each completed story is slotted into the
open sprint record with its points; when that reaches `<%SPRINT_CAPACITY_SP%>` SP, planning
pauses while `16-sprint-plans` and `17-story-plans` run for that sprint, then resumes. Once every
story is planned, `18-consolidate-design-work` unifies the design work the stories produced
piecemeal. Only then does code start.

---

## Related

- `project-management/workflows/01-feature-map/` — the wayfinder map the whole loop is cut from
- `project-management/workflows/CONTEXT.md` — the workflow index and the cadence diagram
- `project-management/docs/QA-GUIDE.md` · `SECURITY-GUIDE.md` · `GDPR-GUIDE.md` — the
  per-discipline gates a story passes through inside the loop
- `project-management/docs/VERSIONING-GUIDE.md` — consulted when a sprint includes a release

<!--
08/09/2026 — the index table's `STORIES.md` and `SPRINTS.md` rows and a third routing bullet,
added when the plans in `src/17-STORY-PLANS/` were renamed to carry an `<exec-order>` prefix.
Previous rows: "Story format, statuses, and per-story plans" and "MoSCoW, phases, sprint records
and plans" — accurate before there were two prefix rules to route between, and silent about the
question a writer now arrives with. `planning/CONTEXT.md` holds the matching ownership table and
this one is kept in step with it (`planning/CLAUDE.md` → Definition of done).

Deliberately NOT changed: "STORY-PLAN-US###" in the second bullet. It is an artefact-class noun
with no extension and no path, parallel to "SPRINT-PLAN" on the line below it, and neither states
a filename pattern — the patterns are stated in the sub-documents and owned by the two folder
`CLAUDE.md` files. Prefixing the noun here would break that parallel and put a naming rule in a
thin index.
-->
