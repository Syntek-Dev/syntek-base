@./CONTEXT.md

# CLAUDE.md — apps/core/templatetags/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what the tag decides, and the empty-context row that earns it — imported above) → this
file → `code/docs/NEGATIVE-SPACE.md`.

## Purpose (one line)

The template tags shared by every app — at present one, exposing the request-correlation
identifier to templates that have no context to carry it.

## How to work here

- **Routing:** backend work → `stack-django` skill (Opus); the templates that consume these
  tags → `stack-htmx-templates`. A tag here is loadable by every template in the project, so
  adding one opens with a grilling pass (`.claude/skills/grill-with-docs`).
- **Model:** Opus.
- **Concrete steps:** add the tag to `core.py` → add its row to the table in `CONTEXT.md` →
  lint and type-check via `code/src/scripts/syntax/*.sh`.
- **Definition of done:** the tag works in a context-free render as well as an ordinary one;
  `CONTEXT.md` updated; British English.

## Guardrails

- **A tag here must not require a request context.** That is the entire reason this package
  exists rather than a context processor; one that reads `context["request"]` re-introduces
  the failure it was built to avoid and belongs in a context processor instead.
- **Never widen `{% request_id %}` into a general correlation API.** It reads one
  `ContextVar` and returns a string. Formatting, linking to a tracker, or falling back to a
  timestamp are all decisions that belong to the guide, not to the tag.
- **This module raises no keyed `InvariantViolation`.** It reads a value that is legitimately
  empty; a key raised here with no row in `how-to/src/INVARIANTS.md` fails
  `audits/negative-space.sh` (`key-unregistered`).
- **The library name is load-bearing.** Templates carry `{% load core %}`; renaming the module
  breaks every error page silently at render time rather than at import time.
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** `core.py`.
- **Generated:** none.
- Modules `snake_case.py`, named for the library a template loads; tags `snake_case`.
