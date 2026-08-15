"""Accessibility scan configuration — the single source for the a11y gate.

This is deliberately data, not code: the page list, tags and thresholds live here so the
gate's coverage is reviewable in one diff. **Add every new public-facing page here when
it ships** — a page absent from ``PAGES`` is a page the gate does not scan.

Every entry in ``SUPPRESSIONS`` must carry ``id``, ``selector``, ``justification`` and a
non-empty ``ticket`` — undocumented waivers are rejected in review.

``Suppression`` stays a ``TypedDict`` on purpose: it describes a **waiver record read by a
script**, and its four keys are exactly what a reviewer writes by hand. ``SCAN_PROJECTS``
used to be a ``dict[str, dict[str, object]]`` beside it, which was the same information with
none of the checking — that inconsistency inside one module is why the value objects in
``browser_types.py`` exist (``code/docs/data-structures/TYPES-PYTHON.md``).
"""

from __future__ import annotations

from typing import TypedDict

from tests.e2e.browser_types import ColourScheme, ScanProject, Viewport

# WCAG 2.2 AA only. AAA rules are excluded — they produce false positives against a
# design that never claimed AAA.
AXE_TAGS: tuple[str, ...] = ("wcag2aa", "wcag22aa")

# Impact levels that fail the build, and those merely reported.
FAIL_IMPACTS: frozenset[str] = frozenset({"critical", "serious"})
WARN_IMPACTS: frozenset[str] = frozenset({"moderate", "minor"})

# Per-page navigation budget, in milliseconds.
PAGE_TIMEOUT_MS = 30_000


class Suppression(TypedDict):
    """A documented, ticketed waiver for a single axe rule on a single selector."""

    id: str
    selector: str
    justification: str
    ticket: str


SUPPRESSIONS: tuple[Suppression, ...] = ()

# Public-facing pages to scan. At baseline the project serves only Django's admin at
# `/control/`, which is not a public page and is not ours to hold to WCAG — so this list
# is empty and `test_a11y_scan` skips. Populate it with the first marketing route.
#
#   PAGES = (
#       "/",
#       "/about/",
#       "/contact/",
#   )
PAGES: tuple[str, ...] = ()

# The two widths every scan project is built from. Named once so "the desktop width" is a
# single edit rather than four matching literals.
DESKTOP_VIEWPORT = Viewport(width=1280, height=800)
MOBILE_VIEWPORT = Viewport(width=375, height=812)

# The four scan projects: desktop and mobile, each in light and dark. Dark mode is applied
# automatically via `prefers-color-scheme`, so dark-mode contrast regressions are only
# caught if it is scanned too.
#
# A tuple of records, not a dict keyed by name: the name is a property of the project, so it
# belongs on the object. Keying a dict by it put the identifier one level above the thing it
# identified, which is what forced the fixture to smuggle the key alongside the value.
SCAN_PROJECTS: tuple[ScanProject, ...] = (
    ScanProject("desktop", DESKTOP_VIEWPORT, ColourScheme.LIGHT),
    ScanProject("mobile", MOBILE_VIEWPORT, ColourScheme.LIGHT),
    ScanProject("desktop-dark", DESKTOP_VIEWPORT, ColourScheme.DARK),
    ScanProject("mobile-dark", MOBILE_VIEWPORT, ColourScheme.DARK),
)
