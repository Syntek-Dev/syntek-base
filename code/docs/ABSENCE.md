---
type: guide
skills: [backend, frontend, code-reviewer, refactor]
model: opus
---

# Absence — What "Nothing" Means

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the six kinds of absence, the runtime crib, the absence-enum and never-overload rules

When code returns "nothing", it can mean six different things, and a reader who has to guess
which one will sometimes guess wrong. This guide owns **what an absence means**: the six kinds,
how to tell them apart, and how each is written on the five runtime surfaces this stack ships.
**What shape a value has** is not here — that is the `TYPES-*` family's, and this guide cites
it rather than restating it (_What this is not_, below).

**How to read the markers.** Every rule carries its enforcement tier inline: `[gate: fail]`
names the gate that fails the run, and `[judgement]` is a reviewer's call that no script can
make. The vocabulary and its meanings are [`VISUAL-DESIGN.md`](VISUAL-DESIGN.md) -> _6. What a
script can decide (portable)_ — here no audit lists the `[judgement]` clauses; this guide uses
those two tiers and no other.

---

## The six kinds

| Kind               | It means                                                                       | The question that singles it out                                                                                                                           |
| ------------------ | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Failure**        | The attempt to produce the value went wrong                                    | Did the operation fail to complete?                                                                                                                        |
| **Not-applicable** | The value does not exist for this kind of thing, in any state it can be in     | Could this thing ever have a value here?                                                                                                                   |
| **Empty**          | A collection was produced, and it holds nothing                                | Was a collection produced?                                                                                                                                 |
| **Not-supplied**   | An input its supplier could have given was not given                           | Was it for whoever writes this request or record — a person, a client or an integration — to give, rather than for a process already under way to produce? |
| **Not-yet**        | The value will exist, produced by work already under way                       | Is something in flight that will produce it without anyone acting?                                                                                         |
| **Expected miss**  | A lookup for one specific thing found nothing, and that is an ordinary outcome | None of the above: a single thing was looked for and is not there                                                                                          |

