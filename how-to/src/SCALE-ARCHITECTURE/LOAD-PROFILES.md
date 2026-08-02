# Load Profiles — The Three Surfaces and Their Binding Metrics

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

> **Template skeleton.** Part of the <%ORG_NAME%> base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

The application presents three surfaces that scale independently. Each has one **binding
metric** — the measurement that saturates first and therefore governs that surface's tier
position. This document describes the _shape_ of each surface's load and the paths it
exercises; it sets **no volume targets** (see the tier table at the end — targets are TBD by
design, per the anti-forecast principle in `OVERVIEW.md`).

The three surfaces below — **public/marketing · authenticated app · admin/staff** — are the
template's reusable **default surface set**. They are the starting point, not a fact about any
particular project: on the first `/scale-planning` run, **reconcile them against this project's
actual surfaces** (some projects fold portal + staff into one authenticated surface; some add a
fourth). Keep whichever bind independently.

All surfaces share the perf budgets in `code/docs/performance/API-AND-MONITORING.md`:
TTFB < 200 ms · LCP < 2.5 s · API p95 < 500 ms · DB query p95 < 50 ms · JS < 200 KB gz ·
error rate < 0.1 %. The binding metrics below are what push against those budgets.

---

## Surface 1 — Public / marketing (public site)

**Binding metric: peak requests/second.** Cache-dominated anonymous reads.

**What it is:** the Django-templated public site (django-components + HTMX + Alpine + token
CSS) — home, about, blog, portfolio, services, sector pages, legal — served behind Nginx, plus
the SEO endpoints (robots/sitemaps/llms.txt/RSS/Atom) and the token-CSS asset. Anonymous,
uncached-write-free by default.

**Path exercised per request:**

