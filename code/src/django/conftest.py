"""Root pytest configuration for the Django project.

Shared fixtures belong here once there is application code to exercise. The
settings module is pinned by ``DJANGO_SETTINGS_MODULE`` in the pytest
configuration rather than being set here.
"""

from __future__ import annotations

from typing import TYPE_CHECKING

import pytest

if TYPE_CHECKING:
    from collections.abc import Sequence


def pytest_collection_modifyitems(items: Sequence[pytest.Item]) -> None:
    """Assign the marker every test runs under, by path.

    Three markers, and the distinction between them decides which suite a test lands in:

    * ``*/tests/e2e/*``   → ``e2e``          — browser-level, **never run automatically**
    * ``*/tests/unit/*``  → ``unit``         — phase 1, no database
    * everything else     → ``integration``  — phase 2, database available

    **The `e2e` branch returns early on purpose.** Those tests drive a real browser
    against an already-running stack over HTTP; they never touch the database through the
    ORM. Letting them fall through to ``integration`` would attach ``django_db``, which
    opens a connection to — and flushes — a database the suite does not own. Both phases
    of ``backend.sh`` filter on ``-m unit`` / ``-m integration``, so this marker is
    what keeps the browser suite out of the ordinary run.
    """
    for item in items:
        path = str(item.fspath)

        if "/tests/e2e/" in path:
            if not item.get_closest_marker("e2e"):
                item.add_marker(pytest.mark.e2e)
            continue

        if item.get_closest_marker("unit") or item.get_closest_marker("integration"):
            continue

        if "/tests/unit/" in path:
            item.add_marker(pytest.mark.unit)
        else:
            item.add_marker(pytest.mark.integration)
