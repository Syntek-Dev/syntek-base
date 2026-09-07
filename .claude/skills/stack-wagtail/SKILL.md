---
name: stack-wagtail
description: >-
  Wagtail CMS idioms for <%PROJECT_NAME%> — the content management surface running inside the
  Django deployable: page models and the page tree, StreamField blocks, the native Willow
  rendition pipeline on Cloudinary storage, the editor admin as a second authentication
  surface, and the audit and personal-data debt a CMS arrives with. Load this when writing or
  reviewing a Page subclass, a StreamField block, a Wagtail hook or the CMS admin wiring, or
  when a backend, frontend, database or security skill needs the canonical Wagtail idioms.
---

# Stack: Wagtail (<%PROJECT_NAME%>)

**CMS-only.** This skill and the guides it routes to exist only in a project generated with
`INCLUDE_WAGTAIL`.

Reference material for the **content management surface**. It is deliberately thin: Wagtail
work is Django work, so the doing belongs to the skills that already own it. What lives here is
the routing — which guide answers which question, and the four rules that are true in this
project and nowhere in Wagtail's own documentation.

**Locale:** British English (en_GB) · <%TIMEZONE%> · <%CURRENCY%>.

---

## When to use this skill

Any task touching a `Page` subclass, a StreamField block or its template, a Wagtail hook, the
CMS admin wiring, or the Wagtail image and document models.

**Not** a substitute for the skills that do the work. A `Page` subclass **is** a Django model
and a block template **is** a Django template, so:

| The work                                  | The skill that does it | What this skill adds                                         |
| ----------------------------------------- | ---------------------- | ------------------------------------------------------------ |
| Page models, migrations, service layer    | `backend`              | The page tree owns URLs the marketing app would otherwise    |
| Block templates, components, token CSS    | `frontend`             | A block template is a component; StreamField is not a system |
| Schema, indexes, RLS policies             | `database`             | Wagtail's tables carry no scope column                       |
| Permission checks, the admin surface, PII | `security`             | The editor admin is a second authentication surface          |
| Tests for any of the above                | `test-writer`          | Page models are measured; Wagtail's own package is not       |

Load this **alongside** one of those, never instead of one.

---

## The four rules

These are project decisions, not Wagtail defaults. Wagtail's documentation will tell you
otherwise on all four, because it does not know about this stack.

1. **The native rendition pipeline stays, and Cloudinary is the storage beneath it.** Willow
   and Pillow do the transform; Cloudinary holds the bytes. Never the app filesystem, never the
   private S3 route. `code/docs/OBJECT-STORAGE.md` is why.
2. **The custom image model exists before the first upload.** Switching later copies nothing
   and needs a hand-written data migration.
3. **The editor admin never mounts at `/admin/`,** and Wagtail's catch-all route is always
   last in the root URLconf. `code/docs/URL-STRATEGY.md` owns the route table.
4. **Wagtail's `PageLogEntry` and `Revision` never stand in for the audit trail.** They
   duplicate it; `code/docs/security/AUDIT-TRAIL.md` states what an audit record must be.

---

## Where the answers live

`code/docs/WAGTAIL.md` is the index; the detail is in `code/docs/wagtail/`:

| Question                                                    | Guide                                        |
| ----------------------------------------------------------- | -------------------------------------------- |
| What is Wagtail, how is it installed, what version          | `code/docs/wagtail/FUNDAMENTALS.md`          |
| Authoring a page type, blocks, rich text                    | `code/docs/wagtail/PAGES-AND-STREAMFIELD.md` |
| Images, documents, renditions, storage, upload hardening    | `code/docs/wagtail/IMAGES-AND-MEDIA.md`      |
| The editor admin, groups, permissions, moderation, previews | `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md` |
| Forms, redirects, sitemaps, settings, routable pages        | `code/docs/wagtail/CONTRIB-SURFACES.md`      |
| The v2 and v3 APIs, search and Modelsearch                  | `code/docs/wagtail/API-AND-SEARCH.md`        |

Each guide links out to the matching section of Wagtail's own documentation. **Read the
project guide first** — it says which of Wagtail's options this project has already closed off,
and reading upstream first produces answers this project has rejected
(`.claude/CLAUDE.md` Section 3.2).

---

## The six decisions a CMS project settles once

Do not answer these per story. Each is recorded in `project-management/src/15-DECISIONS/`
before the second page type exists, and each is named in the guide that raises it:

1. Which of the page tree or a Django view owns each public route.
2. Which store is authoritative for CMS roles, and how it stays in step with the project's own.
3. Whether Wagtail's tables lacking a scope column is acceptable here.
4. Who owns the `<head>` — Wagtail's page fields or the project's `build_seo()` pipeline.
5. The `how-to/src/PLATFORM-PROVIDERS.md` substrate row, with its reason.
6. How brand voice is enforced on content the prose gate cannot see, because it lives in the
   database rather than in a file.

---

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here. **There is no
`code/workflows/` folder for the CMS**: Wagtail ships no source tree and no scripts, so its
one-time install lives in `code/docs/wagtail/FUNDAMENTALS.md` and every repeatable piece is
carried by the workflows below, each carrying a flagged `CMS-only` note at the step it affects.

- `project-management/workflows/19-backend-code/` — where a `Page` subclass and its migration belong
- `project-management/workflows/21-frontend-code/` — block templates, and who owns a public route
- `project-management/workflows/12-seo-checks/` — who owns the `<head>` on a CMS-served page
- `project-management/workflows/09-gdpr-compliance/` — the form-submission personal-data sink
- `code/workflows/03-database-migration/` — Wagtail's tables and the missing scope column
- `code/workflows/06-gdpr-enforcement/` — the export and erasure wrappers the content app owns
- `code/workflows/08-security-hardening/` — the second login surface and the upload path
- `code/workflows/02-tdd-cycle/` — Red → Green → Refactor for page models and blocks

## The one thing that is easy to get wrong

**Wagtail brings Django REST Framework and `django-tasks` into the dependency graph** — for its
own older API and its own task interface. Neither is this project's. Django Ninja serves
`/api/` and Celery runs background work, and that does not change because a CMS is installed.
Building on either is a stack change, argued in an ADR, not a convenience.
