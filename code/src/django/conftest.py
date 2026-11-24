"""Root pytest configuration for the Django project.

Shared fixtures belong here once there is application code to exercise. The
settings module is pinned by ``DJANGO_SETTINGS_MODULE`` in the pytest
configuration rather than being set here.
"""

from __future__ import annotations

import inspect
import json
import re
from pathlib import Path
from typing import TYPE_CHECKING

import pytest

if TYPE_CHECKING:
    from collections.abc import Sequence

# Where the story map is written, beside the suites' own report artefacts. Gitignored, and
# bind-mounted into the test container, so the generator on the host reads what the run produced.
STORY_MAP_PATH = (
    Path(__file__).resolve().parents[1] / "scripts" / "tests" / "reports" / "story-map.json"
)


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


def _junit_address(nodeid: str) -> tuple[str, str]:
    """Return the ``(classname, name)`` pair pytest's JUnit XML writer will use for this node.

    Replicated rather than imported because ``_pytest.junitxml.mangle_test_address`` is private,
    and the generator joins on these two fields. The transformation is stable and documented: the
    file path becomes dotted with its ``.py`` dropped, ``::`` separates the remaining names, and a
    parametrisation's bracketed id stays welded to the final name.
    """
    path, open_bracket, params = nodeid.partition("[")
    names = path.split("::")
    names[0] = re.sub(r"\.py$", "", names[0].replace("/", "."))
    names[-1] += open_bracket + params
    return ".".join(names[:-1]), names[-1]


def _read_previous_map() -> list[dict[str, object]]:
    """Return the entries an earlier session wrote, or none if there is no usable map.

    An unreadable file — absent, truncated by an interrupted run, or not a list — is treated as
    empty and rewritten, never raised: the record is best-effort and must not fail the suite.
    """
    try:
        loaded: object = json.loads(STORY_MAP_PATH.read_text(encoding="utf-8"))
    except OSError, ValueError:
        return []
    if not isinstance(loaded, list):
        return []
    return [entry for entry in loaded if isinstance(entry, dict)]


def pytest_collection_finish(session: pytest.Session) -> None:
    """Write the story map the per-story test record is generated from.

    The suites run whole-project and a JUnit ``<testcase>`` carries only ``classname`` and
    ``name`` — nothing that says which story a test belongs to. Neither can it be inferred: a
    path breaks the moment a story spans two apps, and a branch diff misses every test a later
    fix touches. So the marker is read at collection and written out beside the XML, keyed by the
    same two fields, for ``code/src/scripts/tests/test-record.sh`` to join on.

    The docstring travels with it because it is the only prose the report artefacts cannot supply,
    and the record's *Why* column is where it lands.

    **The map describes the run, not the last session.** Every backend runner calls pytest twice —
    ``-m unit``, then ``-m integration`` — so a session that overwrote the file would erase the
    unit phase's entries whenever the integration phase selected none of a story's tests. So the
    previous map is read back and merged by ``nodeid``: this session is authoritative for the
    tests it collected (re-marked, or dropped when a marker was removed) and leaves every other
    entry alone. An entry for a test no longer collected is harmless — the generator joins on the
    run's JUnit XML, so a test that did not run gets no row.

    Writing is best-effort: a read-only or absent reports directory must never fail a test run,
    because this file's job is a record and the suite's job is the truth.
    """
    collected = {item.nodeid for item in session.items}
    entries = [entry for entry in _read_previous_map() if entry.get("nodeid") not in collected]

    for item in session.items:
        stories = [
            str(argument) for marker in item.iter_markers(name="story") for argument in marker.args
        ]
        if not stories:
            continue

        classname, name = _junit_address(item.nodeid)
        doc = inspect.getdoc(item.obj) if hasattr(item, "obj") else None
        entries.append(
            {
                "classname": classname,
                "name": name,
                "nodeid": item.nodeid,
                "stories": sorted(set(stories)),
                "docstring": (doc or "").strip().split("\n")[0],
            }
        )

    try:
        STORY_MAP_PATH.parent.mkdir(parents=True, exist_ok=True)
        entries.sort(key=lambda entry: str(entry["nodeid"]))
        STORY_MAP_PATH.write_text(json.dumps(entries, indent=2, sort_keys=True), encoding="utf-8")
    except OSError:
        pass
