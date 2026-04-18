# Refactor — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Prerequisites

- [ ] Tests green before starting
- [ ] Scope clearly defined

---

## Steps

### Step 1 — Confirm Tests Green

Establish a clean baseline before touching any code.

```bash
docker compose exec backend pytest
docker compose exec frontend pnpm test --run
```

### Step 2 — Identify the Refactoring Scope

Run the refactor agent to identify issues and plan the changes.

```text
/syntek-dev-suite:refactor [describe the scope and the problem to address]
```

### Step 3 — Apply the Refactoring

Make structural changes without altering behaviour. Work in small increments —
run the tests after each meaningful change to catch regressions immediately.

### Step 4 — Verify Behaviour Unchanged

```bash
docker compose exec backend pytest
docker compose exec frontend pnpm test --run
```

All tests must pass. Coverage must not decrease.

### Step 5 — Lint and Type-Check

```bash
docker compose exec backend uv run ruff check .
docker compose exec frontend pnpm tsc --noEmit
```

### Step 6 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
