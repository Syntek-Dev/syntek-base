"""Known-positive fixture — every line here MUST be reported. Never "fix" this file."""

from typing import Any, Dict


def build_order(order_id: str) -> dict:  # P1
    return {"id": order_id, "total": 0}


def summarise(rows: list[str]) -> dict[str, Any]:  # P1 + P2
    return {"count": len(rows)}


PROFILE: dict[str, Any] = {"name": "", "email": ""}  # P2
SETTINGS: Dict[str, str] = {}  # P3

# DICT-OK:
LEGACY: dict[str, Any] = {}  # M — the marker above carries no reason
