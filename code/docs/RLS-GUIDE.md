# Row Level Security Guide

**Last Updated**: 07/04/2026 **Version**: 1.1.0 **Maintained By**: Syntek Development Team
**Language**: British English (en_GB) **Timezone**: Europe/London

---

## Table of Contents

- [Overview](#overview)
- [When to Use RLS](#when-to-use-rls)
- [RLS and Application Isolation](#rls-and-application-isolation)
- [Defence-in-Depth Model](#defence-in-depth-model)
- [Enabling RLS in Django Migrations](#enabling-rls-in-django-migrations)
- [The app_user Session Variable Pattern](#the-app_user-session-variable-pattern)
- [RLSMiddleware for Django](#rlsmiddleware-for-django)
- [RLS with Strawberry GraphQL](#rls-with-strawberry-graphql)
- [RLS and Background Tasks (Celery)](#rls-and-background-tasks-celery)
- [Policy Templates](#policy-templates)
- [Open RLS Policy on pending_oauth_session](#open-rls-policy-on-pending_oauth_session-info-004)
- [Django ORM Interaction](#django-orm-interaction)
- [Testing RLS Policies](#testing-rls-policies)
- [Performance](#performance)
- [The BYPASSRLS Role](#the-bypassrls-role)
- [Auditing Existing Tables](#auditing-existing-tables)
- [Security Checklist](#security-checklist)

---

## Overview

Row Level Security (RLS) enforces data isolation at the PostgreSQL engine level. A policy attached
to a table restricts which rows any given database connection can read or write — regardless of how
the query was constructed.

Application-layer filtering (e.g. `filter(tenant=request.tenant)` in Django) is the first line of
defence. It is also fragile: a missing `WHERE` clause, a background job running without a tenant
context, or a direct database connection bypasses it entirely. RLS is the last line of defence that
cannot be bypassed by application code running under a restricted database role.

**The guarantee:** when RLS is enabled and enforced on a table, a query that does not satisfy the
policy returns zero rows — it does not raise an error and it does not return rows it should not.

---

## When to Use RLS

Enable RLS on every table that meets any of the following criteria:

| Criterion                                          | Example tables                                            |
| -------------------------------------------------- | --------------------------------------------------------- |
| Contains rows scoped to a specific tenant          | `orders`, `invoices`, `members`, `bookings`               |
| Contains rows scoped to a specific user            | `user_preferences`, `notifications`, `sessions`           |
| Contains PII or sensitive personal data            | `addresses`, `payment_methods`, `health_records`          |
| Used for user-owned rows                           | Any table where per-row ownership is tracked              |
| Is shared across tenants but with row-level grants | Shared lookup tables with per-tenant visibility overrides |

Do not apply RLS to:

- Purely public reference tables (currencies, countries, feature flags with no per-tenant rows).
- Django's internal tables (`django_*`, `auth_permission`, `contenttypes`). These are managed by
  Django and bypassing RLS on them is correct.
- Migration tables. The migration user must be able to read `django_migrations` freely.

---

## RLS and Application Isolation

syntek-website is a **single-tenant application** — there is no tenant schema isolation layer.
RLS is used exclusively for **user-level row isolation**: ensuring that each authenticated user
can only read and write their own rows.

The defence layers are:

```text
┌──────────────────────────────────────────────┐
│  Application layer (Django ORM filter)        │  fragile — first line
├──────────────────────────────────────────────┤
│  Row Level Security (this guide)             │  strongest — DB engine
└──────────────────────────────────────────────┘
```

Policy expression for all user-scoped tables:

- `user_id = current_setting('app.current_user_id', true)::uuid`

There is no `app.current_tenant_id` requirement in this project. The `tenant_id` variable is
accepted by `set_rls_context` for forward compatibility but is not used in any active policy.

---

## Defence-in-Depth Model

The layers involved in a typical Syntek request that accesses a user-scoped table:

```text
HTTP request
  │
  ▼
RLSMiddleware          sets app.current_user_id via SET LOCAL (single call)
  │
  ▼
Django ORM             .filter(user=request.user) — application filter
  │
  ▼
PostgreSQL RLS         enforces policy regardless of ORM filter
  │
  ▼
Python encryption      decrypts sensitive fields after row is retrieved
  │
  ▼
Strawberry resolver    returns data to client
```

Each layer operates independently. A failure in one does not defeat the others.

---

## Enabling RLS in Django Migrations

Use `RunSQL` in the migration that creates the table. Define RLS in the same migration as the
`CREATE TABLE` statement — not a separate migration added later.

```python
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("content", "0001_initial"),
    ]

    operations = [
        # 1. Enable RLS on the table
        migrations.RunSQL(
            sql="""
                ALTER TABLE content_article
                    ENABLE ROW LEVEL SECURITY;

                ALTER TABLE content_article
                    FORCE ROW LEVEL SECURITY;
            """,
            reverse_sql="""
                ALTER TABLE content_article
                    DISABLE ROW LEVEL SECURITY;
            """,
        ),

        # 2. SELECT policy — users see only their own rows
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_select_own
                    ON content_article
                    FOR SELECT
                    USING (
                        user_id = current_setting('app.current_user_id', true)::uuid
                    );
            """,
            reverse_sql="""
                DROP POLICY IF EXISTS article_select_own
                    ON content_article;
            """,
        ),

        # 3. INSERT policy — users may only insert rows for themselves
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_insert_own
                    ON content_article
                    FOR INSERT
                    WITH CHECK (
                        user_id = current_setting('app.current_user_id', true)::uuid
                    );
            """,
            reverse_sql="""
                DROP POLICY IF EXISTS article_insert_own
                    ON content_article;
            """,
        ),

        # 4. UPDATE policy — users may only update their own rows
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_update_own
                    ON content_article
                    FOR UPDATE
                    USING (
                        user_id = current_setting('app.current_user_id', true)::uuid
                    )
                    WITH CHECK (
                        user_id = current_setting('app.current_user_id', true)::uuid
                    );
            """,
            reverse_sql="""
                DROP POLICY IF EXISTS article_update_own
                    ON content_article;
            """,
        ),

        # 5. DELETE policy — users may only delete their own rows
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_delete_own
                    ON content_article
                    FOR DELETE
                    USING (
                        user_id = current_setting('app.current_user_id', true)::uuid
                    );
            """,
            reverse_sql="""
                DROP POLICY IF EXISTS article_delete_own
                    ON content_article;
            """,
        ),
    ]
```

### Migration rules

- Always use `FORCE ROW LEVEL SECURITY`. Without `FORCE`, the table owner (typically the migration
  role) bypasses all policies.
- Always provide `reverse_sql` for every `RunSQL` operation. Migrations must be reversible.
- Separate each policy into its own `RunSQL` call so rollbacks are granular.
- Use `current_setting('app.current_user_id', true)` — the second argument `true` means return
  `NULL` if the setting is not set, rather than raising an error. The policy then evaluates to
  `NULL = NULL` which is `FALSE`, so no rows are returned. This is the correct safe default.

---

## The app_user Session Variable Pattern

PostgreSQL session variables (set with `SET LOCAL`) pass context from the application to RLS
policies without requiring extra columns or joins. `SET LOCAL` scopes the variable to the current
transaction — it is automatically cleared when the transaction ends.

### Variable naming convention

| Variable                | Type   | Set by        | Used for                                 |
| ----------------------- | ------ | ------------- | ---------------------------------------- |
| `app.current_user_id`   | `uuid` | RLSMiddleware | Per-user row isolation                   |
| `app.current_tenant_id` | `uuid` | RLSMiddleware | Per-tenant row isolation (shared schema) |

### Setting the variables in a transaction

Both `app.current_user_id` and `app.current_tenant_id` must be set in the **same** `cursor.execute`
call to guarantee they are always consistent and cannot be partially applied (MED-017 / RLS-02):

```python
from django.db import connection

_SET_RLS_SQL = """
SELECT set_config('app.current_user_id',   %s, true),
       set_config('app.current_tenant_id', %s, true)
"""


def set_rls_context(user_id: str, tenant_id: str = "") -> None:
    """Set both RLS session variables for the current transaction.

    Sets ``app.current_user_id`` and ``app.current_tenant_id`` atomically
    in a single SQL call. Must be called inside an active transaction.
    Uses SET LOCAL (is_local=true) so both variables are automatically
    cleared when the transaction ends.

    Pass an empty string for ``tenant_id`` for system-level operations
    that have no tenant context (e.g. pre-auth audit events).
    """
    with connection.cursor() as cursor:
        cursor.execute(_SET_RLS_SQL, [str(user_id), str(tenant_id)])
```

The third argument to `set_config` is `is_local` — `true` means the setting applies only for the
current transaction. Never use `false` (session-scoped), which would persist the value across
connection pool reuse.

**Import path:** `from apps.audit.middleware import set_rls_context`

---

## RLSMiddleware for Django

`RLSMiddleware` lives in `apps.audit.middleware` and sets **both** `app.current_user_id` and
`app.current_tenant_id` in a single SQL call on every authenticated request (MED-017 / RLS-02). The
two variables must be set atomically — using two separate `execute` calls would leave a window where
only one is set, breaking policies that check both.

```python
# apps/audit/middleware.py
import logging
from django.db import connection

logger = logging.getLogger("apps.audit")

_SET_RLS_SQL = """
SELECT set_config('app.current_user_id',   %s, true),
       set_config('app.current_tenant_id', %s, true)
"""


class RLSMiddleware:
    """Set both PostgreSQL RLS session variables for every authenticated request.

    Sets app.current_user_id and app.current_tenant_id atomically in a single
    SQL call. Must appear after AuthenticationMiddleware and TenantMiddleware in
    MIDDLEWARE. Uses SET LOCAL (is_local=true) so both variables are scoped to
    the current transaction and are never reused across connection pool connections.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        user = getattr(request, "user", None)
        if user is not None and getattr(user, "is_authenticated", False):
            self._set_rls_context(request)
        return self.get_response(request)

    def _set_rls_context(self, request) -> None:
        user_id = str(request.user.pk)
        tenant = getattr(request, "tenant", None)
        tenant_id = str(tenant.pk) if tenant is not None else ""
        try:
            with connection.cursor() as cursor:
                cursor.execute(_SET_RLS_SQL, [user_id, tenant_id])
        except Exception:
            logger.error(
                "audit: failed to set RLS context for user %s / tenant %r",
                user_id, tenant_id,
                exc_info=True,
            )
            raise
```

### Middleware order

```python
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "apps.audit.middleware.RLSMiddleware",         # sets both RLS context variables
    # application middleware below
]
```

### Rules

- `RLSMiddleware` must run **after** `AuthenticationMiddleware` — `request.user` must be set.
- **Both variables must be set in a single `cursor.execute` call** — never two separate calls. A
  partial set (only `user_id`, or only `tenant_id`) leaves policies in an inconsistent state.
- If the request has no authenticated user (unauthenticated endpoint), do not set either variable.
  Policies evaluate `NULL = NULL → FALSE` and return zero rows, which is the correct safe default.
- `tenant_id` defaults to `""` for all requests in this single-tenant application — it is accepted
  by `set_rls_context` for forward compatibility but is not used in active policies.
- Never log the user ID alongside other sensitive request data — the middleware logs only on error.

---

## RLS with Strawberry GraphQL

Strawberry resolvers run in the request context after middleware has already executed. If
`RLSMiddleware` is in `MIDDLEWARE`, the session variable is already set when the resolver runs.

**Resolvers must not issue raw queries that bypass RLS.** The rules:

1. Use `Model.objects.filter(...)` — the ORM always uses the restricted application role.
2. If a resolver calls `connection.cursor()` for a raw query, it must set the RLS context explicitly
   using `set_rls_context` before the query.
3. Never execute raw queries in a resolver using the migration role or any role with `BYPASSRLS`.

```python
# schema.py
import strawberry
from strawberry.types import Info
from apps.content.models import Article


@strawberry.type
class Query:
    @strawberry.field
    def my_articles(self, info: Info) -> list["ArticleType"]:
        # RLS context is already set by RLSMiddleware.
        # The ORM query returns only rows the policy permits.
        user = info.context["request"].user
        return list(Article.objects.filter(user=user).order_by("-created_at")[:50])
```

### Admin resolvers that must see all rows

Admin resolvers that legitimately need to bypass RLS (e.g. a super-admin listing all articles)
must:

1. Check the caller has the `admin` permission via `_require_permission`.
2. Execute the query using the migration/admin database alias (`using="admin_db"`) which connects
   with the `BYPASSRLS` role — never the default application role.
3. Document the bypass explicitly with a comment.

```python
@strawberry.field
def all_articles_admin(self, info: Info) -> list["ArticleType"]:
    # ADMIN ONLY — bypasses RLS via admin_db alias.
    # Requires admin permission.
    _require_permission(info, "admin")
    return list(Article.objects.using("admin_db").all())
```

---

## RLS and Background Tasks (Celery)

Celery workers do not have an HTTP request and therefore no `RLSMiddleware` runs. Tasks that query
user-scoped tables must set the RLS context explicitly inside a transaction.

```python
from celery import shared_task
from django.db import transaction
from apps.audit.middleware import set_rls_context
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

- Always wrap the task body in `transaction.atomic()` when using `set_rls_context`. `SET LOCAL` only
  persists for the duration of the current transaction.
- Pass `user_id` as a task argument — never access `request.user` from a Celery task.
- `set_rls_context` sets both variables in a single SQL call — never call it twice with separate
  arguments.
- Tasks that operate on behalf of a system process (no specific user) must use the admin database
  alias, not bypass RLS silently by omitting the context variable.

---

## RLS and the Python Encryption Layer

`encrypt_field` and `decrypt_field` (from `apps.core.encryption`) operate on individual field
values and do not issue SQL queries. They are not affected by RLS.

When a service method calls `encrypt_field` before `save()` or `decrypt_field` after a query,
RLS is enforced by the active transaction's `app.current_user_id` session variable. Encryption
and RLS are complementary — encryption protects data at rest; RLS controls which rows the
DB engine returns.

The call order within a transaction does not matter: set the RLS context, call `save()` /
`filter()`, and the DB handles row-level isolation while the Python layer handles field-level
encryption:

```python
# Inside a service method that encrypts a field and writes to the DB
with transaction.atomic():
    set_rls_context(str(user.pk))
    ciphertext = encrypt_field(plaintext, _field_key, "MyModel", "data")
    MyModel.objects.create(user=user, data=ciphertext)
```

---

## Policy Templates

### Owner-only (user-scoped)

```sql
-- User sees and modifies only their own rows
CREATE POLICY {table}_user_isolation
    ON {table}
    USING (user_id = current_setting('app.current_user_id', true)::uuid)
    WITH CHECK (user_id = current_setting('app.current_user_id', true)::uuid);
```

### Tenant-scoped (shared schema mode)

```sql
-- Row must belong to the current tenant AND the current user
CREATE POLICY {table}_tenant_user_isolation
    ON {table}
    USING (
        tenant_id = current_setting('app.current_tenant_id', true)::uuid
        AND user_id = current_setting('app.current_user_id', true)::uuid
    )
    WITH CHECK (
        tenant_id = current_setting('app.current_tenant_id', true)::uuid
        AND user_id = current_setting('app.current_user_id', true)::uuid
    );
```

### Role-based (tenant members)

```sql
-- Any user in the tenant may read; only the owner may write
CREATE POLICY {table}_tenant_read
    ON {table}
    FOR SELECT
    USING (tenant_id = current_setting('app.current_tenant_id', true)::uuid);

CREATE POLICY {table}_owner_write
    ON {table}
    FOR INSERT UPDATE DELETE
    USING (owner_id = current_setting('app.current_user_id', true)::uuid)
    WITH CHECK (owner_id = current_setting('app.current_user_id', true)::uuid);
```

### Shared rows (public read, owner write)

```sql
-- All authenticated users can read; only the creator can write
CREATE POLICY {table}_public_read
    ON {table}
    FOR SELECT
    USING (current_setting('app.current_user_id', true) IS NOT NULL);

CREATE POLICY {table}_creator_write
    ON {table}
    FOR INSERT UPDATE DELETE
    USING (created_by_id = current_setting('app.current_user_id', true)::uuid)
    WITH CHECK (created_by_id = current_setting('app.current_user_id', true)::uuid);
```

---

## Open RLS Policy on pending_oauth_session (INFO-004)

The `pending_oauth_session` table uses an open SELECT policy (all rows visible), which is
intentional by design. The security model relies on two properties:

1. **UUID primary key (v4).** The probability of guessing a valid UUID at random is approximately 1
   in 2^122 — computationally infeasible in any realistic attack window.

2. **600-second TTL.** Rows expire within 10 minutes. The attack surface shrinks to the time between
   session creation and expiry; guessing a valid UUID within that window is still infeasible.

Because OAuth state parameters are transmitted over HTTPS and validated in the same browser session
that initiated the flow, an attacker who cannot intercept HTTPS traffic cannot obtain a valid state
token to look up.

**Trade-off:** A strict per-user RLS policy on this table would require that the RLS session
variable is set _before_ the OAuth callback is processed — which is impossible because the callback
arrives without an authenticated session. Open SELECT is the only viable approach without
introducing a separate unguessable lookup token.

**Do not apply user-scoped RLS to this table.** If the threat model changes (e.g. multi-user OAuth
flows where session isolation matters), introduce a separate lookup mechanism rather than forcing a
per-user RLS constraint on the callback path.

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

The second query returns the same rows as the first when RLS is active and the context is set. The
application-layer `filter` is still preferred because it makes intent explicit and it works
correctly in test environments where RLS may not be active.

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

### `db_default` and computed columns

`db_default` values are set by PostgreSQL at INSERT time. They do not interact with RLS — the
policy's `WITH CHECK` clause runs after the row is constructed, checking the values being written
rather than the `db_default`.

### `Meta.db_table_comment`

Table comments are metadata and are not affected by RLS. They should document which RLS policies are
active:

```python
class Article(models.Model):
    class Meta:
        db_table = "content_article"
        db_table_comment = (
            "User articles. RLS: article_select_own / article_insert_own / "
            "article_update_own / article_delete_own"
        )
```

---

## Testing RLS Policies

Use `testcontainers-python` with PostgreSQL 18.3 to run tests against a real database engine. Never
mock RLS — mock RLS tests do not verify that the policies are correct.

### Test structure

```python
# tests/test_rls_articles.py
import pytest
from django.contrib.auth import get_user_model
from django.db import connection, transaction

User = get_user_model()


@pytest.mark.django_db(transaction=True)
class TestArticleRLS:
    """Verify RLS policies on content_article.

    Each test uses a real PostgreSQL transaction with SET LOCAL to confirm
    that the policy correctly permits or denies access.
    """

    def test_user_sees_only_own_articles(self, user_a, user_b, article_factory):
        article_factory(user=user_a)
        article_factory(user=user_b)

        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT set_config('app.current_user_id', %s, true)",
                    [str(user_a.pk)],
                )
            from apps.content.models import Article
            visible = list(Article.objects.all())

        assert len(visible) == 1
        assert visible[0].user_id == user_a.pk

    def test_unauthenticated_context_returns_no_rows(self, user_a, article_factory):
        article_factory(user=user_a)

        with transaction.atomic():
            # Do not set app.current_user_id — simulates missing context
            from apps.content.models import Article
            visible = list(Article.objects.all())

        assert visible == []

    def test_user_cannot_read_other_users_rows(self, user_a, user_b, article_factory):
        target = article_factory(user=user_b)

        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT set_config('app.current_user_id', %s, true)",
                    [str(user_a.pk)],
                )
            from apps.content.models import Article
            result = Article.objects.filter(pk=target.pk).first()

        assert result is None

    def test_insert_policy_prevents_spoofing_user_id(self, user_a, user_b):
        with transaction.atomic():
            with connection.cursor() as cursor:
                cursor.execute(
                    "SELECT set_config('app.current_user_id', %s, true)",
                    [str(user_a.pk)],
                )
            from apps.content.models import Article
            import pytest as _pytest
            with _pytest.raises(Exception):
                # Attempting to insert a row for user_b while context is user_a
                Article.objects.create(user_id=user_b.pk, title="spoofed")
```

### Coverage requirement

RLS policy tests count toward the module's coverage floor (75% minimum; 90% for auth-related apps).
Every policy (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) must have at least:

1. A positive test — the correct user can perform the operation.
2. A negative test — a different user cannot perform the operation.
3. A missing-context test — no `app.current_user_id` set returns zero rows / raises.

---

## Performance

### Index the columns used in policies

Every RLS policy expression must be backed by an index. Without an index, PostgreSQL evaluates the
policy by scanning every row.

```python
# In the model
class Article(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, db_index=True)
    # db_index=True on a ForeignKey is the default — verify it is present

    class Meta:
        indexes = [
            # Composite index for common query pattern: user + published status
            models.Index(fields=["user", "is_published"], name="article_user_published_idx"),
        ]
```

For shared-schema multi-tenant tables, index `tenant_id` and `user_id` together:

```python
models.Index(fields=["tenant", "user"], name="table_tenant_user_idx")
```

### EXPLAIN output

Run `EXPLAIN (ANALYZE, BUFFERS)` on queries against RLS-protected tables to verify the index is
used. An `Index Scan` or `Bitmap Index Scan` on the `user_id`/`tenant_id` index confirms the policy
is evaluated efficiently:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM content_article;
-- Expected: Index Scan using article_user_published_idx
-- Not expected: Seq Scan (signals missing index)
```

### Connection pooling

`SET LOCAL` scopes the variable to the current transaction. When using PgBouncer or another
connection pooler in transaction mode, the variable is correctly cleared at transaction end. Never
use session mode with RLS session variables — the variable persists across connection pool reuse.

---

## The BYPASSRLS Role

PostgreSQL superusers and roles with the `BYPASSRLS` attribute bypass all RLS policies.

### Rules

- The application database role must **never** have `BYPASSRLS` or superuser privileges.
- The migration/admin role **may** have `BYPASSRLS` — it must apply and verify migrations without
  being blocked by policies it is in the process of creating.
- The `BYPASSRLS` role must use a separate named database alias (`admin_db`) in Django's `DATABASES`
  configuration so that its use is explicit and auditable.
- Any resolver, service, or task that uses the `admin_db` alias must document why and must require
  an explicit permission check (`_require_permission`).

```python
# settings.py
DATABASES = {
    "default": {
        # Application role — restricted, respects RLS
        "ENGINE": "django.db.backends.postgresql",
        "NAME": env("DB_NAME"),
        "USER": env("DB_APP_USER"),      # least-privilege role, no BYPASSRLS
        "PASSWORD": env("DB_APP_PASSWORD"),
        "HOST": env("DB_HOST"),
    },
    "admin_db": {
        # Migration/admin role — BYPASSRLS for migrations and admin queries
        "ENGINE": "django.db.backends.postgresql",
        "NAME": env("DB_NAME"),
        "USER": env("DB_ADMIN_USER"),    # BYPASSRLS role
        "PASSWORD": env("DB_ADMIN_PASSWORD"),
        "HOST": env("DB_HOST"),
    },
}
```

Run migrations against `admin_db`:

```bash
docker compose exec backend python manage.py migrate --database=admin_db
```

---

## Auditing Existing Tables

Run this query against any database to identify user-scoped or tenant-scoped tables that do not yet
have RLS enabled:

```sql
-- Tables without RLS that likely need it (heuristic: column name contains user_id or tenant_id)
SELECT
    t.table_schema,
    t.table_name,
    c.relrowsecurity AS rls_enabled,
    c.relforcerowsecurity AS rls_forced
FROM information_schema.tables t
JOIN pg_class c
    ON c.relname = t.table_name
JOIN pg_namespace n
    ON n.oid = c.relnamespace
    AND n.nspname = t.table_schema
WHERE t.table_type = 'BASE TABLE'
  AND t.table_schema NOT IN ('pg_catalog', 'information_schema')
  AND (
      EXISTS (
          SELECT 1 FROM information_schema.columns col
          WHERE col.table_name = t.table_name
            AND col.column_name IN ('user_id', 'tenant_id', 'owner_id', 'created_by_id')
      )
  )
  AND c.relrowsecurity = false
ORDER BY t.table_schema, t.table_name;
```

Run this query to list all active policies:

```sql
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
ORDER BY schemaname, tablename, policyname;
```

---

## New Modules — RLS is Mandatory

> **Every new backend module that owns user-scoped or tenant-scoped tables must include RLS policies
> in `0001_initial.py`.** There is no acceptable window between table creation and RLS enforcement
> for new code. Existing modules use separate migrations only because they predate this rule.

This rule is a **blocking criterion** — the same status as a missing `transaction.atomic()` on a
multi-write service method. Do not merge a new module without it.

### Checklist for new modules

When creating a new module with any user-scoped or tenant-scoped table:

1. **Identify which tables require RLS** — any table with a `user_id`, `tenant_id`, or
   `owner_id`-style column.
2. **Add `ENABLE ROW LEVEL SECURITY` and `FORCE ROW LEVEL SECURITY`** in `0001_initial.py` using
   `RunPython` helpers (not `RunSQL`), so the operation is a no-op on non-PostgreSQL backends.
3. **Define policies for all four operations** — `SELECT`, `INSERT`, `UPDATE`, `DELETE`. If an
   operation is not needed (e.g. immutable audit rows), use `USING (false)` to explicitly block it
   rather than leaving it undefined.
4. **Include `reverse_code`** for every `RunPython` operation so local development and test teardown
   work correctly.
5. **Write at least one positive and one negative RLS test** using `testcontainers` + `psycopg2`
   (see [Testing RLS Policies](#testing-rls-policies)).

### Why `0001_initial.py`, not a later migration

For existing modules, RLS was added in a separate migration because the tables already existed in
deployed environments. For new modules, `0001_initial.py` defines the table — there is no prior
deployment state to protect. Adding RLS here closes the gap entirely: the table is never accessible
without its policies in place.

### Example — minimal new-module RLS in `0001_initial.py`

```python
from __future__ import annotations
from collections.abc import Callable
from django.db import migrations

_TABLE = "myapp_mymodel"
_U = "current_setting('app.current_user_id', true)::bigint"

def _rls_on(_: object, se: object) -> None:
    if se.connection.vendor != "postgresql":
        return
    se.execute(f"ALTER TABLE {_TABLE} ENABLE ROW LEVEL SECURITY;")
    se.execute(f"ALTER TABLE {_TABLE} FORCE ROW LEVEL SECURITY;")
    se.execute(f"CREATE POLICY mymodel_owner_select ON {_TABLE} FOR SELECT USING (user_id = {_U});")
    se.execute(f"CREATE POLICY mymodel_open_insert ON {_TABLE} FOR INSERT WITH CHECK (true);")
    se.execute(f"CREATE POLICY mymodel_owner_update ON {_TABLE} FOR UPDATE USING (user_id = {_U}) WITH CHECK (user_id = {_U});")
    se.execute(f"CREATE POLICY mymodel_owner_delete ON {_TABLE} FOR DELETE USING (user_id = {_U});")

def _rls_off(_: object, se: object) -> None:
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

---

## Security Checklist

Before merging any migration or service that touches a user-scoped or tenant-scoped table:

- [ ] `ENABLE ROW LEVEL SECURITY` is present in the migration for the table
- [ ] `FORCE ROW LEVEL SECURITY` is present — the table owner does not bypass policies
- [ ] Policies are defined for all four operations: `SELECT`, `INSERT`, `UPDATE`, `DELETE`
- [ ] `current_setting('app.current_user_id', true)` uses the safe two-argument form
- [ ] The application database role does not have `BYPASSRLS` or superuser privileges
- [ ] `RLSMiddleware` is registered in `MIDDLEWARE` after `AuthenticationMiddleware`
- [ ] `RLSMiddleware` sets **both** `app.current_user_id` and `app.current_tenant_id` in a single
      SQL call
- [ ] `RLSMiddleware` uses `SET LOCAL` (`is_local=true`) — never session-scoped `SET`
- [ ] Celery tasks that query user-scoped tables call `set_rls_context(user_id)` inside
      `transaction.atomic()`
- [ ] Strawberry resolvers do not issue raw queries without first calling `set_rls_context`
- [ ] Admin resolvers that bypass RLS use the `admin_db` alias and require an explicit permission
      check
- [ ] All columns used in policy expressions have a database index
- [ ] `EXPLAIN` confirms index usage on at least one representative query per policy
- [ ] Positive, negative, and missing-context tests exist for each policy
- [ ] The `db_table_comment` on the model lists all active policies
- [ ] Migration `reverse_sql` is provided for every `RunSQL` RLS statement
