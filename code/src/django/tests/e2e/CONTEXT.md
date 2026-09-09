# code/src/django/tests/e2e — Browser-Level End-to-End Tests

One browser driver, in Python. These tests drive a real Chromium against an
**already-running stack** over HTTP. They never touch the database through the ORM.

## Why this layer exists at all

Almost everything is cheaper to test through the Django test client — see
`code/docs/testing/FRONTEND-TESTING.md`, which is where template, component, and
HTMX-partial tests belong. This suite is for the small set of things that client
genuinely cannot see, because it executes no JavaScript and computes no layout:

| Needs a browser                            | Why the test client cannot do it                |
| ------------------------------------------ | ----------------------------------------------- |
| Horizontal overflow at a given width       | No layout engine — nothing has a computed width |
| Colour contrast, computed from the cascade | No CSS resolution                               |
| An HTMX swap actually landing in the DOM   | No JavaScript                                   |
| Alpine state after an interaction          | No JavaScript                                   |
| Focus order and keyboard traversal         | No focus model                                  |

If a test does not need one of those, it does not belong here.

## Directory tree

```text
code/src/django/tests/e2e/
├── __init__.py                       ← package marker
├── a11y_config.py                    ← page list, axe tags, impact thresholds, scan projects
├── browser_types.py                  ← Viewport · ColourScheme · ScanProject — the suite's value objects
├── CLAUDE.md                         ← operating rules
├── conftest.py                       ← viewport projects, base URL, overflow helper
├── CONTEXT.md                        ← this file
├── test_e2e_a11y.py                  ← axe-core WCAG 2.2 AA scan across every public page
└── test_e2e_marketing_overflow.py    ← table-driven responsive overflow + heading checks
```

## Running

The stack must already be up — the suite talks to it over HTTP:

```bash
bash code/src/scripts/development/server.sh up
bash code/src/scripts/tests/e2e-py.sh
```

```bash
# Narrow to matching tests
bash code/src/scripts/tests/e2e-py.sh -k overflow

# Watch it drive a real browser
bash code/src/scripts/tests/e2e-py.sh --headed

# One module
bash code/src/scripts/tests/e2e-py.sh code/src/django/tests/e2e/test_e2e_a11y.py
```

`E2E_BASE_URL` overrides the target; it defaults to the dev stack behind nginx on host
port **81**.

## The viewport projects

`conftest.py` declares what a `playwright.config.ts` would call `projects`:

| Name       | Size     |
| ---------- | -------- |
| `chromium` | 1280x800 |
| `mobile`   | 375x812  |
| `tablet`   | 768x1024 |

Every context defaults to `chromium`; a test narrows with `page.set_viewport_size(...)`,
or takes the `sized_page` fixture to be parametrised across all three.

## The a11y gate

`a11y_config.py` is the single source for the scan: `PAGES`, `AXE_TAGS` (WCAG 2.2 AA
only — AAA produces false positives against a design that never claimed it),
`FAIL_IMPACTS` (critical and serious fail; moderate and minor warn), and the four
`SCAN_PROJECTS` (desktop/mobile x light/dark, because dark-mode contrast regressions are
invisible to a light-only scan).

**The gate is only as good as `PAGES`.** A page missing from that tuple is a page nobody
scans. Add each public route as it ships.

Scans run with `reduced_motion="reduce"`: scroll-driven reveal animations hold content at
`opacity: 0` until it enters the viewport, which hides it from axe's contrast checks.
Under reduced motion the reveal CSS is inert and the page renders fully visible.

Results are written per page and project to `code/src/scripts/tests/reports/a11y/` (gitignored),
and read back by the test-record generator for the violation count on a story's accessibility row.

## What a run leaves behind

`e2e-py.sh` runs with a JUnit XML flag, so a run is a **record** as well as a gate. Both artefacts
are gitignored, and neither is written for a human to read:

| Artefact                                                     | Written by         | Read for                                   |
| ------------------------------------------------------------ | ------------------ | ------------------------------------------ |
| `code/src/scripts/tests/reports/e2e/results.xml`             | the JUnit XML flag | the E2E suite rollup and its per-test rows |
| `code/src/scripts/tests/reports/a11y/<page>--<project>.json` | `test_e2e_a11y.py` | the accessibility row's violation count    |

`bash code/src/scripts/tests/test-record.sh US###` turns both into the generated block of
`project-management/src/18-TESTS/US###-TEST-STATUS.md`. A browser test carrying no story marker is
absent from that block rather than failing the run — the marker itself is `CLAUDE.md`'s rule.

## The configuration is typed, not a nest of dictionaries

`SCAN_PROJECTS` and `VIEWPORTS` were both `dict[str, dict[str, …]]` — records whose keys were
known at design time, which meant a misspelt `"colour_scheme"` was a `KeyError` at scan time
rather than an error at edit time. They are now built from the three value objects in
`browser_types.py`: `Viewport`, the `ColourScheme` enum, and `ScanProject`, which carries its own
`name` so a project can be passed to a fixture as one value.

That last point removed a real defect: the a11y fixture used to smuggle the project name onto the
Playwright page with `page.__dict__["_scan_project"]`. It now yields a `ScannedPage` record
holding the page and its project together.

**Playwright's dictionary comes back at exactly one place** — `Viewport.to_playwright()` — which
is the boundary conversion the standard prescribes, marked `DICT-OK:` and confined to that method.
The rule: `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md`.

## Baseline state

`PAGES` and `OVERFLOW_PAGES` are both empty — the template serves no public routes yet,
so every test skips. That is correct, not broken. Populate both as the first marketing
pages land.

## Cross-references

- `code/docs/testing/FRONTEND-TESTING.md` — everything that does **not** need a browser
- `code/docs/accessibility/TESTING-AND-COMPONENTS.md` — what this gate does not cover
- `code/src/scripts/tests/CONTEXT.md` — the full runner inventory, and `test-record.sh`'s
  blast radius
- `project-management/src/18-TESTS/CONTEXT.md` — where a run's artefacts end up as a story record
