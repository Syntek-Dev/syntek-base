"""The dependency probes behind ``/health/ready/`` and the rule that aggregates them.

Two things live here and nothing else: one probe per dependency, and the aggregation that
turns a set of probe results into the single word ``/health/ready/`` publishes. The view
layer holds no judgement about what "ready" means — it maps a status to a status code.

**Criticality is a property of the dependency, not of the probe.** PostgreSQL is
``CRITICAL`` because no request that reaches application code can be served without it;
Valkey is ``DEGRADABLE`` because ``CACHES["default"]["OPTIONS"]["IGNORE_EXCEPTIONS"]`` is
``True``, so a cache outage costs latency rather than correctness (``config/settings/base.py``).
Encoding that on the dependency is what lets a new probe arrive without touching the
aggregation rule.

Contract: ``code/docs/logging/HEALTH-CONTRACT.md``. The endpoint shapes and the status codes
are decided there and must not be re-decided here.
"""

from __future__ import annotations

from dataclasses import dataclass
from enum import StrEnum
from typing import TYPE_CHECKING, Final

from django.core.cache import cache
from django.db import connection

if TYPE_CHECKING:
    from collections.abc import Callable, Iterable

__all__ = [
    "PROBES",
    "Component",
    "ComponentResult",
    "Criticality",
    "HealthStatus",
    "ReadinessReport",
    "aggregate",
    "gather",
    "probe_cache",
    "probe_database",
]

# The round-trip key the cache probe writes and reads back. Namespaced so it can never
# collide with an application key, and short-lived so an abandoned probe leaves nothing.
_CACHE_PROBE_KEY: Final = "health:probe"
_CACHE_PROBE_VALUE: Final = "ok"
_CACHE_PROBE_TTL_SECONDS: Final = 10


class HealthStatus(StrEnum):
    """The three words ``/health/ready/`` is allowed to publish.

    A ``StrEnum`` rather than bare strings because the value crosses a process boundary —
    the deploy repo's uptime probe keys on ``[BODY].status == operational``, so these are
    a published contract, not an internal label (``code/docs/data-structures/TYPES-PYTHON.md``).
    """

    OPERATIONAL = "operational"
    DEGRADED = "degraded"
    DOWN = "down"


class Criticality(StrEnum):
    """Whether losing a dependency takes the service down or merely degrades it."""

    CRITICAL = "critical"
    DEGRADABLE = "degradable"


class Component(StrEnum):
    """The dependencies that exist to be probed.

    ``API`` and ``PAGES`` are named in the contract but deliberately absent: neither
    surface is wired in the template, and a probe that always passes is worse than no
    probe because it reports health it never measured. Each arrives with its surface.
    """

    DATABASE = "database"
    CACHE = "cache"


@dataclass(frozen=True, slots=True)
class ComponentResult:
    """One dependency's verdict. Never surfaced publicly — see ``ReadinessReport``."""

    component: Component
    healthy: bool
    criticality: Criticality


@dataclass(frozen=True, slots=True)
class ReadinessReport:
    """The aggregate, plus the per-component detail the public endpoint withholds.

    ``status`` is the only field ``/health/ready/`` serialises. The breakdown is kept on
    the object for the admin surface the contract reserves, and because discarding it here
    would mean probing twice to ever show it.
    """

    status: HealthStatus
    components: tuple[ComponentResult, ...]


def probe_database() -> bool:
    """True when PostgreSQL answers a trivial query on the default connection.

    Deliberately not ``connection.ensure_connection()``: that succeeds against a socket
    that has been accepted but cannot serve, which is precisely the failure a readiness
    probe exists to catch.
    """
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            return cursor.fetchone() == (1,)
    except Exception:  # noqa: BLE001 — any failure to answer is a failed probe
        return False


def probe_cache() -> bool:
    """True when Valkey round-trips a sentinel value.

    A write-then-read, not a bare ``cache.set()``, because ``IGNORE_EXCEPTIONS`` is on:
    every cache call swallows its own error and ``set`` returns without raising while
    ``get`` returns ``None``. The round trip is the only signal that survives that
    setting, which is why this is not the one-liner it looks like it should be.
    """
    try:
        cache.set(_CACHE_PROBE_KEY, _CACHE_PROBE_VALUE, _CACHE_PROBE_TTL_SECONDS)
        return cache.get(_CACHE_PROBE_KEY) == _CACHE_PROBE_VALUE
    except Exception:  # noqa: BLE001 — a raising backend is as unhealthy as a lying one
        return False


# The registry the aggregation walks. Adding a dependency is one row here plus its probe;
# nothing in `gather` or the view layer changes.
PROBES: Final[tuple[tuple[Component, Criticality, Callable[[], bool]], ...]] = (
    (Component.DATABASE, Criticality.CRITICAL, probe_database),
    (Component.CACHE, Criticality.DEGRADABLE, probe_cache),
)


def aggregate(results: Iterable[ComponentResult]) -> HealthStatus:
    """Reduce per-component verdicts to the single published word.

    One failed ``CRITICAL`` dependency is ``down``; any failed ``DEGRADABLE`` one with all
    criticals healthy is ``degraded``; everything healthy is ``operational``. The order
    matters — ``down`` wins over ``degraded``, because the caller needs the worse news.
    """
    unhealthy = [result for result in results if not result.healthy]

    if any(result.criticality is Criticality.CRITICAL for result in unhealthy):
        return HealthStatus.DOWN
    if unhealthy:
        return HealthStatus.DEGRADED
    return HealthStatus.OPERATIONAL


def gather() -> ReadinessReport:
    """Run every registered probe and aggregate the results."""
    results = tuple(
        ComponentResult(component=component, healthy=probe(), criticality=criticality)
        for component, criticality, probe in PROBES
    )
    return ReadinessReport(status=aggregate(results), components=results)
