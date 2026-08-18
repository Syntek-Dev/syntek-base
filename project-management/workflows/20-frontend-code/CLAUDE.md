@./CONTEXT.md

# CLAUDE.md — workflows/20-frontend-code/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, governing documents — imported above) → this file → `STEPS.md`
then `CHECKLIST.md`.

## Purpose (one line)

The frontend implementation workflow — build a story's Django-templated frontend
(django-components + HTMX + Alpine + token CSS) across every surface, once wireframes and
component designs are signed off.

## How to work here

- **Routing:** this workflow _drives code_ under the `stack-htmx-templates` skill (Opus), alongside
  `code/workflows/01-implement-story/` and `02-tdd-cycle/`. Hard gates to read first:
  `code/docs/ACCESSIBILITY.md` (WCAG 2.2 AA) and `testing/COVERAGE.md`. New public page
  → `code/src/scripts/development/new-django-view.sh` — never hand-create route
  directories.
- **Model:** Opus for templates, components, and tests, and for renames or running
  a script.
- **Concrete steps:** **check the django-components library (`code/src/django/components/`)
  before writing any new component** — reuse via a `{% component %}` tag and only create
  new if no match → build every page as a server-rendered Django view + template, with
  HTMX partials for server operations and Alpine for local interactions → tests via
  `code/src/scripts/tests/*.sh`. **Never run `docker` directly.**
  Satisfy `CHECKLIST.md`; next is `workflows/22-pr-and-review/`.
- **Definition of done:** WCAG 2.2 AA met on all interactive components; the 75%
  coverage floor met; SEO requirements (`docs/SEO-CHECKLIST.md`) satisfied for
  public pages; checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `workflow`/`phase`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **WCAG 2.2 AA is non-negotiable** on every interactive component (CLAUDE.md Section 8) — on
  **both** surfaces. One standard, two technique sets
  (`code/docs/accessibility/MOBILE.md`).
- **Token-first CSS:** components consume `var(--token)` only — never a raw colour,
  spacing, or size literal. The same law binds the mobile surface with a different
  enforcement clause (`mobile-tokens.sh`).
- **`frontend` is web-only and its remit is unchanged.** Mobile work is handed to
  `stack-react-native` at Step 4M — never approached by applying Django-template assumptions
  to React Native. That skill is absent from a web-only project, which is why the
  frontmatter routes to `frontend` and names the mobile route at its point of use instead.
- **Reuse before build:** always check the django-components library first; public pages
  are server-rendered Django templates (SEO-critical content must not depend on
  client-side JS).
- All operations go through `code/src/scripts/**/*.sh`. Source files ≤ 750 lines
  (800 grace).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the code in `code/src/django/` (views,
  `templates/`, `components/`).
- **Generated (never hand-edit):** nothing — there is no build step on this layer.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; stories
  referenced as `US###`; dates DD/MM/YYYY.
