# API Testing Guide

**Last Updated:** 30/04/2026 **Maintained By:** Syntek Studio **Language:** British English (en_GB)

---

## Overview

Three tools cover API testing at different layers:

| Tool       | Environment     | Purpose                                                          |
| ---------- | --------------- | ---------------------------------------------------------------- |
| GraphiQL   | Local           | Interactive schema exploration and manual query/mutation testing |
| Bruno      | Local + Staging | Automated `.bru` HTTP test suite — runs as part of `all.sh`      |
| Hoppscotch | Staging         | Shared team workspace for pre-promotion verification             |

GraphiQL and Bruno are complementary for local development. GraphiQL is for interactive
exploration — discovering the schema, writing queries by hand, debugging a resolver in the
moment. Bruno is the automated suite that verifies the real HTTP layer: Django middleware, CORS
headers, authentication headers, status codes, and response shape. pytest GraphQL tests use the
Strawberry `Client` and bypass HTTP entirely — Bruno is the only layer that catches HTTP-level
issues. Hoppscotch is for the staging environment where `graphiql` is disabled.

---

## Local Development — GraphiQL

GraphiQL is available automatically when the dev stack is running. No setup required.

**Access it:**

```text
http://localhost:8000/graphql/
```

Start the stack if it is not already running:

```bash
./code/src/scripts/development/server.sh up
```

### What you can do

- Write and run GraphQL queries and mutations
- Browse the schema via the built-in explorer (introspection is enabled in local dev)
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
verification — that is what Bruno (automated) and Hoppscotch (manual) are for.

---

## Bruno API Tests (Automated HTTP Layer)

Bruno `.bru` files test the GraphQL API over real HTTP, exercising the full Django
request/response cycle including middleware, authentication headers, CORS, and error formatting.
They live in `code/src/tests/api/`.

Full detail on assertions and collection authoring: `code/docs/TESTING.md §Bruno API Tests`.

### Collection structure

```text
code/src/tests/api/
├── CONTEXT.md
├── environments/
│   ├── local.env          ← BASE_URL=http://localhost:8000
│   └── staging.env        ← BASE_URL=https://staging.example.com
├── auth/
│   ├── login.bru          ← Login mutation — happy path + wrong password
│   ├── refresh.bru        ← RefreshToken mutation
│   └── me.bru             ← Me query — authenticated + unauthenticated
└── users/
    └── update-profile.bru
```

### Running Bruno tests

The dev stack must be running before executing the API test suite.

```bash
# Full collection against local dev stack
./code/src/scripts/tests/api.sh

# Single collection
./code/src/scripts/tests/api.sh --collection auth

# CI mode — outputs JUnit XML to code/src/scripts/reports/
./code/src/scripts/tests/api.sh --reporter junit
```

Bruno tests are included in `all.sh` — they run automatically as part of the standard pre-push
suite alongside the backend and frontend tests.

### What every `.bru` file must assert

- [ ] HTTP status code — `200` for GraphQL; `4xx` for malformed requests that fail before the resolver
- [ ] `Content-Type: application/json` header present
- [ ] `data` shape — required fields present and correctly typed on the happy path
- [ ] `errors` absent on the happy path
- [ ] `errors` present and correctly shaped on all failure paths
- [ ] Authentication failure returns a structured GraphQL error — not a Django 403 HTML page

### Adding a new `.bru` file

Every new GraphQL mutation or query must have a matching `.bru` file before the story is closed
(Rule 18 in `code/docs/TESTING.md`). This is the authoritative proof the API works over real
HTTP — pytest GraphQL tests alone do not cover this.

1. Create the `.bru` file in the matching collection directory (e.g. `auth/` for auth operations)
2. Use the `local.env` environment for development
3. Cover at least: happy path, unauthenticated request, and one invalid input case
4. Run `./code/src/scripts/tests/api.sh --collection <name>` to verify before committing

### Difference from pytest GraphQL tests

| Concern                         | pytest (Strawberry `Client`) | Bruno (HTTP)                   |
| ------------------------------- | ---------------------------- | ------------------------------ |
| Schema logic                    | Yes                          | Yes (indirectly)               |
| Django middleware               | No                           | Yes                            |
| CORS and authentication headers | No                           | Yes                            |
| Real HTTP status codes          | No                           | Yes                            |
| Response content-type headers   | No                           | Yes                            |
| Suitable for smoke tests        | No                           | Yes (runs against any env URL) |

Both are required — they test different things.

---

## Staging — Hoppscotch

Hoppscotch is a self-hosted team workspace running on the staging server. It is the shared
source of truth for manual API verification before promotion to production, and complements the
automated Bruno suite.

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

This keeps the Hoppscotch workspace in sync with the codebase and ensures future deploys can be
verified against the same set of requests.

---

## Production

There is no interactive API tooling in production. Introspection is disabled and error details
are masked. If you need to investigate a production issue, reproduce it locally or on staging.

---

## Promotion Flow

```text
Local dev                      Staging                     Production
(GraphiQL + Bruno local.env)   (Bruno staging.env + Hoppscotch)
```

A change is ready to promote when:

- [ ] Tested locally in GraphiQL — query returns the expected shape
- [ ] Bruno suite passes against `local.env` — `./code/src/scripts/tests/api.sh`
- [ ] `.bru` file added for every new mutation or query
- [ ] Deployed to staging and Bruno passes against `staging.env`
- [ ] Verified in Hoppscotch — all relevant collection requests pass with no regressions

Only changes that pass every layer are promoted to production.

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

This is a known limitation. Use GraphiQL for local testing and Hoppscotch for staging only.

### Bruno reports a 403 HTML page instead of a GraphQL error

Django returned an HTML error before the request reached the GraphQL resolver — usually a CSRF
or CORS misconfiguration. Check `CORS_ALLOWED_ORIGINS` in the active settings file and confirm
the `Authorization` header is set correctly in the Bruno environment file.

### Bruno `api.sh` fails with "connection refused"

The dev stack is not running. Start it first:

```bash
./code/src/scripts/development/server.sh up
```
