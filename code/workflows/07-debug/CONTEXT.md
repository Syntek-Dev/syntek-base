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

### Hard gates — read before executing Step 1

None — debugging is reactive; no mandatory pre-reads before investigating a bug.

### Soft references — consult during execution

- `code/docs/CODE-REVIEW-GRAPH.md` — the code-review-graph **debug playbook**
  (`.claude/skills/debug-issue.md`): `semantic_search_nodes` → `query_graph` callers/callees →
  `get_flow` → `detect_changes` → `get_impact_radius`, to trace the fault structurally
- `how-to/workflows/03-debugging/` — operational debugging (logs, containers, runtime errors)
- `code/docs/testing/BACKEND-TESTING.md` — pytest test writing conventions for regression tests
- `code/docs/testing/FRONTEND-TESTING.md` — template and HTMX-partial conventions for regression tests
- `code/docs/rendering/PITFALLS-AND-EXAMPLES.md` — SSR/CSR boundary issues and Server Component constraints
- `code/docs/performance/DATABASE-PERFORMANCE.md` — N+1 queries and slow resolver investigation
- `code/docs/logging/DJANGO-LOGGING.md` — reading structured log output
- `code/workflows/10-debugging-with-logs/` — observability-based companion workflow
- `code/docs/cloudinary/CONTEXT.md` — when debugging Cloudinary SDK calls, transformation URLs, or media delivery errors; invoke `/cloudinary-docs` or `/cloudinary-transformations`
- `project-management/src/19-BUGS/` — bug report artefacts
- `project-management/workflows/19-implementation-documentation/` — **how work reaches this
  workflow**: findings recorded there with a defect disposition are routed to `src/19-BUGS/` and
  become the input for a debug pass. There is no PM-layer debug workflow — 19 is the entry point.
