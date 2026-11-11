---
type: guide
skills: [logging, stack-django]
model: opus
---

# Logging — Cloudinary (File and Media Storage)

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Cloudinary media storage config, env vars, CDN delivery setup

---

## Cloudinary — file and media storage

Cloudinary handles all file uploads in every environment. There is no local `/media/`
directory and no Django `FileSystemStorage` — the default storage backend always points to
Cloudinary. This eliminates the ephemeral-container media loss problem entirely.

### Installation

`cloudinary`, the official Python SDK, is already declared in the root `pyproject.toml`. It is
the only Cloudinary package: **never add `django-cloudinary-storage`.** That package was dropped
on 11/11/2026 because its last release was 0.3.0 on 23/08/2020.

### The storage backend is an adapter, not a package

The SDK ships fields, forms and template tags, but **no Django `Storage` class**. Making
Cloudinary the default storage backend therefore means writing a small adapter: a
`django.core.files.storage.Storage` subclass whose `_save` and `delete` call `cloudinary.uploader`,
`exists` calls `cloudinary.api.resource`, and `url` calls `cloudinary.CloudinaryImage(...).build_url()`, with its own tests
against a mocked SDK. It is the same adapter-seam shape as the private-document store in
[`../OBJECT-STORAGE.md`](../OBJECT-STORAGE.md). Wagtail's rendition pipeline sits on top of it
and keeps doing its own transforms (`../wagtail/IMAGES-AND-MEDIA.md`).

### Configuration (`config/settings/base.py`)

```python
import cloudinary

cloudinary.config(
    cloud_name=env("CLOUDINARY_CLOUD_NAME"),
    api_key=env("CLOUDINARY_API_KEY"),
    api_secret=env("CLOUDINARY_API_SECRET"),
    secure=True,
)

# Django 6 STORAGES API — Cloudinary as the default (media) backend, through the adapter.
STORAGES = {
    "default": {"BACKEND": "apps.<owning_app>.storage.CloudinaryStorage"},
    "staticfiles": {"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"},
}
```

`apps.<owning_app>` stands for wherever the adapter is built. Nothing is wired at baseline.

### What Cloudinary provides

- CDN delivery — no Nginx `/media/` proxy required
- Automatic image optimisation (format negotiation, quality, resizing)
- Secure signed URLs for private assets (if needed)
- Direct browser-to-Cloudinary uploads via signed upload presets, where the browser first requests
  a signature from a session-authed Django view or Ninja endpoint

### Required env vars

| Variable                | Description                               |
| ----------------------- | ----------------------------------------- |
| `CLOUDINARY_CLOUD_NAME` | Cloud name from Cloudinary dashboard      |
| `CLOUDINARY_API_KEY`    | API key                                   |
| `CLOUDINARY_API_SECRET` | API secret — never hardcode, never commit |

---

## Required environment variables — full summary

| Variable                | dev | test | staging | prod |
| ----------------------- | --- | ---- | ------- | ---- |
| `CLOUDINARY_CLOUD_NAME` | ✅  | ✅   | ✅      | ✅   |
| `CLOUDINARY_API_KEY`    | ✅  | ✅   | ✅      | ✅   |
| `CLOUDINARY_API_SECRET` | ✅  | ✅   | ✅      | ✅   |
| `SENTRY_DSN`            | ❌  | ❌   | ✅      | ✅   |
| `SENTRY_BROWSER_DSN`    | ❌  | ❌   | ✅      | ✅   |

Prometheus, Alloy, Loki, and Grafana are configured on the server — no application env vars
required for those tools.

_Part of the `code/docs/` documentation family. See [`../LOGGING.md`](../LOGGING.md) for the full index._
