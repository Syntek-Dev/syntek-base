# Wagtail CMS on the syntek-base stack

**Researched:** 07/09/2026 · **Sources checked against:** Wagtail 8.0, wagtail-ai 3.1.1,
django-ai-core 0.1.6

## Question

If a project generated from syntek-base needs a content management system, can Wagtail be that
CMS — and if so, what does the stack have to give up, buy or decide first?

Three sub-questions the answer turns on:

1. Does Wagtail 8 run on Django 6.1 and Python 3.14, which this template's floors require?
2. Do Wagtail's images go through Cloudinary, or does Wagtail bring its own pipeline?
3. Is Wagtail AI a usable part of that, given the brand-voice and PII doctrine?

## Verdict

**Wagtail 8.0 fits the stack, and the integration cost is almost entirely doctrine rather than
code.** The Django skeleton this template ships is small enough that Wagtail's settings and URL
requirements are appends, not a restructure. What is expensive is everything the repository's own
rules then demand: a second admin surface, a second permission store, an audit record that
Wagtail duplicates rather than satisfies, and a media pipeline that currently has nowhere legal
to write.

On the three sub-questions:

1. **Yes.** Wagtail 8.0 declares Django 6.1 support and classifies Python 3.14.
2. **Wagtail brings its own.** Renditions are new image files generated in-process by Willow and
   written through a Django storage backend. Cloudinary can be that backend, but it is storage,
   not the transformation engine, unless a third-party package or a custom image model is used.
   **Recommended: keep Wagtail's native pipeline, put the bytes on Cloudinary.**
3. **Not yet.** Wagtail AI has not been released against Wagtail 8 or Django 6, its dependency
   chain is alpha, and its output lands in the one place this repository's anti-slop gate cannot
   see.

## Claims

### 1. Version compatibility

**1.1 Wagtail 8.0 supports Django 6.1 and Python 3.14.** The PyPI metadata for wagtail 8.0
declares `requires_python >=3.10` with classifiers through `Programming Language :: Python ::
3.14`, and `Framework :: Django` classifiers for 5.2, 6.0 and 6.1. The 8.0 release notes, dated
25 August 2026, carry "Django 6.1 support" as a named feature.
_Sources: [S1], [S2]._

**1.2 The template's floors are `django>=6.1` and `requires-python >=3.14`.** Both sit inside
Wagtail 8's declared support, so no floor has to move.
_Source: `pyproject.toml:22-23`._

**1.3 Wagtail 8 depends on Django Ninja.** Its install requirements include
`django-ninja>=1.6.3,<2.0` and `pydantic>=2,<3`. Wagtail's new v3 REST API, released in 8.0 as a
preview, is built on Django Ninja and type hints and auto-generates OpenAPI 3.1 schemas. This is
the same framework and the same schema format the template already serves its own API with.
_Sources: [S1], [S2]._

**1.4 Wagtail 8 also brings Django REST Framework.** `djangorestframework>=3.18,<4` is an install
requirement, carried for the older v2 API. The template declares Django Ninja as its API
framework and does not currently hold DRF. Installing Wagtail therefore puts a second API
framework in the dependency graph whether or not the project routes anything through it.
_Sources: [S1], `pyproject.toml:47`._

**1.5 Wagtail 8 brings `django-tasks`.** `django-tasks>=0.9,<0.13` is an install requirement.
This is a task-runner interface, and it coexists with rather than replaces the Celery and Valkey
setup the template declares — but it is a second background-work abstraction in the same process
family.
_Sources: [S1], `pyproject.toml:57-61`._

### 2. What Wagtail requires of the settings and URL surface

**2.1 The required apps are eleven Wagtail apps plus two third-party ones.** `wagtail`,
`wagtail.admin`, `wagtail.search`, `wagtail.images`, `wagtail.documents`, `wagtail.snippets`,
`wagtail.users`, `wagtail.sites`, `wagtail.embeds`, `wagtail.contrib.forms`,
`wagtail.contrib.redirects`, plus `taggit` and `modelcluster`. One middleware is required:
`wagtail.contrib.redirects.middleware.RedirectMiddleware`.
_Source: [S3]._

