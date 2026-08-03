# MAP-[FEATURE] — [Title]

**Charted**: DD/MM/YYYY · **Charted by**: [name] · **Workflow**: `01-feature`
**Status**: Charting / Resolving / Blockers clear — stories may start / Complete
**Frontier open**: [n] · **Blocking open**: [n]

> Copy to `MAP-<FEATURE>.md`. This is a **low-resolution index**, not a storage vault — every
> resolved node links to the artefact it became. Add a row to `CONTEXT.md` → Map index.

---

## Destination

[One or two lines: what "done" looks like for this feature.]

---

## Notes

| Field                | Value                                                       |
| -------------------- | ----------------------------------------------------------- |
| Domain               | [PLACEHOLDER]                                               |
| Skills to load       | [PLACEHOLDER]                                               |
| Standing preferences | [PLACEHOLDER — decisions already made that bound this work] |
| Umbrella ADRs        | [PLACEHOLDER]                                               |

---

## Resolved decisions

Each links to the artefact it became. **An answer that lives only here has not been graduated.**

| Node  | Decision                   | Type     | Settled    | Became                         |
| ----- | -------------------------- | -------- | ---------- | ------------------------------ |
| N-001 | [EXAMPLE] Tenancy boundary | grilling | DD/MM/YYYY | [EXAMPLE] `ADR-0##-TENANCY.md` |
| N-002 | [PLACEHOLDER]              |          |            |                                |

---

## Frontier

Open decisions in dependency order. **Blocked-by is prose links to other nodes**, so the takeable
edge is visible at a glance. At least one node must be unblocked, or the wiring is wrong.

| Node  | Decision      | Type     | Blocked by | Blocking a story? |
| ----- | ------------- | -------- | ---------- | ----------------- |
| N-003 | [PLACEHOLDER] | grilling | none       | yes               |
| N-004 | [PLACEHOLDER] | research | N-003      | no                |
| N-005 | [PLACEHOLDER] | tracer   | none       | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `task` (manual unblocking work)

**Blocking a story?** — `yes` means no story may be written until it is settled. Only these gate
`02-story-creation`; the rest may stay open.

---

## Fog of war

In scope, but not yet sharp enough to state as a decision. **Leaving something here is honest;
forcing it into a node is not.** Promote to the frontier when an outcome sharpens it.

- [PLACEHOLDER]

---

## Out of scope

Consciously ruled out, with the reason — so it is not silently reopened later.

| Ruled out     | Why           |
| ------------- | ------------- |
| [PLACEHOLDER] | [PLACEHOLDER] |

---

## Session log

One row per RESOLVE session, so the map's history is legible without git archaeology.

| Date       | Node settled | Outcome       | Frontier redrawn |
| ---------- | ------------ | ------------- | ---------------- |
| DD/MM/YYYY | N-00#        | [PLACEHOLDER] | [ ]              |

---

## Gate to stories

- [ ] Destination and out-of-scope bounds confirmed
- [ ] Every knowable decision is a node or in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] Index row in `CONTEXT.md` current

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
