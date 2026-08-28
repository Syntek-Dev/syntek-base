# MAP-UPSTREAM-TRACKING — watching what this template pins

**Seeded**: 16/08/2026 · **Charted**: 28/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Charting** — frontier drawn, four research nodes discharged by measurement
**Frontier open**: 18 · **Blocking open**: 4 · **Resolved**: 4

> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — deliberately: these are
> **the template's** upstream pins, and a generated project inherits its own set rather than this
> one. **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index**, on the interim decline
> `MAP-RULE-OWNERSHIP` N-010 settled on 28/08/2026 — the index relocates rather than gains an
> exception, and slice S-06 there carries it.
>
> **Seeded 16/08/2026, charted 28/08/2026.** The seeded evidence has been **voided and re-derived**,
> not patched: both of its two "measured members" were wrong, and one was wrong on the day it was
> written. A section whose stated purpose is _"so a CHART sitting starts from measurement rather
> than from scratch"_ was starting it from two false readings.

---

## Destination

Every upstream technology this template pins has a **named watcher, a stated trigger and an
owner** — so that a release, a deprecation or a retagging reaches a human by some mechanism other
than somebody happening to look.

**The scale is now measured rather than estimated: 113 human-declared upstreams across 8
ecosystems, and exactly one has a trigger.** That one — Expo SDK — already has a home
(`CONTRIBUTING.md:243-253`) whose own words defer to _"a general mechanism being designed
separately"_. This map is that mechanism.

**Done looks like** a pin register with an owner and trigger per row, plus whatever watches it —
and an explicit decision about what a trigger is allowed to cost.

---

## Notes

| Field                    | Value                                                                                                                                                                                              |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Template maintenance — syntek-base's own upstream surface, not a generated project's                                                                                                               |
| Skills to load           | `cicd` (the pipelines and the dependency set) · `runbook` (the register and its guide) · `doc-writer` · `security` (the supply-chain half)                                                         |
| Standing preferences     | The obligation belongs to whoever maintains the template · `CONTRIBUTING.md` is copier-excluded and is why it currently holds the one obligation that exists                                       |
| Umbrella ADRs            | **None, and none may be authored here** — a dated house rule (`../15-DECISIONS/CLAUDE.md:34-41`, 16/08/2026), **not** a mechanical impossibility. See below                                        |
| Register entries triaged | **0 closes · 0 blocks · 1 unrelated** — exhaustive; `DEFERRED.md` holds no rows                                                                                                                    |
| Scope confirmed by Sam   | 28/08/2026 — `Q4→2` the register's grain is **human-declared (113)** · `Q5→1` CI actions and container images are **in scope** · `Q6→2` the Rust advisory gap is corrected here and **routed out** |

**The ADR row is corrected, and the correction is somebody else's node.** This map previously read
_"None, and none is possible"_. That is false: `15-DECISIONS/` ships `ADR-000-TEMPLATE.md`, its
folder pair and PM workflow `15-decisions`, and **no gate blocks an ADR file**. What is true is a
house rule declining one, dated 16/08/2026. **`MAP-PROGRESSIVE-ENHANCEMENT` N-026 owns whether that
decline stands**; five files in this folder carry the strong wording and this map does not settle it
for them.

---

## Register claimed

**Nothing claimed.** Triaged against the live registers on 28/08/2026, not inherited from seeding.

| Register      | Entry                                              | Verdict       | Retired by                                             |
| ------------- | -------------------------------------------------- | ------------- | ------------------------------------------------------ |
| `GAPS.md`     | SL-1, SL-2, SL-3 — _Standing limitations_          | **exempt**    | Never — accepted properties, not entries               |
| `GAPS.md`     | 22/08/2026 — `main` has never received this branch | **unrelated** | Its own PR merging; the entry says _"Do not chart it"_ |
| `DEFERRED.md` | _(no rows — 17 lines of preamble)_                 | —             | —                                                      |

**This is a claim, not a close.** Nothing here edits either register.

