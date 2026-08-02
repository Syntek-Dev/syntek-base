---
name: stack-django
description: >-
  Django 6 + Django Ninja + PostgreSQL backend idioms for <%PROJECT_NAME%> —
  service-layer boundaries, model conventions, Django Ninja endpoints and Schema models with
  named Policy permission checks, strict type hints, and pytest via the project scripts. Load
  this when writing or reviewing server-side code (models, migrations, services, Django Ninja
  endpoints), or when a backend/security/refactor agent needs the canonical stack idioms.
---

# Stack: Django & Django Ninja (<%PROJECT_NAME%>)

Reference material for the backend layer. The `backend`, `security`, and `refactor`
agents cite this file for stack idioms so they need not restate them. It is the
authoritative statement of **how backend code is shaped here** — the governing
procedures (`code/workflows/*`) and reference guides (`code/docs/*`) own the _why_.

**Locale:** British English (en_GB) · <%TIMEZONE%> · <%CURRENCY%>. Apply British spelling
in code comments, docstrings, and identifiers where a choice exists.

---

## Section map

| Topic                         | Where                                 |
| ----------------------------- | ------------------------------------- |
| Stack layers and versions     | [Architecture](#architecture)         |
| Dev operations (scripts only) | [Commands](#commands)                 |
| Django, service-layer, Ninja  | [Coding standards](#coding-standards) |
| Strict type-hint policy       | [Type hinting](#type-hinting)         |
| App and package layout        | [File structure](#file-structure)     |
| pytest conventions            | [Testing](#testing-pytest)            |

**When to use this skill:** any task touching `code/src/django/**` — a new model,
migration, service method, Ninja endpoint, query-performance fix, RLS or PII
work, or a review of the same. For the frontend equivalent see `.claude/skills/stack-htmx-templates/`.

---

## Architecture

| Layer           | Technology                                     |
| --------------- | ---------------------------------------------- |
| **Platform**    | Docker Compose (dev) · Gunicorn + Nginx (prod) |
| **Backend**     | Python 3.14, Django 6.0.6                      |
| **API**         | Django Ninja (`/api/`, OpenAPI at `/api/docs`) |
| **Database**    | PostgreSQL 18 (with row-level security)        |
| **Cache/queue** | Valkey                                         |
| **Testing**     | pytest, pytest-django                          |

The public UI is **server-rendered HTML** — Django templates + django-components + HTMX +
Alpine (see `.claude/skills/stack-htmx-templates/`). The **Django Ninja** JSON API (`/api/`,
auto OpenAPI at `/api/docs`) is the only API surface. `templates/` holds
the public pages and components alongside internal artefacts (e.g. audit email bodies).

---

## Commands

**Never** run `python`, `manage.py`, `pytest`, `pip`, `uv`, or `docker` directly — every
dev operation goes through a script in `code/src/scripts/**/*.sh`. This is a
non-negotiable project rule.

| Task                     | Command                                                      |
| ------------------------ | ------------------------------------------------------------ |
| Start full-stack dev env | `bash code/src/scripts/development/server.sh`                |
| Django shell             | `bash code/src/scripts/development/shell.sh`                 |
| Make migrations          | `bash code/src/scripts/database/migrate.sh make`             |
| Apply migrations         | `bash code/src/scripts/database/migrate.sh run`              |
| Database shell (psql)    | `bash code/src/scripts/database/shell.sh`                    |
| Seed dev data            | `bash code/src/scripts/database/seed-dev.sh`                 |
| Run backend tests        | `bash code/src/scripts/tests/backend.sh`                     |
| Backend coverage         | `bash code/src/scripts/tests/backend-coverage.sh`            |
| Verify RLS/DB security   | `bash code/src/scripts/database/verify-db-security.sh`       |
| New Django app           | `bash code/src/scripts/development/new-django-app.sh <name>` |
| Manage users             | `bash code/src/scripts/database/manageusers.sh`              |

After any model change run `migrate.sh make` → `migrate.sh run` (migrations stay in lockstep
with the models; Django Ninja emits the OpenAPI schema at `/api/docs` automatically).

---

## Coding standards

### Django

- **Logic lives in the service layer or on models — never in endpoints.** Django Ninja
  endpoints stay thin: authenticate, authorise, validate, delegate to a service, shape
  the response. An endpoint with business logic in it is a refactor target.
- **Multi-write operations are wrapped in `transaction.atomic()`** in the service method,
  not scattered across the caller.
- **Aim for 3NF.** Add `db_index=True` / composite indexes for every field that filters or
  orders a hot query; add `constraints` for invariants the DB should enforce.
- **UUID primary keys on anything the API exposes** — never leak sequential IDs (IDOR and
  enumeration risk). <%PROJECT_NAME%> Admin surfaces UUIDs; see `code/docs/URL-STRATEGY.md`.
- Kill N+1s with `select_related` (FK/1:1) and `prefetch_related` (reverse/M2M) at the
  service boundary. See `code/docs/PERFORMANCE.md`. Bound every list query — keyset over
  offset for scale-readiness (`code/docs/architecture/CORE-AND-SCALING.md`).

### Service layer

- A service is a module of functions (or a class) under `apps/<app>/services/` that owns
  one domain's business rules. Endpoints and management commands call services; services
  call models. Nothing calls an endpoint.
- **Reuse first, create second.** Before adding a query scope, validator, or permission
  check, search for an existing manager method or service function — copy-pasted query
  logic or duplicated validation across endpoints is a red flag. Extract a shared manager,
  service method, or Policy class instead.

```python
"""Blog publication service — orchestrates draft-to-published transitions."""

from django.db import transaction
from django.utils import timezone

from apps.blogs.models import BlogPost


def publish(post: BlogPost, *, published_by_id: str) -> BlogPost:
    """Publish a draft blog post.

    Args:
        post: The draft post to publish.
        published_by_id: UUID of the authorising editor (for the audit trail).

    Returns:
        BlogPost: The saved, published post.

    Raises:
        ValueError: If the post is not in a publishable state.
    """
    if post.status != BlogPost.Status.DRAFT:
        raise ValueError("Only draft posts may be published.")

    with transaction.atomic():
        post.status = BlogPost.Status.PUBLISHED
        post.published_at = timezone.now()
        post.save(update_fields=["status", "published_at"])
    return post
```

### Django Ninja

- **Every state-changing endpoint has an explicit, named Policy permission check** (OWASP
  A01). No mutating endpoint resolves without one — this is a hard gate the `security` agent enforces.
- **Verify user-supplied IDs against the caller's ownership** before acting on them — no
  IDOR. Resolve the object _scoped to the caller_, never fetch-then-trust.
- Routers and Ninja `Schema` (Pydantic) models live in `apps/<app>/api.py`; split into an
  `api/` package (one router module per concern) once a file approaches the 750-line source limit.
- Filter PII fields by permission **in the response Schema**, and guard PII endpoints with a
  permission check plus audit logging. See `code/docs/SECURITY.md` and `ENCRYPTION-GUIDE.md`.
- Return structured errors via Ninja exception handlers, not bare strings — follow the error
  conventions in `code/docs/API-DESIGN.md`.

```python
"""Blog endpoints — publish transition guarded by an explicit Policy check."""

from ninja import Router, Schema

from apps.blogs.models import BlogPost
from apps.blogs.policies import BlogPolicy
from apps.blogs.services import publication

router = Router(tags=["blogs"])


class BlogPostOut(Schema):
    id: str
    status: str
    published_at: str | None


@router.post("/posts/{post_id}/publish", response=BlogPostOut)
def publish_post(request, post_id: str) -> BlogPost:
    """Publish a draft post owned by the authenticated editor."""
    user = request.user
    # Ownership-scoped fetch — never trust a raw client-supplied ID.
    post = BlogPolicy.get_owned_or_403(user, post_id)
    BlogPolicy.require_can_publish(user, post)
    return publication.publish(post, published_by_id=str(user.id))
```

### Row-level security & PII

An **RLS context middleware**, registered after `AuthenticationMiddleware`, issues
`SET LOCAL` for the scope session variables inside the request transaction. A scoped table
reached without that context set is a security finding.

Set **only** the scope variables a policy actually reads, each derived from a field that
exists. A variable written but read by nothing looks like isolation, tests green, and
silently defaults. A scope column, its policy, its index, and the middleware that sets it are
added together or not at all.

Hash PII for lookup and encrypt it for storage via the field-encryption pipeline; encrypted
columns cannot be indexed, ordered, or searched. Full detail: `code/docs/DATABASE.md`,
`code/docs/RLS-GUIDE.md`, `code/docs/ENCRYPTION-GUIDE.md`.

### Search

Full-text search is PostgreSQL-native: a `SearchVectorField` with a `GinIndex`, ideally
maintained as a stored generated column so it cannot drift from its source. Supply the search
configuration explicitly — the implicit form is not immutable and a generated column will be
rejected. Add the GIN index concurrently on any populated table. `django.contrib.postgres`
must be in `INSTALLED_APPS` for any of it. See `code/docs/DATABASE.md` — _Search_.

---

## Type hinting

**CRITICAL: all Python code uses strict type hints** — enforced by basedpyright
(`pyrightconfig.json`). Prefer modern built-in generics (`list[str]`, `X | None`) over the
legacy `typing` aliases.

```python
from django.db.models import QuerySet

from apps.users.models import User


def get_active_users(limit: int | None = None) -> QuerySet[User]:
    """Retrieve active users.

    Args:
        limit: Maximum number of users to return; None returns all.

    Returns:
        QuerySet[User]: Active user records, newest first.
    """
    users = User.objects.filter(is_active=True).order_by("-date_joined")
    if limit is not None:
        users = users[:limit]
    return users
```

Every module opens with a docstring stating its purpose (no pronouns). Every public
function/method documents what it does (not how), typed args, return, and raised
exceptions — "The function validates input", never "It validates it".

---

## File structure

Apps live under `code/src/django/apps/<app>/`. Non-trivial apps use **packages** (a
directory with `__init__.py`) rather than single-file modules, so each concern stays
under the 750-line source limit and gets its own `CONTEXT.md` + `CLAUDE.md` pair.

```text
code/src/django/
├── config/                 # settings, URLs, ASGI/WSGI, Ninja API root
├── apps/
│   ├── core/               # shared base models, middleware, utilities
│   ├── users/              # auth, permissions, Policy classes
│   └── blogs/              # example domain app
│       ├── models/         # models package (one model group per module)
│       ├── services/       # business logic — the only place logic lives
│       ├── api.py          # Ninja routers, Schema models, endpoints
│       ├── policies.py     # named permission checks (OWASP A01)
│       ├── migrations/
│       └── tests/          # unit/ + integration/
├── templates/              # internal-only (e.g. audit email bodies) — not public UI
├── conftest.py             # shared pytest fixtures
└── manage.py               # invoked only via scripts, never directly
```

New app → `bash code/src/scripts/development/new-django-app.sh <name>` (never
`manage.py startapp`). Read a directory's `CONTEXT.md` before working in it.

---

## Testing (pytest)

Tests live in `apps/<app>/tests/` split into `unit/` and `integration/`. Run them through
`bash code/src/scripts/tests/backend.sh` (never `pytest` directly). Coverage floors and
mocking strategy: `code/docs/TESTING.md`.

```python
"""Unit tests for the blog publication service."""

import pytest

from apps.blogs.models import BlogPost
from apps.blogs.services import publication


@pytest.mark.django_db
def test_publish_promotes_draft(draft_post: BlogPost) -> None:
    """A draft transitions to published and stamps published_at."""
    published = publication.publish(draft_post, published_by_id="00000000-0000-0000-0000-000000000001")

    assert published.status == BlogPost.Status.PUBLISHED
    assert published.published_at is not None


@pytest.mark.django_db
def test_publish_rejects_non_draft(published_post: BlogPost) -> None:
    """Publishing an already-published post raises ValueError."""
    with pytest.raises(ValueError, match="draft"):
        publication.publish(published_post, published_by_id="00000000-0000-0000-0000-000000000001")
```

Test what the service guarantees (state transitions, permission denials, error paths), not
Django's ORM. Every state-changing endpoint needs a test that asserts the permission check
**denies** an unauthorised caller, not just that it allows the happy path.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/16-backend-code/` — models, services, business logic
- `project-management/workflows/17-api-code/` — the Django Ninja API layer
- `code/workflows/02-tdd-cycle/` — Red → Green → Refactor
- `code/workflows/04-api-design/` — routers, Schemas, endpoints
- `code/workflows/09-database-migration/` — schema changes
