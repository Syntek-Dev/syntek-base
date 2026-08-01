# SERVER-ARCHITECTURE — Overview

**Last Updated**: {{DATE}} | **Maintained By**: {{ORG_NAME}} (via `/scale-planning`)

> **Template skeleton.** Part of the {{PROJECT_NAME}} base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

## What this directory is

`SERVER-ARCHITECTURE/` is the **deploy-facing consolidation** of everything the
{{PROJECT_NAME}} application requires from the server and the edge. It exists so the
deploy repo (`{{DEPLOY_REPO}}`) has a single document to implement against, rather than
requirements scattered across `GAPS.md`, the ADRs, the nginx configs, the CF Tunnel
topology, and the health/metrics contract in `code/docs/logging/HEALTH-CONTRACT.md`.

It holds exactly two things:

1. **The app's requirements ON the server/edge** (`EDGE-REQUIREMENTS.md`) — security
   headers and CSP, URL routing, body-size limits, TLS, Cloudflare and CF Tunnel
   configuration, and the health/metrics endpoints the server must probe and scrape.
2. **The scaling numbers as assigned compute + buffer** (`COMPUTE-ALLOCATION.md`) —
   the sizing envelope from the sibling `how-to/src/SCALE-ARCHITECTURE/` directory,
   re-expressed as concrete per-process provisioning **with a headroom buffer**, so
   the NixOS deployment always provisions with margin.

## The pipeline

```text
codebase ──reconcile──▶ how-to/src/SCALE-ARCHITECTURE ──(+buffer)──▶ how-to/src/SERVER-ARCHITECTURE (THIS dir) ──▶ {{DEPLOY_REPO}}
```

- **codebase → SCALE-ARCHITECTURE** — the `/scale-planning` skill reconciles what the
  application actually is (workers, queues, pools, caches, endpoints) into a
  readiness audit and a sizing envelope, keyed to the project's Postgres
  horizontal-scaling ADR phase-gates.
- **SCALE-ARCHITECTURE → SERVER-ARCHITECTURE** — this directory consumes that
  envelope and adds the headroom buffer (policy in `COMPUTE-ALLOCATION.md`),
  producing assigned compute the server can provision against. It also carries the
  edge-requirement catalogue, which is independent of sizing.
- **SERVER-ARCHITECTURE → {{DEPLOY_REPO}}** — the deploy repo reads this directory and
  implements it in its NixOS modules and host configuration (`NIXOS-HANDOFF.md` maps
  which file feeds which module).

`SCALE-ARCHITECTURE/` is seeded and maintained separately — reference it by path;
never restate its envelope here beyond the assigned-compute mapping.

## The contract precedent

This directory follows an established shape, not a new invention. The app repo
already ships two app↔deploy contracts:

- `code/src/docker/prometheus/prometheus.yml` — the canonical **scrape-target
  contract** that the NixOS `services.prometheus.scrapeConfigs` must implement. No
  Prometheus runs in this repo; the file specifies, the deploy repo implements.
- `code/docs/logging/HEALTH-CONTRACT.md` — the health/metrics endpoints live in
  `{{DEPLOY_REPO}}`, not in this repo. The deploy repo's Gatus module header cites it
  back as its endpoint contract.

Every document here keeps that discipline: **this repo specifies; the deploy repo
implements.** Nothing in this directory is executable configuration.

## The anti-forecast rule

The repo is explicitly anti-forecast. The project's Postgres horizontal-scaling ADR
holds the rule: _"progress through phases only when the threshold for each phase is
observable and measured — do not pre-emptively add infrastructure"_, reinforced by
`code/docs/PERFORMANCE.md` (measure first; premature optimisation is the wrong
abstraction too early).

Consequences for this directory:

- Compute allocation is **current-tier envelope + buffer**, keyed to the ADR
  phase-gates — never a forecast build-out for imagined future load.
- The buffer exists so _normal_ peak sits below the gate triggers (CPU/IO threshold —
  TBD — regenerate via /scale-planning against this project's live code); a gate-trip
  is then a clean, observable signal to move up a tier.
- **No target-user figure exists in this repo.** Targets are recorded as
  `TBD — set via /scale-planning grilling` and never fabricated.

## What the NixOS repo reads from here

| This directory          | Consumed by (deploy repo)                                                                                                                                                                                           |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `EDGE-REQUIREMENTS.md`  | `modules/nginx/` (headers, CSP directives, body-size, routing locations), `modules/cloudflared/` + Cloudflare zone config, `modules/gatus/` + `modules/prometheus/` (probe/scrape wiring), host `configuration.nix` |
| `COMPUTE-ALLOCATION.md` | Host env for the app containers (`GUNICORN_WORKERS`, `CELERY_CONCURRENCY`, …), Postgres/pooler/Valkey sizing on the bare-metal tier, and the tier-upgrade decision when a gate trips                                |
| `NIXOS-HANDOFF.md`      | The map itself — which value lands where, and the change-flow discipline                                                                                                                                            |

## Reading order

1. `CONTEXT.md` — orientation and glossary (edge requirement · assigned compute ·
   buffer · deploy contract).
2. This file — the pipeline and the two framing rules.
3. `EDGE-REQUIREMENTS.md` — the consolidation deliverable.
4. `COMPUTE-ALLOCATION.md` — the numbers.
5. `NIXOS-HANDOFF.md` — how it lands in the deploy repo.
