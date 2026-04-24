# code/src/mobile/src/graphql — GraphQL Operations

Hand-written GraphQL operations consumed by the mobile app, plus auto-generated TypeScript types.

## Directory layout

```text
graphql/
├── fragments/   # Reusable field selections shared across queries and mutations
├── generated/   # Auto-generated types and hooks — never edit manually
├── mutations/   # GraphQL mutation documents
└── queries/     # GraphQL query documents
```

## Workflow

1. Write `.graphql` files in `fragments/`, `queries/`, or `mutations/`
2. Run codegen to regenerate `generated/`:

```bash
bash code/src/scripts/development/server.sh codegen:mobile
```

1. Import generated hooks in components — never import raw document nodes directly

## Conventions

- Fragment names: `<ModelName>Fields` — e.g. `UserFields`, `PostFields`
- Query names: `Get<Resource>` — e.g. `GetCurrentUser`, `GetPostList`
- Mutation names: imperative verb — e.g. `CreatePost`, `UpdateProfile`, `DeleteComment`
- One operation per file — filename matches the operation name in kebab-case: `get-current-user.graphql`

## Cross-references

- `code/src/mobile/src/graphql/generated/CONTEXT.md` — generated output, not for manual editing
- `code/src/backend/apps/core/schema.py` — Strawberry schema these operations target
