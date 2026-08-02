---
workflow: 07-review
phase: verify
agent: review
skills: [codebase-design, improve-codebase-architecture, stack-django, stack-htmx-templates]
model: opus
---

# Code Review — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                    |
| ---- | ------------------------------------------------------------------------------------------ |
| 1–3  | **Guides in code/docs/** → CODING-PRINCIPLES.md, SECURITY.md, TESTING.md                   |
| 1–2  | **External — Security & Standards** → OWASP Top 10 (2021), OWASP REST Security Cheat Sheet |
| 1–3  | **External — Code Quality** → Ruff, ESLint, Prettier, basedpyright                         |

---

## Prerequisites

- [ ] Tests green
- [ ] Linters clean

---

## Steps

### Step 1 — Code Review

Run the code review agent across the scope being reviewed.

```text
review [scope — file, app, or feature]
```

> **↳ New agent:** `review` · **Model:** opus · **MCP:** code-review-graph (review playbook — `.claude/skills/review-changes.md`)

The review runs on **two independent axes — reported separately, never merged or ranked, with
no single cross-axis winner**:

- **Standards** — does the change follow the repo's coding standards and the code-smell
  baseline (`code/docs/CODING-PRINCIPLES.md`, `code/docs/SECURITY.md`)?
- **Spec** — does it implement what the originating `US###` story or PLAN asked for? Trace each
  acceptance criterion to the code that satisfies it.

A passing Standards axis must not mask a Spec failure. The **12 Fowler code smells**
(_Refactoring_, ch. 3) are a labelled _judgement-call_ baseline for the Standards axis — a smell
flags where to look, never a hard violation on its own; documented repo standards override it.

Address all findings on **both axes** before proceeding.

### Step 2 — Security Check

Run the security agent to verify OWASP compliance on the same scope.

```text
security [scope]
```

> **↳ New agent:** `security` · **Model:** opus · **MCP:** code-review-graph

Address all critical and high findings. Document any accepted lower-severity risks.

### Step 3 — QA Verification

```text
qa-tester [scope]
```

> **↳ New agent:** `qa-tester` · **Model:** opus · **MCP:** code-review-graph

Confirm no regressions and that acceptance criteria are met.

### Step 4 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it
5. Refresh the code-review-graph so its flows match the updated docs: `code-review-graph update` (or the `build_or_update_graph_tool` MCP tool) — keeps the graph and the layered docs in lockstep

---

### Step 5 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
