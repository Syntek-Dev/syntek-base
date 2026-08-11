from __future__ import annotations

from django.apps import AppConfig


class CoreConfig(AppConfig):
    """Project-wide primitives every domain app builds on. Owns no domain models.

    No ``default_auto_field``: this app declares no models, so there is no primary key for
    it to apply to. The first ``core`` model adds it — or, better, sets ``DEFAULT_AUTO_FIELD``
    once in ``config/settings/base.py`` for every app at the same time.
    """

    name = "apps.core"
