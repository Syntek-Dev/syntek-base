# code/src/shared

Shared UI component library for the Syntek website. Components here are used across multiple pages and are designed to be platform-portable — the same component tree powers the Next.js web app today and can be consumed by a React Native mobile app in the future.

## Purpose

- Centralise components used in more than one page to avoid duplication.
- Enforce a consistent design language (Tailwind CSS tokens, spacing, typography).
- Decouple presentational logic from page-level routing concerns so components remain portable.
- Serve as the single source of truth for the Syntek design system at the component level.

## Directory tree

```text
code/src/shared/
├── CONTEXT.md              ← this file
├── components/             ← reusable UI primitives and composite components
│   ├── ui/                 ← base primitives (Button, Input, Card, Modal, …)
│   ├── layout/             ← structural wrappers (Container, Grid, Section, …)
│   ├── navigation/         ← nav bars, breadcrumbs, sidebars, tab groups
│   ├── forms/              ← form controls, field wrappers, validation messages
│   ├── feedback/           ← toasts, alerts, skeletons, loading spinners
│   └── data-display/       ← tables, lists, badges, avatars, stat cards
├── hooks/                  ← framework-agnostic custom React hooks
├── utils/                  ← pure helper functions (formatting, validation, dates)
├── types/                  ← shared TypeScript interfaces and type utilities
└── styles/                 ← global CSS tokens and Tailwind config extensions
```

> Directories are created on demand — only add a folder when the first file in that category is added. Do not create empty placeholders.

## Rules

### What belongs here

- Any React component used in two or more pages or layouts.
- Hooks that are not tightly coupled to a single page's data shape.
- Pure utility functions with no Next.js or React Native import dependencies.
- TypeScript types shared across the frontend and any future mobile client.

### What does NOT belong here

- Page components (`app/` directory stays in `code/src/frontend/src/app/`).
- GraphQL queries, mutations, or generated hooks (those stay in `code/src/frontend/src/graphql/`).
- Server components that rely on Next.js-specific APIs (`headers()`, `cookies()`, `fetch` with `cache`).
- One-off components only needed by a single page — keep those co-located.

## Platform portability

Components in `components/ui/`, `components/layout/`, `components/forms/`, and `components/feedback/` must not import from `next/*`, `next/navigation`, `next/image`, or any other framework-specific package. Use an adapter pattern or props injection to pass framework-specific behaviour in from the consuming app.

Hooks in `hooks/` must not depend on Next.js APIs. If a hook needs routing awareness, accept a callback prop rather than calling `useRouter()` directly.

## Styling

All styling uses **Tailwind CSS 4.2** utility classes. Avoid inline styles and CSS Modules inside shared components — they do not port cleanly to React Native. When a component needs a design token (colour, spacing, radius), define it in `styles/` and reference it via the Tailwind config.

## Testing

- Unit tests for shared components live alongside their source file: `Button.test.tsx` next to `Button.tsx`.
- Tests run as part of the frontend Vitest suite (`frontend.sh` / `frontend-coverage.sh`).
- Coverage floor: 70% line and branch (inherited from the frontend threshold in `vitest.config.ts`).

## Storybook

Story files live alongside their component: `Button.stories.tsx` next to `Button.tsx`.

Both Storybook instances discover stories automatically:

- **Web** (`frontend/` Storybook): picks up `shared/src/**/*.stories.tsx`
- **Mobile** (`mobile/` Storybook): picks up `shared/src/**/*.stories.tsx`

When a shared component has platform-specific variants (`.web.tsx` / `.native.tsx`), the same
`*.stories.tsx` file works for both — Metro resolves the `.native.tsx` variant on mobile and
the `.web.tsx` variant in the browser automatically.

## Consuming in Next.js

```typescript
import { Button } from "@/shared/components/ui/Button";
```

The `@/shared` path alias is configured in `tsconfig.json` for the frontend workspace.

## Mobile app

The React Native mobile app lives at `code/src/mobile/`. It imports directly from `code/src/shared/`.

- Provide platform-specific adapters for any web-only primitives (e.g. `Image`, `Link`).
- Do not duplicate shared component logic — extend via composition.
- See `code/src/mobile/CONTEXT.md` for the full mobile stack and conventions.
