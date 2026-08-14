---
type: guide
skills: [backend, stack-django, stack-htmx-templates]
model: opus
---

# Performance

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Performance measurement, caching, query optimisation, monitoring across the stack

Performance measurement, caching strategies, query optimisation, and monitoring across the
Django server-rendered stack — the HTMX/Alpine site and the Django Ninja JSON API. Follows the
same philosophy as the coding principles: measure first, then optimise.

## Sub-documents

| Document                                                                     | Covers                                                                                                                                                                                                                                                                                                                                          |
| ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`performance/DATABASE-PERFORMANCE.md`](performance/DATABASE-PERFORMANCE.md) | N+1 query detection and fixes, per-request cache + prefetch (ABAC pattern), `nplusone` dev-only detection, query analysis (EXPLAIN), indexing strategy, query patterns to avoid, application-level caching (Valkey), HTTP caching, cache invalidation, connection pooling, database scaling tiers, read replica routing, cross-shard discipline |
| [`performance/FRONTEND-PERFORMANCE.md`](performance/FRONTEND-PERFORMANCE.md) | Page-weight budgets, HTMX/Alpine tuning, template fragment caching, rendering strategy (see RENDERING.md), Cloudinary media optimisation, token CSS performance                                                                                                                                                                                 |
| [`performance/API-AND-MONITORING.md`](performance/API-AND-MONITORING.md)     | Django Ninja API and network performance, background jobs and queues (Celery), monitoring metrics table, production monitoring (Sentry/GlitchTip, Prometheus, Loki, Grafana, Alloy), load testing rules, pre-deploy performance checklist                                                                                                       |

## The Rules

1. **Do not optimise without measuring.** (Pike Rule 1, Pike Rule 2.)
2. **Premature optimisation is the wrong abstraction applied too early.** Wait until a real
   performance problem exists, then fix the actual bottleneck.
3. **The fastest code is code that does not run.** Eliminate unnecessary work before optimising
   the work that remains.
4. **Performance budgets are constraints, not goals.** Set them, enforce them in CI, and treat
   violations as bugs.
5. **User-perceived performance matters more than server-side metrics.** A page that loads in
   200ms but shows nothing for 2 seconds is slower than a page that loads in 500ms with a
   meaningful first paint.

## Related

Budgets and measurement live here; the deployment sizing that keys to these budgets lives
elsewhere and consults these numbers rather than duplicating them:

- [`how-to/src/SCALE-ARCHITECTURE/`](../../how-to/src/SCALE-ARCHITECTURE/) — readiness audit and
  sizing envelope (how the app scales).
- [`how-to/src/SERVER-ARCHITECTURE/`](../../how-to/src/SERVER-ARCHITECTURE/) — the server/edge
  contract (what the server must provide). **This doc owns the targets and the techniques that
  meet them; SERVER-ARCHITECTURE owns the compute the server assigns**
  ([`architecture/BUILD-OPERATE-SEAM.md`](architecture/BUILD-OPERATE-SEAM.md)).
- [`architecture/CORE-AND-SCALING.md`](architecture/CORE-AND-SCALING.md) — the keystone scaling
  doc; both snapshots follow the same discipline: reconcile against measured load, don't
  provision ahead of it (anti-forecast).

_Part of the `code/docs/` documentation family._
