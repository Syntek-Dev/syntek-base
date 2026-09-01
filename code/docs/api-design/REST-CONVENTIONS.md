---
type: guide
skills: [backend, stack-django]
model: opus
---

# API Design — REST API Conventions

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — REST endpoint design: URLs, methods, pagination, errors, idempotency

---

These are the HTTP-contract conventions for the first-party JSON API, which is built with Django
Ninja (see [`./NINJA-CONVENTIONS.md`](./NINJA-CONVENTIONS.md) for the router/schema mechanics). Every
Ninja endpoint follows the URL, method, status-code, envelope, pagination, and error rules below.

## General Principles

1. **APIs are domain contracts, not database mirrors.** Endpoints and types expose what the consumer
   needs, not the internal schema.
2. **Consistency over cleverness.** Every endpoint in a project follows the same naming, pagination,
   error, and authentication patterns.
3. **Fail explicitly.** Every error returns a structured response with enough information for the
   consumer to understand what went wrong and how to fix it.
4. **Least privilege.** Every endpoint requires authentication unless explicitly public. Every
   response includes only the data the consumer is authorised to see.
5. **Idempotency.** `GET`, `PUT`, and `DELETE` are idempotent. `POST` is not — but where possible,
   design `POST` endpoints to handle duplicate submissions gracefully.

---

## URL Structure

URLs are nouns, not verbs. The HTTP method conveys the action.

```bash
# Good
GET    /api/v1/orders              # List orders
POST   /api/v1/orders              # Create an order
GET    /api/v1/orders/{id}         # Retrieve an order
PUT    /api/v1/orders/{id}         # Replace an order
PATCH  /api/v1/orders/{id}         # Partially update an order
DELETE /api/v1/orders/{id}         # Delete an order

# Good — nested resources for clear ownership
GET    /api/v1/orders/{id}/lines   # List lines for an order

# Bad — verbs in URLs
POST   /api/v1/createOrder
GET    /api/v1/getOrderById
```

**Rules:**

- Use plural nouns for resource collections (`/orders`, `/users`, `/bookings`).
- Use kebab-case for multi-word URLs (`/order-lines`, `/payment-methods`).
- Nest resources to a maximum of two levels. Deeper nesting should use a flat URL with query
  parameters.
- All API URLs are prefixed with `/api/` and a version identifier (`/api/v1/`).

---

## HTTP Methods

| Method   | Purpose                           | Idempotent                       | Request body   |
| -------- | --------------------------------- | -------------------------------- | -------------- |
| `GET`    | Retrieve a resource or collection | Yes                              | No             |
| `POST`   | Create a new resource             | No                               | Yes            |
| `PUT`    | Replace a resource entirely       | Yes                              | Yes (complete) |
| `PATCH`  | Partially update a resource       | No (by convention, treat as Yes) | Yes (partial)  |
| `DELETE` | Remove a resource                 | Yes                              | No             |

- `PUT` requires the full resource in the body. Missing fields are set to their defaults or null.
- `PATCH` requires only the fields being changed.
- `DELETE` returns `204 No Content` on success.
- Do not use `GET` for operations that modify state.

---

## Status Codes

| Code                        | Meaning                          | Use when                                                          |
| --------------------------- | -------------------------------- | ----------------------------------------------------------------- |
| `200 OK`                    | Success                          | GET, PUT, PATCH success with a response body                      |
| `201 Created`               | Resource created                 | POST success. Include `Location` header with the new resource URL |
| `204 No Content`            | Success, no body                 | DELETE success, or updates that return no body                    |
| `400 Bad Request`           | Client error — invalid input     | Validation failures, malformed JSON                               |
| `401 Unauthorized`          | Not authenticated                | Missing or invalid authentication token                           |
| `403 Forbidden`             | Authenticated but not authorised | The user does not have permission for this action                 |
| `404 Not Found`             | Resource does not exist          | The requested resource ID is not found                            |
| `409 Conflict`              | State conflict                   | Duplicate creation, version mismatch                              |
| `422 Unprocessable Entity`  | Validation error                 | Semantically invalid input (Ninja schema-validation convention)   |
| `429 Too Many Requests`     | Rate limit exceeded              | Include `Retry-After` header                                      |
| `500 Internal Server Error` | Server error                     | Unhandled exception (never return internal details)               |

**Rules:**

- Use `422` for validation errors (semantically wrong). Use `400` for malformed requests (invalid
  JSON, wrong content type). Pick one per project and be consistent.
