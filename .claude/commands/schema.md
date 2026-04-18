---
description: Generate or export the Strawberry GraphQL schema
usage: /schema
---

Work with the Strawberry GraphQL schema.

**Export schema:**
`docker compose exec backend python manage.py export_schema --path schema.graphql`

**View schema introspection:**
http://localhost:8000/graphql/ (GraphQL Playground)

**Regenerate frontend types after schema changes:**
`docker compose exec frontend npm run codegen`

**Schema Location:** `backend/apps/core/schema.py` (root schema)

$ARGUMENTS
