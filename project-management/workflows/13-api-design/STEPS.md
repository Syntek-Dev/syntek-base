---
workflow: 13-api-design
phase: design
skills: [backend, stack-django]
model: fable
---

# Steps — API Design

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                                        |
| --------- | ---------------------------------------------------------------------------------------------- |
| All steps | **Internal — Live Artefacts** → src/13-API-DESIGN/                                             |
| Planning  | **Internal — Live Artefacts** → src/13-API-DESIGN/PLANNING/ (save PLAN-\*.md design docs here) |

---

## Prerequisites

- [ ] User story (`src/02-STORIES/US###.md`) is approved
- [ ] Database schema (`src/04-DATABASE/`) is signed off for the relevant models
- [ ] Security threat model (`src/10-SECURITY/`) is complete (for permission rules)

---

## Step 1 — Grill, then Identify the API surface

> **Model:** opus

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> about each read and state-changing
endpoint, its permission rules, and ownership checks before identifying the API surface.

Review the user story acceptance criteria and wireframes. List every data operation the story
requires:

- What data does the UI need to **read**? → candidate `GET` endpoints
- What state does the UI need to **change**? → candidate `POST` / `PUT` / `PATCH` / `DELETE` endpoints
- Does any state change need to **notify** another system? → candidate webhook

Write the raw list into the working document before designing signatures.

---

## Step 2 — Define Ninja Schema models

For each endpoint identified in Step 1, define the Schema (Pydantic) models it works with:

1. **Response Schema models** — output shapes returned to the client (map from Django models but
   omit fields the client never needs)
2. **Request Schema models** — request-body shapes for write endpoints (one request model per
   endpoint)
3. **Enums** — replace magic strings with Python enums where a field has a fixed set of values
4. **Field types** — note any non-primitive field types needed (e.g. `datetime`, `UUID`, `Decimal`)

---

## Step 3 — Write read-endpoint signatures

For each read operation:

```text
GET /api/<resource>/            → list[ResourceSchema]
GET /api/<resource>/{id}/       → ResourceSchema
```

Document:

- Required vs optional query parameters
- Pagination strategy — cursor `(cursor, limit)` / offset `(limit, offset)` / none
- The response status codes and whether a `404` is returned when absent

---

## Step 4 — Write write-endpoint signatures

For each write operation, choose the router module (`api.py`), HTTP method, and path:

```text
POST /api/<resource>/           (payload: CreateResourceSchema) → ResourceSchema
PATCH /api/<resource>/{id}/     (payload: UpdateResourceSchema) → ResourceSchema
```

Return a response Schema model (not a bare scalar) so extra fields can be added without a breaking
change. Document:

- What the endpoint returns on success and its success status code
- What named error responses it can return (via registered exception handlers)
- Whether it must be wrapped in `transaction.atomic()` (required if ≥ 2 writes)

---

## Step 5 — Define webhooks (if needed)

For each event-driven notification:

```text
POST <consumer-url>             (signed payload: EventSchema)
```

Document the event payload shape, the trigger condition, and the HMAC signing, replay-protection,
and idempotency guarantees (`code/docs/api-design/WEBHOOKS.md`).

---

## Step 6 — Define the permission matrix

For every endpoint, fill in the permission table:

| Endpoint | Allowed roles | Ownership check required | Notes |
| -------- | ------------- | ------------------------ | ----- |
| ...      | ...           | Yes / No                 | ...   |

Rules:

- Every state-changing endpoint must have at least one explicit role listed via a named
  permission check — no open access
- Any endpoint that accepts a user-supplied ID must have ownership verification noted
- Anonymous access must be explicitly justified

---

## Step 7 — Document error strategy

List the named error responses the client must handle — each raised by a registered Ninja
exception handler and mapped to an HTTP status code:

| Error type         | When raised                          | HTTP status |
| ------------------ | ------------------------------------ | ----------- |
| `NotFoundError`    | Resource does not exist              | 404         |
| `PermissionDenied` | Caller lacks required role/ownership | 403         |
| `ValidationError`  | Input fails field-level validation   | 422         |
| ...                | ...                                  | ...         |

---

## Step 8 — Note breaking-change and deprecation decisions

If this design modifies an existing Schema model or endpoint:

- List fields being deprecated (mark the endpoint `deprecated=True` so it surfaces in the auto
  OpenAPI at `/api/docs`)
- Note the planned removal version
- Confirm no currently-used client request is broken without a migration path

---

## Step 9 — Peer review

> **Model:** opus

Share the draft document with at least one other team member. Confirm:

- [ ] All acceptance criteria from the user story are covered by at least one endpoint
- [ ] Permission matrix is complete — no gaps
- [ ] Error responses cover all failure paths identified in the security threat model
- [ ] No endpoint signature will cause a breaking change without a versioning plan

---

## Step 10 — Save and cross-reference

1. Save the document to `src/13-API-DESIGN/API-US###-<descriptor>.md`
2. Add a reference in the user story (`src/02-STORIES/US###.md`) under a **API Design** section
3. Proceed to `workflows/15-sprint-plans/` to include this story in the next sprint

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
