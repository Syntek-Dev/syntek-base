---
workflow: 02-tdd-cycle
phase: build
skills: [test-writer, stack-django, stack-htmx-templates]
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

> **↳ New dispatch:** `general-purpose` · **Skill:** `test-writer` · **Model:** opus · **MCP:** none

Write tests that describe the desired behaviour before writing any implementation. Tests must
assert on **outcomes** — return values, database state, API responses — not on internal methods
or implementation details. Use realistic data from the start (factories with `Faker`, not
hardcoded `"test@test.com"`). Structure with parametrize and markers so the suite is selectively
runnable as it grows.

**Agree the seams first — grill first** (`.claude/CLAUDE.md` Section 10): load
`.claude/skills/grill-with-docs` and interview <%DEVELOPER_NAME%> about which seams and
behaviours to test — the service boundary, Ninja endpoint, or component contract on the story's critical
path — before writing any test, then confirm that list with <%DEVELOPER_NAME%>. Test those seams, not every
reachable edge case. Two rules hold on every assertion: the expected value comes from an **independent source of
truth** (a known literal, a worked example, or the acceptance criteria) and is never recomputed the
way the code computes it (**no tautological tests**); and every assertion runs **through the public
interface** so it survives Phases 2–3 unchanged. Framing:
`code/docs/testing/COVERAGE.md` → **Test Discipline**. The same pass settles every open question
in the story's manual testing guide — each row whose `Notes` reads `Awaiting answer` — and the rows
are rewritten from the answers before `test-writer` is briefed, because a forked skill cannot ask
(`project-management/src/18-TESTS/MANUAL/CLAUDE.md` → _Authoring_).

**The story's manual testing guide is a named input** —
`project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md`, authored from the specs at
`project-management/workflows/17-story-plans/` Step 7.2 before any code. Brief it to
`test-writer` beside the story and its acceptance criteria. `test-writer` triages every row —
automatable rows become story-marked tests, manual-only rows stay manual — and names the triage
in its handoff; the rule is its own (`.claude/skills/test-writer/SKILL.md` → _Triage the manual
guide_). The guide is read here, never edited, and every row is still walked at
`22-implementation-documentation`, whichever way it was triaged.

<!-- UPDATED 30/09/2026. Phase 1 gained the manual testing guide as an input. The guide is now
     authored from the specs at 17-story-plans, before code, so it exists when this phase runs and
     is an independent oracle for it; triaging its rows here is what turns "a manual Fail beside a
     green suite is a missing test" from a verdict at the walk into a test written up front. The
     argument for moving authorship: "project-management/src/18-TESTS/CLAUDE.md". Phase 4's
     heading also said "PM 19" while its body named 22; 22 is the closeout. -->

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

**Where the red is committed before its fix, it is an ordinary commit — never `--no-verify`.**
No commit hook runs a gate's self-test, so a red probe inside one commits like any other change;
self-tests run at push and in CI, against the commit pushed — bar the two that need the
toolchains or a generated project, which run in CI only. Two rules hold it, and both are
**review rules**, checked by replaying history rather than by a hook:

- **Red in a commit of its own, before its fix.** The red commit adds the probe and changes no
  check; the fix commit follows it.
- **Never weaken a red probe.** The fix commit leaves the probe untouched — no edited
  expectation, no rename, no deletion, no redefined helper. A probe and its check changing
  together is the shape that hides a weakened check.

The reviewer replays both commits: `git checkout <red-sha>` then the self-test (or suite) the
probe lives in must exit `1` with the new probe failing and every older one passing;
`git checkout <fix-sha>` then the same command must exit `0`; and `git diff <red-sha> <fix-sha>`
must not touch the probe. An exit `2` at either commit is a script error, never a red.
In this template the replay is one command per commit, run from any checkout: <!-- doc-references: template-only -->
`bash .github/scripts/template-integrity.sh --self-tests <sha>` runs every self-test against a copy <!-- doc-references: template-only -->
of that commit, and names a listed script the commit lacks "absent — skipped", never a pass or a <!-- doc-references: template-only -->
red, only when the commit is an ancestor of the one on `origin/main`, as last fetched, that introduced it — any other lack (a deletion, an orphan, a squash, a graft, no `origin/main`) is "deleted", red but not run, and a shallow repository is refused; <!-- doc-references: template-only --> <!-- Deletion refused 21/11/2026; rewritten histories and shallow 21/11/2026 (round 8); origin/main alone, no grafts 21/11/2026 (round 9). -->
so a commit older than a listed self-test that `origin/main` does not yet hold — a script the
branch itself adds — reads it "deleted" until the branch reaches `main`, and its replay exits `1`
even where its own probe passes. The reviewer reads that case by the reason the replay prints
("no commit on origin/main that adds it descends from this one"), confirms that the script is the
only red and that `origin/main` lacks it (`git cat-file -e origin/main:<path>` fails), judges the
commit's own probe from its suite run at that commit, and replays it again once `main` holds it; <!-- The not-yet-on-main reading 21/11/2026 (round 10). -->
`SELF_TEST_LEDGER=<file>` on a detector's `--self-test` records each probe's label <!-- doc-references: template-only -->
and result, so the two ledgers show the label unchanged and its result gone `fail` to `pass`. <!-- doc-references: template-only -->
<!-- 21/11/2026: the planned-red opt-in (19/11/2026 to 20/11/2026) was removed; both rules became review rules. -->

---

## Phase 2 — Green (Minimal Implementation)

```text
backend [scope]   # for backend
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **MCP:** none

```text
frontend [scope]  # for frontend
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `frontend` · **Model:** opus · **MCP:** none

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

> **↳ New dispatch:** `general-purpose` · **Skill:** `refactor` · **Model:** opus · **MCP:** code-review-graph

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

## Phase 4 — Implementation Documentation (hand off to PM 22)

Hand the story to `project-management/workflows/22-implementation-documentation/`. That
workflow **owns** the closeout and is its single source of truth — do not restate the record
formats, destinations, or templates here; a second copy is exactly how they drift.

```text
doc-writer
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `doc-writer` · **Model:** opus · **MCP:** code-review-graph

It covers the IMPLEMENTATION record for every applicable spec (GDPR, security, QA, SEO, API),
the story's automated test record `project-management/src/18-TESTS/AUTOMATED/US###-TEST-STATUS.md`
written and its manual guide `project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md`
walked, the story's findings record in `project-management/src/20-FINDINGS/`, the `/GAPS.md` and
`/DEFERRED.md` routing, the `CONTEXT.md`/`CLAUDE.md` closeout across every touched layer, and
the code-review-graph refresh.

**Hard gate:** implementation docs, the touched `CONTEXT.md`/`CLAUDE.md`, and the graph refresh
must all be complete **before any commit** (`.claude/CLAUDE.md` Section 6).

---

## Phase 5 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
