---
type: guide
agent: planner
skills: [stack-django, stack-htmx-templates]
model: fable
---

# Negative Space — What the Code Must Never Allow

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** fable — Invariant classes, the single enforcement point, the error taxonomy

Almost every other guide here states what the code **should** do. This one states what it must
**never** allow, and what happens the moment that becomes true anyway.

## The governing principle

**One enforcement point, named. One loud failure, unmistakable.**

- Every invariant is enforced in exactly **one** place, and that place is written down. An
  invariant checked in four places is skipped in the fifth.
- A broken invariant is a **bug in this codebase**, not a message for the user. It surfaces as a
  500 and an error-tracker event — never as a friendly 4xx that hides it.

The database half of this is already law and is **not restated here**: constraints live in the
database, and application validation is not a substitute
([`DATABASE.md`](DATABASE.md) § _Before the first migration on a new table_,
[`data-structures/SCHEMA-DESIGN.md`](data-structures/SCHEMA-DESIGN.md) § _Foreign Keys and
Constraints_, and `.claude/CLAUDE.md` § 6). This guide adds the fact none of them carry: **which
single place enforces it, and what happens when it breaks.**

## What counts as an invariant

Two kinds, both in scope:

- **Data-shape rules** — statements about stored values. Uniqueness, bounds, enum membership,
  referential integrity, non-overlap, fields required together.
- **Write-path rules** — statements about _when_ a write may happen. Enqueue only after commit;
  the audit row written in the same transaction; the scope variable set before a scoped query.

**Not in scope:** architectural bans — "no god dictionaries", "no stringly-typed data", "no
business logic in middleware". Those are already owned by
[`data-structures/ANTI-PATTERNS.md`](data-structures/ANTI-PATTERNS.md) and
[`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md). A rule about
code shape is not an invariant about data.

---

## The enforcement-point register

The register has **two halves**, on the same split as
[`architecture/PROVIDER-NEUTRALITY.md`](architecture/PROVIDER-NEUTRALITY.md) and
`how-to/src/PLATFORM-PROVIDERS.md`:

| Half                       | Lives in                   | Contains                                               |
| -------------------------- | -------------------------- | ------------------------------------------------------ |
| **The invariant classes**  | this guide, below          | the _kinds_ of invariant and how each is enforced      |
| **This project's answers** | `how-to/src/INVARIANTS.md` | the actual invariants this project holds, one row each |

Both halves use the same six columns:

| Column              | Holds                                                                                                                                            |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `Invariant`         | the statement, one sentence                                                                                                                      |
| `Key`               | the row's identifier, and the exact string the guard raises — `—` on a pure `db-constraint` row, whose constraint name already is its identifier |
| `Mechanism`         | `db-constraint` · `service-guard` · `client-guard` _(mobile-only)_ · `both`                                                                      |
| `Enforcement point` | the constraint name, or the exact function — **one**, never "the service layer"                                                                  |
| `On breach`         | which error class it raises (see the taxonomy below)                                                                                             |
| `Stated in`         | the guide that already owns the rule                                                                                                             |

**`Key` is a column and not a convention, because a gate cannot read a convention.** A key living
only in prose beside a worked example is a key nothing can correlate with the code that raises it,
which is exactly the drift between register and runtime this column exists to close.

**A `service-guard` row names one function. A second call site is a finding**, recorded in
`project-management/src/19-FINDINGS/` — not a judgement call.

**This register owns one fact and routes the rest.** No row restates a rule that `DATABASE.md`,
`SCHEMA-DESIGN.md`, `TASK-AUTHORING.md` or `rls/MIDDLEWARE-AND-NINJA.md` already carries; the
`Stated in` column points at it.

### The invariant classes

| Invariant class                                     | Mechanism       | Enforcement point                                                       | Stated in                         |
| --------------------------------------------------- | --------------- | ----------------------------------------------------------------------- | --------------------------------- |
| No two rows share a natural key                     | `db-constraint` | `UniqueConstraint`                                                      | `SCHEMA-DESIGN.md`                |
| No two **live** rows share a natural key            | `db-constraint` | `UniqueConstraint(condition=Q(deleted_at__isnull=True))`                | this guide — see below            |
| A bounded or enum-like column holds only its values | `db-constraint` | `CheckConstraint`                                                       | `DATABASE.md`                     |
| Two fields are consistent with each other           | `db-constraint` | `CheckConstraint` over `F()` expressions                                | `SCHEMA-DESIGN.md`                |
| A relationship exists, with a known delete rule     | `db-constraint` | the foreign key's explicit `on_delete` + `NOT NULL`                     | `DATABASE.md`                     |
| No two rows overlap on a range                      | `db-constraint` | `ExclusionConstraint` — **needs `BtreeGistExtension()` in a migration** | this guide — see below            |
| A row is reachable only within its scope            | `both`          | the scope column, its policy, its index, and the middleware — together  | `RLS-GUIDE.md`                    |
| A task is enqueued only after its data is committed | `service-guard` | `transaction.on_commit()` at the one enqueue site                       | `TASK-AUTHORING.md`               |
| An audit row is written with the data it describes  | `service-guard` | the `AuditService.log()` call inside `transaction.atomic()`             | `security/AUDIT-TRAIL.md`         |
| A request body carries no unknown fields            | `service-guard` | `apps.core.schemas.Schema` — its `extra="forbid"`, ruff `TID251`        | `api-design/NINJA-CONVENTIONS.md` |
| A precondition held in another system still holds   | `service-guard` | the one service method that re-reads it                                 | this guide                        |

**Two of these are absent from the codebase today and cost one migration operation each.**
`ExclusionConstraint` and `BtreeGistExtension` both live in `django.contrib.postgres`, go in
`Meta.constraints` beside `CheckConstraint`, and need no new convention — the existing "mirror it
in `Meta.constraints`" rule already covers them. **`btree_gist` is a migration concern, not a
settings one:** an extension a project's first migration does not install makes every later
exclusion constraint fail at apply time rather than at review time.

### The soft-delete trap

A plain `UNIQUE` on a soft-deleting table **forbids re-creating a row whose predecessor was
soft-deleted**. The `SoftDeleteManager` / `PublishableModel` convention
([`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) § _Soft-Delete
Queryset Convention_) implies this and no guide states it. On any soft-deleting table, a
uniqueness invariant is a **partial** unique index:

