---
workflow: 19-api-code
phase: build
skills: [backend, stack-django]
model: opus
---

# API Code (Django Ninja) — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

This workflow produces code — consult **both** layer reference files:

| Step      | File                 | Section                                                                     |
| --------- | -------------------- | --------------------------------------------------------------------------- |
| All steps | `code/REFERENCES.md` | **Guides in code/docs/** → API-DESIGN.md, SECURITY.md, CODING-PRINCIPLES.md |
| All steps | `code/REFERENCES.md` | **External — Framework & Language Docs → Backend** → Django Ninja           |
| Tests     | `code/REFERENCES.md` | **External — Testing** → pytest, pytest-django                              |
| Lint/type | `code/REFERENCES.md` | **External — Code Quality** → Ruff, basedpyright                            |

---

## Steps

### Step 1 — Grill, then Review the Service Layer and Story

> **Model:** opus · **MCP:** code-review-graph (reference only)

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> — the endpoint and contract details (read and
write endpoints), the permission check guarding every mutating endpoint (OWASP A01)
and ownership checks (no IDOR), and the error shapes returned before writing any code.

Read the implemented service methods and the user story acceptance criteria.

Before writing any API code, read:

- `code/docs/api-design/NINJA-CONVENTIONS.md` — router and Schema design, endpoint patterns, pagination conventions
- `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md` — service/endpoint separation (endpoints must not contain business logic)
- `code/docs/security/AUTH-AND-AUTHZ.md` — permission check patterns and IDOR prevention requirements

Identify:

- Which data must be readable (GET endpoints)
- Which actions must be performable (POST/PUT/PATCH/DELETE endpoints)
- Which user roles may access each operation

### Step 2 — Design Routers and Schemas

Follow `code/workflows/04-api-design/` before writing code — use it to agree the Schema
shapes and endpoint signatures first.

Create the Ninja request/response Schemas and the `router` for the feature in the
relevant Django app's `api.py`. Mount that router onto the project's single `NinjaAPI`,
defined once in `code/src/django/config/api.py` and served at `/api/` by `config/urls.py`.
If no `NinjaAPI` exists yet, this story creates it — see
`code/docs/api-design/NINJA-CONVENTIONS.md`.

### Step 3 — Write Read Endpoints

Implement the read (GET) endpoints. Verify:

- Only data the caller is authorised to see is returned
- No unbounded queries — always apply pagination or limits per `code/docs/api-design/NINJA-CONVENTIONS.md`

### Step 4 — Write Mutating Endpoints

```text
backend [describe the mutating endpoints to implement]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `backend` · **Model:** opus · **MCP:** none

Every mutating endpoint must:

- Have an explicit permission check (OWASP A01) — see `code/docs/security/AUTH-AND-AUTHZ.md`
- Verify any user-supplied IDs against the caller's ownership before use (no IDOR)

Run `code/workflows/08-security-hardening/` after the mutating endpoints are implemented
to verify all security requirements are met.

### Step 5 — Write Tests

Follow `code/workflows/02-tdd-cycle/` for the red-green-refactor steps.

```text
test-writer [describe the read and write endpoints to test]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `test-writer` · **Model:** opus · **MCP:** none

Refer to `code/docs/testing/API-TESTING.md` for Django Ninja (TestClient) test conventions and fixture patterns.

Test coverage must include:

- Authenticated success paths
- Unauthenticated / unauthorised rejection
- Ownership boundary enforcement (IDOR prevention)
- Invalid input handling

### Step 6 — Run Tests and Enforce Coverage

```bash
bash code/src/scripts/tests/backend-coverage.sh
```

### Step 7 — Lint and Type-Check

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

### Step 8 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

### Step 9 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
