---
name: test-writer
description: >-
  Produce the TDD Red phase for one <%PROJECT_NAME%> story — failing tests across the Django
  backend, the templated frontend and the MCP tools, plus the minimal skeleton that lets them
  run. Load when the failing tests have to exist before implementation starts, or a story's
  coverage has to reach its floor. Not implementing against them (`backend`, `frontend`), not
  hunting extra edge cases adversarially (`qa-tester`), not diagnosing a fault in code that
  already runs (`bugfix`), and not wiring the suite into CI (`cicd`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-django stack-htmx-templates stack-fastmcp
---

# Write the Red Phase (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable task whose output is failing tests and a
skeleton).

**You hand off red, never green.** The implementation that makes these pass is someone else's.

**Locale:** <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%> in every fixture and assertion.

---

## The brief arrives settled

A fork cannot confirm a scope, so the brief must carry **the story and its acceptance
criteria** — tests cover that story's scope and nothing else — and **the seams to cover**: the
service boundaries, endpoints, or component contracts on the critical path. Testing every
reachable edge case instead of the named seams is how a suite becomes unmaintainable.

**If the seam list is missing, name the seams you infer from the acceptance criteria and say so
in the handoff** — that is recoverable. **If the acceptance criteria are missing, return**;
without them there is no independent source of truth and every assertion becomes tautological.
Where the seams are genuinely open, that is a `grilling` pass run inline first.

## Two hard rules on every assertion

- **No tautological tests.** The expected value comes from an independent source — a known
  literal, a worked example, the acceptance criteria — **never recomputed the way the code under
  test computes it**. A test that mirrors the implementation passes for both of them.
- **Assert through the public interface** — return value, database state, API response,
  rendered output. Never a private method or an internal field, so the tests survive Green and
  Refactor unchanged.

Full framing: `code/docs/testing/COVERAGE.md` → _Test Discipline_.

## Before writing a file

```bash
git status                                       # confirm the branch is us###/short-description
grep -rl "def test_\|describe(\|it(" code/src    # find the coverage that already exists
```

**Where coverage exists, extend it — never duplicate it.** Group the new cases in a clearly
named block referencing the story.

## What to produce

1. **Skeleton** — the structural code that lets the tests run without an import or syntax
   error: models, service methods returning a dummy, Django Ninja endpoints and Schemas
   registered but empty. Migrations only where the tests touch the database
   (`bash code/src/scripts/database/migrate.sh make`).
2. **Unit and integration tests** — Arrange-Act-Assert: the happy path, the edges (null, empty,
   boundary, first and last page), the error conditions, and the security assertions below.
   Independent, no shared mutable state, external services mocked.
3. **An acceptance spec** — Given/When/Then in business language for the primary journey, and
   **only where the story is user-facing.**

Placement follows `code/docs/TESTING.md`: backend beside its app
(`apps/<app>/tests/unit|integration/`), frontend beside its component, API flows in
`code/src/tests/`. **Do not invent a parallel test tree.**

## Security assertions — non-negotiable, and red first

Where the story adds a state-changing endpoint or exposes a user-owned resource, the suite
**must** include failing tests for:

- **The permission check** — an unauthenticated or under-privileged caller is rejected.
- **No IDOR** — a caller cannot read or mutate another user's record by supplying its ID.

These gate the implementer. Never omit them on a security-relevant story.

**MCP tools** (`apps/**/mcp_tools.py`) carry three mandatory seams of their own, because **no
Django middleware covers them**: no token → rejected; another user's reference → not found; and
the mutation's policy-denial path. Assert the tool list and its schemas too — an agent client
holds them the way an HTTP client holds the OpenAPI document, so **a renamed parameter is a
breaking change**. `fastmcp.Client(mcp)` connects in-process; no server runs.

**Mobile-only:** tests under `code/src/mobile/` live in `__tests__/`, never under `app/` — where
`expo-router` would treat them as routes and bundle them — and mount the real router via
`renderRouter`. The conventions are `stack-react-native`'s, not this skill's.

## Verify RED

```bash
bash code/src/scripts/tests/backend.sh
bash code/src/scripts/tests/backend-coverage.sh
```

**Every new test must fail on an assertion, not on a missing import or class.** A test that
errors out is not a valid red — it proves nothing about behaviour and will pass the moment the
name exists.

## Guardrails

- The red phase only — the stub, never the working implementation.
- Inside the acceptance criteria: no scope creep, no unrelated regression tests.
- E2E runs Chrome unless asked otherwise.
- Skeleton code obeys the 750-line source limit and consumes `var(--token)` only.

## Handoff

Report the files created, **the red test names**, the seams they cover, and any seam you
inferred rather than were given. Then name what is owed: `backend` or `frontend` to implement
against them, `qa-tester` for the adversarial pass over what the tests do not reach, `cicd` to
wire anything new into the pipeline, and `completion` to record the test task.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/02-tdd-cycle/` — the Red phase this produces
- `project-management/workflows/11-qa-checks/` — the QA plan these tests must cover
- `code/workflows/05-mcp-server/` — an MCP tool's red phase is an in-memory `Client` test

## Cross-references

- `code/docs/TESTING.md` — test structure, mocking strategy, framework choice
- `code/docs/testing/COVERAGE.md` — the floors (75% line and branch, 90% auth) and the discipline
- `code/docs/security/AUTH-AND-AUTHZ.md` — the permission and IDOR behaviours to assert
- `code/docs/mcp-server/TESTING-AND-OPS.md` — the in-process client and the three tool seams
- `code/docs/CODING-PRINCIPLES.md` — naming, style, and the length limits the skeleton obeys
