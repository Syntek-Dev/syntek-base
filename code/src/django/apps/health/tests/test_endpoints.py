"""Integration tests for the two public health endpoints, against a real database.

These assert the wire contract in ``code/docs/logging/HEALTH-CONTRACT.md`` — the paths, the
status codes, the body shapes, and the two things the readiness body must **not** contain.
A change that breaks one of these breaks the deploy repository's uptime probe and every
container ``HEALTHCHECK``, neither of which this repository can see.
"""

from __future__ import annotations

import json
from typing import TYPE_CHECKING

from django.core.cache import cache
from django.urls import reverse

import pytest

from apps.health.checks import (
    Component,
    ComponentResult,
    Criticality,
    HealthStatus,
    ReadinessReport,
)

if TYPE_CHECKING:
    from django.test import Client

pytestmark = pytest.mark.django_db


@pytest.fixture(autouse=True)
def _clear_readiness_memo() -> None:
    """The endpoint memoises for 15s; without this, test order would decide the answer."""
    cache.clear()


def _report(status: HealthStatus) -> ReadinessReport:
    return ReadinessReport(
        status=status,
        components=(
            ComponentResult(
                component=Component.DATABASE, healthy=True, criticality=Criticality.CRITICAL
            ),
        ),
    )


class TestLiveness:
    def test_answers_ok_at_the_contracted_path(self, client: Client) -> None:
        response = client.get("/health/")

        assert response.status_code == 200
        assert response.content == b"ok"

    def test_is_reachable_by_name(self, client: Client) -> None:
        assert reverse("health:liveness") == "/health/"

    def test_is_plain_text(self, client: Client) -> None:
        response = client.get("/health/")

        assert response.headers["Content-Type"].startswith("text/plain")

    def test_is_never_cached(self, client: Client) -> None:
        """An intermediary caching liveness would keep a dead process looking alive."""
        response = client.get("/health/")

        assert "no-cache" in response.headers["Cache-Control"]

    def test_rejects_a_write_method(self, client: Client) -> None:
        assert client.post("/health/").status_code == 405


class TestReadiness:
    def test_reports_operational_against_a_live_stack(self, client: Client) -> None:
        response = client.get("/health/ready/")

        assert response.status_code == 200
        assert json.loads(response.content) == {"status": "operational"}

    def test_is_reachable_by_name(self, client: Client) -> None:
        assert reverse("health:readiness") == "/health/ready/"

    def test_degraded_is_a_200_not_a_503(
        self, client: Client, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        """The site is serving. A degraded cache must not take the status page red."""
        monkeypatch.setattr("apps.health.views.gather", lambda: _report(HealthStatus.DEGRADED))

        response = client.get("/health/ready/")

        assert response.status_code == 200
        assert json.loads(response.content) == {"status": "degraded"}

    def test_down_is_a_503(self, client: Client, monkeypatch: pytest.MonkeyPatch) -> None:
        monkeypatch.setattr("apps.health.views.gather", lambda: _report(HealthStatus.DOWN))

        response = client.get("/health/ready/")

        assert response.status_code == 503
        assert json.loads(response.content) == {"status": "down"}

    def test_body_carries_the_status_and_nothing_else(self, client: Client) -> None:
        """No component breakdown, no versions, no hostnames — that is reconnaissance."""
        payload = json.loads(client.get("/health/ready/").content)

        assert list(payload) == ["status"]

    def test_is_never_cached_at_the_http_layer(self, client: Client) -> None:
        response = client.get("/health/ready/")

        assert "no-cache" in response.headers["Cache-Control"]

    def test_rejects_a_write_method(self, client: Client) -> None:
        assert client.post("/health/ready/").status_code == 405

    def test_the_verdict_is_memoised(self, client: Client, monkeypatch: pytest.MonkeyPatch) -> None:
        """Probing must not stampede the dependencies it is probing."""
        calls = 0

        def _counting_gather() -> ReadinessReport:
            nonlocal calls
            calls += 1
            return _report(HealthStatus.OPERATIONAL)

        monkeypatch.setattr("apps.health.views.gather", _counting_gather)

        client.get("/health/ready/")
        client.get("/health/ready/")

        assert calls == 1
