# API Testing Guide

**Last Updated:** 24/04/2026 **Maintained By:** Syntek Studio **Language:** British English (en_GB)

---

## Overview

This project uses two API testing tools depending on the environment:

| Environment | Tool       | URL                                |
| ----------- | ---------- | ---------------------------------- |
| Local       | GraphiQL   | `http://localhost:8000/graphql/`   |
| Staging     | Hoppscotch | Configured by your team lead       |
| Production  | None       | No interactive tooling — by design |

---

## Local Development — GraphiQL

GraphiQL is available automatically when the dev stack is running. No setup required.

**Access it:**

```text
http://localhost:8000/graphql/
```

Open this URL in your browser after starting the stack:

```bash
./code/src/scripts/development/server.sh up
```

### What you can do

- Write and run GraphQL queries and mutations
- Browse the schema via the built-in explorer (introspection is on in local dev)
- Pass variables in the Variables panel
- Set request headers (e.g. `Authorization: Bearer <token>`) in the Headers panel

### Authenticated requests

Most queries and mutations require authentication. To test with a real token:

1. Log in via the frontend at `http://localhost:3000` with a dev account
2. Copy the access token from the browser (DevTools → Application → Local Storage, or from the
   GraphQL login mutation response)
3. In GraphiQL, open the **Headers** panel and add:

```json
{
  "Authorization": "Bearer <your-token-here>"
}
```

### GraphiQL is local-only

GraphiQL is disabled in staging and production. Do not rely on it for cross-environment
verification — that is what Hoppscotch is for.

---

## Staging — Hoppscotch

Hoppscotch is a self-hosted team workspace running on the staging server. It is the shared
source of truth for API verification before promotion to production.

Your team lead will provide:

- The Hoppscotch URL
- A team invite link to the shared workspace
- A staging access token to add to your environment variables

### Using the shared workspace

1. Open the Hoppscotch URL in your browser and sign in
2. Navigate to **Collections** — there is one collection per domain area (Auth, Tenancy, etc.)
3. Select the **Staging** environment from the environment picker
4. Run the requests in the relevant collection to verify your changes

### Adding a new request

When you add a new GraphQL operation to the codebase, add a matching request to the Hoppscotch
collection on staging before closing the story:

1. Open the matching collection (e.g. **Auth** for authentication operations)
2. Create a new request with the operation name as the request name
3. Set the method to **POST** and the URL to the staging GraphQL endpoint
4. Paste the operation into the **Body** tab (GraphQL mode)
5. Add any required variables
6. Save the request to the collection

This keeps the Hoppscotch workspace in sync with the codebase and ensures future deploys can
be verified against the same set of requests.

---

## Promotion Flow

```text
Local dev  →  Staging  →  Production
(GraphiQL)    (Hoppscotch)
```

A change is ready to promote when:

- [ ] Tested locally in GraphiQL — query returns the expected shape
- [ ] Deployed to staging and verified in Hoppscotch — all relevant collection requests pass
- [ ] No regressions in existing Hoppscotch collection requests

Only changes that pass both layers are promoted to production.

---

## Production

There is no interactive API tooling in production. Introspection is disabled and error details
are masked. If you need to investigate a production issue, reproduce it locally or on staging.

---

## Common Issues

### "Introspection is disabled" in Hoppscotch

This means you are pointing Hoppscotch at the production endpoint, or staging introspection is
turned off. Confirm you have the **Staging** environment selected, not Production.

### GraphiQL shows a blank screen or "Cannot query field"

The dev stack may not be running, or the schema has changed and the browser has a stale cache.
Restart the stack and hard-refresh the browser (`Ctrl+Shift+R` / `Cmd+Shift+R`).

### 401 Unauthorized in GraphiQL

Your token has expired. Log in again via the frontend and copy the new token into the GraphiQL
Headers panel.

### CORS error when pointing Hoppscotch at localhost

This is a known limitation — see `how-to/docs/API-TESTING.md`. Use GraphiQL for local testing
and Hoppscotch for staging only.
