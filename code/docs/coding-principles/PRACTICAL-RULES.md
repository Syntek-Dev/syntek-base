---
type: guide
agent: code-reviewer
skills: [global-workflow]
model: opus
---

# Coding Principles — Practical Rules

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Practical coding rules: DRY, KISS, YAGNI, abstraction trade-offs

---

## DRY vs WET — The Rule of Three

Don't abstract prematurely. Duplication is acceptable the first and second time you write something.
On the **third occurrence**, refactor into a shared abstraction.

The wrong abstraction is worse than duplication: a premature abstraction forces every future use
into a shape that doesn't quite fit, creating complexity that's painful to undo.

---

## KISS — Keep It Simple

Resist unnecessary complexity. The simplest solution that works correctly is almost always the best.

Every abstraction must earn its place by making the code simpler overall. If adding a design pattern
makes one class cleaner but requires three new files and an interface, question whether the net
result is simpler.

---

## YAGNI — You Ain't Gonna Need It

Do not build for hypothetical future requirements. Ship what is needed now, refactor when actual
needs emerge.

Every feature that exists "just in case" has a maintenance cost from the moment it is written. When
the requirement does arrive, you will understand it better than you could have predicted.

YAGNI pairs with the Rule of Three: don't abstract until there are three real cases, and don't
build until there is a real need.

---

## Class vs Function

Use the simplest form that satisfies the requirement. Everything here is Python — the site is
server-rendered Django templates, so there is no second language with its own rules.

| Context                                               | Use      |
| ----------------------------------------------------- | -------- |
| Stateless utility or predicate                        | Function |
| Service with injected dependencies                    | Class    |
| Implements a Protocol (Policy, Strategy)              | Class    |
| Framework expects a class (view, permission, manager) | Class    |
| Custom `Exception` subclass                           | Class    |
| django-component                                      | Class    |
| Template filter or tag                                | Function |

---

## Decision Structuring: Boolean, Pattern Matching, Policy, and Strategy

Four tools exist for encoding decisions. Use the simplest one that fits.

### Boolean (if/elif/else)

Use plain conditionals when the check is simple, lives in one place, and carries no domain name.

```python
if not user.is_active:
    raise PermissionDenied("Account is inactive.")
```

When a boolean chain grows beyond two or three branches, or the same condition appears in more than
one place, reach for Policy or Strategy instead.

### Structural pattern matching

Reach for `match`/`case` (Python 3.10+) when a decision branches on the **shape** of a value —
destructuring a sequence, a mapping, or a class by its attributes — rather than testing independent
booleans. It replaces an `if`/`elif` chain that is really "inspect the structure, then unpack and
dispatch": decoding a tagged or union payload, parsing a command, walking an event or AST node.

```python
match event:
    case {"type": "click", "x": x, "y": y}:
        handle_click(x, y)
    case {"type": "key", "code": code}:
        handle_key(code)
    case _:
        raise ValueError(f"Unknown event: {event!r}")
```

Use it when each branch **binds and unpacks** part of the value and the set of shapes is closed and
known. Keep the match total — always end with a `case _:` wildcard so an unexpected shape fails
loudly rather than slipping through.

Prefer **polymorphism over `match`** when the alternatives are an open set of domain types that own
their behaviour (see [`./DESIGN-PRINCIPLES.md`](./DESIGN-PRINCIPLES.md)) — adding a type should not
force an edit to every `match`. Pattern matching is for closed, data-shaped unions where the
branching logic lives _outside_ the data: serialisers, interpreters, protocol decoders. Make a
`match` total with a `case _:` that raises, so an unhandled variant fails loudly rather than
falling through silently.

### Policy — what to do

A Policy encapsulates a business rule: a named decision about what is permitted, required, or
forbidden. Use a Policy when the rule has a name in the domain, appears in more than one place,
must be independently testable, or may be swapped without touching the calling code.

### Strategy — how to do it

