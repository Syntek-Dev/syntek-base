---
type: guide
skills: [sprint, global-workflow]
model: fable
---

# Planning Cadence

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

The order planning runs in, and the trigger that fires sprint planning. Index:
[`../PLANNING-GUIDE.md`](../PLANNING-GUIDE.md).

---

## Why a human plans first

Every gate in this layer exists so that by the time implementation starts there is nothing left
to decide. Done properly, writing the code becomes the easy part — mechanical and unsurprising,
because every question that would have stalled it was answered upstream by a person.

It assumes real project-management and development knowledge. Someone without it can still work
the sequence: the numbered gates, their `STEPS.md` and `CHECKLIST.md` carry the questions you
would not have known to ask. You will move slower and lean harder on the grilling passes, and the
output is still a designed system rather than an accreted one.

---

## Map the feature first

`01-feature-map` charts the feature's decision frontier with wayfinder, then settles each node. The
resolved `MAP-<FEATURE>.md` is what the stories are cut from — and what stops every later
grilling pass re-asking the same cross-cutting questions.

Stories may start once every node marked **blocking** is resolved. Fog of war may remain open.

---

## Then plan one story at a time

A single story runs the whole specify tier — `02-story-creation` through `15-decisions` — before
the next story starts.

The reason is compounding. Story 2 is planned with everything story 1 settled already in hand;
story 7 inherits six stories' worth of resolved schema, flows, tokens, and ADRs. Batching a gate
across the backlog throws that away and re-litigates the same questions at every gate.

```text
01  chart the feature (once)
     ↓
02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11 → 12 → 13 → 14 → 15
                                                                   │
                                          sprint full? ────────────┤
                                            │            no → └────→ next story
                                           yes
                                            ↓
                                     16 → 17  (for that sprint's stories)
                                            │
                                            └→ next story
     ↓  (once every story is planned)
18  consolidate the per-story design work
     ↓
19 → 20 → 21  implement
```

---

## The flags are the gate entry conditions

Every story carries a 13-row FLAGS table, one row per gate, filled at `02-story-creation` from
the feature map's slice row. **A flag reading `N/A` means that gate is skipped for that story;
any other value means it runs.** That is the whole routing mechanism — the loop above is the
running order, and the flags decide which of its gates a given story actually enters.

| Flag       | Gate                   |     | Flag     | Gate                |
| ---------- | ---------------------- | --- | -------- | ------------------- |
| DB         | `04-database-schema`   |     | SEO      | `12-seo-checks`     |
| User Flow  | `05-user-flow-design`  |     | API      | `13-api-design`     |
| Brand      | `06-brand-guides`      |     | Logging  | `14-logging-checks` |
| Components | `07-component-designs` |     | Backend  | `19-backend-code`   |
| Wireframes | `08-wireframes`        |     | Frontend | `21-frontend-code`  |
| GDPR       | `09-gdpr-compliance`   |     |          |                     |
| Security   | `10-security-checks`   |     |          |                     |
| QA         | `11-qa-checks`         |     |          |                     |

Three rules follow, and each closes a way the mechanism fails quietly:

- **A blank row is not `N/A`.** `N/A` is a decision with a reason; blank is an unanswered
  question that skips a gate without anyone choosing to. All 13 rows are filled or the story is
  not written.
- **The flag is a manifest, never the design.** It says which gates run and gives them their
  first-pass values. The gate owns the design, may add to a value, and the story is updated to
  match at gate close. Treating the flag as authoritative and skipping the gate is the failure
  this table invites.
- **A downstream checklist reads the flag.** Any box demanding a gate's artefact is written
  "for every in-scope story whose <flag> is not `N/A`" — an unconditional demand cannot be
  ticked by a story that correctly skipped the gate.

Each gate states its own condition in its `CONTEXT.md` → _When to use this_. This table is where
the rule lives; those are the local facts.

---

## Sprint capacity — the trigger

| Figure       | Value                       | Meaning                                                    |
| ------------ | --------------------------- | ---------------------------------------------------------- |
| **Capacity** | `<%SPRINT_CAPACITY_SP%>` SP | The sprint is full. Stop planning stories; plan the sprint |
| **Grace**    | `<%SPRINT_GRACE_SP%>` SP    | Hard ceiling, for when the next story would split badly    |

Set at generation time (`SPRINT_CAPACITY_SP` / `SPRINT_GRACE_SP` in `copier.yml`) and editable <!-- doc-references: template-only -->
here afterwards — **this table is the canonical statement of both**.

**Reading the ceiling:**

- Capacity is a **trigger**, not a target to fill exactly. A sprint that lands on 10 SP because
  the next story is a 5 is a correct sprint, not an under-filled one.
- Grace exists for one situation: the next story would overshoot, and splitting it would produce
  two halves that make no sense alone. Grace is not a routine allowance — a sprint that habitually
  runs to it means the capacity figure is wrong.
- **Never split a story badly to hit the number.** A story split along an artificial seam costs
  more in rework than an oversized sprint costs in schedule.
- Revisit both figures after two sprints against measured velocity. A ceiling that does not match
  what the team delivers makes every sprint either starve or overrun.

---

## When a sprint plan is written

The moment its sprint fills — not at the end of a backlog-wide checks phase. Because each story
has already been through the full specify tier individually, the pre-sprint checks are complete
for every story in the sprint **by construction**.

**Prerequisites** — all must hold for **every story in the filling sprint**:

- The story has cleared `15-decisions` — the whole specify tier is done for it
- GDPR review complete (`src/09-GDPR/PLANNING/`)
- Security threat model and assessment complete (`src/10-SECURITY/`)
- QA plan exists with no unresolved `AC-GAP` entries (`src/11-QA/PLANNING/`)
- SEO plan exists, or the story records `SEO: N/A` with a reason (`src/12-SEO/PLANNING/`)
- API contract designed, or the story adds no Ninja surface (`src/13-API-DESIGN/PLANNING/`)
- `US###.md` has complete acceptance criteria and a story-point estimate

A story that cannot satisfy these is not ready to be counted towards the sprint — resolve it or
drop it back to the backlog rather than planning a sprint around it.

---

## Then consolidate

Planning per story means design arrives per story, and it drifts by construction. Once **every**
story is planned, `18-consolidate-design-work` reconciles the accumulated schema, flows, tokens,
components, and screens into one coherent design. Implementation starts after that, never before.

---

## Related

- [`STORIES.md`](STORIES.md) — story format, statuses, and per-story plans
- [`SPRINTS.md`](SPRINTS.md) — MoSCoW, phases, and the sprint plan format
- `project-management/workflows/CONTEXT.md` — the workflow index
