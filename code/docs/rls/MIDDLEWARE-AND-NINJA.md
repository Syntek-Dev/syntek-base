---
type: guide
skills: [database, stack-django]
model: opus
---

# RLS Guide — Middleware, Django Ninja, and Background Tasks

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — RLS middleware, Django Ninja endpoint context, and background-task session variables

---

## The RLS context middleware

An **RLS context middleware** sets the session variables the policies read, on every
authenticated request, inside the request transaction. Where more than one variable is set,
they are written in a **single** SQL call — two separate `execute` calls leave a window in
which only one is set.

### The invariant: every variable written is read by a policy

Set exactly the variables the policies consume, and derive each from a field that actually
exists on the model it is read from.

A variable written but read by no policy is **worse than absent**. It looks like isolation,
tests as if it works, and silently defaults — typically to a sentinel like `0` — when the
attribute it reads from is missing. Reviews then treat the table as scoped when nothing
enforces it. The same applies in reverse: a policy reading a variable nothing sets fails
closed, which is safe but will be diagnosed as a permissions bug rather than a wiring one.

When adding a scope variable, add all three parts together — the column, the policy that
reads it, and the middleware that sets it. When removing one, remove all three.

Reserving a variable for future use is a **documented decision**, not a silent write: leave
it unset until a policy consumes it, and record why in the model's `db_table_comment`.

The single-scope form — the common case, and the one to start from:

```python
import logging
from django.db import connection

logger = logging.getLogger(__name__)

_SET_RLS_SQL = "SELECT set_config('app.current_user_id', %s, true)"


class RLSContextMiddleware:
    """Set the PostgreSQL RLS session variable for every authenticated request."""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        user = getattr(request, "user", None)
        if user is not None and getattr(user, "is_authenticated", False):
            self._set_rls_context(request)
        return self.get_response(request)

    def _set_rls_context(self, request) -> None:
        user_id = str(request.user.pk)
        try:
            with connection.cursor() as cursor:
                cursor.execute(_SET_RLS_SQL, [user_id])
        except Exception:
            # Log the identifier, never the value of any scoped row.
            logger.error("failed to set RLS context for user %s", user_id, exc_info=True)
            raise
```

Add a second scope variable **only once a policy reads it**, and set both in one call so they
can never diverge:

```python
_SET_RLS_SQL = """
SELECT set_config('app.current_user_id',   %s, true),
       set_config('app.current_<scope>_id', %s, true)
"""
```

Derive the second value from a relation that genuinely exists. A `getattr(user, "…_id", None)`
against a field the model does not define resolves to `None` on every request and writes a
sentinel — the failure the invariant above exists to prevent.

### Middleware order

The RLS context middleware must run **after** authentication, so `request.user` is populated,
and **before** any middleware or view that queries a scoped table.

```python
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "<app>.middleware.RLSContextMiddleware",  # after authentication, before scoped queries
    # application middleware below
]
```

Where more than one middleware writes scope variables — a surface-specific one alongside the
general one, or an impersonation guard that substitutes a different subject — their **relative
order is load-bearing**: the last writer wins for the rest of the request. Assert that order in
an integration test rather than relying on the list reading correctly.

### Rules

- `RLSMiddleware` must run **after** `AuthenticationMiddleware` — `request.user` must be set.
- **Both variables must be set in a single `cursor.execute` call** — never two separate calls.
- If the request has no authenticated user, do not set either variable. Policies evaluate
  `NULL = NULL → FALSE` and return zero rows, which is the correct safe default.
- Never log the user ID alongside other sensitive request data.

---

## RLS with Django Ninja endpoints

Django Ninja endpoints run in the request context after middleware has already executed. If
`RLSMiddleware` is in `MIDDLEWARE`, the session variable is already set when the endpoint handler
runs. Both HTMX operations against Django views and JSON calls to
these endpoints) reach the ORM through the same restricted application database role.

**Endpoints must not issue raw queries that bypass RLS.** The rules:

1. Use `Model.objects.filter(...)` — the ORM always uses the restricted application role.
2. If an endpoint calls `connection.cursor()` for a raw query, it must call `set_rls_context`
   before the query.
3. Never execute raw queries in an endpoint using the migration role or any role with `BYPASSRLS`.

```python
# apps/content/api.py
from datetime import datetime
from ninja import Router

from apps.core.schemas import Schema
from apps.content.models import Article

router = Router()


class ArticleOut(Schema):
    id: int
    title: str
    created_at: datetime


@router.get("/articles", response=list[ArticleOut])
def my_articles(request):
    # RLS context is already set by RLSMiddleware.
    user = request.user
    return list(Article.objects.filter(user=user).order_by("-created_at")[:50])
```

### Admin endpoints that must see all rows

**Every state-changing Django Ninja endpoint needs an explicit permission check.** Admin endpoints
that legitimately need to bypass RLS to read or write across all users must:

1. Check the caller holds the `admin` permission via `require_permission`.
2. Execute the query using the `admin_db` database alias (BYPASSRLS role).
3. Document the bypass explicitly with a comment.

```python
@router.get("/admin/articles", response=list[ArticleOut])
def all_articles_admin(request):
    # ADMIN ONLY — bypasses RLS via the admin_db alias.
    require_permission(request, "admin")
    return list(Article.objects.using("admin_db").all())
```

