# Readiness — Config-Flip or Rewrite, Per Dimension

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

> **Template skeleton.** Part of the <%PROJECT_NAME%> base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

The readiness audit answers, for each target tier of the project's Postgres horizontal-scaling
ADR: **is reaching it a configuration flip, or a rewrite?** The anti-forecast rule means we do
not build ahead — but we _do_ keep the path rehearsed, so a tripped phase-gate is followed by a
calm change, not a scramble. Each dimension below is assessed honestly against the code as it is
today — regenerate every verdict from live code on the first `/scale-planning` run.

Verdicts: **FLIP** (env var / NixOS module / small declared change) · **NEAR-FLIP** (small,
already-designed code change) · **WORK** (real engineering, already scoped by an ADR) ·
**OPEN** (unscoped — needs a `/scale-planning` grilling before the gate can trip safely).

The three-surface starting set — **public/marketing · authenticated app · admin/staff** — is
the template default; reconcile it against this project's actual surfaces before assessing.

---

## Dimension 1 — Statelessness of the app tier

**Verdict: TBD — regenerate via /scale-planning against this project's live code** (baseline
expectation: FLIP).

- Gunicorn/Uvicorn workers should hold no cross-request state; sessions are expected to be
  `cached_db` (Postgres-durable, Valkey-accelerated, no affinity) — confirm in
  `config/settings/`.
- Any streaming transport (SSE) should ride per-user Valkey pub/sub channels, so **any** worker
  can hold **any** user's stream. Adding workers then adds connection capacity with **no**
  sticky-session requirement. Verify the fan-out path against the authenticated-app surface's
  realtime service.
- Celery workers are stateless consumers; the broker (Valkey DB 0) holds the queue.
- Watch two caveats, neither normally blocking: **Celery beat is a singleton** (one instance
  only — its loss pauses schedules until restart; acceptable under `restart: unless-stopped`),
  and any **legacy/dark consumer** left in the tree should be torn down rather than ever scaled.

## Dimension 2 — Bounded / keyset-paginated queries

**Verdict: TBD — regenerate via /scale-planning against this project's live code** (baseline
expectation: NEAR-FLIP — good posture depends on a repo-wide audit not yet run).

- Authenticated-app collection reads should be **keyset-paginated** on an opaque `public_id`
  cursor resolved to a pk with a stable `order_by` — the right shape for unbounded growth, and
  replica-safe. Confirm the pattern on this project's high-volume list endpoints.
- Public/marketing queries should be **explicitly bounded** (fixed slices) and cache-fronted;
  offset pagination is fine at marketing volumes behind the page cache.
- The perf checklist mandates "all collection endpoints are paginated with enforced limits"
  (`code/docs/performance/API-AND-MONITORING.md`), but this is enforced by review, not by a
  repo-wide audit. **Honest gap:** no automated check proves every Django Ninja list router
  carries a limit. Candidate `/scale-planning` action: a one-off router/endpoint sweep before
  Phase 1.

## Dimension 3 — Tenant scoping (distribution-key coverage) for Phase 2

**Verdict: TBD — regenerate via /scale-planning against this project's live code** (baseline
expectation: OPEN — the honest one).

- The Postgres horizontal-scaling ADR's premise: a uniform distribution key (e.g. a `tenant_id`
  / area FK) on every user-owned table, hash-shard on it at Phase 2. RLS applied comprehensively
  at the DB level (`code/docs/RLS-GUIDE.md`) proves per-row scoping discipline exists everywhere
  it matters.
- **But the scoping key may not be uniform.** Different surfaces can key on different columns —
  one surface on a client/owner FK, another on **membership** (a SECURITY DEFINER predicate)
  rather than a tenant column; the user table may deliberately carry no RLS. A record spanning
  staff + client members may have no single obvious distribution column today. Reconcile the
  actual scoping keys against this project's tables.
- Consequence: Phase 2's `create_distributed_table(..., '<distribution_key>')` cannot be applied
  mechanically to membership-keyed domains — the distribution-column mapping (and co-location
  groups) for those tables is an **unscoped design decision**. The ADR's implementing stories
  are TBD, which matches.
- This does _not_ gate Phase 1 (replica routing is scoping-agnostic). It gates Phase 2 only —
  and Phase 2's trigger (CPU/IO sustained _after_ Phase 1 proves insufficient; specific
  threshold TBD) is far off. Record the decision on the scale-planning map; do not design it
  prematurely.

## Dimension 4 — In-process state

**Verdict: TBD — regenerate via /scale-planning against this project's live code** (baseline
expectation: FLIP).

