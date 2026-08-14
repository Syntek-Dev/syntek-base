---
type: guide
skills: [database, stack-django]
model: opus
---

# Data Structures — Database Schema Design

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Database schema design, normalisation, indexing, PostgreSQL features

---

## PostgreSQL

The database is PostgreSQL 18 — there is no other engine to design around. Lean on the features
that make it the right choice, and let migrations (never hand-edited SQL) apply every change:

- **`jsonb`** for semi-structured data — binary, indexable, and searchable with GIN indexes.
- **Partial indexes** — a `WHERE` clause on the index (`condition=…` in Django) keeps hot indexes
  small.
- **Check constraints** — fully enforced at the database level; use them liberally.
- **Recursive CTEs** for tree and graph traversal without extra round-trips.
- **`uuid` primary keys** via `gen_random_uuid()` where a non-sequential public identifier is
  wanted (see `URL-STRATEGY.md` for where UUIDs vs slugs apply).

---

## Normalisation

**First Normal Form (1NF):** every column contains a single, atomic value. No lists, no
comma-separated strings, no arrays of mixed types.

```sql
-- BAD: violates 1NF
CREATE TABLE events (id SERIAL PRIMARY KEY, name TEXT, tags TEXT);

-- GOOD: separate table
CREATE TABLE event_tags (
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    tag TEXT NOT NULL,
    PRIMARY KEY (event_id, tag)
);
```

**Second Normal Form (2NF):** every non-key column depends on the entire primary key.

**Third Normal Form (3NF):** every non-key column depends on the primary key and nothing else.
No transitive dependencies.

**Rule of thumb:** normalise by default. Denormalise deliberately when you have measured a
performance problem.

---

## Denormalisation

Denormalisation introduces controlled redundancy to avoid expensive joins. It is a performance
optimisation, not a design shortcut.

**When to denormalise:** a value is read far more often than it is written, and computing it
requires joining multiple tables.

**Django example:**

```python
class Order(models.Model):
    cached_total = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        default=Decimal("0.00"),
        help_text="Denormalised. Updated by recalculate_total().",
    )

    def recalculate_total(self) -> None:
        self.cached_total = self.lines.aggregate(
            total=models.Sum(models.F("unit_price") * models.F("quantity"))
        )["total"] or Decimal("0.00")
        self.save(update_fields=["cached_total"])
```

**Rules:** always document which field is denormalised; the denormalised field must never be the
only source of truth; keep it in sync with Django signals, an explicit service method, or a Celery
task — never leave synchronisation to chance.

---

## Indexes

Add indexes deliberately, not speculatively.

**When to add:** a column appears in `WHERE`, `ORDER BY`, or `JOIN` clauses in queries that run
frequently or against large tables, confirmed by `EXPLAIN ANALYZE`.

**Django:**

```python
class Meta:
    indexes = [
        models.Index(fields=["customer", "-created_at"], name="idx_order_customer_date"),
        models.Index(
            fields=["status"],
            name="idx_order_active",
            condition=models.Q(status__in=["pending", "confirmed", "shipped"]),
        ),
    ]
```

**Composite column order follows equality → range → sort.** Columns matched with `=` come
first, then the column used for a range comparison, then the column ordered on. Selectivity
decides which of several _candidate_ indexes to build; it does not decide column order
within one. An index ordered by selectivity instead of access shape will be skipped for the
range and sort it was meant to serve.

```python
# Query: WHERE customer = ? AND created_at >= ? ORDER BY created_at DESC
models.Index(fields=["customer", "-created_at"], name="idx_order_customer_date")
#             equality ──┘        └── range + sort
```

**Rules:** every index must name the real query pattern it serves — an index no query uses
slows every write for nothing; add it in the same change as the query that needs it; review
indexes periodically and drop the unused.

Adding an index to a table that already holds rows takes a lock for the duration of the
build — see **Migrations** below for the concurrent form.

---

## Foreign Keys and Constraints

Invariants are enforced **in the database**, not only in application code. Validation in a
service is a convenience for the caller; the constraint is what makes the invariant true. A
rule enforced only in Python is one management command, data migration, or direct write away
from being violated — and the violation is then permanent.

Every table declares, as applicable: foreign keys with an explicit `on_delete`, `NOT NULL`,
`UniqueConstraint`, and a **`CheckConstraint` on every bounded or enum-like column** —
quantities that cannot be negative, ranges whose end must follow their start, status columns
restricted to a known set, and mutually exclusive nullable columns.

```python
class OrderLine(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    product = models.ForeignKey("Product", on_delete=models.PROTECT)
    quantity = models.PositiveIntegerField()

    class Meta:
        constraints = [
            models.CheckConstraint(check=models.Q(quantity__gte=1), name="orderline_qty_positive"),
            models.UniqueConstraint(fields=["order", "product"], name="orderline_unique_product"),
        ]
```

