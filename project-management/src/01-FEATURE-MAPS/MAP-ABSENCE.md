# MAP-ABSENCE — Absence is not one thing

**Charted**: 15/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Charting** — frontier drawn, nothing settled beyond the research nodes
**Frontier open**: 11 · **Blocking open**: 1 (N-008) · **Fog of war open**: 4
**Measured at**: 15/08/2026 11:26, against `pm/base-health-map` at `7cd385d` **plus 10 uncommitted
working-tree changes under `code/docs/data-structures/`** — see _The collision_ below. Every line
count in this map is a working-tree measurement, not a HEAD measurement, and the two differ today.

> **Template-development artefact.** This map charts work on `syntek-base` itself, not on a
> project generated from it. It is **committed here**, so it syncs across devices, and it is
> emptied out by `copier.yml` `_exclude` at generation — so it never reaches a generated
> project. Every claim below is written to stand on its own; a cross-map reference names the map
> **and** what it asserts, so losing the other file costs the reference, not the fact.

---

## The collision — read this before anything else

**This epic was charted into ground that was being built on at the same moment.** Between 11:18
and 11:25 on 15/08/2026, while this map's research nodes were running, a concurrent session
resolved **`MAP-DOMAIN-OBJECTS`** and wrote **six new guides** into `code/docs/data-structures/`,
none of them yet committed:

| File                         | cloc | Carries, verbatim                                                                            |
| ---------------------------- | ---- | -------------------------------------------------------------------------------------------- |
| `TYPES-OVER-DICTIONARIES.md` | 236  | _Parse at the boundary, pass objects inward_ · _Parse once, not defensively everywhere_      |
| `TYPES-BROWSER.md`           | 265  | _Declare every property at init_ · _Shared state goes through `Alpine.store`_                |
| `TYPES-RUST.md`              | 258  | _`Option` and `Result`, never sentinels_ · _Enums make illegal states unrepresentable_       |
| `TYPES-EXCEPTIONS.md`        | 255  | the exceptions catalogue and the `DICT-OK:` escape hatch                                     |
| `TYPES-TYPESCRIPT.md`        | 249  | _Discriminated unions make illegal states unrepresentable_ · _Parsing at the fetch boundary_ |
| `TYPES-PYTHON.md`            | 242  | _The type checker, and what CI actually enforces_ (the `typeCheckingMode` table)             |

**This was discovered by the adversarial verifiers, not by the researchers.** Six of this map's
seven research nodes reported clauses as "genuinely absent" that had become present mid-run; the
refuters found 33 such claims across the six surfaces. That is the whole argument for the refute
stage, and it is recorded here because the same thing will happen again: **a research verdict on
this repository has a shelf life measured in hours while parallel sessions are running.**

**Consequence for the destination.** Three of the brief's four _governing_ rules are now law and
must be **cited, never restated**:

| Brief's governing rule                            | Now owned by                                                              |
| ------------------------------------------------- | ------------------------------------------------------------------------- |
| Normalize at the boundary                         | `TYPES-OVER-DICTIONARIES.md` _Parse at the boundary_ + `REFACTORING.md` 9 |
| Prefer making it unrepresentable / split the type | `TYPES-RUST.md` + `TYPES-TYPESCRIPT.md`, both as H2s                      |
| Several kinds of absence are an enum              | `ANTI-PATTERNS.md` _Boolean Blindness_ (pre-existing, on a Keep list)     |
| **Never overload one absence with two meanings**  | **partially** — `rls/MIDDLEWARE-AND-NINJA.md:270` states it for one case  |

**What survives is narrower and sharper than the brief, and it is still substantial**: the
six-way absence taxonomy itself, the whole of Python `None`, the whole of the HTMX two-axis
contract, and the enforcement gaps on every surface. That is this map.

---

## Destination

**"Which of six things does this absence mean?" becomes a decidable question on every surface
this template ships.** One owning guide, `code/docs/ABSENCE.md`, states the six kinds — expected
miss · not-yet · empty · failure · not-supplied · not-applicable — and the cross-language crib
that maps each onto Python, Rust, Alpine, HTMX and mobile TypeScript. Per-surface clauses land in
the guide that already owns that surface. The `TYPES-*` family owns _what shape a value has_;
this owns _what its absence means_, and the two cross-reference at exactly one row.

**Done looks like:** a developer choosing between `return None`, `return []` and `raise` can name
which of the six they mean and read the answer off one table; an HTMX view returning "nothing"
picks deliberately between 204, `hx-swap="none"`, an empty-state partial and a 404; and no rule
in the guide is enforced by nothing.

**What this is not.** Not a second statement of `TYPES-*`. Not a rewrite of `NEGATIVE-SPACE.md`,
which is a sibling discipline — that guide asks _what must never be true_, this one asks _what
this absence means_ — and they touch at exactly one row (failure → `raise` / `Result` / 4xx).
Not the mass conversion of existing code, of which there is almost none.

