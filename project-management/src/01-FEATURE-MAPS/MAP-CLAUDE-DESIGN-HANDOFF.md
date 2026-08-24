# MAP-CLAUDE-DESIGN-HANDOFF — the design tier's client-facing half

**Charted**: 22/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Charting — every node unresolved by instruction**
**Frontier open**: 23 · **Blocking open**: 7 · **Resolved**: 0

> **Committed here, never shipped.** `copier.yml` `_exclude` empties `project-management/src/**`
> at generation, so this map never reaches a generated project — it charts **syntek-base's own**
> design tier. **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**: that file ships,
> and a shipped file may cite layering-system artefacts only, never a per-project instance. Same
> rule `MAP-UPSTREAM-TRACKING` records against itself.
>
> **Nothing below is settled.** The chart sitting draws the frontier; a later `/wayfinder resolve`
> pass batches the nodes and sends each batch to `/grill-with-docs`.

---

## Destination

The design tier's **client-signoff half** — wireframes, brand guide, component library, ERDs and
user flows — is produced in **Claude Design via `/design`** from a brief this repository authors,
after `18-consolidate-design-work` has reconciled the per-story work into one set. The repository
keeps the **internal half**: the `.tex` generators, `wireframe.css`, the slop audits and the
three-stage artefact folders remain the source of truth a developer builds from.

---

## Notes

| Field                    | Value                                                                                                                                                                              |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | The template's own design tier — `DESIGN.md`, PM workflows `04`–`08` and `17`, `src/04`–`08`                                                                                       |
| Skills to load           | `grill-with-docs` (every grilling node) · `frontend` · `scaffold` (a new workflow folder) · `doc-writer` (`DESIGN.md`) · `runbook` (the operator half) · `cicd` (gates)            |
| Standing preferences     | Token-first, DB-canonical · route-don't-restate · **no hosted dependency in the artefact of record** (`08-wireframes/STEPS.md` Step 2) · Figma removed from the repo on 22/08/2026 |
| Umbrella ADRs            | **None, and none is possible** — this template authors no ADRs (`../15-DECISIONS/CLAUDE.md`)                                                                                       |
| Register entries triaged | 0 closes · 0 blocks · 0 unrelated                                                                                                                                                  |

---

## Register claimed

**`GAPS.md` and `DEFERRED.md` both hold no entries** — each is a shipped skeleton carrying its
format block and nothing else, verified 22/08/2026. The triage is therefore exhaustive by being
empty, and this feature claims nothing. Recorded rather than omitted, because a blank Register
section is otherwise indistinguishable from a triage nobody ran.

---

## What is already measured

Facts established 22/08/2026, so a RESOLVE sitting starts from measurement. **None of these is a
node, and none of them decides anything.**

| Fact                                                                                                                                                                                                                                        | Source                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `/design` is a **research preview**, shipped in v2.1.234–239, on Pro/Max/Team/Enterprise, requires v2.1.233+. It is **not in the commands reference or the bundled-skills page** — only the Week 34 digest                                  | `code.claude.com/docs/en/whats-new/2026-w34`      |
| It is **built on artifacts**: Claude writes an `.html` or `.md` file **into the repo**, then publishes it to a private `claude.ai` URL as a canvas of editable artboards; you pick one and it implements that one                           | Week 34 digest · `docs/en/artifacts`              |
| An artifact page is **one self-contained page under a strict CSP**: relative links do not resolve, external stylesheets are blocked, Google Fonts is the only external source, `.html`/`.htm`/`.md` only, 16 MiB rendered                   | `docs/en/artifacts` → _Page constraints_          |
| Artifacts require an **Anthropic-API-backed claude.ai login** and are unavailable under ZDR, HIPAA or CMEK, and on Bedrock / Vertex / Foundry                                                                                               | `docs/en/artifacts` → _Availability_              |
| **This repo currently disables them**: `.claude/settings.json` sets `disableArtifact: true`, `disableClaudeAiConnectors: true`, `disableRemoteControl: true`                                                                                | `.claude/settings.json:230–232`                   |
| Claude reads an existing **design system** from the project before choosing its own, looking for a `## Design system` block in `CLAUDE.md` or a theme file                                                                                  | `docs/en/artifacts` → _Improve the visual design_ |
| `/design-sync` converts a **React** design system and is Anthropic-API-only — inapplicable to Django templates + django-components                                                                                                          | `docs/en/commands`                                |
| The design tier's artefacts of record today: `08-WIREFRAMES/` self-contained HTML + `SHARED/wireframe.css`; `06-BRAND-GUIDE/guide-build/brand_guide.py` → `.tex` → `.pdf`; `07-COMPONENTS/component-build/components.py` + `section-*.tex`  | those folders' `CONTEXT.md`                       |
| Both generators carry a **`--check` mode** asserting the generated `.tex`/`.pdf` match source; both are regenerated **at consolidation only**, by `17` Step 6                                                                               | `18-consolidate-design-work/STEPS.md` Step 6      |
| The design-time slop gate — `css-slop.sh`, `template-slop.sh`, `render-slop.sh` (renders at 1280 px) — runs at `17` over `CONSOLIDATED-IDEAS` + `SHARED` + the Django CSS. **`06` and `07` have no script gate** and are gated by eye       | `DESIGN.md` → _The design-time gate_              |
| `ERD-DIAGRAMS/` and `DIAGRAMS/` both declare PNG exports from Mermaid source and forbid hand-editing — but **no script, step or workflow in the repository produces those PNGs**, and `mcp-mermaid` is named in `05-user-flow-design` alone | those folders' `CONTEXT.md` · repo-wide grep      |
| PM workflow numbers are a **sequence, not a catalogue** — inserting mid-sequence means renumbering every later folder and sweeping every reference, including `.claude/skills/`                                                             | `project-management/workflows/CLAUDE.md`          |
| `project-management/src/**` is `_exclude`d wholesale at generation, with `!` re-includes for the scaffolding — so **artefacts never ship, but the workflows, `DESIGN.md` and any brief do**                                                 | `copier.yml:47`, `135–150`                        |

