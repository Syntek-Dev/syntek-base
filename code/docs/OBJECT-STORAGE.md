---
type: guide
agent: backend
skills: [stack-django]
model: opus
---

# Object Storage (Private Documents)

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus. Private-document storage over the S3 API: presigned URLs, upload
validation, and the private/public split

**Interface:** the S3 API, consumed via `boto3`
**Seam kind:** protocol
**Default:** <%OBJECT_STORE%>
**Proven alternates:** MinIO · Garage · Ceph RGW · AWS S3 · Cloudflare R2 · Backblaze B2

**Status: declared, not wired.** `boto3` is a declared dependency (`pyproject.toml`, under the
comment _"Private-document storage (S3 API). Public media goes to Cloudinary above."_) and
nothing consumes it. There is no storage adapter anywhere under `code/src/django/`, no
object-store service in any of the four Compose files
(`code/src/docker/docker-compose.{dev,test,staging,prod}.yml`), and `STORAGES["default"]` in
`config/settings/base.py` is still Django's `FileSystemStorage`. This guide is the design of
record for the first feature that needs to hold a private document. It is written in the present
tense because that is what a project implements when it builds it, not because it exists today.

---

## What this covers, and what it does not

Three kinds of file leave this application by three different routes. They are not
interchangeable, and choosing between them is not a per-feature preference.

| Kind                                                                  | Route                  | Governing guide                                  |
| --------------------------------------------------------------------- | ---------------------- | ------------------------------------------------ |
| **Private documents and attachments** (contracts, invoices, evidence) | The S3 API via `boto3` | This guide                                       |
| **Public media** (imagery, video, anything transformed or CDN-served) | Cloudinary             | [`logging/CLOUDINARY.md`](logging/CLOUDINARY.md) |
| **Static assets** (CSS, JS, fonts shipped with the build)             | Django `staticfiles`   | [`PERFORMANCE.md`](PERFORMANCE.md)               |

**The routing invariant:** a file whose readership is a permission check goes to the object
store; a file whose readership is "anyone with the URL" goes to Cloudinary. Nothing crosses. A
private document delivered through a transformation CDN has been made public by an
implementation detail, and a public image signed on every request has bought a permission check
nobody needed at the cost of a cache nobody gets.

Cloudinary's upload, delivery and transformation surface is documented in full at
[`cloudinary/CONTEXT.md`](cloudinary/CONTEXT.md). Do not restate it here, and do not build an
S3 path for public media because it feels tidier to have one storage backend. The two have
different jobs.

---

## Lead with the protocol, not the product

S3 is a **protocol**, and several products implement it. That makes this a **protocol seam**
under [`architecture/PROVIDER-NEUTRALITY.md`](architecture/PROVIDER-NEUTRALITY.md), which
carries a specific evidence bar and, importantly, does **not** require a second code path. One
adapter is correct here. The implementations vary on the far side of the socket.

The bar is three points, and only the third is ever violated:

1. The protocol is **named** in the guide, which is what the header block above does.
2. The code speaks it through the protocol's **own client**, `boto3`, never a vendor SDK.
3. **No product-specific API is touched.** One call to a <%OBJECT_STORE%> administration
   endpoint and the seam is gone, silently, years before anyone tries to swap engines.

Point 3 is the whole discipline. Restrict the surface to the S3 operations every implementation
supports: `put_object`, `get_object`, `head_object`, `delete_object`,
`generate_presigned_url`, `generate_presigned_post`, and multipart upload. Bucket creation,
lifecycle policies, quota administration and replication belong to the deploy repository, not
to application code, precisely because that is where the implementations diverge.

The register of what this project actually resolves to is
[`how-to/src/PLATFORM-PROVIDERS.md`](../../how-to/src/PLATFORM-PROVIDERS.md). When the engine
is chosen, record it there and in an ADR under `project-management/src/14-DECISIONS/`.

---

## The adapter contract

One module owns every call into `boto3`. Nothing else in the codebase imports it. That module
is the deep interface the rest of the application depends on, and it exposes intent
(`store_document`, `issue_download_url`, `remove_document`), never S3 vocabulary.

**The client is configured from the environment, never from a literal.** The first feature adds
these to `code/src/docker/.env.*.example` and to a settings module, and no value among them is
ever committed:

