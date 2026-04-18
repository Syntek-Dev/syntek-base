---
description: Deploy to staging environment
usage: /staging
---

Build and deploy to the staging environment.

**Run:** `./staging.sh`

This script will:

1. Run the full test suite (backend + frontend)
2. Generate GraphQL TypeScript types
3. Build Docker images with staging configuration
4. Deploy to staging environment

$ARGUMENTS
