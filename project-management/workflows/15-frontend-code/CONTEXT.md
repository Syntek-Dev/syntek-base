# Workflow: Frontend Code

> **Agent hints — Model:** Sonnet · **MCP:** `code-review-graph`, `docfork` + `context7` (Next.js, React, Tailwind), `figma` (read designs), `claude-in-chrome` (visual verification)

## Directory Tree

```text
project-management/workflows/15-frontend-code/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when implementing Next.js pages and React components. Wireframes and
component designs must be signed off and the GraphQL API must be available before this
workflow begins.

## Prerequisites

- [ ] Wireframes are signed off (`project-management/src/07-WIREFRAMES/`)
- [ ] Component designs are approved in Figma
- [ ] GraphQL API for the feature is implemented and tested
- [ ] TypeScript types can be generated from the current schema

## Key concepts

- All pages use the Next.js App Router (`code/src/frontend/src/app/`)
- Apollo Client with auto-generated TypeScript hooks is the GraphQL client
- WCAG 2.2 AA compliance is required on all interactive components
- Frontend coverage floor: 70% minimum (Vitest + React Testing Library)
- All commands run via `docker compose exec frontend` — never directly

## Cross-references

### code/ layer — read before writing any frontend code

| Path                             | When to read                                                               |
| -------------------------------- | -------------------------------------------------------------------------- |
| `code/CONTEXT.md`                | Next.js conventions, frontend project structure, tooling rules             |
| `code/docs/CODING-PRINCIPLES.md` | Component design rules, naming, single-responsibility                      |
| `code/docs/TESTING.md`           | Vitest + React Testing Library conventions and coverage floors             |
| `code/docs/ACCESSIBILITY.md`     | WCAG 2.2 AA requirements for all interactive components                    |
| `code/docs/PERFORMANCE.md`       | Client-side performance rules (lazy loading, bundle size, Core Web Vitals) |
| `code/docs/RESPONSIVE-DESIGN.md` | Breakpoint tokens, media vs container query guidance, viewport test set    |

### code/workflows/ — companion workflows to run alongside this one

| Workflow                         | Purpose                                               |
| -------------------------------- | ----------------------------------------------------- |
| `code/workflows/01-new-feature/` | Full-stack feature checklist that wraps this workflow |
| `code/workflows/02-tdd-cycle/`   | Red-green-refactor steps for component and page tests |

### Source locations

- `code/src/frontend/` — Next.js project root
- `code/src/frontend/src/app/` — App Router pages and layouts
- `code/src/frontend/src/components/` — shared React components
- `code/src/frontend/src/graphql/generated/` — auto-generated TypeScript types and hooks

### project-management/ — prerequisites and next step

- `project-management/workflows/06-component-designs/` — component designs consumed here
- `project-management/workflows/07-wireframes/` — wireframes consumed here
- `project-management/workflows/14-api-code/` — GraphQL API must exist before this workflow
- `project-management/workflows/17-pr-and-review/` — follow this after frontend is tested
