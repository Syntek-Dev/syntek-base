---
type: guide
skills: [stack-react-native]
model: opus
---

# Mobile Coding Principles — TypeScript, Exhaustiveness, and Failing Loudly on a Device

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — compiler configuration, exhaustiveness, the mobile error expression

**MOBILE-ONLY.** This guide and the tree it governs are absent from a project generated without
the mobile surface.

The mobile peer of [`BACKEND-CODING-PRINCIPLES.md`](BACKEND-CODING-PRINCIPLES.md) and
[`FRONTEND-CODING-PRINCIPLES.md`](FRONTEND-CODING-PRINCIPLES.md) — both of which are Django's,
despite the second one's name. Read with the framework-neutral
[`CODING-PRINCIPLES.md`](CODING-PRINCIPLES.md).

This guide owns **how the mobile surface expresses** the rules in
[`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md). It never restates them: what an invariant is, the
three-class taxonomy, and the one-enforcement-point rule are all decided there and cited here.

---

## 1. The compiler is the cheapest enforcement point this surface has

`tsc --noEmit` is one of the few gates that runs on every push and pull request, with no path
filter, on both this repository and a generated project. A rule the compiler can hold is a rule
nobody has to remember, so the configuration is where mobile negative space starts.

### The flags, and what each one makes impossible

All four live in `code/src/mobile/tsconfig.json`. **`strict` implies none of them, and
`expo/tsconfig.base` sets none.**

| Flag                         | What stops being writable                                                        |
| ---------------------------- | -------------------------------------------------------------------------------- |
| `noUncheckedIndexedAccess`   | Reading `items[0]` as if the element must exist. It is `T \| undefined`          |
| `exactOptionalPropertyTypes` | Passing an explicit `undefined` where a property is merely optional              |
| `noImplicitReturns`          | A function that returns a value down one branch and falls off the end of another |
| `noFallthroughCasesInSwitch` | A `case` that silently runs the next one                                         |

Each bans a **state**, which is what earns it a place here. That is also the test for adding a
fifth: a flag that enforces a style is a lint rule, not an invariant.

**All four stay `true`.** **[gate: fail]** (`ts-flags-loosened`) They are the "single config"
deletion class: `tsc` exits 0 without them, so a flag loosened to clear a build is invisible in
every gate that runs. `audits/negative-space.sh` asserts their presence — the audit leg the
standing constraint demands of anything in that class.

### Deliberately not set, and why

| Flag                                          | Why not                                                                     |
| --------------------------------------------- | --------------------------------------------------------------------------- |
| `noUnusedLocals` · `noUnusedParameters`       | ESLint's `no-unused-vars` already owns it — two enforcers of one rule drift |
| `erasableSyntaxOnly` · `verbatimModuleSyntax` | Module and syntax discipline, not correctness                               |
| `noPropertyAccessFromIndexSignature`          | A style preference about dot versus bracket access                          |

The first row is the one that matters. A rule enforced twice is a rule that changes in one place
and not the other, and the copy is believed exactly as much as the original.

### The cost, stated honestly

All four were probed against the baseline before being adopted, and the baseline compiled clean.
**That proves very little** and should not be quoted as though it does: the tracked tree is a
handful of files. `noUncheckedIndexedAccess` in particular will be felt on the first screen that
maps over an API list, and the correct response is a length check or a guard, never a `!`
non-null assertion — that re-introduces exactly the unproven claim the flag exists to remove.

---

## 2. Exhaustiveness — the compiler and the runtime, not one or the other

A union type tells the compiler which cases exist. It cannot tell it what the server actually
sent. Both halves are needed, and they fail at different times.

`code/src/mobile/lib/invariant.ts` ships two things: `InvariantViolation`, the surface's
programmer-error type, and `unreachable()`, the guard.

```ts
import { unreachable } from "@/lib/invariant";

type OrderStatus = "draft" | "placed" | "shipped";

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

Adding a member to `OrderStatus` now fails `typecheck.sh` at **every** call site that has not
handled it, because `unreachable()` takes `never`. The throw is what catches the same value
arriving from the API at runtime, where the compiler never saw it.

**The key is the register row's identifier**, exactly as on the backend, so a tracker event names
which invariant failed rather than only where. Register: `how-to/src/INVARIANTS.md`.

**It is not called `assertNever`.** `assert` is the banned mechanism
([`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) Section _The guard clause_), and this raises a keyed error
rather than asserting a condition. The name states the situation, not the technique.

---

## 3. Identifiers stay plain strings, until there is a boundary that proves otherwise

Branded (nominal) ID types were considered and **declined at baseline**. A brand is only worth
what the boundary that mints it can prove, and this surface has no such boundary yet: there is no
API client, no fetch layer, and no schema validation. A brand minted by `as UserId` on an
unvalidated response is a cast asserting a proof it does not have — the TypeScript shape of the
`assert` the backend already bans.

**Trigger to revisit, recorded rather than left to memory:** brands arrive in the same change as
the mobile API client, minted at the single point that parses a response and nowhere else. Adopt
them before that and every call site inherits a false guarantee.

The decline is **narrow, and does not extend to records.** An identifier stays a plain `string`;
a set of keys known at design time is still a named `interface` or a discriminated union, and a
closed set of values is still a literal union over an `as const` object. That standard, and the
parse function whose arrival fires the trigger above, are
[`data-structures/TYPES-TYPESCRIPT.md`](data-structures/TYPES-TYPESCRIPT.md).

---

## 4. How this surface expresses the error taxonomy

The three classes are [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md)'s. **What differs on a device is
which class is the common one.**

| Class                 | On this surface                                                | What the user gets                        |
| --------------------- | -------------------------------------------------------------- | ----------------------------------------- |
| **Programmer error**  | `InvariantViolation` thrown in app code, or a 5xx from the API | The error screen, and a report            |
| **User error**        | A 4xx the screen can act on — validation, permission, conflict | An inline message on the field or screen  |
| **Environment error** | Offline, timeout, DNS, a dropped connection, or a 503          | A retry affordance, never an error report |

**The inversion worth stating plainly:** on the server an environment error is unusual. On a
phone it is the ordinary case — a train tunnel is not a defect. Reporting every failed request
is how a mobile error tracker becomes noise, and a noisy tracker is a muted one.

A **5xx is the server's** programmer error, not the app's. The app shows the error screen and
reports that it saw one; it never files the server's bug as its own.

### The four statuses that mean "you did not reach the application"

`lib/error-classes.ts` is the classifier, and its one non-obvious rule is that **408, 502, 503
and 504 are environment errors despite three of them being 5xx**. Each is the edge saying the
process behind it is not answering, or a timeout the server noticed first — the same fact as
being offline, not a defect in anyone's code. Without the carve-out, every request landing in a
rolling deploy's restart window is filed as a bug, which is how the tracker fills with noise and
then gets muted.

The default runs the other way, and deliberately: **an unrecognised failure is a programmer
error.** Defaulting to `environment` would silence exactly the failures nobody has thought about
yet, which are the ones worth hearing about.

### One error boundary, at the root

`expo-router` exports `ErrorBoundary`; a route or layout file exporting it is wrapped
automatically, and the component receives `{ error, retry }`.

**It belongs in `app/_layout.tsx` and nowhere else.** Per-screen boundaries protect the screens
someone thought would fail, and the screen nobody expected to fail is the one that will — the
same reasoning that gave the web one global HTMX handler rather than per-element ones
([`rendering/PITFALLS-AND-EXAMPLES.md`](rendering/PITFALLS-AND-EXAMPLES.md)). A screen may
override it only where it can genuinely recover better than the root can.

### The tracker is declared, not wired

No error-reporting SDK is a dependency of this surface, deliberately. The Expo SDK is a matched
set of pins and adding to it is a versioned template release rather than a routine bump
(`code/src/mobile/CLAUDE.md`).

What the doctrine fixes now is **what must be reported when one exists**: every programmer error,
once per event; environment errors aggregated, never per occurrence; user errors never. The same
three rows the backend already follows.

**Trigger:** the SDK arrives with the first build that ships to a store, because an unreported
crash on a device is invisible in a way a server error never is — there are no logs to read.

### `X-Request-ID`

The API sets one on every response ([`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) Section _The error
taxonomy_). This surface **holds the most recent one**, shows it on the error screen, and attaches
it to the report — a user saying "it broke" is then one identifier away from the event.

The rule is conditional and the condition matters: a **render** error has no request behind it,
so there is nothing to show. Display it when the failure came from a request, and show nothing
rather than a stale identifier from an unrelated one.

---

## 5. What is not built yet

Shipped at baseline: the four flags, `lib/invariant.ts`, and `lib/error-classes.ts` — each with
tests, and each verified by gates that run here.

**The line these three sit on:** what a failure _is_ can be decided without knowing how the
project looks or speaks, so it ships. What the user _sees_ cannot, so it does not.

| Not built                | Why it waits                                                             |
| ------------------------ | ------------------------------------------------------------------------ |
| The root `ErrorBoundary` | Needs an error screen to render                                          |
| The error screen         | Needs the token module and brand-voice copy, neither of which exists yet |
| The request-ID holder    | Needs the API client that would receive the header                       |

Building them now would mean inventing the mobile frontend baseline rather than documenting it.
`classify()` is what they will each be built on, so the taxonomy is settled before the screen
that expresses it exists — the opposite order from the one that produces three screens
disagreeing about what counts as an error.

---

## What this guide does not own

| Concern                                              | Owner                                    |
| ---------------------------------------------------- | ---------------------------------------- |
| What an invariant is, the taxonomy, the guard clause | [`NEGATIVE-SPACE.md`](NEGATIVE-SPACE.md) |
| This project's actual invariants                     | `how-to/src/INVARIANTS.md`               |
| Expo, expo-router, StyleSheet and testing idioms     | `.claude/skills/stack-react-native/`     |
| The tree's operating rules and the scripts           | `code/src/mobile/CLAUDE.md`              |
| Token-first styling on this surface                  | `design-tokens/MOBILE.md`                |
| WCAG 2.2 AA techniques for React Native              | `accessibility/MOBILE.md`                |
| Platform conformance and adaptivity                  | `visual-design/MOBILE.md`                |
| Records, unions and the parse boundary in TypeScript | `data-structures/TYPES-TYPESCRIPT.md`    |

_Part of the `code/docs/` documentation family._
