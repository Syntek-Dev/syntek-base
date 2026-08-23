---
type: guide
skills: [stack-react-native, test-writer, code-reviewer]
model: opus
---

# Types Over Dictionaries — TypeScript and React Native

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — discriminated unions, const objects and exhaustiveness on the mobile surface

**Mobile-only.** Present only in a project generated with the mobile surface.

The rule this guide applies is decided in
[`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md) and quoted once here:

> A dictionary is a data structure, not a type. When a set of keys is known at design time and
> carries meaning in the domain, it is a named type with named fields. Dictionaries are for keys
> that are genuinely data — unknown, dynamic, or supplied by the outside world.

What follows is how TypeScript expresses that, and which parts of the compiler already enforce
it. The named anti-patterns — stringly typed data, boolean blindness, nested dicts as poor
man's objects, the rest — belong to [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md) and are not restated
here in a TypeScript accent.

---

## Records are interfaces or type aliases, never `Record<string, unknown>`

A shape whose keys you can list is a type. Write the type.

```typescript
// Bad — every read is a guess, and nothing renames with the field.
function summarise(order: Record<string, unknown>): string {
  return `${String(order.reference)} — ${String(order.total)}`;
}

// Good — the shape is the contract, and the editor knows it.
interface OrderSummary {
  reference: string;
  total: number;
}
```

**`noUncheckedIndexedAccess` is the flag that makes this enforceable rather than merely
advisable.** Indexing a `Record<string, T>` yields `T | undefined`, always — the compiler cannot
know a string key is present, because nothing declared it. So every read of a dictionary-as-record
costs a guard the same read of a named field does not:

```typescript
function draftTotal(byKey: Record<string, OrderSummary>): number | null {
  const draft = byKey.draft; // OrderSummary | undefined — guard it, every time
  if (draft === undefined) {
    return null;
  }
  return draft.total;
}
```

That friction is not the flag being awkward. **It is the compiler telling you the dictionary is
wrong**, because it is being asked to prove something about a key that was never declared. The
correct response is a named field, never a `!` non-null assertion, which simply asserts the proof
the flag exists to demand.

The four flags beyond `strict` and the two deliberately declined are
[`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) Section 1's — read the table
there rather than a copy of it. All four are set in `code/src/mobile/tsconfig.json`.

---

## Closed sets: union of literals plus a const object

