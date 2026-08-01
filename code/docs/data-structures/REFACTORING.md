---
type: guide
agent: database
skills: [stack-django]
model: opus
---

# Data Structures — Refactoring Toward Better Structures

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Spotting data-structure code smells, refactoring toward typed shapes

---

## Recognising the Signals

The following code smells indicate that the data structure is wrong:

| Signal                                                                           | Likely problem                                                        |
| -------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| A function has many `if/elif` branches based on a `type` or `status` field       | Use polymorphism or separate models                                   |
| You are passing a dictionary through many functions, adding keys as you go       | Replace with a dataclass or typed object                              |
| Two lists must be kept in sync by index                                          | Merge into a single list of structured objects                        |
| A model has 20+ fields                                                           | Split into focused models with clear boundaries                       |
| You are writing `.split(",")` or `.join(",")` on a model field                   | Normalise into a related table                                        |
| A function accepts `**kwargs` and uses string keys with no documentation         | Define an explicit parameter type                                     |
| A function takes a long parameter list, several arguments always passed together | Bundle the recurring cluster into a parameter object                  |
| The same `if` check appears in many places across the codebase                   | The missing check should be a constraint on the data structure itself |
| A test requires elaborate setup to construct the right shape of dict             | The dict should be a typed structure with defaults                    |
| A Ninja `Schema` or API serialiser reshapes data extensively                     | The domain model is too far from the API contract                     |
| You need a comment to explain what a variable contains                           | The type should be self-documenting                                   |

---

## Refactoring Strategies

**1. Extract a value object.** When the same group of fields appears together across multiple
models or functions (e.g., `amount` + `currency`, `start_date` + `end_date`), extract them into
a value object — a frozen `dataclass`.

**2. Replace dict with dataclass.** When a dictionary has a known, fixed shape, replace it with a
dataclass. This gives you autocompletion, type checking, and documentation for free.

**3. Normalise the schema.** When a column contains multiple values (CSV, JSON array of IDs,
pipe-separated strings), create a related table. Migrate data with a data migration.

**4. Split the mega-model.** When a model has too many fields, identify the distinct domain
concepts within it (profile, billing, preferences, audit) and extract each into a separate model
with a one-to-one relationship to the original.

**5. Replace boolean with enum.** When a boolean field is gaining exceptions or a third state is
needed, replace it with a `TextChoices` enum (Django) or union type (TypeScript). Migrate existing
data.

**6. Separate overloaded status.** When a status field encodes multiple independent dimensions,
split it into separate fields — one per dimension.

**7. Introduce aggregate boundaries.** When external code directly creates, modifies, or deletes
child objects outside the aggregate root, move those operations into methods on the root.

**8. Introduce a parameter object.** When a function takes a long parameter list — roughly four or
more — or the same cluster of arguments is threaded through several call layers together, bundle them
into one typed object — a frozen dataclass — and pass
that. You gain shorter signatures, no positional-argument mistakes, a domain name for the cluster,
and a natural home for its validation and derived values. Reach for keyword-only arguments first when
the list is short and stable; promote to a parameter object once the cluster recurs across call sites
or earns a name. Note the inverse failure: passing an object you already hold purely to read one of
its fields is _stamp coupling_, not a parameter object — see
[`../coding-principles/DESIGN-PRINCIPLES.md`](../coding-principles/DESIGN-PRINCIPLES.md).

**General rule:** every refactoring that changes a data structure must include a migration (for
database changes) and updated tests.

---

## Rules and Principles

1. Design the data before writing the logic. If the logic is complex, question the data structure.
2. Use the simplest structure that supports the required operations.
3. Make the structure enforce correctness. If a value cannot be negative, use
   `PositiveIntegerField` or a `CHECK` constraint, not a validation function that might be bypassed.
4. Use explicit types. Every function parameter, return value, model field, and API response should
   have a declared type. No `any`, no untyped dicts.
5. Name structures after the domain, not the implementation. `Booking`, not `DataRecord`.
6. Normalise by default. Denormalise deliberately, document it, and automate the synchronisation.
7. Every index must correspond to a measured query performance need.
8. Every foreign key must have an explicit `on_delete`. Every constraint must be enforced at the
   database level.
9. Transform data at boundaries. API responses are transformed into domain types at the fetch layer.
   The rest of the application works with clean domain types.
10. When the structure is wrong, fix the structure. Do not write clever code to work around a bad
    data model.
11. Lean on PostgreSQL to enforce structure: `jsonb` (never `text`) for semi-structured data,
    partial indexes for hot subsets, and `CHECK` / `UniqueConstraint` for invariants — they hold
    regardless of the application code path.
12. Validate the shape at every boundary: a Ninja `Schema` for JSON and a Django form for an
    HTMX-posted form, so a malformed payload is rejected before it reaches the model.

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
