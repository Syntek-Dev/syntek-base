"""Accessibility scan — axe-core WCAG 2.2 AA across every public page.

Uses ``axe-core-python``, which bundles ``axe.min.js``, so the gate carries no Node and
no CDN fetch. Scans ``len(PAGES)`` pages across four projects (desktop/mobile x
light/dark). Critical and serious violations fail; moderate and minor are reported as
warnings. Results are written per page/project so CI can publish them.

At baseline ``PAGES`` is empty and every scan skips. That is the correct behaviour for a
template with no public routes — but it means **the gate is only as good as
``a11y_config.PAGES``**, so add each page as it ships.
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import TYPE_CHECKING, Any

import pytest
from axe_core_python.sync_playwright import Axe

from tests.e2e.a11y_config import (
    AXE_TAGS,
    FAIL_IMPACTS,
    PAGE_TIMEOUT_MS,
    PAGES,
    SCAN_PROJECTS,
)

if TYPE_CHECKING:
    from collections.abc import Iterator

    from playwright.sync_api import Browser, Page

# parents[3] is code/src (this file is code/src/django/tests/e2e/), which puts the output
# under the gitignored code/src/scripts/tests/reports/.
RESULTS_DIR = Path(__file__).resolve().parents[3] / "scripts" / "tests" / "reports" / "a11y"

AXE_OPTIONS: dict[str, Any] = {"runOnly": {"type": "tag", "values": list(AXE_TAGS)}}


def _describe(violations: list[dict[str, Any]]) -> str:
    """Render violations for an assertion message — rule, impact, and the first 3 nodes."""
    blocks: list[str] = []
    for violation in violations:
        impact = violation.get("impact") or "unknown"
        header = f"  [{impact}] {violation['id']}: {violation['description']}"
        nodes = "\n".join(
            f"    ↳ {node.get('html', '')}" for node in violation.get("nodes", [])[:3]
        )
        blocks.append(f"{header}\n{nodes}" if nodes else header)
    return "\n\n".join(blocks)


@pytest.fixture(params=sorted(SCAN_PROJECTS), ids=sorted(SCAN_PROJECTS))
def scan_page(request: pytest.FixtureRequest, browser: Browser, base_url: str) -> Iterator[Page]:
    """A page configured for one of the four scan projects.

    ``reduced_motion`` is set on the context rather than left to a device preset.
    Scroll-driven reveal animations hold their content at ``opacity: 0`` until scrolled
    into view, hiding it from axe's contrast checks; under reduced motion the reveal CSS
    is inert and the page renders at its final, fully-visible state.
    """
    project = SCAN_PROJECTS[str(request.param)]
    context = browser.new_context(
        base_url=base_url,
        viewport=project["viewport"],
        color_scheme=project["color_scheme"],
        reduced_motion="reduce",
    )
    page = context.new_page()
    page.__dict__["_scan_project"] = str(request.param)
    yield page
    context.close()


@pytest.mark.skipif(not PAGES, reason="no public pages configured — see a11y_config.PAGES")
@pytest.mark.parametrize("page_path", PAGES)
def test_a11y_scan(scan_page: Page, page_path: str) -> None:
    """No critical or serious WCAG 2.2 AA violations on *page_path*."""
    project = scan_page.__dict__["_scan_project"]

    scan_page.goto(page_path, wait_until="networkidle", timeout=PAGE_TIMEOUT_MS)

    results = Axe().run(scan_page, options=AXE_OPTIONS)
    violations: list[dict[str, Any]] = results.get("violations", [])

    failures = [v for v in violations if (v.get("impact") or "") in FAIL_IMPACTS]
    warnings = [v for v in violations if (v.get("impact") or "") not in FAIL_IMPACTS]

    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    slug = page_path.strip("/").replace("/", "__") or "home"
    (RESULTS_DIR / f"{slug}--{project}.json").write_text(
        json.dumps(
            {
                "page": page_path,
                "project": project,
                "failures": failures,
                "warnings": warnings,
                "passCount": len(results.get("passes", [])),
            },
            indent=2,
        ),
        encoding="utf-8",
    )

    assert not failures, (
        f"Critical/serious violations on {page_path} ({project}):\n\n{_describe(failures)}"
    )