**2.2 The insertion is an append, not a restructure.** `INSTALLED_APPS` and `MIDDLEWARE` are each
defined exactly once, in `code/src/django/config/settings/base.py:28-46` and `:48-61`, and no
environment module redefines either. `TEMPLATES` needs no change: the explicit loader list at
`:79-88` already names `django.template.loaders.app_directories.Loader`, so Wagtail's own
templates resolve.
_Source: read directly from the file._

**2.3 Wagtail's serving route is a catch-all that must be last.** The documented URL
configuration mounts the Wagtail admin and documents at explicit prefixes, then hands everything
unmatched to Wagtail's page-serving mechanism via a regex route matching the empty string. The
template's root URLconf at `code/src/django/config/urls.py:20-23` currently holds two routes and
no catch-all.
_Sources: [S3], read directly from the file._

**2.4 Wagtail's admin defaults to `/admin/`, which this repository reserves.**
`code/docs/URL-STRATEGY.md` states that the built-in Django admin always lives at `/control/` and
that the `/admin/` prefix is exclusively owned by the project's own custom admin area. Remounting
Wagtail's admin is a one-line change, but the surface table in that guide gains a row, and that
file is one of the guides whose contents are non-negotiables.
_Sources: `code/docs/URL-STRATEGY.md:30-35`, [S3]._

**2.5 The URL slot is already anticipated.** The subdomain-routing feature map already reserves
the `admin.` subdomain for "the custom admin area (CMS, blog editor, CRM)" with the developer
Django admin staying at `/control/`. A CMS admin therefore has a planned home rather than needing
a fresh decision.
_Source: `project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md:129`._

### 3. Images — the pipeline question

**3.1 Wagtail generates renditions as new files, in-process.** Rendered versions of an original
image are called renditions, and Wagtail's documentation states they are stored as new image
files in the site's media images directory on first invocation. `Willow[heif]>=1.11,<2` is a hard
install requirement, and Willow wraps Pillow. A rendition is a database row plus a file, produced
by the template tags `{% image %}`, `{% srcset_image %}` and `{% picture %}`, or in Python by
`get_rendition()`.
_Sources: [S4], [S5], [S1]._

**3.2 This is the architectural inverse of Cloudinary's model.** Wagtail generates and stores;
Cloudinary stores once and transforms by URL. Both work, but only one engine does the transform.
Pointing `STORAGES["default"]` at Cloudinary makes Wagtail upload every derivative it has already
rendered locally — Cloudinary storage is paid for, its transformation CDN is unused.
_Source: synthesis of [S4] and the Cloudinary delivery model in `code/docs/cloudinary/`._

**3.3 Wagtail's `picture` and `srcset_image` tags already cover most of what a transformation CDN
is wanted for.** `{% picture myimage format-{avif,webp,jpeg} width-{400,800} %}` renders a
`<picture>` element with one `<source>` per format and a `srcset` per width, in a fixed
preference order of AVIF, WebP, JPEG, PNG, GIF.
_Sources: [S4], [S6]._

**3.4 Rendition lookups are cached against a named cache alias.** Wagtail tries a cache called
`renditions` and falls back to the default cache. The template already runs Valkey, so this is
configuration rather than infrastructure.
_Source: [S5]._

**3.5 Storage is swappable without touching the editor experience.** Wagtail's image library,
multiple upload, chooser modal, focal points, collections and usage tracking are all admin UI
sitting above a Django storage backend. `WAGTAILIMAGES_RENDITION_STORAGE` additionally allows
renditions to live somewhere other than the originals.
_Source: [S7]._

**3.6 A custom image model is the sanctioned extension point, and it must be chosen before the
first upload.** `WAGTAILIMAGES_IMAGE_MODEL` points at a subclass of `AbstractImage`, paired with
a subclass of `AbstractRendition`; `get_upload_to` can be overridden on either to control storage
paths, and `WAGTAILIMAGES_IMAGE_FORM_BASE` supplies a custom admin form. The documentation is
explicit that switching an existing site to a custom image model copies no images automatically
and needs a hand-written data migration.
_Sources: [S8], [S7]._

