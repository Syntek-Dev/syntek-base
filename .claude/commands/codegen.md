---
description: Generate TypeScript types from the Strawberry GraphQL schema
usage: /codegen
---

Generate TypeScript types and Apollo hooks from the Django Strawberry schema.

**One-time:** `docker compose exec frontend npm run codegen`
**Watch mode:** `docker compose exec frontend npm run codegen:watch`

**Prerequisites:**

- Django backend must be running with introspection enabled
- Schema endpoint: http://localhost:8000/graphql/

**Output:** `frontend/src/graphql/generated/`

$ARGUMENTS
