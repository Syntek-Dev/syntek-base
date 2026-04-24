# code/src/mobile — Expo React Native App

This is the Expo (React Native) mobile app for the project, sharing the same GraphQL API as the web frontend.

## Stack

| Component       | Technology                                                         |
| --------------- | ------------------------------------------------------------------ |
| Framework       | Expo SDK (latest) + Expo Router                                    |
| Native Layer    | React Native 0.85.x                                                |
| Language        | TypeScript 6.0.3                                                   |
| UI Library      | React Native + React 19.2                                          |
| Styling         | NativeWind 4.2.3 + react-native-css-interop 0.2.3                  |
| Tailwind Config | Tailwind CSS 3.x (NativeWind 4 requires v3, not v4)                |
| GraphQL Client  | Apollo Client                                                      |
| Code Gen        | GraphQL Code Generator                                             |
| Unit / TDD      | Jest + React Native Testing Library + @testing-library/jest-native |
| E2E / BDD       | Detox                                                              |

> **Note:** NativeWind 4.x depends on Tailwind CSS v3. The web frontend uses Tailwind CSS v4 — the
> configs are intentionally separate. Do not share `tailwind.config.js` between `frontend/` and `mobile/`.
>
> `react-native-css-interop` is bundled with NativeWind 4.2.3 — it does not need to be installed
> separately, but its version must stay in sync with the nativewind version.

## Directory Layout

```text
mobile/
├── app/                    # Expo Router screens (file-based routing)
│   ├── (tabs)/             # Tab navigator group
│   ├── _layout.tsx         # Root layout — providers, fonts, navigation
│   └── index.tsx           # Entry screen
├── e2e/
│   ├── features/           # Detox spec files (BDD-style, one per feature)
│   └── steps/              # Screen-object helpers and step utilities
├── src/
│   ├── components/         # Screen-specific React Native components
│   ├── graphql/
│   │   ├── queries/        # .graphql query files
│   │   ├── mutations/      # .graphql mutation files (created on demand)
│   │   ├── fragments/      # Shared GraphQL fragments (created on demand)
│   │   └── generated/      # Auto-generated TypeScript types and hooks (never edit)
│   ├── lib/                # Apollo client setup and shared utilities
│   └── test/
│       ├── builders/       # Typed test data factory functions
│       └── setup.ts        # Jest global setup (jest-native matchers + MSW lifecycle)
├── assets/                 # Static assets (images, fonts, icons)
├── app.json                # Expo config
├── babel.config.js
├── metro.config.js         # Metro bundler config (required for NativeWind 4)
├── tailwind.config.js      # Tailwind v3 config (separate from frontend's v4 config)
├── tsconfig.json
└── package.json
```

## Key Entry Points

| Path                     | Purpose                                   |
| ------------------------ | ----------------------------------------- |
| `app/_layout.tsx`        | Root layout — Apollo provider, navigation |
| `app/index.tsx`          | Entry screen                              |
| `src/graphql/generated/` | Auto-generated hooks — never edit by hand |
| `src/lib/apollo.ts`      | Apollo Client instance for React Native   |
| `src/test/setup.ts`      | Jest global setup                         |

## Testing

### Unit / TDD (Jest + RNTL)

- Test files live alongside source: `Button.test.tsx` next to `Button.tsx`
- Use `@testing-library/react-native` for rendering and querying components
- Use `@testing-library/jest-native` matchers (`toBeVisible`, `toHaveStyle`, etc.)
- NativeWind styles must be unwrapped in tests — configure `nativewind/jest` preset in `jest.config.js`
- Coverage floor: 70% line and branch

### E2E / BDD (Detox)

- Feature specs live in `e2e/features/` (BDD-style, one file per feature)
- Screen-object helpers and step utilities live in `e2e/steps/`
- Mirrors the frontend E2E structure (`frontend/e2e/features/` + `frontend/e2e/steps/`)
- Run via the project script — never call `detox` directly outside the container

## Storybook

Stories render on-device via Expo — no simulator required, works with Expo Go.

### Running on your phone

```bash
pnpm storybook
```

This sets `EXPO_PUBLIC_STORYBOOK_ENABLED=true` and starts the Expo dev server. Scan the QR
code with Expo Go (or your development build) and Storybook opens directly on the device.

The `app/_layout.tsx` root layout detects the env var at startup and renders `StorybookUI`
instead of the normal Expo Router navigation. The `__DEV__` guard ensures Storybook is never
included in production builds.

### After adding stories

Run the story loader generation script after adding, removing, or renaming any story file:

```bash
pnpm storybook:generate
```

This regenerates `storybook.requires.ts` at the package root. Do not edit that file manually.

### Story file conventions

- Story files live alongside the component they document: `Button.stories.tsx` next to `Button.tsx`
- Stories from `code/src/shared/src/**/*.stories.tsx` are also picked up automatically
- Use `@storybook/react-native` APIs — not `@storybook/react` or browser-specific helpers

## Shared UI

Cross-platform components, hooks, and utilities live in `code/src/shared/`. Import directly from
the shared workspace path. Platform-specific adapters are provided for any web-only primitives
(e.g. `Image`, `Link`) — extend via composition, never duplicate shared logic.

## Standards

- All code must follow `code/docs/CODING-PRINCIPLES.md`
- WCAG 2.2 AA compliance required on all interactive components
- Run codegen via the project script after any backend schema change
- Never run `npx expo`, `pnpm`, `detox`, or `npm` directly — use scripts in `code/src/scripts/`

## Dev

Run inside the Docker container:

```bash
docker compose exec mobile pnpm run start
```

## Cross-references

- `code/src/shared/CONTEXT.md` — shared components, hooks, and utilities
- `code/docs/CODING-PRINCIPLES.md` — coding standards
- `code/docs/API-DESIGN.md` — Apollo Client and GraphQL query conventions
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements
- `code/docs/TESTING.md` — test coverage floors and TDD cycle
