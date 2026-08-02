---
type: guide
agent: backend
skills: [stack-django]
model: opus
---

# API Design — Django Ninja Conventions

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Django Ninja router/schema naming, endpoint design, per-endpoint auth, and module conventions

---

Django Ninja is the project's first-party JSON API. A `NinjaAPI` instance is mounted once, each
Django app contributes a `Router`, and every request and response is a typed Pydantic `Schema`.
Its consumers are machine clients — integrations, webhooks, and any future mobile app. The site
itself never touches it: pages use server-rendered templates and HTMX against Django views
(see [`./CLIENT-PATTERNS.md`](./CLIENT-PATTERNS.md)).

## Schema Design

- Name schemas after the domain, not the database table. `OrderOut`, not `OrdersTableSchema`.
- Use clear, specific names and the `In`/`Out` suffix convention: `CreateOrderIn`, `OrderOut`.
- Every endpoint carries a `summary` and a docstring — both surface in the OpenAPI page.
- Use `UUID`/`int` for identifiers, `str` for text, `Decimal` for money, `datetime` for timestamps.
- Make fields required by default. Use `T | None = None` only when absence is meaningful.
- Response schemas are derived from models with `ModelSchema` where the shape matches; hand-write a
  `Schema` when the API contract must diverge from the ORM (the API is a contract, not a mirror).

### Every backend module must have an `api.py`

Every `apps/<name>/` module exports an `api.py` at the package root — the single assembly point for
that module's HTTP surface. It defines a `Router`, its endpoints, and the request/response schemas
(or imports them from `schemas.py` when the file grows).

**Required contents of `api.py`:**

1. **A module `Router`** — `router = Router(tags=["orders"])`; `tags` groups the endpoints in the
   OpenAPI page.
2. **Endpoints** decorated with `@router.get/post/put/patch/delete`, each declaring its `response`
   schema and, where it is not public, its `auth=`.
3. **No business logic** — endpoints validate, authorise, delegate to the service layer, and map the
   result. Delegate to the service layer for everything else.

```python
# apps/orders/api.py
from ninja import Router
from apps.orders.schemas import OrderOut
from apps.orders.services import get_orders_for_user
from apps.core.api_auth import SessionAuth

router = Router(tags=["orders"])


@router.get("/orders", response=list[OrderOut], auth=SessionAuth(), summary="List orders")
def list_orders(request) -> list[OrderOut]:
    """Return the authenticated user's orders."""
    return [_to_order(o) for o in get_orders_for_user(request.auth)]
```

The project root wires every module router onto one `NinjaAPI`:

```python
# config/api.py — the single mounted API
from ninja import NinjaAPI
from apps.orders.api import router as orders_router

api = NinjaAPI(title="<%PROJECT_NAME%> API", version="1.0.0", docs_url="/docs")
api.add_router("/", orders_router)
# urls.py: path("api/", api.urls)  → endpoints under /api/, docs at /api/docs
```

**Rules:**

- A resolver for the current user returns `None` (never raises) when unauthenticated.
- Never expose raw ciphertext, HMAC tokens, or internal IDs through a response schema.
- The router only wires endpoints together; `api.py` must not contain business logic.
- One `NinjaAPI` instance for the whole project — modules add routers, they do not create APIs.

---

## Endpoint Design (reads)

- URLs are nouns; the HTTP method conveys the action (`GET /orders`, `GET /orders/{id}`).
- Accept filter arguments as typed query params via a `FilterSchema` or plain parameters.
- Paginate every collection endpoint — never return an unbounded list.

```python
from ninja import Query
from ninja.pagination import paginate, PageNumberPagination


@router.get("/orders/{order_id}", response=OrderOut | None, auth=SessionAuth())
def get_order(request, order_id: int) -> OrderOut | None:
    """Retrieve a single order by ID (scoped to the caller)."""
    ...


@router.get("/orders", response=list[OrderOut], auth=SessionAuth())
@paginate(PageNumberPagination)
def list_orders(request, status: str | None = None):
    """List orders for the authenticated user."""
    ...
```

