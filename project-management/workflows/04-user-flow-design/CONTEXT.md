# Workflow: User Flow Design

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/04-user-flow-design/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when mapping out how users move through the product for a given feature
area. Run it after story creation and before brand guides or wireframes.

## Prerequisites

- [ ] User stories covering the area exist in `project-management/src/01-STORIES/`
- [ ] Acceptance criteria are understood for all in-scope stories
- [ ] The product area (auth, client portal, public, admin, etc.) is identified

## Key concepts

- User flows document screens, decisions, and transitions — not visual design
- One file per product area: `USER-FLOW-<AREA>.md`
- Flows are the source of truth for wireframe scope and GDPR data-touch mapping
- Every decision node must have an outcome for both success and failure paths

## Cross-references

### Hard gates — read before executing Step 1

None — user flow design is a pre-code design phase; no safety gates apply.

### Soft references — consult during execution

- `project-management/src/04-USER-FLOW/` — where user flow documents are saved
- `project-management/src/01-STORIES/` — stories the flows are derived from
- `project-management/src/08-GDPR/` — GDPR data-touch artefacts traced from flows
- `project-management/src/09-SECURITY/` — existing threat findings inform flow decisions
- `project-management/docs/GDPR-GUIDE.md` — data flows must map to lawful basis and retention rules
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE threat modelling is applied to flows in workflow 09
- `code/docs/RESPONSIVE-DESIGN.md` — device and orientation data; flows must account for mobile and desktop paths
- `code/docs/URL-STRATEGY.md` — URL and route structure that flows must follow
- `project-management/workflows/06-component-designs/` — component design follows from agreed flows
- `project-management/workflows/07-wireframes/` — follow this after flows are agreed
