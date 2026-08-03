# Scale Architecture — Overview

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> (via `/scale-planning`)

> **Template skeleton.** Part of the <%ORG_NAME%> base template. The structure, framing rules,
> glossary, and contract discipline below are reusable as-is; every concrete value (process
> inventory, load figures, citations) is a placeholder to be **regenerated from this project's
> live code on the first `/scale-planning` run**. Do not treat the placeholder values as real.

This directory answers one question about the <%PROJECT_NAME%> application: **how does it
scale?** Not "how big should the server be" (that is `how-to/src/SERVER-ARCHITECTURE/`), and
not "what growth do we expect" (this repo deliberately refuses to forecast) — but: given the
system as it is actually built and deployed today, which parts absorb more load by turning a
knob, which parts need structural work, and which observable signals tell us when to act.

## The pipeline

```text
codebase ──reconcile──▶ how-to/src/SCALE-ARCHITECTURE ──(+buffer)──▶ how-to/src/SERVER-ARCHITECTURE ──▶ <%DEPLOY_REPO%>
```

1. **Reconcile.** Each `/scale-planning` run diffs this snapshot against the live codebase —
   Compose files, Django settings, `config/urls.py`, the ADRs — and patches any drift. The
   code is authoritative; these documents are its current, verified reading.
2. **Assess.** `LOAD-PROFILES.md` states how each surface loads the stack and what its binding
   metric is; `READINESS.md` audits each dimension as config-flip or rewrite;
   `SIZING-ENVELOPE.md` maps the tunable knobs onto the project's Postgres-scaling ADR's
   phase-gates.
3. **Buffer and assign.** `SERVER-ARCHITECTURE/` takes the envelope's current-tier peak,
   applies the headroom buffer (below), and expresses the result as assigned compute and edge
   duties for the deploy repo.
4. **Provision.** The `<%DEPLOY_REPO%>` repo (handoff map:
   `how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md`) turns the server spec into
   declarative NixOS configuration and Compose deployment.

## The anti-forecast principle

This repo is explicitly anti-forecast, and this directory must never undermine that:

- **The project's Postgres horizontal-scaling ADR**: "Progress through phases only when the
  threshold for each phase is observable and measured — do not pre-emptively add
  infrastructure."
- **`code/docs/PERFORMANCE.md`**: "Do not optimise without measuring... Wait until a real
  performance problem exists, then fix the actual bottleneck."
- **`code/docs/performance/API-AND-MONITORING.md`**: load-test "after adding a new tenant or
  significantly increasing the user base"; a p95 regression beyond the guide's stated
  threshold requires investigation.

The consequences for these documents:

- A **target user-count sets the trajectory** the architecture must be _able_ to follow — it
  does **not** authorise provisioning anything now. The readiness audit exists precisely so
  that when a phase-gate trips, moving up is a rehearsed config flip, not a scramble.
- **Reconciliation is a readiness audit plus a sizing envelope** — never a purchase order.
- **No tier target is invented.** No concrete target-user or traffic figure exists in this
  template yet. All tier targets in `LOAD-PROFILES.md` are marked
  `TBD — set via /scale-planning grilling` until <%DEVELOPER_NAME%> settles them.

## The load-target model

Three surfaces scale independently, each with its own binding metric, across three tiers
(**launch · 6-month · 2-year**). These are the template's **reusable default surface set** —
reconcile them against this project's actual surfaces on the first `/scale-planning` run
before assuming they hold:

| Surface            | Binding metric                                                     | Character                                  |
| ------------------ | ------------------------------------------------------------------ | ------------------------------------------ |
| public / marketing | peak req/s                                                         | cache-dominated anonymous reads            |
| authenticated app  | peak concurrent held connections (SSE/WebSocket) + active sessions | stateful, session-authed, held connections |
| admin / staff      | seats                                                              | small, authenticated, bursty               |

Full profiles, the paths each surface exercises, and the tier table (targets
`TBD — regenerate via /scale-planning against this project's live code`): `LOAD-PROFILES.md`.

## The buffer policy

`SERVER-ARCHITECTURE/` consumes the envelope under this locked rule:

> **Assign ≈ current-tier peak × (1 + headroom)**, sized so that _normal_ peak load keeps the
> server comfortably **under the scaling ADR's gate triggers** (primary CPU/IO
> sustained-utilisation ceiling; read p95 ceiling —
> _TBD, regenerate via /scale-planning against this project's live code and ADRs_). A gate-trip
> is therefore a genuine "move up a tier" signal, not noise from an undersized baseline.

The headroom value itself is a `SERVER-ARCHITECTURE/` decision (settled by grilling, recorded
there). This side only guarantees the inputs: an honest current-tier peak per binding metric
and an honest statement of which knobs the next tier turns.

## How the snapshot stays current

The `scale-planning` skill drives a `scale-planner` agent under the project's standard
decision machinery:

- **Wayfinder** charts the epic's open decisions onto
  `project-management/src/01-FEATURE/MAP-SCALE-PLANNING.md`, resolved node-by-node across
  sessions.
- **`grill-with-docs`** settles each decision — one question at a time, each with a
  recommended answer — and records the outcome (to the map, an ADR, or these documents).
- **Living snapshot:** regenerated from live code if missing; reconciled and drift-patched on
  every run. A value stated here without a `file:line` citation to live code is a defect.

## Reading order

1. `TOPOLOGY.md` — what actually runs, and where state and connections live.
2. `LOAD-PROFILES.md` — how the three surfaces load that topology.
3. `READINESS.md` — how ready each dimension is to move up a tier.
4. `SIZING-ENVELOPE.md` — which knobs a tier sets, and their current baselines.

Then continue to `how-to/src/SERVER-ARCHITECTURE/` for the buffered, server-facing output.
