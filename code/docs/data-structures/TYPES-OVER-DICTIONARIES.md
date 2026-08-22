---
type: guide
skills: [database, stack-django, code-reviewer, refactor]
model: opus
---

# Types Over Dictionaries — The Standard

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the cross-surface standard: the principle, the enum test, the boundary
rule, and what a reviewer checks

> **Forward-looking.** The web surface ships no domain code at baseline — `apps/core` holds the
> Ninja schema bases, the middleware, the error tree and the management-command base, and there
> are no models, no migrations and no endpoints. This guide is the standard the first one is
> built to, not a description of code that exists.

---

## The principle

> A dictionary is a data structure, not a type. When a set of keys is known at design time and
> carries meaning in the domain, it is a named type with named fields. Dictionaries are for keys
> that are genuinely data — unknown, dynamic, or supplied by the outside world.

Three goals, in the order they pay off:

1. **Invalid states are unrepresentable.** A field that must exist cannot be absent; a field that
   must be one of four values cannot be a fifth.
2. **Changing a field's shape is a compile-time or type-check error**, not a runtime `KeyError` or
   an `undefined` property read three layers away from the change.
3. **A reader learns the domain by reading the type definitions.** The types are the map; the
   functions are the routes over it.

**This is mandatory for all new and modified code.** It is strict by default and explicitly not
absolutist: there is a documented escape hatch, the marker
`DICT-OK: <reason> — confined to <boundary>`, and a short list of cases where a dictionary is the
right answer. Both live in [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md) and are gated by
`code/src/scripts/audits/dict-discipline.sh`. Anything without the marker, outside the listed
exceptions, is a review blocker.

### What "a named type" means per surface

The principle is one rule; the spelling is four. Nothing here is exotic — each surface already has
the construct, and the standard is only that it gets used.

| Surface                    | The named type is                                                                                                 |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Python / Django            | a `@dataclass`, a Ninja `Schema`, a `TextChoices` enum, a model, or a `TypedDict` for a genuine key-value payload |
| TypeScript _(mobile-only)_ | an `interface`, a `type` alias, or a discriminated union over a literal `kind`                                    |
| Rust _(rust-only)_         | a `struct`, an `enum` carrying data per variant, or a newtype over a primitive                                    |
| Browser                    | the object the view hands the template — attributes and methods, not a bag the template indexes                   |

---

## Parse at the boundary, pass objects inward

The single most load-bearing rule here. Incoming JSON, form data, query strings, database rows
and third-party payloads are parsed into domain objects **once, at the edge**. **No dictionary
survives past the boundary layer.**

A dictionary that leaks inward does not stay one thing. Every function it reaches acquires an
implicit contract with a key it never declared, and the shape becomes a fact you can only learn by
reading every caller — which is the point at which the type checker has stopped helping.

| Surface                    | The boundary                                                                                                                                                   | What crosses it inward                                     |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| Python / Django            | a Ninja `Schema` in `apps/<app>/schemas.py` subclassing `apps.core.schemas.Schema` (which sets `extra="forbid"`), a Django `Form`, or a `from_row` classmethod | a model instance, a dataclass, or a value object           |
| TypeScript _(mobile-only)_ | the API client module, at the `fetch` call site                                                                                                                | a declared response type, narrowed before it is returned   |
| Rust _(rust-only)_         | a `#[derive(Deserialize)]` wire struct, converted with `TryFrom`                                                                                               | the domain struct or enum the rest of the crate works with |
| Browser                    | the Django view builds the view-model; the template renders it                                                                                                 | attributes and methods on that view-model                  |

```python
from apps.core.schemas import Schema  # never `from ninja import Schema` — ruff TID251


# Boundary: the payload becomes a type here, and never travels as a dict.
class InviteIn(Schema):
    email: str
    role: TeamRole


def invite_member(team: Team, payload: InviteIn, *, actor: User) -> Invitation: ...
```

**A parse failure at a trust boundary is a user error**, not a broken invariant: it raises from the
`ServiceError` tree and answers 4xx (422 on a schema failure). Reserve `InvariantViolation` for a
domain object this codebase built wrong internally, which is a programmer error and a 500. The
three classes and their expressions are [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)'s.

The corollary: **the boundary is the only place a `dict` is unpacked.** A service method that takes
`**kwargs` and reaches into it, or a template tag that indexes a context dictionary by a key
assembled at runtime, has moved the boundary inward without saying so.

