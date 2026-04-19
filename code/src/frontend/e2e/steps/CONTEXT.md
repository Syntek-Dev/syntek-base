# code/src/frontend/e2e/steps

Page-object models and step helper utilities for Playwright E2E tests. Currently empty — add
page objects here as feature specs are implemented.

## Naming Convention

| Pattern          | Example         | Use for                        |
| ---------------- | --------------- | ------------------------------ |
| `<page>.page.ts` | `login.page.ts` | Page-object model for one page |

## Conventions

- Page objects encapsulate Playwright locators and actions for a specific page or component.
- Spec files import page objects — specs stay declarative, page objects stay low-level.
- Never use raw selectors in spec files — always go through a page object.

## Cross-references

- `code/src/frontend/e2e/CONTEXT.md` — E2E overview
- `code/src/frontend/e2e/features/CONTEXT.md` — spec files
