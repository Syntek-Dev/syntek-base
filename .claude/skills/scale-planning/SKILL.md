---
name: scale-planning
description: >-
  Plan the deployment for a target number of users and prove it is built to scale — a
  readiness audit plus a sizing envelope keyed to the scaling phase-gates, charted as a
  wayfinder epic and settled node-by-node with grilling. Maintains two living snapshots
  (how-to/src/SCALE-ARCHITECTURE and how-to/src/SERVER-ARCHITECTURE) that feed the NixOS
  deploy repo with headroom. Invoke by typing /scale-planning, or when sizing the stack
  for growth, reconciling the architecture against what the server must provide, or
  preparing the server/edge contract the <%DEPLOY_REPO%> repo consumes.
---

# Skill: scale-planning (<%PROJECT_SLUG%>)

Scale planning answers two questions the project has never pinned down: **is the deployment
sized correctly for a target number of users, and is it built so that reaching the next tier
is a config change, not a rewrite?** It owns the app↔server/deploy contract — the spec the
separate NixOS deploy repo (`<%DEPLOY_REPO%>`) provisions against.

It runs as a **wayfinder-charted epic** — the frontier is too big for one sitting and it
spans another repo — with **grilling** settling each decision node. The governing decision is
recorded in the project's decision register; the deep vocabulary (module / interface / depth / seam) comes from
`.claude/skills/codebase-design`.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## The one rule: reconcile, never forecast

The repo is deliberately anti-forecast — the scaling phase-gates and `code/docs/PERFORMANCE.md`: _"do not
pre-emptively add infrastructure"_, scale on observable phase-gates (read p95 > 50 ms → read
replica; primary CPU/IO > 70 % → Citus), _"measure first, then optimise"_. Scale planning must
**reinforce** that, not fight it:

- The target user-count sets the **trajectory** the architecture must be _able_ to follow. It
  does **not** authorise provisioning capacity now.
- Output is a **readiness audit** (is the next tier a config-flip or a rewrite?) plus a
  **sizing envelope keyed to the phase-gates** — not a tier-by-tier build-out.
- Compute is assigned with a **headroom buffer** (below), so a node runs under its gate
  trigger — but the gate-trip, not a forecast, is the signal to move up a tier.

Never write a plan that stands up infrastructure ahead of an observed gate. If a decision would,
stop and record why in the scale-planning contract (supersede/amend — never rewrite an accepted ADR).

## Two snapshots, one pipeline

```text
codebase ──reconcile──▶ how-to/src/SCALE-ARCHITECTURE ──(+buffer)──▶ how-to/src/SERVER-ARCHITECTURE ──▶ <%DEPLOY_REPO%>
          (live code)     how it scales                  headroom      what the server must provide       (template flake repo)
```

- **SCALE-ARCHITECTURE** — _how it scales._ Per-surface load profiles, the readiness audit,
  and the sizing envelope keyed to those gates.
- **SERVER-ARCHITECTURE** — _what the server/edge must do._ The consolidated catalogue of edge
  requirements (CSP/security headers, routing, URL paths, body-size, TLS, Cloudflare, CF
  Tunnel, health/metrics) **plus** the SCALE numbers expressed as assigned compute + buffer.
  This is the deploy-facing contract, in the same spirit as `code/docs/logging/HEALTH-CONTRACT.md`
  and the `code/src/docker/prometheus/prometheus.yml` "contract".

Both live under `how-to/src/**` — the human-operational tier, exempt from the 300-line limit
(their `CONTEXT.md`/`CLAUDE.md` pairs are **not** exempt — keep those ≤ 300 lines).

## Process

### 1. Ensure the snapshot (auto-spin-up + reconcile)

The snapshot is **living**. On every run:

- **Missing** (`how-to/src/SCALE-ARCHITECTURE/` absent) → build it first. Explore the live
  codebase — the `code-review-graph` explore playbook (`code/docs/CODE-REVIEW-GRAPH.md`), then
  Read/Grep/Glob — and write the snapshot before any planning.
- **Present** → **reconcile it against the live code** and patch or flag drift before you plan.
  Never plan against a stale snapshot. This is the "ground in the live code, reconcile drift"
  doctrine (`code/docs/FRONTEND-CODING-PRINCIPLES.md` § Ground in the Live Code).

Do the same for `how-to/src/SERVER-ARCHITECTURE/` — its edge-requirement catalogue drifts as
features add new server needs (a new route needs a CSP source; a new upload needs a body-size).

### 2. Chart or resolve (wayfinder)

Load `.claude/skills/wayfinder`. The map is the project's plans folder (`MAP-SCALE-PLANNING.md`).

- **CHART** (one session) — pin the destination, map the frontier breadth-first across both
  tracks (SCALE and SERVER), wire the blocking edges, fire the research nodes, then stop.
