# API Testing — Tool Setup & Promotion Flow

> **Agent hints — Model:** Sonnet · **MCP:** `docfork` + `context7` (Bruno CLI)

**Last Updated:** 24/04/2026 **Maintained By:** Syntek Studio **Language:** British English (en_GB)

---

## Overview

This document explains which API testing tools are used in each environment, why, and how they
interact with the promotion flow. Read this before suggesting changes to GraphQL tooling or
environment configuration.

---

## Tool Assignment by Environment

| Environment | Tool       | Introspection | Shared workspace |
| ----------- | ---------- | ------------- | ---------------- |
| Local       | GraphiQL   | On (DEBUG)    | No — per-dev     |
| Staging     | Hoppscotch | On (explicit) | Yes — team       |
| Production  | None       | Off           | N/A              |

### Local — GraphiQL

GraphiQL is served automatically by Strawberry when `DEBUG = True`. No installation, no
configuration — it is available at the GraphQL endpoint (`http://localhost:8000/graphql/`) as
soon as the dev stack is running.

It is intentionally ephemeral: no saved collections, no shared state. Its purpose is rapid
local iteration during development.

### Staging — Hoppscotch (self-hosted)

Hoppscotch runs as a self-hosted service on the staging/infra server (defined in `syntek-infra`,
not in this repo). It provides a persistent team workspace with saved collections, environment
variables, and request history.

The staging Hoppscotch instance is configured with:

- **GraphQL endpoint:** the staging `/graphql/` URL
- **Environment variable:** `Authorization: Bearer <token>` for authenticated requests
- **Introspection:** on — controlled by `GRAPHQL_INTROSPECTION=true` in staging settings

Collections on staging act as a living acceptance test suite. If a collection fails after a
deploy, it is caught before promotion to production.

### Production

No interactive API tooling is available in production. Introspection and GraphiQL are disabled.
`MaskErrors` is active. The only way to test production is via the staging Hoppscotch
collections after promotion.

---

## Promotion Flow

```text
Local dev  →  Staging  →  Production
(GraphiQL)    (Hoppscotch)
```

1. **Local** — developer tests the query or mutation in GraphiQL during implementation.
2. **Staging** — the change is deployed and verified against the shared Hoppscotch collections.
   If a collection request fails, the deploy does not proceed.
3. **Production** — only changes that pass staging Hoppscotch verification are promoted.

---

## Django Settings Implications

### Local (`config/settings/local.py`)

`DEBUG = True` is the only requirement. Strawberry serves GraphiQL automatically.

If a developer opens Hoppscotch in their browser and targets `http://localhost:8000/graphql/`,
the browser makes the request directly — this works, but requires the Hoppscotch server's
origin to be in `CORS_ALLOWED_ORIGINS`. Mixed-content errors (HTTPS Hoppscotch → HTTP localhost)
will block the browser request. This is a known limitation; use GraphiQL locally instead.

### Staging (`config/settings/staging.py`)

```python
GRAPHQL_INTROSPECTION = True   # enables schema explorer in Hoppscotch
DEBUG = False                  # MaskErrors active; GraphiQL served only if graphiql=True explicitly
```

`DisableIntrospection` must be toggled off via `GRAPHQL_INTROSPECTION`. See `API-DESIGN.md` —
Hardening at the consuming project root schema (INFO-005).

### Production (`config/settings/production.py`)

```python
GRAPHQL_INTROSPECTION = False
DEBUG = False
```

Both `DisableIntrospection` and `MaskErrors` are active. No interactive tooling.

---

## Hoppscotch Collections as Acceptance Tests

The Hoppscotch workspace on staging should contain one collection per domain area, mirroring
the GraphQL operation files in `shared/graphql/operations/`:

| Collection        | Mirrors                                      |
| ----------------- | -------------------------------------------- |
| Auth              | `shared/graphql/operations/auth.graphql`     |
| Tenancy           | `shared/graphql/operations/tenancy.graphql`  |
| (domain-specific) | `shared/graphql/operations/<domain>.graphql` |

When a new operation is added, a corresponding request must be added to the matching Hoppscotch
collection on staging before the story is marked complete.

---

## What Claude Should Not Do

- Do not add Hoppscotch as a Docker Compose service in this repo — it belongs in `syntek-infra`.
- Do not set `CORS_ALLOWED_ORIGINS = ["*"]` to fix Hoppscotch-to-localhost issues.
- Do not enable introspection in production to support tooling.
- Do not suggest GraphiQL for staging or production verification — use Hoppscotch collections.