The permission check is mandatory and independent of RLS: RLS is defence-in-depth for the
row scope, never a substitute for the endpoint-level authorisation gate. Ninja auto-publishes the
OpenAPI schema for these endpoints at `/api/docs`; the bypass endpoints must still be admin-gated.

---

## RLS and Background Tasks (Celery)

Celery workers do not have an HTTP request and therefore no `RLSMiddleware` runs. Tasks that query
user-scoped tables must set the RLS context explicitly inside a transaction.

```python
from celery import shared_task
from django.db import transaction
from apps.<%AUDIT_APP%>.middleware import set_rls_context
from apps.content.models import Article


@shared_task
def send_digest_email(user_id: str) -> None:
    with transaction.atomic():
        set_rls_context(user_id)
        # All ORM queries inside this block see only the user's rows.
        articles = list(
            Article.objects.filter(user_id=user_id, digest_sent=False)
        )
        # ... process and send
```

### Rules for tasks

- Always wrap the task body in `transaction.atomic()` when using `set_rls_context`. `SET LOCAL`
  only persists for the duration of the current transaction.
- Pass `user_id` as a task argument — never access `request.user` from a Celery task.
- Tasks that operate on behalf of a system process (no specific user) must use the `admin_db`
  alias, not bypass RLS silently by omitting the context variable.

---

## Django ORM Interaction

### Standard ORM queries — no changes needed

The ORM issues SQL through the application database role. RLS applies transparently:

```python
# Returns only rows where user_id matches app.current_user_id
articles = Article.objects.filter(user=request.user)

# Equivalent — RLS enforces the same restriction even without the filter
articles = Article.objects.all()
```

The application-layer `filter` is still preferred because it makes intent explicit.

### Raw queries

```python
# BAD — raw query without setting RLS context
with connection.cursor() as cursor:
    cursor.execute("SELECT * FROM content_article")

# GOOD — set context variable first, inside a transaction
with transaction.atomic():
    set_rls_context(str(user.pk))
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM content_article")
```

### Row locking

`SET LOCAL` and `select_for_update()` both live for exactly one transaction, so they end up in
the same `atomic()` block. That block is then doing two jobs, and only one of them is visible in
the code.

**A lock only ever covers rows the policy makes visible.** PostgreSQL applies the `SELECT`
policy's `USING` clause when it chooses the rows, and `FOR UPDATE` locks what is left. With no
scope variable set, the policy matches nothing, so the lock is taken on **zero rows** and the
query returns `None` — no error, no warning, and a `TransactionManagementError` only if there is
no transaction at all.

```python
# BAD — the lock is taken before the scope exists, so it covers nothing
with transaction.atomic():
    row = Article.objects.select_for_update().filter(pk=pk).first()
    set_rls_context(str(user.pk))

# GOOD — scope first, then lock, both inside the one transaction
with transaction.atomic():
    set_rls_context(str(user.pk))
    row = Article.objects.select_for_update().filter(pk=pk).first()
    if row is None:
        raise InvariantViolation("article.locked_row_exists", pk=pk)
```

The guard is the point. "No row" here has two causes that look identical — the row is genuinely
absent, or the scope was never set — and only one of them is a user's problem. Treating the
result as a benign not-found is how a missing scope variable ships silently. Which class it
belongs to and how it must surface: [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md).

---

### New Modules — RLS is Mandatory

Every new backend module that owns user-scoped tables must include RLS policies in `0001_initial.py`.
There is no acceptable window between table creation and RLS enforcement.

```python
from django.db import migrations

_TABLE = "myapp_mymodel"
_U = "current_setting('app.current_user_id', true)::bigint"


def _rls_on(_, se):
    if se.connection.vendor != "postgresql":
        return
    se.execute(f"ALTER TABLE {_TABLE} ENABLE ROW LEVEL SECURITY;")
    se.execute(f"ALTER TABLE {_TABLE} FORCE ROW LEVEL SECURITY;")
    se.execute(f"CREATE POLICY mymodel_owner_select ON {_TABLE} FOR SELECT USING (user_id = {_U});")
    se.execute(f"CREATE POLICY mymodel_open_insert ON {_TABLE} FOR INSERT WITH CHECK (true);")
    se.execute(
        f"CREATE POLICY mymodel_owner_update ON {_TABLE} FOR UPDATE USING (user_id = {_U}) WITH CHECK (user_id = {_U});"
    )
    se.execute(f"CREATE POLICY mymodel_owner_delete ON {_TABLE} FOR DELETE USING (user_id = {_U});")


def _rls_off(_, se):
    if se.connection.vendor != "postgresql":
        return
    se.execute(f"DROP POLICY IF EXISTS mymodel_owner_select ON {_TABLE};")
    se.execute(f"DROP POLICY IF EXISTS mymodel_open_insert ON {_TABLE};")
    se.execute(f"DROP POLICY IF EXISTS mymodel_owner_update ON {_TABLE};")
    se.execute(f"DROP POLICY IF EXISTS mymodel_owner_delete ON {_TABLE};")
    se.execute(f"ALTER TABLE {_TABLE} DISABLE ROW LEVEL SECURITY;")


class Migration(migrations.Migration):
    dependencies = []
    operations = [
        # ... CreateModel operations ...
        migrations.RunPython(_rls_on, reverse_code=_rls_off),
    ]
```

_Part of the `code/docs/` documentation family. See [`../RLS-GUIDE.md`](../RLS-GUIDE.md) for the full index._
