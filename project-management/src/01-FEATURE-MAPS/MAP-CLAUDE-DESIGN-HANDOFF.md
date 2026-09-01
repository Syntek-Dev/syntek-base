# MAP-CLAUDE-DESIGN-HANDOFF — the design tier's client-facing half

**Charted**: 22/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Fully charted — frontier and fog cleared 01/09/2026; five slices cut**
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 23

> **Committed here, never shipped.** `copier.yml` `_exclude` empties `project-management/src/**`
> at generation, so this map never reaches a generated project — it charts **syntek-base's own**
> design tier. **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**: that file ships,
> and a shipped file may cite layering-system artefacts only, never a per-project instance. Same
> rule `MAP-UPSTREAM-TRACKING` records against itself.
>
> Resolved in one sitting, 01/09/2026: two research legs, then six grilling rounds settled all
> 23 nodes. Five slices are cut below; `02-story-creation` takes it from here.

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
| Domain                   | The template's own design tier — `DESIGN.md`, PM workflows `04`–`08` and `18`, `src/04`–`08`                                                                                       |
| Skills to load           | `grill-with-docs` (every grilling node) · `frontend` · `scaffold` (a new workflow folder) · `doc-writer` (`DESIGN.md`) · `runbook` (the operator half) · `cicd` (gates)            |
| Standing preferences     | Token-first, DB-canonical · route-don't-restate · **no hosted dependency in the artefact of record** (`08-wireframes/STEPS.md` Step 2) · Figma removed from the repo on 22/08/2026 |
| Umbrella ADRs            | None yet — **authoring one is possible since 31/08/2026** (`.claude/MEMORY.md`, the exclusion is the permission), only via a slice's driving `US###`                               |
| Register entries triaged | 0 closes · 0 blocks · 0 unrelated                                                                                                                                                  |

---

## Register claimed

**`GAPS.md` and `DEFERRED.md` both hold no entries** — each is a shipped skeleton carrying its
format block and nothing else, verified 22/08/2026. The triage is therefore exhaustive by being
empty, and this feature claims nothing. Recorded rather than omitted, because a blank Register
section is otherwise indistinguishable from a triage nobody ran.

---

## What is already measured

Facts established 22/08/2026; re-measured 01/09/2026 — four drifted rows corrected in place, dated. **None of these is a
node, and none of them decides anything.**

