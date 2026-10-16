# MAP-PIN-DETECT-MOVE — Pin every dependency, scan the pins, move them deliberately

**Charted**: 16/10/2026 · **Charted by**: Sam, with Claude · **Workflow**: `01-feature-map`
**Charted at**: `73fd24d` (working tree, nothing committed)
**Status**: Blockers clear — stories may start · charted 16/10/2026; thirteen decisions Sam
settled in a grilling sitting before the chart enter as resolved, the map's home was asked at CHART,
three answers the Step 7 research reopened were settled in a same-day RESOLVE batch, and the three
grilling nodes an independent review's findings opened were settled with N-022 in a second; two
provisional slices drawn, re-cut at Step 8a next
**Frontier open**: 2 · **Blocking open**: 0 · **Resolved**: 25 · **Slices**: 2

> **Committed here, never shipped.** `copier.yml` `_exclude` empties `project-management/src/**`
> at generation, so this map charts **syntek-base's own** supply-chain work and never reaches a
> generated project; what its slices build does ship. **No row is added to
> `01-FEATURE-MAPS/CONTEXT.md`'s Map index** — declined on the record under N-001 on
> MAP-REGISTER-INDEXES, which relocates the index to `MAP-INDEX.md` (`US010`); this map takes its
> row there when `US010` counts the maps (see `GAPS.md` 01/09/2026 — the index-row instruction).
>
> **This is Thread A** of the 14/10/2026 dependency sweep's follow-ups
> (`handoffs/HANDOFF-IMAGE-SCANNING-14-10-2026.md`). It began as Docker image scanning. Sam widened
> it the same day into the rule the scan serves ("Add it to thread a", said before Q9 was asked;
> Q9 then set its scope), and said, with his Q12 answer, "we want to go with pinned packages where
> possible to ensure security".
>
> **Evidence lives in one research note**, cited by path, section heading and claim code:
> `research/IMAGE-SCANNING-AND-PINNING.md`. It records the Grype measurements, the Grype, pnpm, uv,
> Expo and GitHub runner facts, and the repository's state at `73fd24d`. This map is the index.

---

## Destination

Every dependency surface this template ships is pinned exactly where the repository controls it,
scanned for advisories against those pins (Grype for the shipped django prod image), and moved only
deliberately: routine moves wait out a 7-day cooldown, and security moves happen at once through a
named, reasoned exception. One pin-detect-move rule in `code/docs/security/SUPPLY-CHAIN.md` states
it. _(Confirmed as written by Sam, this conversation, 16/10/2026 (Q15).)_

---

## Notes

| Field                    | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Domain                   | The supply-chain surfaces: the Python and JS manifests and lockfiles (root and mobile), the uv and pnpm settings that govern a move, the uv pins in CI and the Dockerfiles, the base and service image references, the action pins, and a new image audit with its ignore file, pin file, local installer, nightly leg and advisory workflow                                                                                                                                                                                                                                                                                                                                                                                                                       |
| Skills to load           | `cicd` (workflows, Dockerfiles, the dependency set), `security` (the scan and its policy), `doc-writer` (`SUPPLY-CHAIN.md`, `SECRETS-AND-TRANSPORT.md`, the audits rows), `global-workflow`; `grill-with-docs` for any node Step 8a opens; procedures of record `how-to/workflows/06-quality-gates/` and `how-to/workflows/07-dependency-updates/`                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Standing preferences     | Script-first (`.claude/CLAUDE.md` Section 6); a skip is never a pass (`code/docs/GATE-REPORTING.md`); one enforcer per rule; a workflow is path-filtered or required, never both (`project-management/docs/git/PR-AND-REQUIRED-CHECKS.md:42-48`); `audits/CLAUDE.md`'s registration rules for a new audit; N-015 and N-016 on MAP-UPSTREAM-TRACKING (SHA pins; images split by what ships)                                                                                                                                                                                                                                                                                                                                                                         |
| Confirmed by Sam's "yes" | Sam answered the whole design table "yes" (this conversation, 16/10/2026). Beyond Q1 to Q13 it carried: `SECRETS-AND-TRANSPORT.md:68` narrowed to Grype; the audit's rows in `audits/CONTEXT.md` and the README audit register; `code/src/docker/CONTEXT.md:33-35` corrected to agree with N-016 on MAP-UPSTREAM-TRACKING. The Q18 option Sam chose also named a check that fails on any specifier that is not exact; where that check lives is N-026                                                                                                                                                                                                                                                                                                              |
| Minor calls on record    | Made by Claude and not overridden by Sam (this conversation, 16/10/2026): the wrapper maps Grype's exit codes onto the audit convention and always passes `-c .grype.yaml`; the scan builds `Dockerfile.prod`, whose package content matches `Dockerfile.staging`; each ignore rule's `reason:` carries why and its re-check trigger; each run downloads a current database rather than caching one; the three workflows whose `setup-uv` steps pass no version (`audit-render-slop.yml`, `audit-template.yml`, `test-e2e.yml`) gain a `UV_VERSION` and pass it; pnpm settings move to where pnpm 11 reads them; Q9 ruled Renovate, MCP pins and copier out of Thread A, and Claude then routed them to their existing owners rather than to new `GAPS.md` entries |
| Confirmed after charting | Sam, this conversation, 16/10/2026: the destination and the drafted Out rows as written (Q15); two slices, pin-and-move then detect (Q16)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Umbrella ADRs            | None. A node passing the three-test gate becomes `ADR-US###-*` authored by its slice's story — never by this map                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| Evidence                 | `research/IMAGE-SCANNING-AND-PINNING.md`, written alongside this map and independently verified the same day; a RESOLVE sitting re-reads the section it leans on                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| Register entries triaged | 0 closes, 1 blocks, 25 unrelated — 26 open `GAPS.md` entries (the four loose items under "Still open, found on the way" counted one each, and the 16/10/2026 issue #14 entry appended alongside this map); `DEFERRED.md` has no rows; SL-1 to SL-3 exempt                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Evidence limitation      | context7 and Perplexity were unauthenticated this session, so neither tier was consulted (could not look, not looked-and-clean). The built prod image was never scanned: no project script builds `Dockerfile.prod`, so the first baseline belongs to S-02                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Scale baseline           | `how-to/src/SCALE-ARCHITECTURE/` holds template skeletons. The scan adds CI load only, so no node assumes a size                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |

