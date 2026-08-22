# MAP-UPSTREAM-TRACKING — watching what this template pins

**Seeded**: 16/08/2026 · **Seeded by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Seeded, not charted** — the frontier below is deliberately empty
**Frontier open**: 0 · **Blocking open**: 0 · **Resolved**: 0

> **Seeded, not charted, and the distinction is the point.** This file exists because N-022 on
> `MAP-BASE-HEALTH` measured a class it could not settle, and losing that measurement to a session
> boundary was the alternative. **Nothing here is a decision.** The frontier is empty because
> charting it is a `/wayfinder` CHART sitting that has not happened — do not read the empty table
> as "no open decisions". Precedent for a seeded map: `MAP-SCALE-PLANNING.md`, seeded at generation
> with every row `TBD`.
>
> **Committed here, never shipped.** This file is tracked, so it syncs across devices, and
> `copier.yml` `_exclude` empties the artefact trees at generation — deliberately: these are
> **the template's** upstream pins, and a generated project inherits its own set rather than this
> one. **No row is added to `01-FEATURE-MAPS/CONTEXT.md`'s Map index** — that file ships, and a shipped
> file may cite layering-system artefacts only, never a per-project instance (the same rule
> `MAP-BASE-HEALTH` records against itself).

---

## Destination

Every upstream technology this template pins has a **named watcher, a stated trigger and an
owner** — so that a release, an advisory or a deprecation reaches a human by some mechanism other
than somebody happening to look. Today exactly one of roughly twenty does.

---

## Notes

| Field                    | Value                                                                                          |
| ------------------------ | ---------------------------------------------------------------------------------------------- |
| Domain                   | Template maintenance — syntek-base's own upstream surface, not a generated project's           |
| Skills to load           | `cicd` (the pipelines and the dependency set) · `wayfinder` (to chart) · `runbook` (the guide) |
| Standing preferences     | The obligation belongs to whoever maintains the template; it never ships downstream            |
| Umbrella ADRs            | **None, and none is possible** — this template authors no ADRs (`../15-DECISIONS/CLAUDE.md`)   |
| Register entries triaged | 0 — not charted yet                                                                            |

---

## What is already measured

The two members below arrived from `MAP-BASE-HEALTH` with their evidence, and are recorded here so
a CHART sitting starts from measurement rather than from scratch. **They are not nodes.**

| Member                      | Measured state                                                                                                                                               |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Expo SDK** — settled      | The **only** pin with a decided trigger. Owner split by act; the template follows every SDK release, a project adopts on its first store build. N-022, 16/08 |
| **AccessKit / `quick-xml`** | `code/src/rust/deny.toml:31` gates two RUSTSEC suppressions on a date **and** an event — _"or sooner if Slint bumps accesskit"_. **Nothing watches either**  |

**The gap, measured 16/08/2026 and stated as a negative because that is what it is:**

- **Nothing in the repository watches upstream _releases_ for any technology.**
  `.github/workflows/audit-deps.yml` (`cron: "0 6 * * *"`) is a **CVE sweep** — `pnpm audit` plus
  `pip-audit` — which opens an issue for **advisories**, not for new versions, and covers JS and
  Python only. `code/src/scripts/audits/dependency-drift.sh` compares an **incoming template**
  against a project. Neither looks upstream. There is no Dependabot and no Renovate config.
- **`REFERENCES.md`'s stack table is not a register.** 17 rows, of which **9 read `latest`** — so
  over half record no version at all, and the table is a documentation index that happens to carry
  some numbers.
- **The pins are scattered by ecosystem**, with no single list: `pyproject.toml`, `pnpm-lock.yaml`,
  `code/src/mobile/package.json`, `code/src/rust/Cargo.toml`, `.nvmrc`, `.python-version`,
  `.opengrep-version`, `code/src/rust/.cargo-deny-version`, `rust-toolchain.toml`, the Dockerfiles.
- **cargo-deny's stale-ignore signal fires too late to be a watcher.**
  `warning[advisory-not-detected]` can only appear **after** somebody has regenerated `Cargo.lock`
  — which is the very act a trigger is supposed to prompt.

---

## Fog of war

In scope, not yet sharp enough to state as a decision. **Leaving something here is honest.**

- **Whether one mechanism can serve all of them.** ~20 technologies across five ecosystems, with
  different release channels, notification surfaces and blast radii. A single watcher may be the
  wrong shape, and "one register plus per-ecosystem watchers" may be the right one — that is the
  first thing a CHART sitting has to decide, not assume.
- **What the pin inventory even is.** The list above is a floor gathered in passing; nobody has
  enumerated every pinned upstream in this repository.
- **Whether the obligation survives generation.** These are the template's pins. A generated
  project inherits a snapshot and then diverges — whether it inherits a _mechanism_ too, and
  whether that mechanism is the same one, is undecided.
- **Whether "immediately" generalises.** N-022 settled Expo on _follow every release, immediately_,
  chosen precisely because a per-technology readiness judgement does not scale. Whether that holds
  for a database major, a language runtime, or a toolchain pin is exactly what this map is for.
- **What a trigger is allowed to cost.** A watcher that opens an issue per release across twenty
  technologies is noise; one that opens none is the current state.

---

## Out of scope

| Ruled out                                    | Why                                                                                                                                                       |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Security advisories                          | Already covered — `audit-deps.yml` sweeps CVEs daily and `rust/audit.sh` gates the Rust tree. This map is about **releases**, which is a different signal |
| A generated project's own dependency updates | `how-to/workflows/07-dependency-updates/` and `code/src/scripts/dependencies/update.sh` own that                                                          |
| The Expo trigger itself                      | Settled by N-022 on `MAP-BASE-HEALTH`, 16/08/2026. It enters here as a **worked example**, not a question                                                 |
| Authoring an ADR for any of it               | This template authors no ADRs (`../15-DECISIONS/CLAUDE.md`)                                                                                               |

---

## Session log

| Date       | Node settled     | Outcome                                                                                                                                                                                            | Frontier redrawn |
| ---------- | ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 16/08/2026 | _none — seeding_ | Seeded out of N-022's grilling on `MAP-BASE-HEALTH`, on Sam's call that the general case is its own map rather than a node on that one. Two members and the measured gap recorded; **not charted** | [ ]              |

---

## Gate to stories

Every box below is unticked because **this map has not been charted**. It is listed in full so the
CHART sitting has its checklist rather than reconstructing one.

- [ ] Destination and out-of-scope bounds confirmed
- [ ] The pin inventory enumerated — every pinned upstream in the repository, with where it is pinned
- [ ] Every open `GAPS.md` / `DEFERRED.md` entry triaged
- [ ] Every knowable decision is a node or in fog of war
- [ ] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved**
- [ ] Every resolved node links to the artefact it became
- [ ] ~~Index row in `CONTEXT.md` current~~ — **deliberately not applicable**, see the header
