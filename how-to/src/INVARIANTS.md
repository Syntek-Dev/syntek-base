# Invariants — This Project's Enforcement-Point Register

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

Every rule this project's data must never break, the **one** place each is enforced, and what
happens the moment it breaks anyway.

**The rule that produced this table is not here.** It lives on the build side, in
[`code/docs/NEGATIVE-SPACE.md`](../../code/docs/NEGATIVE-SPACE.md) — what counts as an invariant,
the classes and their mechanisms, and the three-class error taxonomy. That rule is the same in
every project generated from this template. **This file is the answer sheet, and it is yours.**

## How to read a row

| Column                | Meaning                                                                                |
| --------------------- | -------------------------------------------------------------------------------------- |
| **Invariant**         | The statement, one sentence. What must never be true                                   |
| **Mechanism**         | `db-constraint` · `service-guard` · `both`                                             |
| **Enforcement point** | The constraint name, or the exact function — **one**, never "the service layer"        |
| **On breach**         | `programmer error` · `user error` · `environment error` — see the taxonomy in the rule |
| **Stated in**         | The guide that already owns the underlying rule, where one does                        |

**A `service-guard` row names one function.** A second call site enforcing the same invariant is a
finding for `project-management/src/19-FINDINGS/`, not a judgement call.

**`programmer error` is the default.** A breach reaching a user as a friendly message means the
invariant was never enforced — it was described. The exceptions are constraints a user can
genuinely race (two signups claiming one email), which say so in the `On breach` column.

---

## Database-enforced invariants

The constraint is the truth. Any application-level check above it exists to produce a better
message, never to be the enforcement.

| Invariant                                | Mechanism | Enforcement point | On breach | Stated in |
| ---------------------------------------- | --------- | ----------------- | --------- | --------- |
| _None yet — this project has no models._ |           |                   |           |           |

## Service-enforced invariants

For rules PostgreSQL cannot express: preconditions in another system, workflow ordering, and the
write-path rules. Each names exactly one function.

| Invariant                                  | Mechanism | Enforcement point | On breach | Stated in |
| ------------------------------------------ | --------- | ----------------- | --------- | --------- |
| _None yet — this project has no services._ |           |                   |           |           |

---

## A worked row, for shape only

Delete this section once the tables above have real rows in them.

| Invariant                                                     | Mechanism       | Enforcement point                                         | On breach                                 | Stated in           |
| ------------------------------------------------------------- | --------------- | --------------------------------------------------------- | ----------------------------------------- | ------------------- |
| No two **live** widgets share a slug within one account       | `db-constraint` | `widget_unique_live_slug_per_account`                     | `user error` — a user can race this (409) | `NEGATIVE-SPACE.md` |
| An order's total equals the sum of its lines                  | `both`          | `CheckConstraint` + `OrderService.recalculate_total()`    | `programmer error`                        | —                   |
| A confirmation email is enqueued only after the order commits | `service-guard` | `OrderService.create_order()` → `transaction.on_commit()` | `programmer error`                        | `TASK-AUTHORING.md` |

The second row's key is what the code raises:
`InvariantViolation("order.total_matches_lines", …)`. The identifier in the register and the
identifier in the `raise` are the same string, deliberately — that is what stops this file and the
running code becoming two lists that drift.

---

## What keeps this file true

**The database half is checked.** `bash code/src/scripts/audits/negative-space.sh` fails on a
`Meta.constraints` entry with no row here, and on a `db-constraint` row naming a constraint that
does not exist. Two limits worth knowing: the check matches **names**, so it proves a row exists
and never that it is the right one; and it finds nothing at all until this project has models.

**The service half is not, and cannot be.** A `service-guard` row is kept true by the same-change
rule: the guard and its row ship in the same commit, the way a build fact and its
`SERVER-ARCHITECTURE` row do
([`code/docs/architecture/BUILD-OPERATE-SEAM.md`](../../code/docs/architecture/BUILD-OPERATE-SEAM.md)).
A guard added without a row is invisible to everyone who reads this file next.

## Cross-references

- [`code/docs/NEGATIVE-SPACE.md`](../../code/docs/NEGATIVE-SPACE.md) — the rule this file answers
- [`code/docs/DATABASE.md`](../../code/docs/DATABASE.md) — read before any model or migration
- [`how-to/src/PLATFORM-PROVIDERS.md`](PLATFORM-PROVIDERS.md) — the other per-project answer sheet
