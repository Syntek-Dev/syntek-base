"""Root URL configuration.

Django's admin is the only route the baseline registers, and it mounts at the
non-obvious ``DJANGO_ADMIN_PATH`` (``control/``) — never ``/admin/``, which is
reserved for the project's own admin surface. A guessable admin path attracts
credential-stuffing traffic, so the prefix is configurable and a deployment can
move it without a code change.
"""

from __future__ import annotations

from django.conf import settings
from django.contrib import admin
from django.urls import path

urlpatterns = [
    path(settings.DJANGO_ADMIN_PATH, admin.site.urls),
]

if settings.DEBUG:
    from django.contrib.staticfiles.urls import staticfiles_urlpatterns

    urlpatterns += staticfiles_urlpatterns()
