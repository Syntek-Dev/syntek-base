# Daily Development — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Pull Latest

```bash
git checkout dev
git pull origin dev
```

### Step 2 — Create Feature Branch

```bash
git checkout -b us###/feature-name
```

### Step 3 — Start Containers

```bash
docker compose up -d
docker compose ps
```

### Step 4 — Work on User Story

Follow the relevant `code/` workflow for the task type.

### Step 5 — Lint Before Committing

```bash
# Backend
docker compose exec backend ruff check --fix .

# Frontend
docker compose exec frontend npm run lint
docker compose exec frontend npm run type-check
```

### Step 6 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
