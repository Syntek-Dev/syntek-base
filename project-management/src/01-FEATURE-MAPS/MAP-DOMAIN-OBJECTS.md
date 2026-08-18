# MAP-DOMAIN-OBJECTS — A dictionary is a data structure, not a type

**Charted**: 15/08/2026 · **Charted by**: Sam · **Workflow**: `01-feature`
**Status**: **Resolving** — charted and resolved in one session by explicit instruction
**Frontier open**: 0 · **Blocking open**: 0 · **Fog of war open**: 2

> **Template-development artefact.** This map charts work on `syntek-base` itself, not on a
> project generated from it. It is **committed here**, so it syncs across devices, and it is
> emptied out by `copier.yml` `_exclude` at generation — so it never reaches a generated
> project. Every claim below is written to stand on its own.

---

## Destination

**"Domain objects over dictionaries" becomes a named, gated standard across all five surfaces
this template can ship** — Python/Django, TypeScript/React Native, Rust, and the browser pair
(Alpine + HTMX). One owning guide states the principle, the enum test and the migration policy;
one sibling states the exceptions and the greppable escape hatch; four surface guides express it
in the language and libraries this project actually uses. A deterministic audit mirrors the
decidable half, and **the baseline stops shipping the anti-pattern it forbids** — the dictionaries
a generated project inherits are converted in the same change.

**Done looks like:** a reviewer can decide "domain object or dictionary?" from a written test
rather than taste; a dictionary in domain code without a `DICT-OK:` reason fails a script; and
the four `dict[str, dict[str, …]]` records in the shipped e2e suite are named types that every
generated project starts from.

**What this is not.** Not a rewrite of `data-structures/ANTI-PATTERNS.md`, which
`MAP-NEGATIVE-SPACE` put on its Keep list and which already carries eleven patterns. This epic
**cites and routes to it**; the new material is the half that file does not have — the exceptions
catalogue, the escape hatch, the boundary-parsing rule, and every surface except Python.

---

## Notes

| Field                    | Value                                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Cross-surface data modelling — `code/docs/data-structures/`                                                                                          |
| Skills to load           | `doc-writer`, `domain-modelling`, `codebase-design`, `stack-django`, `stack-react-native`, `stack-rust`, `stack-htmx-templates`                      |
| Standing preferences     | Chart-and-resolve in one session (Sam, 15/08/2026); forward-looking surfaces marked as such; override the two `rendering/` examples; gate the marker |
| Umbrella ADRs            | None — this is doctrine, not an architectural trade-off                                                                                              |
| Register entries triaged | 0 closes · 0 blocks · 0 unrelated — **both registers are empty**                                                                                     |

### The three collisions this epic lands on

Charted explicitly, because each is a place a naive pass would contradict shipped doctrine.

1. **`ANTI-PATTERNS.md` is on `MAP-NEGATIVE-SPACE`'s "Keep — do not touch" list.** Its eleven
   patterns already cover God Dictionary, Stringly Typed, Primitive Obsession, Nested Dicts,
   Implicit Schema, Boolean Blindness and Overloaded Status. **Route to it; never restate it.**
2. **`NEGATIVE-SPACE.md` Section _What counts as an invariant_ declares "no god dictionaries" and
   "no stringly-typed data" out of scope**, naming `ANTI-PATTERNS.md` as the owner. The new
   family must slot in beside that owner, not compete with it — `audits/doctrine-drift.sh`
   enforces one-rule-one-home.
3. **`MOBILE-CODING-PRINCIPLES.md` Section 3 declined branded ID types at baseline**, with a
   stated trigger (a parse boundary that mints them). The source brief asks for branded
   identifiers. **The existing decision wins**; the TypeScript guide records the trigger rather
   than reversing the call.

---

## Register claimed

`GAPS.md` and `DEFERRED.md` were both read at charting. **Both hold zero open entries** — nothing
to claim, nothing blocking. The triage is exhaustive by being empty.

| Register    | Entry             | Verdict | Retired by |
| ----------- | ----------------- | ------- | ---------- |
| GAPS.md     | _no open entries_ | —       | —          |
| DEFERRED.md | _no open rows_    | —       | —          |

---

## Resolved decisions

| Node  | Decision                                                           | Type     | Settled    | Became                                                  |
| ----- | ------------------------------------------------------------------ | -------- | ---------- | ------------------------------------------------------- |
| N-001 | Which of the five surfaces actually exist, and with what tooling   | research | 15/08/2026 | The audit in this map's _Surface census_                |
| N-002 | Where the family lands and how it splits under the 300-line cap    | grilling | 15/08/2026 | Six files in `code/docs/data-structures/`               |
| N-003 | Absent surfaces: omit or write forward-looking                     | grilling | 15/08/2026 | Forward-looking, marked in a standing banner            |
| N-004 | Does the standard override the shipped `rendering/` examples       | grilling | 15/08/2026 | Yes — both examples corrected in place                  |
| N-005 | Is the escape hatch gated or review-only                           | grilling | 15/08/2026 | Gated — `audits/dict-discipline.sh`                     |
| N-006 | Rust with no serde: scope to today, or write the wire/domain split | grilling | 15/08/2026 | Forward-looking, serde declared at the seam             |
| N-007 | TypeScript/React Native as a fifth surface                         | grilling | 15/08/2026 | `TYPES-TYPESCRIPT.md`, respecting the Section 3 decline |
| N-008 | Do the baseline's own dictionaries get converted                   | grilling | 15/08/2026 | Yes — they are what every project inherits              |

