---
type: guide
skills: [backend, database, stack-django, test-writer]
model: opus
---

# Types Over Dictionaries — Python

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — frozen dataclasses, NewType, StrEnum and exhaustive match on the Django surface

The Python surface exists, but the tree is near-empty: `apps/core` and the e2e suite are all
there is — no domain models, no migrations, no endpoints. Said once, and not repeated. Every
example below that names a real file is real; the rest is the standard the first model is built
to.

The governing rule is [`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md)'s:

> A dictionary is a data structure, not a type. When a set of keys is known at design time and
> carries meaning in the domain, it is a named type with named fields. Dictionaries are for keys
> that are genuinely data — unknown, dynamic, or supplied by the outside world.

---

## The record types, and which to reach for

| Need                                                        | Use                                                         | Why                                                                                                                         |
| ----------------------------------------------------------- | ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| An immutable in-process record                              | `@dataclass(frozen=True, slots=True)`                       | `frozen` makes it hashable and safe to pass anywhere; `slots` blocks the attribute typo that a plain class silently accepts |
| A record validated from **untrusted** input                 | `Schema` / `OutSchema` / `QuerySchema`, `apps.core.schemas` | Parsing is the boundary. `Schema` forbids unknown fields on request bodies; `OutSchema` and `QuerySchema` stay permissive   |
| A persisted record                                          | A Django model                                              | The database owns the invariants — constraints, not just `choices=`                                                         |
| A lightweight positional record that stays tuple-compatible | `typing.NamedTuple`                                         | Unpacks and indexes like the tuple it replaces, so it can be introduced without touching call sites                         |

**Never `from ninja import Schema`** — ruff `TID251` bans both that and Django's `BaseCommand`,
with `code/src/django/apps/core/schemas.py` and
`code/src/django/apps/core/management/base.py` the two per-file exemptions. Which base, and why
the strictness differs across the three: [`../api-design/NINJA-CONVENTIONS.md`](../api-design/NINJA-CONVENTIONS.md).

**The rule: never return a dict from a function whose keys the caller is expected to know.**

```python
# Bad — four key names the caller must learn by reading the body, and nothing checks them.
def summarise_account(account: Account) -> dict[str, Any]:
    return {
        "name": account.name,
        "open_invoices": account.invoices.filter(paid_at__isnull=True).count(),
        "balance": account.balance,
        "overdue": account.has_overdue(),
    }
```

```python
# Good — the return type is the documentation, and basedpyright checks every access.
@dataclass(frozen=True, slots=True)
class AccountSummary:
    name: str
    open_invoices: int
    balance: Money
    overdue: bool


def summarise_account(account: Account) -> AccountSummary: ...
```

The dict version costs nothing to write and everything to change: renaming `overdue` is a grep
across templates and tests with no failure if one is missed. The dataclass version is a rename
the checker completes.

The rule is about **named** keys, not about ceremony. A function returning a genuine pair that
the caller immediately unpacks — `start, end = window()` — is a tuple, and wrapping it in a
class buys nothing. The moment either element is read by name anywhere, it has become a record.

---

## Identifiers: NewType

Two UUIDs are the same type to Python and different things to the domain. `typing.NewType`
recovers the distinction with no runtime object:

```python
from typing import NewType
from uuid import UUID

UserId = NewType("UserId", UUID)
OrderId = NewType("OrderId", UUID)


def reassign_order(order: OrderId, to: UserId) -> None: ...


reassign_order(some_user_id, some_order_id)  # basedpyright: argument type mismatch
```

`UserId(value)` compiles to the identity function — no wrapper, no allocation, no `__eq__`
override. The cost is one line per identifier and the discipline of minting it where the value
is first parsed.

**The honest limit for this project.** basedpyright runs in `typeCheckingMode = "standard"`, not
`strict`, and excludes `**/tests/**` and `**/conftest.py`. So `NewType` earns its place in
`apps/` — where the checker runs — and buys nothing in the e2e suite, where it is not looking.
Do not spend the line there.

**The mobile surface declined the equivalent.** Branded (nominal) IDs in TypeScript are
**not** adopted at baseline; the trigger is recorded — they arrive in the same change as the
mobile API client, minted at the single point that parses a response
([`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) Section 3). The two surfaces
differ because the mechanisms differ: Python's `NewType` is free, and a TypeScript brand is a
cast asserting a proof that only a real parse boundary can supply.

---

## TypedDict is transitional

A `TypedDict` describes the shape of an external payload you do **not** own. It is not a
substitute for a domain object you **do** own, because it is structural: it gives you key names
and nothing else — no methods, no invariants, no constructor to validate in. Nothing stops a
caller building one field by field with a value the domain forbids.

