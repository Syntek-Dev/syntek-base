@./CONTEXT.md

# CLAUDE.md — code/src/django/templates/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/django/CONTEXT.md` → this
folder's `CONTEXT.md` (why only the 500 page ships, and what is absent — imported above) →
this file → `code/docs/RENDERING.md`.

## Purpose (one line)

The project-wide template root — at baseline the 500 page alone, because it is the only
template Django resolves without an application asking it to.

## How to work here

- **Routing:** template work → `stack-htmx-templates` skill (Opus), via the `frontend` agent.
  A new page route is scaffolded by `code/src/scripts/development/new-django-view.sh` —
  never hand-created.
- **Model:** Opus.
- **Concrete steps:** read `code/docs/RENDERING.md` for where the interaction belongs
  (server, HTMX, or Alpine) → write the template → styles consume `var(--token)` only →
  verify with `code/src/scripts/audits/css-tokens.sh`.
- **Definition of done:** every value a token; WCAG 2.2 AA satisfied
  (`code/docs/ACCESSIBILITY.md`); the `CONTEXT.md` tree updated; British English.

## Guardrails

- **`500.html` extends nothing, loads no stylesheet, and names no internals.** Django renders
  it with an empty `Context` and no request, so an inherited base silently renders blanks —
  the failure this doctrine exists to close. The reasoning is in the file's own header
  comment; read it before editing.
- **The identifier reaches the page through `{% request_id %}`, never a context processor.**
  A context processor cannot run without a `RequestContext`, and the 500 page has none.
- **Copy here is a placeholder until first-time setup.** `how-to/src/BRAND-VOICE.md` § 2 —
  use the voice, do not invent it. Rewriting the placeholder against § 3 is a setup step, not
  a licence to improvise a tone mid-story.
- **Never add `503.html` here.** Django defines no handler for it; the page that matters is
  served by the edge when this process is not answering
  (`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`).
- **No client-side build.** Templates are served as written — no bundler, no JSX, no
  compilation step (`code/src/CLAUDE.md`).

## Output & naming

- **Hand-written:** every `.html` here.
- **Generated:** none.
- Templates `snake_case.html`; Django's conventional error pages keep their numeric names;
  per-app templates live under a directory named for the app.
