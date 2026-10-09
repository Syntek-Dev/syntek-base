# MAP-INSTRUCTION-DELIVERY — `.ai/` as the single source, four hosts, and a gate behind each adapter

**Charted**: 18/09/2026 · **Charted by**: Claude (Opus 5) · **Workflow**: `01-feature-map`
**Re-charted**: 09/10/2026 · **Re-charted by**: Claude (Opus 5.5), destination confirmed by Sam
**Status**: Blockers clear — stories may start
**Frontier open**: 15 · **Blocking open**: 0 · **Resolved**: 13

> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — this charts **syntek-base's
> own** configuration topology; a generated project inherits the decided arrangement, not the
> argument. The name matters: a `MAP-TEMPLATE-*.md` would match the `!*TEMPLATE*` negation and
> ship.
> **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**, on the interim decline
> `MAP-RULE-OWNERSHIP` N-010 settled on 28/08/2026 — the index relocates to a seeded
> `MAP-INDEX.md` (`MAP-REGISTER-INDEXES` N-001, slice S-01, unbuilt) rather than gaining an
> exception.

> **Re-charted, not replaced.** The 09/10/2026 brief — make `.ai/` the canonical, portable project
> configuration that a future Syntek AI CLI, TUI, engine, orchestrator and evaluation layer read
> directly — widens this map's destination rather than starting a second map, because both would
> claim the same two `GAPS.md` entries. Two of the 18/09 bounds were re-opened on new evidence;
> _Re-chart, 09/10/2026_ below says which, and why. Node and slice numbers are stable: the 18/09
> nodes keep theirs, and new ones are appended.

---

## Destination

**`.ai/` is the single authored source for syntek-base's AI configuration — instructions and
context at the root and in every directory, memory, settings, MCP servers, skills and hook intents
— and Claude Code, Codex, Antigravity and OpenCode each reach it through thin native adapters that a
gate keeps in step with their source and inside each host's instruction budget. llama.cpp and vLLM
are declared as inference backends, not as routes. Nothing built here is a runtime.**

The insight the 18/09 charting rested on still holds: `CLAUDE.md` and `AGENTS.md` **are the adapter
layer**, allowed to differ per host because that is their job. What changed is where the source
lives. The future Syntek AI components read `.ai/` directly; the adapters exist for the tools in use
today, and none of them discovers `.ai/` by name
(`research/AI-HOST-CONFIG-CONVENTIONS.md`).

---

## Re-chart, 09/10/2026 — what changed and why

| 18/09 bound or claim                                                                   | 09/10 evidence                                                                                                                                                                                                                                                                                                                         | Now                                          |
| -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| Renaming the pairs is out: _"Claude Code's memory filenames are **not configurable**"_ | The premise is partly outdated — Claude Code reads `AGENTS.md` natively from v2.1.277. More to the point, a nested `CLAUDE.md` holding `@.ai/INSTRUCTIONS.md` and `@.ai/CONTEXT.md` loads lazily and expands both imports (**measured**, Claude Code 2.1.296), so a pair can move behind a two-line adapter without breaking discovery | **Re-opened** — N-014                        |
| Hooks, `settings.json`, permissions and skills discovery are out (18/09 Q1)            | The 09/10 brief puts them in scope, and every host now documents skills, MCP and hook mechanisms                                                                                                                                                                                                                                       | **Re-opened** — as files, never as a runtime |
| Routes three and four are Gemini CLI and Copilot CLI                                   | The brief names Antigravity and OpenCode; Antigravity publishes a migration path from Gemini CLI                                                                                                                                                                                                                                       | **Replaced** — N-013                         |
| Symlinking `CLAUDE.md` or `AGENTS.md` to the source is out                             | Still true: a generated adapter carries a header and a context pointer a symlink cannot, and Windows needs Developer Mode for one                                                                                                                                                                                                      | **Stands**                                   |
| Moving `AGENTS.md` into `.codex/` or `.agents/` is out                                 | Codex still walks root → working directory only                                                                                                                                                                                                                                                                                        | **Stands**                                   |
| The local / vLLM route is not an adapter target                                        | Neither backend reads a project file                                                                                                                                                                                                                                                                                                   | **Stands** — declared as providers, N-020    |

**Counts re-measured on 09/10/2026:** 216 paired directories (217 tracked `CLAUDE.md`, one of them
the `.agents/skills/` alias) and 226 `CONTEXT.md`; `.claude/CLAUDE.md` is 27,364 bytes and 269
counted lines; five MCP servers are declared, not four. The 18/09 figures of 215, 224 and 266 are
superseded.

