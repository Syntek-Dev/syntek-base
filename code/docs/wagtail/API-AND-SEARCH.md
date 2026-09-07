---
type: guide
skills: [stack-wagtail]
model: opus
---

# Wagtail — API and Search

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

> **CMS-only.** This guide exists only in a project generated with `INCLUDE_WAGTAIL`.

Two Wagtail surfaces, and both land on ground this project already occupies. The CMS API is
built on the same framework serving `/api/`; the CMS search index sits in the same PostgreSQL
database as the project's own full-text search. Neither is switched on by installing Wagtail,
and neither should be switched on without a reason written down.

## The gate question: does this project need a CMS API at all?

A monolith that server-renders its own pages usually needs neither API. The templates read the
page tree through the ORM; nothing has to cross HTTP to get at content that is already in
process. Ask before enabling either version:

- **Is there a consumer outside this deployable?** A React Native app, a partner integration, a
  static-site build step, a separate editorial tool. If the only consumer is the Django
  templates, the answer is no.
- **Is a write API the goal, or is the admin enough?** v3's write operations exist to build
  editorial tooling. If editors are happy in the Wagtail admin
  (`code/docs/wagtail/ADMIN-AND-PERMISSIONS.md`), a write API is attack surface bought for
  nothing.
- **Who owns the contract?** An API is a contract with a lifetime longer than the story that
  added it (`code/docs/API-DESIGN.md`).

Enabling either version is a decision recorded in `project-management/src/15-DECISIONS/`, not a
line quietly added to `INSTALLED_APPS`.

## Two APIs, not two versions of one thing

