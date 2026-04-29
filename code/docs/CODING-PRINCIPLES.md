# Coding Principles

> **Agent hints — Model:** Sonnet

**Last Updated**: 22/03/2026 **Version**: 1.11.0 **Maintained By**: Development Team **Language**:
British English (en_GB) **Timezone**: Europe/London

---

## Table of Contents

- [Overview](#overview)
- [File Length](#file-length)
- [Rob Pike's 5 Rules of Programming](#rob-pikes-5-rules-of-programming)
- [Linus Torvalds' Coding Rules](#linus-torvalds-coding-rules)
- [SOLID Principles](#solid-principles)
- [CUPID Properties](#cupid-properties)
- [GRASP Patterns](#grasp-patterns)
- [The Unix Philosophy](#the-unix-philosophy)
- [Kent Beck's Four Rules of Simple Design](#kent-becks-four-rules-of-simple-design)
- [Domain-Driven Design Fundamentals](#domain-driven-design-fundamentals)
- [Package and Module Principles](#package-and-module-principles)
- [The Law of Demeter](#the-law-of-demeter)
- [The Twelve-Factor App](#the-twelve-factor-app)
- [DRY vs WET — The Rule of Three](#dry-vs-wet--the-rule-of-three)
- [KISS — Keep It Simple](#kiss--keep-it-simple)
- [YAGNI — You Ain't Gonna Need It](#yagni--you-aint-gonna-need-it)
- [Error Handling](#error-handling)
- [Naming Conventions](#naming-conventions)
- [Import Rules](#import-rules)
- [Testing](#testing)
- [Comments and Documentation](#comments-and-documentation)
- [Security](#security)
- [Dependencies](#dependencies)
- [Git and Version Control](#git-and-version-control)
- [Logging](#logging)
- [Code Review Checklist](#code-review-checklist)

---

## Overview

These principles apply to **all code** in this project. Read and apply them before writing or
reviewing any code. They are derived from two of the most influential systems programmers — Rob Pike
(co-creator of Go) and Linus Torvalds (creator of Linux) — and extended with practical rules for web
application development.

---

## File Length

Each coding file should be a maximum of **750 lines** with a grace of 50 lines. This includes
comments. If a file exceeds 750 lines (or the grace lines), break it into modules and import them
into a central file.

---

## Rob Pike's 5 Rules of Programming

> Originally from "Notes on Programming in C" (1989), cited widely in the Go community.

**Rule 1 — Don't guess bottlenecks** You cannot tell where a programme will spend its time.
Bottlenecks occur in surprising places. Do not second-guess and add speed hacks until you know where
the bottleneck actually is.

**Rule 2 — Measure before tuning** Do not tune for speed until you have measured. Even then, do not
tune unless one part of the code overwhelms the rest.

**Rule 3 — Fancy algorithms are slow when N is small** Fancy algorithms are slow when N is small,
and N is usually small. Fancy algorithms have big constants. Until you know that N is frequently
large, don't get fancy. Even if N does get large, apply Rule 2 first.

**Rule 4 — Fancy algorithms are buggy** Fancy algorithms are more complex and much harder to
implement correctly. Use simple, reusable, and easy-to-maintain algorithms. Use simple data
structures too.

**Rule 5 — Data structures dominate** Data dominates. If you have chosen the right data structures
and organised things well, the algorithms will almost always be self-evident. Data structures are
central to programming — not algorithms.

---

## Linus Torvalds' Coding Rules

> Derived from Linus Torvalds' coding style documents, talks, and mailing list contributions.

**Rule 1 — Data structures over algorithms** _"Show me your flowcharts and conceal your tables, and
I shall continue to be mystified. Show me your tables, and I won't usually need your flowcharts;
they'll be obvious."_

Focus on how data is organised. A solid data model often eliminates the need for complex, messy
code. The logic naturally follows from the structure.

**Rule 2 — Good taste in coding**

- Remove special cases: good code eliminates edge cases rather than adding `if` statements for them
- Simplify logic: avoid tricky expressions or complex, deeply nested control flows
- Reduce branches: fewer conditional statements make code faster and easier to reason about

**Rule 3 — Readability and maintainability**

- Short functions: functions do one thing, are short, and fit on one or two screenfuls of text
- Descriptive names: variables and functions should be descriptive but concise
- Avoid excessive indentation: deep nesting makes code hard to read

**Rule 4 — Code structure and style**

- Avoid multiple assignments on a single line
- One operation per statement — clarity beats cleverness

**Rule 5 — Favour stability over complexity** Do not do something clever just because you can.
Stability and predictability are more valuable than clever or novel approaches.

**Rule 6 — Make it work, then make it better** Get it working first, then optimise. Do not
over-optimise during initial implementation. All code should be maintainable by anyone, not just the
original author.

---

## SOLID Principles

> Five object-oriented design principles popularised by Robert C. Martin ("Uncle Bob"). SOLID
> provides prescriptive rules for structuring classes and dependencies. It works best in languages
> with interfaces and inheritance (TypeScript, Python with protocols/ABCs) but the thinking applies
> broadly.

**S — Single Responsibility Principle.** A class or module should have only one reason to change.
Each unit owns one piece of functionality. If a class handles both payment processing and email
notifications, those are two reasons to change — split them.

**O — Open/Closed Principle.** Software entities should be open for extension but closed for
modification. Add behaviour through new code (new classes, new implementations) rather than
rewriting existing, tested code. Strategy patterns, plugin architectures, and middleware pipelines
are common ways to achieve this.

**L — Liskov Substitution Principle.** Subtypes must be substitutable for their base types without
breaking correctness. If a function accepts a base type, every subtype must honour the same contract
— same preconditions, same postconditions, no surprises. Violating this creates fragile hierarchies
where swapping implementations causes hidden breakage.

**I — Interface Segregation Principle.** Clients should not be forced to depend on interfaces they
do not use. Prefer many small, focused interfaces over one large one. A `PaymentProcessor` interface
that also includes `generateReport()` forces every implementation to deal with reporting even if it
has nothing to report.

**D — Dependency Inversion Principle.** High-level modules should not depend on low-level modules;
both should depend on abstractions. In practice: inject dependencies rather than instantiating them
directly. A Django service class should accept a payment gateway interface, not import Stripe
directly at the top of the file.

**When SOLID helps most:** designing service layers, building plugin systems, structuring Django
apps and TypeScript modules, and anywhere you need to swap implementations (testing, multi-tenancy,
feature flags).

**When to be cautious:** SOLID can lead to premature abstraction if applied dogmatically. If there
is only one implementation and no foreseeable second, an interface adds indirection without value.
Apply the Rule of Three (see DRY vs WET) before extracting abstractions.

---

## CUPID Properties

> Proposed by Daniel Terhorst-North (originator of BDD) as a properties-based complement to SOLID.
> Where SOLID is prescriptive ("structure your code this way"), CUPID is descriptive ("good code
> tends to have these qualities"). CUPID applies equally to object-oriented, functional, scripting,
> and infrastructure code.

**C — Composable.** Code plays well with others. Small, focused units that combine easily, with
clear inputs and outputs. A composable function takes arguments and returns values without hidden
side effects. A composable Django app can be dropped into any project without dragging in unrelated
dependencies.

**U — Unix philosophy.** Do one thing well. Simple, focused components with clear boundaries —
echoing the Unix tradition of small, pipeable tools. A management command that both fetches data and
transforms it is doing two things. Split them and compose them.

**P — Predictable.** Code does what you expect. Deterministic behaviour, few surprises, easy to
reason about. A function called `get_user()` should not silently create a user if one doesn't exist.
Predictable code builds trust and makes debugging straightforward.

**I — Idiomatic.** Code follows the conventions and patterns of its language and ecosystem. It looks
like it belongs. Pythonic Django code uses querysets and managers, not raw SQL wrapped in utility
functions. Idiomatic Rust uses ownership and borrowing, not `unsafe` blocks everywhere. Idiomatic
TypeScript uses the type system, not `any`.

**D — Domain-based.** Code is structured around the problem domain, not around technical layers.
Names, boundaries, and organisation reflect what the software does, not how it's built. A module
called `payments` is more useful than one called `services`. A GraphQL schema that mirrors the
business language is easier for everyone to work with.

**Use CUPID as a sanity check:** after applying SOLID, DRY, or any other principle, ask — is this
code composable, predictable, idiomatic, and domain-aligned? If not, something has gone wrong
regardless of which rules were followed.

---

## GRASP Patterns

> General Responsibility Assignment Software Patterns, from Craig Larman's work on object-oriented
> analysis and design. GRASP provides nine patterns for deciding which object should be responsible
> for what. Particularly useful during domain modelling and when designing Django
> model/service/serialiser layers or GraphQL resolvers.

**Information Expert.** Assign responsibility to the class that has the most relevant data. If
`Order` has all the line items, `Order` should calculate the total — not an external
`OrderCalculator` service.

**Creator.** Assign object creation to the class that has the initialising data, aggregates the
object, or closely uses it. If `ShoppingCart` contains `CartItem` objects, `ShoppingCart` is the
natural place to create them.

**Controller.** Assign the responsibility of handling a system event to a class that represents the
overall system or a use-case scenario. In Django, this maps to views and API viewsets. In GraphQL,
this maps to mutation resolvers. The controller coordinates but does not contain business logic.

**Low Coupling.** Minimise dependencies between classes. A change in one class should affect as few
others as possible. Low coupling makes code easier to test, reuse, and refactor.

**High Cohesion.** Keep related responsibilities together within a single class or module. A class
with high cohesion does a small number of closely related things. A `UserService` that handles
authentication, profile updates, email preferences, and billing has low cohesion — split it.

**Polymorphism.** When behaviour varies by type, use polymorphism rather than conditional logic.
Instead of a switch statement checking `payment_type`, define a `PaymentMethod` interface with
implementations for each type.

**Indirection.** Introduce an intermediate object to mediate between two components and reduce
direct coupling. Middleware, adapters, and event buses are forms of indirection.

**Pure Fabrication.** When no domain object is a natural fit for a responsibility, create a service
class that does not represent a domain concept. A `NotificationService` or `PDFGenerator` may not
map to any real-world entity but exists purely to maintain cohesion and low coupling elsewhere.

**Protected Variations.** Identify points of predicted variation and create stable interfaces around
them. Wrap external APIs, third-party libraries, and volatile business rules behind interfaces so
that changes in those areas do not ripple through the codebase.

---

## The Unix Philosophy

> Articulated by Doug McIlroy and expanded by Eric S. Raymond in "The Art of Unix Programming".
> CUPID references this directly, but the full philosophy goes deeper and applies to how we design
> services, CLI tools, and composable systems.

**Do one thing well.** Write programmes and modules that do one thing and do it well. A function, a
service, a CLI command — each should have a single, clear purpose.

**Write programmes to work together.** Design components with clean interfaces so they can be
composed. Functions take inputs and return outputs. Services communicate through well-defined APIs.
Avoid hidden dependencies and shared mutable state.

**Handle text streams as a universal interface.** In the Unix tradition, text is the lingua franca.
In modern web development, this translates to JSON as the common interchange format, structured
logging, and APIs that produce predictable, parseable output.

**Favour clarity over cleverness.** Make the operation of a programme or module transparent. If
someone has to read the source to understand what a tool does, the interface has failed.

**Build to be replaced.** Design every component as though it will be thrown away and rewritten.
This mindset produces clean interfaces, minimal coupling, and code that is easy to swap out when
requirements change.

---

## Kent Beck's Four Rules of Simple Design

> From Kent Beck, refined by J.B. Rainsberger. A minimalist complement to SOLID — where SOLID can
> sometimes lead toward more abstractions, Beck's rules push you to justify every class and
> interface. The rules are in priority order.

**1. Passes all tests.** The code works. This is the non-negotiable baseline. If it doesn't pass the
tests, nothing else matters.

**2. Reveals intention.** A reader can understand what the code does and why without needing
external documentation or the original author's explanation. Names, structure, and flow communicate
purpose.

**3. Has no duplication.** Every piece of knowledge has a single, authoritative representation. This
aligns with DRY but is subordinate to rules 1 and 2 — do not remove duplication if it makes the code
harder to understand.

**4. Has the fewest elements.** Remove anything that does not serve rules 1, 2, or 3. Every class,
method, variable, and abstraction must earn its place. If a layer of indirection exists only because
"we might need it later", remove it.

**Apply these rules as a test after writing code.** Does it pass? Is it clear? Is knowledge
duplicated? Is there anything that can be removed without violating the first three rules?

---

## Domain-Driven Design Fundamentals

> From Eric Evans' work on Domain-Driven Design. CUPID's "Domain-based" property is a distillation
> of DDD's core insight. These fundamentals apply to how we structure Django apps, GraphQL schemas,
> and multi-tenant systems where different clients have different domain language.

**Ubiquitous Language.** Use the same terms in code, documentation, and conversation with
stakeholders. If the business calls it a "booking", the code should not call it a "reservation" or
an "appointment". The domain model and the language are one and the same.

**Bounded Contexts.** Different parts of a system may use the same word to mean different things. A
"user" in the authentication context is not the same as a "user" in the billing context. Draw
explicit boundaries and let each context own its own model. In a Django monorepo, this maps to
separate apps with clear interfaces between them.

**Aggregates.** A cluster of domain objects that are treated as a single unit for data changes. An
`Order` aggregate might include `OrderLine` items and a `ShippingAddress`. External code interacts
with the aggregate root (`Order`), never directly with its internals. This enforces consistency
boundaries.

**Domain Events.** When something significant happens in the domain, emit an event. `OrderPlaced`,
`PaymentFailed`, `UserVerified`. Events decouple the trigger from the response and make the system
easier to extend — new behaviour can subscribe to existing events without modifying the code that
emits them.

**Anti-Corruption Layer.** When integrating with external systems or legacy code, create a
translation layer that maps their model into yours. Never let an external API's data shapes leak
into your domain model. Wrap third-party clients behind interfaces that speak your domain language.

---

## Package and Module Principles

> Also from Robert C. Martin, these extend SOLID to the package and module level. Directly
> applicable to monorepo architecture decisions — how packages are split, what goes in shared
> libraries versus application code, and how dependency graphs are managed.

### Cohesion Principles (what goes into a package)

**Reuse-Release Equivalence Principle.** The unit of reuse is the unit of release. If code is
intended to be reused, it must be properly versioned, documented, and released. Random utility files
dumped into a `shared/` folder are not reusable packages — they are a coupling hazard.

**Common Closure Principle.** Classes that change together belong together. Group code by reason for
change, not by technical layer. If a change to payment processing requires edits to three packages,
those packages are drawn wrong.

**Common Reuse Principle.** Classes that are used together belong together. Do not force consumers
to depend on things they do not need. If a package contains both payment logic and unrelated email
utilities, consumers who only need payments are coupled to email changes.

### Coupling Principles (how packages relate)

**Acyclic Dependencies Principle.** The dependency graph between packages must have no cycles. If
package A depends on B and B depends on A, they are effectively one package with a confusing
boundary. Break cycles by extracting shared abstractions into a third package or inverting one of
the dependencies.

**Stable Dependencies Principle.** Depend in the direction of stability. Packages that change
frequently should depend on packages that change rarely, not the other way around. Core domain logic
should be stable; UI adapters and integration layers should be volatile.

**Stable Abstractions Principle.** Stable packages should be abstract. If a package is depended upon
by many others (making it hard to change), it should consist primarily of interfaces and abstract
classes — making it open for extension without requiring modification.

---

## The Law of Demeter

> Also known as the Principle of Least Knowledge. An object should only talk to its immediate
> collaborators, not reach through chains of objects to access distant dependencies.

**The rule:** a method `M` of object `O` may only call methods on `O` itself, objects passed as
arguments to `M`, objects created within `M`, and direct component objects of `O`. It should not
call methods on objects returned by other method calls.

**Bad:** `order.getCustomer().getAddress().getCity()` — this chains through three objects, coupling
the caller to the internal structure of `Order`, `Customer`, and `Address`.

**Good:** `order.getShippingCity()` — the `Order` exposes a method that encapsulates the traversal.
If the internal structure changes, only `Order` needs updating.

**In GraphQL schema design:** it is tempting to expose deeply nested relationships. The Law of
Demeter suggests flattening where possible and providing purpose-built fields rather than forcing
clients to traverse the object graph.

**In Django:** avoid chaining through related objects in views or serialisers. If a view needs
`order.customer.address.city`, consider whether the order model should expose a property or method
that encapsulates that access.

---

## The Twelve-Factor App

> A methodology for building software-as-a-service applications, originally published by Heroku
> engineers. Less about code structure and more about application architecture, but it complements
> all of the above for deployed services.

**I. Codebase.** One codebase tracked in version control, many deploys. A single repo produces
staging and production deployments — not separate codebases for each environment.

**II. Dependencies.** Explicitly declare and isolate dependencies. Never rely on system-wide
packages. Use `pyproject.toml`, `package.json`, or `Cargo.toml` with pinned versions and committed
lock files.

**III. Config.** Store configuration in the environment. Database URLs, API keys, feature flags —
all come from environment variables, never hardcoded in source.

**IV. Backing Services.** Treat backing services (databases, caches, email providers, message
queues) as attached resources. The code makes no distinction between local and third-party services
— swap a local PostgreSQL for a managed one by changing a URL.

**V. Build, Release, Run.** Strictly separate the build stage (compile, bundle), the release stage
(combine build with config), and the run stage (execute in the environment). A release is immutable
— to change anything, create a new release.

**VI. Processes.** Execute the app as one or more stateless processes. Any data that needs to
persist must be stored in a stateful backing service. Session state belongs in a cache or database,
not in local memory.

**VII. Port Binding.** Export services via port binding. The app is self-contained and does not rely
on runtime injection of a web server. Django with gunicorn, Node with its built-in HTTP server — the
app binds to a port and serves requests.

**VIII. Concurrency.** Scale out via the process model. Different work types (web requests,
background jobs, scheduled tasks) run as separate process types that can be scaled independently.

**IX. Disposability.** Maximise robustness with fast startup and graceful shutdown. Processes can be
started and stopped at a moment's notice. Handle SIGTERM gracefully, finish in-flight requests, and
release resources.

**X. Dev/Prod Parity.** Keep development, staging, and production as similar as possible. Same
backing services, same operating system, same container images. NixOS and Docker help enforce this.

**XI. Logs.** Treat logs as event streams. The app writes to stdout; the execution environment
captures, routes, and stores logs. Never write to log files within the app.

**XII. Admin Processes.** Run admin and management tasks as one-off processes in the same
environment as the app. Django management commands, database migrations, and one-off scripts run
against the same codebase and config as the running app.

---

## DRY vs WET — The Rule of Three

Don't abstract prematurely. Duplication is acceptable the first and second time you write something.
On the **third occurrence**, refactor into a shared abstraction.

The wrong abstraction is worse than duplication: a premature abstraction forces every future use
into a shape that doesn't quite fit, creating complexity that's painful to undo. Three clear,
slightly repetitive implementations are preferable to one clever abstraction that obscures intent.

Extract a shared function, service, component, or utility when the same logic appears in three or
more places.

---

## KISS — Keep It Simple

Resist unnecessary complexity. The simplest solution that works correctly is almost always the best
one.

Complexity has a compounding cost: every layer of abstraction, every indirection, every clever trick
adds cognitive load for every future reader. A solution that is simple today remains simple when
revisited in six months. A clever solution becomes a mystery.

This does not mean avoiding all abstraction. It means every abstraction must earn its place by
making the code simpler overall, not just in one spot. If adding a design pattern makes one class
cleaner but requires three new files and an interface, question whether the net result is simpler.

KISS reinforces Linus's Rule 5 (favour stability over complexity) and Pike's Rules 3 and 4 (fancy
algorithms are slow and buggy).

---

## YAGNI — You Ain't Gonna Need It

> From Extreme Programming. Do not build for hypothetical future requirements. Ship what is needed
> now, refactor when actual needs emerge.

Every feature, abstraction, or configuration option that exists "just in case" has a maintenance
cost from the moment it is written. It must be tested, documented, understood by new team members,
and kept compatible with every future change — all for a requirement that may never arrive.

When the requirement does arrive, you will understand it better than you could have predicted. The
code you would write then, informed by real constraints, will be better than the speculative code
you would write now.

YAGNI pairs with the Rule of Three: don't abstract until there are three real cases, and don't build
until there is a real need.

---

## Error Handling

Prefer explicit error handling over silent failures. Never swallow an error without logging it —
silent failures are the hardest class of bug to diagnose.

### Python `except` clause syntax (CRITICAL — do not regress)

Always use **parenthesised tuple syntax** when catching multiple exception types:

```python
# CORRECT — Python 3
except (ValueError, TypeError):
    ...

# WRONG — Python 2 syntax, causes SyntaxError in Python 3
except ValueError, TypeError:
    ...
```

**Never** write `except ExcA, ExcB:` — this is Python 2 syntax and will raise a `SyntaxError` at
import time in Python 3 (`mypy`, `ruff`, `basedpyright` will also flag it).

When catching multiple exceptions that require different handling, use **separate `except` blocks**:

```python
except SomeModel.DoesNotExist:
    pass  # expected path
except SomeModel.MultipleObjectsReturned:
    logger.error("Data integrity violation — multiple rows matched lookup_key=%r", key)
    # then fall through or re-raise as appropriate
```

Silently `pass`-ing a `MultipleObjectsReturned` (or any data-integrity exception) is a bug — log it
at `ERROR` level first so incidents are visible in observability tooling.

_(Fixed in US130 as C-01 — see `mutations/oidc.py::_get_or_create_oidc_user`.)_

### Multi-step operations must use `transaction.atomic()` (CRITICAL — recurring failure)

Any service method that performs two or more database writes must be wrapped in
`transaction.atomic()`. Without it, a failure partway through leaves the database in an inconsistent
state.

```python
# WRONG — if bulk_create fails, the delete has already happened
BackupCode.objects.filter(user=user).delete()
BackupCode.objects.bulk_create([...])

# CORRECT
with transaction.atomic():
    BackupCode.objects.filter(user=user).delete()
    BackupCode.objects.bulk_create([...])
```

This applies to: registration flows, provisioning, permission assignments, role deletions, and any
other mutation that touches more than one model or row. Missing `transaction.atomic()` on multi-step
writes will be caught at QA. Add it when writing the service, not after.

- Use custom exception types over generic ones. An exception that says `OrderPaymentFailed` with an
  order ID and reason is more actionable than a bare `Exception`.
- Every error message should answer three questions: **what** went wrong, **why** it happened, and
  ideally **what to do** about it.
- In PHP/Laravel, use custom exception classes and handler registration. Let exceptions bubble to
  the handler rather than swallowing them in service classes.
- In Python/Django, use Django's exception hierarchy and DRF's exception handling. Log unexpected
  exceptions to Sentry before re-raising or returning error responses.
- In TypeScript/React, use `Result`-style patterns or typed error boundaries. Never let `unknown`
  errors reach the UI without a fallback.
- Do not return `null` where an exception is the more honest type. Use `null` only when the absence
  of a value is expected and valid.
- All HTTP API errors must return structured JSON with a consistent shape:
  `{ "error": { "code": "...", "message": "..." } }`.

---

## Naming Conventions

Beyond Linus's "descriptive but concise" rule, follow these concrete conventions across all
languages in this project:

- **Booleans** read as questions: `is_active`, `has_permission`, `can_retry`.
- **Functions and methods** are verbs: `get_user`, `validate_input`, `send_alert`.
- **Avoid abbreviations** unless universally understood in context (`url`, `id`, `cfg` are
  acceptable; `usr`, `mgr`, `svc` are not).
- **No single-letter variables** except in tight loops (`i`, `j`) or clear mathematical contexts.
- **PHP/Laravel:** `camelCase` for variables and methods; `PascalCase` for classes; `snake_case` for
  database columns and environment variables.
- **Python/Django:** `snake_case` for variables, functions, and modules; `PascalCase` for classes;
  `SCREAMING_SNAKE_CASE` for constants.
- **TypeScript/React:** `camelCase` for variables and functions; `PascalCase` for components,
  classes, and types; `SCREAMING_SNAKE_CASE` for constants; `kebab-case` for CSS classes and file
  names.
- **Database tables:** `snake_case`, plural nouns (e.g., `user_profiles`, `order_items`).
- **Environment variables:** `SCREAMING_SNAKE_CASE` (e.g., `DATABASE_URL`, `APP_SECRET_KEY`).

---

## Import Rules

**All imports must appear at the top of the file.** This rule applies to every language in this
project: Python, Rust, TypeScript, JSX, TSX, and CSS. Imports inside functions, methods, or classes
are not permitted unless one of the narrow justified exceptions below applies.

The default is always top-level. Inline imports are harder to discover, harder to trace during
debugging, and invisible to static analysis tools. They slow down every reader who has to scroll
through a function to find out what it depends on.

### Import order by language

**Python** — enforced by `ruff` (isort-compatible):

```text
1. stdlib
2. third-party packages
3. local / project imports
```

```python
from __future__ import annotations  # always first if present

import logging                       # stdlib
import re

import strawberry                    # third-party
from django.conf import settings

from apps.core.conf import get_setting  # local
```

**Rust** — enforced by `rustfmt` / `clippy`:

```text
1. std
2. external crates
3. crate-local modules (self, super, crate::)
```

```rust
use std::collections::HashMap;  // std

use serde::{Deserialize, Serialize};  // external crates

use crate::models::User;  // crate-local
```

**TypeScript / JSX / TSX** — enforced by ESLint (`import/order`) and Prettier:

```text
1. React (if present)
2. Third-party packages
3. Local components (relative paths)
4. Local utilities, hooks, and services (relative paths)
5. Type-only imports (`import type`)
```

```tsx
import React, { useState } from "react"; // React

import clsx from "clsx"; // third-party

import { Button } from "@/components/ui/Button"; // local components
import { usePermissions } from "@/hooks/usePermissions";

import type { User } from "@/types/auth"; // type-only
```

**CSS / Tailwind** — `@import` rules must appear before all other declarations:

```text
1. External resets / vendor stylesheets
2. Design tokens / variables
3. Utility overrides
4. Component styles
```

```css
@import "normalize.css"; /* external reset */
@import "./tokens.css"; /* design tokens */
@import "./utilities.css"; /* utilities */
@import "./components/card.css"; /* components */
```

---

### Justified exceptions (all languages)

| Exception                        | Rule                                                                                                                                                                                                                                                                                                 |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Circular import resolution**   | When two modules genuinely depend on each other and moving the import to the top creates a cycle, defer one import to the point of use. This is a last resort — prefer refactoring the dependency, extracting a shared module, or using dependency injection.                                        |
| **Optional / conditional deps**  | When a dependency might not be installed (e.g. a platform-specific library or an optional feature), guard the import with `try/except ImportError` at the call site. Do not place an unguarded module-level import that will break CI.                                                               |
| **Heavy imports on rare paths**  | When a module is expensive to load (large C extension, GPU library) and only needed in one rarely-called code path, lazy importing avoids penalising startup time. Document the reason with a comment.                                                                                               |
| **`if TYPE_CHECKING:` (Python)** | Imports only needed for type annotations belong inside `if TYPE_CHECKING:`. They are never executed at runtime and exist solely to satisfy the type checker. Use string annotations (`"MyType"`) or `from __future__ import annotations` to avoid needing the runtime import.                        |
| **Test-only mocking scope**      | In test files, importing inside a test function after patching ensures the patched version is picked up. This applies only to test files — never to production code.                                                                                                                                 |
| **Genuine name collision**       | When two packages export identically named symbols that are both needed in the same file, import one or both with an alias (`as`) at the top of the file. If aliasing is not enough and a collision truly cannot be resolved, an in-function import of the rarer symbol is acceptable. Document why. |

---

### Python-specific exceptions

The following additional exceptions apply to Python files in `packages/backend/`:

| Exception                                  | Rule                                                                                                                                                                                                                                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Django migration `RunPython` functions** | Imports inside the callable passed to `RunPython` are the standard Django migration pattern. The function runs in the migration executor's context, not the application's. Model imports must be done via `apps.get_model()` or local imports to avoid historical model state issues. |
| **`AppConfig.ready()`**                    | Imports for startup wiring (signal handlers, validation calls) must be deferred into `ready()`. Importing at module level in `apps.py` creates a circular import because Django has not finished loading the app registry when the file is first parsed.                              |

### Python — shadowing avoidance

When a top-level import would shadow a local variable or method parameter, rename the import with an
underscore prefix:

```python
# django.db.connection would shadow the `connection` parameter in reset_search_path()
from django.db import connection as _db_connection
```

---

### What is NOT a justified exception

- **Circular imports between internal modules.** If moving an import to the top causes a circular
  import, this is a structural problem — refactor the dependency, extract a shared module, or use
  dependency injection. Do not paper over it with an inline import.
- **"It felt cleaner inside the function."** Inline imports inside a function are harder to
  discover, harder to trace during debugging, and invisible to static analysis tools.
- **"I haven't checked if it causes a circular import."** Assume it doesn't. Move it to the top
  first and see if anything breaks. Only keep it deferred if you can demonstrate the cycle.

---

### Quick checklist

Before committing any source file:

- [ ] All imports are at the top of the file, not inside functions, methods, or classes.
- [ ] Imports are grouped and ordered per the convention for the language (stdlib → third-party →
      local for Python; std → external → crate-local for Rust; React → third-party → local →
      type-only for TS/TSX).
- [ ] The only inline imports present match one of the justified exceptions above, with a comment
      explaining which exception applies and why.
- [ ] Any renamed import (`as _name`) has a naming convention that makes the reason clear.
- [ ] Python: `AppConfig.ready()` and `RunPython` callables use deferred imports; all other code
      does not.

---

## Testing

Every public function, service, and API endpoint requires tests. See **[TESTING.md](TESTING.md)**
for the full testing guide, patterns, and examples adapted to this project's stack.

Summary of requirements:

- Every public service method or utility function has at least one unit test.
- Every HTTP endpoint has integration tests covering the happy path, error paths, and auth failures.
- Every new database migration has a test verifying the migration runs and rolls back cleanly.
- Tests are independent — no test relies on another having run first.
- Test names describe the scenario: `test_login_fails_with_expired_token` not `test_login_2`.

---

## Comments and Documentation

Comments explain **why**, not **what**. If code needs a comment to explain what it does, rewrite the
code to be clearer instead.

- **Docstrings** are mandatory on all public APIs. In PHP, use PHPDoc `/** */` blocks. In Python,
  use docstrings. In TypeScript, use JSDoc `/** */` comments.
- **TODO comments** must include a name or ticket reference:
  `// TODO(sam): remove after STORY-030 deploys`.
- Avoid commented-out code in committed files. Delete it; git history is the recovery mechanism.
- Do not restate configuration in prose. Comments should explain architectural decisions or
  operational constraints, not repeat what the code already says.

---

## Security

- **Never hardcode** secrets, API keys, or credentials in any file committed to this repository. All
  secrets live in environment variables or a secrets manager.
- **Always validate and sanitise** user input at system boundaries. Assume all external input is
  hostile until proven otherwise.
- **Parameterised queries** for all database access. String interpolation into SQL is never
  acceptable — use the ORM or prepared statements.
- **Principle of least privilege**: every service, user, role, and token has only the permissions it
  needs and nothing more.
- **Pin all dependencies** explicitly. Unpinned dependencies are a supply-chain risk.
- See **[SECURITY.md](SECURITY.md)** for detailed security patterns and the compliance checklist.

---

## Dependencies

Don't add a dependency for something you can write correctly in under 50 lines. Before adding any
dependency, answer all five questions:

1. Can this be implemented simply without it? If yes, write it.
2. Is it actively maintained? (Recent commits, issues acknowledged and resolved)
3. Does it have a clean security track record? (Check CVE databases and `npm audit` / `pip audit` /
   `composer audit`)
4. Is the licence compatible? (MIT, Apache 2.0, ISC are acceptable; GPL requires careful review)
5. Is the version pinned explicitly? Never use unbounded version ranges.

In PHP, pin exact versions in `composer.json`. In Python, pin in `requirements.txt` or
`pyproject.toml`. In TypeScript, use exact versions in `package.json` and commit lock files.

---

## Git and Version Control

- **Atomic commits**: each commit does exactly one thing. Mixed concerns belong in separate commits.
- **Conventional Commits format**: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`. Subject line
  under 72 characters. Body explains the reasoning and context, not the diff.
- **Never commit** generated files, secrets, `.env` files, or environment-specific configuration.
- **Branch naming** follows `<story-id>/<short-description>`: `us028/stripe-payments`.
- **Pull requests** require a description explaining what changed and why, with a reference to the
  story ID.
- Force-push is only permitted on personal feature branches before a PR is opened, never after.

---

## Logging

Log at the appropriate level for the audience and severity:

| Level     | Use for                                                     |
| --------- | ----------------------------------------------------------- |
| `DEBUG`   | Development detail — request payloads, query parameters     |
| `INFO`    | Significant state changes — user created, payment processed |
| `WARNING` | Recoverable issues — retry attempted, fallback used         |
| `ERROR`   | Failures requiring attention — payment failed, write error  |

Rules:

- **Never use `print()` (Python) or `console.log/warn/error()` (TypeScript) in committed code.**
  Always use the project logger so output flows through the configured handlers and appears in
  `code/src/logs/` locally and in Loki in staging/prod. `print()` and `console.log()` bypass
  every handler — they are invisible to observability tooling.
- Temporary `print()` or `console.log()` statements added while chasing a bug must be removed
  before the fix is committed. They are not a substitute for a proper log statement.
- Include enough context to diagnose the issue without re-running: include IDs, paths, and relevant
  values alongside the error.
- Never log sensitive data: passwords, tokens, secret values, or PII.
- In production, use structured logging (JSON) where possible. Avoid free-text log strings that
  cannot be parsed or searched.
- Log at `ERROR` when an error propagates to the top of the call stack unhandled. Log at `WARNING`
  or `DEBUG` when it is caught and recovered from.

---

## Code Review Checklist

Before submitting code for review or marking a task complete, verify:

- [ ] Errors are handled explicitly — no silent failures or unchecked exceptions
- [ ] All public functions and service methods have tests
- [ ] Test names describe the scenario being tested
- [ ] The code follows existing patterns in the codebase
- [ ] A stranger could understand this code in six months without context
- [ ] No secrets, credentials, or API keys are present in the diff
- [ ] No new dependency was added without evaluation (see Dependencies above)
- [ ] Every modified file stays within the 750-line limit
- [ ] Relevant documentation has been updated
- [ ] No commented-out code was left in the diff
- [ ] All imports are at the top of the file (see Import Rules above) — no imports inside functions,
      methods, or classes unless a documented justified exception applies
