# URL Strategy

**Last Updated**: 29/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Phase 1: Path-based routing (current plan)

All admin and portal routes are served from the same domain using path prefixes.

| Surface        | Prefix     | Example                        |
| -------------- | ---------- | ------------------------------ |
| Marketing site | `/`        | `example.com/services/`        |
| Admin area     | `/admin/`  | `example.com/admin/projects/`  |
| Client portal  | `/portal/` | `example.com/portal/projects/` |

## Phase 2: Subdomain routing (future migration)

When the platform matures, admin and portal will move to dedicated subdomains. No code changes to business logic are required — only Next.js middleware and Nginx routing configuration changes.

| Surface        | Subdomain            | Example                        |
| -------------- | -------------------- | ------------------------------ |
| Marketing site | `example.com`        | `example.com/services/`        |
| Admin area     | `admin.example.com`  | `admin.example.com/projects/`  |
| Client portal  | `portal.example.com` | `portal.example.com/projects/` |

**Migration approach:** Wrap all admin/portal URL construction in a single `buildAdminUrl()` / `buildPortalUrl()` utility. Phase 2 only requires updating those two functions and the Next.js middleware matcher.

---

## Identifier conventions

### Admin area — UUIDs in all URLs

All entity references in admin routes use UUIDs. Admins are internal users who understand technical identifiers; UUIDs prevent enumeration attacks and avoid leaking business data (e.g. client count) via sequential IDs.

| Entity         | Admin URL pattern                   |
| -------------- | ----------------------------------- |
| Client         | `/admin/clients/{client_uuid}/`     |
| Project        | `/admin/projects/{project_uuid}/`   |
| Invoice        | `/admin/invoices/{invoice_uuid}/`   |
| Support ticket | `/admin/support/{ticket_uuid}/`     |
| Proposal       | `/admin/proposals/{proposal_uuid}/` |

**Rule:** Every Django model intended to appear in admin URLs must have a `uuid` field (`UUIDField(default=uuid4, unique=True, editable=False)`).

### Client portal — slugs in all URLs

All entity references in portal routes use human-readable slugs. Clients are non-technical; slugs make URLs comprehensible and shareable without confusion. Slugs are generated on creation and are read-only after first publish.

| Entity           | Portal URL pattern                                           |
| ---------------- | ------------------------------------------------------------ |
| Portal user      | `/portal/account/` (no username in URL — authenticated only) |
| Company (client) | Contextual only — not in URL                                 |
| Project          | `/portal/projects/{project_slug}/`                           |
| Invoice          | `/portal/invoices/{invoice_uuid}/` ¹                         |
| Support ticket   | `/portal/projects/{project_slug}/tickets/{ticket_uuid}/` ¹   |

¹ Invoices and support tickets retain UUIDs in the portal — they are looked up by reference, not browsed by name, so human-readable slugs add no value and create uniqueness edge cases.

**Rule:** Every Django model intended to appear in portal project URLs must have a `slug` field (`SlugField(unique=True, max_length=200)`). Slugs are auto-generated from the name on creation using `django.utils.text.slugify` and are never auto-updated (to avoid breaking bookmarked URLs).

---

## Slug uniqueness

| Model           | Slug source  | Uniqueness scope |
| --------------- | ------------ | ---------------- |
| `<app>_<model>` | `model.name` | Global           |

If a slug collision occurs, append a short numeric suffix: `my-project-2`.

---

## CORS and session scope

- **Phase 1:** Single domain — cookies are `SameSite=Lax`, no CORS configuration needed between admin and portal.
- **Phase 2:** Cross-subdomain cookies must use `SESSION_COOKIE_DOMAIN = ".<domain>"` and `CSRF_COOKIE_DOMAIN = ".<domain>"`. Admin and portal sessions remain separate — a portal login does not grant admin access. Implement subdomain migration only after explicit security review.