---

## State-changing endpoints (writes)

- Name the URL after the resource; the method (`POST`/`PUT`/`PATCH`/`DELETE`) is the verb.
- Accept a single request `Schema` for complex bodies. Return the affected resource schema.
- **Every state-changing endpoint needs an explicit permission check.** No `POST`/`PUT`/`PATCH`/
  `DELETE` ships without a named authorisation check, and every user-supplied ID is verified against
  the caller's ownership before use (no IDOR).

```python
from ninja import Schema
from ninja.errors import HttpError


class CreateOrderIn(Schema):
    lines: list[OrderLineIn]
    currency: str = "GBP"


@router.post("/orders", response={201: OrderOut}, auth=SessionAuth(), summary="Create an order")
def create_order(request, payload: CreateOrderIn):
    """Create a new order for the authenticated user."""
    if not can_access_module(request.auth, "orders"):
        raise HttpError(403, "You do not have permission to create orders.")
    order = create_order_service(request.auth, payload)
    return 201, _to_order(order)
```

**Type completeness rule:** the response schema must expose every field a request schema accepts as
writable. If `CreateOrderIn` accepts `sort_order`, `OrderOut` must expose `sort_order` so callers
can confirm the stored value.

**Constraint guard rule:** any service function that soft-deletes a shared resource must check
**all** models that reference it via M2M, not only the primary consumer — checking one leaves
orphaned M2M references after deletion.

---

## Soft-Delete Filtering in M2M Prefetches

When a response schema includes an M2M relationship whose related model uses soft-delete tracking
(`deleted_at`), the prefetch **must** apply the soft-delete filter. A bare
`prefetch_related("field")` returns all rows — including soft-deleted ones.

```python
# WRONG — returns deleted sector tags
qs = qs.prefetch_related("tags")

# CORRECT — filters deleted rows at the DB level
from django.db.models import Prefetch
from apps.core.models import Tag

qs = qs.prefetch_related(
    Prefetch("tags", queryset=Tag.objects.filter(deleted_at__isnull=True))
)
```

This applies to every service queryset that backs an endpoint. The mapper (`_to_*`) calls `.all()`
on the prefetched relation — filtering happens in the service layer, not the mapper.

---

## Mapper functions — define once, import everywhere

Model-to-schema mapper functions (`_to_<type>`) are defined **once** in the module's `services.py`
(or a `mappers.py`) and imported wherever needed.

| Location                | Pattern                                                   |
| ----------------------- | --------------------------------------------------------- |
| `services.py`           | Canonical definition — `def _to_<type>(obj) -> OutSchema` |
| `api.py`                | Local-import wrapper (avoids intra-app circular imports)  |
| `apps/core/` composites | Top-level import (no circular risk)                       |

Never duplicate an identical function body across files. If the body exists, import it.

---

## Error Handling in Django Ninja

For expected domain errors, either raise `HttpError(status, message)` or model alternate outcomes
as a status-keyed response union so clients can discriminate on the HTTP status:

```python
class NotFoundOut(Schema):
    message: str


@router.post("/orders/{order_id}/cancel", response={200: OrderOut, 404: NotFoundOut, 409: NotFoundOut})
def cancel_order(request, order_id: int):
    ...
```

Register **exception handlers** on the `NinjaAPI` instance so every error returns the standard
envelope (see [`./REST-CONVENTIONS.md`](./REST-CONVENTIONS.md) — REST Error Response Format) and no
traceback leaks:

```python
from ninja.errors import ValidationError


@api.exception_handler(ValidationError)
def on_validation_error(request, exc):
    details = [{"field": e["loc"][-1], "message": e["msg"]} for e in exc.errors]
    return api.create_response(
        request,
        {"error": {"code": "validation_failed", "message": "Invalid request.", "details": details}},
        status=422,
    )
```

---

## Production hardening on the root `NinjaAPI`

