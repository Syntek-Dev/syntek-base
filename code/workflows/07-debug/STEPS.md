# Debug — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Prerequisites

- [ ] Containers running
- [ ] Bug is reproducible

---

## Steps

### Step 1 — Reproduce with a Failing Test

Write the smallest possible test that demonstrates the incorrect behaviour.
Do not attempt a fix until this test exists and is failing.

```bash
docker compose exec backend pytest tests/ -k "test_<bug_name>" -v
```

### Step 2 — Isolate the Scope

Narrow the failing case to the smallest unit. Use the Django shell for backend
data inspection or React DevTools for frontend component state.

```bash
docker compose exec backend python manage.py shell
```

### Step 3 — Implement the Fix

Apply the minimal fix. Do not refactor surrounding code in the same commit —
if a design problem is evident, note it and open a separate refactoring task.

```text
/syntek-dev-suite:debug [describe the bug and the isolated scope]
```

### Step 4 — Verify No Regressions

Run the full test suite to confirm the fix does not break anything else.

```bash
docker compose exec backend pytest
docker compose exec frontend pnpm test --run
```

### Step 5 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