---

## What the re-measurement overturned

Measured 28/08/2026 against the working tree, and adversarially verified. **Every figure the seeded
map carried was wrong**, and the direction of each correction matters: three of the four make the
case for this map _stronger_, and one dissolves a claim entirely.

| Seeded claim                                                                                                              | Measured 28/08/2026                                                                                                                                                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| _"roughly twenty pinned upstreams across **five** ecosystems"_                                                            | **113** human-declared upstreams · **~356** declaration sites · **8** ecosystems · **2,081** exactly-pinned lockfile entries behind them. Off by ~5.6×. The only reading under which "twenty" survives is the shipped-runtime subset (25)                                                                      |
| _"`deny.toml:31` gates two RUSTSEC suppressions … **Nothing watches either**"_                                            | **False, and false the day it was written.** `deny.toml:26` reads **`ignore = []`**; `:11` reads _"EMPTY BY MEASUREMENT, 16/08/2026"_. Deleted at `b805774`, **16/08/2026** — the seeding date. The quoted trigger _"or sooner if Slint bumps accesskit"_ **exists nowhere in the repository except this map** |
| _"`REFERENCES.md` — **17** rows, of which **9** read `latest`"_                                                           | **22 rows, 12 `latest`.** Checked at three historical commits including the map's own first — **it has never been 17/9**. The conclusion ("not a register") survives and is understated                                                                                                                        |
| _"Nothing in the repository watches upstream **releases** for any technology"_                                            | **Refuted** — see N-002. Three surfaces exist; all three require somebody to act first. The accurate claim is _nothing watches **unprompted**_, and `CONTRIBUTING.md:256` already states it correctly                                                                                                          |
| The Expo trigger, cited as _"N-022"_ with no map name                                                                     | **Actively ambiguous** — `N-022` is a live node on two other maps carrying different decisions, breaching the folder's own rule that node numbers are scoped per map. The decision itself is **not homeless**; see N-003                                                                                       |
| Out of scope: _"advisories already covered — `audit-deps.yml` sweeps CVEs daily and `rust/audit.sh` gates the Rust tree"_ | **The Rust half is false as a statement of equivalent coverage.** See N-002 and **N-021**                                                                                                                                                                                                                      |
| The scattered-pins list                                                                                                   | Omits **four whole pin surfaces**: 12 GitHub Actions across 144 `uses:` sites, 5 container images across 18 sites, `packageManager` + `engines`, and `pnpm-workspace.yaml`'s 25 overrides + 13 exact age-excludes — the largest hand-written pin block in the repository                                       |

---

## Resolved decisions

**Four research nodes, discharged by measurement on 28/08/2026 and adversarially verified.** Each
became a table in this map and nothing outside it — the exception the folder's _every resolved node
graduates_ rule allows for a census taken to inform a decision not yet made. **If this map dies,
they die with it.**

| Node  | Decision                                                         | Type     | Settled    | Became                                        |
| ----- | ---------------------------------------------------------------- | -------- | ---------- | --------------------------------------------- |
| N-001 | **The pin inventory** — the map's own first fog item, enumerated | research | 28/08/2026 | _The measured inventory_ below                |
| N-002 | What already watches, and what it actually reaches               | research | 28/08/2026 | _What watches today_ below; **spawned N-021** |
| N-003 | Where the Expo trigger lives now its origin map is deleted       | research | 28/08/2026 | The two homes named below                     |
| N-004 | The mechanism option space, measured against these pin classes   | research | 28/08/2026 | _The option space_ below; feeds N-009         |

### N-001 — the measured inventory

**113 distinct named upstreams carry a version declaration a human wrote**, across ~356 sites, in
8 ecosystems: Python 36 · JavaScript 48 · Rust 7 · containers 3 · CI 13 · standalone tools 2 ·
MCP and vendored skills 4. Behind them sit **2,081** exactly-pinned lockfile entries (`uv.lock` 119,
`Cargo.lock` 605, `pnpm-lock.yaml` 1,357).

