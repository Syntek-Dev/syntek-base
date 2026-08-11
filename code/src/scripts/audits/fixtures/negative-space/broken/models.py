"""Fixture models for negative-space.sh --self-test. Never imported, never migrated.

Declares a constraint the register beside it does not carry — the `constraint-unregistered`
positive. The register's own constraint row names something this file never declares, which
is the `constraint-absent` positive.
"""

from __future__ import annotations

from django.db import models


class Widget(models.Model):
    """A stand-in model; only its Meta is read."""

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=["account", "slug"],
                condition=models.Q(deleted_at__isnull=True),
                name="widget_unique_live_slug",
            ),
        ]

    def __str__(self) -> str:
        return "widget"
