---
name: frontend
description: >-
  Build the web frontend of <%PROJECT_NAME%> — Django templates, django-components, HTMX,
  Alpine, and token-driven vanilla CSS, all server-rendered with no client build step. Load
  when a story needs its pages or components built, or an existing screen needs a UI, WCAG 2.2
  AA or visual-language pass. Not the models, services or endpoints behind it (`backend`), not
  login, session or CSRF flows (`authentication`), not authoring its tests (`test-writer`), and
  not the separate React Native deployable (`stack-react-native`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling stack-htmx-templates
---

# Build the Web Frontend (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable build task whose output is templates,
components and token CSS).

**Surface boundary.** This is the **web surface only**. Every page is server-rendered — there
is no React and no client build step, and that stays absolutely true in a project that also
carries the optional React Native surface. Work under `code/src/mobile/` belongs to
`stack-react-native`; never carry React Native patterns back to these pages, and never apply
Django-template assumptions to that one (`code/src/CONTEXT.md` → _Surfaces_).

**Locale:** British English throughout, including every user-facing string.

---

## The brief arrives settled

A fork cannot open a grilling pass, so the design must already exist. The brief must carry the
**screen's wireframe** (`project-management/src/08-WIREFRAMES/WF-###-*`), the **component
designs** (`src/07-COMPONENTS/`) and the **brand foundations** (`src/06-BRAND-GUIDE/`) — or
name the established code pattern being followed. **With no artefact and no pattern, flag it
and return; do not improvise a design.** Where the design itself is what needs settling, that
is a `grilling` pass run inline before this skill is dispatched: component structure, every
state (loading, empty, error), where each interaction runs, the WCAG needs, the breakpoints,
and which token each value resolves to.

## Interaction doctrine

Place every interaction by class, not by habit (full doctrine: `code/docs/RENDERING.md`):

- **First load, navigation, content** → server-rendered full HTML. The default.
- **Meaningful server operation** (save, submit, load, moderate, publish) → **HTMX** fragment
  swap, **always** with a visible indicator (`htmx-indicator` / `hx-disabled-elt`). A
  non-instant HTMX interaction with no feedback is a defect — a review gate, peer to WCAG.
- **Rapid or fine-grained interaction** (live-filter, drag-reorder before save, interdependent
  fields, menus, toggles) → **Alpine**, local, no round-trip; synced on commit.
- **`hx-boost` is banned.** Content must be usable without JavaScript.

## How to work

1. **Reuse before you build — the live code is the truth.** Check the
   `code/src/django/components/` catalogue before authoring a new component; duplicating a
   shared one is a defect, and shared UI is a `{% component %}`, never inline markup. Read the
   shipped code and reconcile the wireframe against it: **where the code has moved on, follow
   the code and surface the drift** rather than re-applying a stale design.
2. **Compose from services, not the API.** Marketing pages pull published content from the
   domain services directly (SSR), never through the JSON API — replicating the endpoint's
   field masks as they stand.
3. **Rich admin editing is server-rendered too.** Where a screen needs more than HTMX affords,
   reach for Alpine. A new build step is an architectural decision, not a frontend one.
4. **Comment the why only** — one pronoun-free line per view, template and component on why it
   exists; the markup states the what. No story, ticket, doc path, person or date, and no
   `TODO`/`FIXME` (route to `DEFERRED.md` / `GAPS.md`).

## Guardrails

- **Token-first CSS.** Component and page CSS consume `var(--token)` only — never a raw hex,
  px or rem literal. New values enter through the `/admin/design-tokens` editor or a migration,
  and the var must resolve in the token layer. Verify: `audits/css-tokens.sh`.
- **Gradients are tokens, never inline.** No raw `linear-`/`radial-`/`conic-gradient(…)` in
  component or page CSS — a generic inline ramp (blue→purple above all) is the AI-look tell.
  A functional gradient (shimmer, mask) stays inline only with a `gradient-allow` annotation.
  Verify: `audits/css-gradients.sh`.
