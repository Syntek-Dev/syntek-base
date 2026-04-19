# code/src/mobile/src/graphql/mutations — GraphQL Mutations

Write operations sent to the backend. One `.graphql` file per mutation.

## Naming

- Operation name: imperative verb + noun — `CreatePost`, `UpdateProfile`, `DeleteComment`
- File name: kebab-case matching operation name — `create-post.graphql`, `update-profile.graphql`

## Example shape

```graphql
mutation UpdateProfile($input: UpdateProfileInput!) {
  updateProfile(input: $input) {
    ...UserFields
  }
}
```

## Rules

- Always use a typed `$input` variable — never inline scalar arguments directly in the mutation call
- Spread fragments for the return type rather than repeating field selections
- Optimistic updates and cache invalidation belong in the component, not the `.graphql` file

## Cross-references

- `code/src/mobile/src/graphql/CONTEXT.md` — GraphQL layer overview and codegen workflow
- `code/src/mobile/src/graphql/fragments/CONTEXT.md` — fragments to spread in return types
