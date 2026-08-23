---
type: guide
skills: [stack-rust, code-reviewer]
model: opus
---

# Types Over Dictionaries — Rust

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — newtypes, enums with data, and the wire/domain seam

> **Rust-only.** This guide and the tree it describes exist only in a project generated with
> `INCLUDE_RUST`. On a project without it, `code/src/rust/` is absent and nothing here applies.

> **Forward-looking.** The workspace ships no wire types at baseline — `code/src/rust/Cargo.toml`
> declares exactly three shared dependencies (`pyo3`, `zeroize`, `secrecy`), and `serde` is in
> neither it nor either crate manifest. Every `serde` example below is the standard the first
> deserialising crate is built to, not a description of code that exists.

The principle is the project's, not this surface's, and `TYPES-OVER-DICTIONARIES.md` owns it:

> A dictionary is a data structure, not a type. When a set of keys is known at design time and
> carries meaning in the domain, it is a named type with named fields. Dictionaries are for keys
> that are genuinely data — unknown, dynamic, or supplied by the outside world.

Rust is the surface where that costs the least. A struct is free, an enum is free, and the
compiler refuses the code that ignores them.

---

## Structs with named fields; newtypes for identifiers and units

A newtype is a single-field struct wrapping a primitive. It compiles to the primitive — same
size, same layout, no allocation, no indirection — and buys a name the type checker enforces.

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct UserId(pub u64);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct OrderId(pub u64);

fn cancel(order: OrderId, actor: UserId) -> Result<(), DomainError>;
```

Swap the two arguments — `cancel(actor, order)` — and it does not compile, because `UserId` and
`OrderId` are unrelated types with no conversion between them. With two bare `u64`s it compiles,
ships, and cancels the wrong order.

**Units are where this surface earns it most.** The existing crate deals in bytes and secrets,
and bytes are not characters:

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub struct Bytes(pub usize);

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub struct Chars(pub usize);
```

`String::len()` returns **bytes**; a password policy counts **characters**; `chars().count()`
returns those. Both are `usize`, so the wrong one is a silent off-by-a-multibyte-character bug
that only appears once a user types something outside ASCII. Wrapped, the mistake is a compile
error and the signature documents which unit it wanted.

**The shipped argument is already in the tree.** `SecretBytes` in
[`code/src/rust/crates/nativecore/src/lib.rs`](../../src/rust/crates/nativecore/src/lib.rs) is a
newtype-shaped wrapper over `Vec<u8>` with identical runtime representation. The whole reason it
exists is that the type carries a guarantee the primitive cannot: `Drop` zeroizes it, and
`__repr__` refuses to render its contents. A `Vec<u8>` promises nothing about either. That is the
newtype argument in one already-written type — the wrapper is not overhead, it is the promise.

Two conventions:

- **A pure tag takes a public tuple field** (`pub struct UserId(pub u64)`) — there is no
  invariant to protect.
- **A value with an invariant keeps its field private** and offers a fallible constructor, so
  the only way to hold one is to have passed the check. Route the invariant itself to
  [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md); the register names one enforcement point, and
  that constructor is it.

**A newtype does not cross the PyO3 boundary as itself.** PyO3 converts by trait, not by memory
layout, so `#[repr(transparent)]` buys nothing there — that attribute is for a C ABI. A
`#[pyfunction]` takes the primitive Python already holds, and the newtype is minted immediately
inside it, which is exactly where a fallible constructor's check belongs
([`../rust/PYO3-BOUNDARY.md`](../rust/PYO3-BOUNDARY.md) — _Keep the boundary thin_).

---

## Enums make illegal states unrepresentable

