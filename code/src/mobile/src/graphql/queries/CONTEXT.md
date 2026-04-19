# code/src/mobile/src/graphql/queries — GraphQL Queries

Read operations sent to the backend. One `.graphql` file per query.

## Naming

- Operation name: `Get<Resource>` — `GetCurrentUser`, `GetPostList`, `GetPostDetail`
- File name: kebab-case matching operation name — `get-current-user.graphql`

## Example shape

```graphql
query GetCurrentUser {
  currentUser {
    ...UserFields
  }
}
```

## Rules

- Spread fragments for all return types — do not duplicate field selections across query files
- Pagination queries must accept `$cursor` and `$limit` variables
- Avoid deeply nested queries; prefer separate queries for nested data fetched on demand

## Cross-references

- `code/src/mobile/src/graphql/CONTEXT.md` — GraphQL layer overview and codegen workflow
- `code/src/mobile/src/graphql/fragments/CONTEXT.md` — fragments to spread in return types