**3.7 A dedicated Cloudinary package exists, with caveats.** `wagtailcloudinary` 2.3.0 was
released on 3 September 2025 and declares `wagtail>=6.3` and `cloudinary>=1.44,<1.45`. It
predates Wagtail 8 and its tight upper bound on `cloudinary` would constrain the template's
currently unpinned dependency. **Only its PyPI metadata was read; its source and documentation
were not.**
_Source: [S9]._

**3.8 The template's own Cloudinary dependency is stale and unwired.**
`django-cloudinary-storage` last released 0.3.0 on 23 August 2020. `cloudinary` is not in
`INSTALLED_APPS` and no `CLOUDINARY_*` setting exists anywhere under
`code/src/django/config/settings/`.
_Sources: [S10], read directly from the settings tree._

**3.9 The routing doctrine already points Wagtail images at Cloudinary.**
`code/docs/OBJECT-STORAGE.md:37-45` routes public media — "imagery, video, anything transformed
or CDN-served" — to Cloudinary and states that nothing crosses between that route and the private
S3 one. The same guide at `:107-111` forbids mounting the S3 adapter as `STORAGES["default"]`.
Wagtail needs a working default storage, so Cloudinary is the doctrinally correct home and the
ordinary Wagtail-on-S3 deployment is the route the rules close off.
_Source: read directly from the file._

**3.10 Media is currently unserved and non-durable.** `MEDIA_URL` and `MEDIA_ROOT` exist at
`code/src/django/config/settings/base.py:191-192`, but the root URLconf never serves media,
`STORAGES["default"]` is `FileSystemStorage` in base, staging and production alike (`:194-197`),
and the staging and production Compose services declare no volumes. Nothing uses default storage
today because the project has no models; Wagtail would be the first thing to make it
load-bearing.
_Source: read directly from the settings and Compose files._

**3.11 Wagtail's upload validation is weaker than this repository's.**
`code/docs/security/INPUT-AND-API.md:175-193` requires magic-byte content-type validation, an
explicit MIME allowlist, size limits at three layers, UUID filenames, EXIF stripping and ClamAV
in production, and states that the Django app never serves raw uploads from its own filesystem.
Wagtail validates by extension and by whether Pillow can open the file. Its own guards are
`WAGTAILIMAGES_MAX_UPLOAD_SIZE` (10 MB default) and `WAGTAILIMAGES_MAX_IMAGE_PIXELS` (128
megapixels default, a decompression-bomb limit). `python-magic` and `pyclamd` are listed in
`pyproject.toml:68` as deliberately undeclared until a feature needs them.
_Sources: [S7], read directly from the files._

### 4. Wagtail AI

**4.1 Wagtail AI has not been released against Wagtail 8 or Django 6.** The newest PyPI release
is 3.1.1 (6 August 2026). Its `main` branch, last pushed 12 August 2026, declares `Django>=5.2`
and `Wagtail>=7.1` with classifiers for `Framework :: Django :: 5.2` and `Framework :: Wagtail ::
7` — no Django 6 classifier of any kind. Wagtail 8.0 was released 25 August 2026. There are no
upper bounds, so it would install; it is untested on this combination.
_Sources: [S11], [S12], [S2]._

**4.2 Wagtail 8 warns that add-ons may lag it.** The 8.0 release notes say of the new custom base
page models feature that certain add-on packages may not yet be compatible.
_Source: [S2]._

**4.3 The whole chain is alpha.** wagtail-ai carries `Development Status :: 3 - Alpha`, MIT
licence, 203 stars and 45 open issues. Its core dependency `django-ai-core` is at 0.1.6, also
alpha, created September 2025, 22 stars, and its README's own TODO list still includes testing
index backends and writing documentation. The chain reaches `any-llm-sdk>=1.23,<2`, `queryish`,
and `llm>=0.12`.
_Sources: [S11], [S13], [S14]._

**4.4 Related-pages suggestions need a vector index.** `django-ai-core` ships storage providers
for pgvector, LlamaIndex and S3 Vectors. pgvector on PostgreSQL 18 would be the natural choice
and means a database extension plus a migration.
_Source: [S14]._

