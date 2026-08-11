@./CONTEXT.md

# CLAUDE.md — code/docs/accessibility/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the WCAG 2.2 AA accessibility standard — semantic HTML and
ARIA, keyboard/focus interaction, and django-component patterns/testing — behind the
`code/docs/ACCESSIBILITY.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; `frontend` is the consumer that reads the
  web sub-docs before building any interactive component (Django template,
  django-component, or HTMX partial). `MOBILE.md` is read by `mobile` instead —
  mobile-only, absent on a web-only project.
- **Model:** Opus for substantive guidance and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`HTML-AND-ARIA.md`,
  `INTERACTION.md`, `TESTING-AND-COMPONENTS.md`, `MOBILE.md`) → keep the parent
  `ACCESSIBILITY.md` a thin index and update the `CONTEXT.md` file table if a file is
  added, renamed, or removed → check length with `code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** guidance is testable against WCAG 2.2 AA; each file ≤ 300
  lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split further rather than overflow.
- Keep each file single-topic; don't let `TESTING-AND-COMPONENTS.md` absorb
  raw ARIA reference that belongs in `HTML-AND-ARIA.md`, and don't let React Native
  technique leak out of `MOBILE.md` into the web sub-docs.
- Guidance must stay WCAG 2.2 AA-accurate — no advice that would fail an audit.
  **The standard itself is never scoped by surface** — only the techniques are.
- Examples must match the surface. On the **web** surface: Django templates +
  django-components + HTMX + Alpine, and no client-framework examples, because there is
  no client framework. In `MOBILE.md`: React Native only — it documents a separate
  deployable, not a client framework for the Django pages.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/ACCESSIBILITY.md`.
