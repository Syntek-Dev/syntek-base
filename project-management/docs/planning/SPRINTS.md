---
type: guide
agent: sprint
skills: [global-workflow]
model: fable
---

# Sprints and Sprint Plans

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Opening a `SPRINT-##` record (`src/03-SPRINTS/`) and writing its plan
(`src/15-SPRINT-PLANS/`). Index: [`../PLANNING-GUIDE.md`](../PLANNING-GUIDE.md).

---

## Two artefacts, two moments

| Artefact                                         | Written by           | When                                       | Holds                                               |
| ------------------------------------------------ | -------------------- | ------------------------------------------ | --------------------------------------------------- |
| `src/03-SPRINTS/SPRINT-##.md`                    | `03-sprint-planning` | Opened early; filled as stories clear `14` | Goal, timeline, capacity, story table, dependencies |
| `src/15-SPRINT-PLANS/{exec}-SPRINT-PLAN-{##}.md` | `15-sprint-plans`    | The moment the sprint fills                | Phase breakdown, constraints, definition of done    |

The **record** is the running ledger — it accumulates stories with their points, and it is what
tells you the sprint is full. The **plan** is written once, against a settled story set.

---

## MoSCoW

Four tiers. A plan must contain at least the **Must** tier; **Should** and **Could** are stretch
and are dropped first when capacity tightens.

| Priority   | Definition                                                | Rule                                                       |
| ---------- | --------------------------------------------------------- | ---------------------------------------------------------- |
| **Must**   | Sprint fails without this — core functionality or blocker | Capacity must be reserved to deliver all Must stories      |
| **Should** | High value; included if capacity allows                   | Included in the plan; dropped if Must stories overrun      |
| **Could**  | Nice to have; low priority                                | Only started once all Must and Should stories are complete |
| **Won't**  | Out of scope for this sprint; explicitly deferred         | Recorded in the plan to prevent scope creep                |

**Avoid a plan where everything is Must.** If every story is Must, the sprint has no give and the
first surprise breaks it — re-evaluate scope or split the sprint.

---

## Sequencing

Sprint numbering is **not** execution order. Honour the dependency chain: never schedule a story
ahead of its blocker, even if that leaves a lower-numbered sprint running later.

That is also why the plan filename carries two segments:

```text
{exec-order}-SPRINT-PLAN-{sprint-number}.md   (e.g. 01-SPRINT-PLAN-01.md)
```

Both 2-digit zero-padded. `{exec-order}` is the recommended **build** sequence; `{sprint-number}`
is the sprint it plans, matching `src/03-SPRINTS/SPRINT-##.md`. They usually match, and diverge
deliberately when a sprint must be built out of number order — an infrastructure or observability
sprint pulled early. **Do not "correct" a deliberate mismatch.**

---

## Development phases

Each sprint follows the same four-phase sequence. Stories map to phases by the layers they touch.

| Phase | Workflow           | What is built                                                 |
| ----- | ------------------ | ------------------------------------------------------------- |
| **1** | `18-backend-code`  | Django models, services, business logic, migrations           |
| **2** | `19-api-code`      | Django Ninja routers, endpoints, and request/response Schemas |
| **3** | `20-frontend-code` | Django views + templates, django-components (HTMX + Alpine)   |
| **4** | `22-pr-and-review` | PR, code review, QA sign-off, merge to `testing`              |

Tests are written **alongside** each phase, not after. A story may touch only some phases — a
purely backend change skips Phase 3 — and the plan records which each story needs.

`21-implementation-documentation` runs between Phase 3 and Phase 4: it writes the implementation
records and refreshes the graph, and it is a merge gate.

---

## What a sprint plan holds

- **Sprint goal** — one sentence: what this sprint delivers and why
- **Stories** — grouped Must / Should / Could / Won't, each linked to its story plan and QA plan
- **Story-plans index** — each in-scope story → its `STORY-PLAN-US###-*.md`
- **Phase breakdown** — the stories in each of the four phases, with key deliverables
- **Sprint-wide constraints** — GDPR / security / QA / SEO summaries drawn from `09`–`13`
- **Definition of done**

**No per-story implementation depth.** Models, endpoints, components, and field-level
GDPR/security belong in the story plan (`src/16-STORY-PLANS/`). The sprint plan carries only
sprint-wide summaries and the index — duplicating the detail guarantees the two drift.

---

## Capacity

The point ceiling and the fill trigger live in [`CADENCE.md`](CADENCE.md) → _Sprint capacity_.
Record capacity in the sprint record as `used / total SP`, and call out an under-capacity sprint
in the notes rather than padding it.

---

## Related

- [`CADENCE.md`](CADENCE.md) — the fill trigger and the point ceiling
- [`STORIES.md`](STORIES.md) — the stories a sprint is built from
- `src/03-SPRINTS/SPRINT-00-TEMPLATE.md` · `src/15-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md`
- `project-management/docs/VERSIONING-GUIDE.md` — when the sprint includes a release
