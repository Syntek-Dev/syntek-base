---
workflow: 04-api-design
phase: design
agent: backend
skills: [stack-django]
model: opus
---

# Django Ninja API Design — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                              |
| ---- | ---------------------------------------------------------------------------------------------------- |
| 1    | **Guides in code/docs/** → API-DESIGN.md, ARCHITECTURE-PATTERNS.md                                   |
| 2–3  | **External — Framework & Language Docs → Backend** → Django Ninja                                    |
| 3    | **Guides in code/docs/** → SECURITY.md (permission checks required on every state-changing endpoint) |
| 4–5  | **External — Framework & Language Docs → Frontend** → HTMX (how pages reach the server)              |
| 6    | **External — Testing** → pytest, pytest-django                                                       |

---

## Steps

### Step 1 — Grill, then Design the Endpoints and Schema

> **↳ New agent:** `planner` · **Model:** fable · **MCP:** code-review-graph

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> one question at a time — each endpoint (operation), request and response
Schema, the named Policy guarding every state-changing endpoint (OWASP A01), ownership
checks (no IDOR), error shapes, and idempotency. Record hard-to-reverse calls as an ADR in
the project's decision register.

Then document the intended Schema models and endpoints before writing any code.
Save the design to `project-management/src/13-API-DESIGN/PLANNING/`.

### Step 2 — Implement Schema Models

```text
backend [implement Ninja Schema request/response models in apps/<app>/schemas.py]
```

> **↳ New agent:** `backend` · **Model:** opus · **MCP:** none

### Step 3 — Implement Endpoints

```text
backend [implement Router endpoints in apps/<app>/api.py]
```

> **↳ New agent:** `backend` · **Model:** opus · **MCP:** none

Every state-changing endpoint must:

1. Verify the caller is authenticated
2. Check the caller has permission for the operation
3. Validate any user-supplied IDs

Implement items 1–2 as named Policy classes — see
[CODING-PRINCIPLES.md — Decision Structuring](../../docs/CODING-PRINCIPLES.md#decision-structuring-boolean-policy-and-strategy).
Item 3 is input validation, not Policy.

**M2M prefetch rule:** For every M2M relationship on an endpoint's queryset, check whether the
related model uses `deleted_at` soft-delete. If so, replace `prefetch_related("<field>")` with
`Prefetch("<field>", queryset=Model.objects.filter(deleted_at__isnull=True))`. See
`code/docs/api-design/NINJA-CONVENTIONS.md` — "Soft-Delete Filtering in M2M Prefetches".

**Schema completeness rule:** The Ninja response Schema must expose every field that request
Schema inputs accept as writable (e.g., if `sort_order` is settable in `CreateXIn`, it must appear
in the `XOut` response Schema so callers can confirm the stored value).

**Constraint guard rule:** Any service function that soft-deletes a shared resource (e.g. a tag
used via M2M across multiple content types) must query all consumer models, not just the primary
one, before proceeding.

### Step 4 — Confirm the Consumer

This API serves **machine clients only** — integrations, webhooks, and any future mobile app.
Before going further, name the consumer. If the answer is "a page in this repository", stop: that
interaction belongs on a Django view reached over HTMX, not here
(`code/docs/api-design/CLIENT-PATTERNS.md`).

For a genuine external consumer, settle the auth scheme now
(`code/docs/api-design/AUTH-STRATEGY.md`) — session cookie for same-origin, Bearer token or HMAC
signature otherwise.

### Step 5 — Verify the OpenAPI Schema

The dev stack must be running before this step. Django Ninja auto-generates the OpenAPI schema
at `/api/docs` from the Router endpoints and Schema models — there is no codegen step. Confirm
the new endpoints appear and their request/response shapes are correct.

> **Model:** opus · **MCP:** none

### Step 6 — Write Tests

```bash
bash code/src/scripts/tests/backend.sh apps/<app>/tests/ -v
```

### Step 7 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

### Step 8 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
