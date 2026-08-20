# MAP-PROGRESSIVE-ENHANCEMENT — the technology ladder, the no-JS floor, and the browser contract

**Charted**: 15/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: Charting
**Frontier open**: 16 · **Blocking open**: 3 · **Resolved**: 9
**All three research nodes have returned. Two of the three delivered addenda only**, so N-024
carries the recovery of both missing bodies — including the **rung-2 feature table**, without
which N-012 cannot be settled.
**N-005 is reopened as N-025**: the premise for excluding Firefox was measured and found false.
**N-007** — **enforce, never transform**: no transform tool is adoptable without a build step, and
the repo's own ESLint 10 can enforce a Baseline policy on `.css` natively. Spawned N-021.
**N-008** — **WebKit is the risk; Edge is policy, not engine**, confirming the standing
expectation. Roughly **half of UK mobile traffic is WebKit**. Spawned N-022 (PII in HTMX's
`localStorage` history cache — a GDPR finding) and N-023 (scroll-reveal stuck invisible).
**N-009** — the no-JS gate is a **one-line decorator**, and **Playwright's WebKit is not Safari**.
Spawned N-025.
**Takeable now:** N-010, N-017, N-019, N-022, N-024, N-025.

> **This map is committed here and never ships.** It is tracked, so it syncs across devices;
> `copier.yml` `_exclude` empties the artefact trees at generation — deliberately, because this
> charts **syntek-base's own** doctrine work. The name matters: a map called
> `MAP-TEMPLATE-*.md` would match the `!*TEMPLATE*` negation and ship.
> **No row is added to `CONTEXT.md`'s map index** for the same reason — that file _does_ ship,
> so a row pointing at an unshipped map would dangle in every generated project. The index
> correctly reads "None charted yet".

---

## Destination

Every interaction in a generated project is placed on the **lowest rung that can carry it**,
degrades to a **working server-side path** when JavaScript is unavailable, and renders
correctly on the **declared browser matrix** — each proved by a gate that runs, not by review.

The deliverable is **documentation plus a justified toolchain recommendation**. No application
code, no dependency change, no build configuration is touched.

---

## Notes

| Field                    | Value                                                                                                                                       |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Web surface doctrine — Django templates + django-components + HTMX + Alpine + token CSS                                                     |
| Skills to load           | `doc-writer` · `frontend` · `stack-htmx-templates` · `test-writer` · `cicd` · `scaffold`                                                    |
| Standing preferences     | **No ADRs in this repo** (see Out of scope) · Tier A · one guide owns the ladder · a rule ships with a gate · Chromium + WebKit             |
| Umbrella ADRs            | **None, by constraint.** The shipped guide _is_ the decision record                                                                         |
| Register entries triaged | **0 closes · 0 blocks · 0 unrelated** — `GAPS.md` reads `_No active entries._` and `DEFERRED.md` carries no rows. Triage vacuously complete |

**The premise that reshapes this epic:** the frontend does not exist yet. One template
(`500.html`), zero CSS files, zero HTMX attributes, zero Alpine directives, zero routes beyond
Django admin at `/control/`. There is **no remediation backlog** — only a forward commitment,
and it costs nothing today that it will not cost tenfold after ten stories.

---

## Register claimed

Both registers are empty, so nothing is claimed and nothing blocks. Recorded explicitly because
an untriaged register is indistinguishable from an empty one.

| Register      | Entry                | Verdict | Retired by |
| ------------- | -------------------- | ------- | ---------- |
| `GAPS.md`     | _No active entries._ | —       | —          |
| `DEFERRED.md` | _No rows._           | —       | —          |

---

## Resolved decisions

Settled at charting by explicit sign-off (Step 2 — destination and bounds). **None has graduated
yet**: each names the frontier node that turns it into shipped text, which is what stops a
decision dying on this map.