| Fact                                                                                                                                                                                                                                                                                                                        | Source                                            |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `/design` is a **research preview**, shipped in v2.1.234–239, on Pro/Max/Team/Enterprise, requires v2.1.233+. It is **not in the commands reference or the bundled-skills page** — only the Week 34 digest                                                                                                                  | `code.claude.com/docs/en/whats-new/2026-w34`      |
| It is **built on artifacts**: **nothing is written into the repo** — it publishes an artboard editor to a private `claude.ai/code/artifact/<id>`; export is manual, **PNG or PDF only** _(corrected 01/09/2026, N-001)_                                                                                                     | Week 34 digest · `docs/en/artifacts`              |
| An artifact page is **one self-contained page under a strict CSP**: relative links do not resolve, external stylesheets are blocked, Google Fonts is the only external source, `.html`/`.htm`/`.md` only, 16 MiB rendered                                                                                                   | `docs/en/artifacts` → _Page constraints_          |
| Artifacts require an **Anthropic-API-backed claude.ai login** and are unavailable under ZDR, HIPAA or CMEK, and on Bedrock / Vertex / Foundry                                                                                                                                                                               | `docs/en/artifacts` → _Availability_              |
| **This repo currently disables them**: `.claude/settings.json` sets `disableArtifact: true`, `disableClaudeAiConnectors: true`, `disableRemoteControl: true`                                                                                                                                                                | `.claude/settings.json:230–232`                   |
| Claude reads an existing **design system** from the project before choosing its own, looking for a `## Design system` block in `CLAUDE.md` or a theme file                                                                                                                                                                  | `docs/en/artifacts` → _Improve the visual design_ |
| `/design-sync` converts a **React** design system and is Anthropic-API-only — inapplicable to Django templates + django-components                                                                                                                                                                                          | `docs/en/commands`                                |
| The design tier's artefacts of record today: `08-WIREFRAMES/` self-contained HTML + `SHARED/wireframe.css`; `06-BRAND-GUIDE/guide-build/brand_guide.py` → `.tex` → `.pdf`; `07-COMPONENTS/component-build/components.py` + `section-*.tex`                                                                                  | those folders' `CONTEXT.md`                       |
| Both generators carry a **`--check` mode** asserting the generated **`.tex` only** matches source — the `.pdf` is unchecked build output; both regenerated at consolidation only, by **`18`** Step 6 _(corrected 01/09/2026)_                                                                                               | `18-consolidate-design-work/STEPS.md` Step 6      |
| The design-time slop gate — `css-slop.sh`, `template-slop.sh`, `render-slop.sh` (renders at 1280 px) — runs at **`18`** (Step 5) over `CONSOLIDATED-IDEAS` + `SHARED` + the Django CSS _(corrected 01/09/2026; a fourth audit, `copy-slop.sh`, exists uncited)_. **`06` and `07` have no script gate** and are gated by eye | `DESIGN.md` → _The design-time gate_              |
| `ERD-DIAGRAMS/` and `DIAGRAMS/` both declare PNG exports from Mermaid source and forbid hand-editing — but **no script, step or workflow in the repository produces those PNGs**, and `mcp-mermaid` is named in `05-user-flow-design` alone                                                                                 | those folders' `CONTEXT.md` · repo-wide grep      |
| PM workflow numbers are a **sequence, not a catalogue** — inserting mid-sequence means renumbering every later folder and sweeping every reference, including `.claude/skills/`                                                                                                                                             | `project-management/workflows/CLAUDE.md`          |
| `project-management/src/**` is `_exclude`d wholesale at generation, with `!` re-includes for the scaffolding — so **artefacts never ship; the workflows and `DESIGN.md` do — a brief under `src/` would not, unless it matches a re-include** _(corrected 01/09/2026)_                                                      | `copier.yml:152`, `155–181`                       |

| `/design` takes its brief **only as inline argument text** (`/design <description>`) — no flag, no file syntax, no automatic pickup documented; it reads the codebase for styling conventions and tokens, and artifacts docs say a `## Design system` block in `CLAUDE.md` takes precedence | N-001, 01/09/2026 · `docs/en/commands` · `docs/en/artifacts` |
| `disableArtifact` is **deprecated** — the live key is `enableArtifact`, and `false` is a **firewall** no other config file can re-enable; whether it blocks `/design` is undocumented, inferred yes | N-001 · `docs/en/settings-reference` |
| **No Claude Code CLI version pin exists in this repo** — nothing in `package.json`, `pnpm-workspace.yaml`, `install.sh` or `.claude/`; CI pins only `claude-code-action@v1` | re-measure, 01/09/2026 |
| **Zero diagram PNGs and zero Mermaid sources exist repo-wide** — `mcp-mermaid` (`npx`, `.mcp.json`) is the only PNG-capable tool: no output-path parameter, nothing scripts or gates it, "(reference only)" in `05-user-flow-design` | N-018, 01/09/2026 |

| The share-back control is **Export → Send to Claude Code**: a **handoff bundle** — design HTML/CSS, per-artboard screenshots, an implementation README and the design-conversation context, referenced by an Anthropic-hosted URL Claude Code reads natively. **Officially undocumented**: format, landing path and constraints are third-party accounts only; the direction is Design→Code, with no documented reverse | Sam (UI, 01/09/2026) · N-007 lookup — no Anthropic docs page exists |

---

## Resolved decisions

