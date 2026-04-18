# Debugging — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Check Container Logs

```bash
# All logs
docker compose logs -f

# Backend only
docker compose logs -f backend

# Frontend only
docker compose logs -f frontend
```

### Step 2 — Isolate the Problem

If the error is in a GraphQL resolver, test the query directly in the Playground:
http://localhost:8000/graphql/

If it is a frontend issue, open browser DevTools → Network → find the failing request.

### Step 3 — Inspect Data (Backend)

```bash
docker compose exec backend python manage.py shell
```

```python
from apps.<app>.models import <Model>
<Model>.objects.filter(<condition>)
```

### Step 4 — Run the Failing Test in Verbose Mode

```bash
# Backend
docker compose exec backend pytest tests/<module>/<test_file>.py::test_name -v -s

# Frontend
docker compose exec frontend npm test -- --run --reporter=verbose
```

### Step 5 — Use the Debug Agent

```text
/syntek-dev-suite:debug [describe the problem and what you have tried]
```

### Step 6 — Document and Fix

If the bug warrants a bug report:
Save to `project-management/src/BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md`.

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
