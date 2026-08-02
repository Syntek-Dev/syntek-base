---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Rendering Strategy — the Interaction-Model Doctrine

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — where an interaction runs (server / HTMX / Alpine) and why

Governs the **Django-templated** frontend. Every page is server-rendered Django templates with
django-components, enhanced by HTMX (server ops) and Alpine (local interactions). There is **no
client-side framework and no Node server**: Django renders every page, and the browser receives
HTML rather than a bundle that renders HTML.

## Why SSR/HTMX is right for _this_ app

For content, forms, and CMS-style sites serving broad audiences on ordinary hardware, the
interactions that matter are genuine **server operations** (save, load, submit, navigate, moderate,
publish) — a round-trip is expected, and fast first load / TTI (no large JS bundle to download,
parse, hydrate) dominates. The failure mode to engineer around is **per-interaction latency without
feedback**, and **rapid/fine-grained** interactions (live-filter-as-you-type, drag-reorder,
interdependent fields), which are worse over the network. The craft is knowing which interactions to
leave on the server (most) and which to keep client-side in Alpine (the few rapid ones).

## The doctrine (the decision rule)

| Interaction class                                                                       | Runs where                       | Rule                                                                            |
| --------------------------------------------------------------------------------------- | -------------------------------- | ------------------------------------------------------------------------------- |
| First load / navigation / content                                                       | **Server** (full HTML template)  | Default. Fast TTI, no hydration, server is source of truth.                     |
| Meaningful server op (save, submit, load, moderate, publish)                            | **HTMX** fragment swap           | Expected to hit the server; **always** an `htmx-indicator` / `hx-disabled-elt`. |
| Rapid / fine-grained (live-filter, drag-reorder, interdependent fields, menus, toggles) | **Alpine**, local, no round-trip | Keep off the network; sync on commit, not per-keystroke.                        |

There is no fourth row. An interaction that seems to need one — a rich editor, a canvas, a
real-time board — is a decision to reopen the stack choice, not a component to bolt on; it is
argued in an ADR before any dependency lands.

**Non-negotiable (review-gated):** every HTMX interaction that isn't near-instant must show
feedback. Un-fed-back latency reads as broken.

## Hard rules

- **`hx-boost` is BANNED.** Every server op is an explicit `hx-*` element on the element that owns
  it — never a blanket boost that turns links into ajax.
- **Content must be usable with JS disabled.** All navigation is real `<a href>`; Alpine and HTMX
  only _enhance_. A page with scripts blocked still renders and links still work.
- **No inline `<script>`/`<style>`** (CSP-clean). Alpine reads HTML attributes (`x-data`, `@click`);
  htmx is configured via a `<meta name="htmx-config">`; per-page JS is a static file.
- **Server-render first, cache whole.** Anonymous GET pages are cached by `cache_marketing`
  (versioned Valkey page cache). Anything that varies per-visitor (consent banner, analytics) is
  decided **client-side** so the cached HTML is identical for everyone.
- **Accessibility on swaps:** manage focus and use `aria-live` for HTMX-swapped regions; assert the
  markup-level rules in pytest and work the manual checklist (`code/docs/ACCESSIBILITY.md`).

## Where each concern lives

| Concern                | Home                                                                   |
| ---------------------- | ---------------------------------------------------------------------- |
| Page views / templates | `apps/marketing/views/` + `templates/marketing/` (extends `base.html`) |
| Reusable UI            | django-components in `code/src/django/components/`                     |
| Server ops (HTMX)      | view returns a fragment; template posts with `hx-post` + indicator     |
| Local interactivity    | Alpine `x-data` (nav menu, dropdowns, consent banner, tabs)            |
| Per-page SEO `<head>`  | `apps/marketing/seo.build_seo` + `_seo_head.html`                      |
| Block content          | Python `render_blocks` (server-side, golden-fixture tested)            |

## Testing

- View/template/fragment correctness → **pytest** through the Django test client (assert on
  rendered fragments; golden fixtures for `render_blocks`). See
  `code/docs/testing/FRONTEND-TESTING.md`.
- Alpine has no unit layer. Its behaviour is reachable only from the browser suite
  (`code/src/django/tests/e2e/`), which is deliberately small — so keep Alpine state
  presentational and put anything worth testing on the server.

## Sub-documents

- `rendering/TEMPLATES-AND-INTERACTIVITY.md` — when an interaction belongs on the server, in HTMX,
  or in Alpine.
- `rendering/PITFALLS-AND-EXAMPLES.md` — HTMX / Alpine pitfalls with worked examples.

See also: `.claude/skills/stack-htmx-templates/SKILL.md` (stack idioms),
`apps/marketing/CONTEXT.md` (app structure), `code/docs/PERFORMANCE.md` (caching).
</content>
</invoke>
