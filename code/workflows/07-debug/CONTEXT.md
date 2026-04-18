# Workflow: Debug

## Directory Tree

```text
code/workflows/07-debug/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when a bug has been identified in code logic — incorrect behaviour,
wrong output, or unexpected state. This workflow focuses on isolating the fault in
code, writing a regression test, and implementing the minimal fix.

For operational debugging (container not starting, runtime errors in logs, broken
builds, network issues) use `how-to/workflows/03-debugging/`. Both workflows are
designed to be used together — start with the operational workflow to confirm the
environment is healthy, then use this workflow to fix the logic.

## Prerequisites

- [ ] Containers are running
- [ ] The bug is reproducible — you have steps to trigger it consistently

## Key concepts

- Write a failing test _before_ writing the fix — this pins the bug and becomes the regression test
- Bisect to the smallest failing case before investigating the root cause
- The fix should be minimal — do not refactor surrounding code in the same commit
- If the fix reveals a design problem, open a separate refactoring task

## Cross-references

- `how-to/workflows/03-debugging/` — operational debugging (logs, containers, runtime errors)
- `code/docs/TESTING.md` — test writing conventions and coverage requirements
- `project-management/src/BUGS/` — bug report artefacts