### Owners across maps

- **S-03 on MAP-UPSTREAM-TRACKING** ("The pins made watchable") keeps the MCP servers (five today,
  not the three its row names), the postgres/valkey re-point register note, the image-size trigger
  row, the pnpm keep-entry with its delete-when-moot unification, and the `dependency-drift.sh`
  correction. **Its image half is built by S-01 here**: the `python:3.14-slim` digest pin, the uv
  pin and nginx's specific tag, with uv's value moving from "the CI version", `0.12.5` at its
  writing, to `0.12.24`, CI included (N-017). The four tag-pinned `uses:`, in two workflows this branch added on 16/09/2026
  and 18/09/2026 and so outside #15, are pinned by S-01 here (N-009). An edge note on that map records this.
- **S-02 on MAP-UPSTREAM-TRACKING** (Renovate) is out of scope here. When it lands it watches
  `.grype-version` too (Q7), under N-010 on MAP-UPSTREAM-TRACKING (dashboard approval). Its
  vulnerability carve-out opens PRs at once, which meets S-01's strict 7-day pnpm cooldown (Fog of
  war). Its acceptance also cites `SUPPLY-CHAIN.md:36`, the line S-01 rewrites: S-01 keeps a
  watcher clause there or moves that citation in the same change.
- **S-01 on MAP-UPSTREAM-TRACKING** (the pin register) is unbuilt. `.grype-version` takes a row in
  the toolchain-pins table (`PR-AND-REQUIRED-CHECKS.md:151-169`) now (Q7); when the register lands,
  Grype and cosign take rows there too.
- **N-003 on MAP-UPSTREAM-TRACKING** settled the Expo trigger, whose template-side home is
  `CONTRIBUTING.md:245-248` (the project-adopts home, `code/src/mobile/CLAUDE.md:40-47`, is
  unaffected). N-015 here moves it from "on release" to "once past the cooldown". An
  edge note on that map records this.
- **N-010 on MAP-GATE-PARITY** (S-05 there) pins copier at its two live invocations. A third copier
  site, `.github/scripts/shipped-ai.sh:31`, is recorded beside it by an edge note there. The uv
  cooldown cannot govern any of them, because `uvx` ignores project settings
  (`research/IMAGE-SCANNING-AND-PINNING.md`, UV 7).
- **MAP-BUN-TOPOLOGY** claims the `pnpm-update.sh` header entry. That script's bare
  `pnpm self-update` takes pnpm's built-in one-day cooldown, not the workspace's 7 days (PN 5);
  S-01's rule governs tool moves, and whichever change lands second conforms. An edge note there
  records this.
