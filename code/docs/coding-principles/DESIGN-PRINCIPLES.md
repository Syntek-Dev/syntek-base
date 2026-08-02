---
type: guide
agent: code-reviewer
skills: [global-workflow]
model: opus
---

# Coding Principles — Design Principles

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Pike, Torvalds, SOLID design philosophy for code review

---

## Rob Pike's 5 Rules of Programming

**Rule 1 — Don't guess bottlenecks.** Bottlenecks occur in surprising places. Do not second-guess
and add speed hacks until you know where the bottleneck actually is.

**Rule 2 — Measure before tuning.** Do not tune for speed until you have measured. Even then, do
not tune unless one part of the code overwhelms the rest.

**Rule 3 — Fancy algorithms are slow when N is small.** Fancy algorithms have big constants. Until
you know that N is frequently large, don't get fancy. Even if N does get large, apply Rule 2 first.

**Rule 4 — Fancy algorithms are buggy.** Use simple, reusable, and easy-to-maintain algorithms.
Use simple data structures too.

**Rule 5 — Data structures dominate.** If you have chosen the right data structures and organised
things well, the algorithms will almost always be self-evident.

---

## Linus Torvalds' Coding Rules

**Rule 1 — Data structures over algorithms.** Focus on how data is organised. A solid data model
often eliminates the need for complex, messy code.

**Rule 2 — Good taste in coding.**

- Remove special cases: good code eliminates edge cases rather than adding `if` statements for them
- Simplify logic: avoid tricky expressions or deeply nested control flows
- Reduce branches: fewer conditional statements make code faster and easier to reason about

**Rule 3 — Readability and maintainability.**

- Short functions: functions do one thing and fit on one or two screenfuls of text
- Descriptive names: variables and functions should be descriptive but concise
- Avoid excessive indentation: deep nesting makes code hard to read

**Rule 4 — Code structure and style.** Avoid multiple assignments on a single line. One operation
per statement — clarity beats cleverness.

**Rule 5 — Favour stability over complexity.** Do not do something clever just because you can.
Stability and predictability are more valuable than clever or novel approaches.

**Rule 6 — Make it work, then make it better.** Get it working first, then optimise.

---

## SOLID Principles

**S — Single Responsibility.** A class or module should have only one reason to change.

**O — Open/Closed.** Open for extension but closed for modification. Add behaviour through new
code rather than rewriting existing, tested code.

**L — Liskov Substitution.** Subtypes must be substitutable for their base types without breaking
correctness.

**I — Interface Segregation.** Clients should not be forced to depend on interfaces they do not
use. Prefer many small, focused interfaces over one large one.

**D — Dependency Inversion.** High-level modules should not depend on low-level modules; both
should depend on abstractions. Inject dependencies rather than instantiating them directly.

**When SOLID helps most:** designing service layers, structuring Django apps, anywhere you need to
swap implementations (testing, feature flags).

**When to be cautious:** SOLID can lead to premature abstraction. Apply the Rule of Three before
extracting abstractions.

---

## CUPID Properties

**C — Composable.** Small, focused units that combine easily, with clear inputs and outputs and no
hidden side effects.

**U — Unix philosophy.** Do one thing well. Simple, focused components with clear boundaries.

**P — Predictable.** Deterministic behaviour, few surprises, easy to reason about.

**I — Idiomatic.** Code follows the conventions and patterns of its language and ecosystem.

**D — Domain-based.** Code is structured around the problem domain, not around technical layers.

---

## GRASP Patterns

**Information Expert.** Assign responsibility to the class that has the most relevant data.

**Creator.** Assign object creation to the class that has the initialising data, aggregates the
object, or closely uses it.

**Controller.** Django views and Django Ninja routers coordinate but do not contain business logic.

**Low Coupling.** Minimise dependencies between classes. A change in one should affect as few
others as possible.

**High Cohesion.** Keep related responsibilities together. A `UserService` handling authentication,
profile updates, email preferences, and billing has low cohesion — split it.

**Polymorphism.** When behaviour varies by type, use polymorphism rather than conditional logic.

**Indirection.** Introduce an intermediate object to mediate between two components and reduce
direct coupling.

**Pure Fabrication.** When no domain object is a natural fit, create a service class that exists
purely to maintain cohesion and low coupling elsewhere.

