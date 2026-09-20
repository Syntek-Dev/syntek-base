# MAP-NATIVE-MOBILE-SURFACE — Retire React Native; the mobile surface becomes Kotlin and Swift

**Charted**: 20/09/2026 · **Charted by**: Claude (Opus) · **Workflow**: `01-feature-map`
**Status**: Charting
**Frontier open**: 21 · **Blocking open**: 9

> A **low-resolution index**, not a storage vault — every resolved node links to the artefact it
> became. See **The index row, withheld** in `## Notes` below.

---

## Destination

The optional mobile surface is **two native surfaces** — Kotlin/Android and Swift/iOS — gated by
independent `INCLUDE_ANDROID` and `INCLUDE_IOS` answers, reached after the Expo/React Native
skeleton is deleted and the forge migration lands. Done when a project can generate either, both
or neither, and every gate each surface owns **reports rather than skips**
(`code/docs/GATE-REPORTING.md`).

---

## Notes

| Field                    | Value                                                                                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Template surface architecture · CI/CD · governance (skills, audits, docs, copier gating)                                                          |
| Skills to load           | `wayfinder` · `grill-with-docs` · `scaffold` · `cicd` · `doc-writer` · `version` · `code-reviewer`                                                |
| Standing preferences     | See **Settled before charting** below — four decisions from the 20/09/2026 grilling that bound this map                                           |
| Umbrella ADRs            | **None, and none is authored from here.** ADRs are `ADR-US###-…` and story-bound; each slice's story authors its own at PM step `04`–`14`         |
| Register entries triaged | **0 closes · 1 blocks · 15 unrelated** (`GAPS.md`, 16 open entries; standing limitations `SL-1`–`SL-3` exempt). `DEFERRED.md` carries **no rows** |

### Settled before charting

These came from a two-round grilling on 20/09/2026, **before** this map existed. They are
standing preferences that bound the work, not nodes this map resolved — the frontier below starts
downstream of them.

| #   | Decision                                                                                                   |
| --- | ---------------------------------------------------------------------------------------------------------- |
| 1   | **Native Kotlin + Swift as two surfaces** — not React Native, not KMP/Compose Multiplatform                |
| 2   | **Delete the RN skeleton now** rather than freeze or carry it — nothing downstream consumes it             |
| 3   | **Native sequences after the forge migration**, so no CI plumbing is built on a forge already slated to go |
| 4   | **Two independent opt-ins**, `INCLUDE_ANDROID` and `INCLUDE_IOS` — Android-only needs no Apple hardware    |

**The reasoning, recorded once so it is not re-litigated.** The "one codebase" argument for a
cross-platform framework was substantially a staffing and typing argument, and AI-assisted coding
erodes that specific cost. Two further points carried weight: `code/docs/accessibility/MOBILE.md`
concedes in its own text that RN's accessibility props are a **lossy mapping** onto the two
platform stacks ("neither is cross-platform on its own"), against WCAG 2.2 AA as a Section 8
non-negotiable; and `stack-react-native/SKILL.md` documents Expo's pins as a **matched set**
where one SDK bump moves five pins together.

**The counter-argument, kept on the map rather than buried.** A unified codebase makes behavioural
divergence _structurally impossible_; two codebases make it merely _cheap to fix_, and AI arguably
makes drift **easier** because each one-sided change is cheap to make. Nothing in this repository
gates that today. **N-019 owns it** — it is not settled by the decisions above.

### The index row, withheld

No row is added to `CONTEXT.md` → _Map index_, on the settled decision **N-010 on
`MAP-RULE-OWNERSHIP`** (28/08/2026) — not on a judgement taken here. A `MAP-<FEATURE>` row is a
per-project instance citation in a file that **ships**: `copier.yml:157-161` excludes
`/project-management/src/**` but re-includes every `CONTEXT.md` and `CLAUDE.md`, so this index
travels into every generated project. That is precisely the defect `audits/doc-references.sh`
exists to prevent.