- **`US006`** (MAP-SCRIPT-GUARDS) is the only planned reader of the deployment posture, and that map
  keeps CI out of its own scope (`MAP-SCRIPT-GUARDS.md:157`), consistent with N-008.
- **`US002`** owns the audits register's headroom in general; N-022 settled this map's share by
  compression. **N-004 on MAP-NATIVE-MOBILE-SURFACE** asks the same question for that map's rows;
  an edge note there records N-022's answer for its next sitting.

---

## Register claimed

**This is a claim, not a close.** This map edits neither `GAPS.md` nor `DEFERRED.md`, and nothing
was closed. One entry is appended to `GAPS.md` alongside it, not by it: the 16/10/2026 public
tracking-issue entry, the home Q8 gave that concern. Closing is
`workflows/22-implementation-documentation/`'s, against shipped code.

| Register | Entry                                                                                           | Verdict | Retired by / wired to                                                                                                                                                                                                                                                                                   |
| -------- | ----------------------------------------------------------------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GAPS.md  | 17/09/2026 — the audits register's headroom is one line smaller than nineteen artefacts believe | blocks  | N-022 — S-02 adds rows to `audits/CONTEXT.md`, at its ceiling under an allowance expiring 01/12/2026 (RE 14: as `docs-length.sh` measured it on 16/10/2026). Settled by N-022: S-02 pays for its rows by compressing existing lines; N-026 keeps S-01 out of the file. The headroom itself is `US002`'s |

**Unrelated (25).** Seven constrain this map without blocking it:

- **01/09/2026 RUSTSEC invisible.** Already retired by PR #15's Rust leg (`audit-deps.yml:133-188`),
  so this map does not claim it; workflow 22 marks it closed.
- **02/09/2026 `doc-references` against the PM tree.** It blocks the PR that carries this map to
  `main` (529 findings on this branch, 16/10/2026), not either slice; the ruleset lets the admin
  role bypass it.
- **09/09/2026 `_migrations` advisory invisible.** It binds S-01 if S-01 ships a migration
  advisory for the exact pins or the cooldown.
- **16/08/2026 `pnpm-update.sh` header.** Claimed by MAP-BUN-TOPOLOGY (see owners above).
- **11/09/2026 Bun tracers lack Bun.** Its `uvx copier` clause is owned by N-010 on MAP-GATE-PARITY.
- **09/10/2026 the Playwright pin.** The repository's one host-coupled exact pin: S-01's rule must
  say how a pin that follows the host's browser bundle moves, and must not contradict
  `audits/playwright-pin.sh`.
- **16/10/2026 issue #14 publishes advisory detail.** Appended alongside this map; S-02's leg
  reports into that issue, so the entry's outcome binds S-02's issue section.

The other eighteen are unrelated outright: the three other loose items under "Still open, found on
the way"; 31/08/2026 PE gate; 31/08/2026 htmx major 2; 01/09/2026 no mail backend; 01/09/2026 story
`Status` vocabulary; 01/09/2026 index-row instruction (declined above); 09/09/2026 security block
twice; 11/09/2026 `install-frontend.sh`; 16/09/2026 MCP declared twice; 17/09/2026 maps refuted by
their tables; 17/09/2026 backlog register ungated; 18/09/2026 Codex instruction budget; 09/10/2026
one GitHub identity; 15/10/2026 `mutmut.sh`; 15/10/2026 design hand-off tracers; 15/10/2026
external store waits on 0.5.0. The 16/08/2026 sitting's Q10 and Q15 rows ("still open") were read
too and touch none of this.

---

## What is already measured

Facts, not decisions. Re-measure before leaning on one at RESOLVE
(`workflows/01-feature-map/STEPS.md` Step 8.1). Sources are sections of
`research/IMAGE-SCANNING-AND-PINNING.md` unless a path is given.

