@./CONTEXT.md

# CLAUDE.md — code/src/mobile/lib/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is here and why only these two ship — imported above) → this file →
`code/docs/MOBILE-CODING-PRINCIPLES.md`.

## Purpose (one line)

The app's non-route modules — at baseline, the mobile expression of the error taxonomy: the
programmer-error type and the classifier over it.

## How to work here

- **Routing:** `stack-react-native` skill (Opus). A change to the error classes is a change to
  the taxonomy every surface shares, so it opens with a grilling pass
  (`.claude/skills/grill-with-docs`) rather than a direct edit.
- **Model:** Opus.
- **Concrete steps:** add the module → add its test under `../__tests__/` → typecheck and lint
  through `code/src/scripts/mobile/*.sh`.
- **Definition of done:** every union is exhausted through `unreachable()`; the module is
  imported by something; tests pass; British English.

## Guardrails

- **`InvariantViolation` keeps its name across surfaces.** The backend raises the same class
  name and the project's invariant register carries one breach column for both; renaming
  either half breaks the correspondence the register depends on.
- **`unreachable()` is never called `assertNever`.** `assert` is the banned mechanism — this
  raises a keyed error rather than asserting one, and the name has to say so.
- **A programmer error is never shown to a user.** It reaches the tracker; the user gets the
  generic surface.
- **Never run `expo`, `npx`, `pnpm` or `jest` directly** — use `code/src/scripts/mobile/*.sh`.
- **Nothing here imports from `../app/`.** Dependency runs one way — routes consume modules.
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** every `.ts` module here.
- **Generated:** none.
- Modules `kebab-case.ts`; exported classes `PascalCase`; the register key a keyed error
  quotes is `lower.dotted.case`, matching the row it names.
