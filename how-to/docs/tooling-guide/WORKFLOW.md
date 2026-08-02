---
type: guide
agent: setup
skills: [global-workflow]
model: opus
---

# Internal Agents — End-to-End Development Workflow

**Version:** 0.1.0 **Tooling:** internal (`.claude/agents/`) **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Full dev cycle: setup, planning, TDD, QA, docs, PR

---

## Complete Development Workflow

This walks a full development cycle from project setup to PR, delegating each phase to the
internal agent that owns it (`.claude/agents/`). Claude Code auto-selects an agent from the
task, or you invoke one explicitly via the Agent tool (`subagent_type: <name>`). The `git`
agent commits after each unit of work so version control stays granular.

For an end-to-end run, start from an **orchestrator** — `feature`, `bugfix`, `pr`, `review`,
`security`, `refactor`, `release`, or `story` — and let it delegate to the specialists below.

### Phase 1: Project Initialisation

Claude Code loads `.claude/CLAUDE.md` automatically at the start of every session — there is no
plugin init step. To stand up structure and configuration for a new area:

- `setup` — scaffold project structure, environment files, and directory
  `CONTEXT.md`/`CLAUDE.md` pairs.
- `git` — commit the initialisation work.

### Phase 2: Project Planning

- `planner` — architect the feature into a phased, testable plan.
- `git` — commit the plan.

### Phase 3: User Stories & Sprint Planning

- `user-story` — generate structured US### stories from the plan.
- `sprint` — organise stories into balanced, dependency-ordered sprints.
- `git` — commit stories and sprints.

### Phase 4: Pre-Development Review

- `review` — review the plan, stories, and sprints before coding begins.
- `git` — commit any review changes.

### Phase 5: PM Tool Integration (optional)

- `pm` — link with the project-management tool (ClickUp, Linear, Jira, GitHub Projects).
- `git` — commit the PM setup.

### Phase 6: Git Branch Setup

- `git` — create the `us###/short-description` branch. Branch rules:
  `project-management/docs/GIT-GUIDE.md`.

### Phase 7: User Story Planning

- `planner` — plan the specific user story.
- `git` — commit the story plan.

### Phase 8: Test-Driven Development

- `test-writer` — write failing tests scoped to the story plus minimal stubs (TDD Red).
- `git` — commit the tests.

Run the suite with `bash code/src/scripts/tests/all.sh` (or `tests/backend.sh` /
one side).

### Phase 9: Coding

Implement the story with the relevant specialists, committing after each with `git`:

| Agent            | Scope                                          |
| ---------------- | ---------------------------------------------- |
| `backend`        | APIs, models, services, Django Ninja routers   |
| `frontend`       | UI components, pages, accessibility, token CSS |
| `database`       | Schemas, migrations, RLS, query tuning         |
| `data-scientist` | Data analysis and insight from project data    |

Goal: pass the tests and satisfy the acceptance criteria.

### Phase 10: Quality Assurance

Run in order, committing fixes after each with `git`:
`qa-tester` → `debugger` → `review` → `refactor` → `syntax` → `security`.

- `qa-tester` — hostile QA to surface bugs and edge cases.
- `debugger` — root-cause any failure found.
- `review` — code review (SOLID, security, style).
- `refactor` — clean up without changing behaviour.
- `syntax` — clear lint, format, and type errors (`bash code/src/scripts/syntax/check.sh`).
- `security` — OWASP and access-control audit.

### Phase 11: Final Verification

Repeat the Phase 10 cycle once implementation is complete; commit after each change.

### Phase 12: Documentation

- `doc-writer` — write and update developer docs and directory `CONTEXT.md`/`CLAUDE.md` pairs.
- `version` — bump semver and sync version files and metadata headers (rules:
  `project-management/docs/VERSIONING-GUIDE.md`).
- `git` — commit documentation and version updates.

### Phase 13: Completion & PR

- `completion` — mark the story and sprint complete once verified.
- `pr` — open the pull request to the testing branch.

---

## Workflow Summary

```text
SETUP        setup → git → planner → git
PLANNING     user-story → sprint → git → review → git
PM & BRANCH  pm → git → git (us### branch)
TDD          planner (story) → git → test-writer → git
IMPLEMENT    backend → frontend → database → data-scientist        (git after each)
QA           qa-tester → debugger → review → refactor → syntax → security   (git after each)
FINAL        (repeat the QA cycle)
DOCS         doc-writer → version → git
DONE         completion → pr (to testing)
```

---

## Best Practices

### 1. Start with `planner`

For any non-trivial feature, get a phased, testable plan before coding.

### 2. Run `qa-tester` before merging

An adversarial pass catches bugs and security gaps a review misses.

### 3. Keep `.claude/CLAUDE.md` current

When you add a dependency or change a framework, update `.claude/CLAUDE.md` and
`.claude/MEMORY.md` — the agents read them first every session.

### 4. Let agents read files

Point an agent at a file rather than pasting code — e.g. ask `backend` to fix the resolver in
`apps/users/`, not to fix a pasted blob.

### 5. Use the right model

Fable runs the planning/spec/design tier (`story`, `sprint`, `planner`, `user-story`, and the
architecture/GDPR/security/QA/API-design guides). Opus is the default for everything else —
implementation, delivery, and mechanical tasks (`syntax`, `doc-writer`, `version`).
Never `sonnet` or `haiku`. See `.claude/CLAUDE.md` §4.

### 6. Chain logically

`planner → user-story → sprint → backend → frontend → test-writer → qa-tester → review →
completion`.

### 7. Commit after each step

Small, focused commits via the `git` agent after each agent completes — a `feat:` commit for
the model, a `test:` commit for its tests. Commit conventions:
`project-management/docs/GIT-GUIDE.md`.

_Part of the `how-to/docs/` documentation family. See [`../TOOLING-GUIDE.md`](../TOOLING-GUIDE.md) for the full index._
