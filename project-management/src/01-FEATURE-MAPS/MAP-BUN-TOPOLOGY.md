# MAP-BUN-TOPOLOGY — Bun replaces pnpm, and Node wherever Node is not needed

**Charted**: 11/09/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Charting complete** — frontier drawn and unresolved; research node N-001 resolved 11/09/2026
**Frontier open**: 29 · **Blocking open**: 21 · **Resolved**: 1 · **Provisional slices**: 5

> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — this charts **syntek-base's
> own** toolchain, and a generated project inherits the decided toolchain, not the argument.
> **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**, on the interim decline
> `MAP-RULE-OWNERSHIP` N-010 settled on 28/08/2026: the index relocates to a seeded `MAP-INDEX.md`
> (`MAP-REGISTER-INDEXES` N-001, slice S-01, unbuilt), and until that lands this map declines the
> row deliberately, on the record.

---

## Destination

**Bun replaces pnpm as the package manager, and replaces Node as the runtime of the web
toolchain** — eslint, prettier, markdownlint-cli2, the Bruno CLI, lefthook and the `npx`-launched
MCP servers — in syntek-base and in every generated project, carried to existing projects by an
**acting** Copier migration in a major release. **Node stays a prerequisite only when
`INCLUDE_MOBILE` is set.** Every pnpm supply-chain control has a Bun equivalent, or the swap stops.

**The fallback is pre-agreed.** If the runtime tracers fail against N-002's criteria, the
destination degrades to **package manager only** — Node stays the tooling runtime — recorded as
an outcome at N-016, never re-grilled. S-01 is exactly that fallback; S-02 is cut only on a pass.

### Destination bounds — settled at charting, 11/09/2026 (round 1)

| #   | Question                    | Settled                                                                    |
| --- | --------------------------- | -------------------------------------------------------------------------- |
| Q1  | What "done" replaces        | pnpm **and** Node for the web toolchain; Node only with `INCLUDE_MOBILE`   |
| Q2  | Bun as a bundler            | **Out** — the web surface has no build step by doctrine; Metro stays       |
| Q3  | The mobile workspace member | Switches with the root, onto **one** `bun.lock`                            |
| Q4  | Generated projects          | Template-wide, **acting** `.copier/migrations/` script, major version bump |
| Q5  | Supply-chain parity         | **Hard gate** — a control with no Bun equivalent stops the swap            |

**These graduate at S-01**: the story cut from it authors the ADR recording Q1–Q5 and the parity
table (N-024), per the graduation table — a map never authors an ADR direct.

---

## Notes

| Field                    | Value                                                                                                                                                                |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | The JS dev toolchain — manifests, lockfile, `code/src/scripts/`, `.claude/hooks/`, 7 CI workflows, `.mcp.json`, Copier migration, the docs that name pnpm            |
| Skills to load           | `cicd`, `planner`, `grill-with-docs`, `research`, `prototype`, `security`, `doc-writer`, `version`; `stack-react-native` for the mobile nodes                        |
| Standing preferences     | Q1–Q5 above. Tracers run in a throwaway worktree or scratch clone, **never this tree**. The pass/fail bar for a tracer is settled before it runs (N-002, N-003)      |
| Umbrella ADRs            | None yet — S-01's story authors the one ADR for Q1–Q5 and the parity table                                                                                           |
| Register entries triaged | **14 open: 2 closes · 2 blocks · 10 unrelated.** `DEFERRED.md` is empty                                                                                              |
| Suggested first batch    | **A — grilling N-002 + N-003**: the two bars every tracer is judged against, settled before any spike runs. **B — tracers N-006 to N-010** once Bun exists somewhere |

### What is load-bearing today — measured 11/09/2026 at `b6c5c25`