- Audit that ephemeral state lives in Valkey, not process memory: presence markers, sweep
  markers, rate-limit counters (Valkey DB 0), and any page-cache version counter should all be
  Valkey keys — confirm against this project's cache/realtime modules.
- Confirm **no** in-process caches, module-level registries, or local files that would break
  under multiple containers. The Celery beat schedule file is container-local by design and safe
  to lose.

## Dimension 5 — Sync-in-async I/O

**Verdict: TBD — regenerate via /scale-planning against this project's live code** (baseline
expectation: NEAR-FLIP — contained, with one known structural cost).

- The hot async path (SSE) should be genuinely async: `redis.asyncio` subscriptions, an async
  view, DB touches wrapped for the async context. Backlog replay and per-event RLS re-reads that
  hit Postgres from the async loop should each be short and indexed — under high connection
  counts these sync-into-async hops are the **first** thing to profile (they occupy the worker's
  executor). Verify the streaming view against this project's realtime code.
- Everything else long-running should already be off the request path by rule: Celery for email,
  scans, exports, sitemap regeneration, and (from Phase 2) cross-shard aggregates
  (`CORE-AND-SCALING.md`, cross-shard query rule; the project's export-pipeline ADR).
- The Django Ninja API routers and HTMX views are conventional sync Django under ASGI — fine,
  bounded by `GUNICORN_TIMEOUT` (confirm the value in the prod Compose file).

## Dimension 6 — Cache-stampede posture

**Verdict: TBD — regenerate via /scale-planning against this project's live code** (baseline
expectation: FLIP by design — the ladder exists, expect to be on step 0).

- Expected current state: baseline `get_or_set` + TTLs (step 0 of the project's
  cache-stampede-mitigation ADR ladder). A version-keyed page cache whose publish path bumps the
  version is an **instant mass-invalidation** — the classic stampede window if it fires at
  marketing peak. Confirm the page-cache versioning scheme against this project's cache module.
- The cache-stampede ADR pre-designs the escalation with measurable triggers: step 1 coalescing
  (add when latency spikes correlate with expiry), step 2 SWR, step 3 Celery-warmed hot keys,
  step 4 Lua, step 5 Redlock (only if Valkey ever goes multi-node). Each is a small, contained
  Django change — no infrastructure.
- **Honest state to verify:** steps 1–3 are typically unimplemented, which is _correct_ per the
  incremental-rollout rule — but the trigger metrics (expiry-correlated latency) may not yet be
  alerted on. Wiring that observation is cheaper than the mitigation and should precede it.

---

## Verdict against the phase-gate tiers

Regenerate every cell against this project's live code on the first `/scale-planning` run — the
tier vocabulary and column structure are the reusable framework; the readiness verdicts are
placeholders.

| Target tier                                           | What it takes                                                                                                                                                    | Readiness                                                                                                                       |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Phase 0 headroom** (more of the same)               | `GUNICORN_WORKERS` / `CELERY_CONCURRENCY` env bumps; raise the global rate-limit max + CF edge rule; Valkey `maxmemory` (NixOS)                                  | **FLIP** — all declared knobs (`SIZING-ENVELOPE.md`)                                                                            |
| **Phase 1** (streaming replica + `using('readonly')`) | Provision replica (deploy repo); add the ADR's `PrimaryReplicaRouter` + `readonly` DATABASES entry; audit read-after-write paths                                 | **NEAR-FLIP** — router code is pre-written in the scaling ADR; replica-lag audit is the real work; story TBD                    |
| **Phase 2** (shard on the distribution key)           | Coordinator + ≥ 2 workers; distribution-column mapping incl. the membership-keyed domain (Dimension 3); FK drops + service-layer integrity; migration discipline | **WORK + OPEN** — scoped by the scaling ADR except the Dimension-3 mapping; all stories TBD; do not start before the gate trips |
| **Celery growth** (multi-queue / autoscale)           | Dedicated queues + autoscaling, explicitly deferred to a named future story ("worker autoscaling / multiple queues")                                             | **NEAR-FLIP** — compose-level change; deferred until queue depth demands it                                                     |
| **Object-store geo-scale**                            | SeaweedFS → Garage behind the boto3 seam (the object-store ADR names Garage as the geo trigger)                                                                  | **FLIP at the app** (config-only engine swap); deploy-repo work server-side                                                     |

**Verify in deploy repo:** the scaling ADR's Phase 0 assumes PgBouncer in front of the primary;
confirm PgBouncer's presence (or absence — the NixOS runbook may ship only the postgres-proxy
:5501) before counting connection headroom — tracked as a `SERVER-ARCHITECTURE/` reconcile item.
