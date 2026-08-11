# Workflow: Worktree Setup

Two stories in one checkout means one Docker stack, one database and one set of ports. A
worktree per story is what makes parallel work possible without the two contaminating each
other.

**Last Updated**: <%DATE%>

## Directory Tree

```text
how-to/workflows/02-worktree-setup/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, key concepts, governing documents)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when you need to work on two or more user stories in parallel — each story
gets its own git worktree, its own Docker stack, and its own local URL, so they never
interfere with each other.

## When NOT to use this

- You are working on a single story — use the standard `how-to/workflows/03-daily-development/`
  workflow instead.
- The story does not require running the full dev stack locally.

## Key concepts

- A git worktree is a separate checkout of the same repository in a sibling directory
- Each worktree checks out a different branch, so you can have two feature branches open
  simultaneously without stashing or switching
- `server.sh` auto-detects the active worktree branch and applies the correct Docker override
- Container names and Docker volumes are namespaced per-worktree — stacks never share data

## Cross-references

### Governing documents

- `project-management/docs/GIT-GUIDE.md` — branch naming must be correct before creating a worktree

### Related reading

- `how-to/docs/GIT-WORKTREES.md` — full naming convention, `/etc/hosts` setup, remove workflow
