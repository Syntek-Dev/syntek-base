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
| Guards, errors, off-request   | [Coding standards](#coding-standards) |
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
- **Every failure is classified into one of three trees**, all in
  `apps.core.services.errors`: a `ServiceError` subclass for a user error (4xx),
  `InvariantViolation` for a broken guarantee (500 and one tracker event), and
  `DependencyUnavailable` for an unreachable provider (503, raised in the adapter that owns
  the SDK). The latter two are **siblings of `ServiceError`, never members** — inside the
  tree, one broad `except ServiceError` turns a broken invariant into a friendly 400.
- **Guard the invariant at the top of one named method, with a `raise`.** `assert` is banned
  outside tests and ruff `S101` fails the build on it; an `AssertionError` cannot carry the
  register key, so it reaches the tracker naming nothing. The guard's only exit is the raise
  — never an early return, a confirming query, or a log.
- **`InvariantViolation` takes its register key first** —
  `InvariantViolation("order.total_matches_lines", …)` — and that key appears in exactly one
  `raise`. Add the row to `how-to/src/INVARIANTS.md` in the same change;
  `code/src/scripts/audits/negative-space.sh` fails on a key with no row, a row with no
  raise, and one key raised twice.

Read `code/docs/NEGATIVE-SPACE.md` before writing a guard or a constraint — it owns what
counts as an invariant, the single-enforcement-point rule, and the taxonomy above.

```python
"""Blog publication service — orchestrates draft-to-published transitions."""

from django.db import transaction
from django.utils import timezone

from apps.blogs.models import BlogPost
from apps.core.services.errors import ServiceValidationError


def publish(post: BlogPost, *, published_by_id: str) -> BlogPost:
    """Publish a draft blog post.

    Args:
        post: The draft post to publish.
        published_by_id: UUID of the authorising editor (for the audit trail).

    Returns:
        BlogPost: The saved, published post.

    Raises:
        ServiceValidationError: If the post is not in a publishable state.
    """
    if post.status != BlogPost.Status.DRAFT:
        raise ServiceValidationError("Only draft posts may be published.")

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
- **Schemas subclass the bases in `apps.core.schemas`** — request bodies `Schema`, responses
  `OutSchema` or `ninja.ModelSchema`, `Query(...)` containers `QuerySchema`. Ruff `TID251`
  fails the build on a direct `ninja.Schema` import, because Ninja's own default **silently
  discards** unknown fields in a request body. `QuerySchema` deliberately accepts extras:
  Ninja hands Pydantic the whole query string, so forbidding them would 422 every inbound
  link carrying `?utm_source=…` (`code/docs/api-design/NINJA-CONVENTIONS.md`).
- Filter PII fields by permission **in the response Schema**, and guard PII endpoints with a
  permission check plus audit logging. See `code/docs/SECURITY.md` and `ENCRYPTION-GUIDE.md`.
- Return structured errors via Ninja exception handlers, not bare strings — follow the error
  conventions in `code/docs/API-DESIGN.md`.

```python
"""Blog endpoints — publish transition guarded by an explicit Policy check."""

from ninja import Router

from apps.core.schemas import Schema

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

### Off the request cycle

Work that runs without a request has no user to answer to, so the same three classes land
differently. Each surface has one owning guide; read it before writing on that surface.

- **Management commands** — `code/docs/MANAGEMENT-COMMANDS.md`. Subclass
  `apps.core.management.base.ManagementCommand`; ruff `TID251` fails the build on Django's
  `BaseCommand`, by either import path. Arguments are untrusted input — argparse **parses**,
  which is not validating, so a command-line identifier is exactly as unverified as one from
  a URL. Destructive work declares its bounds and takes `--dry-run`; the confirmation prompt
  is not the safety, because `--noinput`, a pipe and a scheduler all skip it. Exit 75
  (`EX_TEMPFAIL`) is the one code that carries meaning — a scheduler retries on it.
- **Background tasks** — `code/docs/TASK-AUTHORING.md`. Enqueue inside
  `transaction.on_commit()`, pass identifiers rather than instances, and re-read by primary
  key inside the task. The **user-error class is empty here**: a task has nobody to tell, so
  an argument it cannot act on was put there by code. A signature change is a two-release
  change — a rolling deploy has both live, so a queued message carries the previous shape.
- **Which process it runs in** — `code/docs/PROCESS-MODEL.md`. Worker class, the event loop,
  and the ORM's sync boundary; read it before choosing sync versus async or adding a process
  beyond the web one.

---

## Type hinting

**CRITICAL: all Python code uses strict type hints** — enforced by basedpyright
(`pyrightconfig.json`). Prefer modern built-in generics (`list[str]`, `X | None`) over the
legacy `typing` aliases.

```python
from django.db.models import QuerySet

from apps.users.models import User


def get_active_users(limit: int | None = None) -> QuerySet[User]:
    """Newest-first so the caller can slice a preview without a second ordering."""
    users = User.objects.filter(is_active=True).order_by("-date_joined")
    if limit is not None:
        users = users[:limit]
    return users
```

**Comments and docstrings carry the _why_ only** — the code states the what, and the
typed signature already carries args, return, and raises, so no
`Args:`/`Returns:`/`Raises:` block. Every module opens with a one-line docstring on why it
exists. No pronouns. **Never reference a story (`US###`), sprint, ADR, ticket, PR, commit,
`code/docs/*` path, person, or date from inside a code file**, and never leave a
`TODO`/`FIXME` — deferred work belongs in `DEFERRED.md`/`GAPS.md`. The one exception is
published interface text: a Ninja endpoint docstring and `summary` render on the OpenAPI
page, and a FastMCP tool docstring is the prompt the model reads, so both state the full
what. Full standard: `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` §4.

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

- `project-management/workflows/18-backend-code/` — models, services, business logic
- `project-management/workflows/19-api-code/` — the Django Ninja API layer
- `code/workflows/02-tdd-cycle/` — Red → Green → Refactor
- `code/workflows/04-api-design/` — routers, Schemas, endpoints
- `code/workflows/03-database-migration/` — schema changes