| Fact                                                                                                                                                                                                                                | Source                                                                        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Only the django image ships: staging and prod Compose define `django` alone, and Postgres, Valkey and Nginx run on the server. Staging and prod images hold the same packages                                                       | "The repository today - images, pins and gates"                               |
| No workflow builds `Dockerfile.prod` or `Dockerfile.staging`, and none publishes an image                                                                                                                                           | Same section; `GAPS.md` SL-2                                                  |
| `python:3.14-slim` (Debian 13): 161 matches, 159 of them Debian packages with no fix; `--fail-on low --only-fixed` fails only on 2 Medium CPE matches against the CPython binary. Each Alpine service image has 1 fixable High      | "Measured - Grype against the base and service images"                        |
| Grype exits 2 on findings and 1 on error, the reverse of the audit convention; its database is about 190 MB compressed, published daily and refused once built more than 120 h ago; ignore rules carry `reason` but no expiry       | "Measured" (GM 9); "Grype - install, verification, database and ignore rules" |
| From `0.120.0` Grype signs `checksums.txt`, which lists each archive's hash, with a sigstore bundle. _(Reasoned in the note:)_ with releases immutable since `0.103.0`, checking the bundle then the archive needs no separate hash | "Grype" (GI 1 to GI 4); "Corrections" (CO 3)                                  |
| 27 checks are required on `main`; `[8/8] Security` runs with no Docker; scheduled runs start only from the default branch                                                                                                           | "The repository today" (RE 5); "CI - where a scan can run, and what it costs" |
| Every pnpm install since 11.1.3 re-checks the lockfile against the active release age; setting one explicitly also turns strict mode on; `saveExact` lives in `pnpm-workspace.yaml`; pnpm 11 ignores `.npmrc`'s four keys           | "pnpm 11 - cooldown and exact saves"                                          |
| uv records a relative `exclude-newer` as a span, so the lock does not churn as time passes; `required-version` errors every project command outside its range, not `uvx`; `setup-uv` without `version:` installs the highest match  | "uv - cooldown, exact bounds and the version guard"                           |
| `expo install --check` judges installed versions, not specifiers, so an exact pin and a tilde resolving to one version get the same verdict; Expo serves its floors remotely, and five of today's point at releases days old        | "Expo - exact pins against the cooldown"                                      |
| Today's images build with uv `0.13.1` through `uv:latest`, while CI pins `0.12.5` and the host runs `0.12.22`; `0.12.24` is the newest 0.12.x past the cooldown                                                                     | "uv"; "The repository today"; `uv --version` on this host, 16/10/2026         |

---

## Resolved decisions

N-001 to N-013 were settled by Sam in a grilling sitting on 16/10/2026, before the chart (Q1 to
Q13), and enter as a record, not as a charting outcome. N-014 was asked at CHART (Q14; Q15 and Q16
are recorded in Notes). N-018 to N-021 are research nodes fired at Step 7, each graduated into its
section of the evidence note. Their findings reopened three answers, which Sam settled the same day
as N-015 to N-017 (Q17 to Q19): a same-day RESOLVE batch taken on Sam's answers, not a charting
outcome. **Became** names the graduation target: this map for N-014, and for the other decisions
the Slices row each rides in, a Slices row being a graduation target
(`.claude/skills/wayfinder/SKILL.md`, _Graduation table (RESOLVE step 4)_).