**The grain is settled at the human-declared 113** (Sam, 28/08/2026, `Q4→2`) — the lockfile grain is
unmaintainable and already exact, and the headline grain is what `REFERENCES.md` already attempts
and demonstrably fails at.

**Pin quality, as one picture** — this is what a watcher would have to cope with:

| Quality                  | Members                                                                                                                                                                    |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Exact**                | rust-toolchain 1.97.1 · cargo-deny 0.20.2 · opengrep 1.27.1 · pnpm 11.22.0 · uv 0.12.5 (CI) · react 19.2.3 · react-native 0.86.2 · 13 pnpm age-excludes · 5 CI action tags |
| **Bounded range**        | 25 `pnpm-workspace.yaml` overrides · maturin `>=1.7,<2.0`                                                                                                                  |
| **Open floor (`>=`)**    | 11 Python runtime · 12 Python dev/test · 2 `engines` · Copier 9.6.0                                                                                                        |
| **Caret / tilde**        | 7 root JS devDeps · 18 mobile deps · 5 Rust crates                                                                                                                         |
| **Major tag only**       | 7 CI actions (**126 of 144 `uses:` sites**) · `postgres:18-alpine` · `valkey/valkey:8-alpine` · node 24 · python 3.14                                                      |
| **`latest`, or nothing** | `ghcr.io/astral-sh/uv:latest` (4) · `nginx:alpine` (2) · `ubuntu-latest` (53) · `python-version: "3.x"` (1) · **3 MCP servers** · 10 unconstrained Python runtime deps     |

**Three findings that decide nodes below:**

- **`uv` is pinned two contradictory ways in the same repository.** Exactly `0.12.5` in three CI
  workflows, and `ghcr.io/astral-sh/uv:latest` in all four Dockerfiles — **`latest` is the version
  that reaches the built artefact.**
- **Zero GitHub Actions are SHA-pinned anywhere**, and 126 of 144 `uses:` sites resolve through a
  mutable major tag (`actions/checkout@v7` alone is 53). A retagged action is a supply-chain event
  this repository cannot detect.
- **The 3 MCP servers are the only declared upstreams with no version expression of any kind**, and
  they run on a maintainer's machine with repository access. `skills-lock.json` pins by content hash
  — it detects change but names nothing to compare a release against.

### N-002 — what watches today, and what it reaches

**The absolute claim is refuted. The narrow one is true and is the argument for this map.**

| Surface                            | What it does                                                                                                                                                         | Reaches                                     |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `CONTRIBUTING.md:243-253`          | A **written standing obligation** — _"Follow every SDK release … Every SDK release, on release"_. No automation whatsoever                                           | Expo SDK only                               |
| `dependencies/update.sh --check`   | **Genuinely queries upstream registries** — PyPI `info.version` with a `<-- MAJOR` marker, `pnpm outdated`, `cargo update --dry-run`. Exits 1 on "updates available" | 3 of 12 pin classes. **Zero CI call sites** |
| `development/pnpm-update.sh:68`    | `pnpm self-update`, repinning pnpm across `package.json`, the Dockerfiles and `.claude/CLAUDE.md`                                                                    | pnpm only. On demand                        |
| `.github/workflows/audit-deps.yml` | **CVE sweep, not a release watcher.** Daily 06:00; `pnpm audit` + `pip-audit`; opens **or comments on** one tracking issue                                           | 2 of 8 ecosystems. **No cargo step**        |
| `audits/dependency-drift.sh`       | The **only machine-readable pin enumerator** in the repository — parses 6 files across 5 ecosystems including CI `uses:` refs and env version keys                   | Template-vs-project, **never upstream**     |

**So the honest statement is: nothing watches upstream releases _unprompted_.** Every existing
surface needs a human to type something first. `CONTRIBUTING.md:256` already words it correctly —
_"Nothing here watches upstream **releases** for any of the others"_ — and the map dropped the
_"of the others"_.

