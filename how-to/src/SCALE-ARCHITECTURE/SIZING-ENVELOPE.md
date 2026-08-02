# Sizing Envelope — The Knobs, Their Baselines, and the Phase-Gates

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

> **Template skeleton.** Part of the <%ORG_NAME%> base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

The sizing envelope is the set of tunable values that bound what the current deployment can
absorb. For each knob: where it is set, its current baseline (cited to a live-code source),
which surface/binding metric it serves, and how it maps onto the project's Postgres
phase-gates. **Per-tier values are TBD** — they are derived from the tier targets in
`LOAD-PROFILES.md`, which are themselves unset until `/scale-planning` grilling settles them.
This document guarantees the _structure_ the targets will fill.

## How SERVER-ARCHITECTURE consumes this

> **Buffer policy (locked):** assign ≈ current-tier peak × (1 + headroom), sized so normal
> peak stays **under** the Postgres phase-gate triggers (the primary CPU/IO gate and the
> read-p95 gate — thresholds **TBD — regenerate via /scale-planning against this project's
> live code**). A gate-trip is then a genuine move-up-a-tier signal. The headroom value is
> settled and recorded in `SERVER-ARCHITECTURE/`; this side supplies the per-knob baselines
> and the measured current-tier peaks (measurement sources: `LOAD-PROFILES.md`).

---

## The knobs

> The six knobs below are the reusable catalogue — the app-tier, connection, cache, background,
> request-ceiling, and substrate dials. The catalogue and its phase-gate mapping are stable
> across <%ORG_NAME%> projects; every **baseline** value is a placeholder to reconcile against this
> project's live code.

### 1. Gunicorn/Uvicorn workers — the app-tier throughput and stream-capacity knob

| Setting                 | Where                                                              | Baseline                                                                  |
| ----------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| `GUNICORN_WORKERS`      | env → `code/src/docker/docker-compose.prod.yml` (+ `.staging.yml`) | **TBD — regenerate via /scale-planning against this project's live code** |
| `GUNICORN_TIMEOUT`      | env → `code/src/docker/docker-compose.prod.yml`                    | **TBD — regenerate**                                                      |
| `GUNICORN_MAX_REQUESTS` | env → `code/src/docker/docker-compose.prod.yml`                    | **TBD — regenerate** (worker recycle — leak hygiene)                      |

Serves: public/marketing miss/render throughput **and** the authenticated app's held
long-lived-connection capacity (each async worker is a loop holding streams — `TOPOLOGY.md`).
Pure env flip; bounded above by server cores/RAM (server tier, knob 6) and by DB connections
(knob 2: each worker holds a persistent connection, `conn_max_age`).
**Phase-gate link:** raising workers raises primary connection count and CPU — the Phase 1/2
gates are the ceiling this knob pushes against. Tier values: **TBD**.

### 2. Database pool / connection-pooler — the connection-headroom knob

| Setting                               | Where                          | Baseline                                                                  |
| ------------------------------------- | ------------------------------ | ------------------------------------------------------------------------- |
| `conn_max_age` / `conn_health_checks` | `config/settings/base.py`      | **TBD — regenerate** — persistent per-worker connections                  |
| Direct connections (worst case)       | derived                        | ≈ `GUNICORN_WORKERS` + `CELERY_CONCURRENCY` + beat — **TBD — regenerate** |
| Connection-pooler (PgBouncer) pool    | deploy repo (Phase 0 baseline) | **TBD — regenerate via /scale-planning against this project's live code** |

