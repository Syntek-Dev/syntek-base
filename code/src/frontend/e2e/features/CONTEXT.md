# code/src/frontend/e2e/features

Playwright spec files for end-to-end tests. Currently empty — add spec files here as user
stories are implemented.

## Naming Convention

| Pattern             | Example         |
| ------------------- | --------------- |
| `<feature>.spec.ts` | `login.spec.ts` |

## Rules

- One spec file per user-facing feature or story.
- Specs are written from the user's perspective — describe behaviour, not implementation.
- Scenario names must map to acceptance criteria in the corresponding user story.
- Never mock the backend in E2E specs — assert against real server responses.

## Cross-references

- `code/src/frontend/e2e/CONTEXT.md` — E2E overview
- `code/src/frontend/e2e/steps/CONTEXT.md` — page objects and step helpers
