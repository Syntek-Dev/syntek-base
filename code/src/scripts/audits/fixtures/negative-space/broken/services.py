"""Fixture service layer for negative-space.sh --self-test. Never imported.

One key raised with no register row (`key-unregistered`), and one key raised at two sites
(`key-duplicated`) — the second call site the register forbids.
"""

from __future__ import annotations

from apps.core.services.errors import InvariantViolation


def mark_paid(order: object) -> None:
    """Raises a key no register row carries."""
    if order is None:
        raise InvariantViolation("order.ghost_key", "order=None")


def refund(order: object) -> None:
    """The registered enforcement point."""
    if order is None:
        raise InvariantViolation("order.doubled_key", "first site")


def cancel(order: object) -> None:
    """The second call site — a finding, not a judgement call."""
    if order is None:
        raise InvariantViolation("order.doubled_key", "second site")
