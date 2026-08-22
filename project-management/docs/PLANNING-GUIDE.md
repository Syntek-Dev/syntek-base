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

| Sub-document                                 | Governs                                              | Serves                                     |
| -------------------------------------------- | ---------------------------------------------------- | ------------------------------------------ |
| [`planning/CADENCE.md`](planning/CADENCE.md) | The loop, the sprint-fill trigger, the point ceiling | Every workflow `01`–`17`                   |
| [`planning/STORIES.md`](planning/STORIES.md) | Story format, statuses, and per-story plans          | `src/02-STORIES/` · `src/17-STORY-PLANS/`  |
| [`planning/SPRINTS.md`](planning/SPRINTS.md) | MoSCoW, phases, sprint records and plans             | `src/03-SPRINTS/` · `src/16-SPRINT-PLANS/` |

---

## Which one do I need?

- **"How does planning actually run here?"** → `CADENCE.md`. Start here if you are new; the
  per-story loop is the thing most likely to be assumed wrong.
- **Writing or refining a `US###`, or its `STORY-PLAN-US###`** → `STORIES.md`.
- **Opening a `SPRINT-##` record, or writing its `SPRINT-PLAN`** → `SPRINTS.md`.

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
