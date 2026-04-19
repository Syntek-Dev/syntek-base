# code/src/mobile/src/test/builders — Test Data Builders

Factory functions that construct realistic, fully-typed test data objects. Consumed by unit tests and RNTL integration tests across `src/`.

## Conventions

- One file per domain model: `userBuilder.ts`, `postBuilder.ts`
- Each builder exports a single function named `build<Model>` that accepts a partial override: `buildUser(overrides?: Partial<User>): User`
- Defaults must be realistic — real-looking names, valid email formats, ISO date strings
- Never return `null` or `undefined` from a builder — use a sensible default instead

## Example shape

```typescript
import { User } from '@/graphql/generated/graphql';

export function buildUser(overrides?: Partial<User>): User {
  return {
    id: 'user-1',
    email: 'alice@example.com',
    displayName: 'Alice Example',
    avatarUrl: null,
    ...overrides,
  };
}
```

## Cross-references

- `code/src/mobile/src/test/CONTEXT.md` — parent test utilities directory