### The database row is a payload too

The row is the boundary everybody forgets, because it feels like ours. It is not: `.values()`,
`.values_list(flat=False)`, a `RawQuerySet`, and a cursor's `fetchall()` all hand back tuples and
dictionaries whose keys are column names, not domain names. Passing one inward couples every
function it reaches to the current schema — so a column rename, the cheapest migration there is,
becomes a `KeyError` in a code path no migration test covers.

Materialise the model, or convert once through a `from_row` classmethod that names the mapping in
a single place. `.values()` is legitimate for a projection consumed immediately and locally — an
aggregate fed straight into a template, a set of primary keys — which is the confinement policy in
[`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md), not an exemption from it.

### Parse once, not defensively everywhere

The alternative to parsing at the edge is not "no parsing" — it is parsing **repeatedly and
partially**, a `.get("email")` here and an `if "role" in payload` there. That is worse than either
option on its own: the checks disagree over time, the strictest one is whichever function happened
to be written last, and the value that fails all of them still travels.

Parse once and the shape is a fact from that line onward. Every downstream guard clause about
presence, type or membership disappears, because the type already carries the answer — which is
why the correct fix for a defensive `if key in data` deep in a service is almost never to add a
better check there.

```typescript
// Boundary: the response becomes a declared type here. Nothing downstream sees the payload.
export async function fetchTeam(id: string): Promise<Team> {
  const raw: unknown = await (await fetch(`/api/teams/${id}`)).json();
  return parseTeam(raw); // throws on a shape the API did not promise
}
```

---

## The enum test

> Use an enum when all three hold — the set of values is closed, it is known at design time, and
> behaviour branches on it.

Miss any one and an enum is the wrong tool. All three, and a bare string is a defect.

| Trigger                | Concrete example                                                            |
| ---------------------- | --------------------------------------------------------------------------- |
| Status / state         | `BookingStatus.PENDING` → `CONFIRMED` → `CHECKED_IN` → `CANCELLED`          |
| Kind / type / category | `DocumentKind.INVOICE` vs `RECEIPT` vs `CONTRACT` — different render paths  |
| Mode                   | `ExportMode.SUMMARY` vs `FULL` — decides which columns the formatter emits  |
| Role / permission      | `TeamRole.OWNER` vs `ADMIN` vs `MEMBER` — the Policy class branches on it   |
| Unit                   | `Currency.GBP`, `Duration.MINUTES` — the value is meaningless without it    |
| Sort / filter option   | `OrderSort.NEWEST` vs `PRICE_ASC` — a closed set the query builder switches |
| Error category         | the taxonomy itself: user, programmer, environment                          |

**Counter-cases — values that come from data belong in data, not in an enum:**

| Counter-case                                           | Why it is data                                                          |
| ------------------------------------------------------ | ----------------------------------------------------------------------- |
| User-defined tags                                      | The set is open and grows without a deploy — a `Tag` table, not an enum |
| A DB-driven lookup table that changes without a deploy | Editing a row must not require a release; an enum makes it require one  |
| A third party's vocabulary                             | They own it and will extend it — model it as a stored string plus a map |

The last one is where the test earns its keep. A provider's `event_type` looks closed until they
ship a new one on a Tuesday. Store what they sent, map the values you handle onto **your** enum,
and route the rest to one explicit "unhandled" path.

### When the test half-holds

Two of three is the common case, and each pair has its own answer. Reaching for an enum anyway is
how a codebase ends up shipping a release to add a label.

| What holds                                      | What is missing       | The answer                                                                      |
| ----------------------------------------------- | --------------------- | ------------------------------------------------------------------------------- |
| Closed and known, but nothing branches on it    | branching behaviour   | A named constant or a lookup — an enum here is ceremony, not safety             |
| Branching behaviour, but the set is open        | closure               | A registry or strategy keyed by a stored value; the branch is data, not a match |
| Closed and branching, but only known at runtime | design-time knowledge | A DB-backed table plus a small handled subset your code maps onto               |

### Adding a variant safely

**Exhaustive matching is the whole point.** It is what turns adding a variant from a hunt through
the codebase into a compile error at every site that must change — and leaves the sites that need
no change silently correct. A `default:` or a catch-all `else` that quietly does something
reasonable throws that away; it converts a mechanical, checkable edit back into a judgement call
nobody knows they are making.

The mechanism differs per surface — `match` and the type checker in Python, `unreachable(value,
key)` in TypeScript ([`../../src/mobile/lib/invariant.ts`](../../src/mobile/lib/invariant.ts)),
a `match` with no `_` arm in Rust. Route to the four surface guides in the next section for the
exact spelling and the lint that backs it.

### Persisting an enum

Persist a **stable string** or an **explicit integer code**. Never the ordinal, never the
declaration order — both mean reordering members silently rewrites the meaning of every stored row,
and nothing fails at the moment the damage is done.

```python
# Bad — the stored value is positional, so alphabetising the members corrupts history.
status = models.IntegerField()  # 0 = pending, 1 = confirmed, ...

# Good — the wire value is written down and independent of order.
status = models.CharField(max_length=20, choices=BookingStatus.choices)
```

The database column takes a `CHECK` constraint **as well as** the application-level `choices`.
Application validation is not a substitute: a management command or a raw `UPDATE` bypasses it
entirely. Constraint rules: [`../DATABASE.md`](../DATABASE.md). Column and index design:
[`SCHEMA-DESIGN.md`](SCHEMA-DESIGN.md).

---

## Where each surface expresses this

| Guide                                        | Covers                                                                                  |
| -------------------------------------------- | --------------------------------------------------------------------------------------- |
| [`TYPES-PYTHON.md`](TYPES-PYTHON.md)         | Dataclasses, `TypedDict`, Ninja `Schema`, `TextChoices`, `match` under basedpyright     |
| [`TYPES-TYPESCRIPT.md`](TYPES-TYPESCRIPT.md) | **Mobile-only.** Discriminated unions, `as const`, exhaustiveness via `unreachable()`   |
| [`TYPES-RUST.md`](TYPES-RUST.md)             | **Rust-only.** Enums with data, `TryFrom` at the wire boundary, newtypes, clippy's arms |
| [`TYPES-BROWSER.md`](TYPES-BROWSER.md)       | The view-model the template renders, and the shape HTMX and Alpine each hand back       |
| [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md) | When a dictionary **is** right, the confinement policy, and the `DICT-OK:` protocol     |

**Forward-looking surfaces.** Rust carries no `serde` dependency at baseline, so the deserialise
boundary described there is a standard rather than a description. Alpine ships no code at all, and
HTMX only `static/js/observability.js`, so the browser guide is likewise the shape the first
interactive component is built to. Both live surfaces are already type-checked, at different
heights — basedpyright in `standard` mode over `code/src/django`, TypeScript at `strict` plus
four flags beyond it — and `code/src/scripts/syntax/check.sh` runs the pair.

---

## What this guide does not own

| Concern                                               | Owner                                                                        |
| ----------------------------------------------------- | ---------------------------------------------------------------------------- |
| The named anti-patterns and their refactors           | [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md)                                       |
| Value objects, aggregates, ubiquitous language        | [`DOMAIN-MODELLING.md`](DOMAIN-MODELLING.md)                                 |
| When a dict **is** right, and the `DICT-OK:` protocol | [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)                                 |
| Database constraints, lock-safe migration of one      | [`../DATABASE.md`](../DATABASE.md) · [`SCHEMA-DESIGN.md`](SCHEMA-DESIGN.md)  |
| Invariant enforcement points and the error taxonomy   | [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)                               |
| Choosing between list, set, dict and deque on merit   | [`FUNDAMENTALS.md`](FUNDAMENTALS.md)                                         |
| Branded (nominal) ID types — **declined at baseline** | [`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) Section 3 |

