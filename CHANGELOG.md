# Changelog

**Last Updated**: <%DATE%> **Version**: 2.0.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 03/08/2026

### Added

- **The planning cadence is now explicit: plan one story at a time, all the way through.** A story runs `02-story-creation` → `14-decisions` before the next one starts, so each story is planned against everything the previous ones settled. The rationale is recorded where the loop lives (`project-management/workflows/CONTEXT.md`): a human thinks the work through at plan time so implementation is mechanical. It assumes real PM and development knowledge — and the gate sequence is what carries someone who does not yet have it.
- **A sprint is planned when it fills, not at the end of a backlog-wide checks phase.** Each story clearing `13` is slotted into the open `SPRINT-##.md` with its points; at `SPRINT_CAPACITY_SP` (grace `SPRINT_GRACE_SP`) planning pauses while `15-sprint-plans` and `16-story-plans` run for that sprint, then resumes. Canonical rules and the ceiling: `project-management/docs/PLANNING-GUIDE.md` → _Sprint Capacity_.
- **Two Copier questions — `SPRINT_CAPACITY_SP` (11) and `SPRINT_GRACE_SP` (13)**, with a validator forcing grace above capacity. These close a real hole: `.claude/agents/sprint.md` already claimed the guide defined a point ceiling, and it never did.
- **`project-management/workflows/01-feature/` and `src/01-FEATURE/` — discovery, once per feature.** Wayfinder charts the feature's decision frontier, then each node is settled one at a time and graduated to an ADR, plan, or story. The resolved `MAP-<FEATURE>.md` is what stories are cut from, and what stops every later grilling pass re-asking the same cross-cutting questions. Its reading order is deliberate: `CONTEXT.md` → `CLAUDE.md` → the relevant `docs/` guides → **the whole of `project-management/src/`** → the codebase. Because every story closes with `IMPLEMENTATION/` records stating where the build diverged from the plan, reading `src/` shows what was actually built rather than what was once intended.
- **`how-to/src/TEMPLATE-GUIDE/09-PROJECT-MANAGEMENT.md`** — how to use `project-management/src/`: the five tiers, the workflow↔`src` mirroring, the three-stage vs two-stage folder patterns, a which-folder-when table, and the four ways people get it wrong. `09-FIRST-STORY.md` became `10-FIRST-FEATURE.md` and now opens by charting the feature, because work no longer starts with a story.
- **`project-management/docs/planning/`** — `CADENCE.md`, `STORIES.md`, `SPRINTS.md`, behind the thin `PLANNING-GUIDE.md` index, on the `GDPR-GUIDE.md` → `gdpr/` precedent. The capacity figure is stated once, in `CADENCE.md`.
- **`project-management/workflows/17-consolidate-design-work/`** — the second half of the per-story bargain. Planning per story means design arrives per story and drifts by construction; once every story is through `15`, this workflow reconciles it into one coherent design before any code. It resolves `04-DATABASE` first, because schema fragmentation is the expensive kind, and its Step 7 corrects any story plan the consolidation invalidated — otherwise the developer codes from a plan asserting a superseded design.

### Changed

- **PM workflows renumbered again, +1 across the board** (`01`–`22` → `02`–`23`) to open `01` for the feature-discovery gate, and `src/` `01`–`20` → `02`–`21` alongside it so the `01`–`16` workflow↔`src` mirroring survives. ~2,455 references across every layer. `code/workflows/` and `how-to/workflows/` numbering is untouched — those are catalogues, where numbers are stable identifiers.
- **`SPRINT-PLANNING-GUIDE.md` → `PLANNING-GUIDE.md` + `planning/`.** The old name had stopped describing its contents once the cadence — which governs `01`–`17`, not sprint planning — moved into it.
- **`12-seo-checks` is now a planning gate, not a verification one.** It sat in the specify tier but required a deployed page, which made it impossible to run in its own slot. It now sets per-dimension SEO targets before the page exists; auditing the built page, Lighthouse, and the `IMPLEMENTATION/` record moved to `21-implementation-documentation`, which already owned every other implementation record. Its model moves Opus → Fable, because choosing a schema type and an indexing posture is judgement, not measurement.

- **`src/04-DATABASE` … `src/08-WIREFRAMES` are now three-stage:** `USER-STORY-IDEAS/` → `CONSOLIDATED-IDEAS/` → `IMPLEMENTATION/`. Stage 1 is **frozen** once workflow `16` runs — it is the audit trail of what each story asked for. Stage 2 is **what gets built**. Each folder keeps one cumulative asset outside the stages (`ERD-DIAGRAMS/`, `DIAGRAMS/`, `guide-build/`, `component-build/`, `SHARED/wireframe.css`); the brand and component PDFs are regenerated once, at consolidation, not per story. `08-WIREFRAMES/SCREENS/` is absorbed into the stage folders.
- **Folders `09-GDPR` … `13-API-DESIGN` keep their two-stage `PLANNING/` + `IMPLEMENTATION/` split.** A lawful basis or an API contract is genuinely per story and does not fragment a shared system, so it needs no consolidation pass.
- **PM workflows `16`–`21` renumbered to `17`–`22`** to make room at `16`. Unlike `code/workflows/` and `how-to/workflows/` — catalogues where numbers are stable identifiers and are never reused — PM workflow numbers are a **running order**, so inserting mid-sequence is legitimate here. 413 references updated across 161 files. Historical entries in this file and `RELEASES.md` are left as written: they record what those releases actually shipped.

### Removed

- **`project-management/docs/SPRINT-PLANNING-GUIDE.md`** — replaced by `PLANNING-GUIDE.md` and `planning/{CADENCE,STORIES,SPRINTS}.md`.
- **`project-management/src/08-WIREFRAMES/SCREENS/`** — absorbed into the three-stage folders: per-story screens to `USER-STORY-IDEAS/`, the built set to `CONSOLIDATED-IDEAS/`.

### Fixed

- **Twenty `IMPLEMENTATION/` folders credited `pr-and-review` for writing their records.** Workflow `21-implementation-documentation` explicitly absorbed that duty — its own `CONTEXT.md` says the PR workflow "now only **verifies** these records". Every one now routes correctly.
- **Three workflows had no grilling pass at all** — brand guides, wireframes, and sprint plans — despite `.claude/CLAUDE.md` §10 making it the default for substantial work. Each now opens with one.
- `.claude/skills/wayfinder/SKILL.md` referenced the map as `` `the project's plans folderMAP-<EPIC>.md` `` — a token substitution that had lost its separator. Maps now resolve to `src/01-FEATURE/`.
- `21-implementation-documentation/CONTEXT.md` was still titled "Workflow 19".

