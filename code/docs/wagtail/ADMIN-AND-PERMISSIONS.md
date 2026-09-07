---
type: guide
skills: [stack-wagtail]
model: opus
---

# Wagtail — Admin and Permissions

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

> **CMS-only.** This guide exists only in a project generated with `INCLUDE_WAGTAIL`.

The editor admin is where Wagtail collides hardest with this project's own contracts. It brings a
second login, a second authorisation store and a second audit record, all against the same user
model and the same session cookie. This guide names each collision and routes to the guide that
already owns the rule.

Install order, app list and version floor: `code/docs/wagtail/FUNDAMENTALS.md`.

---

## Where the admin mounts

The Wagtail admin needs a URL prefix, and **it is never `/admin/`** — this project reserves that
path and puts Django's own admin at `/control/`. Pick a distinct, non-obvious prefix for the
editor admin; `code/docs/URL-STRATEGY.md` owns the route table and every prefix in it, and
`code/docs/WAGTAIL.md` carries the settled decision.

Two ordering facts follow from mounting a CMS inside an existing project:

- **The Wagtail front-end catch-all is always last** in `code/src/django/config/urls.py`. It
  matches any unclaimed path, so anything routed after it is unreachable — the API, the marketing
  routes and the health probes all resolve first. Rule and rationale: `code/docs/WAGTAIL.md`.
- **`WAGTAILADMIN_BASE_URL` is the absolute public origin**, and upstream is explicit that it
  carries neither the admin path nor a trailing slash. Notification emails, the user bar and the
  admin's other absolute URLs are built from it, so a wrong value ships a wrong link to a real
  editor rather than failing loudly. Left unset it raises a system check warning.

