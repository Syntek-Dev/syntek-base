# Workflow: Debugging

> **Agent hints — Model:** Sonnet

## Directory Tree

```text
how-to/workflows/03-debugging/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when:

- A test is failing unexpectedly
- A runtime error appears in the container logs
- A GraphQL query or mutation returns an unexpected result
- The frontend fails to render or throws a console error

## Prerequisites

- [ ] Containers are running and you can access logs

## Key concepts

- Check container logs first — most errors are visible there
- Use Django shell for quick backend data inspection
- Use the GraphQL Playground for isolated query testing
- Browser DevTools (Network tab) for frontend GraphQL request inspection

## Cross-references

- `how-to/docs/DEVELOPMENT.md` — log commands and troubleshooting tips
