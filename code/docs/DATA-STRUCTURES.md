---
type: guide
agent: database
skills: [stack-django]
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

_Part of the `code/docs/` documentation family._
