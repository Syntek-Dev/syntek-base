# code/src/mobile/src/graphql/fragments — GraphQL Fragments

Reusable field selections spread into queries and mutations to avoid repetition.

## Naming

- Fragment name: `<ModelName>Fields` — e.g. `UserFields`, `PostFields`
- File name: `<model-name>-fields.graphql` — e.g. `user-fields.graphql`

## Example shape

```graphql
fragment UserFields on UserType {
  id
  email
  displayName
  avatarUrl
}
```

## Rules

- Fragments must be declared on a concrete type, not an interface, unless the interface is returned directly by the schema
- Keep fragments focused — do not include every field; only what the consuming operation needs
- A fragment used by only one operation should be inlined into that operation's file instead

## Cross-references

- `code/src/mobile/src/graphql/CONTEXT.md` — GraphQL layer overview and codegen workflow
