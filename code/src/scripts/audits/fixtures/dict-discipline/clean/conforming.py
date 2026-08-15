"""Known-negative fixture — this file MUST produce zero findings.

It carries the shapes the standard permits: a named record type, a true index keyed by a
closed set, and one annotated boundary conversion.
"""

from dataclasses import dataclass
from enum import StrEnum
from typing import Any


class OrderStatus(StrEnum):
    DRAFT = "draft"
    PLACED = "placed"


@dataclass(frozen=True, slots=True)
class Order:
    id: str
    status: OrderStatus
    total_pence: int

    def to_payload(self) -> dict[str, str | int]:
        """DICT-OK: the JSON encoder's input — confined to this serialisation method."""
        return {"id": self.id, "status": self.status.value, "total_pence": self.total_pence}


def build_order(order_id: str) -> Order:
    return Order(id=order_id, status=OrderStatus.DRAFT, total_pence=0)


# A true index: the key is the lookup, not a field name.
ORDERS_BY_ID: dict[str, Order] = {}

# DICT-OK: axe-core's opaque options payload — confined to the scan call site.
SCAN_OPTIONS: dict[str, Any] = {"runOnly": "wcag22aa"}
