# code/src/mobile/e2e/features — Detox Feature Specs

One `.e2e.ts` spec file per user-facing feature. Each file contains one or more `describe` blocks
written in BDD style (`describe` / `it` with full natural-language descriptions).

## Naming

`<feature-name>.e2e.ts` — lowercase, hyphen-separated. Examples:
- `authentication.e2e.ts`
- `profile-edit.e2e.ts`
- `push-notifications.e2e.ts`

## Cross-references

- `code/src/mobile/e2e/steps/CONTEXT.md` — screen-object helpers used by specs
- `code/src/mobile/e2e/CONTEXT.md` — E2E layer overview
