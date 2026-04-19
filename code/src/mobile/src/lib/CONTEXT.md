# code/src/mobile/src/lib — Utilities and Providers

Apollo Client setup, shared hooks, and utility functions used across the mobile app.

## Expected files

| File | Purpose |
|---|---|
| `apollo.ts` | Apollo Client instance with AsyncStorage persistence |
| `ApolloProvider.tsx` | React provider wrapping the app with the Apollo Client |
| `useAuth.ts` | Authentication state hook |

## Apollo setup

The Apollo Client for mobile uses `@react-native-async-storage/async-storage` for cache persistence across app restarts. The client is initialised once in `apollo.ts` and provided to the component tree via `ApolloProvider.tsx`.

## Rules

- One concern per file — do not mix Apollo setup with authentication logic
- Hooks must be prefixed `use` and export a single default value
- No component rendering in this directory — providers only wrap children, they do not render UI

## Cross-references

- `code/src/mobile/app/CONTEXT.md` — `_layout.tsx` imports `ApolloProvider` from here
- `code/src/shared/src/lib/CONTEXT.md` — cross-platform utilities shared with the web frontend
