# MAP-UPSTREAM-TRACKING — watching what this template pins

**Seeded**: 16/08/2026 · **Charted**: 28/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Frontier closed 01/09/2026** — every node resolved or dissolved across one seven-batch sitting; the route is fully charted and Slices S-01–S-03 are the build
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 22

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
they die with it** — except N-021, which graduated out.

| Node  | Decision                                                         | Type     | Settled    | Became                                                                     |
| ----- | ---------------------------------------------------------------- | -------- | ---------- | -------------------------------------------------------------------------- |
| N-001 | **The pin inventory** — the map's own first fog item, enumerated | research | 28/08/2026 | _The measured inventory_ below                                             |
| N-002 | What already watches, and what it actually reaches               | research | 28/08/2026 | _What watches today_ below; **spawned N-021**                              |
| N-003 | Where the Expo trigger lives now its origin map is deleted       | research | 28/08/2026 | The two homes named below                                                  |
| N-004 | The mechanism option space, measured against these pin classes   | research | 28/08/2026 | _The option space_ below; feeds N-009                                      |
| N-021 | **The Rust advisory gap** — corrected here, fix routed out       | build    | 01/09/2026 | The `GAPS.md` entry of 01/09/2026 — the cargo-deny leg, re-verified        |
| N-009 | **The watcher mechanism** — Renovate, self-hosted                | grilling | 01/09/2026 | _The mechanism and the home_ below; Slices rows once N-010 + N-012 settle  |
| N-005 | **The register's home and shape** — two files split by act       | grilling | 01/09/2026 | _The mechanism and the home_ below; Slices rows once N-010 + N-012 settle  |
| N-013 | Script-leg home (`dependencies/` vs `audits/`)                   | grilling | 01/09/2026 | **Dissolved** — N-009 chose no script leg, so the question has no subject  |
| N-010 | **What a trigger may cost** — dashboard with approval            | grilling | 01/09/2026 | _The cost and the inheritance_ below; Slices S-02                          |
| N-012 | **The watcher ships, secret-gated**                              | grilling | 01/09/2026 | _The cost and the inheritance_ below; Slices S-02                          |
| N-006 | **`REFERENCES.md` demoted** — the Version column goes            | grilling | 01/09/2026 | _The columns and the gate_ below; Slices S-01                              |
| N-007 | **Owner by exception** over a prose default                      | grilling | 01/09/2026 | _The columns and the gate_ below; Slices S-01                              |
| N-008 | **Coverage gate, no version column**                             | grilling | 01/09/2026 | _The columns and the gate_ below; Slices S-01                              |
| N-017 | **No blanket floors** — floors arrive with wiring                | grilling | 01/09/2026 | _The scope trio_ below; Slices S-01 + S-03                                 |
| N-019 | **Pin the dev tooling** — all six become register rows           | grilling | 01/09/2026 | _The scope trio_ below; Slices S-01, S-02, S-03                            |
| N-020 | **Delete-when-moot unified** across both ecosystems              | grilling | 01/09/2026 | _The scope trio_ below; Slices S-03                                        |
| N-014 | **Copier tokens vs Renovate** — parse set clean, two warns       | tracer   | 01/09/2026 | _The config's last inputs_ below; Slices S-02                              |
| N-011 | **The watcher targets the integration branch**, detected         | grilling | 01/09/2026 | _The config's last inputs_ below; Slices S-02                              |
| N-015 | **SHA-pin all 144 action sites**, bot-maintained                 | grilling | 01/09/2026 | _The watched-set pair_ below; Slices S-03                                  |
| N-016 | **Images split by what ships** — digests vs specific tags        | grilling | 01/09/2026 | _The watched-set pair_ below; Slices S-03                                  |
| N-022 | **The `PLATFORM-PROVIDERS.md` row** — specified into S-02        | build    | 01/09/2026 | S-02's acceptance (confirmed by Sam: build nodes place into slices direct) |
| N-018 | **Mobile split, `expo` as the signal**                           | grilling | 01/09/2026 | _The mobile surface_ below; Slices S-02 + S-03                             |

### N-005 + N-009 — the mechanism and the home (settled together, Sam `Q1→3` · `Q2→2`)