`code/src/django/tests/e2e/a11y_config.py` carried both readings at once, and is worth reading
because the fix has already landed. `Suppression` **stays** a `TypedDict` — a waiver record a
script reads, its four keys exactly what a reviewer types by hand, and no behaviour to hang on it.
`SCAN_PROJECTS` beside it did not earn the same ruling:

```python
# Was — the keys are known at design time and the values carry meaning.
SCAN_PROJECTS: dict[str, dict[str, object]] = {
    "desktop": {"viewport": {"width": 1280, "height": 800}, "colour_scheme": "light"},
}
```

`dict[str, object]` means every read needs a cast, and the scheme accepted `"lgiht"`. It is now a
`tuple[ScanProject, ...]` over the value objects in
`code/src/django/tests/e2e/browser_types.py` — a frozen `Viewport`, a `ColourScheme` `StrEnum`,
and a `ScanProject` that carries its own `name`:

```python
@dataclass(frozen=True, slots=True)
class Viewport:
    width: int
    height: int

    def to_playwright(self) -> dict[str, int]:
        # DICT-OK: Playwright's API signature, not ours — confined to this method, the
        # suite's only crossing point into that library's vocabulary.
        return {"width": self.width, "height": self.height}
```

**The conversion method is the boundary exception**, not a loophole — the dict exists for exactly
one call and never escapes ([`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)). `ColourScheme` is spelt
the British way and becomes Playwright's `color_scheme` at the one call that opens a context; that
translation is the boundary doing its job, not an inconsistency.

Two things did **not** change, and both are the rule working rather than an exception to it.
`VIEWPORTS` in `code/src/django/tests/e2e/conftest.py` stayed a dict — `dict[str, Viewport]`, a
name-to-record index, where only the _value_ was ever the defect. And `dict[str, Any]` for the axe
payload in `code/src/django/tests/e2e/test_e2e_a11y.py` stayed too, marked: an opaque third-party
result nobody here owns. What went was `page.__dict__["_scan_project"]` — a name smuggled onto
somebody else's object, which is a dictionary used as a type in the least visible way available.
Putting `name` on `ScanProject` left nothing to smuggle.

---

## Constructors and conversions

Name the direction and put it on the type. `from_row` / `from_payload` inward, `to_payload` /
`to_*` outward — instead of ad-hoc dict shuffling repeated at each call site.

```python
@dataclass(frozen=True, slots=True)
class Address:
    line1: str
    postcode: str

    @classmethod
    def from_payload(cls, payload: AddressIn) -> "Address":
        return cls(line1=payload.line1.strip(), postcode=payload.postcode.upper())

    def to_payload(self) -> AddressOut:
        return AddressOut(line1=self.line1, postcode=self.postcode)
```

Naming the conversion is what makes it **greppable** — one search finds every place an address
enters the system — and **testable**: normalisation has a function to assert against rather than
four inlined `.upper()` calls that drift apart.

**The conversion lives on the type, not in the service that happens to call it first.** A service
that builds an `Address` inline is the only one that knows how; the second service to need one
copies the six lines, and the two normalisations diverge on the first bug fix. One type, one
inward constructor per boundary it is parsed from, one outward method per boundary it is written
to — and each of those is a name a review can ask about.

Which error class a failure here raises follows the taxonomy in
[`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md), and the two directions are not symmetrical. A
parse failure at a trust boundary is a **user error** — a `ServiceError` subclass, surfaced as a
4xx. A domain object constructed wrong by our own code is a **programmer error** —
`InvariantViolation`, a 500 and a tracker event. `from_payload` may reject; `to_payload` on a
valid object may not fail at all.

---

## Enums

| Situation                                    | Use                  | Note                                                         |
| -------------------------------------------- | -------------------- | ------------------------------------------------------------ |
| A closed set that is serialised or persisted | `enum.StrEnum`       | The value is part of the contract                            |
| A closed set that never leaves the process   | `enum.Enum`          | The value is an internal detail; do not spend a string on it |
| A Django model field                         | `models.TextChoices` | Owned by [`DOMAIN-MODELLING.md`](DOMAIN-MODELLING.md)        |

**The enum test** — use an enum when all three hold: the set of values is closed, it is known at
design time, and behaviour branches on it. Counter-case: values that come from data (user-defined
tags, a DB-driven lookup table that changes without a deploy, a third party's vocabulary) belong
in data, not in an enum.

```python
from enum import StrEnum


class ExportFormat(StrEnum):
    CSV = "csv"
    XLSX = "xlsx"
    PDF = "pdf"


ExportFormat("csv") is ExportFormat.CSV  # True — parsing back is free
f"{ExportFormat.CSV}"  # "csv" — it interpolates as its value, not as the member name
```

**A str-valued enum is needed whenever the value crosses a boundary** — JSON, a database column,
a URL segment, a log line. There it must be a stable string. An `IntEnum` makes the stored value a
promise about declaration order, and inserting a member in the middle silently re-points every row
already written. A string cannot be broken by an edit that does not touch it.

`ServiceError.code` in `code/src/django/apps/core/services/errors.py` is a closed set spelt as
bare `str` defaults. That is **backlogged, not an oversight** — the field is the JSON error
envelope's machine-readable `code`, whose spelling is owned by
[`../api-design/AUTH-AND-ERRORS.md`](../api-design/AUTH-AND-ERRORS.md) Section _The error
envelope_, and the migration row is already open in
[`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md). Do not re-argue it here.

---

## Exhaustive match

```python
from apps.core.services.errors import InvariantViolation


def content_type_for(fmt: ExportFormat) -> str:
    match fmt:
        case ExportFormat.CSV:
            return "text/csv"
        case ExportFormat.XLSX:
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case ExportFormat.PDF:
            return "application/pdf"
        case _:
            raise InvariantViolation("export.format_handled", f"format={fmt!r}")
```

What this buys: adding a fourth format surfaces every place that must change. The alternative — a
dict lookup with a `.get(fmt, "application/octet-stream")` default — ships the new format as a
wrong content type nobody notices for a month.

The `case _:` arm **raises**; it never asserts. `assert` is banned outside tests by ruff `S101`,
and the raise is what carries the register key an error-tracker event is keyed on. The key needs a
row in `how-to/src/INVARIANTS.md`; the guard-clause shape is
[`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md) Section _The guard clause_.

**Be honest about who is doing the work here.** basedpyright in `standard` mode does not narrow
and report exhaustiveness as aggressively as a strict setting would, so the runtime raise is not
belt-and-braces over a checker that already caught it — on this project it is the primary
mechanism. Treat the `case _:` arm as required, not decorative.

---

## The type checker, and what CI actually enforces

| Setting            | Value                                                              | What it means here                                              |
| ------------------ | ------------------------------------------------------------------ | --------------------------------------------------------------- |
| `typeCheckingMode` | `standard`                                                         | Not `strict` — inference gaps and implicit `Any` pass           |
| `include`          | `code/src/django`                                                  | Nothing outside the Django tree is checked at all               |
| `exclude`          | `**/migrations`, `**/__pycache__`, `**/tests/**`, `**/conftest.py` | The e2e suite above is excluded — deliberately, and permanently |
| Ruff `TID251`      | `ninja.Schema`, both `BaseCommand` paths                           | The banned-api mechanism already exists and takes new entries   |

Run both through the project scripts — `code/src/scripts/syntax/check.sh` for the type check and
`code/src/scripts/syntax/lint.sh` for ruff — never a raw invocation.

**What this means, stated plainly: the checker will not catch a dict returned from a test helper.**
`SCAN_PROJECTS` was invisible to it for its whole life and always would have been, since excluding
test trees is deliberate — it was found by reading the module, not by running anything. So the
review checklist is **not** redundant with the type checker; it covers exactly the surface the
checker declines. The mechanical half is `code/src/scripts/audits/dict-discipline.sh`, which reads
the escape-hatch marker:

```text
DICT-OK: <reason> — confined to <boundary>
```

`#` in Python. A marker with no reason text after the colon is itself a finding. Anything without
the marker, outside the listed exceptions, is a review blocker. `TID251` is the tool for the next
step: a helper that keeps returning `dict[str, Any]` across a service boundary can be banned by
name in `pyproject.toml`, in the same way `ninja.Schema` already is.

---

## Cross-references

| Topic                                                          | Guide                                                                        |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| The core principle, the enum test, the cross-surface rule      | [`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md)                   |
| When a dictionary is legitimate, and the `DICT-OK:` marker     | [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)                                 |
| God Dictionary, Stringly Typed, Primitive Obsession, the rest  | [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md)                                       |
| `TextChoices`, value objects, aggregates, Ninja response shape | [`DOMAIN-MODELLING.md`](DOMAIN-MODELLING.md)                                 |
| The error taxonomy and the guard clause                        | [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)                               |
| Which schema base, and why the three differ                    | [`../api-design/NINJA-CONVENTIONS.md`](../api-design/NINJA-CONVENTIONS.md)   |
| Branded IDs on the mobile surface, and the trigger to revisit  | [`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) Section 3 |

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
