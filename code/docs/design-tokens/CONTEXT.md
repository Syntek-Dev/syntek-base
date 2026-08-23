# code/docs/design-tokens

Sub-documents for the DB-backed design-token system. The entry point is
`code/docs/DESIGN-TOKENS.md`, which carries the token-first law and links here for detail.

## Directory Tree

```text
code/docs/design-tokens/
├── CLAUDE.md  ← operating rules
├── CONTEXT.md ← this file
├── MODEL.md   ← `DesignToken` + `DesignTokenValue` models, 9 categories, `value_kind`, flags
├── CASCADE.md ← Six preference axes, justification rule, render cascade, Ninja delivery pipeline
├── EDITOR.md  ← `/admin/design-tokens` editor, governance, extension points, and known surface drift
└── MOBILE.md  ← The mobile bridge — six colour forms, gamut mapping, `render_tokens_ts()`, axis loss
```

## Cross-references

- `code/docs/DESIGN-TOKENS.md` — the index these sub-documents belong to, and the status of
  what they specify