- **N-009 — Renovate, self-hosted.** `renovatebot/github-action` on a scheduled workflow with a
  PAT — no Mend app, no external write access. The one mechanism reaching all 12 pin classes,
  including the bespoke pin files via `customManagers` regex; its dashboard-approval and
  `minimumReleaseAge` models match the cost controls the house already chose. Joins
  `audit-deps.yml` as the second scheduled workflow.
- **N-005 — two files split by act, the Expo precedent generalised.** A new `how-to/src/`
  register sheet (ships, writable downstream; carries the per-row columns — owner and trigger
  shape pending N-007 and N-010) plus `CONTRIBUTING.md` keeping the maintainer's obligation
  floor (copier-excluded), its table pointing at the register as the Expo row already points at
  this map's mechanism.

### N-010 + N-012 — the cost and the inheritance (settled together, Sam `Q3→2` · `Q4→1`)

- **N-010 — dependency dashboard with approval.** `dependencyDashboardApproval: true`: one issue
  per repository, zero PRs until a box is ticked, vulnerability PRs still opening immediately —
  the `audit-deps.yml` precedent exactly. Per-class carve-outs, if ever wanted, are later
  `packageRules`, not a re-decision.
- **N-012 — ships, secret-gated.** `renovate.json` and the scheduled workflow ship to generated
  projects; without a project-supplied PAT the workflow no-ops with an **explicit "unconfigured"
  notice** (`code/docs/GATE-REPORTING.md` — never silently green). Chosen because the register
  sheet already ships (`Q2→2`), and a shipped register nothing updates recreates the
  `REFERENCES.md` failure this map measured. No `_exclude` rows for either file.

### N-006 + N-007 + N-008 — the columns and the gate (settled together, Sam `Q5→1` · `Q6→1` · `Q7→2`)

- **N-006 — demote.** `REFERENCES.md`'s stack table keeps name + docs URL and **loses its Version
  column**; the register owns pin truth. Re-measured 01/09/2026 before deciding: 22 rows / 12
  `latest` confirmed, but this map's "6 rows pinned in no manifest" was **wrong** — 5 appear in no
  manifest, 8 carry no version constraint — and **five `latest` rows are actually pinned**
  (Valkey `8-alpine`, django-htmx `>=1.19`, pytest, pytest-django, Playwright). Wrong in both
  directions; a second version surface recreates the drift the register ends. **Cross-map:** the
  django-htmx row is **`MAP-ABSENCE`'s to retire** (the move to plain htmx) — the register must
  not enshrine it.
- **N-007 — owner by exception.** One prose line names the register's default owner (the template
  maintainer here; rendered for the project downstream); a row carries an owner cell only where it
  differs. Every row still resolves to an owner, honouring the Destination; zero of the five
  existing sheets carry a column, and that precedent held.
- **N-008 — coverage gate, no version column.** The register **never carries versions** —
  manifests own them. A new `audits/` script reconciles both directions **by name**: census
  upstream ↔ register row ↔ `renovate.json` coverage or a stated exemption (the `negative-space.sh`
  pattern — the only reconciliation shape this repo has proven; measured 01/09/2026: 2 of 5
  sheets gated, both by name never version, and no version comparator exists anywhere).
  Registration per `audits/CLAUDE.md`: rows in the two `CONTEXT.md` tables in the same change and
  a `--path` contract; the one-workflow-per-audit shape is convention (26 files), not a stated
  rule.

### N-017 + N-019 + N-020 — the scope trio (settled together, Sam `Q8→2` · `Q9→1` · `Q10→1`)

- **N-017 — no blanket floors.** The 10 unconstrained runtime deps stay bare; the register marks
  them **"unfloored by policy — floors arrive with wiring"**, per the doctrine's actual wording
  (`07-dependency-updates/STEPS.md:64-69`: _"raise a floor deliberately, say why beside it,
  re-resolve in the same change"_ — re-measured 01/09/2026: the map's "needs evidence" was a
  paraphrase). Renovate watches their resolution through the lockfile regardless — floors were
  hygiene here, never watchability. **Measured on the way:** `argon2-cffi` is entirely unused —
  no `PASSWORD_HASHERS` in `base.py`, so runtime hashes with Django's PBKDF2 default. Resolved
  01/09/2026 (Sam): **not a gap, no routing** — the syntek-modules authentication module owns
  wiring Argon2 and the crypto setup; projects may choose their own, and the docs recommend the
  secure default.
