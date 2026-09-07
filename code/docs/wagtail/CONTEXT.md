# code/docs/wagtail

Sub-documents of [`code/docs/WAGTAIL.md`](../WAGTAIL.md), split out because the index would
otherwise exceed the 300-line instructional limit once it covered Wagtail rather than only its
edges. Present only in a project generated with the CMS surface (`INCLUDE_WAGTAIL`).

## Directory Tree

```text
code/docs/wagtail/
├── CONTEXT.md                   ← this file
├── CLAUDE.md                    ← operating rules
├── FUNDAMENTALS.md              ← the mental model, the install order, the version floor
├── PAGES-AND-STREAMFIELD.md     ← page types, blocks, rich text, snippets
├── IMAGES-AND-MEDIA.md          ← renditions, storage, upload hardening, documents
├── ADMIN-AND-PERMISSIONS.md     ← the editor admin, groups, moderation, previews
├── CONTRIB-SURFACES.md          ← forms, redirects, sitemaps, settings, routable pages
└── API-AND-SEARCH.md            ← the v2 and v3 APIs, search and Modelsearch
```

## Which document, when

| Document                   | Read before                                                                                   |
| -------------------------- | --------------------------------------------------------------------------------------------- |
| `FUNDAMENTALS.md`          | Anything. It is the base-level understanding the rest assumes, and it holds the install order |
| `PAGES-AND-STREAMFIELD.md` | Authoring a page type, a block, or a rich-text field                                          |
| `IMAGES-AND-MEDIA.md`      | Touching images or documents — and **before the first upload**, not after                     |
| `ADMIN-AND-PERMISSIONS.md` | Mounting the admin, granting a CMS role, or reviewing the auth surface                        |
| `CONTRIB-SURFACES.md`      | Enabling a `wagtail.contrib` app — two of them arrive switched on                             |
| `API-AND-SEARCH.md`        | Exposing CMS content over HTTP, or making pages searchable                                    |

## Why this family exists at all

Wagtail's own documentation is large, good, and does not know about this project. Each file here
answers the same two questions in the same order: **what Wagtail does**, with a link to the
upstream page that owns it, and then **what this project has already decided about it**, which is
usually narrower than what Wagtail permits. Reading upstream first produces answers this project
has rejected (`.claude/CLAUDE.md` Section 3.2).

The links point at `docs.wagtail.org/en/stable/`. The version-pinned form is `/en/v8.0/` — note
the `v`, without which the URL 404s — and it is deliberately not used here, because these guides
ship into projects that will upgrade.

## Cross-references

- `code/docs/WAGTAIL.md` — the index these belong to, holding the settled decisions
- `.claude/skills/stack-wagtail/` — the skill that routes work into these guides
- `code/docs/OBJECT-STORAGE.md` — the media routing invariant `IMAGES-AND-MEDIA.md` obeys
- `code/docs/security/AUDIT-TRAIL.md` — the record `ADMIN-AND-PERMISSIONS.md` defers to

**Last Updated**: <%DATE%>
