---
type: guide
skills: [database, stack-django]
model: opus
---

# Data Structures

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Domain modelling, PostgreSQL schema design, indexing, anti-patterns

This guide covers how to choose, design, and maintain data structures across the <%PROJECT_NAME%>
stack — Python/Django with Django Ninja response schemas on the server. Data structure decisions
are the highest-leverage decisions in a codebase — get the data right and the algorithms, queries,
and templates follow naturally.

## Sub-documents

| Document                                                                       | Covers                                                                                                                                                                                            |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`data-structures/FUNDAMENTALS.md`](data-structures/FUNDAMENTALS.md)           | Fundamental structures (Lists, Dicts, Sets, Tuples, Queues, Trees, Graphs) and how to choose the right one                                                                                        |
| [`data-structures/DOMAIN-MODELLING.md`](data-structures/DOMAIN-MODELLING.md)   | Models Reflect the Business, Value Objects, Enumerations, Aggregates, Django Ninja response schemas                                                                                               |
| [`data-structures/SCHEMA-DESIGN.md`](data-structures/SCHEMA-DESIGN.md)         | PostgreSQL schema design, Normalisation, Denormalisation, Indexes, Foreign Keys, Migrations, Soft Deletes, Polymorphic, JSON Fields, Multi-Tenancy                                                |
| [`data-structures/SCHEMA-MIGRATIONS.md`](data-structures/SCHEMA-MIGRATIONS.md) | Migrating a **deployed** database: which column additions are cheap, the expand→write→backfill→contract change, backfill mechanics, the lock queue, `NOT VALID` → `VALIDATE`, maintenance windows |
| [`data-structures/ANTI-PATTERNS.md`](data-structures/ANTI-PATTERNS.md)         | All 10 anti-patterns: God Dictionary, Stringly Typed, Primitive Obsession, Parallel Collections, Nested Dicts, Mega-Model, Implicit Schema, CSV Columns, Boolean Blindness, Overloaded Status     |
| [`data-structures/REFACTORING.md`](data-structures/REFACTORING.md)             | Recognising the signals, Refactoring strategies, Rules and Principles                                                                                                                             |

## The types-over-dictionaries family

The **mandatory standard**, split by surface. `ANTI-PATTERNS.md` above names what is wrong; this
family states the rule, the exceptions and the escape hatch, and how each language expresses it.
The decidable half is gated by `code/src/scripts/audits/dict-discipline.sh`.

| Document                                                                                   | Covers                                                                                                              |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| [`data-structures/TYPES-OVER-DICTIONARIES.md`](data-structures/TYPES-OVER-DICTIONARIES.md) | **Start here.** The principle, parse-at-the-boundary, the enum test, the migration backlog, the PR review checklist |
| [`data-structures/TYPES-EXCEPTIONS.md`](data-structures/TYPES-EXCEPTIONS.md)               | When a dictionary **is** right — the seven uses, the confinement policy, and the `DICT-OK:` escape hatch            |
| [`data-structures/TYPES-PYTHON.md`](data-structures/TYPES-PYTHON.md)                       | Frozen dataclasses, `NewType`, `TypedDict` as transitional, `StrEnum`, exhaustive `match` under basedpyright        |
| [`data-structures/TYPES-TYPESCRIPT.md`](data-structures/TYPES-TYPESCRIPT.md)               | **Mobile-only.** Discriminated unions, `as const` over `enum`, exhaustiveness through `unreachable()`               |
| [`data-structures/TYPES-RUST.md`](data-structures/TYPES-RUST.md)                           | **Rust-only.** Newtypes, enums carrying data per variant, and the serde wire/domain seam via `TryFrom`              |
| [`data-structures/TYPES-BROWSER.md`](data-structures/TYPES-BROWSER.md)                     | `Alpine.data` component contracts, frozen constants, and the HTMX request DTO / response view-model pair            |

_Part of the `code/docs/` documentation family._
