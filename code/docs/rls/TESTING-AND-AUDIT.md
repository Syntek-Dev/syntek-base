---
type: guide
agent: database
skills: [stack-django]
model: opus
---

# RLS Guide — Testing and Security Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Testing RLS policies with testcontainers, security audit checklist

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
    """Verify RLS policies on content_article."""

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

Every policy (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) must have at least:

1. A positive test — the correct user can perform the operation.
2. A negative test — a different user cannot perform the operation.
3. A missing-context test — no `app.current_user_id` set returns zero rows / raises.

RLS policy tests count toward the module's coverage floor (75% minimum; 90% for auth-related apps).

---

## Security Checklist

Before merging any migration or service that touches a user-scoped table:

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
- [ ] Django Ninja endpoints do not issue raw queries without first calling `set_rls_context`
- [ ] Admin endpoints that bypass RLS use the `admin_db` alias and require an explicit permission
      check
- [ ] All columns used in policy expressions have a database index
- [ ] `EXPLAIN` confirms index usage on at least one representative query per policy
- [ ] Positive, negative, and missing-context tests exist for each policy
- [ ] The `db_table_comment` on the model lists all active policies
- [ ] Migration `reverse_sql` is provided for every `RunSQL` RLS statement

_Part of the `code/docs/` documentation family. See [`../RLS-GUIDE.md`](../RLS-GUIDE.md) for the full index._
