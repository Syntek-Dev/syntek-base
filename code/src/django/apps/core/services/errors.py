"""The exception bases every app's service layer builds on — two trees, unrelated on purpose.

``ServiceError`` and its subclasses are **user errors**: expected, actionable, mapped to a
4xx by the API layer. Each app defines a thin base inheriting from these
(``code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`` Section Service Exception Hierarchy).

``InvariantViolation`` and ``DependencyUnavailable`` are **siblings of that tree, not
members of it, and must never be moved into it.** A single broad ``except ServiceError``
would otherwise turn a broken invariant into a friendly 400 — the precise failure
``code/docs/NEGATIVE-SPACE.md`` Section The error taxonomy exists to prevent. A flag on a shared
base has the same weakness.
"""

from __future__ import annotations

__all__ = [
    "DependencyUnavailable",
    "InvariantViolation",
    "ServiceError",
    "ServiceNotFoundError",
    "ServicePermissionError",
    "ServiceValidationError",
]


class ServiceError(Exception):
    """Root of the user-error tree. Subclass it per app rather than raising it directly."""

    code: str = "unknown_error"


class ServicePermissionError(ServiceError):
    """Authorisation or ownership check failed."""

    code: str = "permission_denied"


class ServiceNotFoundError(ServiceError):
    """The resource does not exist, or is soft-deleted."""

    code: str = "not_found"


class ServiceValidationError(ServiceError):
    """Field-level input validation failed."""

    code: str = "validation_error"


class InvariantViolation(Exception):
    """A programmer error: something this codebase guarantees was found to be false.

    Surfaces as a 500 and one error-tracker event — never a friendly 4xx. ``key`` is the
    row identifier in ``how-to/src/INVARIANTS.md``, so the event names *which* invariant
    broke and the register and the running code stay one artefact rather than two lists.
    """

    def __init__(self, key: str, detail: str = "") -> None:
        self.key = key
        self.detail = detail
        super().__init__(f"{key}: {detail}" if detail else key)


class DependencyUnavailable(Exception):
    """An environment error: an outbound dependency could not be reached.

    Raised by the adapter that owns the provider's SDK — the only place that knows which
    of its exceptions mean "the network". Surfaces as a 503, logged at ``WARNING``, and
    aggregated in the tracker rather than reported per event.

    Not named ``EnvironmentError``: that is a built-in alias of ``OSError``.
    """

    def __init__(self, dependency: str, detail: str = "") -> None:
        self.dependency = dependency
        self.detail = detail
        super().__init__(f"{dependency}: {detail}" if detail else dependency)