- **N-019 — pin the six.** The 3 MCP servers get version pins in `.mcp.json` (`npx -y pkg@X.Y.Z`
  / `uvx pkg==X`), watched by a Renovate `customManagers` regex; the 3 vendored skills get
  register rows naming `cloudinary-devs/skills` as the watch subject (git datasource), with
  `skills-lock.json`'s hashes staying the change detector. Re-measured 01/09/2026: the map's
  "neither ships" was **refuted** — `.mcp.json`, `.agents/` and `skills-lock.json` all ship, so
  pinning also ends latest-at-launch resolving on every generated project's machine.
- **N-020 — delete-when-moot, unified.** `pnpm-workspace.yaml:62-65`'s keep-an-ignore-matching-
  nothing entry goes; an ignore matching nothing is a failure in **both** ecosystems (the
  coverage gate's concern); the dated image-size rule graduates to a register row with the
  trigger _"image-size ≥ 2.0.3 ships"_. Anchor corrected 01/09/2026: the same-question
  opposition is `:62-65` vs `deny.toml:22-25` — the dated rule at `:81-82` answers a different
  question (keep-while-unfixable) and stays sound.

### N-011 + N-014 — the config's last inputs (settled 01/09/2026; N-014 by measurement, N-011 Sam `Q11→2`)

- **N-014 — discharged by tracer.** `_templates_suffix: ""` renders everything at generation, so
  tokens are raw only in this repo — where the watcher runs. Census: every version-pin position
  Renovate reads is **token-free**; 13 files carry tokens in inert positions; exactly two are
  load-bearing — the staging/prod compose `image: ghcr.io/<%ORG_SLUG%>/…` refs, a per-dependency
  skip/warn, not a parse failure, and real paths downstream. `check-template-parsers.sh` (at
  `.github/scripts/`, not `audits/` — corrected) proves each surface's own toolchain, all 7
  probes green 01/09/2026; it does not prove Renovate's extractors, which is why this census was
  taken.
- **N-011 — detect the integration branch.** A step in the shipped workflow sets
  `RENOVATE_BASE_BRANCH_PATTERNS` to `testing` where that branch exists, else the default branch;
  `renovate.json` leaves the option unset (repo config would win over env). One un-tokenised file
  correct raw and rendered — a copier token in an executable workflow position was measured out
  (zero precedent; the raw token would run here). Here it resolves to `main`; downstream to
  `testing`, keeping _"feature branches always target `testing`"_ intact. The git guide gains its
  first bot-PR sentence (S-02 build work) — measured: no git doc covers bot PRs today.

### N-015 + N-016 — the watched-set pair (settled together, Sam `Q14→1` · `Q15→3`)

- **N-015 — comply with the doctrine.** `SUPPLY-CHAIN.md:68` already commands _"pin CI action
  versions by commit SHA, not tag"_ and **zero of 144 sites comply** — the decision was
  doctrine-vs-practice, not an open trade-off. All sites move to SHAs with load-bearing version
  comments, maintained by Renovate (`helpers:pinGitHubActionDigests` + `ToSemver`; a bare SHA
  without its comment is disabled by default). Re-measured 01/09/2026: 126 major-tag + 18
  exact-tag **sites** (the map's "5" counted refs); 8 sites are template-only
  (`audit-template.yml`), so a baseline project inherits 130.
- **N-016 — split by what ships.** `SECRETS-AND-TRANSPORT.md:67` (_"digest pinning or specific
  tags. Never use `latest`"_) is violated by the 4 `uv:latest` sites. The build-graph pair is
  **digest-pinned** (`python:3.14-slim`, and `uv` pinned to the CI-pinned version — ending the
  `0.12.5`-vs-`latest` contradiction, one number in both places); the dev/test-only services take
  **specific version tags** (`nginx` gains one; `postgres:18-alpine` and `valkey/valkey:8-alpine`
  stay, their rolling re-points accepted and register-noted — they never leave a developer
  machine). Census corrected: the fifth image is `python:3.14-slim` (6 sites); **node 24 was
  never a container image** (it is CI `setup-node` only).

### N-018 — the mobile surface (settled, Sam `Q16→2`)

**Split, with `expo` as the signal.** The SDK-aligned set (~123 packages per SDK, 41 not
`expo-`-prefixed) is ignored via a `bundledNativeModules.json`-derived list — alignment belongs
to `npx expo install --fix`, per Expo's one-SDK-at-a-time release train, because individual
npm-latest bumps break alignment _"in a way that leaves CI green"_ (measured; Renovate has no
Expo-SDK-aware behaviour and `monorepo:expo` does not preserve alignment). The `expo` package
itself stays watched as the **SDK-release signal**: dashboard-only, with a written never-merge
rule — the bump is executed by the Expo flow, never by ticking the PR box. The non-aligned dev
tools (eslint, jest, typescript-eslint, testing-library) are watched normally. Census corrected:
the 18 pins are 11 tilde / 5 caret / **2 exact** (`react`, `react-native`), and `app.json`
carries no `sdkVersion` — the `expo` pin is the SDK. Found on the way, carried as a slice leg:
`dependency-drift.sh:279`'s premise (_"if it declared its own pins"_) is false — mobile declares
18, workspace-resolved, invisible to that audit.

Detail beyond this stays out of the map: the rationale ships with the register sheet, the gate
script and the workflow the slices build.

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
| **Exact**                | rust-toolchain 1.97.1 · cargo-deny 0.20.2 · opengrep 1.27.1 · pnpm 11.25.0 · uv 0.12.5 (CI) · react 19.2.3 · react-native 0.86.2 · 13 pnpm age-excludes · 5 CI action tags |
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
one-third of a release watcher is already written and is the sanctioned entry point. (Nuance,
01/09/2026: with `uv.lock` committed — as here since 16/08/2026 — the Python leg is
`uv lock --check` lock-drift, not the PyPI major scan; that scan runs only in the no-lock branch.)

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

| Option                                  | Reaches                                                                                                                                                         | Costs                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Dependabot**                          | ~8 of 12 classes natively — `uv` (GA 03/2025), `npm`, `cargo`, `docker`, `docker-compose`, `github-actions`, **`rust-toolchain` (since 08/2025)**, `pre-commit` | **No custom/regex manager, structurally** — `.nvmrc`, `.python-version`, `.opengrep-version` and `.cargo-deny-version` are unreachable (confirmed 01/09/2026). ~~Branch prefix not configurable~~ — **configurable since 04/08/2026** (`pull-request-branch-name`), recorded wrong the day this was charted. ~~`target-branch` disables security updates~~ — **it does not**: they always run against the default branch, ignoring per-ecosystem config |
| **Renovate**                            | **The only single mechanism reaching every class** — `nvm`, `pyenv`, `pep621` (incl. `uv.lock`), plus `customManagers` regex for the two bespoke files          | Either the Mend GitHub App with repository write access — fitting neither of `PROVIDER-NEUTRALITY.md`'s two seam kinds cleanly (**N-022**) — or **self-hosted** via `renovatebot/github-action` on a scheduled workflow with a PAT, no external app (measured 01/09/2026)                                                                                                                                                                               |
| **A script leg** (`update.sh` extended) | The 3 lockfile ecosystems it already covers                                                                                                                     | Nothing for Actions, containers, or the 6 standalone pin files. Registration cost differs sharply by folder (**N-013**)                                                                                                                                                                                                                                                                                                                                 |

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

**Cut 01/09/2026, all four blocking nodes settled.** Every open node is assigned to the slice its
outcome lands in; a slice's acceptance absorbs its open nodes' answers as they settle. Specified
here, never performed.

| Slice | Story | Title                          | Nodes                                                                      | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | Flags |
| ----- | ----- | ------------------------------ | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| S-01  | —     | The pin register and its floor | N-005 ✅ · N-006 ✅ · N-007 ✅ · N-008 ✅ · N-019 ✅                       | The `how-to/src/` register sheet ships with a row per human-declared upstream (113 at census; the django-htmx row is **`MAP-ABSENCE`'s to retire** — plain htmx replaces it), **no version column**, trigger per row, owner by exception over a prose default; `CONTRIBUTING.md` keeps the copier-excluded obligation floor pointing at it; `REFERENCES.md`'s stack table loses its Version column; the coverage gate ships as a new `audits/` script reconciling census ↔ register ↔ `renovate.json` both directions by name, registered per `audits/CLAUDE.md`; `ubuntu-latest` carried as an explicit exemption row; rows for the six dev-tooling upstreams (3 MCP servers, the vendored-skills set) and the 10 unconstrained Python deps annotated **"unfloored by policy"**                                                                                                                                                                                                                                                                                                                               | N/A   |
| S-02  | —     | The self-hosted watcher        | N-009 ✅ · N-010 ✅ · N-012 ✅ · N-011 ✅ · N-014 ✅ · N-022 ✅ · N-018 ✅ | `renovate.json` + scheduled workflow ship; secret-gated no-op reports **"unconfigured"** explicitly; `dependencyDashboardApproval: true` with the vulnerability carve-out intact; the two tokenised ghcr image refs handled (ignore rule or documented warning — the parse set is otherwise clean); the workflow detects the integration branch (`RENOVATE_BASE_BRANCH_PATTERNS` = `testing` where it exists, else default; `renovate.json` leaves the option unset) and the git guide gains its bot-PR sentence; the mobile split (SDK-aligned set ignored via a `bundledNativeModules.json`-derived list; `expo` watched dashboard-only as the SDK-release signal with a written never-merge rule; non-aligned dev tools watched normally); a `PLATFORM-PROVIDERS.md` row under **_Process dependencies_** naming self-hosted Renovate (`renovatebot/github-action` + PAT), its role and its substitute path (Dependabot or a script leg — both already inside `SUPPLY-CHAIN.md:36`'s doctrine); a `customManagers` regex watching `.mcp.json`'s pins and a git-datasource watch on `cloudinary-devs/skills` | N/A   |
| S-03  | —     | The pins made watchable        | N-015 ✅ · N-016 ✅ · N-017 ✅ · N-020 ✅                                  | Every pin class the settled scope keeps carries something to watch against: all 144 action sites SHA-pinned with version comments (`helpers:pinGitHubActionDigests` + `ToSemver`), the build-graph images digest-pinned (`python:3.14-slim`; `uv` pinned to the CI version, ending the `latest` contradiction), the dev-only services on specific tags (`nginx` gains one; postgres/valkey rolling re-points accepted and register-noted), the 3 MCP servers pinned in `.mcp.json`, the pnpm keep-entry (`:62-65`) deleted with delete-when-moot unified, the image-size trigger carried as a register row, and `dependency-drift.sh:279`'s false mobile premise corrected (parse the mobile importer or restate the comment)                                                                                                                                                                                                                                                                                                                                                                                  | N/A   |

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

**The frontier is closed** — sections A–D all empty, 01/09/2026. What remains of this map is
build: the three slices above.

### A — The register

| Node  | Decision                                                                                                                                                                                                                                                                            | Type     | Blocked by | Blocking? |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | --------- |
| N-006 | **`REFERENCES.md`'s stack table** — promoted to the register, demoted to a docs index with the version column **removed**, or retired. 22 rows, 12 `latest`, and 6 rows name technologies pinned in no manifest at all (HTMX and Alpine are pinned **nowhere**)                     | grilling | none       | no        |
| N-007 | Does the register carry an **owner column** — none of the **five** `how-to/src/` answer sheets does (re-measured 01/09/2026: five register sheets exist, not three; zero owner columns holds), and the Destination promises one                                                     | grilling | none       | no        |
| N-008 | Is the register **gated by a script** or kept true by prose discipline — precedent runs both ways, and `copier.yml:76-84` records prose-only discipline failing before. Sharpened by N-005 + N-009: what keeps the `how-to/src/` sheet and `renovate.json` in step is this question | grilling | none       | no        |

_N-005 resolved 01/09/2026 — see Resolved decisions._

### B — The mechanism

**Empty — every node resolved 01/09/2026** (N-009, N-010, N-012 in batches one and two; N-013
dissolved; N-011, N-014 in batch five). See Resolved decisions.

### C — The watched set

**Empty — every node resolved 01/09/2026** (N-015, N-016, N-017, N-018, N-019, N-020). See
Resolved decisions.

### D — Corrections found while charting

| Node  | Decision                                                                                                                                                                                                                                                                                                                                                                                                                               | Type  | Blocked by | Blocking? |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- | ---------- | --------- |
| N-022 | Does self-hosted Renovate (`Q1→3`: a PAT plus `renovatebot/github-action`, no external app) earn a row in `how-to/src/PLATFORM-PROVIDERS.md`, and where — a CI bot with write access fits neither of `PROVIDER-NEUTRALITY.md`'s **two** seam kinds cleanly (corrected 01/09/2026: the map said "four"; the register's own sections are five, the seam kinds two); _Process dependencies_ is the likely section now no app is installed | build | none       | no        |

_N-021 resolved 01/09/2026 — re-verified and graduated to `GAPS.md`; see Resolved decisions._

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

### Suggested first batch

**Both blocking batches taken and settled 01/09/2026** — N-005 + N-009 (`Q1→3` · `Q2→2`), then
N-010 + N-012 (`Q3→2` · `Q4→1`). Next sittings pick from the takeable-now batches named above the
frontier.

**N-021 settled 01/09/2026** — re-verified (no cargo step in `audit-deps.yml`; `cargo-deny` only
via path-filtered `syntax-rust.yml`) and graduated to `GAPS.md`, per `Q6→2`.

**N-017, N-019 and N-020 batch together** as the three scope questions that need no mechanism to
answer: they are about which pins deserve a trigger at all.

---

## Fog of war

In scope, not yet sharp enough to state as a decision. **Leaving something here is honest.**
**Emptied 01/09/2026** — every item settled, graduated or struck during the resolve sitting; the
map is fully charted.

- ~~**Whether one mechanism can serve all of them.**~~ **Settled by N-009, 01/09/2026** — one
  tool, Renovate self-hosted, reaches all 12 classes; the per-class blast-radius differences move
  into N-010's cost answer and the C-section nodes.
- ~~**Whether "immediately" generalises.**~~ **Sharpened by N-010, 01/09/2026** — it does not:
  the general posture is approval-gated (a human ticks the dashboard box). Whether any row beyond
  Expo carries an _immediately_ obligation is register content, settled row by row as S-01 writes
  the trigger column.
- **Whether the register and the watcher can disagree.** Now concrete (01/09/2026): the watcher is
  `renovate.json` and the register a `how-to/src/` markdown sheet, and nothing keeps them in step.
  Graduated into N-008's wording — it resolves there, not here.
- ~~**Whether `ubuntu-latest` at 53 sites is a pin at all.**~~ **Graduated 01/09/2026** — the
  settled register shape (coverage or **stated exemption**, `Q7→2`) fits it exactly: it becomes an
  explicit exemption row in S-01 (unversioned runner image, nothing to watch, accepted and
  stated).
- ~~**What a generated project inherits.**~~ **Settled across the sitting, 01/09/2026** — all
  three halves: the obligation floor stays template-only (`CONTRIBUTING.md:238-241`), the register
  sheet ships (`Q2→2`), and the mechanism ships secret-gated (`Q4→1`).

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

| Date       | Node settled                  | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | Frontier redrawn |
| ---------- | ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 16/08/2026 | _none — seeding_              | Seeded out of the template-health grilling, on Sam's call that the general case is its own map. Two members and the measured gap recorded; **not charted**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | [ ]              |
| 28/08/2026 | N-001 · N-002 · N-003 · N-004 | **Charted: 22 nodes, 18 open, 5 blocking, 4 discharged by measurement.** The seeded evidence was **voided and re-derived** — every figure it carried was wrong, and the `deny.toml` member was false on the day it was written, its quoted trigger existing nowhere but the map. The inventory is **113 upstreams across 8 ecosystems**, not twenty across five. The _"nothing watches releases"_ claim is **refuted and narrowed** to _unprompted_, and the Expo trigger was found alive in two homes whose own words defer to this map. Bounds confirmed by Sam: `Q4→2`, `Q5→1`, `Q6→2`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | [x]              |
| 01/09/2026 | N-021 · N-005 · N-009 · N-013 | **First RESOLVE sitting.** Batch = N-005 + N-009 as one grilling pass (the home and the mechanism are one question); N-021 discharged first per the map's own instruction — re-verified and graduated to the `GAPS.md` entry of 01/09/2026. Re-measurement (four agents, internal + external): every load-bearing claim confirmed except four drifts, all corrected on the map — **five** `how-to/src/` register sheets, not three (zero owner columns holds); `PROVIDER-NEUTRALITY.md` defines **two** seam kinds, not four; Dependabot's branch prefix became configurable **04/08/2026**, before charting, so the option table was wrong the day it was written; and `target-branch` does **not** disable security updates. Also measured: Renovate runs app-free via `renovatebot/github-action` on a schedule, and `update.sh --check`'s PyPI major scan only runs in the no-`uv.lock` branch — here the live Python leg is lock-drift. **The batch then settled by grilling** (Sam `Q1→3` · `Q2→2`): N-009 = Renovate **self-hosted** (`renovatebot/github-action`, scheduled, PAT — no external app); N-005 = **two files split by act** — a shipping `how-to/src/` register sheet plus `CONTRIBUTING.md` keeping the copier-excluded obligation floor. N-013 dissolved (no script leg exists to home). Frontier redrawn: 14 open, blocking down to N-010 + N-012, both takeable | [x]              |
| 01/09/2026 | N-010 · N-012                 | **Second batch, same sitting** (grouped: both decide what the shipped Renovate config may do). Sam `Q3→2` · `Q4→1`: N-010 = **dashboard with approval** — one issue, zero PRs until ticked, vulnerability PRs still immediate (the `audit-deps.yml` precedent); N-012 = **ships, secret-gated** — `renovate.json` + workflow inherited, no-op with an explicit "unconfigured" notice until a project adds its PAT, no `_exclude` rows. **All blocking nodes now closed.** Slices S-01/S-02/S-03 cut with every open node assigned; N-011 unblocked; two fog items settled ("immediately" does not generalise — approval-gated; the inheritance question answered in all three halves)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]              |
| 01/09/2026 | N-006 · N-007 · N-008         | **Third batch, same sitting** (grouped: one surface — the sheet's columns and its gate). Re-measurement first: 22/12 confirmed, but the "6 rows pinned in no manifest" figure **refuted** (5 in no manifest, 8 without a version constraint) and **five `latest` rows are actually pinned** — the shipped table is wrong in both directions; gate precedent measured precise (2 of 5 sheets gated, both by name never version; no version comparator exists anywhere). Sam `Q5→1` · `Q6→1` · `Q7→2`: `REFERENCES.md` loses its Version column; owner by exception over a prose default; coverage gate with **no version column** (census ↔ register ↔ `renovate.json`, both directions, the `negative-space.sh` pattern). **Cross-map fact from Sam:** django-htmx's removal (plain htmx) is `MAP-ABSENCE`'s — its census row is that map's to retire. Section A empty; 9 open, 0 blocking                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | [x]              |
| 01/09/2026 | N-017 · N-019 · N-020         | **Fourth batch, same sitting** (grouped: which pins deserve a trigger at all — none needs the mechanism to answer). Re-measurement first, three drifts: the floor doctrine's wording is _"deliberately, say why beside it"_ (a paraphrase was on the map); **"neither ships" refuted** — `.mcp.json`, `.agents/` and `skills-lock.json` all ship; the N-020 opposition re-anchored to `pnpm-workspace.yaml:62-65` vs `deny.toml:22-25`. **Found on the way: `argon2-cffi` entirely unused — runtime hashes PBKDF2** (no `PASSWORD_HASHERS` in `base.py`); routing held for Sam. Sam `Q8→2` · `Q9→1` · `Q10→1`: no blanket floors (unfloored-by-policy register annotation); pin all six dev-tooling upstreams and watch them; delete-when-moot unified, the pnpm keep-entry goes, image-size becomes a register-row trigger. 6 open, 0 blocking                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]              |
| 01/09/2026 | N-011 · N-014                 | **Fifth batch, same sitting** (the shipped config's last two inputs; tracer leg first). N-014 **discharged by measurement**: every version-pin position Renovate reads is token-free; only the staging/prod ghcr `image:` refs are load-bearing tokens (skip/warn here, real downstream); `check-template-parsers.sh` relocated on the map to `.github/scripts/`. External re-measure: `baseBranches` renamed **`baseBranchPatterns`**; env passthrough (`RENOVATE_BASE_BRANCH_PATTERNS`) reaches the self-hosted container while repo config leaves it unset. Measured: no git doc covers bot PRs; zero shipped workflows carry a token in an executable position, ruling out a rendered base-branch token. Sam `Q11→2`: **the watcher targets the integration branch, detected** — `testing` where it exists, else default; the git guide gains its bot-PR sentence. Sections A + B empty; 4 open, 0 blocking                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]              |
| 01/09/2026 | N-015 · N-016                 | **Sixth batch, same sitting** (the watched-set pair; both in scope per `Q5→1`). Re-measurement found **both questions already answered by doctrine and violated in practice**: `SUPPLY-CHAIN.md:68` commands SHA pins (0 of 144 comply); `SECRETS-AND-TRANSPORT.md:67` bans `latest` (4 `uv:latest` sites). Census corrections: 18 exact-tag **sites** not 5; the fifth image is `python:3.14-slim`, node 24 never was one. Sam `Q14→1` · `Q15→3`: SHA-pin all sites bot-maintained; images split by what ships (build-graph digest-pinned with `uv` matched to the CI pin; dev services on specific tags, rolling re-points accepted). **Held finding resolved (Sam): argon2-cffi/PBKDF2 is not a gap** — syntek-modules' authentication module owns the wiring; recorded in `.claude/MEMORY.md`. 2 open (N-018, N-022), 0 blocking                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | [x]              |
| 01/09/2026 | N-022 · N-018                 | **Seventh batch — the frontier closes.** N-022 specified into S-02 direct (Sam confirmed): a _Process dependencies_ row in `PLATFORM-PROVIDERS.md`. N-018 re-measured then settled (Sam `Q16→2`): **mobile split with `expo` as the signal** — the SDK-aligned set ignored (`bundledNativeModules.json`-derived; alignment belongs to `npx expo install --fix`, since npm-latest bumps break it leaving CI green and Renovate has no SDK-aware behaviour), `expo` dashboard-only with a never-merge rule, non-aligned dev tools watched. Corrections: the 18 pins are 11 tilde / 5 caret / 2 exact; `dependency-drift.sh:279`'s premise false in its own source (fix = S-03 leg). Fog emptied: `ubuntu-latest` graduated to an S-01 exemption row. **Frontier and fog both empty — the map is fully charted; the build is S-01–S-03**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]              |

---

## Gate to stories

- [x] **Destination and out-of-scope bounds confirmed** — Sam, 28/08/2026 (`Q4→2 Q5→1 Q6→2`)
- [x] **The pin inventory enumerated** — N-001; 113 upstreams, ~356 sites, 8 ecosystems, with where each is pinned
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 0 closes · 0 blocks · 1 unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired; **six takeable now**
- [x] **Every node marked blocking is resolved** — N-005, N-009, N-010, N-012 all settled 01/09/2026
- [x] Every resolved node links to the artefact it became — **N-001 to N-004 became tables in this
      map and nothing outside it.** Deliberate, and named as a cost
- [x] **Every slice has a flag manifest** — S-01, S-02, S-03 cut 01/09/2026, all flags `N/A` as
      expected (no model, endpoint, screen or personal-data path)
- [x] **No index row in `CONTEXT.md`** — the interim decline `MAP-RULE-OWNERSHIP` N-010 settled on
      28/08/2026; the row arrives with that map's slice S-06

**This is a template-development map, so there are no stories to cut.** The equivalent gate is that
**All four blocking nodes settled 01/09/2026** — Renovate self-hosted, the two-file split,
approval-gated cost, ships secret-gated. The register and watcher may now be built: the slices
above are the base, and the remaining open nodes refine them without gating them.
