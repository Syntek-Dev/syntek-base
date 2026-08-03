@./CONTEXT.md

# CLAUDE.md — workflows/08-wireframes/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file.

## Purpose (one line)

Create and sign off wireframes — layout and interaction, not final visual design —
before any new page, screen, or significant component is built.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`. **Hard gate:**
  `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA considered at layout stage; interactive
  states required from the start. Feeds GDPR (08), security (09), and QA (10).
- **Model:** Fable — layout and interaction design is substantive.
- **Concrete steps:** confirm a driving `US###` and its acceptance criteria → wireframe
  the agreed user flow (`src/05-USER-FLOW/`) starting at 360 px portrait and scaling up →
  **check the django-components library before specifying any new element and reuse where possible** →
  define every interactive state (default, hover, focus, error, empty) → save to
  `project-management/src/08-WIREFRAMES/`.
- **Prototype spike:** to answer one open design question — a state model or what a
  screen should look like — before committing to a real build, load
  `.claude/skills/prototype/SKILL.md` for a throwaway spike.
- **Definition of done:** wireframes implement the agreed flow, every interactive
  element has defined states, accessibility considered, checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Reuse before specifying new UI** — confirm the element is not already in
  the django-components library (`code/src/django/components/`) before drawing it.
- Wireframes represent **layout and interaction only** — visual polish is brand and
  component work; they drive component structure in `code/src/django/components/`.
- Mobile-first at 360 px portrait scaling up (`code/docs/responsive/BREAKPOINTS.md`);
  navigation follows `code/docs/URL-STRATEGY.md`; page structure choices affect the
  server/HTMX/Alpine split (`TEMPLATES-AND-INTERACTIVITY.md`) and Core Web Vitals
  (`FRONTEND-PERFORMANCE.md`).
- Documentation and design only — no code.

## Output & naming

- **Hand-written:** wireframe files in `src/08-WIREFRAMES/`; `STEPS.md`/`CHECKLIST.md`
  updates.
- Wireframes `WF-<US###>-*` / `WF-<SCREEN>-*` across the 13 breakpoints; documentation
  `SCREAMING-SNAKE-CASE.md`; dates DD/MM/YYYY.
