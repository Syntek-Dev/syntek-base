"""Fixture test for negative-space.sh --self-test. Never collected by pytest.

This file exists to prove the EXCLUSION. It constructs an unregistered key, exactly as a
real guard suite would. If test code ever stops being exempt, `clean/` starts producing
findings and the self-test fails — which is the point.
"""

from __future__ import annotations

from apps.core.services.errors import InvariantViolation


def test_key_is_carried() -> None:
    """The key survives construction."""
    error = InvariantViolation("fixture.never_registered_py")
    assert error.key == "fixture.never_registered_py"