Serves: every surface. The pool is what lets worker count grow without exhausting Postgres
`max_connections`.
**Phase-gate link:** this is the Phase 0 architecture itself ("single primary + pooler").
At Phase 1 the pool splits (primary + `readonly` alias via the Postgres horizontal-scaling
ADR's router); at Phase 2 it points at the shard coordinator. Tier values: **TBD**.

### 3. Valkey memory and channels — the cache/broker/pub-sub knob

| Setting                                      | Where                                                                             | Baseline                                                                                                                                 |
| -------------------------------------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `maxmemory` + `maxmemory-policy allkeys-lfu` | Valkey NixOS config — **deploy-repo knob** (the cache-stampede-mitigation ADR)    | `maxmemory` **TBD — regenerate**; policy `allkeys-lfu` (default)                                                                         |
| Cache client behaviour                       | `config/settings/base.py`                                                         | django-valkey, DB 1, `KEY_PREFIX <%ORG_SLUG%>`, default TTL **TBD — regenerate**, `IGNORE_EXCEPTIONS=True` (outage → misses, not errors) |
| DB split                                     | locked convention (`SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md`, connection plane) | DB 0 broker + pub/sub + rate-limit; DB 1 cache                                                                                           |

Serves: public/marketing (page cache, stampede posture), authenticated app (pub/sub channels +
presence keys — grows with online users), all (sessions read-through, Celery broker).
**Phase-gate link:** none of the Postgres phase-gates — Valkey scales by memory until the
cache ADR's multi-node step ever becomes real. Watch instead: evictions under LFU and pub/sub
delivery lag. Tier values: **TBD**.

### 4. Celery concurrency — the background-throughput knob

| Setting                         | Where                                           | Baseline                                                                                                  |
| ------------------------------- | ----------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `CELERY_CONCURRENCY`            | env → `code/src/docker/docker-compose.prod.yml` | **TBD — regenerate**                                                                                      |
| `CELERY_MAX_MEMORY` (per child) | env → `code/src/docker/docker-compose.prod.yml` | **TBD — regenerate**                                                                                      |
| Queues                          | single default queue                            | multi-queue + autoscaling **explicitly deferred** (TBD — reconcile against this project's task inventory) |

Serves: everything moved off the request path — email, scans, exports, the heaviest render or
document jobs, scheduled regenerations, and periodic reapers — and, from Phase 2, all
cross-shard aggregates by rule. Reconcile the task inventory against this project's live code.
**Phase-gate link:** Phase 2 makes Celery the _only_ lawful home of cross-shard work, so its
concurrency becomes a first-class envelope figure then. Until queue depth is observed growing,
the deferral stands. Tier values: **TBD**.

### 5. Request budget — the explicit throughput ceiling

| Setting                   | Where                                     | Baseline                                         |
| ------------------------- | ----------------------------------------- | ------------------------------------------------ |
| `GLOBAL_RATE_LIMIT_MAX`   | env → `config/settings/base.py`           | **TBD — regenerate** (site-wide req/min ceiling) |
| Cloudflare edge rate rule | deploy repo (aligned with the app budget) | mirrors the app budget                           |

Serves: public/marketing primarily — the de facto peak-req/s cap. A marketing tier move
**must** raise both ends together (app env + edge rule) or the edge silently caps the tier.
Tier values: **TBD**.

### 6. Server tier — the substrate knob

| Setting          | Where                   | Baseline                                                                  |
| ---------------- | ----------------------- | ------------------------------------------------------------------------- |
| Dedicated server | deploy repo `README.md` | **<%SERVER_TIER%>**, single box: all bare-metal services + all containers |

Serves: everything — cores bound worker counts, RAM bounds Valkey `maxmemory` + Postgres
`shared_buffers`, disk I/O bounds the Phase 2 gate metric directly.
**Phase-gate link:** vertical (a bigger box) remains the first, cheapest response to an
approaching CPU/IO gate _before_ Phase 1/2 topology changes — a config-flip in the deploy repo.
Phase 1 (replica) and Phase 2 (shard workers) are the first knobs that require **additional
machines**, which is exactly why they are gate-locked. Tier values: **TBD**.

---

## Envelope summary — knob × phase-gate

The **structure** of this table is the reusable artefact — the six knobs against the three
Postgres phases. The gate thresholds and Phase-0 baselines are placeholders.

| Knob             | Phase 0 (now)                     | Phase 1 trigger: read p95 > [TBD] sustained                | Phase 2 trigger: CPU/IO > [TBD] sustained           |
| ---------------- | --------------------------------- | ---------------------------------------------------------- | --------------------------------------------------- |
| Gunicorn workers | env bump within box limits        | unchanged (reads move to replica)                          | unchanged (writes still one primary path per shard) |
| DB pool          | single primary + pool             | + `readonly` alias + router (code pre-written per the ADR) | pool → shard coordinator; FK/migration discipline   |
| Valkey           | memory headroom (deploy knob)     | unchanged                                                  | + cache warming for cross-shard aggregate caches    |
| Celery           | concurrency **TBD**, single queue | unchanged                                                  | becomes the sole cross-shard query path — resize    |
| Request budget   | both ends aligned (**TBD**)       | raise with measured marketing peak                         | raise with measured marketing peak                  |
| Server tier      | <%SERVER_TIER%>; vertical first   | + replica machine                                          | + coordinator + ≥ 2 workers                         |

**The discipline, restated:** every column right of "Phase 0" is entered only on its observed
trigger — never on a date, a target, or a hunch. The envelope's job is to make sure that when
the trigger fires, the change is already named, costed, and rehearsed.

## Current-tier peaks (inputs to the buffer)

The three surfaces below are the reusable **default** set — public/marketing, authenticated
app, admin/staff. Reconcile them against this project's actual surfaces on the first run; every
measured peak is a placeholder until a gauge is wired.

| Binding metric                                  | Measured peak                       | Source                                                        |
| ----------------------------------------------- | ----------------------------------- | ------------------------------------------------------------- |
| public/marketing peak req/s                     | **TBD — regenerate** (pre-launch)   | Prometheus/nginx — wire before first buffer calculation       |
| authenticated app concurrent long-lived streams | **TBD — regenerate** (no gauge yet) | candidate first `/scale-planning` action (`LOAD-PROFILES.md`) |
| admin/staff seats                               | **TBD — regenerate**                | admin/staff member count                                      |

Until these are measured in anger, `SERVER-ARCHITECTURE/` buffers from the baselines above —
which is precisely why each knob is cited to its live-code source (`file`/env location) and
reconciled every run.