---

## Notes

| Field                    | Value                                                                                                                                                                                                                                                                                                                                                                              |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Instruction and context topology, host adapters, MCP, skills, memory, settings, hook intents, generation gating                                                                                                                                                                                                                                                                    |
| Skills to load           | `scaffold` · `doc-writer` · `cicd` · `research` · `grill-with-docs` · `global-workflow` · `codebase-design`                                                                                                                                                                                                                                                                        |
| Standing preferences     | Canonical `.ai/*.md` files carry no host syntax — no `@` imports. Adapters are two-line import files or generated copies, never symlinks. Project configuration may restrict permissions, never widen them. Secrets are referenced by environment-variable name only. Every example inference endpoint names its host and port. Nothing here is a runtime, a compiler or a service |
| Umbrella ADRs            | None yet. ADR candidates: N-005, N-007, N-014, N-015 and N-016, each authored by the story its slice becomes                                                                                                                                                                                                                                                                       |
| Register entries triaged | 2 closes · 0 blocks · 14 unrelated (16 total). Re-triaged 09/10/2026 — no entry has been added since 18/09                                                                                                                                                                                                                                                                         |
| External evidence read   | `research/AI-HOST-CONFIG-CONVENTIONS.md` — Claude Code 2.1.296, Codex 0.160.1, Antigravity (`agy` 1.3.0, docs 2.22.0), OpenCode v2.0.18, llama.cpp v0.6.0 and b11530, vLLM 0.31.0; read 09/10/2026, each claim checked by an adversarial second reader                                                                                                                             |
| Repository audit         | 09/10/2026, read-only: the 216 pairs by cluster, 33 gate and script dependents, the Copier patterns, the skills, hooks, MCP and memory surfaces. Outcomes are in the nodes and slices below, not stored here                                                                                                                                                                       |

**Re-measure before leaning on any of it.** Host behaviour moved in the month before this
re-chart — llama.cpp changed its default port on the day it was written. A drifted citation still
reads plausibly, which is why a re-read never catches one.

---

## Register claimed

**This is a claim, not a close.** Nothing here edits `GAPS.md`. The entries are marked
`✅ CLOSED` by `workflows/22-implementation-documentation/`, against shipped code.

| Register | Entry                                                                                               | Verdict | Retired by    |
| -------- | --------------------------------------------------------------------------------------------------- | ------- | ------------- |
| GAPS.md  | 16/09/2026 — MCP servers are declared twice, and the shared `.ai/` entry point cannot yet hold them | closes  | S-04          |
| GAPS.md  | 18/09/2026 — Codex's instruction budget is already exceeded in 65 of 355 directories                | closes  | S-02 and S-05 |

The 18/09 entry retires only when **both** halves land: S-02 brings the root rules under budget, and
S-05 is the gate that fails when a chain exceeds it again. S-06 raises `project_doc_max_bytes` as a
stopgap, which decides nothing and retires nothing.

---

## Resolved decisions

**Settled in a charting session, and why that is allowed here.** The grilling nodes below were
settled in the two `/grill-with-docs` rounds that re-pinned the destination: each answer bounded
what "done" means. They are recorded as resolved rather than left open to be asked again. Each
graduates to the slice whose story authors its ADR — a map never authors one directly.