Hardening is applied once, on the mounted `NinjaAPI` — it is not inherited by routers automatically.

- **Interactive docs off in production.** Gate `docs_url` on an explicit setting so a project
  accidentally deployed with `DEBUG=True` does not expose its OpenAPI page. `DEBUG=True` must not
  enable the docs by itself.
- **Error masking.** With `DEBUG=False`, Ninja returns generic 500s; the exception handlers above
  guarantee no traceback, SQL, or file path reaches a client.
- **Default auth + CSRF.** Set a default `auth=` on the `NinjaAPI` so an endpoint is authenticated
  unless it explicitly opts out. Session-authed endpoints enforce CSRF (`csrf=True`).

```python
from django.conf import settings

api = NinjaAPI(
    title="<%PROJECT_NAME%> API",
    version="1.0.0",
    docs_url="/docs" if settings.API_DOCS_ENABLED else None,
    csrf=True,
    auth=SessionAuth(),
)
```

`API_DOCS_ENABLED` is an explicit opt-in (default `False` outside local), independent of `DEBUG`.

---

## Rate Limiting — Two Independent Mechanisms

Two defence layers run simultaneously and guard different surfaces; they do not overlap.

**HTTP-middleware rate limiting** — the shape to build when the API is first exposed: two
Valkey-backed middlewares, both fail-open, both returning HTTP 429 with a `Retry-After` header.
They must read `request.user` _after_ the auth middleware has resolved it, so the authenticated
limiter sees the resolved user. **Neither exists at baseline** — add them with the first public
endpoint, in the shared app that owns cross-cutting middleware:

| Middleware                            | Applies to                                  | Suggested limit      |
| ------------------------------------- | ------------------------------------------- | -------------------- |
| `PublicAPIRateLimitMiddleware`        | Unauthenticated requests to `/api/`, per IP | 60 req/min per IP    |
| `AuthenticatedAPIRateLimitMiddleware` | Authenticated requests, per user            | 200 req/min per user |

**Ninja endpoint throttling** — Ninja's throttle classes (`AuthRateThrottle`, `AnonRateThrottle`)
applied per-router or per-endpoint via `throttle=`, backed by the same Valkey cache. Use it for
finer-grained limits (e.g. a stricter cap on an expensive search endpoint) than the blanket HTTP
middleware provides.

**Interaction summary:**

1. A request arrives at the WSGI/ASGI layer.
2. The auth middleware resolves `request.user` (session or Bearer token).
3. The applicable HTTP rate-limit middleware checks the IP/user rate — 429 (`Retry-After`) if over.
4. The request reaches the Ninja endpoint; any endpoint `throttle=` applies before the handler runs.

Both HTTP middlewares share the same Valkey backend.

---

## Auto-generated OpenAPI and typed clients

Django Ninja generates the OpenAPI schema and an interactive documentation page automatically from
the endpoint type hints and `Schema` models, so the schema always tracks the code.

- **Docs page:** the Swagger UI is served at `/api/docs` (gated by `API_DOCS_ENABLED`).
- **Raw schema:** the OpenAPI JSON is at `/api/openapi.json`.
- **Commit the schema.** Since every consumer is external, the OpenAPI document is the only
  contract they hold. Commit it and diff it in CI: a removed field or a narrowed type is a
  breaking change (see [`../testing/ADVANCED-TESTING.md`](../testing/ADVANCED-TESTING.md)).
- **The site does not consume this API.** Pages perform server operations through Django views over
  HTMX; adding a browser `fetch` to a Ninja endpoint means rendering HTML in the browser, which the
  stack exists to avoid (see [`./CLIENT-PATTERNS.md`](./CLIENT-PATTERNS.md)).

---

## API Documentation

- The API is self-documenting via the auto-generated OpenAPI page (disabled in production).
- Every endpoint has a `summary` and docstring; every schema field is typed and, where useful,
  described via `Field(description=...)`.
- Publish versioned API documentation separately from the live docs page.

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
</content>
</invoke>