The enum test is [`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md)'s, whole:

> Use an enum when all three hold — the set of values is closed, it is known at design time, and
> behaviour branches on it.

Its counter-cases are that guide's too — user-defined tags, a DB-driven lookup that changes
without a deploy, a third party's vocabulary — and they belong in data on every surface, this one
included.

Where it passes, the house pattern is a `const` object plus a union derived from it:

```typescript
export const ORDER_STATUS = {
  DRAFT: "draft",
  PLACED: "placed",
  SHIPPED: "shipped",
} as const;

export type OrderStatus = (typeof ORDER_STATUS)[keyof typeof ORDER_STATUS];
```

You get one declaration, a type that narrows to exactly three literals, and a runtime object to
iterate when a picker needs the options.

**Not TypeScript's `enum`**, for three reasons that compound:

- It **emits a runtime object** — a reverse-mapped one for numeric enums — so a construct meant
  to describe data becomes shipped code.
- It is **nominally typed**, which fights structural JSON: a `"draft"` parsed from a response is
  not assignable to an enum member of the same value without a cast, and an unproven cast at that
  seam is precisely what Section _Parsing at the fetch boundary_ below refuses.
- `const enum`, the variant that avoids the emit, **does not survive Metro**: Babel transpiles
  each file alone, with no cross-file type information, so it cannot inline the members and emits
  the ordinary enum object anyway. Not a compiler claim — `isolatedModules` would state the same
  constraint to `tsc`, and it is off here, implied only by the declined `verbatimModuleSyntax`.

A literal union plus `as const` costs nothing at runtime and narrows precisely. There is no case
on this surface where the `enum` keyword wins.

### The `Record` that is not a violation

`code/src/mobile/lib/error-classes.ts` already ships the pattern:

```typescript
export type ErrorClass = "programmer" | "user" | "environment";
export const REPORTING: Record<ErrorClass, ReportingRule> = {/* ... */};
```

**That `Record` is a legitimate use, and the distinction matters.** It is a _total map keyed by a
closed union_, not a bag of string keys: the compiler checks completeness, so adding a fourth
class fails the build until `REPORTING` gains its row. Contrast `Record<string, ReportingRule>`,
which claims nothing, proves nothing, and hands back `| undefined` on every read. Same generic,
opposite guarantees — the key type is what separates them.

---

## Exhaustiveness — use the helper that already ships

`code/src/mobile/lib/invariant.ts` exports `unreachable(value: never, key: string): never`. Every
switch over a closed union ends in it.

```typescript
import { unreachable } from "@/lib/invariant";

function label(status: OrderStatus): string {
  switch (status) {
    case "draft":
      return "Draft";
    case "placed":
      return "Placed";
    case "shipped":
      return "Shipped";
    default:
      return unreachable(status, "order.status_is_known");
  }
}
```

It does two jobs, and they fail at different times:

- **Compile time.** The parameter is `never`, so widening `OrderStatus` breaks `typecheck.sh` at
  _every_ call site that has not handled the new member — not just the one someone remembered.
- **Run time.** The throw catches the same value arriving from the API, where the compiler never
  saw it. That is an `InvariantViolation` — a programmer error, a 500-equivalent on this surface,
  never a friendly message.

It is deliberately **not** called `assertNever`: `assert` is the banned mechanism
([`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)), and this raises a keyed error rather than
asserting a condition. The key is the register row's identifier in `how-to/src/INVARIANTS.md`.
The full reasoning is [`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md)
Section 2 and is not repeated here.

---

## Discriminated unions make illegal states unrepresentable

The TypeScript analogue of an enum-carrying-data. When a value is in one of several states and
each state has its own fields, one interface with optional fields encodes the state machine in
the _absence_ of data — which nothing can check.

```typescript
// Bad — 2^4 field combinations and two booleans, of which four states are real.
interface Upload {
  file?: File;
  progress?: number;
  url?: string;
  error?: string;
  isUploading: boolean;
  isDone: boolean;
}
```

Every reader must reconstruct the rules from the field names, and `isUploading && isDone` is
writable — the defect [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md) names, and diagnoses, there.
Discriminate instead:

```typescript
type Upload =
  | { kind: "idle" }
  | { kind: "uploading"; file: File; progress: number }
  | { kind: "done"; url: string }
  | { kind: "failed"; reason: string };
```

Each variant carries exactly what that variant has, and nothing else is reachable: inside
`case "done"`, `url` is a `string` — no guard, no `?.`. The illegal combinations are not merely
discouraged, they are unwritable, and the switch over `kind` closes with `unreachable()`.

**`exactOptionalPropertyTypes` is why the first version hurts.** With the flag set, an optional
property cannot be assigned an explicit `undefined`, so "clear it back to nothing" becomes a
delete or a rebuild rather than a one-line reset. Optional fields that encode a state machine are
precisely what that flag was set to make painful; a discriminated union makes the pain go away by
removing the fields, not by loosening the flag.

---

## Parsing at the fetch boundary

`response.json()` is declared `Promise<any>` by the DOM lib Expo's base config pulls in, so the
lie needs no cast to tell: `const order: OrderSummary = await response.json()` compiles in
silence, and every downstream guarantee inherits a proof nobody supplied. Annotate the result
`unknown` and the compiler stops accepting it. **The API client is the trust boundary**, and a
boundary parses.

```typescript
type Parsed<T> = { ok: true; value: T } | { ok: false; reason: string };

function parseOrderSummary(raw: unknown): Parsed<OrderSummary> {
  if (typeof raw !== "object" || raw === null) {
    return { ok: false, reason: "not an object" };
  }
  const { reference, total } = raw as Partial<Record<keyof OrderSummary, unknown>>;
  if (typeof reference !== "string" || typeof total !== "number") {
    return { ok: false, reason: "reference or total missing" };
  }
  return { ok: true, value: { reference, total } };
}
```

The single `as` inside the function is the whole point: it is confined to the one place that then
proves each field, and the caller receives a value it can trust or a reason it cannot. That is
the confinement policy applied — the cast does not escape the parser, and the caller needs no
undocumented keys ([`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)).

**Classify the failure, do not invent a class for it.** The parser returns `ok: false`; the API
client is what turns that into a thrown error, so a malformed payload reaches the existing
`classify()` in `code/src/mobile/lib/error-classes.ts` alongside transport and status failures —
one classifier, not a second private taxonomy. A shape the app _asked_ for and got wrong is its
own bug; a shape the _user_ got wrong never reaches here — nobody can author a response body.

