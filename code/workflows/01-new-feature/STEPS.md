---
workflow: 01-new-feature
phase: build
agent: feature
skills: [stack-django, stack-htmx-templates, global-workflow]
model: opus
---

# Add a New Full-Stack Feature — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Steps | Section                                                                                                    |
| ----- | ---------------------------------------------------------------------------------------------------------- |
| 1–5   | **Guides in code/docs/** → CODING-PRINCIPLES.md, ARCHITECTURE-PATTERNS.md, DATA-STRUCTURES.md, SECURITY.md |
| 3–5   | **External — Framework & Language Docs → Backend** → Django 6.x, Django Ninja                              |
| 6–7   | **External — Framework & Language Docs → Frontend** → Django templates + django-components + HTMX + Alpine |
| 2, 8  | **External — Testing** → pytest, pytest-django, factory_boy                                                |
| 5, 9  | **Guides in code/docs/** → SECURITY.md (every state-changing endpoint must verify permissions — OWASP A01) |

---

## Prerequisites

- [ ] User story confirmed and branch created
- [ ] Containers running (`docker compose up -d`)
- [ ] No uncommitted changes from a previous workflow

---

## Steps

### Step 1 — Grill, then Architectural Plan

```text
planner [feature name and scope]
```

> **↳ New agent:** `planner` · **Model:** fable · **MCP:** code-review-graph

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> one question at a time about the feature's scope, data model, API surface,
permissions, and edge cases before producing the plan.

Save the plan to `project-management/src/15-STORY-PLANS/STORY-PLAN-US###-<DESCRIPTOR>.md`.

### Step 2 — Write Failing Tests First (Red Phase)

```text
test-writer [feature name] --mode failing-first
```

> **↳ New agent:** `test-writer` · **Model:** opus · **MCP:** none

Verify all new tests are **red** before proceeding.

### Step 3 — Backend: Models and Migration

```text
backend [create models for feature]
```

> **↳ New agent:** `backend` · **Model:** opus · **MCP:** code-review-graph

Then run:

```bash
bash code/src/scripts/database/migrate.sh make
bash code/src/scripts/database/migrate.sh run
```

### Step 3a — Register Models in Django Admin (`/control/`)

For every new model, open the app's `admin.py` and add a registration class. Minimum required:

```python
@admin.register(MyModel)
class MyModelAdmin(admin.ModelAdmin):
    list_display = (...)      # columns shown in the changelist
    list_filter = (...)       # right-hand filter sidebar (boolean, date, FK fields)
    search_fields = (...)     # fields searched by the search bar (use __ for relations)
    readonly_fields = (...)   # audit fields: auto_now, auto_now_add, encrypted fields
    ordering = (...)          # default sort order
```

Rules:

- `auto_now` / `auto_now_add` fields must be in `readonly_fields` (Django enforces this).
- Encrypted fields (`EncryptedCharField`, `EncryptedEmailField`) are not searchable — omit from `search_fields`.
- For related models (OneToOne, ForeignKey) prefer `TabularInline` or `StackedInline` on the parent admin rather than a separate registration.
- GDPR-sensitive models (consent, PII stores): make all fields `readonly_fields` — the admin is read-only for audit purposes.

### Step 4 — Backend: Service Layer

If the service wraps Cloudinary (upload, admin API, or media management), invoke `/cloudinary-docs`
first and read `code/docs/cloudinary/PYTHON_SDK.md` before implementing.

```text
backend [implement service methods for feature]
```

> **↳ New agent:** `backend` · **Model:** opus · **MCP:** none

Every service method doing ≥ 2 writes must use `transaction.atomic()`.

### Step 5 — Backend: Django Ninja Endpoints and Schema Models

```text
backend [implement Django Ninja endpoints and Schema models]
```

> **↳ New agent:** `backend` · **Model:** opus · **MCP:** none

Every state-changing endpoint must verify permissions before executing business logic — implement as a named Policy
class (see [CODING-PRINCIPLES.md — Decision Structuring](../../docs/CODING-PRINCIPLES.md#decision-structuring-boolean-policy-and-strategy)).

### Step 6 — Define Ninja Schemas (only if the feature has a machine-facing API)

Most features need no step here. Pages talk to Django views over HTMX and pass data through the
template context, not through JSON. Skip to Step 7 unless an external consumer — an integration,
a webhook, a future mobile client — needs this feature over the API.

If one does, define the Ninja Schema request/response models on the endpoint
(`apps/<app>/schemas.py`). The auto-generated OpenAPI schema at `/api/docs` is the contract those
consumers hold; commit it so CI can diff it (`code/docs/api-design/NINJA-CONVENTIONS.md`).

### Step 7 — Frontend: Components and Pages

**Component placement — decide before writing any component code:**

| Artefact type                                                        | Location                                                                                                  |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Design tokens (colour, spacing, radius, typography, shadows, motion) | DB-canonical in `apps/design_tokens`; CSS seed at `static/css/tokens/*.css`                               |
| Reusable component (`.py` + `.html` + `.css`, co-located)            | `code/src/django/components/<snake>/` — rendered with `{% component %}`                                   |
| Reusable server-rendered component                                   | a django-component under the owning Django app                                                            |
| Public page (Django view + template + URL)                           | scaffold with `bash code/src/scripts/development/new-django-view.sh <route_path>`                         |
| HTMX partial (a swap target)                                         | `_<name>.html` beside the full-page template, `{% include %}`d by it so both paths render the same markup |
| Per-page JavaScript (rare)                                           | a static `.js` file — never an inline `<script>`                                                          |

`apps/design_tokens` is the **only** source of design token values — never define colour, spacing, radius, typography, shadow, or motion values in component or page CSS directly. If a token does not exist, add it via the `/admin/design-tokens` editor or a migration first.

If a page renders Cloudinary-hosted images or video, invoke `/cloudinary-transformations` for URL
transformation syntax before writing. Delivery URLs are built server-side with the Python SDK
(`code/docs/cloudinary/PYTHON_SDK.md`) — there is no client-side Cloudinary SDK.

```text
frontend [implement the Django template, components, and HTMX partials]
```

> **↳ New agent:** `frontend` · **Model:** opus · **MCP:** none

Place each interaction by class — server, HTMX, or Alpine (`code/docs/RENDERING.md`). Every HTMX
request carries an `hx-indicator`. All interactive elements must meet WCAG 2.2 AA.

### Step 7M — Frontend: Mobile Screens (mobile-only)

> **Skip entirely if `code/src/mobile/` does not exist** — the project is web-only, and this step,
> the `mobile` agent, and the `stack-react-native` skill are all absent.

```text
mobile [describe the screens to implement]
```

> **↳ New agent:** `mobile` · **Skill:** `stack-react-native` · **Model:** opus · **MCP:** none

The mobile app consumes the **same Django Ninja API built in Steps 5–6** — it is a separate
deployable, not a client for the Django pages, so nothing from Step 7 carries across. Routes are
expo-router files under `code/src/mobile/app/`; styling is `StyleSheet` over the token module;
WCAG 2.2 AA holds with a React Native technique set (`code/docs/accessibility/MOBILE.md`).

Full procedure, including the checklist: `project-management/workflows/18-frontend-code/`
→ Step 4M.

### Step 8 — Make Tests Green

```bash
bash code/src/scripts/tests/backend.sh
```

All tests written in Step 2 must be green. Return to the relevant step if any fail.

**Mobile-only:** the mobile suite is a second runtime and is not covered by the command above.

```bash
bash code/src/scripts/mobile/test.sh --coverage
bash code/src/scripts/mobile/bundle.sh
```

### Step 9 — Code Review and QA

```text
review
```

> **↳ New agent:** `review` · **Model:** opus · **MCP:** code-review-graph

```text
qa-tester
```

> **↳ New agent:** `qa-tester` · **Model:** opus · **MCP:** code-review-graph

### Step 10 — Implementation Documentation (hand off to PM 19)

Hand the story to `project-management/workflows/19-implementation-documentation/`. That
workflow **owns** the closeout and is its single source of truth — do not restate the record
formats, destinations, or templates here; a second copy is exactly how they drift.

```text
doc-writer
```

> **↳ New agent:** `doc-writer` · **Model:** opus · **MCP:** code-review-graph

It covers, in order:

1. the IMPLEMENTATION record for every design/compliance spec that applied to the story —
   GDPR, security, QA, SEO, API — each copied from its `.../IMPLEMENTATION/US000-TEMPLATE.md`
   and closed against its `PLANNING/` artefact with code evidence
2. the story's findings record in `project-management/src/18-FINDINGS/`
3. the `/GAPS.md` and `/DEFERRED.md` routing for anything that cannot close in this PR
4. the `CONTEXT.md` / `CLAUDE.md` closeout across every touched layer, **and** the
   code-review-graph refresh alongside it

**Hard gate:** implementation docs, the touched `CONTEXT.md`/`CLAUDE.md`, and the graph refresh
must all be complete **before any commit** (`.claude/CLAUDE.md` §6).

**Stays in this layer:** if the story added or changed the Django Ninja API surface, the Bruno
tests are a code artefact, not a PM record — one `.bru` file per endpoint plus error scenarios,
in `code/src/tests/api/<domain>/`. Write them here, not in workflow 19.

### Step 11 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

---

## Error Handling

If tests fail after implementation: run `debugger` to find the root cause.

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