- Never return `200` with an error body. If the operation failed, use a 4xx or 5xx status code.
- Include `Retry-After` (in seconds) with `429` responses.

---

## Request and Response Shapes

**A success response is not wrapped.** It is the declared `OutSchema`, and a collection is
Ninja's own pagination shape:

```json
// Single resource
{
  "id": "ord_abc123",
  "status": "confirmed",
  "total": "49.99",
  "currency": "GBP",
  "created_at": "2026-03-15T10:30:00Z"
}

// Collection, via Ninja pagination
{
  "items": [ ... ],
  "count": 148
}
```

There was a `{ "data": ... }` envelope here until 14/08/2026. It was removed rather than
implemented: Ninja builds the OpenAPI schema from the declared `response=`, so wrapping the body
after the fact makes `/api/docs` advertise a payload the API never sends. **Errors are wrapped and
successes are not**, and that asymmetry is the rule rather than an oversight — see
[`./AUTH-AND-ERRORS.md`](./AUTH-AND-ERRORS.md) — _The error envelope_ for the principle.

**Rules:**

- Return the `OutSchema` directly; paginate collections with Ninja's paginator.
- Use ISO 8601 format for all dates and times, always in UTC (`2026-03-15T10:30:00Z`).
- Use strings for monetary values to avoid floating-point precision issues.
- Use snake_case for JSON keys.

---

## Pagination

All collection endpoints must be paginated. Never return unbounded lists.

**The parameter names are Django Ninja's, not ours.** Ninja ships two paginators and the
parameter names come from the class you attach — inventing a third spelling produces an endpoint
whose documented parameter is a parameter of nothing.

| Paginator               | Parameters         | Notes                                              |
| ----------------------- | ------------------ | -------------------------------------------------- |
| `LimitOffsetPagination` | `limit` `offset`   | Ninja's **default** when no class is named         |
| `PageNumberPagination`  | `page` `page_size` | `page_size` is capped by `NINJA_MAX_PER_PAGE_SIZE` |

```bash
GET /api/orders?limit=25&offset=50
GET /api/orders?page=2&page_size=25
```

**Rules:**

- **Ninja's own default page size is 100**, not 25. Set `NINJA_PAGINATION_PER_PAGE` to change it
  and `NINJA_MAX_PER_PAGE_SIZE` to cap what a client may ask for. This project sets neither yet,
  so the shipped default is 100 until it does.
- Include pagination metadata in the `meta` object.
- Include navigation links in the `links` object.

**Cursor pagination is preferred for large or frequently changing datasets, and Ninja does not
ship it.** There is no `CursorPagination` class — reaching for one means writing a
`PaginationBase` subclass, which is a decision for the story that needs it, not a default to
assume. When it is written, the cursor is opaque to the client: never expose database IDs or
offsets in the cursor value.

---

## Filtering, Sorting, and Search

```bash
GET /api/v1/orders?status=confirmed
GET /api/v1/orders?created_after=2026-01-01&created_before=2026-03-31
GET /api/v1/orders?sort=-created_at
GET /api/v1/orders?search=widget
```

**Rules:**

- Use the field name as the query parameter name for simple equality filters.
- Use suffixed parameters for range filters (`created_after`, `created_before`, `total_gte`).
- Use `sort` with field names, prefixed with `-` for descending.
- Use `search` for full-text search across multiple fields.
- Validate all filter parameters. Unknown parameters should be ignored (not cause errors).

---

## Versioning

APIs must be versioned from the first release. Breaking changes require a new version.

### URL-based versioning (preferred)

```bash
/api/v1/orders
/api/v2/orders
```

### What constitutes a breaking change

- Removing a field from a response.
- Renaming a field.
- Changing a field's type.
- Removing an endpoint.
- Changing the authentication mechanism.

### What is NOT a breaking change

- Adding a new field to a response.
- Adding a new endpoint.
- Adding a new optional query parameter.

### Rules

- Maintain the previous version for at least 6 months after a new version is released.
- Document the deprecation timeline and communicate it to consumers.
- Add a `Deprecation` header to responses from deprecated endpoints.

---

## REST Error Response Format

**Owned by [`./AUTH-AND-ERRORS.md`](./AUTH-AND-ERRORS.md) — _The error envelope_.** The shape, the
`error.code` casing, the dotted `details[].field` path, and the six Ninja handlers that must all be
registered are stated there once.

Restated here until 14/08/2026, alongside three other copies. They had drifted.

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