| `on_delete` | Use when                                       |
| ----------- | ---------------------------------------------- |
| `CASCADE`   | The child has no meaning without the parent    |
| `PROTECT`   | Deletion should be prevented if children exist |
| `SET_NULL`  | The relationship is optional                   |

---

## Migrations

- Every model change produces a migration. Never modify the database schema manually — changes flow
  through `code/src/scripts/database/migrate.sh`.
- Never modify a migration applied to staging or production — create a new migration. Squash
  forward; never rewrite history.
- Data migrations (`RunPython`) must have both a forward and reverse function, be idempotent, and
  log counts rather than values — never personal data.
- Large data migrations on populated tables are batched.

### Lock discipline

**Never hold a long `ACCESS EXCLUSIVE` lock on a large table.** A change that is instant on an
empty development database can block every read and write for the duration of a rewrite in
production — and a lock request that has to wait queues everything behind it.

**Build indexes concurrently on any table that is not empty.** A concurrent build cannot run
inside a transaction, so the migration opts out of the atomic wrapper:

```python
from django.contrib.postgres.operations import AddIndexConcurrently


class Migration(migrations.Migration):
    atomic = False  # required — CREATE INDEX CONCURRENTLY cannot run in a transaction

    operations = [
        AddIndexConcurrently(
            model_name="order",
            index=models.Index(fields=["customer", "-created_at"], name="idx_order_customer_date"),
        ),
    ]
```

A concurrent build can fail and leave an invalid index behind; check for one before retrying.

Every `RunSQL` carries a `reverse_sql`. A migration that cannot be rolled back cannot be deployed
with confidence. Where a migration denormalises, adds a partial index, or takes a heavy lock, it
carries a comment explaining **why** — the shape is not self-evident to the next reader.

**Adding columns and constraints to a deployed database** — which changes are cheap, which need
staging, how to run a batched backfill, the lock-queue hazard, `NOT VALID` → `VALIDATE`, and when
a maintenance window is the right call: [`SCHEMA-MIGRATIONS.md`](SCHEMA-MIGRATIONS.md).

---

## Soft Deletes

```python
class SoftDeleteModel(models.Model):
    deleted_at = models.DateTimeField(null=True, blank=True, db_index=True)

    class Meta:
        abstract = True

    def soft_delete(self):
        self.deleted_at = timezone.now()
        self.save(update_fields=["deleted_at"])


class SoftDeleteManager(models.Manager):
    def get_queryset(self):
        return super().get_queryset().filter(deleted_at__isnull=True)
```

**Rules:** the default query scope must exclude soft-deleted records; define a retention policy
(e.g., hard-delete after 90 days via a scheduled Celery task).

**M2M and reverse FK relationships:** a soft-delete filter on the owner model's queryset does
**not** automatically filter related objects fetched via `prefetch_related`. When querying across
a M2M or reverse FK relationship, use `Prefetch()` with an explicit soft-delete filter on the
related queryset:

```python
from django.db.models import Prefetch

qs = qs.prefetch_related(Prefetch("tags", queryset=Tag.objects.filter(deleted_at__isnull=True)))
```

Similarly, any constraint guard before soft-deleting a shared record (e.g., a tag used across
multiple content types) must check **all** models that reference it — not just the primary
consumer — to prevent orphaned M2M references.

---

## Polymorphic Relationships

Prefer separate foreign keys with a check constraint over `GenericForeignKey`:

```python
class Comment(models.Model):
    article = models.ForeignKey("Article", null=True, blank=True, on_delete=models.CASCADE)
    event = models.ForeignKey("Event", null=True, blank=True, on_delete=models.CASCADE)
    body = models.TextField()

    class Meta:
        constraints = [
            models.CheckConstraint(
                check=(
                    models.Q(article__isnull=False, event__isnull=True)
                    | models.Q(article__isnull=True, event__isnull=False)
                ),
                name="comment_single_parent",
            ),
        ]
```

Use `GenericForeignKey` only when the number of possible parent types is unbounded.

---

## JSON Fields

**Good uses:** semi-structured data that varies between records and does not need to be joined,
filtered, or aggregated at the database level.

**Bad uses:** structured data that should be relational (order lines, tags, related records).

**Rules:** if you need to `WHERE`, `JOIN`, `ORDER BY`, or `AGGREGATE` on a value, it belongs in
a column, not in a `jsonb` field. Validate JSON structure at the application level — with a Ninja
`Schema` on the server, and a `CHECK` constraint in the database for anything bounded.

---

## Multi-Tenancy Patterns

```python
class TenantModel(models.Model):
    tenant = models.ForeignKey("Tenant", on_delete=models.CASCADE, db_index=True)

    class Meta:
        abstract = True


class Booking(TenantModel):
    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["tenant", "reference"],
                name="booking_unique_ref_per_tenant",
            ),
        ]
```

**Rules:** every query that returns tenant data must be scoped to the authenticated tenant; unique
constraints must be tenant-scoped; background jobs must explicitly receive a tenant context.

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
