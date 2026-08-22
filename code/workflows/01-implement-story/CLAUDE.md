@./CONTEXT.md

# CLAUDE.md — workflows/01-implement-story/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when to use, key concepts — imported above) → this file.

## Purpose (one line)

The procedure for adding a new capability that spans both the Django backend and the
server-rendered Django templates + django-components + HTMX + Alpine frontend, from a
user story through to a review-ready branch.

## How to work here

- **Routing:** execute via `STEPS.md`; backend work through the `stack-django`
  skill, frontend through `stack-htmx-templates`
  — both Opus. Business logic goes in Django **services**, not endpoints; Ninja Schema
  models in `apps/<app>/schemas.py`, endpoints in `apps/<app>/api.py`.
- **Design-first tooling (before you decompose):** chart a large, ambiguous
  feature/epic into a cross-session decision map with
  `.claude/skills/wayfinder/SKILL.md` before decomposing it; answer one open design
  question with a throwaway spike via `.claude/skills/prototype/SKILL.md` before
  committing to a real build; ground an ADR/PLAN or stack choice in a
  primary-source-cited note with `.claude/skills/research/SKILL.md`.
- **Model:** Opus to author the feature or revise these steps and
  mechanical edits to the workflow files.
- **Concrete steps:** confirm the prerequisites (story exists, `us###/…` branch,
  `GAPS.md` clear, containers up) → read the four hard-gate docs → implement backend
  then frontend → commit the OpenAPI schema after any Ninja Schema
  change → tests to the coverage floor via `code/src/scripts/tests/*.sh` →
  `CHECKLIST.md` before handing to `project-management/workflows/22-implementation-documentation/`
  (records, findings, docs, graph refresh — the hard gate before commit), which then hands to
  `23-pr-and-review/`.
- **Definition of done:** every item in `CHECKLIST.md` ticked; coverage floors met;
  docs hard-gate satisfied before commit.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Hard gates bite here:** every new state-changing Django Ninja endpoint carries an
  explicit permission check and verifies user IDs against caller ownership (no IDOR);
  any PII field is encrypted before commit; WCAG 2.2 AA on every interactive component;
  coverage floors block the PR.
- **Reuse before build:** check the the django-components library catalogue
  (`code/src/django/components/`) before creating any frontend component.
- Never invoke `pnpm`, `pytest`, `python`, or `docker` directly — only the
  shell scripts.

## Output & naming

- **Hand-written:** these workflow files; the feature source they drive lives under
  `code/src/django/`.
- **Generated (never hand-edit):** the OpenAPI schema Ninja publishes at `/api/docs`.
- Branch `us###/feature-name`; workflow files `SCREAMING-SNAKE-CASE.md`.