**`update.sh --check` changes the mechanism question from build-to-buy into a genuine fork**, since
one-third of a release watcher is already written and is the sanctioned entry point.

**The finding that spawned N-021.** The Out-of-scope row claiming advisories are covered is false
for Rust: `audit-deps.yml` has **no cargo step**, and `cargo-deny` runs only from `syntax-rust.yml`,
path-filtered to `code/src/rust/**`. **A RUSTSEC advisory against an unchanged `Cargo.lock` is
invisible until somebody edits a Rust file** — the exact continuous-drift failure `audit-deps.yml`
was written to close for JavaScript and Python.

### N-003 — the Expo trigger is not homeless

The origin map was deleted, but the decision graduated before it died. **Two live homes, split by
act**, plus four corroborating citations:

- **Template produces** — `CONTRIBUTING.md:243-245` (the one-row `Upstream | Obligation | Trigger`
  table) with rationale at `:247-253`. Copier-excluded at `copier.yml:100`, so it binds the
  maintainer and never ships.
- **Project adopts** — `code/src/mobile/CLAUDE.md:40-47`: _"the trigger is the first build that
  ships to a store"_, naming `CONTRIBUTING.md` as the other half.

**And that table already names this map as its successor.** `CONTRIBUTING.md:255-258`: _"This table
is a floor, not the register. Expo is one of about twenty pinned upstream technologies, and it is
the only one with a stated trigger"_ — deferring to a general mechanism **being designed
separately**, which does not yet exist. The register has a home waiting for it and a stated reason
for that home.

**The dangling `N-022` pointer is retired** — it is a live node number on two other maps carrying
different decisions, which breaches `01-FEATURE-MAPS/CONTEXT.md:58-59`.

### N-004 — the option space

| Option                                  | Reaches                                                                                                                                                         | Costs                                                                                                                                                                                                                                                     |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Dependabot**                          | ~8 of 12 classes natively — `uv` (GA 03/2025), `npm`, `cargo`, `docker`, `docker-compose`, `github-actions`, **`rust-toolchain` (since 08/2025)**, `pre-commit` | **No custom/regex manager, structurally** — `.nvmrc`, `.python-version`, `.opengrep-version` and `.cargo-deny-version` are unreachable. `dependabot/` branch prefix is not configurable. `target-branch` **disables security updates** for that ecosystem |
| **Renovate**                            | **The only single mechanism reaching every class** — `nvm`, `pyenv`, `pep621` (incl. `uv.lock`), plus `customManagers` regex for the two bespoke files          | A GitHub App with repository write access — which `PLATFORM-PROVIDERS.md`'s four seam kinds fit poorly (**N-018**)                                                                                                                                        |
| **A script leg** (`update.sh` extended) | The 3 lockfile ecosystems it already covers                                                                                                                     | Nothing for Actions, containers, or the 6 standalone pin files. Registration cost differs sharply by folder (**N-013**)                                                                                                                                   |

**Cost controls, measured, because "what a trigger may cost" was this map's sharpest fog:**

- **The house answer already exists.** `audit-deps.yml:103-134` searches for an open issue by title
  and comments rather than opening a second — one aggregated issue, never one per finding. It is the
  **only scheduled workflow of 35**.
- **Renovate's `dependencyDashboardApproval: true`** is the closest analogue for releases: one issue
  per repository, **zero PRs until a box is ticked**, with the documented carve-out that
  vulnerability PRs still open immediately.
- **A cooldown concept already exists here under Renovate's own name** — `pnpm-workspace.yaml`'s 13
  `minimumReleaseAgeExclude` entries.

**Two constraints nothing else records:**

- **The repo's own doctrine already names both products.** `SUPPLY-CHAIN.md:36` — _"automate with
  GitHub Dependabot, Renovate, or equivalent"_. Adopting one is inside doctrine, not a departure.