The not-supplied / not-applicable split parallels E. F. Codd's "missing-but-applicable" A-marks
and "inapplicable" I-marks
([_Missing Information (Applicable and Inapplicable) in Relational Databases_](https://sigmodrecord.org/1986/12/13/missing-information-applicable-and-inapplicable-in-relational-databases/),
SIGMOD Record 15(4), 1986, p. 57); it is not derived from them, and his A-mark spans both
not-yet and not-supplied here.

### Exhaustive and mutually exclusive — the decision order

The table's rows are also its procedure, and the order is the tie-break.

- **Classify an absence by asking the six questions in table order and stopping at the first
  yes.** **[judgement]** The last row answers yes to everything the first five did not, so every
  absence lands on a kind; stopping at the first yes means it lands on exactly one.
- **If the absence is not produced by an attempt to obtain a value, it is none of the six** —
  see _What is not an absence_. **[judgement]**

### The tie-breaks, where two kinds could plausibly apply

- **Failure beats every other kind.** **[judgement]** An attempt that did not complete cannot
  report what it would have found, so a timeout on a lookup is a failure, never an expected miss
  — and a query that errored is never an empty list.
- **Not-applicable beats not-supplied: ask whether any state of this thing accepts a value.**
  **[judgement]** If none does, it is not-applicable; if one does and nobody gave it, it is
  not-supplied. A private individual's VAT number is not-applicable; a VAT-registered company
  that left the field blank has a not-supplied one.
- **Empty beats expected miss: ask whether the question was about one thing or about many.**
  **[judgement]** A filter returning zero rows is empty; a lookup by identifier returning no row
  is a miss — even when both run the same query underneath.
- **An omitted list is not-supplied; a list sent empty is empty.** **[judgement]** A payload
  that leaves out its `tags` field produced no collection, so the empty question does not apply;
  one that sends `tags: []` supplied a collection that holds nothing.
- **Not-yet requires work in flight; waiting on whoever supplies it is not-supplied.** **[judgement]** A
  thumbnail a queued task is rendering is not-yet. A profile photo the user has not uploaded is
  not-supplied, however likely it is to arrive — and so is a field an integration left out.
- **Not-yet beats expected miss when the producer is known.** **[judgement]** A payment record
  the provider's webhook will create is not-yet while that payment is pending; the same lookup
  with no payment initiated is a miss.

---

## The crib — six kinds on five runtime surfaces

One column per surface. Every cell names the expression, or says why that kind cannot arise
there. **Rust** is present only in a project generated with `INCLUDE_RUST`, and **mobile
TypeScript** only with `INCLUDE_MOBILE`; the other three ship everywhere.

| Kind               | Python (Django)                                                                                                                                                                                                                                                                                               | Rust                                                                                                                                                                                                                                                                                                                   | Alpine                                                                                                                                                                                                                                               | HTMX                                                                                                                                                                                                           | Mobile TypeScript                                                                                                                                                                                                 |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Expected miss**  | `T \| None` from an internal lookup; a single-object read raises `ServiceNotFoundError` — a miss on the error channel, not a failure: 404 on the JSON API, caught by an HTMX-facing view                                                                                                                      | `Option<T>`, `None`                                                                                                                                                                                                                                                                                                    | The HTMX swap carries it; Alpine holds no lookup of its own                                                                                                                                                                                          | 200 with the not-found partial while the global handler retargets 5xx only — a 4xx swaps nothing — never a blank body                                                                                          | `T \| undefined` from an array index, `Map.get` or `Array.find`, narrowed before use                                                                                                                              |
| **Not-yet**        | A `TextChoices` status member on the owning model (`PENDING`), or a `StrEnum` where the state is serialised off it — never `None`                                                                                                                                                                             | An enum variant (`Pending`), never `None`                                                                                                                                                                                                                                                                              | Cannot arise — Alpine does not fetch; a server operation's not-yet is the HTMX placeholder, with `htmx-indicator` / `hx-disabled-elt`                                                                                                                | A 200 placeholder that replaces itself (`hx-trigger="load delay:…"`, `hx-swap="outerHTML"`) until the finished content returns                                                                                 | A union member such as `{ kind: "loading" }`                                                                                                                                                                      |
| **Empty**          | `[]`, an empty `QuerySet` or `()` — never `None`                                                                                                                                                                                                                                                              | `Vec::new()` or an empty slice, returned only when the call succeeded                                                                                                                                                                                                                                                  | A live filter's getter over `{% json_script %}` data, shown empty only once a query is supplied (an empty query is not-supplied), its count written by `x-text` to a `role="status"` element outside any `x-if`                                      | 200 with the empty-state partial — never a blank body                                                                                                                                                          | `[]` — never `null`                                                                                                                                                                                               |
| **Failure**        | `raise` — a `ServiceError` subclass for a user error (bar `ServiceNotFoundError`, the miss above), `InvariantViolation` for a programmer error, `DependencyUnavailable` from the outbound adapter for an environment error (503)                                                                              | `Err(E)` in a `Result`, propagated with `?`                                                                                                                                                                                                                                                                            | Cannot arise — Alpine holds no network operation; a failure lands in the HTMX global handler's error region, never as an empty state                                                                                                                 | 5xx for an environment or programmer error, swapped — or, for an edge error page, written — into the error region; a form's user error is the re-rendered form at 200; a non-form 4xx shows nothing until S-03 | A throw routed through `classify()` — `InvariantViolation` for a programmer error, the HTTP `Response` for a status failure — or a `{ kind: "failed"; reason: string }` member held as state                      |
| **Not-supplied**   | An `apps.core.schemas.Schema` field (`QuerySchema` for a query) `T \| None = None` or a declared default — read through `model_fields_set` where omitted and `null` differ (a PATCH); an absent key on an optional form field cleans to its empty value (`""`, `None`, `False`, `[]`) — _Django forms_, below | `Option<T>` on an input struct (a missing key is `None`), or `#[serde(default)]` on a non-`Option` field, without which a missing key fails to deserialise; `Option<Option<T>>` where omitted and `null` differ (a PATCH), marked `#[serde(default)]` behind a deserialiser that maps a present `null` to `Some(None)` | A property declared at init with its empty default (`""`, `false`)                                                                                                                                                                                   | Request side: the key is absent from the payload — an unchecked checkbox sends nothing                                                                                                                         | An optional property `name?: T`, left absent rather than set — the parse function maps the API's `null` to an absent key; an outgoing PATCH body has `name?: T \| null`, absent for not-supplied, `null` to clear |
| **Not-applicable** | In the domain type, a record or variant with no such field, never a nullable attribute; on the model, a nullable column only where a `CheckConstraint` ties its NULL to the row's kind (another column, or another column's NULL), parsed into the variant at `from_row`                                      | An enum variant that carries no such field                                                                                                                                                                                                                                                                             | Where applicability turns on another field's client-side value: out of the submitted form — an `x-if` on a `<template>` or a `:disabled` binding, never a bare `x-show` — and out of any `:hx-vals` it binds for htmx; otherwise the server omits it | The element is not rendered — a server `{% if %}` — so no request is ever made                                                                                                                                 | A union member that has no such property                                                                                                                                                                          |