| Node  | Decision                                                                                                                                                                                                                                                                                                                        | Type     | Settled    | Became                                                                                     |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | ------------------------------------------------------------------------------------------ |
| N-001 | **Threshold.** Fail at Low and above, only where a fix exists (`--fail-on low --only-fixed`); the two CPython CPE matches enter as named ignore rules. Sam, this conversation, 16/10/2026 (Q1)                                                                                                                                  | grilling | 16/10/2026 | S-02                                                                                       |
| N-002 | **Where it runs.** A nightly leg in `audit-deps.yml` plus an advisory, path-filtered `audit-images.yml`; neither required, so the required set stays at 27. Sam (Q2)                                                                                                                                                            | grilling | 16/10/2026 | S-02                                                                                       |
| N-003 | **What can fail.** The prod image only; the dev, test and service images are not scanned. Sam (Q3)                                                                                                                                                                                                                              | grilling | 16/10/2026 | S-02; the Out of scope row                                                                 |
| N-004 | **Scope.** Everything Grype catalogues, except Python packages under `/workspace/.venv`, which pip-audit owns through `uv.lock`. Sam (Q4)                                                                                                                                                                                       | grilling | 16/10/2026 | S-02                                                                                       |
| N-005 | **The ignore file ships**, settings and entries together, and the scan fails on a rule that matched nothing. Sam (Q5)                                                                                                                                                                                                           | grilling | 16/10/2026 | S-02                                                                                       |
| N-006 | **Could not run is exit 2.** Grype, Docker or a current database missing exits 2; the pre-PR audits sweep skip-lists the scan with CI as its owner. Sam (Q6)                                                                                                                                                                    | grilling | 16/10/2026 | S-02                                                                                       |
| N-007 | **The scanner pin.** `.grype-version` holds the version only; installs verify the signed checksums with cosign, then the archive against them; a toolchain-pins row; Renovate watches it once S-02 on MAP-UPSTREAM-TRACKING lands. Sam (Q7)                                                                                     | grilling | 16/10/2026 | S-02                                                                                       |
| N-008 | **Live findings.** A documented rule tied to `.claude/CLAUDE.md` Section 0; CI reads no posture. The public-issue concern goes to `GAPS.md`. Sam (Q8)                                                                                                                                                                           | grilling | 16/10/2026 | S-02; the 16/10/2026 `GAPS.md` entry                                                       |
| N-009 | **Thread A's scope.** The rule in place of `SUPPLY-CHAIN.md`'s generic text, the image half of S-03 on MAP-UPSTREAM-TRACKING, the uv cooldown and version guard, and SHA pins for the four tag-pinned `uses:`; Renovate, MCP pins and copier are not Thread A's. Sam (Q9)                                                       | grilling | 16/10/2026 | S-01; the owners above                                                                     |
| N-010 | **The cooldown is 7 days** for pnpm, uv and scanner releases; a security move skips it through a named, reasoned exception. Sam (Q10)                                                                                                                                                                                           | grilling | 16/10/2026 | S-01 (dependencies and tools); S-02 (the Grype pin)                                        |
| N-011 | **A verified local installer**, `development/install-grype.sh`, pinned and cosign-verified like `install-opengrep.sh`, but checking Grype's sigstore bundle and then the archive's hash, which that script's recipe does not. Sam (Q11)                                                                                         | grilling | 16/10/2026 | S-02                                                                                       |
| N-012 | **uv is exact where builds happen**: CI and the Dockerfiles pin one version exactly; `required-version` bounds the host to the same minor. Sam (Q12; the value is N-017)                                                                                                                                                        | grilling | 16/10/2026 | S-01                                                                                       |
| N-013 | **Exact direct pins** in `pyproject.toml` and the root `package.json`, with `code/src/mobile/package.json` exempt only if `expo install --check` rejects exact pins; `add-bounds = "exact"` and pnpm `saveExact` keep additions exact; `update.sh` moves manifest and lock together. Sam (Q13). The condition failed: see N-016 | grilling | 16/10/2026 | S-01; `add-bounds` reopened and dropped as N-025                                           |
| N-014 | **This map is the home.** A new map rather than a sitting reopening MAP-UPSTREAM-TRACKING, whose frontier closed 01/09/2026. Sam (Q14)                                                                                                                                                                                          | grilling | 16/10/2026 | This map; the edge note on MAP-UPSTREAM-TRACKING                                           |
| N-015 | **Expo waits the cooldown too.** `CONTRIBUTING.md`'s "on release" and "immediately" for an SDK release become "once past the cooldown"; security fixes still take named exceptions. Sam (Q17)                                                                                                                                   | grilling | 16/10/2026 | S-01; the edge note on N-003 on MAP-UPSTREAM-TRACKING                                      |
| N-016 | **Mobile is exact as well.** `expo install --check` judges installed versions, so an exact pin gets the same verdict as a tilde, and Q13's condition for an exemption failed; where `expo install` writes a `~`, the mobile update path makes it exact. Sam (Q18)                                                               | grilling | 16/10/2026 | S-01                                                                                       |
| N-017 | **uv `0.12.24`**, the newest 0.12.x past the cooldown; `required-version = ">=0.12.22,<0.13"` unchanged. Sam (Q19)                                                                                                                                                                                                              | grilling | 16/10/2026 | S-01                                                                                       |
| N-018 | **pnpm 11, read:** the cooldown is in minutes and turns strict once set; installs re-check the lock; exceptions are exact versions or names, never ranges; `saveExact` does not convert an existing caret; `pnpm self-update` takes the built-in age, not the workspace's                                                       | research | 16/10/2026 | `research/IMAGE-SCANNING-AND-PINNING.md`, "pnpm 11 - cooldown and exact saves"; feeds S-01 |
| N-019 | **uv, read:** the relative cooldown is stored as a span; `exclude-newer-package` exempts one package; `add-bounds` affects `uv add` only, is a preview setting, and uv's source advises against `exact` because the lock already pins; `uvx` ignores project settings                                                           | research | 16/10/2026 | "uv - cooldown, exact bounds and the version guard"; feeds S-01 and N-025                  |
| N-020 | **CI capacity, read:** the scan fits the public runner's disk; GitHub caches cannot be overwritten, so a cached database never refreshes under one key; `ubuntu-latest` moves to 26.04 between 19/10/2026 and 19/11/2026                                                                                                        | research | 16/10/2026 | "CI - where a scan can run, and what it costs"; feeds S-02                                 |
| N-021 | **Expo, read:** `--check` judges installed versions against ranges Expo serves remotely, so its verdict can change with no change in the repository; five of today's SDK 57 floors are days old                                                                                                                                 | research | 16/10/2026 | "Expo - exact pins against the cooldown"; feeds S-01                                       |
| N-022 | **Room for the audit rows.** S-02 pays for its rows in `audits/CONTEXT.md` by compressing existing lines, the allowance's own remedy, rather than waiting on `US002`. Sam, this conversation, 16/10/2026                                                                                                                        | grilling | 16/10/2026 | S-02; the edge note on N-004 on MAP-NATIVE-MOBILE-SURFACE                                  |
| N-025 | **No `add-bounds`.** Python exactness rests on the exact-specifier check alone; uv's preview `add-bounds = "exact"` is not adopted, reversing that clause of Q13. Sam (16/10/2026)                                                                                                                                              | grilling | 16/10/2026 | S-01                                                                                       |
| N-026 | **The check is a leg of `dependency-drift.sh`**, the existing dependency gate, not a new audit, so it needs no register rows and N-022 does not bind S-01. Sam (16/10/2026)                                                                                                                                                     | grilling | 16/10/2026 | S-01                                                                                       |
| N-027 | **The Grype pin is `0.120.1`**, as the approved design table named; the scan prints the installed and pinned versions side by side and never fails on a gap, as `static-analysis.sh:201-203,221` does. Sam (16/10/2026)                                                                                                         | grilling | 16/10/2026 | S-02                                                                                       |