```python
constraints = [
    models.UniqueConstraint(
        fields=["account", "slug"],
        condition=models.Q(deleted_at__isnull=True),
        name="widget_unique_live_slug_per_account",
    ),
]
```

### The one case where a constraint firing is not a bug

A constraint a user can legitimately **race** — two signups claiming the same email in the same
instant — will fire without anyone having written a bug. Such a row names its user-facing path
explicitly in the `On breach` column (`IntegrityError` → caught at the one enforcement point →
409). **Every other constraint firing is a programmer error**: it means the guard that should have
stopped it is missing, and it must surface as one.

### What the gate decides

`audits/negative-space.sh` mirrors the decidable half of this register. Every clause carries its
tier inline and the script implements against the markers, rather than re-deriving what is
detectable; the marker vocabulary and the exit-code rule are
`code/src/scripts/audits/CONTEXT.md`'s.

- **Every `Meta.constraints` entry has a register row.** **[gate: fail]** (`constraint-unregistered`)
- **Every `db-constraint` row names a constraint a model declares.** **[gate: fail]** (`constraint-absent`)
- **Every `service-guard` / `client-guard` key is raised in exactly one place.** **[gate: fail]**
  Three ways to break it, reported apart: the row raises nowhere (`key-unraised`), a key is raised
  with no row (`key-unregistered`), or one key is raised at two sites (`key-duplicated`) — the
  second call site this section already forbids.
- **The register exists wherever there is anything to register.** **[gate: fail]**
  (`register-absent`) Deleting it while models or guards exist turns every clause above into a
  silent no-op, which is worse than having no gate.
- **The worked-row example is gone once real rows exist.** **[gate: warn]** (`worked-row-stale`)

Two things it will never decide, marked so the boundary is read rather than assumed:

- **Whether a named enforcement point enforces the _right_ thing.** **[judgement]** The check
  matches names; a row can point at a function guarding something else and stay green.
