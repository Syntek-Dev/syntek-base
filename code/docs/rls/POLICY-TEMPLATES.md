---
type: guide
skills: [database, stack-django]
model: opus
---

# RLS Guide — Policy Templates

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Reusable RLS policy templates: owner-scoped, tenant-scoped SQL patterns

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

## Open RLS Policy on pending_oauth_session

The `pending_oauth_session` table uses an open SELECT policy (all rows visible), which is
intentional by design. The security model relies on two properties:

1. **UUID primary key (v4).** Guessing a valid UUID is computationally infeasible (~1 in 2^122).

2. **600-second TTL.** Rows expire within 10 minutes. The attack surface shrinks to the time
   between session creation and expiry.

Because OAuth state parameters are transmitted over HTTPS and validated in the same browser session
that initiated the flow, an attacker who cannot intercept HTTPS traffic cannot obtain a valid state
token.

**Trade-off:** A strict per-user RLS policy would require that the RLS session variable is set
_before_ the OAuth callback is processed — which is impossible because the callback arrives without
an authenticated session. Open SELECT is the only viable approach without introducing a separate
unguessable lookup token.

**Do not apply user-scoped RLS to this table.** If the threat model changes, introduce a separate
lookup mechanism rather than forcing a per-user RLS constraint on the callback path.

---

## Performance

### Index the columns used in policies

Every RLS policy expression must be backed by an index:

```python
class Article(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, db_index=True)

    class Meta:
        indexes = [
            models.Index(fields=["user", "is_published"], name="article_user_published_idx"),
        ]
```

### EXPLAIN output

Run `EXPLAIN (ANALYZE, BUFFERS)` on queries against RLS-protected tables to verify the index is
used:

```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM content_article;
-- Expected: Index Scan using article_user_published_idx
-- Not expected: Seq Scan (signals missing index)
```

### Connection pooling

`SET LOCAL` scopes the variable to the current transaction. When using PgBouncer in transaction
mode, the variable is correctly cleared at transaction end. Never use session mode with RLS session
variables — the variable persists across connection pool reuse.

---

## Model Documentation

Document active policies in the model's `db_table_comment`:

```python
class Article(models.Model):
    class Meta:
        db_table = "content_article"
        db_table_comment = (
            "User articles. RLS: article_select_own / article_insert_own / "
            "article_update_own / article_delete_own"
        )
```

_Part of the `code/docs/` documentation family. See [`../RLS-GUIDE.md`](../RLS-GUIDE.md) for the full index._