---

## Notes

| Field                    | Value                                                                                                                                                                                                                                                          |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Absence semantics · optional modelling · response contracts · lint and audit legs                                                                                                                                                                              |
| Skills to load           | `grill-with-docs` · `doc-writer` · `stack-django` · `stack-htmx-templates` · `stack-rust` · `stack-react-native` · `code-reviewer` · `refactor`                                                                                                                |
| Standing preferences     | Cite `TYPES-*`, never restate it · additive first · every clause declares its deletion class · a new guide is born under 270 cloc · surfaces gated by copier `_exclude` only                                                                                   |
| Umbrella ADRs            | **None.** Fifteenth consecutive decline on the settled precedent: `15-DECISIONS/` is user-story-focused, so architecture doctrine goes to `code/docs/` and its per-project half to `how-to/src/`                                                               |
| Register entries triaged | **0 closes · 0 blocks · 0 unrelated** — root `GAPS.md` and `DEFERRED.md` are empty stubs by design, and `TEMPLATE-GAPS.md` carries standing limitations only since 13/08/2026                                                                                  |
| Scope confirmed by Sam   | 15/08/2026 — five surfaces (four briefed + mobile TS) · new top-level guide · sibling of `NEGATIVE-SPACE.md` · doctrine + existing mechanical legs · HTMX pin in scope, vendoring deferred · `code-reviewer` **and the refactor setup** gain routed dimensions |
| Research                 | All seven nodes settled at charting (N-001 to N-007), each adversarially refuted by an independent verifier. **Six of seven had absence claims overturned.** Verdicts below                                                                                    |

### The standing rule for every node on this map

**Cite-don't-restate is not advice here, it is the failure mode.** `audits/doctrine-drift.sh`
exists because "a rule restated in two guides is not redundancy, it is a fork". The `TYPES-*`
family landed hours ago and is not yet committed; anything this epic writes that paraphrases it
forks a document whose ink is still wet. **If a node's outcome would restate a `TYPES-*` H2, it
was mis-scoped — stop and re-grill.**

---

## Register claimed

Both shipped registers are **empty stubs by design**, and `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`
has carried standing limitations only since 13/08/2026, its dated entries having moved to
`MAP-BASE-HEALTH`. **Nothing closes and nothing blocks.**

| Register      | Entry               | Verdict   | Retired by |
| ------------- | ------------------- | --------- | ---------- |
| `GAPS.md`     | _(no open entries)_ | unrelated | —          |
| `DEFERRED.md` | _(no open entries)_ | unrelated | —          |

**This is a claim, not a close.** Nothing here edits either register.

**Two live maps constrain this one without sharing an edge.** `MAP-DOMAIN-OBJECTS` (Resolving,
frontier 0) owns the type-shape half, above. `MAP-BASE-HEALTH` (Charting, 10 open, 0 blocking)
owns the template's own defects, and its **N-027 ratchet** — shipped this morning — is the single
hardest constraint on where this epic can write. Its **N-030** (`routing-skills.sh` cannot see a
multi-line `skills:` array) will silently swallow this guide's routing frontmatter on arrival.

---

## Resolved decisions

Each research node was run by one agent and then attacked by an independent verifier instructed
to refute it. **The verdicts below are the post-refutation position**, not the researcher's.

| Node  | Decision                                                           | Type     | Settled    | Became                                 |
| ----- | ------------------------------------------------------------------ | -------- | ---------- | -------------------------------------- |
| N-001 | Python: what is already law, what is absent, what can be gated     | research | 15/08/2026 | The verdict below — feeds N-010        |
| N-002 | Rust: the lint tables, the modelling half, the disarmament         | research | 15/08/2026 | The verdict below — feeds N-013        |
| N-003 | Alpine: the doctrine, the vendoring claim, the tier collision      | research | 15/08/2026 | The verdict below — feeds N-009        |
| N-004 | HTMX: both axes, the shipped handler, the version landscape        | research | 15/08/2026 | The verdict below — feeds N-011, N-012 |
| N-005 | Mobile TS: the flags, the null-vs-undefined precedent, the gates   | research | 15/08/2026 | The verdict below — feeds N-014        |
| N-006 | The refactor and review consumers — where a rule actually attaches | research | 15/08/2026 | The verdict below — feeds N-017        |
| N-007 | New-guide viability: the registration checklist and the ratchet    | research | 15/08/2026 | The verdict below — binds all          |

### N-001 verdict — Python is the hole in a pattern this repo has already built twice

The Django surface is the only one that **always** ships, and it is the only one with neither a
guide section nor an audit clause for absence. Rust denies four lint families per crate; mobile
sets four tsconfig flags with a `[gate: fail]` audit clause. Python has ruff and basedpyright
doing real work that **no document mentions**.

