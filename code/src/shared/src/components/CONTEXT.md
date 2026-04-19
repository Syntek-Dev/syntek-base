# code/src/shared/src/components

Reusable UI components shared across pages and platform clients. Currently contains only the
barrel `index.ts` — component subdirectories are created on demand.

## Current Structure

```text
shared/src/components/
└── index.ts                 ← barrel export — re-export all components from here
```

## Planned Subdirectories (created on demand)

| Directory       | Purpose                                     |
| --------------- | ------------------------------------------- |
| `ui/`           | Base primitives: Button, Input, Card, Modal |
| `layout/`       | Structural: Container, Grid, Section        |
| `navigation/`   | Nav bars, breadcrumbs, sidebars             |
| `forms/`        | Form controls, field wrappers, validation   |
| `feedback/`     | Toasts, alerts, skeletons, loading spinners |
| `data-display/` | Tables, lists, badges, avatars, stat cards  |

## Rules

- Each component lives in its own file: `Button.tsx`.
- Unit test co-located: `Button.test.tsx` next to `Button.tsx`.
- Export every component from `index.ts` — consumers import from `@/shared/components`.
- Components must not import from `next/*` or any other framework-specific package.

## Cross-references

- `code/src/shared/CONTEXT.md` — shared library overview and platform portability rules
- `code/src/shared/src/CONTEXT.md` — src root overview
