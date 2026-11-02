---
type: guide
skills: [stack-wagtail]
model: opus
---

# Wagtail — Images and Media

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

> **CMS-only.** This guide exists only in a project generated with `INCLUDE_WAGTAIL`.

Wagtail's media layer is two apps — `wagtail.images` and `wagtail.documents` — and they behave
very differently. Images are transformed in-process and cached as derived files; documents are
stored as uploaded and served under a permission check that a remote storage backend can quietly
bypass. Read this **before the first upload**, because two of the decisions below cannot be
taken again cheaply.

Upstream entry points: [images overview](https://docs.wagtail.org/en/stable/advanced_topics/images/index.html)
and [documents overview](https://docs.wagtail.org/en/stable/advanced_topics/documents/index.html).
Every setting named here is defined in
[the settings reference](https://docs.wagtail.org/en/stable/reference/settings.html).

## Renditions: a derived file plus a row

A **rendition** is a resized, re-encoded copy of an original image. Wagtail generates it with
Willow over Pillow, in the web process, and stores it as **a new file on the storage backend
plus a `Rendition` row in the database**. `foo.jpg` rendered at `fill-300x150|jpegquality-60`
becomes `foo.fill-300x150.jpegquality-60.jpg`. The cost model follows from that: every distinct
width, format and filter spec multiplies both counts.

Three template tags, all from `wagtailimages_tags`, documented in
[How to use images in templates](https://docs.wagtail.org/en/stable/topics/images.html):

| Tag            | Renders                     | Use when                                                    |
| -------------- | --------------------------- | ----------------------------------------------------------- |
| `image`        | one `<img>`                 | A single fixed size — thumbnails, icons, fixed-width panels |
| `srcset_image` | `<img srcset sizes>`        | One format, several widths, browser picks by viewport       |
| `picture`      | `<picture>` with `<source>` | Several formats, with or without several widths             |

`{% picture page.photo format-{avif,webp,jpeg} width-{400,800} sizes="80vw" %}` emits one
`<source>` per extra format with the `<img>` as fallback. **The source order is not
configurable** — Wagtail always writes AVIF, WebP, JPEG, PNG, GIF, so the browser takes the
first it supports. Format behaviour and the `WAGTAILIMAGES_FORMAT_CONVERSIONS` fallback map are
in [image file formats](https://docs.wagtail.org/en/stable/advanced_topics/images/image_file_formats.html).

That example is **six renditions per image** — three formats at two widths each. Six files, six
rows, six Pillow encodes. Choose the matrix deliberately; it is a page-weight and storage
decision, not a template detail. Which of these belongs server-rendered and which is a component
concern is `code/docs/RENDERING.md` and `code/docs/FRONTEND-CODING-PRINCIPLES.md`.

In Python, `image.get_rendition("fill-300x186|jpegquality-60")` returns a `Rendition` carrying
`url`, `width` and `height`; `image.get_renditions(*specs)` generates a set in one pass and is
materially cheaper than looping. Both are covered in
[Generating renditions in Python](https://docs.wagtail.org/en/stable/advanced_topics/images/renditions.html).

**Rendition lookups use a cache alias named `renditions`, falling back to `default` if it is not
defined.** Define it explicitly in `code/src/django/config/settings/base.py` rather than letting
CMS lookups share and evict the general cache — sizing and eviction policy are
`code/docs/PERFORMANCE.md`.

## Willow transforms, Cloudinary stores

**The project decision: Wagtail's native pipeline generates the renditions, and Cloudinary sits
beneath it as the `STORAGES["default"]` backend.** Cloudinary is storage here, **not** the
transformation engine — no Cloudinary transformation URLs, no `cloudinary` field types on a
Wagtail model. Willow decides the pixels; Cloudinary holds the bytes.

The reasoning is already settled and is not re-argued here: the media routing invariant is
`code/docs/OBJECT-STORAGE.md`, the Cloudinary integration itself is
`code/docs/logging/CLOUDINARY.md`, and the substrate classification is
`how-to/src/PLATFORM-PROVIDERS.md`. Route questions there.

Two consequences to hold:

- **The app filesystem is never the store.** A container filesystem is not durable, and
  renditions written there vanish on redeploy and regenerate under live traffic.
- `WAGTAILIMAGES_RENDITION_STORAGE` defaults to `None`, meaning renditions follow the project
  default. Set it to a **storage alias from `STORAGES`** only to split renditions off the
  originals; a dotted path or an instance also works but the alias is upstream's recommendation.

## The custom image model exists before the first upload

Wagtail supports swapping its `Image` model for one of your own —
[custom image models](https://docs.wagtail.org/en/stable/advanced_topics/images/custom_image_model.html).
It takes **two** models, not one: an image model extending `AbstractImage`, and a rendition
model extending `AbstractRendition` with a foreign key back to it, `related_name="renditions"`,
and a unique constraint over `("image", "filter_spec", "focal_point_key")`. Then
`WAGTAILIMAGES_IMAGE_MODEL = "content.CustomImage"`.

**Do this before the first upload.** Upstream is explicit: switching an existing site to a
custom image model **copies no images across** and requires a hand-written data migration, and
every template and foreign key referencing the old model has to be revisited. There is no
management command for it, and the migration touches the same rows the CMS is serving from.
The migration-safety rules in `code/docs/DATABASE.md` apply in full.

Code that needs the model without importing it uses `get_image_model()`, and code that needs
only the label uses `get_image_model_string()` — never a hard import of `wagtail.images.models.Image`.

Upload paths are controlled by overriding `get_upload_to(filename)` on either model. The
defaults are the `original_images` folder for originals and `images` for renditions, both
ASCII-normalised and length-limited. Override where the storage layout has to carry a prefix or
a scope; keep any scope segment consistent with `code/docs/rls/FUNDAMENTALS.md` rather than
inventing a second scheme.

## Upload hardening lives on the image form base

`WAGTAILIMAGES_IMAGE_FORM_BASE` points at a form extending Wagtail's `BaseImageForm`, and **this
project puts its upload validation there**: magic-byte sniffing, the MIME allowlist, EXIF
stripping and any AV scan. The obligations themselves are
`code/docs/security/INPUT-AND-API.md`; this section only names where they attach. Documents have
the parallel hook, `WAGTAILDOCS_DOCUMENT_FORM_BASE`.

`WAGTAILIMAGES_EXTENSIONS` is not a substitute. Upstream warns that it validates the extension
only, and a file can be renamed whatever its contents are. **The extension list narrows what an
editor can pick; the form base decides what is actually stored.**

Two limits are on by default and both should be stated explicitly rather than inherited:

- `WAGTAILIMAGES_MAX_UPLOAD_SIZE` — **10 MB** if unset. In bytes.
- `WAGTAILIMAGES_MAX_IMAGE_PIXELS` — **128 megapixels** if unset. This is the decompression-bomb
  guard, and it counts animation frames, so a 25-frame 100x100 GIF counts as 250,000 pixels.

**EXIF survives on the stored original.** Renditions are re-encoded and so drop it, but the
original is stored as uploaded, and it is the original that carries GPS coordinates, device
serials and timestamps. Strip on the form base, before the file reaches storage. Whether that
metadata is personal data is `project-management/docs/gdpr/DATA-RIGHTS.md`.

## Documents are not this project's private-document route

Documents get their own model and form base — `WAGTAILDOCS_DOCUMENT_MODEL` and
`WAGTAILDOCS_DOCUMENT_FORM_BASE`, with the same before-the-first-upload caution and the same
`get_document_model()` accessor. See
[custom document model](https://docs.wagtail.org/en/stable/advanced_topics/documents/custom_document_model.html).

Wagtail's own privacy mechanism is the **collection view restriction**: put a document in a
collection, restrict that collection to logged-in users, a group, or a shared password
([private pages and collections](https://docs.wagtail.org/en/stable/advanced_topics/privacy.html)).
Two facts constrain how far that goes:

1. **Collection privacy applies to documents, not images.** An image is served from its storage
   URL with no check at all.
2. **The check is only as strong as `WAGTAILDOCS_SERVE_METHOD`.** With a remote backend — which
   is this project's default — it resolves to `redirect`, and the browser is sent straight to the
   storage URL. `serve_view` is the only method that enforces the restriction, and it costs an
   application request per download and needs the media path blocked at the web server.
   [Storing and serving](https://docs.wagtail.org/en/stable/advanced_topics/documents/storing_and_serving.html)
   sets out the trade-off and the headers that go with each.

**So: genuinely confidential files do not go in Wagtail's document store.** They go through this
project's private-document route (`code/docs/OBJECT-STORAGE.md`), which was designed for exactly
that. Wagtail documents are for editor-managed public collateral — brochures, price lists,
policies — with the restriction used as convenience, never as the control. Wagtail also performs
**no AV scanning** of its own; that is the form base's job, per the section above.

Editor uploads, deletions and replacements are state-changing actions on a privileged path.
Wagtail's `PageLogEntry` and `Revision` duplicate the audit record and **never satisfy it** —
`code/docs/security/AUDIT-TRAIL.md` owns what does.

## Performance: the first view after a publish pays

**Renditions generate synchronously, in-process, on first render.** The first request for a page
after a publish encodes every format at every width the templates ask for, one after another,
inside the response. A hero image at three formats and three widths is nine Pillow encodes and
nine storage writes before a byte is returned.

Blunt the edge:

- **Prefetch.** `Image.objects.prefetch_renditions(*specs)` on an image queryset, or
  `prefetch_related("listing_image__renditions")` on any other model, collapses a listing page's
  rendition lookups into one extra query.
- **Warm ahead of traffic.** Wagtail's `wagtail_update_image_renditions` management command
  regenerates renditions in bulk. Like every other management command it is reached through a
  wrapper script under `code/src/scripts/`, added alongside it — never a raw invocation
  (`code/docs/MANAGEMENT-COMMANDS.md`).
- **Size for it.** The encode is CPU and the writes are storage egress, and both belong in the
  envelope: `how-to/src/SCALE-ARCHITECTURE/` and `code/docs/PERFORMANCE.md`.

If the CMS ever needs to serve renditions to an external client by URL, Wagtail has a signed
[dynamic image serve view](https://docs.wagtail.org/en/stable/advanced_topics/images/image_serve_view.html).
Mount it **above** the Wagtail catch-all, which is always the last route in
`code/src/django/config/urls.py` — the ordering rule and the whole prefix map are
`code/docs/URL-STRATEGY.md`.

## Accessibility: alt text is content, and content is editor-authored

The `image` tag emits an `alt` attribute from the image's contextual alt text, falling back to
`default_alt_text`. Wagtail's own default derives from the title, which is usually the filename
— useless to a screen reader. **Override `default_alt_text` on the custom image model** to force
it from a real description field, and pass `alt=""` explicitly on genuinely decorative images so
they are skipped rather than announced.

WCAG 2.2 AA is an outcome, not a checkbox, and editor-authored content is inside its scope:
`code/docs/ACCESSIBILITY.md`. Layout and token rules for the surrounding component are unchanged
by the CMS (`code/docs/DESIGN-TOKENS.md`).

## Cross-references

- `code/docs/WAGTAIL.md` — the parent index, the three settled decisions, the version floor
- [`FUNDAMENTALS.md`](FUNDAMENTALS.md) — the install order and which apps are required
- [`PAGES-AND-STREAMFIELD.md`](PAGES-AND-STREAMFIELD.md) — `ImageBlock` and images in rich text
- [`ADMIN-AND-PERMISSIONS.md`](ADMIN-AND-PERMISSIONS.md) — collections as a permission surface
- [`API-AND-SEARCH.md`](API-AND-SEARCH.md) — images and documents over the v2 and v3 APIs
- `code/docs/OBJECT-STORAGE.md` · `code/docs/logging/CLOUDINARY.md` — the storage decision
- `code/docs/security/INPUT-AND-API.md` — the upload obligations the form base implements
