---
story: "{US###}"
title: "{STORY TITLE}"
status: "{Draft | Reviewed | Signed off}"
version: "{0.1.0}"
created: "{DD/MM/YYYY}"
---

# API Design — {US###}: {STORY TITLE}

_Template — copy to `API-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]` row and
`{PLACEHOLDER}` with this story's own design, and delete this note once populated. This
is the **pre-implementation** Django Ninja contract for a single story; its
post-implementation counterpart is `../IMPLEMENTATION/API-IMPL-US000-TEMPLATE.md`._

The contract is for the project's **single `NinjaAPI`** — defined once in `config/api.py`
and served under `/api/`, with its OpenAPI schema at `/api/docs`, as JSON for machine
consumers. **No page in this repository calls it**: every surface is
server-rendered Django templates reaching the server through HTMX against Django views.

> At baseline no `NinjaAPI` is wired and no app defines a router — Django Ninja is declared
> in `pyproject.toml` but unused. The first story to need an endpoint creates both. Write
> this contract against `code/docs/api-design/NINJA-CONVENTIONS.md`, which fixes where the
> instance lives and how routers attach to it.

**Also covers:** {any other story whose endpoints are defined here, or "None."}
**Schema authority:** {Schemas reused from another design doc and referenced here, or
"None — all Schemas defined below."}

---

## Step 1 — API Surface

The endpoints this story needs. One row per read (GET) and write (POST/PATCH/DELETE)
endpoint, on the router this story's app contributes to the `NinjaAPI`.

