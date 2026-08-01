---
workflow: 02-daily-development
phase: setup
agent: git
skills: [global-workflow]
model: opus
---

# Daily Development — Steps

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                          |
| ---- | ------------------------------------------------------------------------------------------------ |
| 1–2  | **Internal → Cross-layer references** → project-management/docs/GIT-GUIDE.md                     |
| 3–5  | **Internal → Reference guides** → how-to/docs/CLI-TOOLING.md                                     |
| 3, 5 | **External — Tools & CLI** → Docker Compose v2 reference                                         |
| 6    | **Internal → Cross-layer references** → project-management/docs/GIT-GUIDE.md (Before Every Push) |
| 7    | **Internal → Reference guides** → how-to/docs/TOOLING-GUIDE.md                                   |

---

## Steps

### Step 1 — Pull Latest

```bash
git checkout testing
git pull origin testing
```

> **Model:** opus

### Step 2 — Create Feature Branch

```bash
git checkout -b us###/feature-name
```

> **Model:** opus

### Step 3 — Start Containers and Apply Migrations

```bash
bash code/src/scripts/development/server.sh up
bash code/src/scripts/development/server.sh status
bash code/src/scripts/database/migrate.sh run
```

Applying migrations picks up any schema changes pulled from `testing`.

> **Model:** opus

### Step 4 — Work on User Story

Follow the relevant `code/` workflow for the task type.

> **↳ New agent:** `backend` (or `frontend` depending on task) · **Model:** opus · **MCP:** code-review-graph

### Step 5 — Lint Before Committing

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

> **Model:** opus

### Step 6 — Run the Test Suite Before Pushing

Per `project-management/docs/GIT-GUIDE.md` ("Before Every Push"), the backend and
frontend suites must pass locally before you commit and push:

```bash
bash code/src/scripts/tests/backend.sh
```

> **Model:** opus

### Step 7 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