**Whether a set of values earns an enum at all** is the cross-surface enum test, and it is
[`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md)'s — unchanged here. This section is
about what a Rust enum can carry once that test has passed: **data per variant**, which turns a
closed set into a state machine no other surface in this project gets for free.

A struct of `Option` fields multiplies out every combination of present and absent, and then
relies on prose to say which ones are real.

```rust
// Bad — four optional fields. Sixteen representable states; four are legal.
pub struct Upload {
    pub queued_at: Option<Instant>,
    pub started_at: Option<Instant>,
    pub finished_at: Option<Instant>,
    pub error: Option<UploadError>,
}
```

Nothing stops `finished_at` and `error` both being `Some`, or `started_at` being `None` while
`finished_at` is `Some`. Every reader has to reconstruct the state machine from the field names,
and every writer has to remember to clear the fields the new state invalidates.

```rust
// Good — exactly the legal states exist, each carrying only its own data.
pub enum Upload {
    Queued { at: Instant },
    Running { started: Instant, sent: Bytes },
    Done { started: Instant, finished: Instant, size: Bytes },
    Failed { started: Instant, error: UploadError },
}
```

Twelve of the sixteen states are now unwritable. The invariant is not documented, checked or
tested; the states it forbids are simply absent from the type's vocabulary.

**Match exhaustively. Never write a catch-all `_ =>` arm on a workspace enum.**

```rust
let status = match upload {
    Upload::Queued { .. } => Status::Waiting,
    Upload::Running { sent, .. } => Status::Progress(sent),
    Upload::Done { size, .. } => Status::Complete(size),
    Upload::Failed { error, .. } => Status::Error(error),
};
```

The catch-all is what turns "add a variant" from a compile error into a silent behaviour change:
the new variant falls into `_`, every call site keeps compiling, and the new state is handled by
whatever the fallback happened to be. Use `..` inside a variant pattern to ignore fields you do
not need — that keeps the arm short without discarding the variant check.

The mobile surface has to build this by hand: `unreachable(value, key)` in
[`code/src/mobile/lib/invariant.ts`](../../src/mobile/lib/invariant.ts) is a runtime helper
manufacturing the exhaustiveness Rust gets from the compiler for nothing. Do not give it away.

**`#[non_exhaustive]` is for a type other crates match on.** It forces every downstream `match`
to carry a catch-all arm, which is precisely how a published library adds a variant without a
major bump. Both crates here are `publish = false`; there is no downstream. Applying it inside
the workspace buys a semver guarantee nobody needs and destroys the compile error that is the
entire point of the section above. **Within this workspace, do not reach for it.**

---

## Option and Result, never sentinels

Absence is `Option`. Failure is `Result`. Neither is ever encoded in the value.

```rust
// Bad — three different sentinels, none of them in the signature.
fn find_index(haystack: &[u8], needle: u8) -> i64 { -1 }        // -1 means "absent"
fn load_keys(path: &Path) -> Vec<Key> { Vec::new() }            // empty means "failed"
fn decrypt(ct: &[u8]) -> (Vec<u8>, bool) { (Vec::new(), false) } // bool beside the value
```

```rust
// Good — the return type states the outcome.
fn find_index(haystack: &[u8], needle: u8) -> Option<usize>;
fn load_keys(path: &Path) -> Result<Vec<Key>, KeyStoreError>;
fn decrypt(ct: &[u8]) -> Result<SecretBytes, CryptoError>;
```

A sentinel is only a convention, so the caller who did not read the doc comment gets a plausible
wrong answer instead of a compile error. `-1` indexes nothing. An empty `Vec` reads as "no keys
configured", which is a different fact from "the key store was unreadable".

**The lint table is what makes `Result` the real return channel rather than a formality.** Both
[`crates/nativecore/Cargo.toml`](../../src/rust/crates/nativecore/Cargo.toml) and
[`crates/desktop/Cargo.toml`](../../src/rust/crates/desktop/Cargo.toml) deny `unwrap_used`,
`expect_used`, `panic`, `indexing_slicing`, `todo`, `unimplemented` and `unreachable`.

| Denial                                          | What it forces                                                                               |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `unwrap_used`, `expect_used`                    | An `Option`/`Result` cannot be discharged by panicking — it propagates with `?`              |
| `indexing_slicing`                              | `slice[i]` is unavailable; `.get(i)` returns `Option`, so absence enters the type either way |
| `panic`, `todo`, `unimplemented`, `unreachable` | There is no escape hatch that skips the error channel                                        |

**The PyO3 boundary is why.** `panic = "abort"` is deliberately not set in the release profile,
because a panic crossing the boundary is converted into a Python exception — at best. Aborting
would take the whole Gunicorn worker with it. The lints exist so that conversion is never
exercised in the first place; mapping is
[`../rust/PYO3-BOUNDARY.md`](../rust/PYO3-BOUNDARY.md)'s. Lints run through
`code/src/scripts/rust/lint.sh`.

This is the Rust spelling of a rule the Python side already carries: a guard **raises**, it never
asserts. Here it **returns `Err`**, it never panics.

**Which error class the `Err` becomes** follows [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)
unchanged: a parse failure on untrusted input at a trust boundary is a **user error** and lands in
the `ServiceError` tree as a 4xx; a domain object the code built wrong internally is a
**programmer error**, raised as `InvariantViolation` with its register key and surfaced as a 500.
A single `CryptoError` variant can be either, so the boundary that converts it decides — not the
crate that raised it.

---

## Ban `HashMap<String, Value>` and `serde_json::Value` in domain code

Deserialise directly into typed structs. A `serde_json::Value` in a domain signature is the
Rust spelling of the implicit-schema anti-pattern
([`ANTI-PATTERNS.md`](ANTI-PATTERNS.md) owns it), and the compiler stops helping the moment it
appears — every field access becomes a chain of `.get("...")` returning `Option<&Value>`, and
every typo is a runtime `None` instead of a build failure.

The full pattern at an untrusted boundary is three parts, and the third is the one that makes it
hold:

```rust
// wire/order.rs — mirrors the JSON on the network and nothing else.
use serde::Deserialize;

#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WireOrder {
    pub id: u64,
    pub status: String,
    pub total_pence: i64,
}

// The conversion is the only way in. This is where a parse becomes a domain object.
impl TryFrom<WireOrder> for Order {
    type Error = WireError;

    fn try_from(wire: WireOrder) -> Result<Self, Self::Error> {
        let status = wire
            .status
            .parse::<OrderStatus>()
            .map_err(|_| WireError::UnknownStatus(wire.status.clone()))?;
        Ok(Order { id: OrderId(wire.id), status, total: Pence(wire.total_pence) })
    }
}

// domain/order.rs — no serde derives anywhere on it.
pub struct Order {
    pub id: OrderId,
    pub status: OrderStatus,
    pub total: Pence,
}
```

`#[serde(deny_unknown_fields)]` is the serde analogue of `extra="forbid"` on this project's Ninja
request bodies ([`code/src/django/apps/core/schemas.py`](../../src/django/apps/core/schemas.py)):
a field the server started sending, or an attacker added, is a hard parse error rather than a
silently ignored key. Same doctrine, two languages.

The domain type having **no** serde derives is not tidiness — it is what makes it impossible to
accidentally deserialise straight into it. There is no `from_str` path to an `Order`; the only
constructor a caller can reach is the `TryFrom`, which means every `Order` in the process has
been through the conversion that enforces its invariants.

**Where the seam will sit in this project.** The desktop crate,
[`code/src/rust/crates/desktop/`](../../src/rust/crates/desktop/), is a peer of the web surface
and will consume the Django Ninja API at `/api/` exactly as any third-party client would
([`../DESKTOP.md`](../DESKTOP.md)) — it ships no HTTP client today. It is therefore the crate
where the first wire types land: a `wire` module beside the domain types, never mixed into them.

**The genuine exception** — an opaque payload this project does not own the vocabulary for —
is governed by the confinement policy and takes the marker, in full, with a reason:

```rust
// DICT-OK: opaque third-party webhook envelope — confined to wire::webhook
```

The policy and the marker are [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)'s, gated by
`code/src/scripts/audits/dict-discipline.sh`. A marker with no reason after the colon, or no
`confined to` clause, is itself a finding.

---

## The two type families, and the rule that keeps them apart

| Axis          | Wire type                              | Domain type                             |
| ------------- | -------------------------------------- | --------------------------------------- |
| Mirrors       | the JSON on the network                | the domain                              |
| serde derives | yes, plus `deny_unknown_fields`        | **none**                                |
| Shape         | may be ugly — flat, stringly, nullable | named fields, newtypes, enums with data |
| Invariants    | none; it is a parse target             | enforced in its constructor             |
| Changes when  | the API changes                        | the domain changes                      |
| Lives in      | `wire/`                                | `domain/`                               |

Merging them is the mistake, because the API's shape and the domain's shape **have different
reasons to change** — and a merged type inherits both. Every field the server renames drags the
domain behind it, and every domain refactor becomes a wire-compatibility question. The `TryFrom`
is where the two rates of change are absorbed, and it costs about twelve lines.

---

## What CI enforces

None of this rests on a reviewer noticing. `.github/workflows/syntax-rust.yml` runs three of
these scripts on any change under `code/src/rust/`; the fourth has its own workflow because its
surface is every language, not this one.

| Gate                                         | What it catches from this guide                                                                                       |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `code/src/scripts/rust/lint.sh`              | The whole deny table — an `.unwrap()`, a `slice[i]`, an `unreachable!()`. Clippy at `-D warnings`, so a warning fails |
| `code/src/scripts/rust/test.sh`              | The `TryFrom` conversions, which are the only place a domain invariant is provable                                    |
| `code/src/scripts/rust/audit.sh`             | Taking `serde` at all — a new crate is a supply-chain event before it is a type decision                              |
| `code/src/scripts/audits/dict-discipline.sh` | `HashMap<String, Value>` outside a `wire` module, and a `DICT-OK:` marker with no reason or no boundary               |

**Exhaustive matching is enforced by none of them, and that is the point.** A missing arm is a
`rustc` error, not a lint — it fails the build before any script runs, which is the earliest and
cheapest gate in the list. Reaching for `_ =>` is what moves the failure out of the compiler and
into a code review that may not happen.

---

## Cross-references

| Document                                                           | Covers                                                                                                                                     |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| [`../RUST.md`](../RUST.md)                                         | The workspace, the gate question ("does this need to be Rust?"), and the sub-document map                                                  |
| [`../rust/PYO3-BOUNDARY.md`](../rust/PYO3-BOUNDARY.md)             | The never-panic rule, error mapping into Python, type-conversion costs across the boundary                                                 |
| [`../rust/SUPPLY-CHAIN.md`](../rust/SUPPLY-CHAIN.md)               | **Adding `serde` is a supply-chain event**, gated by `cargo-deny` against `code/src/rust/deny.toml` — run `code/src/scripts/rust/audit.sh` |
| [`../DESKTOP.md`](../DESKTOP.md)                                   | The Slint surface that will consume `/api/`, and therefore hosts the first `wire` module                                                   |
| [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md)                             | The named anti-patterns this guide's rules defend against — stringly typed, primitive obsession, implicit schema, boolean blindness        |
| [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)                       | The confinement policy and the `DICT-OK:` escape hatch                                                                                     |
| [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)                     | The three-class error taxonomy an `Err` is mapped into, and the one-enforcement-point register                                             |
| [`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) | Section 3 — why branded ID types were **declined** on the TypeScript surface, and the trigger that revisits it                             |

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
