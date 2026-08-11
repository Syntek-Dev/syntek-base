@./CONTEXT.md

# CLAUDE.md — code/src/django/static/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/django/CONTEXT.md` → this
folder's `CONTEXT.md` (what ships here and why a script precedes any page — imported above) →
this file → `code/docs/DESIGN-TOKENS.md`.

## Purpose (one line)

The static asset source — at baseline the one global HTMX error handler, which must be a
static file rather than an inline template block because it exists exactly once per site.

## How to work here

- **Routing:** frontend work → `stack-htmx-templates` skill (Opus), via the `frontend` agent.
  Design values → `code/docs/DESIGN-TOKENS.md` and the `/admin/design-tokens` editor.
- **Model:** Opus.
- **Concrete steps:** add the file → reference it from a template with `{% static %}` →
  verify tokens with `code/src/scripts/audits/css-tokens.sh` and formatting with
  `code/src/scripts/syntax/format.sh`.
- **Definition of done:** no raw design literal in any CSS; the `CONTEXT.md` tree updated;
  British English in every user-visible string.

## Guardrails

- **There is no client-side build.** Files here are served as written — no bundler, no
  transpiler, no module graph. Adding one is an ADR-level stack change
  (`code/docs/RENDERING.md`), never an incidental dependency.
- **The HTMX error handler stays global and stays here.** One `document.body` listener pair,
  never per element and never inline in a template: the view nobody expected to fail is the
  one that will. `audits/negative-space.sh` (`htmx-handler-absent`) checks a listener exists;
  it cannot check that it is correct, so review that part by reading.
- **A handler must never make a failure quieter.** Do not clear htmx's `isError`, do not
  swallow a swap, and never leave a path where an error produces no visible change — that is
  the defect the file was written to remove.
- **Token-first applies to every stylesheet here.** Component CSS consumes `var(--token)`
  only, and the var name must resolve in the token layer.
- **User-facing strings are placeholders until first-time setup** — `how-to/src/BRAND-VOICE.md`
  § 2, use the voice, do not invent it.

## Output & naming

- **Hand-written:** every file here.
- **Generated (never hand-edit):** the collected `staticfiles/` tree, which is build output
  and is not this directory.
- Directories `kebab-case/`; scripts and stylesheets `kebab-case` with their natural
  extension; vendored third-party files carry their version in the filename.
