# Workflow: Worktree Setup

Two stories in one checkout means one Docker stack, one database and one set of ports. When
stories run in parallel, a worktree for each is what keeps them from contaminating each other.
A story running alone needs none — it runs in the main checkout on its branch.

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

This workflow is entered **only** when two or more user stories run in parallel — each story
then gets its own git worktree, its own Docker stack, and its own local URL, so they never
interfere with each other. The rule that decides it is `how-to/docs/GIT-WORKTREES.md`'s.

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
