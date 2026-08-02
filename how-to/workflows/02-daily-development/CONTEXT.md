# Workflow: Daily Development

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/workflows/02-daily-development/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this at the start of each development session to set up your working context.

## Prerequisites

- [ ] First-time setup has been completed
- [ ] You know which user story you are working on today

## Key concepts

- Always pull latest from `testing` before starting a new user story branch
- Create a branch with the format `us###/short-description`
- Containers must be running before any development work

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/GIT-GUIDE.md` — branch naming convention must be correct before the first commit

### Soft references — consult during execution

- `how-to/docs/DEVELOPMENT.md` — full command reference
- `how-to/docs/CLI-TOOLING.md` — daily CLI commands
- `how-to/docs/TOOLING-GUIDE.md` — project-specific scripts