---

## Slices

**Provisional, written at CHART**, in the form MAP-DESIGN-HANDOFF uses: `workflows/01-feature-map/STEPS.md`
Step 8a re-cuts them once no blocking node remains. Each slice is cuttable only when every node it
names is `✅`; `02-story-creation` writes the story and back-fills `Story`, and no `US###` is
reserved. Every open node belongs to a slice. Acceptance states outcomes; the literals behind them
(setting names, values, file lists) belong to each slice's story and plan.

| Slice | Story | Title                              | Nodes                                                                                                                                                  | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Flags                                                                                                                                                                                                  |
| ----- | ----- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| S-01  | —     | Pin and move                       | N-009 ✅ · N-010 ✅ · N-012 ✅ · N-013 ✅ · N-015 ✅ · N-016 ✅ · N-017 ✅ · N-018 ✅ · N-019 ✅ · N-021 ✅ · N-025 ✅ · N-026 ✅ · N-023 ○            | `SUPPLY-CHAIN.md` states one pin-detect-move rule in place of the generic text at `:17-38` (Q9 named `:17-37`); every direct dependency in `pyproject.toml` and both `package.json` files is exact, pnpm saves new JS additions exact, and a `dependency-drift.sh` leg fails on one that is not; `update.sh` moves a manifest and its lock together; routine moves of dependencies and tools wait 7 days, and every exception names its reason; an Expo SDK is adopted once past the cooldown; one uv version runs in every workflow and every image, and the host's uv is held to the same minor; the base image is digest-pinned and nginx has a specific tag; every `uses:` is SHA-pinned with its version comment; pnpm reads every setting the repository sets; installs and lock checks stay green                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | Security: supply chain (pins, cooldown, exceptions) · QA: integration (CI frozen installs, lock checks, the exact-specifier check), manual (`update.sh` on one Python and one JS move)                 |
| S-02  | —     | Detect: Grype on the shipped image | N-001 ✅ · N-002 ✅ · N-003 ✅ · N-004 ✅ · N-005 ✅ · N-006 ✅ · N-007 ✅ · N-008 ✅ · N-010 ✅ · N-011 ✅ · N-020 ✅ · N-022 ✅ · N-027 ✅ · N-024 ○ | `audits/image-vulns.sh` builds the prod image and scans it under the shipped `.grype.yaml`, failing at Low and above where a fix exists and leaving the venv's Python packages to pip-audit; it exits 0 clean, 1 on findings and 2 when it could not run, prints the installed Grype beside the pin without failing on a gap, fails on an ignore rule that matched nothing, and proves itself on a fixture pair; every ignore rule names why and what triggers a re-check, and the first run's findings are each fixed or entered; Grype is installed at `0.120.1`, in CI and by `development/install-grype.sh`, only after cosign verifies the signed checksums against Anchore's release identity and the archive matches its listed hash; a Grype release moves only past the cooldown or by a named exception; the nightly leg reports into the tracking issue and fails the run, and the advisory workflow runs on any change to what the image or the scan is built from, so the required set stays at 27; each run uses a current database; the pre-PR sweep skip-lists the scan with CI as its owner; the audit has its register rows, paid for by compressing existing lines, and its toolchain-pins row; `SECRETS-AND-TRANSPORT.md:68` names Grype; a live surface's finding is handled under Section 0 | Security: supply chain (signature verification, scan policy); the issue's content follows the 16/10/2026 `GAPS.md` entry · QA: unit (self-test fixtures), integration (a CI dry run of both workflows) |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking.

