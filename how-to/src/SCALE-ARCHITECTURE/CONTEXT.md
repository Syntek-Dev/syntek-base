# how-to/src/SCALE-ARCHITECTURE — How the Application Scales

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

The application-side scaling snapshot: what the running system looks like today, how each
surface loads it, how ready the architecture is to move up the Postgres scaling phase-gates, and
which knobs a tier change turns. This directory is the **reconciled substrate** that
`how-to/src/SERVER-ARCHITECTURE/` (the server-facing spec) and the separate `<%DEPLOY_REPO%>`
repo consume — it describes _how it scales_, never _what to buy_.

## Directory Tree

```text
how-to/src/SCALE-ARCHITECTURE/
├── CONTEXT.md           ← this file — orientation + glossary
├── CLAUDE.md            ← operating rules for working in this directory
├── OVERVIEW.md          ← entry point: what this snapshot is, the pipeline, the anti-forecast rule
├── TOPOLOGY.md          ← deployment/runtime topology as it bears on scale (processes, state)
├── LOAD-PROFILES.md     ← the three surfaces, binding metrics, growth-curve tiers (targets TBD)
├── READINESS.md         ← config-flip-vs-rewrite audit per readiness dimension (honest state)
└── SIZING-ENVELOPE.md   ← the tunable knobs, current baselines, phase-gate mapping
```

## What is here

| Document             | Read when                                                                  |
| -------------------- | -------------------------------------------------------------------------- |
| `OVERVIEW.md`        | First — the snapshot's purpose, the reconcile→buffer→provision pipeline    |
| `TOPOLOGY.md`        | You need the process inventory: what runs, what holds state or connections |
| `LOAD-PROFILES.md`   | You need a surface's load shape, binding metric, or the tier table         |
| `READINESS.md`       | You are assessing whether reaching a tier is a config flip or a rewrite    |
| `SIZING-ENVELOPE.md` | You are setting or reading the capacity knob values for a tier             |

## What this directory is NOT

- **Not the server spec.** Assigned compute, edge duties, and the applied headroom buffer live
  in `how-to/src/SERVER-ARCHITECTURE/` (seeded separately) and are provisioned by the
  `<%DEPLOY_REPO%>` repo.
- **Not a forecast.** The Postgres-scaling ADR and `code/docs/PERFORMANCE.md` are explicit:
  measure first, scale on observable phase-gates, "do not pre-emptively add infrastructure". No
  document here authorises buying capacity.
- **Not a duplicate of the ADRs.** The Postgres-scaling, cache-stampede-mitigation, and
  object-store ADRs and `code/docs/architecture/CORE-AND-SCALING.md` are referenced, never
  restated.

## Glossary

**Sizing envelope** — the set of tunable capacity values (Gunicorn workers, Celery
concurrency, DB pool, Valkey maxmemory, server tier) that together bound what the current
deployment can absorb, expressed per tier with headroom. Defined in `SIZING-ENVELOPE.md`.
_Avoid_ "capacity" — repo-wide that means sprint story-point capacity
(`project-management/docs/SPRINT-PLANNING-GUIDE.md`). _Avoid_ "provisioning plan" — that is
the deploy repo's output, downstream of here.

**Readiness audit** — the per-dimension assessment in `READINESS.md` of whether reaching the
next tier is a configuration flip (env var, NixOS module, router class) or a rewrite
(schema migration, code restructure). _Avoid_ "gap analysis" — that names the
`PLANNING/` gap reports and `GAPS.md` workflow. _Avoid_ "health check" — that is the live
`/health/` probe surface (`apps.health`).

**Load profile** — the description of how one surface (marketing, portal, admin/staff)
exercises the stack: its request/async paths, its load shape, and its binding metric.
Defined in `LOAD-PROFILES.md`. _Avoid_ "traffic forecast" or "traffic model" — forecasting is
exactly what this repo refuses to do; a profile describes shape, not predicted volume.

**Binding metric** — the single measurement that saturates first on a surface and therefore
governs its tier position (marketing → peak req/s; portal → peak concurrent SSE connections;
admin → seats). _Avoid_ "KPI" — business reporting vocabulary. _Avoid_ "SLO" — the perf
budgets in `code/docs/performance/API-AND-MONITORING.md` are budgets, and the binding metric
is what pushes against them.

**Phase-gate** — a Postgres-scaling-ADR observable trigger that authorises the next
infrastructure phase (Phase 1: read p95 > 50 ms sustained; Phase 2: primary CPU/IO > 70 %
sustained). A gate-trip is the _only_ signal to move up a tier. _Avoid_ "milestone" —
sprint/PM vocabulary. _Avoid_ a bare "threshold" — the perf budgets are also thresholds; a
phase-gate is specifically the scaling trigger.

## Living-document contract

This snapshot is **regenerated if missing and reconciled on every `/scale-planning` run**: the
`scale-planner` agent diffs each document against the live codebase (Compose files, settings,
ADRs, app CONTEXT.md files) and patches drift before any new decision is grilled. Nothing here
is authoritative over the code — the code is the source; these documents are its current,
verified reading. Decisions (tier targets, headroom values) are settled through
`grill-with-docs` and charted on the project's plans folder (`MAP-SCALE-PLANNING.md`).

## Cross-references

- `how-to/src/SERVER-ARCHITECTURE/` — the downstream server-facing spec (assigned compute + buffer)
- the project's decision register — where the scaling and cache-posture decisions are recorded
- `code/docs/architecture/CORE-AND-SCALING.md` — the day-to-day scaling rules
- `code/docs/PERFORMANCE.md` (+ `performance/API-AND-MONITORING.md`) — budgets and load-test triggers
- `<%DEPLOY_REPO%>` (deploy repo) — the provisioning this snapshot's topology maps
  onto, via `how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md`
