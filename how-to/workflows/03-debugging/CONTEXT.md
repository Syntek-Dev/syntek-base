# Workflow: Debugging

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/workflows/03-debugging/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when:

- A test is failing unexpectedly
- A runtime error appears in the container logs
- A Django Ninja endpoint returns an unexpected result
- The frontend fails to render or throws a console error

## Prerequisites

- [ ] Containers are running and you can access logs

## Key concepts

- Check container logs first — most errors are visible there
- Use Django shell for quick backend data inspection
- Use the Django Ninja `/api/docs` OpenAPI UI for isolated endpoint testing
- Browser DevTools (Network tab) for HTMX request and swapped-fragment inspection

## Cross-references

### Hard gates — read before executing Step 1

None — operational debugging is reactive; start with container logs.

### Soft references — consult during execution

- `how-to/docs/DEVELOPMENT.md` — log commands and troubleshooting tips
- `how-to/docs/CLI-TOOLING.md` — log commands and container inspection
- `code/workflows/07-debug/` — code-logic debugging (after environment confirmed healthy)
- `code/workflows/10-debugging-with-logs/` — observability tools for staging/prod issues
