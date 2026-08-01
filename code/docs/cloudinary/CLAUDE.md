@./CONTEXT.md

# CLAUDE.md — code/docs/cloudinary/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(SDK file table + key facts, imported above) → this file.

## Purpose (one line)

Vendored LLM-context copies of the official Cloudinary SDK docs — read before writing
or reviewing any upload, transformation, or admin-API call. Only the Python SDK
(Django backend) applies to this stack; delivery URLs are built server-side, so no
JavaScript SDK is wired in.

## How to work here

- **Routing:** these are consumed, not authored freehand. For live Cloudinary docs
  use the `cloudinary-docs` / `cloudinary-transformations` skills (Opus). Backend
  calls go through a media app's SDK wrapper
  (`services/cloudinary_service.py`); templates receive a finished delivery URL from
  the view, never an SDK component.
- **Model:** Opus when applying the guidance to code and a re-index.
- **Refresh, don't rewrite:** these files are installed from the `cloudinary-devs/skills`
  package and recorded in `skills-lock.json`. To update, re-run the skills install and
  let it overwrite — never hand-edit the vendored SDK text.
- **Definition of done:** any change stays in step with `skills-lock.json`; the
  `CONTEXT.md` file table and key facts still match.

## Guardrails

- **Do not hand-author** the SDK docs — they are third-party vendored content.
- Keep the key facts accurate: exception base class is `cloudinary.exceptions.Error`
  (not `cloudinary.api.Error`); upload via `cloudinary.uploader.upload()`; admin via
  `cloudinary.api.*`; config via the `CLOUDINARY_URL` env var.
- **Cloudinary credentials are secrets** — env only, never in docs or code samples.

## Output & naming

- **Vendored (generated):** `PYTHON_SDK.md` and `CROSS_SDK_INFO.md` —
  `SCREAMING_SNAKE_CASE.md` as shipped by the upstream skill. The JavaScript-SDK files
  were removed with the React sweep; do not reinstate them without a stack change.
- Only `CONTEXT.md`/`CLAUDE.md` in this folder are hand-written.
