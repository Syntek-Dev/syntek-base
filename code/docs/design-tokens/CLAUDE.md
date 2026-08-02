@./CONTEXT.md

# CLAUDE.md — code/docs/design-tokens/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The deep specification for the DB-backed design-token system — the
`DesignToken`/`DesignTokenValue` models, the six-axis preference cascade, the Django Ninja
endpoints, and the `/admin/design-tokens` editor and governance — behind the
`code/docs/DESIGN-TOKENS.md` entry point that carries the token-first law.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; the live implementation is
  `code/src/django/apps/design_tokens/` — keep this spec in step with it.
- **Model:** Opus for substantive spec work and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`MODEL.md`, `CASCADE.md`,
  `EDITOR.md`, `MOBILE.md`) → keep `DESIGN-TOKENS.md` a thin index that still states the
  token-first law → update the `CONTEXT.md` file table on any change → verify length
  with `code/src/scripts/audits/cloc.sh`.
- **Definition of done:** spec matches the shipped models, cascade, Ninja endpoints, and
  editor; each file ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- **Token-first is the law this folder governs:** design values are DB-canonical;
  they enter via the `/admin/design-tokens` editor or a migration, never as raw
  literals in component CSS, which may only consume `var(--token)`. Never document a
  workaround — the audit `code/src/scripts/audits/css-tokens.sh` enforces it. The law's
  **force** is identical on the mobile surface; only its **enforcement clause** is
  restated there (`mobile-tokens.sh`) because `var()` does not exist in React Native.
- **Never state the no-rebuild promise unqualified** — it is web-only. A token change
  reaches an installed mobile app only through a rebuild and a store release.
- Keep `MODEL.md`'s categories/flags and `CASCADE.md`'s axes exactly as implemented, and
  keep `MOBILE.md`'s axis table honest about which three collapse to BASE.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/DESIGN-TOKENS.md`;
  live app spec is `code/src/django/apps/design_tokens/CONTEXT.md`.