**The HTMX column governs Django views answering HTMX requests**, and is written against
[`rendering/PITFALLS-AND-EXAMPLES.md`](rendering/PITFALLS-AND-EXAMPLES.md) -> _An error the user
never sees_: htmx 2, the major this stack pins, swaps no 4xx or 5xx by default, and the global
handler shipped for the first page that loads htmx (`observability.js`) retargets a 5xx alone, so a
4xx reaches the user as no change at all. That is why a miss answers 200 today; slice `S-03` of the absence map (decision `N-011`)
moves it to a 404 partial through that listener, and until then a non-form user error — a request
DTO that fails to parse
([`data-structures/TYPES-BROWSER.md`](data-structures/TYPES-BROWSER.md) -> _The request — named
fields, never an opaque blob_) — is invisible. **An HTMX-facing view catches `ServiceNotFoundError`
and renders the not-found partial, on the `HX-Request` branch only.** **[judgement]** A Django view
has no Ninja exception handler, so an uncaught one becomes a 500 and reads as a failure; a
full-page request for a missing object stays a real 404.

**The JSON API is not the HTMX column** — two surfaces, two contracts
([`api-design/CLIENT-PATTERNS.md`](api-design/CLIENT-PATTERNS.md) -> _Errors_). `/api/` answers a
miss with 404 and the error envelope —
[`api-design/REST-CONVENTIONS.md`](api-design/REST-CONVENTIONS.md) -> _Status Codes_ and
[`api-design/AUTH-AND-ERRORS.md`](api-design/AUTH-AND-ERRORS.md) -> _The error envelope_.

- **A lookup scoped to the caller answers absent and not-owned identically**, on every surface.
  **[judgement]** Owned by [`security/AUTH-AND-AUTHZ.md`](security/AUTH-AND-AUTHZ.md) ->
  _Anti-Enumeration_; the not-found partial is never the oracle that tells the two apart.

**Alpine does not fetch.** **[judgement]** [`RENDERING.md`](RENDERING.md) -> _The doctrine (the
decision rule)_ keeps it local with no round-trip, so a miss arrives in the HTMX swap and a failure
in the global handler's error region — the server's partial, or the handler's fallback or offline
message. Not-yet and failure therefore cannot arise in Alpine. Empty arises in a client-side live
filter ([`FRONTEND-CODING-PRINCIPLES.md`](FRONTEND-CODING-PRINCIPLES.md) -> _HTMX & Alpine_), and
its empty state reads differently from no query yet; the announcement is
[`accessibility/TESTING-AND-COMPONENTS.md`](accessibility/TESTING-AND-COMPONENTS.md) ->
_Announcing dynamic updates_. The Python not-applicable cell's model half is
[`data-structures/SCHEMA-DESIGN.md`](data-structures/SCHEMA-DESIGN.md) -> _Polymorphic
Relationships_.

**Django forms.** A form field is required by default, `BooleanField` included, so an absent key
there is a validation error — a user error, not an absence. A `disabled` field takes its
`initial`, and a `ModelForm` gives an omitted optional field the model default (bar a checkbox or
multi-select). Form encoding cannot separate omitted from empty for a checkbox or a multi-select,
so the omitted-list tie-break above cannot be read there. **Where omitted and empty must differ,
the input arrives as JSON through a `Schema`, where `model_fields_set` sees it.** **[judgement]**

**Rust-only.** The Rust column expresses
[`data-structures/TYPES-RUST.md`](data-structures/TYPES-RUST.md) -> _Option and Result, never
sentinels_, which owns the shape rule behind it: this column adds only which kind each `Option`
or `Result` carries. **A future client of `/api/` maps a single-object 404 to `Ok(None)` at the wire
seam, never to `Err`.** **[judgement]**

**Mobile-only.** The mobile column's shapes are
[`data-structures/TYPES-TYPESCRIPT.md`](data-structures/TYPES-TYPESCRIPT.md)'s. Its failure path
is [`MOBILE-CODING-PRINCIPLES.md`](MOBILE-CODING-PRINCIPLES.md) -> _4. How this surface expresses
the error taxonomy_: the shipped `classify()` files a 404, like every 4xx bar 408, as a user error, so an API 404 on a
single-object read lands on the failure channel until the API client maps it to a not-found member
at the parse boundary.

---

## The absence-enum rule

