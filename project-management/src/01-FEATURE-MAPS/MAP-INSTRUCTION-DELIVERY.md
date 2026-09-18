# MAP-INSTRUCTION-DELIVERY — One statement, four hosts, and a gate behind each copy

**Charted**: 18/09/2026 · **Charted by**: Claude (Opus 5) · **Workflow**: `01-feature-map`
**Status**: Charting
**Frontier open**: 12 · **Blocking open**: 8

> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — this charts **syntek-base's
> own** instruction topology; a generated project inherits the decided arrangement, not the
> argument. The name matters: a `MAP-TEMPLATE-*.md` would match the `!*TEMPLATE*` negation and
> ship.
> **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**, on the interim decline
> `MAP-RULE-OWNERSHIP` N-010 settled on 28/08/2026 — the index relocates to a seeded
> `MAP-INDEX.md` (`MAP-REGISTER-INDEXES` N-001, slice S-01, unbuilt) rather than gaining an
> exception. `GAPS.md 01/09/2026` records that the instruction to add a row is itself a shipped
> falsehood in three files, this map's own skill among them.

---

## Destination

**Every host-facing instruction and every MCP declaration this template ships is stated once in a
neutral layer and reaches each access route through a thin per-route adapter, gated at generation
— with each route's budget declared where a machine can read it, and a gate that fails when an
adapter drifts from its source or a route's budget is exceeded.**

The insight the epic rests on is `ai-ecosystem-business-plan.tex`'s own: `access route / client`
is a first-class abstraction, and provider adapters _"translate neutral requests into provider
protocols… They advertise supported features and limits; unsupported semantics must be surfaced
rather than silently dropped."_ `CLAUDE.md`, `AGENTS.md`, `GEMINI.md` and
`.github/copilot-instructions.md` **are that adapter layer for instruction delivery**. They are
allowed to differ per host — that is their job — and the plan's ban on depending on _"a
Claude-specific instruction filename"_ binds the **public contract**, not the adapter.

---

## Notes

| Field                    | Value                                                                                                                                                                           |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Instruction topology, host adapters, MCP configuration, generation gating                                                                                                       |
| Skills to load           | `scaffold` (routing surfaces, pairs, `GAPS.md`) · `doc-writer` (guide substance) · `cicd` (audits, CI, Copier) · `grill-with-docs`                                              |
| Standing preferences     | Route adapters may differ per host; the neutral layer may not. Ships gated, never dead. No rename of `CLAUDE.md`/`CONTEXT.md`.                                                  |
| Umbrella ADRs            | None yet — N-002, N-004 and N-007 are the three likeliest to earn one                                                                                                           |
| Register entries triaged | 2 closes · 0 blocks · 14 unrelated (16 total)                                                                                                                                   |
| External evidence read   | Anthropic memory + sub-agents docs · OpenAI Codex AGENTS.md + config reference · Gemini CLI `gemini-md.md` · GitHub Copilot custom-instructions support matrix — all 18/09/2026 |

**Re-measure before leaning on any of it.** Every external claim above was read on 18/09/2026 and
host behaviour moves; a drifted citation still reads plausibly, which is why a re-read never
catches one. N-001 exists to make that re-measurement a recorded artefact rather than a habit.

---

## Register claimed

**This is a claim, not a close.** Nothing here edits `GAPS.md`. The entries are marked
`✅ CLOSED` by `workflows/22-implementation-documentation/`, against shipped code.

| Register | Entry                                                                                               | Verdict | Retired by |
| -------- | --------------------------------------------------------------------------------------------------- | ------- | ---------- |
| GAPS.md  | 16/09/2026 — MCP servers are declared twice, and the shared `.ai/` entry point cannot yet hold them | closes  | S-04       |
| GAPS.md  | 18/09/2026 — Codex's instruction budget is already exceeded in 65 of 355 directories                | closes  | S-02       |

The 16/09 entry names this map's destination in its own words — _"a single declaration under
`.ai/` that every provider and model reads, which would delete the parity rule in
`.ai/INSTRUCTIONS.md` rather than refine it"_ — and defers it with a stated trigger: _"Revisit
when a third host joins."_ **That trigger has fired.** The destination takes Gemini CLI and
Copilot CLI as routes three and four, so two servers and one audit is no longer the cheaper state.

The 18/09 entry was written by this charting session from measurement, not inference. It carries
an immediate mitigation that decides nothing and must not be mistaken for the fix.

**The other 14 open entries are unrelated.** Three share this feature's _shape_ — N hand-maintained
copies with no gate behind them — without sharing its subject: `09/09/2026` (the security-settings
block ships twice and has drifted), `17/09/2026` (the backlog register is five copies) and
`01/09/2026` (the `CONTEXT.md` index-row instruction survives in three shipped files). They are
precedent for how this repository has answered the defect class before, not work this feature does.

---

## Resolved decisions

_None — charting settles nothing. The five destination bounds were confirmed on 18/09/2026 and are
recorded in Destination and Out of scope, not here._