That last row is a live decision, not an omission: brands arrive **in the same change as the
mobile API client**, minted at the one point that parses a response. Do not mandate them before
that boundary exists — a brand minted by a cast asserts a proof nothing performed.

---

## Migrating existing code

**The standard binds all new and modified code. There is no mass refactor.** A file is brought up
to it when a story already has reason to open it; converting untouched code buys a diff nobody can
review against a behaviour nobody changed.

What the audit found, ranked. A row is claimed by whatever story next touches its file.

| Priority | Location                                       | What                                                                | Why it ranks here                                                                                                                                                                                                                                 |
| -------- | ---------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1        | `code/src/django/tests/e2e/a11y_config.py`     | `SCAN_PROJECTS: dict[str, dict[str, object]]` — a four-row matrix   | `dict[str, object]` forces a cast at every read, and the **same module already models `Suppression` as a `TypedDict`** — one file, two answers. **Fixed in this change**                                                                          |
| 2        | `code/src/django/tests/e2e/conftest.py`        | `VIEWPORTS: dict[str, dict[str, int]]` — the viewport matrix        | The same defect one file over, and the two matrices overlap; a shared `Viewport` type removes the duplication as a side-effect. **Fixed in this change**                                                                                          |
| 3        | `code/src/django/tests/e2e/test_e2e_a11y.py`   | `page.__dict__["_scan_project"]` — a stringly-keyed stash on `Page` | A key with no declaration anywhere, typo-fatal at runtime only. Ranked below 1 and 2 because the fix was a fixture change, not a type addition. **Fixed in this change** — the fixture yields a `ScannedPage` record                              |
| 4        | `code/src/django/apps/core/services/errors.py` | `ServiceError.code: str` — a closed set carried as bare strings     | **Deferred.** The field's spelling was settled on 14/08/2026 with the one JSON error envelope ([`../api-design/AUTH-AND-ERRORS.md`](../api-design/AUTH-AND-ERRORS.md)), and a just-settled cross-cutting surface is not reopened in the same week |

