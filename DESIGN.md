# DESIGN.md

**Project**: project-name | **Last Updated**: 29/04/2026 | **Maintained By**: Syntek Studio
**Stack**: Next.js 16 (App Router) · React 19 · TypeScript 6.0.3 · Expo SDK · React Native 0.85 · Tailwind CSS 4.2 · NativeWind 4.2

This file is the entry point for design work in Claude Design. It maps the relevant standards, guides, and workflows across all four documentation layers. Replace placeholder values (project name, brand tokens, component paths) when using this as a starter for a new project.

---

## Design Standards

### Code Layer — Standards & Guides

| Guide                                                                      | Purpose                                                             |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| [`code/docs/ACCESSIBILITY.md`](code/docs/ACCESSIBILITY.md)                 | WCAG 2.2 AA requirements for all interactive frontend components    |
| [`code/docs/RESPONSIVE-DESIGN.md`](code/docs/RESPONSIVE-DESIGN.md)         | Breakpoints, fluid layouts, mobile-first patterns                   |
| [`code/docs/ARCHITECTURE-PATTERNS.md`](code/docs/ARCHITECTURE-PATTERNS.md) | Component architecture, composition patterns, shared UI conventions |
| [`code/docs/CODING-PRINCIPLES.md`](code/docs/CODING-PRINCIPLES.md)         | Code quality standards that apply to UI components                  |
| [`code/docs/PERFORMANCE.md`](code/docs/PERFORMANCE.md)                     | Rendering performance, animation budgets, image optimisation        |
| [`code/docs/TESTING.md`](code/docs/TESTING.md)                             | Component testing standards — Vitest, RTL, Jest, Detox              |

### Project Management Layer — Standards & Guides

| Guide                                                                                          | Purpose                                                          |
| ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| [`project-management/docs/RESPONSIVE-DESIGN.md`](project-management/docs/RESPONSIVE-DESIGN.md) | Responsive design decisions and rationale at the PM/design level |
| [`project-management/docs/SEO-CHECKLIST.md`](project-management/docs/SEO-CHECKLIST.md)         | SEO requirements for all Next.js pages                           |
| [`project-management/docs/GDPR-GUIDE.md`](project-management/docs/GDPR-GUIDE.md)               | Consent UI, data collection forms, privacy notices               |
| [`project-management/docs/QA-GUIDE.md`](project-management/docs/QA-GUIDE.md)                   | QA expectations for frontend features                            |

---

## Design Workflows

### Project Management Layer — Design & Planning

| Workflow                                                                                                             | Purpose                                                     |
| -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [`project-management/workflows/04-user-flow-design/`](project-management/workflows/04-user-flow-design/CONTEXT.md)   | Define user journeys before implementation begins           |
| [`project-management/workflows/05-brand-guides/`](project-management/workflows/05-brand-guides/CONTEXT.md)           | Establish colour, typography, spacing, and tone             |
| [`project-management/workflows/06-component-designs/`](project-management/workflows/06-component-designs/CONTEXT.md) | Design individual UI components with states and variants    |
| [`project-management/workflows/07-wireframes/`](project-management/workflows/07-wireframes/CONTEXT.md)               | Low- and mid-fidelity wireframes for layout decisions       |
| [`project-management/workflows/08-gdpr-compliance/`](project-management/workflows/08-gdpr-compliance/CONTEXT.md)     | GDPR-compliant UI patterns — consent, data forms, notices   |
| [`project-management/workflows/10-qa-checks/`](project-management/workflows/10-qa-checks/CONTEXT.md)                 | QA verification before a feature ships                      |
| [`project-management/workflows/14-frontend-code/`](project-management/workflows/14-frontend-code/CONTEXT.md)         | Translating designs into Next.js components                 |
| [`project-management/workflows/15-app-code/`](project-management/workflows/15-app-code/CONTEXT.md)                   | Translating designs into Expo / React Native screens        |
| [`project-management/workflows/16-pr-and-review/`](project-management/workflows/16-pr-and-review/CONTEXT.md)         | PR review process including visual and accessibility checks |

### Code Layer — Implementation Workflows

| Workflow                                                                     | Purpose                                                   |
| ---------------------------------------------------------------------------- | --------------------------------------------------------- |
| [`code/workflows/01-new-feature/`](code/workflows/01-new-feature/CONTEXT.md) | Full cycle for implementing a new frontend feature        |
| [`code/workflows/02-tdd-cycle/`](code/workflows/02-tdd-cycle/CONTEXT.md)     | TDD for UI components — write tests first, then implement |
| [`code/workflows/06-review/`](code/workflows/06-review/CONTEXT.md)           | Code review checklist with UI-specific checks             |
| [`code/workflows/08-refactor/`](code/workflows/08-refactor/CONTEXT.md)       | Refactoring UI components without regressions             |

---

## Key Source Paths

| Path                                | Contents                                        |
| ----------------------------------- | ----------------------------------------------- |
| `code/src/frontend/src/app/`        | Next.js App Router pages                        |
| `code/src/frontend/src/components/` | Page-specific React components                  |
| `code/src/mobile/app/`              | Expo Router screens                             |
| `code/src/shared/`                  | Cross-platform components, hooks, and utilities |

---

## Design Constraints

- **Accessibility**: WCAG 2.2 AA on all interactive components — see [`code/docs/ACCESSIBILITY.md`](code/docs/ACCESSIBILITY.md)
- **Responsive**: Mobile-first; breakpoints defined in [`code/docs/RESPONSIVE-DESIGN.md`](code/docs/RESPONSIVE-DESIGN.md)
- **SEO**: All Next.js pages require meta, OG, and structured data — see [`project-management/docs/SEO-CHECKLIST.md`](project-management/docs/SEO-CHECKLIST.md)
- **GDPR**: Consent UI and data forms must follow [`project-management/docs/GDPR-GUIDE.md`](project-management/docs/GDPR-GUIDE.md)
- **Styling**: Tailwind CSS 4.2 on web; NativeWind 4.2 on mobile — no inline styles
- **Shared UI**: Prefer `code/src/shared/` components before creating new ones
- **Tooling**: All frontend files must pass ESLint, Prettier, and `tsc` before commit — run `code/src/scripts/syntax/lint.sh`, `format.sh`, and `check.sh`
- **Language**: British English (en_GB) in all copy and labels
