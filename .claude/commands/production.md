---
description: Deploy to production environment
usage: /production
---

Build and deploy to the production environment.

**Run:** `./production.sh`

This script will:

1. Prompt for confirmation (safety check)
2. Run the full test suite (backend + frontend)
3. Generate GraphQL TypeScript types
4. Build Docker images with production configuration
5. Deploy to production environment

$ARGUMENTS
