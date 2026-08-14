---
name: reporting
description: >-
  Build the query and aggregation services behind <%PROJECT_NAME%>'s reports and dashboards —
  role-scoped PostgreSQL/ORM aggregates, a standardised result shape, recommended indexes, and
  PII kept out of anything summarised. Load when a story needs report data: revenue summaries,
  activity metrics, audit rollups, KPI aggregates. Not the dashboard UI (`frontend`), not
  turning the result into a file (`export`), not applying the index migration (`database`), and
  not drawing analytical conclusions from it (`data-analysis`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-django
---

# Build Report Data (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is query services and an
index recommendation).

You return **query services, recommended indexes, and PII-safe result shapes** — and nothing
downstream of that. State the handoff and stop.

---

## The brief arrives settled

A wrong assumption here means a rewritten query layer, and a fork cannot ask. The brief must
carry five things:

| Needed             | Because it decides                    |
| ------------------ | ------------------------------------- |
| The report purpose | Which metrics exist at all            |
| The data sources   | Which models and tables are in scope  |
| Date range + grain | The `group_by` period and the indexes |
| The target roles   | The access scope and detail level     |
| Update frequency   | Live query versus cache or summary    |

**If the target role is missing, return** — it is the one that decides what may be selected,
and guessing it widens a query past someone's permissions. Where these are open, that is a
`grilling` pass run inline first.

Before writing a query, read the **owning app's `CONTEXT.md` and `CLAUDE.md`** and inspect the
live schema (`.claude/plugins/db-tool.py orm`) — existing report infrastructure is reused, not
re-derived.

## Role-based shaping

Scope every query to the caller's role **and** ownership. A report endpoint is still a
permission-gated surface: it carries an explicit check, it verifies every user-supplied filter
ID against the caller, and it never returns a row the caller could not have fetched directly.
Widening a query for convenience is the defect this remit exists to prevent.

Typical shapes: an admin sees system-wide metrics and activity; a manager sees team KPIs and
allocation; finance sees revenue, refunds, tax and outstanding invoices; a user sees only their
own activity and account summary.

## Service architecture

Report logic lives in service modules, never in an endpoint:

```text
apps/<app>/services/
├── report_service.py      # base: date range, pagination, currency, percentage change
├── admin_report.py        # admin-scoped queries
├── finance_report.py      # finance-scoped queries
└── report_filters.py      # dataclass: start/end, user_id, group_by, limit/offset
```

Return a standardised result dataclass carrying `data` plus `metadata` — generation timestamp,
timezone, and the query parameters used. Currency formats as <%CURRENCY%> and dates as
DD/MM/YYYY.

## PII in a report

A report aggregates personal data, so treat it as hazardous by default:

- **Aggregate and summary reports carry no individual PII** — counts, sums and averages only.
  `COUNT(DISTINCT user_id)`, never the raw IDs; a "top customer" row surfaces `public_uuid`,
  never an email address.
- **Individual-record reports gate PII columns behind an explicit permission check before
  selection**, and decrypt a Fernet column only where the caller holds that permission.
- **Audit-log reports group by event type and hashed identifier** — the stored IP is already
  one-way hashed (`code/docs/security/AUDIT-TRAIL.md`) and stays that way.
- **Trend data anonymises identifiers** with a salted hash, so no raw user ID appears.

## Query performance

Aggregate **in the database** — `annotate` and `aggregate`, never a Python loop over a full
queryset — and use `select_related` / `prefetch_related` for the joins. Recommend the composite
index the report's filter-and-sort columns need (`(status, created_at)` and its kin) and **hand
the migration to `database`; do not add it here**. Where a report is hot and expensive, propose
a nightly summary table or a Valkey cache with a stated TTL — and flag the refresh scheduler as
a handoff rather than building it.

## Definition of done

Every query scoped to role and ownership behind an explicit permission check; no raw PII in
aggregate output and individual-record PII gated and stated; all aggregation database-side;
recommended indexes listed for `database`; the result shape localised; the owning app's
`CONTEXT.md` updated for any new service module.

## Handoff

Report the **report and its target roles** in one line, the **services created or changed** by
path, the **recommended indexes** as migration notes, the **call shape**, and the
**performance estimate** with any caching or summary-table recommendation. Then name what is
owed: `database` to apply the indexes or build the summary table, `export` to turn the result
into a downloadable file, `frontend` for the dashboard, `data-analysis` for insight beyond
aggregation, `test-writer` for the query tests, and `completion` to close the story.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/18-backend-code/` — the aggregation and service layer
- `project-management/workflows/19-api-code/` — the report endpoints over it

## Cross-references

- `code/docs/PERFORMANCE.md` — query optimisation, caching, response-time targets
- `code/docs/security/AUTH-AND-AUTHZ.md` — the permission check and the IDOR rule
- `code/docs/security/AUDIT-TRAIL.md` — what an audit rollup is allowed to read
- `code/docs/ENCRYPTION-GUIDE.md` — what must never leave a Fernet column aggregated
- `code/docs/DATA-STRUCTURES.md` — the model and type conventions the queries run over
- `code/docs/API-DESIGN.md` — the endpoint and error conventions when data is exposed
