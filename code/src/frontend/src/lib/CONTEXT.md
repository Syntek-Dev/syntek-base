# code/src/frontend/src/lib

Shared utility modules and provider wrappers for the Next.js frontend.

## Current Files

| File                 | Purpose                                                        |
| -------------------- | -------------------------------------------------------------- |
| `apollo-wrapper.tsx` | `ApolloClient` instance and `ApolloProvider` wrapper component |

## Conventions

- `lib/` holds singleton clients, provider wrappers, and pure utility functions used across
  multiple pages or components.
- Files here must not contain page-specific business logic.
- Client components (those needing browser APIs or React state) must declare `"use client"`.
- Pure utility functions (no React imports) go in `utils.ts` or a named module.

## Apollo Client

`apollo-wrapper.tsx` creates a single `ApolloClient` with:

- `HttpLink` pointing to `NEXT_PUBLIC_GRAPHQL_URL` (defaults to `/graphql/`).
- `InMemoryCache` for query caching.

The `ApolloWrapper` component is imported in `src/app/layout.tsx` to provide Apollo context to
all client components.

## Cross-references

- `code/src/frontend/src/CONTEXT.md` — src tree overview
- `code/src/frontend/src/graphql/CONTEXT.md` — GraphQL operations
- `code/src/backend/config/urls.py` — GraphQL endpoint (`/graphql/`)
