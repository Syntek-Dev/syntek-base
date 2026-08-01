---
type: guide
agent: database
skills: [stack-django]
model: opus
---

# Database

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Pre-flight data-layer rules, migration safety, search, deferred infrastructure

Read this before writing a model, a migration, or a query. It is the short, directive
entry point; the detail lives in the four guides it routes to. The database is
**PostgreSQL** — that is the fixed substrate, not a swappable choice.

## The governing principle

**Decide early anything expensive to retrofit; defer anything that can be inserted as a
layer later.** If it changes the data model or the write path, decide now. If it sits in
front of something already working, defer it until it hurts.

No speculative infrastructure: every stateful service must have a named problem it solves,
and every deferral must record the condition that reopens it — a trigger, not a shrug.

## Before the first migration on a new table

These are settled **before** any DDL runs, because each is expensive to change afterwards.

**Scope.** Every table holding user-owned or otherwise partitionable rows carries an
explicit scope column, and names it in `db_table_comment`. Which column that is — owner,
account, organisation, tenant — is a domain decision, so the owning agent **opens a grilling
pass** (`.claude/skills/grill-with-docs`) covering ownership, cardinality, isolation scope,
invariants, personal-data fields, retention, and expected query shapes. A tenancy question
spanning many tables is charted with `.claude/skills/wayfinder` and resolved node by node.
Never a fixed questionnaire — see `.claude/CLAUDE.md` §10.

Purely global reference data carries no scope column; say so explicitly in
`db_table_comment` rather than leaving it ambiguous.

**A scope column implies three things, together:** a row-security policy that reads it, an
index that supports it, and a request-time mechanism that sets the session variable the
policy reads. **Never write a scope session variable that no policy reads** — a variable
populated from a field that does not exist is indistinguishable from one that works, and
fails silently.

**Constraints live in the database.** Foreign keys with an explicit delete behaviour,
`NOT NULL`, `UNIQUE`, and `CHECK` on every bounded or enum-like column. Application-level
validation is a convenience for the user; the database constraint is what makes the
invariant true. A rule enforced only in application code is one direct write away from
being violated.

**Column types are precise.** Timestamps are timezone-aware. Money is exact, never
floating point. `jsonb` — never `text` — and only where the shape is genuinely unknown or
open-ended. If a value needs filtering, joining, ordering or aggregating, it is a column,
not a key inside a document.

**Indexes come from real query patterns**, never speculation. Composite column order
follows **equality → range → sort**. Partial indexes keep hot subsets small. Every index
must name the query shape it serves; an index no query uses slows every write for nothing.

## Migration safety

Migrations are version-controlled and generated through the project scripts. **No manual
DDL against a deployed database, ever.**

- **Never hold a long exclusive lock on a large table** — and remember a lock request that
  must wait queues every reader and writer behind it. Run DDL under a short lock timeout
  and retry, rather than waiting open-endedly.
- **Not every column addition needs staging.** A constant default is applied lazily and
  goes in one migration; a volatile or per-row-computed value needs the staged
  expand → write → backfill → contract change.
- **Adding an index to a populated table:** build it concurrently, in a non-atomic
  migration. An ordinary index build takes a lock that blocks writes for the duration.
- **`NOT NULL` and new constraints on populated tables** go via `NOT VALID` → `VALIDATE`,
  so the scan runs under a lock that permits concurrent reads and writes.
- **Backfills are background jobs, never migrations** — batched, idempotent, resumable,
  throttled, and observed.
- **Every raw-SQL operation carries a reverse.** A migration that cannot be rolled back is
  a migration that cannot be deployed with confidence.
- **Never edit or delete an applied migration.** Squash forward; never rewrite history.
- Data migrations are idempotent, log counts rather than values, and never write personal
  data to a log.

Full procedure, decision table, and the maintenance-window criteria:
[`data-structures/SCHEMA-MIGRATIONS.md`](data-structures/SCHEMA-MIGRATIONS.md).

Where a migration denormalises, adds a partial index, or takes a heavy lock, it carries a
comment saying **why**. A migration without that comment is a finding, not a judgement
call — record it in `project-management/src/18-FINDINGS/`.

## Search