| Node  | Decision                                                                                                                                                                                                                                                                                                | Type     | Settled    | Became                                   |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ---------------------------------------- |
| N-001 | Each host's discovery rule and budget: Claude Code loads nested `CLAUDE.md` lazily and nests imports four hops deep; Codex walks root → working directory within 32 KiB and takes bare fallback names only; Antigravity truncates a rule file at 24,000 bytes; OpenCode v2 reads `AGENTS.md` only       | research | 09/10/2026 | `research/AI-HOST-CONFIG-CONVENTIONS.md` |
| N-006 | What one MCP declaration must reproduce: the server set, each `command`, each `args` list in order — for four hosts, with the environment referenced by name as `${VAR}` (Claude Code), `env_vars` (Codex), `{env:VAR}` (OpenCode), and no documented form (Antigravity)                                | research | 09/10/2026 | `research/AI-HOST-CONFIG-CONVENTIONS.md` |
| N-011 | `.claude/rules/` `paths:` frontmatter is not used: a two-line import adapter loads lazily and expands, measured                                                                                                                                                                                         | research | 09/10/2026 | `research/AI-HOST-CONFIG-CONVENTIONS.md` |
| N-013 | The hosts are Claude Code, Codex, Antigravity and OpenCode; llama.cpp and vLLM are inference backends, not routes                                                                                                                                                                                       | grilling | 09/10/2026 | S-02 and S-12 — ADR at story time        |
| N-002 | The neutral layer is `.ai/` at every scope: `<dir>/.ai/INSTRUCTIONS.md` holds the rules, `<dir>/.ai/CONTEXT.md` the orientation                                                                                                                                                                         | grilling | 09/10/2026 | S-02 and S-10 — ADR at S-10's story      |
| N-014 | Every pair moves into `<dir>/.ai/`, except: directories inside `.ai/` (their pair sits directly in them), the eight `reports/` folders and the audit fixture pair. A root `CONTEXT.md` survives as a generated copy of `.ai/CONTEXT.md` — at the root only                                              | grilling | 09/10/2026 | S-10 — ADR at story time                 |
| N-004 | Adapters: Claude Code gets a two-line `@.ai/INSTRUCTIONS.md` / `@.ai/CONTEXT.md` file; Codex, Antigravity and OpenCode get a generated, committed `AGENTS.md` carrying the instructions and a pointer to the context, drift-gated. Codex's `CLAUDE.md` fallback is removed once every directory has one | grilling | 09/10/2026 | S-08 and S-10 — ADR at S-10's story      |
| N-005 | Generated projects: the new layout ships on `copier copy`; `copier update` from an older version is blocked until a migration exists; `settings.toml`, `hooks/`, `opencode.json` and `.agents/mcp_config.json` stay excluded until settled                                                              | grilling | 09/10/2026 | S-03 — ADR at story time                 |
| N-007 | A generator, not parity: MCP is declared once under `[mcp.servers.*]` in `.ai/settings.toml` and rendered to all four hosts                                                                                                                                                                             | grilling | 09/10/2026 | S-04 — ADR at story time                 |
| N-015 | Skill files live in `.ai/skills/`; `.claude/skills/` and `.agents/skills/` hold one link per skill. The vendored cloudinary skills stay physical in `.agents/skills/`, where `npx` installs them, and are linked into `.ai/skills/`                                                                     | grilling | 09/10/2026 | S-11 — ADR at story time                 |
| N-016 | `.ai/MEMORY.toml` replaces `.claude/MEMORY.md`                                                                                                                                                                                                                                                          | grilling | 09/10/2026 | S-09 — ADR at story time                 |
| N-018 | `.ai/hooks/*.yaml` describe each hook's intent; the native wiring stays hand-maintained per host                                                                                                                                                                                                        | grilling | 09/10/2026 | S-14                                     |
| N-020 | llama.cpp and vLLM are declared in `.ai/settings.toml`, disabled, with per-host setup snippets; nothing host-facing ships enabled                                                                                                                                                                       | grilling | 09/10/2026 | S-13                                     |

---

## Slices

