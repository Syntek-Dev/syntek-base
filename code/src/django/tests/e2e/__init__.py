"""Browser-level end-to-end tests — one browser driver, in Python.

These drive a real Chromium against an **already-running stack** over HTTP. They never
touch the test database through the ORM, are marked ``e2e`` by the root ``conftest.py``,
and are excluded from both phases of ``code/src/scripts/tests/backend.sh``.

Run them with ``bash code/src/scripts/tests/e2e-py.sh``.
"""
