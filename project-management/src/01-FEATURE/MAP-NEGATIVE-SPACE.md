# MAP-NEGATIVE-SPACE — Constrain what is not allowed, and fail loudly

**Charted**: 09/08/2026 · **Charted by**: Sam Bailey · **Workflow**: `01-feature`
**Last verified**: 14/08/2026 — N-007 to N-011 re-checked against the tree at **v3.2.1 + `93037ba`**
(the earlier pass this line recorded ran at v3.1.0). Every core claim holds; four drifted and are
amended in place below
**Status**: **Shipped** — frontier emptied 11/08/2026 and every artefact is committed and released
(`ce259df` v2.7.0 · `59eba9d` v2.15.0 · `9489d8b` v2.18.0 · `35eeb12`). Doctrine complete, every
surface expressed, the gate runs, the baseline conforms, the stack skills route to it, and the
attribution is verified and measured
**Frontier open**: 0 · **Blocking open**: 0 · **Fog of war open**: 0 — discharged 14/08/2026,
two written into their owning guides, one converted to a stated limit, two graduated to
`MAP-BASE-HEALTH` as its `N-026` and `N-027`. **No node was opened here; this map does not
reopen.** The completion bar in
`.claude/skills/wayfinder/SKILL.md` is now met in full — _"done when Frontier and Fog of war are
both empty"_

> **Template-development artefact.** This map charts work on `syntek-base` itself, not on a
> project generated from it. It is **committed here**, so it syncs across devices, and it is
> emptied out by `copier.yml` `_exclude` at generation — so it never reaches a generated
> project. The exclusion lives in `copier.yml`, which does not travel either.
>
> **Untracked is the settled position, confirmed by Sam 14/08/2026** — not a risk awaiting a fix.
> The consequence is stated once, here, and not re-argued: this file exists only in this working
> tree, a fresh clone will not have it, and nothing outside the tree can restore it. Every claim
> below is therefore written to stand on its own; a cross-map reference names the map **and** what
> it asserts, so losing the other file costs the reference, not the fact.

---

## Destination

**Negative space programming becomes a named discipline in the template**: the codebase states
what is _not_ allowed and fails loudly on impossible states, rather than only encoding the happy
path. One thin owning guide holds what nothing else can own — the **enforcement-point register**,
the **programmer-error / user-error split**, and the **explicit-`raise`** standard — and every
surface clause lands in the guide that already governs that surface and is routed to from the
owner. A deterministic audit mirrors the decidable half. The baseline ships conforming.

**Done looks like:** for any invariant, a developer can name its **single** enforcement point and
its database constraint without guessing; a broken invariant reaches Sentry as a 500 rather than a
friendly 4xx; and the template does not ship a skeleton that violates its own rule.

**What this is not.** Not a rewrite of the constraint doctrine — `DATABASE.md` and
`data-structures/SCHEMA-DESIGN.md` already carry it and are on the Keep list. Not a consolidation
pass over guides that restate each other (Q3 → option 2). The register **binds new work**; it does
not reopen old.

---

## Change budget — what we alter, what we keep

**Roughly half the source brief is already doctrine here** (N-001). The failure mode to guard
against is not under-delivery but a second, gateless prose source restating four enforced guides —
exactly the drift `MAP-DOCTRINE-UPGRADE` N-009 repaired in `code-reviewer.md`.

### Keep — do not touch, do not "improve"

- **`.claude/CLAUDE.md` Section 6 constraint non-negotiables**, `code/docs/DATABASE.md` Section _Before the
  first migration_, and `data-structures/SCHEMA-DESIGN.md` Section _Foreign Keys and Constraints_. The
  Postgres leg of the brief is **already law**; this epic cites it, never restates it.
- **The service exception hierarchy** (`architecture/SERVICE-AND-MIDDLEWARE.md`) — `ServiceError`
  and its four subclasses. N-005 layers a taxonomy **over** it; it does not renumber it.
- **The middleware rules** in the same guide — ordering, no business logic, no global expense.
- **`data-structures/ANTI-PATTERNS.md`** — nine named anti-patterns already cover god-dicts,
  stringly-typed data, primitive obsession, boolean blindness and overloaded status fields.

  > **Amended 14/08/2026 — the count was ten, and the fog-of-war pass made it eleven.** Measured
  > rather than assumed: the file carried **ten** patterns when this line was written, not nine.
  > The discharge of the ID-or-instance entry added **_The ID-or-Instance Parameter_** as the
  > eleventh. That is not a Keep-list breach: the standing rule forbids **removing** something on
  > the list, and N-004 explicitly designated this file as the home for architectural bans
  > (_"Architectural bans stay in `data-structures/ANTI-PATTERNS.md`"_). Nothing already there was
  > touched.

- **`TASK-AUTHORING.md` → The enqueue boundary** — `transaction.on_commit()`, pass identifiers,
  re-read in the task. N-010 adds entry validation beside it, and changes none of it.
- **The IDOR / ownership rules** in `security/INPUT-AND-API.md` and `security/OWASP-AND-CHECKLIST.md`.
- The layered `CONTEXT.md`/`CLAUDE.md` convention, the 300-line instructional limit, the frozen
  `project-management/src/` numbering, the coverage floors.

### Change — edits to files that already exist

