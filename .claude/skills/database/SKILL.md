---
name: database
description: >-
  Do <%PROJECT_NAME%>'s data-layer work — express an approved schema as Django models and a
  lock-safe migration, write the row-level-security policies that scope a table, design PII
  columns onto the encryption pipeline, and diagnose a slow query or missing index. Load when
  the work is the data layer itself rather than the logic above it. Not the service layer,
  endpoints or Policy classes over it (`backend`), not authoring migration or RLS tests
  (`test-writer`), and not analysing the data for insight (`data-analysis`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling domain-modelling stack-django
---

# Work the Data Layer (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable task whose output is models, a migration, and
policies).

**The stack is fixed — do not detect it and do not ask which engine.** PostgreSQL 18, the
Django 6 ORM, dev database `<%PROJECT_SLUG%>_dev`. Every operation runs through
`code/src/scripts/database/*.sh` — never `python manage.py`, raw `psql`, or `docker`.

---

## The brief arrives settled

A fork cannot open a grilling pass, and schema design is the one thing here that must be
grilled. **The signed-off schema arrives with the brief** — entities and what they actually
mean, relationships and cardinality, the ownership or tenancy boundary the RLS policies will
scope on, the constraints and invariants, which fields are PII and under what lawful basis,
the retention, and the query shapes expected. Its home is
`project-management/workflows/04-database-schema/`.

**If the brief carries no approved schema, return and say so.** Where the schema is what needs
settling, that is a `grilling` pass run inline first — this skill builds what it decided.

## Schema

- **Normalise to 3NF** unless a documented denormalisation earns its keep.
- Model in `apps/<app>/models/`; relationships declare an explicit `on_delete`; business rules
  are enforced in `Meta.constraints` (`CheckConstraint`, `UniqueConstraint`) — **at the
  database, not only in Python**.
- **Invariants live in the database:** foreign keys with explicit delete behaviour, `NOT NULL`,
  `UNIQUE`, and a `CHECK` on every bounded or enum-like column. Application validation is never
  a substitute.
- Record the settled entity and aggregate names where the next reader will find them — the
  nearest `CONTEXT.md` glossary (`domain-modelling`).
- Design values (colour, spacing) are token-canonical in `apps/design_tokens`; never seed a raw
  design literal into another table.
- New Django app → `bash code/src/scripts/development/new-django-app.sh <app_name>`.

## Migrations

- **Review the generated file before applying it** — confirm it matches intent.
- Reversible where feasible; data migrations idempotent and preserving existing rows.
- Split the schema change and the data backfill into separate migrations on a large table.
- **Lock discipline is non-negotiable.** Never hold a long `ACCESS EXCLUSIVE` lock on a large
  table: DDL under a short lock timeout with retry, indexes built concurrently on populated
  tables, and add-nullable → backfill → constrain where the value is volatile or computed per
  row (`code/docs/data-structures/SCHEMA-MIGRATIONS.md`).
- Every migration opens with a comment block stating its purpose, written in the third person
  about the column — "Stores the UTC placed-at timestamp", never "we store it when they order".

## Row-level security

Every user- or tenant-scoped table gets RLS **in the same migration that creates it**:

- `ENABLE` **and** `FORCE ROW LEVEL SECURITY` — without `FORCE`, the owner role bypasses every
  policy.
- Policies for `SELECT`, `INSERT`, `UPDATE` (both `USING` and `WITH CHECK`), and `DELETE`.
- **A scope column, its policy, its supporting index, and the middleware that sets its session
  variable ship together.** Never write a scope variable no policy reads — it reads as
  isolation while enforcing none. The middleware itself is `backend`'s to build; reference the
  pattern rather than re-specifying it.
- Run `verify-db-security.sh` afterwards, and flag `test-writer` for cross-user access tests.
- The isolation scope column is an **RLS key**. A **distribution key** is a separate, coarser
  decision needed only where sharding is plausible
  (`code/docs/architecture/CORE-AND-SCALING.md`).

## PII columns

PII goes through the project's Fernet pipeline — never invent a scheme
(`code/docs/ENCRYPTION-GUIDE.md`).

- Keep PII in dedicated tables or fields, off the hot query paths.
- The encrypted value is a `TextField`; a searchable field carries a **separate keyed-HMAC hash
  column, and the hash is what gets indexed** — ciphertext is random, so it cannot be indexed,
  ordered, or full-text searched (`code/docs/encryption/LOOKUP-TOKENS.md`).
- Passwords are Django-hashed: never encrypted, never searched.

## Query and index tuning

Diagnose with `EXPLAIN (ANALYZE, BUFFERS)` through `shell.sh`. Fix N+1s with `select_related`
/ `prefetch_related`; add composite and partial indexes for the query shapes that actually run;
reach for GIN/GiST/`tsvector` where the access pattern warrants it, and balance every read gain
against its write cost. **Unbounded scans and offset pagination are a scale-readiness
finding** — prefer keyset.

## Scripts — never a raw command

```bash
bash code/src/scripts/database/migrate.sh make          # generate from model changes
bash code/src/scripts/database/migrate.sh run           # apply to the dev database
bash code/src/scripts/database/migrate.sh show          # inspect migration state
bash code/src/scripts/database/verify-db-security.sh    # confirm the security config
bash code/src/scripts/database/shell.sh                 # psql session, read-only inspection
bash code/src/scripts/database/seed-dev.sh              # seed dev fixtures
```

The test database is a separate one from dev — **never point a test run at the dev database.**

## Definition of done

Migration generated, reviewed, and applied cleanly, with `show` confirming state; RLS present
and `verify-db-security.sh` passing for every scoped table; the migration record written per
`03-database-migration/STEPS.md`; every affected `CONTEXT.md` updated.

**Findings are recorded, not fixed in the same pass.** A divergence from `code/docs/DATABASE.md`
found while doing the work goes to `project-management/src/20-FINDINGS/` through workflow `22`.
Where an existing migration or model carries no explanation for its shape, **flag the absence
rather than inventing the reasoning**, and mark anything inferred `TODO(verify)`.

## Handoff

Report the models and migrations created, the policies added, and the findings recorded. Then
name what is owed: `backend` for the RLS session middleware and the service layer above this,
`test-writer` for migration, policy and query tests, `qa-tester` to verify isolation actually
holds, `doc-writer` for the schema narrative, `cicd` to confirm the migration applies in the
pipeline, and `scale-planning` where the change moves the sizing envelope or the shard-key
coverage.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/04-database-schema/` — the schema, designed and signed off first
- `project-management/workflows/19-backend-code/` — the build phase that drives the migration
- `code/workflows/03-database-migration/` — writing and applying it; the procedure of record
- `project-management/workflows/22-implementation-documentation/` — where findings are filed
- `how-to/workflows/04-database-operations/` — backup, restore, reset and seed, never schema

## Cross-references

- `code/docs/DATABASE.md` — **read first.** Scope columns, database-level constraints, index
  ordering, lock-safe migrations, search, and the deferred-infrastructure register
- `code/docs/DATA-STRUCTURES.md` — domain modelling, field and type conventions
- `code/docs/RLS-GUIDE.md` — the policy conventions and templates
- `code/docs/ENCRYPTION-GUIDE.md` — the field-encryption pipeline and its lookup tokens
- `code/docs/PERFORMANCE.md` — index strategy, N+1 avoidance, query budgets
- `code/docs/architecture/CORE-AND-SCALING.md` — the phase-gates a schema change is judged against