- `PLANNING-GUIDE.md` documented sprint plans as `SPRINT-PLAN-##.md`; `src/15-SPRINT-PLANS/` has always used `{exec-order}-SPRINT-PLAN-{sprint-number}.md`. The guide now matches, and explains why the two segments diverge.
- `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` claimed twenty-one Copier questions; there were twenty-seven before this change and are now twenty-nine.

---

## [1.2.0] - 02/08/2026

### Added

- **An optional native desktop surface, gated by the new `INCLUDE_DESKTOP` question.** A **Slint** application at `code/src/rust/crates/desktop/` — a real native binary, not a webview or an Electron shell. The question is only asked when `INCLUDE_RUST` is true, because Slint is Rust, and both default to `false`.
- **It is a member of the existing Rust workspace, not a second one.** `members = ["crates/*"]` is a glob, so the workspace adapts with no edit and there stays exactly one `rust-toolchain.toml`, one `deny.toml` and one `clippy.toml`. `slint` is pinned in the crate rather than `[workspace.dependencies]`, since one member uses it. Lint, test, audit and build therefore come from the existing Rust script group — `code/src/scripts/desktop/` carries only the two genuinely desktop-specific operations, `run.sh` and `package.sh`.
- **`desktop` agent, `stack-slint` skill, `code/docs/DESKTOP.md` + two sub-docs, and `code/workflows/13-desktop-app/`** — all excluded together with the crate.

### Changed

- **`deny.toml` now carries Slint's licence exceptions and two accepted advisories.** These are unconditional, because no file in this template has conditional contents; on a project without the desktop surface they match nothing and cargo-deny reports an informational note rather than an error.
- **`code/src/` describes four surfaces.** Desktop is a distinct _surface_ (its own delivery target and release cycle) inside a shared _workspace_ — the first time those two ideas come apart in this repository, and worth reading `code/src/CONTEXT.md` for.

### Security

- **Two `quick-xml` advisories (RUSTSEC-2026-0194, -0195) are accepted, with justification and a re-check date.** Both are denial-of-service issues reached **only** through Slint's accessibility stack (`accesskit_unix` → `atspi` → `zbus_xml` → `quick-xml`), and every version pin up that chain to Slint's own `=1.17.1` blocks the patched 0.41.0. The parser handles D-Bus introspection XML from the **local** AT-SPI session bus, not network or user input; an attacker able to publish malicious XML there already owns the session. **Removing AccessKit is not the mitigation** — it is what makes the app usable with a screen reader. Re-check 02/11/2026.
- **`unmaintained` is now scoped to `workspace`.** You can act on your own direct dependency choices; you cannot act on one buried three levels inside a GUI toolkit, and a permanent ignore list of other people's transitive crates rots silently.

### Licensing — read before enabling

- **The app ships under Slint's Royalty-free tier**, which permits proprietary **and commercially sold** desktop applications at no cost, in exchange for **disclosing that you use Slint**. The `AboutSlint` widget is that disclosure and `code/src/scripts/desktop/package.sh` refuses a release build without it — a licence gate, not a lint.
- **The tier does not cover embedded systems** (an appliance screen, a POS terminal, a car dashboard), **nor redistributing anything that exposes Slint's own APIs.** The second is why desktop UI is never moved into a shared package layer, and why desktop panels are duplicated across applications rather than shared. That duplication is a deliberate, priced decision.
- This is a reading of the licence text, not legal advice.

### Fixed

- Nothing. No defect is addressed in this release.

---

## [1.1.0] - 02/08/2026

### Added

- **An optional Rust surface, gated by the new `INCLUDE_RUST` question.** A Cargo workspace at `code/src/rust/` for PyO3 extension modules, standalone binaries, CLI tools and services — with `nativecore`, a baseline PyO3 crate, as its first member. It follows the `INCLUDE_MOBILE` precedent exactly: templated `_exclude` entries are the single conditionalisation mechanism, no file gains templated contents, and the indexes list the new rows unconditionally with a **rust-only** flag. A project generated with `INCLUDE_RUST: false` gets **no new or removed files** — verified by diffing a `1.1.0` web-only generation against a `1.0.0` one. Sixteen files differ in content: the documentation indexes gaining flagged rows, the version metadata, and one comment in `pyproject.toml`. The tree is unchanged; it is not byte-identical, and that distinction matters when reviewing a `copier update` diff.
- **The flag gates authoring, not consuming.** A project that merely depends on a prebuilt PyO3 wheel installs it like any other dependency and needs no toolchain — it answers `false`. `true` means _this repository compiles Rust_, which makes `rustup` a prerequisite for `uv sync` and adds a Rust stage to the backend image. That cost is why the default is `false`, and why the distinction is stated in `TEMPLATE-TOKENS.md`, `05-ANSWERS.md`, the guide, the skill and the agent.
- **`rust` agent and `stack-rust` skill**, excluded together with the tree — a Rust agent with no Rust to work on is worse than no agent at all. Both carry the gate question as their opening move: Rust earns its place only on a guarantee Python cannot make, or a **measured** hot path.
- **`code/docs/RUST.md` and three sub-documents** — `rust/PYO3-BOUNDARY.md` (never panic across FFI, thin-boundary shape, error mapping, the GIL, `abi3`), `rust/MEMORY-HYGIENE.md` (why Python cannot erase a secret, zeroize-on-drop, constant-time comparison, and the limits it does _not_ cover — copies, swap, core dumps), and `rust/SUPPLY-CHAIN.md` (why a crate is more dangerous than a Python package, and what `deny.toml` enforces).
- **`code/workflows/12-rust-extension/`** — appended, never renumbered, per the stable-identifier rule. Entered from PM `18-backend-code`; Step 1 is a grilling pass whose first question is the gate.
- **`code/src/scripts/rust/`** — `build.sh`, `test.sh`, `lint.sh`, `audit.sh` plus `_common.sh`. The second script group keyed by stack rather than operation, and the second to run on the host rather than in Docker; the toolchain pin is what keeps a host run and the image's build stage identical.
- **`syntax-rust.yml`** — clippy at `-D warnings`, the Rust test suite, and `cargo-deny`. The workflow file is itself rust-only, so there is no job to guard on a project without the surface.
- **`code/docs/encryption/RUST-CRYPTO.md`** — the dual-path branch of the encryption guide.

### Changed

