# MAP-NATIVE-DESIGN-TIER — a script-first design tier with no Claude Design

**Charted**: 09/10/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Charted at**: `1d1290d`
**Status**: Resolving · charted 09/10/2026; six research nodes resolved at CHART Step 7, thirteen
grilling nodes open; RESOLVE opens with batch 1
**Frontier open**: 13 · **Blocking open**: 12 · **Resolved**: 6

> **Committed here, never shipped.** `copier.yml` `_exclude` empties `project-management/src/**`
> at generation, so this map charts **syntek-base's own** design tier and never reaches a
> generated project. **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index** — declined
> on the record under `MAP-REGISTER-INDEXES` N-001, which relocates the index to `MAP-INDEX.md`
> (`US010`); this map takes its row there when `US010` counts the maps (see `GAPS.md`
> 01/09/2026 — the index-row instruction).
>
> **Supersedes `MAP-CLAUDE-DESIGN-HANDOFF` in intent only.** How that map retires — and which of
> its decisions carry over — is **N-007**; it is untouched until N-007 settles.
>
> **Evidence lives in `research/NATIVE-DESIGN-TIER-TOOLING.md`.** This map is the index; a
> claim below without a citation cites that note's numbered claim.

---

## Destination

The design tier (`04`–`08`) has no Claude Design dependency: artefacts are authored as Markdown —
wireframes seeded from it, then edited as HTML/CSS — and rendered to HTML on vanilla CSS by
script-first tooling that runs headless on Linux CI with no optional tool present. Every artefact
is checked on its rendered output, never silently overwritten after a human edit, and approved
only by a human, bound to a version and content hash that any change to it or its inputs
invalidates. _(Confirmed by Sam 09/10/2026, grilling round 1 Q1.)_

---

## Notes

| Field                    | Value                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | PM design tier — `src/04`–`08`, workflows `04`–`08` and `18`, the `00-ASSETS` export scripts, `DESIGN.md`                                                                                                                                                                                                                                                                                                                                       |
| Skills to load           | `grill-with-docs` (every grilling node) · `prototype` (N-012) · `research` · `codebase-design` · `scaffold` (any new folder pair) · `cicd` (CI, dependency group) · `doc-writer` · `runbook`                                                                                                                                                                                                                                                    |
| Standing preferences     | **Sam, 09/10/2026:** Markdown source turned into HTML + vanilla CSS, as simply as possible · **start-then-edit applies to wireframes only** — the generated HTML/CSS becomes the edited artefact of record · the seed `.md` moves to an archive folder once seeded · the Mermaid MCP is retained, not replaced. **Template:** token-first · script-first · no hosted tool as the artefact of record (`workflows/08-wireframes/STEPS.md` Step 2) |
| Umbrella ADRs            | None. A node passing the three-test gate becomes `ADR-US###-*` authored by its slice's story — never by this map                                                                                                                                                                                                                                                                                                                                |
| Evidence                 | `research/NATIVE-DESIGN-TIER-TOOLING.md` (N-001 to N-006)                                                                                                                                                                                                                                                                                                                                                                                       |
| Register entries triaged | 0 closes · 3 blocks · 18 unrelated — 21 open `GAPS.md` entries (19 before this map, 2 appended by it); `DEFERRED.md` has no open rows                                                                                                                                                                                                                                                                                                           |

---

## Register claimed

**This is a claim, not a close.** Nothing here edits `GAPS.md` or `DEFERRED.md` to close an
entry — that is `workflows/22-implementation-documentation/`, against shipped code. **One recorded
exception:** this charting appended two blocker entries (09/10/2026) and closed none, authorised by
Sam in grilling round 1 Q3, under `workflows/01-feature-map/STEPS.md` Step 6 (manual unblocking work
is a `GAPS.md` blocker).

| Register | Entry                                                                                           | Verdict | Retired by / wired to                                                           |
| -------- | ----------------------------------------------------------------------------------------------- | ------- | ------------------------------------------------------------------------------- |
| GAPS.md  | 17/09/2026 — the audits register's headroom is one line smaller than nineteen artefacts believe | blocks  | N-015, **only if** it chooses a new audit row; the headroom itself is `US002`'s |
| GAPS.md  | 09/10/2026 — the Playwright pin needs a Chromium the current NixOS generation no longer roots   | blocks  | N-013 — building S-02 needs a browser at the pin                                |
| GAPS.md  | 09/10/2026 — the human and every agent act as one GitHub identity, and `main` needs no approval | blocks  | N-017 — building S-05 needs the identity or key its mechanism names             |