| Node  | Decision                                                                                                                                                                                                                                                                                                                                        | Type     | Settled    | Became                                                                   |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ------------------------------------------------------------------------ |
| N-001 | `/design` publishes to a claude.ai artboard editor and **writes nothing into the repo** (export = manual PNG/PDF); a brief reaches it only as inline argument text; research preview, CLI ≥ 2.1.234, Pro/Max/Team/Enterprise, claude.ai login, excluded under ZDR/HIPAA/CMEK and on Bedrock/Vertex/Foundry; `/design-sync` confirmed React-only | research | 01/09/2026 | §What is already measured — rows corrected and added                     |
| N-018 | **No producer exists and none ever ran** — zero PNGs, zero Mermaid sources; `mcp-mermaid` is the only capable tool, ad hoc and unwired; the folders' "re-export on sign-off" instruction is aspirational                                                                                                                                        | research | 01/09/2026 | §What is already measured · sharpens N-019                               |
| N-002 | **Artifacts on in syntek-base; a copier question downstream, defaulting off** — drop the deprecated `disableArtifact` here (the connector/remote-control siblings untouched); a generated project opts in at generation                                                                                                                         | grilling | 01/09/2026 | slice work — `settings.json` + `copier.yml`; ADR candidate via its story |
| N-003 | **Documented degradation** — the designed handoff is the promised client-facing default; a project failing the floor (plan tier, claude.ai login, ZDR/HIPAA/CMEK, Bedrock/Vertex/Foundry) is named a lesser, internal-deliverable tier in `DESIGN.md`                                                                                           | grilling | 01/09/2026 | slice work — `DESIGN.md`                                                 |
| N-005 | **Repo canonical, all five classes** — Claude Design is strictly a client-facing render; only decisions come back into the repo                                                                                                                                                                                                                 | grilling | 01/09/2026 | the spine every slice row builds against; ADR candidate via its story    |
| N-006 | **HTML replaces `.tex`; the PDF is printed from the HTML** — one canonical medium, LaTeX toolchain retired; `--check` asserts the committed `.html`; the PDF is unchecked derived build output                                                                                                                                                  | grilling | 01/09/2026 | slice work — both generators; ADR candidate via its story                |
| N-008 | **Inline at packaging** — the handoff step inlines `SHARED/wireframe.css` into each page it publishes; the repo keeps the linked file as-is                                                                                                                                                                                                     | grilling | 01/09/2026 | slice work — the packaging step N-014 places                             |
| N-016 | **Full gate** — `css-slop.sh` + `template-slop.sh` + `render-slop.sh` run over the brand and components HTML at `18`, same as the wireframes                                                                                                                                                                                                    | grilling | 01/09/2026 | slice work — `18` STEPS.md + the audits                                  |
| N-004 | **A workflow step behind the flag** — the handoff is a numbered step that opens "if artifacts are enabled" (the N-002 copier answer) and routes to the documented degraded path otherwise                                                                                                                                                       | grilling | 01/09/2026 | slice work — the step N-014 places; `DESIGN.md`                          |
| N-007 | **One-way canonically; the bundle is reference input** — Export → Send to Claude Code may land only in a gitignored reference location; canonical sources are edited by hand under normal review                                                                                                                                                | grilling | 01/09/2026 | slice work — `.gitignore` + `DESIGN.md`                                  |
| N-009 | **Index plus a separate brief file** — `DESIGN.md` stays a router under `docs-length.sh`; the brief owns its own file and its own shipping story (N-022)                                                                                                                                                                                        | grilling | 01/09/2026 | slice work — `DESIGN.md` + the brief file                                |
| N-012 | **After `18` only** — one consolidated client-facing set; per-story design work stays internal                                                                                                                                                                                                                                                  | grilling | 01/09/2026 | slice work — `18` STEPS.md                                               |
| N-013 | **One artifact per family** — wireframes / brand guide / components / diagrams each publish as their own artifact; the client receives a short set of links, each well under the 16 MiB ceiling                                                                                                                                                 | grilling | 01/09/2026 | slice work — the packaging step                                          |
| N-015 | **No** — the audits gate repo-canonical artefacts at `18`, before publication; the returning bundle is gitignored reference and never gated                                                                                                                                                                                                     | grilling | 01/09/2026 | forced by N-007; no build work                                           |
| N-017 | **Transcribed decision record** — sign-off decisions and requested changes are written into `18`'s consolidation record, dated, citing the artifact URL                                                                                                                                                                                         | grilling | 01/09/2026 | slice work — `18` STEPS.md + its record template                         |
| N-019 | **PNG-internal / designed-client-facing** — `mcp-mermaid` exports land in the declared folders (`04-DATABASE/ERD-DIAGRAMS/`, `05-USER-FLOW/DIAGRAMS/`) as the internal tier, closing the N-018 gap; the designed diagram is the client render in the handoff batch                                                                              | grilling | 01/09/2026 | slice work — the export wiring N-020 shapes                              |
| N-014 | **`18` gains a step** — packaging, publishing and sign-off transcription append to `18-consolidate-design-work` as the flagged step (N-004); no renumbering, no new scaffold                                                                                                                                                                    | grilling | 01/09/2026 | slice work — `18` STEPS.md + CHECKLIST.md                                |
| N-020 | **Regenerate at `18`** — the consolidation pass re-exports PNGs and re-renders designed diagrams from Mermaid source every time, alongside Step 6's generator regeneration                                                                                                                                                                      | grilling | 01/09/2026 | slice work — the `18` step + folder CLAUDE.md rules                      |
| N-021 | **`18` owns the designed diagram** — built only at packaging, from source, per batch; `04`/`05` own the Mermaid source alone and stay medium-neutral                                                                                                                                                                                            | grilling | 01/09/2026 | slice work — `18` STEPS.md                                               |
| N-010 | **Route** — the brief names `VISUAL-DESIGN.md`, `BRAND-VOICE.md` and the token layer; the repo-resident `/design` session reads them; generated restatement is the recorded fallback if the preview will not follow references                                                                                                                  | grilling | 01/09/2026 | Slice S5                                                                 |
| N-011 | **A generated `## Design system` block** — emitted from the DB-canonical token layer into the `CLAUDE.md` surface (landing point needs care: the root file is generated and gitignored)                                                                                                                                                         | grilling | 01/09/2026 | Slice S5                                                                 |
| N-022 | **Tokenised brief template, ships** — lives on a shipping path, rendered with copier answers, completed at first-time setup steps 7–10                                                                                                                                                                                                          | grilling | 01/09/2026 | Slice S5                                                                 |
| N-023 | **Optional row in both** — `03-PREREQUISITES.md` and `08-CLAUDE-CODE.md`, naming the availability floor and the copier answer                                                                                                                                                                                                                   | grilling | 01/09/2026 | Slice S1                                                                 |

