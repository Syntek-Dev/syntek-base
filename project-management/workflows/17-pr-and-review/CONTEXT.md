# Workflow: PR and Code Review

> **Agent hints — Model:** Opus · **MCP:** `code-review-graph`

## Directory Tree

```text
project-management/workflows/17-pr-and-review/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when a feature branch is complete and ready to be reviewed
and merged through the branch promotion chain.

## Prerequisites

- [ ] All tests pass on the feature branch
- [ ] Linters are clean
- [ ] A QA pass has been run

## Cross-references

- `project-management/docs/GIT-GUIDE.md` — branch strategy and PR gates
