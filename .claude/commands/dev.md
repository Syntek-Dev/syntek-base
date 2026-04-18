---
description: Start the full-stack development environment
usage: /dev
---

Start the Syntek Website full-stack development environment (Django + Next.js).

**Run:** `./dev.sh`

This script will:

1. Start Docker Compose with development configuration
2. Wait for the PostgreSQL database to be ready
3. Run any pending Django migrations
4. Display access URLs

**Access:**

- Frontend (Next.js): http://localhost:3000
- GraphQL Playground: http://localhost:8000/graphql/
- Django Admin: http://localhost:8000/admin/

$ARGUMENTS
