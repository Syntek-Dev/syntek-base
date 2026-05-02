---
workflow: 12-api-design
phase: design
---

# Steps — API Design

## Prerequisites

- [ ] User story (`src/01-STORIES/US###.md`) is approved
- [ ] Database schema (`src/03-DATABASE/`) is signed off for the relevant models
- [ ] Security threat model (`src/09-SECURITY/`) is complete (for permission rules)

---

## Step 1 — Identify the API surface

Review the user story acceptance criteria and wireframes. List every data operation the story
requires:

- What data does the UI need to **read**? → candidate queries
- What state does the UI need to **change**? → candidate mutations
- Does any state change need to be **pushed** to other clients in real time? → candidate subscriptions

Write the raw list into the working document before designing signatures.

---

## Step 2 — Define GraphQL types

For each operation identified in Step 1, define the types it works with:

1. **Object types** — output shapes returned to the client (map from Django models but omit
   fields the client never needs)
2. **Input types** — argument shapes for mutations (one input type per mutation)
3. **Enums** — replace magic strings with enums where a field has a fixed set of values
4. **Scalars** — note any custom scalars needed (e.g. `DateTime`, `UUID`, `Decimal`)

---

## Step 3 — Write query signatures

For each read operation:

```text
query operationName(arg: Type): ReturnType
```

Document:

- Required vs optional arguments
- Pagination strategy — relay-style `(first, after)` / offset `(limit, offset)` / none
- Whether the result is nullable and why

---

## Step 4 — Write mutation signatures

For each write operation:

```text
mutation operationName(input: OperationNameInput!): OperationNamePayload
```

Use a payload type (not a bare scalar) so extra fields can be added without a breaking change.
Document:

- What the mutation returns on success
- What named error types it can return
- Whether it must be wrapped in `transaction.atomic()` (required if ≥ 2 writes)

---

## Step 5 — Write subscription signatures (if needed)

For each real-time operation:

```text
subscription operationName(arg: Type): EventType
```

Document the event shape and the trigger condition.

---

## Step 6 — Define the permission matrix

For every operation, fill in the permission table:

| Operation | Allowed roles | Ownership check required | Notes |
| --------- | ------------- | ------------------------ | ----- |
| ...       | ...           | Yes / No                 | ...   |

Rules:

- Every mutation must have at least one explicit role listed — no open access
- Any operation that accepts a user-supplied ID must have ownership verification noted
- Anonymous access must be explicitly justified

---

## Step 7 — Document error strategy

List the named error types the client must handle:

| Error type         | When raised                          | HTTP-equivalent |
| ------------------ | ------------------------------------ | --------------- |
| `NotFoundError`    | Resource does not exist              | 404             |
| `PermissionDenied` | Caller lacks required role/ownership | 403             |
| `ValidationError`  | Input fails field-level validation   | 422             |
| ...                | ...                                  | ...             |

---

## Step 8 — Note breaking-change and deprecation decisions

If this design modifies an existing type or operation:

- List fields being deprecated (mark with `@deprecated(reason: "...")`)
- Note the planned removal version
- Confirm no currently-used client query is broken without a migration path

---

## Step 9 — Peer review

Share the draft document with at least one other team member. Confirm:

- [ ] All acceptance criteria from the user story are covered by at least one operation
- [ ] Permission matrix is complete — no gaps
- [ ] Error types cover all failure paths identified in the security threat model
- [ ] No operation signature will cause a breaking change without a versioning plan

---

## Step 10 — Save and cross-reference

1. Save the document to `src/12-API-DESIGN/API-US###-<descriptor>.md`
2. Add a reference in the user story (`src/01-STORIES/US###.md`) under a **API Design** section
3. Proceed to `workflows/13-sprint-plans/` to include this story in the next sprint
