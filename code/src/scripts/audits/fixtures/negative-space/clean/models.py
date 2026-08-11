"""Fixture models for negative-space.sh --self-test. Never imported, never migrated.

Declares exactly one constraint, and the register beside it carries exactly one row naming
it. The `indexes` entry is here on purpose: an index is not an invariant, so the detector
must not demand a register row for `order_reference_idx`.
"""

from __future__ import annotations

from django.db import models


class Order(models.Model):
    """A stand-in model; only its Meta is read."""

    class Meta:
        constraints = [
            models.CheckConstraint(
                condition=models.Q(total__gte=0),
                name="order_total_matches_lines",
            ),
        ]
        indexes = [
            models.Index(fields=["reference"], name="order_reference_idx"),
        ]

    def __str__(self) -> str:
        return "order"
