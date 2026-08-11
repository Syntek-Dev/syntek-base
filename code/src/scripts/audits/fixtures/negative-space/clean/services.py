"""Fixture service layer for negative-space.sh --self-test. Never imported.

Two guards, two keys, each raised at exactly one site — and both keys appear in the
register beside this file.
"""

from __future__ import annotations

from apps.core.services.errors import InvariantViolation


def mark_paid(order: object) -> None:
    """The `both` row's service half."""
    if order is None:
        raise InvariantViolation("order.total_matches_lines", "order=None")


def create_order(payload: object) -> None:
    """The `service-guard` row's enforcement point."""
    if payload is None:
        raise InvariantViolation("order.email_after_commit", "payload=None")
