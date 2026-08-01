---
type: guide
agent: backend
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Performance — Database

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — N+1 prevention, query optimisation, indexing, ORM tuning

---

## Database Query Optimisation

### N+1 Queries

The N+1 problem is the most common performance issue in ORM-based applications. It occurs when a
query for N items triggers N additional queries to load a related object for each item.

**Django — detecting and fixing N+1:**

```python
# BAD: N+1 — one query for orders, then one query per order to get the customer
orders = Order.objects.all()
for order in orders:
    print(order.customer.name)  # hits the database for each order

# GOOD: select_related for ForeignKey / OneToOne (SQL JOIN)
orders = Order.objects.select_related("customer").all()

# GOOD: prefetch_related for ManyToMany / reverse ForeignKey (separate query + Python join)
orders = Order.objects.prefetch_related("lines", "lines__product").all()
```

**Django's `nplusone` library** or `django-debug-toolbar` flag lazy-loaded relationships during
development. In this project `nplusone` is a **dev-only** dependency, registered solely in
`config/settings/dev.py` with `NPLUSONE_RAISE = True` — a detected N+1 raises during development
and never ships to staging, production, or the test suite. Enable an equivalent in every project:
catch N+1 problems at development time, before they reach a request path.

### Per-request cache + prefetch (ABAC pattern)

When the same expensive lookup is needed by several endpoints or service calls **within one
request** — the canonical case is the ABAC `AdminMember` permission check — combine two techniques:

1. **Load once with `prefetch_related`** so all related rows arrive in one extra query, then
   iterate `.all()` in Python instead of issuing `.get(child=...)` per item (which is an N+1).
2. **Memoise for the request** with `apps.core.db.get_or_cache(request, key, loader)`, backed by
   `RequestCacheMiddleware` (registered after `AuthenticationMiddleware`). The dict lives on
   `request._db_cache`, is recreated per request, and never bleeds across requests.

```python
# apps/users/services/abac.py
def load_admin_member(user, *, request=None):
    def _loader():
        try:
            return AdminMember.objects.prefetch_related("module_permissions").get(user=user)
        except ObjectDoesNotExist:
            return None

    # request carries the cache; fall back to the user so no-request callers
    # (Celery, management commands) still get a correct, uncached result.
    return get_or_cache(request if request is not None else user, f"admin_member:{user.pk}", _loader)
```

**When to reach for which tool:**

| Tool                           | Scope         | Use for                                                   |
| ------------------------------ | ------------- | --------------------------------------------------------- |
| `select_related`               | single query  | ForeignKey / OneToOne — pull the parent in a JOIN         |
| `prefetch_related`             | one + N rows  | reverse FK / M2M — one extra query, joined in Python      |
| `get_or_cache` (per-request)   | one request   | repeated identical lookups in a single request (no bleed) |
| Valkey cache (`cache.get/set`) | cross-request | data shared across requests/users with an explicit TTL    |

Never store tokens or PII in `request._db_cache` — only non-sensitive model data. The cache is a
performance aid, not an authorisation boundary; permission checks still run on every call.

### Query Analysis

Always use `EXPLAIN` before adding indexes or rewriting queries.

**PostgreSQL:**

```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 42 ORDER BY created_at DESC;
```

Look for: `Seq Scan` (full table scan — may need an index), `Nested Loop` (check for N+1),
`Sort` (check for missing index on sort column).

> The database is PostgreSQL. Other engines emit different `EXPLAIN` output (e.g. MySQL `type: ALL`
> for a full scan, `Using filesort` for an unindexed sort), but the discipline is identical:
> run `EXPLAIN` before you index or rewrite.

### Finding the slow queries in the first place

`EXPLAIN` tells you why a query you already suspect is slow. Two server-side facilities tell
you **which** queries to suspect — enable both, or optimisation is guesswork.

- **Statement statistics** (`pg_stat_statements`) — aggregates every executed statement by
  normalised form, with total and mean time, call count, and rows returned. This is the primary
  tool: sort by total time to find what actually costs the most, which is often a fast query run
  very often rather than one slow query.
- **Slow query logging** — set a duration threshold so anything exceeding it is logged with its
  parameters.

**Where logging query text would expose personal data.** If the schema holds encrypted columns
or personal data, statement logging can write plaintext parameters or ciphertext into container
logs — a real conflict with the retention and PII rules in `code/docs/LOGGING.md`. Resolve it
explicitly rather than by silently disabling the log:

- Log **durations and statement identifiers**, not parameters, and correlate back through
  statement statistics.
- Or keep full logging in development and test only, where the data is synthetic.