---

## Slices

**Cut 01/09/2026, every frontier node resolved.** Stories and their numbers come from
`02-story-creation`; a slice row is the base, never the story.

| Slice | Story | Title                              | Nodes                                           | Acceptance                                                                                                                                                                                                     | Flags      |
| ----- | ----- | ---------------------------------- | ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| S1    | TBD   | Artifact posture and documentation | N-002, N-003, N-023                             | Deprecated `disableArtifact` dropped here; copier question ships, defaulting off; availability floor + degraded tier documented in `DESIGN.md`; Optional rows in `03-PREREQUISITES.md` and `08-CLAUDE-CODE.md` | N/A        |
| S2    | TBD   | Brand + components go HTML         | N-006, N-016                                    | Both generators emit self-contained HTML; the PDF is derived by headless render; `--check` asserts the `.html`; all three slop audits pass over them at `18`                                                   | Components |
| S3    | TBD   | The handoff step in `18`           | N-004, N-007, N-008, N-012, N-013, N-015, N-017 | `18` gains the flagged step: per-family packaging with `wireframe.css` inlined, publish, sign-off transcribed into the consolidation record; the reference-bundle path gitignored                              | Wireframes |
| S4    | TBD   | Diagram pipeline                   | N-018, N-019, N-020, N-021                      | `mcp-mermaid` PNG exports land in `ERD-DIAGRAMS/` and `DIAGRAMS/`, regenerated at `18` alongside Step 6; designed diagrams rendered per batch at `18`; folder rules updated                                    | N/A        |
| S5    | TBD   | The brief and its surfaces         | N-005, N-009, N-010, N-011, N-022               | `DESIGN.md` routes, staying under `docs-length.sh`; the tokenised brief template ships and completes at first-time setup; a generated `## Design system` block is emitted from the DB-canonical layer          | N/A        |

