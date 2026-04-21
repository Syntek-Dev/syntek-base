# Backend Code — Steps

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Read the Schema and Story

Review the approved schema document in `project-management/src/03-DATABASE/` and the
corresponding user story in `project-management/src/01-STORIES/`.

Before writing any code, read:
- `code/CONTEXT.md` — Django project structure and settings conventions
- `code/docs/DATA-STRUCTURES.md` — model naming, field conventions, and indexing strategy
- `code/docs/CODING-PRINCIPLES.md` — transaction rules, error handling, function design

Confirm:

- Which Django app(s) own the new models or changes
- Which service methods are required
- The acceptance criteria that backend tests must cover

### Step 2 — Apply the Migration

Follow `code/workflows/09-database-migration/` to generate and apply the migration cleanly:

```bash
bash code/src/scripts/database/migrate.sh make
bash code/src/scripts/database/migrate.sh run
```

### Step 3 — Write Tests First

Follow `code/workflows/02-tdd-cycle/` for the red-green-refactor steps.

```text
/syntek-dev-suite:test-writer [describe the model, service, or behaviour to test]
```

Tests are written before implementation — no stubs to make tests pass.

Coverage floors:
- 75% minimum for all modules
- 90% minimum for auth-related code

Refer to `code/docs/TESTING.md` for pytest conventions and fixture patterns.

### Step 4 — Implement Models

```text
/syntek-dev-suite:backend [describe the models to implement]
```

Follow the approved schema exactly. Apply PII field encryption per `code/docs/ENCRYPTION-GUIDE.md`
and row-level security per `code/docs/RLS-GUIDE.md` where applicable.

### Step 5 — Implement Services

Write service methods that encapsulate business logic:

- Wrap methods that perform ≥ 2 writes in `transaction.atomic()`
- No inline imports unless unavoidable (document the reason)
- Log at ERROR or WARNING before swallowing any exception — see `code/docs/LOGGING.md`
- Apply permission and ownership checks per `code/docs/SECURITY.md`

### Step 6 — Register in Admin

Register new models in the Django admin for internal use and data verification.

### Step 7 — Run Tests and Enforce Coverage

```bash
bash code/src/scripts/tests/backend-coverage.sh
```

All tests must pass with real implementations — no stubs.

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