| Node  | Decision                                                                                                                                                                                                             | Type     | Settled    | Became                                                         |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- | -------------------------------------------------------------- |
| N-001 | **Tier A** — full core functionality without JavaScript. Every critical flow completes server-side; HTMX and Alpine are strictly enhancement                                                                         | grilling | 15/08/2026 | pending — **N-014** (guide Section 1)                          |
| N-002 | **Tier A is pinned by the template, not asked per project.** Exceptions are recorded, never negotiated at generation                                                                                                 | grilling | 15/08/2026 | pending — **N-014** (guide Section 1)                          |
| N-003 | **A new guide owns the ladder, the PE rules and the browser policy as one doctrine.** `RENDERING.md` loses its claim to be the placement authority and routes to it                                                  | grilling | 15/08/2026 | pending — **N-014** + **N-015**                                |
| N-004 | **The rule ships with a gate** — an audit script plus its CI workflow, matching the repo's 25-audit convention                                                                                                       | grilling | 15/08/2026 | pending — **N-013** (rules) + **N-016** (script)               |
| N-005 | **The browser matrix grows to Chromium + WebKit**, and `TAXONOMY.md`'s unbacked three-engine claim is corrected                                                                                                      | grilling | 15/08/2026 | pending — **N-018** (engine) + **N-019** (claim)               |
| N-006 | **No ADR.** The tooling decision, its rejected options and its consequences live in the shipped guide; a Tier A exception is a greppable annotation plus a table in Section 1                                        | grilling | 15/08/2026 | pending — **N-014** (rationale) + **N-016** (the grep)         |
| N-007 | **Enforce, never transform.** No CSS-compatibility tool is adoptable without a build step; the policy is a `browserslist` string and the enforcement is `@eslint/css` `use-baseline` on the ESLint already installed | research | 15/08/2026 | evidence — feeds N-010, N-011, N-012, N-016                    |
| N-008 | **WebKit is the risk; Edge is policy, not engine.** Confirms the standing expectation, and surfaces four rules no existing guide states                                                                              | research | 15/08/2026 | evidence — feeds N-010, N-011, N-012; **spawned N-022, N-023** |
| N-009 | **The no-JS gate is one decorator, and Playwright's WebKit is not Safari.** Delivered the test harness; **the rung-2 feature table did not arrive**                                                                  | research | 15/08/2026 | evidence — feeds N-017; **spawned N-025**; gap → N-024         |

### What N-007 established (evidence, not yet policy)

Measured live, not cited: `autoprefixer@10.5.4` against Baseline Widely available emits
**9 properties and 5 values** — all `-webkit-` bar two `-moz-`, **zero `-ms-`, zero `-o-`**.
Against `defaults` it emits **48**. **The browser policy, not the tool, decides whether
prefixing is a problem.**

- **No transform tool clears the no-build constraint.** Autoprefixer, `postcss-preset-env` and
  the `@csstools` plugins are all PostCSS plugins; esbuild and Vite are bundlers. The lightest
  real option, `lightningcss-cli`, is one binary — but it splits source from artefact in
  `static/css/`, which is the thing this repo's stack decision exists to avoid.
- **Tailwind v4 is the precedent, not the product.** It deleted Autoprefixer outright and
  absorbed Lightning CSS, because it already had a build step. This repo reaches the same
  conclusion for free.
- **Baseline is native to browserslist since 4.26.0 (12/09/2025)** — `baseline widely available
with downstream`. The "Baseline has no tooling" objection is obsolete.
- **`@eslint/css@1.4.0` is an official ESLint org plugin** that lints `.css` with no PostCSS, no
  bundler, no build. Proven to run against this repo's exact `eslint@10.8.1` on Node 24.
  `eslint.config.mjs` already carries a `*.min.css` ignore, and Prettier's glob already covers
  `.css` — the config was written in anticipation of exactly this.
- **`with downstream` is not optional.** Samsung Internet is the largest single GB miss (2.38%)
  and is a downstream Chromium; the suffix recovers it.
- **A live footgun:** browserslist queries apply left to right, so
  `last 2 versions, not dead, > 0.2%` — the README's own suggestion — **silently readmits IE 11**
  and triples the prefix surface to 76 properties.
- **Polyfills are categorically ruled out.** htmx 2.x ships `src/htmx.js` untranspiled and Alpine
  3 is `Proxy`-based via `@vue/reactivity`; **`Proxy` cannot be polyfilled** — `proxy-polyfill`
  cannot trap property addition, which is exactly what `x-data` needs. Both floor at **ES2020**,
  well below the CSS floor, so JS is not the binding constraint.
