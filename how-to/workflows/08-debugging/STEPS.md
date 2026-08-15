---
workflow: 08-debugging
phase: verify
skills: [bugfix, global-workflow]
model: opus
---

# Debugging — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                                              |
| ---- | -------------------------------------------------------------------------------------------------------------------- |
| 1–2  | **External — Tools & CLI** → Docker Compose v2 reference                                                             |
| 2–4  | **External — Debugging & Observability** → Django debug toolbar, pytest documentation, Chrome DevTools Network panel |
| 5    | **Internal → Reference guides** → how-to/docs/TOOLING-GUIDE.md                                                       |

---

## Steps

### Step 1 — Check Container Logs

```bash
# All logs
bash code/src/scripts/development/logs.sh --follow

# Backend only
bash code/src/scripts/development/logs.sh --service backend --follow

# Frontend only
bash code/src/scripts/development/logs.sh --service frontend --follow
```

> **Model:** opus

### Step 2 — Isolate the Problem

If the error is in a Django Ninja endpoint, test the operation directly in the OpenAPI docs:
http://dev.<%PROJECT_SLUG%>.localhost:81/api/docs

If it is a frontend issue, open browser DevTools → Network → find the failing request.

> **Model:** opus · **MCP:** claude-in-chrome (DevTools inspection)

### Step 3 — Inspect Data (Backend)

```bash
bash code/src/scripts/development/shell.sh
```

```python
from apps.<app>.models import <Model>
<Model>.objects.filter(<condition>)
```

> **Model:** opus · **MCP:** code-review-graph (model structure analysis)

### Step 4 — Run the Failing Test in Verbose Mode

```bash
# Backend
bash code/src/scripts/tests/backend.sh tests/<module>/<test_file>.py::test_name -v -s

# Frontend
```

> **Model:** opus

### Step 5 — Diagnose the Root Cause

```text
bugfix — run the ## Root cause phase only: [describe the problem and what you have tried]
```

Diagnosis, not repair: the phase ends at a documented root cause and a recommended fix. Applying
that fix, regression-testing it and committing it is the full `bugfix` sequence, entered
separately.

> **↳ New dispatch:** `general-purpose` · **Skill:** `bugfix`, the `## Root cause` phase only — no fix, no commit · **Model:** opus · **MCP:** code-review-graph

### Step 6 — Document and Fix

If the bug warrants a bug report:
Save to `project-management/src/20-BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md`.

> **Model:** opus

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
