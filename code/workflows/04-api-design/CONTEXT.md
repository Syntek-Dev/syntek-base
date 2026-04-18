# Workflow: GraphQL API Design

## Directory Tree

```text
code/workflows/04-api-design/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when adding or modifying the Strawberry GraphQL schema —
new types, queries, mutations, or subscriptions.

## Prerequisites

- [ ] Data model is agreed and documented
- [ ] `code/docs/API-DESIGN.md` has been read
- [ ] Django backend containers are running

## Key concepts

- Types defined in `apps/<app>/types.py`
- Queries and mutations defined in `apps/<app>/schema.py`
- Root schema aggregated in `apps/core/schema.py`
- Business logic delegated to `apps/<app>/services.py` — resolvers stay thin
- After schema changes, always run `pnpm codegen` to regenerate frontend types

## Cross-references

- `code/docs/API-DESIGN.md` — GraphQL and REST conventions
- `code/docs/SECURITY.md` — mutation permission requirements
