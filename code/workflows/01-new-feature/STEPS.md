# Add a New Full-Stack Feature — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Prerequisites

- [ ] User story confirmed and branch created
- [ ] Containers running (`docker compose up -d`)
- [ ] No uncommitted changes from a previous workflow

---

## Steps

### Step 1 — Architectural Plan

```text
/syntek-dev-suite:plan [feature name and scope]
```

Save the plan to `project-management/src/00-PLANS/PLAN-<FEATURE-NAME>.md`.

### Step 2 — Write Failing Tests First (Red Phase)

```text
/syntek-dev-suite:test-writer [feature name] --mode failing-first
```

Verify all new tests are **red** before proceeding.

### Step 3 — Backend: Models and Migration

```text
/syntek-dev-suite:backend [create models for feature]
```

Then run:

```bash
docker compose exec backend python manage.py makemigrations
docker compose exec backend python manage.py migrate
```

### Step 4 — Backend: Service Layer

```text
/syntek-dev-suite:backend [implement service methods for feature]
```

Every service method doing ≥ 2 writes must use `transaction.atomic()`.

### Step 5 — Backend: GraphQL Types and Resolvers

```text
/syntek-dev-suite:backend [implement Strawberry types and resolvers]
```

Every mutation must verify permissions before executing business logic — implement as a named Policy
class (see [CODING-PRINCIPLES.md — Decision Structuring](../../docs/CODING-PRINCIPLES.md#decision-structuring-boolean-policy-and-strategy)).

### Step 6 — Export Schema and Generate Frontend Types

```bash
docker compose exec backend python manage.py export_schema --path schema.graphql
docker compose exec frontend npm run codegen
```

### Step 7 — Frontend: Components and Pages

```text
/syntek-dev-suite:frontend [implement Next.js component and page]
```

Use generated Apollo hooks from `frontend/src/graphql/generated/`. All interactive elements
must meet WCAG 2.2 AA.

### Step 8 — Make Tests Green

```bash
docker compose exec backend pytest
docker compose exec frontend npm test
```

All tests written in Step 2 must be green. Return to the relevant step if any fail.

### Step 9 — Code Review and QA

```text
/syntek-dev-suite:review
/syntek-dev-suite:qa-tester
```

### Step 10 — Commit

```text
/syntek-dev-suite:git
```

---

## Error Handling

If tests fail after implementation: run `/syntek-dev-suite:debug` to find the root cause.

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
