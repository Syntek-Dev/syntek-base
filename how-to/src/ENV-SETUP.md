# Environment Setup — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## Overview

All configuration is provided via `.env.*` files in `code/src/docker/`. These files are never
committed — only the `.env.*.example` files are tracked in version control.

`install.sh` copies the example files for you on first run. If you need to recreate them:

```bash
cp code/src/docker/.env.dev.example      code/src/docker/.env.dev
cp code/src/docker/.env.test.example     code/src/docker/.env.test
cp code/src/docker/.env.staging.example  code/src/docker/.env.staging
cp code/src/docker/.env.prod.example     code/src/docker/.env.prod
```

---

## Files by environment

| File | Used by | When |
| ---- | ------- | ---- |
| `.env.dev` | `docker-compose.dev.yml` | Local development |
| `.env.test` | `docker-compose.test.yml` | CI and local test runs |
| `.env.staging` | `docker-compose.staging.yml` | GitHub Actions → staging server |
| `.env.prod` | `docker-compose.prod.yml` | GitHub Actions → production server |

---

## Key variables

### Django

```bash
DJANGO_SECRET_KEY=CHANGE_ME          # Long random string — never reuse across environments
DJANGO_DEBUG=True                    # Must be False in all non-local environments
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
CORS_ALLOWED_ORIGINS=http://dev.projectname.com
```

### Database (PostgreSQL)

```bash
POSTGRES_DB=project_name_dev
POSTGRES_USER=project_name
POSTGRES_PASSWORD=CHANGE_ME
POSTGRES_HOST=db                     # Docker Compose service name — not localhost
POSTGRES_PORT=5432
```

### Cache (Valkey)

```bash
VALKEY_URL=redis://valkey:6379/0     # Docker Compose service name — not localhost
```

### Next.js / frontend

```bash
NEXT_PUBLIC_GRAPHQL_URL=http://dev.projectname.com/graphql/
```

### Email (dev)

```bash
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=maildev                   # Docker Compose service — captured by Maildev UI
EMAIL_PORT=1025
```

---

## Security rules (non-negotiable)

- `DJANGO_SECRET_KEY` must be unique per environment — never share keys.
- `DJANGO_DEBUG=False` in staging and production — no exceptions.
- `CORS_ALLOWED_ORIGINS` must be an explicit allowlist — never `*` in production.
- Never commit a `.env.*` file containing real secrets.
- All secrets in CI/CD are stored as GitHub Actions secrets, not in code.

---

## Generating a secret key

```bash
python -c "import secrets; print(secrets.token_urlsafe(50))"
```

Or inside the container:

```bash
docker compose exec backend python -c "import secrets; print(secrets.token_urlsafe(50))"
```

---

## Verifying the environment

Check that all required variables are set before starting a new environment:

```bash
./code/src/scripts/development/server.sh status
```

The status command reports which containers are running and highlights any missing configuration.