| Slice | Story | Title                                   | Nodes                                                         | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                               | Flags                                                                                             |
| ----- | ----- | --------------------------------------- | ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| S-01  | —     | Host registry and budgets               | N-001 ✅ · N-008 ○                                            | Each host's discovery rule, instruction budget and evidence date is recorded in `.ai/settings.toml`, where a gate can read it; the research note is its cited source                                                                                                                                                                                                                                                                                     | QA: unit — the registry parses and every host has a budget                                        |
| S-02  | —     | Neutral root rules                      | N-002 ✅ · N-003 ○ · N-004 ✅ · N-011 ✅ · N-012 ○ · N-013 ✅ | `.ai/INSTRUCTIONS.md` holds the project's neutral rules within Antigravity's 24,000-byte rule limit; `.claude/CLAUDE.md` is a thin Claude adapter; root `AGENTS.md` is generated; the root context lives in `.ai/CONTEXT.md` with a generated root `CONTEXT.md`; neither canonical file carries host syntax                                                                                                                                              | QA: unit — adapters regenerate byte-identical; manual — one session per host loads the root rules |
| S-03  | —     | What ships, and the update block        | N-005 ✅ · N-023 ○                                            | `copier copy` produces the new layout; `copier update` from an older version stops with a message saying why; the excluded extras never reach a generated project                                                                                                                                                                                                                                                                                        | QA: unit — generate, then update from the previous tag; `shipped-ai` extended                     |
| S-04  | —     | One MCP declaration, rendered           | N-006 ✅ · N-007 ✅ · N-009 ○ · N-024 ○                       | `.mcp.json`, the `mcp_servers` tables of `.codex/config.toml`, the `mcp` block of `opencode.json` and `.agents/mcp_config.json` are rendered from `.ai/settings.toml`; the server set, each command and each ordered argument list match by construction; no secret value is written anywhere                                                                                                                                                            | Security: environment names only, never values · QA: unit — render round-trip                     |
| S-05  | —     | The drift and budget gate               | N-010 ○                                                       | A gate fails when an adapter differs from its canonical source, when a Codex root → working-directory chain exceeds its declared budget, and when an Antigravity rule file exceeds 24,000 bytes; none of the three passes silently                                                                                                                                                                                                                       | QA: unit — `--self-test` over a generated pair                                                    |
| S-06  | —     | Housekeeping                            | N-027 ○                                                       | `.claude/settings.local.json`, `.ai/settings.local.toml` and `.ai/.generated/` are ignored by the repository's own `.gitignore`; Codex's `project_doc_max_bytes` sits above the worst measured chain, marked as a stopgap; root `AGENTS.md` addresses every host, not only Codex                                                                                                                                                                         | QA: unit — `git check-ignore` on each local-only path                                             |
| S-07  | —     | The gates learn the `.ai/` layout       | N-028 ○                                                       | Every gate and generator that reads pairs accepts both layouts and is proven against a fixture tree in the new one: `docs-pairing`, `sync-trees`, `docs-length`, `template-orphans`, the shipped-file checks, `doc-references`, the lefthook globs, the CI path filters, the `reports/` and `questionnaires/` allowlists, the Copier re-include patterns, `new-django-app.sh` and the `scaffold` skill. None reports a pass over a scope it did not read | QA: unit — `--self-test` per gate on both layouts                                                 |
| S-08  | —     | Sync and rewrite tooling                | N-029 ○                                                       | `code/src/scripts/development/ai-sync.sh` regenerates every adapter and the root `CONTEXT.md` copy, checks by default, writes only with `--write`, owns only what it renders and never deletes; a citation-rewrite tool modelled on the v6.0.0 migration rewrites paths idempotently                                                                                                                                                                     | QA: unit — `--self-test`; a second run changes nothing                                            |
| S-09  | —     | Memory in TOML                          | N-016 ✅ · N-017 ○                                            | `.ai/MEMORY.toml` holds the three real entries under schema v1; the generated-project seed is blank and seed-once; the shipped-memory checks read TOML; no fabricated entry exists                                                                                                                                                                                                                                                                       | QA: unit — seed-once across copy and update                                                       |
| S-10  | —     | The scripted move                       | N-002 ✅ · N-004 ✅ · N-014 ✅                                | Every pair outside the exempt set lives at `<dir>/.ai/`; each such directory carries a two-line `CLAUDE.md` and a generated `AGENTS.md`; every citation and `Read order:` line points at its final target, rewritten once; every S-07 gate passes on the moved tree                                                                                                                                                                                      | QA: unit — all gates; manual — a nested load verified on each host                                |
| S-11  | —     | Skills in `.ai/skills/`                 | N-015 ✅                                                      | Skill files live in `.ai/skills/`; `.claude/skills/` and `.agents/skills/` hold one link per skill; cloudinary stays physical in `.agents/skills/`; `skill-conformance` identifies vendored skills from `skills-lock.json`; no gate reports zero skills                                                                                                                                                                                                  | QA: unit — conformance on both layouts and in a generated project                                 |
| S-12  | —     | OpenCode and Antigravity project config | N-013 ✅ · N-025 ○                                            | `opencode.json` uses keys the published schema accepts and carries the rendered MCP block and permission rules mirroring the `.env` denies; Antigravity reads the repository's `AGENTS.md` and `.agents/skills/`; each host advertises every skill exactly once                                                                                                                                                                                          | Security: `.env` reads denied on every host · QA: manual — one session per host lists the skills  |
| S-13  | —     | Settings and providers                  | N-020 ✅ · N-021 ○                                            | `.ai/settings.toml` sets only keys that are true today, and reserved keys are documented rather than set; llama.cpp and vLLM are declared disabled with an explicit host and port; snippets exist for OpenCode, for Codex at user level, and for Claude Code through `ANTHROPIC_BASE_URL`, marked unsupported by Anthropic                                                                                                                               | Security: loopback-only examples, keys by environment name · QA: unit — settings parse            |
| S-14  | —     | Hook intents and the standard           | N-018 ✅ · N-019 ○ · N-026 ○                                  | One `.ai/hooks/*.yaml` per existing hook registration; `how-to/docs/AI-CONFIG.md` and `how-to/docs/ai-config/` state scope inheritance and precedence, the file-ownership classes, the dated host matrix, the generated-TOML contract with one example, and the plugins and mods convention; `.ai/`'s own maintenance rules live there                                                                                                                   | QA: unit — every hook spec names a registered hook; `docs-length` on the guide                    |

