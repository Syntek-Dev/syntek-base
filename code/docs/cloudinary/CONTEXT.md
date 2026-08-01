# code/docs/cloudinary — Cloudinary SDK Reference Docs

**Claude Model:** opus — Cloudinary upload, transformation, and admin API SDK reference

Vendored LLM-context copies of the official Cloudinary SDK documentation,
installed from the `cloudinary-devs/skills` package and recorded in `skills-lock.json`.

**One SDK is in use in this stack: the Python SDK** (Django backend — uploads, admin API,
erasure). Media reaches the browser as ordinary `<img>`/`<video>` markup with a Cloudinary URL
built server-side; there is no client-side SDK, because there is no client-side framework. The
JavaScript-SDK docs that used to sit here (`REACT_SDK.md`, `NEXTJS_SDK.md`, `REACT_NATIVE_SDK.md`)
were removed with the React sweep.

> The vendored `cloudinary-react` **skill** is still installed via `skills-lock.json`. Nothing
> loads it, but it must be removed through the skills tool rather than by deleting the symlink
> by hand.

## Files

| File                | SDK                   | Status / when to read                                                   |
| ------------------- | --------------------- | ----------------------------------------------------------------------- |
| `PYTHON_SDK.md`     | Cloudinary Python SDK | **In use** — any backend upload, admin API, or erasure work             |
| `CROSS_SDK_INFO.md` | Cross-SDK reference   | Config params, transformation syntax, browser support, input validation |

## When to use these docs

- Writing or reviewing Cloudinary upload, transformation, or admin API calls (Python SDK, Django backend)
- Adding or modifying a media app's `services/cloudinary_service.py` or an upload orchestration service
- Building a delivery URL for a template — transformation syntax is in `CROSS_SDK_INFO.md`
- Debugging Cloudinary exception types (base class: `cloudinary.exceptions.Error`)

## Key facts (Python SDK)

- Exception base class: `cloudinary.exceptions.Error` (not `cloudinary.api.Error`)
- Upload: `cloudinary.uploader.upload()`
- Admin API: `cloudinary.api.*`
- Config: `CLOUDINARY_URL` env var or `cloudinary.config()`

## Cross-references

- `code/docs/logging/CLOUDINARY.md` — media storage configuration and required env vars
- `code/docs/LOGGING.md` — Cloudinary logging patterns
- `skills-lock.json` — installed skill versions and hashes
