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

It has two halves. **Steps 1–6 give a running stack** and are what a teammate joining an
established project runs. **Steps 7–8 run once per project, before the first feature is
charted**: sharpen the project description, then plan scale and architecture. Skip them on an
onboarding; do not skip them on a new project.

## Prerequisites

- [ ] Docker and Docker Compose installed
- [ ] Git configured with your SSH key
- [ ] Access to the repository
- [ ] GitHub CLI (`gh`) installed and authenticated (`gh auth login`) — required for the PR workflow

## Key concepts

- The project runs entirely inside Docker — no local Python or Node installations needed
- Environment files are not committed — copy from `.env.*.example` files
- The backend container runs Django on port 8000; frontend on port 3000
- **The description comes before the plan, and the plan comes before the feature.** The brief in
  `CONTEXT.md` says what is being built and for whom; `/scale-planning` says at what size and
  therefore what is _not_ required. Both are cheap now and expensive after ten features have
  been built on assumptions nobody wrote down.

## Cross-references

### Hard gates — read before executing Step 1

None — setup is sequential; follow STEPS.md in order.

### Soft references — consult during execution

- `how-to/docs/DEVELOPMENT.md` — full command reference
- `how-to/docs/CLI-TOOLING.md` — CLI tools needed during setup
- `project-management/docs/GIT-GUIDE.md` — git config and SSH key setup
- `CONTEXT.md` → _What this project is_ — the brief Step 7 sharpens
- `.claude/skills/scale-planning/SKILL.md` — the Step 8 procedure
- `how-to/src/SCALE-ARCHITECTURE/` · `how-to/src/SERVER-ARCHITECTURE/` — the two snapshots Step 8 fills
- `project-management/workflows/01-feature/` — what runs next, once 7 and 8 are done
