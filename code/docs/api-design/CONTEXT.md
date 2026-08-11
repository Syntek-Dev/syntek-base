# code/docs/api-design

Sub-documents for API design. Covers authentication, authorisation, rate limiting, auth-scheme selection, client patterns, Django Ninja conventions, REST/HTTP conventions, webhooks, event tracking, and API documentation.

## Directory Tree

```text
code/docs/api-design/
├── CLAUDE.md            ← operating rules
├── CONTEXT.md           ← this file
├── REST-CONVENTIONS.md  ← REST/HTTP naming and design conventions (the Ninja JSON API)
├── NINJA-CONVENTIONS.md ← Django Ninja router/schema naming and design conventions
├── AUTH-AND-ERRORS.md   ← Authentication, authorisation, and rate limiting
├── AUTH-STRATEGY.md     ← Choosing an auth scheme; JWT hardening; API-key lifecycle
├── WEBHOOKS.md          ← Secure outbound and inbound webhooks
├── EVENT-TRACKING.md    ← First-party engagement/CTR event ingestion
├── API-DOCS.md          ← Auto-generated OpenAPI docs and pre-release checklist
└── CLIENT-PATTERNS.md   ← Client-side consumption: HTMX partials, CSRF, errors, swaps
```

## Cross-references

- `code/docs/API-DESIGN.md` — the index these sub-documents belong to
