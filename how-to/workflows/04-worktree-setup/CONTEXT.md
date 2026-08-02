# Workflow: Worktree Setup

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/workflows/04-worktree-setup/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when you need to work on two or more user stories in parallel — each story
gets its own git worktree, its own Docker stack, and its own local URL, so they never
interfere with each other.

## When NOT to use this

- You are working on a single story — use the standard `how-to/workflows/02-daily-development/`
  workflow instead.
- The story does not require running the full dev stack locally.

## Prerequisites

- [ ] First-time setup has been completed (`how-to/workflows/01-first-time-setup/`)
- [ ] You are on the `testing` branch and it is up to date
- [ ] The Docker override files for your story numbers exist in
      `code/src/docker/docker-compose.us###.dev.yml` and `docker-compose.us###.test.yml`
- [ ] If you have run this workflow before, the one-time `/etc/hosts` entries for your
      worktree hostnames already exist — otherwise Step 4 adds them on the first run
      (see `how-to/docs/GIT-WORKTREES.md` for the full list)

## Key concepts

- A git worktree is a separate checkout of the same repository in a sibling directory
- Each worktree checks out a different branch, so you can have two feature branches open
  simultaneously without stashing or switching
- `server.sh` auto-detects the active worktree branch and applies the correct Docker override
- Container names and Docker volumes are namespaced per-worktree — stacks never share data

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/docs/GIT-GUIDE.md` — branch naming must be correct before creating a worktree

### Soft references — consult during execution

- `how-to/docs/GIT-WORKTREES.md` — full naming convention, `/etc/hosts` setup, remove workflow