**Default to PostgreSQL full-text search.** A `tsvector` column with a **GIN** index, using
the framework's search-vector field type. Prefer a generated column (`GENERATED ALWAYS AS
… STORED`) so the vector cannot drift from its source.

Two constraints decide whether this is even possible:

- **The expression must be immutable.** Supply the text-search configuration explicitly —
  the implicit form depends on a session setting and a generated column will be rejected.
- **Encrypted columns cannot be searched.** Authenticated encryption is non-deterministic
  by design, so a vector built over ciphertext indexes noise. If a field must be both
  encrypted and searchable, that is an **encryption** decision, not a search one — reopen it
  through a grilling pass. Document-shaped bodies index their extracted text, never the raw
  document structure.

The vector's GIN index is added to a populated table concurrently, like any other.

## Query rules

- **Eager-load any relation walked in a loop.** Detect N+1s in development with tooling
  configured to raise rather than warn — a silent log line gets ignored.
- **Every collection query is bounded.** Prefer keyset pagination over offset for anything
  that grows; offset degrades linearly and is unstable under concurrent writes.
- **Select the columns you need.** Use an existence check rather than counting rows to
  test for presence.
- **Analyse before optimising.** Read the query plan first; add the index the plan asks
  for, not the one you assumed.
- **Multi-write operations are transactional.** If any step fails, all steps roll back.

## Observability and recovery

- **Statement statistics enabled**, so slow queries can be found by evidence rather than
  suspicion.
- **Slow query logging on**, with a threshold. Where logging query text would expose
  personal data or ciphertext, log durations and statement identifiers rather than
  parameters — and record that trade-off rather than silently disabling the log.
- **Backups with point-in-time recovery, verified by an actual restore.** A backup that has
  never been restored is a hypothesis. A periodic dump is not point-in-time recovery.

## Connection handling

Connection pooling is **configuration, not architecture**. Start with persistent
connections and health checks in the framework's database settings, sized so that
worst-case concurrent connections stay well under the server limit.

Worst-case connections ≈ (web workers + task workers + schedulers) × database aliases.
Compute it before assuming a pooler is needed.

## Deferred, with triggers

Each of these is deliberately absent. Each records the condition that reopens it.

| Deferred                                                    | Revisit when                                                                                                                                                                                                                                                                                                                         |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **A connection pooler** (PgBouncer being the common choice) | Steady-state connections exceed ~60% of the server's connection limit, or a long-lived streaming request is shown to hold a connection for its lifetime                                                                                                                                                                              |
| **A read replica**                                          | Read latency at the agreed percentile is sustained above budget while write headroom remains                                                                                                                                                                                                                                         |
| **A dedicated search service**                              | A capability full-text search genuinely cannot express is a stated requirement — typo tolerance beyond trigram matching, faceting over high-cardinality dimensions, per-field relevance tuning, or federated search across separate databases — **and** full-text search has been implemented, indexed and measured against it first |
| **Table partitioning**                                      | A single table's size makes vacuum or index maintenance the bottleneck, and archiving cold rows has already been exhausted                                                                                                                                                                                                           |
| **Sharding**                                                | Write throughput saturates the largest available single primary, or the working set is so far beyond memory that cache hit rates collapse — **never** a row count                                                                                                                                                                    |

**On adding any stateful service:** on a single-node deployment it competes with the
database for the same memory and IO. Weigh its resident footprint (a JVM-based service
reserves heap that is off-limits to the page cache; a single-binary service does not),
its persistence and full-reindex cost, and its operational burden. Budget it its own node
or a hosted plane — never spare capacity. Selection is a grilling decision, not a default.

**If a pooler is adopted in transaction-pooling mode**, server-side prepared statements and
`LISTEN`/`NOTIFY` both break. Disable prepared statements at the driver, and confirm nothing
depends on `NOTIFY` before switching.

**Sharding is the last lever, not a tier.** Exhaust query tuning, N+1 elimination, indexing,
caching, partitioning, archiving, and vertical scale first. Carry the shard key from the
start; defer the machinery until required. Logical shards mapped onto physical databases
beat a raw hash ring — in a database, "keys moved" means physically migrating rows. If the
driver is multi-tenancy rather than volume, evaluate schema-per-tenant first.

## Where the detail lives

| Concern                                                            | Guide                                                                          |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------ |
| Modelling, normalisation, indexes, constraints                     | [`data-structures/SCHEMA-DESIGN.md`](data-structures/SCHEMA-DESIGN.md)         |
| Migrating a deployed database — columns, backfills, locks, windows | [`data-structures/SCHEMA-MIGRATIONS.md`](data-structures/SCHEMA-MIGRATIONS.md) |
| Domain modelling, value objects, aggregates                        | [`data-structures/DOMAIN-MODELLING.md`](data-structures/DOMAIN-MODELLING.md)   |
| Row-level security policies, session context, testing              | [`RLS-GUIDE.md`](RLS-GUIDE.md)                                                 |
| Field encryption and lookup tokens                                 | [`ENCRYPTION-GUIDE.md`](ENCRYPTION-GUIDE.md)                                   |
| Query optimisation, caching, connection handling, scaling          | [`performance/DATABASE-PERFORMANCE.md`](performance/DATABASE-PERFORMANCE.md)   |
| Scaling phase-gates and core decisions                             | [`architecture/CORE-AND-SCALING.md`](architecture/CORE-AND-SCALING.md)         |

Findings against these rules are recorded per story in
`project-management/src/18-FINDINGS/`; the governing procedure is
`code/workflows/09-database-migration/`.

_Part of the `code/docs/` documentation family._
