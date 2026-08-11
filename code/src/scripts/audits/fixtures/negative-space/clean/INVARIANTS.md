# Fixture register — the known NEGATIVE for negative-space.sh --self-test

Every row here agrees with the code beside it. If this file starts producing findings, the
detector has gained a false positive. **Fix the detector, never the fixtures.**

## Database-enforced invariants

| Invariant                                    | Key                         | Mechanism | Enforcement point                                        | On breach          | Stated in |
| -------------------------------------------- | --------------------------- | --------- | -------------------------------------------------------- | ------------------ | --------- |
| An order's total equals the sum of its lines | `order.total_matches_lines` | `both`    | `order_total_matches_lines` + `OrderService.mark_paid()` | `programmer error` | —         |

## Service-enforced invariants

| Invariant                                                     | Key                        | Mechanism       | Enforcement point                                         | On breach          | Stated in           |
| ------------------------------------------------------------- | -------------------------- | --------------- | --------------------------------------------------------- | ------------------ | ------------------- |
| A confirmation email is enqueued only after the order commits | `order.email_after_commit` | `service-guard` | `OrderService.create_order()` → `transaction.on_commit()` | `programmer error` | `TASK-AUTHORING.md` |

## Client-enforced invariants — mobile-only

| Invariant                              | Key                     | Mechanism      | Enforcement point | On breach          | Stated in |
| -------------------------------------- | ----------------------- | -------------- | ----------------- | ------------------ | --------- |
| An order status the app renders exists | `order.status_is_known` | `client-guard` | `label()`         | `programmer error` | —         |
