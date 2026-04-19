# code/src/frontend/src

Source tree for the Next.js App Router frontend.

## Directory Tree

```text
frontend/src/
├── app/                     ← Next.js App Router pages, layouts, and route segments
│   ├── globals.css          ← global styles (Tailwind base + custom resets)
│   ├── layout.tsx           ← root layout — ApolloWrapper, metadata, html/body
│   └── page.tsx             ← home page route (`/`)
├── components/              ← page-specific React components (single-page use only)
├── graphql/
│   ├── generated/           ← auto-generated TypeScript types and hooks (never edit)
│   └── queries/             ← .graphql query and mutation operation files
├── lib/
│   └── apollo-wrapper.tsx   ← ApolloClient provider (client component)
└── test/
    ├── builders/            ← typed test data factory functions
    ├── msw-server.ts        ← shared MSW Node.js server instance
    └── setup.ts             ← Vitest global setup (jest-dom + MSW lifecycle)
```

> Components needed by multiple pages belong in `code/src/shared/src/components/`, not here.

## Cross-references

- `code/src/frontend/CONTEXT.md` — full frontend stack overview
- `code/src/frontend/src/app/CONTEXT.md` — App Router pages and routing
- `code/src/frontend/src/graphql/CONTEXT.md` — GraphQL queries and code generation
- `code/src/frontend/src/lib/CONTEXT.md` — shared utilities and Apollo setup
- `code/src/frontend/src/test/CONTEXT.md` — test infrastructure (MSW, builders)
