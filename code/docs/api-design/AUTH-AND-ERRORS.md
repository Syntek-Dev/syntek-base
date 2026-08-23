---
type: guide
skills: [backend, stack-django]
model: opus
---

# API Design — Authentication, Authorisation, Errors, and Rate Limiting

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — API auth transport, authorisation, rate limiting, and error response conventions

---

## Authentication and Authorisation in APIs

This covers the **transport** of credentials on the Django Ninja JSON API. The **choice** of scheme
(session vs opaque token vs JWT) belongs to [`./AUTH-STRATEGY.md`](./AUTH-STRATEGY.md).

### Token / session authentication (Django Ninja)

- A same-origin caller authenticates with the **Django session cookie** — Ninja's `django_auth` /
  a `SessionAuth` class reads `request.user`. CSRF applies (`csrf=True` on the `NinjaAPI`).
- For token-bearing callers, use short-lived opaque tokens (or JWTs) in the
  `Authorization: Bearer <token>` header, validated by a Ninja `HttpBearer` auth class.
- When an opaque token is stored in the browser, use `httpOnly` Secure cookies, never `localStorage`.
  See [`../security/CRYPTO-AND-DATA.md`](../security/CRYPTO-AND-DATA.md) — Browser Storage Policy.
- Tokens are validated on every request. Do not cache authentication decisions.
- Return `401` for missing or invalid credentials. Return `403` for valid credentials without
  sufficient permissions.

### API key authentication

- For service-to-service communication or third-party integrations, use API keys.
- API keys are sent in the `X-API-Key` header (a Ninja `APIKeyHeader` auth class), not in query
  parameters (query parameters appear in logs and browser history).
- Each API key has a defined scope and rate limit.

### Authorisation

- Every endpoint checks authorisation, not just authentication — a per-endpoint permission check on
  every state-changing endpoint.
- Scope all queries to the authenticated user or tenant. See
  [`../security/AUTH-AND-AUTHZ.md`](../security/AUTH-AND-AUTHZ.md) for IDOR prevention rules.
- Return `403` with a generic message. Do not reveal whether a resource exists if the user is not
  authorised to see it — use `404` instead of `403` where appropriate to prevent enumeration.

---

## The error envelope

**This guide owns the JSON API's error contract.** Every other guide routes here rather than
restating it — the rule lived in four places once, and they disagreed.

Every error response from `/api/`, without exception:

```json
{
  "error": {
    "code": "validation_failed",
    "message": "The request contained invalid fields.",
    "details": [{ "field": "address.postcode", "message": "This field is required." }]
  }
}
```

- `error.code` — machine-readable, **lowercase `snake_case`**. The same casing as an invariant
  register key, so every machine-readable error identifier in this project reads alike.
- `error.message` — one human-readable sentence. Never a stack trace, file path, SQL
  fragment, or internal exception text.
- `error.details` — optional, and only for field-level validation. `field` is the **full dotted
  path** to the failing input, so a nested schema reports `address.postcode` rather than a bare
  `postcode` that names two different fields on the same request.

**There is no request identifier in the body.** `X-Request-ID` is a response header on every
request, because a rendered 500 page has no JSON body and the correlation has to hold on every
surface. See [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) — _What each class looks like from
outside_.

### Success responses are not wrapped

A success response **is** its `OutSchema`, and a paginated collection is Ninja's own pagination
shape. There is no `{"data": ...}` envelope.

This is not an inconsistency with the rule above, it is the principle behind both:

> **Diverge from the framework where the divergence buys something. Stay native where it does
> not.**

The error envelope buys a machine-readable `code` that Ninja has no equivalent for, and it is
worth the six handlers below. A success wrapper buys nothing and costs OpenAPI accuracy: Ninja
generates the schema from the declared `response=`, so a renderer that wraps the body at the last
moment makes `/api/docs` describe a payload the API does not send.

### All six handlers, or the envelope is a fiction

Django Ninja registers **six** default exception handlers, and each one emits its own native
shape. Overriding only the obvious two leaves `401`, `403`, `404` and every `raise HttpError(...)`
answering in a different format from the same API.

| Ninja exception       | Status    | `error.code`              |
| --------------------- | --------- | ------------------------- |
| `AuthenticationError` | 401       | `authentication_required` |
| `AuthorizationError`  | 403       | `permission_denied`       |
| `ValidationError`     | 422       | `validation_failed`       |
| `HttpError`           | as raised | derived from status       |
| `Http404`             | 404       | `not_found`               |
| `Exception`           | 500       | `internal_error`          |

