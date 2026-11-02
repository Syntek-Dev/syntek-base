---
type: guide
skills: [story, global-workflow]
model: opus
---

# Stories and Story Plans

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Writing a `US###` (`src/02-STORIES/`) and its implementation plan
(`src/17-STORY-PLANS/`). Index: [`../PLANNING-GUIDE.md`](../PLANNING-GUIDE.md).

---

## Cutting stories from the map

Stories are cut from the resolved `MAP-<FEATURE>.md` (`src/01-FEATURE-MAPS/`), not invented from a
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

**The vocabulary is owned by `.claude/skills/completion/SKILL.md`** — the twelve statuses, their
meanings, the transition rules and the completion clock are written there once. In planning
terms the lifecycle reads:

`Open` → `Pending` → `In Progress` → `In Review` → `Accepted` → `Customer Review` →
`Customer Accepted` → (window) → `Completed` → `Closed` (archive)

- **Side exits.** `Rejected` (internal review or QA) and `Customer Rejected` both return the
  story to `Pending`; `Blocked` is a wait on dependencies. Nothing skips `Accepted`.
- **The customer gate** is the story's FLAGS row `Customer review`: absent or `Yes` means it
  applies; `N/A` skips the three customer statuses (`Accepted` → window → `Completed`).
- **The window.** `Completed` is reached by time, not judgement — `FEEDBACK_WEEKS` after
  customer acceptance, and no earlier than `CUSTOMER_REVIEW_WEEKS` + `FEEDBACK_WEEKS` after the
  story entered `Customer Review`. Both are Copier answers (defaults 2 and 4). After
  `Completed`, changes are chargeable work, cut as a new story.
- **Status history.** Every transition appends a row to the story's `## Status history` table;
  the clock reads its dates.
- **The board and the archive.** `src/02-STORIES/STORIES-BOARD.md` is generated from the status
  lines by `pm-board.sh --write`. `pm-archive.sh US###` sets `Closed` on a `Completed` story and
  moves it, with its story plan, into `02-STORIES/archive/` — frozen thereafter, and still found
  by ID. `pm-board.sh --warn` names the stories ready for `Completed` or for archiving.

The words are mirrored into `project-management/export/clickup/` and pushed by the
`clickup-sync` workflow; a tool whose board uses different words maps them once, through
`CLICKUP_STATUS_MAP` (`pm-tool-sync`), rather than mixing the two.

---

## Numbering

`US###` — three-digit zero-padded. **Numeric gaps are deliberate**: only files that exist are
listed, and a retired number is never reused. Renumbering to close a gap breaks every
cross-reference pointing at the old number. The next free number is taken across
`02-STORIES/` **and** its `archive/` — an archived story still holds its number.

---

## The story plan

`<exec-order>-STORY-PLAN-US###-<DESCRIPTOR>.md` in `src/17-STORY-PLANS/`, written by
`17-story-plans` when the story's sprint fills. **This is the master a developer codes from** —
not the story, and not the sprint plan.

**The prefix is build order, and it is renumbered whenever build order changes.** `<exec-order>`
is 2-digit zero-padded and gives the story's position in the settled build sequence across the
whole backlog — not its sprint, and not a per-sprint counter; `00-` is the template. **This is the
opposite of the sprint plan's guardrail** ([`SPRINTS.md`](SPRINTS.md)): there, `{exec-order}`
disagreeing with `{sprint-number}` is deliberate and must never be "corrected", because the pair
is what carries the meaning. A story plan has one number, so it either tracks build order or it
says nothing. Rule owner: `src/17-STORY-PLANS/CLAUDE.md`.

<!--
08/09/2026 — superseded by the line above when the plans gained their `<exec-order>` prefix.
Previous text: "`STORY-PLAN-US###-<DESCRIPTOR>.md` in `src/17-STORY-PLANS/`, written by
`17-story-plans` when the story's sprint fills."
-->

It records:

- Technical approach per layer (database, service, API, frontend)
- A key-decisions table — chosen vs rejected, with rationale and a doc reference
- A dependency matrix — blocked-by / blocks / can-start-now
- Phased tasks mapped onto `19-backend-code` → `20-api-code` → `21-frontend-code`
- A test strategy per layer, defined before any code
- GDPR, security, and QA constraints **carried in** from the `02`–`13` specs, not re-derived
- Deferred items and risks, each against a named future story

**Keep the dependency callout honest.** A plan carries no status of its own (the board shows
the story's), so its `blocked-by` / `blocks` callout is what the parallel-worktree DAG reads —
and it depends on that being true.

**Consolidation can invalidate a plan.** If `18-consolidate-design-work` changes a shape the plan
assumed, the plan is corrected there — before code, not after.

---

## Related

- [`CADENCE.md`](CADENCE.md) — when in the loop each of these is written
- [`SPRINTS.md`](SPRINTS.md) — the sprint the story is slotted into
- `project-management/docs/QA-GUIDE.md` — the scenario format acceptance criteria must support
- `src/02-STORIES/US000-TEMPLATE.md` · `src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md`