- **`code/src/` now describes three surfaces rather than two.** The native surface is the odd one: it has no separate runtime, because a PyO3 extension is loaded **into** the web surface's process and shares its address space. That is precisely why its supply chain is gated harder than any Python dependency.
- **Fernet remains canonical for field encryption.** Native crypto is a branch for what Fernet structurally cannot do — constant-time comparison, and wiping key material Python cannot erase — never a replacement. Keeping the two paths separate is deliberate: two implementations of the _same_ concern is a parity burden that drifts, whereas two covering _different_ concerns is a boundary. It also keeps `syntek-base` usable by anyone outside <%ORG_NAME%>, which a hard dependency on a private wheel would not.

### Fixed

- Nothing. No defect is addressed in this release.

---

## [1.0.0] - 02/08/2026

### Changed

- **The template is now stable.** The root version track leaves `0.x` and enters `1.0.0`. Nothing in the generated project changes as a consequence — this release is a **statement about support, not a code change**. The surface a generated project inherits is exactly the one 0.14.0 produced, and the two are functionally identical.
- **What `1.0.0` commits to.** From here the Copier answer file (`copier.yml`'s twenty-two questions, or twenty-four with the mobile surface), the three-layer directory contract (`code/` · `how-to/` · `project-management/`), the `CONTEXT.md` + `CLAUDE.md` pairing rule, and the numbered workflow identifiers are treated as the template's public interface. A breaking change to any of them now requires `2.0.0`, which is the guarantee the `0.x` track could not offer — under semver, `0.x` permits a breaking change in any minor bump, and this template used that latitude repeatedly (the workflow renumbers in 0.14.0 and the PM renumber in 0.8.0 would each have been a major bump under this policy).
- **The `0.1.0`–`0.14.0` track is reclassified as pre-release history.** Those fourteen versions are published as GitHub pre-releases; `1.0.0` is the first entry marked latest. The reclassification is presentational — the commits, the changelog entries and the release notes are unchanged.

### Removed

- **`.claude/MEMORY.md` emptied of its template-development entries.** It carried five notes accumulated while `syntek-base` itself was built — the "surface" vocabulary, the one-way optional-content gate, the Expo pin matrix, the `glob` override, and the expo-router route-collision rule. Every one is reasoning about **how the template was constructed**, which a generated project inherits as noise: it describes decisions already made, in a repository the reader is not working in. The file ships with its three headings (`Feedback`, `Project Patterns`, `Project State`) and its write-policy preamble intact, so a generated project starts recording against an empty store rather than deleting someone else's notes first. Where that reasoning is durable it already lives in the right place — `code/src/CONTEXT.md` defines _surface_, and `how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md` holds the gating rationale.

### Fixed

- Nothing. No defect is addressed in this release; `0.14.0` is the last release carrying fixes.

---

## [0.14.0] - 02/08/2026

### Added

- **`code/docs/MCP-SERVER.md` and its `mcp-server/` sub-tree** — the design of record for a FastMCP tool surface at `/mcp/`, serving LLM agent clients beside Django Ninja's `/api/`. Four sub-documents: `MOUNTING.md` (the `config/asgi.py` Starlette composition), `TOOL-DESIGN.md` (tools over the service layer), `AUTH-AND-THREATS.md` (`TokenVerifier` and the MCP threat model), `TESTING-AND-OPS.md` (in-memory `Client` tests, observability, rollout). **Nothing is mounted and `fastmcp` is not a declared dependency** — the same available-but-unwired status Django Ninja itself holds.
- **The two-adapter rule, stated once.** MCP tools and Ninja endpoints are peers over one service layer; neither calls the other and neither holds logic. Ninja alone made that seam hypothetical — a second adapter makes it real.
- **`.claude/skills/stack-fastmcp/`** — the MCP idioms, loaded on demand by `backend` (tools), `security` (the threat surface) and `test-writer` (in-memory client tests). No new agent: MCP tools are backend service-layer work, and the roster stays non-overlapping.
- **Five new `how-to/` workflows**, each mapping onto scripts that already exist: `04-database-operations` (backup, restore, reset, seed, users — 8 scripts that had no workflow), `05-testing-and-coverage` (8 runners), `06-quality-gates` (the 8 pre-PR gates + 7 audits), `07-dependency-updates`, and `09-write-operator-guide` — the meta-workflow for authoring operator documentation.
- **`.claude/agents/operator-docs.md`** — a specialist owning `how-to/docs/*` and `how-to/src/*`. Justified by three testable differences from `doc-writer`: different audience (running the system vs writing code), different length standard (`how-to/src/` is the sanctioned exemption from the 300-line cap), and different verification (a runbook is proven by executing it). Completes a three-way split with `support-articles`, which owns end-user help.
- **`.claude/skills/runbook/`** — the operator-doc craft: the fixed spine (purpose → prerequisites → steps with expected output → failure modes → rollback → verification), script-first command discipline, and the execute-to-verify rule.
- **`code/workflows/05-mcp-server/`** — the procedure, opening with a gate question (is an agent genuinely the caller, or would an HTTP client do?) and running through mount, verifier, tools, tests and hardening. Entered from PM `19-api-code`, never from a design gate.
- `/api/` and `/mcp/` documented as **machine prefixes** in `code/docs/URL-STRATEGY.md`, which previously named only the four human-facing surfaces. `/mcp/` is a sibling of `/api/`, never nested inside it.
- `fastmcp` added to the "deliberately NOT declared at baseline" register in `pyproject.toml`, with its trigger condition — an agent must carry out this project's domain operations, **not** "expose the API to AI".

### Changed

- `backend`'s remit widened from "Django Ninja endpoints" to "Django Ninja endpoints and the FastMCP tool adapter"; `security` and `test-writer` gained MCP routing lines. `code/workflows/CLAUDE.md` now describes eleven workflows, not ten.
- `config/CONTEXT.md` records that `asgi.py` is the one file an MCP surface changes, and that the mount sits outside Django's middleware chain.
- **The nine how-to workflows regrouped into four families** — set up (`01`–`02`), run (`03`–`07`), diagnose (`08`), author (`09`) — matching the shape the code layer now has. `02-daily-development` → `03`, `03-debugging` → `08`, `04-worktree-setup` → `02`; `01-first-time-setup` kept its number.
- **`doc-writer`'s remit now explicitly excludes `how-to/`**, and `how-to/src/CLAUDE.md` no longer routes there — it previously named `doc-writer` against that agent's own stated scope of `code/docs/*`, a contradiction that had gone unnoticed.
- `how-to/workflows/CLAUDE.md` corrected from "three-file shape" to four — every workflow here has carried a `CLAUDE.md` as well since the pairing rule landed.
- **The eleven code workflows renumbered into three families** — build (`01`–`06`), verify (`07`–`08`), diagnose & improve (`09`–`11`). Within build the layers now read bottom-up (`03` data → `04` `/api/` → `05` `/mcp/`); within diagnose they read in handoff order (`09` find → `10` fix → `11` improve). `01-new-feature`, `02-tdd-cycle` and `04-api-design` keep their numbers; the other eight moved. The mapping was circular (`03`→`08`, `08`→`11`, `09`→`03`), so the rename went through a temporary namespace.
- The renumber touched **282 path tokens across 117 files** plus 12 bare-number references that carry no slug (`.claude/CLAUDE.md` §2.4, `code/docs/CODE-REVIEW-GRAPH.md`, and two workflow `CLAUDE.md` files). Historical `CHANGELOG.md` / `RELEASES.md` entries were deliberately **not** rewritten — they record the paths as they stood at that release.
- **`09-debugging-with-logs` and `10-debug` are now adjacent**, which is the defect that motivated the change: they are two halves of one activity (`09` locates a fault, `10` fixes it and proves the fix), they reference each other five times, and `09/STEPS.md` ends by handing over to `10` — yet they previously sat three positions apart with unrelated workflows between them.
- `code/workflows/CONTEXT.md` regrouped into the three families, and now states outright that **these numbers are stable identifiers, not a sequence** — append a workflow, never renumber one. Roughly 110 files cite these paths, and a stale number in an agent definition is a silent routing failure.

### Fixed

- **`.copier/README.md` shipped a workflow table whose `#` column had decoupled from the workflow names** — row `03` pointed at `08-security-hardening/`, row `09` at `03-database-migration/`. The renumber sweep corrected every slug but had no way to know a separate hand-maintained column encoded the same number. Every generated project would have carried it. Rebuilt as a family-grouped table, along with both directory trees (`10 coding workflows` → 11, `4 operational` → 9) and the "three files" claim (workflows carry four).
- **Stale hard counts removed from `README.md`, `01-OVERVIEW.md` and `07-REPO-TOUR.md`** — "50 agents" (52), "16 skills" (23), "15 GitHub Actions workflows" (17). The 0.13.0 release deliberately removed such counts because one differs between two correct projects once the roster is conditional; that removal reached `08-CLAUDE-CODE.md` and missed these three, which had gone stale exactly as predicted. The Copier question count is now stated accurately as twenty-two, or twenty-four with the mobile surface, rather than the stale "twenty-one".
- `07-REPO-TOUR.md` described the code workflows as a **range** ending at `10-debugging-with-logs`; the sweep renumbered that token to `09`, leaving a semantically wrong but syntactically valid endpoint. A path check cannot catch this class of error.
- `12-EXTENDING.md`'s "An MCP server" section was about servers the project **consumes** via `.mcp.json`, and would now be read as covering the FastMCP surface the project **serves**. Split into two sections.

- **Six of the eight `claude.yml` quality gates failed on every push and pull request** raised against this template — `uv sync --frozen` cannot resolve without a `uv.lock`, which is absent by design here because it would pin the root project under the literal project-slug token. Each now carries the same `Detect the backend lockfile` step `test.yml` already used, guarded at **step** level so the JS half (Prettier, ESLint, `pnpm audit`) keeps gating this repository rather than being thrown away with the Python half.
- `audit-deps.yml` failed on its nightly schedule for the same reason, opening a tracking issue about a Python dependency tree that does not exist yet. The JS half is unguarded and keeps its nightly CVE scan.
- `clickup-sync.yml` failed whenever triggered: the template ships `US000-TEMPLATE.md` and no real stories, so `export/clickup/` holds no `US###-CLIENT.md` files and `sync-clickup.sh` exits 2 on preflight. Now guarded on the exports existing. This is **not** the missing-credentials case — the script already degrades to a dry run for that by itself.
- All three `syntax-python.yml` jobs failed at `astral-sh/setup-uv@v4`, a stale action pin with no explicit version while every other workflow here uses `@v5` with `UV_VERSION`. Fixed rather than skipped: these jobs run `uv sync` **without** `--frozen`, so they need no lockfile and are the one Python gate this repository genuinely enforces on itself.

---

## [0.13.0] - 02/08/2026

### Added

- **The opt-in React Native mobile surface.** `INCLUDE_MOBILE` (default `false`) gates a bootable Expo application at `code/src/mobile/` — Expo SDK 57 with Continuous Native Generation, expo-router, TypeScript, one placeholder route, and no binary assets. Answering no produces a repository functionally identical to 0.12.0's output.
- `MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID` Copier questions, asked only when the mobile surface is included; the bundle ID defaults to the primary domain, label-reversed.
- `code/src/scripts/mobile/` — `install.sh`, `server.sh`, `lint.sh`, `typecheck.sh`, `test.sh` and `bundle.sh`, plus a shared `_common.sh`. Metro runs on the **host**, the one dev operation that is not containerised, because Expo Go on a physical device cannot reach a loopback alias.
- Four mobile CI jobs — `jest-expo + coverage` and `Bundle export` in `test.yml`, `ESLint (mobile surface)` and `TypeScript (mobile surface)` in `syntax-js-ts.yml` — each guarded at **step** level so a web-only project reports green rather than skipped.
- `.claude/agents/mobile.md` and `.claude/skills/stack-react-native/` — the mobile governance pair, excluded with the tree.
- `code/docs/design-tokens/MOBILE.md` — the design-token bridge: six colour forms with OKLCH canonical and five derived on write, CSS Color 4 gamut mapping, 8-digit hex for mobile, the `render_tokens_ts()` emitter, and which three preference axes collapse to BASE.
- `code/docs/accessibility/MOBILE.md` — the React Native technique set for the unchanged WCAG 2.2 AA standard, including why verification here is manual.
- `code/src/scripts/audits/mobile-tokens.sh` and `.github/workflows/audit-mobile-tokens.yml` — the mobile half of the token-first law. Self-guarding: exits 0 with a note when there is no mobile surface.
- `code/src/mobile/CHANGELOG.md`, `VERSION-HISTORY.md` and `RELEASES.md` — the mobile application is a third independent semver track, starting at 0.1.0.
- Mobile-flagged steps in `project-management/workflows/20-frontend-code/` (Step 4M), `code/workflows/01-new-feature/` (Step 7M) and `code/workflows/02-tdd-cycle/`, plus the mobile wireframe convention in `project-management/src/08-WIREFRAMES/`.

### Changed

- **Five documented invariants narrowed in scope, not in force**, to "the web surface" — `code/src/CLAUDE.md`, `code/src/CONTEXT.md`, `eslint.config.mjs`, `project-management/src/CONTEXT.md` and `code/docs/RENDERING.md`. A mobile app is a separate deployable, not a bundler for Django pages, so `RENDERING.md`'s "there is no fourth row" survives verbatim.
- **"Surface" became load-bearing vocabulary**, defined once in `code/src/CONTEXT.md` → _Surfaces_. Silence still means the web surface.
- `test-backend.yml` renamed **`test.yml`** to hold both surfaces' test jobs, and its path filters dropped — a path-filtered required check never reports and would silently stop gating mobile.
- `audit-template.yml` now runs **both** `INCLUDE_MOBILE` values through every assertion, plus two new ones: the opt-in is obeyed in both directions, and every shared file is byte-identical across the render paths.
- Jinja comment delimiters moved from the vertical-bar pair to a tilde pair, because the old opening sequence collided with TypeScript union types and would have swallowed a generated declaration. No committed file used it as a real comment, so nothing behavioural changed. The sequences themselves are quoted in `how-to/src/TEMPLATE-GUIDE/`, which is excluded from rendering and is the only place they can appear literally.
- `VERSIONING-GUIDE.md` documents the mobile track and its **two-files-one-number** rule (`package.json` and `app.json`); the `version` agent learned it, and its stale `backend`/`frontend`/`shared` sub-package list was corrected.
- `code/docs/testing/COVERAGE.md` reworded from "one floor, not one per layer" to **one standard, enforced once per runtime** — `coverage.py` and Jest share no accumulator.
- **Hard agent counts removed rather than incremented** across `.claude/CLAUDE.md`, `CONTEXT.md`, `.claude/CONTEXT.md`, `how-to/docs/TOOLING-GUIDE.md` and `TEMPLATE-GUIDE/08-CLAUDE-CODE.md` — a count differs between two correct projects once the roster is conditional, and one was already stale.
- `project-management/workflows/08-wireframes/` corrected to match the artefact folder it drives: self-contained HTML screens named `WF-###-<Screen-Name>.html`, not `WF-US###-<DESCRIPTOR>.md`, and Figma/Excalidraw are no longer offered as alternative media.

### Fixed

- `@jest/reporters>glob` repinned from `^7.1.6` to `^9.3.5`, removing `inflight@1.0.6` from the tree. The constraint is an interop shape, not a version floor: glob 10 and 11 set `__esModule` with no `default` export, so `.default.sync` is undefined and the Jest 29 coverage reporter dies. glob 9 is the newest version that still works.

### Security

- `inflight@1.0.6` — an unbounded-memory-leak package — no longer appears anywhere in the dependency tree.

---

## [0.12.0] - 02/08/2026

### Added

- `copier.yml` — the executable template contract: twenty-one questions with derived defaults and validators, custom Jinja delimiters, exclusion rules, and four post-generation tasks. Replaces `setup.sh`.
- `.copier-answers.yml` — rendered into every generated project so `copier update` can three-way-merge later template improvements into live projects.
- `.copier/README.md` — the generated project's README, moved out of the repository root so the root README can describe the template itself.
- `LICENSE` — MIT. The template no longer withholds a licence; `<%LICENCE%>` remains a token so a generated project still chooses its own.
- `SECURITY.md` — private vulnerability disclosure policy, scoped to the realistic risk of an insecure default propagating into every generated project.
- `CONTRIBUTING.md` at the root — the external contributor front door, distinct from `how-to/src/CONTRIBUTING.md` which holds the standards applying inside a generated project.
- `.github/CODEOWNERS`, `.github/PULL_REQUEST_TEMPLATE.md`, and `.github/ISSUE_TEMPLATE/` (bug report, template improvement, config).
- `.github/workflows/audit-template.yml` and `.github/scripts/check-template-tokens.sh` — two unconditional CI gates: token-syntax integrity, and a full generation smoke test asserting zero surviving tokens, no template-only leakage, and intact `${{ }}` / `[[ ]]` syntax.
- `how-to/src/TEMPLATE-GUIDE/` — fourteen numbered guides plus a `CONTEXT.md`/`CLAUDE.md` pair, covering overview, stack, prerequisites, quickstart, answers, generation, repository tour, Claude Code, first story, customising, extending, deployment, updating, and troubleshooting.
- `how-to/src/CONTRIBUTING.md` — the contributing and code-quality standard, lifted out of `how-to/src/CONTEXT.md`.
- Host platform and container-runtime detection in `install.sh` — distinguishes Linux, macOS, WSL and native Windows, accepts Docker Desktop or Colima on macOS, rejects non-WSL Windows shells, and warns on WSL 1 and on repositories living under `/mnt/c`.

### Changed

- **Token delimiters replaced** — swept across 433 files. Jinja's default double-brace delimiters collide with GitHub Actions expressions (`${{ }}`), Django template syntax, and Bruno variables; double-square-bracket was rejected in turn because it is bash test syntax. The replacement variable, block and comment delimiters were each verified absent from the tree before adoption — see `how-to/src/TEMPLATE-TOKENS.md` for the set and the reasoning.
- `README.md` rewritten template-facing and literal — 1160 lines to 140 — describing syntek-base rather than impersonating a shipped product, and indexing the guide set.
- `how-to/src/CONTEXT.md` is now a genuine orientation index rather than a 239-line guide.
- `how-to/src/TEMPLATE-TOKENS.md` rewritten as the contract `copier.yml` implements, including the delimiter rationale.
- Licence language in `how-to/src/CONTEXT.md`, `how-to/src/CLAUDE.md` and the project README now keys off `<%LICENCE%>` instead of asserting proprietary.
- `how-to/CONTEXT.md` and `how-to/REFERENCES.md` corrected — the tree had drifted, omitting every `CLAUDE.md`, `CELERY-FIRST-RUN.md`, `FEATURE-DEPLOY.md`, and `TEMPLATE-TOKENS.md`.
- Deployment documentation made provider-neutral: any Linux host with Docker will serve the application; Hetzner, NixOS and Cloudflare are named as the target the runbooks are written against, not a requirement.
- The Claude Code guide now distinguishes grilling from wayfinder, and the plan requirement (Fable tier) is stated in the README, prerequisites and Claude Code guides.

### Removed

- `setup.sh` — superseded by Copier. Its literal string substitution had no update path, which is the capability the migration exists to gain.

### Fixed

- Two tokens corrupted by Prettier's Markdown formatter, which pairs the underscore inside a token name with nearby `_emphasis_` and rewrites both. A corrupted token renders as an undefined variable and vanishes silently from every generated project.
- Literal token delimiters written in prose inside `how-to/src/CLAUDE.md`, a rendered file — Jinja parsed them and generation failed outright with `TemplateSyntaxError`.
- `_exclude` patterns anchored to the repository root. They use gitignore semantics, so an unanchored `README.md` also matched `.copier/README.md`, and `CONTRIBUTING.md` would have swallowed `how-to/src/CONTRIBUTING.md`.

### Security

- Branch protection on `main` via a repository ruleset — pull request required, conversation resolution required, force-push and deletion blocked, and eleven required status checks. Administrators may bypass, so solo merges still work.
- Private vulnerability reporting enabled on the repository, matching the disclosure route `SECURITY.md` documents.

---

## [0.11.0] - 01/08/2026

### Added

- Root `CONTEXT.md` — the project overview: directory tree, layer map, starting points, conventions, and repository state. Reinstates the orientation file retired in 0.10.0.

### Fixed

- `.claude/CLAUDE.md` line 6 imports `@../CONTEXT.md`, which resolved to nothing after 0.10.0 removed the file. The import now loads on every session as intended.

---

## [0.10.0] - 01/08/2026

### Added

- `REFERENCES.md` — the root reference index covering every layer entry point, guide, workflow, and external standard.
- `DEFERRED.md` — the register of work deliberately deferred, alongside `GAPS.md` for active blockers.
- `setup.sh` and a rewritten `install.sh` — resolve the template placeholders and prepare a scaffolded project.
- `skills-lock.json` — installed Claude Code skills with their versions and hashes.
- `.github/workflows/audit-css-tokens.yml`, `audit-css-gradients.yml`, `audit-copy-emdash.yml`, `audit-secrets.yml`, and `audit-deps.yml` — CI wiring for the audit scripts added in 0.4.0.
- `.github/workflows/claude.yml` and `clickup-sync.yml` — the Claude Code review pipeline and the ClickUp story export sync.
- `.zed/settings.json` — editor configuration shipped as part of the template's tooling surface.
- `handoffs/`, `learning/`, and `research/` — session sandboxes for the handoff, teach, and research skills, each with `CONTEXT.md` and `CLAUDE.md`.

### Changed

- Hardcoded project identifiers replaced with substitution placeholders throughout the root files — `<%PROJECT_NAME%>`, `<%PROJECT_SLUG%>`, `<%ORG_NAME%>`, `<%ORG_SLUG%>`, `<%DEVELOPER_NAME%>`, `<%LOCALE%>`, `<%TIMEZONE%>`, `<%CURRENCY%>`, `<%LICENCE%>`, and `<%DATE%>`.
- `README.md` rewritten for the Django-only monolith; the version badge and footer set to `0.10.0`.
- `DESIGN.md` and `GAPS.md` rewritten around the token-first design system and the template's open items.
- `package.json`, `pnpm-workspace.yaml`, and `pnpm-lock.yaml` reduced to the tooling dependencies that survive without a JavaScript application.
- `eslint.config.mjs`, `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`, and `.npmrc` re-scoped to the remaining file types.
- `lefthook.yml` — pre-commit hooks re-pointed at the Django tree, with a self-gating ClickUp export step and an advisory code-review-graph pass.
- The six surviving CI workflows re-pointed at `code/src/django/` and the rewritten script surface.

### Removed

- Root `CONTEXT.md` — superseded by `REFERENCES.md` as the root index.
- `LICENCE` — a base template does not choose a licence on behalf of the project scaffolded from it; the placeholder `<%LICENCE%>` is resolved at setup.
- `CONTRIBUTING.md` — superseded by the PM layer's git, PR, and review workflows.

---

## [0.9.0] - 01/08/2026

### Added

- `how-to/docs/AI-DICTIONARY.md` with `ai-dictionary/` — plain-English definitions across `THE-MODEL.md`, `SESSIONS-CONTEXT-AND-TURNS.md`, `TOOLS-AND-ENVIRONMENT.md`, `MEMORY-AND-STEERING.md`, `PATTERNS-OF-WORK.md`, `HANDOFFS.md`, and `FAILURE-MODES.md`.
- `how-to/docs/TOOLING-GUIDE.md` with `tooling-guide/` — `COMMANDS.md`, `CONFIGURATION.md`, and `WORKFLOW.md` covering the internal agents and skills.
- `how-to/docs/GIT-WORKTREES.md`, `SKILL-AUTHORING.md`, `CELERY-FIRST-RUN.md`, and `FEATURE-DEPLOY.md`.
- `how-to/workflows/04-worktree-setup/` — a complete workflow (`CONTEXT.md`, `STEPS.md`, `CHECKLIST.md`, `CLAUDE.md`) for running parallel stories in isolated worktrees and Docker stacks.
- `how-to/src/SCALE-ARCHITECTURE/` — `OVERVIEW.md`, `LOAD-PROFILES.md`, `SIZING-ENVELOPE.md`, `READINESS.md`, and `TOPOLOGY.md` for sizing a deployment against a target user count.
- `how-to/src/SERVER-ARCHITECTURE/` — `OVERVIEW.md`, `COMPUTE-ALLOCATION.md`, `EDGE-REQUIREMENTS.md`, and `NIXOS-HANDOFF.md`, the interface to the NixOS deployment repository.
- `how-to/src/NIXOS-SETUP.md`, `how-to/src/TEMPLATE-TOKENS.md`, `how-to/REFERENCES.md`, and `CLAUDE.md` operating-rules files throughout the layer.

### Changed

- `how-to/docs/DEVELOPMENT.md`, `CLI-TOOLING.md`, and the three existing workflows rewritten for the Django-only stack and the rewritten script surface.
- `how-to/CONTEXT.md` updated for the new document set and workflow `04`.

### Removed

- `how-to/docs/SYNTEK-GUIDE.md` and `how-to/docs/API-TESTING.md` — project-specific or superseded by the code-layer testing guides.
- Nine narrow contributor guides under `how-to/src/` — `BRANCH-GUIDE.md`, `COMMIT-GUIDE.md`, `PR-GUIDE.md`, `CODE-REVIEW.md`, `ISSUE-REPORTING.md`, `ENV-SETUP.md`, `GETTING-STARTED.md`, `CLAUDE-MULTILAYER.md`, and `API-TESTING.md` — each duplicated an authoritative guide in the code or PM layer.

---

## [0.8.0] - 01/08/2026

### Added

- `project-management/src/` renumbered to `00`–`20` across three tiers — specify (`02-STORIES` … `13-API-DESIGN`), decide and plan (`14-DECISIONS`, `15-SPRINT-PLANS`, `16-STORY-PLANS`), and record (`17-TESTS` … `21-REFACTORING`).
- `project-management/workflows/` extended to `01`–`21`, adding `13-api-design`, `14-decisions`, `15-sprint-plans`, `16-story-plans`, the `16`–`18` implementation phases, `21-implementation-documentation`, `22-pr-and-review`, and `23-release`.
- `project-management/docs/gdpr/` — `COMPLIANCE.md` and `DATA-RIGHTS.md`, with `GDPR-GUIDE.md` reduced to a thin index over them.
- `project-management/export/clickup/` and `clickup-task-map.json` — the read-only client export surface regenerated from source stories by the pre-commit hook.
- `project-management/src/00-ASSETS/scripts/` — the export and sync family: `export-clickup-stories.sh`, `export-design-docs.sh`, `export-pm-files.sh`, `export-wireframes.sh`, `sync-clickup.sh`, and the self-gating `precommit-clickup.sh`.
- `CLAUDE.md` operating-rules files for the layer root, `docs/`, every `src/` artefact folder, and every numbered workflow.

### Changed

- All eight PM guides rewritten for the Django-only stack — `GIT-GUIDE.md`, `VERSIONING-GUIDE.md` (now a two-tier scheme with the django sub-package), `SEO-CHECKLIST.md`, `SECURITY-GUIDE.md`, `QA-GUIDE.md`, `PLANNING-GUIDE.md`, `GDPR-GUIDE.md`, and the `RESPONSIVE-DESIGN.md` redirect stub.
- `project-management/CONTEXT.md` and `REFERENCES.md` rewritten around the three-tier structure and the cross-layer workflow pairing map.
- Story, sprint, and plan templates re-expressed with template placeholders in place of project-specific content.

### Removed

- The pre-renumbering artefact folders `00-DECISIONS/`, `00-PLANS/`, `13-SPRINT-PLANS/`, `14-TESTS/`, `15-REVIEWS/`, `16-BUGS/`, and `17-REFACTORING/` — superseded by their renumbered equivalents.
- The organisation's logo exports (`00-ASSETS/LOGOS/` at 8k, HD, and SVG) and the project's twelve ERD diagrams (`00-ASSETS/ERD-DIAGRAMS/`) — a template ships the asset pipeline, not one organisation's brand or one project's schema.

---

## [0.7.0] - 01/08/2026

### Added

- `code/docs/DATABASE.md` — scope columns, database-level invariants, lock-safe migration patterns, search, and the deferred-infrastructure register.
- `code/docs/DESIGN-TOKENS.md` with `design-tokens/` (`MODEL.md`, `CASCADE.md`, `EDITOR.md`) — the database-canonical token system that component CSS may only consume through `var(--token)`.
- `code/docs/RENDERING.md` with `rendering/` — where each interaction runs: server template, HTMX, or Alpine.
- `code/docs/VISUAL-DESIGN.md`, `BACKEND-CODING-PRINCIPLES.md`, and `FRONTEND-CODING-PRINCIPLES.md`.
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore, debug, review, and refactor playbooks for the code-review-graph MCP server.
- Sub-folders splitting every oversized guide: `accessibility/`, `api-design/`, `architecture/`, `coding-principles/`, `data-structures/`, `encryption/`, `logging/`, `performance/`, `responsive/`, `rls/`, `security/`, and `testing/`.
- `code/docs/cloudinary/` — the Cloudinary Python SDK and cross-SDK reference index.
- `code/REFERENCES.md` and `CLAUDE.md` operating-rules files for the code layer root, `code/workflows/`, and all ten numbered workflows.

### Changed

- All fourteen existing `code/docs/*.md` guides rewritten for the Django-only stack and reduced to thin indexes over their sub-folders where they exceeded the 300-code-line instructional limit.
- All ten `code/workflows/` procedures re-pointed at the Django tree, the rewritten script surface, and the paired project-management workflows.
- `code/CONTEXT.md` — directory tree and layer map updated for the single-stack monolith and the 750-line source file limit.

---

## [0.6.0] - 01/08/2026

### Added

- `.claude/agents/` — 50 agent definitions in two tiers: 8 orchestrators (`bugfix`, `feature`, `pr`, `refactor`, `release`, `review`, `security`, `story`) plus the specialists and document writers they delegate to.
- `.claude/skills/` — the internalised skill library: `stack-django`, `stack-htmx-templates`, `global-workflow`, the `grilling` engine with its `grill-me` and `grill-with-docs` wrappers, `codebase-design`, `domain-modelling`, `improve-codebase-architecture`, `scale-planning`, `teach`, `wayfinder`, `handoff`, `prototype`, `research`, `legal-documents`, and `msp-scp-documents`.
- `.claude/MEMORY.md` — the project memory store that replaces the global auto-memory system.
- `.claude/CONTEXT.md` — orientation for the configuration directory.
- `.claude/hooks/pre-pr-check.sh` — the eight-gate quality check run before a pull request is marked ready; `post-pr-comment.sh` posts the structured result summary.
- `.claude/hooks/pre-compact-handoff.sh` — intercepts auto-compaction so a session writes an explicit handoff document instead of silently compacting.
- `.agents/skills/cloudinary-docs`, `cloudinary-react`, and `cloudinary-transformations` — Cloudinary SDK skill references.
- `CONTEXT.md` and `CLAUDE.md` pairs for the hooks and plugins directories.

### Changed

- `.claude/CLAUDE.md` — rewritten around the Django-only stack, the two-tier agent model, the Fable/Opus model allocation, the templatised project placeholders, and the non-negotiable rules (token-first CSS, database-enforced invariants, lock-safe migrations, and the docs hard gate).
- `.claude/settings.json` — auto-compaction disabled, dynamic workflows enabled, the Opus model and extra-high effort level pinned, and both marketplace plugins disabled.
- `.claude/hooks/lib/check-*.sh` — the eight shared check scripts re-pointed at the Django tree and the rewritten script surface.

### Removed

- `.claude/commands/` — seven slash commands (`codegen`, `dev`, `migrate`, `production`, `schema`, `staging`, `test`) superseded by the runners under `code/src/scripts/`.
- `.claude/hooks/pr-gate.sh` and `pr-comment.sh` — replaced by `pre-pr-check.sh` and `post-pr-comment.sh`.
- `.claude/plugins/chrome-tool.py`, `ddev-tool.py`, `docker-tool.py`, and `quality-tool.py` — plugins that ran dev operations; those now belong exclusively to the shell scripts.

---

## [0.5.0] - 01/08/2026

### Added

- `code/src/tests/api/environments/*.bru` — native Bruno environment files for `local`, `host`, `docker`, `staging`, and `production`, alongside the retained JSON definitions.
- `code/src/tests/api/environments/host.json` — the host-machine environment, for running the suite outside the Docker network.
- `code/src/tests/template-test.bru` — a single annotated request template that every new Bruno suite is copied from, relocated from `api/template-test.bru`.
- `code/src/improvement-architecture/` — scratch area for architecture improvement reports; contents are git-ignored, orientation files are tracked.
- `CLAUDE.md` operating-rules files for `code/src/tests/`, `code/src/tests/api/`, `code/src/tests/api/environments/`, and `code/src/logs/`.

### Changed

- `code/src/tests/api/bruno.json` and the `docker`, `staging`, `production`, and `variables` JSON environments re-pointed at the Django service and its `/api/` prefix.
- `code/src/tests/CONTEXT.md`, `api/CONTEXT.md`, and `logs/CONTEXT.md` rewritten for the template layout.

### Removed

- The illustrative Bruno collections — `api/auth/`, `api/orders/`, `api/users/`, and `api/performance/` — a template ships no domain fixtures.
- `code/src/tests/api/template-test.bru` — relocated up one level to `code/src/tests/template-test.bru`.

---

## [0.4.0] - 01/08/2026

### Added

- `code/src/scripts/_lib/` — shared shell helpers, including `worktree-detect.sh` for resolving the active worktree and its Docker project name.
- `code/src/scripts/audits/` — `css-tokens.sh` (enforces that component CSS only consumes resolvable `var(--token)` values), `css-gradients.sh`, `copy-emdash.sh`, and `security.sh`.
- `code/src/scripts/development/new-django-view.sh` — scaffolds a public page as a Django view, template, and URL entry; the only supported way to add a page route.
- `code/src/scripts/development/hosts-story-add.sh` and `hosts-story-remove.sh` — manage per-story loopback host entries for parallel worktrees.
- `code/src/scripts/development/install.sh`, `install-backend.sh`, `install-frontend.sh`, and `pnpm-update.sh` — dependency installation and update runners.
- `code/src/scripts/database/seed-dev.sh` and `verify-db-security.sh` — development seeding and a row-level-security and grant verification pass.
- `code/src/scripts/tests/e2e-py.sh` (Playwright driven from the Django tree), `server.sh`, and `mutmut.sh` for mutation testing.
- `CLAUDE.md` operating-rules files for the script root and every script sub-directory.

### Changed

- Every runner under `database/`, `deployment/`, `development/`, `syntax/`, and `tests/` re-pointed from `code/src/backend/` to `code/src/django/`.
- `code/src/scripts/CONTEXT.md` rewritten around the Django-only script inventory.

### Removed

- `code/src/scripts/tests/frontend.sh`, `frontend-coverage.sh`, `mobile.sh`, `mobile-coverage.sh`, and `e2e.sh` — superseded by `e2e-py.sh` or removed with their layer.
- `code/src/scripts/development/codegen.sh`, `new-next-route.sh`, and `new-expo-screen.sh` — scaffolding for the removed JavaScript layers.
- `code/src/scripts/tests/reports/**` — generated report directories are no longer tracked; `.gitignore` now excludes them and a single `reports/.gitignore` keeps the directory self-managing.

---

## [0.3.0] - 01/08/2026

### Added

- `code/src/django/` — the Django project bundle: `config/` (ASGI and WSGI entry points, root URL conf, and the four-environment settings split), `apps/`, `templates/`, `static/`, `tests/e2e/` with accessibility and marketing-overflow suites, plus `conftest.py`, `manage.py`, and `pyrightconfig.json`.
- `code/src/django/CHANGELOG.md`, `code/src/django/VERSION-HISTORY.md`, and `code/src/django/RELEASES.md` — sub-package version files at the `0.1.0` baseline, as required for every package manifest by `project-management/docs/VERSIONING-GUIDE.md`.
- `code/src/docker/django/` — the Django container images and entrypoints for dev, test, staging, and production.
- `code/src/docker/postgres/` — PostgreSQL container configuration, including `postgresql.dev.conf`.
- `code/src/docker/docker-compose.usXXX.dev.yml.example` and `docker-compose.usXXX.test.yml.example` — per-worktree Compose overlays for parallel story development.
- `CLAUDE.md` operating-rules files alongside every `CONTEXT.md` in the `code/src`, `docker`, and `django` trees, per the directory pairing rule.

### Changed

- `code/src/backend/` → `code/src/django/` — the Python package root is renamed to reflect that Django now serves the entire application, not just an API.
- `code/src/docker/backend/` → `code/src/docker/django/` — image names, build contexts, and entrypoints follow the rename.
- Compose files, the Nginx dev and test configurations, and the four `.env.*.example` templates re-pointed at the `django` service.
- `pyproject.toml` — project name templatised to `<%PROJECT_SLUG%>`, version set to the django sub-package `0.1.0` baseline, and the dependency set narrowed to the Django-only stack.

### Removed

- `code/src/backend/**` — superseded in full by `code/src/django/**`.
- `code/src/shared/**` — the TypeScript package shared between the web and mobile clients, obsolete now that neither client exists.

---

## [0.2.0] - 01/08/2026

### Removed

- `code/src/frontend/**` — the Next.js/React web application (34 files), including its App Router pages, components, hooks, and TypeScript configuration.
- `code/src/mobile/**` — the Expo React Native application (45 files), including its screens, navigation, native configuration, and Expo tooling.
- `code/src/docker/frontend/**` — the frontend container images and configuration for dev, test, staging, and production (5 files).
- `code/src/docker/mobile/Dockerfile.test` — the React Native test image.
- `.github/workflows/test-frontend.yml` and `.github/workflows/test-mobile.yml` — the CI pipelines for the two removed layers.

---

## [0.1.0] - 01/08/2026

### Added

- Initial scaffold from the base template — Django · Django Ninja · django-components · HTMX · Alpine · vanilla token CSS · Celery · PostgreSQL · Valkey · Nginx · Docker.
- `.gitignore` rules for the template surface — generated test reports under `code/src/scripts/tests/reports/`, the resolved Python lockfile, git worktree checkouts under `.claude/worktrees/`, and local Claude Code overrides.

### Changed

- Root version track reset from `1.11.0` to `0.1.0` — this repository is now the reusable base template rather than a single delivered project.
- `CHANGELOG.md`, `RELEASES.md`, and `VERSION-HISTORY.md` truncated to the template baseline; the pre-template 1.x history is retained in git history only and is not back-filled.

### Removed

- `uv.lock` — the resolved Python lockfile is no longer tracked. The template's `pyproject.toml` carries unsubstituted placeholders, so the lockfile is resolved per scaffolded project rather than shipped.
