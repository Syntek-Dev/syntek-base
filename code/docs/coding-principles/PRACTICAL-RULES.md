---
type: guide
skills: [code-reviewer, global-workflow]
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

## Design Patterns in Refactoring

A pattern is applied to make **future change cheap along the axis where change is actually
expected**. Not for tidiness, and not because the result feels cleaner. It earns its place when it
converts an **invasive** edit into an **additive** one: adding the next variant means writing new
code, not editing existing code in three places. The second benefit is real but smaller — a
recognisable Strategy or Adapter is **shared vocabulary**, telling the next reader where a new
variant belongs without reverse-engineering the design first. A refactor that does neither has
bought indirection and nothing else, and must not happen. **"It's cleaner" is not a justification**
— it is the absence of one, and it is what tells you when to stop abstracting.

### The trigger rule

Before any refactor that abstracts, unifies, extracts, or deduplicates a function, method, or
class, state two things:

1. **The axis of change** it absorbs — what varies, with evidence that it varies.
2. **The pattern** being applied, by name — or that none applies and why plain extraction is
   enough.

Plain extraction is the honest answer more often than not: lifting a named helper out of a long
method absorbs no axis and needs no pattern. If you cannot name a concrete axis with evidence it is
real, **do not abstract**. Where a well-known pattern fits, use it and use its published name —
never invent a bespoke structure in its place, because a nameless one has to be re-read before it
can be understood.

### When not to abstract

- **The Rule of Three applies unchanged** (_DRY vs WET_, above). Two similar call sites are a
  coincidence; three are a pattern. Never unify on the second occurrence.
- **Incidental duplication stays duplicated.** Code that looks alike but changes for different
  reasons is not duplication. Unify by **reason to change**, never by shape — two services that
  both build a six-field dict today will diverge the moment one gains a seventh.
- **A wrong abstraction costs more than the duplication it replaced.** Duplication is visible and
  cheap to undo. A bad abstraction hides its cost behind an interface every caller now depends on,
  and undoing it means touching all of them.
- **Prefer the simplest thing that removes the actual pain** — the pain you can point at, not the
  one you anticipate (_YAGNI_, above).

### Smell to pattern

| Smell                                              | Pattern                           |
| -------------------------------------------------- | --------------------------------- |
| Branching on a type or mode to pick behaviour      | Strategy                          |
| Long `if`/`elif` or `match` on an object's state   | State                             |
| Same skeleton, differing steps                     | Template Method                   |
| Callers coupled to concrete construction           | Factory Method / Abstract Factory |
| Optional behaviour bolted onto an existing object  | Decorator                         |
| Incompatible third-party or legacy interface       | Adapter                           |
| Callers wrestling with a sprawling subsystem       | Facade                            |
| Cross-cutting concern (caching, auth, logging)     | Proxy or middleware               |
| Recursive tree handled with special-cased leaves   | Composite                         |
| Telescoping constructors, long parameter lists     | Builder                           |
| Hard-wired collaborators blocking tests            | Dependency injection              |
| Data-access queries scattered across services      | Repository                        |
| `None` checks repeated at every call site          | Null Object                       |
| Two dimensions of variation multiplying subclasses | Bridge                            |

Three rows are genuinely ambiguous in this stack:

- **Strategy vs State.** A Strategy is chosen by the caller and stays put; a State replaces itself
  as the object transitions. If the object decides its own next behaviour, it is State.
- **Proxy vs middleware.** A per-object concern (a caching wrapper around one collaborator) is a
  Proxy; a per-request concern is Django middleware, ordered in `settings.MIDDLEWARE`
  ([`../architecture/SERVICE-AND-MIDDLEWARE.md`](../architecture/SERVICE-AND-MIDDLEWARE.md)).
- **Repository vs the ORM.** Django's `Manager` and `QuerySet` **are** the repository. Express the
  pattern as a custom manager or a queryset method; a separate repository class over the ORM is a
  second abstraction across the same seam.

A **Policy** is a Strategy whose axis is a business rule rather than an algorithm
(_Decision Structuring_, above) — the same object under a narrower name, not a fifteenth row.

### The decision record

A chosen pattern carries a note of one or two sentences — a docstring on the interface, or a line
in the PR body — stating three things: **the pattern**, **the axis of change** it absorbs, and
**what would have to become true to remove it again**. That third clause is the only thing that
lets a future reader delete an abstraction whose axis has gone away.

```python
class ExportFormatter(Protocol):
    """Strategy — axis: output format (CSV, XLSX, PDF), one per download type.

    Remove and inline if the product ever settles on a single export format.
    """
```

### Review checklist

Before opening a refactor PR, every answer is yes:

- [ ] Can I name the axis of change this absorbs, in one sentence?
- [ ] Is there evidence that axis is real — three existing consumers, or a committed requirement?
- [ ] Can a new variant be added by writing new code, without editing existing code?
- [ ] Does the abstraction carry the pattern's published name, discoverable from the class or
      module name?
- [ ] Is the decision record written, including what would justify removing it?
- [ ] Would removing this abstraction make the code worse, rather than merely different?

---

## Error Handling

Prefer explicit error handling over silent failures. Never swallow an error without logging it.

- Use custom exception types over generic ones.
- Every error message should answer: **what** went wrong, **why** it happened, and **what to do**.
- All HTTP API errors return one structured JSON envelope, owned by
  [`../api-design/AUTH-AND-ERRORS.md`](../api-design/AUTH-AND-ERRORS.md) — _The error envelope_.
  It is stated there and nowhere else; this guide is framework-neutral and the envelope is not.

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
