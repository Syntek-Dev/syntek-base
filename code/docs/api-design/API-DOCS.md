---
type: guide
skills: [backend, stack-django]
model: opus
---

# API Design — API Documentation

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — auto-generated Django Ninja OpenAPI documentation, pre-release API checklist

---

Webhook design — outbound payloads, HMAC signing, and inbound verification — is documented
separately in [`WEBHOOKS.md`](WEBHOOKS.md).

## API Documentation

Django Ninja generates the OpenAPI 3.x schema and an interactive Swagger UI **automatically** from
the endpoint type hints and `Schema` models, so the documentation always tracks the code without a
separate generation step to keep in sync.

- The interactive docs are hosted at `/api/docs`; the raw OpenAPI JSON is at `/api/openapi.json`.
- Both are gated on an explicit setting so they are available in local/dev and **off in production**.
- Every endpoint carries a `summary` and a docstring; every schema field is typed and, where useful,
  described via `Field(description=...)`. These flow straight into the OpenAPI page.
- Document error responses with the same detail as success responses — declare them in the
  `response=` map (e.g. `response={200: OrderOut, 404: NotFoundOut}`).

```python
# config/api.py — one NinjaAPI, docs gated on a setting
from django.conf import settings
from ninja import NinjaAPI

api = NinjaAPI(
    title="<%PROJECT_NAME%> API",
    version="1.0.0",
    docs_url="/docs" if settings.API_DOCS_ENABLED else None,
)
# urls.py:  path("api/", api.urls)   → docs at /api/docs, schema at /api/openapi.json
```

**Disable in production:** set `API_DOCS_ENABLED=False` (its default outside local). Do not rely on
`DEBUG` alone — a project accidentally deployed with `DEBUG=True` must still not expose its schema.

Publish versioned API documentation separately from the live docs page for external consumers.

---

## API Design Checklist

Before releasing any API endpoint:

- [ ] URL follows REST conventions (plural nouns, no verbs, correct HTTP methods)
- [ ] Response uses the standard envelope (`{ "data": ... }` or `{ "data": [...], "meta": ... }`)
- [ ] Error responses use the standard format (`{ "error": { "code": ..., "message": ... } }`)
- [ ] Correct HTTP status codes are used for success and error cases
- [ ] Authentication is required (or the endpoint is explicitly documented as public)
- [ ] Authorisation checks scope data to the authenticated user/tenant
- [ ] Every state-changing endpoint has an explicit permission check (no IDOR)
- [ ] Pagination is implemented for all collection endpoints
- [ ] Rate limiting / throttling is configured
- [ ] Dates are in ISO 8601 UTC format
- [ ] Monetary values are strings, not floats
- [ ] No internal details (stack traces, SQL, file paths) are leaked in error responses
- [ ] The endpoint is defined on a module `Router` and wired onto the single `NinjaAPI`
- [ ] Request and response `Schema` models are declared (typed, described) so OpenAPI is complete
- [ ] The endpoint appears correctly in `/api/docs` with its `summary` and schemas
- [ ] Exception handlers are registered so validation and errors return the standard envelope
- [ ] The docs page and raw schema are disabled in production (`API_DOCS_ENABLED=False`)
- [ ] The endpoint has integration tests covering happy path, auth failure, and validation failure

_Part of the `code/docs/` documentation family. See [`../API-DESIGN.md`](../API-DESIGN.md) for the full index._
</content>
