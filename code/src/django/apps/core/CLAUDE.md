@./CONTEXT.md

# CLAUDE.md — apps/core/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is here, what is documented but unshipped — imported above) → this file →
`services/CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The shared primitives every domain app imports — the Ninja schema bases and the
service-layer exception trees — and nothing that belongs to a domain.

## How to work here

- **Routing:** backend work → `stack-django` skill (Opus). A change here is a
  **cross-cutting** change: every app inherits it, so it opens with a grilling pass
  (`.claude/skills/grill-with-docs`) rather than a direct edit.
- **Model:** Opus.
- **Concrete steps:** confirm the thing is genuinely project-wide (below) → add the module →
  update this folder's `CONTEXT.md` table → lint and type-check via
  `code/src/scripts/syntax/*.sh`.
- **Definition of done:** the module is imported by at least two apps, or is a base class
  the doctrine names; `CONTEXT.md` updated; British English.

## Guardrails

- **`core` owns no domain concepts.** If a name would mean something to a customer, it
  belongs in a domain app. The test: could a second, unrelated project use this module
  unchanged? If not, it is not core.
- **`InvariantViolation` and `DependencyUnavailable` never become `ServiceError`
  subclasses**, and no shared base is introduced over the three. One broad
  `except ServiceError` would turn a broken invariant into a friendly 400
  (`code/docs/NEGATIVE-SPACE.md`).
- **`schemas.py` is the only module in the project permitted to import `ninja.Schema`** —
  ruff `TID251` enforces it, and `pyproject.toml` exempts this one path. Request bodies
  subclass `Schema`; responses `OutSchema` or `ninja.ModelSchema`; `Query(...)` containers
  `QuerySchema`. **Never give `QuerySchema` `extra="forbid"`** — Ninja passes the whole
  query string to Pydantic, so it would 422 on `?utm_source=…`.
- **A module documented in `code/docs/` is not thereby owed now.** Add it when the node or
  story that decides its rule lands; the outstanding list is in `CONTEXT.md`.
- No models here without a decision recorded first — adding one creates `models/` and
  `migrations/` and makes `core` a migration dependency of everything.
- Files ≤ 750 lines (800 grace); every new sub-package gets a `CONTEXT.md` + `CLAUDE.md`.

## Output & naming

- **Hand-written:** every `.py` here.
- **Generated (never hand-edit):** nothing yet — no migrations exist.
- Modules `snake_case.py`; the app is registered as `apps.core`; documentation
  `SCREAMING-SNAKE-CASE.md`.
