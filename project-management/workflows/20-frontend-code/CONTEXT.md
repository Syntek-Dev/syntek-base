# Workflow: Frontend Code

**Last Updated**: <%DATE%>

## Directory Tree

```text
project-management/workflows/20-frontend-code/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CONTEXT.md               ← this file (when to use, prerequisites, key concepts)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

Use this workflow when implementing the Django-templated public frontend
(django-components + HTMX + Alpine + token-driven CSS) and, where a rich admin-only
editor is needed, the same server-rendered stack. Wireframes and component designs must be
signed off, and any Django Ninja API the feature consumes must
be available before this workflow begins.

**It also covers the optional mobile surface**, in one clearly-flagged step (`STEPS.md` → Step 4M,
`CHECKLIST.md` → _Mobile surface_) rather than a separate workflow — one story's frontend is one
piece of work regardless of how many surfaces it lands on. A web-only project skips that step and
that section entirely; nothing else in this workflow changes.

## Prerequisites

- [ ] Wireframes are signed off (`project-management/src/08-WIREFRAMES/`)
- [ ] Component designs are approved in Figma
- [ ] The Django Ninja API (the single `NinjaAPI`, served under `/api/`) for any admin
      screen is implemented and tested — pages consume Django view context directly

## Key concepts

- Public pages are Django views + templates in `code/src/django/templates/` (a new page
  is scaffolded via `code/src/scripts/development/new-django-view.sh`, landing in
  `apps.marketing`) — never hand-create route directories
- Every surface is server-rendered — no client-side data fetching anywhere. Interactions that need
  the server go through HTMX against Django views; the Ninja JSON API serves machine clients only
- WCAG 2.2 AA compliance is required on all interactive components
- Coverage floor: the single backend floor of 75% line and branch (frontend tests are pytest tests)
- All commands run via the project shell scripts in `code/src/scripts/` — never directly
- Always check the django-components library (`code/src/django/components/`) before
  writing a new component — reuse it via a `{% component %}` template tag. Only create a
  new component if the library has no suitable match.

## Cross-references

### Hard gates — read before executing Step 1

- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA is non-negotiable on all interactive components (CLAUDE.md §8)
- `code/docs/testing/COVERAGE.md` — the single 75% line-and-branch floor blocks PR (frontend tests are pytest tests)

### Soft references — consult during execution

#### code/ layer

| Path                                                 | When to read                                                                                         |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `code/CONTEXT.md`                                    | Django + django-components conventions, frontend project structure, tooling rules                    |
| `code/docs/coding-principles/STYLE-AND-PROCESS.md`   | Component design rules, naming, single-responsibility                                                |
| `code/docs/testing/FRONTEND-TESTING.md`              | Template, component, and HTMX-partial test conventions (pytest)                                      |
| `code/docs/performance/FRONTEND-PERFORMANCE.md`      | Lazy loading, bundle size, Core Web Vitals rules                                                     |
| `code/docs/rendering/TEMPLATES-AND-INTERACTIVITY.md` | Server-vs-HTMX-vs-Alpine decision rule — where an interaction runs                                   |
| `code/docs/responsive/BREAKPOINTS.md`                | Device breakpoints, mobile-first CSS conventions                                                     |
| `code/docs/responsive/CONTAINER-QUERIES.md`          | Container query syntax, units, and design toolchain integration                                      |
| `code/docs/URL-STRATEGY.md`                          | Route naming, slug conventions, and URL structure for public Django pages                            |
| `code/docs/data-structures/DOMAIN-MODELLING.md`      | Understanding data shapes for component/template context                                             |
| `code/docs/cloudinary/PYTHON_SDK.md`                 | When a page renders Cloudinary images or video — invoke `/cloudinary-transformations` for URL syntax |
| `code/docs/cloudinary/PYTHON_SDK.md`                 | When rendering Cloudinary images or video server-side in a Django view or template                   |
| `code/docs/RESPONSIVE-DESIGN.md`                     | Device breakpoints and orientation data the designs are based on                                     |

#### code/workflows/ — companion workflows to run alongside this one

| Workflow                         | Purpose                                               |
| -------------------------------- | ----------------------------------------------------- |
| `code/workflows/01-new-feature/` | Full-stack feature checklist that wraps this workflow |
| `code/workflows/02-tdd-cycle/`   | Red-green-refactor steps for component and page tests |

#### Source locations

- `code/src/django/` — Django project root (public frontend: views, templates, components)
- `code/src/django/apps/marketing/` — public marketing pages (views + `urls.py`);
  scaffold a new page with `code/src/scripts/development/new-django-view.sh`
- `code/src/django/templates/` — Django page templates
- `code/src/django/components/` — django-components server-rendered UI library; check here
  first before creating any new component

#### project-management/ — prerequisites, next step, and guides

- `project-management/workflows/07-component-designs/` — component designs consumed here
- `project-management/workflows/08-wireframes/` — wireframes consumed here
- `project-management/workflows/19-api-code/` — the Django Ninja API must exist before this workflow
- `project-management/workflows/22-pr-and-review/` — follow this after frontend is tested
- `project-management/docs/SEO-CHECKLIST.md` — SEO requirements for all public-facing pages
- `project-management/src/12-SEO/` — existing SEO requirements for the feature area
