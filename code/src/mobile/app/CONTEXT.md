# code/src/mobile/app — Expo Router Screens

File-based routing root. Every `.tsx` file here is a route; every `_layout.tsx` is a layout wrapper.

## Conventions

| Pattern | Purpose |
|---|---|
| `_layout.tsx` | Layout wrapper for the current segment and its children |
| `index.tsx` | Index screen for the current segment |
| `(group)/` | Route group — groups screens under a shared layout without affecting the URL |
| `[param].tsx` | Dynamic segment — `[id].tsx` exposes `params.id` via `useLocalSearchParams()` |

## Root layout

`_layout.tsx` at this level is the root layout. It:
- Imports `../global.css` to activate NativeWind
- Conditionally renders `StorybookUI` when `EXPO_PUBLIC_STORYBOOK_ENABLED=true` in dev
- Otherwise renders `<Slot />` (Expo Router's outlet)

## Cross-references

- `code/src/mobile/CONTEXT.md` — full mobile stack and conventions
- `code/src/mobile/src/components/CONTEXT.md` — screen-specific components
- `code/src/mobile/src/lib/CONTEXT.md` — Apollo provider and shared utilities
