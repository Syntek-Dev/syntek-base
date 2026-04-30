# TDD Cycle — Steps

**Last Updated**: 30/04/2026 **Version**: 1.1.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Phase 0 — Compile & Type-Check

Before writing a single test, confirm the codebase compiles cleanly. A failing type-check means
the baseline is already broken — tests written on top of it give false results.

```bash
./code/src/scripts/syntax/check.sh
```

This runs basedpyright (backend) and `tsc --noEmit` (frontend/mobile) plus lint. Fix all errors
before proceeding. Do not suppress type errors to unblock this step.

---

## Phase 1 — Red (Write Failing Tests)

```text
/syntek-dev-suite:test-writer [scope of work] --mode failing-first
```

Write tests that describe the desired behaviour before writing any implementation. Tests must
assert on **outcomes** — return values, database state, API responses — not on internal methods
or implementation details. Use realistic data from the start (factories with `Faker`, not
hardcoded `"test@test.com"`). Structure with parametrize and markers so the suite is selectively
runnable as it grows.

Cover all four tiers relevant to the scope:

| Tier        | When required                                                  | Script                                               |
| ----------- | -------------------------------------------------------------- | ---------------------------------------------------- |
| Unit        | Every new function or class                                    | `./code/src/scripts/tests/backend.sh -m unit`        |
| Integration | Any code that touches the database, queue, or external service | `./code/src/scripts/tests/backend.sh -m integration` |
| API (Bruno) | Every new GraphQL mutation or query                            | `./code/src/scripts/tests/api.sh`                    |
| E2E / BDD   | Acceptance criteria from the user story (explicit only)        | `./code/src/scripts/tests/e2e.sh`                    |

Verify tests are red:

```bash
# Backend
./code/src/scripts/tests/backend.sh -v

# Frontend
./code/src/scripts/tests/frontend.sh

# Mobile
./code/src/scripts/tests/mobile.sh
```

Do not proceed to Phase 2 until all new tests are red. A test that is green before any
implementation exists is either testing the wrong thing or testing nothing.

---

## Phase 2 — Green (Minimal Implementation)

```text
/syntek-dev-suite:backend [scope]   # for backend
/syntek-dev-suite:frontend [scope]  # for frontend
```

Write the **minimum** code to make all tests pass. No gold-plating, no speculative abstractions.

During this phase, amend or add tests when real edge cases are discovered through building the
feature. Route each new test to the right tier:

- **User-observable edge case** (account suspended, session expired, form rejected with a
  specific visible message) → add a BDD scenario to the relevant `.feature` file
- **Internal edge case** (transaction rollback, retry logic, N+1 protection) → add a unit or
  integration test
- Never add a test solely to raise a coverage number

Run tests again — all must be green:

```bash
# Backend — all markers
./code/src/scripts/tests/backend.sh

# Frontend
./code/src/scripts/tests/frontend.sh

# Mobile
./code/src/scripts/tests/mobile.sh

# API (Bruno) — verify HTTP behaviour once implementation is in place
./code/src/scripts/tests/api.sh
```

Re-run the type-check to confirm the implementation hasn't introduced type errors:

```bash
./code/src/scripts/syntax/check.sh
```

Do not proceed to Phase 3 if any test is red or if the type-check fails.

---

## Phase 3 — Refactor

```text
/syntek-dev-suite:refactor [scope]
```

Improve readability and structure. No new behaviour. All tests — including Bruno API tests — must
remain green after every refactor step.

```bash
# Run the full suite to confirm nothing regressed
./code/src/scripts/tests/backend.sh
./code/src/scripts/tests/frontend.sh
./code/src/scripts/tests/mobile.sh
./code/src/scripts/tests/api.sh
```

Check coverage floors are still met:

```bash
./code/src/scripts/tests/backend-coverage.sh
./code/src/scripts/tests/frontend-coverage.sh
```

---

## Phase 4 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
