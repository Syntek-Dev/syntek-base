"""Root URL configuration.

Two routes at the baseline. Django's admin mounts at the non-obvious
``DJANGO_ADMIN_PATH`` (``control/``) — never ``/admin/``, which is reserved for the
project's own admin surface. A guessable admin path attracts credential-stuffing traffic,
so the prefix is configurable and a deployment can move it without a code change.

The health endpoints mount **first and at a fixed prefix**: they are consumed by the
``HEALTHCHECK`` in every Dockerfile and by the deploy repository's uptime probe, so unlike
the admin they are a contract rather than a preference
(``code/docs/logging/HEALTH-CONTRACT.md``).
"""

from __future__ import annotations

from django.conf import settings
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("", include("apps.health.urls")),
    path(settings.DJANGO_ADMIN_PATH, admin.site.urls),
]

if settings.DEBUG:
    from django.contrib.staticfiles.urls import staticfiles_urlpatterns

    urlpatterns += staticfiles_urlpatterns()