---

## Resolved decisions

**None.** Charting settles nothing by design; the table stays empty until the first RESOLVE
sitting.

| Node | Decision | Type | Settled | Became |
| ---- | -------- | ---- | ------- | ------ |
| —    | —        | —    | —       | —      |

---

## Slices

**None yet, and the frontier says why.** Seven nodes are marked blocking a story — N-001, N-004,
N-005, N-009, N-012, N-014 and N-018 — and **N-005 is the one that decides the shape of every
slice**: until canonicity is settled per artefact class, a slice cannot say which side it builds.
Slices are cut here once those seven resolve, never before.

| Slice | Story | Title                   | Flags |
| ----- | ----- | ----------------------- | ----- |
| —     | —     | _(blocked — see N-005)_ | —     |

**What the manifest is expected to look like when it exists, written as an expectation and not as
a manifest.** This map's deliverables are workflow steps, `DESIGN.md`, a brief and the slop
audits, so the code-shaped flags — `DB`, `API`, `Backend`, `GDPR`, `Logging` — should read `N/A`
throughout. `Wireframes` and `Components` are the two that may genuinely fire, because N-005 and
N-008 decide what `08-WIREFRAMES/` and `07-COMPONENTS/` produce and in which medium.

---

## Frontier

Open decisions in dependency order. **Blocked-by is prose links to other nodes.** Unblocked and
takeable today: **N-001, N-002, N-005, N-018**.

### A — Platform and posture

| Node  | Decision                                                                                                                                                                    | Type     | Blocked by   | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | ----------------- |
| N-001 | What `/design` actually does in a live session at the pinned CLI version — what it reads, what file it writes where, whether a repo-authored brief reaches it at all        | research | none         | yes               |
| N-002 | `disableArtifact: true` is the current posture and `/design` is built on artifacts. Turn it on here, on downstream, on in neither, or on in one and not the other           | grilling | none         | no                |
| N-003 | The availability floor a generated project inherits — plan tier, claude.ai login, and the ZDR/HIPAA/CMEK exclusion. What the template promises a project that cannot run it | grilling | N-001        | no                |
| N-004 | Research-preview posture: does `/design` become a step in a numbered workflow (procedure of record), or stay an optional front-end named only in `DESIGN.md`                | grilling | N-001, N-003 | yes               |

### B — Canonicity, the spine

| Node  | Decision                                                                                                                                                                  | Type     | Blocked by | Blocking a story? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ----------------- |
| N-005 | **Which side is canonical, per artefact class** — repo file as source and Claude Design as render, or the reverse, for each of wireframes, brand, components, ERDs, flows | grilling | none       | yes               |
| N-006 | What `--check` asserts once a second visual deliverable exists, and whether the `.pdf` stays the client deliverable or becomes internal                                   | grilling | N-005      | no                |
| N-007 | One-way or round-trip: does a Claude Design edit ever return to the repo, through which file, and under whose review                                                      | grilling | N-005      | no                |
| N-008 | `SHARED/wireframe.css` cannot be `<link>`ed from a published artifact (CSP). Survive as-is, inline at handoff, or be replaced by a design-system brief                    | grilling | N-005      | no                |

### C — The brief

| Node  | Decision                                                                                                                                                        | Type     | Blocked by   | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | ----------------- |
| N-009 | What `DESIGN.md` becomes — a routing index that also briefs, or an index plus a separate brief file. Bears on `docs-length.sh` and the 300-line limit           | grilling | N-005        | yes               |
| N-010 | Whether the brief **restates** `VISUAL-DESIGN.md` Section 3's six axes and `BRAND-VOICE.md`, or routes to them. Route-don't-restate versus what a tool reads    | grilling | N-009        | no                |
| N-011 | Which surface carries the tokens `/design` reads — `DESIGN.md`, `.claude/CLAUDE.md`'s `## Design system` block, or a file generated from the DB-canonical layer | grilling | N-005, N-009 | no                |