1. CF edge (static asset hits largely die here) → CF Tunnel → Nginx → Django.
2. A full-page cache in Valkey (DB 1), keyed under a **version-namespaced** cache key: a
   **HIT** is one Valkey GET and a response — no DB. A **MISS** renders the template against
   Postgres, then writes back. Any content publish bumps the version, atomically invalidating
   every page.
   _(TTL — TBD — regenerate via `/scale-planning` against this project's live code.)_
3. The surface's form/POST endpoint (e.g. a contact form) is never cached; it is typically the
   surface's only regular write path (enquiry insert + Celery-queued email + upload scan).

**Load shape:** high read ratio, spiky (a shared blog post, a campaign), near-zero writes.
The stampede exposure on version-bump or TTL expiry is governed by the project's
**cache-stampede mitigation ADR** — reconcile the current posture step (e.g. plain `get_or_set`

- TTL vs. coalescing/SWR/warming) against live code; escalation triggers live in `READINESS.md`.

**Current explicit ceiling:** the site-wide request budget (the global rate-limit setting in
`config/settings/base.py`), mirrored by the Cloudflare edge rule (deploy repo), is the de facto
marketing throughput cap — raising it is part of any tier move.
_(Value — TBD — regenerate via `/scale-planning` against this project's live code.)_

**Scales by:** cache hit-rate first (near-free), then Gunicorn/Uvicorn worker count for the
miss/render path, then the DB read path (the Postgres horizontal-scaling ADR's first phase) —
in that order.

---

## Surface 2 — Authenticated app (client-facing, real-time / stateful)

**Binding metric: peak concurrent long-lived connections + active users.** This is the main
concurrency/stateful surface — the only place the app holds long-lived connections. (If a given
project's authenticated surface holds no streams, its binding metric collapses to peak req/s
like Surface 1 — reconcile on the first run.)

**What it is:** the login-gated authenticated surface (Django-templated, session-authed,
uncached, CSRF-carrying) and any real-time engine behind it (e.g. a chat/notifications stream).

**Path exercised:**

- **Page/HTMX requests:** Nginx → Django → Postgres under membership-scoped RLS; any encrypted
  PII is Fernet-decrypted at the single `presentation` boundary. Normal short requests.
- **The stream (the load that matters):** where the surface streams, each connected user holds
  **one open HTTP connection per tab** on a Uvicorn worker, subscribed to a per-user Valkey
  pub/sub channel (DB 0). On connect: an unseen-backlog replay from Postgres. Per live event: an
  id-only frame, re-read under the recipient's own RLS, rendered server-side.
  _(Channel/key names — TBD — regenerate via `/scale-planning` against this project's live code.)_
- **Presence:** heartbeats refresh a short-TTL presence key; a Celery-beat reaper `SCAN`s the
  keyspace on an interval — a steady background cost proportional to online users.
  _(Presence TTL + reaper interval — TBD — regenerate via `/scale-planning` against this
  project's live code.)_
- **Sends/writes:** POST → RLS-checked insert → post-commit fan-out publish to each member's
  channel. Attachments route Cloudinary (public media) / SeaweedFS S3 (private files) with an
  upload malware scan (ClamAV).

**Load shape:** connection-count-bound, not throughput-bound. Cost per idle connection is an
async task + a pub/sub subscription (cheap); cost per event is fan-out × per-recipient RLS
re-read (a DB touch per delivery). Hot spots under growth: (a) Uvicorn worker async capacity for
held connections, (b) per-event DB re-reads, (c) reaper sweep time as the presence keyspace
grows. Fan-out through Valkey means workers scale horizontally with no affinity.

**Scales by:** worker count (more async loops for held connections) → Valkey headroom (pub/sub +
presence) → DB read path for backlog/RLS re-reads (the Postgres scaling ADR's first phase).

---

## Surface 3 — Admin / staff (internal)

**Binding metric: seats.** A small, known population of internal staff accounts.

**What it is:** the internal admin area — Django-templated staff pages (login door,
shell/dashboard, media library) — server-rendered like every other surface, saving through
session-authed Django Ninja `/api/*` routers; `/control/` is the Django admin at its
non-obvious path (never `/admin/`). Staff real-time seats also land on Surface 2's stream
transport.

**Path exercised:** authenticated reads/writes against Postgres (some via a `BYPASSRLS`
admin DB alias), Cloudinary/media admin API calls, design-token editor writes, analytics/
observability dashboards reading short-TTL Valkey-cached upstream data.

**Load shape:** low volume, bursty, write-heavy relative to the other surfaces, never
cache-served. Seats predict everything: concurrent editors, dashboard polling, staff real-time
connections. Platform-wide aggregates must already be background Celery work, never
request-path (`code/docs/architecture/CORE-AND-SCALING.md`, cross-shard query rule) — that
discipline is what keeps this surface flat as data grows.

**Scales by:** effectively nothing until seats grow materially; its scaling story is the
discipline (background aggregates, bounded queries), not capacity.

---

## The growth-curve tier table

Tiers are **launch · 6-month · 2-year**. The structure below is locked; the volume targets and
current baselines are deliberately unset — a fresh template carries **no measured figures**, and
inventing one here would violate the anti-forecast principle. Baselines are regenerated from live
code on the first `/scale-planning` run; targets are settled by <%DEVELOPER_NAME%> through `/scale-planning`
grilling and recorded on `MAP-SCALE-PLANNING.md`; the envelope (`SIZING-ENVELOPE.md`) then states
what each tier requires.

| Surface           | Binding metric                                  | Current baseline                                                   | Launch tier                              | 6-month tier                             | 2-year tier                              |
| ----------------- | ----------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| public/marketing  | peak req/s                                      | TBD — regenerate via `/scale-planning` against this project's code | TBD — set via `/scale-planning` grilling | TBD — set via `/scale-planning` grilling | TBD — set via `/scale-planning` grilling |
| authenticated app | peak concurrent long-lived conns + active users | TBD — regenerate via `/scale-planning` against this project's code | TBD — set via `/scale-planning` grilling | TBD — set via `/scale-planning` grilling | TBD — set via `/scale-planning` grilling |
| admin/staff       | seats                                           | TBD — regenerate via `/scale-planning` against this project's code | TBD — set via `/scale-planning` grilling | TBD — set via `/scale-planning` grilling | TBD — set via `/scale-planning` grilling |

**How to read a target once set:** it defines the trajectory each surface must be _able_ to
follow — the readiness audit must show a config-flip (or a named, rehearsed change) path to it —
but provisioning for it happens only when a Postgres-scaling ADR phase-gate or a measured
binding-metric trend demands it.

**Measurement first:** each binding metric needs a live measurement source before targets mean
anything — Nginx/Prometheus req/s for marketing, a connection gauge for the authenticated stream
surface (a likely first `/scale-planning` outcome if none exists yet), and the staff-account
count for seats.
