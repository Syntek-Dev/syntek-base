# code/src/frontend/src/graphql/queries

GraphQL `.graphql` operation files. GraphQL Code Generator reads these and produces typed hooks
in `../generated/`.

## Naming Conventions

| Pattern                    | Example              | Use for                                                  |
| -------------------------- | -------------------- | -------------------------------------------------------- |
| `Get<Resource>.graphql`    | `GetUser.graphql`    | Single-resource queries                                  |
| `List<Resource>.graphql`   | `ListPosts.graphql`  | List / paginated queries                                 |
| `<Verb><Resource>.graphql` | `CreatePost.graphql` | Mutations (place in mutations/ when that dir is created) |

## Rules

- One `.graphql` file per operation or logical group.
- All operations must be named — anonymous operations fail codegen.
- Shared fragments belong in a `fragments/` directory (create when the first is written).
- After adding or editing a `.graphql` file, run codegen before using the generated hook.

## Cross-references

- `code/src/frontend/src/graphql/CONTEXT.md` — GraphQL directory overview and codegen workflow
- `code/docs/API-DESIGN.md` — Apollo Client and GraphQL query conventions
