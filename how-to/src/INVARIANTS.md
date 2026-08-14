# Invariants — This Project's Enforcement-Point Register

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

Every rule this project's data must never break, the **one** place each is enforced, and what
happens the moment it breaks anyway.

**The rule that produced this table is not here.** It lives on the build side, in
[`code/docs/NEGATIVE-SPACE.md`](../../code/docs/NEGATIVE-SPACE.md) — what counts as an invariant,
the classes and their mechanisms, and the three-class error taxonomy. That rule is the same in
every project generated from this template. **This file is the answer sheet, and it is yours.**

## How to read a row

| Column                | Meaning                                                                                                                                              |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Invariant**         | The statement, one sentence. What must never be true                                                                                                 |
| **Key**               | This row's identifier, and the exact string the guard raises. `—` on a pure `db-constraint` row, where the constraint name is already the identifier |
| **Mechanism**         | `db-constraint` · `service-guard` · `client-guard` · `both`                                                                                          |
| **Enforcement point** | The constraint name, or the exact function — **one**, never "the service layer"                                                                      |
| **On breach**         | `programmer error` · `user error` · `environment error` — see the taxonomy in the rule                                                               |
| **Stated in**         | The guide that already owns the underlying rule, where one does                                                                                      |

**The key in this column and the key in the `raise` are one string, checked by name.**
`audits/negative-space.sh` correlates them in both directions on both surfaces, so a guard added
without a row — or a row whose key nothing raises — fails rather than being noticed later.

**A `service-guard` row names one function.** A second call site enforcing the same invariant is a
finding for `project-management/src/19-FINDINGS/`, not a judgement call.

**`programmer error` is the default.** A breach reaching a user as a friendly message means the
invariant was never enforced — it was described. The exceptions are constraints a user can
genuinely race (two signups claiming one email), which say so in the `On breach` column.

---

## Database-enforced invariants

The constraint is the truth. Any application-level check above it exists to produce a better
message, never to be the enforcement.

| Invariant                                | Key | Mechanism | Enforcement point | On breach | Stated in |
| ---------------------------------------- | --- | --------- | ----------------- | --------- | --------- |
| _None yet — this project has no models._ |     |           |                   |           |           |

## Service-enforced invariants

For rules PostgreSQL cannot express: preconditions in another system, workflow ordering, and the
write-path rules. Each names exactly one function.

| Invariant                                  | Key | Mechanism | Enforcement point | On breach | Stated in |
| ------------------------------------------ | --- | --------- | ----------------- | --------- | --------- |
| _None yet — this project has no services._ |     |           |                   |           |           |

## Client-enforced invariants — mobile-only

For rules the mobile app holds on its own, where neither the database nor a service is in the
call path: an exhausted union, a screen precondition, a state machine that must not skip.
`client-guard` rows raise `InvariantViolation` from `code/src/mobile/lib/invariant.ts`, and the
key here and the key in the throw are the same string.

**A client guard never re-checks what the server already enforces.** It states what this app
assumes; duplicating a service guard here is the second call site the register forbids, only
harder to notice because it sits on the other side of an API.

| Invariant                                 | Key | Mechanism      | Enforcement point | On breach | Stated in |
| ----------------------------------------- | --- | -------------- | ----------------- | --------- | --------- |
| _None yet — this project has no screens._ |     | `client-guard` |                   |           |           |

---

## A worked row, for shape only

Delete this section once the tables above have real rows in them.

| Invariant                                                     | Key                         | Mechanism       | Enforcement point                                         | On breach                                 | Stated in           |
| ------------------------------------------------------------- | --------------------------- | --------------- | --------------------------------------------------------- | ----------------------------------------- | ------------------- |
| No two **live** widgets share a slug within one account       | —                           | `db-constraint` | `widget_unique_live_slug_per_account`                     | `user error` — a user can race this (409) | `NEGATIVE-SPACE.md` |
| An order's total equals the sum of its lines                  | `order.total_matches_lines` | `both`          | `order_total_matches_lines` + `OrderService.mark_paid()`  | `programmer error`                        | —                   |
| A confirmation email is enqueued only after the order commits | `order.email_after_commit`  | `service-guard` | `OrderService.create_order()` → `transaction.on_commit()` | `programmer error`                        | `TASK-AUTHORING.md` |

**Read the `Key` column against the code.** Row two's key is what the guard raises —
`InvariantViolation("order.total_matches_lines", …)` — and row one has none, because a constraint
is identified by its own name. That identity is what stops this file and the running code becoming
two lists that drift, and it is what `audits/negative-space.sh` checks.

Note row two's `Enforcement point`: a `both` row names the **actual constraint**
(`order_total_matches_lines`), never the Django class that builds it. `CheckConstraint` identifies
nothing — a table can carry twenty.

---

## What keeps this file true

**Both halves are checked, by name, in both directions.**
[`code/src/scripts/audits/negative-space.sh`](../../code/src/scripts/audits/negative-space.sh)
correlates this file with the code: a `Meta.constraints` entry with no row here fails, a
`db-constraint` row naming a constraint no model declares fails, and a `Key` that is raised
nowhere — or raised in two places, or raised with no row at all — fails. The mobile
`client-guard` rows are read the same way, against `code/src/mobile/`.

**Know the limit, because it decides how much the green run is worth: matching _names_ proves a
row exists and never that it is the right one.** An enforcement point can guard something else
entirely and stay green, and no audit can find an invariant nobody wrote down. Those two are
marked `[judgement]` in the rule and belong to the reviewer. What the same-change rule still
carries alone is the _content_ of a row, exactly as it does for a build fact and its
`SERVER-ARCHITECTURE` entry
([`code/docs/architecture/BUILD-OPERATE-SEAM.md`](../../code/docs/architecture/BUILD-OPERATE-SEAM.md)).

**The second limit is the one that looks like proof and is not: a fully green register says
nothing about whether any row is _exercised_.** The audit correlates names and coverage counts
executed lines; neither would fail if a constraint were dropped from the model or a guard's
`raise` were deleted, provided the row and the name still line up. The proof is mutation
testing — `bash code/src/scripts/tests/mutmut.sh run` — which removes the enforcement and asks
whether a test notices. It is local-only and deliberately outside CI because it is slow, so it
is an act someone chooses rather than a gate that arrives. Choose it when a row's enforcement
point is load-bearing enough that being wrong about it would be expensive.

## Cross-references

- [`code/docs/NEGATIVE-SPACE.md`](../../code/docs/NEGATIVE-SPACE.md) — the rule this file answers
- [`code/docs/DATABASE.md`](../../code/docs/DATABASE.md) — read before any model or migration
- [`how-to/src/PLATFORM-PROVIDERS.md`](PLATFORM-PROVIDERS.md) — the other per-project answer sheet