- **The two repositories disagree about where a PR targets**, and both statements are current.
  `CONTRIBUTING.md:166` says branch from `main` (conformant here); the shipped guide says feature
  branches **always** target `testing` (so the same bot is non-conformant downstream). **N-011.**

---

## Slices

**None, and none can be cut** — every blocking node is open, and a slice comes from a resolved
frontier. Whether the deliverable is one mechanism or one per ecosystem is **N-009**, and it changes
what a slice would even contain.

| Slice | Story | Title                             | Flags |
| ----- | ----- | --------------------------------- | ----- |
| —     | —     | _(blocked — see N-005 and N-009)_ | —     |

**All thirteen gate flags are expected to read `N/A`** — a watcher is CI plumbing, a register is a
markdown file, an owner is a name in it. No model, no endpoint, no screen, no personal-data path.
**One cost the flags do not capture, recorded so it is not discovered late:** if the answer is a
script it lands in `code/src/scripts/`, and `audits/CLAUDE.md` requires a row in **two** `CONTEXT.md`
tables in the same change, a `--path` contract and a CI workflow. If it is a shipped config it needs
a `copier.yml` `_exclude` decision. Written as an expectation, not a manifest.

---

## Frontier

Open decisions in dependency order. **Blocking** here means _"no register or watcher may be written
against it"_ — this map's analogue of blocking a story, because the deliverable is plumbing and
prose rather than a feature.

**Takeable now — six nodes, nothing in flight:** N-005, N-009, N-017, N-019, N-020, N-021.

### A — The register

| Node  | Decision                                                                                                                                                                                                                                                                                                                                | Type     | Blocked by | Blocking? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | --------- |
| N-005 | **The register's home and shape.** `CONTRIBUTING.md`'s table promoted (copier-excluded, correct today, but it is a contributor-onboarding document a 113-row register would swamp), a `how-to/src/` answer sheet (ships, and is **writable downstream**), or an extension of `PR-AND-REQUIRED-CHECKS.md:149-169`'s toolchain-pins table | grilling | none       | **yes**   |
| N-006 | **`REFERENCES.md`'s stack table** — promoted to the register, demoted to a docs index with the version column **removed**, or retired. 22 rows, 12 `latest`, and 6 rows name technologies pinned in no manifest at all (HTMX and Alpine are pinned **nowhere**)                                                                         | grilling | N-005      | no        |
| N-007 | Does the register carry an **owner column** — none of the three `how-to/src/` answer sheets does, and the Destination promises one                                                                                                                                                                                                      | grilling | N-005      | no        |
| N-008 | Is the register **gated by a script** or kept true by prose discipline — precedent runs both ways, and `copier.yml:76-84` records prose-only discipline failing before                                                                                                                                                                  | grilling | N-005      | no        |

### B — The mechanism

| Node  | Decision                                                                                                                                                                                                            | Type     | Blocked by   | Blocking? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------ | --------- |
| N-009 | **The watcher mechanism**: Dependabot alone, Renovate alone, a script leg, or Dependabot **plus** a script leg for what it structurally cannot see. Renovate is the only single mechanism reaching every class      | grilling | none         | **yes**   |
| N-010 | **What a trigger may cost** — a PR per release, one aggregated issue on the `audit-deps.yml` precedent, or Renovate's dependency dashboard with approval                                                            | grilling | N-009        | **yes**   |
| N-011 | **The PR target branch**, which is a different answer here and downstream — and whether Dependabot's security-update penalty for `target-branch` is acceptable                                                      | grilling | N-009, N-012 | no        |
| N-012 | **Does the watcher config ship to generated projects?** `.github/workflows/` ships wholesale, so a `dependabot.yml` or `renovate.json` is **inherited by default** and suppressing it needs a deliberate `_exclude` | grilling | N-009        | **yes**   |
| N-013 | If a script leg is chosen: `dependencies/` or `audits/` — the tree's own taxonomy points at the first, and the audits folder has no answer for a script whose input is the network                                  | grilling | N-009        | no        |
| N-014 | What happens to **copier tokens inside the manifests a watcher parses** — `check-template-parsers.sh` exists because the verdict is per-tool and not statically decidable                                           | tracer   | N-009        | no        |

