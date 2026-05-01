# Workflow: Release

> **Agent hints — Model:** Sonnet

## Directory Tree

```text
project-management/workflows/18-release/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when cutting a release — version bump, changelog update, and deployment.

## Prerequisites

- [ ] Staging branch is green and accepted
- [ ] All stories for this release are marked complete
- [ ] Changelog entries are up to date

## Cross-references

- `project-management/docs/VERSIONING-GUIDE.md` — version bump rules and file checklist
