# GraphQL API Design — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Design the Schema

Document the intended types, queries, and mutations before writing any code.
Save the design to `project-management/src/00-PLANS/PLAN-<FEATURE>-API.md`.

### Step 2 — Implement Types

```text
/syntek-dev-suite:backend [implement Strawberry types in apps/<app>/types.py]
```

### Step 3 — Implement Resolvers

```text
/syntek-dev-suite:backend [implement queries and mutations]
```

Every mutation must:

1. Verify the caller is authenticated
2. Check the caller has permission for the operation
3. Validate any user-supplied IDs

Implement items 1–2 as named Policy classes — see
[CODING-PRINCIPLES.md — Decision Structuring](../../docs/CODING-PRINCIPLES.md#decision-structuring-boolean-policy-and-strategy).
Item 3 is input validation, not Policy.

### Step 4 — Export Schema

```bash
docker compose exec backend python manage.py export_schema --path schema.graphql
```

### Step 5 — Generate Frontend Types

```bash
docker compose exec frontend npm run codegen
```

### Step 6 — Write Tests

```bash
docker compose exec backend pytest tests/graphql/ -v
```

### Step 7 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
