@./CONTEXT.md

# CLAUDE.md — workflows/03-sprint-planning/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when-to-use, key concepts — imported above) → this file.

## Purpose (one line)

Produce the **high-level** sprint record — sprint goal, candidate stories, and initial
scope via MoSCoW — early in a sprint cycle, before design work begins.

## How to work here

- **Routing:** run `STEPS.md` against `CHECKLIST.md`; use `sprint`.
  **Hard gate:** read `docs/PLANNING-GUIDE.md` before writing — the MoSCoW
  format must be correct.
- **Charting an epic:** before decomposing a big, ambiguous feature/epic into candidate
  stories, load `.claude/skills/wayfinder/SKILL.md` to chart it into a decision map
  resolved across sessions.
- **Model:** Fable — scoping and prioritisation are judgement calls.
- **Concrete steps:** confirm a story backlog exists in `src/02-STORIES/` and the prior
  sprint is closing → pick candidate stories with MoSCoW (Must/Should/Could/Won't) →
  write the goal and scope as `SPRINT-##.md` in `project-management/src/03-SPRINTS/`.
- **Definition of done:** `SPRINT-##.md` records intent (goal + candidates); the
  definitive plan is deferred to `workflows/15-sprint-plans/` after the pre-sprint
  checks — do not write story assignments or phase breakdowns here.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **This record captures intent only.** Detailed story assignment, phase breakdown, and
  GDPR/security/QA constraints belong to `workflows/15-sprint-plans/` — keep the two
  distinct.
- Check candidate stories against open GDPR (`src/09-GDPR/`), security
  (`src/10-SECURITY/`), and QA (`src/11-QA/`) findings before committing scope.
- Documentation only — no code.

## Output & naming

- **Hand-written:** the sprint record and `STEPS.md`/`CHECKLIST.md` updates.
- High-level records `SPRINT-##.md` in `src/03-SPRINTS/`; detailed plans
  `SPRINT-PLAN-##.md` live under `src/15-SPRINT-PLANS/`; dates DD/MM/YYYY.
