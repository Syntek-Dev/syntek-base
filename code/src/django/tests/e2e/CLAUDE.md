@./CONTEXT.md

# CLAUDE.md — code/src/django/tests/e2e/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(why the layer exists, viewport projects, the a11y gate — imported above) → this file.

## Purpose (one line)

The browser-level suite — a real Chromium driven from pytest against a running stack,
for the handful of things the Django test client cannot see.

## How to work here

- **Routing:** `test-writer` or `qa-tester` (Opus), loading `stack-htmx-templates`.
  Run via `code/src/scripts/tests/e2e-py.sh` — **never `pytest` or `playwright`
  directly.**
- **Model:** Opus for authoring a spec and for running the suite.
- **Concrete steps:** bring the stack up (`development/server.sh up`) → add the page to
  `a11y_config.PAGES` and/or a row to `OVERFLOW_PAGES` → run `e2e-py.sh -k <name>` while
  iterating, then the whole suite → reports land in
  `code/src/scripts/tests/reports/a11y/`.
- **Definition of done:** the suite exits `0` against the dev stack; every new public
  route appears in `a11y_config.PAGES`; no critical or serious axe violation.

## Guardrails

- **Justify the browser.** If a test does not need layout, CSS resolution, or JavaScript,
  it belongs in `apps/<app>/tests/` through the Django test client instead — that suite
  is faster, runs in CI on every push, and counts towards the coverage floor. This one
  does none of those things.
- **Measure overflow, never screenshot it.** `has_horizontal_overflow()` compares
  `scrollWidth` to `clientWidth`. A screenshot diff fails on any rendering difference and
  tells you nothing about the cause.
- **A new public page means a new `PAGES` entry** — the a11y gate silently covers only
  what that tuple lists, so an unlisted page is an unscanned page.
- **Every `SUPPRESSIONS` entry carries a ticket.** `id`, `selector`, `justification`, and
  a non-empty `ticket` — an undocumented waiver is rejected in review.
- **Never add `django_db` or a model import here.** These tests do not own the database
  the running stack is using; the root `conftest.py` marks the whole directory `e2e`
  specifically to keep `django_db` off it.
- **Chromium only.** The runner installs one engine deliberately; do not parametrise
  across browsers without deciding to carry the install cost.

## Output & naming

- **Hand-written:** every `.py` here.
- **Generated (gitignored):** `code/src/scripts/tests/reports/a11y/<page>--<project>.json`.
- Modules `test_e2e_<area>.py`; fixtures in `conftest.py`; scan configuration in
  `a11y_config.py` and nowhere else.
