# MAP-SCALE-PLANNING — Size this system for the growth it is meant to survive

**Charted**: TBD — run `/scale-planning` · **Charted by**: TBD · **Workflow**: `01-feature-map`
**Status**: Not started
**Frontier open**: every node below · **Blocking open**: every node below

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the guides which route here point at something real from day one. Until `/scale-planning`
> has run, every row below reads `TBD` and the answers do not exist.
>
> **Run `/scale-planning` before charting your first feature.** Sizing is cheap now and expensive
> after the tenth feature: it decides what the system does **not** need, and a decision to skip
> infrastructure is only defensible once the gate that would demand it has been named.

---

## Destination

**TBD — run `/scale-planning`.** Done means three things are true: the target user count is
written down, the readiness audit says whether the codebase can reach it, and the sizing envelope
is expressed as compute the deploy repository can actually provision — with headroom.

## Notes

| Field                    | Value                                                                  |
| ------------------------ | ---------------------------------------------------------------------- |
| Domain                   | Scale, capacity, and the server/edge contract                          |
| Skills to load           | `scale-planning` · `wayfinder` · `grill-with-docs` · `codebase-design` |
| Standing preferences     | TBD — run `/scale-planning`                                            |
| Register entries triaged | TBD                                                                    |

## The two snapshots this map feeds

| Snapshot                         | Answers                                                     | State |
| -------------------------------- | ----------------------------------------------------------- | ----- |
| `how-to/src/SCALE-ARCHITECTURE`  | _How it scales_ — load profiles, readiness, sizing envelope | TBD   |
| `how-to/src/SERVER-ARCHITECTURE` | _What the server and edge must provide_, plus buffer        | TBD   |

## Register claimed

TBD — `/scale-planning` triages `GAPS.md` and `DEFERRED.md` on its first run.

## Resolved decisions

| Node                                  | Decision | Type | Settled | Became |
| ------------------------------------- | -------- | ---- | ------- | ------ |
| _none — nothing has been settled yet_ |          |      |         |        |

## Frontier

Every axis below is unsettled. `/scale-planning` charts them properly on its first run, wires the
blocking edges, and replaces this list; the point of naming them here is that a reader can see
**what is missing** rather than only that something is.

| Node  | Decision                                                                     | Type     | Blocked by | Blocking a story? |
| ----- | ---------------------------------------------------------------------------- | -------- | ---------- | ----------------- |
| N-001 | **Target size** — users, tenants and concurrency this is designed to survive | grilling | none       | **yes**           |
| N-002 | **Load profile per surface** — request mix, payload sizes, peak shape        | grilling | N-001      | **yes**           |
| N-003 | **Read/write split and the query shapes** that dominate at target            | grilling | N-002      | **yes**           |
| N-004 | **Data volume and growth rate** per major table                              | grilling | N-001      | **yes**           |
| N-005 | **Readiness audit** — what in the codebase blocks reaching N-001             | research | N-002      | no                |
| N-006 | **Which scaling phase-gates apply**, and which are explicitly not yet met    | grilling | N-005      | no                |
| N-007 | **Sizing envelope** — compute, memory, storage, connections, with buffer     | grilling | N-006      | no                |
| N-008 | **Edge requirements** — TLS, routing, body limits, CSP, health and metrics   | grilling | N-002      | no                |
| N-009 | **Failure and degradation modes** — what sheds load first, and how           | grilling | N-007      | no                |
| N-010 | **What this system will deliberately not support**, and why                  | grilling | N-001      | no                |

## Fog of war

TBD — in scope but not yet sharp enough to state as a decision.

## Out of scope

| Ruled out | Why |
| --------- | --- |
| TBD       | TBD |

## Session log

| Date              | Node settled | Outcome | Frontier redrawn |
| ----------------- | ------------ | ------- | ---------------- |
| _no sessions yet_ |              |         |                  |

## Gate to stories

**Nothing has been settled, so no story may be charted against this map yet.** The gate is
N-001 through N-004: until the target size, the load profile, the query shapes and the data
growth are written down, a feature cannot be judged against the size it has to survive.

Run `/scale-planning`.
