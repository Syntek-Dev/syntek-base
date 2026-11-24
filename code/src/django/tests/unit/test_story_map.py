"""The story map the root ``conftest.py`` writes for ``tests/test-record.sh``.

The backend runners run pytest twice per run — ``-m unit``, then ``-m integration`` — and each
session ends by writing ``reports/story-map.json``. The map must describe the **run**, not the
last session: a story whose marked tests all ran in the unit phase has to survive the
integration phase, or its automated record is generated with no rows
(``project-management/src/21-BUGS/BUG-TEST-RECORD-STORY-MAP-EMPTY-AFTER-COVERAGE-RUN-21-11-2026.md``).

The hook is driven directly with stand-in sessions rather than through a nested pytest run: the
behaviour under test is what two consecutive sessions leave in the file, and a stand-in states
each session's selection exactly.
"""

from __future__ import annotations

import importlib.util
import json
from dataclasses import dataclass, field
from pathlib import Path
from types import ModuleType
from typing import TYPE_CHECKING

import pytest

if TYPE_CHECKING:
    from collections.abc import Callable, Iterator

pytestmark = [pytest.mark.unit, pytest.mark.story("US014")]

ROOT_CONFTEST = Path(__file__).resolve().parents[2] / "conftest.py"


def _load_root_conftest() -> ModuleType:
    """Load the root conftest under a private name, so pytest's own registration is untouched."""
    spec = importlib.util.spec_from_file_location("_root_conftest_under_test", ROOT_CONFTEST)
    assert spec is not None
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


@dataclass
class _Item:
    """The slice of ``pytest.Item`` the writer reads: a node id, its markers, its function."""

    nodeid: str
    stories: tuple[str, ...] = ()
    obj: Callable[[], None] = field(default=lambda: None)

    def iter_markers(self, name: str | None = None) -> Iterator[pytest.Mark]:
        marks = [pytest.mark.story(*self.stories).mark] if self.stories else []
        return iter(mark for mark in marks if name is None or mark.name == name)


@dataclass
class _Session:
    items: list[_Item]


def _documented() -> None:
    """Writes the record's Why column."""


UNIT_TEST = _Item("apps/core/tests/unit/test_x.py::test_marked", ("US014",), _documented)
INTEGRATION_TEST = _Item("apps/core/tests/test_y.py::test_unmarked")


@pytest.fixture
def conftest_module(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> ModuleType:
    module = _load_root_conftest()
    monkeypatch.setattr(module, "STORY_MAP_PATH", tmp_path / "story-map.json")
    return module


def _map(module: ModuleType) -> list[dict[str, object]]:
    path: Path = module.STORY_MAP_PATH
    entries: list[dict[str, object]] = json.loads(path.read_text(encoding="utf-8"))
    return entries


def test_a_later_session_keeps_an_earlier_sessions_story_entries(
    conftest_module: ModuleType,
) -> None:
    """A unit phase's marked test survives an integration phase that selects none."""
    conftest_module.pytest_collection_finish(_Session([UNIT_TEST]))
    conftest_module.pytest_collection_finish(_Session([INTEGRATION_TEST]))

    entries = _map(conftest_module)

    assert [entry["nodeid"] for entry in entries] == [UNIT_TEST.nodeid]
    assert entries[0]["stories"] == ["US014"]
    assert entries[0]["docstring"] == "Writes the record's Why column."


def test_a_rerun_test_replaces_its_own_entry_rather_than_duplicating_it(
    conftest_module: ModuleType,
) -> None:
    """The same node id written twice is one entry, carrying the latest markers."""
    conftest_module.pytest_collection_finish(_Session([UNIT_TEST]))
    retagged = _Item(UNIT_TEST.nodeid, ("US008", "US014"), _documented)
    conftest_module.pytest_collection_finish(_Session([retagged]))

    entries = _map(conftest_module)

    assert len(entries) == 1
    assert entries[0]["stories"] == ["US008", "US014"]


def test_a_test_that_loses_its_marker_leaves_the_map(conftest_module: ModuleType) -> None:
    """A session is authoritative for the tests it ran: an unmarked rerun drops the old entry."""
    conftest_module.pytest_collection_finish(_Session([UNIT_TEST]))
    conftest_module.pytest_collection_finish(_Session([_Item(UNIT_TEST.nodeid)]))

    assert _map(conftest_module) == []


def test_an_unreadable_previous_map_is_replaced_not_fatal(conftest_module: ModuleType) -> None:
    """A corrupt map from an interrupted run never fails the next session; it is rewritten."""
    path: Path = conftest_module.STORY_MAP_PATH
    path.write_text("{not json", encoding="utf-8")

    conftest_module.pytest_collection_finish(_Session([UNIT_TEST]))

    assert [entry["nodeid"] for entry in _map(conftest_module)] == [UNIT_TEST.nodeid]
