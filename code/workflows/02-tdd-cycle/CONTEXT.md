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
- [ ] Test framework running (`pytest` for backend, `vitest` for frontend, `jest` for mobile)
- [ ] `./code/src/scripts/syntax/check.sh` passes (type-check + lint) before writing any tests
- [ ] No stubs — green means real implementation passing

## Key concepts

- **Red:** Write tests that describe the desired behaviour at the contract level — return values,
  database state, API responses. Tests must fail. Use realistic data (real-looking names, valid
  email addresses, plausible amounts). Structure tests with factories and parametrize from the
  start so the suite scales without sprawl.
- **Green:** Write the minimum implementation to make tests pass. During this phase, amend or
  add tests when real edge cases are discovered through building the feature. User-observable edge
  cases (account suspended, session expired) get a BDD scenario. Internal edge cases (transaction
  rollback, retry logic) get a unit or integration test. Never add a test solely to raise a
  coverage number.
- **Refactor:** Improve code quality without changing behaviour. Because initial tests assert on
  outcomes (not internals), the Refactor phase should require zero test changes unless the public
  contract itself changes.

Coverage floors:

- Backend: 75% minimum; 90% for auth-related code
- Frontend / Mobile: 70% minimum

## Cross-references

- `code/docs/TESTING.md` — full TDD rules, pytest/vitest/jest setup, Bruno API tests, output
  configuration, and coverage thresholds