- **The mitigation is a design rule, not a purchase:** real `<form action>` and `<a href>` on
  every critical path, plus `[x-cloak] { display: none }` so a dead Alpine **fails hidden rather
  than fails ugly**. That is Tier A restated from the toolchain side.
- **The honest objection, to carry into N-010:** `@eslint/css` bakes the Baseline dataset into
  its own `dist/`, so the declared policy (a rolling 30-month window) and the enforced policy (a
  frozen snapshot) **drift silently**, and a `pnpm update` can redden a file nobody touched. It
  is also a lint, not a guarantee — it flags missing modernity, never a **missing prefix**.

### What N-008 established (evidence, not yet policy)

**Delivery caveat, recorded honestly:** what returned was an **addendum** referencing sections of
a main report that never arrived, and `SendMessage` is unavailable in this session, so the full
Q1–Q6 body — including the explicitly-cited Edge engine verdict and the per-feature CSS
divergence table — **has not been received**. The ranked list and the findings below did arrive
and are usable. **N-011 and N-012 should not be settled on this alone**; the CSS table is the
missing input.

**The ranked five became six**, with a new entry at #3:

1. **Scroll-reveal content stuck invisible** — Firefox has no `animation-timeline` support;
   Chromium and Safari lose it on inactive timelines. **Confirmed as a defect, not a polish
   issue** — this discharges the matching fog-of-war item into **N-023**
2. Enterprise **Edge policy** blocking JavaScript or cookies
3. **NEW — iOS skips `pushState` entries pushed without user activation** (WebKit **248303**,
   NEW, confirmed intentional by a WebKit engineer as "back/forward list hijacking prevention").
   Matches HTMX issue **#1076** — "Safari (iOS 16) odd history behaviour", never root-caused,
   with the reporter noting it does not occur with React or Vue routers. **Interpretation, not a
   cited claim:** those routers push inside a click handler, where user activation is present;
   **HTMX pushes after the XHR resolves.** **Rule: confine `hx-push-url` to gesture-initiated
   requests** — any `hx-trigger="every 30s"`, `load` trigger or programmatic `htmx.ajax()` that
   pushes URL is at risk
4. WebKit `:focus-visible` / click-focus breaking HTMX and Alpine focus management
5. Third-party-origin assets blocked by Edge **Tracking Prevention**
6. External DOM mutation — auto-translate and MV2 extensions

**Four rules no existing guide states:**

- **HTMX's history cache is `localStorage`** (`historyCacheSize` default 10, full DOM snapshots).
  WebKit deletes all script-writable storage after **seven days** without user interaction, so
  history restoration degrades silently for returning Safari visitors — **and any page rendering
  personal data needs `hx-history="false"`, because HTMX is otherwise persisting rendered PII to
  disk.** Alpine's `$persist` defaults to `localStorage` and carries the same exposure. **This is
  a UK GDPR finding, not a compatibility one** → **N-022**
- **`beforeunload` does not fire on iOS** (WebKit **219102**, REOPENED — fixed Nov 2020, reverted
  Dec 2020 for a performance regression). Worse, WebKit **199854** has `pagehide`, `unload` **and
  `visibilitychange`** failing when a tab or MobileSafari closes. **Use `visibilitychange` →
  `hidden` as the primary save signal, `pagehide` as fallback, `beforeunload` for the desktop
  dialog only, and accept that navigation cannot be blocked on iOS**
- **Top-level `await` is broken in Safari for diamond module graphs** — two modules importing a
  third concurrently fails the graph. Fixed only in **STP 243 (May 2026)**, landing in Safari 27.
  **This stack is exactly the vulnerable configuration** — no bundler, plain
  `<script type="module">`. **Avoid top-level await in any module imported more than once**
- **Neither library publishes a browser baseline, so record the derived floors:** Alpine 3.x →
  **Safari 12.1 / iOS 12.2** (unguarded `queueMicrotask`); HTMX 2.x → **Safari 13.1 / iOS 13.4**
  (optional chaining in source). Alpine discussion #2901 asking for a support list is still
  unanswered by maintainers

**Three corrections to received wisdom:**

- **HTMX does not use `MutationObserver`** — zero occurrences in the shipped 2.0.10 bundle.
  **Alpine alone observes the document**, subtree-wide, so **every HTMX swap fires Alpine's
  document-wide observer.** That is the real coupling cost, and it is Alpine's