**Already enforced and undocumented** — writing these as prose would state an existing
enforcement, not add a rule: `== None` is banned by ruff **E711** (live via `select = ["E"]`,
zero occurrences repo-wide, and `rg 'E711|none-comparison'` over 1001 files returns **0**);
mutable defaults by **B006**; `Optional[X]` by **UP045**.

**`strict` buys nothing.** Measured from the installed bundle (basedpyright 1.39.10, sourcemap to
`configOptions.ts`): `reportOptionalCall`, `reportOptionalContextManager`, `reportOptionalIterable`,
`reportOptionalMemberAccess`, `reportOptionalOperand` and `reportOptionalSubscript` are `'error'`
at **basic, standard and strict alike**. So "an optional dereferenced without narrowing" is
already a CI failure. The genuinely un-enforced halves are **propagation** (how far an optional
travels) and **intent** (whether absence is meaningful) — which only doctrine can carry.
`reportUnnecessaryTypeIgnoreComment` is `'none'` even at strict, so the `# type: ignore` smell
needs its own line.

**Three shipped things a naive clause would break, and one it should fix:**

- `code/docs/rendering/PITFALLS-AND-EXAMPLES.md:324` **and** `rendering/TEMPLATES-AND-INTERACTIVITY.md:104`
  both ship `Form(request.POST or None)` — the canonical Django bind-on-POST idiom and literally
  the `x or default` shape the brief flags. **Two sites, not one**; any carve-out names both.
- `accessibility/TESTING-AND-COMPONENTS.md:36` ships `pressed: bool | None = None` with
  `{% if pressed is not None %}` — a legitimate ARIA tri-state. The `Option<bool>` smell needs the
  carve-out or it flags correct code.
- `rls/MIDDLEWARE-AND-NINJA.md:58` ships `getattr(user, "is_authenticated", False)`. A blanket
  `getattr(x, "y", None)` ban would contradict the repo's own RLS example.
- **The live defect:** `api-design/NINJA-CONVENTIONS.md:136` ships
  `response=OrderOut | None` for a single-object GET — modelling a miss as `None` in the same file
  whose line 27 is the repo's closest existing absence clause (_"Make fields required by default.
  Use `T | None = None` only when absence is meaningful"_), and bypassing the shipped
  `ServiceNotFoundError` → 404 mapping.

**Two collisions with standing rules.** `.claude/skills/stack-django/SKILL.md:275` bans
`Args:`/`Returns:`/`Raises:` docstring blocks, so "the docstring states what `None` means" cannot
land in its obvious form. And the same file claims at :259 that basedpyright runs **strict**; it
runs `standard`, and `how-to/src/CONTRIBUTING.md:168` says so — a docs-versus-docs contradiction,
both green.

**Cheapest leg on the board:** `audits/doctrine-drift.sh` is a three-row table whose own comment
reads _"Adding a rule to this table is the whole cost of guarding it."_

### N-002 verdict — the Rust bans are real, and one of them is silently refunded

**Confirmed:** `unwrap_used` and `expect_used` are `deny` in both crates' `[lints.clippy]`
(`nativecore/Cargo.toml:44-45`, `desktop/Cargo.toml:47-48`). **Corrected:** there is **no**
`#![deny(...)]` in `desktop/src/main.rs` — the single source-level attribute in the whole tree is
an `#[allow(` at `main.rs:31`. Source attributes carry **none** of the ban and **all** of the
exemption.

**The finding that matters.** `pedantic = warn` plus `-D warnings` should make
`clippy::option_option` a hard error today. It does not, on any `pub` item, because clippy's
`avoid-breaking-exported-api` defaults to `true` and `clippy.toml` (four lines) never sets it
false. Measured three ways: pub field → 0 diagnostics; same field private → warning; pub field
with the key set false → error. **`nativecore` is nothing but exported API.** Both crates set
`publish = false`, so the default is buying compatibility protection for a promise nobody made.
The same disarmament applies to `ref_option` and `struct_excessive_bools`.

**The repo is stricter than the brief and says so nowhere.** The brief permits `unwrap` in tests,
`build.rs` and examples; this repo permits it in none — `clippy.toml` sets no
`allow-unwrap-in-tests`, and `build.rs:6` returns `Result` _because_ `expect_used` is denied
there. An undocumented stricture decays exactly as an undocumented laxity does.

**`NEGATIVE-SPACE.md` has a per-surface table and forgot two surfaces.** Lines 231-250 argue that
_"a surface earns a row of its own the moment its mechanism differs from its neighbour's"_, then
list six — and omit **Rust and desktop**, both of which have a documented, lint-enforced,
genuinely different mechanism. Two table rows is the most additive landing on this map; the file
is at 252 against a 270 ratchet, so two rows fit and a section does not.

