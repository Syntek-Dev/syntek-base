# Workflow: TDD Cycle

> **Agent hints — Model:** Sonnet · **MCP:** `code-review-graph`, `docfork` + `context7` (pytest, Vitest)

## Directory Tree

```text
code/workflows/02-tdd-cycle/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow for any implementation work using test-driven development.
Always follows the Red → Green → Refactor pattern.

## Prerequisites

- [ ] Clear acceptance criteria from the user story
- [ ] Test framework running (`pytest` for backend, `vitest` for frontend)
- [ ] No stubs — green means real implementation passing

## Key concepts

- **Red:** Write tests that describe the desired behaviour. All tests must fail.
- **Green:** Write the minimum implementation to make tests pass. No extras.
- **Refactor:** Improve code quality without changing behaviour. Tests remain green.

Coverage floors:

- Backend: 75% minimum; 90% for auth-related code
- Frontend: 70% minimum

## Cross-references

- `code/docs/TESTING.md` — full TDD rules and pytest/vitest setup