**4.5 Its output lands where the anti-slop gate cannot see.**
`code/src/scripts/audits/copy-slop.sh` blocks machine-authored prose tells, enforcing
`how-to/src/BRAND-VOICE.md`. It scans `.py` and `.html` files within declared scopes
(`copy-slop.sh:147`, `:315-326`). Content stored in the database is outside that scan. Moving
copy into a CMS already removes it from the gate's reach; generating that copy with an LLM fills
the blind spot with exactly what the gate exists to catch. Enforcing brand voice on CMS content
needs a second, database-side implementation.
_Source: read directly from the file._

**4.6 It makes the LLM provider a data processor.** Page content an editor typed, which may
contain personal data, is sent to a third-party API. Under the repository's own rules that is an
Article 28 processing agreement, a sub-processor register row and a lawful-basis decision, not a
dependency choice.
_Sources: `project-management/docs/GDPR-GUIDE.md`, `.claude/skills/msp-scp-documents`._

### 5. What the repository's own doctrine then charges

**5.1 Wagtail's admin login is a second authentication surface.** `wagtailadmin_urls` ships its
own login view against the same `auth.User` model and issues the same Django session. The auth
doctrine requires MFA on privileged accounts, session regeneration on privilege change, lockout
or back-off after repeated failures, and identical response shapes regardless of outcome — all
built into the project's own login. A second login form reaching the same session bypasses each
of them unless separately subjected to the same controls.
_Sources: `code/docs/security/AUTH-AND-AUTHZ.md:26-29`, `:113-116`,
`code/docs/security/OWASP-AND-CHECKLIST.md:29`._

**5.2 Wagtail's permissions are a second authorisation store.**
`code/docs/architecture/AUTH-CONTRACT.md:17-19` and `code/docs/security/AUTH-AND-AUTHZ.md:69-89`
make one canonical predicate the first statement of every role-management method. Wagtail ships
`wagtail.users` plus group-scoped page and collection permissions — a privilege-granting path
that never passes through it.
_Source: read directly from the files._

**5.3 Wagtail's log models duplicate the audit record rather than satisfying it.**
`code/docs/security/AUDIT-TRAIL.md` requires a UUID primary key because a sequential integer
leaks activity volume (`:51-64`), and requires that actor and target identifiers carry no foreign
key so that deleting a user cannot cascade the record away (`:82-101`). Wagtail's `PageLogEntry`
and `Revision` models satisfy neither.
_Source: read directly from the file._

**5.4 `wagtail.contrib.forms` is a mandatory app and an unclassified PII sink.** Its
`FormSubmission` model stores arbitrary submitted form data as a JSON blob. That lands
simultaneously on classification (`code/docs/security/CRYPTO-AND-DATA.md:170`), the Fernet
encryption pipeline (`code/docs/ENCRYPTION-GUIDE.md:19-28`), row-level security
(`code/docs/rls/FUNDAMENTALS.md:33-39`) and the schema rule that a value needing a shape gets one
(`code/docs/DATABASE.md:30-45`).
_Source: read directly from the files._

**5.5 Wagtail's tables carry no scope column.** `.claude/CLAUDE.md` Section 6 requires that a
scope column, the policy reading it, its index and the middleware setting its session variable
ship together. Wagtail brings dozens of third-party tables with none of these. Whether that is a
violation or an unscoped-by-design exemption is an open question the repository has not answered
for any third-party table.
_Source: read directly from the file._

**5.6 StreamField is dict-shaped by design.** `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md`
is mandatory on all new and modified code, with a `DICT-OK:` escape hatch. StreamField block data
is JSON. Whether the hatch suffices or the gate needs editing depends on whether
`code/src/scripts/audits/dict-discipline.sh` scans the paths the block definitions live in.
_Source: read directly from the files._

**5.7 Wagtail is a substrate dependency, not a swappable one.**
`code/docs/architecture/PROVIDER-NEUTRALITY.md` and `how-to/src/PLATFORM-PROVIDERS.md` classify
every infrastructure dependency, and changing a substrate row is described as a fork rather than
a configuration change. Once page models are authored against Wagtail's `Page` and StreamField,
there is no interface to swap behind — Wagtail passes the substrate test the same way Django
does.
_Source: read directly from the files._

