---
type: guide
skills: [setup, global-workflow]
model: opus
---

# Internal Skills — End-to-End Development Cycle

**Version:** 0.1.0 **Tooling:** internal (`.claude/skills/`) **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — full dev cycle: setup, planning, TDD, QA, docs, PR

---

## Complete Development Workflow

This walks a full development cycle from project setup to PR, loading the skill that owns each
phase (`.claude/skills/CONTEXT.md` says which skill owns what). How a skill is reached and where
it runs: [`COMMANDS.md`](COMMANDS.md). The `git` skill commits after each unit of work so version
control stays granular.

For an end-to-end run, reach for the skill whose remit is the **whole arc** — `implement-story`, `bugfix`,
`release` — and let it sequence the scoped skills below rather than driving each by hand.

### Phase 1: Project Initialisation

Claude Code loads `.claude/CLAUDE.md` automatically at the start of every session — there is no
plugin init step. To stand up structure and configuration for a new area:

- `setup` — scaffold project structure, environment files, and directory
  `CONTEXT.md`/`CLAUDE.md` pairs.

### Phase 2: Project Planning

- `planner` — architect the feature into a phased, testable plan.

### Phase 3: User Stories & Sprint Planning

- `story` — write each `US###` story from the plan, one at a time.
- `sprint` — organise stories into balanced, dependency-ordered sprints.

### Phase 4: Pre-Development Review

- `review` — review the plan, stories, and sprints before coding begins.

### Phase 5: PM Tool Integration (optional)

- `pm-tool-sync` — link with the project-management tool (ClickUp, Linear, Jira, GitHub
  Projects).

### Phase 6: Git Branch Setup

- `git` — create the `us###/short-description` branch. Branch rules:
  `project-management/docs/GIT-GUIDE.md`.

### Phase 7: User Story Planning

- `planner` — plan the specific user story.

### Phase 8: Test-Driven Development

- `test-writer` — write failing tests scoped to the story plus minimal stubs (TDD Red).

Run the suite with `bash code/src/scripts/tests/all.sh` (or `tests/backend.sh` /
one side).

### Phase 9: Coding

Implement the story with the relevant skills, committing after each with `git`:

| Skill           | Scope                                          |
| --------------- | ---------------------------------------------- |
| `backend`       | APIs, models, services, Django Ninja routers   |
| `frontend`      | UI components, pages, accessibility, token CSS |
| `database`      | Schemas, migrations, RLS, query tuning         |
| `data-analysis` | Answering a question from the project's data   |

Goal: pass the tests and satisfy the acceptance criteria.

### Phase 10: Quality Assurance

Run in order, committing fixes after each with `git`:

- `review` — sequences the content review (`code-reviewer`), the hostile QA pass (`qa-tester`),
  and, where auth, permissions, PII or a new state-changing endpoint are in scope, `security`.
- `bugfix` — its `## Root cause` phase, entered on its own, to diagnose any failure that pass
  proves. Fixing it is the rest of that skill, and a separate decision.
- `refactor` — clean up without changing behaviour.
- `syntax` — clear lint, format, and type errors (`bash code/src/scripts/syntax/check.sh`).

### Phase 11: Final Verification

Repeat the Phase 10 cycle once implementation is complete; commit after each change.

### Phase 12: Documentation

- `doc-writer` — write and update developer docs and directory `CONTEXT.md`/`CLAUDE.md` pairs.
- `version` — bump semver and sync version files and metadata headers (rules:
  `project-management/docs/VERSIONING-GUIDE.md`).

### Phase 13: Completion & PR

- `completion` — mark the story and sprint complete once verified.
- `pr` — open the pull request to the testing branch.

---

## Workflow Summary

```text
SETUP        setup → git → planner → git
PLANNING     story → sprint → git → review → git
PM & BRANCH  pm-tool-sync → git → git (us### branch)
TDD          planner (story) → git → test-writer → git
IMPLEMENT    backend → frontend → database → data-analysis        (git after each)
QA           review → bugfix (root cause) → refactor → syntax     (git after each)
FINAL        (repeat the QA cycle)
DOCS         doc-writer → version → git
DONE         completion → pr (to testing)
```

---

## Best Practices

### 1. Start with `planner`

For any non-trivial feature, get a phased, testable plan before coding.

### 2. Run `review` before merging

It sequences the adversarial pass, which catches bugs and security gaps a read-only review
misses.

### 3. Keep the review out of the writer's hands

The build and the review of it are separate dispatches, so the reader meets the diff without the
writer's intent already in context. Nothing enforces it — it holds because each phase is
dispatched separately ([`COMMANDS.md`](COMMANDS.md)).

### 4. Keep `.claude/CLAUDE.md` current

When you add a dependency or change a framework, update `.claude/CLAUDE.md` and
`.claude/MEMORY.md` — they are read first every session.

### 5. Point at files, not pasted code

Name the file rather than pasting it — e.g. fix the service in `apps/users/`, not a pasted blob.

### 6. Use the right model

Tier is set by the `model:` frontmatter on the guide or workflow you are in. The table, and why
`sonnet` and `haiku` are never used, is `.claude/CLAUDE.md` Section 4.

### 7. Chain logically

`planner → story → sprint → backend → frontend → test-writer → qa-tester → review →
completion`.

### 8. Commit after each step

Small, focused commits via the `git` skill after each phase — a `feat:` commit for the model, a
`test:` commit for its tests. Commit conventions: `project-management/docs/GIT-GUIDE.md`.

_Part of the `how-to/docs/` documentation family. See [`../TOOLING-GUIDE.md`](../TOOLING-GUIDE.md) for the full index._
