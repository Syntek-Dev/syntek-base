# code/src/frontend/src/app

Next.js App Router directory. Every file here participates in the file-system routing convention.

## Current Structure

```text
frontend/src/app/
├── globals.css              ← Tailwind CSS base directives and global resets
├── layout.tsx               ← root layout component
└── page.tsx                 ← home page (`/`)
```

## Routing Conventions

| File            | Purpose                                                        |
| --------------- | -------------------------------------------------------------- |
| `layout.tsx`    | Shared UI wrapping nested routes (persists across navigations) |
| `page.tsx`      | Renderable route — publicly accessible at the segment path     |
| `loading.tsx`   | Streaming loading UI (Suspense boundary)                       |
| `error.tsx`     | Error boundary for the segment                                 |
| `not-found.tsx` | 404 handler for the segment                                    |
| `route.ts`      | API route handler (use sparingly — prefer GraphQL)             |

## Root Layout

`layout.tsx` wraps every page with:

- `<html lang="en-GB">` — locale set to British English.
- `ApolloWrapper` — provides the Apollo Client context to all client components.
- `globals.css` — Tailwind base styles.

## Standards

- Every page must export `metadata` (or `generateMetadata`) for SEO.
- All interactive components must meet WCAG 2.2 AA compliance.
- Server Components are the default — only add `"use client"` when browser APIs or state are required.
- Route groups (`(group-name)/`) organise routes without affecting the URL.

## Cross-references

- `code/src/frontend/src/CONTEXT.md` — full src tree overview
- `project-management/docs/SEO-CHECKLIST.md` — SEO requirements per page
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements
