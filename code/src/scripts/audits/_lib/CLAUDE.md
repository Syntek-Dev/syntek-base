@./CONTEXT.md

# CLAUDE.md — audits/\_lib/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the file inventory and why it is not the shared library — imported above) → this file →
`../CLAUDE.md` for the rules every audit obeys.

## Purpose (one line)

Sourced splits of a single audit's clauses, kept beside the audit that owns them.

## How to work here

- **Routing:** a change to a clause here is a change to its caller's audit — read the caller's
  header and `../CLAUDE.md` first. A helper with a second caller moves to
  `code/src/scripts/_lib/` instead.
- **Model:** Opus — this is audit control flow.
- **Concrete steps:** edit the file → run the caller's `--self-test` and its unscoped run →
  `shellcheck` the caller and the file together.
- **Definition of done:** the caller's `--self-test` passes, its unscoped run is unchanged, and
  `CONTEXT.md` here lists the file with its caller.

## Guardrails

- **Sourced, never executed** — functions and constants only; nothing runs on `source`.
- **Scopes stay in the caller.** A file here reads the caller's scope variables and never
  declares one, so `--self-test` repoints the whole set in one place.
- Moving a clause here moves its self-test assertions with it where they can move cleanly, so
  the clause and its proof are read together.

## Output & naming

- **Hand-written:** the `*.sh` files only.
- Named `<caller>-<concern>.sh`, `kebab-case`, so the caller is legible from the file name.
