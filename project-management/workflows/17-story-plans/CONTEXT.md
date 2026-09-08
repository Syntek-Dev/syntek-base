# Workflow 16 — Story Plans

**Last Updated**: <%DATE%>

This is the last thinking step before code. If the plan is right, implementation is mechanical;
if it is thin, every gap it left gets decided at the keyboard by whoever hits it first.

## Directory Tree

```text
project-management/workflows/17-story-plans/
├── CHECKLIST.md   ← verification checklist before marking complete
├── CLAUDE.md      ← operating rules
├── CONTEXT.md     ← this file (when to use, key concepts, governing documents)
└── STEPS.md       ← ordered steps to execute
```

## Purpose

<!-- 08/09/2026: the produced artefact gained an `<exec-order>-` prefix. Superseded text,
     preserved rather than deleted — this section named
     `src/17-STORY-PLANS/STORY-PLAN-US###-<descriptor>.md`, copied from
     "STORY-PLAN-US000-TEMPLATE.md"; Inputs and Outputs named
     "src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md" and
     `src/17-STORY-PLANS/STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`; Governing documents
     named "project-management/src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md". -->

<!-- 08/09/2026, later the same day: the three "Plans Index" mentions were rewritten to
     describe what exists. Superseded text, preserved rather than deleted — _Why the filename
     carries a number_ read "A number can be **reserved** in the Plans Index before its plan is
     written" (added earlier today); Inputs listed "`src/17-STORY-PLANS/CONTEXT.md` → Plans
     Index — the settled build order the new plan's `<exec-order>` prefix is counted against"
     (added earlier today); Outputs listed "An updated row in `src/17-STORY-PLANS/CONTEXT.md` →
     Plans Index, with status and links, the index kept in `<exec-order>` sequence" (the row
     pre-dates today; the sequence clause was added today). Why: no Plans Index exists, and
     `src/17-STORY-PLANS/CONTEXT.md` → _The plans index_ records its absence as a decision —
     that file ships, so an index row would put a per-project citation in it. Build order is
     read off the sprint plans in `src/16-SPRINT-PLANS/`, a plan is indexed against its sprint
     in that plan's _Story Plans — the code master_ table, and a reserved number is recorded in
     the owning story. The folder-level index is deferred to the register-index work charted in
     `src/01-FEATURE-MAPS/`; no file is named for it because none exists yet. -->

Write the per-story implementation plan — the final decide-&-plan step before code — for a
user story slotted into a sprint. This workflow produces
`src/17-STORY-PLANS/<exec-order>-STORY-PLAN-US###-<descriptor>.md`, copied from the canonical
`00-STORY-PLAN-US000-TEMPLATE.md`: the single master reference a developer codes from, fixing
the technical approach, key decisions, dependencies, and risks before any code is written.

## Why the filename carries a number

The prefix is the story's **position in the settled build order across the whole backlog** —
2-digit zero-padded, read off the sprint plans in their own `<exec-order>` sequence and then
the story order inside each. It is not the sprint number and not a per-sprint counter, and
`00-` belongs to the template, mirroring `00-SPRINT-PLAN-00-TEMPLATE.md`. A number can be
**reserved** before its plan is written — recorded in the story that owns it and, where a
sprint plan already carries that story, as a no-file row in that plan's
_Story Plans — the code master_ table; `src/17-STORY-PLANS/` holds no index of its own, and its
`CONTEXT.md` → _The plans index_ records that as a decision. How to derive the number, and the
rule that it is renumbered whenever build order moves: `STEPS.md` Step 2.

**It is the reverse of the rule next door, and the difference is the count of numbers.** A
sprint plan carries two — `<exec-order>` and `<sprint-number>` — and
`project-management/src/16-SPRINT-PLANS/CLAUDE.md` holds that a mismatch between them is deliberate
information and must never be "corrected". A story plan carries one, so there is no pair to
disagree with: its prefix either tracks build order or means nothing.

## When to run

- After `workflows/16-sprint-plans/` has slotted the story into a sprint and sequenced its
  phase
- After any ADR the story rests on has been accepted (`workflows/15-decisions/`)
- Before `workflows/19-backend-code/` — no story enters implementation without a completed
  plan
- Required for every story entering a development sprint, whichever layers it touches

