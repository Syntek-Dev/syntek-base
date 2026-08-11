@./CONTEXT.md

# CLAUDE.md — apps/core/services/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the two exception trees and how each surfaces — imported above) → this file.

## Purpose (one line)

The service-layer primitives shared across apps — at baseline, the exception bases that
decide how every failure in this codebase is classified.

## How to work here

- **Routing:** `stack-django` skill (Opus). Any change to the exception classes is a change
  to the error taxonomy, so it goes through `code/docs/NEGATIVE-SPACE.md` first — the guide
  is the rule, this module is its expression.
- **Model:** Opus.
- **Concrete steps:** amend `errors.py` → update the table in `CONTEXT.md` → lint and
  type-check via `code/src/scripts/syntax/*.sh`.
- **Definition of done:** the class hierarchy still matches `NEGATIVE-SPACE.md`'s table;
  `CONTEXT.md` updated; British English.

## Guardrails

- **Never make `InvariantViolation` or `DependencyUnavailable` inherit `ServiceError`**, and
  never introduce a common base over all three. The API layer catches `ServiceError`
  broadly; putting the other two inside that catch converts a 500 into a friendly 4xx and
  loses the tracker event.
- **`InvariantViolation` always takes its register key first** —
  `InvariantViolation("order.total_matches_lines", …)`. A raise without a key breaks the
  link between the tracker and `how-to/src/INVARIANTS.md`.
- **`DependencyUnavailable` is raised in the adapter, never in a service method.** Only the
  adapter knows which of a provider SDK's exceptions mean "the network"
  (`code/docs/architecture/PROVIDER-NEUTRALITY.md`).
- Retry, backoff and circuit-breaker behaviour is **not** decided here — that is
  `code/docs/TASK-AUTHORING.md` and `architecture/SERVICE-AND-MIDDLEWARE.md`.
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** `errors.py`.
- Exception classes `PascalCase`, ending in the failure they name; `code` is a
  `SCREAMING_SNAKE_CASE` string on the `ServiceError` tree only.
