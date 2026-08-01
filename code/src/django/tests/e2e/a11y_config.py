"""Accessibility scan configuration — the single source for the a11y gate.

This is deliberately data, not code: the page list, tags and thresholds live here so the
gate's coverage is reviewable in one diff. **Add every new public-facing page here when
it ships** — a page absent from ``PAGES`` is a page the gate does not scan.

Every entry in ``SUPPRESSIONS`` must carry ``id``, ``selector``, ``justification`` and a
non-empty ``ticket`` — undocumented waivers are rejected in review.
"""

from __future__ import annotations

from typing import TypedDict

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

# The four scan projects: desktop and mobile, each in light and dark. Dark mode is applied
# automatically via `prefers-color-scheme`, so dark-mode contrast regressions are only
# caught if it is scanned too.
SCAN_PROJECTS: dict[str, dict[str, object]] = {
    "desktop": {"viewport": {"width": 1280, "height": 800}, "color_scheme": "light"},
    "mobile": {"viewport": {"width": 375, "height": 812}, "color_scheme": "light"},
    "desktop-dark": {"viewport": {"width": 1280, "height": 800}, "color_scheme": "dark"},
    "mobile-dark": {"viewport": {"width": 375, "height": 812}, "color_scheme": "dark"},
}