Upstream on adding Wagtail to an existing project:
[advanced_topics/add_to_django_project.html](https://docs.wagtail.org/en/stable/advanced_topics/add_to_django_project.html).

---

## The second authentication surface

**Wagtail ships its own login view, its own password-reset flow and its own account-settings page,
against the same `AUTH_USER_MODEL`, issuing the same Django session cookie.** A session obtained at
the CMS login is a session everywhere. There is no separate CMS identity to reason about
separately.

Say the consequence plainly: **every requirement `code/docs/security/AUTH-AND-AUTHZ.md` places on
this project's own login either reaches the CMS login too, or the CMS is the documented way around
all of it.** MFA on privileged accounts, session regeneration on privilege change, lockout or
exponential back-off after repeated failures, and identical response shapes so neither login nor
reset leaks whether an account exists — all of them, at both doors or at neither.

The levers, all in
[reference/settings.html](https://docs.wagtail.org/en/stable/reference/settings.html):

| Setting                               | What it buys                                                                                                               |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `WAGTAILADMIN_LOGIN_URL`              | Redirects unauthenticated admin requests to the project's own login view. Unset, Wagtail falls back to its own admin login |
| `WAGTAILADMIN_USER_LOGIN_FORM`        | Extends Wagtail's `LoginForm` with extra fields, where the redirect is not wanted                                          |
| `WAGTAIL_PASSWORD_RESET_ENABLED`      | Turns off the CMS's parallel reset flow when the project owns password reset                                               |
| `WAGTAIL_PASSWORD_MANAGEMENT_ENABLED` | Turns off in-admin password change                                                                                         |
| `WAGTAILUSERS_PASSWORD_ENABLED`       | Whether password fields appear in the CMS user editor at all                                                               |

`WAGTAILADMIN_LOGIN_URL` is the cheapest correct answer: one login view, one set of controls, one
place a security finding lands. Choosing anything else is a decision that gets recorded in
`project-management/src/15-DECISIONS/` with the compensating controls named, not a default that
happens.

Enumeration and response-shape rules: `code/docs/security/INPUT-AND-API.md`. The checklist a live
surface is audited against: `code/docs/security/OWASP-AND-CHECKLIST.md`.

Entry to the admin at all is gated by the **"Can access Wagtail admin"** permission, so a user
account existing is not the same as an editor account existing.

---

## Two authorisation stores, and which one is authoritative

Wagtail extends Django groups in three directions
([topics/permissions.html](https://docs.wagtail.org/en/stable/topics/permissions.html)):

- **Page permissions** attach at any point in the page tree and propagate down it: add, edit,
  publish, bulk delete, lock, unlock. There is no separate delete permission — edit implies delete,
  and the creating user owns what they create.
- **Collection permissions** do the same for images and documents over the collection tree. The
  `choose` permission is a chooser-UI affordance, and upstream states outright that it is **not** a
  mechanism for hiding sensitive files from a low-privilege editor.
- **Permission policies** handle everything else, registered per model in a global registry
  ([reference/permissions.html](https://docs.wagtail.org/en/stable/reference/permissions.html)).

**None of this passes the canonical predicate in `code/docs/architecture/AUTH-CONTRACT.md`.** That
contract gates on the actor's area-admin and superadmin flags, actor-is-not-target, and area scope.
A Wagtail group grants over a tree of content. The two vocabularies do not translate.

**The decision: the Wagtail group and permission store is authoritative for CMS roles only** — what
an editor may do to content, inside the editor admin. It is never authoritative for anything the
application's own endpoints, services or MCP tools check; those stay on the contract predicate,
without exception. A change that lets membership of a Wagtail group widen an application permission
has crossed the boundary, and is a review finding rather than a design option.

Row-level security does not follow the CMS for free either: Wagtail's own tables are scoped by no
policy unless one is written for them. `code/docs/rls/FUNDAMENTALS.md`.

A permission the CMS needs but no model owns is created against the content type of
`wagtail.admin.models.Admin` and surfaced with the `register_permissions` hook —
[adding custom permissions](https://docs.wagtail.org/en/stable/topics/permissions.html#adding-custom-permissions).
Field-level and panel-group restrictions are a `permission` argument on the panel:
[reference/pages/panels.html](https://docs.wagtail.org/en/stable/reference/pages/panels.html).

---

## Custom user models and `wagtail.users`

`AUTH_USER_MODEL` is unset at baseline, so Django's `auth.User` is in use and the choice is still
open — decide it before the first migration (`code/src/django/config/settings/CONTEXT.md`).
Wagtail accommodates a custom model
([custom_user_models.html](https://docs.wagtail.org/en/stable/advanced_topics/customization/custom_user_models.html)),
and adopting one here costs four things beyond setting `AUTH_USER_MODEL` itself:

1. The model inherits `AbstractBaseUser` and `PermissionsMixin` — `AbstractUser` satisfies both.
2. The app holding it sits **above** `wagtail.users` in `INSTALLED_APPS`, so its template overrides
   win.
3. Extra fields reach the CMS user forms by subclassing `UserEditForm` and `UserCreationForm`.
4. Those forms are wired in through a `UserViewSet` subclass named by a `WagtailUsersAppConfig`
   subclass, which **replaces** the plain `wagtail.users` entry in `INSTALLED_APPS`.

The consequence worth stating: the CMS user editor is a **second write path onto the user model**,
including any encrypted or PII column on it. Whatever `code/docs/ENCRYPTION-GUIDE.md` requires of
the first write path applies here, and a field that should never be editable by an editor is kept
out of these forms rather than merely hidden in a template.

---

## Editorial workflow

Upstream has no single editorial-workflow topic page, so the shape is set out here and the
individual references are linked.

**Moderation workflows.** A `Workflow` is an ordered set of `Task`s assigned to part of the page
tree; a submission creates a `WorkflowState`, and each task a `TaskState`. All of these are
documented models in
[reference/models.html](https://docs.wagtail.org/en/stable/reference/models.html). One task type
ships — `GroupApprovalTask`, approval by membership of a group. Custom task types subclass `Task`,
expose their fields through `admin_form_fields`, and override `user_can_access_editor`,
`locked_for_user` and `get_actions` to change behaviour:
[extending/custom_tasks.html](https://docs.wagtail.org/en/stable/extending/custom_tasks.html). A
custom task is application code and is held to `code/docs/BACKEND-CODING-PRINCIPLES.md` and
`code/docs/data-structures/TYPES-OVER-DICTIONARIES.md` like any other.

The switches — `WAGTAIL_WORKFLOW_ENABLED`, `WAGTAIL_WORKFLOW_REQUIRE_REAPPROVAL_ON_EDIT`,
`WAGTAIL_WORKFLOW_CANCEL_ON_PUBLISH`, `WAGTAIL_FINISH_WORKFLOW_ACTION` — are the
[workflow settings block](https://docs.wagtail.org/en/stable/reference/settings.html#workflow-settings).

**Revisions and comparison.** Every save writes a `Revision`, and the admin compares any two. They
accumulate without bound, which is a data-layer problem the moment the content volume is real: the
`purge_revisions` management command exists for it
([reference/management_commands.html](https://docs.wagtail.org/en/stable/reference/management_commands.html)),
and growth planning is `code/docs/DATABASE.md`.

**Scheduled publishing is not a background job Wagtail runs for you.** A draft scheduled for a
future date goes live only when the `publish_scheduled` management command runs. This project's
scheduler is Celery beat, so scheduled publishing is a beat entry that has to exist, be monitored,
and be present in every environment where editors can schedule. Without it the content silently
never appears.

**Locking.** The `lock` and `unlock` page permissions cover manual locks;
`WAGTAILADMIN_GLOBAL_EDIT_LOCK` makes a lock bind its own author too, so the user who applied it
cannot edit the locked page or snippet either; and a workflow task locks through `WorkflowLock`
while it holds the object.

**Previews.** Preview renders the draft through the real page template, under the editor's own
session. It is a real request against real code, not a static mock — so an N+1, a permission check
or a slow call in that template is exercised by preview exactly as it is in production. The
editing interface itself is
[page_editing_interface.html](https://docs.wagtail.org/en/stable/advanced_topics/customization/page_editing_interface.html).

---

## The audit position

`PageLogEntry` and `Revision` record who changed which content and when, and the admin builds its
history views from them
([extending/audit_log.html](https://docs.wagtail.org/en/stable/extending/audit_log.html)). They
**duplicate part of the record `code/docs/security/AUDIT-TRAIL.md` requires and satisfy none of
it**: they are scoped to CMS objects only, written by Wagtail's own code paths, carry no linkage to
this project's actor, target and action vocabulary, are retained on Wagtail's terms rather than the
project's, and offer no tamper-resistance. Treat them as an editor convenience. Where a CMS action
is one the audit trail must hold, write the project's own audit record as well, in the same
transaction — `wagtail.log_actions.log` and the `register_log_actions` hook are how that write
hangs off a CMS action, but the authoritative record is the project's.

---

## Hooks — the admin extension point

Wagtail's admin is extended through **hooks**, registered from a `wagtail_hooks` module inside an
installed app. The full roster is
[reference/hooks.html](https://docs.wagtail.org/en/stable/reference/hooks.html); the ones this area
reaches for are `register_permissions`, `register_group_permission_panel`, `register_admin_viewset`,
`register_admin_urls`, `construct_main_menu`, `register_account_settings_panel`,
`register_log_actions`, and the `before_edit_page` family for interception.

Two standing rules: **a hook is application code**, so it carries type hints, tests and the coverage
floor in `code/docs/testing/COVERAGE.md` like anything else; and **a hook is not a security
boundary** — hiding a menu item or a panel changes what an editor sees, never what they can reach.
The permission behind it is what closes the door.

Beyond hooks: admin views and viewsets
([extending/admin_views.html](https://docs.wagtail.org/en/stable/extending/admin_views.html),
[reference/viewsets.html](https://docs.wagtail.org/en/stable/reference/viewsets.html)), group
edit/create views
([extending/customizing_group_views.html](https://docs.wagtail.org/en/stable/extending/customizing_group_views.html)),
the account settings form
([extending/custom_account_settings.html](https://docs.wagtail.org/en/stable/extending/custom_account_settings.html)),
and admin templates
([admin_templates.html](https://docs.wagtail.org/en/stable/advanced_topics/customization/admin_templates.html)).
Admin UI you customise still owes WCAG 2.2 AA — `code/docs/ACCESSIBILITY.md`.

Testing helpers for all of it:
[advanced_topics/testing.html](https://docs.wagtail.org/en/stable/advanced_topics/testing.html).

---

## Related guides

| Guide                                        | Covers                                                     |
| -------------------------------------------- | ---------------------------------------------------------- |
| `code/docs/WAGTAIL.md`                       | The parent index, the settled decisions, the version floor |
| `code/docs/wagtail/FUNDAMENTALS.md`          | What Wagtail is, install order, versions                   |
| `code/docs/wagtail/PAGES-AND-STREAMFIELD.md` | Page types, blocks, rich text                              |
| `code/docs/wagtail/IMAGES-AND-MEDIA.md`      | Images, documents, renditions, storage                     |
| `code/docs/wagtail/CONTRIB-SURFACES.md`      | Forms, redirects, sitemaps, settings                       |
| `code/docs/wagtail/API-AND-SEARCH.md`        | The v2/v3 APIs, search, Modelsearch                        |
| `.claude/skills/stack-wagtail/`              | The skill that loads this family                           |