- **Whether an invariant is missing altogether.** **[judgement]** Nothing can grep for a rule
  nobody wrote down — and that is the failure mode this whole guide exists for.

**Scope, because a gate that measures the wrong thing is worse than none.** Models only, never
migrations: a migration history holds every constraint ever added, including ones since dropped,
so scanning it would force this register to carry dead rows to stay green. Test code is exempt on
both surfaces, exactly as ruff `S101` exempts it, because testing a guard is the coverage this
doctrine wants. There is **no silencing annotation** — a comment suppressing a finding here is
itself a finding, on the same reasoning that makes a `# noqa: S101` one.

---

## The error taxonomy

Three classes. Two would force every upstream timeout to be filed as a defect in our own code,
until the error tracker is noisy enough that someone mutes the rule this guide exists to install.

### What each class raises, and where

| Class                 | Type raised                                            | Raised where                                       |
| --------------------- | ------------------------------------------------------ | -------------------------------------------------- |
| **Programmer error**  | `InvariantViolation` — a **sibling** of `ServiceError` | the single enforcement point named in the register |
| **User error**        | the existing `ServiceError` subclasses                 | the service layer, unchanged                       |
| **Environment error** | `DependencyUnavailable`                                | the outbound adapter that owns the provider's SDK  |

**`InvariantViolation` sits outside the `ServiceError` tree on purpose.** Inside it, a single broad
`except ServiceError` turns a broken invariant into a friendly 400 — the exact failure this guide
exists to prevent. A flag on a shared base has the same weakness. The `ServiceError` hierarchy
itself is unchanged; this layers over it
([`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) § _Service
Exception Hierarchy_).

**`InvariantViolation` requires its register key** — `InvariantViolation("order.total_matches_lines", …)`.
The key is the register row's identifier, so an error-tracker event names _which_ invariant broke,
and the register and the running code stay one artefact rather than two lists that drift.

The environment class is **not** `EnvironmentError`, which is a built-in alias of `OSError`.
Classification happens in the adapter because that is the only place that knows the provider's SDK
([`architecture/PROVIDER-NEUTRALITY.md`](architecture/PROVIDER-NEUTRALITY.md)); a central list of
"which exceptions mean the network" in a catch-all handler goes stale on every SDK bump, and
silently reclassifies genuine bugs as "try again".

### What each class looks like from outside

| Class                 | Status              | Log level            | Error tracker             | Body                      |
| --------------------- | ------------------- | -------------------- | ------------------------- | ------------------------- |
| **Programmer error**  | 500                 | `ERROR` + `exc_info` | per event                 | generic — never internals |
| **User error**        | 4xx (422 on schema) | `INFO`               | never                     | specific and actionable   |
| **Environment error** | 503                 | `WARNING`            | aggregated, not per event | `Retry-After` where known |

**Every response carries `X-Request-ID`**, and the tracker event is tagged with it — so a user
reporting "I got an error" is traceable to one event. It is a **header, not a body key**, because a
rendered 500 page has no JSON body and this taxonomy holds on every surface.

The identifier comes **from the edge where there is one**, and `apps.core.middleware` mints one
otherwise — reusing the proxy's value is what keeps a single request to a single identifier
across the access log and the tracker, instead of two that have to be joined by timestamp. The
edge's obligation is `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`.

**`RequestIDMiddleware` stays in `MIDDLEWARE`.** **[gate: fail]** (`request-id-middleware-absent`)
Removing it fails nothing and breaks no test — every response simply stops carrying the header,
and the taxonomy above quietly loses the one thing that makes a user's report findable.

**Retries, backoff and circuit breakers for environment errors are not owned here** —
[`TASK-AUTHORING.md`](TASK-AUTHORING.md) and
[`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md) already carry
them.

### The taxonomy is surface-agnostic; the expression is not

The same three classes hold on the JSON API, rendered pages, HTMX swaps, background tasks and
management commands. **How each surface expresses them is that surface's guide**, not this one —
an HTMX error must never be a silent empty swap, and a task's arguments are untrusted input, but
those clauses live where the surface lives.

| Surface                        | Its clause lives in                                                                                                                           |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Rendered pages and HTMX        | [`rendering/PITFALLS-AND-EXAMPLES.md`](rendering/PITFALLS-AND-EXAMPLES.md) § _An error the user never sees_                                   |
| The JSON API                   | [`logging/DJANGO-LOGGING.md`](logging/DJANGO-LOGGING.md) — the Ninja exception handlers                                                       |
| Background tasks               | [`TASK-AUTHORING.md`](TASK-AUTHORING.md) § _The error taxonomy on this surface_ — and why the user class is **empty** there                   |
| Management commands            | [`MANAGEMENT-COMMANDS.md`](MANAGEMENT-COMMANDS.md) § _The error taxonomy on this surface_ — an operator, a traceback, and exit 75             |
| The mobile app _(mobile-only)_ | [`MOBILE-CODING-PRINCIPLES.md`](MOBILE-CODING-PRINCIPLES.md) § 4 — the root boundary, and why an environment error is the ordinary case there |

---

## The guard clause

A `service-guard` row in the register points at one function. This is what has to be inside it.

### `raise`, never `assert`

**`assert` is banned outside tests.** Three reasons, weakest last:

1. **`AssertionError` cannot carry the register key.** The key is what ties a tracker event back to
   the row that broke ([§ _The error taxonomy_](#the-error-taxonomy)); an assertion arrives naming
   nothing.
2. **It is indistinguishable from a failing test.** The same exception type means the one signal
   that should say "production invariant broke" reads as "somebody's test is red".
3. **`python -O` strips assertions entirely.** Not used in this repository today — which is exactly
   why it is the dangerous one: nothing fails when someone adds it.

Enforced by **ruff `S101`** (`pyproject.toml`), exempting `*/tests/*` and `conftest.py`. A
`# noqa: S101` is a **finding**, recorded in `project-management/src/19-FINDINGS/` — not a
workaround. Narrowing a type for the type checker is not an exception to this: `if x is None:
raise …` narrows identically for basedpyright and survives `-O`.

### The shape

The guard sits **at the top of the one service method the register names**, before any work:

```python
def mark_paid(order: Order, *, actor: User) -> Order:
    if order.total != order.line_total():
        raise InvariantViolation(
            "order.total_matches_lines",
            f"order={order.pk} total={order.total}",
        )
    ...
```

Extracting it into a named `_check_*()` helper is **allowed, never required** — the register's
enforcement point is then that helper. What makes the rule decidable is the key appearing in
exactly one `raise`, not the call shape, so a helper per invariant buys nothing but a shallow
module.

**A guard never returns early.** Returning quietly on a broken invariant is the silent failure this
guide exists to prevent; the only exit is the raise.

**A guard does not:**

| Not this                               | Because                                                                     |
| -------------------------------------- | --------------------------------------------------------------------------- |
| Query the database to "confirm" a rule | If the database can express it, the constraint **is** the enforcement point |
| Log                                    | The handler logs, once, with the class's level                              |
| Catch anything                         | A guard states a condition; it does not handle one                          |
| Repeat in the endpoint or the template | That is the second call site the register forbids                           |

---

## What this guide does not own

| Concern                                                    | Owner                                    |
| ---------------------------------------------------------- | ---------------------------------------- |
| That constraints belong in the database at all             | [`DATABASE.md`](DATABASE.md)             |
| Constraint syntax, normalisation, indexes                  | `data-structures/SCHEMA-DESIGN.md`       |
| Lock-safe migration of a constraint onto a populated table | `data-structures/SCHEMA-MIGRATIONS.md`   |
| The `ServiceError` hierarchy and middleware rules          | `architecture/SERVICE-AND-MIDDLEWARE.md` |
| Anti-patterns in data shape                                | `data-structures/ANTI-PATTERNS.md`       |
| Log levels, the Ninja exception handlers, tracker wiring   | `logging/DJANGO-LOGGING.md`              |
| The enqueue boundary and idempotency                       | [`TASK-AUTHORING.md`](TASK-AUTHORING.md) |
| IDOR and ownership checks                                  | `security/INPUT-AND-API.md`              |
| **This project's actual invariants**                       | `how-to/src/INVARIANTS.md`               |

_Part of the `code/docs/` documentation family._
