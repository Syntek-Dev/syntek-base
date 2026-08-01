# code/docs/design-tokens

**Claude Model:** opus — Design-token deep specification: models, preference cascade, editor, governance

Sub-documents for the DB-backed design-token system. The entry point is
`code/docs/DESIGN-TOKENS.md`, which carries the token-first law and links here for detail.

## Files

| File         | Purpose                                                                              |
| ------------ | ------------------------------------------------------------------------------------ |
| `MODEL.md`   | `DesignToken` + `DesignTokenValue` models, 9 categories, `value_kind`, flags         |
| `CASCADE.md` | Six preference axes, justification rule, render cascade, Ninja delivery pipeline     |
| `EDITOR.md`  | `/admin/design-tokens` editor, governance, extension points, and known surface drift |

Parent guide: `code/docs/DESIGN-TOKENS.md`
Live app: `code/src/django/apps/design_tokens/CONTEXT.md`
