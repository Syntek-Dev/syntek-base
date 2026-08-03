---
workflow: 20-frontend-code
phase: build
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Frontend Code — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

This workflow produces code — consult **both** layer reference files:

| Step       | File                               | Section                                                                                                                                            |
| ---------- | ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| All steps  | `code/REFERENCES.md`               | **Guides in code/docs/** → CODING-PRINCIPLES.md, ACCESSIBILITY.md, RESPONSIVE-DESIGN.md, rendering/TEMPLATES-AND-INTERACTIVITY.md, URL-STRATEGY.md |
| Components | `code/REFERENCES.md`               | **External — Framework & Language Docs → Frontend** → Django + django-components, HTMX, Alpine                                                     |
| Styling    | `code/REFERENCES.md`               | **External — Framework & Language Docs → Styling** → CSS custom properties (MDN)                                                                   |
| Tests      | `code/REFERENCES.md`               | **External — Testing** → pytest, pytest-django, factory_boy                                                                                        |
| Standards  | `code/REFERENCES.md`               | **External — Security & Standards** → WCAG 2.2 AA                                                                                                  |
| Artefacts  | `project-management/REFERENCES.md` | **Internal — Live Artefacts** → src/08-WIREFRAMES/, src/07-COMPONENTS/                                                                             |
| **Mobile** | `code/REFERENCES.md`               | **Mobile-only** → `code/docs/accessibility/MOBILE.md`, `code/docs/design-tokens/MOBILE.md`, `code/src/mobile/CONTEXT.md`                           |

---

## Surfaces

This workflow covers the frontend of **whichever surfaces the story touches**. Steps 1–11 are the
**web surface** (Django templates + django-components + HTMX + Alpine). **Step 4M is mobile-only**
and applies solely to a project generated with the mobile surface.

**Why the frontmatter still says `agent: frontend`.** The `mobile` agent and the
`stack-react-native` skill do not exist in a web-only project, so routing frontmatter naming them
would point at nothing on half of all generated projects. The mobile route is therefore named at
its point of use, in Step 4M, where its absence is self-explanatory. This is deliberate, not an
omission.

`frontend` keeps its remit unchanged and is **web-only** — it hands mobile work over rather than
applying Django-template assumptions to React Native.

---

## Steps

### Step 1 — Grill, then Review Wireframes and Component Designs

> **Model:** opus · **MCP:** figma, code-review-graph (reference only)

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> one question at a time — the component structure (reuse from the
django-components library vs new), the states to implement (default, hover, focus,
disabled, error, empty), the interactions, whether each one runs on the server, through
HTMX, or in Alpine, and the WCAG 2.2 AA accessibility requirements before building.

Read the signed-off wireframes from `project-management/src/08-WIREFRAMES/` and the Figma
component designs for the feature area.

Before writing any code, read:

- `code/CONTEXT.md` — Django + django-components conventions, template structure, frontend tooling rules
- `code/docs/coding-principles/STYLE-AND-PROCESS.md` — component design rules, naming, single-responsibility
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements for all interactive components
- `code/docs/performance/FRONTEND-PERFORMANCE.md` — page weight, HTMX tuning, fragment caching, Core Web Vitals

Identify:

- Which pages and routes are needed
- Which components are new vs reused — check `code/src/django/components/` first
- The data the view must put in the template context, and which parts of the page are HTMX swap targets

### Step 2 — Scaffold the Public Page (marketing pages only)

For a new public marketing page, scaffold the Django view, template, and `urls.py`
entry — never hand-create route directories:

```bash
bash code/src/scripts/development/new-django-view.sh <route_path>
```

An HTMX partial needs no scaffold — add `_<name>.html` beside the page template and
`{% include %}` it from the full page, so both request paths render the same markup.

### Step 3 — Implement Pages and Routes

Follow `code/workflows/01-new-feature/` for the full-stack feature checklist.

```text
frontend [describe the pages and routes to implement]
```

> **↳ New agent:** `frontend` · **Model:** opus · **MCP:** none

- Public pages are Django views + templates under `code/src/django/` (`apps.marketing`)
- Fetch page data from the Django view context — the public site is server-rendered (no client-side data fetching)
- Follow the component hierarchy from the wireframes

### Step 4 — Implement Components

**Component placement — decide before writing any component code:**

| Artefact type                                                        | Location                                                                                                                                     |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Design tokens (colour, spacing, radius, typography, shadows, motion) | `code/src/django/apps/design_tokens/` — DB-canonical; enter via the `/admin/design-tokens` editor or a migration, consumed as `var(--token)` |
| Reusable server-rendered component (used in 2+ pages or areas)       | `code/src/django/components/<name>/` — a django-component, reused via `{% component %}`                                                      |
| Area layout shell (reusable page skeleton within an area)            | a base template in `code/src/django/templates/` extended via `{% extends %}` — see the `marketing`, `portal` areas for the pattern           |
| Page-specific template partial or HTMX/Alpine behaviour              | alongside the page template in `code/src/django/templates/`                                                                                  |
| HTMX swap target (a fragment a view returns on `HX-Request`)         | `_<name>.html` beside the page template, `{% include %}`d by the full page so both paths share one source                                    |
| Route, page, or view                                                 | `code/src/django/apps/marketing/` (view + `urls.py`) with its template in `code/src/django/templates/`                                       |

`code/src/django/apps/design_tokens/` is the **only** source of design token values. No page
or component CSS may define its own colour, spacing, radius, typography, shadow, or motion values.
If a token does not exist, add it via the `/admin/design-tokens` editor or a migration — never a
raw literal in component/page CSS. Component CSS only ever consumes `var(--token)`.
`code/src/django/components/` is the authority for component styling and BEM conventions.

If a page renders Cloudinary-hosted images or video, build the delivery URL server-side with the
Cloudinary Python SDK. Invoke `/cloudinary-transformations` for transformation URL syntax before
writing.

Build each component against its Figma design:

- Apply design tokens via CSS custom properties — no raw hex values
- Implement all required states (default, hover, focus, disabled, error, success, empty)
- Match the annotated accessibility requirements from the component design
- Follow naming and structure conventions in `code/docs/coding-principles/STYLE-AND-PROCESS.md`

### Step 4M — Implement Mobile Screens (mobile-only)

> **Skip entirely if `code/src/mobile/` does not exist** — the project has no mobile surface and
> this step, the `mobile` agent, and the `stack-react-native` skill are all absent.

```text
mobile [describe the screens to implement]
```

> **↳ New agent:** `mobile` · **Skill:** `stack-react-native` · **Model:** opus · **MCP:** none

The mobile app is a **separate deployable that consumes the same Django Ninja API** — it renders
no Django page and Django never bundles it. Do not carry template, HTMX, or CSS assumptions
across; read `code/src/mobile/CLAUDE.md` first.

- **Routes** are expo-router files under `code/src/mobile/app/`. That directory is **routes only** —
  every file in it becomes a route, so tests go in `code/src/mobile/__tests__/`, never beside their
  subject
- **Styling** is `StyleSheet.create` over the generated token module — never a raw literal.
  A genuinely structural value carries a `token-allow` comment with a reason
  (`code/docs/design-tokens/MOBILE.md`)
- **Accessibility** is the same WCAG 2.2 AA standard with a different technique set —
  `accessibilityRole` on everything interactive, state in `accessibilityState` and never baked
  into the label, and platform touch-target minimums (44 pt iOS / 48 dp Android), which are
  stricter than WCAG's 24 × 24 (`code/docs/accessibility/MOBILE.md`)
- **Never commit `ios/` or `android/`** — Expo regenerates them, and committing them would put
  binaries in a tree that Copier cannot render

Run every operation through the scripts — never raw `pnpm`, `expo`, `tsc`, or `jest`:

```bash
bash code/src/scripts/mobile/lint.sh
bash code/src/scripts/mobile/typecheck.sh
bash code/src/scripts/mobile/test.sh --coverage
bash code/src/scripts/audits/mobile-tokens.sh
bash code/src/scripts/mobile/bundle.sh
```

`bundle.sh` is the gate that catches a test or dev-only import leaking into the production
bundle. Run it before raising a PR, not after.

**Accessibility verification here is manual.** There is no React Native counterpart to
`axe-core-python`, so Step 8's automated browser suite has no mobile equivalent. React Native
Testing Library queries (`getByRole`, `getByLabelText`) catch missing props in unit tests; the
rest is VoiceOver on iOS **and** TalkBack on Android — neither is a proxy for the other. Never
record mobile a11y as "scanned clean".

### Step 5 — Write Tests

Follow `code/workflows/02-tdd-cycle/` for the red-green-refactor steps.

```text
test-writer [describe the components and pages to test]
```

> **↳ New agent:** `test-writer` · **Model:** opus · **MCP:** none

Refer to `code/docs/testing/FRONTEND-TESTING.md`. Frontend tests are **pytest** tests through the
Django test client — there is no client-side runner, and they count towards the single backend
coverage floor (75% line and branch).

Test cases must cover:

- The page renders with the expected data (assert on `response.context`, not the full HTML)
- Validation failure re-renders the form with its errors at `200`
- The HTMX branch returns the partial and no page chrome; the full-page branch returns the document
- Response headers that drive the page (`HX-Trigger`, `HX-Redirect`) are asserted
- Accessibility — landmarks, heading order, labels, and accessible names in the rendered markup
- Query counts on any page that loops over a queryset (`django_assert_num_queries`)

### Step 6 — Run Tests and Enforce Coverage

```bash

```

### Step 7 — Accessibility Check

Verify WCAG 2.2 AA compliance on all interactive components using the full checklist
in `code/docs/ACCESSIBILITY.md`:

- Colour contrast ratios
- Keyboard navigability and focus order
- Screen reader labels (ARIA)

### Step 8 — Visual Verification

> **Model:** opus · **MCP:** claude-in-chrome (reference only)

Start the dev server and verify the golden path and edge cases in the browser, then run the
automated browser suite:

```bash
bash code/src/scripts/tests/e2e-py.sh
```

Add the new route to `a11y_config.PAGES` and `OVERFLOW_PAGES` first — the gate covers only what
those tuples list. Contrast, focus order, and screen-reader announcement stay a manual pass.

```bash
bash code/src/scripts/development/server.sh up --service django
```

Use `mcp__claude-in-chrome__*` for automated visual verification where applicable.

### Step 9 — Lint and Type-Check

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

### Step 10 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

### Step 11 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
