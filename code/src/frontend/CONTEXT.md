# code/src/frontend — Next.js Project

This is the Next.js 16.2.4 App Router frontend for the Syntek Studio website.

## Stack

| Component      | Technology                    |
| -------------- | ----------------------------- |
| Framework      | Next.js 16.2.4 (App Router)   |
| Language       | TypeScript 6.0.3              |
| UI Library     | React 19.2                    |
| Styling        | Tailwind CSS 4.2              |
| GraphQL Client | Apollo Client                 |
| Code Gen       | GraphQL Code Generator        |
| Tests          | Vitest, React Testing Library |

## Directory Layout

```text
frontend/
├── e2e/
│   ├── features/           # Playwright spec files (BDD-style, one per feature)
│   └── steps/              # Page-object models and step helpers
├── src/
│   ├── app/                # Next.js App Router pages and layouts
│   ├── components/         # Page-specific React components (single-page use only)
│   ├── graphql/
│   │   ├── queries/        # .graphql query and mutation files
│   │   ├── mutations/      # .graphql mutation files (created on demand)
│   │   ├── fragments/      # Shared GraphQL fragments (created on demand)
│   │   └── generated/      # Auto-generated TypeScript types and hooks (never edit)
│   ├── lib/                # Singleton clients and shared utilities (e.g. ApolloWrapper)
│   └── test/
│       ├── builders/       # Typed test data factory functions
│       ├── msw-server.ts   # Shared MSW Node.js server instance
│       └── setup.ts        # Vitest global setup (jest-dom + MSW lifecycle)
├── public/                 # Static assets
├── next.config.ts
├── playwright.config.ts
├── postcss.config.mjs      # PostCSS — activates @tailwindcss/postcss for next build
├── tsconfig.json
└── package.json
```

## Key Entry Points

| Path                     | Purpose                                   |
| ------------------------ | ----------------------------------------- |
| `src/app/layout.tsx`     | Root layout — providers, fonts, metadata  |
| `src/app/page.tsx`       | Home page                                 |
| `src/graphql/generated/` | Auto-generated hooks — never edit by hand |

## Standards

- All code must follow `code/docs/CODING-PRINCIPLES.md`
- WCAG 2.2 AA compliance required on all interactive components
- Run codegen via `docker compose exec frontend pnpm run codegen` after any backend schema change
- SEO metadata required on every page — see `project-management/docs/SEO-CHECKLIST.md`

## Cross-references

- `code/docs/ARCHITECTURE-PATTERNS.md` — Next.js App Router patterns
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements
- `code/docs/API-DESIGN.md` — Apollo Client and GraphQL query conventions
- `code/docs/PERFORMANCE.md` — Next.js optimisation patterns