**Acceptance is what must be TRUE; Flags is which gates RUN.** The 13-flag roster is
`../02-STORIES/US000-TEMPLATE.md`; every flag not written reads `N/A`, because no slice touches a
model, an endpoint, a screen or personal data. The `Story` column is back-filled by
`02-story-creation`.

**Build order (provisional; admission belongs to `03-sprint-planning`):** S-01, then S-02, so the
first scan's baseline is taken against a digest-pinned image (Q16). No size is set at CHART.
`project-management/src/02-STORIES/CUT-PLAN.md` gains this map's section in the change that cuts
its first slice.

---

## Frontier

| Node  | Decision                                                                                                                                                                                              | Type  | Blocked by | Blocking a story? |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- | ---------- | ----------------- |
| N-023 | **Specify S-01's build into its row**: the rule, the exact manifests and the check that holds them, the cooldowns, the uv, image and action pins, the `CONTRIBUTING.md` and `docker/CONTEXT.md` edits | build | none       | no                |
| N-024 | **Specify S-02's build into its row**: the audit, its ignore and pin files, the installer, both workflow surfaces, the rows and the doc edits                                                         | build | none       | no                |

**Takeable now:** N-023 and N-024 — Step 8a re-cuts the slices first, now that no blocking node
remains (`workflows/01-feature-map/STEPS.md`).

---

## Fog of war

- **Renovate's vulnerability PRs against a strict cooldown.** S-02 on MAP-UPSTREAM-TRACKING opens
  them at once; under S-01's explicit 7-day pnpm cooldown, a PR for a release under a week old fails
  its install unless it carries a named exception, and who writes that exception is unsettled.
- **`expo install` over an exact entry.** pnpm keeps an existing entry's style (PN 7); that `expo install`
  passes pnpm an SDK range was read from Expo's source by a lookup and is not in the evidence note. So an exact mobile entry likely stays exact and only a newly
  added SDK package arrives with `~`. Unmeasured; S-01's plan measures it.
- **More images to come.** Celery worker and beat are designed but not shipped
  (`how-to/src/SERVER-ARCHITECTURE/COMPUTE-ALLOCATION.md:131-141`), and a Rust surface gives the
  image a build stage (`code/docs/RUST.md:52`); either changes what N-003 scans.
- **Native libraries inside wheels.** Whether Grype sees the copies `psycopg-binary` and
  `cryptography` bundle is unmeasured; S-02's first run shows it.
- **Ubuntu 26.04.** `ubuntu-latest` moves between 19/10/2026 and 19/11/2026, and its free disk is
  undocumented.
- **The pnpm installer action.** The pinned `pnpm/action-setup` points pnpm 11 users at
  `pnpm/setup` (`pnpm/action-setup@0977fd99`, `README.md:2-6`); moving is an action move under the
  rule, not yet a decision.
- **A database outage.** If Anchore stops publishing for five days, every scan exits 2; how the
  nightly words that is unsettled.
- **The next uv minor.** uv 0.13 clears the cooldown on 16/10/2026, and uv's resolution docs say a
  lockfile may be rejected across minor releases (`docs.astral.sh/uv/concepts/resolution/`,
  "Lockfile versioning"; not in the evidence note); when to move the `<0.13` bound is not yet a
  decision.
- **Expo's warnings.** `expo start` runs a background dependency check unless `EXPO_OFFLINE`,
  `EXPO_NO_DEPENDENCY_VALIDATION` or web-only is set (`expo/expo@396da464`,
  `packages/@expo/cli/src/start/startAsync.ts:89-93`), and `code/src/scripts/mobile/server.sh:56`
  sets none of them; a 7-day lag behind Expo's remote floors may make its warning routine.

---

## Out of scope

