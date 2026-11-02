---
type: guide
skills: [stack-wagtail]
model: opus
---

# Wagtail Guide

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

**Applies to:** the Wagtail apps inside the Django deployable **Reference implementation:** the
content app **Claude Model:** opus — page models, the media pipeline, the second admin surface

The content management surface of <%PROJECT_NAME%>: **Wagtail 8**, running inside the same Django
deployable that serves the API and the rendered pages. Not a separate service and not a headless
backend — one process, one database, one deploy.

> **CMS-only.** This guide and the family beneath it exist only in a project generated with
> `INCLUDE_WAGTAIL`. A project without it has no CMS, and the public pages are ordinary Django
> views.

## Sub-documents

This file is an index. It holds what is true across the whole surface; the detail lives in
[`wagtail/`](wagtail/CONTEXT.md), and each of those answers the same two questions in order —
what Wagtail does, with a link to the upstream page that owns it, then what this project has
already decided about it.

| Document                                                               | Read before                                                                      |
| ---------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| [`wagtail/FUNDAMENTALS.md`](wagtail/FUNDAMENTALS.md)                   | Anything else — the page tree, the mental model, the install order, the versions |
| [`wagtail/PAGES-AND-STREAMFIELD.md`](wagtail/PAGES-AND-STREAMFIELD.md) | Authoring a page type, a block, a rich-text field or a snippet                   |
| [`wagtail/IMAGES-AND-MEDIA.md`](wagtail/IMAGES-AND-MEDIA.md)           | Touching images or documents — and **before the first upload**, never after      |
| [`wagtail/ADMIN-AND-PERMISSIONS.md`](wagtail/ADMIN-AND-PERMISSIONS.md) | Mounting the admin, granting a CMS role, or auditing the auth surface            |
| [`wagtail/CONTRIB-SURFACES.md`](wagtail/CONTRIB-SURFACES.md)           | Enabling a `wagtail.contrib` app — two of them arrive switched on                |
| [`wagtail/API-AND-SEARCH.md`](wagtail/API-AND-SEARCH.md)               | Exposing CMS content over HTTP, or making pages searchable                       |

Upstream, the corresponding shape is `getting_started/`, `topics/`, `advanced_topics/`,
`extending/`, `reference/` and `releases/` at <https://docs.wagtail.org/en/stable/>. Read the
project guide first: it says which of Wagtail's options this project has already closed off, and
reading upstream first produces answers this project has rejected (`.claude/CLAUDE.md`
Section 3.2).

---

## Read this first: what this guide decides for you

Wagtail is a large framework with several defensible integrations. This project has already
chosen among them, and these three are not per-story preferences:

1. **Wagtail's native image pipeline stays.** Willow and Pillow generate renditions in-process.
   Cloudinary is the **storage** underneath, never the transformation engine.
2. **A custom image model exists from day one** — before the first upload, because switching
   later copies nothing automatically and needs a hand-written data migration.
3. **Wagtail's admin never mounts at `/admin/`.** That prefix belongs to the project's own admin
   area; the built-in Django admin stays at `/control/` (`code/docs/URL-STRATEGY.md`).

Each is argued in the sub-document that owns it. Departing from one is a design decision that
goes through the normal gate, not a config change.

## Version floor

Wagtail 8.0 declares support for Django 6.1 and classifies Python 3.14, both of which this stack
requires. Two consequences worth knowing before you read a traceback:

- **Wagtail depends on Django Ninja** (`>=1.6.3,<2.0`) and pydantic. Its v3 REST API is built on
  the same framework this project serves `/api/` with, so raising or pinning Ninja affects both.
- **Wagtail also brings Django REST Framework and `django-tasks`**, for its older API and its
  task interface respectively. Neither is this project's API framework or task runner. Do not
  build on either — Ninja and Celery remain the only two, and a second of each in the dependency
  graph is a cost of the CMS, not a licence to use it.

The release cadence, the LTS position and the upgrade path are in
[`wagtail/FUNDAMENTALS.md`](wagtail/FUNDAMENTALS.md).

## The six decisions a CMS project settles once

A CMS does not fit this stack cleanly, and the friction is concentrated in six places. Settle
each **before the second page type exists**, record it in `project-management/src/15-DECISIONS/`,
and do not re-answer it per story. The guide that raises each is named beside it:

