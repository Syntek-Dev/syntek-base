---
type: guide
skills: [stack-wagtail]
model: opus
---

# Wagtail — Fundamentals

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

> **CMS-only.** This guide exists only in a project generated with `INCLUDE_WAGTAIL`.

Read this before any other file in `code/docs/wagtail/`. It is the base layer: what Wagtail's
objects are, what it refuses to be, the order the install has to happen in, and the version
floor underneath all of it. The settled decisions and the standing-standards map are in
`code/docs/WAGTAIL.md` and are not restated here.

Upstream entry points: [Getting started](https://docs.wagtail.org/en/stable/getting_started/index.html)
and [The Zen of Wagtail](https://docs.wagtail.org/en/stable/getting_started/the_zen_of_wagtail.html).
The [tutorial](https://docs.wagtail.org/en/stable/getting_started/tutorial.html) builds a
greenfield project and is worth reading for its shape, not its commands — none of them are how
work runs here.

---

## The mental model

### The page tree

Every piece of page content is a row in one table, and every row has exactly one parent. There is
a single root, created by Wagtail's own migrations, and everything else descends from it. `Page`
subclasses django-treebeard's materialised-path node, so ancestry, ordering and depth are encoded
in a path column rather than walked with recursive queries — which is why `get_children()`,
`get_ancestors()` and `descendant_of()` are cheap and why moving a page rewrites paths for the
whole subtree. The theory, and the parent/leaf modelling habit that follows from it, is
[Pages — Theory](https://docs.wagtail.org/en/stable/reference/pages/theory.html).

**The tree is also the URL structure.** A page's slug plus its ancestors' slugs is its path, so
the content hierarchy and the public route table are the same object. That is the first of the
six decisions below and the reason `code/docs/URL-STRATEGY.md` has to be read alongside this.

### Page, Snippet, Setting

Three model kinds, distinguished by whether the thing has a URL and whether there is one of it:

| Kind        | Has a URL | Lives in the tree | Use it for                                                                         |
| ----------- | --------- | ----------------- | ---------------------------------------------------------------------------------- |
| **Page**    | Yes       | Yes               | Anything a visitor navigates to                                                    |
| **Snippet** | No        | No                | Reusable content with many instances — an author, a call-to-action, a footer block |
| **Setting** | No        | No                | One editable record per site or per install — contact details, social links        |

References: [Page models](https://docs.wagtail.org/en/stable/topics/pages.html) ·
[Snippets](https://docs.wagtail.org/en/stable/topics/snippets/index.html) ·
[Settings models](https://docs.wagtail.org/en/stable/reference/contrib/settings.html). Choosing
between them is `code/docs/wagtail/PAGES-AND-STREAMFIELD.md`.

### Sites, and how a hostname reaches a page

A `Site` row maps a **hostname and port** to a **root page**, with one row flagged the default.
`Site.find_for_request()` resolves the incoming request against that table, and the matched
site's root page is what answers `/`. Wagtail's first migration writes a default site pointing at
the root page; its hostname is a placeholder and correcting it is part of the install, not an
afterthought. Fields and methods: [Site](https://docs.wagtail.org/en/stable/reference/models.html).
Running several of them from one deployable is
[multi-site, multi-instance and multi-tenancy](https://docs.wagtail.org/en/stable/advanced_topics/multi_site_multi_instance_multi_tenancy.html).

### Locales

A `Locale` row is a language this install can hold content in, and a translatable model carries a
locale plus a translation key linking its variants. Translation is a **content structure**, not a
template-level `gettext` concern, and turning it on later means a data migration —
[Internationalisation](https://docs.wagtail.org/en/stable/advanced_topics/i18n.html).

### Drafts, revisions, live

A page carries both a published state and an edit buffer. Saving writes a `Revision` — a JSON
snapshot of the whole object — and publishing copies the latest revision onto the live row and
sets `live=True`. So a page can be live and simultaneously hold newer unpublished edits;
`Page.objects.live()` is what a public view queries, and the editor sees the draft.

**Revisions are not the audit trail.** `PageLogEntry` and `Revision` record editorial history for
editors, and never discharge the obligations in `code/docs/security/AUDIT-TRAIL.md`
(`code/docs/WAGTAIL.md`). Upstream's own framing:
[Audit log](https://docs.wagtail.org/en/stable/extending/audit_log.html).

### Collections

Images and documents do not sit in the page tree. They sit in a **Collection** — a second, much
shallower tree whose only job is to scope media for permissions, so a group can be given upload
rights over one collection and not another. It is the unit of media access control, not a folder
for tidiness: [Permissions](https://docs.wagtail.org/en/stable/topics/permissions.html).

---

## What Wagtail is not

- **Not a theme system.** There are no downloadable themes and no template inheritance from a
  vendor. Every page type ships its own template, written to
  `code/docs/FRONTEND-CODING-PRINCIPLES.md` and consuming `var(--token)` like any other
  component. Wagtail states this itself: _"Wagtail is not an instant website in a box"_
  ([The Zen of Wagtail](https://docs.wagtail.org/en/stable/getting_started/the_zen_of_wagtail.html)).
- **Not a plugin marketplace.** Packages exist, but the assumption is that you write Python. A
  requirement met by installing a third-party app is a dependency decision under
  `how-to/src/PLATFORM-PROVIDERS.md`, not a configuration change.
- **Not headless by default.** Wagtail renders server-side templates through the same request
  cycle as the rest of this deployable — which is exactly what this project wants
  (`code/docs/RENDERING.md`). The APIs are additive and opt-in
  (`code/docs/wagtail/API-AND-SEARCH.md`).
- **Not a second permission system you can ignore.** It brings its own groups, its own
  collection-scoped rights and its own admin, on top of Django's
  (`code/docs/wagtail/ADMIN-AND-PERMISSIONS.md`).

---

## Installing it

### The gate: six decisions, recorded before the second page type exists

Wagtail installs into the existing deployable, so it lands on top of conventions this project has
already settled. Six of them it contradicts or extends. Settle each once, record it in
`project-management/src/15-DECISIONS/`, and do not re-answer it per story.

| #   | Decision                                                              | Argued in                                                                             |
| --- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| 1   | Which of the page tree or a Django view owns each public route        | below, plus `code/docs/URL-STRATEGY.md`                                               |
| 2   | Which store is authoritative for CMS roles, and how it stays in step  | `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md`                                          |
| 3   | Whether Wagtail's tables lacking a scope column is acceptable here    | `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md`, against `code/docs/rls/FUNDAMENTALS.md` |
| 4   | Who owns the `<head>` — Wagtail's page fields or `build_seo()`        | `code/docs/wagtail/CONTRIB-SURFACES.md`, against `code/docs/DISCOVERABILITY.md`       |
| 5   | The `how-to/src/PLATFORM-PROVIDERS.md` substrate row, with its reason | below                                                                                 |
| 6   | How brand voice is enforced on content the prose gate cannot read     | `code/docs/WAGTAIL.md`                                                                |

**On (1):** the catch-all route means Wagtail answers anything no earlier pattern claimed, so
"who owns this URL" stops being obvious the moment both exist. Decide by surface — the marketing
tree, say, versus everything under a functional prefix — and write the boundary down; do not
resolve it per route later.

**On (5):** Wagtail is a **substrate**, not an adapter seam. Once page models subclass `Page`
there is nothing behind it to swap, so the register row records a dependency accepted with its
eyes open, not a provider that could be replaced.

### The order

Every command below runs through `code/src/scripts/**/*.sh` — never a raw `python`, `pip`, `uv`
or `pytest` invocation, whether you are running it or writing it into a doc
(`.claude/CLAUDE.md` Section 6).

1. **The dependency.** Add `wagtail` at `>=8.0,<9.0` to the Django package's dependencies, then
   re-resolve through `code/src/scripts/dependencies/update.sh`. Read the version floor below
   first — the resolution pulls Django Ninja, DRF and `django-tasks` in with it.
2. **The thirteen `INSTALLED_APPS` entries** in `code/src/django/config/settings/base.py`:
   `wagtail`, `wagtail.admin`, `wagtail.search`, `wagtail.images`, `wagtail.documents`,
   `wagtail.snippets`, `wagtail.users`, `wagtail.sites`, `wagtail.embeds`,
   `wagtail.contrib.forms`, `wagtail.contrib.redirects`, plus `taggit` and `modelcluster`. What
   each provides: [Integrating Wagtail into a Django project](https://docs.wagtail.org/en/stable/advanced_topics/add_to_django_project.html).
3. **One middleware entry** — `wagtail.contrib.redirects.middleware.RedirectMiddleware`, appended
   after the existing stack. It is the only one Wagtail adds.
4. **The required settings.** `WAGTAIL_SITE_NAME` (the name editors see on login),
   `WAGTAILADMIN_BASE_URL` (absolute-URL base for notification emails; no admin path, no trailing
   slash), and `DATA_UPLOAD_MAX_NUMBER_FIELDS = 10_000`, because a StreamField editor posts far
   more form fields than Django's default allows. Every other knob:
   [Settings reference](https://docs.wagtail.org/en/stable/reference/settings.html).
5. **The custom image and document models, declared now.** They must exist before the first
   upload — switching afterwards copies nothing automatically (`code/docs/WAGTAIL.md`,
   `code/docs/wagtail/IMAGES-AND-MEDIA.md`). Storage is Cloudinary beneath Wagtail's own Willow
   pipeline, never the app filesystem (`code/docs/OBJECT-STORAGE.md`).
6. **Three URL routes** in `code/src/django/config/urls.py`, in this order: the Wagtail admin
   (**never** at `/admin/` — `code/docs/URL-STRATEGY.md` owns the prefix), the documents serve
   view, and the Wagtail catch-all **last**, after every project route. A catch-all that is not
   last silently shadows the routes below it.
7. **Migrate.** `code/src/scripts/database/migrate.sh make --app <app>` then
   `code/src/scripts/database/migrate.sh run`. This creates Wagtail's tables, the root page and
   the default `Site` row. Lock-safety rules are unchanged (`code/docs/DATABASE.md`).
8. **Create the first page.** Make an editor account with
   `code/src/scripts/database/manageusers.sh create-superuser`, bring the stack up with
   `code/src/scripts/development/server.sh up`, correct the default `Site` hostname and port,
   then add a home page beneath the root through the CMS admin.

---

## The version floor, and the LTS trap

Wagtail **8.0** (25/08/2026) is the floor. It is the release that
[introduced formal Django 6.1 support](https://docs.wagtail.org/en/stable/releases/8.0.html),
which this stack requires. It also inherits the search backend that **7.2** moved out into the
separate `modelsearch` package (`code/docs/wagtail/API-AND-SEARCH.md`). Its dependency
consequences — Django Ninja, DRF, `django-tasks` — are in `code/docs/WAGTAIL.md` and settled
there.

**The trap:** Wagtail publishes LTS releases roughly annually and the reflex is to pin to one.
The current LTS is **7.4** (05/05/2026), which predates Django 6.1 entirely. Pinning to it means
downgrading Django, not stabilising Wagtail. There is no LTS fallback for this stack until the
next LTS ships with 6.1 support.

So **verify before assuming**, every time this comes up: the
[release notes index](https://docs.wagtail.org/en/stable/releases/index.html) names the current
LTS, [Upgrading Wagtail](https://docs.wagtail.org/en/stable/releases/upgrading.html) gives both
the cadence — a feature release every three months — and the procedure, one feature release at a
time, running the deprecation warnings out at each step. Dates and support windows are on
Wagtail's own [release schedule](https://github.com/wagtail/wagtail/wiki/Release-schedule).

---

## Where to go next

| Question                                                   | Guide                                        |
| ---------------------------------------------------------- | -------------------------------------------- |
| How do I model a page type, a block or a rich-text field?  | `code/docs/wagtail/PAGES-AND-STREAMFIELD.md` |
| Where do images and documents go, and what is a rendition? | `code/docs/wagtail/IMAGES-AND-MEDIA.md`      |
| Who gets into the CMS admin, and what may they publish?    | `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md` |
| Forms, redirects, sitemaps, per-site settings              | `code/docs/wagtail/CONTRIB-SURFACES.md`      |
| Exposing content over HTTP, or making it searchable        | `code/docs/wagtail/API-AND-SEARCH.md`        |
| What has already been decided across the whole surface?    | `code/docs/WAGTAIL.md`                       |