Whichever is chosen, record the choice and its reason next to the setting. A disabled slow-query
log with no explanation is indistinguishable from an oversight, and the next person to look will
either re-enable it and leak, or leave the system unobservable.

### Indexing Strategy

See `DATA-STRUCTURES.md` — Indexes for the full indexing guide. Performance-specific additions:

- **Covering indexes** (PostgreSQL): if a query only needs columns that are all in the index, the
  database can answer the query from the index alone without reading the table. For hot queries,
  consider adding `INCLUDE` columns.
- **Index-only scans**: verify with `EXPLAIN` that your most frequent queries achieve index-only
  scans.
- **Unused indexes**: indexes that are never used by queries slow down writes without benefiting
  reads. Audit periodically with `pg_stat_user_indexes`.

### Query Patterns to Avoid

- **SELECT \***: select only the columns you need. Fewer columns = smaller result set = faster
  transfer.
- **Unbounded queries**: every collection query must have a `LIMIT`. See `API-DESIGN.md` —
  Pagination.
- **Queries in loops**: if you need data for each item in a list, use a single query with `IN (...)`
  or a `JOIN`, not a query per item.
- **COUNT(\*) for existence checks**: if you only need to know whether a record exists, use
  `EXISTS` (SQL) or `.exists()` (Django) instead of counting all matches.

```python
# BAD: counts all matching rows
if Order.objects.filter(customer=customer, status="pending").count() > 0:

# GOOD: stops at the first match
if Order.objects.filter(customer=customer, status="pending").exists():
```

---

## Caching

### Cache Hierarchy

Apply caching at the layer closest to the consumer, falling back to deeper layers:

1. **Browser cache** — static assets, HTTP cache headers.
2. **CDN cache** — edge-cached HTML, API responses, assets (Cloudinary for media).
3. **Application cache** — computed values and serialised query results in Valkey.
4. **Database query cache** — query results cached by the ORM or database (use sparingly —
   invalidation is hard).

### Application-Level Caching

**Django (Valkey-backed):**

```python
from django.core.cache import cache

def get_dashboard_stats(tenant_id: int) -> dict:
    cache_key = f"dashboard_stats:{tenant_id}"
    stats = cache.get(cache_key)
    if stats is None:
        stats = _compute_dashboard_stats(tenant_id)
        cache.set(cache_key, stats, timeout=300)  # 5 minutes
    return stats
```

**Rules:**

- Always include the tenant ID (or user ID, or relevant scope) in cache keys. A shared cache key
  for tenant-scoped data is a data breach.
- Set explicit TTL (time to live) on every cached value. Never cache without an expiry.
- Use a consistent key naming convention: `{resource}:{scope}:{identifier}` (e.g.,
  `orders:tenant_42:recent`).
- Cache serialised data, not ORM objects. ORM objects carry database connections, lazy-loaded
  relationships, and state that does not serialise cleanly.

### HTTP Caching

Set appropriate cache headers on API and asset responses:

```text
# Static assets — cache aggressively with content hashing
Cache-Control: public, max-age=31536000, immutable

# API responses — no caching by default
Cache-Control: no-store

# API responses that can be cached — short TTL with revalidation
Cache-Control: private, max-age=60, must-revalidate
ETag: "abc123"
```

**Rules:**

- Static assets with content hashes in the filename (`app.a1b2c3.css`, the versioned HTMX and
  Alpine vendor scripts) should be cached for one year with `immutable`.
- Django Ninja responses that return user-specific data must use `Cache-Control: private` or
  `no-store`.
- Never cache responses that contain authentication tokens or sensitive data.

### Cache Invalidation

Cache invalidation is the hardest problem. Minimise its complexity:

- **Time-based expiry** (TTL) is the simplest strategy. Use it where stale data is acceptable for a
  short period.
- **Event-based invalidation**: clear the cache when the underlying data changes. Use Django
  signals or explicit service methods.
- **Version-prefixed keys** (Valkey): group related entries under a version token in the key
  (`orders:v3:tenant_42:recent`) and bump the version to invalidate the whole group at once — the
  old keys expire on their TTL. This is how the marketing page cache (`cache_marketing`) is
  invalidated on publish, without scanning keys.
- **Never cache and forget.** Every cached value must have either a TTL or an explicit invalidation
  trigger. If you cannot define when a cached value becomes stale, do not cache it.

---

## Connection Pooling

Database connections are expensive to establish. Use connection pooling to reuse them.