Wagtail 8 ships both, side by side, on different frameworks
([overview](https://docs.wagtail.org/en/stable/advanced_topics/api/index.html)):

|           | **v2**                   | **v3**                       |
| --------- | ------------------------ | ---------------------------- |
| Built on  | Django REST Framework    | Django Ninja + pydantic      |
| Direction | Read-only                | Read **and write**           |
| Status    | Stable, still maintained | **Preview**, new in 8.0      |
| Schema    | None generated           | OpenAPI 3.1, RFC 7807 errors |
| App label | `wagtail.api.v2`         | `wagtail.api.v3`             |

- **v2** is the battle-tested headless read API: register endpoint viewsets on a
  `WagtailAPIRouter` and expose per-model fields through `api_fields`
  ([configuration](https://docs.wagtail.org/en/stable/advanced_topics/api/v2/configuration.html)
  · [usage](https://docs.wagtail.org/en/stable/advanced_topics/api/v2/usage.html)).
- **v3** covers most of what the admin does — pages including drafts, revisions and page actions,
  images, documents, snippets, sites, locales, redirects, rich text and StreamField
  ([v3 index](https://docs.wagtail.org/en/stable/advanced_topics/api/v3/index.html)).

**v3 is a preview and upstream says so.** It may change incompatibly in any release until it
stabilises, which is why Wagtail's own instruction is to mount it at `/api/v3-preview/` rather
than `/api/v3/` — the prefix is the warning to consumers. Treat every v3 integration as work
that will need revisiting at the next Wagtail minor, and do not put a third party on it.

## The dependency collision

**Wagtail requires `django-ninja>=1.6.3,<2.0` — the same framework this project serves `/api/`
with.** One resolver, one pin, two consumers. Raising Ninja for a project feature now also moves
Wagtail's v3 API, and a Wagtail upgrade can narrow what the project's own API may run. Dependency
changes go through the normal gate with both consumers named.

**Two `NinjaAPI` instances live in one process** once v3 is mounted: the project's and Wagtail's.
Ninja requires instances to differ by `version` or `urls_namespace`, or URL reversing collides
([Ninja versioning](https://django-ninja.dev/guides/versioning/)). The project's instance owns
`/api/` and its conventions are not negotiable for it —
`code/docs/api-design/NINJA-CONVENTIONS.md`.

**Wagtail also drags in Django REST Framework**, because v2 needs it. It is present in the
dependency graph and it is **not this project's API framework**. Writing a DRF serializer or
viewset for project code is a stack change argued in an ADR, never a convenience taken because
the package happened to be installed. Subclassing a Wagtail v2 viewset to configure the CMS API
is a different act, and the only sanctioned one.

**There is a third option, and it is the one that fits this stack.** Wagtail documents building
your own Ninja endpoints over its models —
[How to set up Django Ninja](https://docs.wagtail.org/en/stable/advanced_topics/api/django-ninja.html)
— with `ModelSchema` over `Page`, calculated fields for the URL, and a union of per-type schemas
discriminated by content type. That keeps content on the project's existing `NinjaAPI`, under the
project's schema and auth conventions, and exposes exactly the fields a consumer asked for. It
costs the endpoints you write; it buys one API contract instead of two.

## If you do mount v3

- **Route order.** The API path must appear **above** the Wagtail catch-all in the root URLconf.
  The catch-all is always last (`code/docs/WAGTAIL.md` · `code/docs/URL-STRATEGY.md`); anything
  below it is unreachable.
- **The docs surface is public by default.** `<API root>/docs/` and `<API root>/openapi.json` are
  served to anonymous callers and describe the authenticated endpoints too. Set
  `WAGTAILAPI_DOCS_ENABLED = False` to close both. Note that the project's own Ninja docs live at
  `/api/docs` — two schema surfaces, and neither should be reachable in production by accident.
- **Shared settings.** v3 reads the v2 `WAGTAILAPI_*` settings where they apply —
  `WAGTAILAPI_BASE_URL`, `WAGTAILAPI_LIMIT_MAX`, `WAGTAILAPI_SEARCH_ENABLED`,
  `WAGTAILAPI_RICH_TEXT_FORMAT`
  ([settings reference](https://docs.wagtail.org/en/stable/reference/settings.html#wagtailapi-settings)).
- **Images over the API return the custom image model's shape.** That model exists before the
  first upload (`code/docs/WAGTAIL.md`), so an API added later inherits a decision already made —
  see `code/docs/wagtail/IMAGES-AND-MEDIA.md`.

### Tokens and identity

v3 authenticates with bearer tokens **tied to a user account**; a request acts as that user with
that user's Wagtail permissions
([authentication](https://docs.wagtail.org/en/stable/advanced_topics/api/v3/authentication.html)).
The details that matter to a review:

- Only an HMAC-SHA-256 digest is stored, bound to `SECRET_KEY`. Rotation works through
  `SECRET_KEY_FALLBACKS`; rotating without a fallback revokes every token at once.
- **Use dedicated service accounts, not real users' tokens.** A service account carries a minimal
  permission set and can be revoked without disturbing a person. This is the same reasoning as
  `code/docs/architecture/AUTH-CONTRACT.md`, applied to a second identity surface.
- Token management is itself permission-gated, and managing another user's tokens requires the
  user model's change permission — which also grants password resets and group membership.
- Revocation is a timestamp, not a delete, and creation and revocation are written to Wagtail's
  log. **Wagtail's log is not the project's audit record** (`code/docs/WAGTAIL.md`); an API token
  is a credential, so its lifecycle belongs in `code/docs/security/AUDIT-TRAIL.md` as well.

### Security posture

Any API over CMS content is a read surface over **draft and live content** with its own permission
model, evaluated by Wagtail rather than by the project's Policy classes. Anonymous callers reach
the public read endpoints; a missing or revoked token is treated as anonymous rather than
rejected. That makes it a distinct surface to threat-model, not an extension of `/api/`:

- Access control and IDOR over page, image and snippet identifiers —
  `code/docs/security/OWASP-AND-CHECKLIST.md` and `code/docs/security/AUTH-AND-AUTHZ.md`.
- Input handling and rate limiting on the write operations —
  `code/docs/security/INPUT-AND-API.md`. `WAGTAILAPI_LIMIT_MAX` caps page size; it is not a
  throttle.
- v3 returns RFC 7807 `application/problem+json`, which is **not** the project's error envelope.
  Reconcile the two deliberately rather than letting two shapes leak to one consumer.

## Search: the modelsearch split

**Wagtail 7.2 moved search out into the external Django Modelsearch library, and Wagtail 8
inherits it** — Wagtail 8 pins `modelsearch>=1.3.2,<1.4`. **The installable package is
`modelsearch`**; `django-modelsearch` is only the repository and documentation name. The
Wagtail-facing documentation has **not** moved — indexing, searching and backends are all still on
the Wagtail site, and they remain the pages to read:

- [Search overview](https://docs.wagtail.org/en/stable/topics/search/index.html)
- [Indexing](https://docs.wagtail.org/en/stable/topics/search/indexing.html)
- [Searching](https://docs.wagtail.org/en/stable/topics/search/searching.html)
- [Backends](https://docs.wagtail.org/en/stable/topics/search/backends.html)

What did move is the backend's own configuration reference, to
[Django Modelsearch](https://django-modelsearch.readthedocs.io/en/latest/backends.html) — the
PostgreSQL-specific options live at its
[PostgreSQL configuration](https://django-modelsearch.readthedocs.io/en/latest/backends.html#postgresql-configuration)
section. **Configure through `WAGTAILSEARCH_BACKENDS`, not `MODELSEARCH_BACKENDS`**: inside
Wagtail the Wagtail-prefixed setting is the one that applies.

### The database backend, on this stack

- `"BACKEND": "wagtail.search.backends.database"` uses the database's own full-text search. On
  PostgreSQL it requires `django.contrib.postgres` in `INSTALLED_APPS`.
- Pages, images and documents are indexed for you. Extra fields on a page model are indexed by
  appending `index.SearchField` and `index.FilterField` entries to `search_fields`; a model is
  taken out of the index entirely with `search_fields = []`.
- Signal handlers keep the index current on save and delete. `AUTO_UPDATE: False` disables them
  per backend, at which point `update_index` must run on a schedule
  ([management commands](https://docs.wagtail.org/en/stable/reference/management_commands.html)).
- Query through the QuerySet: `.search()` converts the QuerySet into results, so **filter first,
  search second**. `.autocomplete()` is the partial-match variant, for type-ahead only.
- Editorial control over results is Wagtail's promoted-search-results contrib app
  ([search promotions](https://docs.wagtail.org/en/stable/reference/contrib/searchpromotions.html)),
  alongside the other surfaces in `code/docs/wagtail/CONTRIB-SURFACES.md`.

### Two search systems in one database

This project's own search doctrine is a `tsvector` generated column with a GIN index, built per
table — `code/docs/DATABASE.md`. Wagtail's database backend maintains **its own index tables** over
the models it knows about. They coexist; they do not merge, and neither one should be
reimplemented in the other's terms:

- **CMS content is searched through Wagtail's API.** Do not hand-write a `tsvector` over
  `wagtailcore_page`. The page tree is Wagtail's, and a second index over it drifts.
- **Application data is searched through project doctrine.** A domain model that happens to be
  registered as a snippet is still application data; index it the project's way unless editors
  need to find it in the admin.
- **Elasticsearch is a dedicated search service**, whatever configures it. Adopting it clears
  `code/docs/DATABASE.md`'s trigger conditions for one first — full-text search implemented,
  indexed and measured — and it adds an operational component the sizing envelope has to carry
  (`how-to/src/SCALE-ARCHITECTURE/`).
- Index maintenance is write amplification on every editorial save. Where that shows up, it shows
  up as latency in the admin — `code/docs/PERFORMANCE.md`.

## Related guides

| Guide                                        | Covers                                                            |
| -------------------------------------------- | ----------------------------------------------------------------- |
| `code/docs/WAGTAIL.md`                       | The three settled decisions, the version floor, settings and URLs |
| `code/docs/wagtail/FUNDAMENTALS.md`          | What Wagtail is, install order, versions                          |
| `code/docs/wagtail/PAGES-AND-STREAMFIELD.md` | The page models and blocks an API serialises                      |
| `code/docs/wagtail/IMAGES-AND-MEDIA.md`      | The custom image model and renditions                             |
| `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md` | The permission model v3 tokens inherit                            |
| `code/docs/wagtail/CONTRIB-SURFACES.md`      | Forms, redirects, sitemaps, settings                              |
| `code/docs/API-DESIGN.md`                    | The project's own API contract, which this never overrides        |
