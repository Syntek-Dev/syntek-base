# api/orders

**Last Updated**: 24/04/2026
**Version**: 1.0.0
**Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Directory Structure

```text
orders/
├── CONTEXT.md
├── create_order.bru    # POST /orders/
├── delete_order.bru    # DELETE /orders/{id}/
├── get_order.bru       # GET /orders/{id}/
├── list_orders.bru     # GET /orders/
└── update_order.bru    # PATCH /orders/{id}/
```

---

## Purpose

Bruno request templates for the standard orders resource CRUD API. Covers list, retrieve, create, update, and delete operations.

---

## Notes

- Parent: `../CONTEXT.md`
- `create_order.bru` (seq 1) stores `test_order_id` via `bru.setVar` — subsequent get/update/delete tests depend on this running first
- Adjust endpoint paths and request bodies to match the project's orders API schema
