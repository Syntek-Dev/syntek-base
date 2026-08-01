@./CONTEXT.md

# CLAUDE.md — code/docs/rendering/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc index, imported above) → this file.

## Purpose (one line)

The rendering-strategy sub-documents behind `code/docs/RENDERING.md` — the Django-template /
HTMX / Alpine decision and the common HTMX/Alpine pitfalls with worked examples.

## How to work here

- **Routing:** documentation, not code — `doc-writer` agent, and this guidance governs
  `stack-htmx-templates` work.
  Opus for substantive edits; Opus for mechanical touches.
- **Concrete steps:** edit the relevant sub-doc → keep `code/docs/RENDERING.md` a thin index and
  the interaction-model doctrine authoritative → every example must be runnable against the
  current Django templates + HTMX + Alpine stack. Any dev command in an example invokes a
  `code/src/scripts/**/*.sh` script, never raw `python` or `docker`.
- **Definition of done:** guidance matches the shipped template/HTMX patterns; each file
  ≤ 300 code lines; British English.

## Guardrails

- **300-line instructional limit** — these are `**/docs/*.md`; split and demote the
  parent to an index if a file exceeds it.
- Examples that render UI must consume `var(--token)` only — never a raw colour or
  size literal, keeping the token-first rule intact even in illustrative CSS.
- **Three tiers only** — server, HTMX, Alpine. Never document a fourth (a client
  framework, a bundler, a client router); that is an ADR-level stack change, not a
  rendering pattern.
- Examples must keep secrets server-side and rely on the session cookie for auth —
  never an embedded key in markup or a static script.

## Output & naming

- **Hand-written:** every `.md` in this folder. Nothing is generated.
- `SCREAMING-SNAKE-CASE.md` filenames; parent guide is `code/docs/RENDERING.md`.
  </content>
