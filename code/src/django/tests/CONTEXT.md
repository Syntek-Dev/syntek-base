# code/src/django/tests — Project-Level Test Packages

Tests that belong to no single Django app. **Per-app tests do not live here** — they sit
beside the app they cover, in `apps/<app>/tests/`, so a test moves when its app does.

## Directory tree

```text
code/src/django/tests/
├── __init__.py
├── CLAUDE.md
├── CONTEXT.md    ← this file
└── e2e/          ← browser-level suite (Playwright via pytest); see its CONTEXT.md
```

## What lives here

| Suite  | Scope                                                                 | Runner                             |
| ------ | --------------------------------------------------------------------- | ---------------------------------- |
| `e2e/` | Cross-cutting browser checks against a running stack — a11y, overflow | `code/src/scripts/tests/e2e-py.sh` |

## What does not

- Service, model, and endpoint tests → `apps/<app>/tests/`
- Template, django-component, and HTMX-partial tests → `apps/<app>/tests/` as well; they
  run through the Django test client, not a browser (`code/docs/testing/FRONTEND-TESTING.md`)
- HTTP-layer API tests → `code/src/tests/api/` (Bruno collection)

## Cross-references

- `code/src/django/tests/e2e/CONTEXT.md` — the browser suite in detail
- `code/docs/testing/TAXONOMY.md` — which layer a given test belongs to
