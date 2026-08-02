---
type: guide
agent: planner
skills: [stack-django, stack-htmx-templates, scale-planning]
model: fable
---

# Architecture Patterns — Core Decisions and Scaling

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Decisions to settle before the first migration, and the scaling phase-gates

Two things belong here: the decisions a project must settle **before its first migration**,
because reversing them later means a data migration or a full reset; and the **phase-gates**
that govern when the data tier changes shape.

---

## Settle before the first migration

Each of these is cheap now and expensive later. Settle each through a grilling pass
(`.claude/skills/grill-with-docs`) and record the answer in the project's own documentation —
the nearest `CONTEXT.md` for a name, its own decision record for a trade-off.

| Decision                | Why it is expensive to reverse                                                                |
| ----------------------- | --------------------------------------------------------------------------------------------- |
| **Auth user model**     | Swapping it after migrations have run means dropping tables and re-migrating from scratch     |
| **Primary key shape**   | Sequential integers leak volume and invite enumeration; changing type later rewrites every FK |
| **PII posture**         | Which fields are encrypted, and how they are looked up — re-encrypting is a data migration    |
| **Isolation scope**     | The scope column, its policy, its index, and the middleware that sets it — all four, together |
| **Distribution key**    | Only if sharding is plausible; adding one later is a backfill across every table              |
| **Environment split**   | Which settings differ per environment, and that secrets come only from the environment        |
| **Soft vs hard delete** | Retrofitting soft delete means auditing every existing query for the filter                   |

Two of these interact and are worth stating plainly:

- **The isolation scope is not automatically the distribution key.** A project can be
  owner-scoped for row security and still need a different, coarser key if it ever shards.
  Decide them separately; do not assume one implies the other.
- **A scope column with no policy reading it is not isolation.** See
  [`../RLS-GUIDE.md`](../RLS-GUIDE.md).

Record what was decided and, where it is non-obvious, why. A project that cannot say why its
user model or its key shape is what it is will re-litigate the question at the worst moment.

---

## Scaling: the order of operations

**Scale for latency first. Scale for throughput second. Change shape last.**

1. **Latency** — query tuning, indexing, eliminating N+1s, caching. Nearly always where the
   win is, and the only step that costs no infrastructure.
2. **Throughput** — connection handling, then read replicas once reads genuinely saturate.
3. **Shape** — partitioning, then sharding. Structural, and effectively one-way.

Do not skip a step. A team that shards before eliminating N+1s has multiplied the queries
across more machines and made them harder to fix.

---

## Phase-gates

Advance a phase **only when its trigger is observed and measured.** Do not pre-emptively add
infrastructure: an unused replica is cost and operational surface with no benefit, and it
disguises the query problem that was the actual bottleneck.

| Phase | Trigger (observed, sustained — not projected)                                          | Change                                 |
| ----- | -------------------------------------------------------------------------------------- | -------------------------------------- |
| **0** | Baseline                                                                               | Single primary; persistent connections |
| **1** | Read latency at the agreed percentile sustained above budget, write headroom remaining | Read replica + a routing layer         |
| **2** | Primary CPU or IO sustained above its ceiling, and Phase 1 proved insufficient         | Horizontal distribution across nodes   |

Set the concrete thresholds per project against measured baselines, and record them where the
alerting is defined — a gate nobody is alerted on is not a gate.

**A row count is never a trigger.** Neither is a date, a forecast, or a competitor's
architecture. The triggers are saturation of a real resource.

---

## Read replicas (Phase 1)

- Route to a replica only where **stale data is acceptable** — list views, search, reporting,
  dashboards.
- Route to the primary for **read-after-write** within a request, anything inside a
  transaction, and anything requiring up-to-the-second accuracy.
- Replication lag is real and variable under write pressure. Never assume a replica is current.

---

## Horizontal distribution (Phase 2)

Sharding is the **last** lever, not a tier to graduate into. Exhaust query tuning, N+1
elimination, indexing, caching, native partitioning, archiving cold rows, and vertical scale
first — in that order.

If it is ever reached:

- **A uniform distribution key must be present on every distributed table**, and carried from
  the start. This is the one part of sharding that cannot be deferred, because adding the column
  later means backfilling every table at exactly the moment the system is already under strain.
  If sharding is plausible, carry the key now; if it is not, say so explicitly and move on.
- **Co-locate related tables** on the same key so a per-tenant query stays single-node.
- **Cross-shard foreign keys are generally unsupported.** Referential integrity moves to the
  service layer — a real cost to weigh before committing.
- **Shard count is effectively immutable** once data is distributed. Choose for the expected
  growth horizon.
- **Cross-shard scatter-gather queries never sit on a user-facing request path.** Platform-wide
  aggregates and admin reporting become background jobs with cached results.
- If the driver is **multi-tenancy rather than volume**, evaluate schema-per-tenant first — it
  is simpler, and reversible in a way that sharding is not.

Prefer **logical shards mapped onto physical databases** over a raw consistent-hash ring: in a
database, "keys moved" means physically migrating rows, and the indirection is what makes
rebalancing survivable.

---

## Related

- [`../DATABASE.md`](../DATABASE.md) — the pre-flight data-layer rules and the deferred register
- [`../data-structures/SCHEMA-MIGRATIONS.md`](../data-structures/SCHEMA-MIGRATIONS.md) — changing
  a deployed schema without downtime
- [`../PERFORMANCE.md`](../PERFORMANCE.md) — the budgets these gates are measured against
- [`../RLS-GUIDE.md`](../RLS-GUIDE.md) — isolation scope and policy conventions
- `how-to/src/SCALE-ARCHITECTURE/` · `how-to/src/SERVER-ARCHITECTURE/` — sizing under these
  gates, and the server/edge contract the deployment implements

The governing discipline throughout: **reconcile against what is measured; never provision
ahead of a gate.**

_Part of the `code/docs/` documentation family. See [`../ARCHITECTURE-PATTERNS.md`](../ARCHITECTURE-PATTERNS.md) for the full index._