N-010's resolution is **relocation, not exception** — the `## Map index` table leaves the shipped
`CONTEXT.md` for its own non-shipping file, after which both rules are obeyed and the row is
added. The register-wide case is claimed by `MAP-REGISTER-INDEXES.md`. Until that lands this map
declines the row exactly as the other **14** do, deliberately and on the record. The instruction
in this folder's `CLAUDE.md` to add one is itself covered by the open `GAPS.md` entry of
01/09/2026, _the `CONTEXT.md` index-row instruction survives in three shipped files no slice
repairs_.

---

## Register claimed

Every open `GAPS.md` entry has a verdict; the unrelated count is what makes the triage provably
exhaustive. **This is a claim, not a close** — `workflows/22-implementation-documentation/` marks
`✅ CLOSED` against shipped code, never this map.

| Register    | Entry                                                                                     | Verdict    | Retired by / note                                                                                                                               |
| ----------- | ----------------------------------------------------------------------------------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| GAPS.md     | 17/09/2026 — the audits register's headroom is one line smaller than 19 artefacts believe | **blocks** | `code/src/scripts/audits/CONTEXT.md` sits at **299 of 300** counted lines. S-02 adds native token/type audit rows to it. **Node N-004**         |
| GAPS.md     | 11/09/2026 — the Bun map's eight tracers have no Bun to run on                            | unrelated  | **But S-01 edits its provisioning list** — the "Expo Go device on the LAN" leg disappears, and "both `INCLUDE_MOBILE` render paths" is restated |
| GAPS.md     | 18/09/2026 — Codex's instruction budget exceeded in 65 of 355 directories                 | unrelated  | All 65 are under `.claude/`; the mobile tree is not among them. S-01 removes 5 pairs, S-02/S-03 add more — re-measure, do not assume            |
| GAPS.md     | 17/09/2026 — three feature maps assert things their own tables refute                     | unrelated  | A **caution for authoring this map**, not an interaction. Every count above is measured, not carried forward                                    |
| GAPS.md     | 17/09/2026 — the backlog register is five hand-maintained copies                          | unrelated  | A different register (`SPRINT-##.md`), untouched here                                                                                           |
| GAPS.md     | 31/08/2026 — the PE gate's markup half cannot see structure                               | unrelated  | Web surface only                                                                                                                                |
| GAPS.md     | 31/08/2026 — htmx pinned at major 2                                                       | unrelated  | Web surface only                                                                                                                                |
| GAPS.md     | 01/09/2026 — a RUSTSEC advisory against an unchanged `Cargo.lock` is invisible            | unrelated  | Rust surface — **but its shape recurs**: see N-018, the Gradle/SPM equivalent                                                                   |
| GAPS.md     | 01/09/2026 — staging and production have no mail backend                                  | unrelated  | Deployment                                                                                                                                      |
| GAPS.md     | 01/09/2026 — the story `**Status:**` header carries two competing vocabularies            | unrelated  | PM artefact vocabulary                                                                                                                          |
| GAPS.md     | 01/09/2026 — the `CONTEXT.md` index-row instruction survives in three shipped files       | unrelated  | Documentation doctrine — **adjacent to the index-row conflict noted below**                                                                     |
| GAPS.md     | 02/09/2026 — `doc-references.sh` applies its citation rule to a tree that never ships     | unrelated  | Audit scoping                                                                                                                                   |
| GAPS.md     | 09/09/2026 — the staging/production security-settings block ships twice                   | unrelated  | Django settings                                                                                                                                 |
| GAPS.md     | 09/09/2026 — a print-only `_migrations:` advisory is invisible in the preview             | unrelated  | **But N-001 depends on the same mechanism** — dropping a copier answer key may need a `_migrations:` entry                                      |
| GAPS.md     | 11/09/2026 — `install-frontend.sh --local` hands two stray arguments to `sudo rm -rf`     | unrelated  | Install script                                                                                                                                  |
| GAPS.md     | 16/09/2026 — MCP servers are declared twice                                               | unrelated  | MCP parity                                                                                                                                      |
| DEFERRED.md | _(no rows)_                                                                               | —          | The file carries its header only                                                                                                                |

