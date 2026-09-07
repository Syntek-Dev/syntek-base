---
type: guide
skills: [stack-wagtail]
model: opus
---

# Wagtail — Contrib Surfaces

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

> **CMS-only.** This guide exists only in a project generated with `INCLUDE_WAGTAIL`.

The `wagtail.contrib.*` apps are optional add-ons upstream. Two of them are on this project's
mandatory app list, so they arrive switched on whether or not anyone asked for them, and one of
those two is a personal-data sink. A third collides with a route this project has already
claimed for a view of its own. Read the upstream index at
[Contrib modules](https://docs.wagtail.org/en/stable/reference/contrib/index.html); this guide
covers what changes about them here.

| Module                               | Status here              | Upstream                                                                                              |
| ------------------------------------ | ------------------------ | ----------------------------------------------------------------------------------------------------- |
| `wagtail.contrib.forms`              | **Mandatory**            | [Form builder](https://docs.wagtail.org/en/stable/reference/contrib/forms/index.html)                 |
| `wagtail.contrib.redirects`          | **Mandatory**            | [Redirects](https://docs.wagtail.org/en/stable/reference/contrib/redirects.html)                      |
| `wagtail.contrib.sitemaps`           | **Collides** — undecided | [Sitemap generator](https://docs.wagtail.org/en/stable/reference/contrib/sitemaps.html)               |
| `wagtail.contrib.settings`           | Opt-in                   | [Settings models](https://docs.wagtail.org/en/stable/reference/contrib/settings.html)                 |
| `wagtail.contrib.routable_page`      | Opt-in                   | [RoutablePageMixin](https://docs.wagtail.org/en/stable/reference/contrib/routablepage.html)           |
| `wagtail.contrib.frontend_cache`     | Opt-in                   | [Frontend cache invalidator](https://docs.wagtail.org/en/stable/reference/contrib/frontendcache.html) |
| `wagtail.contrib.search_promotions`  | Opt-in                   | [Promoted search results](https://docs.wagtail.org/en/stable/reference/contrib/searchpromotions.html) |
| `wagtail.contrib.table_block`        | Opt-in                   | [TableBlock](https://docs.wagtail.org/en/stable/reference/contrib/table_block.html)                   |
| `wagtail.contrib.typed_table_block`  | Opt-in                   | [Typed table block](https://docs.wagtail.org/en/stable/reference/contrib/typed_table_block.html)      |
| `wagtail.contrib.simple_translation` | Opt-in                   | [Simple translation](https://docs.wagtail.org/en/stable/reference/contrib/simple_translation.html)    |
| `wagtail.contrib.legacy.richtext`    | Avoid                    | [Legacy richtext](https://docs.wagtail.org/en/stable/reference/contrib/legacy_richtext.html)          |

---

## 1. The form builder is a personal data sink, switched on

`wagtail.contrib.forms` lets an editor assemble a form in the page editor: a page model extends
`AbstractEmailForm` (or `AbstractForm` where no email is wanted), a `FormField` inline defines
the fields, and every submission lands in a `FormSubmission` row. **The field set is chosen by
an editor at runtime**, so the submitted payload is stored as a JSON blob rather than columns.

That is the whole problem. A surface an editor can point at "NHS number" tomorrow is a
special-category data collector with no schema review, and it is installed by default.

- **Classification comes first, before the field exists.** What may be collected, and at what
  sensitivity, is `code/docs/security/CRYPTO-AND-DATA.md`. The form builder does not classify
  anything for you.
- **Encryption at rest** for anything classified as PII follows `code/docs/ENCRYPTION-GUIDE.md`.
  A JSON blob is not exempt because it is a blob.
- **Row scoping** of submissions is `code/docs/rls/FUNDAMENTALS.md`, not the Wagtail admin's own
  permission model.
- **Export and erasure** are `project-management/docs/gdpr/DATA-RIGHTS.md`. **These are a
  merge-blocking criterion and Wagtail exposes neither** — the admin offers a CSV download of a
  form's submissions, which is not a subject access response and not a deletion path. **The
  project owns the wrappers**: a service that finds every submission belonging to a data
  subject across every form page, and one that erases them.
- **The blob is the one place a dictionary is legitimate** here, because the keys genuinely are
  data. Everything wrapping it is a named type — see
  `code/docs/data-structures/TYPES-EXCEPTIONS.md` for the `DICT-OK:` boundary marker.

The seam for all of this is a custom submission model: override `get_submission_class()` and
`process_form_submission()` on the page, per
[Form builder customisation](https://docs.wagtail.org/en/stable/reference/contrib/forms/customization.html).
Do this **before the first submission**, for the same reason the custom image model precedes the
first upload.

**Wagtail's `PageLogEntry` and `Revision` never satisfy this project's audit record** — a
submission read, exported or erased is an audit event under
`code/docs/security/AUDIT-TRAIL.md` (rule: `code/docs/WAGTAIL.md`).

Two further traps: `AbstractEmailForm` mails submissions to an **editor-supplied address**, which
puts PII in plaintext transit under someone else's control (`code/docs/NOTIFICATIONS.md`), and the
`DATA_UPLOAD_MAX_NUMBER_FIELDS = 10_000` this project raises for Wagtail's page editor lifts the
ceiling on what a public form submission may post too, so validating what a form accepts is yours
(`code/docs/security/INPUT-AND-API.md`).

---

## 2. Redirects, and the one middleware Wagtail requires

`wagtail.contrib.redirects` is the only Wagtail app on the mandatory list that also adds
middleware: `wagtail.contrib.redirects.middleware.RedirectMiddleware`, which sits **after every
other middleware** because it works by catching a 404 and looking the path up.

Two behaviours to know before it ships:

- **Redirects are created automatically** when a page moves or its slug changes, preserving
  inbound links. Upstream calls this well suited to sites of about 5,000 pages or fewer;
  `WAGTAILREDIRECTS_AUTO_CREATE = False` turns it off.
- **A redirect is editor-writable routing.** An editor can point any path at any URL, including
  an external one, which is an open-redirect surface reachable without a deploy. Treat the
  target field as untrusted input (`code/docs/security/INPUT-AND-API.md`) and the redirect table
  as part of the route map that `code/docs/URL-STRATEGY.md` governs.

An `import_redirects` management command ships with the app; running it follows
`code/docs/MANAGEMENT-COMMANDS.md`, and every dev operation goes through the project scripts.

---

## 3. Discoverability — the `<head>` first, then the sitemap

**Decision 4 of the six a CMS project settles once is raised here** (`code/docs/WAGTAIL.md` ·
`code/docs/wagtail/FUNDAMENTALS.md`): **who owns the `<head>`**. A Wagtail page carries its own
`seo_title` and `search_description` and serves itself, while this project assembles every head
through `build_seo()` (`code/docs/DISCOVERABILITY.md`, per page:
`project-management/docs/SEO-CHECKLIST.md`). Either the page fields feed that pipeline or they
bypass it; two pipelines emitting one `<head>` is the failure mode, and bridging them is work
rather than a default.

The sitemap is the same question one level out. `code/docs/discoverability/ROOT-SURFACE.md`
specifies `/sitemap.xml` as this project's own Django view generated from published state —
**specified, not yet built**. Wagtail ships `wagtail.contrib.sitemaps`, whose view wraps
`django.contrib.sitemaps` so that the Wagtail `Site` record is available during generation, and
which walks the published page tree.

**Both cannot own `/sitemap.xml`.** The options are one merged view that includes CMS pages, two
views at separate paths behind an index, or Wagtail's view superseding the project's. Settle it
alongside the `<head>`, record the outcome in `project-management/src/15-DECISIONS/`, and do not
resolve either inside a story.

Whatever wins, two mechanical facts hold: `django.contrib.sitemaps` must be in `INSTALLED_APPS`,
and the sitemap route must be registered **above** the Wagtail page-serving catch-all in
`code/src/django/config/urls.py`. **The Wagtail catch-all is always last, and the editor admin
never mounts at `/admin/`** (rule: `code/docs/WAGTAIL.md` · route map:
`code/docs/URL-STRATEGY.md`). Per-page control is `Page.get_sitemap_urls()`, which returns a list
of location dictionaries and an empty list to exclude the page.

---

## 4. Site settings are content, not configuration

`wagtail.contrib.settings` registers models an editor can edit from the admin Settings menu:
`BaseGenericSetting` for values shared across every site, `BaseSiteSetting` for per-site values,
both wired up with the `register_setting` decorator. Reading them in a template needs the
`wagtail.contrib.settings.context_processors.settings` context processor, or the
`{% get_settings %}` tag outside a request context.

**They are not Django settings.** They are database rows, editable without review or deploy, and
the two share only a word. Upstream keeps them on different pages, and both are worth reading:

- [Settings models](https://docs.wagtail.org/en/stable/reference/contrib/settings.html) — the
  contrib app described above.
- [Settings](https://docs.wagtail.org/en/stable/reference/settings.html) — Wagtail's own Django
  settings reference, where `WAGTAIL_SITE_NAME`, `WAGTAILADMIN_BASE_URL` and
  `WAGTAIL_APPEND_SLASH` are defined, and which belongs in
  `code/src/django/config/settings/base.py`.

Never move into an editable settings model: a secret, a flag that gates a permission check, or a
design value. Secrets stay in the environment, permission decisions stay in code
(`code/docs/security/AUTH-AND-AUTHZ.md`), and design values are already DB-canonical through a
different layer (`code/docs/DESIGN-TOKENS.md`). Access the values through a named type rather
than passing the settings object around (`code/docs/data-structures/TYPES-OVER-DICTIONARIES.md`).

---

## 5. Routable pages — when a page owns its sub-URLs

`RoutablePageMixin` lets one page instance answer several paths — `/blog/2013/06/`,
`/blog/tagged/python/` — through view methods decorated with `path` or `re_path`. A default
route for `r'^$'` serves the page normally unless a method overrides it. Punctuation is not
supported in the patterns.

| Use a routable page when                              | Use a Django view when                              |
| ----------------------------------------------------- | --------------------------------------------------- |
| The sub-URL is a facet of editable page content       | The URL is a product surface with no page behind it |
| An editor moving the page must move the sub-URLs too  | The path is fixed in the route map                  |
| The template and context come from the page model     | The response is JSON, a file, or a redirect         |
| The route is a listing, filter or archive of children | The route mutates state or needs a permission check |

A state-changing route belongs in a Django Ninja endpoint with an explicit permission check
(`code/docs/API-DESIGN.md` · `code/docs/api-design/NINJA-CONVENTIONS.md`), never in a page view
method. Where the interaction runs is `code/docs/RENDERING.md`.

Override `get_route_paths()` on a routable page so the redirects app creates redirects for its
alternative routes when the page moves.

---

## 6. The remaining surfaces

- **Frontend cache invalidation.** `wagtail.contrib.frontend_cache` registers signal handlers
  that purge a page's URL from Varnish, Cloudflare or CloudFront when it is published or
  deleted, configured through `WAGTAILFRONTENDCACHE`. It purges **HTML**, and nothing else:
  **renditions are Willow-generated files stored on Cloudinary, never on the app filesystem**
  (rule: `code/docs/WAGTAIL.md`), and their cache is a separate concern
  (`how-to/src/PLATFORM-PROVIDERS.md` · `code/docs/PERFORMANCE.md`).
- **Promoted search results.** `wagtail.contrib.search_promotions` lets editors pin pages to
  search terms, surfaced with `{% get_search_promotions %}`. It decorates a results page; the
  backend behind it is `code/docs/wagtail/API-AND-SEARCH.md`.
- **Table blocks.** `table_block` and `typed_table_block` give editors a grid inside a
  StreamField. Editor-authored tables are the usual source of missing header scopes and captions
  — hold them to `code/docs/ACCESSIBILITY.md`, and see
  `code/docs/wagtail/PAGES-AND-STREAMFIELD.md` for the block itself.
- **Simple translation** adds a per-page action that **copies** a page into another locale — the
  copy arrives in the source language and in draft, so a human still translates it. **Legacy
  richtext** installs as `wagtail.contrib.legacy.richtext` (a dot, not an underscore) and only
  restores the `<div class="rich-text">` wrapper the `richtext` filter once emitted; it has no
  place in a new build.

---

## Related

- `code/docs/WAGTAIL.md` — the parent index, the settled decisions, the version floor
- `code/docs/wagtail/FUNDAMENTALS.md` — install order, app list, settings
- `code/docs/wagtail/PAGES-AND-STREAMFIELD.md` — page types and blocks
- `code/docs/wagtail/IMAGES-AND-MEDIA.md` — renditions and storage
- `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md` — the editor admin and moderation
- `code/docs/wagtail/API-AND-SEARCH.md` — the v2/v3 APIs, search, Modelsearch
- `.claude/skills/stack-wagtail/` — the skill that loads this family