**Shipped at N-008:** `pyproject.toml` (ruff `TID251` + the `N818` exemption) · `config/settings/base.py` (`INSTALLED_APPS`) · `api-design/NINJA-CONVENTIONS.md` Section _Schema strictness_ · the stale-reference sweep across 14 documents. **Shipped at N-007:** `pyproject.toml` (the ruff `S101` gate) · `code/docs/BACKEND-CODING-PRINCIPLES.md`
Section _Error Handling_ (the routed clause) · the root `README.md` Section _Influences and attribution_ (the
attribution row Section 6 requires in the same change). **Shipped at N-009:**
`config/settings/dev.py` + `test.py` (`string_if_invalid`) · `config/settings/base.py`
(`MIDDLEWARE`) · `rendering/PITFALLS-AND-EXAMPLES.md` (two clauses) ·
`FRONTEND-CODING-PRINCIPLES.md` (one checklist row) · `NEGATIVE-SPACE.md` (the per-surface routing
table) · `SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 13 · the `middleware/request_log` path
repointed in three documents. **Shipped at N-011:** `code/src/mobile/tsconfig.json` (four flags) ·
`code/src/mobile/jest.config.js` (the `lib/**` coverage glob) · `copier.yml` `_exclude` (the new
guide, gated on `INCLUDE_MOBILE`) · `NEGATIVE-SPACE.md` (the mobile row on the per-surface table) ·
`how-to/src/INVARIANTS.md` (the `client-guard` mechanism and its section) ·
`code/src/mobile/CONTEXT.md` + `CLAUDE.md` · three indexes. **Shipped at N-012** (markers only, no
new prose rules): `NEGATIVE-SPACE.md` Section _What the gate decides_ + the middleware clause ·
`rendering/PITFALLS-AND-EXAMPLES.md` (the listener clause and its limit) ·
`MOBILE-CODING-PRINCIPLES.md` (the four-flags clause). **Shipped at N-010:** `pyproject.toml`
(ruff `TID251` on both `BaseCommand` import paths, plus the one per-file exemption) ·
`TASK-AUTHORING.md` (the version-skew clause and Section _The error taxonomy on this surface_) ·
`NEGATIVE-SPACE.md` (the last two rows of the per-surface table) · `PROCESS-MODEL.md` (the
connection rule, which one of its three processes now satisfies structurally) ·
`apps/core/CONTEXT.md` + `CLAUDE.md`, `apps/CONTEXT.md`, `django/CONTEXT.md`, three indexes.
**Shipped at N-014:** `rendering/PITFALLS-AND-EXAMPLES.md` (the corrected handler, the two
snippet defects, and Section _The identifier a full-page error cannot be given_) ·
`FRONTEND-CODING-PRINCIPLES.md` (Section _What is not built yet_, the web peer of the mobile guide's
Section 5) · `MOBILE-CODING-PRINCIPLES.md` (the four unreached-application statuses, and Section 5 rewritten
now the classifier ships) · `EDGE-REQUIREMENTS.md` Section 14 + its status row · `code/src/CONTEXT.md`,
`django/CONTEXT.md`, `apps/CONTEXT.md`, `apps/core/CONTEXT.md`, `mobile/CONTEXT.md`. **Still to
come:** `code/src/scripts/development/new-django-app.sh` (N-008, if the scaffold is ever the
propagation point — N-014 did **not** touch it: the script builds a domain app, and nothing
N-014 shipped is per-app). **Shipped at N-015:** `.claude/skills/stack-django/SKILL.md`
(the guard/taxonomy clauses, the schema-base rule, Section _Off the request cycle_, and one worked
example corrected from a bare `ValueError`) · `stack-htmx-templates/SKILL.md`
(Section _When a swap would show nothing_) · `stack-react-native/SKILL.md` (Section _What the types and the
app must never allow_) · `stack-fastmcp/SKILL.md` (Section _What a tool must never allow_, plus a
committed merge conflict repaired). **Shipped at N-016:** `THIRD-PARTY-NOTICES.md` (two measured
overlap rows) · `README.md` Section _Influences_ (the per-claim pointer corrected for the TigerStyle
row). **Never coming, and now moot:** routing clauses on the agents. The agent tier was retired
in full at **v3.0.0** — `.claude/agents/` deleted, 56 files — so the files N-015 declined to edit
no longer exist. Verified absent 14/08/2026.

### Add — new files

**Shipped at N-006:** `code/docs/NEGATIVE-SPACE.md` (the rule, 154 code lines) · `how-to/src/INVARIANTS.md`
(the per-project answer sheet). **Shipped at N-008:** `code/src/django/apps/core/` — `apps.py`, `schemas.py`, `services/errors.py`, and two `CONTEXT.md`/`CLAUDE.md` pairs. **Shipped at N-009:** `code/src/django/apps/core/middleware.py` — `RequestIDMiddleware` and `current_request_id()`. **Shipped at N-013:** `code/src/scripts/audits/negative-space.sh` (nine fail clauses, one warn, a `--self-test`) · `code/src/scripts/audits/fixtures/negative-space/{broken,clean}/` · `.github/workflows/audit-negative-space.yml`. **Shipped at N-010:** `code/docs/MANAGEMENT-COMMANDS.md` (the owning guide, 144 code lines) · `code/src/django/apps/core/management/` — `__init__.py`, `base.py` (`ManagementCommand` + `EXIT_TEMPFAIL`), and its `CONTEXT.md`/`CLAUDE.md` pair. **Shipped at N-014:** `code/src/django/templates/500.html` · `code/src/django/static/js/observability.js` · `code/src/django/apps/core/templatetags/` — `__init__.py`, `core.py` (`{% request_id %}`), and its doc pair · `code/src/mobile/lib/error-classes.ts` + `__tests__/error-classes.test.ts` · doc pairs for `templates/` and `static/`. **Deliberately not built:** `503.html` (Django defines no handler, and the 503 that matters is the edge's — `EDGE-REQUIREMENTS.md` Section 14), the HTMX error partial and the `#error-region` div (both need a base template), and the mobile error screen (needs the token module and the voice).

### The standing constraint — baseline edits must survive deletion

Sam's Q5 caveat, promoted to a rule because it decides several nodes: **a generated project may
delete any skeleton file.** A rule whose only enforcement is a line in a file a project can remove
is not enforced — it is a default that vanishes silently. Every baseline edit must therefore state
which class it is in:

| Class                | Survives deletion? | Example                                                      |
| -------------------- | ------------------ | ------------------------------------------------------------ |
| **Doctrine + audit** | Yes                | The audit re-derives the finding from whatever files exist   |
| **Scaffold-emitted** | Yes for new work   | `new-django-app.sh` re-emits it on every app                 |
| **Single config**    | **No**             | A `model_config` on one base class nothing forces you to use |

N-008, N-009, N-011 and N-014 each name their class explicitly. A clause that lands only in the
third class needs an audit leg or it does not ship as a rule.

### The standing rule for every node

**Additive first.** Prefer a routed clause in the guide that already owns the surface over a new
paragraph in the owner; prefer a cross-reference over an edit; never delete a guide to replace it.
If a node's outcome would remove something on the Keep list, it was mis-scoped — stop and re-grill.

---

## Notes

| Field                                  | Value                                                                                                                                                                                                                                        |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                                 | Correctness doctrine · invariant enforcement · error taxonomy · audit tooling · skill routing                                                                                                                                                |
| Skills to load                         | `codebase-design` · `domain-modelling` · `grill-with-docs` · `stack-django` · `stack-htmx-templates` · `stack-react-native` (N-011) · `runbook` (the audit register)                                                                         |
| Standing preferences                   | Additive first · one enforcement point + the DB constraint · no restatement of an enforced guide · baseline edits declare their deletion class · instructional `.md` ≤ 300 lines · surfaces gated by copier `_exclude` only                  |
| Umbrella ADRs                          | **None.** Fourteenth consecutive decline on the settled precedent: `14-DECISIONS/` is user-story-focused, so architecture doctrine goes to `code/docs/` and its per-project half to `how-to/src/`. Confirmed by Sam at charting              |
| Register entries triaged               | 0 closes · 2 blocks · 12 unrelated (root `GAPS.md` and `DEFERRED.md` are empty stubs by design; at charting all 14 open entries sat in `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` — since 13/08/2026, `MAP-BASE-HEALTH.md`)                |
| Research                               | All three research nodes settled at charting — N-001 (the enforcement inventory), N-002 (exclusion + partial unique constraints), N-003 (Ninja's silent-ignore default). Verdicts below; no `research/` note earned one, each feeds one node |
| Relationship to `MAP-DOCTRINE-UPGRADE` | **Separate map, deliberately.** That epic's destination is _design_ discipline (what good looks like); this one is _correctness_ discipline (what must never be true). No shared blocking edges; the Keep lists are disjoint                 |

---

## Register claimed

The two shipped registers (`GAPS.md`, `DEFERRED.md`) are **empty stubs by design** — the
template's own register was `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`, holding all 14 open
entries when this map was charted. **Nothing closes**; two constrain the work.

**This is a claim, not a close.** Nothing here edits either register.

| Register           | Entry                                                          | Verdict | Retired by                                         |
| ------------------ | -------------------------------------------------------------- | ------- | -------------------------------------------------- |
| `TEMPLATE-GAPS.md` | 03/08/2026 — Python pre-commit hooks cannot run in syntek-base | blocks  | node N-014 (must commit `.py` edits `--no-verify`) |
| `TEMPLATE-GAPS.md` | 02/08/2026 — the backend test suites never execute here        | blocks  | node N-014 (baseline edits are unverifiable here)  |

Two further entries **inform without blocking**, and are recorded so the reasoning is not
re-derived: 09/08/2026 — `static-analysis.sh` has never executed (this is why Q4 chose an own
script over Opengrep rules), and 02/08/2026 — Expo SDK tracking has no owner (N-011's flags ride
the pinned SDK 57 toolchain).

> **The register moved on 13/08/2026 and these four rows moved with it.** `TEMPLATE-GAPS.md` now
> carries **standing limitations only**; its dated entries were charted into
> `MAP-BASE-HEALTH.md`. Nothing above changes — the entries constrained this epic's work as
> recorded — but the path to follow-up is the map, not the register:
>
> | Entry as cited above                   | Now                                                  |
> | -------------------------------------- | ---------------------------------------------------- |
> | 03/08 — Python pre-commit hooks        | `MAP-BASE-HEALTH` N-001 → N-003                      |
> | 02/08 — backend test suites never run  | **stays in `TEMPLATE-GAPS.md`** as `SL-1` — accepted |
> | 09/08 — `static-analysis.sh` never ran | `MAP-BASE-HEALTH` N-007                              |
> | 02/08 — Expo SDK tracking has no owner | `MAP-BASE-HEALTH` N-022                              |

---

## Resolved decisions

| Node  | Decision                                                                                           | Type     | Settled    | Became                                                                                                                                                                  |
| ----- | -------------------------------------------------------------------------------------------------- | -------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| N-001 | What the template already enforces, clause by clause, and where                                    | research | 09/08/2026 | The verdict below — feeds N-004/006                                                                                                                                     |
| N-002 | Exclusion constraints and partial unique indexes on Django 6 / PG 18                               | research | 09/08/2026 | The verdict below — feeds N-004                                                                                                                                         |
| N-003 | Where `extra="forbid"` can be set once in Ninja / Pydantic v2, and what Ninja does today           | research | 09/08/2026 | The verdict below — feeds N-008                                                                                                                                         |
| N-004 | The enforcement-point register — what an invariant is, its shape, and where it lives               | grilling | 09/08/2026 | The verdict below — authored at N-006 (`how-to/src/INVARIANTS.md` + the class catalogue)                                                                                |
| N-005 | Programmer error vs user error — the taxonomy, how each is signalled, how each surfaces            | grilling | 09/08/2026 | The verdict below — authored at N-006; one `TEMPLATE-GAPS.md` entry (the error envelope)                                                                                |
| N-006 | The owning guide — its home, and which clauses it keeps versus routes out                          | grilling | 09/08/2026 | **`code/docs/NEGATIVE-SPACE.md`** + **`how-to/src/INVARIANTS.md`**, both shipped                                                                                        |
| N-007 | `raise` not `assert`, and the service guard-clause standard — where it lands                       | grilling | 09/08/2026 | `NEGATIVE-SPACE.md` Section _The guard clause_ + the ruff `S101` gate in `pyproject.toml`                                                                               |
| N-008 | The schema-strictness leg — how `extra="forbid"` propagates with no `apps/core`                    | grilling | 09/08/2026 | **`apps/core/` shipped** + `NINJA-CONVENTIONS.md` Section _Schema strictness_ + ruff `TID251`                                                                           |
| N-009 | The template/component leg — `string_if_invalid`, and the HTMX error partial                       | grilling | 11/08/2026 | `rendering/PITFALLS-AND-EXAMPLES.md` (two clauses) + `apps/core/middleware.py` + `EDGE-REQUIREMENTS.md` Section 13                                                      |
| N-011 | The TypeScript leg — flags, branded IDs, exhaustiveness, and the mobile error expression           | grilling | 11/08/2026 | **`code/docs/MOBILE-CODING-PRINCIPLES.md`** + `mobile/tsconfig.json` (4 flags) + `mobile/lib/invariant.ts`                                                              |
| N-012 | What the gate can decide, at which tier — the `[gate: fail]` / `[warn]` / `[judgement]` assignment | grilling | 11/08/2026 | 12 tiered clauses, marked inline in `NEGATIVE-SPACE.md`, `rendering/PITFALLS-AND-EXAMPLES.md`, `MOBILE-CODING-PRINCIPLES.md`                                            |
| N-013 | Write `audits/negative-space.sh`, its fixtures, its register row and its CI workflow               | task     | 11/08/2026 | **`code/src/scripts/audits/negative-space.sh`** + `fixtures/negative-space/` + `audit-negative-space.yml` + the `Key` column                                            |
| N-010 | The task and management-command leg — args as untrusted, on top of the on-commit doctrine          | grilling | 11/08/2026 | **`code/docs/MANAGEMENT-COMMANDS.md`** + `apps/core/management/base.py` + ruff `TID251` + two `TASK-AUTHORING.md` clauses                                               |
| N-014 | The baseline edits on both surfaces, each declaring its deletion class                             | task     | 11/08/2026 | `templates/500.html` + `templatetags/core.py` + `static/js/observability.js` + `mobile/lib/error-classes.ts` + `EDGE-REQUIREMENTS.md` Section 14                        |
| N-015 | Routing clauses on the agents and stack skills                                                     | task     | 11/08/2026 | Four `.claude/skills/stack-*/SKILL.md` clauses. The agent half never shipped and now cannot — the tier was deleted at v3.0.0. Remit reopened as `MAP-BASE-HEALTH` N-019 |
| N-016 | The attribution verification pass over whatever N-008 → N-015 derived                              | task     | 11/08/2026 | Two measured rows in `THIRD-PARTY-NOTICES.md` (0.0% each) + the corrected per-claim pointer in `README.md` Section _Influences_                                         |

**N-001 verdict — roughly half the brief is already law here, and the half that is not is
sharper than the brief states.** `grep -rin "negative space"` returns **zero** repo-wide, so the
_discipline_ is genuinely absent, but most of its Postgres and service-layer clauses are not.

**Already enforced, cite-don't-restate:** the whole Postgres leg — `NOT NULL`, `CHECK` on every
bounded or enum-like column, `UNIQUE`, explicit `on_delete`, mirrored in `Meta.constraints` — is a
`.claude/CLAUDE.md` Section 6 non-negotiable **and** doctrine in two guides, with the "application
validation is not a substitute" reasoning already written. Domain exceptions over `None`, frozen
dataclasses between layers, `Literal`/`Enum` over `str`, middleware purity and ordering, and the
IDOR/ownership rules are all covered. `TASK-AUTHORING.md` already forbids passing model instances
to a task and requires re-reading by primary key inside it.

**Genuinely absent:** `extra="forbid"` (**zero occurrences**) · the programmer-error /
user-error split (**zero occurrences**) · `raise`-not-`assert` (no rule; Python's `-O` strips
asserts) · **partial unique indexes and exclusion constraints** (`btree_gist`, `ExclusionConstraint`
— zero occurrences, and the repo has a soft-delete convention, which is precisely where partial
unique bites) · `string_if_invalid` · the HTMX "real error partial, never a silent empty swap"
rule · every TypeScript flag beyond `strict` (`code/src/mobile/tsconfig.json` is `strict: true`
plus `types: ["jest"]`).

**Three structural findings changed the frontier.**

1. **`code/src/django/apps/` is empty.** There is no `core` app, no shared Ninja `Schema` base,
   and **no `config/api.py`** — despite `api-design/NINJA-CONVENTIONS.md` documenting both as
   required. So `extra="forbid"` has nowhere to live as a single config line, and the honest
   propagation point is `new-django-app.sh`, which today emits `models/`, `migrations/`,
   `CONTEXT.md` and `CLAUDE.md` and **no `api.py` or `services/`**. This is what makes N-008 a
   real decision rather than a one-line edit.
2. **Required-prop validation is already achieved more cheaply than the brief proposes.**
   `accessibility/TESTING-AND-COMPONENTS.md` shows `get_context_data(self, *, icon: str, label:
str, ...)` — keyword-only, no default — so a missing prop is already a loud `TypeError` at the
   call site. An explicit `raise` on top would be the restatement the standing rule forbids. N-009
   inherits this as a constraint, not an open question.
3. **The brief's "don't restate at five layers" rule is in live tension with this repository's
   habit**, which deliberately restates rules across guides and agents. That tension is the epic's
   load-bearing decision and is why N-004 exists and blocks most of the map.

**N-002 verdict — both mechanisms are native Django, cost one migration operation, and add no
dependency.** `ExclusionConstraint` lives in `django.contrib.postgres.constraints` and goes in
`Meta.constraints` alongside `CheckConstraint` and `UniqueConstraint`, so it needs **no new
convention** — the existing "mirror in `Meta.constraints`" rule already covers it. It raises
`IntegrityError` on conflict and is also checked during model validation.

Two findings matter for the register (N-004):

- **`btree_gist` is a migration concern, not a settings one.** It installs via the
  `BtreeGistExtension()` **migration operation**, which means the repo's lock-safe migration
  doctrine governs it — and an extension that a project's first migration does not install makes
  every later exclusion constraint fail at apply time, not at review time.
- **`condition=Q(...)` is the answer to the soft-delete clash**, on both constraint types.
  `UniqueConstraint(fields=[...], condition=Q(deleted_at__isnull=True))` is the partial unique
  index, and it is the missing piece the repo's `SoftDeleteManager` / `PublishableModel`
  convention implies but never states: a plain `UNIQUE` on a soft-deleting table forbids
  re-creating a row whose predecessor was soft-deleted. That is a live defect the doctrine would
  otherwise ship, and it is the strongest single argument for the register.

**N-003 verdict — Django Ninja's documented default is to _silently ignore_ unknown fields.**
Not reject, not warn. So every request body in a generated project today accepts arbitrary extra
keys and discards them without a trace, which is the exact failure mode this epic exists to close.

The fix is `model_config = ConfigDict(extra="forbid")`, set per schema. Because Pydantic v2
inherits `model_config` through subclassing, **one project-local base class propagates it to every
schema that inherits from it** — which is precisely the "single config" deletion class in the
change budget: it survives nothing if a project deletes or bypasses the base. That is why N-008 is
a decision about propagation and not a one-line edit.

**Open remainder, deliberately not claimed as settled:** how `extra="forbid"` interacts with
`ModelSchema` (fields derived from the model) and with generated OpenAPI typed clients. The
documentation lookup does not answer it, and guessing would put a wrong constraint in the register.
N-008 verifies it before committing — recorded in fog of war.

**N-004 verdict — the register is two files, and it owns exactly one fact: _where_ an invariant is
enforced.** That fact is genuinely unowned today (N-001), which is what earns the register its place
without becoming a fourth restatement of the constraint doctrine.

- **What counts as an invariant:** data-shape rules **and write-path rules** — when a write may
  happen, not only what may be stored. So `TASK-AUTHORING.md`'s on-commit boundary and the RLS
  "never set a scope variable no policy reads" rule are in scope. Architectural bans stay in
  `data-structures/ANTI-PATTERNS.md`; admitting them would reopen the Keep list.
- **Two halves, on the shipped `PROVIDER-NEUTRALITY.md` / `PLATFORM-PROVIDERS.md` split.** The
  **class catalogue** is doctrine, ships filled in, and is identical in every project
  (`code/docs/` — its exact home is N-006). The **instance sheet** is the per-project answer sheet
  at **`how-to/src/INVARIANTS.md`**, empty at generation. `**/src/*.md` is exempt from the
  300-line limit, so it grows without ever being split — the deciding fact, because a register
  split at forty rows is a register that gets abandoned.
- **It owns the enforcement-point fact and routes everything else.** No row restates a rule that
  `DATABASE.md`, `SCHEMA-DESIGN.md`, `TASK-AUTHORING.md` or `rls/MIDDLEWARE-AND-NINJA.md` already
  carries; each row points at it.
- **Coverage is total, tiered by column** rather than split by table. Invariants Postgres cannot
  express are in, so they cannot end up enforced in four places and skipped in a fifth.

| Column                          | Holds                                                               |
| ------------------------------- | ------------------------------------------------------------------- |
| `Invariant` / `Invariant class` | the statement, one sentence                                         |
| `Mechanism`                     | `db-constraint` · `service-guard` · `both`                          |
| `Enforcement point`             | the constraint name, or the exact function — **one**, never a layer |
| `On breach`                     | what is raised and how it surfaces — **vocabulary set by N-005**    |
| `Stated in`                     | the guide that already owns the rule                                |

A `service-guard` row names one function; **a second call site is a finding**, not a judgement call.

- **Drift control puts it in the "doctrine + audit" deletion class.** `negative-space.sh` (N-013)
  derives the DB half — a `Meta.constraints` entry with no row fails, and a `db-constraint` row
  naming no constraint fails. `service-guard` rows fall to the same-change rule, on the
  `BUILD-OPERATE-SEAM.md` precedent. **Two honest limits, recorded rather than discovered later:**
  the check is grep-shaped, so it proves a name exists and never that it is the right one; and with
  `code/src/django/apps/` empty it is a **no-op at baseline**. Both are correct for this class —
  the audit re-derives from whatever files exist — but neither should be mistaken for proof.
- **The `mechanism` column is what N-012 reads.** Its `[gate: fail]` / `[warn]` / `[judgement]`
  tiers are derived from it, not re-decided.

**Deliberately not authored at N-004.** The `on breach` column takes its vocabulary from N-005, so
writing either half then meant writing it twice. Both were authored at N-006 —
`code/docs/NEGATIVE-SPACE.md` Section _The enforcement-point register_ and `how-to/src/INVARIANTS.md`.

**N-005 verdict — three classes, and the programmer-error one is deliberately uncatchable.** Half
of this already ships and is not restated: `logging/DJANGO-LOGGING.md` already rules that Ninja
validation errors are "user-facing, not bugs — log them at `INFO`, not `ERROR`". N-005 generalises
that one clause into a taxonomy and moves ownership; the clause itself does not change.

**Why three, not the brief's two.** With two classes every upstream timeout is filed as a defect in
our code, the error tracker fills with noise, and the "500 → tracker" rule becomes the thing someone
mutes — defeating the epic. The third class is what keeps the first one credible.

| Class                 | Type raised                                                                      | Raised where                                       |
| --------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------- |
| **programmer error**  | `InvariantViolation` — **a sibling of `ServiceError`, outside the tree**         | the single enforcement point named in the register |
| **user error**        | the existing `ServiceError` subclasses, unchanged                                | the service layer, as today                        |
| **environment error** | `DependencyUnavailable` (not `EnvironmentError` — a built-in alias of `OSError`) | the outbound adapter that owns the SDK             |

`InvariantViolation` sits **outside** `ServiceError` on purpose: inside it, one broad
`except ServiceError` turns a broken invariant into a friendly 400. A flag on a shared base would
have the same failure. This layers over the hierarchy without renumbering it, as the Keep list
requires.

| Class                 | Status              | Log level            | Error tracker             | Body                      |
| --------------------- | ------------------- | -------------------- | ------------------------- | ------------------------- |
| **programmer error**  | 500                 | `ERROR` + `exc_info` | per event                 | generic — never internals |
| **user error**        | 4xx (422 on schema) | `INFO`               | never                     | specific and actionable   |
| **environment error** | 503                 | `WARNING`            | aggregated, not per event | `Retry-After` where known |

- **The taxonomy is surface-agnostic; the expression is per-surface.** The same three classes hold
  on the API, rendered pages, HTMX, tasks and management commands. How each surface expresses them
  is N-009's and N-010's, not this node's.
- **`InvariantViolation` requires the register's key** — `InvariantViolation("order.total_matches_lines", …)`.
  This is what makes N-004's register and the runtime one artefact rather than two drifting lists,
  and it gives N-013 a second decidable check: every `service-guard` row's key appears in exactly
  one `raise`.
- **Correlation is a header, not a body key** — `X-Request-ID` on every response, on every surface,
  tagged onto the tracker event. A rendered 500 page has no JSON body, so a body key could not
  satisfy the surface-agnostic rule. N-009 must render that ID where a user can quote it.
- **Cited, never restated:** retry and backoff for environment errors are `TASK-AUTHORING.md`'s;
  the circuit-breaker rule is `architecture/SERVICE-AND-MIDDLEWARE.md`'s.

**N-006 verdict — a new top-level guide, named for the discipline, and it authored both backlogged
nodes.** `code/docs/NEGATIVE-SPACE.md` is a peer of `DATABASE.md`, not a sub-doc: N-015 routes
agents and stack skills to it **by name**, and a discipline routed to by name needs a stable
top-level path. (N-015 ultimately routed the **stack skills only**; the agent half never shipped
and the tier was deleted at v3.0.0. The argument is unaffected — a name routed to is still a name
routed to.) `coding-principles/` was ruled out by its own folder guardrail — it is declared
framework-neutral, and the taxonomy names Ninja status codes and `ServiceError`.

- **The two files never share a name**, mirroring `PROVIDER-NEUTRALITY.md` / `PLATFORM-PROVIDERS.md`:
  the rule is `code/docs/NEGATIVE-SPACE.md`, the answer sheet is `how-to/src/INVARIANTS.md`. A path
  tells you which one you are holding.
- **The new guide owns the error taxonomy.** `logging/DJANGO-LOGGING.md` keeps its Ninja handler
  wiring and gained a block naming the owner — a taxonomy that decides exception type, HTTP status
  and tracker behaviour is not a logging rule; logging is one of its four consequences.
- **Section 6 was extended, not appended to.** The existing "invariants are enforced in the database"
  non-negotiable now also carries the single-enforcement-point rule and the programmer-error
  consequence. `.claude/CLAUDE.md` had 8 lines of headroom and still does — the clause fit on the
  existing line. Naming the enforcement point is that rule finished, not a second one.
- **One file, no sub-folder.** N-004 had already made this guide something that routes rather than
  expounds; it lands at 154 code lines against a 270-line warn threshold, with ample room for N-007.
- **One clause the authoring produced that no node had asked for:** a constraint a user can
  legitimately **race** (two signups claiming one email) fires without anyone having written a bug.
  Such rows name their user-facing path explicitly; every other constraint firing is a programmer
  error. Without that carve-out the doctrine would have made every duplicate-key race a 500.

**Graduated outside the map:** the header choice sidestepped a contradiction this node found —
`PRACTICAL-RULES.md` mandates `{"error": {...}}` while the Ninja handlers in two other
guides return `{"detail": …}`. Filed as a `TEMPLATE-GAPS.md` entry (09/08/2026), deliberately
unresolved here: fixing it means editing three guides, which is the consolidation pass this epic
ruled out.

> **Now `MAP-BASE-HEALTH` N-015**, and re-measured 14/08/2026 — the split is **4 guides to 1**,
> not 3 to 2, and it is **doc-versus-doc, not doc-versus-code**. `{"error": {...}}` in
> `coding-principles/PRACTICAL-RULES.md`, `api-design/REST-CONVENTIONS.md`,
> `api-design/API-DOCS.md` and `api-design/NINJA-CONVENTIONS.md`; `{"detail": …}` only in
> `logging/DJANGO-LOGGING.md`. **No handler ships** — there is no `exception_handler` or
> `create_response` anywhere under `code/src/django/`, and no `.py` in the tree contains
> `"detail"`. Cheaper to settle than charted, and nothing has to be migrated.

**N-007 verdict — the gate already existed and had been switched off.** `pyproject.toml` selects
flake8-bandit (`"S"`) and then globally ignored `S101` with the comment _"assert statements (used in
tests)"_ — **redundant**, because `per-file-ignores` already exempted `*/tests/*`. So the entire
enforcement leg was one deleted line. Unlike N-013's grep-shaped script, this one is a real
analyser, and it was green at baseline (2 asserts repo-wide, both under `tests/e2e/`).

> **Re-measured 14/08/2026 at v3.2.1 — still green, but the count is now 3.** The third is
> N-013's own fixture, `audits/fixtures/negative-space/clean/tests/test_guard.py`, which
> postdates this verdict and sits under `tests/`, so it is exempt by the same per-file rule.
> The config is unchanged in substance since: the only edit to its block at v3.2.0 was the
> section-sign sweep rewriting a comment. `conftest.py` still carries its own exemption line
> beside `*/tests/*`, exactly as this verdict reasoned it must.

> **Corrected at N-014 (11/08/2026), by Sam's decision.** This verdict originally called `S101`
> "the strongest gate this epic has… the only Python gate that executes in the template
> repository", on the reasoning that `syntax-python.yml` carries no lockfile guard. The lockfile
> reasoning is right and the conclusion was wrong: every job in that workflow runs
> `uv sync --only-dev` first, and **uv refuses to parse the root `pyproject.toml` here at all**
> because its `name` is still the unrendered project-slug token — an invalid package name,
> rejected while reading the manifest, before a lockfile is ever considered. So **no Python job
> in this repository's CI has ever run.** The rule itself is sound and does execute in a
> generated project, where the name is rendered; what was untrue was where it is proved. The
> baseline claim "green at baseline" stands — it was measured with the host's directly-installed
> `ruff` binary, which parses no manifest. Register entry: `TEMPLATE-GAPS.md` (11/08/2026).

- **The brief's `-O` rationale is the weakest of the three reasons, and is recorded as such.**
  `PYTHONOPTIMIZE` appears nowhere in Docker, the scripts or CI. The load-bearing reason is that
  **`AssertionError` cannot carry the register key** — so an assertion reaches the tracker naming no
  invariant, and is indistinguishable from a failing test. `-O` is listed last, precisely because
  nothing fails the day someone adds it.
- **Absolute ban, no type-narrowing carve-out.** `if x is None: raise …` narrows identically for
  basedpyright and survives `-O`, so the carve-out would buy nothing and be indistinguishable from
  the banned use at review time. A `# noqa: S101` is a **finding**, not a workaround. A
  services-only ban was rejected as unenforceable: ruff cannot express "services" as a path while
  `apps/` is empty.
- **The guard is inline at the top of the one named method; a `_check_*()` helper is allowed, never
  required.** What makes N-013's second check decidable is the **key appearing in exactly one
  `raise`**, not the call shape — so mandating a helper per invariant would manufacture a shallow
  one-line module per register row. A guard never returns early, never queries to "confirm" a rule
  the database owns, never logs, and is never repeated at the endpoint or template.
- **Deletion class: doctrine + audit.** Ruff re-derives the finding from whatever `.py` files exist;
  removing the config means removing the linter, not deleting a skeleton file. `conftest.py` joins
  `*/tests/*` in the exemptions — it is test code and does not match that glob.
- **Ownership amendment — N-007 shipped its own baseline edit, and N-014 records rather than
  re-owns it.** N-014's blockers exist because `.py` edits cannot be verified here; this is a
  `pyproject.toml` edit verified by a gate that runs **on the host**, which is the correction
  above: the gate is real, its home is the directly-installed `ruff` binary rather than CI.
  Deferring it would have shipped N-007 in the "single config" class with no audit leg, which the
  change budget forbids.
- **Attribution shipped in the same change**, closing a live breach: N-006 wrote a whole guide with
  no `README.md` Section _Influences_ row, while `.claude/CLAUDE.md` Section 6 requires the row in the change
  that derives the rule. Credited to **TigerBeetle's `TIGER_STYLE.md` (Apache-2.0 — permissive,
  checked before deriving)**, naming ThePrimeagen's coinage and Hoare's prior art, and recording
  that **its assertion mechanism is deliberately not adopted**. N-016 shrinks to a verification pass.

**N-008 verdict — the propagation point had to be built, so the empty-`apps/` gap is closed rather
than routed around.** N-003's two open remainders were verified first, from primary sources:
`model_config` and `class Meta` **coexist on a `ModelSchema`** (Ninja's own camelCase example sets
both), and the generated-client risk is **latent, not live** — Pydantic emits
`additionalProperties: false` only for `extra="forbid"`, and this project generates no typed client.

- **The finding neither node predicted: a query-parameter schema must never forbid extras.**
  `ninja.parser.Parser.parse_querydict` iterates `request.GET` and hands Pydantic **every key in the
  query string**; `list_fields` only decides `getlist()` versus `[]`. A forbidding `Query(...)`
  container therefore 422s on `?utm_source=…`, `?gclid=…` and every tracking parameter on a real
  inbound link. So the rule binds **request bodies only**, and the three bases are separate
  (`Schema` · `OutSchema` · `QuerySchema`) rather than one strict base applied uniformly.
- **Propagation is a shadowing re-export, because its failure mode is a wrong import.** Pydantic
  inherits `model_config` through subclassing, so one base does the work; banning
  `from ninja import Schema` is what stops the bypass, and that is decidable by a linter rather than
  by review. **Ruff `TID251` (`flake8-tidy-imports.banned-api`)** carries it, verified firing against
  a probe file; `apps/core/schemas.py` is the single per-file exemption. **Corrected at N-014:**
  that verification was run with the host's `ruff` binary, not in CI — no Python job runs in this
  repository (see the note under N-007). The ban fires; the claim about where it is proved was
  wrong, and the distinction matters because a rule proved only on one developer's machine is one
  `pnpm`-style tolerance away from being unproved everywhere.
- **`apps/core/` now ships, thin and scoped.** `schemas.py` (this node) and `services/errors.py`
  (N-005's three classes over the documented `ServiceError` tree), plus `apps.py`, the doc pair, and
  the `INSTALLED_APPS` entry. **No models, no migrations.** `core` is skeleton like `config/`, so it
  does not come from `new-django-app.sh` — that script needs Docker and builds a _domain_ app.

  > **Amended 14/08/2026 — `errors.py` changed under this node, from outside it.** `93037ba`
  > lowercased all four `ServiceError` codes (`PERMISSION_DENIED` → `permission_denied`, and the
  > other three) on `MAP-BASE-HEALTH` N-015's ruling that **`error.code` is a wire value copied
  > onto the response, not a Python constant** — so it takes the response's spelling and now reads
  > like an invariant register key. Nothing this node decided is disturbed: the file, the class
  > tree, the `N818` exemption and the sibling placement of `InvariantViolation` are untouched.
  > Recorded because a verdict that names an artefact owns the claim that the artefact still says
  > what it said.

- **The name `core` is a house constant, deliberately not the registered `<%CORE_APP%>` token.** A
  Django app is a Python **package name**, which `TEMPLATE-TOKENS.md` Section _Position matters as much as
  shape_ puts in the never-tokenise row — the same defect class as the Rust crate name. `<%CORE_APP%>`
  is consequently registered-but-unused; filed for a decision rather than removed here.
- **`N818` yields to the taxonomy, not the reverse.** Ruff wants `*Error` suffixes;
  `InvariantViolation` and `DependencyUnavailable` are named as they are because neither is a
  `ServiceError` (and the latter dodges the `OSError` alias). Per-file exemption, reasoned in place.
- **Deletion class: doctrine + audit.** Ruff re-derives from whatever `.py` files exist.

**The stale-reference sweep, run alongside.** `apps.core` was documented in **14 places and shipped
in none**; the sweep also surfaced that the docs carried domain names from the codebase syntek-base
was extracted from. Removed or genericised: `SectorTagNotFoundError`, `LIVE_SECTOR_TAGS`,
`apps/portfolio`, `PORTFOLIO_ITEM_CREATED`, `apps.core.api.audit`; hardcoded `apps.audit` repointed
to the registered `<%AUDIT_APP%>` token in six files; every `from ninja import Schema` example in
four guides and the `stack-django` skill repointed to the new base; `schema.py` → `schemas.py`
standardised. Illustrative "portfolio page" content was **left alone** — a marketing site legitimately
has one; only stale _module paths_ were in scope.

**Graduated outside the map:** `ruff check .` is **red on `main` today** — 2 × `E501` and 2 × `S603`
in the `06-BRAND-GUIDE` and `07-COMPONENTS` build scripts, all pre-existing and untouched here. Not
fixed, because `S603` needs a decision about whether those scripts should shell out at all. Filed as
a `TEMPLATE-GAPS.md` entry (09/08/2026).

> **No longer true, re-measured 14/08/2026 at v3.2.1: `ruff check .` reports `All checks passed!`**
> The `S603` decision this verdict deferred was taken outside the map and went the way the
> deferral implied — the two PM asset builders keep shelling out to `xelatex`, with a reasoned
> per-file exemption in `pyproject.toml` rather than a rewrite; the `E501` pair is gone. **The
> entry behind this looks closable, and this map does not close it** — wayfinder claims, and
> `21-implementation-documentation` closes against shipped code. Route: the dated entries moved
> to `MAP-BASE-HEALTH.md` on 13/08/2026.

**N-009 verdict — `string_if_invalid` cannot be the enforcement, so the template surface ships an
honest gap rather than a false gate.** Django's own documentation settles it: a non-empty value
stops filters applying to invalid variables, so `{{ missing|default:"x" }}` renders the marker
instead of `"x"` — a behaviour change, not a diagnostic — and `{% if %}`, `{% for %}` and
`{% regroup %}` read an invalid variable as `None` and **never consult it at all**. It is therefore
a dev-and-test aid only, and the commonest case still fails silently in every environment.

- **The HTMX leg carries the real rule, and it splits by taxonomy class.** HTMX swaps on 2xx only,
  so a 500 today replaces _nothing_ — the indicator stops and the page is unchanged. User errors
  keep the shipped 200-re-render (Keep list, untouched); programmer (500) and environment (503)
  errors go to **one global `htmx:beforeSwap` listener, never a per-element handler**, because the
  view nobody expected to fail is the one that will. `htmx:sendError` needs the same region: a
  request that never lands attempts no swap, so nothing else fires.
- **Both clauses landed in `rendering/PITFALLS-AND-EXAMPLES.md`** (169 → 214 code lines), beside
  the CSRF _"the swap silently does nothing"_ sibling and the `item_edit` 200-re-render that **is**
  the user-error half. `FRONTEND-CODING-PRINCIPLES.md` gained one checklist row that routes.
- **`X-Request-ID` had to be built, not merely rendered.** N-005 assigned N-009 "render the ID
  where a user can quote it", but nothing generated it — `MIDDLEWARE` was Django defaults only and
  `templates/` is empty. `apps/core/middleware.py` ships: it **reads the edge's identifier and
  mints a UUID4 only when one is absent or malformed**, so a request keeps one identifier across
  the proxy access log and the tracker rather than two joined on timestamp. Inbound is untrusted —
  bounded alphabet, 200-character cap — because the value is echoed into a header and rendered on
  an error page.
- **The `MIDDLEWARE` guardrail was invoked, not broken.** `config/settings/CLAUDE.md` permits an
  addition _"until a feature genuinely requires more"_, and the taxonomy is that feature. The
  alternative was doctrine documented everywhere and shipped nowhere — the exact defect N-008's
  sweep had just finished cleaning up.
- **Ordering follows the Keep list.** `SERVICE-AND-MIDDLEWARE.md` puts request-ID injection third,
  after the security headers — so a response `SecurityMiddleware` short-circuits itself (the SSL
  redirect) carries no identifier. Accepted and recorded in place: it never reaches app code.
- **The edge half shipped in the same change**, as `BUILD-OPERATE-SEAM.md` requires —
  `EDGE-REQUIREMENTS.md` Section 13 plus its status-summary row, `seam-contract.sh` green. Section 2's dormant
  CSP nonce already derived from a `request_id`, so the two entries are now pinned to **one**
  identifier instead of two.
- **Deletion classes, declared.** `string_if_invalid` is **single config** and deliberately not a
  rule — a diagnostic earns no audit leg. The global HTMX handler is **single config and is a
  rule**, so it claims a check on `negative-space.sh`: a template carrying `hx-` implies the
  handler present in a static JS file. The middleware claims a second. **N-012 assigns both tiers.**
- **Shipped versus recorded, on the N-007 precedent.** Settings and middleware ship because ruff
  and basedpyright execute here. `500.html`, `503.html`, the error partial and `observability.js`
  are **N-014's**: there is no `base.html` to extend and no static JS tree, so building them would
  mean inventing the frontend baseline.

**Graduated outside the map:** the docs named `apps/core/middleware/request_log.py`, which a
shipped `middleware.py` cannot coexist with. Repointed in three places (`logging/DJANGO-LOGGING.md`,
`apps/core/CONTEXT.md`, `TEMPLATE-GAPS.md`): request logging becomes a second class in that module.

**N-011 verdict — the mobile surface is the one place this epic could ship a rule and prove it
end to end.** `tsc`, ESLint, Jest and the coverage floors all execute on the host in this
repository, and CI runs `mobile-typecheck` on every push with **no path filter**. So unlike every
Python leg, which N-014 blocks on suites that cannot run here, the mobile guard shipped
**verified**: types clean, lint clean, six tests green, `lib/invariant.ts` at 100%.

- **The node was scoped wider than its title, deliberately.** N-005 ruled the taxonomy
  surface-agnostic and the expression per-surface, and `NEGATIVE-SPACE.md`'s per-surface table had
  **two rows and no mobile one**. Settling only the type-system half would have left a visible
  hole in a table this epic had just built, so N-011 carried the error leg too — the same both-halves
  shape N-009 used for web.
- **Four flags, each banning a state:** `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`,
  `noImplicitReturns`, `noFallthroughCasesInSwitch`. **`strict` implies none of them and
  `expo/tsconfig.base` sets none** — the baseline was one flag deep and looked like four.
  All seven candidates were probed at once before adopting and came back green, which is recorded
  with its own caveat: the tracked tree is **92 lines**, so green proves the skeleton compiles and
  nothing else. `erasableSyntaxOnly`, `verbatimModuleSyntax` and
  `noPropertyAccessFromIndexSignature` were dropped as style and module rules rather than
  correctness ones.
- **`noUnusedLocals`/`noUnusedParameters` were declined on this epic's own rule.** ESLint's
  `no-unused-vars` already enforces it; adding them would put one rule under two enforcers, which
  is the register's second-call-site prohibition in a different medium.
- **Branded IDs declined, with the trigger written down.** There is no fetch layer, no parse
  boundary and no schema validation on this surface, so a brand could only be minted by
  `as UserId` on an unvalidated response — **a cast asserting a proof it does not have, which is
  the TypeScript shape of the `assert` N-007 banned**. They arrive with the mobile API client.
- **`unreachable(value: never, key)`, not `assertNever`.** It throws a keyed `InvariantViolation`
  whose class name matches the backend's exactly, so the register's `On breach` column reads the
  same on both surfaces — which is what N-005 meant by surface-agnostic. The name states the
  situation rather than the banned technique.
- **The error leg turns on an inversion worth naming: on a phone the environment error is the
  ordinary case.** A train tunnel is not a defect, so reporting every failed request is how a
  mobile tracker becomes noise and then gets muted — defeating the epic on this surface exactly as
  a two-class taxonomy would have on the server. A 5xx is likewise recorded as **the server's**
  programmer error, not the app's. One `ErrorBoundary` at the root `_layout.tsx`, never per screen,
  on N-009's precedent; `expo-router` ships the mechanism (`{ error, retry }`, verified in the
  installed package). The tracker is **declared, not wired** — the Expo pins are a matched set and
  adding to them is a versioned template release.
- **`lib/` had to be invented, and the coverage glob was the trap.** `app/` is routes-only —
  expo-router would publish a helper placed there as a navigable screen — so a non-route module had
  nowhere to live. `collectCoverageFrom` covers `app/` and `components/` only, so a module in a new
  directory would have shipped **invisible to the floor**: untested and reported green. `lib/**`
  joined the glob in the same change.
- **Deletion classes, and the asymmetry between them.** The flags are **single config** and claim
  the audit leg the standing constraint demands — `negative-space.sh` asserts the four are `true`,
  which is N-012's to tier and N-013's to write. The guard module needs none: a config flag can be
  removed silently, but a module that is imported **cannot be** — deleting it fails the compile at
  every call site.
- **Shipped versus recorded, on the N-007/N-009 precedent.** The flags and the guard ship because
  gates prove them. The root boundary, the error screen and the request-ID holder are **N-014's**:
  there is no token module, no brand-voice copy and no API client, so building them would mean
  inventing the mobile frontend baseline.
- **No attribution row is owed.** The flags are TypeScript's own features and the `never`-parameter
  exhaustiveness idiom is unattributable folklore — neither is doctrine derived from a named
  outside source, so Section 6's same-change rule does not fire. Recorded because the absence of a row is
  otherwise indistinguishable from having forgotten one.

**N-012 verdict — the tiers came out almost entirely `fail`, and looking for the exceptions is
what found that the audit as claimed would have failed this template on day one, twice.**
`__tests__/invariant.test.ts` constructs `InvariantViolation("order.total_matches_lines")` four
times and `unreachable(_, "order.status_is_known")` twice; `INVARIANTS.md` Section _A worked row, for
shape only_ names three enforcement points that do not exist. Both are correct code. A gate
designed without reading them would have shipped red and been loosened within a day — the
failure mode that turns a rule into a threshold nobody trusts.

**Twelve clauses: nine `[gate: fail]`, one `[gate: warn]`, two `[judgement]`.** The warn tier
nearly did not exist — `skill-conformance.sh` has precedent for a script with none — because warn
is reserved here for thresholds that fail correct work (`VISUAL-DESIGN.md` Section 6) and every claimed
check is a presence or correlation test. It earns one honest member: `worked-row-stale`, the
teaching example still sitting beside real rows.

| Tier               | Clauses                                                                                                                                                                                                     |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`[gate: fail]`** | `constraint-unregistered` · `constraint-absent` · `key-unraised` · `key-unregistered` · `key-duplicated` · `register-absent` · `htmx-handler-absent` · `request-id-middleware-absent` · `ts-flags-loosened` |
| **`[gate: warn]`** | `worked-row-stale`                                                                                                                                                                                          |
| **`[judgement]`**  | whether an enforcement point guards the **right** thing · whether an invariant is missing altogether                                                                                                        |

- **One script, decided against this folder's own splitting rule rather than around it.** The
  slop family splits by **input language** because a CI path filter is a file glob; this script
  reads Python, Markdown, HTML, JS and JSON. It stays one because that rule is about the **cost of
  firing** — `render-slop.sh` downloads a browser — and these clauses are `grep` and `awk`. The
  decisive half: `constraint-*` and `key-*` **correlate** two languages against each other, so
  they cannot be split at all without splitting the fact they check.
- **Scope is where the honesty is.** _Models only, never migrations_ — a migration history holds
  every constraint ever added, including dropped ones, so scanning it would force the register to
  carry dead rows to stay green. _Both surfaces_ for keys, because N-011 made the class name
  identical across them precisely so the `On breach` column reads the same; checking one half
  makes that decorative. _Tests exempt_ on both, mirroring ruff `S101`, because testing a guard is
  the coverage this doctrine wants. _`INVARIANTS.md` parsed section-aware_, worked row out of
  scope — which N-013 must build as a parser, not a line grep.
- **No silencing annotation, and the tier assignment is what makes that coherent.** N-007 already
  ruled a `# noqa: S101` a finding rather than a workaround; with no threshold tier, nothing here
  legitimately needs silencing. This closes the fog-of-war entry that asked for a `slop-allow`
  analogue: the answer is that this doctrine does not get one.
- **`--self-test` over `fixtures/negative-space/`, exit 2 without them.** Four of the claimed
  checks are no-ops in this repository and two pass, so the ordinary run would be green for the
  whole life of the rule having measured almost nothing — the exact defect `docs-length.sh` was
  written to close, and the reason `render-slop.sh` carries a self-test. This is the cheapest one
  in the folder: text fixtures and grep, no browser.
- **Markers land inline on the clause, across three guides** — `NEGATIVE-SPACE.md` (the register
  clauses, the middleware, both judgements), `rendering/PITFALLS-AND-EXAMPLES.md` (the HTMX
  listener), `MOBILE-CODING-PRINCIPLES.md` (the four flags). **`INVARIANTS.md` deliberately gets
  none**: it is the per-project answer sheet, and a tier written there would ship as doctrine
  inside the one file that is meant to be the project's own.
- **Two claimed rules are deliberately not re-enforced here.** The `assert` ban is ruff `S101`'s
  and the `ninja.Schema` import ban is ruff `TID251`'s. A second enforcer of one rule drifts, and
  the wrong copy is believed as readily as the right one — `skill-conformance.sh` declining to
  check length is the shipped precedent.
- **The HTMX clause keys on the listener, not on a path.** `PITFALLS-AND-EXAMPLES.md` already
  names `static/js/observability.js`, but N-014 has not built it; binding the gate to that path
  would make a legitimate reorganisation a CI failure. Recorded limit: it proves a listener
  exists, never that it handles 500 and 503 correctly.

**N-013 verdict — the register had no column for the key it was built around, and writing the
gate is what found it.** N-005 ruled that `InvariantViolation` carries the register key and
`NEGATIVE-SPACE.md` called it "the register row's identifier", but the five columns N-004 fixed
were settled _before_ keys existed and N-006 authored both halves without reconciling them. The
only place a key appeared was prose beneath the worked row — which N-012 had just put out of
scope. Three of nine fail clauses were unimplementable. **A sixth `Key` column now carries it**,
`—` on a pure `db-constraint` row whose constraint name is already its identifier.

- **The doctrine was checkable in principle and unbuildable in fact, and only the build could
  tell.** This is the second time this epic has found that: N-009 discovered `string_if_invalid`
  cannot police production, and both were found by trying to ship the thing rather than by
  reading harder. A clause nobody has implemented is a claim, not a rule.
- **Nine clauses, ~470 lines of `grep` and `awk`, no new dependency.** The register is parsed
  section-aware in `awk` — the worked-row section is skipped by heading, so the teaching example
  can keep naming enforcement points that do not exist. Constraint names are captured inside an
  8-line window opened by `*Constraint(` and closed by `Index(`, because an index is not an
  invariant and demanding a register row for one would be wrong.
- **The self-test is the whole reason the job is worth running here.** Four clauses are no-ops in
  this repository and two merely pass, so the ordinary run is green having measured almost
  nothing. `--self-test` runs every clause over `fixtures/negative-space/{broken,clean}`:
  `broken/` must trip all eight fail clauses, `clean/` must trip none. It exits **2** when the
  fixtures are missing rather than passing having proved nothing, and CI runs it **before** the
  scan.
- **Two things the fixtures prove that no assertion could.** `broken/` trips `constraint-absent`
  **once, not twice** — its worked-row section names a constraint nothing declares, so a
  line-based parser would report two; one is the proof the parser is section-aware. And `clean/`
  carries a `guard.test.ts` and a `tests/test_guard.py` that both raise unregistered keys, so if
  test exclusion ever breaks, the known-negative starts producing findings.
- **Watched failing on purpose, in both directions.** Loosening a flag in `clean/` and repairing
  the middleware in `broken/` each drive the self-test to exit 1. A gate nobody has seen fail is
  not a gate, and neither control is a hypothetical.
- **The middleware clause is bounded to the `MIDDLEWARE` list, not a file-wide grep.** `broken/`'s
  settings module names `RequestIDMiddleware` in its own docstring and the clause still fires — a
  mention is not the wiring.
- **`INVARIANTS.md` Section _What keeps this file true_ was rewritten rather than left.** It said the
  service half "cannot be checked at all" and that nothing under `audits/` checked the database
  half. Both were true when written and false the moment this shipped.

**N-010 verdict — the node's two halves turned out to be wildly asymmetric, and finding that
out is most of what the node did.** `TASK-AUTHORING.md` had **already written the task leg**:
"a task validates its arguments", "identity arrives as an argument, and the task treats it as
data to be verified, not as a caller", "the permission decision was made at enqueue time".
Management commands, meanwhile, were owned by **nothing** — `CommandError`, `BaseCommand`,
`add_arguments` and `argparse` return **zero occurrences repo-wide**, against five passing
mentions in five guides. The node's title implies one rule across two surfaces; there was one
surface with the rule already written and one with no guide at all.

- **A new guide, because "additive first" had nothing to attach to.** `code/docs/MANAGEMENT-COMMANDS.md`
  (144 code lines) is a peer of `TASK-AUTHORING.md` and **routes** to its Section _No request, no
  middleware_ rather than restating it. Extending `TASK-AUTHORING.md` instead was rejected on a
  fact that decides it: that guide is _declared, not wired_, while **`manage.py` runs today** —
  filing a live rule under a surface that does not exist. `BACKEND-CODING-PRINCIPLES.md` was
  rejected as a category error (a principles guide, not a surface guide) and on headroom.
- **The sharp half is not hostility, it is that argparse parses and parsing is not validation.**
  `type=int` proves a string was numeric and says nothing about whether the number is one this
  command may act on. Two consequences the guide states and nothing else did: a command-line
  identifier is **exactly as unverified as one from a URL** (IDOR does not become acceptable
  because the caller had a shell), and **blast radius is the argument nobody passes** — so
  destructive work takes `--dry-run`, bounds are declared rather than discovered, and the
  confirmation prompt is explicitly _not_ the safety, because `--noinput`, a pipe and a
  scheduler all skip it.
- **The taxonomy is carried by type; exactly one exit code carries meaning.** `EX_TEMPFAIL` (75,
  BSD `sysexits.h`) for the environment class, because it is the only distinction anything
  downstream acts on — a scheduler retries on it. That is the 503-versus-500 split in the
  vocabulary a shell has. A code per class was rejected: nothing reads it, so it goes wrong
  silently. **A traceback is the correct output for a programmer error**, not untidiness.
- **The finding on the task side: the user-error class is _empty_ there.** A task has nobody to
  tell, so an argument it cannot act on was put there by code — a programmer error, even where
  the identical value on an endpoint is a 422. The user error, if any, happened at **enqueue**
  time on the surface that had a user. A task that validates and returns quietly converts a bug
  into a silent no-op. Commands have all three classes, because the operator is a real user;
  that asymmetry is now the two per-surface rows this node added.

  > **The table has moved on since — amended 14/08/2026.** The two rows this node added are
  > intact and still say what they said, but the table N-009 built and N-010 completed is no
  > longer the five-row one either verdict describes. `93037ba` **repointed the JSON API row**
  > from `logging/DJANGO-LOGGING.md` to `api-design/AUTH-AND-ERRORS.md` Section _The error
  > envelope_ — the taxonomy guide had been routing the JSON API to a **logging** guide, which is
  > `MAP-BASE-HEALTH` N-015's finding for why the envelope fork went unseen — and **added a sixth
  > row** for the MCP tool surface, under a new principle worth keeping: _a shared service layer
  > is not a shared expression_, so a surface earns a row the moment its mechanism differs from
  > its neighbour's. Six rows now: rendered pages and HTMX · the JSON API · MCP tools ·
  > background tasks · management commands · the mobile app.

- **One genuinely absent task clause, and it is a deploy-shape bug rather than a value one.**
  A rolling deploy has both releases live, so a queued message carries the **previous**
  release's argument shape — a `TypeError` when the worker calls the function, before the body
  runs and where no idempotency check reaches it. A signature change is therefore a two-release
  change, which is the add-nullable-then-constrain migration rule applied to a message.
- **Deletion class: doctrine + audit, via the mechanism N-008 already built.** Ruff `TID251`
  bans `django.core.management.base.BaseCommand` **and** the `django.core.management`
  re-export — banning one path only would have left a one-word bypass — with a single per-file
  exemption. **Verified firing against a probe file** (both paths, including an aliased import;
  the exempt module clean) — on the host, with the directly-installed `ruff` binary.
  **Corrected at N-014:** this was recorded as the "second rule this epic has proved end to end
  after N-011, and the first on the Django surface". The probe result is real, but it is a
  **local** proof, and N-011 remains the **only** rule proved by a gate that actually runs in
  this repository's CI. That asymmetry has a cause worth keeping: uv rejects the unrendered
  project-slug token as an invalid package name and refuses to parse `pyproject.toml`, while pnpm
  skips name validation on a private package and parses the identical token in `package.json`
  without complaint — verified both ways on 11/08/2026. See the note under N-007. The ban is what
  makes it a rule: subclassing
  Django's base directly **still works**, and the only difference is that a broken invariant
  stops being distinguishable from a transient outage.
- **The recommendation that was wrong, corrected before it shipped: no register row.** The
  grilling pass claimed `ManagementCommand` would give `INVARIANTS.md` its first real row for
  "a non-request process closes stale connections". It would not — that is resource hygiene,
  not a data-shape or write-path rule, and the base class **makes it structural rather than
  guarding it**; a guard's only exit is a `raise`. Worse, a keyed `InvariantViolation` raised
  from shipped template code with an empty register would have tripped the audit's own
  `key-unregistered` clause. The base class therefore classifies and never raises a key.
- **It closed a staleness it created.** `PROCESS-MODEL.md` said all three non-request processes
  must call `close_old_connections` themselves; one of them now does not have to. The same
  change records **why** the base class does it at all: Django's cleanup lives in
  `run_from_argv`, which `call_command()` never reaches, so a command invoked from a task or a
  test would otherwise inherit its caller's connection state.
- **No attribution row is owed, recorded because an absent row is otherwise indistinguishable
  from a forgotten one.** `sysexits.h` supplies a number and a name, not doctrine — cited in
  `code/REFERENCES.md` beside Django's own command documentation, as this project cites OWASP
  and WCAG, rather than in `README.md` Section _Influences_.

**N-014 verdict — the node's own assignment was unbuildable as written, and the line that
replaced it is "ship what decides the class, defer what carries the voice".** Every artefact
N-009 and N-011 deferred here is a **user-facing string**, and `how-to/src/BRAND-VOICE.md` Section 2
forbids inventing one ("use the voice — do not invent it") while Section 3 is `TBD` until first-time
setup. So the node could not simply build its backlog. The split it settled on instead runs
through every surface: **what a failure _is_** can be decided before a project has a look or a
voice and therefore ships; **what the user _sees_** cannot, and does not.

- **Django renders `500.html` with an empty `Context` and no request** — its own documentation
  says the default 500 view "passes no variables to the `500.html` template and is rendered with
  an empty `Context` to lessen the chance of additional errors". Two consequences neither N-005
  nor N-009 could have known: a **context processor cannot reach the page**, so the mechanism
  that would obviously carry `X-Request-ID` is the one ruled out; and `{% extends %}` on a base
  that reads `request` renders **blanks rather than failing** — the silent failure this epic
  exists to close, on the one page a user reaches only after something has broken. The
  identifier therefore arrives through a **simple tag** (`apps/core/templatetags/core.py`),
  which reads the `ContextVar` rather than the context and so works in **every** rendering path.
  **Third time this epic has found a clause checkable in principle and unbuildable in fact**,
  after N-009's `string_if_invalid` and N-013's missing `Key` column — and, like both, found by
  trying to ship rather than by reading harder.
- **`503.html` was not built, and the Q4 answer was revised mid-grilling to say so.** Django
  defines no 503 handler and no template name; more decisively, the 503 that matters is returned
  when the application is **not answering at all**, which a Django template cannot serve. It is
  the one point in the taxonomy where the build side genuinely cannot own its own expression, so
  it ships as `EDGE-REQUIREMENTS.md` Section 14 — a static document the edge holds — with the app-side
  renderer triggered by the first outbound adapter. Nothing raises `DependencyUnavailable` yet.
- **The documented HTMX snippet was unsafe, and building it is what showed that.** It assigned
  `document.getElementById("error-region")` straight to the swap target, which is `null` on any
  page without the region — a swap into `null` fails silently, reproducing the exact defect the
  handler exists to close. The shipped handler creates the region. It also refuses to swap a
  **complete HTML document**: an application 5xx is a rendered partial, but an edge 502 or 504 is
  a whole page, and nesting one inside a `div` is not an error message. Neither the status nor
  the content type separates them; the doctype does.
- **The mobile leg shipped its classifier and not its screen** — `lib/error-classes.ts`, the
  exact parallel of N-011's `lib/invariant.ts`: a module, imported, deleting loudly, and provable
  by gates that run here. It carries the one rule most likely to be got wrong: **408, 502, 503
  and 504 are environment errors despite three being 5xx**, because each is the edge saying the
  process is not answering, so a rolling deploy's restart window is not a fleet of new defects.
  The default runs the other way and deliberately — **an unrecognised failure is a programmer
  error**, because defaulting to `environment` would silence exactly the failures nobody has
  considered yet. Verified: `tsc`, ESLint, 16 tests, `error-classes.ts` at 100%.
- **Deletion classes recorded, not re-owned**, per the change budget. `500.html` and
  `observability.js` are **single config** — a project may delete either, and the second already
  claims `htmx-handler-absent`. The `{% request_id %}` tag and `error-classes.ts` are the
  **imported-module** class N-011 named: deleting a tag library fails the template render, and
  deleting a module fails the compile at every call site. **No tenth clause was added to
  `negative-space.sh`** — N-012's tiering is settled, and a presence check on a template would
  cost more than it proves.
- **The one honest limit, written down rather than discovered later:** `htmx-handler-absent`
  keys on a template using `hx-`, and no template does. So the handler is **shipped and unproven
  in this repository**, and the first page to use HTMX is what turns the clause on. Recorded in
  `FRONTEND-CODING-PRINCIPLES.md` Section _What is not built yet_ so a green run is not mistaken for
  evidence.
- **No attribution row is owed.** Django's error-view behaviour, the HTMX event names and the
  `sysexits`-free status mapping are all the frameworks' own documented facts, not doctrine
  derived from a named outside source. Recorded because an absent row is otherwise
  indistinguishable from a forgotten one — the same note N-011 made.

**Graduated outside the map — and it undercut a claim this map made three times.** `uv` cannot
parse the root `pyproject.toml` in this repository at all: its `name` is still the unrendered
project-slug token, which is not a valid package name, so `uv sync --only-dev --dry-run` fails
while reading the manifest and never reaches dependency resolution. Every job in
`syntax-python.yml` runs that command first, so **the ruff and basedpyright jobs fail at the sync
step here** — despite that file's own header stating they "work in the base template and in a
generated project alike" and are "the only Python gate this repository actually enforces on
itself". N-007 recorded the same claim, and N-008 and N-010 described their `TID251` bans as
proved end to end. Those proofs are real but **local**: they came from the host's
directly-installed `ruff` binary, which parses no manifest. The rules are sound and do run in a
generated project.

**Sam chose to accept it and correct the record** (option (c) of three, 11/08/2026): the
`syntax-python.yml` header is rewritten, and N-007, N-008 and N-010 each carry an inline
correction naming the local proof and withdrawing the CI claim. Nothing about the rules changed —
only where they are known to hold. The register entry stays open as an accepted limitation rather
than being closed, because "no Python gate runs here" remains true and every future `.py` change
needs to know it.

**The generalisable half, and the reason this was worth chasing:** two manifests in this
repository carry the same unrendered token in their `name`, and **one tooling ecosystem tolerates
it while the other does not** — pnpm skips name validation on a private package and parsed
`package.json` without complaint; uv rejects it outright. So the mobile gates genuinely run here
and the Python gates never have. Both were verified on 11/08/2026 rather than inferred from each
other, which is the point: **one tokenised name is not evidence about another**, and N-011's
end-to-end claim survives only because it was checked separately.

**Graduated outside the map:** `code/src/CLAUDE.md` requires a `CONTEXT.md`/`CLAUDE.md` pair for
every new directory under `src/`, but `mobile/app/` and `mobile/__tests__/` have never had one and
`docs-pairing.sh` cannot see the breach — it iterates over existing `CONTEXT.md` files, so a
directory with **neither** file is invisible to it. `lib/` followed the tree's precedent rather
than the written rule; filed as a `TEMPLATE-GAPS.md` entry (11/08/2026) rather than settled here,
because scoping the rule to "a surface is paired at its root" is a governance decision this node
does not own.

**N-015 verdict — the node lost half its scope to a decision made outside it, and the surviving
half found that nothing had ever routed here at all.** The survey is the finding: **no file
under `.claude/agents/` or `.claude/skills/` cited a single one of this epic's artefacts** —
not `NEGATIVE-SPACE.md`, `MANAGEMENT-COMMANDS.md`, `MOBILE-CODING-PRINCIPLES.md`,
`INVARIANTS.md`, `negative-space.sh`, or any of the three shipped modules. The mechanism was
never missing: 40 of 56 agents carry a `## Context loading` list of `code/docs/` guides. This
epic simply had no rows in it, which is what makes the node's premise correct and its cost low.

- **Sam settled that the agent tier was being retired**, so the node shipped **skills only** and
  the agent half was **not attempted** rather than attempted and skipped. Routing 56 files due
  for deletion is work thrown away twice. **The call was vindicated at v3.0.0**, which deleted
  `.claude/agents/` in full — every file the node declined to edit is gone, and none of that
  work would have survived.
- **The loss survived the deletion, and has moved home twice.** Recorded first in
  `TEMPLATE-GAPS.md` (11/08/2026), it moved with that register's dated entries to
  `MAP-BASE-HEALTH.md` on 13/08/2026 and is now its **N-019**. The remit is the **verifier**
  tier — `code-reviewer`, `security`, `qa-tester`, `refactor`, `bugfix`, `review` (the six that
  exist post-migration; `debugger` folded into `bugfix`) — because a missing guard is _caught_
  there rather than written. **Premise re-verified 14/08/2026 and still true at that moment:**
  only the four `stack-*` skills cited `NEGATIVE-SPACE.md`, and not one of the six cited it,
  `INVARIANTS.md` or `MANAGEMENT-COMMANDS.md`.

  > **Closed the same day, by `MAP-BASE-HEALTH` N-019.** Five of the six now carry it —
  > `code-reviewer`, `qa-tester`, `security`, `refactor`, `bugfix`. **`review` was declined**, on
  > this node's own "three skills, not four" reasoning: it is a sequencer that dispatches the
  > other three and checks nothing itself. The remit landed wider than routing — N-012's two
  > `[judgement]` clauses, which no gate can decide, became a `code-reviewer` dimension. The
  > deletion class this node called **the weakest in the epic** is unchanged and now has a
  > measured reason: a gate asserting a guide is cited would ship red at **26 of 77**
  > guide→skill pairs, which is `MAP-BASE-HEALTH` N-025 rather than something N-019 could fix.

- **The hole was wider than the epic.** Seven of 31 top-level `code/docs/` guides are cited by
  no agent and no skill. Three were this epic's; `TASK-AUTHORING.md` and `PROCESS-MODEL.md` were
  adopted anyway, because `NEGATIVE-SPACE.md`'s own per-surface table routes to both and leaving
  them unreachable would have been a half-built door. `DISCOVERABILITY.md` and
  `OBJECT-STORAGE.md` were left: the first belongs to a concurrent stream, the second to nobody
  yet.
- **One door plus the surface's own, not one or the other.** Every routed skill gets
  `NEGATIVE-SPACE.md` — the taxonomy is what makes a surface clause legible — plus the guide for
  the surface it actually writes. Routing to the owner alone would have relied on a second hop
  that nobody takes from a twenty-item list.
- **`## Governing procedures` could not carry any of it.** That section is reserved for
  **workflows**, and its presence and placement are `[gate: fail]` in `skill-conformance.sh`
  (`SKILL-AUTHORING.md` Section 5). So each clause landed inline in the section whose work it governs,
  on that guide's own in-file-versus-sub-doc rule.
- **`INVARIANTS.md` is routed to three skills, not four.** The register's `client-guard`
  mechanism is mobile-only and its `service-guard` rows name service methods, so a template
  author never adds a row — a pointer in `stack-htmx-templates` would have been a no-op, which
  `SKILL-AUTHORING.md` Section 4 says to cut rather than ship.
- **The MCP surface has no clause to route to, and one was not invented.** `MCP-SERVER.md` and
  its four sub-docs carry **nothing** of the taxonomy, and the per-surface table has no MCP row.
  `stack-fastmcp` therefore routes as **inheriting the JSON API row** — true, because a tool is
  a peer adapter over the same service layer — rather than gaining a sixth row pointing at
  prose nobody has written. Filed as a gap; the surface is unwired and `fastmcp` is not a
  declared dependency, so nothing is broken while it waits.
- **Two defects found by editing rather than reading, which is now this epic's fourth and fifth.**
  `stack-fastmcp/SKILL.md` carried an **unresolved merge conflict committed at `3bd49e8`**,
  invisible because Prettier had reformatted the markers into valid Markdown — `<<<<<<<` as an <!-- conflict-markers: ignore -->
  indented list continuation, `>>>>>>>` as a `> > > > > > >` blockquote. No audit, CI workflow or <!-- conflict-markers: ignore -->
  hook anywhere looks for conflict markers. And `stack-django`'s worked service example raised a
  bare `ValueError`, which the API layer's `except ServiceError` does not catch — so the skill
  would have taught a 500 for an ordinary user mistake, three lines under a new pointer to the
  guide forbidding exactly that. Both repaired here.
- **Deletion class: doctrine only, and it is the weakest in the epic.** A skill is reference
  prose; nothing re-derives it and no gate asserts that a guide is cited. That is inherent to
  routing rather than a defect in this node — but it means these clauses decay silently, and the
  survey that found the hole is the only thing that would find it again.

**N-016 verdict — the eight nodes since N-007 derived nothing, and the one thing that needed
fixing was the bookkeeping behind N-007's own row.** The sweep's strongest single number:
across **all sixteen artefacts** N-008 → N-015 shipped — four guides, the register, the audit
script, five Python and TypeScript modules, a template, and the four skill clauses — there is
**not one external link**. Every outside reference this epic touches lives in `code/REFERENCES.md`
or `README.md`, which is where the rule says it should.

- **`TigerStyle` appeared in exactly one file in the repository: `README.md`.** The row itself is
  correct and shipped in the same change as the rule, as Section 6 requires. What was missing sat one
  layer down: `THIRD-PARTY-NOTICES.md` Section _Not listed here_ **measures** five-gram overlap for
  every derivation it declines to notice, and the epic's own source had no row — while
  `wshobson/agents` → `TASK-AUTHORING.md` had one, measured 09/08/2026, the same day N-007
  shipped. **Now measured: 0.0% against `NEGATIVE-SPACE.md` (2,493 five-grams) and 0.0% against
  `INVARIANTS.md` (912).** Apache-2.0 and zero overlap, so no notice is owed — but that is now a
  fact on the record rather than an assumption.
- **The README's per-claim pointer was wrong for that row, and structurally so.** Section _Platform and
  engineering craft_ promises citations in `research/AGENT-SKILL-ECOSYSTEM.md`; every other row
  has 3–12 entries there and TigerStyle has **zero**. The reason is not an omission: that note
  surveys the **agent-skill ecosystem**, and TigerBeetle's is an engineering style guide, so it
  was never in scope. The pointer now names the exception and sends the reader to the measurement
  instead. A promise a note cannot keep is worse than no promise.
- **`sysexits.h` upheld, on the reasoning N-010 gave.** It is cited in `code/REFERENCES.md` with
  the judgement written inline — it supplies a number and a name, not doctrine — which is how
  this project cites OWASP and WCAG. No `README.md` row is owed.
- **The share-alike rule held with nothing to repair.** `trailofbits/skills` (CC-BY-SA-4.0) is
  read-only doctrine here, and it appears **nowhere** in anything this epic shipped. The check is
  recorded because a clean result and an unrun check are indistinguishable afterwards.
- **One claim re-verified rather than trusted:** `THIRD-PARTY-NOTICES.md` asserts that every
  `audits/rules/*.yml` carries an explicit "no upstream rule text consulted" header. All five do.

---

## Frontier

**Empty.** All sixteen nodes are resolved; the route to the destination is fully charted.

**Types:** `research` (looked up, no human) · `tracer` (spike) · `grilling` (one
`/grill-with-docs` surface) · `task` (manual unblocking work)

**No node blocks a story**, because this epic cuts no stories — it produces documentation, one
audit script and routing, inside the template itself. It follows `MAP-DOCTRINE-UPGRADE`'s process
precedent: `01-feature`, `21-implementation-documentation`, `22-pr-and-review` and `23-release`
apply; the per-story specification machinery (`02`–`13`, `15`–`17`) and the build phases
(`18`–`20`) do not, because there is no schema, user flow, wireframe or user-facing surface to
specify.

**The doctrine core is complete, the gate runs, and every surface now expresses the taxonomy.**
N-004 → N-007 settled the register, the taxonomy, the owning guide and the guard clause; N-008 and
N-009 gave the Django surface its schema and error-expression legs; N-011 gave the mobile surface
both of its legs at once; N-012 turned the accumulated claims into twelve tiered clauses with
their scope rules; N-013 turned those into a script watched failing in both directions; N-010
closed the last two surfaces and, with them, the per-surface table this epic built at N-009.

N-015 routed the doctrine into the four stack skills, and lost its agent half to the decision to
retire the agent tier — a retirement since **completed at v3.0.0**, which deleted all 56 files.
The loss was recorded rather than absorbed, and now sits at `MAP-BASE-HEALTH` N-019. N-016 then
verified the attribution across everything the epic shipped and found sixteen artefacts carrying
no external link at all, one row of bookkeeping missing behind N-007, and a README pointer that
promised a note which could not cover it.

**The destination is reached.** For any invariant, a developer can name its single enforcement
point and its database constraint without guessing; a broken invariant reaches the tracker as a
500 rather than a friendly 4xx on every surface the project has; the template ships a baseline
that conforms to its own rule; and the skills a developer loads now route to all of it.

**Fog of war is now empty too, discharged 14/08/2026 — and not one entry became a node.** Six
were open at closing; two closed earlier the same day (a guide section that shipped, and length
pressure lifting), and the last four were discharged in a single pass: **two written into the
guides that own them** (`rls/MIDDLEWARE-AND-NINJA.md` → _Row locking_, and
`ANTI-PATTERNS.md`'s eleventh pattern), **one converted into a stated limit** in
`INVARIANTS.md`, and **two graduated to `MAP-BASE-HEALTH`** — the `api.py` / `new-django-app.sh`
scaffold half as its **`N-026`** (Batch E, _declared not built_, which it fits exactly), and the
tree-wide instructional-length condition as its **`N-027`**, deliberately **unbatched** because it
fits none of that map's five classes and a sixth asserted in passing would pre-empt its own open
question about whether the taxonomy ships. Both placed 14/08/2026; that map went 21 open to 23.

**The reason none of them was a node is worth keeping**, because it is the same reason three
times: each had already been decided by an existing ruling and was waiting on a **measurement**,
not on a judgement. N-004 had already named `ANTI-PATTERNS.md` as the home for architectural
bans; `mutmut.sh` had already been ruled out of CI; the length condition had already been
declared not this epic's. Reopening a shipped map to write two clauses would have cost more in
churn than it bought. **The two that graduated moved on liveness, not durability** — both maps
are gitignored alike, so nothing survives a fresh clone either way, but a closed map is never
read again and `MAP-BASE-HEALTH.md` has an open frontier.

**No attribution row is owed, recorded because an absent row is otherwise indistinguishable from
a forgotten one** — the same note N-011, N-014 and N-010 each made. PostgreSQL's row-security
evaluation order, Django's `select_for_update` transaction requirement and mutmut's own behaviour
are the projects' documented facts, not doctrine derived from a named outside source, so Section 6's
same-change rule does not fire. Gates green on discharge: `negative-space.sh` (now self-reporting
**12 fail, 1 warn** — the count N-013's verdict reads stale on), `docs-length.sh` (717 files, none
over), `doc-references.sh`, and the section-sign invariant at zero.

**Next — none.** The epic goes to `21-implementation-documentation`, then `22-pr-and-review`
and `23-release`, per the process precedent recorded above.

---

## Fog of war

- **~~The empty-`apps/` gap~~ — CLOSED at N-008.** `apps/core/` ships with `schemas.py` and `services/errors.py`; `config/api.py` and the per-app `api.py` remain unbuilt, and `new-django-app.sh` still emits neither (N-014). The original entry follows.
- **The empty-`apps/` gap, now with two dependants.** `NINJA-CONVENTIONS.md` requires a per-app
  `api.py` and a mounted `config/api.py`; neither exists and `new-django-app.sh` emits neither.
  N-005 has added a second dependant: `InvariantViolation` and `DependencyUnavailable` belong
  beside the `ServiceError` tree in `apps/core/services/errors.py`, which does not exist either —
  the same root cause as N-008's, not a new one. Still a pre-existing defect this epic did not
  create, and still likelier a `TEMPLATE-GAPS.md` entry than a node; but N-006 must decide whether
  the doctrine may name a module path that ships empty, and N-014 owns whatever is emitted.
  **N-014 closed its half by not needing it:** nothing it shipped is per-app — a template tag, a
  project-level template, a static file and a mobile module are all singletons — so the scaffold
  was never the propagation point for this leg, and `new-django-app.sh` is untouched. The
  `api.py` / `config/api.py` half stays open and belongs to whichever node or story first needs
  an endpoint.

  > **~~Open here~~ — GRADUATED 14/08/2026 as `N-026` on `MAP-BASE-HEALTH`, into its **Batch E**
  > (_declared, not built — a shipped document routes to something that does not exist_), which it
  > fits exactly. And half of it documented itself in the meantime.** Re-measured: `config/api.py` is still absent (`config/` holds
  > `asgi.py`, `urls.py`, `wsgi.py`, `settings/` and nothing else) and `new-django-app.sh` still
  > emits `models/`, `migrations/` and the two doc files — **no `api.py`, no `services/`**. What
  > changed is that `api-design/AUTH-AND-ERRORS.md` now **states the absence in the guide**:
  > _"`config/api.py` does not exist in the base template, so no handler ships."_ So the
  > documentation half closed itself at `93037ba`, outside this map, and what remains is the
  > scaffold half — which has **no owner and no trigger date**, which is exactly why it cannot
  > stay on a closed map. Moved on the same liveness reasoning as the entry above.

- **~~`select_for_update` inside `atomic`~~ — CLOSED 14/08/2026, and the interaction is sharper
  than the entry guessed.** Checked rather than assumed: `select_for_update` appears **once**
  repo-wide, in `BACKEND-CODING-PRINCIPLES.md`'s MFA example, with no RLS context anywhere near
  it. The real finding is not that the two doctrines conflict but that they compose **silently**:
  a `FOR UPDATE` can only lock rows the policy already makes visible, so a lock taken before the
  scope variable is set covers **zero rows** and returns `None` — no error, and a
  `TransactionManagementError` only when there is no transaction at all. "No row" then has two
  causes that look identical, and one of them is a missing scope variable. **Landed as
  `rls/MIDDLEWARE-AND-NINJA.md` → _Row locking_** (the RLS guide owns it, beside its existing
  `Standard queries` and `Raw queries` subsections — additive-first), with a four-line pointer
  from `BACKEND-CODING-PRINCIPLES.md`'s `transaction.atomic()` rule. **No register row:** there is
  no single enforcement point, so it is a coding rule rather than an invariant.
- **~~"No functions that accept either an ID or an instance."~~ — CLOSED 14/08/2026, and it was
  **not** already implied.** The entry's own hedge was checkable and checked: `ANTI-PATTERNS.md`
  carries ten patterns and **none** is about signatures — the nearest text in the repo is
  `TASK-AUTHORING.md`'s "pass the primary key and re-read", which is a different rule with a
  different reason (staleness across a queue, not an ambiguous parameter). **Landed as the
  eleventh pattern, _The ID-or-Instance Parameter_**, on N-004's own ruling that architectural
  bans live in that file. The argument written down is the one the entry did not have: the union's
  two paths differ in **query count** and in **failure mode**, so no caller can reason about
  either without reading the body, and the `isinstance` branch is not domain logic and never
  becomes any.
- **~~Whether mutation testing is the honest proof~~ — CLOSED 14/08/2026, converted from a worry
  into a stated limit.** The concern is real and survives intact: N-012's `--self-test` proves the
  **audit**, not the **constraints**, so the register can be fully green while every row it names
  is untested. What the lookup settled is that it is not a decision — `mutmut>=3.0` is already a
  declared dependency, `code/src/scripts/tests/mutmut.sh` already exists, and
  `code/src/scripts/tests/CONTEXT.md` already rules it **deliberately out of CI** as too slow.
  Nothing was left to choose; the gap was that `INVARIANTS.md` did not **say** it. It now does —
  a third paragraph in Section _What keeps this file true_, beside the naming limit N-013 wrote
  there, on that node's own "two honest limits, recorded rather than discovered later" precedent.
  **Deliberately not filed as a register entry:** in `syntek-base` the proof cannot be run at all —
  `mutmut.sh` targets `apps/`, which holds only `core/` with no models and no unit suite, and the
  script is Docker-gated. That is a **consequence of `TEMPLATE-GAPS.md` SL-1** (the backend suites
  never execute here), not a second limitation, and duplicating it would put the same fact in two
  registers. The clause in `INVARIANTS.md` is written per-project and carries none of this.
- **~~How a project records a deliberate exemption~~ — CLOSED at N-012.** There is no
  `slop-allow` analogue and there will not be one: with no threshold tier, nothing here
  legitimately needs silencing, and a comment suppressing a finding is itself a finding (the
  N-007 `# noqa: S101` precedent).
- **~~`extra="forbid"` versus `ModelSchema` and generated OpenAPI clients~~ — RESOLVED at N-008.**
  No conflict with `ModelSchema` (`model_config` and `Meta` coexist); the client risk is latent, as
  nothing generates a typed client today. Verified from Ninja's docs and source, not assumed.
- **`stack-django/SKILL.md` crossed the warn threshold at N-015** — 238 → **281/300**, against a
  270 warn. The seam, if it comes to that, is `SKILL-AUTHORING.md`'s own progressive-disclosure
  move: `## Coding standards` is four sub-sections and roughly half the file, so it discloses into
  a `SCREAMING-SNAKE-CASE.md` beside `SKILL.md` while the entry file keeps the section map.
  **Re-measured 14/08/2026 — it is no longer the longest instructional file, and it is the least
  urgent of four now over the warn:** `encryption/FIELD-ENCRYPTION.md` 291,
  `SEO-CHECKLIST.md` 289, `VISUAL-DESIGN.md` 287, this 281 (717 files checked, all under 300).
  This entry is therefore an **instance of a tree-wide condition, not a property of this file** —
  which is what would sharpen it into a node, and the node is not this epic's.

  > **~~Open here~~ — GRADUATED 14/08/2026 as `N-027` on `MAP-BASE-HEALTH`, unedited.** It landed
  > **unbatched** there: it fits none of that map's five defect classes, and asserting a sixth in
  > passing would pre-empt its own open fog-of-war question about whether that taxonomy ships.
  > Re-measured once
  > more on discharge and the condition **grew while the file sat still**: the approaching set is
  > now **five, not four** — `encryption/FIELD-ENCRYPTION.md` 291 · `SEO-CHECKLIST.md` 289 ·
  > `VISUAL-DESIGN.md` 287 · `stack-django/SKILL.md` 281 · **`code/src/scripts/audits/CONTEXT.md`
  > 270, newly over**. 717 files checked, all still under 300, gate green. That is the argument
  > for graduating rather than splitting: `stack-django` is **fourth of five** with 19 lines of
  > headroom, and splitting the fourth-worst file fixes nothing tree-wide. It moves because this
  > map is **closed** and that one has an open frontier — an entry parked on a shipped map is
  > never read again, which is this folder's own "an answer left only here dies with the map".

- **~~`TASK-AUTHORING.md` is three lines from its warn threshold~~ — CLOSED 14/08/2026.** N-010
  took it to 267/300 and splitting was declined here, the guide being on the Keep list. It no
  longer appears in `docs-length.sh`'s approaching set at all, so the pressure that made this an
  entry is gone; nothing was split to achieve it. The recorded seam — delivery-guarantee and
  broker material against the authoring rules — stands if it ever crosses again.
- **~~Whether the soft-delete partial unique is a defect to file now~~ — CLOSED, written rather
  than filed.** N-002 found that a plain `UNIQUE` on a soft-deleting table forbids re-creating a
  soft-deleted row, and that no guide stated it. It is now stated: `code/docs/NEGATIVE-SPACE.md`
  Section _The soft-delete trap_, with the `UniqueConstraint` + `condition=Q(deleted_at__isnull=True)`
  form worked through. Verified shipped 14/08/2026. No register entry was needed.

---

## Out of scope

| Ruled out                                                       | Why                                                                                                                        |
| --------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Rewriting the Postgres constraint doctrine                      | Already law in two guides and a Section 6 non-negotiable — Keep list                                                       |
| Re-deciding the `ServiceError` hierarchy                        | Exists and works; N-005 layers over it                                                                                     |
| A consolidation pass over guides that restate each other        | Q3 → option 2. Collides with "additive first" and would reopen four Keep-list guides                                       |
| An ADR                                                          | Fourteenth consecutive decline; architecture doctrine goes to `code/docs/`, per-project half to `how-to/src/`              |
| Design-by-contract libraries (`deal`, `icontract`, runtime DbC) | Adds a dependency to enforce what a `CHECK` constraint and a guard clause already do                                       |
| Opengrep rules as the gate                                      | `static-analysis.sh` has never executed (register, 09/08/2026) — a green job that scanned nothing is worse than no job     |
| Rust and desktop surfaces                                       | The brief names Django and React Native only; `stack-rust` already owns a never-panic FFI boundary that is this discipline |
| Checks in hot loops, and guarding what Pydantic already proves  | Stated in the brief and adopted verbatim as a bound on every node                                                          |

---

## Session log

| Date       | Node settled                  | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | Frontier redrawn                                           |
| ---------- | ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| 09/08/2026 | N-001, N-002, N-003           | Charted; all three research nodes fired and settled. Ninja silently ignores unknown fields today                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]                                                        |
| 09/08/2026 | N-004                         | Register settled: two halves on the `PLATFORM-PROVIDERS.md` split, five columns, owns the enforcement-point fact only, audit-derived DB half. Authoring waits on N-005's `on breach` vocabulary                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | [x]                                                        |
| 09/08/2026 | N-005                         | Three classes, not two. `InvariantViolation` sits outside the `ServiceError` tree and carries the register key; correlation via `X-Request-ID`. One `TEMPLATE-GAPS.md` entry filed (error envelope)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | [x]                                                        |
| 09/08/2026 | N-006                         | `code/docs/NEGATIVE-SPACE.md` + `how-to/src/INVARIANTS.md` shipped, with N-004 and N-005 authored into them; Section 6 extended at zero line cost; 7 indexes updated; length, pairing and token audits green                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | [x]                                                        |
| 09/08/2026 | N-008                         | `apps/core/` shipped (schemas + errors, no models), closing the empty-`apps/` gap. Query-param schemas found to be the one surface `extra="forbid"` breaks. Ruff `TID251` bans `ninja.Schema`. Stale-reference sweep run across 14 docs                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | [x]                                                        |
| 09/08/2026 | N-007                         | Guard clause shipped with a gate that already existed and was switched off — one `ignore` line deleted turns ruff `S101` on, green at baseline. Attribution row added in the same change (TigerStyle, Apache-2.0), shrinking N-016. Doctrine core complete                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | [x]                                                        |
| 11/08/2026 | N-009                         | `string_if_invalid` found structurally incapable of policing production, so it ships dev/test-only with the gap recorded. The real rule is the HTMX one — 2xx-only swaps mean a 500 shows nothing — split by taxonomy class. `X-Request-ID` had to be built: `apps/core/middleware.py` reads the edge's value and mints a fallback, with `EDGE-REQUIREMENTS.md` Section 13 in the same change                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | [x]                                                        |
| 11/08/2026 | N-011                         | Scoped to both legs, because the per-surface table had no mobile row. Four flags adopted (`strict` implies none of them); `noUnusedLocals` declined because ESLint owns it; branded IDs declined until there is a parse boundary to mint at. First rule this epic proved end to end — `tsc`, ESLint and Jest all run here. `lib/` invented, and joined the coverage glob that would otherwise have hidden it. Last blocking edge cleared                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | [x]                                                        |
| 11/08/2026 | N-012                         | Twelve clauses: nine fail, one warn, two judgement — the warn tier nearly did not exist. Found that the audit as claimed would have failed this template on day one, on the mobile guard's own tests and on `INVARIANTS.md`'s worked row, so test code is exempt and the register is parsed section-aware. One script, decided against the slop family's splitting rule rather than around it. No silencing annotation, closing a fog-of-war entry; `--self-test` fixtures, because four clauses are no-ops here                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [x]                                                        |
| 11/08/2026 | N-013                         | Nine clauses shipped as `audits/negative-space.sh` with a `broken`/`clean` fixture pair and a CI workflow that self-tests before it scans. Building it found the register had **no column for the key** three clauses read — a sixth `Key` column now carries it. Watched failing in both directions; `broken/` trips `constraint-absent` once rather than twice, which is the proof the register parser is section-aware                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | [x]                                                        |
| 11/08/2026 | N-010                         | The two halves were asymmetric: `TASK-AUTHORING.md` had already written the task leg, while commands were owned by nothing (`CommandError`, `BaseCommand`, `argparse` — zero repo-wide). A new guide, routing rather than restating; the taxonomy carried by type with one meaningful exit code (75, `EX_TEMPFAIL`); the user class found **empty** on tasks and full on commands. Enforced by reusing N-008's `TID251` mechanism, verified firing on both import paths — the epic's second end-to-end proof. The grilling pass's claimed register row was **withdrawn**: resource hygiene is not an invariant, and a key raised against an empty register would have tripped the audit's own `key-unregistered` clause                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | [x]                                                        |
| 11/08/2026 | N-014                         | Its own backlog turned out to be unbuildable: every deferred artefact is a user-facing string, and `BRAND-VOICE.md` Section 2 forbids inventing a voice. Settled instead on "ship what decides the class, defer what carries the voice", which held on both surfaces. Django renders `500.html` with an **empty `Context` and no request**, so a context processor cannot carry the identifier and `{% extends %}` renders blanks rather than failing — a simple tag reading the `ContextVar` is the only mechanism that works in every path. `503.html` **not** built: Django defines no handler, and the 503 that matters is served when Django is down, so it is the edge's (Section 14). The documented HTMX snippet was found unsafe in two ways, both fixed. Mobile shipped the classifier and not the screen — 16 tests, 100%. Separately: `uv` cannot parse this repository's `pyproject.toml`, so the ruff CI jobs three verdicts rest on **do not run here**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]                                                        |
| 11/08/2026 | N-015                         | The survey was the finding: **nothing under `.claude/` cited a single one of this epic's artefacts**, though 40 of 56 agents already carry a guide list — the mechanism was never missing, only the rows. Sam settled that the **agent tier is being retired**, so the node shipped skills only and the agent half was not attempted; the verifier remit is the recorded loss. Seven of 31 top-level guides turned out to be cited by nobody, so `TASK-AUTHORING.md` and `PROCESS-MODEL.md` were adopted — the per-surface table routes to both. `## Governing procedures` could not carry any of it (reserved for workflows, gate-checked), so clauses landed inline. `stack-fastmcp` routes as inheriting the API row rather than inventing a sixth. Two defects found by editing: a **merge conflict committed at `3bd49e8`**, hidden because Prettier reformatted the markers into valid Markdown, and a worked example raising a bare `ValueError` under a new pointer to the guide forbidding it                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | [x]                                                        |
| 11/08/2026 | N-016                         | Sweep clean where it counts: **all sixteen artefacts N-008 → N-015 shipped carry no external link**, so nothing was derived and nothing is owed. `sysexits.h` upheld on N-010's reasoning; the CC-BY-SA read-only rule held, with no trace of `trailofbits` anywhere in the epic. The one repair was behind **N-007's own row**: `TigerStyle` appeared in exactly one file in the repository, and `THIRD-PARTY-NOTICES.md` — which measures five-gram overlap for every derivation it declines to notice — had no row for the epic's own source. Now measured, **0.0% against both** `NEGATIVE-SPACE.md` and `INVARIANTS.md`. The README's per-claim pointer was wrong for that row and structurally so: it promises an **agent-skill ecosystem** survey, and TigerStyle is an engineering style guide. **Frontier empty**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | [x]                                                        |
| 14/08/2026 | _none — verification_         | **N-007 → N-011 re-verified against v3.2.1 + `93037ba`; nothing settled, four claims amended.** Every load-bearing claim holds, measured not assumed: `S101` ungated with `*/tests/*` and `conftest.py` exempted; `apps/core/` shipping the three bases with `QuerySchema` still permissive and `TID251` banning `ninja.Schema`; `string_if_invalid` dev/test-only, `RequestIDMiddleware` in `MIDDLEWARE` behind `SecurityMiddleware` with its rationale as a code comment, `EDGE-REQUIREMENTS.md` Sections 13 **and** 14 present; `ManagementCommand` with `EXIT_TEMPFAIL = 75` and `TID251` on **both** `BaseCommand` paths; all four TypeScript flags `true`, `lib/**` in the coverage glob, `unreachable(value: never, key)` intact, and `syntax-js-ts.yml` still carrying **no path filter** — with the workflow now stating why in its own header. `negative-space.sh` runs green. The four amendments: the assert baseline is 3 not 2 (N-013's fixture, exempt); `errors.py` codes lowercased from outside the map; `ruff check .` now **passes**, so N-008's red-on-main graduation is spent; the per-surface table gained a **sixth** row and repointed the JSON API one. **One adjacent drift the five nodes rest on:** the gate is now **twelve fail clauses, not nine** — three MCP clauses added at `93037ba` — so N-013's count and its "four of the nine are no-ops here" note read stale at seven of twelve. N-009's `htmx-handler-absent` and N-011's `ts-flags-loosened` legs are unchanged                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | n/a — frontier already empty                               |
| 14/08/2026 | _none — fog-of-war discharge_ | **All four remaining fog-of-war entries discharged in one pass, and none became a node** — each turned out to be waiting on a measurement rather than a judgement, because an existing ruling had already decided it. **`select_for_update` × RLS:** one occurrence repo-wide, and the interaction is not a conflict but a **silent composition** — a `FOR UPDATE` locks only rows the policy already makes visible, so a lock taken before the scope variable is set covers **zero rows** and returns `None` with no error. Written as `rls/MIDDLEWARE-AND-NINJA.md` → _Row locking_, plus a four-line pointer from `BACKEND-CODING-PRINCIPLES.md`; **no register row**, there being no single enforcement point. **ID-or-instance:** the entry's hedge was wrong — `ANTI-PATTERNS.md` carries **ten** patterns (the Keep list said nine) and **none** covers signatures, so it shipped as the eleventh, on N-004's own ruling that architectural bans live there. **Mutation testing:** nothing left to decide — `mutmut>=3.0` is declared, `mutmut.sh` exists, and CI exclusion was already ruled; the gap was that `INVARIANTS.md` never **said** the register can be green while every row is unexercised. Now a third paragraph there, written per-project; **not** filed as a register entry, because its unprovability _here_ is a consequence of SL-1 rather than a second limitation. **Two graduated to `MAP-BASE-HEALTH`, and placed the same session** — the `api.py` scaffold half as its **`N-026`** in **Batch E**, whose documentation half had meanwhile closed itself at `93037ba` (`AUTH-AND-ERRORS.md` now states the absence outright), leaving a scaffold question two separate nodes had deferred to "the first story that needs an endpoint" — **a trigger nobody owns**; and the instructional-length condition as its **`N-027`**, re-measured and **grown to five files** while `stack-django` sat still at fourth (`audits/CONTEXT.md` newly over at 270), landing **unbatched** because it fits none of that map's five defect classes and a sixth asserted in passing would pre-empt its own fog-of-war question about whether the taxonomy ships. Both moved for **liveness, not durability**: the maps are gitignored alike, but a closed map is never read again. `MAP-BASE-HEALTH` went 21 open to 23 | n/a — frontier already empty; **fog of war now empty too** |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — closes / blocks / unrelated
- [x] Every claimed entry names what will retire it; **neither register file edited here**
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] **Every node marked "blocking a story" is resolved** — none are; this epic cuts no stories
- [x] Every resolved node links to the artefact it became
- [x] Index row — **deliberately not added**, corrected 14/08/2026. This box was ticked against a
      row that was never written: `01-FEATURE/CONTEXT.md` still reads _"None charted yet"_. That
      is right, and the tick was the error — the file **ships**, so it may cite layering-system
      artefacts only, never a per-project instance. Same ruling as `MAP-BASE-HEALTH.md`

**This epic produces docs, one audit script and routing — it does not go through
`02-story-creation`.** Nodes are settled directly via `/wayfinder resolve`, each graduating to the
guide, script or config it becomes.