| Node | Decision | Type | Settled | Became |
| ---- | -------- | ---- | ------- | ------ |
| —    | —        | —    | —       | —      |

---

## Slices

| Slice | Story   | Title                              | Nodes                                           | Acceptance                                                                                                                                                                      | Flags                                                                                                     |
| ----- | ------- | ---------------------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| S-01  | `US###` | The route registry and its budget  | N-001 ○ · N-008 ○                               | Every access route has a record naming its discovery rule, its instruction budget and the evidence date; the budget is readable by a machine, not only a person                 | QA: unit — registry parses, every route has a budget                                                      |
| S-02  | `US###` | The neutral layer and its adapters | N-002 ○ · N-003 ○ · N-004 ○ · N-011 ○ · N-012 ○ | Doctrine is stated once in the neutral layer; each route's adapter carries only what that host needs; no directory's Codex chain exceeds the configured limit                   | QA: unit — no adapter restates its source                                                                 |
| S-03  | `US###` | Route gating at generation         | N-005 ○                                         | A generated project ships an adapter for each route it opted into and none for the rest; an absent route leaves no file for a gate to exempt                                    | QA: unit — generate with each route on and off                                                            |
| S-04  | `US###` | One MCP declaration, rendered      | N-006 ○ · N-007 ○ · N-009 ○                     | `.mcp.json` and `.codex/config.toml` are rendered from one neutral declaration; the server set, each `command` and each `args` order match by construction rather than by audit | Security: `${VAR}` interpolation must not be rendered into a committed file · QA: unit, render round-trip |
| S-05  | `US###` | The drift and budget gate          | N-010 ○                                         | A gate fails when an adapter diverges from its neutral source, and when any route's chain exceeds its declared budget; neither condition can pass silently                      | QA: unit, `--self-test` over a generated pair                                                             |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. Every one of the 12 nodes
belongs to exactly one slice, and no slice is cuttable — every node is open.

**S-04 retires the 16/09 gap only if N-007 chooses the generator.** If it re-affirms parity, the
slice becomes a narrower one and the gap stays open with a new trigger; that is a real outcome, not
a failure, and the map should say so rather than assume the generator wins.

---

## Frontier

| Node  | Decision                                                                                                  | Type     | Blocked by    | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------------- | -------- | ------------- | ----------------- |
| N-001 | Each route's discovery rule and instruction budget, measured and dated                                    | research | none          | yes               |
| N-006 | What a single MCP declaration must reproduce for both hosts                                               | research | none          | no                |
| N-002 | What the neutral layer **is** — `.ai/INSTRUCTIONS.md` alone, or `.ai/` plus the layered `CONTEXT.md` tree | grilling | N-001         | yes               |
| N-008 | How Base declares a route budget so Engine can read it                                                    | grilling | N-001         | yes               |
| N-011 | Whether `.claude/rules/` `paths:` frontmatter subsumes any of the 215 pairs                               | research | N-001         | no                |
| N-003 | Which of `.claude/CLAUDE.md`'s 266 lines are neutral doctrine and which are Claude runtime detail         | grilling | N-002         | yes               |
| N-004 | Adapter shape per route — `@` import, symlink, real file, or fallback-filename entry                      | grilling | N-002         | yes               |
| N-009 | Does one generator satisfy both MCP formats without losing a per-host key                                 | tracer   | N-006         | no                |
| N-007 | Generator or parity — does `.ai/` hold the single MCP declaration                                         | grilling | N-006         | yes               |
| N-005 | Which Copier question gates a route, and what an opted-out project ships                                  | grilling | N-004         | yes               |
| N-010 | What fails when an adapter drifts from its source, or a budget is exceeded                                | grilling | N-004 · N-007 | yes               |
| N-012 | Bring `.claude/CLAUDE.md` under the Codex chain budget                                                    | build    | N-003         | no                |

**Takeable edge: N-001 and N-006** — both research, both unblocked, both fired below.

### What each node already has under it

- **N-001** — evidence gathered 18/09/2026 and quoted in `GAPS.md 18/09/2026`; it resolves when it
  lands in an artefact, not when it is known. Claude Code: 200-line **target**, 4 MiB hard skip,
  cost paid again per subagent unless `omitClaudeMd`. Codex: **32 KiB shared root→cwd**, whole-file
  drop nearest-first, `AGENTS.override.md` → `AGENTS.md` → fallbacks, one file per directory.
  Gemini CLI: `context.fileName` takes a list, JIT ancestor scan, no documented cap. Copilot: fixed
  name set, support is **feature-dependent** — cloud agent and CLI yes, most IDE Chats no.
- **N-002** — constrained by this repo's own gate: `docs-length.sh` binds `.ai/**` at 300 counted
  lines. `.ai/INSTRUCTIONS.md` is at **119**, `.claude/CLAUDE.md` at **266**. The neutral layer
  therefore **cannot absorb the adapter wholesale**, which is why this is a decision and not a move.