- **An absence with more than one meaning is an enum, never a null.** **[judgement]** Where one
  field or return value can be absent for two or more of the six reasons, each reason is a named
  member the reader matches on. A bare `None`, `null` or `undefined` says only "nothing", and
  the reader rebuilds which nothing from context — the provenance problem Robert Harper's
  [_Boolean Blindness_](https://existentialtype.wordpress.com/2011/03/15/boolean-blindness/)
  describes for Booleans, one level down.
- **Two spellings of one meaning are still one meaning.** **[judgement]** Normalising `null`
  and `undefined` into a single "no value" where both mean the same kind is parsing at the
  boundary, not overloading; the rule bites only when the meanings differ.

```python
# Bad — one None, two meanings, and the caller cannot tell which.
def vat_number(account: Account) -> str | None: ...


# Good — each meaning is a named member, and no member is also a str.
class VatNumberAbsence(Enum):
    NOT_SUPPLIED = auto()  # a VAT-registered company that left it blank
    NOT_APPLICABLE = auto()  # a private individual: no VAT number exists


def vat_number(account: Account) -> str | VatNumberAbsence: ...


def vat_label(account: Account) -> str:
    match vat_number(account):
        case VatNumberAbsence.NOT_SUPPLIED:
            return "Not given yet"
        case VatNumberAbsence.NOT_APPLICABLE:
            return "Not VAT-registered"
        case str() as number:
            return number
        case _:
            raise InvariantViolation("account.vat_number_handled", f"account={account.pk}")
```

The base is plain `Enum` because the value never leaves the process. A `StrEnum` member is also a
`str` and equals its value, so a real value spelt like a member lands in that member's arm, and
`str | VatNumberAbsence` gives the checker nothing to separate; a plain `Enum` member equals no
`str`. **The `case _:` arm is mandatory.**
**[judgement]** Both are owned by
[`data-structures/TYPES-PYTHON.md`](data-structures/TYPES-PYTHON.md) -> _Enums_ and _Exhaustive
match_.

- **This rule is stated here and in no other guide.** **[gate: fail]** `doctrine-drift.sh`,
  claim `absence-enum`: a backtick-fenced `class …Absence(StrEnum)` or `(Enum)` line outside this
  guide fails `doctrine-restated`, whatever the fence's language, and this one going missing fails
  `doctrine-unowned`. It scans fenced code under `code/docs`, `.claude/skills` and the three
  workflow trees, and its CI workflow is path-filtered to the same trees.
- **Every other restatement is a reviewer's catch.** **[judgement]** Prose, another class name,
  `enum.StrEnum` or `TextChoices`, a bare `class Absence`, a `~~~` fence, and the Rust or
  TypeScript spelling all pass the gate green.

---

## The never-overload rule

- **Never let one absence carry two meanings.** **[judgement]** Where one of the meanings is a
  failure, the failure leaves the absence channel — it raises, returns `Err`, or answers with an
  error status — and what remains is a single kind. Where none is a failure, the absence-enum
  rule above applies.
- **A lookup that can come back empty for a reason other than the row's absence is guarded, not
  trusted.** **[judgement]** The one shipped instance is
  [`rls/MIDDLEWARE-AND-NINJA.md`](rls/MIDDLEWARE-AND-NINJA.md) -> _Row locking_: a locked query
  returns no row both when the row is genuinely absent and when the scope was never set, so the
  guard raises rather than reading the result as an ordinary miss.

---

## What is not an absence

- **A response or call that completes with nothing to return is not one of the six.**
  **[judgement]** A 204, or a deliberate `hx-swap="none"`, reports a finished action with
  nothing to redraw; a function annotated `-> None` is called for its effect. None of them is a
  value someone asked for, so none of them is classified here — and none of them may stand in
  for an absence that is one of the six.

---

## What this is not

| Concern                                                                | Owner                                                                                                                       |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| What shape a value has — records, enums, unions, the parse boundary    | [`data-structures/TYPES-OVER-DICTIONARIES.md`](data-structures/TYPES-OVER-DICTIONARIES.md) and its sibling `TYPES-*` guides |
| `Option` and `Result` over sentinels, and the lints that force them    | **Rust-only.** [`data-structures/TYPES-RUST.md`](data-structures/TYPES-RUST.md) -> _Option and Result, never sentinels_     |
| Which error class a failure is, and how each surfaces                  | [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) -> _The error taxonomy_ — a sibling discipline                                     |
| A gate that could not look, against a surface that is genuinely absent | [`GATE-REPORTING.md`](GATE-REPORTING.md) — a sibling                                                                        |
| A path absent here and present in a generated project, or the reverse  | [`FORWARD-VOICE.md`](FORWARD-VOICE.md) — a sibling                                                                          |

`NEGATIVE-SPACE.md` asks what must never be true; this guide asks what an absence means. They
touch at one row of the crib — failure — and that row names the expression while the error
taxonomy decides the class.

---

## Cross-references

- [`data-structures/TYPES-OVER-DICTIONARIES.md`](data-structures/TYPES-OVER-DICTIONARIES.md): the
  shape standard every crib cell is written inside
- [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md): the error taxonomy behind the failure row
- [`rls/MIDDLEWARE-AND-NINJA.md`](rls/MIDDLEWARE-AND-NINJA.md): the never-overload rule's shipped
  instance
- `code/src/scripts/audits/doctrine-drift.sh`: the claim that keeps the absence-enum rule in one
  home

_Part of the `code/docs/` documentation family._
