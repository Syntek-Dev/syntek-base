---
type: guide
skills: [database, stack-django]
model: opus
---

# Data Structures — Schema Migrations Against a Live Database

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Adding columns and constraints to a deployed database without downtime

Changing a schema on an empty development database is free. Changing it on a deployed one is
not. This guide covers what PostgreSQL actually does for each kind of change, which changes
need the staged treatment, and how to run the ones that do.

The rule underneath everything: **never hold a long `ACCESS EXCLUSIVE` lock on a large table.**

---

## Which path applies

Not every column addition needs staging. PostgreSQL applies **constant** default values lazily,
so the cheap path is genuinely cheap — the expensive dance is for values the database cannot
materialise itself.

| What you are adding                         | Cost                                   | Path                   |
| ------------------------------------------- | -------------------------------------- | ---------------------- |
| Nullable column, no default                 | Metadata only — instant                | Single migration       |
| Column with a **constant** default          | Metadata only — default applied lazily | Single migration       |
| Column with a **volatile** default          | Full table rewrite                     | Staged change          |
| Value computed per row by application logic | Rewrite or long `UPDATE`               | Staged change          |
| `NOT NULL` on a populated column            | Full scan under a strong lock          | `NOT VALID` → validate |
| Column type change                          | Full table rewrite                     | Staged, or a window    |

"Volatile" means the value differs per row — a generated identifier, a per-row timestamp. A
literal, or an expression that evaluates identically for every row, is constant.

> Verify the behaviour for the deployed major version before relying on it. Lazy constant
> defaults and validate-then-constrain are long-standing, but locking behaviour is
> version-sensitive and worth confirming rather than assuming.

---

## Single-migration additions

When the decision table says _single migration_, add the column and move on:

```python
migrations.AddField("order", "channel", models.CharField(max_length=20, default="web"))
```

No backfill, no background job, no second deploy. Reaching for the staged change here costs two
extra deploys and a job for nothing.

---

## The staged change

For a volatile or computed value, the column cannot be filled by the database in one statement
without holding the table. Split it so that **no single step is long**, and so that the system is
correct at every intermediate point — including if you stop halfway.

### Stage 1 — Expand

Add the column **nullable, with no default**. Instant, metadata only.

```python
migrations.AddField("order", "reference", models.CharField(max_length=32, null=True))
```

The column now exists and is empty. Nothing reads it yet.

### Stage 2 — Write

Deploy code that populates the column on **every** new write, while still tolerating `NULL` on
read. This must ship and be running before the backfill starts, otherwise the backfill races
new rows and never converges.

Reads must handle both shapes for the whole of this stage. A read path that assumes the column
is populated will fail on historical rows.

### Stage 3 — Backfill

Fill the historical rows in **batches**, as a background job — never as a migration. A migration
holds a transaction for its duration; a job does not.

```python
BATCH = 5_000

def backfill(last_pk: int = 0) -> int:
    """Fill one batch. Returns the last pk processed, or 0 when complete."""
    rows = list(
        Order.objects.filter(pk__gt=last_pk, reference__isnull=True)
        .order_by("pk")
        .values_list("pk", flat=True)[:BATCH]
    )
    if not rows:
        return 0
    for pk in rows:
        Order.objects.filter(pk=pk).update(reference=compute_reference(pk))
    return rows[-1]
```

### Stage 4 — Contract

Once the backfill reports zero remaining, tighten the constraint (below) and drop the
tolerate-`NULL` branches from the read paths. Only now is the column guaranteed populated.

---

## Backfill mechanics

The job is where a careless change takes the site down. Five properties are not optional:

- **Batched.** Walk the primary key with a keyset cursor, never `OFFSET`. One transaction per
  batch, committed before the next — a single `UPDATE` over millions of rows holds locks and
  bloats WAL.
- **Idempotent.** Filter on the column still being `NULL`, so a re-run cannot double-apply and a
  crash mid-run is safe.
- **Resumable.** Persist the cursor. A job that restarts from zero after a failure will never
  finish on a large table.
