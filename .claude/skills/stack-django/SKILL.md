---
name: stack-django
description: >-
  Django 6 + Django Ninja + PostgreSQL backend idioms for <%PROJECT_NAME%> —
  service-layer boundaries, model conventions, Django Ninja endpoints and Schema models with
  named Policy permission checks, strict type hints, and pytest via the project scripts. Load
  this when writing or reviewing server-side code (models, migrations, services, Django Ninja
  endpoints), or when a backend/security/refactor skill needs the canonical stack idioms.
---

# Stack: Django & Django Ninja (<%PROJECT_NAME%>)

Reference material for the backend layer. The `backend`, `security`, and `refactor`
skills cite this file for stack idioms so they need not restate them. It is the
authoritative statement of **how backend code is shaped here** — the governing
procedures (`code/workflows/*`) and reference guides (`code/docs/*`) own the _why_.

**Locale:** British English (en_GB) · <%TIMEZONE%> · <%CURRENCY%>. Apply British spelling
in code comments, docstrings, and identifiers where a choice exists.

---

## Section map

| Topic                         | Where                                        |
| ----------------------------- | -------------------------------------------- |
| Stack layers and versions     | [Architecture](#architecture)                |
| Dev operations (scripts only) | [Commands](#commands)                        |
| Django, service-layer, Ninja  | [`CODING-STANDARDS.md`](CODING-STANDARDS.md) |
| Guards, errors, off-request   | [`CODING-STANDARDS.md`](CODING-STANDARDS.md) |
| Strict type-hint policy       | [Type hinting](#type-hinting)                |
| App and package layout        | [File structure](#file-structure)            |
| pytest conventions            | [Testing](#testing-pytest)                   |

**When to use this skill:** any task touching `code/src/django/**` — a new model,
migration, service method, Ninja endpoint, query-performance fix, RLS or PII
work, or a review of the same. For the frontend equivalent see `.claude/skills/stack-htmx-templates/`.

---

## Architecture

| Layer           | Technology                                     |
| --------------- | ---------------------------------------------- |
| **Platform**    | Docker Compose (dev) · Gunicorn + Nginx (prod) |
| **Backend**     | Python 3.14, Django 6.1.3                      |
| **API**         | Django Ninja (`/api/`, OpenAPI at `/api/docs`) |
| **Database**    | PostgreSQL 18 (with row-level security)        |
| **Cache/queue** | Valkey                                         |
| **Testing**     | pytest, pytest-django                          |

The public UI is **server-rendered HTML** — Django templates + django-components + HTMX + Alpine
(see `.claude/skills/stack-htmx-templates/`). The **Django Ninja** JSON API (`/api/`, auto OpenAPI
at `/api/docs`) is the only API surface. `templates/` holds the 500 page today; the marketing
pages and the base template arrive with the first story (`code/src/django/templates/CONTEXT.md`).

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
| Database shell (psql)    | `bash code/src/scripts/database/shell.sh --psql`             |
| Seed dev data            | `bash code/src/scripts/database/seed-dev.sh`                 |
| Run backend tests        | `bash code/src/scripts/tests/backend.sh`                     |
| Backend coverage         | `bash code/src/scripts/tests/backend-coverage.sh`            |
| Check DB security config | `bash code/src/scripts/database/verify-db-security.sh`       |
| New Django app           | `bash code/src/scripts/development/new-django-app.sh <name>` |
| Manage users             | `bash code/src/scripts/database/manageusers.sh`              |

After any model change run `migrate.sh make` → `migrate.sh run` (migrations stay in lockstep
with the models; Django Ninja emits the OpenAPI schema at `/api/docs` automatically).

---

## Coding standards

The Django, service-layer, Django Ninja, row-level security and PII, search and off-request
idioms — with the worked service and endpoint examples — are in
[`CODING-STANDARDS.md`](CODING-STANDARDS.md). Read it before writing a model, a service method,
an endpoint, a guard, a management command or a task.

---

## Type hinting

**Annotate every signature** — parameters and return type, on every function and method.
basedpyright checks them, but in **`standard`** mode, not `strict`: both
`code/src/django/pyrightconfig.json:7` and `pyproject.toml:166` set `typeCheckingMode =
"standard"`, so the checker will not flag an unannotated parameter or an implicit `Any` for
you. The discipline is the author's; the tool only catches contradictions. Prefer modern
built-in generics (`list[str]`, `X | None`) over the legacy `typing` aliases.

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
`Args:`/`Returns:`/`Raises:` block. Every module opens with a docstring on why it exists,
as long as that reason needs; an inline **comment** is one line. No pronouns. **Never
reference a story (`US###`), sprint, ADR, ticket, PR, commit, `docs/` path, person, or date
from inside a code file**, and never leave a
`TODO`/`FIXME` — deferred work belongs in `DEFERRED.md`/`GAPS.md`. The one exception is
published interface text: a Ninja endpoint docstring and `summary` render on the OpenAPI
page, and a FastMCP tool docstring is the prompt the model reads, so both state the full
what. Full standard: `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 4.

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
├── templates/              # 500.html today; the marketing pages arrive with the first story
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

pytestmark = pytest.mark.story("US012")  # every test below belongs to this story's record


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

**The `story` marker is attribution, not selection** — it is what the per-story test record in
`project-management/src/18-TESTS/AUTOMATED/` is generated from, and an unmarked test is silently
absent from that record (`code/docs/testing/TAXONOMY.md` — _Markers_).

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/19-backend-code/` — models, services, business logic
- `project-management/workflows/20-api-code/` — the Django Ninja API layer
- `code/workflows/02-tdd-cycle/` — Red → Green → Refactor
- `code/workflows/04-api-design/` — routers, Schemas, endpoints
- `code/workflows/03-database-migration/` — schema changes

## Cross-references

- `code/docs/BACKEND-CODING-PRINCIPLES.md` — the Django/Python/Celery specifics behind these idioms
- `code/docs/ARCHITECTURE-PATTERNS.md` — the layered boundaries the service layer sits inside
- `code/docs/DATA-STRUCTURES.md` — the model and type conventions the ORM layer encodes
- `code/docs/LOGGING.md` — structured logging, and what must never reach a log line
- `code/docs/MCP-SERVER.md` — the `/mcp/` surface beside `/api/`, and what it does not inherit
- `code/docs/EXPORTS.md` · `code/docs/NOTIFICATIONS.md` · `code/docs/OBJECT-STORAGE.md` — declared, not wired: read before a story wires one
- `project-management/docs/QA-GUIDE.md` · `project-management/docs/SECURITY-GUIDE.md` — what the PM layer gates this code against
- Cited from `CODING-STANDARDS.md`, and named here so this index answers for them:
  `code/docs/NEGATIVE-SPACE.md` · `code/docs/API-DESIGN.md` · `code/docs/SECURITY.md` ·
  `code/docs/ENCRYPTION-GUIDE.md` · `code/docs/DATABASE.md` · `code/docs/RLS-GUIDE.md` ·
  `code/docs/PERFORMANCE.md` · `code/docs/URL-STRATEGY.md` · `code/docs/MANAGEMENT-COMMANDS.md` ·
  `code/docs/TASK-AUTHORING.md` · `code/docs/PROCESS-MODEL.md` · `how-to/src/INVARIANTS.md`
