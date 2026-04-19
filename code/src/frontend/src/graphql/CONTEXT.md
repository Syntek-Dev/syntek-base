# code/src/frontend/src/graphql

GraphQL operation files and auto-generated TypeScript types. This directory is the source of
truth for all Apollo Client queries and mutations.

## Directory Tree

```text
frontend/src/graphql/
├── generated/               ← auto-generated TypeScript types and hooks (never edit)
│   └── .gitkeep
└── queries/                 ← .graphql query and mutation operation files
    └── .gitkeep
```

> `mutations/` and `fragments/` directories are created when the first mutation or shared
> fragment is written. Do not create empty placeholders.

## Workflow

1. Write a `.graphql` file in `queries/` (queries) or `mutations/` (mutations).
2. Regenerate `generated/` after any change:

   ```bash
   docker compose exec frontend pnpm run codegen
   ```

3. Import the generated hook in your component — never call Apollo directly.

## Conventions

- One `.graphql` file per operation or logical group.
- Naming: `GetUser.graphql`, `CreatePost.graphql`, `UserFragment.graphql`.
- Use the `@/graphql/generated` path alias — never use relative imports from `generated/`.
- Run codegen after any backend schema change before writing new frontend code.

## Cross-references

- `code/src/frontend/src/graphql/generated/CONTEXT.md` — generated output rules
- `code/src/frontend/src/graphql/queries/CONTEXT.md` — query file conventions
- `code/src/backend/apps/core/schema.py` — the backend schema that drives codegen
- `code/docs/API-DESIGN.md` — Apollo Client and GraphQL query conventions