**Decline `clippy::option_if_let_else`** — it pushes `if let … else` with real bodies toward
`map_or`, which is the opposite of the brief's rule. `redundant_clone` is the one worth having,
and it measured green across the workspace including the generated Slint module.

**Nothing blocks a merge on Rust.** `syntax-rust.yml` is path-filtered and therefore not a
required check; `lefthook.yml` has no cargo leg; `code-reviewer/SKILL.md` has zero hits for
rust, clippy, slint or unwrap. Every clippy-based claim here is advisory.

### N-003 verdict — the Alpine leg is smaller than the brief and its foundations are false

**`TYPES-BROWSER.md` took most of it hours ago** — _Declare every property at init_ (with the
"no key added by a method the first time it runs" clause verbatim), _Shared state goes through
`Alpine.store`_, and frozen state constants covering the named-state-field rule.

**What is left is partly a restatement of a tier rule the repo already has, and the collision is
the interesting part.** The brief models `x-data` holding fetched server data. Three shipped
guides route exactly that to HTMX instead — `architecture/FRONTEND-PATTERNS.md:38`
(_"Django is the source of truth… the site holds no client-side data cache"_),
`testing/FRONTEND-TESTING.md:186` (_"keep `x-data` to presentational toggles"_),
`api-design/CLIENT-PATTERNS.md:171`. `rg 'x-for'` returns **0** repo-wide. So an `x-for`-over-fetched-list
clause would be doctrine for a stack this project says it does not have.

**Two false claims ship in the one file agents load for frontend facts.**
`.claude/skills/stack-htmx-templates/SKILL.md:33` states Alpine is _"vendored at
`static/vendor/alpine/alpine.min.js`"_ — that path does not exist, and
`code/src/django/static/CONTEXT.md` says so in plain words. Line 169 references a _"51-route axe
scan"_ against an empty `PAGES` list. **`doc-references.sh` cannot see either**: a `.js` token
skips path resolution, and `static/vendor/…` is outside the owned-path allowlist.

**Alpine is pinned nowhere.** `rg -i 'unpkg|jsdelivr|cdnjs'` → 0; `REFERENCES.md:238` records its
version as literally `latest`. An Alpine rule would be written against an unpinned, undelivered
library with no gate that would notice a semantics change.

**A shipped example commits the exact smell.** `accessibility/HTML-AND-ARIA.md:105` ships bare
`x-data` with an undeclared `open`, a static `aria-expanded` never bound to it, and a `hidden`
never toggled — simultaneously a declare-every-key violation and a broken accessibility example
in the accessibility guide.

### N-004 verdict — the version is not a preference, it decides whether three shipped paragraphs are correct

**The choice is two-way, not the brief's three-way, and it is already half-made.** django-htmx
1.29.0 is installed, **vendors both bundles**, and hard-restricts the majors:
`django_htmx/jinja.py:41` raises `ValueError` unless the version is `2` or `4`. `{% htmx_script %}`
**defaults to 2**. There is no htmx 3; htmx 4 is beta.

**Pinning 4 breaks CSRF in three files.** `rendering/PITFALLS-AND-EXAMPLES.md:100`,
`api-design/CLIENT-PATTERNS.md:102` and `stack-htmx-templates/SKILL.md` all document
`<body hx-headers='{"X-CSRFToken": …}'>`. Under htmx 4, attribute inheritance became explicit and
django-htmx's own docs require `hx-headers:inherited` — so pinning 4 silently disables CSRF
inheritance on every non-form `hx-delete`/`hx-patch`, the exact failure `PITFALLS:90-103` exists
to prevent.

**The shipped handler ignores the entire 4xx band.** `static/js/observability.js:60` is
`if (event.detail.xhr.status < 500) return;`. The doctrine table at `PITFALLS:147-151` has three
rows and **no 4xx row**, while `CLIENT-PATTERNS.md:115` has a 403 row reading _"Nothing to swap"_.
A 403 or 404 therefore produces the silent dead-click the whole doctrine exists to close — a gap
in **already-landed** doctrine, not new ground, and precisely the brief's fourth "nothing".

**django-htmx is declared and entirely unwired.** One hit across 1206 tracked files, a comment in
`pyproject.toml:40`. Not in `INSTALLED_APPS`, not in `MIDDLEWARE`. Every documented example
hand-rolls `request.headers.get("HX-Request")` and hand-assigns `response["HX-Trigger"]`, while
`django_htmx.http` ships typed `reswap()`, `retarget()`, `trigger_client_event()` and a
`SwapMethod` literal that already enumerates `"none"`.

**A documented pattern contradicts two hard rules.** `CLIENT-PATTERNS.md:143` recommends
`hx-on:htmx:response-error="showToast(…)"` — inline JS, which htmx evaluates via the `Function`
constructor against a CSP the edge requirements declare must never gain `unsafe-inline`; and it
is a per-element handler competing with `PITFALLS:153`'s _"one global listener, never per
element"_. `showToast` is defined nowhere.