---

## Resolved decisions

**Empty — charting settles nothing** (`wayfinder` anti-pattern: _resolving during a chart
session_). The four decisions that bound this map predate it and sit under **Notes → Settled
before charting**.

| Node | Decision | Type | Settled | Became |
| ---- | -------- | ---- | ------- | ------ |
| —    | —        | —    | —       | —      |

---

## Slices

| Slice | Story | Title                                   | Nodes                                                                              | Acceptance                                                                                                                                                                                                           | Flags                                                                                                                      |
| ----- | ----- | --------------------------------------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| S-01  | —     | Retire the React Native surface         | N-001 ⛔ · N-002 ⛔ · N-003 ⛔ · N-005 ○                                           | No `code/src/mobile/`, no `code/src/scripts/mobile/`, no `stack-react-native` skill, no `INCLUDE_MOBILE`. Both render paths generate clean; `template-orphans.sh`, `routing-skills.sh` and `doc-references.sh` green | Docs: 9 files · Gates: `template-orphans`, `routing-skills`, `doc-references`, `docs-pairing` · Copier: answer key removal |
| S-02  | —     | The cross-native doctrine layer         | N-004 ⛔ · N-011 ⛔ · N-012 ⛔ · N-013 ⛔ · N-016 ⛔ · N-017 ○ · N-019 ○ · N-020 ○ | Token emitters, error taxonomy, type discipline, accessibility, testing floors and skills specified for both native surfaces before either tree exists                                                               | Docs: token/a11y/types/coding-principles families · Gates: new audit rows within `audits/CONTEXT.md` headroom              |
| S-03  | —     | The Android surface (`INCLUDE_ANDROID`) | N-007 ⛔ · N-008 ⛔ · N-009 ⛔ · N-014 ○ · N-015 ○ · N-018 ○ · N-021 ○             | A project answering `INCLUDE_ANDROID` true generates a building, linting, testing Kotlin tree; **Linux CI only** — no Apple hardware                                                                                 | Copier: new bool · CI: Gradle on Linux · Gates: token, types, negative-space, a11y                                         |
| S-04  | —     | The iOS surface (`INCLUDE_IOS`)         | N-006 ⛔ · N-010 ⛔ · N-014 ○ · N-015 ○ · N-018 ○ · N-021 ○                        | A project answering `INCLUDE_IOS` true generates a building, linting, testing Swift tree on a macOS runner that **reports rather than skips**                                                                        | Copier: new bool · CI: macOS runner · Gates: as S-03                                                                       |

**Node state:** `✅` resolved · `○` open · `⛔` open **and** blocking.

**S-01 is the only slice cuttable in the near term** — its nodes need no forge and no hardware.
S-02 is documentation and gates, so it can also proceed ahead of the forge; S-03 and S-04 are
gated on the forge migration (see **N-005**) per standing preference 3.

**S-03 before S-04, deliberately.** Gradle builds and tests on Linux, so the Android surface can
land with no Mac in the building. That is the whole reason standing preference 4 chose two bools
over one.

---

## Frontier