## Inputs

- The story's sprint plan (`src/16-SPRINT-PLANS/##-SPRINT-PLAN-##.md`)
- Any ADRs the story rests on or that a plan review might trigger (`src/15-DECISIONS/`)
- Every relevant 02–14 spec: story (`02-STORIES`), schema (`04-DATABASE`), logging (`14-LOGGING`), user flow
  (`05-USER-FLOW`), wireframes (`08-WIREFRAMES`), GDPR (`09-GDPR`), security
  (`10-SECURITY`), QA (`11-QA`), SEO (`12-SEO`), API design (`13-API-DESIGN`)
- `src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` — the canonical superset template
- The sprint plans in `src/16-SPRINT-PLANS/`, in their own `<exec-order>` sequence — the
  settled build order the new plan's `<exec-order>` prefix is counted against — and each one's
  _Story Plans — the code master_ table, where a plan is indexed against its sprint
- `src/17-STORY-PLANS/CONTEXT.md` → _The plans index_ — why the folder holds no index, and
  where a reserved number is recorded instead

## Outputs

- `src/17-STORY-PLANS/<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` — the
  completed story plan
- The story's row in its sprint plan's _Story Plans — the code master_ table
  (`src/16-SPRINT-PLANS/##-SPRINT-PLAN-##.md`) pointed at the new file, any reserved-number
  placeholder replaced. `src/17-STORY-PLANS/CONTEXT.md` gains no row: it holds no index by
  recorded decision (its _The plans index_ section), the folder-level index being deferred to
  the register-index work charted in `src/01-FEATURE-MAPS/`

## Key decisions

1. Technical approach per layer (database, service, API, frontend) or per phase for a
   multi-step story
2. Key decisions table — chosen vs rejected approach, with rationale and a doc reference
3. Dependency matrix — blocked-by / blocks / can-start-now, kept honest against the DAG
4. Phased implementation tasks mapped onto the code workflow chain
   (`19-backend-code` → `20-api-code` → `21-frontend-code`)
5. Test strategy per layer, defined before any code is written
6. GDPR, security, and QA constraints carried in from the 02–14 specs, not re-derived
7. Deferred items and risks, each named against a target future story

## Related workflows

| Workflow                              | Relationship                                                                    |
| ------------------------------------- | ------------------------------------------------------------------------------- |
| `15-decisions`                        | Upstream — ADRs this plan cites as constraints on its approach                  |
| `16-sprint-plans`                     | Upstream — sets the story's sprint, priority, and phase sequence                |
| `02-story-creation` … `13-api-design` | Upstream — every design/compliance spec this plan carries constraints from      |
| `19-backend-code`                     | Downstream — implementation begins from this plan                               |
| `20-api-code`                         | Downstream — Django Ninja layer implementation follows this plan's API approach |
| `21-frontend-code`                    | Downstream — UI implementation follows this plan's frontend approach            |
| `22-implementation-documentation`     | Downstream — closes the plan with IMPLEMENTATION-side records against it        |
| `23-pr-and-review`                    | Downstream — the plan's definition of done gates the PR                         |

## Cross-references

### Governing documents

- `project-management/src/17-STORY-PLANS/CLAUDE.md` — how-to-work-here rules for this
  folder: copy the template, never start from scratch, keep the dependency DAG honest
- `project-management/src/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md` — the canonical
  superset template every plan is copied from
- `project-management/src/16-SPRINT-PLANS/CLAUDE.md` — the sibling `<exec-order>` rule this
  folder deliberately inverts; read both before renumbering either

### Related reading

- `project-management/src/16-SPRINT-PLANS/` — the sprint plan this story plan expands
- `project-management/src/15-DECISIONS/` — ADRs the plan rests on
- `project-management/src/02-STORIES/` … `src/13-API-DESIGN/` — every design/compliance
  spec the plan carries constraints from
- `code/docs/ARCHITECTURE-PATTERNS.md` — service layer and module boundaries the plan's
  technical approach must respect
- `code/docs/SECURITY.md` — permission and IDOR controls carried into the plan
- `project-management/docs/QA-GUIDE.md` — QA constraints carried into the plan's test
  strategy
- `project-management/workflows/19-backend-code/` — downstream workflow that implements
  the plan