**Build order.** S-06 → S-07 → S-08, then three tracks. **Instructions:** S-03 → S-02 → S-09 →
S-10 → S-05, with S-01 before S-05. **Skills:** S-11. **Configuration:** S-04 → S-12 → S-13.
S-14 lands last, because it documents what the others built. S-03's update block lands no later
than S-02, the first slice that moves a shipped file. S-09 lands before S-10 so the `Read order:`
lines are rewritten once, to `.ai/INSTRUCTIONS.md` and `.ai/MEMORY.toml` together.

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking. Every one of the 28 nodes
belongs to a slice. **No open node blocks a story:** each is confined to one slice and is settled
in that story's own grilling at `17-story-plans`, and none changes the slicing. Challenge that the
moment one turns out to cross slices.

---

## Frontier

| Node  | Decision                                                                                                                                            | Type     | Blocked by | Blocking a story? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ----------------- |
| N-027 | Housekeeping: the `.gitignore` rows, the Codex budget stopgap, the root `AGENTS.md` retitle                                                         | build    | none       | no                |
| N-028 | Every pair-reading gate and generator accepts both layouts                                                                                          | build    | N-027      | no                |
| N-029 | `ai-sync.sh` and the citation-rewrite tool                                                                                                          | build    | N-028      | no                |
| N-023 | The `copier update` block — which versions it stops, what it says, how it is proven                                                                 | grilling | none       | no                |
| N-003 | Which lines of `.claude/CLAUDE.md` are neutral rules and which are Claude runtime detail                                                            | grilling | none       | no                |
| N-012 | Bring the root rules under Codex's chain budget and Antigravity's 24,000-byte rule limit                                                            | build    | N-003      | no                |
| N-017 | `MEMORY.toml` schema v1 — fields, categories, confidence kept apart from approval, supersession, the seed's shape                                   | grilling | none       | no                |
| N-008 | How a host's budget is declared so that a gate and, later, Engine can both read it                                                                  | grilling | none       | no                |
| N-010 | What fails on drift and on an exceeded budget, and where the gate runs                                                                              | grilling | N-008      | no                |
| N-009 | Does one renderer serve all four MCP formats without losing a per-host key                                                                          | tracer   | none       | no                |
| N-024 | Does Antigravity hand the inherited environment to a stdio MCP server? If not, it gets only the servers that need no secret                         | tracer   | none       | no                |
| N-025 | How OpenCode v2 presents one skill reached through `.claude/skills` and `.agents/skills`, and whether its compatibility scan should be switched off | tracer   | none       | no                |
| N-021 | The `.ai/settings.toml` key set — which keys are live, which are reserved                                                                           | grilling | none       | no                |
| N-019 | The hook-intent YAML schema                                                                                                                         | grilling | none       | no                |
| N-026 | The generated-TOML contract — schema version, source path and hash, provenance                                                                      | grilling | none       | no                |

**Takeable edge:** N-027, then every node except N-028, N-029, N-012 and N-010. The tracers N-009,
N-024 and N-025 can run today, against the current layout.

---

## Fog of war

- **A Copier question per host** (`INCLUDE_<HOST>`) — unneeded while a generated project takes the
  layout whole; it sharpens into a node if a project ever wants one host only.
- **`.claude/plugins/`** — six Python inspection helpers whose name collides with Claude Code
  plugins and with the future `.ai/plugins/`; whether they move into `.ai/`, and under what name.
- **Whether the `Read order:` lines survive at all** once every host loads its scope files itself.
  S-10 rewrites them once; retiring them is a later doctrine question.
- **Known defects travel with the move.** The 09/10 audit found 35 contradictions across the pairs
  and 119 `CONTEXT.md` files carrying rules. S-10 moves them unchanged; whether any must be fixed
  first, or whether S-10's rewrite is the moment, is not yet decided.
