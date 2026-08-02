# Workflow: User Story Creation

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/01-story-creation/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when you need to create a new user story before development begins.
Every feature must have a corresponding user story.

## Prerequisites

- [ ] Feature requirements are understood
- [ ] You know the user role, goal, and acceptance criteria

## Key concepts

- User stories follow the format: `US###.md` (3-digit zero-padded, e.g. `US001.md`)
- Every story must have clear acceptance criteria
- Acceptance criteria drive the test cases in `code/workflows/02-tdd-cycle/`

## Cross-references

### Hard gates — read before executing Step 1

None — story creation is pre-code; no safety gates apply.

### Soft references — consult during execution

- `project-management/src/01-STORIES/` — where stories are saved
- `project-management/docs/SPRINT-PLANNING-GUIDE.md` — MoSCoW prioritisation and story format requirements
- `project-management/docs/QA-GUIDE.md` — QA scenario format that acceptance criteria must support
- `project-management/docs/SECURITY-GUIDE.md` — security and STRIDE requirements that stories must capture
- `project-management/docs/GDPR-GUIDE.md` — GDPR data requirements to surface in story acceptance criteria
- `project-management/docs/SEO-CHECKLIST.md` — stories with public-facing pages need SEO acceptance criteria
- `project-management/workflows/04-user-flow-design/` — next workflow if story drives new user journeys
