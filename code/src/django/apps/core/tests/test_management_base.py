"""``ManagementCommand`` — the error taxonomy expressed as what an operator and a scheduler see.

Three classes, three outcomes, and the third one is the reason this file exists: a
programmer error must escape as a traceback. A test that only proved the two handled cases
would pass just as happily against a base class that caught everything.

Integration rather than unit: ``close_old_connections()`` runs on entry and exit, so the
command needs a real connection to close.
"""

from __future__ import annotations

from django.core.management import call_command
from django.core.management.base import CommandError

import pytest

from apps.core.management.base import EXIT_TEMPFAIL, ManagementCommand
from apps.core.services.errors import (
    DependencyUnavailable,
    InvariantViolation,
    ServiceNotFoundError,
    ServiceValidationError,
)

pytestmark = pytest.mark.django_db


class _RaisingCommand(ManagementCommand):
    """A command whose only job is to raise whatever it was constructed with."""

    def __init__(self, error: BaseException | None = None) -> None:
        super().__init__()
        self.error = error

    def handle(self, *args: object, **options: object) -> str:
        if self.error is not None:
            raise self.error
        return "done"


class TestExitCode:
    def test_tempfail_is_the_bsd_value(self) -> None:
        """EX_TEMPFAIL from ``sysexits.h`` — a scheduler keys retry behaviour on it."""
        assert EXIT_TEMPFAIL == 75


class TestUserError:
    """A ``ServiceError`` becomes one clean line, not a traceback — it is not a defect."""

    @pytest.mark.parametrize(
        "error", [ServiceNotFoundError("no such booking"), ServiceValidationError("bad date")]
    )
    def test_becomes_a_command_error(self, error: Exception) -> None:
        with pytest.raises(CommandError) as caught:
            call_command(_RaisingCommand(error))

        assert str(caught.value) == str(error)

    def test_does_not_carry_the_retry_exit_code(self) -> None:
        with pytest.raises(CommandError) as caught:
            call_command(_RaisingCommand(ServiceNotFoundError("nope")))

        assert getattr(caught.value, "returncode", 1) != EXIT_TEMPFAIL

    def test_keeps_the_original_as_the_cause(self) -> None:
        original = ServiceNotFoundError("nope")

        with pytest.raises(CommandError) as caught:
            call_command(_RaisingCommand(original))

        assert caught.value.__cause__ is original


class TestEnvironmentError:
    """A ``DependencyUnavailable`` exits 75, which is the only signal a scheduler acts on."""

    def test_becomes_a_command_error_with_tempfail(self) -> None:
        with pytest.raises(CommandError) as caught:
            call_command(_RaisingCommand(DependencyUnavailable("valkey", "connect timeout")))

        assert caught.value.returncode == EXIT_TEMPFAIL
        assert str(caught.value) == "valkey: connect timeout"


class TestProgrammerError:
    """The load-bearing case: an ``InvariantViolation`` must NOT be tidied into a CommandError."""

    def test_propagates_untouched(self) -> None:
        with pytest.raises(InvariantViolation) as caught:
            call_command(_RaisingCommand(InvariantViolation("booking.no_overlap")))

        assert caught.value.key == "booking.no_overlap"

    def test_an_unexpected_exception_also_propagates(self) -> None:
        with pytest.raises(ZeroDivisionError):
            call_command(_RaisingCommand(ZeroDivisionError("1/0")))


class TestSuccess:
    def test_returns_the_handler_result(self) -> None:
        assert call_command(_RaisingCommand()) == "done"
