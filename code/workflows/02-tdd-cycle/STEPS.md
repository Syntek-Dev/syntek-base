---
workflow: 02-tdd-cycle
phase: build
agent: test-writer
skills: [stack-django, stack-htmx-templates]
model: opus
---

# TDD Cycle — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these phases:

| Phase      | Section                                                                       |
| ---------- | ----------------------------------------------------------------------------- |
| All phases | **Guides in code/docs/** → TESTING.md, CODING-PRINCIPLES.md                   |
| Phase 0    | **External — Code Quality** → basedpyright, Ruff, ESLint                      |
| Phases 1–2 | **External — Testing** → pytest, pytest-django, factory_boy, Hypothesis       |
| Phase 2    | **External — Framework & Language Docs → Backend** → Django 6.x, Django Ninja |
| Phase 3    | **External — Code Quality** → Ruff, ESLint, Prettier                          |

---

## Phase 0 — Compile & Type-Check

Before writing a single test, confirm the codebase compiles cleanly. A failing type-check means
the baseline is already broken — tests written on top of it give false results.

```bash
./code/src/scripts/syntax/check.sh
```

> **Model:** opus · **MCP:** none

This runs basedpyright plus lint. **On the web surface there is no TypeScript**, so there is no
frontend typecheck — the templates, components, and HTMX partials are covered by pytest.
Fix all errors before proceeding. Do not suppress type errors to unblock this step.

**Mobile-only.** A project with the mobile surface has a second runtime with its own typecheck;
`check.sh` delegates to it automatically when `code/src/mobile/` is present. To run it alone:

```bash
bash code/src/scripts/mobile/typecheck.sh
```

The two runtimes share **the same coverage numbers, enforced once each** — `coverage.py` and Jest
share no accumulator, so a single combined percentage was never achievable. Mobile tests run via
`bash code/src/scripts/mobile/test.sh --coverage` and live in `code/src/mobile/__tests__/`, never
inside `app/` (every file there is an expo-router route, and a co-located test would enter the
production bundle).

---

## Phase 1 — Grill, then Red (Write Failing Tests)

```text
test-writer [scope of work] --mode failing-first
```

> **↳ New agent:** `test-writer` · **Model:** opus · **MCP:** none

Write tests that describe the desired behaviour before writing any implementation. Tests must
assert on **outcomes** — return values, database state, API responses — not on internal methods
or implementation details. Use realistic data from the start (factories with `Faker`, not
hardcoded `"test@test.com"`). Structure with parametrize and markers so the suite is selectively
runnable as it grows.

**Agree the seams first — grill first** (`.claude/CLAUDE.md` §10): load
`.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%> one question at a time about which seams and
behaviours to test — the service boundary, Ninja endpoint, or component contract on the story's critical
path — before writing any test, then confirm that list with <%DEVELOPER_NAME%>. Test those seams, not every
reachable edge case. Two rules hold on every assertion: the expected value comes from an **independent source of
truth** (a known literal, a worked example, or the acceptance criteria) and is never recomputed the
way the code computes it (**no tautological tests**); and every assertion runs **through the public
interface** so it survives Phases 2–3 unchanged. Framing:
`code/docs/testing/COVERAGE.md` → **Test Discipline**.

Cover all four tiers relevant to the scope:

| Tier        | When required                                                  | Script                                               |
| ----------- | -------------------------------------------------------------- | ---------------------------------------------------- |
| Unit        | Every new function or class                                    | `./code/src/scripts/tests/backend.sh -m unit`        |
| Integration | Any code that touches the database, queue, or external service | `./code/src/scripts/tests/backend.sh -m integration` |
| API (Bruno) | Every new Django Ninja endpoint                                | `./code/src/scripts/tests/api.sh`                    |
| Acceptance  | Each `Scenario:` from the user story, as an integration test   | `./code/src/scripts/tests/backend.sh -m integration` |

Verify tests are red:

```bash
# Backend
./code/src/scripts/tests/backend.sh -v

# Frontend
```

Do not proceed to Phase 2 until all new tests are red. A test that is green before any
implementation exists is either testing the wrong thing or testing nothing.

---

## Phase 2 — Green (Minimal Implementation)

```text
backend [scope]   # for backend
```

> **↳ New agent:** `backend` · **Model:** opus · **MCP:** none

```text
frontend [scope]  # for frontend
```

> **↳ New agent:** `frontend` · **Model:** opus · **MCP:** none

Write the **minimum** code to make all tests pass. No gold-plating, no speculative abstractions.

During this phase, amend or add tests when real edge cases are discovered through building the
feature:

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
refactor [scope]
```

> **↳ New agent:** `refactor` · **Model:** opus · **MCP:** code-review-graph

Improve readability and structure. No new behaviour. All tests — including Bruno API tests — must
remain green after every refactor step.

```bash
# Run the full suite to confirm nothing regressed
./code/src/scripts/tests/backend.sh
./code/src/scripts/tests/api.sh
```

Check coverage floors are still met:

```bash
./code/src/scripts/tests/backend-coverage.sh
./code/src/scripts/tests/backend-coverage.sh
```

---

## Phase 4 — Implementation Documentation (hand off to PM 19)

Hand the story to `project-management/workflows/21-implementation-documentation/`. That
workflow **owns** the closeout and is its single source of truth — do not restate the record
formats, destinations, or templates here; a second copy is exactly how they drift.

```text
doc-writer
```

> **↳ New agent:** `doc-writer` · **Model:** opus · **MCP:** code-review-graph

It covers the IMPLEMENTATION record for every applicable spec (GDPR, security, QA, SEO, API),
the story's findings record in `project-management/src/19-FINDINGS/`, the `/GAPS.md` and
`/DEFERRED.md` routing, the `CONTEXT.md`/`CLAUDE.md` closeout across every touched layer, and
the code-review-graph refresh.

**Hard gate:** implementation docs, the touched `CONTEXT.md`/`CLAUDE.md`, and the graph refresh
must all be complete **before any commit** (`.claude/CLAUDE.md` §6).

---

## Phase 5 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