**"Empty state" is already a word here, meaning something else** — 12 hits across 9 files, every
one a _visual component state_ to design and eyeball. None is a **response contract**. A clause
saying "zero results is a UI state, so render it" reads as a restatement unless written
explicitly about the status code and the partial.

**The request side has no code to bind to.** Zero views, forms, urls or models under `apps/`;
`templates/` holds one file, `500.html`. The unchecked-checkbox rule is pure forward doctrine,
provable only by fixtures. **But it is not doctrinally new:** `api-design/REST-CONVENTIONS.md:75`
already rules _"Missing fields are set to their defaults or null"_ for `PUT`, and `:185` rules
_"Unknown parameters should be ignored (not cause errors)"_ — the same rule on the peer surface,
in words nobody greps for.

**The cheapest node on the map:** `audits/skill-conformance.sh:496` already fails an empty
`skills:` key with the message _"omit the key rather than declaring no dependency"_. The brief's
`hx-target=""` clause is that same rule applied to markup — cite the precedent, add the regex.

### N-005 verdict — the `!` ban is written twice and enforced nowhere

**The cheapest verified win on any surface.** `MOBILE-CODING-PRINCIPLES.md:70` and
`mobile/CLAUDE.md:54` both ban the non-null assertion.
`@typescript-eslint/no-non-null-assertion` is **not** among the 113 effective rules (measured with
`eslint --print-config`), because the config extends only `configs.recommended` and v8 keeps that
rule in `strict`. It needs no type information, measures green on the baseline (zero `!`
assertions), is one line, and runs inside `mobile-lint` — a **required** check.

**The gate ranking is the opposite of the usual assumption.** `audit-negative-space.yml` is
path-filtered and therefore blocks no merge, so `ts-flags-loosened` is advisory;
`syntax-js-ts.yml` has no path filter and its `mobile-lint`/`mobile-typecheck` jobs **are**
required. On this surface an ESLint rule is a harder gate than the audit guarding the tsconfig.

**`strict: false` would pass the existing gate.** `negative-space.sh:81` lists only the four flags
_beyond_ strict; `strict` itself is unchecked, and `strictNullChecks` appears **zero** times in
all 1207 tracked files. The null-safety foundation of this surface rests on an unaudited, unnamed
implication.

**The shipped code already made an absence-representation decision and chose `null`.**
`lib/error-classes.ts:46` returns `number | null` for "carries no status", and the tests at
`:57-58` deliberately collapse the two absences — `classify(null)` and `classify(undefined)` both
return `'programmer'`, in one `it()` block. A "never overload one absence" clause must bless this
as correct-at-an-error-boundary or change it. **This is the highest-value thing to grill here.**

**The guide's own decline list contradicts its own adoption.** It declines
`noPropertyAccessFromIndexSignature` as _"a style preference"_, but with `noUncheckedIndexedAccess`
already on, that flag is exactly what forces the missing-key `| undefined` to be visible at the
call site. By the guide's own test — _"a flag that bans a state is an invariant"_ — it is arguably
an invariant.

**Copier gating is free for a guide and not free for an audit.** `copier.yml:96-137` gates nine
mobile paths including `MOBILE-CODING-PRINCIPLES.md`; `grep negative-space copier.yml` returns
nothing, so audit scripts ship everywhere and must self-skip. `INCLUDE_MOBILE` defaults `false`.

### N-006 verdict — the refactor surface has zero absence content, and the fix may be a cross-reference

**Measured, not asserted.** `rg -ni 'optional|absence|\bnull\b|\bNone\b'` across
`.claude/skills/refactor/SKILL.md`, all four `code/workflows/11-refactor/` files and all three
`project-management/src/22-REFACTORING/` files returns **4 hits, all false positives** — "the
optional opener", "MCP: none", `outline: none`, and "'None.' is a valid entry". Sam's request
lands on genuinely empty ground.

**The guide literally titled _Refactoring Toward Better Structures_ is cited by neither the
refactor skill nor the refactor workflow.** `data-structures/REFACTORING.md` holds the 11-row
smell table, the 8 strategies, and **both** boundary rules — item 9 _"Transform data at
boundaries"_ and item 12 _"validate shape at every boundary"_. `11-refactor/CONTEXT.md` cites two
of its folder-siblings and skips it; `refactor/SKILL.md` cites nothing under `data-structures/`.
**Fixing that cross-reference may deliver more of the intended doctrine than any new prose.**

**There is no editable smell list to append to.** `07-review/STEPS.md:54` names _"the 12 Fowler
code smells"_ as an external baseline, and `README.md:143` confirms _"The taxonomy is referenced,
not reproduced"_ for licence hygiene. A new smell must land as a documented repo standard.
(Noted in passing: Fowler ch. 3 lists 22 smells in the first edition and 24 in the second, not 12
— and nothing in the repo can catch the error because the list is not reproduced.)