- **No em dashes in user-facing copy** — reword rather than substituting a spaced en dash;
  numeric ranges (`Mon–Fri`) keep theirs. Verify: `audits/copy-emdash.sh`.
- **No machine cadence in user-facing copy.** `how-to/src/BRAND-VOICE.md` Section 4 is the ban list
  and carries each clause's tier — **route to it, never restate it**. Verify:
  `audits/copy-slop.sh`, and treat a `[gate: warn]` as a question to answer, not noise.
- **Pills and eyebrows label taxonomy, sparingly** — a blog topic, a case-study category, a
  pricing tier. Not a decoration on every heading. Default to none.
- **Distinctive, on-brand UI — never the generic AI-look.** Hit the signature
  `code/docs/visual-design/WEB.md` sets for the direction named in `code/docs/VISUAL-DESIGN.md`
  Section 3; Section 4.1 is the universal tells and Section 4.2 the deviations that read off that direction's
  axes. **Section 4.2 cannot be judged without Section 3** — read both, every time.
- **WCAG 2.2 AA** on every interactive element: semantic HTML, associated labels, keyboard
  operability, visible focus, focus trapping on modals, 4.5:1 text contrast.
- **New public marketing page** → `bash code/src/scripts/development/new-django-view.sh
<route_path>`. Never hand-create the route files.
- **No PII in client storage** — non-sensitive identifiers only; clear form state after
  submission.

## Verify before handing back

```bash
bash code/src/scripts/audits/css-tokens.sh
bash code/src/scripts/audits/css-gradients.sh
bash code/src/scripts/audits/copy-emdash.sh
bash code/src/scripts/audits/copy-slop.sh
bash code/src/scripts/tests/backend.sh    # marketing view and template tests
```

## Definition of done

The page renders 200 and is responsive across the breakpoint scale with no horizontal scroll;
it is grounded in the live code and built to its wireframe and component designs, hitting the
visual signature for the committed direction; every value resolves to a token and no gradient
is inline; the copy carries no machine tell; the shared `site_footer` legal set is present;
WCAG 2.2 AA met; every HTMX server operation shows an indicator; content usable without
JavaScript; the five gates above clean.

## Handoff

Report what changed, which shared components were reused or newly extracted, and any drift
found between the design artefacts and the shipped code. Then name what is owed:
`test-writer` for view and template tests, `qa-tester` for the accessibility and edge-case
pass, `backend` for anything needing a service or endpoint, `authentication` for a session or
CSRF flow, `seo` for a public page's head and structured data, and `refactor` for a structural
change with no behaviour change.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/20-frontend-code/` — the frontend build phase
- `project-management/workflows/07-component-designs/` — the component designs consumed here
- `project-management/workflows/08-wireframes/` — the wireframes consumed here
- `code/workflows/01-new-feature/` — the full-stack feature procedure
- `code/workflows/02-tdd-cycle/` — template, component and HTMX-partial tests

## Cross-references

- `code/docs/RENDERING.md` — where each interaction runs; the doctrine above in full
- `code/docs/DESIGN-TOKENS.md` — the token catalogue and the `var(--token)`-only contract
- `code/docs/FRONTEND-CODING-PRINCIPLES.md` — component placement, grounding in the live code,
  the legal footer as data, and the single-component-system rule
- `code/docs/VISUAL-DESIGN.md` · `code/docs/visual-design/WEB.md` — the direction and its
  web expression
- `code/docs/ACCESSIBILITY.md` · `code/docs/RESPONSIVE-DESIGN.md` — the two standards floors
- `how-to/src/BRAND-VOICE.md` — the voice every user-facing string is written in
- `code/docs/URL-STRATEGY.md` — `/admin/` is this project's admin, never Django contrib's
- `code/src/django/apps/marketing/CONTEXT.md` · `code/src/django/components/CONTEXT.md`
