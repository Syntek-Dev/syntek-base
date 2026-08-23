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

Write the per-story implementation plan — the final decide-&-plan step before code — for a
user story slotted into a sprint. This workflow produces
`src/17-STORY-PLANS/STORY-PLAN-US###-<descriptor>.md`, copied from the canonical
`STORY-PLAN-US000-TEMPLATE.md`: the single master reference a developer codes from, fixing
the technical approach, key decisions, dependencies, and risks before any code is written.

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
- `src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` — the canonical superset template

## Outputs

- `src/17-STORY-PLANS/STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` — the completed story plan
- An updated row in `src/17-STORY-PLANS/CONTEXT.md` → Plans Index, with status and links

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
- `project-management/src/17-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` — the canonical
  superset template every plan is copied from

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