| Variable                           | Purpose                                                           |
| ---------------------------------- | ----------------------------------------------------------------- |
| `OBJECT_STORE_ENDPOINT_URL`        | The internal endpoint the application signs and uploads against   |
| `OBJECT_STORE_PUBLIC_ENDPOINT_URL` | The browser-reachable host a presigned URL must be signed for     |
| `OBJECT_STORE_ACCESS_KEY_ID`       | Credential                                                        |
| `OBJECT_STORE_SECRET_ACCESS_KEY`   | Credential                                                        |
| `OBJECT_STORE_BUCKET`              | The private bucket for this environment                           |
| `OBJECT_STORE_REGION`              | Region string, required by the signature even where it is nominal |

**The two endpoint URLs are not redundancy.** The application reaches the store over a private
network path; the browser reaches it over a public HTTPS hostname. A presigned URL is signed
over the host it will be presented to, so signing against the internal endpoint produces a URL
that fails signature validation the moment a browser follows it. The deploy-side requirement
for that public hostname is
[`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`](../../how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md)
§ 10.

**Do not mount this as Django's `STORAGES["default"]`.** Default storage is the path
`FileField` takes without thinking, and thinking is the point: a private document needs an
explicit call through the adapter, so that the permission check sits in the call site rather
than in a template tag. If a model must carry a reference, it stores the **object key** as a
plain column and resolves URLs through the adapter on demand.

**Keys are opaque and scoped.** `{scope}/{model}/{uuid}{ext}`, where `scope` is the tenancy
column the row already carries ([`DATABASE.md`](DATABASE.md)). Never the user-supplied
filename, never a sequential integer, never anything a caller can guess or enumerate. Store the
original filename as a column alongside the key, and return it only in the
`Content-Disposition` of a signed download.

---

## Presigned URLs and the expiry policy

A presigned URL is a **bearer credential in a query string**. It authorises whoever holds it,
travels through browser history, referrer headers, proxy logs and screenshots, and cannot be
revoked before it expires. Every rule below follows from that one sentence.

- **Authorise before signing, never after.** The permission check and ownership verification
  run in the service layer; signing is the last step, reached only once the caller has been
  proven entitled. A signing endpoint without an explicit permission check is the
  `.claude/CLAUDE.md` § 6 non-negotiable violated through a side door.
- **Expiries are short, and the ceiling is not negotiable upward per feature.**

| Operation                       | Expiry     | Why                                                                   |
| ------------------------------- | ---------- | --------------------------------------------------------------------- |
| Inline view or download         | 5 minutes  | Long enough to follow a click, short enough to be worthless if leaked |
| Direct browser upload           | 15 minutes | Covers a slow connection on a large file                              |
| Server-side or scheduled access | 60 seconds | Machine to machine, no human latency to absorb                        |

- **Never embed a signed URL in an email, a notification, or anything persisted.** Link to an
  application route that authorises and redirects to a URL signed at that moment.
- **Sign per request, and do not cache the result.** A cached signed URL is a permission check
  that has stopped running.
- **Scope the signature as narrowly as the protocol allows:** one key, one method, one expiry.
  A presigned `PUT` must also pin `Content-Length` bounds and `Content-Type`, or the caller can
  upload anything of any size to the key you just authorised.
- **The public vhost adds TLS and routing, nothing else.** Presigned URLs are
  self-authorising; an edge that adds its own authentication in front of them breaks downloads
  in a way that looks like a signing bug.

---

## Upload validation

Uploads are hostile input ([`security/INPUT-AND-API.md`](security/INPUT-AND-API.md)). Every
check below runs server-side, in the service layer, before a single byte reaches the bucket.

**Size.** Enforced at three layers, because each catches what the others cannot: the edge (a
request-body limit, which rejects before the application allocates), the application (an
explicit per-field maximum, declared rather than inherited), and the presigned policy itself
(`content-length-range`, which is what stops a direct browser upload bypassing both). A size
limit stated in only one of the three is a limit with a documented bypass.

**Declared type against sniffed type.** The `Content-Type` header and the filename extension
are both caller-controlled and neither is evidence. Read the leading bytes, determine the real
type, and require that it appears in an **allowlist declared per upload field**, never a global
list and never a blocklist. Then require that the declared type matches the sniffed type: a
mismatch is not a file to correct, it is a request to reject, because the only thing that
produces one deliberately is an attempt to have two components disagree about what the file is.
The sniffing library (`python-magic`) is deliberately undeclared at baseline and arrives with
the feature that needs it (`pyproject.toml`).

