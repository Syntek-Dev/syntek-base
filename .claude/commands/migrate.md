---
description: Run Django database migrations
usage: /migrate
---

Run Django database migrations inside the backend container.

**Commands:**

- Make migrations: `docker compose exec backend python manage.py makemigrations`
- Run migrations: `docker compose exec backend python manage.py migrate`
- Show migrations: `docker compose exec backend python manage.py showmigrations`
- Rollback: `docker compose exec backend python manage.py migrate <app> <migration>`

$ARGUMENTS
