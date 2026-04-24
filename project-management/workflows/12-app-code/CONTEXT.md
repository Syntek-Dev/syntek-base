# Workflow: Mobile App Code

## Directory Tree

```text
project-management/workflows/12-app-code/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when implementing Expo React Native screens and components. Wireframes and
component designs must be signed off and the GraphQL API must be available before this
workflow begins.

## Prerequisites

- [ ] Wireframes are signed off (`project-management/src/07-WIREFRAMES/`)
- [ ] Component designs are approved in Figma (including mobile viewport variants)
- [ ] GraphQL API for the feature is implemented and tested
- [ ] TypeScript types can be generated from the current schema

## Key concepts

- All screens use Expo Router (`code/src/mobile/app/`)
- NativeWind 4 + react-native-css-interop provides Tailwind utility classes in React Native
- Breakpoints are applied via the `useBreakpoint` hook — not CSS media queries
- Apollo Client with auto-generated TypeScript hooks is the GraphQL client (shared with web)
- Unit test coverage floor: 75% (React Native Testing Library + Jest)
- Detox E2E tests cover critical user flows (sign-in, core happy paths)
- All commands run via `docker compose exec mobile` — never directly

## Cross-references

### code/ layer — read before writing any mobile code

| Path                             | When to read                                                            |
| -------------------------------- | ----------------------------------------------------------------------- |
| `code/CONTEXT.md`                | Expo conventions, Expo Router structure, mobile tooling rules           |
| `code/docs/CODING-PRINCIPLES.md` | Component design rules, naming, single-responsibility                   |
| `code/docs/TESTING.md`           | RNTL + Jest conventions, Detox E2E setup, and coverage floors           |
| `code/docs/ACCESSIBILITY.md`     | WCAG 2.2 AA requirements adapted for React Native                       |
| `code/docs/RESPONSIVE-DESIGN.md` | Mobile viewport tiers, portrait/landscape breakpoints, Maestro test set |
| `code/docs/PERFORMANCE.md`       | React Native performance rules (FlatList, memo, image optimisation)     |

### code/workflows/ — companion workflows to run alongside this one

| Workflow                         | Purpose                                                 |
| -------------------------------- | ------------------------------------------------------- |
| `code/workflows/01-new-feature/` | Full-stack feature checklist that wraps this workflow   |
| `code/workflows/02-tdd-cycle/`   | Red-green-refactor steps for screen and component tests |

### Source locations

- `code/src/mobile/` — Expo project root
- `code/src/mobile/app/` — Expo Router screens and layouts
- `code/src/mobile/src/components/` — React Native components
- `code/src/mobile/src/graphql/generated/` — auto-generated TypeScript types and hooks
- `code/src/shared/` — cross-platform components, hooks, and utilities shared with web

### project-management/ — prerequisites and next step

- `project-management/workflows/06-component-designs/` — component designs consumed here
- `project-management/workflows/07-wireframes/` — wireframes consumed here (use mobile viewports)
- `project-management/workflows/10-api-code/` — GraphQL API must exist before this workflow
- `project-management/workflows/13-pr-and-review/` — follow this after mobile is tested