| Endpoint                            | Type  | Source story | Purpose                                     |
| ----------------------------------- | ----- | ------------ | ------------------------------------------- |
| [EXAMPLE] `GET /api/example-items`  | Read  | {US###}      | {paginated list of published example items} |
| [EXAMPLE] `POST /api/example-items` | Write | {US###}      | {create an example item}                    |

_Add a row for every endpoint the story introduces. State up front whether any endpoint is
public (no auth) or session-authenticated, and note anything reused from another design
doc. Group endpoints under one `Router` per resource._

---

## Step 2 — Ninja Schemas

### Field types & formats

The Python field types and formats this contract relies on, each justified.

| Field type           | Justification                                                          |
| -------------------- | ---------------------------------------------------------------------- |
| [EXAMPLE] `datetime` | ISO 8601 timestamp; used on `published_at`, `created_at`, `updated_at` |
| [EXAMPLE] `UUID`     | Model PKs exposed as opaque UUIDs, never sequential integers           |

### Enums

Replace magic strings with a Python enum wherever the domain has a fixed value set; Ninja
serialises it to its string value.

```python
# [EXAMPLE] — replace with this story's own enum(s)
from enum import Enum


class ExampleStatus(str, Enum):
    DRAFT = "draft"
    PUBLISHED = "published"
    ARCHIVED = "archived"
```

### Response Schemas

One illustrative response Schema (output model). Every optional (nullable) field must
carry a one-line reason.

```python
# [EXAMPLE] — replace with this story's own response Schema(s)
from datetime import datetime
from uuid import UUID

from ninja import Schema


class ExampleItemOut(Schema):
    id: UUID
    slug: str
    title: str
    status: ExampleStatus
    published_at: datetime | None  # null — unpublished items have no publish date
    created_at: datetime
```

_Repeat one block per response Schema. Omit PII fields from any Schema reachable by an
unauthenticated caller (data minimisation); note why each optional field can be null._

### Request Schemas

Write-endpoint bodies — one create and one update Schema per writable entity.

```python
# [EXAMPLE] — replace with this story's own request Schema(s)
class ExampleItemCreate(Schema):
    title: str
    slug: str
    status: ExampleStatus = ExampleStatus.DRAFT  # optional — defaults to DRAFT server-side
```

### Pagination wrapper

List endpoints use django-ninja pagination (`ninja.pagination.paginate`), which returns a
uniform envelope of `items` + `count`. Declare a typed paged Schema per paginated response
type.

```python
class PagedExampleItems(Schema):
    items: list[ExampleItemOut]
    count: int  # total matching rows, for the consumer's pager
```

---

## Step 3 — Read Endpoints (GET)

Each GET endpoint with its query parameters, defaults/limits, and a handler contract
(filters, ordering, pagination, and the null-vs-empty decision).

### [EXAMPLE] `GET /api/example-items`

```python
@router.get("/example-items", response=PagedExampleItems)
@paginate(LimitOffsetPagination)
def list_example_items(
    request,
    status: ExampleStatus | None = None,
) -> QuerySet[ExampleItem]:
    ...
```

- `limit`: page size, default 10, max 50 (enforced by the paginator, not trusted from input)
- `offset`: row offset from the paginator
- `status`: optional filter

**Handler contract:**

- Filters: `{the baseline filter, e.g. status = PUBLISHED, deleted_at IS NULL}`
- Ordering: `{stable ordering, e.g. published_at DESC}`
- Pagination: `LimitOffsetPagination` on a stable key (`id`)
- An empty result set returns `{ "items": [], "count": 0 }` with HTTP 200 — never `null`

_Repeat one block per GET endpoint. For a single-object lookup, state explicitly whether a
miss returns HTTP 404 (no info leak) or a typed error, and why._

---

## Step 4 — Write Endpoints (POST/PATCH/DELETE)

Each write endpoint with its request Schema, response Schema/status, and **explicit
permission rule**. Every endpoint that accepts a user-supplied ID carries an ownership
(IDOR) check.

### [EXAMPLE] `POST /api/example-items`

```python
@router.post("/example-items", response={201: ExampleItemOut})
def create_example_item(request, payload: ExampleItemCreate) -> tuple[int, ExampleItem]:
    ...
```

- **Permission:** {required named rule — role / module + level, e.g. `example` module
  `edit` or `full`, checked before any read or write}
- **Ownership check:** {N/A on create — or, for PATCH/DELETE: the path `id` must resolve
  within the caller's scope before any read or write}
- **Returns:** a typed response Schema with an explicit status code (`201` create, `200`
  update, `204` delete) — never a bare scalar, so fields can be added without a break
- **Transaction:** wrap multi-table writes in `transaction.atomic()`; note the audit-log write

_Repeat one block per write endpoint. If the story has no writes, state "None required —
this story is read-only." and say why._

---

## Step 5 — Real-time & Async

{`None required` — Django Ninja is request/response; a consumer re-fetches the read
endpoints after a write. Or define any polling interval, Server-Sent
Events stream, or background job the story needs, each with its trigger, payload Schema,
and permission rule.}

---

## Step 6 — Permission Matrix

**Every** endpoint from Steps 3–5 appears here — no endpoint may be left out.

| Endpoint                            | Allowed callers       | Auth required | Ownership check | Notes (rate limit)          |
| ----------------------------------- | --------------------- | ------------- | --------------- | --------------------------- |
| [EXAMPLE] `GET /api/example-items`  | {`example` view+}     | Yes (session) | No              | {60 req/IP/60 s}            |
| [EXAMPLE] `POST /api/example-items` | {`example` edit/full} | Yes (session) | {No (create)}   | {200 req/min authenticated} |

_One row per endpoint. The permission check must run before any DB read or write. Justify
any anonymous access explicitly. Every ID-accepting endpoint states its ownership check
(OWASP A01 — no IDOR)._

---

## Step 7 — Error Strategy

Errors are raised as `HttpError` (or an `HttpError` subclass) and normalised by the
exception handlers registered once on the `NinjaAPI` instance, so every failure returns a
consistent JSON body.

| Error type                   | When raised                                   | HTTP status             |
| ---------------------------- | --------------------------------------------- | ----------------------- |
| [EXAMPLE] `PermissionDenied` | Caller lacks the required permission rule     | 403 + `{ "detail": … }` |
| [EXAMPLE] `NotFound`         | Record missing, or outside the caller's scope | 404 (no info leak)      |
| [EXAMPLE] `ValidationError`  | Request Schema validation fails               | 422 + field errors      |
| [EXAMPLE] `RateLimited`      | Caller exceeds the documented rate limit      | 429 + `Retry-After`     |

_List every error type a client may receive. State the HTTP status and JSON body for each,
and keep it consistent across the contract via the shared handler. A not-found lookup that
returns 404 to avoid info disclosure is the intended behaviour, not a leak — say so where
it applies._

---

## Step 8 — Breaking Changes

- {New API with no existing consumers — no deprecations. Or: list any field/Schema removed
  or renamed, the deprecation window, and the external consumers to coordinate with.}
- Future additions to a response Schema should be **additive-only**; no removals without a
  deprecation period. Consumers are external and read the JSON directly, so a removed field
  breaks them at runtime, not at build — diff the committed OpenAPI schema in CI.

---

## Step 9 — Peer Review

Design-quality gates — tick each before the contract is signed off.

- [ ] Every acceptance criterion in {US###} is covered by at least one endpoint
- [ ] Every endpoint appears in the Step 6 permission matrix
- [ ] Every write endpoint names an explicit permission rule; every ID-accepting endpoint
      an ownership (IDOR) check — consistent with `code/docs/SECURITY.md`
- [ ] No PII field is reachable by an unauthenticated caller (data minimisation)
- [ ] Every optional (nullable) response field is justified
- [ ] Pagination stated for every list endpoint; Schema names consistent across docs

---

## Step 10 — Cross-References

**Stories consuming these Schemas (each must link back to this design):**

| Story             | Consumes                                     |
| ----------------- | -------------------------------------------- |
| [EXAMPLE] {US###} | {`GET /api/example-items`, `ExampleItemOut`} |

- `../IMPLEMENTATION/API-IMPL-US000-TEMPLATE.md` — the post-implementation verification of
  this contract
- `../../02-STORIES/{US###}.md` — the story this design serves (add an `### API Design`
  section there referencing this file)
- `../../04-DATABASE/` — the agreed schema this contract exposes
- `code/docs/API-DESIGN.md` — Django Ninja conventions this design is written against
- `code/docs/SECURITY.md` — the permission/IDOR rules this design specifies and code enforces
- `project-management/workflows/13-api-design/` — the workflow that produces this design;
  it feeds `project-management/workflows/19-api-code/`

---

## Checklist

### Prerequisites

- [ ] {US###} acceptance criteria finalised
- [ ] Database schema signed off for the affected tables (`../../04-DATABASE/`)
- [ ] Security threat model / GDPR plan complete where PII is in play

### Schemas

- [ ] All response, request, enum, and paged Schemas the client needs are defined
- [ ] Field types and formats named and justified; magic strings replaced by enums
- [ ] Every optional (nullable) field carries a reason

### Read endpoints

- [ ] Each GET has query params, defaults/limits, ordering, and a handler contract
- [ ] Pagination documented; null-vs-empty (empty envelope vs 404) decision stated

### Write endpoints

- [ ] Each write has a request Schema, a typed response + status code, and a permission rule
- [ ] `transaction.atomic()` flagged for every multi-table write, or "read-only" noted

### Permissions

- [ ] Every endpoint present in the permission matrix
- [ ] Every ID-accepting endpoint has an ownership (IDOR) check; anonymous access justified

### Errors

- [ ] Every error type documented; HTTP status and JSON body stated, and routed through the
      `NinjaAPI` exception handlers

### Sign-off

- [ ] Peer review completed (Step 9)
- [ ] Consuming stories updated with an `### API Design` section referencing this file
- [ ] Document saved to `PLANNING/API-PLAN-US###-<DESCRIPTOR>.md`
