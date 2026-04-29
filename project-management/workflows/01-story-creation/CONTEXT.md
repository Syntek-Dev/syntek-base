# Workflow: User Story Creation

> **Agent hints — Model:** Sonnet

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

- `project-management/src/01-STORIES/` — where stories are saved
