# API Code (GraphQL) — Steps

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Review the Service Layer and Story

Read the implemented service methods and the user story acceptance criteria.

Before writing any API code, read:
- `code/docs/API-DESIGN.md` — GraphQL type design, resolver patterns, pagination conventions
- `code/docs/ARCHITECTURE-PATTERNS.md` — service/resolver separation (resolvers must not contain business logic)
- `code/docs/SECURITY.md` — permission check patterns and IDOR prevention requirements

Identify:

- Which data must be queryable (queries)
- Which actions must be performable (mutations)
- Which user roles may access each operation

### Step 2 — Design Types and Resolvers

Follow `code/workflows/04-api-design/` before writing code — use it to agree the type
shapes and resolver signatures first.

Create Strawberry input and output types for the feature in the relevant Django app.
Register them in the root schema at `code/src/backend/apps/core/schema.py`.

### Step 3 — Write Queries

Implement resolvers for read operations. Verify:

- Only data the caller is authorised to see is returned
- No unbounded queries — always apply pagination or limits per `code/docs/API-DESIGN.md`

### Step 4 — Write Mutations

```text
/syntek-dev-suite:backend [describe the mutations to implement]
```

Every mutation must:

- Have an explicit permission check (OWASP A01) — see `code/docs/SECURITY.md`
- Verify any user-supplied IDs against the caller's ownership before use (no IDOR)

Run `code/workflows/03-security-hardening/` after mutations are implemented to verify
all security requirements are met.

### Step 5 — Write Tests

Follow `code/workflows/02-tdd-cycle/` for the red-green-refactor steps.

```text
/syntek-dev-suite:test-writer [describe the queries and mutations to test]
```

Refer to `code/docs/TESTING.md` for GraphQL test conventions and fixture patterns.

Test coverage must include:

- Authenticated success paths
- Unauthenticated / unauthorised rejection
- Ownership boundary enforcement (IDOR prevention)
- Invalid input handling

### Step 6 — Run Tests and Enforce Coverage

```bash
bash code/src/scripts/tests/backend-coverage.sh
```

### Step 7 — Regenerate Frontend Types

After any schema change, regenerate TypeScript types and hooks:

```bash
bash code/src/scripts/development/codegen.sh
```

### Step 8 — Lint and Type-Check

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

### Step 9 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