**Stated honestly: no runtime schema validator is a declared dependency.** Zod and valibot are
both absent from `code/src/mobile/package.json`, and adding one is a stack change rather than a
routine bump: this tree is deliberately self-contained and the Expo SDK is a pinned, matched set,
so a dependency here rides a versioned template release (`code/src/mobile/CLAUDE.md`). The
baseline answer is a hand-written parse function per payload, tested like any other module.

**Trigger to revisit:** more than a handful of payloads. Past that the hand-written functions
become the duplication a validator exists to remove, and the ADR is worth writing.

---

## Identifiers: branded types stay declined

A branded (nominal) ID makes `UserId` and `OrderId` non-interchangeable despite both being
strings. [`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) Section 3 **declined
them at baseline**, and this guide does not reverse that. For reference, deferred:

```typescript
declare const brand: unique symbol;
export type Brand<T, B extends string> = T & { readonly [brand]: B };
export type UserId = Brand<string, "UserId">;
```

**The trigger it recorded:** brands arrive in the same change as the mobile API client, minted at
the single point that parses a response and nowhere else. A brand minted by `as UserId` on an
unvalidated payload asserts a proof it does not have — the TypeScript shape of the `assert` the
backend already bans.

The parse function in the section above **is** that point. When the API client lands, the trigger
has fired, and the decision is revisited **there** — as an amendment to
[`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) Section 3, which owns it. Not
here, and not before.

---

## What CI enforces

| Gate                                        | What it holds                                             |
| ------------------------------------------- | --------------------------------------------------------- |
| `code/src/scripts/mobile/typecheck.sh`      | `tsc --noEmit` — the flags, the unions, exhaustiveness    |
| `code/src/scripts/mobile/lint.sh`           | ESLint, including unused variables                        |
| `code/src/scripts/mobile/test.sh`           | Jest, and the coverage floors `lib/` counts toward        |
| `code/src/scripts/audits/negative-space.sh` | That the four `tsconfig.json` flags are still `true`      |
| `code/src/scripts/audits/stubs.sh`          | Stub markers in `*.ts`/`*.tsx` (`--file-type typescript`) |

The first two are also reachable as `syntax/lint.sh --file-type typescript` and
`syntax/check.sh --file-type typescript`, which delegate to them. CI invokes the owners
directly; the aggregate exists so one local command covers every surface.

ESLint owns unused variables, which is why `noUnusedLocals` and `noUnusedParameters` are
deliberately absent from `tsconfig.json` — one rule with two enforcers drifts, and the copy is
believed exactly as much as the original.

A dictionary that survives all of this carries the marker or it is a review blocker:

```typescript
// DICT-OK: opaque third-party payload — confined to the analytics adapter
```

The marker string is `DICT-OK: <reason> — confined to <boundary>`, and a marker with no reason
text after the colon is itself a finding. Gated by `code/src/scripts/audits/dict-discipline.sh`.

**Say the limit plainly: TypeScript's guarantees stop at the network.** A compile-clean, lint-clean
app can still receive a payload that violates every type it declares, because nothing at the wire
was type-checked by anything. That is not a gap in the gates — it is the reason the parse boundary
in Section _Parsing at the fetch boundary_ exists, and the reason `unreachable()` throws as well as
failing the build.

---

## Cross-references

| Concern                                                   | Owner                                                              |
| --------------------------------------------------------- | ------------------------------------------------------------------ |
| The core principle, the enum test                         | [`TYPES-OVER-DICTIONARIES.md`](TYPES-OVER-DICTIONARIES.md)         |
| The confinement policy and the `DICT-OK:` escape hatch    | [`TYPES-EXCEPTIONS.md`](TYPES-EXCEPTIONS.md)                       |
| The named anti-patterns and their fixes                   | [`ANTI-PATTERNS.md`](ANTI-PATTERNS.md)                             |
| Modelling the domain the types describe                   | [`DOMAIN-MODELLING.md`](DOMAIN-MODELLING.md)                       |
| Moving existing code onto these shapes                    | [`REFACTORING.md`](REFACTORING.md)                                 |
| The compiler flags, exhaustiveness, branded IDs, taxonomy | [`../MOBILE-CODING-PRINCIPLES.md`](../MOBILE-CODING-PRINCIPLES.md) |
| Invariants, the three error classes, the guard clause     | [`../NEGATIVE-SPACE.md`](../NEGATIVE-SPACE.md)                     |
| This project's invariant register                         | `how-to/src/INVARIANTS.md`                                         |
| The mobile tree's operating rules and scripts             | `code/src/mobile/CLAUDE.md`                                        |

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
