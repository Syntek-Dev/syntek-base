# Django Database Migration — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Define or Modify Models

```text
/syntek-dev-suite:backend [describe model change]
```

### Step 2 — Generate Migration

```bash
docker compose exec backend python manage.py makemigrations
```

Review the generated migration file before applying — confirm it matches intent.

### Step 3 — Apply Migration to Dev Database

```bash
docker compose exec backend python manage.py migrate
```

### Step 4 — Verify

```bash
docker compose exec backend python manage.py showmigrations
docker compose exec backend python manage.py shell
# >>> from apps.<app>.models import <Model>; <Model>.objects.all()
```

### Step 5 — Run Tests

```bash
docker compose exec backend pytest
```

### Step 6 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