- **`transition:true` is safe to enable** — View Transitions reached Baseline **14/10/2025** with
  Firefox 144. **HTMX's own docs still call it experimental; that copy is stale.** (HTMX #1703,
  view transitions not applied on history changes, remains open)
- **No alternative browser engine has shipped on iOS.** The European Commission's own DMA
  implementation report (**COM(2026) 247 final, 21/05/2026**) contains **zero** occurrences of
  "browser engine" and zero of "WebKit". App Review Guideline 2.5.6 names **the EU and Japan
  only — there is no UK entitlement.** Claims that "Chrome runs Blink in the EU" or "Firefox EU
  ships SpiderMonkey" are **explicitly false**. The CMA measured it: _"Apple's WebKit has a 100%
  share of supply of browser engines on iOS."_

**Why this outranks a general compatibility concern:** Safari is **47.54% of UK mobile browser
share** and 29.04% across all platforms (StatCounter, July 2026) — and part of the "Chrome
mobile" figure is Chrome **on iOS**, which is also WebKit. **Roughly half of UK mobile traffic is
WebKit**, so items 1, 3 and 4 above are not edge cases.

### What N-009 established (evidence, not yet policy)

**Same delivery failure as N-008, and it hit the more important half.** An addendum correcting its
own Sections 3 and 4 arrived; it states "nothing in Sections 1, 2, 5, 6 or 7 moves", confirming
those sections exist — but **they were never received**. The missing Section 1 is **the rung-2
feature table**: the SAFE TODAY / NEEDS FALLBACK / NOT YET VIABLE verdicts for `<details>`,
`<dialog>`, Popover, `:has()`, `:focus-within`, CSS tabs and scroll-driven animations. **That
table is the whole evidential basis of N-012**, and of the claim that rung 2 is the rung most
often skipped. Folded into **N-024**.

**What did arrive — the no-JS harness, run live on all three engines** (Playwright 1.62.0,
pytest-playwright 0.9.0):

- **The no-JS leg is a one-line decorator**, not fixture plumbing:
  `@pytest.mark.browser_context_args(java_script_enabled=False)`. That is cheap enough to apply
  to **every** rung-2 claim rather than a sampled few.
- **Disabling JavaScript does not disable CSS** — confirmed on all three engines. `expect()`,
  auto-wait, `click()`, `fill()` and real form submission all work.
- **The factory fixture is `new_context`, not `context_factory`.** Playwright's CLI arguments
  apply **only** to the default `browser`/`context`/`page` fixtures, so a hand-rolled context
  silently loses `--device` and `--base-url`.
- 🔴 **Firefox wedges the whole run.** With JS disabled, `page.evaluate` on a promise-returning
  function **never returns and never times out** — and `page.evaluate` takes no timeout, so pytest
  hangs indefinitely. Playwright marks its own test `fixme` for this. **Rule: never return a
  promise from `page.evaluate` in a no-JS test.** A hung CI job is indistinguishable from a slow one.
- 🔴 **Setting `java_script_enabled` in both the marker and the factory raises `TypeError`** — the
  plugin splats both dicts. One mechanism per test.
- 🔴 **`<noscript>` is unassertable by text in Playwright** — closed without fix. **Put a
  `data-testid` on every `<noscript>` as a matter of course.**
- 🔴 **Linux headed is WebKitGTK; Linux headless is WPE WebKit.** CI and local debugging are not
  the same port.

**Playwright's WebKit is not Safari, and the evidence is blunt.** It builds from WebKit `main`,
**open-source part only**; you cannot pin an older engine except by pinning an older Playwright.
Device emulation is six keys — `iPhone 15` and `iPhone 15 Pro` are **byte-identical**, and the UA
is a fabrication no real device emits (`iPhone OS 17_5` with `Version/26.5` grafted in).
**A green `webkit` run means "not Blink-only". It does not mean "works in Safari", and it is not
iOS testing.** Conversely **Firefox tracks Firefox Stable** — a patch set behind what users run,
versus WebKit's patch set plus release lead plus a different platform port.

**The measurement that reopens a settled decision** — see **N-025**:

| Engine   | Version       | Download  | On disk |
| -------- | ------------- | --------- | ------- |
| Chromium | 151.0.7922.34 | —         | 389 MB  |
| Firefox  | 153.0         | 108.2 MiB | 302 MB  |
| WebKit   | 26.5          | 102 MiB   | 293 MB  |

