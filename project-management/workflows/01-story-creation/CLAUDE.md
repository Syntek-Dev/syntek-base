@./CONTEXT.md

# CLAUDE.md — workflows/01-story-creation/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, prerequisites, key concepts — imported above) → this file.

## Purpose (one line)

The first PM gate — write a well-formed `US###` user story with clear acceptance
criteria before any design or code begins; every feature starts here.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`; use `user-story`
  for the drafting. Story creation is pre-code — no hard safety gates apply.
- **Charting a big epic first:** when the input is a large, ambiguous epic rather than
  one story, chart its decision frontier with `.claude/skills/wayfinder/SKILL.md` (a
  decision map resolved across sessions) before decomposing it into `US###` stories.
- **Model:** Fable — acceptance criteria drive downstream tests, GDPR, security, and
  SEO scope, so they are substantive, not mechanical.
- **Concrete steps:** confirm role/goal/criteria are understood → draft the story in
  the Connextra format → surface GDPR, security, and SEO acceptance criteria per the
  `docs/` guides → save as `US###.md` in `project-management/src/01-STORIES/`.
- **Definition of done:** story named `US###.md`, acceptance criteria testable and
  complete enough to seed `code/workflows/02-tdd-cycle/`, checklist satisfied.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Acceptance criteria must be testable** — they become the QA scenarios
  (`docs/QA-GUIDE.md`) and the TDD cases; vague criteria block the story.
- Stories that touch personal data must capture the GDPR requirement
  (`docs/GDPR-GUIDE.md`); public-facing pages must carry SEO criteria
  (`docs/SEO-CHECKLIST.md`); security-relevant behaviour must be named
  (`docs/SECURITY-GUIDE.md`).
- This is documentation only — no code, secrets, or `.env` content.

## Output & naming

- **Hand-written:** the story file and any updates to `STEPS.md`/`CHECKLIST.md`.
- Stories `US###.md` — three-digit zero-padded (`US001.md`); template at
  `src/01-STORIES/US000-TEMPLATE.md`; dates DD/MM/YYYY.
