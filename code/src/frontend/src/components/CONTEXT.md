# code/src/frontend/src/components

Page-specific React components co-located with the pages that use them. Currently empty — add
components here as pages are built.

## Rules

- Components in this directory are used by a **single** page or route segment only.
- If a component is needed by two or more pages, move it to `code/src/shared/src/components/`.
- Naming: `PascalCase.tsx` for components; `PascalCase.test.tsx` for their unit tests.
- Co-locate test files alongside the component they test.

## Cross-references

- `code/src/frontend/src/CONTEXT.md` — src tree overview
- `code/src/shared/CONTEXT.md` — shared components library (multi-page reuse)
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements
