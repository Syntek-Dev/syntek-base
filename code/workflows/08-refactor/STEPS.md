---
workflow: 08-refactor
phase: build
agent: refactor
skills: [codebase-design, improve-codebase-architecture, stack-django, stack-htmx-templates]
model: opus
---

# Refactor — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                                   |
| ---- | ------------------------------------------------------------------------- |
| 2    | **Guides in code/docs/** → CODING-PRINCIPLES.md, ARCHITECTURE-PATTERNS.md |
| 1, 4 | **External — Testing** → pytest, pytest-django                            |
| 5    | **External — Code Quality** → Ruff, ESLint, Prettier, basedpyright        |

---

## Prerequisites

- [ ] Tests green before starting
- [ ] Scope clearly defined

---

## Steps

### Step 1 — Grill, then Confirm Tests Green

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and interview
<%DEVELOPER_NAME%> one question at a time about the refactor scope and the behaviour-preserving boundary before
touching any code.

Establish a clean baseline before touching any code.

```bash
bash code/src/scripts/tests/backend.sh
```

### Step 2 — Identify the Refactoring Scope

Run the refactor agent to identify issues and plan the changes.

```text
refactor [describe the scope and the problem to address]
```

> **↳ New agent:** `refactor` · **Model:** opus · **MCP:** code-review-graph (refactor playbook — `.claude/skills/refactor-safely.md`)

### Step 3 — Apply the Refactoring

Make structural changes without altering behaviour. Work in small increments —
run the tests after each meaningful change to catch regressions immediately.

### Step 4 — Verify Behaviour Unchanged

```bash
bash code/src/scripts/tests/backend.sh
```

All tests must pass. Coverage must not decrease.

### Step 5 — Lint and Type-Check

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

### Step 6 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it
5. Refresh the code-review-graph so its flows match the updated docs: `code-review-graph update` (or the `build_or_update_graph_tool` MCP tool) — keeps the graph and the layered docs in lockstep

---

### Step 7 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