| Decision                                                              | Raised in                          |
| --------------------------------------------------------------------- | ---------------------------------- |
| Which of the page tree or a Django view owns each public route        | `wagtail/FUNDAMENTALS.md`          |
| Which store is authoritative for CMS roles, and how it stays in step  | `wagtail/ADMIN-AND-PERMISSIONS.md` |
| Whether Wagtail's tables lacking a scope column is acceptable here    | `wagtail/ADMIN-AND-PERMISSIONS.md` |
| Who owns the `<head>` — Wagtail's page fields or `build_seo()`        | `wagtail/CONTRIB-SURFACES.md`      |
| The `how-to/src/PLATFORM-PROVIDERS.md` substrate row, with its reason | `wagtail/FUNDAMENTALS.md`          |
| How brand voice is enforced on content the prose gate cannot see      | below                              |

## Brand voice has a blind spot here, and it is new

`code/src/scripts/audits/copy-slop.sh` blocks machine-authored prose tells in `.py` and `.html`
files within its declared scopes. **Content in the database is outside that scan.** Introducing a
CMS moves the copy that matters most out of the gate's reach — not because the gate is wrong, but
because a file scan cannot see a database.

If brand voice is to hold on CMS content it needs a second, database-side implementation: a
publish hook or a page-model validation step running the same clauses. Until that exists, say so
rather than implying the gate covers it.

## Where Wagtail sits against the standing standards

Each row is a pointer. The owning guide is unchanged by the CMS; what changes is what satisfies
it.

| Standard                                               | How the CMS meets it                                                                                                                                                         |
| ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/docs/data-structures/TYPES-OVER-DICTIONARIES.md` | Block **definitions** are classes and stay typed; the serialised StreamField value is the documented exception in `code/docs/data-structures/TYPES-EXCEPTIONS.md`            |
| `code/docs/DESIGN-TOKENS.md`                           | Binds the public surface. A block template consumes `var(--token)` like any other component. Wagtail's admin CSS is the vendor's and is out of scope                         |
| `code/docs/ACCESSIBILITY.md`                           | WCAG 2.2 AA is an outcome, so editor-authored content is in scope. Wagtail's built-in checker helps; it does not discharge the obligation                                    |
| `code/docs/DISCOVERABILITY.md`                         | A Wagtail page carries its own `seo_title` and `search_description` and its own serve path. Bridging those into `build_seo()` is work, not a default                         |
| `code/docs/security/AUDIT-TRAIL.md`                    | Wagtail's `PageLogEntry` and `Revision` **duplicate** the audit record and never discharge it — they carry sequential keys and cascading foreign keys, which that guide bans |
| `project-management/docs/gdpr/DATA-RIGHTS.md`          | Wagtail's tables cannot expose the export and erasure functions that guide makes merge-blocking, so the content app owns wrappers                                            |
| `code/docs/testing/COVERAGE.md`                        | Wagtail's own package and migrations are out of scope. Every page model, block and hook **this project writes** is measured at the standard floors                           |
| `how-to/src/PLATFORM-PROVIDERS.md`                     | Wagtail is a **substrate** row, not an adapter seam — once page models are authored against its `Page` class there is nothing to swap behind                                 |

## Wagtail AI is deliberately not adopted

Wagtail AI is not part of this surface, and adding it is a fresh decision rather than an
extension of this one. As of this guide's date its released version targets Wagtail 7 and Django
5.2 with no Django 6 classifier, its dependency chain is alpha throughout, it makes the LLM
provider a data processor requiring a processing agreement and a sub-processor register entry,
and it generates exactly the machine-authored copy the section above describes the gate as unable
to see.

None of that is permanent. All of it is a decision to take on the evidence at the time.

## Non-negotiables

- **Wagtail's admin never mounts at `/admin/`,** and its catch-all is always the last route.
- **Cloudinary is the storage; Willow is the transform.** Neither the app filesystem nor the
  private object-store route is a home for CMS media (`code/docs/OBJECT-STORAGE.md`).
- **The custom image model exists before the first upload,** and the upload hardening required by
  `code/docs/security/INPUT-AND-API.md` lives on its form base.
- **Wagtail's log models never stand in for the audit trail.**
- **Editor actions are state-changing operations on a privileged path** and carry the same
  permission and audit obligations as any endpoint.
- **A page's copy is not covered by the prose gate.** Never report it as though it were.

## Cross-references

- [`wagtail/CONTEXT.md`](wagtail/CONTEXT.md) — the six sub-documents and which to read when
- `.claude/skills/stack-wagtail/` — the skill that routes CMS work into this family
- `code/docs/URL-STRATEGY.md` — the route table the CMS prefix and the catch-all join
- `code/docs/OBJECT-STORAGE.md` — the media routing invariant that puts Wagtail on Cloudinary
- `research/WAGTAIL-CMS-INTEGRATION.md` — the primary-source note this family was written from, <!-- doc-references: template-only -->
  with a citation on every claim