**The `codebase-design` vocabulary bans the word "boundary".** `SKILL.md:46-48` lists
_"boundary (for seam)"_ among terms never to substitute. A clause phrased "normalise at the
boundary" collides head-on — and the `TYPES-*` family has already used that exact phrasing in
three H2s. **This needs settling once, for both epics.**

**The compliant shape for a new `code-reviewer` dimension, from the file itself.** Line 156:
_"**Never restate the ban list here.** A copy drifts from the guide and then fails correct work."_
Line 135 shows the pattern: name the rule doc, name the gate, then state only what the gate
cannot decide, marked `[judgement]`. For this doctrine that reads: the owning guide is the rule,
basedpyright's `reportOptional*` set is the gate, and what neither decides — whether an optional's
**reach** is justified and whether absence is **meaningful** — is the skill's judgement. Lines
158-160 already have a convention for clauses that "outrun the diff", which an
optional-propagation finding is, since reach is a property of the call graph.

**`qa-tester` does not duplicate this; it is the complement.** It hunts absence at **runtime**, on
one diff, adversarially; this doctrine is about **static shape** across call frames. The overlap
is one phrase. No de-duplication is needed — only that neither restates the other's half.

**The four code-review-graph cards are git-tracked _and_ declared auto-generated.** Anything
landed in them is committed and silently overwritten on the next `install`. Route to them; never
write in them.

### N-007 verdict — the registration cost is real, and it lands on files already living on borrowed time

**A new `code/docs/*.md` guide is not one file.** It needs the standard header block including the
`**Claude Model:**` line (32 of 33 guides carry it; `VISUAL-DESIGN.md` is the one that does not,
and nothing catches that), routing frontmatter, and index rows in the root `REFERENCES.md`,
`code/REFERENCES.md`, `code/docs/CONTEXT.md` and `code/CONTEXT.md`.

**The reciprocity cost is the real price.** Naming N skills in the frontmatter obliges N edits
under `.claude/skills/` (`skill-conformance.sh` clause 14). **Three of the files that would take
those edits are already over the 270 ratchet and survive only on dated allowances:**
`stack-django/SKILL.md` 290 (expires 01/11/2026), `audits/CONTEXT.md` 282 (01/12/2026),
`.claude/CLAUDE.md` 277 (01/11/2026). **Three more warn-tier files carry no allowance at all and
may not grow by a single line:** `encryption/FIELD-ENCRYPTION.md` 291,
`project-management/docs/SEO-CHECKLIST.md` 289, `VISUAL-DESIGN.md` 287.

**Populations, stated so nothing is a bare ratio.** `ls code/docs/*.md` = 35 files, of which
**one** (`VISUAL-DESIGN.md`, 287) is at or above 270. `find code/docs -name '*.md'` = 164 files,
of which **three** are. Both are the same fact at two scopes.

**The ratchet fired live, mid-session, on a file nobody in this session touched** —
`TYPES-BROWSER.md` was reported _"created at 296 code lines, at or above the 270 tier"_ at 11:10
and now measures 265. **`ABSENCE.md` must be born under 270.**

**`routing-skills.sh` will swallow the frontmatter.** It requires `[` on the `skills:` line;
`.prettierrc` sets `printWidth: 100` and `lefthook.yml:17` makes `prettier --check` mandatory, so
any array over 100 characters is **forced** into the wrapped form the audit cannot see.
`NEGATIVE-SPACE.md`'s eight routing names have never been validated. The repo's format gate and
its routing gate are in direct conflict and the format gate wins silently.
(`MAP-BASE-HEALTH` N-030 owns the fix.)

**The gating shape to copy.** `NEGATIVE-SPACE.md` is **not** copier-gated despite covering mobile;
it ships everywhere, marks the optional part inline as `_(mobile-only)_`, and links to a guide
that is gated out — a dangling link that is deliberate and documented at `copier.yml:103-109`.
A guide covering both always-present and optional surfaces cannot be excluded wholesale, so this
is the shape `ABSENCE.md` copies.

**Two template-integrity gates are RED at HEAD on this branch**, both from commit `8050ac7`, which
is not an ancestor of `main`: `check-template-tokens.sh` exits 1 on an unclosed delimiter in
`audits/conflict-markers.sh:104`, which means **`copier copy` from this branch is currently
broken**; and `shipped-readme.sh` exits 1 with three registration findings. Both run in
`audit-template.yml`. **Any PR from this branch fails that workflow before this epic writes a
line.** Not this epic's to fix — see _Graduated outside this map_.

---

## Frontier

Open decisions in dependency order. **N-008 is the only blocking node**: until the boundary with
`TYPES-*` is drawn, every other node risks writing a fork.

