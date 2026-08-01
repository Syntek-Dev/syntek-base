@./CONTEXT.md

# CLAUDE.md — code/docs/accessibility/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the WCAG 2.2 AA accessibility standard — semantic HTML and
ARIA, keyboard/focus interaction, and django-component patterns/testing — behind the
`code/docs/ACCESSIBILITY.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; `frontend`
  is the consumer that reads these before building any interactive component (Django
  template, django-component, or HTMX partial).
- **Model:** Opus for substantive guidance and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`HTML-AND-ARIA.md`,
  `INTERACTION.md`, `TESTING-AND-COMPONENTS.md`) → keep the parent
  `ACCESSIBILITY.md` a thin index and update the `CONTEXT.md` file table if a file is
  added, renamed, or removed → check length with `code/src/scripts/audits/cloc.sh`.
- **Definition of done:** guidance is testable against WCAG 2.2 AA; each file ≤ 300
  lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split further rather than overflow.
- Keep the three files single-topic; don't let `TESTING-AND-COMPONENTS.md` absorb
  raw ARIA reference that belongs in `HTML-AND-ARIA.md`.
- Guidance must stay WCAG 2.2 AA-accurate — no advice that would fail an audit.
- Examples must match the stack: Django templates + django-components + HTMX + Alpine
  throughout. No client-framework examples — there is no client framework.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/ACCESSIBILITY.md`.