**Protected Variations.** Wrap external APIs, third-party libraries, and volatile business rules
behind interfaces so changes don't ripple through the codebase.

---

## Kent Beck's Four Rules of Simple Design

In priority order:

1. **Passes all tests.** The code works. Non-negotiable baseline.
2. **Reveals intention.** A reader can understand what the code does and why without documentation.
3. **Has no duplication.** Every piece of knowledge has a single authoritative representation.
4. **Has the fewest elements.** Remove anything that does not serve rules 1–3.

---

## Domain-Driven Design Fundamentals

**Ubiquitous Language.** Use the same terms in code, documentation, and conversation with
stakeholders. If the business calls it a "booking", the code calls it a "booking".

**Bounded Contexts.** Draw explicit boundaries around different models of the same concept. In
Django, this maps to separate apps with clear interfaces between them.

**Aggregates.** A cluster of domain objects treated as a single unit for data changes. External
code interacts with the aggregate root, never directly with its internals.

**Domain Events.** When something significant happens in the domain, emit an event. Events decouple
the trigger from the response.

**Anti-Corruption Layer.** When integrating with external systems, create a translation layer that
maps their model into yours. Never let external API shapes leak into your domain model.

---

## Package and Module Principles

**Cohesion:**

- **Reuse-Release Equivalence.** The unit of reuse is the unit of release — properly versioned,
  documented, and released.
- **Common Closure.** Classes that change together belong together. Group code by reason for change.
- **Common Reuse.** Classes that are used together belong together. Don't force consumers to depend
  on things they don't need.

**Coupling:**

- **Acyclic Dependencies.** The dependency graph between packages must have no cycles.
- **Stable Dependencies.** Depend in the direction of stability. Volatile code depends on stable
  code, not the reverse.
- **Stable Abstractions.** Stable packages should consist primarily of interfaces and abstract
  classes — open for extension without requiring modification.

---

## The Law of Demeter

An object should only talk to its immediate collaborators, not reach through chains of objects.

**Bad:** `order.getCustomer().getAddress().getCity()`

**Good:** `order.getShippingCity()`

In Django Ninja response schemas, flatten where possible. In Django, avoid chaining through related
objects in views or templates.

---

## Stamp Coupling — Pass Only What Is Needed

**Stamp coupling** is when a function receives a whole composite object — a model instance, a large
DTO, the `request` — but reads only one or two of its fields. The callee now depends on the entire
shape: it is harder to test (you must construct the full object), harder to reuse (it is welded to
that type), and exposed to unrelated changes in fields it never touches.

Prefer **data coupling** — pass the specific values the callee actually uses:

```python
# Stamp coupling — takes the whole user to read one field
def format_greeting(user: User) -> str:
    return f"Hello, {user.first_name}"

# Data coupling — depends only on what it uses
def format_greeting(first_name: str) -> str:
    return f"Hello, {first_name}"
```

Pass the whole object **only when it is genuinely warranted**: the function uses most of the fields,
the object is the domain aggregate the function operates on, or extracting values would mean
threading four or more arguments — at which point a deliberate, named parameter object (see
[`../data-structures/REFACTORING.md`](../data-structures/REFACTORING.md)) is the right tool, not
accidental stamp coupling. The test: if you would not hand the whole object to a stranger to do this
one job, do not hand it to this function either.

---

## The Twelve-Factor App

I. One codebase in version control, many deploys.
II. Explicitly declare and isolate dependencies. Commit lock files.
III. Store configuration in the environment. Never hardcode.
IV. Treat backing services as attached resources — swap by changing a URL.
V. Strictly separate build, release, and run stages. A release is immutable.
VI. App is stateless processes. Session state belongs in a backing service.
VII. The app is self-contained and binds to a port.
VIII. Scale out via the process model.
IX. Fast startup and graceful shutdown. Handle SIGTERM gracefully.
X. Keep development, staging, and production as similar as possible.
XI. Treat logs as event streams. Write to stdout; the environment routes them.
XII. Run admin tasks as one-off processes in the same environment as the app.

_Part of the `code/docs/` documentation family. See [`../CODING-PRINCIPLES.md`](../CODING-PRINCIPLES.md) for the full index._