**Filenames.** The uploaded name never becomes a key, never becomes a path, and never reaches
the filesystem. Generate a UUID key, keep the original as metadata, and sanitise it on the way
out rather than on the way in: strip directory separators, control characters and leading dots,
truncate to a bounded length, and quote it correctly in `Content-Disposition`. Treat every
filename as a potential path traversal, a potential header injection, and a potential piece of
personal data, because it is routinely all three.

**Content that is never trusted.** SVG and HTML are executable in a browser context and are not
accepted into an allowlist without a stated sanitisation step. Office documents and PDFs carry
active content. Nothing uploaded is ever executed, rendered inline from a same-origin host, or
passed to a shell. Where malware scanning is required, it happens between validation and the
final key, not after the object is already readable.

**Serve downloads with `Content-Disposition: attachment` and `X-Content-Type-Options: nosniff`**
unless a specific, allowlisted type has a stated reason to render inline.

---

## Testing

The adapter is the seam, so it is also the test surface. Exercise it against a local S3
implementation or a stubbed client through the project scripts
(`bash code/src/scripts/tests/backend.sh`), and cover, at minimum:

- A caller without permission receives no signed URL, and no object is written.
- A caller who owns a different tenant's document is rejected (IDOR).
- A file whose sniffed type contradicts its declared type is rejected.
- A file above the size limit is rejected by the application, not only by the edge.
- A generated URL expires, and an expired URL fails.
- A filename containing `../`, a null byte, or a quote is stored and served safely.

Auth-adjacent code carries the 90% coverage floor ([`TESTING.md`](TESTING.md)). Signing is
auth-adjacent.

---

## Deferred, with a trigger

Each of these is deliberately absent. Every deferral records the condition that reopens it, a
trigger, not a shrug.

| Deferred                                              | Revisit when                                                                                                                                              |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **The adapter itself, and any object-store service**  | The first story requires a file that a permission check governs. Until then `boto3` stays a declared dependency with no call site                         |
| **Direct browser upload** (presigned `POST` or `PUT`) | Upload sizes make proxying through the application worker a measured problem, not a suspected one. Proxying is simpler and keeps validation in one place  |
| **Multipart upload**                                  | A single object routinely exceeds a few hundred megabytes, or upload failures on large files are observed rather than anticipated                         |
| **Server-side or client-side encryption at rest**     | A data classification review names a category the host's disk encryption does not satisfy ([`security/CRYPTO-AND-DATA.md`](security/CRYPTO-AND-DATA.md))  |
| **Malware scanning in the upload path**               | Uploads are accepted from outside a trusted user base, or a compliance obligation names it. The scanner sits between validation and the final key         |
| **Object versioning and lifecycle rules**             | A retention obligation or an undo requirement is stated. Both are engine administration, so they belong to the deploy repository, not to this adapter     |
| **A geo-distributed engine**                          | Read latency for documents is sustained above budget from a second region, at which point the engine changes behind the seam and no application code does |

---

## Cross-references

- [`architecture/PROVIDER-NEUTRALITY.md`](architecture/PROVIDER-NEUTRALITY.md): why this is a
  protocol seam, and the evidence that claim has to keep proving
- [`security/INPUT-AND-API.md`](security/INPUT-AND-API.md): the upload-validation rules this
  guide applies to object storage specifically
- [`logging/CLOUDINARY.md`](logging/CLOUDINARY.md) and
  [`cloudinary/CONTEXT.md`](cloudinary/CONTEXT.md): the public-media half of the split
- [`DATABASE.md`](DATABASE.md): the scope column an object key is namespaced by
- [`architecture/SERVICE-AND-MIDDLEWARE.md`](architecture/SERVICE-AND-MIDDLEWARE.md): the
  service layer the adapter sits behind
- [`how-to/src/PLATFORM-PROVIDERS.md`](../../how-to/src/PLATFORM-PROVIDERS.md): the register
  recording which engine this project resolves to

> The public presign hostname, its TLS termination and its CSP allowance are catalogued as the
> deploy contract in `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` § 10; this guide
> keeps owning the "why", SERVER-ARCHITECTURE owns "what the server provides".

_Part of the `code/docs/` documentation family._