```python
from ninja.errors import ValidationError


@api.exception_handler(ValidationError)
def on_validation_error(request, exc):
    details = [
        {"field": ".".join(str(part) for part in error["loc"][1:]), "message": error["msg"]}
        for error in exc.errors
    ]
    return api.create_response(
        request,
        {
            "error": {
                "code": "validation_failed",
                "message": "The request contained invalid fields.",
                "details": details,
            }
        },
        status=422,
    )
```

`loc[1:]` drops Pydantic's leading location segment (`body`, `query`) and joins the rest, which is
what makes `address.postcode` come out whole.

### Where `error.code` comes from

The service layer already carries it. `ServiceError` and its subclasses declare a `code`
attribute ([`../architecture/SERVICE-AND-MIDDLEWARE.md`](../architecture/SERVICE-AND-MIDDLEWARE.md)
— _Service Exception Hierarchy_), and the handler copies it straight onto the wire. A new service
error subclass therefore needs no handler change.

**`InvariantViolation` is the exception to that.** It is a programmer error, so it surfaces as a
generic `internal_error` 500 whose `message` says nothing specific: its register key goes to the
error tracker, never to the caller. The taxonomy behind that split is owned by
[`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) — _The error taxonomy_, not here.

### Not yet built

`config/api.py` does not exist in the base template, so no handler ships. The contract above is
the specification the first endpoint story implements, in the same change as the router it
serves. `audits/doctrine-drift.sh` guards the **doctrine** against re-splitting in the meantime;
the runtime check that all six handlers are registered ships with `config/api.py`.

---

## Rate Limiting

All APIs must be rate limited to prevent abuse and protect infrastructure.

### Default limits

| Endpoint type                                    | Limit        | Window   |
| ------------------------------------------------ | ------------ | -------- |
| Authentication (login, register, password reset) | 5 requests   | 1 minute |
| Standard API (authenticated)                     | 60 requests  | 1 minute |
| Search / heavy queries                           | 20 requests  | 1 minute |
| Webhooks (inbound)                               | 100 requests | 1 minute |
| Public / unauthenticated                         | 30 requests  | 1 minute |

### Response headers

Include rate limit information in every response:

```text
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1710500000
```

When the limit is exceeded, return `429 Too Many Requests` with a `Retry-After` header.

### Implementation

**Django Ninja throttling** — attach throttle classes per-router or per-endpoint via `throttle=`,
backed by the Valkey cache. Blanket per-IP / per-user limits also run as HTTP middleware (see
[`./NINJA-CONVENTIONS.md`](./NINJA-CONVENTIONS.md) — Rate Limiting: Two Independent Mechanisms).

```python
from ninja.throttling import AuthRateThrottle, AnonRateThrottle


# Per-endpoint: a stricter cap on an expensive search endpoint
@router.get("/orders/search", throttle=[AuthRateThrottle("20/min"), AnonRateThrottle("5/min")])
def search_orders(request, q: str): ...


# Or a NinjaAPI-wide default
api = NinjaAPI(throttle=[AuthRateThrottle("60/min"), AnonRateThrottle("30/min")])
```

---

## API Testing Tools

The Ninja JSON API is exercised with standard HTTP tooling — curl, HTTPie, Bruno, or the built-in Swagger UI.

### Built-in OpenAPI docs — zero-config

Django Ninja serves an interactive Swagger UI automatically. It is gated on an explicit setting so it
is available in local/dev and off in production.

```python
# config/api.py
from django.conf import settings
from ninja import NinjaAPI

api = NinjaAPI(docs_url="/docs" if settings.API_DOCS_ENABLED else None)
# urls.py: path("api/", api.urls)  → docs at /api/docs, raw schema at /api/openapi.json
```

**Disable in production:** the docs page and the raw OpenAPI schema must be off in production. Set
`API_DOCS_ENABLED=False` (its default outside local); do not rely on `DEBUG` alone.

### Bruno — the committed integration collection

The repository's API integration tests live in a Bruno collection (`code/src/tests/`). Bruno stores
requests as plain files in version control, so the collection is reviewed and run alongside the code.

### Hoppscotch — self-hosted REST workspace

Full API testing workspace covering REST, WebSocket, and SSE with shared collections, environments,
and history. Self-hostable on your own server.

### Summary

| Tool          | Protocol  | Self-hosted        | Best for                           |
| ------------- | --------- | ------------------ | ---------------------------------- |
| Ninja docs    | REST/JSON | Built-in (setting) | Local exploration, schema browsing |
| Bruno         | REST/JSON | Yes (in repo)      | Committed integration tests        |
| Hoppscotch    | REST/JSON | Yes (Docker)       | Team server, shared collections    |
| `curl`/HTTPie | REST/JSON | n/a                | Quick one-off request checks       |

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