**The 31/08 manifest expectation held**: the code-shaped flags read `N/A` throughout, and
`Components` (S2) and `Wireframes` (S3) are exactly the two that fire.

---

## Frontier

**Empty — the route is fully charted (01/09/2026).** All 23 nodes sit in Resolved decisions;
the takeable edge is now `02-story-creation`, over the Slices table.

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

---

## Fog of war

**Empty — every item dispositioned 01/09/2026:**

- django-components recognition → mooted by N-011: the generated `## Design system` block has documented precedence over codebase inference
- WYSIWYG artboard editing value → mooted by N-007: the bundle is reference-only; canonical edits are made by hand
- Token cost of one batch → bounded by N-013 (per-family artifacts); observed in practice, tunes nothing structural
- Mirroring client comment threads → mooted by N-017: transcription into `18`'s record is the mechanism
- `/design` withdrawn after the preview → covered by N-003 + N-004: the documented degraded path is the standing fallback
- Mobile screens (390 × 844) → **reasonable call, noted for override**: mobile wireframes join the wireframes family artifact when the mobile surface exists; repo-only otherwise
- Whether a designed ERD is a real client artefact → settled by N-019: it is the client tier, by decision

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

| Date       | Node settled               | Outcome                                                                                                                                                                                                                   | Frontier redrawn                                                              |
| ---------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| 22/08/2026 | none                       | Charted: 23 nodes, 7 blocking, 4 takeable, 0 resolved                                                                                                                                                                     | n/a — first pass                                                              |
| 01/09/2026 | N-001, N-018               | Research legs: `/design` writes nothing into the repo, brief is inline-only; no PNG producer exists. Four measured rows corrected (`18` not `17`; `--check` is `.tex`-only; copier lines; artifact write path)            | yes — N-003 unblocked                                                         |
| 01/09/2026 | N-002, N-003, N-005        | Grilled: artifacts on here + copier opt-in downstream; documented-degradation promise in `DESIGN.md`; **repo canonical for all five classes**                                                                             | yes — 9 nodes takeable; `17`→`18` typo swept from N-012/N-014/N-021 and Notes |
| 01/09/2026 | N-006, N-008, N-016        | Grilled: **HTML canonical for brand + components, PDF derived, LaTeX retired**; full slop gate over them at `18`; `wireframe.css` inlined at packaging                                                                    | yes — N-015 unblocked                                                         |
| 01/09/2026 | N-004, N-007, N-009, N-012 | Grilled: flagged workflow step; bundle = gitignored reference only; `DESIGN.md` routes to a separate brief file; handoff after `18` only                                                                                  | yes — N-014 is the last story-blocker                                         |
| 01/09/2026 | N-013, N-015, N-017, N-019 | Grilled: one artifact per family; audits never read returning output; sign-off transcribed into `18`'s record; **PNGs stay, exported via `mcp-mermaid` into the declared folders; designed diagrams are the client tier** | yes — every remaining node takeable                                           |
| 01/09/2026 | N-014, N-020, N-021        | Grilled: `18` gains the flagged handoff step; both diagram renders regenerate at `18`; `18` owns the designed diagram                                                                                                     | yes — **all seven story-blockers resolved**; 4 nodes left                     |
| 01/09/2026 | N-010, N-011, N-022, N-023 | Grilled: brief routes; generated `## Design system` block; tokenised brief template ships; Optional rows in both guides                                                                                                   | **frontier + fog empty — 23/23; five slices cut**                             |

---

## Gate to stories

- [ ] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — both registers are empty
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — all seven, 01/09/2026
- [x] Every resolved node links to the artefact it became — a slice row or §What is already measured
- [x] **Every slice has a flag manifest** — five slices, 01/09/2026
- [x] No index row in `CONTEXT.md` — this map does not ship

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
