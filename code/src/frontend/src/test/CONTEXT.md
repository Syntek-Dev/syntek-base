# code/src/frontend/src/test

Test infrastructure for the frontend Vitest suite. Sets up MSW (Mock Service Worker) for API
mocking and configures the testing library environment.

## Directory Tree

```text
frontend/src/test/
├── builders/                ← typed test data factory functions
│   └── .gitkeep             ← placeholder (no builders yet)
├── msw-server.ts            ← shared MSW Node.js server instance
└── setup.ts                 ← Vitest global setup (jest-dom matchers + MSW lifecycle)
```

## Key Files

| File            | Purpose                                                         |
| --------------- | --------------------------------------------------------------- |
| `setup.ts`      | Imported by `vitest.config.ts` — starts, resets, and closes MSW |
| `msw-server.ts` | Exports the shared MSW `SetupServer` instance                   |
| `builders/`     | Factory functions for creating typed test fixtures              |

## MSW Setup

- `setup.ts` registers `@testing-library/jest-dom/vitest` matchers globally.
- `beforeAll` starts the MSW server with `onUnhandledRequest: "error"` — any un-mocked request
  fails the test immediately.
- `afterEach` resets handlers to prevent test bleed.
- `afterAll` closes the server.

## Builders

`builders/` holds factory functions that produce typed mock data objects. Use builders instead of
raw object literals to keep tests maintainable as schemas evolve.

## Cross-references

- `code/src/frontend/vitest.config.ts` — Vitest configuration
- `code/docs/TESTING.md` — testing strategy and coverage requirements
- `code/src/scripts/tests/frontend.sh` — frontend test runner script
