---
name: feature
description: >-
  Build a new full-stack feature for <%PROJECT_NAME%> end to end — plan, failing tests, models
  and migration, service layer, Django Ninja endpoints, the HTMX frontend, review, QA,
  documentation and commit, in that order. Load when a new capability has to be built rather
  than an existing one changed. Not fixing something broken (`bugfix`), not restructuring
  working code without changing behaviour (`refactor`), not a single scoped layer of a feature
  someone else is sequencing (`backend`, `frontend`, `database`), and not the PR that ships it
  (`pr`).
model: opus
metadata:
  skills: global-workflow grilling
---

# Build a Feature (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the request, its scope and its trade-offs arrive in the
conversation, and every phase below is a dispatch rather than work done here).

**A story is not codeable without its plan.** `project-management/workflows/16-story-plans/`
produces the master this sequence builds from; if there is no `STORY-PLAN-US###`, phase 1 makes
one before anything else starts.

---

## Before phase 1

- **Grill the scope.** Name what must be settled and wait for <%DEVELOPER_NAME%> — the
  `grilling` skill owns the round shape (`.claude/CLAUDE.md` Section 10). A feature bigger than one
  session is charted with `wayfinder` first; a session that must end before the work does exits
  through `handoff`.
- **Check the ground.** `git status` (the branch is `us###/short-description`) and
  `bash code/src/scripts/development/server.sh status` (the dev stack is up).

## The phase sequence

Each phase is a separate Agent tool call to `general-purpose`, naming the skill to load and
briefing it fully — a fresh dispatch has no memory of the previous one. **Phases dispatch
separately so that no phase checks its own output**, and three separations are load-bearing
rather than stylistic: the test writer is not the implementer, the reviewer wrote none of
phases 2–7, and the QA dispatch is not the reviewer. That is a convention this skill holds; the
runtime enforces none of it.

| #   | Phase                       | Skill                        | Note                                                                 |
| --- | --------------------------- | ---------------------------- | -------------------------------------------------------------------- |
| 1   | Plan                        | `planner`                    | Opens with its own grilling pass; lands before any implementation    |
| 2   | Failing tests (TDD red)     | `test-writer`                | All red before phase 3. **Not the phases 3–7 implementer**           |
| 3   | Models and migration        | `database` or `backend`      | Then `bash code/src/scripts/database/migrate.sh make` and `run`      |
| 4   | Service layer               | `backend`                    | Every method with ≥2 writes uses `transaction.atomic()`              |
| 5   | Ninja endpoints and Schemas | `backend`                    | Every state-changing endpoint names its Policy class                 |
| 6   | Codegen and first green     | _(none — run directly)_      | `bash code/src/scripts/tests/backend.sh`                             |
| 7   | Frontend                    | `frontend`                   | Check the django-components catalogue before adding one; WCAG 2.2 AA |
| 8   | Tests green                 | _(none — run directly)_      | `backend.sh` **and** `bash code/src/scripts/tests/all.sh --api`      |
| 9   | Review, then QA             | `code-reviewer`, `qa-tester` | Two separate dispatches, in that order                               |
| 10  | Documentation               | _(none)_                     | **Hard gate before phase 11** — see below                            |
| 11  | Commit                      | `git`                        | Conventional message, scoped to the story                            |

## The documentation gate

Nothing commits until this is done, and it is the gate most often skipped:

1. Every `CONTEXT.md` the feature affects is updated — directory trees, `**Last Updated**`, and
   any new constraint, pattern or decision.
2. Every new directory the feature introduced carries a `CONTEXT.md` **and** its `CLAUDE.md`.
3. The implementation records from phase 9 are written — owned by
   `project-management/workflows/21-implementation-documentation/`, which also refreshes the
   code-review-graph so the docs and the graph stay in lockstep.
4. `GAPS.md` and `DEFERRED.md` are current.

## Definition of done

Tests were red before the implementation and are green after it; every state-changing endpoint
carries an explicit permission check and verifies ownership of every supplied ID; the frontend
consumes `var(--token)` only and meets WCAG 2.2 AA; review and QA both ran as separate
dispatches; the documentation gate is satisfied; the commit is conventional.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/16-story-plans/` — the master plan this builds from
- `project-management/workflows/18-backend-code/` — the backend phase; drives
  `code/workflows/02-tdd-cycle/` and `code/workflows/03-database-migration/`
- `project-management/workflows/19-api-code/` — the API phase; drives `code/workflows/04-api-design/`
- `project-management/workflows/20-frontend-code/` — the frontend phase; drives
  `code/workflows/01-new-feature/`
- `project-management/workflows/21-implementation-documentation/` — records, findings, docs and
  the graph refresh; a hard gate before the commit
- `project-management/workflows/22-pr-and-review/` — PR, review, merge

## Cross-references

- `code/docs/ARCHITECTURE-PATTERNS.md` · `code/docs/API-DESIGN.md` · `code/docs/DATA-STRUCTURES.md`
- `code/docs/SECURITY.md` · `code/docs/TESTING.md` · `code/docs/CODING-PRINCIPLES.md`
- `REFERENCES.md` → _Cross-layer workflow pairing_ — which code workflow each PM phase drives
