---
type: guide
skills: [database, stack-django]
model: opus
---

# RLS Guide — Fundamentals

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — RLS concepts, PostgreSQL policy enforcement, when to apply row scoping

---

## Overview

Row Level Security (RLS) enforces data isolation at the PostgreSQL engine level. A policy attached
to a table restricts which rows any given database connection can read or write — regardless of how
the query was constructed.

Application-layer filtering (e.g. `filter(user=request.user)` in Django) is the first line of
defence. It is also fragile: a missing `WHERE` clause, a background job running without a user
context, or a direct database connection bypasses it entirely. RLS is the last line of defence that
cannot be bypassed by application code running under a restricted database role.

**The guarantee:** when RLS is enabled and enforced on a table, a query that does not satisfy the
policy returns zero rows — it does not raise an error and it does not return rows it should not.

---

## When to Use RLS

Enable RLS on every table that meets any of the following criteria:

| Criterion                               | Example tables                                   |
| --------------------------------------- | ------------------------------------------------ |
| Contains rows scoped to a specific user | `user_preferences`, `notifications`, `sessions`  |
| Contains PII or sensitive personal data | `addresses`, `payment_methods`, `health_records` |
| Used for user-owned rows                | Any table where per-row ownership is tracked     |

Do not apply RLS to:

- Purely public reference tables (currencies, countries, feature flags with no per-user rows).
- **Platform-global RBAC reference tables** — `users_adminrole` and `users_adminrolepermission`.
  These are shared role definitions consumed by every admin, not user-scoped rows; access is
  controlled at the service layer by the area-RBAC gate on the admin-role endpoints, not per-row.
  (`users_adminmember` and `users_modulepermission` remain user-scoped and DO keep RLS.)
- Django's internal tables (`django_*`, `auth_permission`, `contenttypes`).
- Migration tables.

---

## Choosing the isolation scope

RLS enforces isolation at **one named scope per table**. Which scope that is — the owning
user, an account or organisation, or a tenant — is a domain decision settled **before the
table's first migration**, through a grilling pass (`.claude/skills/grill-with-docs`) covering
ownership, cardinality, invariants, and expected query shapes. It is not a default to inherit.

Record the answer in the model's `db_table_comment` alongside the policy names, so the scope
is discoverable from the schema rather than only from the migration that created it.

**Set only the scope variables your policies read.** A session variable written on every
request but consumed by no policy is worse than absent: it reads as isolation, tests green,
and silently falls back to a sentinel if the attribute it derives from does not exist. Reserve
a variable by leaving it unset and documenting the intent — never by writing a placeholder.
See `MIDDLEWARE-AND-NINJA.md`.

The defence layers are:

```text
┌──────────────────────────────────────────────┐
│  Application layer (Django ORM filter)        │  fragile — first line
├──────────────────────────────────────────────┤
│  Row Level Security (PostgreSQL engine)       │  strongest — DB engine
└──────────────────────────────────────────────┘
```

Policy expression for an owner-scoped table:

- `user_id = current_setting('app.current_user_id', true)::<pk type>`

The cast must match the scope column's own type — a `uuid` column casts to `uuid`, an integer
primary key to `bigint`. A mismatched cast raises at query time rather than failing closed, so
it surfaces as an error on a real request rather than in review.

Adding a second scope variable is a schema-level change, not a middleware tweak: it needs the
column, a policy that reads it, an index that supports it, and the middleware that sets it —
all four, together.

---

## Enabling RLS in Django Migrations

Use `RunSQL` in the migration that creates the table. Define RLS in the same migration as the
`CREATE TABLE` statement — not a separate migration added later.

```python
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [("content", "0001_initial")]

    operations = [
        # 1. Enable RLS on the table
        migrations.RunSQL(
            sql="""
                ALTER TABLE content_article
                    ENABLE ROW LEVEL SECURITY;

                ALTER TABLE content_article
                    FORCE ROW LEVEL SECURITY;
            """,
            reverse_sql="ALTER TABLE content_article DISABLE ROW LEVEL SECURITY;",
        ),

        # 2. SELECT policy
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_select_own
                    ON content_article
                    FOR SELECT
                    USING (user_id = current_setting('app.current_user_id', true)::uuid);
            """,
            reverse_sql="DROP POLICY IF EXISTS article_select_own ON content_article;",
        ),

        # 3. INSERT policy
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_insert_own
                    ON content_article
                    FOR INSERT
                    WITH CHECK (user_id = current_setting('app.current_user_id', true)::uuid);
            """,
            reverse_sql="DROP POLICY IF EXISTS article_insert_own ON content_article;",
        ),

        # 4. UPDATE policy
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_update_own
                    ON content_article
                    FOR UPDATE
                    USING (user_id = current_setting('app.current_user_id', true)::uuid)
                    WITH CHECK (user_id = current_setting('app.current_user_id', true)::uuid);
            """,
            reverse_sql="DROP POLICY IF EXISTS article_update_own ON content_article;",
        ),

        # 5. DELETE policy
        migrations.RunSQL(
            sql="""
                CREATE POLICY article_delete_own
                    ON content_article
                    FOR DELETE
                    USING (user_id = current_setting('app.current_user_id', true)::uuid);
            """,
            reverse_sql="DROP POLICY IF EXISTS article_delete_own ON content_article;",
        ),
    ]
```

