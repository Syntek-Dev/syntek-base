---
type: guide
skills: [stack-wagtail]
model: opus
---

# Wagtail — Pages and StreamField

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

> **CMS-only.** This guide exists only in a project generated with `INCLUDE_WAGTAIL`.

Authoring content types: the page models an editor fills in, the blocks they compose out of, the
rich text inside them, and the data migrations that keep all three honest. Nothing here ships at
baseline. The install order and version floor are `code/docs/wagtail/FUNDAMENTALS.md`; the three
settled integration decisions are `code/docs/WAGTAIL.md`.

## A page type is a Django model

A page type subclasses `wagtail.models.Page` and is otherwise an ordinary Django model: your own
fields, your own managers, Django's multi-table inheritance giving it a table of its own alongside
its row in `wagtailcore_page`
([topics/pages.html#writing-page-models](https://docs.wagtail.org/en/stable/topics/pages.html#writing-page-models),
[reference/models.html](https://docs.wagtail.org/en/stable/reference/models.html)).

Four consequences follow, and none of them is optional:

- **It needs a migration like any other model.** Adding a field to a page type is a schema change
  — generated and applied through `code/src/scripts/database/migrate.sh`, never a raw
  `manage.py`, and lock-safe per `code/docs/DATABASE.md`.
- **`content_panels` is the editor form, not the model.** The panel list orders the edit view and
  nothing else
  ([reference/panels.html](https://docs.wagtail.org/en/stable/reference/panels.html),
  [customising the editing interface](https://docs.wagtail.org/en/stable/advanced_topics/customization/page_editing_interface.html)).
- **Invariants are enforced in the database.** A `clean()` on the page form is a courtesy to the
  editor; the constraint that makes the rule true lives where `code/docs/NEGATIVE-SPACE.md` says it
  does. `max_count` and `max_count_per_parent` bind the Wagtail admin only — a singleton that
  matters is a database constraint as well.
- **Page fields carrying personal data follow the same pipeline as everything else** —
  `code/docs/ENCRYPTION-GUIDE.md` and `project-management/docs/gdpr/DATA-RIGHTS.md`. The CMS is not
  a PII exemption.

### Constraining the tree

`parent_page_types` and `subpage_types` take lists of model classes or `app_label.ModelName`
strings and decide where in the tree a type may be created; an empty `parent_page_types` blocks
creation in the editor entirely
([parent page / subpage type rules](https://docs.wagtail.org/en/stable/topics/pages.html#parent-page-subpage-type-rules)).
Set both on every type you add — the default is "anything under anything", which is how a site
ends up with three home pages. The tree's shape is also its URL shape, so read
[reference/pages/theory.html](https://docs.wagtail.org/en/stable/reference/pages/theory.html) for
how a request resolves to a node.

**The Wagtail catch-all route is always last, and never at `/admin/`** — the rule and its reasoning
are `code/docs/WAGTAIL.md`, the route register is `code/docs/URL-STRATEGY.md`. A path served both
by a Django view and by a page is a precedence bug waiting for a reorder.

### Templates and context

Wagtail resolves a page template by convention: `<app_label>/<model_name snake_cased>.html`,
overridable with a `template` attribute or a `get_template()` method, with `get_context()` adding
variables and `serve()` available when you need the whole response
([template rendering](https://docs.wagtail.org/en/stable/topics/pages.html#template-rendering),
[customising template context](https://docs.wagtail.org/en/stable/topics/pages.html#customizing-template-context),
[writing templates](https://docs.wagtail.org/en/stable/topics/writing_templates.html)).

- **The template is an ordinary project template.** Same conventions, same component library, same
  CSS rules: `code/docs/FRONTEND-CODING-PRINCIPLES.md`. Where an interaction runs — server, HTMX or
  Alpine — is decided by `code/docs/RENDERING.md`, unchanged by the page being CMS-backed.
- **`ajax_template` is not an HTMX hook.** It fires on `X-Requested-With: XMLHttpRequest`; HTMX
  identifies itself with `HX-Request`. An HTMX partial swap belongs in `get_template()` reading
  that header, or in a normal Django view.
- **Listings in `get_context()` use the page QuerySet API** —
  [queryset reference](https://docs.wagtail.org/en/stable/reference/pages/queryset_reference.html)
  — and `.live()`, `.child_of()`, `.specific()` and `.defer_streamfields()` are the difference
  between one query and one per row. Budgets: `code/docs/PERFORMANCE.md`.
- **The head is not Wagtail's.** Per-page metadata and structured data go through the project's own
  pipeline: `code/docs/DISCOVERABILITY.md` and `project-management/docs/SEO-CHECKLIST.md`.

## StreamField and blocks

`StreamField` holds an ordered sequence of typed blocks in a single JSON column, letting an editor
compose a page body instead of filling in a fixed form
([topics/streamfield.html](https://docs.wagtail.org/en/stable/topics/streamfield.html)). The block
library and every block's options are the
[block reference](https://docs.wagtail.org/en/stable/reference/streamfield/blocks.html);
`StructBlock`, `ListBlock` and `StreamBlock` are the
[structural types](https://docs.wagtail.org/en/stable/reference/streamfield/blocks.html#structural-block-types)
you build real content types out of.

- **`StructBlock`** groups named children into one composite value — the shape a component's props
  would have ([StructBlock](https://docs.wagtail.org/en/stable/topics/streamfield.html#structblock)).
  Subclass it rather than declaring it inline once it has a template or is used twice.
- **`StreamBlock`** nests a stream inside a block and can cap how many of each child are allowed
  ([StreamBlock](https://docs.wagtail.org/en/stable/topics/streamfield.html#streamblock)).
- **A custom block** is a subclass with a `class Meta` carrying its `template`, `icon` and label.
- **Each block renders through its own template**, with the value bound as `value`
  ([per-block templates](https://docs.wagtail.org/en/stable/topics/streamfield.html#per-block-templates)).
  Use `{% include_block %}` rather than `{{ value }}` for anything rendering HTML: the short form
  does not pass `request` or `page` down.
- **A block using `ImageBlock` inherits the image decisions.** The custom image model exists before
  the first upload, and Cloudinary is the storage beneath Wagtail's own rendition pipeline, never a
  replacement for it — both are settled in `code/docs/WAGTAIL.md`, with the mechanics in
  `code/docs/wagtail/IMAGES-AND-MEDIA.md`.

### A block template is a template, not a second component system

State it plainly, because the mistake is easy and expensive: **StreamField is a content model.** It
decides what an editor may say, not how the site is built. A block template is a Django template
like any other — it consumes `var(--token)` per `code/docs/DESIGN-TOKENS.md`, never a raw literal,
and it may include a django-component rather than reimplementing one
(`code/docs/FRONTEND-CODING-PRINCIPLES.md`). A block that grows its own private CSS vocabulary has
forked the design system.

Accessibility is sharper here than on a fixed page, because the editor chooses the order: heading
levels stay sequential whatever sequence of blocks is placed (`code/docs/ACCESSIBILITY.md`).

## Dict discipline — where the line falls

Serialised StreamField data is JSON by design. That is the **documented exception** in
`code/docs/data-structures/TYPES-EXCEPTIONS.md`, not a hole in
`code/docs/data-structures/TYPES-OVER-DICTIONARIES.md`, and the boundary is exact:

| Surface                                               | Position                                                  |
| ----------------------------------------------------- | --------------------------------------------------------- |
| Block **definitions**                                 | Classes with named children — typed, and stay typed       |
| The **value** in a template (`value.heading`)         | Wagtail's own block values; use them, do not re-wrap them |
| **Raw serialised data** in a migration or an exporter | A dictionary by design — mark it and confine it           |

Python touching the raw form carries the marker in its documented shape —
`# DICT-OK: serialised StreamField block data — confined to this migration` — with the reason and
the boundary both mandatory. Never widen the exception by passing raw block dictionaries into a
service: parse at the edge, exactly as the standard requires everywhere else.

## Rich text

Two forms, one behaviour: `RichTextField` for a whole model field, `RichTextBlock` for rich text
inside a stream
([RichTextBlock](https://docs.wagtail.org/en/stable/reference/streamfield/blocks.html#wagtail.blocks.RichTextBlock)).
Upstream has **no single rich-text topic page** — the material is split across four places, so the
prose below carries what a page model author needs and links only fragments that resolve.

- **Stored HTML is Wagtail's own dialect**, with internal links and embeds held as placeholder
  elements. A `RichTextField` must be rendered through the
  [`richtext` filter](https://docs.wagtail.org/en/stable/topics/writing_templates.html#rich-text-filter)
  to become real HTML; a `RichTextBlock` value renders itself.
- **The `features` whitelist is the content contract.** Passing `features=[...]` to the field or
  the block limits what the editor can produce at all
  ([limiting features](https://docs.wagtail.org/en/stable/advanced_topics/customization/page_editing_interface.html#limiting-features-in-a-rich-text-field),
  [rich text](https://docs.wagtail.org/en/stable/advanced_topics/customization/page_editing_interface.html#rich-text-html)).
  Whitelist the smallest set the design needs — body copy that cannot emit an `h1` cannot break the
  heading order.
- **That whitelist is the allowlist, not a sanitiser you may bypass.** Never mark editor-supplied
  HTML safe by hand; the untrusted-input rules are `code/docs/security/INPUT-AND-API.md`.
- **Extending the editor is a deeper change** —
  [rich text internals](https://docs.wagtail.org/en/stable/extending/rich_text_internals.html) and
  [extending Draftail](https://docs.wagtail.org/en/stable/extending/extending_draftail.html). A new
  feature means new stored markup, so it is a content decision, not a toolbar tweak.

## Snippets — when a page is the wrong answer

Snippets are reusable models outside the page tree, registered with `register_snippet` and given
panels like a page
([topics/snippets/index.html](https://docs.wagtail.org/en/stable/topics/snippets/index.html),
[registering](https://docs.wagtail.org/en/stable/topics/snippets/registering.html)). They can opt
into previews, revisions, drafts, locking and workflow
([optional features](https://docs.wagtail.org/en/stable/topics/snippets/features.html)), and are
rendered by the templates that reference them
([rendering](https://docs.wagtail.org/en/stable/topics/snippets/rendering.html)).

**Choose a snippet** when the content has no URL of its own and is reused across pages — a footer
call to action, an office address, an author record. **Choose a page** when it needs a URL, a
metadata head, or a position in the navigation. Upstream's own advice is to decide deliberately,
because a snippet that grows a URL is a page you now have to migrate.

## StreamField data migrations — the separate hazard

The column is JSON, so **`makemigrations` sees nothing when block structure changes**. Renaming a
block is a schema no-op and a data catastrophe: the old data keeps the old key and stops rendering
([StreamField migrations](https://docs.wagtail.org/en/stable/advanced_topics/streamfield_migrations.html)).

- **Write the data migration deliberately.** `wagtail.blocks.migrations` supplies operations for
  rename, remove and altering block values, saving the hand-rolled `RunPython` recursion
  ([data migrations](https://docs.wagtail.org/en/stable/advanced_topics/streamfield_migrations.html#streamfield-data-migrations)).
- **Published rows are not the whole population.** Drafts and `wagtailcore.Revision.content` hold
  the same JSON; upstream's own worked example migrates both. A migration touching only live pages
  leaves every revision on the old shape, which surfaces the day someone reverts.
- **Expand then contract, as everywhere else.** Add the new block, backfill, and remove the old one
  in a later release — `code/docs/DATABASE.md`, and beyond a `development` posture the
  expand-then-contract rule in `.claude/CLAUDE.md` Section 0 binds this migration too.
- **A revision is not an audit record.** Wagtail's `PageLogEntry` and `Revision` describe content
  history for editors and never satisfy the project's audit obligation
  (`code/docs/security/AUDIT-TRAIL.md`, decision in `code/docs/WAGTAIL.md`).

## Where next

| Question                                      | Guide                                        |
| --------------------------------------------- | -------------------------------------------- |
| What Wagtail is, install order, version floor | `code/docs/wagtail/FUNDAMENTALS.md`          |
| Images, documents, renditions, storage        | `code/docs/wagtail/IMAGES-AND-MEDIA.md`      |
| Who may edit and publish what                 | `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md` |
| Form pages, redirects, sitemaps, settings     | `code/docs/wagtail/CONTRIB-SURFACES.md`      |
| Serving this content over an API, and search  | `code/docs/wagtail/API-AND-SEARCH.md`        |
