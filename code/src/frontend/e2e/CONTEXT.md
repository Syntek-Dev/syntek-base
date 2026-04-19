# code/src/frontend/e2e

End-to-end (E2E) tests using Playwright. Tests run via `code/src/scripts/tests/e2e.sh` against
the full stack (backend + database + frontend).

## Directory Tree

```text
frontend/e2e/
├── features/                ← Playwright spec files (BDD-style, one per feature)
│   └── .gitkeep             ← placeholder (no tests yet)
└── steps/                   ← page-object models and step helpers
    └── .gitkeep             ← placeholder (no tests yet)
```

## Configuration

Playwright is configured in `code/src/frontend/playwright.config.ts`. Key settings:

- Base URL: `http://localhost:3000` (dev), overridden by `PLAYWRIGHT_BASE_URL` in CI.
- Tests discovered from `e2e/features/`.

## Running E2E Tests

```bash
bash code/src/scripts/tests/e2e.sh
```

## Conventions

- Feature files describe user-facing behaviour in plain language (BDD-style).
- Page objects in `steps/` encapsulate selectors and interactions for a specific page.
- E2E tests must not mock the backend — they exercise the full stack end-to-end.
- Coverage thresholds do not apply to E2E tests — they supplement unit tests, not replace them.

## Cross-references

- `code/src/scripts/tests/CONTEXT.md` — test runner scripts
- `code/docs/TESTING.md` — testing strategy and coverage requirements
- `code/src/frontend/playwright.config.ts` — Playwright configuration