A Strategy encapsulates an algorithm or implementation variant. Where a Policy says "MFA is
required to delete a record", a Strategy covers which kind of MFA and how to verify it.

Structurally, Policy and Strategy are identical — an interface with multiple implementations. The
distinction is semantic: the name carries the developer's intent.

### How they compose

Policy determines _whether_ an action is allowed; Strategy determines _how_ it is carried out. The
calling code reads as a sentence: the service enforces a Policy; the Policy delegates _how_ to the
Strategy.

### Quick decision guide

| Signal                                              | Use                         |
| --------------------------------------------------- | --------------------------- |
| One or two conditions, no reuse                     | `if`/`elif`/`else` inline   |
| Branching on the shape of a value, with unpacking   | `match`/`case` (closed set) |
| Named business rule, checked in two or more places  | Policy                      |
| Same operation, multiple implementations            | Strategy                    |
| Rule says _whether_; implementation varies by _how_ | Policy + Strategy composed  |

Apply the Rule of Three: do not extract to a Policy or Strategy until the logic appears in at least
two places, or the intent is clearly a named domain concern from the outset.

---

## Error Handling

Prefer explicit error handling over silent failures. Never swallow an error without logging it.

- Use custom exception types over generic ones.
- Every error message should answer: **what** went wrong, **why** it happened, and **what to do**.
- All HTTP API errors must return structured JSON: `{ "error": { "code": "...", "message": "..." } }`.

For language-specific error handling rules, see
[`../BACKEND-CODING-PRINCIPLES.md`](../BACKEND-CODING-PRINCIPLES.md) and
[`../FRONTEND-CODING-PRINCIPLES.md`](../FRONTEND-CODING-PRINCIPLES.md).

---

## Naming Conventions

- **Booleans** read as questions: `is_active`, `has_permission`, `can_retry`.
- **Functions and methods** are verbs: `get_user`, `validate_input`, `send_alert`.
- **Avoid abbreviations** unless universally understood (`url`, `id` are acceptable; `usr`, `mgr`
  are not).
- **No single-letter variables** except in tight loops (`i`, `j`) or mathematical contexts.
- **Database tables:** `snake_case`, plural nouns (e.g., `user_profiles`, `order_items`).
- **Environment variables:** `SCREAMING_SNAKE_CASE` (e.g., `DATABASE_URL`, `APP_SECRET_KEY`).

---

## Import Rules

**All imports must appear at the top of the file.** This rule applies to Python and CSS
(`@import`). Imports inside functions, methods, or classes are not permitted unless a narrow
justified exception applies.

Inline imports are harder to discover, harder to trace during debugging, and invisible to static
analysis tools.

### Justified exceptions

| Exception                        | Rule                                                                          |
| -------------------------------- | ----------------------------------------------------------------------------- |
| **Circular import resolution**   | Last resort — prefer refactoring the dependency or using dependency injection |
| **Optional / conditional deps**  | Guard with `try/except ImportError` at the call site                          |
| **Heavy imports on rare paths**  | Lazy importing to avoid penalising startup time — document the reason         |
| **`if TYPE_CHECKING:` (Python)** | Imports only needed for type annotations                                      |
| **Test-only mocking scope**      | In test files only, after patching — never in production code                 |

### What is NOT a justified exception

- Circular imports between internal modules — refactor the dependency instead.
- "It felt cleaner inside the function."
- "I haven't checked if it causes a circular import."

### Quick checklist

- [ ] All imports are at the top of the file, not inside functions, methods, or classes.
- [ ] Imports are grouped and ordered per the convention for the language.
- [ ] The only inline imports present match a justified exception, with a comment explaining which.
- [ ] Python: `AppConfig.ready()` and `RunPython` callables use deferred imports; all other code
      does not.

_Part of the `code/docs/` documentation family. See [`../CODING-PRINCIPLES.md`](../CODING-PRINCIPLES.md) for the full index._