Going 1 → 3 engines costs **+210 MiB download and +600 MB disk, under a minute of download**. The
dominant CI cost is the `--with-deps` apt step, not the browser archives.

**Why N-006 is load-bearing, not bookkeeping.** `project-management/src/14-DECISIONS/` is
**not** in copier's `_exclude`, so it renders into every generated project. An ADR authored here
would either ship syntek-base's own decision as though it were the project's, or — if left
untracked by the `src/.gitignore` allowlist — be cited by a shipped guide as a path that does
not exist there. Both fail. The guide carrying its own rationale is the existing house pattern
(`FRONTEND-CODING-PRINCIPLES.md` records the django-cotton rejection inline;
`pnpm-workspace.yaml` records every override's reasoning inline).

**The exception mechanism, precedented three times over:** a greppable inline annotation with a
mandatory reason — the shape of `DICT-OK: <reason> — confined to <boundary>`, `gradient-allow`,
and `docs-length-allow: <reason> (expires DD/MM/YYYY)`.

---

## Frontier

Open decisions in dependency order. **Blocking** here means "no guide text may be written
against it", this epic's analogue of blocking a story — there are no stories, because the
deliverable is doctrine.

| Node  | Decision                                                                                                                                                                                                                              | Type     | Blocked by                             | Blocking?         |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------------------- | ----------------- |
| N-024 | **Recover BOTH missing report bodies** — N-008's cited Edge verdict + CSS divergence table, and **N-009's rung-2 feature table** (the evidential basis of N-012). Re-run as a scoped `/research` pass; `SendMessage` is unavailable   | research | none — **takeable**                    | yes               |
| N-025 | **Reopen N-005 — Firefox in the e2e matrix.** Its exclusion rested on install cost, now measured at +210 MiB / under a minute; meanwhile Firefox is the **only** engine with no `animation-timeline` support, i.e. the #1 ranked risk | grilling | none — **takeable**                    | no                |
| N-010 | **The support policy's expression** — confirm `baseline widely available with downstream`; whether to adopt `@eslint/css`; how the baked-snapshot drift is answered                                                                   | grilling | ~~N-007~~, ~~N-008~~                   | **no — takeable** |
| N-011 | **Guide structure** — how many sub-docs the 300-line cap forces, and which concern each owns                                                                                                                                          | grilling | ~~N-007~~, ~~N-008~~, ~~N-009~~, N-024 | yes               |
| N-012 | **The rung-2 adoption policy** — per feature: SAFE TODAY / NEEDS FALLBACK / NOT YET VIABLE against the matrix N-010 sets. **Cannot be settled until N-024 recovers the feature table**                                                | grilling | ~~N-009~~, N-010, N-024                | yes               |
| N-022 | **PII in client-side history storage** — `hx-history="false"` on any page rendering personal data, and the same rule for Alpine `$persist`. Crosses into GDPR and security doctrine, so it graduates to a **different** guide         | grilling | none — **takeable**                    | no                |
| N-023 | **Scroll-reveal content stuck invisible** — a confirmed defect, not doctrine. The fallback pattern, and whether `visual-design/WEB.md`'s motion standard and the a11y suite's `reduced_motion` workaround both change                 | grilling | N-009                                  | no                |
| N-013 | **The audit's rule set and tier** — what a script can decide statically, what stays reviewer-only, and fail versus warn                                                                                                               | grilling | N-009, N-011                           | no                |
| N-021 | **The nine prefixes** — where the hand-written `-webkit-`/`-moz-` set lives (`tokens/` or `surfaces.css`), and the `css-dead-prefix.sh` that bans `-ms-`/`-o-` and the ones no longer emitted                                         | task     | N-010                                  | no                |
| N-014 | **Write the guide** — `code/docs/PROGRESSIVE-ENHANCEMENT.md` + its sub-docs, all seven sections                                                                                                                                       | task     | N-010, N-011, N-012                    | no                |
| N-015 | **Demote `RENDERING.md`** — three tiers become four rungs; the placement authority moves and the decision table routes                                                                                                                | task     | N-011, N-014                           | no                |
| N-016 | **Build the gate** — `audits/progressive-enhancement.sh` + fixtures + `audit-progressive-enhancement.yml`                                                                                                                             | task     | N-013                                  | no                |
| N-017 | **The no-JS test lane** — the `browser_context_args` marker, the `new_context` factory, the three gotchas, `data-testid` on every `<noscript>`                                                                                        | task     | ~~N-009~~ — **takeable**               | no                |
| N-018 | **Add the second (and possibly third) engine to the e2e suite** — `e2e-py.sh` install, `conftest.py` projects, the two `CONTEXT`/`CLAUDE` pairs, and the WebKit-is-not-Safari caveat written down                                     | task     | N-005, N-025                           | no                |
| N-019 | **Correct the doctrine defects** — `TAXONOMY.md`'s three-engine claim; the **Lightning CSS fiction, 7 line-sites across 6 files** (swept 15/08/2026, below); the `shared/src/css/` and `/assets/tokens.css` paths that do not exist   | task     | none                                   | no                |
| N-020 | **Wire the indexes** — `REFERENCES.md`, `code/REFERENCES.md`, `code/docs/CONTEXT.md`, `.claude/CLAUDE.md` Section 8, `DESIGN.md`                                                                                                      | task     | N-014                                  | no                |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `task` (manual unblocking work)

**The takeable edge — six nodes, nothing in flight.** All three research nodes have returned.
**N-024** (recover both lost bodies) is the only one that gates authoring; **N-022** (PII in
`localStorage`) is the most urgent in absolute terms; **N-019** corrects 8 statements that are
false today; **N-025** reopens a decision made on a falsified premise; **N-010** and **N-017**
are simply unblocked.

### Suggested batches

| Batch | Nodes                                  | Why they belong together                                                                                                                                         |
| ----- | -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **A** | ~~N-007~~, ~~N-008~~, ~~N-009~~, N-024 | Research. All three returned; **two delivered addenda only**, so N-024 re-runs the lost halves as one scoped pass                                                |
| **B** | N-010, N-011, N-012                    | One grilling. All three read the same evidence, and deciding the matrix apart from the feature policy means deciding it twice. **N-012 is hard-gated on N-024**  |
| **C** | N-013, N-016, N-021                    | All the audit-script work in one pass — the PE gate's rules, its implementation, and the dead-prefix guard N-007 spawned                                         |
| **D** | N-014, N-015, N-020                    | The guide, the demotion it forces, and the indexes that must move with it — one authoring pass                                                                   |
| **E** | N-017, N-018, N-025                    | The test surface: the no-JS lane, the engine matrix, and the Firefox reopening that decides how wide it is. All three touch `conftest.py` and `e2e-py.sh`        |
| **F** | N-019                                  | **Standalone and takeable immediately.** Pure correction of statements that are false today; depends on nothing and blocks nothing                               |
| **G** | N-022, N-023                           | The two findings that **graduate outside this guide** — GDPR/security doctrine and the motion standard. Batched so neither is lost in a PE-shaped authoring pass |

---

### N-019 evidence — the Lightning CSS fiction, swept 15/08/2026

**Lightning CSS is not used on any surface, and the claims are unambiguously about the web.**
Checked rather than assumed:

- **Not installed** — `node_modules/lightningcss` does not exist. Its 36 `pnpm-lock.yaml` entries
  are declared by exactly one package, `@expo/metro-config@57.0.7`, which carries it for Expo's
  **web** output (react-native-web) — a target this project does not build.
- **Not mobile.** React Native has no CSS, no cascade and no `var()`. The repo's own
  `mobile-tokens.sh` is the mobile sibling: it scans `code/src/mobile` `*.ts`/`*.tsx` for raw
  values in **`StyleSheet`** code, and states that the resolution half is free there because the
  token module is **typed** — an unresolved import fails `typecheck.sh`.
- **Not desktop.** Slint uses its own `.slint` markup language; `DESKTOP.md` and `desktop/*.md`
  contain **zero** CSS references.
- **The audit that carries the claim is web-only.** `css-tokens.sh`'s `SCOPES` are exactly
  `code/src/django/static/css` and `code/src/django/components`. No mobile path, no Rust path.

**Seven line-sites across six files** say otherwise:

| Site                                          | Claim                                                                                                                                         |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/design-tokens/EDITOR.md:54`        | **"Lightning CSS autoprefixes from the project browserslist config"** — **doubly false**: no Lightning CSS, and no browserslist config either |
| `code/docs/design-tokens/EDITOR.md:45`        | phantom custom property "silently dropped by Lightning CSS"                                                                                   |
| `code/docs/DESIGN-TOKENS.md:62`               | same claim                                                                                                                                    |
| `code/docs/FRONTEND-CODING-PRINCIPLES.md:146` | same claim                                                                                                                                    |
| `code/src/scripts/audits/css-tokens.sh:8`     | same claim, in the gate's own header                                                                                                          |
| `code/src/scripts/audits/CONTEXT.md:153`      | same claim, in the audit register                                                                                                             |
| `code/src/scripts/audits/css-slop.sh:363`     | "this stack (Lightning CSS)" — in a brace-matching comment                                                                                    |

**The gate is right; its stated reason is wrong.** A `var(--x)` with no fallback referencing an
undefined custom property is **invalid at computed-value time** per CSS Variables — the browser
itself discards the declaration. `css-tokens.sh` therefore guards a real failure and must be
kept; only the mechanism sentence changes. **Correcting the reason is what stops the rule being
deleted later by someone who checks and finds no Lightning CSS.**

`EDITOR.md:54` is the one with teeth: it tells a future developer that prefixing is handled
automatically. **Nothing is prefixing anything** — which is exactly the gap N-021 fills.

---

## Fog of war

In scope, not yet sharp enough to state as a decision.

- **What the audit can actually decide.** `TYPES-EXCEPTIONS.md` sets the precedent of saying
  honestly which half of a standard a script can decide and which half is the reviewer's. A form
  missing `action` is greppable; "this Alpine component should have been `<details>`" is not.
  Sharpens once N-009 returns the feature list.
- **Whether the matrix becomes a fifth first-time-setup item.** `.claude/CLAUDE.md` Section 2.2
  names four things settled once per project. If the browser matrix is per-project rather than
  template-pinned, `how-to/workflows/01-first-time-setup/` gains a step. N-010 decides.
- **The `hx-boost` ban's relationship to the ladder.** The ban already forces every server op to
  be explicit, which is most of what rung 3 asks for. Whether the ladder restates it, routes to
  it, or supersedes it is a structural question for N-011.
- ~~**Scroll-driven animations as a correctness bug.**~~ **Discharged 15/08/2026 by N-008 —
  confirmed, and it ranked #1.** Firefox has no `animation-timeline` support at all, and both
  Chromium and Safari drop the effect on inactive timelines, so reveal content can sit
  permanently at `opacity: 0`. Now **N-023**, a real node.
- **The mobile surface has no no-JS analogue.** A React Native app cannot "work without
  JavaScript". Whether the guide states its web-only scope explicitly or relies on the standing
  surface-scoping convention is a small N-011 question.
- **Component-level rung records.** Whether each django-component declares the rung it sits on,
  and where. There is no component to judge, so this cannot sharpen yet.

---

## Out of scope

| Ruled out                                                                          | Why                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ---------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Any ADR**                                                                        | `14-DECISIONS/` ships; an ADR here renders into every generated project or dangles as a cited path that is not there. Standing constraint                                                                                                                                                                                                                                                                                                                                   |
| Application code, dependencies, build configuration                                | Explicit task constraint. The deliverable is documentation plus a justified recommendation; implementation is a separate follow-up                                                                                                                                                                                                                                                                                                                                          |
| Adding a bundler, PostCSS, Tailwind, or any CSS build                              | Reopens a settled stack decision (`code/src/CONTEXT.md` → _No client-side build_). Any tool requiring one is disqualified, not compared                                                                                                                                                                                                                                                                                                                                     |
| Retrofitting existing Alpine usage                                                 | There is none. Zero directives exist                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Mobile, desktop and Rust surfaces                                                  | Separate deployables with their own runtimes; "works without JavaScript" is not a question a native app can be asked                                                                                                                                                                                                                                                                                                                                                        |
| ~~Firefox in the e2e matrix~~ **PREMISE FALSIFIED 15/08/2026 — reopened as N-025** | Excluded on "install and CI cost for the smallest of the three divergences". **Both halves are now false.** N-009 measured the cost at **+108 MiB / 302 MB, under a minute**, with the dominant CI cost being `--with-deps` apt rather than the archive. And N-008 ranked **Firefox's total absence of `animation-timeline` support as the #1 risk** — the largest divergence, not the smallest. Kept in this table, struck rather than deleted, so the reversal is legible |
| A separate `how-to/src/` register for the tier                                     | One guide section holds a policy plus what will typically be nought to three exception rows. It becomes a register only if it outgrows the cap                                                                                                                                                                                                                                                                                                                              |

---

## Session log

| Date       | Node settled     | Outcome                                                                                                                                                                             | Frontier redrawn |
| ---------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 15/08/2026 | N-001 … N-006    | Charted. Destination and bounds signed off; the no-ADR constraint reshaped N-006's mechanism entirely                                                                               | [x]              |
| 15/08/2026 | N-007 (research) | **Enforce, never transform.** Unblocked half of N-010 and N-011; spawned N-021; grew N-019 by a third defect site                                                                   | [x]              |
| 15/08/2026 | N-008 (research) | **WebKit is the risk; Edge is policy.** Unblocked N-010 fully; spawned N-022, N-023, N-024; discharged the scroll-reveal fog item into a confirmed defect                           | [x]              |
| 15/08/2026 | N-009 (research) | **No-JS gate is one decorator; Playwright WebKit is not Safari.** Unblocked N-017; spawned N-025, which **reopens N-005 on a falsified premise**; widened N-024 to both lost bodies | [x]              |

---

## Gate to authoring

This epic produces doctrine, not stories, so the template's story gate reads as a gate to writing
the guide.

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — both registers empty, recorded
- [x] Nothing claimed; neither register file edited here
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired; nothing in flight, six nodes takeable now
- [ ] **Every node marked blocking is resolved** — 3 open (N-011, N-012, N-024)
- [ ] Every resolved node links to the artefact it became — the six charted decisions pending,
      each naming the node that writes it; N-007 is evidence and names what it feeds
- [x] No index row added to `CONTEXT.md` (map is untracked; a row would dangle in every project)

**Authoring may begin once N-011, N-012 and N-024 are settled** — and N-024 gates N-012, so it is
the true critical path. Batches **F** (N-019), **G** (N-022) and nodes **N-010**, **N-017**,
**N-025** are takeable now and depend on nothing.

### Verification log

| Date       | Check                                                                  | Result                                                                                                                                                                     |
| ---------- | ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 15/08/2026 | Node counts against the frontier table                                 | 14 open · 5 blocking · 7 resolved — consistent                                                                                                                             |
| 15/08/2026 | **Resolved "Became" wiring**                                           | **6 of 6 were wrong** — pointed at research/grilling nodes instead of the task nodes that write them. Corrected                                                            |
| 15/08/2026 | Lightning CSS site count                                               | Stated as 6, actually **7 line-sites across 6 files**. Corrected                                                                                                           |
| 15/08/2026 | Every node has a type, a blocked-by, and a blocking verdict            | 14/14 complete                                                                                                                                                             |
| 15/08/2026 | Every frontier node appears in exactly one batch                       | 14/14 — batch F added for N-019, N-021 added to C                                                                                                                          |
| 15/08/2026 | **Re-verified after N-008** — counts, batch coverage, blocker rewiring | 16 open · 4 blocking · 8 resolved; 16/16 batched (G added); N-010 unblocked by N-008's return                                                                              |
| 15/08/2026 | **N-008 delivery completeness**                                        | **Incomplete** — addendum only; main Q1–Q6 body absent and `SendMessage` unavailable. Recorded as N-024 rather than papered over                                           |
| 15/08/2026 | **N-009 delivery completeness**                                        | **Incomplete, same failure** — addendum to its own Sections 3–4 only. **Sections 1, 2, 5, 6, 7 never received**, including the rung-2 feature table. N-024 widened to both |
| 15/08/2026 | **Standing decisions re-tested against returned evidence**             | **N-005 failed** — both halves of its stated reason are now measurably false. Reopened as N-025 and struck-through in Out of scope rather than quietly edited              |
| 15/08/2026 | Final counts, batch coverage, duplicate IDs                            | 16 open · 3 blocking · 9 resolved; 16/16 batched; no duplicate or missing IDs                                                                                              |