| Node  | Decision                                                                                                          | Type     | Blocked by     | Blocks the map? |
| ----- | ----------------------------------------------------------------------------------------------------------------- | -------- | -------------- | --------------- |
| N-008 | **The collision boundary** — what `ABSENCE.md` owns now `TYPES-*` ships, clause by clause                         | grilling | none           | **yes**         |
| N-009 | The six-kind taxonomy and the cross-language crib — shape, home, and whether it fits under 270                    | grilling | N-008          | no              |
| N-010 | The Python `None` leg — the four carve-outs, the docstring collision, the Ninja `\| None` defect                  | grilling | N-008, N-009   | no              |
| N-011 | The HTMX two-axis contract — four nothings, absent keys, the 4xx band                                             | grilling | N-008, N-009   | no              |
| N-012 | **The HTMX version pin** — 2 or 4, and what it does to the CSRF doctrine in three files                           | grilling | none           | no              |
| N-013 | The Rust remainder, the `avoid-breaking-exported-api` refund, and the two missing `NEGATIVE-SPACE.md` rows        | grilling | N-008, N-009   | no              |
| N-014 | The mobile TS remainder — and whether `error-classes.ts`'s null/undefined collapse is blessed or changed          | grilling | N-008, N-009   | no              |
| N-015 | What the gate can decide, at which tier — `[gate: fail]` / `[warn]` / `[judgement]`                               | grilling | N-010 to N-014 | no              |
| N-016 | The mechanical legs: `no-non-null-assertion`, `doctrine-drift.sh` rows, `avoid-breaking-exported-api`, `PGH003`   | task     | N-015          | no              |
| N-017 | The consumer wiring — `code-reviewer` dimension, the **refactor setup**, and the `REFACTORING.md` cross-reference | task     | N-009          | no              |
| N-018 | Attribution: the `README.md` _Influences_ row and licence check, in the same change                               | task     | N-009          | no              |

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `task` (manual unblocking work)

**Two nodes are takeable now**: **N-008**, which everything waits on, and **N-012**, which is
independent because the version pin is decided by django-htmx's constraint and the CSRF
consequence, not by anything this doctrine says.

### Suggested first batch

**N-008 + N-009 as one grilling pass.** They share a subject — the boundary and the crib are one
question about one table — and deciding them apart means deciding them twice: the crib's row set
_is_ the ownership claim. **N-012 runs alone and in parallel**, being a different type of
question with no shared evidence.

---

## Fog of war

In scope, not yet sharp enough to state as a decision.

- **Whether "normalise at the boundary" can be said at all.** `codebase-design/SKILL.md:46` bans
  _boundary_ as a substitute for _seam_, and the `TYPES-*` family has just shipped three H2s using
  it. Either the vocabulary rule gains an explicit I/O-edge sense, or two epics are now in breach.
  Needs settling once, for both — and this map cannot settle it alone.
- **Whether `ABSENCE.md` should exist at all, or become a section of `TYPES-OVER-DICTIONARIES.md`.**
  Scope was confirmed as a new top-level guide _before_ the `TYPES-*` family was visible. N-008
  must be allowed to reverse it; forcing the confirmed answer through would be exactly the
  "decided on stale evidence" failure this map's refute stage exists to catch.
- **What a 204 means when `error-classes.ts:88` already classifies it as a programmer error.**
  The mobile classifier treats any status `>= 500 || < 400` as "this app misreading it", with a
  test pinning `classify({status: 204})`. Not a contradiction with using 204 on HTMX, but the two
  surfaces would then disagree about what a 204 signifies.
- **Whether the request side can be gated before any view exists.** Zero views, forms or
  templates ship; an unchecked-checkbox clause is provable only by fixtures, the position
  `negative-space.sh:44` already documents for seven of its twelve clauses.

---

## Out of scope

| Ruled out                                         | Why                                                                                                                               |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Restating any `TYPES-*` H2                        | `doctrine-drift.sh` exists because a rule in two guides is a fork, not redundancy                                                 |
| Vendoring Alpine or HTMX, or building `base.html` | Confirmed deferred (5B). Needs a template baseline that does not exist — the blocker N-009/N-014 of `MAP-NEGATIVE-SPACE` both hit |
| Reversing the branded-ID decline                  | `MOBILE-CODING-PRINCIPLES.md` Section 3 settled it with a stated trigger; `MAP-DOMAIN-OBJECTS` already declined to reopen it      |
| Flipping basedpyright to `strict`                 | Measured to buy **zero** optional enforcement — all six `reportOptional*` rules are `error` at standard                           |
| Adopting `clippy::option_if_let_else`             | Mechanises the opposite of the brief's combinator rule                                                                            |
| A mass refactor of existing code                  | There is almost none: 352 cloc of Python with zero optional constructs, 230 lines of Rust with one                                |
| Editing the four code-review-graph task cards     | Auto-generated; regenerated on `code-review-graph install`                                                                        |
| Rewriting `ANTI-PATTERNS.md`                      | On `MAP-NEGATIVE-SPACE`'s Keep list, and `MAP-DOMAIN-OBJECTS` re-declined it today                                                |

