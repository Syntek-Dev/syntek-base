@./CONTEXT.md

# CLAUDE.md — apps/core/management/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what `base.py` decides, and why there is no `commands/` package — imported above) →
this file → `code/docs/MANAGEMENT-COMMANDS.md`.

## Purpose (one line)

The base class every management command subclasses, mapping the three error classes onto
the exit codes and output a CLI surface has instead of an HTTP status.

## How to work here

- **Routing:** backend work → `stack-django` skill (Opus). A change here changes how
  **every** command in the project fails, so it opens with a grilling pass
  (`.claude/skills/grill-with-docs`) and goes through `code/docs/MANAGEMENT-COMMANDS.md`
  first — the guide is the rule, this module is its expression.
- **Model:** Opus.
- **Concrete steps:** amend `base.py` → update the table in `CONTEXT.md` and the matching
  one in the guide → lint via `code/src/scripts/syntax/lint.sh`.
- **Definition of done:** the mapping still matches `MANAGEMENT-COMMANDS.md`; the ruff
  `TID251` exemption in `pyproject.toml` still covers this path and nothing else;
  British English.

## Guardrails

- **`base.py` is the only module in the project permitted to import Django's
  `BaseCommand`** — ruff `TID251` bans both `django.core.management.base.BaseCommand` and
  the `django.core.management.BaseCommand` re-export, and `pyproject.toml` exempts this one
  path. Adding a second exemption defeats the mechanism.
- **Never catch `InvariantViolation` here.** A programmer error reaches the operator as a
  traceback and the tracker as an event. Handling it to tidy the output is the
  friendly-4xx failure wearing a different surface.
- **Never invent an exit code per class.** One code carries meaning — `EXIT_TEMPFAIL`,
  because a scheduler acts on it. Everything else keeps Django's exit 1; a vocabulary
  nothing reads is a vocabulary that goes wrong silently.
- **No `commands/` package here.** `core` owns no domain, so it has no command to write.
  A command lives in the app whose data it touches.
- **This module raises no keyed `InvariantViolation`.** It classifies failures; it does not
  guard an invariant. A key raised here with no row in `how-to/src/INVARIANTS.md` fails
  `audits/negative-space.sh` (`key-unregistered`).
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** `base.py`.
- **Generated:** none.
- Modules `snake_case.py`; the class is `ManagementCommand`; the exit constant is
  `SCREAMING_SNAKE_CASE`.
