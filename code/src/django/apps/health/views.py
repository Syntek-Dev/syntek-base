"""The two public health endpoints.

Plain Django views, not Django Ninja. These have to answer while the API surface is
unwired, unreachable or itself the thing that is broken, so they take no dependency on it —
which is also why they mount at the root rather than under ``/api/``.

Both are public and both are ``never_cache``d. A cached readiness answer is worse than no
answer: an intermediary would serve ``operational`` from the moment before an outage for
the whole of it. The short-TTL cache the contract specifies is applied to the *probe
results* in :func:`readiness`, never to the HTTP response.

Contract: ``code/docs/logging/HEALTH-CONTRACT.md``.
"""

from __future__ import annotations

from typing import TYPE_CHECKING, Final

from django.conf import settings
from django.core.cache import cache
from django.http import HttpResponse, JsonResponse
from django.views.decorators.cache import never_cache
from django.views.decorators.http import require_safe

from apps.health.checks import HealthStatus, gather

if TYPE_CHECKING:
    from django.http import HttpRequest

__all__ = ["liveness", "readiness"]

_READINESS_CACHE_KEY: Final = "health:readiness"

# 503 for `down` only. `degraded` is a 200 with a body that says so, because the site is
# serving and a probe that fails the whole endpoint on a degraded cache would take the
# public status page red for something users cannot see.
_STATUS_CODES: Final[dict[HealthStatus, int]] = {
    HealthStatus.OPERATIONAL: 200,
    HealthStatus.DEGRADED: 200,
    HealthStatus.DOWN: 503,
}


@require_safe
@never_cache
def liveness(request: HttpRequest) -> HttpResponse:
    """Is the process up and the URLconf loaded? Nothing else.

    Touches no dependency by design: an orchestrator restarting a container because
    PostgreSQL is briefly unreachable turns a database blip into a rolling outage. That
    judgement belongs to ``/health/ready/``, which takes traffic away without killing
    anything.
    """
    # Bytes, not str: django-stubs types `content` as `bytes`, and the body is a fixed
    # ASCII literal, so there is nothing for an encoding step to decide.
    return HttpResponse(b"ok", content_type="text/plain; charset=utf-8")


@require_safe
@never_cache
def readiness(request: HttpRequest) -> JsonResponse:
    """Aggregate dependency health, short-TTL cached so probing cannot stampede.

    The memo lives in the cache being probed, which is deliberate and not circular: when
    Valkey is down, ``IGNORE_EXCEPTIONS`` turns the read into a miss, so the endpoint falls
    back to probing every request — the correct behaviour for the one case where the memo
    cannot be trusted.

    The body carries the overall word and nothing else. Component names, versions and
    hostnames are reconnaissance for an unauthenticated caller; the breakdown is admin-only.
    """
    cached = cache.get(_READINESS_CACHE_KEY)

    if cached is None:
        status = gather().status
        cache.set(_READINESS_CACHE_KEY, status.value, settings.HEALTH_CACHE_TTL_SECONDS)
    else:
        # Normalised back through the enum rather than trusted: the memo crossed a
        # serialisation boundary, so it is a string until this line says otherwise.
        status = HealthStatus(cached)

    return JsonResponse({"status": status.value}, status=_STATUS_CODES[status])