| Ruled out                                                   | Why                                                                                                                                                        |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Renovate                                                    | Ruled out of Thread A by Sam (Q9); owned by S-02 on MAP-UPSTREAM-TRACKING (Claude's routing, 16/10/2026)                                                   |
| Pinning the MCP servers                                     | Ruled out by Q9; owned by S-03 on MAP-UPSTREAM-TRACKING, whose row says three servers where `.mcp.json` declares five (Claude's routing)                   |
| Pinning copier at its `uvx copier` sites                    | Ruled out by Q9; N-010 on MAP-GATE-PARITY owns the two live invocations, and an edge note there adds `.github/scripts/shipped-ai.sh:31` (Claude's routing) |
| Scanning the dev, test and service images                   | Only the prod image ships (Q3)                                                                                                                             |
| CI behaviour that reads the deployment posture              | Sam's Q8: a documented rule, no CI posture read; MAP-SCRIPT-GUARDS also keeps CI out of its own scope (`MAP-SCRIPT-GUARDS.md:157`)                         |
| What the public tracking issue may publish                  | Q8; the 16/10/2026 `GAPS.md` entry, because it binds every nightly leg, not only images                                                                    |
| Publishing an image                                         | `GAPS.md` SL-2; a scan that builds on the runner is not that trigger                                                                                       |
| Packaging Grype in Sam's nix-config                         | Another repository; it would follow `.grype-version`, as `pkgs/opengrep.nix` follows `.opengrep-version`                                                   |
| The tag-pinned `setup-uv` in syntek-media and syntek-author | Other repositories                                                                                                                                         |
| Closing the RUSTSEC `GAPS.md` entry                         | Retired by PR #15; workflow 22 closes it                                                                                                                   |

---

## Session log

| Date       | Node settled                                  | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | Frontier redrawn |
| ---------- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------- |
| 16/10/2026 | N-001 to N-013 (sitting, before CHART)        | A grilling sitting on facts gathered and independently verified the same day: Q1 to Q13                                                                                                                                                                                                                                                                                                                                                                                                                                        | [x]              |
| 16/10/2026 | N-014 (CHART); N-018 to N-021 (Step 7)        | Charted: Q14 (home), Q15 (destination and Out rows, confirmed as written), Q16 (two slices); four research nodes fired and resolved into `research/IMAGE-SCANNING-AND-PINNING.md`; register triaged, neither file edited by this map                                                                                                                                                                                                                                                                                           | [x]              |
| 16/10/2026 | N-015 to N-017 (same-day RESOLVE batch)       | Batch reason: the three answers Step 7 reopened, which are one question about what the research changed: Expo's timing against the cooldown, the mobile exemption, the uv value. Sam chose 2, 1 and 2 (Q17 to Q19)                                                                                                                                                                                                                                                                                                             | [x]              |
| 16/10/2026 | none (CHART review)                           | An independent three-lens review the same day. Register count corrected to 26 (0 closes, 1 blocks, 25 unrelated; the Playwright pin moved to constraining); N-022 now blocks S-02; N-013, N-016 and N-017 re-worded to Sam's answers; claims the evidence note does not carry struck or marked; three grilling nodes opened (N-025 to N-027) for clauses no decision covered and one approved value Sam reopened; edge notes written on MAP-UPSTREAM-TRACKING, MAP-NATIVE-MOBILE-SURFACE, MAP-BUN-TOPOLOGY and MAP-GATE-PARITY | [x]              |
| 16/10/2026 | N-022 · N-025 · N-026 · N-027 (RESOLVE batch) | Batch reason: the four open grilling nodes, N-022 from the register triage and the three the review opened, each a clause of one slice's acceptance. Sam chose 2 (N-025: no `add-bounds`), 1 (N-026: a `dependency-drift.sh` leg), 1 (N-022: compress) and 1 (N-027: `0.120.1`, print the gap). No blocking node remains; Step 8a is next                                                                                                                                                                                      | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed — the destination and the drafted Out rows
      confirmed as written by Sam (Q15); Q9 ruled three items out of Thread A, and Claude routed
      them to their existing owners (this conversation, 16/10/2026)
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — 0 closes, 1 blocks, 25 unrelated, against
      26 open entries
- [x] Every claimed entry names what it is wired to; **this map edits neither register file** — the
      issue #14 entry is appended alongside it, not by it, and nothing is closed
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — the last four (N-022 and N-025 to
      N-027) on 16/10/2026
- [x] Every resolved node links to the artefact it became — N-014 to this map; N-001 to N-013 and
      N-015 to N-017 to the Slices rows they ride in; N-018 to N-021 to their sections of the
      evidence note
- [x] **Every slice has a flag manifest** — two provisional slices, re-cut at `STEPS.md` Step 8a
- [x] Index row — declined on the record above; the row lands in `MAP-INDEX.md` when `US010` ships

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked** — per
slice, after Step 8a re-cuts them and N-023 and N-024 are specified into their rows.
