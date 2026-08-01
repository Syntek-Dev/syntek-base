"""Responsive overflow + heading coverage for every public marketing page.

Table-driven on purpose. Every page's responsive check is the same two assertions against
a different URL, so they are expressed here as **data rather than as one module per page**
— add a row, not a file.

Unit tests already cover metadata, headings and content. What they cannot do is detect
horizontal overflow, which needs a real layout at a real width — that is the whole reason
this layer exists.

Overflow is measured with ``page.evaluate`` (``scrollWidth > clientWidth``), **never** a
screenshot diff.
"""

from __future__ import annotations

from typing import TYPE_CHECKING

import pytest
from playwright.sync_api import expect

from tests.e2e.conftest import VIEWPORTS, has_horizontal_overflow

if TYPE_CHECKING:
    from playwright.sync_api import Page

MOBILE = VIEWPORTS["mobile"]  # 375x812
TABLET = VIEWPORTS["tablet"]  # 768x1024
DESKTOP = VIEWPORTS["chromium"]  # 1280x800

# Three standard widths — use for a page with a layout that changes twice.
ALL_THREE = (MOBILE, TABLET, DESKTOP)
# The narrow+wide pair — use where only the extremes carry risk.
NARROW_WIDE = (MOBILE, DESKTOP)

# (path, viewports) — one row per page.
#
# At baseline there are no public routes, so this is empty and the tests skip. Populate it
# alongside `a11y_config.PAGES` as pages ship:
#
#   OVERFLOW_PAGES = (
#       ("/", NARROW_WIDE),
#       ("/about/", ALL_THREE),
#       ("/contact/", NARROW_WIDE),
#   )
OVERFLOW_PAGES: tuple[tuple[str, tuple[dict[str, int], ...]], ...] = ()

# Every page that should render a visible top-level heading.
HEADING_PAGES: tuple[str, ...] = tuple(path for path, _ in OVERFLOW_PAGES)


def _viewport_id(viewport: dict[str, int]) -> str:
    return f"{viewport['width']}px"


@pytest.mark.skipif(not HEADING_PAGES, reason="no public pages configured — see OVERFLOW_PAGES")
@pytest.mark.parametrize("path", HEADING_PAGES)
def test_page_loads_with_a_main_heading(page: Page, path: str) -> None:
    """The page renders and its first heading is visible."""
    page.goto(path)

    expect(page.get_by_role("heading").first).to_be_visible()


@pytest.mark.skipif(not OVERFLOW_PAGES, reason="no public pages configured — see OVERFLOW_PAGES")
@pytest.mark.parametrize(
    ("path", "viewport"),
    [
        pytest.param(path, viewport, id=f"{path}-{_viewport_id(viewport)}")
        for path, viewports in OVERFLOW_PAGES
        for viewport in viewports
    ],
)
def test_no_horizontal_overflow(page: Page, path: str, viewport: dict[str, int]) -> None:
    """The page does not scroll sideways at this width."""
    page.set_viewport_size(viewport)
    page.goto(path)

    assert has_horizontal_overflow(page) is False
