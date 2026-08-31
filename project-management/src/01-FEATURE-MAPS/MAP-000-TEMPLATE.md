# MAP-[FEATURE] — [Title]

**Charted**: DD/MM/YYYY · **Charted by**: [name] · **Workflow**: `01-feature-map`
**Status**: Charting / Resolving / Blockers clear — stories may start / Complete
**Frontier open**: [n] · **Blocking open**: [n]

> Copy to `MAP-<FEATURE>.md`. This is a **low-resolution index**, not a storage vault — every
> resolved node links to the artefact it became. Add a row to `CONTEXT.md` → Map index.

---

## Destination

[One or two lines: what "done" looks like for this feature.]

---

## Notes

| Field                    | Value                                                       |
| ------------------------ | ----------------------------------------------------------- |
| Domain                   | [PLACEHOLDER]                                               |
| Skills to load           | [PLACEHOLDER]                                               |
| Standing preferences     | [PLACEHOLDER — decisions already made that bound this work] |
| Umbrella ADRs            | [PLACEHOLDER]                                               |
| Register entries triaged | [n] closes · [n] blocks · [n] unrelated                     |

---

## Register claimed

Open `GAPS.md` and `DEFERRED.md` entries this feature touches, from the Step 2 triage. **Every
open entry gets a verdict** — the unrelated count in Notes is what makes the triage provably
exhaustive.

**This is a claim, not a close.** Nothing here edits `GAPS.md` or `DEFERRED.md`. The entry is
marked `✅ CLOSED` (or the `DEFERRED.md` row removed) by
`workflows/22-implementation-documentation/`, against shipped code.

| Register    | Entry                                   | Verdict | Retired by                     |
| ----------- | --------------------------------------- | ------- | ------------------------------ |
| GAPS.md     | [EXAMPLE] DD/MM/YYYY — {title}          | closes  | [EXAMPLE] `US###` / node N-00# |
| DEFERRED.md | [EXAMPLE] {item} → target `US###`       | closes  | [PLACEHOLDER]                  |
| GAPS.md     | [EXAMPLE] DD/MM/YYYY — {blocking title} | blocks  | node N-00# (frontier)          |

**closes** — this feature retires it; it belongs in the destination, not a footnote.
**blocks** — it stands in the way, so it is a frontier node below, never an assumption.

---

## Resolved decisions

Each links to the artefact it became. **An answer that lives only here has not been graduated.**

| Node  | Decision                   | Type     | Settled    | Became                         |
| ----- | -------------------------- | -------- | ---------- | ------------------------------ |
| N-001 | [EXAMPLE] Tenancy boundary | grilling | DD/MM/YYYY | [EXAMPLE] `ADR-0##-TENANCY.md` |
| N-002 | [PLACEHOLDER]              |          |            |                                |

---

## Slices

The buildable slices this feature cuts into — **the base the stories are written from**. A slice
is a manifest, not a design: it names which gates must run and the first-pass values they start
from. The gate owns the design, may add to a value, and the story is updated to match when the
gate closes.

**Flags are written inline and `N/A` is omitted**, so a typical slice stays one line and this
section stays an index. The full 13-flag roster and each flag's gate:
`../02-STORIES/US000-TEMPLATE.md`.

| Slice | Story   | Title         | Nodes                        | Acceptance                                                                       | Flags                                                                     |
| ----- | ------- | ------------- | ---------------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| S-01  | `US###` | [EXAMPLE] {…} | [EXAMPLE] N-003 ✅ · N-005 ○ | [EXAMPLE] every `ModelA` row carries a scope column and the policy that reads it | [EXAMPLE] DB: `ModelA` · API: `POST /model-a` · GDPR: yes · QA: unit, E2E |
| S-02  | —       | [PLACEHOLDER] | [PLACEHOLDER]                | [PLACEHOLDER]                                                                    | [PLACEHOLDER]                                                             |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. A slice is cuttable only
when every node it names is `✅`, and **no open node may belong to no slice** — an unlisted node
is work with no route to a story.

**Acceptance is what must be TRUE; Flags is which gates RUN.** They never restate each other, and
neither is an outline — the steps that produce the acceptance are the
`project-management/workflows/**` chain the story runs.

**The `Story` column is back-filled by `02-story-creation`**, which allocates the next free
`US###` when it writes the story. A slice with no story yet reads `—`; wayfinder never reserves
a number, because a slice that is later merged or dropped would burn it and `US###` gaps are
permanent.

**A slice is not a story.** Nothing here is written into `../02-STORIES/` from this map — the
row is the input to `02-story-creation`, which cuts the story from it.

---

## Frontier

Open decisions in dependency order. **Blocked-by is prose links to other nodes**, so the takeable
edge is visible at a glance. At least one node must be unblocked, or the wiring is wrong.

| Node  | Decision      | Type     | Blocked by | Blocking a story? |
| ----- | ------------- | -------- | ---------- | ----------------- |
| N-003 | [PLACEHOLDER] | grilling | none       | yes               |
| N-004 | [PLACEHOLDER] | research | N-003      | no                |
| N-005 | [PLACEHOLDER] | tracer   | none       | no                |
| N-006 | [PLACEHOLDER] | build    | N-003      | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity — and a mode:
any node may be probed with `/prototype` before it resolves) · `grilling` (one
`/grill-with-docs` surface) · `build` (the work a slice's story carries — named here, never done
here; it resolves when its deliverable and acceptance reach its slice row). **Manual unblocking
work is not a node** — provisioning, running a script or seeding data is a `GAPS.md` blocker.

**Blocking a story?** — `yes` means no story may be written until it is settled. Only these gate
`02-story-creation`; the rest may stay open. **A `build` node is always `no`** — it cannot block a
story, because it _is_ the story's work.

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
- [ ] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [ ] Every claimed entry names what will retire it; **neither register file edited here**
- [ ] Every knowable decision is a node or in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] **Every slice has a flag manifest** — every gate it needs, `N/A` omitted
- [ ] Index row in `CONTEXT.md` current

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
