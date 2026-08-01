---
type: guide
agent: backend
skills: [stack-django]
model: opus
---

# API Design

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Django Ninja JSON API contract conventions, auth, webhooks, client patterns

Django Ninja is the project's first-party JSON API (`NinjaAPI` mounted at `/api/`, auto OpenAPI at
`/api/docs`). This guide covers its conventions plus the shared REST/HTTP contract, auth, webhooks,
and how clients consume it. An API is a contract — changes affect every consumer.
Design it carefully, document it explicitly, and change it deliberately.

## Sub-documents

| Document                                                             | Covers                                                                                                                                         |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [`api-design/REST-CONVENTIONS.md`](api-design/REST-CONVENTIONS.md)   | URL structure, HTTP methods, status codes, request/response shapes, pagination, filtering, versioning                                          |
| [`api-design/NINJA-CONVENTIONS.md`](api-design/NINJA-CONVENTIONS.md) | Django Ninja `Router`/`api.py` module rule, Schema request/response models, per-endpoint auth, exception handlers, throttling, auto OpenAPI    |
| [`api-design/AUTH-AND-ERRORS.md`](api-design/AUTH-AND-ERRORS.md)     | Bearer/`X-API-Key` transport, authorisation, `401` vs `403`, rate limiting defaults, Ninja throttling, API testing tools                       |
| [`api-design/AUTH-STRATEGY.md`](api-design/AUTH-STRATEGY.md)         | Choosing an auth scheme — session vs opaque token+secret vs JWT — Django Ninja primary; DRF/FastAPI portable; JWT hardening; API-key lifecycle |
| [`api-design/WEBHOOKS.md`](api-design/WEBHOOKS.md)                   | Secure outbound + inbound webhooks — HMAC signing, replay protection, idempotency, framework receivers                                         |
| [`api-design/EVENT-TRACKING.md`](api-design/EVENT-TRACKING.md)       | First-party engagement/CTR event ingestion complementing Plausible; ingestion API shape and privacy                                            |
| [`api-design/API-DOCS.md`](api-design/API-DOCS.md)                   | Auto-generated Ninja OpenAPI at `/api/docs`; pre-release API checklist                                                                         |
| [`api-design/CLIENT-PATTERNS.md`](api-design/CLIENT-PATTERNS.md)     | How the browser consumes the server: HTMX partials, CSRF, errors, swaps                                                                        |

_Part of the `code/docs/` documentation family._
