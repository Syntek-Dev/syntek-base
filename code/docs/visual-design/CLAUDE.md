@./CONTEXT.md

# CLAUDE.md — code/docs/visual-design/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The per-surface expression of the visual-design doctrine — the signature made concrete, the
component vocabulary, and, where the surface has one, the pre-ship checklist (`WEB.md`) — behind
the `code/docs/VISUAL-DESIGN.md` entry point, which keeps the cross-surface core.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; `frontend` is the consumer that reads `WEB.md`
  before building any page or component. A `MOBILE.md` is read by the mobile stack skill and a
  `DESKTOP.md` by the desktop one — each absent unless the project opted into that surface.
- **Model:** Opus for substantive guidance and for typos or re-indexing.
- **Concrete steps:** edit the relevant surface sub-doc → keep `VISUAL-DESIGN.md` the index and
  update the `CONTEXT.md` file table if a file is added, renamed, or removed → add the matching
  `_exclude` entry to `copier.yml` for any new surface file → check length with <!-- doc-references: template-only -->
  `code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** every clause is traceable to a Section 3 axis or is explicitly
  direction-independent; each file ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **The direction is committed once, in the parent guide's Section 3 — never here.** A project is not
  `editorial` on the web and something else on mobile. These files hold the _expression_ of one
  direction, never a second commitment.
- **Never restate the ban list here.** Section 4.1 and Section 4.2 live in the parent. A surface sub-doc may add
  a surface-specific clause, but it names the axis it reads, and a universal tell always goes to
  Section 4.1 so it is stated once.
- Every clause written in the default `editorial` direction carries a note naming its axis, so a
  project on different settings knows what to restate rather than having to infer it.
- **300-line instructional limit** per file — split further rather than overflow.
- Examples must match the surface. In `WEB.md`: Django templates + django-components + HTMX +
  Alpine, no client-framework examples, because there is no client framework. A `MOBILE.md` is
  React Native only; a `DESKTOP.md` is Slint only.
- WCAG 2.2 AA, the token-first law, the focus ring and the reduced-motion contract are **never**
  scoped by direction or surface — a sub-doc may not weaken them.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`, named for the surface; parent guide is
  `code/docs/VISUAL-DESIGN.md`.