| Node  | Decision                                                                                                                                                                             | Type     | Blocked by   | Blocking a story? |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------------ | ----------------- |
| N-001 | Does dropping the `INCLUDE_MOBILE` answer key need a `copier.yml` `_migrations:` entry, or is deletion sufficient?                                                                   | research | none         | yes               |
| N-002 | Which mobile-adjacent guides are deleted vs re-pointed — `TYPES-TYPESCRIPT.md` in particular, given the web's `django/static/js/` scripts                                            | research | none         | yes               |
| N-003 | Does the `code/src/*` glob in `pnpm-workspace.yaml` stay for a future JS surface, or go with the tree?                                                                               | grilling | N-002        | yes               |
| N-004 | Where do the native audit rows fit, given `audits/CONTEXT.md` at 299/300 lines?                                                                                                      | grilling | none         | yes               |
| N-005 | Is the forge migration its own `MAP-FORGE-MIGRATION`, a `GAPS.md` blocker, or a slice here?                                                                                          | grilling | none         | yes               |
| N-006 | macOS runner — owned Apple hardware, or a hosted Mac-runner service? (Apple's licence forbids macOS virtualisation on non-Apple hardware)                                            | grilling | N-005        | yes               |
| N-007 | Android CI on Linux — does `INCLUDE_ANDROID` ship independently of any Mac decision?                                                                                                 | grilling | N-005        | yes               |
| N-008 | Tree layout — `code/src/android/` + `code/src/ios/`, or `code/src/mobile/{android,ios}/`? (`code/src/CONTEXT.md` → _Where the mobile surface sits_ argues the sibling case)          | grilling | none         | yes               |
| N-009 | Android UI toolkit — Jetpack Compose or Views/XML                                                                                                                                    | grilling | N-008        | yes               |
| N-010 | iOS UI toolkit — SwiftUI or UIKit                                                                                                                                                    | grilling | N-008        | yes               |
| N-011 | The token bridge — the emitted **colour form is per-platform, not shared** (see _Emission, measured_ below), and does `design-tokens/MOBILE.md` split in two?                        | grilling | N-009, N-010 | no                |
| N-012 | The error taxonomy in Kotlin and Swift — does `negative-space.sh` learn two languages, or do the native surfaces get their own gate?                                                 | grilling | N-008        | no                |
| N-013 | `TYPES-KOTLIN.md` / `TYPES-SWIFT.md` and two new `dict-discipline.sh` scanners — **note its `TS_SCOPE` is `code/src/mobile` alone**, so S-01 removes its TypeScript leg outright     | grilling | N-012        | no                |
| N-014 | Accessibility — `accessibility/MOBILE.md` splits into per-platform guides over UIAccessibility and Compose semantics                                                                 | grilling | N-009, N-010 | no                |
| N-015 | Store listing — one guide for both stores, or two? (`discoverability/APP-STORE.md` · `how-to/src/STORE-LISTING.md`)                                                                  | grilling | N-008        | no                |
| N-016 | Skills — two (`stack-kotlin-android`, `stack-swift-ios`) or one `stack-native-mobile`? Description-match routing is the deciding constraint                                          | grilling | N-008        | yes               |
| N-017 | Sub-package versioning — two manifests with different formats (Gradle `versionName`/`versionCode`, Xcode `MARKETING_VERSION`) against `VERSIONING-GUIDE.md`                          | grilling | N-008        | no                |
| N-018 | Supply chain — Gradle and SPM sit outside `dependency-drift.sh` and `pnpm audit`. What is the gate? (`cargo-deny` is the precedent)                                                  | grilling | N-008        | no                |
| N-019 | **Is there any gate that catches Android and iOS diverging behaviourally?** The honest counter-argument to two surfaces — **the `contrast` axis is its first real instance** (below) | grilling | N-008        | no                |
| N-020 | Testing — JUnit/Espresso and XCTest against `code/docs/testing/COVERAGE.md`'s 75%/90% floors                                                                                         | grilling | N-009, N-010 | no                |
| N-021 | Does `MOBILE-CODING-PRINCIPLES.md` become two guides or one with two halves?                                                                                                         | grilling | N-016        | no                |

**Unblocked now:** N-001, N-002, N-004, N-005, N-008.

**Types:** `research` (looked up, no human) · `tracer` · `grilling` (one `/grill-with-docs`
surface) · `build`. Manual unblocking work is not a node — provisioning the Mac is a `GAPS.md`
blocker once N-006 settles, not a decision.

### Emission, measured — the channel N-011 and N-019 argue inside

Added 20/09/2026. Recorded here because it bounds two nodes and is otherwise scattered across
three guides; the specification itself stays in `design-tokens/CASCADE.md` and `MOBILE.md`.

**The channel is a build-time emitter, not the API and not `/mcp/`.** Each surface gets a sibling
renderer over the same `DesignToken`/`DesignTokenValue` rows — `render_tokens_css()` (web),
`render_tokens_ts()` (RN today), and a `_kt()`/`_swift()` pair under this map — all Django-side
Python riding the existing provider-agnostic git write-back, so the generated module is committed
and compiled in. `MOBILE.md` rules the alternative out in terms: `GET /api/design-tokens/` is
"session authenticated and admin-only … an editor surface, not a public token API".

Three consequences the nodes inherit:

- **N-011 — the colour form does not generalise.** The `#rrggbbaa` choice is justified in
  `MOBILE.md` by _React Native_ parse compatibility. Compose takes `Color(0xAARRGGBB)` — **alpha
  first** — and SwiftUI takes float components. That is two emitters in substance, not one with
  two file extensions.
- **N-019 — `contrast` is the first real divergence case.** `MOBILE.md` rejected mapping that axis
  onto iOS-only APIs because it "would make the token system behave differently on iOS and Android
  for the same row". Two independent native surfaces weaken that symmetry argument rather than
  answering it, which is precisely what N-019 has to settle.
- **The no-rebuild promise stays web-only and now doubles.** A token change reaches an installed
  native app through a rebuild **and a store release** — two stores, two review queues.

**None of it is wired.** There is no `DesignToken` model and no `render_tokens_*` anywhere in
`code/src/django/` (measured 20/09/2026), so retargeting the emitters costs specification edits,
not a rewrite. This is why S-02 can run ahead of the forge.

---

## Fog of war

- Whether a shared "mobile" doctrine layer survives at all, or Android and iOS are fully
  independent surfaces down to the documentation. N-008 and N-016 will sharpen it.
- Whether the API needs anything for two native clients that it does not need for one — token
  handling, offline behaviour, versioned response contracts.
- Whether the **desktop/Slint** surface should be reconsidered under the same reasoning. Raising
  it now would widen this map past what it can hold honestly.
- What happens if the forge migration is deferred indefinitely. Standing preference 3 assumes it
  lands; it has no date.
- Whether Bruno API-contract tests are the divergence gate N-019 is looking for, or whether that
  needs something that does not exist yet.

---

## Out of scope

| Ruled out                                     | Why                                                                                                                                                   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| KMP / Compose Multiplatform                   | Ruled out 20/09/2026. If the Xcode tax is paid anyway, KMP's saving narrows to shared business logic while adding a third toolchain and Swift interop |
| Retaining React Native in any form            | Standing preference 2 — nothing downstream consumes it, so carrying it is upkeep on a surface with a scheduled death                                  |
| Building an actual mobile app                 | This is **template capability**. No generated project has opted into a mobile surface                                                                 |
| The forge migration itself                    | A prerequisite, not part of this feature — 37 workflows and GitHub-specific required-check semantics. N-005 decides where it is charted               |
| Changes to the Django, Rust or Slint surfaces | Untouched. Every doctrine statement scoped to "the web surface" stays scoped there                                                                    |

---

## Session log

| Date       | Node settled | Outcome                                              | Frontier redrawn |
| ---------- | ------------ | ---------------------------------------------------- | ---------------- |
| 20/09/2026 | —            | Charted: 21 nodes, 4 slices, register triaged 0/1/15 | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocking a story" is resolved** — 9 open
- [ ] Every resolved node links to the artefact it became — none resolved yet
- [x] **Every slice has a flag manifest**
- [ ] Index row in `CONTEXT.md` — **withheld pending a decision**; see the note in `## Notes`

**Stories may be cut in `workflows/02-story-creation/` once the boxes above are ticked.** S-01 is
closest: four nodes, three of them unblocked today.