### How a row is discharged

A row leaves this table when the type exists and the dictionary is gone, not when a marker is
added to it. Three steps, in order: define the type beside the data it replaces; convert every
read in the same change, so there is never a period where both spellings are live; delete the
dictionary. If the conversion cannot be finished in one change, the row stays open and the
existing code stays as it is — a half-migrated structure is strictly worse than an unmigrated one,
because a reader now has to know which half they are in.

**Two things the audit deliberately left alone.** `AXE_OPTIONS` and the axe violation payloads in
`test_e2e_a11y.py` are `dict[str, Any]` because they are an opaque third-party payload — a listed
exception. `**options: Any` in `apps/core/management/base.py` is Django's own pass-through
signature, not a domain type. Both are correct as written; see
[`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md).

---

## Pull-request review checklist

- [ ] No function returns a bare `dict` whose keys the caller must know — the return type is named.
- [ ] Every payload crossing a trust boundary is parsed into a named type **at** that boundary, once.
- [ ] No dictionary from that payload survives past the boundary layer into a service or a template.
- [ ] A parse failure there raises from the `ServiceError` tree (4xx), never `InvariantViolation`.
- [ ] Every closed, design-time set that behaviour branches on is an enum, not a bare string or int.
- [ ] Every match or switch over an enum is exhaustive — no catch-all arm doing something plausible.
- [ ] No magic string or number at a call site where a constant or enum member already exists.
- [ ] Every dictionary in domain code is a listed exception or carries `DICT-OK:` with a reason.
- [ ] Every `DICT-OK:` marker has reason text after the colon and names the boundary it is confined to.
- [ ] No new state encoded as two or more booleans that cannot in fact vary independently.
- [ ] Persisted enum values are stable strings or explicit integer codes — never ordinals.
- [ ] Every persisted enum column has a database `CHECK` constraint, not only `choices=`.
- [ ] No `dict[str, Any]` in a signature outside a pass-through or an opaque third-party payload.
- [ ] No stringly-keyed stash on an object (`obj.__dict__["…"]`, an untyped attribute bag).

Run `code/src/scripts/syntax/check.sh` before claiming any of the type-checked rows; the checker
decides them faster and more honestly than reading does. A rejected finding is recorded in
`project-management/src/20-FINDINGS/`, not argued in a thread.

---

## Why

- **Refactoring safety.** Rename a field on a type and the checker names every site. Rename a
  dictionary key and you are grepping a string that also appears in three unrelated contexts.
- **IDE support.** Completion, go-to-definition and find-references work on a type. On a string
  key they work on nothing, which is why dictionary-shaped code is read by guessing.
- **Self-documenting signatures.** `invite_member(team, payload: InviteIn)` says what it takes.
  `invite_member(team, data: dict)` says that reading the body is mandatory.
- **One whole bug class removed.** `KeyError` and the `undefined` property read exist only where
  the shape was never declared. Declaring it does not make them rarer; it makes them impossible.

The cost is real and small: a type definition per boundary, and one conversion at each edge. It is
paid once, at the point where somebody already understood the shape.

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