- **Throttled.** Pause between batches. The goal is to finish eventually without competing with
  live traffic — a backfill that completes in an hour but doubles p95 latency is a worse outcome
  than one that takes a day unnoticed.
- **Observed.** Watch replication lag, dead-tuple counts, and autovacuum. A fast backfill
  generates dead tuples faster than autovacuum reclaims them, and pushes lag onto any replica.

Set a `statement_timeout` on the job so a single pathological batch cannot run unbounded.

---

## The lock queue — the real hazard

A strong lock request that cannot be granted immediately **queues, and everything requesting the
table behind it queues too.** A one-second `ALTER TABLE` stuck behind a long-running query does
not wait politely on its own; it blocks every subsequent read and write until it acquires. This
is how a migration documented as "instant" takes a site down.

Guard every DDL statement with a short lock timeout and retry rather than waiting:

```sql
SET lock_timeout = '3s';
ALTER TABLE orders ADD COLUMN reference text;
```

If it cannot get the lock in three seconds it fails cleanly, changes nothing, and is retried —
instead of forming a queue. Retry during a quiet period, and check for long-running transactions
and idle-in-transaction sessions first: they are the usual reason the lock cannot be taken.

---

## `NOT NULL` without a long scan

Setting `NOT NULL` directly scans the whole table under a strong lock. A validated `CHECK` proving
no nulls exist lets the database skip that scan, and the validation itself takes a weaker lock
that permits concurrent reads and writes:

```sql
-- 1. add the constraint without scanning — instant, enforced for new rows
ALTER TABLE orders ADD CONSTRAINT orders_reference_not_null
  CHECK (reference IS NOT NULL) NOT VALID;

-- 2. validate it — scans, but concurrent reads and writes continue
ALTER TABLE orders VALIDATE CONSTRAINT orders_reference_not_null;

-- 3. now fast: the validated constraint proves there are no nulls
ALTER TABLE orders ALTER COLUMN reference SET NOT NULL;

-- 4. drop the now-redundant CHECK
ALTER TABLE orders DROP CONSTRAINT orders_reference_not_null;
```

Step 1 fails immediately if any row is still `NULL` — which is the correct outcome: it means the
backfill has not finished. The same `NOT VALID` → `VALIDATE` sequence applies to foreign keys and
to any `CHECK` added to a populated table.

> Recent PostgreSQL versions also accept `NOT VALID` on `SET NOT NULL` directly, collapsing steps
> 1–3. Confirm support on the deployed major version before using it.

---

## Planned maintenance window

A window is a legitimate tool, not an admission of failure. It is the right call when:

- the change is a **column type rewrite** on a table large enough that no online path exists;
- there is **no batching path** — the change cannot be decomposed into independently-safe steps;
- the expand/contract sequence would run for **weeks**, keeping two code paths alive across
  several releases, and the accumulated complexity and bug surface cost more than the downtime;
- the service has a genuine **low-traffic period** and the change fits inside it with margin.

If you take a window: announce it, rehearse the migration against a restored production-sized
copy and time it, set a hard abort threshold with a tested rollback, and put the application into
a real read-only or maintenance mode rather than relying on traffic being low.

The failure mode to avoid is an **unplanned** window — a migration assumed to be instant that
takes an exclusive lock on a large table. That is the outcome everything above exists to prevent.

---

## Checklist

Before a schema change reaches a deployed database:

- [ ] The decision table has been consulted — staging is used because it is needed, not by habit
- [ ] No step holds a long `ACCESS EXCLUSIVE` lock on a large table
- [ ] DDL runs under a short `lock_timeout` with a retry, never an open-ended wait
- [ ] The write path populates the column before any backfill starts
- [ ] Reads tolerate both shapes until the contract stage completes
- [ ] The backfill is batched, idempotent, resumable, throttled, and observed
- [ ] `NOT NULL` and new constraints go via `NOT VALID` → `VALIDATE`
- [ ] Every operation is reversible, or its irreversibility is stated in the migration comment
- [ ] The migration carries a comment explaining **why**, where the shape is not self-evident

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