### C — The watched set

| Node  | Decision                                                                                                                                                                                                                                                                     | Type     | Blocked by | Blocking? |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | --------- |
| N-015 | **Do the 12 CI actions move to commit SHAs?** In scope per `Q5→1`. 126 of 144 sites on mutable major tags, zero SHA-pinned — against 144 sites to churn on every bump                                                                                                        | grilling | N-005      | no        |
| N-016 | **The 5 container images.** In scope per `Q5→1`, but `nginx:alpine` and `ghcr.io/astral-sh/uv:latest` carry **nothing to watch against** — so pinning them precedes watching them                                                                                            | grilling | N-005      | no        |
| N-017 | Do the **10 unconstrained Python runtime dependencies** get floors — two are security-critical (`cryptography`, `argon2-cffi`), against a written doctrine that a floor needs evidence                                                                                       | grilling | none       | no        |
| N-018 | The **mobile surface's 18 pins**: same mechanism, or Expo alone? `dependency-drift.sh:279` excludes them on a premise now false in its own source                                                                                                                            | grilling | N-005      | no        |
| N-019 | **Unpinned developer tooling** — the 3 MCP servers and 3 hash-pinned vendored skills. Neither ships; both run with repository access                                                                                                                                         | grilling | none       | no        |
| N-020 | **The two self-firing rules with no firing mechanism** — `pnpm-workspace.yaml:76-79` (_"re-check when 2.0.3 ships"_) and `deny.toml:22-25` (_"delete an entry the moment its subject leaves the graph"_). The two ecosystems hold **opposite doctrine on the same question** | grilling | none       | no        |

### D — Corrections found while charting

| Node  | Decision                                                                                                                                                                                                                                      | Type | Blocked by | Blocking? |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ---------- | --------- |
| N-021 | **The Rust advisory gap.** The Out-of-scope row is corrected here; **the fix is routed out, not adopted** (Sam, `Q6→2`). The fix is a `cargo-deny` leg in `audit-deps.yml`; the destination is a `GAPS.md` entry, **not written by this map** | task | none       | no        |
| N-022 | Does a Renovate GitHub App earn a row in `how-to/src/PLATFORM-PROVIDERS.md`, and under which seam kind — a CI bot with write access fits none of the four cleanly                                                                             | task | N-009      | no        |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `task` (manual unblocking work)

### Suggested first batch

**N-005 + N-009 as one grilling pass.** They look separable and are not: an answer sheet that ships
and an obligation table that does not are different files, and which one carries the trigger column
decides whether the answer is one file or two. Deciding the register's home without knowing what
writes to it means deciding it twice.

**N-021 runs alone and immediately** — it is a correction of a statement that is false today,
depends on nothing, and blocks nothing.

**N-017, N-019 and N-020 batch together** as the three scope questions that need no mechanism to
answer: they are about which pins deserve a trigger at all.

---

## Fog of war

In scope, not yet sharp enough to state as a decision. **Leaving something here is honest.**

- **Whether one mechanism can serve all of them.** Sharper than at seeding, but still open: 12 pin
  classes with different release channels, notification surfaces and blast radii. N-009 chooses a
  tool; whether that tool is _one_ thing is what stays foggy.
- **Whether "immediately" generalises.** Expo was settled on _follow every release, immediately_
  (`CONTRIBUTING.md:247-253`), chosen precisely because a per-technology readiness judgement does not
  scale. Whether that holds for a database major, a language runtime or a toolchain pin is exactly
  what this map is for — and it is not answerable until N-010 prices a trigger.
- **Whether the register and the watcher can disagree.** If the watcher is Renovate and the register
  is markdown, nothing keeps them in step, and the repository has measured that failure before.
