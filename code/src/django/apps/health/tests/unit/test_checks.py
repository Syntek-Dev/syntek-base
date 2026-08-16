"""Unit tests for the probes and the aggregation rule. No database, no cache server.

The aggregation rule is tested directly against constructed ``ComponentResult``s rather
than through the endpoint, because the interesting cases — a critical dependency down while
a degradable one is healthy, and the reverse — cannot be produced by breaking a real
dependency in a test run.
"""

from __future__ import annotations

import pytest

from apps.health.checks import (
    Component,
    ComponentResult,
    Criticality,
    HealthStatus,
    aggregate,
    probe_cache,
    probe_database,
)


def _result(component: Component, *, healthy: bool, criticality: Criticality) -> ComponentResult:
    return ComponentResult(component=component, healthy=healthy, criticality=criticality)


class TestAggregate:
    """The rule that turns per-component verdicts into the one published word."""

    def test_everything_healthy_is_operational(self) -> None:
        results = [
            _result(Component.DATABASE, healthy=True, criticality=Criticality.CRITICAL),
            _result(Component.CACHE, healthy=True, criticality=Criticality.DEGRADABLE),
        ]

        assert aggregate(results) is HealthStatus.OPERATIONAL

    def test_failed_critical_dependency_is_down(self) -> None:
        results = [
            _result(Component.DATABASE, healthy=False, criticality=Criticality.CRITICAL),
            _result(Component.CACHE, healthy=True, criticality=Criticality.DEGRADABLE),
        ]

        assert aggregate(results) is HealthStatus.DOWN

    def test_failed_degradable_dependency_is_degraded(self) -> None:
        results = [
            _result(Component.DATABASE, healthy=True, criticality=Criticality.CRITICAL),
            _result(Component.CACHE, healthy=False, criticality=Criticality.DEGRADABLE),
        ]

        assert aggregate(results) is HealthStatus.DEGRADED

    def test_down_wins_over_degraded_when_both_fail(self) -> None:
        """The caller needs the worse news, so severity does not average out."""
        results = [
            _result(Component.DATABASE, healthy=False, criticality=Criticality.CRITICAL),
            _result(Component.CACHE, healthy=False, criticality=Criticality.DEGRADABLE),
        ]

        assert aggregate(results) is HealthStatus.DOWN

    def test_no_probes_at_all_is_operational(self) -> None:
        """An empty registry cannot report a failure it never measured."""
        assert aggregate([]) is HealthStatus.OPERATIONAL


class TestPublishedVocabulary:
    """These three strings are a contract with the deploy repo's uptime probe."""

    def test_status_values_are_the_contracted_words(self) -> None:
        assert HealthStatus.OPERATIONAL.value == "operational"
        assert HealthStatus.DEGRADED.value == "degraded"
        assert HealthStatus.DOWN.value == "down"

    def test_status_compares_equal_to_its_string(self) -> None:
        """StrEnum, so a serialised memo round-trips without a bespoke decoder."""
        assert HealthStatus.OPERATIONAL == "operational"


class TestProbeFailureIsContained:
    """A probe reports a boolean. It never propagates the dependency's exception."""

    def test_database_probe_returns_false_when_the_cursor_raises(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        def _explode() -> object:
            raise RuntimeError("connection refused")

        monkeypatch.setattr("apps.health.checks.connection.cursor", _explode)

        assert probe_database() is False

    def test_cache_probe_returns_false_when_the_backend_raises(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        def _explode(*_args: object, **_kwargs: object) -> object:
            raise RuntimeError("valkey unreachable")

        monkeypatch.setattr("apps.health.checks.cache.set", _explode)

        assert probe_cache() is False

    def test_cache_probe_returns_false_when_the_value_does_not_round_trip(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """The IGNORE_EXCEPTIONS case: set and get both succeed, and the write was lost."""
        monkeypatch.setattr("apps.health.checks.cache.set", lambda *_a, **_k: None)
        monkeypatch.setattr("apps.health.checks.cache.get", lambda *_a, **_k: None)

        assert probe_cache() is False
