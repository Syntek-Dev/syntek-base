# Workflow: User Flow Design

**Last Updated**: <%DATE%>

A flow shows the seams a story does not own — the transitions where one slice hands to
another. Those are where products break, and they are invisible from inside a single story.

## Directory Tree

```text
project-management/workflows/05-user-flow-design/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when mapping out how users move through the product for a given feature
area. Run it after story creation and before brand guides or wireframes.

## Key concepts

- User flows document screens, decisions, and transitions — not visual design
- One file per product area: `USER-FLOW-<AREA>.md`
- Flows are the source of truth for wireframe scope and GDPR data-touch mapping
- Every decision node must have an outcome for both success and failure paths

## Cross-references

### Governing documents

None — user flow design is a pre-code design phase; no safety gates apply.

### Related reading

- `project-management/src/05-USER-FLOW/` — where user flow documents are saved
- `project-management/src/02-STORIES/` — stories the flows are derived from
- `project-management/src/09-GDPR/` — GDPR data-touch artefacts traced from flows
- `project-management/src/10-SECURITY/` — existing threat findings inform flow decisions
- `project-management/docs/GDPR-GUIDE.md` — data flows must map to lawful basis and retention rules
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE threat modelling is applied to flows in workflow 09
- `code/docs/RESPONSIVE-DESIGN.md` — device and orientation data; flows must account for mobile and desktop paths
- `code/docs/URL-STRATEGY.md` — URL and route structure that flows must follow
- `project-management/workflows/07-component-designs/` — component design follows from agreed flows
- `project-management/workflows/08-wireframes/` — follow this after flows are agreed
