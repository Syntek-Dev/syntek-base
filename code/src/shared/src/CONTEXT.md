# code/src/shared/src

Source root for the shared component library. Contains reusable React components, hooks,
utilities, and types consumed by `code/src/frontend/` and future platform clients.

## Current Structure

```text
shared/src/
├── components/              ← reusable UI components
│   └── index.ts             ← barrel export for all components
└── index.ts                 ← package entry point — re-exports the full public API
```

> Additional directories (`hooks/`, `utils/`, `types/`, `styles/`) are created on demand —
> only when the first file in that category is added.

## Conventions

- `index.ts` is the public API. Only its exports are guaranteed stable for consumers.
- Never import from internal paths in consumer code — always use the `@/shared` alias.
- Add directories only when the first file in a category is created; no empty placeholders.

## Cross-references

- `code/src/shared/CONTEXT.md` — full shared library overview and portability rules
- `code/src/shared/src/components/CONTEXT.md` — component directory detail
