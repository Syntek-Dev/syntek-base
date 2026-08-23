"""The health routes, mounted at the root by ``config/urls.py``.

The prefix is fixed rather than configurable, unlike ``DJANGO_ADMIN_PATH``: these paths are
a contract with the deploy repository's uptime probe and with the ``HEALTHCHECK`` line in
every Dockerfile, so moving one silently breaks a consumer this repository cannot see
(``code/docs/logging/HEALTH-CONTRACT.md``).
"""

from __future__ import annotations

from django.urls import path

from apps.health import views

app_name = "health"

urlpatterns = [
    path("health/", views.liveness, name="liveness"),
    path("health/ready/", views.readiness, name="readiness"),
]
