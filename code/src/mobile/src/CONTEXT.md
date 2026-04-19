# code/src/mobile/src — Mobile Source Root

Non-routing source code for the mobile app. All application logic, components, GraphQL, and utilities live here.

## Directory layout

```text
src/
├── components/   # Reusable React Native UI components
├── graphql/      # Queries, mutations, fragments, and generated types
├── lib/          # Apollo client, utilities, and shared hooks
└── test/         # Test utilities, builders, and shared fixtures
```

## Conventions

- Nothing in `src/` is a route — routes live in `../app/`
- Components here are reusable primitives; screen-specific components live alongside their screen in `../app/`
- All GraphQL operations must have generated types — never write raw query strings in components
- Path alias `@/*` maps to this directory — use `@/components/Button` not `../../components/Button`

## Cross-references

- `code/src/mobile/app/CONTEXT.md` — Expo Router screens that consume these components
- `code/src/shared/CONTEXT.md` — Cross-platform components available to both mobile and web
