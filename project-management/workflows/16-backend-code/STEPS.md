---
workflow: 16-backend-code
phase: build
agent: backend
skills: [stack-django]
model: opus
---

# Backend Code — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

This workflow produces code — consult **both** layer reference files:

| Step | File                               | Section                                                                                                                                     |
| ---- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| 1–5  | `code/REFERENCES.md`               | **Guides in code/docs/** → CODING-PRINCIPLES.md, DATA-STRUCTURES.md, SECURITY.md, TESTING.md, ENCRYPTION-GUIDE.md, RLS-GUIDE.md, LOGGING.md |
| 1–4  | `code/REFERENCES.md`               | **External — Framework & Language Docs → Backend** → Django 6.x, Django Ninja, Python 3.14                                                  |
| 3, 7 | `code/REFERENCES.md`               | **External — Testing** → pytest, pytest-django                                                                                              |
| 8    | `code/REFERENCES.md`               | **External — Code Quality** → Ruff, basedpyright                                                                                            |
| 1    | `project-management/REFERENCES.md` | **Internal — Live Artefacts** → src/03-DATABASE/, src/01-STORIES/                                                                           |

---

## Steps

### Step 1 — Grill, then Read the Schema and Story

> **Model:** opus · **MCP:** code-review-graph (reference only)

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> one question at a time — the implementation approach, the edge cases to
guard, and the service boundaries (which app owns each model, which service methods are
required) before writing any code.

Review the approved schema document in `project-management/src/03-DATABASE/` and the
corresponding user story in `project-management/src/01-STORIES/`.

Before writing any code, read:

- `code/CONTEXT.md` — Django project structure and settings conventions
- `code/docs/data-structures/SCHEMA-DESIGN.md` — model naming, field conventions, and indexing strategy
- `code/docs/coding-principles/PRACTICAL-RULES.md` — transaction rules, error handling, function design

Confirm:

- Which Django app(s) own the new models or changes
- Which service methods are required
- The acceptance criteria that backend tests must cover

### Step 2 — Apply the Migration

Follow `code/workflows/09-database-migration/` to generate and apply the migration cleanly:

```bash
bash code/src/scripts/database/migrate.sh make
bash code/src/scripts/database/migrate.sh run
```

### Step 3 — Write Tests First

Follow `code/workflows/02-tdd-cycle/` for the red-green-refactor steps.

```text
test-writer [describe the model, service, or behaviour to test]
```

> **↳ New agent:** `test-writer` · **Model:** opus · **MCP:** none

Tests are written before implementation — no stubs to make tests pass.

Coverage floors:

- 75% minimum for all modules
- 90% minimum for auth-related code

Refer to `code/docs/testing/BACKEND-TESTING.md` for pytest conventions and fixture patterns.

### Step 4 — Implement Models

```text
backend [describe the models to implement]
```

> **↳ New agent:** `backend` · **Model:** opus · **MCP:** none

Follow the approved schema exactly. Apply PII field encryption per `code/docs/encryption/FIELD-ENCRYPTION.md`
and row-level security per `code/docs/rls/MIDDLEWARE-AND-NINJA.md` where applicable.

### Step 5 — Implement Services

Write service methods that encapsulate business logic:

- Wrap methods that perform ≥ 2 writes in `transaction.atomic()`
- No inline imports unless unavoidable (document the reason)
- Log at ERROR or WARNING before swallowing any exception — see `code/docs/logging/DJANGO-LOGGING.md`
- Apply permission and ownership checks per `code/docs/security/AUTH-AND-AUTHZ.md`
- If a service method calls `cloudinary_service.py` or any Cloudinary SDK, invoke `/cloudinary-docs`
  and read `code/docs/cloudinary/PYTHON_SDK.md` before implementing

### Step 6 — Register in Admin

Register new models in the Django admin for internal use and data verification.

### Step 7 — Run Tests and Enforce Coverage

```bash
bash code/src/scripts/tests/backend-coverage.sh
```

All tests must pass with real implementations — no stubs.

### Step 8 — Lint and Type-Check

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

### Step 9 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

### Step 10 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
