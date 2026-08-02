# Workflow: First-Time Setup

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/workflows/01-first-time-setup/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow the first time you set up this project on a new machine,
or when onboarding a new team member.

## Prerequisites

- [ ] Docker and Docker Compose installed
- [ ] Git configured with your SSH key
- [ ] Access to the repository
- [ ] GitHub CLI (`gh`) installed and authenticated (`gh auth login`) — required for the PR workflow

## Key concepts

- The project runs entirely inside Docker — no local Python or Node installations needed
- Environment files are not committed — copy from `.env.*.example` files
- The backend container runs Django on port 8000; frontend on port 3000

## Cross-references

### Hard gates — read before executing Step 1

None — setup is sequential; follow STEPS.md in order.

### Soft references — consult during execution

- `how-to/docs/DEVELOPMENT.md` — full command reference
- `how-to/docs/CLI-TOOLING.md` — CLI tools needed during setup
- `project-management/docs/GIT-GUIDE.md` — git config and SSH key setup