| Surface             | Load-bearing                                                                                                                                                                                                                                    |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Runtime images      | **None** — all four Dockerfiles are `python:3.14-slim`; Node is host and CI tooling only                                                                                                                                                        |
| Bundler             | **None on the web**; the only bundler that runs is Metro, via `expo export`                                                                                                                                                                     |
| Manifests           | `package.json` (`pnpm@11.25.0`, `engines.node >=24`) · `pnpm-workspace.yaml` (26 overrides, 1 patch, 4 audit ignores, 6 build denials, 13 age excludes) · `.npmrc` (4 keys) · `.nvmrc` (24) · `pnpm-lock.yaml` v9 (1,357 packages, 2 importers) |
| Scripts and hooks   | 14 of 82 scripts under `code/src/scripts/` plus `install.sh`; 6 `.claude/hooks` files; 4 lefthook legs                                                                                                                                          |
| CI                  | 7 of 35 workflows — 15 `pnpm/action-setup`, 15 `setup-node`, 12 store caches                                                                                                                                                                    |
| MCP                 | `context7` and `mcp-mermaid` via `npx -y` (`.mcp.json`)                                                                                                                                                                                         |
| Docs                | ~60 instructional files name pnpm; ~229 mentions across 101 files repo-wide (scout census)                                                                                                                                                      |
| Python-bundled Node | basedpyright (`nodejs-wheel` 24.16.0) and the Playwright driver carry their own — out of scope                                                                                                                                                  |

---

## Register claimed

**A claim, not a close.** Nothing here marks an entry `✅ CLOSED`; that is
`workflows/22-implementation-documentation/`, against shipped code.

| Register | Entry                                                                                              | Verdict | Retired by                                                                                    |
| -------- | -------------------------------------------------------------------------------------------------- | ------- | --------------------------------------------------------------------------------------------- |
| GAPS.md  | 16/08/2026 sitting, _Still open_ — `pnpm-update.sh`'s header claims files it no longer updates     | closes  | N-026 / N-019 — the script retires or is replaced by the Bun pin mover                        |
| GAPS.md  | 11/09/2026 — `install-frontend.sh --local` hands two stray arguments to `sudo rm -rf`              | closes  | **Conditional** — `bugfix` first; if still open, S-01 retires it when N-024 rewrites the file |
| GAPS.md  | 09/09/2026 — a print-only `_migrations:` advisory is invisible in the `template-update.sh` preview | blocks  | Frontier **N-022**. An advisory half is certain even in an acting migration (N-021)           |
| GAPS.md  | 11/09/2026 — the Bun map's eight tracers have no Bun to run on                                     | blocks  | Manual provisioning, not a node — blocks N-006 to N-013 until an environment exists           |

**Unrelated (10):** 31/08 PE-gate markup half and prefix set · 31/08 htmx pinned at major 2 ·
01/09 RUSTSEC advisory invisible (**adjacent** — N-026 edits the same `audit-deps.yml`; a
merge-order note only) · 01/09 no staging/production mail backend · 01/09 two `**Status:**`
vocabularies · 01/09 the `CONTEXT.md` index-row instruction · 02/09 `doc-references.sh` on a
never-shipping tree · 09/09 the security-settings block shipped twice · 16/08 _Still open_:
`COVERAGE.md`'s `-n auto` · 16/08 _Still open_: the `10.0.1.0/24` collision.

---

## Resolved decisions

The destination bounds above were settled at charting and graduate through S-01.

| Node  | Decision                                                                                                                             | Type     | Settled    | Became                                      |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------ | -------- | ---------- | ------------------------------------------- |
| N-001 | Bun's config discovery, manifest enforcement and CLI exit contracts — 12 legs from source, each re-checked by an independent refuter | research | 11/09/2026 | `research/BUN-PACKAGE-MANAGER-CONTRACTS.md` |

### What N-001 settled, and where each finding lands

Pointers only — the claims and their citations are in the note.