### Migration rules

- Always use `FORCE ROW LEVEL SECURITY`. Without `FORCE`, the table owner bypasses all policies.
- Always provide `reverse_sql` for every `RunSQL` operation. Migrations must be reversible.
- Separate each policy into its own `RunSQL` call so rollbacks are granular.
- Use `current_setting('app.current_user_id', true)` — the `true` argument means return `NULL`
  if the setting is not set, rather than raising an error. The policy then evaluates to
  `NULL = NULL` which is `FALSE`, so no rows are returned.

---

## The app_user Session Variable Pattern

PostgreSQL session variables (set with `SET LOCAL`) pass context from the application to RLS
policies without requiring extra columns or joins. `SET LOCAL` scopes the variable to the current
transaction — it is automatically cleared when the transaction ends.

### Variable naming convention

| Variable                | Type   | Set by        | Used for               |
| ----------------------- | ------ | ------------- | ---------------------- |
| `app.current_user_id`   | `uuid` | RLSMiddleware | Per-user row isolation |
| `app.current_tenant_id` | `uuid` | RLSMiddleware | Reserved (future use)  |

### Setting the variables in a transaction

Both variables must be set in the **same** `cursor.execute` call to guarantee they are always
consistent:

```python
from django.db import connection

_SET_RLS_SQL = """
SELECT set_config('app.current_user_id',   %s, true),
       set_config('app.current_tenant_id', %s, true)
"""


def set_rls_context(user_id: str, tenant_id: str = "") -> None:
    """Set both RLS session variables for the current transaction."""
    with connection.cursor() as cursor:
        cursor.execute(_SET_RLS_SQL, [str(user_id), str(tenant_id)])
```

The third argument to `set_config` is `is_local` — `true` means the setting applies only for the
current transaction. Never use `false` (session-scoped).

**Import path:** `from apps.<%AUDIT_APP%>.middleware import set_rls_context`

---

## The BYPASSRLS Role

PostgreSQL superusers and roles with the `BYPASSRLS` attribute bypass all RLS policies.

### Rules

- The application database role must **never** have `BYPASSRLS` or superuser privileges.
- The migration/admin role **may** have `BYPASSRLS` for migrations.
- The `BYPASSRLS` role must use a separate named database alias (`admin_db`) in Django's `DATABASES`
  configuration so that its use is explicit and auditable.

```python
# settings.py
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "USER": env("DB_APP_USER"),      # least-privilege role, no BYPASSRLS
        ...
    },
    "admin_db": {
        "ENGINE": "django.db.backends.postgresql",
        "USER": env("DB_ADMIN_USER"),    # BYPASSRLS role
        ...
    },
}
```

---

## Auditing Existing Tables

```sql
-- Tables without RLS that likely need it
SELECT t.table_name, c.relrowsecurity AS rls_enabled
FROM information_schema.tables t
JOIN pg_class c ON c.relname = t.table_name
JOIN pg_namespace n ON n.oid = c.relnamespace AND n.nspname = t.table_schema
WHERE t.table_type = 'BASE TABLE'
  AND t.table_schema NOT IN ('pg_catalog', 'information_schema')
  AND EXISTS (
      SELECT 1 FROM information_schema.columns col
      WHERE col.table_name = t.table_name
        AND col.column_name IN ('user_id', 'tenant_id', 'owner_id', 'created_by_id')
  )
  AND c.relrowsecurity = false
ORDER BY t.table_name;

-- List all active policies
SELECT schemaname, tablename, policyname, cmd, qual
FROM pg_policies
ORDER BY schemaname, tablename, policyname;
```

_Part of the `code/docs/` documentation family. See [`../RLS-GUIDE.md`](../RLS-GUIDE.md) for the full index._
