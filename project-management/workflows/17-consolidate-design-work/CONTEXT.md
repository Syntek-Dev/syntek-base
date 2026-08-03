# Workflow 16 — Consolidate Design Work

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/17-consolidate-design-work/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## Purpose

Turn the design and schema work that accumulated **one story at a time** into a single
coherent system. Workflows `02`–`14` run per story, so each story produces its own
tables, flows, tokens, components, and screens in the `USER-STORY-IDEAS/` folder of
`src/04-DATABASE` … `src/08-WIREFRAMES`. That is deliberate — it keeps each story
thinking end-to-end — but it guarantees drift: two stories will name the same concept
differently, invent the same button twice, or model the same entity two ways.

This workflow is the second half of that bargain. It runs **once, after every story is
planned**, reconciles the accumulated per-story work into `CONSOLIDATED-IDEAS/`, and
produces the design a developer actually builds against.

## When to use this

- Every story in the planning cycle has cleared `16-story-plans/`
- Before `18-backend-code/` — no implementation starts from unconsolidated design

## When NOT to use this

- Mid-cycle, with stories still to plan — consolidating early means doing it twice
- For a single story's design work — that belongs in its `USER-STORY-IDEAS/` pass
- To add new scope — this workflow unifies what exists; new capability is a new story

## Prerequisites

- [ ] Every story is through `16-story-plans/` with a completed `STORY-PLAN-US###-*.md`
- [ ] Each in-scope story has its `USER-STORY-IDEAS/` artefacts in `src/03`–`src/07`,
      or an explicit `N/A` with a reason
- [ ] All sprints opened during planning have their `15-sprint-plans/` plan written
- [ ] Any ADR the accumulated design rests on is `Accepted` in `src/14-DECISIONS/`

## Key concepts

- **Two stages, one design.** Stage 1 is per story and provisional; stage 2 is this
  workflow. Neither is optional — stage 1 without stage 2 ships five stories' worth of
  near-duplicate components.
- **Stage 1 is frozen, not deleted.** `USER-STORY-IDEAS/` files stay exactly as written
  once consolidation runs. They record what each story asked for and why, which is the
  evidence trail when a consolidated decision is later questioned.
- **Collisions are the output.** The value here is finding that `US004` and `US011` both
  designed a status badge, or that three stories each added a `created_by` column with a
  different delete behaviour. Finding none is a signal the pass was shallow, not that the
  design was clean.
- **Consolidation can invalidate a story plan.** If unifying changes a shape a
  `STORY-PLAN-US###-*.md` assumed, that plan is corrected here — before code, not after.
- **Hard-to-reverse resolutions become ADRs.** A consolidation choice that a later
  decision would need to explicitly supersede goes to `14-decisions/` as a new record.
- **Schema consolidation is the expensive one.** Visual drift is cheap to fix after the
  fact; a fragmented schema is not (`code/docs/DATABASE.md`). Do `04-DATABASE` first.

## Scope — the five folders

| Folder            | Stage 1 produces                       | Consolidation resolves                        |
| ----------------- | -------------------------------------- | --------------------------------------------- |
| `04-DATABASE/`    | Per-story tables, columns, constraints | One schema: shared entities, consistent FKs   |
| `05-USER-FLOW/`   | Per-story journeys                     | Whole journeys, with per-story flows as stubs |
| `06-BRAND-GUIDE/` | Per-story token needs                  | One token set; the generator re-run           |
| `07-COMPONENTS/`  | Per-story component needs              | One component set; duplicates merged          |
| `08-WIREFRAMES/`  | Per-story screens                      | One screen set on the consolidated components |

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/DATABASE.md` — the data-layer rules a consolidated schema must satisfy:
  database-level constraints, scope columns, lock-safe migration shape
- `code/docs/DESIGN-TOKENS.md` — token-first: consolidated values are DB-canonical and
  enter via the editor or a migration, never as literals

### Soft references — consult during execution

- `project-management/src/16-STORY-PLANS/` — the plans this workflow may have to correct
- `project-management/src/14-DECISIONS/` — where a hard-to-reverse resolution lands
- `project-management/docs/PLANNING-GUIDE.md` — the per-story cadence this closes
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA on the consolidated component set
- `project-management/workflows/18-backend-code/` — the downstream phase this unblocks