**Django:**

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "CONN_MAX_AGE": 600,  # reuse connections for 10 minutes
        "CONN_HEALTH_CHECKS": True,  # verify connections before reuse (Django 4.1+)
        # ... other settings
    }
}
```

**Pooling is configuration, not architecture.** Persistent connections in the framework are the
starting posture; an external pooler is a later, separate decision with real costs.

**Rules:**

- Set `CONN_MAX_AGE` and `CONN_HEALTH_CHECKS` in all environments, on **every** database alias —
  a second alias doubles the connection count.
- Close connections explicitly in long-running processes (management commands, task workers) that
  may otherwise hold them indefinitely.

### Do the arithmetic before reaching for a pooler

```text
worst-case connections ≈ (web workers + task worker concurrency + schedulers) × database aliases
```

Compare that against the server's connection limit. A handful of workers against a default limit
of 100 leaves ample headroom, and a pooler in front of it solves a problem that does not exist
while adding a failure mode and a protocol restriction.

**Trigger — revisit an external pooler when** steady-state connections exceed roughly **60% of
the server's connection limit**, or when a long-lived streaming request (server-sent events, a
websocket-backed view) is shown to hold a database connection for the stream's lifetime rather
than only for its queries. The second case changes the arithmetic from _per worker_ to _per
concurrent client_, which is a different order of magnitude — measure it before assuming either
way.

### If a pooler is adopted in transaction-pooling mode

Transaction pooling is what makes a pooler worth having, and it breaks two things:

- **Server-side prepared statements.** The driver must be told not to use them; otherwise
  statements prepared on one backend are executed on another and fail.
- **`LISTEN` / `NOTIFY`.** Session-scoped, so it cannot survive a connection handed to another
  client. Confirm nothing depends on it — a pub/sub channel on the cache service is unaffected,
  a database-notification path is not.

Session-pooling mode preserves both but recovers far less, and is rarely worth the hop.

### Full-text search indexes

A GIN index over a search vector is large and comparatively slow to build. Add it concurrently
on any populated table (see `data-structures/SCHEMA-DESIGN.md` — Lock discipline), keep the
vector in a stored generated column so it is maintained by the database rather than by
application code that can be bypassed, and measure ranking queries with `EXPLAIN` before adding
further indexes to support them.

---

## Database Scaling

### Latency vs Throughput

Before adding infrastructure to solve a database performance problem, identify which property
is actually constrained:

| Symptom                                                  | Bottleneck     | Solution                              |
| -------------------------------------------------------- | -------------- | ------------------------------------- |
| Individual queries are slow at low concurrency           | Query latency  | Query optimisation, indexing, caching |
| Individual queries are fast; throughput drops under load | Concurrency    | Connection pooling, query coalescing  |
| Write throughput saturates the primary; reads are fine   | Write capacity | Sharding — Phase 2                    |
| Read throughput saturates the primary; writes are fine   | Read capacity  | Read replica — Phase 1                |

Latency and throughput pull in opposite directions when scaling horizontally. Sharding
distributes write load but adds a coordinator hop; read replicas add read capacity but
introduce replication lag. See [`../architecture/CORE-AND-SCALING.md`](../architecture/CORE-AND-SCALING.md)
for the full decision, options considered, and phase gates.

### Scaling Tiers

Only advance a phase when the threshold is observable and measured. Do not pre-emptively
add infrastructure.

| Phase | Threshold to advance                                       | What to introduce                                          |
| ----- | ---------------------------------------------------------- | ---------------------------------------------------------- |
| 0     | Baseline (current)                                         | Single Postgres primary + PgBouncer                        |
| 1     | Read latency p95 > 50 ms sustained; write headroom remains | Streaming replication replica; read router in Django       |
| 2     | Primary CPU/IO > 70 % sustained; Phase 1 insufficient      | Citus coordinator + ≥ 2 workers; hash-shard on `tenant_id` |

### Read Replica Routing

Route reads to the replica only when stale data is acceptable:

- **Use the replica for**: list views, search, reporting, dashboard reads, any query where data a
  few seconds old is acceptable.
- **Use the primary for**: read-after-write (reading a record immediately after creating it in the
  same request), anything inside a transaction, anything requiring up-to-the-second accuracy.
- Replication lag is typically seconds to low minutes under write pressure. Never assume replica
  data is current.

### Cross-Shard Query Discipline

Once Citus sharding is introduced (Phase 2), cross-shard scatter-gather queries are expensive.
At that point, enforce the following:

- Cross-shard queries **must not** appear on any user-facing request path. All scatter-gather
  operations are background Celery tasks.
- Platform-wide aggregates (usage reports, billing summaries, admin dashboards) are background
  tasks with results cached in Valkey.
- Per-tenant queries are always single-shard — the hash distribution on `tenant_id` guarantees
  data locality; no cross-shard overhead for the common query path.

_Part of the `code/docs/` documentation family. See [`../PERFORMANCE.md`](../PERFORMANCE.md) for the full index._
