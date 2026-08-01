# Workflow: TDD Cycle

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
- [ ] Test framework running (`pytest` — one runner for every layer)
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

Coverage floors — **one floor, not one per layer**: template, component, and HTMX-partial
tests are pytest tests and count towards the same floor.

- 75% line and branch minimum; 90% for auth-related code

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/testing/COVERAGE.md` — coverage floors (75% line and branch / 90% auth) block PR — one floor, not one per layer; output configuration

### Soft references — consult during execution

- `code/docs/testing/BACKEND-TESTING.md` — pytest setup, Django test patterns, fixture conventions
- `code/docs/testing/FRONTEND-TESTING.md` — template, component, and HTMX-partial tests; markup-level accessibility
- `code/docs/TESTING.md` — full TDD taxonomy, test matrix, and running tests
- `code/docs/testing/API-TESTING.md` — when story includes API layer
- `code/docs/coding-principles/PRACTICAL-RULES.md` — shapes what unit vs integration testing means