- **Whether `ubuntu-latest` at 53 sites is a pin at all.** It is an unversioned upstream inside the
  gate set that reviews everything else, and it fits no row shape the register would have.
- **What a generated project inherits.** The **obligation** half is already settled and on the record
  (`CONTRIBUTING.md:238-241`); the **mechanism** half is N-012, and the register half is neither.

---

## Out of scope

| Ruled out                                    | Why                                                                                                                                                                                                                                                                                                                                                   |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Security advisories, **for JS and Python**   | Genuinely covered — `audit-deps.yml` sweeps both daily. This map is about **releases**, a different signal                                                                                                                                                                                                                                            |
| ~~Security advisories, for Rust~~            | **Corrected 28/08/2026.** `audit-deps.yml` has **no cargo step**; `cargo-deny` runs only from path-filtered `syntax-rust.yml`, so a RUSTSEC advisory against an unchanged `Cargo.lock` is invisible until a Rust file is edited. **Routed to `GAPS.md` via N-021, not adopted here** (`Q6→2`). Struck rather than deleted, so the reversal is legible |
| A generated project's own dependency updates | `how-to/workflows/07-dependency-updates/` and `code/src/scripts/dependencies/update.sh` own that                                                                                                                                                                                                                                                      |
| The Expo trigger itself                      | Settled 16/08/2026 and **graduated to two live homes** (N-003). It enters here as a **worked example**, not a question                                                                                                                                                                                                                                |
| Authoring an ADR for any of it               | A dated house rule (`../15-DECISIONS/CLAUDE.md:34-41`), **not** an impossibility. Whether the decline stands is `MAP-PROGRESSIVE-ENHANCEMENT` N-026's                                                                                                                                                                                                 |
| Bumping anything                             | This map decides **what watches and who owns it**. Taking an update is `07-dependency-updates`, every time                                                                                                                                                                                                                                            |

---

## Session log

| Date       | Node settled                  | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Frontier redrawn |
| ---------- | ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 16/08/2026 | _none — seeding_              | Seeded out of the template-health grilling, on Sam's call that the general case is its own map. Two members and the measured gap recorded; **not charted**                                                                                                                                                                                                                                                                                                                                                                                                                                | [ ]              |
| 28/08/2026 | N-001 · N-002 · N-003 · N-004 | **Charted: 22 nodes, 18 open, 5 blocking, 4 discharged by measurement.** The seeded evidence was **voided and re-derived** — every figure it carried was wrong, and the `deny.toml` member was false on the day it was written, its quoted trigger existing nowhere but the map. The inventory is **113 upstreams across 8 ecosystems**, not twenty across five. The _"nothing watches releases"_ claim is **refuted and narrowed** to _unprompted_, and the Expo trigger was found alive in two homes whose own words defer to this map. Bounds confirmed by Sam: `Q4→2`, `Q5→1`, `Q6→2` | [x]              |

---

## Gate to stories

- [x] **Destination and out-of-scope bounds confirmed** — Sam, 28/08/2026 (`Q4→2 Q5→1 Q6→2`)
- [x] **The pin inventory enumerated** — N-001; 113 upstreams, ~356 sites, 8 ecosystems, with where each is pinned
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 0 closes · 0 blocks · 1 unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired; **six takeable now**
- [ ] **Every node marked blocking is resolved** — 4 open: N-005, N-009, N-010, N-012
- [x] Every resolved node links to the artefact it became — **N-001 to N-004 became tables in this
      map and nothing outside it.** Deliberate, and named as a cost
- [ ] **Every slice has a flag manifest** — no slices; blocked on N-005 and N-009
- [x] **No index row in `CONTEXT.md`** — the interim decline `MAP-RULE-OWNERSHIP` N-010 settled on
      28/08/2026; the row arrives with that map's slice S-06

**This is a template-development map, so there are no stories to cut.** The equivalent gate is that
**N-005 and N-009 must settle before any register or watcher is written** — the home and the
mechanism, and the first batch takes them together because they are one question.