- **RESOLVE** (later sessions) — take the next unblocked node and settle it by type: a
  **grilling** node opens `.claude/skills/grill-with-docs`; a **research** node is looked up; a
  **tracer** spikes a foggy area; a **task** does manual unblocking (e.g. hand a value to the
  deploy repo). Graduate the outcome to its real home, then redraw the frontier.

### 3. Size the envelope + buffer (grilling)

Each sizing node is a `grill-with-docs` surface. The **load target** is a **per-surface growth
curve** — never one flat number — because the surfaces scale on different metrics:

| Surface       | Binding metric            | Why                                                |
| ------------- | ------------------------- | -------------------------------------------------- |
| marketing     | peak req/s (cacheable)    | read-dominated; cache absorbs most load            |
| portal        | peak concurrent SSE conns | chat/SSE holds one live connection per active user |
| admin / staff | seats                     | low-volume internal                                |

Tiers: **launch / 6-month / 2-year**. No concrete target exists in the repo yet — set them by
grilling; do **not** fabricate numbers. Map each tier's estimated peak onto the envelope knobs
(gunicorn workers, DB pool / PgBouncer, Valkey `maxmemory`, Celery concurrency, Hetzner tier)
and onto the scaling phase-gates.

**Buffer policy:** assign compute ≈ current-tier peak × (1 + headroom), sized so normal peak
stays under the gate triggers (CPU/IO 70 %). A gate-trip is the signal to move up a tier.

### 4. Feed the server contract

Fold the envelope into `SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md` as assigned compute + buffer,
and keep `SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` current. The NixOS repo reads this contract;
this repo **specifies**, the deploy repo **implements** — never write server/edge config here.

## Readiness — the audit dimensions

For each dimension, classify reaching the next tier as **config-flip** or **rewrite**. "Built
for scalability" = the flips stay flips.

- Statelessness (no in-process session/state that a second worker/node breaks)
- Bounded, keyset-paginated queries (no unbounded scans; `tenant_id` on every user-owned table)
- Async-safe I/O (no sync blocking inside the ASGI path; chat SSE is Channels-free)
- Cache-stampede posture (the cache-stampede posture — warming / coalescing / locking)
- Data-tier headroom deferred to those gates (this skill does not re-decide Postgres scaling)

## Where decisions land (graduation)

Follow wayfinder's graduation table:

- **Architectural, hard-to-reverse, real trade-off** → a new ADR (three-test gate; next free
  number tracked in the project's decision register).
- **A buildable slice** → a `US###` story + `PLAN-US###-*.md` (synced to ClickUp by the
  `clickup-sync` workflow — never write ClickUp directly).
- **A sizing / readiness / edge fact** → the living `SCALE-ARCHITECTURE` / `SERVER-ARCHITECTURE`
  snapshot.
- **A cross-repo dependency or blocker** → `GAPS.md` (e.g. a value the NixOS repo must set).
- **Deferred to a named future story** → `DEFERRED.md`.
- **Terminology** → the glossary of the nearest `CONTEXT.md` (`domain-modelling`).

Refresh the code-review-graph after any doc change so the layered docs and the graph stay in
lockstep (`code/docs/CODE-REVIEW-GRAPH.md`).

## Anti-patterns

- **Forecasting** — standing up infrastructure ahead of an observed phase-gate. Reconcile,
  don't forecast.
- **Fabricating a target** — inventing user/traffic numbers instead of grilling them; leave an
  honest TBD.
- **Planning against a stale snapshot** — always reconcile against live code first.
- **Writing server/edge config here** — this repo specifies the contract; the NixOS repo
  implements it.
- **Re-deciding Postgres scaling** — the data tier belongs to the scaling phase-gates; key to its gates, don't
  duplicate them.
- **Grilling the whole epic in one sitting** — that is what the wayfinder frontier is for.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/13-decisions/` — where a hard-to-reverse sizing choice is recorded

## Cross-references

- `.claude/skills/wayfinder/SKILL.md` — the cartographer this runs as; the map artefact.
- `.claude/skills/grill-with-docs/SKILL.md` — the per-node engine that records decisions.
- `.claude/skills/codebase-design/SKILL.md` — depth / seam vocabulary for the readiness audit.
- `.claude/agents/scale-planner.md` — the Fable specialist that drives this skill.
- the project's own decision register — where the governing decision is recorded.
- `code/docs/architecture/CORE-AND-SCALING.md` — the phase-gates keyed to.
- `code/docs/PERFORMANCE.md` · `code/docs/architecture/CORE-AND-SCALING.md` — the budgets and scaling rules (do not duplicate).
- `code/docs/logging/HEALTH-CONTRACT.md` — the app→deploy contract precedent.
- `how-to/src/SCALE-ARCHITECTURE/` · `how-to/src/SERVER-ARCHITECTURE/` — the two living snapshots.
- `<%DEPLOY_REPO%>` — the deploy repo that implements the contract (`how-to/src/01–11`); `how-to/src/NIXOS-SETUP.md` here is now a pointer stub.
