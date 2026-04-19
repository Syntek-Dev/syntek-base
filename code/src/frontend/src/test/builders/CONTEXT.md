# code/src/frontend/src/test/builders

Test data builder functions. Currently empty — add builder modules here as GraphQL types and
models are introduced.

## Naming Convention

| Pattern              | Example        | Exports                         |
| -------------------- | -------------- | ------------------------------- |
| `build<TypeName>.ts` | `buildUser.ts` | `buildUser(overrides?) => User` |

## Rules

- Builders accept a partial override object so tests only specify what they care about.
- Derive builder shapes from the generated GraphQL types in `src/graphql/generated/`.
- Never use raw object literals for multi-field types in tests — always use a builder.

## Cross-references

- `code/src/frontend/src/test/CONTEXT.md` — test infrastructure overview
- `code/src/frontend/src/graphql/generated/CONTEXT.md` — generated types used as builder inputs