- **N-004** — Anthropic documents both shapes and prefers the import: _"On Windows, creating a
  symlink requires Administrator privileges or Developer Mode, so use the `@AGENTS.md` import
  instead."_ A symlink is one byte-stream and so **cannot carry host-specific content at all**.
  Codex has no import mechanism, so its adapter is a real file or a `project_doc_fallback_filenames`
  entry — the two hosts may not land on the same answer, and N-004 must allow that.
- **N-005** — precedent is `INCLUDE_MOBILE` / `INCLUDE_RUST` / `INCLUDE_DESKTOP` in `copier.yml`,
  each gating a surface with `_exclude` templating.
- **N-006** — `mcp-parity.sh` already states exactly what a render must reproduce: the server-name
  set, each `command`, each `args` **in order**; per-host supervision keys (`startup_timeout_sec`,
  `${VAR}` interpolation) stay per-host and are not drift.
- **N-009** — `sync-trees.sh` is the render-from-source precedent in this repository's own idiom:
  it reconciles a generated block against disk and re-stages what it fixed.
- **N-010** — `docs-length.sh` already measures `AGENTS.md`, `.ai/**` and `.codex/**`, and its
  self-test already covers symlinked aliases, alias loops and external aliases. The gate this slice
  needs may be an extension rather than a new script.

---

## Fog of war

- **Whether `CONTEXT.md` joins Gemini's `context.fileName` list.** The Gemini CLI doc's own example
  is `["AGENTS.md", "CONTEXT.md", "GEMINI.md"]`. If it does, the 224 `CONTEXT.md` files stop being
  Claude-and-human orientation and become a second host's instruction surface — which changes what
  may be written in them. Not sharp enough to state as a decision until N-002 fixes what the neutral
  layer is.
- **Whether the Base→Engine budget contract needs a versioned interface or a file read.** Q4 bounded
  Base to _declaring_ the budget; the consumption shape is `syntek-ai-engine`'s and not knowable here.
- **Whether a generated project's `AGENTS.md` carries its own content or routes to `.ai/` exactly as
  this repo's does.** Depends on N-004 and N-005 together.
- **Whether a fifth route — a local serving route behind vLLM — ever wants an adapter-shaped
  artefact**, or whether a budget record is the whole of what it needs. Today it reads no file.

---

## Out of scope

| Ruled out                                                              | Why                                                                                                                                                                                                                                                                                                       |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Renaming `CLAUDE.md` / `CONTEXT.md` pairs to `INSTRUCTIONS.md`         | Measured: Claude Code's memory filenames are **not configurable**, so a rename breaks discovery across 215 pairs on the primary host. Codex and Gemini can be pointed elsewhere; the one that cannot is the one that matters. Neutrality comes from the adapter pattern, not a neutral-sounding filename. |
| Symlinking `.claude/CLAUDE.md` or `AGENTS.md` to `.ai/INSTRUCTIONS.md` | A symlink collapses the adapter into the neutral layer, and an adapter exists to differ per host. Also fails on Windows without elevation.                                                                                                                                                                |
| Moving `AGENTS.md` into `.codex/` or `.agents/`                        | Codex walks **project root → cwd**; neither directory is on that path, so the file would never load.                                                                                                                                                                                                      |
| Perplexity `pplx` as an adapter target                                 | No generation models and no instruction-file convention — the ecosystem plan records three tool commands and no selectable model IDs.                                                                                                                                                                     |
| The local / vLLM route as an adapter target                            | It discovers nothing from disk; whatever reaches Qwen or DeepSeek is composed and sent. Answered by the budget contract (N-008), not by a file.                                                                                                                                                           |
| Context composition and budget **enforcement** for local models        | `ai-ecosystem-business-plan.tex` puts _"fit it to the task's context budget"_ in Engine. Base declares the budget; Engine consumes it. Q4 bound this deliberately.                                                                                                                                        |
| Hooks, `settings.json`, permissions and skills discovery               | Q1 bounded the destination at instruction files plus MCP config. These are host-facing too and would each double the frontier.                                                                                                                                                                            |
| `MAP-RULE-OWNERSHIP`'s "one rule, one home"                            | Different problem, easily confused with this one. That map stops a rule being **restated** inside one tree; this map decides how one statement **reaches N hosts**. A per-route adapter is not a second home.                                                                                             |

---

## Session log

| Date       | Node settled | Outcome                                                                                                                                  | Frontier redrawn |
| ---------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 18/09/2026 | — (charting) | Destination and five bounds confirmed; 16 register entries triaged; `GAPS.md 18/09/2026` written from measurement; N-001 and N-006 fired | [x] initial      |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited to close anything**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — 8 open
- [ ] Every resolved node links to the artefact it became — none resolved yet
- [x] **Every slice has a flag manifest** — every gate it needs, `N/A` omitted
- [x] Index row in `CONTEXT.md` current — **declined on the record**, see the header note

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.** Eight
blocking nodes are open, so none may be cut yet.