**5.8 Coverage floors reach the project's page models, not Wagtail's own code.**
`code/docs/testing/COVERAGE.md` measures `apps/` only and omits migrations, so Wagtail's package
and its several hundred migrations contribute nothing. Every `Page` subclass, StreamField block,
`get_context` override and Wagtail hook the project writes is measured, at 75 per cent line and
branch.
_Source: read directly from the file._

**5.9 A stack surface has cost 12 or more doctrine files each time.** The FastMCP surface is a
155-line skill plus a seven-file `code/docs/` family (857 lines) plus a four-file workflow folder
(352 lines). The Slint desktop surface is comparable at roughly 1,100 lines. Wagtail is a wider
surface than either.
_Source: measured against the files in this repository._

## Sources

- **[S1]** wagtail 8.0 package metadata, PyPI JSON API — `https://pypi.org/pypi/wagtail/json`
- **[S2]** Wagtail 8.0 release notes, 25 August 2026 —
  `https://docs.wagtail.org/en/stable/releases/8.0.html`
- **[S3]** How to add Wagtail into an existing Django project —
  `https://docs.wagtail.org/en/stable/advanced_topics/add_to_django_project.html`
- **[S4]** How to use images in templates — `https://docs.wagtail.org/en/stable/topics/images.html`
- **[S5]** Generating renditions in Python —
  `https://docs.wagtail.org/en/stable/advanced_topics/images/renditions.html`
- **[S6]** Image file formats —
  `https://docs.wagtail.org/en/stable/advanced_topics/images/image_file_formats.html`
- **[S7]** Wagtail settings reference — `https://docs.wagtail.org/en/stable/reference/settings.html`
- **[S8]** Custom image models —
  `https://docs.wagtail.org/en/stable/advanced_topics/images/custom_image_model.html`
- **[S9]** wagtailcloudinary 2.3.0 package metadata, PyPI JSON API —
  `https://pypi.org/pypi/wagtailcloudinary/json`
- **[S10]** django-cloudinary-storage 0.3.0 package metadata, PyPI JSON API —
  `https://pypi.org/pypi/django-cloudinary-storage/json`
- **[S11]** wagtail-ai 3.1.1 package metadata, PyPI JSON API —
  `https://pypi.org/pypi/wagtail-ai/json`
- **[S12]** wagtail/wagtail-ai repository metadata and `main` branch `pyproject.toml` and
  `CHANGELOG.md` — `https://github.com/wagtail/wagtail-ai`
- **[S13]** wagtail/django-ai-core repository metadata and README —
  `https://github.com/wagtail/django-ai-core`
- **[S14]** django-ai-core 0.1.6 package metadata and repository tree —
  `https://pypi.org/pypi/django-ai-core/json`

**Licence position.** Wagtail is BSD-3-Clause, a permissive licence under which verbatim
quotation with attribution is allowed. This note nevertheless re-authors every fact in its own
words rather than quoting, so no attribution row in `README.md` is owed by it. A future document
that quotes Wagtail's documentation verbatim must add that row in the same change.

## Feeds

- `code/docs/WAGTAIL.md` — the CMS-only guide that ships to a project answering `INCLUDE_WAGTAIL`
  true. Written 07/09/2026 alongside this note.
- The `INCLUDE_WAGTAIL` copier question and its exclusion entries in `copier.yml`. <!-- doc-references: template-only -->

No ADR: the decision this note feeds is a per-project generation answer, and the guide above
carries the reasoning that an ADR would otherwise hold.

## What was not checked

- `wagtailcloudinary`'s source and documentation. Only its PyPI metadata was read, so claim 3.7
  describes what it declares, not what it does.
- Whether Wagtail 8's admin renders correctly under a nonce-less Content-Security-Policy with no
  `unsafe-inline`, which is what the edge sets for this stack.
- Whether `Willow[heif]` needs system libraries beyond what the Django image already installs.
- Whether `django-tasks` and Celery conflict in practice when both are configured.
- Whether `laces`, Wagtail's component-rendering dependency, conflicts with django-components'
  global template-compilation monkeypatch — the conflict that caused django-cotton to be dropped
  from this stack. Flagged as a risk to test, not a confirmed clash.