### D — Handoff point and batching

| Node  | Decision                                                                                                                                                | Type     | Blocked by   | Blocking a story? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | ----------------- |
| N-012 | **Confirm the handoff sits after `17` only** — the stated assumption — or whether a lighter per-story pass is also needed before a client sees anything | grilling | N-005        | yes               |
| N-013 | What one handoff batch contains: the whole consolidated set, or per family / domain. The 16 MiB single-page ceiling bears on it                         | grilling | N-012        | no                |
| N-014 | Does `17` gain a step, or is a new numbered workflow scaffolded — and if so where, given `24-release` already occupies the tail of a **sequence**       | grilling | N-012, N-013 | yes               |

### E — Gates, audits and sign-off

| Node  | Decision                                                                                                                                    | Type     | Blocked by   | Blocking a story? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | ----------------- |
| N-015 | Whether the three slop audits read Claude Design output, and if so where that output must live for them to reach it                         | grilling | N-005, N-008 | no                |
| N-016 | `06` and `07` are gated by eye because their artefacts are LaTeX. An HTML deliverable is gate-able — should it be gated, and by which audit | grilling | N-005        | no                |
| N-017 | Where a client's sign-off lands in the repo, given comments live on the artifact and are unavailable on a public link                       | grilling | N-003        | no                |

### F — ERDs and user flows

| Node  | Decision                                                                                                                                                               | Type     | Blocked by   | Blocking a story? |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | ----------------- |
| N-018 | **Establish what produces the Mermaid PNGs today** — both folders forbid hand-editing and nothing in the repo exports them. Find the producer or confirm there is none | research | none         | yes               |
| N-019 | Designed diagram versus PNG: replacement, sibling, or PNG-internal / designed-client-facing                                                                            | grilling | N-018, N-005 | no                |
| N-020 | What keeps a designed diagram in step with its Mermaid source, given "never edit the export directly" is the current rule                                              | grilling | N-019        | no                |
| N-021 | Which workflow owns the designed diagram — `04` and `05`, where the source lives, or `17`, where the batch is handed over                                              | grilling | N-019, N-012 | no                |

### G — What ships downstream

| Node  | Decision                                                                                                                                                         | Type     | Blocked by   | Blocking a story? |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | ----------------- |
| N-022 | Which parts of this ship to a generated project. Artefacts never travel; the workflows, `DESIGN.md` and the brief do — so the brief must be generic or tokenised | grilling | N-004        | no                |
| N-023 | Whether `/design` earns a row in `03-PREREQUISITES.md` and `08-CLAUDE-CODE.md`, and in **Optional** or as a requirement — a month after Figma's rows came out    | grilling | N-003, N-004 | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `task` (manual unblocking work)

---

## Fog of war

In scope, not yet sharp enough to state as a decision.

- Whether `/design`'s codebase reading recognises **django-components** as a design system at all —
  every published account of the feature assumes React, and `/design-sync` is React-only outright
- Whether WYSIWYG artboard editing yields anything a developer can act on beyond a picture
- The token cost of one handoff batch, and whether that changes the batching answer in N-013
- Whether client comment threads can be mirrored back into the repo in any durable form
- What the design tier falls back to if `/design` is withdrawn or changes shape after the preview
- Whether mobile screens (390 × 844) go through the same handoff or stay repo-only
- Whether a "designed" ERD is a real client artefact or a diagram nobody outside engineering reads

---

## Out of scope

| Ruled out                                                               | Why                                                                                                                 |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `/design-sync`                                                          | Converts a **React** design system and is Anthropic-API-only; this stack is Django templates + django-components    |
| Re-introducing Figma, or any hosted tool, as the **artefact of record** | Removed from the repository on 22/08/2026; `08-wireframes/STEPS.md` Step 2 bans a second, hosted, undiffable medium |
| Changing the DB-canonical design-token layer                            | `code/docs/DESIGN-TOKENS.md` owns it; this feature consumes tokens, never redefines where they live                 |
| Retiring `brand_guide.py` / `components.py` / `wireframe.css`           | Explicit instruction: the internal generators stay. What they generate **for** is N-006, not whether they exist     |
| The mobile store-listing artefacts                                      | `how-to/src/STORE-LISTING.md` is a different surface with its own limits                                            |
| Claude Design seat licensing and client billing                         | A commercial decision, not a template one                                                                           |

---

## Session log

| Date       | Node settled | Outcome                                               | Frontier redrawn |
| ---------- | ------------ | ----------------------------------------------------- | ---------------- |
| 22/08/2026 | none         | Charted: 23 nodes, 7 blocking, 4 takeable, 0 resolved | n/a — first pass |

---

## Gate to stories

- [ ] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — both registers are empty
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — 7 open
- [ ] Every resolved node links to the artefact it became
- [ ] **Every slice has a flag manifest** — no slices yet; blocked on N-005
- [x] No index row in `CONTEXT.md` — this map does not ship

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
