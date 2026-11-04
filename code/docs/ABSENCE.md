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
script can decide (portable)_; this guide uses those two tiers and no other.

---

## The six kinds

| Kind               | It means                                                                       | The question that singles it out                                   |
| ------------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------ |
| **Failure**        | The attempt to produce the value went wrong                                    | Did the operation fail to complete?                                |
| **Not-applicable** | The value does not exist for this kind of thing, in any state it can be in     | Could this thing ever have a value here?                           |
| **Empty**          | A collection was produced, and it holds nothing                                | Was a collection produced?                                         |
| **Not-supplied**   | An input a person could have given was not given                               | Was it a person's to supply, on this request or record?            |
| **Not-yet**        | The value will exist, produced by work already under way                       | Is something in flight that will produce it without anyone acting? |
| **Expected miss**  | A lookup for one specific thing found nothing, and that is an ordinary outcome | None of the above: a single thing was looked for and is not there  |

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
- **Not-yet requires work in flight; waiting on a person is not-supplied.** **[judgement]** A
  thumbnail a queued task is rendering is not-yet. A profile photo the user has not uploaded is
  not-supplied, however likely it is to arrive.
- **Not-yet beats expected miss when the producer is known.** **[judgement]** A payment record
  the provider's webhook will create is not-yet while that payment is pending; the same lookup
  with no payment initiated is a miss.

---

## The crib — six kinds on five runtime surfaces

One column per surface. Every cell names the expression, or says why that kind cannot arise
there. **Rust** is present only in a project generated with `INCLUDE_RUST`, and **mobile
TypeScript** only with `INCLUDE_MOBILE`; the other three ship everywhere.

| Kind               | Python (Django)                                                                                                                                                                     | Rust                                                                  | Alpine                                                                                                                 | HTMX                                                                                                                          | Mobile TypeScript                                                        |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| **Expected miss**  | `T \| None` from an internal lookup; a single-object read raises `ServiceNotFoundError` — a miss carried on the error channel to its 404, not a failure                             | `Option<T>`, `None`                                                   | The component's own `fetch` sets its declared state property to a frozen constant (`"not-found"`), never a bare `null` | 200 with the not-found partial — never a 4xx, which swaps nothing, nor a blank body                                           | `T \| undefined` from an index read or `Array.find`, narrowed before use |
| **Not-yet**        | A `TextChoices` status member on the owning model (`PENDING`), or a `StrEnum` where the state is serialised off it — never `None`                                                   | An enum variant (`Pending`), never `None`                             | A state property declared at init from a frozen constant (`"loading"`), never an undeclared key                        | A 200 placeholder fragment that re-requests itself through `hx-trigger`                                                       | A union member such as `{ status: "loading" }`                           |
| **Empty**          | `[]`, an empty `QuerySet` or `()` — never `None`                                                                                                                                    | `Vec::new()` or an empty slice, returned only when the call succeeded | `results: []` declared at init and rendered through an `x-if` empty-state template — never `null`                      | 200 with the empty-state partial — never a blank body                                                                         | `[]` — never `null`                                                      |
| **Failure**        | `raise` — a `ServiceError` subclass for a user error (bar `ServiceNotFoundError`, the miss above), `InvariantViolation` for a programmer error                                      | `Err(E)` in a `Result`, propagated with `?`                           | An `error` property declared at init as `null`, set to the message the alert region announces                          | 5xx for an environment or programmer error, swapped into the error region; a form's user error is the re-rendered form at 200 | A thrown `Error`, or a `{ status: "error" }` union member                |
| **Not-supplied**   | A Ninja `Schema` field `T \| None = None` or a declared default — read through `model_fields_set` where omitted and `null` differ (a PATCH); an absent form key read as its default | `Option<T>` on an input struct, or the field's `Default`              | A property declared at init with its empty default (`""`, `false`)                                                     | Request side: the key is absent from the payload — an unchecked checkbox sends nothing                                        | An optional property `name?: T`, left absent rather than set             |
| **Not-applicable** | A record type or variant with no such field, never a nullable attribute                                                                                                             | An enum variant that carries no such field                            | The control is not rendered — an `x-if`, never `x-show`, which leaves it in the submitted form                         | The element is not rendered — a server `{% if %}` — so no request is ever made                                                | A union member that has no such property                                 |

The HTMX column is written against
[`rendering/PITFALLS-AND-EXAMPLES.md`](rendering/PITFALLS-AND-EXAMPLES.md) -> _An error the user
never sees_: htmx swaps no 4xx or 5xx by default, and the shipped global handler retargets a 5xx
alone, so a 4xx reaches the user as no change at all.

**Rust-only.** The Rust column expresses
[`data-structures/TYPES-RUST.md`](data-structures/TYPES-RUST.md) -> _Option and Result, never
sentinels_, which owns the shape rule behind it: this column adds only which kind each `Option`
or `Result` carries.

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


# Good — each meaning is named, so a match over the result is exhaustive.
class VatNumberAbsence(StrEnum):
    NOT_SUPPLIED = "not-supplied"  # a VAT-registered company that left it blank
    NOT_APPLICABLE = "not-applicable"  # a private individual: no VAT number exists


def vat_number(account: Account) -> str | VatNumberAbsence: ...
```

- **This rule is stated here and in no other guide.** **[gate: fail]** `doctrine-drift.sh`,
  claim `absence-enum`: a second fenced Python class named `…Absence` whose base is written
  exactly `(StrEnum)` or `(Enum)` fails `doctrine-restated`, and this one going missing fails
  `doctrine-unowned`. It scans fenced code under `code/docs`, `.claude/skills` and the three
  workflow trees, and its CI workflow is path-filtered to the same trees.
- **Every other restatement is a reviewer's catch.** **[judgement]** Prose, another class name,
  `enum.StrEnum` or `TextChoices`, and the Rust or TypeScript spelling all pass the gate green.

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
