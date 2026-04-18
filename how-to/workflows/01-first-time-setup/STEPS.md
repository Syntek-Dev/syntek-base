# First-Time Setup — Steps

**Last Updated**: 18/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Clone the Repository

```bash
git clone git@github.com:Syntek-Studio/syntek-website.git
cd syntek-website
```

### Step 2 — Copy Environment Files

```bash
cp .env.dev.example .env.dev
```

Edit `.env.dev` and fill in any required values (database credentials, secret key, etc.).

### Step 3 — Build and Start Containers

```bash
docker compose up -d --build
```

Wait for containers to be healthy:

```bash
docker compose ps
```

### Step 4 — Run Migrations

```bash
docker compose exec backend python manage.py migrate
```

### Step 5 — Create a Superuser (Optional)

```bash
docker compose exec backend python manage.py createsuperuser
```

### Step 6 — Generate Frontend Types

```bash
docker compose exec frontend npm run codegen
```

### Step 7 — Verify

Open:

- Frontend: http://localhost:3000
- GraphQL Playground: http://localhost:8000/graphql/
- Django Admin: http://localhost:8000/admin/

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
