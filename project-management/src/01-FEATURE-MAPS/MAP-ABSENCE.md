# MAP-ABSENCE — Absence is not one thing

**Charted**: 15/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature-map`
**Status**: **Fully charted** — all 18 nodes settled across four sittings (charting 15/08/2026,
three resolve batches + the tier pass 31/08/2026); all six slices cuttable
**Frontier open**: 0 · **Blocking open**: 0 · **Fog of war open**: 0
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
settled the **domain-objects-over-dictionaries** epic and wrote **six new guides** into
`code/docs/data-structures/`, none of them yet committed:

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

| Brief's governing rule                            | Now owned by                                                                                                                     |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Normalize at the boundary                         | `TYPES-OVER-DICTIONARIES.md` _Parse at the boundary_ + `REFACTORING.md` 9                                                        |
| Prefer making it unrepresentable / split the type | `TYPES-RUST.md` + `TYPES-TYPESCRIPT.md`, both as H2s                                                                             |
| Several kinds of absence are an enum              | **nobody — overclaim, found 31/08/2026**: that section has zero absence vocabulary, so `ABSENCE.md` **states** this rule (N-008) |
| **Never overload one absence with two meanings**  | **partially** — `rls/MIDDLEWARE-AND-NINJA.md:270` states it for one case                                                         |

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
this owns _what its absence means_. The boundary, clause by clause, was settled 31/08/2026 —
see the batch verdict under _Resolved decisions_ (the split is not clean: Rust absence is cited,
the absence-enum rule is stated, and the gate and doc surfaces belong to sibling guides).

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
| Register entries triaged | Re-triaged 31/08/2026: **0 closes · 0 blocks · 6 unrelated** — `GAPS.md` now carries 3 standing limitations, 3 dated entries and 3 loose items, none touching absence; `DEFERRED.md` still empty; `TEMPLATE-GAPS.md` no longer exists (deleted 22/08/2026)     |
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

Triaged empty at charting; **re-triaged 31/08/2026** against a `GAPS.md` that is no longer a
stub — 3 standing limitations (SL-1..SL-3, read never triaged), 3 dated entries (posture ·
seed-silence · PE-gate) and 3 loose items, every one **unrelated** to absence. `DEFERRED.md`
remains empty. **Nothing closes and nothing blocks.**

| Register      | Entry                                 | Verdict   | Retired by |
| ------------- | ------------------------------------- | --------- | ---------- |
| `GAPS.md`     | 6 open entries (re-triage 31/08/2026) | unrelated | —          |
| `DEFERRED.md` | _(no open entries)_                   | unrelated | —          |

**This is a claim, not a close.** One entry was **appended** this sitting, never closed:
_31/08/2026 — htmx is pinned at major 2, and the v4 migration waits on two named triggers_ —
the N-012 outcome, recorded per RESOLVE step 6.

**One shipped guide family constrains this one without sharing an edge**, and two shipped defects
constrain it from outside any map. The **`TYPES-*` family** owns the type-shape half, above — six
guides and `audits/dict-discipline.sh`, all settled and shipped at `b404307`. The
**`docs-length.sh` 270-line ratchet** — shipped this morning — is the single hardest
constraint on where this epic can write, and `routing-skills.sh`'s blindness to a multi-line
`skills:` array will silently swallow this guide's routing frontmatter on arrival.

---

## Resolved decisions

Each research node was run by one agent and then attacked by an independent verifier instructed
to refute it. **The verdicts below are the post-refutation position**, not the researcher's.

| Node  | Decision                                                           | Type     | Settled    | Became                                       |
| ----- | ------------------------------------------------------------------ | -------- | ---------- | -------------------------------------------- |
| N-001 | Python: what is already law, what is absent, what can be gated     | research | 15/08/2026 | The verdict below — feeds N-010              |
| N-002 | Rust: the lint tables, the modelling half, the disarmament         | research | 15/08/2026 | The verdict below — feeds N-013              |
| N-003 | Alpine: the doctrine, the vendoring claim, the tier collision      | research | 15/08/2026 | The verdict below — feeds N-009              |
| N-004 | HTMX: both axes, the shipped handler, the version landscape        | research | 15/08/2026 | The verdict below — feeds N-011, N-012       |
| N-005 | Mobile TS: the flags, the null-vs-undefined precedent, the gates   | research | 15/08/2026 | The verdict below — feeds N-014              |
| N-006 | The refactor and review consumers — where a rule actually attaches | research | 15/08/2026 | The verdict below — feeds N-017              |
| N-007 | New-guide viability: the registration checklist and the ratchet    | research | 15/08/2026 | The verdict below — binds all                |
| N-008 | The collision boundary — what `ABSENCE.md` owns, clause by clause  | grilling | 31/08/2026 | The 31/08 batch verdict — binds N-010..N-014 |
| N-009 | The taxonomy and crib — new top-level guide, runtime rows, < 270   | grilling | 31/08/2026 | Slice S-01                                   |
| N-012 | The HTMX version pin — **2**                                       | grilling | 31/08/2026 | Slice S-03 + the `GAPS.md` htmx-4 watch      |
| N-017 | Consumer wiring — specified, never performed                       | build    | 31/08/2026 | Slice S-06 acceptance                        |
| N-018 | Attribution in the same change — specified, never performed        | build    | 31/08/2026 | Slice S-01 acceptance                        |
| N-010 | The Python `None` leg — miss = 404, ban scoped, propagation stated | grilling | 31/08/2026 | The second batch verdict — slice S-02        |
| N-011 | The HTMX two-axis contract — 204 no-op, 4xx joins the listener     | grilling | 31/08/2026 | The second batch verdict — slice S-03        |
| N-013 | The Rust remainder — the refund flipped, the stricture documented  | grilling | 31/08/2026 | The third batch verdict — slice S-04         |
| N-014 | The mobile TS remainder — collapse blessed, the decline reversed   | grilling | 31/08/2026 | The third batch verdict — slice S-04         |
| N-015 | The tier assignment — four tiers, markers name their gates         | grilling | 31/08/2026 | The tier-pass verdict — binds every clause   |
| N-016 | The mechanical legs — specified, never performed                   | build    | 31/08/2026 | Slice S-05 acceptance                        |

### The 31/08/2026 batch verdict — N-008 + N-009 as one pass, N-012 beside them

**Grouping:** the crib's row set _is_ the ownership claim, so boundary and taxonomy were one
question; N-012 ran beside them on its own evidence. Before the pass, all six research legs were
re-measured by 12 agents (6 researchers, 6 adversarial refuters) — 16 days of drift had
falsified enough to reshape two of the four questions put to Sam.

**N-008 — the boundary, clause by clause (Sam, 31/08/2026):**

| Clause                                                | Verdict                                                                                                                                                |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Rust absence (`Option`/`Result`, no sentinels)        | **Owned** — `TYPES-RUST.md:156` is an absence-meaning H2, not a shape rule. Cite, never restate; N-013 shrinks to the lint remainder                   |
| Parse at the boundary · unrepresentable states        | Owned as charted — cite. Any `REFACTORING.md` citation must name the _Rules and Principles_ list; the file numbers two lists                           |
| Several kinds of absence are an enum                  | **Owned by nobody** — the charted row was an overclaim. `ABSENCE.md` states it, citing _Boolean Blindness_ and `REFACTORING.md` strategy 5 as adjacent |
| Never overload one absence                            | Stated in `ABSENCE.md`; `rls/MIDDLEWARE-AND-NINJA.md:270` cited as the one shipped instance                                                            |
| Gate-surface absence (tool-absent vs surface-absent)  | **`GATE-REPORTING.md`** (born 18/08) owns it — a **sibling** named in _What this is not_, not a crib row                                               |
| Doc-surface absence (absent here, present downstream) | **`FORWARD-VOICE.md`** (born 18/08) owns it — same sibling treatment                                                                                   |

The crib covers **runtime surfaces only**: Python · Rust · Alpine · HTMX · mobile TS.

**N-009 (Sam, 31/08/2026):** a new top-level `code/docs/ABSENCE.md`, born under 270, six kinds
as charted. Registration is cheaper than N-007 measured: `routing-skills.sh` reads wrapped
arrays now, clause 14 is discharged by existing `code/docs/*` globs, and `code/CONTEXT.md` rows
are unenforced (the three guides born since charting carry none). The boundary-vocabulary fog
item settled with it: `codebase-design/SKILL.md`'s ban on _boundary_ is **scoped to
architectural contexts** — the banning file breaks its own ban four times and 20 headings across
16 files use the word, so the ban was the defect, not the `TYPES-*` headings. The amendment
lands in S-01's story, in the same change as the guide.

**N-012 (Sam, 31/08/2026): pin htmx major 2.** `{% htmx_script %}` defaults to 2 and has zero
call sites — the pin is doctrine nothing loads yet. htmx 4.0.0 went GA on 28/08/2026, but
django-htmx 1.29.0 still vendors 4.0.0-beta6; v4 renames every event (~11 shipped surfaces plus
`negative-space.sh`'s handler clause encode the v2 grammar), and its compat extension does not
re-trigger `htmx:sendError`/`htmx:responseError`, which `observability.js` listens for. The
migration triggers live in the `GAPS.md` watch entry. **The charted independence claim was
false**: v4 swaps 4xx by default, so the pin decides what N-011's 4xx band means — N-011 opens
inheriting pin = 2, under which the charted dead-click evidence stands.

**Re-measured corrections the open nodes inherit** (each claim independently refuted before
recording): `apps/health` ships two views since 16/08 (N-011's request-side fog is part-stale);
`stack-django`'s docstring ban is violated by its own exemplar at :139-151 and by 66 blocks in
`.claude/plugins/` (N-010); `error-classes.ts:47` already branches differently on `null` vs
`undefined` — the collapse is in the test, not the code (N-014); `allow-unwrap-in-tests` binds
six real tests in `nativecore` (N-013); the tier vocabulary is **four** tiers — `[gate: prose]`
exists and _a warn tier is earned, not assumed_ (N-015); `CLIENT-PATTERNS.md` citations drifted
:102→:118, :115→:134, :143→:159.

### The 31/08/2026 second batch verdict — N-010 + N-011 as one pass

**Grouping:** the two halves of the always-shipping Django deployable, both opened against the
morning's refuted re-measurement; three targeted lookups closed the round's evidence
(`error-classes.ts` classify semantics · the PITFALLS doctrine table · htmx 2's native 204
no-swap at `htmx-2.js:265`).

**N-010 (Sam, 31/08/2026):**

- **Miss = 404.** A single-object GET that finds nothing raises `ServiceNotFoundError` into the
  shipped 404 mapping; `response=T | None` is banned for single-object reads and `| None` stays
  fields-only per `NINJA-CONVENTIONS.md:27`. The guide's own read exemplar is fixed in S-02 and
  becomes the worked example.
- **The docstring ban stands, scoped to app code** (`code/src/django/`) — the 66 violating
  blocks are `.claude/plugins/` tooling outside ruff's reach; the ban's own violating exemplar
  at :139-151 is fixed. Doctrine: the annotation carries the shape, **one prose docstring
  sentence names the kind of absence** — never a `Returns:` block.
- **Propagation is a stated rule, judgement-enforced**: absence is resolved where it enters —
  schema, form or service boundary — and interior code takes `T`, not `T | None`. Enforcement is
  the `code-reviewer` `[judgement]` dimension S-06 specifies; N-001 measured that no tool can
  carry reach or intent.
- **The four carve-outs are blessed** as named exceptions with their kinds: bind-on-POST
  `Form(request.POST or None)` (two sites), the ARIA tri-state `bool | None`, and
  `getattr(user, "is_authenticated", False)` at the RLS edge.

**N-011 (Sam, 31/08/2026):**

- **No-op success = 204** — htmx 2 no-swaps it natively (`htmx-2.js:265`); nothing to wire. The
  204/mobile fog item dissolved on evidence: `error-classes.ts` classifies a 2xx carried **by an
  error object** as programmer error — receiving a 204 is not that. Different assertions, no
  disagreement.
- **The non-form 4xx dead click closes in the one global listener**: 4xx joins 5xx on the
  `#error-region` path — a rendered partial at the real status, worded per `NEGATIVE-SPACE.md`'s
  user-error row. The PITFALLS doctrine table gains its 4xx row and the six 5xx-only artefacts
  move together. **The form rule stands** — user error is 200 with the re-rendered form — and
  S-03 adds one surface-scoping sentence so `REST-CONVENTIONS.md:102` (API: never 200 with an
  error body) and PITFALLS (pages: form re-render is 200) stop colliding.
- **The request axis is stated now, gated later**: absent key = unchecked checkbox, cross-citing
  `REST-CONVENTIONS.md` :75 and :185; the fixture-provable gate waits for real forms, the
  position `negative-space.sh:44` already documents.
- Mechanical corrections routed to S-03: `CLIENT-PATTERNS:159`'s `hx-on:` + ghost `showToast`
  replaced by the global listener; the zero-results clause written explicitly as **200 + the
  empty-state partial** so it cannot read as the visual-component sense.

**N-012 amended, not reversed (Sam, 31/08/2026): django-htmx is dropped.** The pin stays major
**2**; the mechanism changes from `{% htmx_script %}` to a **self-vendored bundle**, exactly the
shipped Alpine convention (self-hosted, never a CDN, vendored by the first page that uses it).
Grounds: the package is declared and entirely unwired, all six guides hand-roll its headers, and
self-vendoring ends the inheritance of its bundle cadence (it ships 4.0.0-beta6 today). Removing
`django-htmx` from `pyproject.toml` is an S-03 mechanical leg; the `GAPS.md` watch entry's
trigger is re-worded to "the repo vendors the 4.x GA".

### The 31/08/2026 third batch verdict — N-013 + N-014 as one pass

**Grouping:** the copier-gated optional surfaces, each a remainder after N-008 shrank it. Every
load-bearing claim re-measured at the sitting: `clippy.toml` carries only `doc-valid-idents`,
`NEGATIVE-SPACE.md` is 252 cloc with six surface rows and no Rust or desktop row, the test
collapse sits at `error-classes.test.ts:57-58`, and `strict` is absent from the audited
`TS_FLAGS`.

**N-013 (Sam, 31/08/2026):**

- **`avoid-breaking-exported-api = false`** — one `clippy.toml` line restores `option_option`,
  `ref_option` and `struct_excessive_bools` on `pub` items; both crates set `publish = false`,
  so the default was protecting a promise nobody made. S-04 leg.
- **The test-unwrap stricture is kept and documented** — `unwrap`/`expect` stay denied
  everywhere including tests (green across six real tests); one sentence in the Rust clause and
  the NEGATIVE-SPACE row says so, because an undocumented stricture decays exactly as an
  undocumented laxity does.
- The two **`NEGATIVE-SPACE.md` per-surface rows** (Rust, desktop) land in S-04 — additive,
  252 + 2 rows fits the 270 ratchet; each points at the owning guide.

**N-014 (Sam, 31/08/2026):**

- **The null/undefined collapse is blessed** — `httpStatus()` normalises both into "no usable
  status" at the error boundary; two syntactic absences, one meaning, is parse-at-the-boundary
  applied, not overloading. One sentence in the mobile clause names why.
- **`noPropertyAccessFromIndexSignature` is adopted, reversing the shipped decline** — the
  decline's stated reason ("a style preference") was measured wrong: with
  `noUncheckedIndexedAccess` on, dot access makes an expected-miss lookup read like a guaranteed
  property. Baseline green (no index signatures in the seven files). S-04: flag set `true`,
  joins `TS_FLAGS`, and the decline row gains its dated reversal.
- Calls recorded with the batch: **`strict` joins `negative-space.sh`'s `TS_FLAGS`** (a
  foundation no gate checks is a rule enforced by nothing); `no-non-null-assertion` stays an
  N-016 leg; the ABSENCE.md Rust row stays a citation per N-008; `redundant_clone` stays out of
  scope.

### The 31/08/2026 tier-pass verdict — N-015, with N-016 resolving by specification

**Re-measured at the sitting:** the tier vocabulary is marker-driven — `[gate: fail]` /
`[gate: warn]` / `[judgement]` / `[gate: prose]`, scripts implement against the markers; a warn
tier never flips the exit code and is **earned** (presence tests are fail-tier); the drift table
is three TAB rows where adding a row is the whole cost; ruff `select` has no `PGH`.

**N-015 (Sam, 31/08/2026) — every clause carries its tier inline, and the marker names its
gate:**

- **`[gate: fail]`** — the live enforcement (E711 · B006 · UP045 · `reportOptional*` · the
  clippy denies and the flipped pedantic trio · `no-non-null-assertion` · `TS_FLAGS`), plus two
  **new** members: an `owned` doctrine-drift row pinning the 4xx predicate's statement shape to
  `rendering/PITFALLS-AND-EXAMPLES.md` (six artefacts restating one predicate is the fork the
  table guards), and a `negative-space.sh` clause `@router\.get\(.*\|\s*None` over `apps/**`
  (a presence test, so fail-tier by the earned rule; baseline green once S-02 fixes the doc
  exemplar). Where a gate's workflow is path-filtered, the marker says so — GATE-REPORTING
  honesty.
- **`[judgement]`** — the docstring absence-sentence and propagation reach; the S-06 reviewer
  dimension, no script decides either.
- **`[gate: prose]`** — the carve-outs, the stricture and collapse sentences, 204 and the four
  nothings, the surface-scoping sentence, the request axis; nothing executable until templates
  and forms exist.
- **No clause takes `[gate: warn]`** — every candidate is a presence or correlation test, the
  `skill-conformance.sh` precedent; inventing a soft tier to look lenient is how a gate stops
  meaning anything.

**N-016 resolved by specification** — S-05's legs are the ESLint `no-non-null-assertion` rule,
`PGH` joining ruff `select` (for PGH003), the drift row, and the Ninja-GET clause; the clippy
key and the `TS_FLAGS` additions already belong to S-04. Each leg lands green on the baseline,
and every gated clause's marker names its gate.

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
its routing gate are in direct conflict and the format gate wins silently. The fix is not this
map's to make.

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

## Slices

**Cut 31/08/2026, reversing the charted "none is possible".** Sam's direction: wayfinder maps
slices ready for stories, template work included — the charted position confused the artefact
(no end-user feature) with the unit (a story-sized deliverable). `02-story-creation` cuts from
these rows as from any map; the `Story` column stays `—` until that gate allocates numbers.

| Slice | Story | Title                                   | Nodes                          | Acceptance                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Flags |
| ----- | ----- | --------------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| S-01  | US003 | The guide — `ABSENCE.md` born under 270 | N-008 ✅ · N-009 ✅ · N-018 ✅ | Six kinds stated once with the runtime crib (Python · Rust · Alpine · HTMX · mobile TS); Rust row cites `TYPES-RUST.md:156`; absence-enum rule stated, not cited; GATE-REPORTING, FORWARD-VOICE and NEGATIVE-SPACE named siblings in _What this is not_; `codebase-design`'s boundary ban scoped in the same change; registered (header · frontmatter · both `REFERENCES.md` · `code/docs/CONTEXT.md`); any derived source gains its _Influences_ row + licence check in the same commit; < 270 cloc at birth                                                                                                                                                                                                             | —     |
| S-02  | —     | The Python `None` clause                | N-010 ✅                       | Miss on a single-object GET raises `ServiceNotFoundError` → 404; `response=T \| None` banned for reads, `\| None` fields-only; the guide's read exemplar fixed as the worked example; docstring ban scoped to `code/src/django/` and its violating exemplar fixed; one prose sentence names the kind of absence; propagation rule stated (resolved where it enters, interior code takes `T`) with the four carve-outs blessed as named exceptions                                                                                                                                                                                                                                                                         | —     |
| S-03  | —     | The HTMX contract, on pin 2             | N-011 ✅ · N-012 ✅            | Pin **2**, self-vendored like Alpine — `django-htmx` removed from `pyproject.toml` as a mechanical leg; no-op success = **204** (htmx 2 no-swaps natively); non-form 4xx joins the one global listener's `#error-region` path with a rendered partial at the real status; form errors stay 200 re-render, one surface-scoping sentence reconciling `REST-CONVENTIONS.md:102`; the doctrine table gains its 4xx row and the six 5xx-only artefacts move together; `hx-on:` + ghost `showToast` replaced by the global listener; zero results = 200 + the empty-state partial, stated as status + partial; request axis stated (absent key = unchecked checkbox, citing `REST-CONVENTIONS` :75/:185), fixture gate deferred | —     |
| S-04  | —     | The optional-surface remainders         | N-013 ✅ · N-014 ✅            | `avoid-breaking-exported-api = false` in `clippy.toml`; test-unwrap stricture documented in the Rust clause; the two `NEGATIVE-SPACE.md` rows (Rust, desktop) added, each pointing at its owning guide; null/undefined collapse blessed with its naming sentence in the mobile clause; `noPropertyAccessFromIndexSignature` set `true`, joins `TS_FLAGS`, decline row carries its dated reversal; `strict` joins `TS_FLAGS`; audits self-skip where the surface is copier-gated out                                                                                                                                                                                                                                       | —     |
| S-05  | —     | Tiers and the mechanical legs           | N-015 ✅ · N-016 ✅            | Every clause in `ABSENCE.md` and the per-surface clauses carries its inline tier marker, and each `[gate: fail]` marker names its gate (path-filtered workflows named as such); no clause takes `[gate: warn]`; the four legs land green on baseline — ESLint `no-non-null-assertion` at error, `PGH` in ruff `select`, the `owned` drift row pinning the 4xx predicate to PITFALLS, the `negative-space.sh` `@router.get` `\| None` clause; `[judgement]` clauses route to S-06's dimension and no script decides one                                                                                                                                                                                                    | —     |
| S-06  | —     | Consumer wiring                         | N-017 ✅                       | `code-reviewer` gains the routed dimension in its compliant shape (rule doc + gate named, only reach-and-meaningfulness marked `[judgement]`); `refactor` skill and `11-refactor` cite `data-structures/REFACTORING.md`, naming the _Rules and Principles_ list; depends on S-01 shipping first                                                                                                                                                                                                                                                                                                                                                                                                                           | —     |

**All thirteen gate flags still read `N/A`** — nothing here creates a model, an endpoint, a
screen or a personal-data path — so every manifest is empty by construction; recorded rather
than omitted. N-017 and N-018 are **specified, never performed**: their build work belongs to
their slices' stories.

---

## Frontier

**Empty — the route is fully charted.** All 18 nodes settled: seven research at charting, ten
across the 31/08/2026 sittings, N-016 by specification. No decision remains open on this map;
what remains is the slices' build work, reached through `02-story-creation`.

**Types:** `research` (looked up, no human) · `tracer` (spike to raise fidelity) ·
`grilling` (one `/grill-with-docs` surface) · `build` (the work a slice's story carries —
named here, never done here). **Manual unblocking work is not a node** — it is a `GAPS.md`
blocker. Renamed from `task` on 31/08/2026; the old name was never once used as defined.

**Nothing is takeable — nothing is left.** The next act on this map is `02-story-creation`
cutting stories from S-01..S-06, S-01 first because every per-surface clause cites the guide it
lands beside.

---

## Fog of war

**Empty.** All four charted items graduated on 31/08/2026: the boundary-vocabulary item into
N-009 (the ban was the defect — it broke itself four times in its own file); the guide-existence
item into N-008 (the new top-level guide re-confirmed on fresh evidence); the 204/mobile item
into N-011 — dissolved, not decided (`error-classes.ts` classifies a 2xx carried **by an error
object** as programmer error, which asserts nothing about receiving a 204); and the
request-side-gating item into N-011 and N-015 — stated as `[gate: prose]` now, fixture-provable
later, the position `negative-space.sh:44` documents for seven of its twelve clauses.

---

## Out of scope

| Ruled out                                         | Why                                                                                                                           |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Restating any `TYPES-*` H2                        | `doctrine-drift.sh` exists because a rule in two guides is a fork, not redundancy                                             |
| Vendoring Alpine or HTMX, or building `base.html` | Confirmed deferred (5B). Needs a template baseline that does not exist — the same blocker two earlier nodes both hit          |
| Reversing the branded-ID decline                  | `MOBILE-CODING-PRINCIPLES.md` Section 3 settled it with a stated trigger, and `TYPES-TYPESCRIPT.md:255` records it unreversed |
| Flipping basedpyright to `strict`                 | Measured to buy **zero** optional enforcement — all six `reportOptional*` rules are `error` at standard                       |
| Adopting `clippy::option_if_let_else`             | Mechanises the opposite of the brief's combinator rule                                                                        |
| A mass refactor of existing code                  | There is almost none: 352 cloc of Python with zero optional constructs, 230 lines of Rust with one                            |
| Editing the four code-review-graph task cards     | Auto-generated; regenerated on `code-review-graph install`                                                                    |
| Rewriting `ANTI-PATTERNS.md`                      | Placed on an earlier map's Keep list, and declined again on 15/08/2026 — its 11 patterns stand, cited and never restated      |

---

## Graduated outside this map

Live defects this chart surfaced that are **not this epic's to fix**. Recorded so the evidence is
not lost, and routed rather than adopted. **Nothing here was actioned by this map** — two rows
have since been fixed where they were routed, and are struck below rather than deleted, so the
finding and its close stay legible together.

| Finding                                                                                                                                            | Route                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `check-template-tokens.sh` RED — unclosed delimiter at `audits/conflict-markers.sh:104`; **`copier copy` is broken on this branch**                | **Unrouted** — destination map deleted                                   |
| `shipped-readme.sh` RED — 3 registration findings (`conflict-markers.sh`, two CI workflows)                                                        | **Unrouted** — destination map deleted                                   |
| Eight shipped docs carry leaked `</content>` / `</invoke>` tool-call artefacts, committed at `35eeb12`; the entire `rendering/` family is affected | **Unrouted** — destination map deleted <!-- conflict-markers: ignore --> |
| `x-for` missing from `audits/rules/django-template-xss.yml:22` — a live template-injection gap                                                     | **Unrouted** — destination map deleted                                   |
| ~~`stack-htmx-templates/SKILL.md` — false vendoring claim (:33) and false "51-route" claim (:169)~~ **CLOSED 16/08/2026 at `f4a988b`**             | ~~new node~~ **fixed**                                                   |
| ~~`stack-django/SKILL.md:259` claims basedpyright `strict`; it is `standard`~~ **CLOSED 16/08/2026 at `f4a988b`**                                  | ~~new node~~ **fixed**                                                   |
| ~~`DATA-STRUCTURES.md:26` says "All 10 anti-patterns"; there are 11~~ **CLOSED 24/08/2026** — count corrected and the eleventh named               | ~~routed, never adopted~~ **fixed**                                      |
| `doc-references.sh` structurally cannot resolve any path under `code/src/django/`                                                                  | **Unrouted** — destination map deleted                                   |
| `07-review/STEPS.md` Step 1 names `code-reviewer` in its heading and `review` in its dispatch line                                                 | **Unrouted** — destination map deleted                                   |

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
the tree this map is read in.

**The third struck row was closed on 24/08/2026, twenty-three days after it was written.** The
anti-pattern count was routed to the domain-objects map on 15/08/2026 and never adopted there; it
was re-measured when that map was deleted, found **still wrong**, and fixed in the same pass —
`DATA-STRUCTURES.md:26` now reads **11** and names _ID-or-Instance Parameter_
(`ANTI-PATTERNS.md:270`), the pattern its enumeration had dropped. **The delay is the finding.**
The count went stale at `82c8135` (14/08/2026), which added the eleventh pattern without touching
the index; `b404307` edited **both** files the next day and did not close it; and nothing could
have caught it in between, because `doctrine-drift.sh` reads fenced code only and this was a bare
number in a prose table. That is the split's measured cost, paid in full and now legible.

**The remaining six rows are unchecked here and remain unrouted.** They were not re-measured in
this pass, so an absent strike means nothing was looked at, never that the finding was found to
be clean (`code/docs/GATE-REPORTING.md`).

---

## Session log

| Date       | Node settled                                     | Outcome                                                                                                                                                                                                                                                                                            | Frontier redrawn |
| ---------- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| 15/08/2026 | N-001 to N-007                                   | Seven research nodes settled at charting, each adversarially refuted; 33 absence claims overturned; the `TYPES-*` collision found                                                                                                                                                                  | [x]              |
| 31/08/2026 | N-008 · N-009 · N-012 (+ N-017, N-018 specified) | Re-measured first (6 legs, 12 agents, each refuted); boundary drawn — Rust cited, enum rule stated, gate/doc surfaces siblinged; new top-level guide confirmed; htmx pinned **2** + `GAPS.md` watch; slices S-01..S-06 cut                                                                         | [x]              |
| 31/08/2026 | N-010 · N-011 (N-012 amended)                    | Second batch, one pass: miss = 404 and `\| None` fields-only; docstring ban scoped, propagation stated `[judgement]`; no-op = 204; non-form 4xx joins the global listener, form rule stands; **django-htmx dropped** — htmx self-vendored like Alpine; 204 fog dissolved                           | [x]              |
| 31/08/2026 | N-013 · N-014                                    | Third batch, one pass: `avoid-breaking-exported-api` flipped; test-unwrap stricture kept and documented; two NEGATIVE-SPACE rows land; null/undefined collapse blessed; `noPropertyAccessFromIndexSignature` adopted, reversing the shipped decline; `strict` joins `TS_FLAGS`                     | [x]              |
| 31/08/2026 | N-015 · N-016                                    | Tier pass: every clause carries its inline marker naming its gate; no clause takes `[gate: warn]` (earned, not assumed); two new fail-tier members — the 4xx-predicate drift row and the `@router.get` `\| None` clause; N-016 specified onto S-05. **Frontier and fog empty — map fully charted** | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed (Sam, 15/08/2026 — `1B 2A 3A 4B 5B 6A` plus the refactor addition)
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — re-triaged 31/08/2026: 6 open entries, all unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocks the map" is resolved** — N-008 settled 31/08/2026
- [x] Every resolved node links to the artefact it became
- [x] **Every slice has a flag manifest** — S-01..S-06 cut 31/08/2026; every manifest empty by construction (all 13 flags `N/A`)
- [x] Index row in `CONTEXT.md` current

**Template-development map, slices cut 31/08/2026 on Sam's direction** — `02-story-creation`
is the next gate. N-008 is settled, so per-surface prose may be written by the slices' stories;
S-01 ships first, because every per-surface clause cites the guide it lands beside.