**Unrelated (18).** Seven constrain this map without blocking it: 18/09 Codex instruction budget ·
16/09 MCP declared twice (no new MCP server is planned) · 31/08 PE gate markup half
(`wireframe.css` is the repo's only tracked CSS) · 02/09 `doc-references` vs the PM tree ·
09/09 `_migrations` advisory invisible (S-03's migration) · 11/09 Bun tracers lack Bun (no Node
renderer is planned) · 01/09 index-row instruction (declined above). **01/09 story `Status`
vocabulary is unrelated while N-018 keeps approval state computed** — re-triage if N-018 stores
one. The other ten are unrelated outright: the three "still open" bullets of the 16/08 sitting ·
31/08 htmx major 2 · 01/09 RUSTSEC invisible · 01/09 no mail backend · 09/09 security block
twice · 11/09 `install-frontend.sh` · 17/09 maps refuted by their tables · 17/09 backlog register
ungated.

---

## What is already measured

Facts, not decisions — each is a numbered claim in the research note. Re-measure before leaning on
one at RESOLVE (`workflows/01-feature-map/STEPS.md` Step 8.1).

| Fact                                                                                                                                                                     | Note claim         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------ |
| `04`–`08` hold templates only; 14 of 15 stage templates are `.md`, the exception `WF-IDEA-US000-TEMPLATE.html`                                                           | N-001.1            |
| Nothing produces a diagram image, though `04`/`05` and the consolidated sign-off boxes promise ERD and flow PNGs                                                         | N-001.2            |
| `brand_guide.py`/`components.py`: literals → `.tex` → xelatex; `--check` covers `.tex` only; no wrapper, no CI, raw `python3`                                            | N-001.3            |
| Three hand-synced token copies, already drifted (radius 14 vs 16, a stray 28 px step, a border mismatch); the DB token layer is declared, not wired                      | N-001.4–5          |
| `render-slop` covers 08 only at 1280 px and exits 0 with no browser; `css-tokens` is web-only; `06`/`07` are gated by eye                                                | N-001.6            |
| Three export scripts hard-code Chrome paths absent on NixOS; `export-design-docs.sh` expects six HTML files nothing produces                                             | N-001.7            |
| Claude Design named in workflow `06`; `disableArtifact: true` still set; the predecessor's slices never cut                                                              | N-001.8            |
| Sign-off is free text — `**Status:**`, `**Consolidated by**`, and "Record sign-off as a comment in the document or via PR review."                                       | N-001.9            |
| Playwright pinned 1.61.0 (Chromium rev 1228); the current NixOS generation roots only rev 1243                                                                           | N-001.10           |
| `mcp-mermaid` fails on this host; enabling its install scripts would not fix it on NixOS                                                                                 | N-003.1–2          |
| Python Playwright renders `mermaid.min.js` in-page with no Node (11.17.2 and 12.1.0); 12.x bundles EPL-2.0 elkjs; **committing the bundle breaks `copier copy`**         | N-003.3–5          |
| GitHub renders Mermaid blocks in Markdown and PRs                                                                                                                        | N-003.8            |
| One GitHub identity for the human and every agent; 0 required approvals; admin bypass always; `gh` holds two further accounts                                            | N-005.1–3, N-005.9 |
| VectorCraft has a verified CLI and MCP server but is v0.7, created 30/09/2026, its top committer an account named `claude` (817 of 1,719); ArtCraft's studio has neither | N-002              |

---

## Resolved decisions

| Node  | Decision                                                                                                                                                                                                                      | Type     | Settled    | Became                                         |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ---------------------------------------------- |
| N-001 | The design tier's current state, measured — templates only, no image producer, `.tex` generators, three drifted token copies, unwired token layer, Claude Design residue, free-text sign-off                                  | research | 09/10/2026 | `research/NATIVE-DESIGN-TIER-TOOLING.md` N-001 |
| N-002 | The ArtCraft family verified twice: the studio has no CLI or MCP and a restrictive code licence; VectorCraft's CLI and MCP exist but the repo was created 30/09/2026; PhotoCraft (raster) and DesignCraft (layout) do not fit | research | 09/10/2026 | `research/NATIVE-DESIGN-TIER-TOOLING.md` N-002 |
| N-003 | Renderer and Mermaid facts: in-page Mermaid via Python Playwright works with no Node; the bundle cannot be committed; `mcp-mermaid` is broken here; specialist renderer licences and runtimes                                 | research | 09/10/2026 | `research/NATIVE-DESIGN-TIER-TOOLING.md` N-003 |
| N-004 | Sibling patterns: exit 0/1/2 with `--self-test`, a never-overwrite guard, author-change capture, save-beside, hermetic renders; neither hashes an approval                                                                    | research | 09/10/2026 | `research/NATIVE-DESIGN-TIER-TOOLING.md` N-004 |
| N-005 | Any approval resting on a GitHub account can be produced by an agent on this host; a key needing a touch is the only measured human-presence signal                                                                           | research | 09/10/2026 | `research/NATIVE-DESIGN-TIER-TOOLING.md` N-005 |
| N-006 | Agent-host discovery facts — an **input** to `MAP-INSTRUCTION-DELIVERY` N-001, which owns them                                                                                                                                | research | 09/10/2026 | `research/NATIVE-DESIGN-TIER-TOOLING.md` N-006 |

---

## Slices

**Provisional, written at CHART.** Each slice is cuttable only when every node it names is `✅`;
`02-story-creation` writes the story and back-fills `Story`. Every slice ships its own docs, its
own `copier.yml` allowlist entries and `shipped-artefacts.sh` rows in the same change — no
trailing docs or packaging slice.

| Slice | Story | Title                                                           | Nodes                                                                     | Acceptance                                                                                                                                                                                                                                                                              | Flags                                                               |
| ----- | ----- | --------------------------------------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| S-01  | —     | Claude Design retired; the design-tier docs tell the truth      | N-007 ⛔                                                                  | `MAP-CLAUDE-DESIGN-HANDOFF` retired as N-007 decides, every live inbound citation still resolving and the frozen ones left as pointers; no Claude Design reference left in workflow `06`; the stale references in note claim N-001.13 corrected                                         | QA: docs gates                                                      |
| S-02  | —     | Diagrams build headless from Markdown                           | N-008 ⛔ · N-009 ⛔ · N-011 ⛔ · N-013 ⛔ · N-015 ⛔ · N-016 ⛔ · N-019 ○ | `04`/`05` Markdown renders headless on Linux CI with no optional tool present; a run that could not render says so and never reports clean; a human edit is never silently overwritten; where renders live, the command's shape and its CI placement follow N-011, N-013 and N-015      | QA: unit, integration                                               |
| S-03  | —     | One token source; brand guide and component sheet as HTML + PDF | N-010 ⛔ · N-014 ⛔ · N-016 ⛔                                            | The token source N-010 names feeds every design output and the three hand-synced copies are gone; the brand guide and component sheet render as HTML on vanilla CSS; their checks follow N-016; workflow `18` Step 6, the export scripts and existing projects' brand data follow N-014 | Brand: the token source moves · QA: unit, integration, manual (PDF) |
| S-04  | —     | Wireframes seeded from Markdown, then edited as HTML            | N-012 ⛔ · N-016 ⛔                                                       | A screen is seeded once from Markdown, its `.md` archived, and edited thereafter as HTML/CSS; a human edit to a screen is never silently overwritten; screens are checked on their rendered output as N-016 sets; the archive's place and the consolidation path at `18` follow N-012   | QA: unit, integration, manual                                       |
| S-05  | —     | Only a human can approve a design                               | N-017 ⛔ · N-018 ⛔                                                       | Only a human can approve; an approval binds a version and a content hash, and any change to the artefact or its inputs invalidates it; the mechanism, the record, the checkpoints, the enforcement and the rule's home follow N-017 and N-018                                           | Security: signing, identity, bypass · QA: unit, integration, manual |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking.

**Build order (provisional; admission belongs to `03-sprint-planning`):** S-01 alongside S-02 →
S-03 → S-04 → S-05. Roughly 2 + 8 + 8 + 5 + 5 SP. `CUT-PLAN.md` gains this map's section in the
change that cuts its first slice.

---

## Frontier

Open decisions in dependency order. All are `grilling`; N-012 is probed with `/prototype` first.
The parenthesised _leaning_ is what charting put to Sam — **unsettled**, a starting point for the
grilling round, never an answer.

**Proposed batches:** **1** scope — N-007, N-008, N-009, N-010 · **2** pipeline — N-011, N-013,
N-015, N-016 · **3** artefacts — N-012, N-014 · **4** approval — N-017, N-018, N-019.

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | Type     | Blocked by                                                                                                | Blocking a story?  |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | --------------------------------------------------------------------------------------------------------- | ------------------ |
| N-007 | **Retire `MAP-CLAUDE-DESIGN-HANDOFF`:** supersede (needs a Status value legal under `ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md`) or delete (needs a pointer for frozen citations); which of its decisions carry (its N-005, N-006, N-016) and which are void; record two reversals — its Out row "the internal generators stay" and `08-wireframes/STEPS.md` Step 2's copy-the-template start; repair the inbound citations (`CUT-PLAN.md:86`, `:125`, `:393-406`; `ADR-US010-…:39`; `MAP-REGISTER-INDEXES.md:377`; `MAP-PROGRESSIVE-ENHANCEMENT.md:650`; `CHANGELOG.md:212`), leaving the frozen ones as pointers never rewritten (`CHANGELOG.md:88`, `VERSION-HISTORY.md:20`, `00-ASSETS/WALK-TESTS/WALK-N010-COLD-31-08-2026-TRANSCRIPT.jsonl:45`); the deprecated `disableArtifact` key | grilling | none                                                                                                      | yes — S-01         |
| N-008 | **Renderer set and abstraction:** native Python + Playwright as the core; the Mermaid MCP kept as an in-session tool outside the pipeline; `mmdc`, specialist renderers and the ArtCraft family; per-type functions vs a backend abstraction; the four modes evaluated; a VectorCraft re-evaluation trigger (_leaning: core only, no modes and no abstraction in v1_)                                                                                                                                                                                                                                                                                                                                                                                                                                  | grilling | none                                                                                                      | yes — S-02         |
| N-009 | **Source contract:** extend the existing stage templates vs new source files; metadata derived from the path vs keys, against `MAP-REGISTER-INDEXES` N-004's settled frontmatter schema (an input, not a blocker); one ERD source — the tables or the `erDiagram`; SVG assets as source                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | grilling | none                                                                                                      | yes — S-02         |
| N-010 | **Single token source:** the design tier reads the CSS token file `code/docs/DESIGN-TOKENS.md` specifies (not yet built; `:16-17`) vs a design-tier source of its own; who writes it before the `design_tokens` app exists; retiring the three copies; `MAP-NATIVE-MOBILE-SURFACE`'s emitters (_leaning: one CSS token file, read by the design tier_)                                                                                                                                                                                                                                                                                                                                                                                                                                                 | grilling | none                                                                                                      | yes — S-03         |
| N-011 | **Commit, review and edit surfaces:** `04`–`07` commit Markdown only with outputs git-ignored and kept as CI artifacts, retiring the committed-PNG contracts — or commit renders; wireframe HTML/CSS committed and edited; which file each actor may edit; conflict classes (a source edit is safe; an output edit is refused and ported or discarded; seeding onto an existing screen is refused); explicit commands vs a watcher; Prettier stability                                                                                                                                                                                                                                                                                                                                                 | grilling | N-009                                                                                                     | yes — S-02         |
| N-012 | **Wireframe seed and consolidation:** the seed's Markdown vocabulary (plain Markdown + raw HTML on the `wf-*` classes; probe with `/prototype`); the archive's location — one `08-WIREFRAMES/` archive or one per stage; the seed-provenance stamp; how `18` produces consolidated screens when stage 1 is frozen HTML (copy-then-edit vs a fresh seed)                                                                                                                                                                                                                                                                                                                                                                                                                                                | grilling | N-009, N-011                                                                                              | yes — S-04         |
| N-013 | **Diagram rendering:** Mermaid 11.x vs 12.x (EPL-2.0 elkjs; default-layout drift); the bundle fetched by pinned URL and sha256 into a git-ignored cache; behaviour when Chromium is missing (exit 2, "could not look") (_leaning: 11.x_)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | grilling | N-008, N-011; the 09/10/2026 Playwright `GAPS.md` entry blocks building                                   | yes — S-02         |
| N-014 | **Brand guide, component sheet and exports:** keep the two generators emitting HTML vs fold them into the CLI; one PDF engine; replace `export-design-docs.sh`, `export-wireframes.sh` and `export-pm-files.sh`'s `04`/`05` types; workflow `18` Step 6; the client deliverable's shape; migrating brand data held in `brand_guide.py`; the breaking version against `MAP-BUN-TOPOLOGY` S-04's claim on v8.0.0                                                                                                                                                                                                                                                                                                                                                                                         | grilling | N-007, N-010                                                                                              | yes — S-03         |
| N-015 | **CLI shape, home, dependencies and CI:** verbs (_leaning: `build`, `check`, `seed`; never an approve verb_); the wrapper's place under `code/src/scripts/`; a declared `design` dependency group (`--only-group`); CI split into a required, browser-free approval leg and an advisory render leg; whether a new audit row is needed (`US002`)                                                                                                                                                                                                                                                                                                                                                                                                                                                        | grilling | N-008, N-011; the 17/09/2026 audits-headroom `GAPS.md` entry blocks building if a new audit row is chosen | yes — S-02         |
| N-016 | **Validation per artefact family:** what fails vs warns; reuse vs widen existing gates (`css-tokens` is web-only; `MAP-RULE-OWNERSHIP`'s recorded false positives on `--path project-management`); contrast on token pairs; overflow at viewports; accessibility warn-tier; screenshots read before review; never gated by an AI verdict (`MAP-NAVIGATION` N-009)                                                                                                                                                                                                                                                                                                                                                                                                                                      | grilling | N-010, N-013                                                                                              | yes — S-02 to S-04 |
| N-017 | **Approval mechanism:** a security-key signature that needs a touch vs a separate agent identity with a human-only CODEOWNER vs procedural only (labelled unenforced); the template default vs per-project configuration; any provisioning is a `GAPS.md` blocker (_leaning: the security key as default_)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | grilling | none — the 09/10/2026 identity `GAPS.md` entry blocks building                                            | yes — S-05         |
| N-018 | **Approval record and checkpoints:** the version binding (frontmatter `Version` under the `MAP-REGISTER-INDEXES` schema, a git SHA or a tag); the hash's inputs — the artefact and every file its render reads; state computed vs stored; checkpoints (consolidation at `18` and the consolidated sign-off vs every stage); the rule for when a PR fails; the doctrine's owning guide, outside `.claude/CLAUDE.md`'s budget                                                                                                                                                                                                                                                                                                                                                                            | grilling | N-011, N-017                                                                                              | yes — S-05         |
| N-019 | **Agent surface:** the CLI reached through the workflows only vs a project skill as well; no design MCP server; discovery stays `MAP-INSTRUCTION-DELIVERY` N-001's                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | grilling | N-015                                                                                                     | no                 |

**Takeable now:** N-007, N-008, N-009, N-010, N-017.

---

## Fog of war

- Checking an ERD against the Django models once code exists — needs `django-extensions`, not a
  dependency today
- A gallery of the real django-components (a code-layer surface)
- Wireframes for the mobile surface in a project generated with `INCLUDE_MOBILE`
- Dark-mode and theme variants of wireframes and sheets
- Checking prototype link targets; checking logos use palette colours only
- Theming Mermaid diagrams from the token source
- VectorCraft inspecting SVG assets over MCP — at N-008's re-evaluation trigger

---

## Out of scope

_Confirmed by Sam 09/10/2026, grilling round 1 Q2._

| Ruled out                                                       | Why                                                                                      |
| --------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Claude Design, `/design` and artifacts anywhere in the pipeline | The brief: this feature replaces the dependency                                          |
| tldraw                                                          | Proprietary licence; production use needs a key                                          |
| Kroki's public service and mermaid.ink links                    | Both send diagram source off the host                                                    |
| perceptualdiff                                                  | GPL-2.0, and removed from nixpkgs over its FreeImage dependency (note N-003.11)          |
| Redefining the DB-canonical token layer                         | `code/docs/DESIGN-TOKENS.md` owns it; this map decides only how the design tier reads it |
| Making `AGENTS.md` host-neutral; agent discovery                | `MAP-INSTRUCTION-DELIVERY` N-001 and its S-02                                            |
| Repairing how the Mermaid MCP launches                          | `MAP-UPSTREAM-TRACKING` N-019 (pins) and `MAP-BUN-TOPOLOGY` S-02 (runtime)               |
| Antigravity workflows                                           | They stop working on 19/10/2026; skills replace them                                     |
| Pixel-identical baselines across operating systems              | Playwright's own docs say renders vary by OS and hardware                                |

---

## Session log

| Date       | Node settled  | Outcome                                                                                                                                                                                                                                                                                                                                      | Frontier redrawn |
| ---------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 09/10/2026 | N-001 – N-006 | Charted: six research legs, four adversarial verification legs, two critique passes; 19 nodes, 6 research resolved, 13 grilling open, 12 blocking, 5 takeable. Destination and Out confirmed (round 1 Q1, Q2); two `GAPS.md` entries appended; an independent two-lens review corrected citations, slice acceptance and the register wording | n/a — first pass |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed — 09/10/2026, round 1 Q1 and Q2
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 0 closes · 3 blocks · 18 unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here** — except the
      two blocker entries appended on Sam's authority (round 1 Q3; see Register claimed), none closed
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — 12 open
- [x] Every resolved node links to the artefact it became
- [x] **Every slice has a flag manifest**
- [x] Index row — declined on the record above; the row lands in `MAP-INDEX.md` when `US010` ships

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked** — per
slice, as its own nodes reach `✅`.
