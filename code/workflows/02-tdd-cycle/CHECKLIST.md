# TDD Cycle — Checklist

**Last Updated**: 30/04/2026 **Version**: 1.2.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Pre-Conditions

- [ ] Acceptance criteria are clear and agreed
- [ ] `./code/src/scripts/syntax/check.sh` passes (basedpyright + tsc + lint) before writing any tests
- [ ] Test runners available: pytest (backend), vitest (frontend), jest (mobile)

---

## Execution Checklist

### Phase 0 — Compile & Type-Check

- [ ] `./code/src/scripts/syntax/check.sh` ran and passed with zero errors

### Phase 1 — Red

- [ ] Tests written before any implementation
- [ ] Tests assert on outcomes (return values, DB state, API responses) — not on internals
- [ ] Test data is realistic: factories with Faker, not `"test@test.com"` or `id=999`
- [ ] Tests use factories (not inline model instances)
- [ ] Tests use `@pytest.mark.parametrize` for the same behaviour across different inputs
- [ ] Every test is marked with the correct tier: `unit`, `integration`, or `e2e`
- [ ] Unit tests written for every new function or class
- [ ] Integration tests written for any DB, queue, or external-service interaction
- [ ] Bruno `.bru` file created for every new GraphQL mutation or query
- [ ] BDD scenario written for every acceptance criterion in the user story
- [ ] All new tests confirmed red before proceeding

### Phase 2 — Green

- [ ] Minimum implementation written — no extras
- [ ] All unit and integration tests green
- [ ] All Bruno API tests green (correct HTTP status, response shape, auth behaviour)
- [ ] `./code/src/scripts/syntax/check.sh` passes after implementation
- [ ] User-observable edge cases discovered during implementation → BDD scenario added
- [ ] Internal edge cases discovered during implementation → unit/integration test added
- [ ] No test was added solely to raise a coverage number

### Phase 3 — Refactor

- [ ] Code structure improved — no logic changes, no new behaviour
- [ ] Zero test changes required (initial tests were at the contract level, not the implementation level)
- [ ] All tests (unit, integration, API, BDD) still green after refactor
- [ ] Coverage floors still met: backend ≥ 75% (auth ≥ 90%), frontend/mobile ≥ 70%

---

## Definition of Done

- [ ] All tests pass with real implementation — no stubs, no `NotImplementedError`
- [ ] `./code/src/scripts/syntax/check.sh` passes
- [ ] Coverage floors met
- [ ] Bruno `.bru` file exists for every new mutation/query, asserting happy path, auth failure,
      and at least one error case
- [ ] BDD scenarios cover all acceptance criteria and any user-observable edge cases found
      during implementation
- [ ] Test names read as sentences; failures state expected vs actual
- [ ] Committed and pushed