- **Whether directory context should reach Codex, Antigravity and OpenCode beyond a pointer.** The
  largest `CONTEXT.md` (139,730 bytes) exceeds every non-Claude budget on its own.
- **OpenCode's schema lag** — the published schema is V1-shaped while the V2 docs use new keys;
  `opencode.json` may move to V2 keys when a V2 schema is published.
- **The business plan diverges.** `ai-ecosystem-business-plan.tex` lists other routes, places
  memory and skills in Engine and treats Scrapling as a candidate. It lives in
  `syntek-business-docs` and is not edited from here.
- **The Base → Engine budget contract** — a versioned interface or a file read. Carried from 18/09;
  S-01 declares the budget, and the consumer is Engine's to design.

---

## Out of scope

| Ruled out                                                                                     | Why                                                                                                                                 |
| --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| A Syntek AI CLI or TUI, `syntek-ai-engine`, `syntek-orchestrator`, `syntek-evaluation`        | The 09/10 brief: those are future repositories that read `.ai/`; this map prepares the files they read                              |
| A Markdown-to-TOML compiler, a sync daemon, a plugin loader, a memory service, a hook runtime | Same brief. The generated-TOML contract is documented with one example (S-14); `ai-sync.sh` is a repository script, not a framework |
| Symlinking `CLAUDE.md` or `AGENTS.md` to the canonical source                                 | An adapter carries a header and a context pointer a symlink cannot; Windows needs Developer Mode for one                            |
| Moving `AGENTS.md` into `.codex/` or `.agents/`                                               | Codex walks root → working directory only, so the file would never load                                                             |
| A `.agent/` directory, and Antigravity workflows                                              | `.agent/` is Antigravity's legacy name for `.agents/`; workflows stop working on 19/10/2026                                         |
| Gemini CLI, Copilot CLI and Perplexity `pplx` as routes                                       | Replaced by Antigravity and OpenCode (N-013); `pplx` has no instruction-file convention                                             |
| llama.cpp and vLLM as adapter targets, and providers committed in an enabled state            | Backends read no project file; a dead provider in every project's model list implies a capability that is not there (N-020)         |
| A Codex model provider in project configuration                                               | Codex ignores provider keys in a project `.codex/config.toml`; it is documented at user level instead                               |
| A `copier update` migration for existing generated projects                                   | Blocked rather than built in this epic (N-005); a migration is its own later story                                                  |
| `.ai/plugins/` and `.ai/mods/` directories                                                    | Documented as conventions only (S-14) — nothing real to put in them, and git cannot track an empty directory                        |
| `.claude/rules/` path-scoped rules                                                            | Not needed: the import adapter loads lazily and expands (N-011)                                                                     |
| Context composition and budget **enforcement** for local models                               | Engine's, per the ecosystem plan; Base declares the budget (S-01) and Engine consumes it                                            |
| `MAP-RULE-OWNERSHIP`'s "one rule, one home"                                                   | A different problem: that map stops a rule being restated inside one tree; this one decides how one statement reaches four hosts    |

---

## Session log

| Date       | Node settled                                                                                                     | Outcome                                                                                                                                                                                                                                                                                                                                                                                   | Frontier redrawn |
| ---------- | ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 18/09/2026 | — (charting)                                                                                                     | Destination and five bounds confirmed; 16 register entries triaged; `GAPS.md 18/09/2026` written from measurement; N-001 and N-006 fired                                                                                                                                                                                                                                                  | [x] initial      |
| 09/10/2026 | N-001, N-006, N-011 (research) · N-002, N-004, N-005, N-007, N-013, N-014, N-015, N-016, N-018, N-020 (grilling) | Re-charted from the 09/10 brief: a 14-agent read-only audit with adversarial verification, one local measurement, and two `/grill-with-docs` rounds that re-pinned the destination. The 18/09 bounds on renaming and on hooks, settings and skills were re-opened on that evidence. S-01 to S-05 rewritten, S-06 to S-14 added, N-017 to N-029 charted; the register re-triaged unchanged | [x] re-chart     |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed — re-confirmed 09/10/2026
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited to close anything**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — none is open
- [x] Every resolved node links to the artefact it became — the research note, or the slice whose
      story authors its ADR
- [x] **Every slice has a flag manifest** — every gate it needs, `N/A` omitted
- [x] Index row in `CONTEXT.md` current — **declined on the record**, see the header note

**Stories may be cut in `workflows/02-story-creation/`.** Begin with S-06, the head of the build
order; every other slice waits on S-06 → S-07 → S-08.
