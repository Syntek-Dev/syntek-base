"""The exception trees, and the separation that is the whole point of them.

The load-bearing class here is ``TestTreesAreUnrelated``. If an ``InvariantViolation`` ever
becomes catchable as a ``ServiceError``, one broad ``except ServiceError``
somewhere upstream will turn a broken invariant into a friendly 400 and lose both the 500
the operator needs and the tracker event naming which guarantee broke
(``code/docs/NEGATIVE-SPACE.md``).
"""

from __future__ import annotations

import pytest

from apps.core.services.errors import (
    DependencyUnavailable,
    InvariantViolation,
    ServiceError,
    ServiceNotFoundError,
    ServicePermissionError,
    ServiceValidationError,
)

pytestmark = pytest.mark.unit


class TestServiceErrorTree:
    """The user-error tree: expected, actionable, mapped to a 4xx by the API layer."""

    @pytest.mark.parametrize(
        ("error_class", "expected_code"),
        [
            (ServiceError, "unknown_error"),
            (ServicePermissionError, "permission_denied"),
            (ServiceNotFoundError, "not_found"),
            (ServiceValidationError, "validation_error"),
        ],
    )
    def test_each_carries_its_stable_code(
        self, error_class: type[ServiceError], expected_code: str
    ) -> None:
        assert error_class.code == expected_code

    @pytest.mark.parametrize(
        "error_class", [ServicePermissionError, ServiceNotFoundError, ServiceValidationError]
    )
    def test_every_subclass_is_caught_by_the_root(self, error_class: type[ServiceError]) -> None:
        with pytest.raises(ServiceError):
            raise error_class("boom")


class TestTreesAreUnrelated:
    """The three classes are siblings, not a hierarchy. This is doctrine, not an accident."""

    def test_invariant_violation_is_not_a_service_error(self) -> None:
        assert not issubclass(InvariantViolation, ServiceError)

    def test_dependency_unavailable_is_not_a_service_error(self) -> None:
        assert not issubclass(DependencyUnavailable, ServiceError)

    def test_catching_service_error_does_not_swallow_an_invariant_violation(self) -> None:
        with pytest.raises(InvariantViolation):
            try:
                raise InvariantViolation("order.total_non_negative")
            except ServiceError:  # pragma: no cover — the point is that this never fires
                pytest.fail("InvariantViolation was caught as a user error")

    def test_catching_service_error_does_not_swallow_a_dependency_failure(self) -> None:
        with pytest.raises(DependencyUnavailable):
            try:
                raise DependencyUnavailable("valkey")
            except ServiceError:  # pragma: no cover — the point is that this never fires
                pytest.fail("DependencyUnavailable was caught as a user error")


class TestInvariantViolation:
    """``key`` is the join between the running code and the invariant register."""

    def test_key_is_kept_addressable(self) -> None:
        error = InvariantViolation("booking.no_double_allocation", "seat 4A allocated twice")

        assert error.key == "booking.no_double_allocation"
        assert error.detail == "seat 4A allocated twice"

    def test_message_carries_key_and_detail(self) -> None:
        assert str(InvariantViolation("a.key", "what broke")) == "a.key: what broke"

    def test_message_is_the_bare_key_when_there_is_no_detail(self) -> None:
        assert str(InvariantViolation("a.key")) == "a.key"


class TestDependencyUnavailable:
    """Named for the dependency, because that is what an operator acts on."""

    def test_dependency_is_kept_addressable(self) -> None:
        error = DependencyUnavailable("cloudinary", "connect timeout")

        assert error.dependency == "cloudinary"
        assert error.detail == "connect timeout"

    def test_message_carries_dependency_and_detail(self) -> None:
        assert str(DependencyUnavailable("postgres", "no route")) == "postgres: no route"

    def test_message_is_the_bare_dependency_when_there_is_no_detail(self) -> None:
        assert str(DependencyUnavailable("postgres")) == "postgres"

    def test_is_not_an_oserror(self) -> None:
        """The docstring's reason for the name: ``EnvironmentError`` is an ``OSError`` alias."""
        assert not issubclass(DependencyUnavailable, OSError)
