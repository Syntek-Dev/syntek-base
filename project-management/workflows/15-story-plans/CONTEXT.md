# Workflow 15 — Story Plans

**Last Updated**: <%DATE%>

## Purpose

Write the per-story implementation plan — the final decide-&-plan step before code — for a
user story slotted into a sprint. This workflow produces
`src/15-STORY-PLANS/STORY-PLAN-US###-<descriptor>.md`, copied from the canonical
`STORY-PLAN-US000-TEMPLATE.md`: the single master reference a developer codes from, fixing
the technical approach, key decisions, dependencies, and risks before any code is written.

## When to run

- After `workflows/14-sprint-plans/` has slotted the story into a sprint and sequenced its
  phase
- After any ADR the story rests on has been accepted (`workflows/13-decisions/`)
- Before `workflows/16-backend-code/` — no story enters implementation without a completed
  plan
- Required for every story entering a development sprint, whichever layers it touches

## Inputs

- The story's sprint plan (`src/14-SPRINT-PLANS/##-SPRINT-PLAN-##.md`)
- Any ADRs the story rests on or that a plan review might trigger (`src/13-DECISIONS/`)
- Every relevant 01–12 spec: story (`01-STORIES`), schema (`03-DATABASE`), user flow
  (`04-USER-FLOW`), wireframes (`07-WIREFRAMES`), GDPR (`08-GDPR`), security
  (`09-SECURITY`), QA (`10-QA`), SEO (`11-SEO`), API design (`12-API-DESIGN`)
- `src/15-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` — the canonical superset template

## Outputs

- `src/15-STORY-PLANS/STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` — the completed story plan
- An updated row in `src/15-STORY-PLANS/CONTEXT.md` → Plans Index, with status and links

## Key decisions

1. Technical approach per layer (database, service, API, frontend) or per phase for a
   multi-step story
2. Key decisions table — chosen vs rejected approach, with rationale and a doc reference
3. Dependency matrix — blocked-by / blocks / can-start-now, kept honest against the DAG
4. Phased implementation tasks mapped onto the code workflow chain
   (`16-backend-code` → `17-api-code` → `18-frontend-code`)
5. Test strategy per layer, defined before any code is written
6. GDPR, security, and QA constraints carried in from the 01–12 specs, not re-derived
7. Deferred items and risks, each named against a target future story

## Quality gates

- Every state-changing endpoint the plan introduces carries an explicit permission check
  and ownership verification (OWASP A01, no IDOR)
- GDPR, security, and QA constraints from the 01–12 specs are present in the plan, traced
  back to their source spec
- A test strategy is defined per layer before the plan is treated as codeable
- The plan's dependency callout (`Blocked by` / `Blocks` / `Can be done now`) is accurate —
  the parallel-worktree DAG depends on it
- Plan reviewed by at least one adversarial pass (missing layers, wrong doc references,
  dependency-order errors) before it gates `workflows/16-backend-code/`

## Related workflows

| Workflow                              | Relationship                                                                    |
| ------------------------------------- | ------------------------------------------------------------------------------- |
| `13-decisions`                        | Upstream — ADRs this plan cites as constraints on its approach                  |
| `14-sprint-plans`                     | Upstream — sets the story's sprint, priority, and phase sequence                |
| `01-story-creation` … `12-api-design` | Upstream — every design/compliance spec this plan carries constraints from      |
| `16-backend-code`                     | Downstream — implementation begins from this plan                               |
| `17-api-code`                         | Downstream — Django Ninja layer implementation follows this plan's API approach |
| `18-frontend-code`                    | Downstream — UI implementation follows this plan's frontend approach            |
| `19-implementation-documentation`     | Downstream — closes the plan with IMPLEMENTATION-side records against it        |
| `20-pr-and-review`                    | Downstream — the plan's definition of done gates the PR                         |

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/src/15-STORY-PLANS/CLAUDE.md` — how-to-work-here rules for this
  folder: copy the template, never start from scratch, keep the dependency DAG honest
- `project-management/src/15-STORY-PLANS/STORY-PLAN-US000-TEMPLATE.md` — the canonical
  superset template every plan is copied from

### Soft references — consult during execution

- `project-management/src/14-SPRINT-PLANS/` — the sprint plan this story plan expands
- `project-management/src/13-DECISIONS/` — ADRs the plan rests on
- `project-management/src/01-STORIES/` … `src/12-API-DESIGN/` — every design/compliance
  spec the plan carries constraints from
- `code/docs/ARCHITECTURE-PATTERNS.md` — service layer and module boundaries the plan's
  technical approach must respect
- `code/docs/SECURITY.md` — permission and IDOR controls carried into the plan
- `project-management/docs/QA-GUIDE.md` — QA constraints carried into the plan's test
  strategy
- `project-management/workflows/16-backend-code/` — downstream workflow that implements
  the plan
