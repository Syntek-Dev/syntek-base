# code/src/mobile/src/test — Test Utilities and Fixtures

Shared test helpers consumed by unit and integration tests throughout `src/`.

## Directory layout

```text
test/
├── builders/   # Factory functions that construct realistic test data objects
└── setup.ts    # Jest global setup — jest-native matchers, MSW server lifecycle
```

## Conventions

- `setup.ts` is referenced by `jest.config.js` via `setupFilesAfterFramework`
- Do not import application components here — test utilities must have no circular dependencies
- MSW (Mock Service Worker) handlers for React Native live in `setup.ts` — use `msw/native` not `msw/browser`

## What belongs here

- Custom Jest matchers
- `renderWithProviders` wrapper that supplies Apollo mock client and navigation context
- MSW handler factories for common API responses

## What does not belong here

- Test data that is specific to a single test file — inline it in that file
- Snapshot files — those live alongside the component under test

## Cross-references

- `code/src/mobile/src/test/builders/CONTEXT.md` — factory functions for test data
- `code/docs/TESTING.md` — testing standards and coverage floors
