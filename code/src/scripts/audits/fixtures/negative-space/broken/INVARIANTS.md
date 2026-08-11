# Fixture register — the known POSITIVE for negative-space.sh --self-test

Every clause is violated exactly once here. If a clause stops firing on this file, the
detector has lost it. **Fix the detector, never the fixtures.**

The worked-row section at the bottom is load-bearing: its row would trip
`constraint-absent` if the parser read it, so a green `constraint-absent` count of exactly
one proves the parser is section-aware rather than line-based.

## Database-enforced invariants

| Invariant                                    | Key | Mechanism       | Enforcement point           | On breach          | Stated in |
| -------------------------------------------- | --- | --------------- | --------------------------- | ------------------ | --------- |
| An order's total equals the sum of its lines | —   | `db-constraint` | `order_total_matches_lines` | `programmer error` | —         |

## Service-enforced invariants

| Invariant                                                     | Key                        | Mechanism       | Enforcement point             | On breach          | Stated in           |
| ------------------------------------------------------------- | -------------------------- | --------------- | ----------------------------- | ------------------ | ------------------- |
| A confirmation email is enqueued only after the order commits | `order.email_after_commit` | `service-guard` | `OrderService.create_order()` | `programmer error` | `TASK-AUTHORING.md` |
| A refund is recorded once                                     | `order.doubled_key`        | `service-guard` | `OrderService.refund()`       | `programmer error` | —                   |

## Client-enforced invariants — mobile-only

| Invariant                                 | Key | Mechanism      | Enforcement point | On breach | Stated in |
| ----------------------------------------- | --- | -------------- | ----------------- | --------- | --------- |
| _None yet — this project has no screens._ |     | `client-guard` |                   |           |           |

## A worked row, for shape only

| Invariant                            | Key | Mechanism       | Enforcement point             | On breach          | Stated in |
| ------------------------------------ | --- | --------------- | ----------------------------- | ------------------ | --------- |
| A teaching example, deliberately not | —   | `db-constraint` | `never_declared_constraint`   | `programmer error` | —         |
| real, that must never be parsed      | —   | `service-guard` | `NeverService.never_called()` | `programmer error` | —         |
