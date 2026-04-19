# code/src/mobile/e2e — Detox End-to-End Tests

BDD-style acceptance tests that run against a real device or simulator via Detox.
Mirrors the structure of `code/src/frontend/e2e/`.

## Directory layout

```text
e2e/
├── features/   # Detox spec files — one file per user-facing feature
└── steps/      # Screen-object helpers and step utilities
```

## Conventions

- One spec file per feature in `features/` — name after the feature: `authentication.e2e.ts`
- Screen helpers live in `steps/` and encapsulate element queries and interactions
- Never assert on implementation details — assert on visible text, accessibility labels, and state
- E2E tests are never run automatically in CI — trigger manually via `workflow_dispatch`

## Running

```bash
# Run all E2E tests
bash code/src/scripts/tests/e2e-mobile.sh

# Run a specific feature
bash code/src/scripts/tests/e2e-mobile.sh --grep "Authentication"
```

## Cross-references

- `code/src/mobile/CONTEXT.md` — full mobile stack
- `code/docs/TESTING.md` — testing standards and coverage floors