---

## Surface census (N-001)

| Surface        | Present         | Tooling that decides what an example may use                                             |
| -------------- | --------------- | ---------------------------------------------------------------------------------------- |
| **Python**     | Yes, near-empty | 3.14 · Django 6.x · basedpyright `standard` (**excludes `**/tests/**`**) · ruff `TID251` |
| **TypeScript** | Yes             | Expo · `strict` + 4 negative-space flags · `unreachable()` in `lib/invariant.ts`         |
| **Rust**       | Yes             | Edition 2024 · PyO3 0.29 · Slint · **serde is not a dependency** · clippy denies panics  |
| **Alpine**     | **No code**     | Declared in `pyproject.toml`, unwired. Zero `x-data` in `code/src/`                      |
| **HTMX**       | **Almost none** | `static/js/observability.js` only. **No template uses `hx-`**                            |

**The consequence, stated once:** three of the five surface guides describe code that does not
exist yet. Each carries a standing banner saying so. That is the honest form — the alternative is
prose that reads as description and is actually invention.

---

## The family (N-002)

Six files, because the 300-line cloc cap forces the split and the entry point stays a thin index.

| File                         | Owns                                                                                              |
| ---------------------------- | ------------------------------------------------------------------------------------------------- |
| `TYPES-OVER-DICTIONARIES.md` | The principle, the enum test, the boundary rule, the PR checklist, the migration policy, the why  |
| `TYPES-EXCEPTIONS.md`        | The seven legitimate dictionary uses, the three-part confinement policy, the `DICT-OK:` protocol  |
| `TYPES-PYTHON.md`            | Frozen dataclasses, `NewType`, `TypedDict` as transitional, `StrEnum`, exhaustive `match`         |
| `TYPES-TYPESCRIPT.md`        | Discriminated unions, `as const`, `unreachable()`, why branded IDs stay declined                  |
| `TYPES-RUST.md`              | Newtypes, enums with data per variant, the serde wire/domain seam and `TryFrom`                   |
| `TYPES-BROWSER.md`           | `Alpine.data` / `Alpine.store`, frozen constant objects, the HTMX view-model and shared constants |

---

## Frontier

**Empty.** Every node was settled in the 15/08/2026 session by explicit instruction. The work
each node graduated into is listed in _Resolved decisions_ above and shipped in the same change.

---

## Fog of war

In scope, not yet sharp enough to state as a decision.

- **`ServiceError.code` as a `StrEnum`.** The four codes are a closed set and would be a textbook
  conversion — but `MAP-BASE-HEALTH` N-015 settled their spelling four days ago and tied them to
  the invariant register key. Converting a just-settled cross-cutting surface in the same week is
  how a decision gets re-litigated. **Listed in the migration backlog instead**, which is the
  honest place for it.
- **Whether `dict-discipline.sh` should read Django template `{% %}` context.** A template
  receiving a bare `dict` is the HTMX half of the rule, and the audit cannot see it: the dict is
  built in Python and the template only names keys. Deciding this needs a template to exist.

---

## Out of scope

| Ruled out                                            | Why                                                                                                     |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Rewriting or extending `ANTI-PATTERNS.md`'s patterns | On `MAP-NEGATIVE-SPACE`'s Keep list; eleven patterns already cover the Python anti-pattern half         |
| Reversing the branded-ID decline                     | `MOBILE-CODING-PRINCIPLES.md` Section 3 settled it with a stated trigger; this epic records the trigger |
| A mass refactor of existing code                     | The standard binds new and modified code; existing offenders become a prioritised backlog               |
| Converting `ServiceError.code` to a `StrEnum`        | Settled by `MAP-BASE-HEALTH` N-015 on 14/08/2026 — backlogged, not reopened                             |
| A `desktop` (Slint) surface guide                    | Slint's `.slint` model is its own type system; `desktop/UI-AND-STATE.md` owns it                        |

---

## Session log

| Date       | Node settled  | Outcome                                                                    | Frontier redrawn |
| ---------- | ------------- | -------------------------------------------------------------------------- | ---------------- |
| 15/08/2026 | N-001 → N-008 | Charted and resolved in one sitting; six guides, one audit, baseline fixed | [x]              |

---

## Gate to stories

- [x] Destination and out-of-scope bounds confirmed
- [x] Every open `GAPS.md` / `DEFERRED.md` entry triaged — both registers empty
- [x] Neither register file edited here
- [x] Every knowable decision is a node or in fog of war
- [x] Every node typed and blocker-wired
- [x] Every node marked "blocking a story" is resolved
- [x] Every resolved node links to the artefact it became
- [x] Index row in `CONTEXT.md` current

**This map produces no stories.** It is template doctrine work, shipped directly — the artefacts
are guides, an audit and a baseline correction, not a feature a user story would describe.
