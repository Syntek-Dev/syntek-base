---
workflow: 02-tdd-cycle
phase: build
agent: test-writer
skills: [stack-django, stack-htmx-templates]
model: opus
---

# TDD Cycle — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `code/REFERENCES.md` → **Guides in code/docs/** (TESTING.md, CODING-PRINCIPLES.md) · **External — Testing** · **External — Code Quality** for supporting references.

## Pre-Conditions

- [ ] Acceptance criteria are clear and agreed
- [ ] `./code/src/scripts/syntax/check.sh` passes (basedpyright + tsc + lint) before writing any tests
- [ ] Test runner available: pytest (all layers — services, endpoints, templates, HTMX partials)

---

## Execution Checklist

### Phase 0 — Compile & Type-Check

- [ ] `./code/src/scripts/syntax/check.sh` ran and passed with zero errors · _opus_

### Phase 1 — Red

- [ ] Tests written before any implementation · _opus_
- [ ] Tests assert on outcomes (return values, DB state, API responses) — not on internals · _opus_
- [ ] Test data is realistic: factories with Faker, not `"test@test.com"` or `id=999` · _opus_
- [ ] Tests use factories (not inline model instances) · _opus_
- [ ] Tests use `@pytest.mark.parametrize` for the same behaviour across different inputs · _opus_
- [ ] Every test is marked with the correct tier: `unit`, `integration`, or `e2e` · _opus_
- [ ] Unit tests written for every new function or class · _opus_
- [ ] Integration tests written for any DB, queue, or external-service interaction · _opus_
- [ ] Bruno `.bru` file created for every new Django Ninja endpoint · _opus_
- [ ] BDD scenario written for every acceptance criterion in the user story · _opus_
- [ ] All new tests confirmed red before proceeding · _opus_

### Phase 2 — Green

- [ ] Minimum implementation written — no extras · _opus_
- [ ] All unit and integration tests green · _opus_
- [ ] All Bruno API tests green (correct HTTP status, response shape, auth behaviour) · _opus_
- [ ] `./code/src/scripts/syntax/check.sh` passes after implementation · _opus_
- [ ] User-observable edge cases discovered during implementation → BDD scenario added · _opus_
- [ ] Internal edge cases discovered during implementation → unit/integration test added · _opus_
- [ ] No test was added solely to raise a coverage number · _opus_

### Phase 3 — Refactor

- [ ] Code structure improved — no logic changes, no new behaviour · _opus_
- [ ] Zero test changes required (initial tests were at the contract level, not the implementation level) · _opus_
- [ ] All tests (unit, integration, API, BDD) still green after refactor · _opus_
- [ ] Coverage floors still met: ≥ 75% line and branch (≥ 90% auth) · _opus_

### Phase 4 — Documentation closeout (verified, not written here)

Workflow 19 writes these; this checklist only confirms they exist before the PR. The record
formats, templates, and destinations live in
`project-management/workflows/19-implementation-documentation/` — never restate them here.

- [ ] `project-management/workflows/19-implementation-documentation/` run to completion for this story · _opus_
- [ ] Its `CHECKLIST.md` fully satisfied — every applicable IMPLEMENTATION record written from template and linked to `US###` · _opus_
- [ ] No spec left with a `PLANNING/` artefact but no `IMPLEMENTATION/` record · _opus_
- [ ] Findings record written to `project-management/src/18-FINDINGS/` (even if nothing was found) · _opus_
- [ ] `/GAPS.md` and `/DEFERRED.md` updated from those findings · _opus_
- [ ] Touched `CONTEXT.md`/`CLAUDE.md` complete and the code-review-graph refreshed — hard gate before commit (`.claude/CLAUDE.md` §6) · _opus_

---

## Definition of Done

- [ ] All tests pass with real implementation — no stubs, no `NotImplementedError`
- [ ] `./code/src/scripts/syntax/check.sh` passes
- [ ] Coverage floors met
- [ ] Bruno `.bru` file exists for every new Django Ninja endpoint, asserting happy path, auth failure,
      and at least one error case
- [ ] BDD scenarios cover all acceptance criteria and any user-observable edge cases found
      during implementation
- [ ] Test names read as sentences; failures state expected vs actual
- [ ] Committed and pushed
