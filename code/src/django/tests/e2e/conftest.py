"""Fixtures for the browser-level e2e suite.

This file is what a ``playwright.config.ts`` would otherwise declare. Two things it
carries are load-bearing and must not be lost in a refactor:

* **The three viewport "projects"** — desktop 1280x800, mobile 375x812, tablet 768x1024.
  Every project is Chromium; the test image installs Chromium alone, so a "project" here
  is simply a viewport.
* **Reduced motion for accessibility scans.** Scroll-driven reveal animations typically
  hold their content at ``opacity: 0`` until it scrolls into view, which hides it from
  axe's contrast checks. The a11y suite forces ``reduced_motion="reduce"`` so the page
  renders at its final, fully-visible state.

The base URL defaults to the dev stack behind nginx, which the compose file publishes on
host port **81** (not 80 — a local router commonly holds `127.0.0.1:80`). Override with
``E2E_BASE_URL``.
"""

from __future__ import annotations

import os
from typing import TYPE_CHECKING, Any

import pytest

from tests.e2e.browser_types import Viewport

if TYPE_CHECKING:
    from collections.abc import Iterator

    from playwright.sync_api import Page

# The dev stack serves the whole site through nginx on host port 81. `e2e-py.sh` uses the
# same default, so the script and the suite point at one place.
DEFAULT_BASE_URL = "http://dev.<%PROJECT_SLUG%>.localhost:81"

# The viewport matrix a Playwright config would express as "projects". A mapping from a
# project name to its size is a genuine index — the name is the lookup key a test
# parametrises over — so the dict is correct here; what is not correct is a bare
# `{"width": …, "height": …}` as the value, which is a record with known keys.
VIEWPORTS: dict[str, Viewport] = {
    "chromium": Viewport(width=1280, height=800),
    "mobile": Viewport(width=375, height=812),
    "tablet": Viewport(width=768, height=1024),
}


@pytest.fixture(scope="session")
def base_url() -> str:
    """The running stack under test.

    Overrides ``pytest-playwright``'s own ``base_url`` fixture so ``page.goto("/about/")``
    resolves without every test repeating the host.
    """
    return os.environ.get("E2E_BASE_URL", DEFAULT_BASE_URL).rstrip("/")


@pytest.fixture(scope="session")
def browser_context_args(browser_context_args: dict[str, Any], base_url: str) -> dict[str, Any]:
    """Default every context to the desktop viewport and the shared base URL.

    Individual tests narrow this with ``page.set_viewport_size(...)``.
    """
    # DICT-OK: pytest-playwright's own fixture contract is a kwargs mapping it splats into
    # `browser.new_context()` — confined to this fixture, which is the seam into that plugin.
    return {
        **browser_context_args,
        "base_url": base_url,
        "viewport": VIEWPORTS["chromium"].to_playwright(),
    }


@pytest.fixture(params=sorted(VIEWPORTS), ids=sorted(VIEWPORTS))
def viewport_name(request: pytest.FixtureRequest) -> str:
    """Parametrise a test across all three viewport projects.

    Request this where a Playwright config's ``projects`` array would have run the same
    spec at every width.
    """
    return str(request.param)


@pytest.fixture
def sized_page(page: Page, viewport_name: str) -> Iterator[Page]:
    """A page pre-sized to the current viewport project."""
    page.set_viewport_size(VIEWPORTS[viewport_name].to_playwright())
    yield page


def has_horizontal_overflow(page: Page) -> bool:
    """True when the document scrolls sideways at the current viewport.

    Overflow is asserted by **measurement, never by screenshot comparison** — a screenshot
    diff fails on any rendering difference and tells you nothing about the cause.
    """
    return bool(
        page.evaluate(
            "() => document.documentElement.scrollWidth > document.documentElement.clientWidth"
        )
    )