- **N-003** — three of the four missing controls confirmed at source: audit ignores are CLI-only,
  matched by URL substring and silent when stale; `bun pm untrusted` exits 0 either way, so a
  fail-loud build-script gate must parse its stdout or the install summary; age excludes match
  names only (oven-sh/bun #28967, open). `allowedDeprecatedVersions` maps to nothing — Bun prints
  no deprecation warnings.
- **N-006** — the `bun audit` contract is known from source (both flag forms; `--json` unfiltered;
  the ignored count only on a clean run; exit 1 for findings **and** a registry failure). The
  tracer narrows to finding-by-finding parity with `pnpm audit`.
- **N-007** — the root `package.json` must gain `workspaces` before root `[install]` settings govern
  an install from `code/src/mobile`. A workspace pruned from disk passes a frozen install with a
  note, which suits web-only renders. The token root name is accepted per source; the run proves it.
- **N-009** — `bun outdated` exits 0 whatever it finds, so `update.sh --check` loses its contract;
  it defaults to the current workspace only, which may keep the Expo set out of a root check.
- **N-012 and N-017** — `bunx` reads no project `bunfig.toml`: `[run] bun = true` never reaches it
  (only `--bun`), and neither does the project's age gate or registry. `bun run` reads only the
  current directory's file, so a root `[run]` does not reach scripts run from `code/src/mobile`.
- **N-014** — the age gate touches new resolution only (documented); `bun ci` re-applying it to a
  locked version fails (#40031, open); a required peer inside the window fails the install (PR
  #38995, open).
- **N-019** — Bun enforces neither `engines` nor `packageManager`; the pin is enforced by
  `install.sh` and CI, or not at all.
- **N-020** — `bun.lock` records the root and member names, so a shipped lock carries the token;
  v3 is written only while scoped overrides exist and is unreadable by Bun before 1.4 and by
  Turborepo.
- **N-024** — a frozen install with no `bun.lock` passes and writes nothing; with `pnpm-lock.yaml`
  present it migrates and writes `bun.lock` even when frozen. The lockfile-existence guard is
  mandatory.
- **Release line** — 1.4.0 shipped 20/08/2026, 1.4.2 on 05/09/2026. No release fixes the
  frozen-lockfile false-pass class (#22689 open; PR #41931 open).

---

## Slices

**Provisional** — cut at charting from the build nodes, so every node has a route to a story.
Cuttable only when every node a slice names is `✅`. `Story` is back-filled by `02-story-creation`.

| Slice | Story | Title                                         | Nodes                                                                                                                                                                     | Acceptance                                                                                                                                                                                                                                                                                | Flags                                                                                                                                                                                                                                                                                                 |
| ----- | ----- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| S-01  | —     | Bun is the only package manager               | N-001 ✅ · N-003 ⛔ · N-004 ⛔ · N-005 ○ · N-006 ⛔ · N-007 ⛔ · N-008 ⛔ · N-009 ⛔ · N-011 ⛔ · N-014 ⛔ · N-015 ⛔ · N-016 ⛔ · N-019 ⛔ · N-024 ○ · N-025 ○ · N-026 ○ | A clone installs, audits and updates with Bun alone on both render paths; every pnpm 11 control holds through the equivalent N-016 accepted; a missing or drifted `bun.lock` fails every frozen install; an absent `bun` reports could-not-look; no shipped doc cites a deleted pnpm path | Security: supply-chain parity (audit ignores, age gate, build scripts, overrides, patch), lockfile fail-open, `bunx` auto-fetch · QA: integration — both render paths, mobile importer on one lock; negative — absent lock, unreviewed build script, unmatched ignore, registry failure, absent `bun` |
| S-02  | —     | Bun is the web tooling runtime                | N-002 ⛔ · N-012 ⛔ · N-017 ⛔ · N-027 ○                                                                                                                                  | On a host with no system Node, every web lint, format, markdown, Bruno, pre-commit and MCP leg runs on Bun and returns Node's verdicts on clean and seeded trees; no web CI job installs Node. **Cut only if N-016's Q1 half passes**                                                     | Security: MCP packages' lifecycle scripts stay suppressed; no unpinned `bunx` fetch; the project age gate reaches whatever `bunx` runs · QA: parity — Node vs Bun, clean and seeded; Node-free host; Bruno scripted assertions in both sandboxes                                                      |
| S-03  | —     | Node only where the mobile surface needs it   | N-013 ⛔ · N-018 ⛔ · N-028 ○                                                                                                                                             | A web-only project needs no system Node anywhere; a mobile project needs Node only for the commands N-018 names, pinned in one place, and fails loudly without it; its Expo CI jobs stay green on the shared `bun.lock`                                                                   | QA: integration — mobile CI jobs, `expo export`, jest coverage; manual — Expo Go device loop; negative — Node absent on a mobile project                                                                                                                                                              |
| S-04  | —     | v8.0.0 carries the swap to generated projects | N-010 ⛔ · N-020 ⛔ · N-021 ⛔ · N-022 ⛔ · N-029 ○                                                                                                                       | `copier update` from 7.x to 8.0.0 leaves a project on Bun with no pnpm artefacts, whether or not `bun` is on PATH; every instruction the migration cannot act on is visible in the preview before `--apply`; CI exercises that update and a frozen install on both render paths           | Security: the migration never overwrites and always exits 0 · QA: integration — copy at v7.5.0, update to HEAD, both `INCLUDE_MOBILE` paths, `bun` present and absent; regression — preview shows advisory text; drift audit reports the swap truthfully                                              |
| S-05  | —     | Doctrine names Bun                            | N-023 ⛔ · N-030 ○                                                                                                                                                        | No shipped instructional doc presents pnpm or `npx` as the toolchain; the raw-invocation rule has one owner naming Bun's binaries; the supply-chain rationale sits beside, or routes to, each control; every doc gate passes with no new length allowance                                 | QA: doc gates — `docs-length` (`audits/CONTEXT.md` at 298/300), `doc-references` (deleted paths, `bun.lock`), `doctrine-drift` banned rows, `docs-pairing`                                                                                                                                            |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking.

---

## Frontier

Dependency order, unblocked first. **Takeable now: N-002 to N-010** — the tracers among them also
wait on the GAPS.md environment entry above.

| Node  | Decision                                                                                                                           | Type     | Blocked by                                      | Blocking a story? |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------- | -------- | ----------------------------------------------- | ----------------- |
| N-002 | What counts as a failed runtime spike, and what exactly the Q1 fallback removes                                                    | grilling | none                                            | yes               |
| N-003 | Q5's bar — native Bun config only, or a repo-owned gate that rebuilds a control Bun lacks                                          | grilling | none                                            | yes               |
| N-004 | Landing order against US008's v7.6.0 migration key and the other maps' unbuilt pnpm-shaped slices                                  | grilling | none                                            | yes               |
| N-005 | CI shape — inline `setup-bun` or a composite action; the dependency cache; `test-api.yml`'s path filter                            | grilling | none                                            | no                |
| N-006 | Does `bun audit` return the same findings as `pnpm audit` on the same graph, and can the declared-versus-matched count be computed | tracer   | none                                            | yes               |
| N-007 | Does Bun install the template's manifests as they are, on both render paths                                                        | tracer   | none                                            | yes               |
| N-008 | Do all 26 overrides resolve identically, and does `bun pm migrate` carry the overrides and the patch                               | tracer   | none                                            | yes               |
| N-009 | Do root `bun update --latest` and `bun outdated` keep the Expo SDK set and the age gate intact                                     | tracer   | none                                            | yes               |
| N-010 | What `copier update` does to a real v7.5.0 project whose `pnpm-lock.yaml` the template deletes                                     | tracer   | none                                            | yes               |
| N-011 | Do Metro and Jest resolve from Bun's isolated store, with Node still the runtime                                                   | tracer   | N-007                                           | yes               |
| N-012 | Does the web toolchain run on Bun's runtime with Node-identical verdicts                                                           | tracer   | N-002                                           | yes               |
| N-013 | Does the mobile toolchain run on Bun's runtime, or does Node stay its runtime                                                      | tracer   | N-002, N-011                                    | yes               |
| N-014 | How pnpm 11's implicit one-day age gate is kept, and the fate of the 13 exact-version excludes                                     | grilling | N-003                                           | yes               |
| N-015 | Where the supply-chain lists and their rationale live once `pnpm-workspace.yaml` goes; how the ignore list is verified             | grilling | N-003, N-004, N-006                             | yes               |
| N-016 | **Go/no-go** — proceed, degrade to package manager only, or stop                                                                   | grilling | N-003, N-006, N-007, N-008, N-009, N-011, N-014 | yes               |
| N-017 | How the runtime is switched — root bunfig, per-call-site `--bun`, or a hybrid — and how the mobile scripts choose theirs           | grilling | N-012, N-013                                    | yes               |
| N-018 | The Node boundary, stated once, and where Node is pinned when it is mobile-only                                                    | grilling | N-012, N-013, N-017                             | yes               |
| N-019 | The Bun pin — one home, how exact, what enforces it, who moves it                                                                  | grilling | N-004                                           | yes               |
| N-020 | Does `bun.lock` ship in the template, or is it excluded and regenerated per project                                                | grilling | N-007, N-010                                    | yes               |
| N-021 | Which parts of the v8.0.0 migration act and which advise, and what it does with no `bun` on PATH                                   | grilling | N-008, N-010, N-015, N-020                      | yes               |
| N-022 | What the update preview must show for v8.0.0 — advisory text, and a toolchain swap `dependency-drift` reports truthfully           | grilling | N-019, N-021                                    | yes               |
| N-023 | Who owns the raw-invocation ban list, and which binaries it names after the swap                                                   | grilling | N-018                                           | yes               |
| N-024 | Build — Bun manifests, bunfig, lock and install path; syntek-base's own clones and worktrees switched                              | build    | N-003, N-014, N-015, N-016, N-019               | no                |
| N-025 | Build — every pnpm call site, hook and CI install moved to Bun, with could-not-look reporting                                      | build    | N-005, N-007, N-011, N-016, N-019               | no                |
| N-026 | Build — the supply-chain gates re-pointed at Bun                                                                                   | build    | N-006, N-007, N-009, N-015, N-016, N-019        | no                |
| N-027 | Build — the web toolchain runs on Bun's runtime                                                                                    | build    | N-002, N-012, N-017                             | no                |
| N-028 | Build — Node only where the mobile surface needs it                                                                                | build    | N-013, N-017, N-018                             | no                |
| N-029 | Build — v8.0.0 carries the swap to generated projects                                                                              | build    | N-004, N-020, N-021, N-022                      | no                |
| N-030 | Build — doctrine and docs re-derived for Bun                                                                                       | build    | N-015, N-018, N-019, N-023                      | no                |

### Frontier notes — the evidence each node starts from

Pointers, not reasoning. **Re-measure before leaning on any of them** (RESOLVE Step 1). N-001's
findings are listed under _Resolved decisions_ and are not repeated here.

- **N-002** — `run.bun` is on by default whenever `node` is absent from PATH, so the fallback is
  two changes: drop the bunfig line **and** keep Node in `install.sh`, CI and the prerequisites.
  Open: all-or-nothing vs per-tool carve-out; which platforms must pass; proven once or re-proven
  per Bun bump.
- **N-003** — four controls have no native counterpart: `audit.ignore` is CLI-only in Bun (four
  call sites); `strictDepBuilds` fail-loud has none (Bun's default trusted list would run 4 of the 6
  scripts pnpm denies — esbuild, lefthook, msw, sharp); age excludes take names, not versions;
  MAP-GATE-PARITY N-024 reads an ignored count Bun prints only on a clean run.
- **N-004** — the swap is v8.0.0; Copier fires a key only when `to >= key > from`, so US008's
  v7.6.0 key must land first or be re-keyed. Cross-map slices still pnpm-shaped: MAP-GATE-PARITY
  S-08, S-10; MAP-UPSTREAM-TRACKING S-01 to S-03; MAP-RULE-OWNERSHIP Q19 / US006;
  MAP-PROGRESSIVE-ENHANCEMENT S-02 (`@eslint/css`).
- **N-006** — `check-security.sh:47-48` greps pnpm's "severity" wording, which Bun's summary lacks —
  a skip that reads as a pass. The `--json` output carries the GHSA id only inside `url`.
- **N-007** — the root manifest's name is the `<%PROJECT_SLUG%>` token; `code/src/*` holds
  directories with no `package.json`; `check-lockfiles.sh:145` uses a root `node_modules/` as its
  presence signal.
- **N-008** — 16 bare names, 7 `pkg@range` selectors, 3 `parent>child` rules; the Jest 29 pair
  depends on most-specific-wins. Scoped rules stamp `bun.lock` v3.
- **N-009** — today `update.sh` runs `pnpm update --latest` without `-r`, which never enters the
  mobile importer; Bun's root update also moves every workspace's transitive dependencies.
  oven-sh/bun #25305 (update bypasses the age gate transitively) is open.
- **N-010** — Copier 9.17.0's update order was read from source, not run; CI's `uvx copier` is
  unpinned.
- **N-011** — a pnpm migration gets `configVersion 1`, so the isolated linker; there is no
  `metro.config.*`. Bites under the fallback too, because Q3 puts mobile on the shared lock.
- **N-012** — lefthook's hook template has no bun branch and falls back to `index.js` (needs
  `node`); `mcp-mermaid`'s PNG output launches Chromium through Playwright.
- **N-013** — Expo's using-bun page names Node only for `create expo` and `expo prebuild`, and is
  **silent** on start, export, Metro and Jest — the boundary rests on silence, not a statement.
- **N-014** — pnpm 11 defaults `minimumReleaseAge` to 1440 minutes and the repo sets none; Bun's
  default is off, so bunfig needs `86400` just to stand still. All 13 excludes are inert today.
- **N-015** — overrides, patches and `trustedDependencies` move to root `package.json` (no
  comments); age gate and linker to `bunfig.toml`; ignores become CLI flags.
- **N-019** — candidate homes: `packageManager: bun@x`, `.bun-version`, `engines.bun`.
- **N-020** — `pnpm-lock.yaml` ships today because pnpm keys importers by path; `bun.lock` keys
  workspaces by name. The `uv.lock` precedent excludes and regenerates.
- **N-021** — a migration cannot install Bun; a non-zero exit aborts every later migration
  (outlawed at v2 and v7); deleting the pnpm artefacts turns Bun's auto-migration into a fresh,
  unpinned resolve.
- **N-022** — `dependency-drift.sh` keeps digits only, so `pnpm@11.25.0` → `bun@1.x` reads as a
  BLOCKING major move; it cannot see removed pins, a new `setup-bun`, `bun.lock` or `bunfig.toml`.
- **N-023** — 46 shipped non-record files restate the ban, with lists that disagree (three still
  ban `next`).
- **N-024 to N-030** — deliverables are named in each build node; S-01 is atomic because deleting
  the lock breaks every pnpm call site at once.

---

## Fog of war

- **Rollback after v8.0.0** — Copier cannot update a project back to 7.x; the escape route if a
  Bun release regresses a gate after release is undefined.
- **Bun maturity** — nested overrides, transitive update and `bun.lock` v3 landed in 1.4 (PR
  merged 14/08/2026, released 20/08/2026), under a month before this chart.
- **Copier `_tasks` on update** — whether the temp-dir renders also run ungated tasks (two or three
  lock resolves per update), and whether the existing `uv lock` task already merges `uv.lock`, a
  latent defect a `bun.lock` task would inherit.
- **Project-authored config** — how many generated projects carry their own overrides, patches or
  ignores; this sizes the migration's advisory half.
- **Scoped registries** with no advisory endpoint, which `bun audit` reports as skipped at exit 0.
- **Editors** — Zed and VS Code run ESLint and Prettier on their own Node; nobody has asked whether
  "Bun runtime" reaches them.
- **MCP process environment** — the cwd Claude Code gives MCP servers matters only if the switch
  relies on a local bunfig reaching `bunx`, which N-001 found it never does.
- **`process.version`** under Bun against eslint's and markdownlint-cli2's engines floors.
- **Mobile edges** — Bun's hoist fallback vs Expo's phantom dependencies (only if N-011 fails);
  Metro on a physical device; EAS finding the root `bun.lock` (only once EAS is adopted).
- **Neighbouring records** — MAP-PROGRESSIVE-ENHANCEMENT (still Charting) cites pnpm three times;
  the story-plan template's raw-command exception; a Node row in `post-pr-comment.sh`'s table.

---

## Out of scope

| Ruled out                                                               | Why                                                                                                                    |
| ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Bun as a bundler; replacing Metro                                       | Q2 — the web surface has no build step by doctrine, and Metro stays for mobile                                         |
| Removing Node from a mobile project                                     | Expo still needs Node LTS for `create expo` and `expo prebuild`; the boundary itself is N-018                          |
| A Copier `pnpm \| bun` choice                                           | Q4 — every gate and doc would fork in two                                                                              |
| The Python (uv, pip-audit) and Rust (cargo-deny) supply chains          | Unchanged by the swap                                                                                                  |
| Node bundled by basedpyright (`nodejs-wheel`) and the Playwright driver | Each ships its own; no doc may therefore claim "no Node" outright                                                      |
| Authoring `renovate.json` and the Renovate setup                        | MAP-UPSTREAM-TRACKING N-009 owns it; this map only moves its target to Bun's managers, via N-004                       |
| EAS Build adoption and `eas.json`                                       | None exists; paid cloud builds are out of scope per `02-STACK.md`                                                      |
| Rewriting CHANGELOG, RELEASES, VERSION-HISTORY and dated PM records     | Dated records of the tree at their time are never rewritten                                                            |
| The vendored `.agents/skills/cloudinary-react` text (`npm install`)     | Third-party, managed by `skills-lock.json`                                                                             |
| Pre-Bun gate defects found on the way                                   | Put to Sam as `GAPS.md` candidates, 11/09/2026 — this map's only where a slice rewrites the exact lines (N-025, N-029) |
| Collapsing restated doctrines beyond the raw-invocation ban list        | In scope only for that one rule, and only if N-023 chooses route-don't-restate                                         |

---

## Session log

| Date       | Node settled | Outcome                                                                                                                                       | Frontier redrawn |
| ---------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 11/09/2026 | CHART        | Destination pinned (Q1–Q5); 6 surface scouts + an independent critic drew 30 nodes and 5 slices; N-001 dispatched                             | [x]              |
| 11/09/2026 | N-001        | 12 legs answered from Bun's source at `6b394bf`, each survived an independent refuter; 5 run-only legs folded into N-006, N-007, N-009, N-012 | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed (Sam, 11/09/2026)
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 2 closes · 2 blocks · 10 unrelated
- [x] Every claimed entry names what will retire it; nothing closed here (two entries **appended**)
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — 21 open
- [x] Every resolved node links to the artefact it became
- [x] Every slice has a flag manifest — provisional
- [x] Index row — declined on the record (see the header note)

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.**
