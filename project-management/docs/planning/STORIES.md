---
type: guide
skills: [story, global-workflow]
model: fable
---

# Stories and Story Plans

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Writing a `US###` (`src/02-STORIES/`) and its implementation plan
(`src/16-STORY-PLANS/`). Index: [`../PLANNING-GUIDE.md`](../PLANNING-GUIDE.md).

---

## Cutting stories from the map

Stories are cut from the resolved `MAP-<FEATURE>.md` (`src/01-FEATURE/`), not invented from a
conversation. A story whose shape is still an open node on the map is premature — settle the node
first, or the story's acceptance criteria encode a guess.

One story is a slice of user-visible value, not a layer. "Add the users table" is a task inside a
story; "a visitor can register and verify their email" is a story.

---

## Story format

Connextra, plus the scaffold in `src/02-STORIES/US000-TEMPLATE.md`:

```text
As a [role], I want [goal], so that [benefit].
```

Every story carries an authoritative `**Epic:**` line, a `**Status:**`, MoSCoW priority, a story
point estimate, and acceptance criteria.

**Acceptance criteria are the contract.** They become the QA scenarios (`11-qa-checks`), the TDD
cases, and the definition of done. Vague criteria are the single most expensive defect in this
layer: they pass review, then fail at implementation when everyone discovers they read them
differently.

Testable means an observer could agree it passed without asking the author.

---

## Story point estimation

Fibonacci: 1, 2, 3, 5, 8, 13, 21. Relative sizing, not hours.

**Two thresholds, and they measure different things.** Keep both — collapsing them to one loses
whichever question the survivor does not ask:

| Points  | Verdict                  | The question it answers                                 |
| ------- | ------------------------ | ------------------------------------------------------- |
| **>8**  | Advisory — usually split | Is this comfortably deliverable inside one sprint?      |
| **≥13** | **It is an epic**        | Is this one story at all, or several wearing one title? |

- A story larger than 8 usually wants splitting — but split along a **user-value seam**, not a
  layer boundary. Two halves that each ship something are a good split; "backend half" and
  "frontend half" are one story wearing two hats. A 13 that genuinely has no seam stays a 13
  and gets said so out loud, which is what makes the advisory tier advisory.
- **13 or more is an epic, and that is not a size judgement — it is a shape one.** INVEST's
  _Small_ has already failed at that point, and so, almost always, has _Independent_: a story
  that big is carrying more than one piece of user value. It goes back to the feature map to be
  cut, rather than being estimated harder.
- A story you cannot estimate is a story you do not understand yet. That is a signal to go back
  to the map, not to guess.

---

## Story statuses

The **ClickUp** board vocabulary — the template's default PM board. Each story's `**Status:**`
header must be one of these; they are mirrored into `project-management/export/clickup/` and
pushed by the `clickup-sync` workflow.

| Status              | Meaning                                                       |
| ------------------- | ------------------------------------------------------------- |
| `Open`              | Created, not yet refined or started (default for a new story) |
| `Pending`           | Refined and queued, awaiting a start                          |
| `In Progress`       | Actively being worked                                         |
| `In Review`         | PR raised / under code review                                 |
| `Accepted`          | Internally QA-accepted                                        |
| `Accepted Customer` | Signed off by the client                                      |
| `Rejected`          | Sent back internally                                          |
| `Rejected Customer` | Sent back by the client                                       |
| `Blocked`           | Blocked on a dependency                                       |
| `Completed`         | Done and merged to `testing`; not yet deployed                |
| `Closed`            | Fully closed / archived                                       |

New stories start as `Open`. This is the canonical set — if a project's board uses different
words, map them here once rather than mixing the two.

---

## Numbering

`US###` — three-digit zero-padded. **Numeric gaps are deliberate**: only files that exist are
listed, and a retired number is never reused. Renumbering to close a gap breaks every
cross-reference pointing at the old number.

---

## The story plan

`STORY-PLAN-US###-<DESCRIPTOR>.md` in `src/16-STORY-PLANS/`, written by `16-story-plans` when the
story's sprint fills. **This is the master a developer codes from** — not the story, and not the
sprint plan.

It records:

- Technical approach per layer (database, service, API, frontend)
- A key-decisions table — chosen vs rejected, with rationale and a doc reference
- A dependency matrix — blocked-by / blocks / can-start-now
- Phased tasks mapped onto `18-backend-code` → `19-api-code` → `20-frontend-code`
- A test strategy per layer, defined before any code
- GDPR, security, and QA constraints **carried in** from the `02`–`13` specs, not re-derived
- Deferred items and risks, each against a named future story

**Keep the dependency callout honest.** A plan marked anything other than `Blocked` asserts its
blockers are cleared, and the parallel-worktree DAG depends on that being true.

**Consolidation can invalidate a plan.** If `17-consolidate-design-work` changes a shape the plan
assumed, the plan is corrected there — before code, not after.

---

## Related

- [`CADENCE.md`](CADENCE.md) — when in the loop each of these is written
- [`SPRINTS.md`](SPRINTS.md) — the sprint the story is slotted into
- `project-management/docs/QA-GUIDE.md` — the scenario format acceptance criteria must support
- `src/02-STORIES/US000-TEMPLATE.md` · `src/16-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md`
