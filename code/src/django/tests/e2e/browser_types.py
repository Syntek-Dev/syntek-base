"""The value objects the browser suite is configured with.

Three types, shared by ``a11y_config.py`` and ``conftest.py``, and the reason they are a
module rather than dictionaries in each file: a viewport is a **record whose keys are known
at design time** — ``width`` and ``height``, never anything else — and a colour scheme is a
**closed set of two values**. Both were previously ``dict[str, ...]`` literals, which meant
a misspelt key was a ``KeyError`` at scan time rather than an error at edit time, and the two
files disagreed about what a viewport was without either of them being wrong.

The standard: ``code/docs/data-structures/TYPES-OVER-DICTIONARIES.md``.

**Where the dictionary comes back, and why that is correct.** Playwright's API takes a
``{"width": …, "height": …}`` mapping, so the conversion has to happen somewhere. It happens
in ``Viewport.to_playwright()`` and nowhere else — one named boundary, greppable, testable,
and the only place in the suite that knows Playwright's spelling.
"""

from __future__ import annotations

from dataclasses import dataclass
from enum import StrEnum

__all__ = ["ColourScheme", "ScanProject", "Viewport"]


class ColourScheme(StrEnum):
    """The two colour schemes a scan runs under.

    A ``StrEnum`` rather than a plain ``Enum`` because the value crosses a boundary — it is
    handed to Playwright and written into the JSON report — and a value that crosses a
    boundary must be a **stable string**. An ``IntEnum`` would make the report's contents a
    promise about declaration order that a future edit silently breaks.

    Spelt the British way here because it is ours; ``to_playwright()`` below is where it
    becomes Playwright's ``color_scheme``. That translation is the boundary doing its job,
    not an inconsistency.
    """

    LIGHT = "light"
    DARK = "dark"


@dataclass(frozen=True, slots=True)
class Viewport:
    """A browser viewport in CSS pixels."""

    width: int
    height: int

    def to_playwright(self) -> dict[str, int]:
        """The mapping Playwright's ``viewport=`` and ``set_viewport_size()`` expect.

        DICT-OK: Playwright's API signature, not ours — confined to this method, which is
        the suite's only crossing point into that library's vocabulary.
        """
        return {"width": self.width, "height": self.height}


@dataclass(frozen=True, slots=True)
class ScanProject:
    """One accessibility scan configuration — a viewport at a colour scheme.

    ``name`` is carried **on the object** rather than being a dictionary key above it, so a
    project can be passed to a fixture as one value and still identify itself in a report.
    That is what removed the ``page.__dict__["_scan_project"]`` stash the suite used to need:
    there is no longer a name to smuggle alongside the object.
    """

    name: str
    viewport: Viewport
    colour_scheme: ColourScheme
