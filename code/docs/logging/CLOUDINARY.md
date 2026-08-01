---
type: guide
agent: logging
skills: [stack-django]
model: opus
---

# Logging — Cloudinary (File and Media Storage)

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — Cloudinary media storage config, env vars, CDN delivery setup

---

## Cloudinary — file and media storage

Cloudinary handles all file uploads in every environment. There is no local `/media/`
directory and no Django `FileSystemStorage` — the default storage backend always points to
Cloudinary. This eliminates the ephemeral-container media loss problem entirely.

### Installation

Add `cloudinary` and `django-cloudinary-storage` to the backend dependencies.

### Configuration (`config/settings/base.py`)

```python
INSTALLED_APPS = [
    "cloudinary",
    "cloudinary_storage",
    # … other apps
]

CLOUDINARY_STORAGE = {
    "CLOUD_NAME": env("CLOUDINARY_CLOUD_NAME"),
    "API_KEY": env("CLOUDINARY_API_KEY"),
    "API_SECRET": env("CLOUDINARY_API_SECRET"),
}

# Django 6 STORAGES API — Cloudinary as the default (media) backend.
STORAGES = {
    "default": {"BACKEND": "cloudinary_storage.storage.MediaCloudinaryStorage"},
    "staticfiles": {"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"},
}
```

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

| Variable                     | dev | test | staging | prod |
| ---------------------------- | --- | ---- | ------- | ---- |
| `CLOUDINARY_CLOUD_NAME`      | ✅  | ✅   | ✅      | ✅   |
| `CLOUDINARY_API_KEY`         | ✅  | ✅   | ✅      | ✅   |
| `CLOUDINARY_API_SECRET`      | ✅  | ✅   | ✅      | ✅   |
| `GLITCHTIP_DSN`              | ❌  | ❌   | ✅      | ✅   |
| `VITE_GLITCHTIP_BROWSER_DSN` | ❌  | ❌   | ✅      | ✅   |

Prometheus, Alloy, Loki, and Grafana are configured on the server — no application env vars
required for those tools.

_Part of the `code/docs/` documentation family. See [`../LOGGING.md`](../LOGGING.md) for the full index._
