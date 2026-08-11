# Workflow: Daily Development

A session that starts from a stale branch or a stopped stack loses its first hour to something
unrelated to the work. This is the short routine that prevents it.

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/workflows/03-daily-development/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this at the start of each development session to set up your working context.

## Key concepts

- Always pull latest from `testing` before starting a new user story branch
- Create a branch with the format `us###/short-description`
- Containers must be running before any development work

## Cross-references

### Governing documents

- `project-management/docs/GIT-GUIDE.md` — branch naming convention must be correct before the first commit

### Related reading

- `how-to/docs/DEVELOPMENT.md` — full command reference
- `how-to/docs/CLI-TOOLING.md` — daily CLI commands
- `how-to/docs/TOOLING-GUIDE.md` — project-specific scripts
