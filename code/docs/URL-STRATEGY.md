---
type: guide
agent: backend
skills: [stack-django]
model: opus
---

# URL Strategy

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB) **Timezone**: {{TIMEZONE}}
**Claude Model:** opus — Quick reference for URL patterns, path conventions, route naming
**MCP Servers:** code-review-graph (route structure analysis)

---

## Phase 1: Path-based routing (current plan)

All surfaces are served from the same domain using path prefixes. Every surface is Django
server-rendered — there is **no Node/Next server** anywhere in the stack.

| Surface        | Prefix      | Example                               |
| -------------- | ----------- | ------------------------------------- |
| Marketing site | `/`         | `{{PRIMARY_DOMAIN}}/services/`        |
| Custom admin   | `/admin/`   | `{{PRIMARY_DOMAIN}}/admin/projects/`  |
| Client portal  | `/portal/`  | `{{PRIMARY_DOMAIN}}/portal/projects/` |
| Built-in admin | `/control/` | `{{PRIMARY_DOMAIN}}/control/`         |

### The four surfaces

| Prefix      | Surface                 | Served by                                            | Audience                     |
| ----------- | ----------------------- | ---------------------------------------------------- | ---------------------------- |
| `/`         | Public marketing site   | Django templates + django-components + HTMX + Alpine | Anonymous visitors           |
| `/admin/`   | Custom admin area       | Django templates + django-components + HTMX + Alpine | Admin / staff users          |
| `/portal/`  | Client portal           | Django templates + django-components + HTMX + Alpine | Authenticated clients        |
| `/control/` | Django's built-in admin | `django.contrib.admin`                               | Developers / superusers only |

### `/admin/` — the custom admin area

`/admin/` is the application's **own** admin area, not `django.contrib.admin`. It is Django
server-rendered exactly like the rest of the site (templates + django-components + HTMX + Alpine) —
the admin surface gets no separate client-side stack. Editing screens post through HTMX to Django
views; anything a machine client needs goes through session-authenticated Django Ninja JSON
endpoints. Admin and staff users land here after login.

### `/control/` — Django's built-in admin

The built-in Django admin (`django.contrib.admin`) is mounted at **`/control/`**. It is a
superuser/developer-only escape hatch for raw model access — not the primary management
interface. Restrict it to `is_superuser`, and keep the path out of the sitemap and `robots.txt`.

**Non-negotiable:** never mount `django.contrib.admin` at `/admin/`. The `/admin/` prefix is
exclusively owned by the custom admin area above; the built-in admin always lives at `/control/`.

## Phase 2: Subdomain routing (future migration)

When the platform matures, the admin and portal surfaces move to dedicated subdomains. No
business-logic changes are required — only edge/Nginx host routing and the URL-construction
helpers change.

| Surface        | Subdomain                   | Example                               |
| -------------- | --------------------------- | ------------------------------------- |
| Marketing site | `{{PRIMARY_DOMAIN}}`        | `{{PRIMARY_DOMAIN}}/services/`        |
| Custom admin   | `admin.{{PRIMARY_DOMAIN}}`  | `admin.{{PRIMARY_DOMAIN}}/projects/`  |
| Client portal  | `portal.{{PRIMARY_DOMAIN}}` | `portal.{{PRIMARY_DOMAIN}}/projects/` |

**Migration approach:** Wrap all admin/portal URL construction in a single `build_admin_url()` /
`build_portal_url()` helper — never hand-build these paths in templates or views. Phase 2 then
only requires updating those two helpers and the edge/Nginx host routing.

---

## Identifier conventions

### Admin area — UUIDs in all URLs

All entity references in admin routes use UUIDs. Admin and staff users are internal and understand
technical identifiers; UUIDs prevent enumeration attacks and avoid leaking business data (e.g.
client count) via sequential IDs.

| Entity         | Admin URL pattern                   |
| -------------- | ----------------------------------- |
| Client         | `/admin/clients/{client_uuid}/`     |
| Project        | `/admin/projects/{project_uuid}/`   |
| Invoice        | `/admin/invoices/{invoice_uuid}/`   |
| Support ticket | `/admin/support/{ticket_uuid}/`     |
| Proposal       | `/admin/proposals/{proposal_uuid}/` |

**Rule:** Every Django model intended to appear in admin URLs must have a `uuid` field
(`UUIDField(default=uuid4, unique=True, editable=False)`).

### Client portal — slugs in all URLs

All entity references in portal routes use human-readable slugs. Clients are non-technical; slugs
make URLs comprehensible and shareable without confusion. Slugs are generated on creation and are
read-only after first publish.

| Entity           | Portal URL pattern                                           |
| ---------------- | ------------------------------------------------------------ |
| Portal user      | `/portal/account/` (no username in URL — authenticated only) |
| Company (client) | Contextual only — not in URL                                 |
| Project          | `/portal/projects/{project_slug}/`                           |
| Invoice          | `/portal/invoices/{invoice_uuid}/` ¹                         |
| Support ticket   | `/portal/projects/{project_slug}/tickets/{ticket_uuid}/` ¹   |

¹ Invoices and support tickets retain UUIDs in the portal — they are looked up by reference, not
browsed by name, so human-readable slugs add no value and create uniqueness edge cases.

**Rule:** Every Django model intended to appear in portal project URLs must have a `slug` field
(`SlugField(unique=True, max_length=200)`). Slugs are auto-generated from the name on creation
using `django.utils.text.slugify` and are never auto-updated (to avoid breaking bookmarked URLs).

---

## Slug uniqueness

| Model                     | Slug source    | Uniqueness scope |
| ------------------------- | -------------- | ---------------- |
| `clients_clientproject`   | `project.name` | Global           |
| `portfolio_portfolioitem` | `item.title`   | Global           |
| `portfolio_casestudy`     | `study.title`  | Global           |
| `blog_post`               | `post.title`   | Global           |

If a slug collision occurs, append a short numeric suffix: `my-project-2`.

---

## CORS and session scope

- **Phase 1:** Single domain — cookies are `SameSite=Lax`, and no CORS configuration is needed
  between the admin and portal surfaces.
- **Phase 2:** Cross-subdomain cookies must use `SESSION_COOKIE_DOMAIN = ".{{PRIMARY_DOMAIN}}"` and
  `CSRF_COOKIE_DOMAIN = ".{{PRIMARY_DOMAIN}}"`. Admin and portal sessions remain separate — a portal login
  does not grant admin access. Implement subdomain migration only after explicit security review.
  Where a real cross-origin caller exists, `CORS_ALLOWED_ORIGINS` must be an explicit allowlist —
  never `*` in production.
- **Edge contract:** The consolidated routing/headers contract the server and edge must provide
  lives in `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` — these URL paths are an edge
  requirement the NixOS deployment repo implements.
