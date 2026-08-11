# code/src/django/templates — Project Template Directory

The project-wide template root (`TEMPLATES[0]["DIRS"]`). At baseline it holds **one** file:
the 500 page, which is the only template Django looks for without an application asking it
to. Everything else a page needs — a base template, the marketing app, components — arrives
with the first story.

**Last Updated**: <%DATE%>

## Directory Tree

```text
templates/
├── 500.html      ← the programmer-error page — no base, no CSS, no request
├── CONTEXT.md    ← this file
└── CLAUDE.md     ← operating rules
```

## Why only 500.html

Django resolves `500.html` from this directory on any unhandled exception when
`DEBUG=False`, with **no view and no URL entry** — so it is the one template that has a live
consumer before the project has any pages. Without it the user gets Django's built-in
fallback, which shows a bare "Server Error (500)" and no way to say which request broke.

The three sibling pages Django also resolves by convention — `400.html`, `403.html`,
`404.html` — are **not** here. They are user-facing outcomes rather than programmer errors,
so their copy and layout belong with the pages they sit among, and they render with a request
context that `500.html` does not have.

**There is no `503.html`.** Django defines no 503 handler and no template name for one, and
the 503 that matters is served when Django is not answering at all — which only the edge can
do. That half is a contract clause in `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`.
The application half — a `DependencyUnavailable` reaching a rendered page — has nothing
raising it yet and arrives with the first outbound adapter.

## What is not here yet

No `base.html`, no `marketing/` directory, and therefore no `#error-region` for the HTMX
handler to swap into. `code/src/scripts/development/new-django-view.sh` already requires
`templates/marketing/base.html` and refuses to run without it. The full list, and what each
item waits on, is `code/docs/FRONTEND-CODING-PRINCIPLES.md` § _What is not built yet_.

## Cross-references

- `code/docs/rendering/PITFALLS-AND-EXAMPLES.md` — why the 500 page has no base and no CSS
- `code/docs/NEGATIVE-SPACE.md` § The error taxonomy — the three classes and their statuses
- `code/src/django/apps/core/templatetags/CONTEXT.md` — `{% request_id %}`, the one tag it loads
- `code/src/django/static/CONTEXT.md` — the static tree, including the HTMX error handler
