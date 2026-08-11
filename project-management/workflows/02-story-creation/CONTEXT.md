# Workflow: User Story Creation

**Last Updated**: <%DATE%>

A story is the unit everything downstream is traced to — schema, flow, QA, SEO, the plan, the
branch. Written vaguely it stays vague through all of them.

## Directory Tree

```text
project-management/workflows/02-story-creation/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when you need to create a new user story before development begins.
Every feature must have a corresponding user story.

## Key concepts

- User stories follow the format: `US###.md` (3-digit zero-padded, e.g. `US001.md`)
- Every story must have clear acceptance criteria
- Acceptance criteria drive the test cases in `code/workflows/02-tdd-cycle/`

## Cross-references

### Governing documents

None — story creation is pre-code; no safety gates apply.

### Related reading

- `project-management/src/02-STORIES/` — where stories are saved
- `project-management/docs/PLANNING-GUIDE.md` — MoSCoW prioritisation and story format requirements
- `project-management/docs/QA-GUIDE.md` — QA scenario format that acceptance criteria must support
- `project-management/docs/SECURITY-GUIDE.md` — security and STRIDE requirements that stories must capture
- `project-management/docs/GDPR-GUIDE.md` — GDPR data requirements to surface in story acceptance criteria
- `project-management/docs/SEO-CHECKLIST.md` — stories with public-facing pages need SEO acceptance criteria
- `project-management/workflows/05-user-flow-design/` — next workflow if story drives new user journeys