---

## Graduated outside this map

Live defects this chart surfaced that are **not this epic's to fix**. Recorded so the evidence is
not lost, and routed rather than adopted. **Nothing here was actioned by this map** — two rows
have since been fixed where they were routed, and are struck below rather than deleted, so the
finding and its close stay legible together.

| Finding                                                                                                                                            | Route                                            |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| `check-template-tokens.sh` RED — unclosed delimiter at `audits/conflict-markers.sh:104`; **`copier copy` is broken on this branch**                | `MAP-BASE-HEALTH` — new node                     |
| `shipped-readme.sh` RED — 3 registration findings (`conflict-markers.sh`, two CI workflows)                                                        | `MAP-BASE-HEALTH` — new node                     |
| Eight shipped docs carry leaked `</content>` / `</invoke>` tool-call artefacts, committed at `35eeb12`; the entire `rendering/` family is affected | `MAP-BASE-HEALTH` — new node                     |
| `x-for` missing from `audits/rules/django-template-xss.yml:22` — a live template-injection gap                                                     | `MAP-BASE-HEALTH` — new node                     |
| ~~`stack-htmx-templates/SKILL.md` — false vendoring claim (:33) and false "51-route" claim (:169)~~ **CLOSED 16/08/2026 at `f4a988b`**             | `MAP-BASE-HEALTH` — ~~new node~~ **fixed there** |
| ~~`stack-django/SKILL.md:259` claims basedpyright `strict`; it is `standard`~~ **CLOSED 16/08/2026 at `f4a988b`**                                  | `MAP-BASE-HEALTH` — ~~new node~~ **fixed there** |
| `DATA-STRUCTURES.md:26` says "All 10 anti-patterns"; there are 11                                                                                  | `MAP-DOMAIN-OBJECTS` (same folder, same session) |
| `doc-references.sh` structurally cannot resolve any path under `code/src/django/`                                                                  | `MAP-BASE-HEALTH` — new node                     |
| `07-review/STEPS.md` Step 1 names `code-reviewer` in its heading and `review` in its dispatch line                                                 | `MAP-BASE-HEALTH` — new node                     |

**The two struck rows were closed by `f4a988b` (16/08/2026), and this re-reads the close off the
working tree rather than off the commit message.** The commit on its own settles nothing here: it
touches **five** files under the subject _"docs(guides): five documents described commands nobody
had run against the tree"_, and only two of them are these skills. All three claims are gone from
where they now sit. `stack-htmx-templates/SKILL.md:37` names no vendored path at all — Alpine is
_"self-hosted, never a CDN, and **vendored by the first page that uses it**"_ — and the string
`51` appears nowhere in that file; the axe-scan bullet at `:188-190` points instead at
`code/src/django/tests/e2e/test_e2e_a11y.py` and states at `:189` that `PAGES` is empty at
baseline. `stack-django/SKILL.md:260` reads **`standard`**, not `strict`, citing
`code/src/django/pyrightconfig.json:7` and `pyproject.toml:166` on the line below it. **The
citations moved twice, not once:** `f4a988b` rewrote both htmx claims in place at `:33` and
`:169`, and `3b87426` (20/08/2026) then rewrote the Alpine row a second time and pushed the
testing bullet down nineteen lines — so a line number lifted from either commit is wrong about
the tree this map is read in. `MAP-BASE-HEALTH` asserts the same three as its **N-037** claims,
fixed there by **N-010** — named for the reference, not relied on for the fact.

**The other seven rows are unchecked here and remain open as charted.** They were not re-measured
in this pass, so an absent strike means nothing was looked at, never that the finding was found to
be clean (`code/docs/GATE-REPORTING.md`).

---

## Session log

| Date       | Node settled   | Outcome                                                                                                                           | Frontier redrawn |
| ---------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 15/08/2026 | N-001 to N-007 | Seven research nodes settled at charting, each adversarially refuted; 33 absence claims overturned; the `TYPES-*` collision found | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed (Sam, 15/08/2026 — `1B 2A 3A 4B 5B 6A` plus the refactor addition)
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — both registers are empty
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [ ] **Every node marked "blocks the map" is resolved** — N-008 is open
- [x] Every resolved node links to the artefact it became
- [x] Index row in `CONTEXT.md` current

**This is a template-development map, so there are no stories to cut.** The equivalent gate is
that **N-008 must settle before any prose is written**, because every other node's output depends
on where the boundary with `TYPES-*` falls.
