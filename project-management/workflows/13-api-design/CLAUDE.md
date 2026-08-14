@./CONTEXT.md

# CLAUDE.md — workflows/13-api-design/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, inputs, key decisions, quality gates — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The design-stage API workflow — design the Django Ninja API contract (Schema
request/response models, endpoints, permission matrix) for a story after the schema is
signed off and before sprint planning, producing `API-US###-<descriptor>.md` in
`src/13-API-DESIGN/`.

## How to work here

- **Routing:** run `STEPS.md` in order; the two hard gates —
  `code/docs/api-design/NINJA-CONVENTIONS.md` and
  `code/docs/security/AUTH-AND-AUTHZ.md` — must be read before Step 1. Inputs: approved
  story, signed-off schema (`src/04-DATABASE/`), wireframes, and the threat model
  (`src/10-SECURITY/`) for permission rules.
- **Model:** Fable for contract design; Opus for mechanical touches (status
  flips, moving a file).
- **Skills:** load `.claude/skills/research/SKILL.md` when a contract decision needs a
  primary-source-cited note to ground an ADR/PLAN or stack choice (ADR groundwork).
- **Concrete steps:** read the two hard-gate guides → define Schema request/response
  models and enums, endpoint signatures (router modules, HTTP methods), the permission
  matrix, ownership enforcement, error strategy, and pagination pattern → write
  `API-US###-<descriptor>.md` into
  `src/13-API-DESIGN/` → have it reviewed by one other team member → satisfy
  `CHECKLIST.md`.
- **Definition of done:** every state-changing endpoint carries a documented explicit
  permission check; every user-supplied ID has ownership verification noted; no operation
  is left with an open `*` permission; the design has had a second pair of eyes before
  sprint planning. The signed-off doc is then the single source of truth for
  `workflows/19-api-code/`, and feeds estimates into `workflows/15-sprint-plans/`.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **Every state-changing endpoint must carry a documented, explicit permission check;
  user-supplied IDs must have ownership verification noted (IDOR prevention).**
- **No operation may be left with an open `*` permission** — the permission matrix
  must be complete before sign-off.
- Design must be convention-compliant (`NINJA-CONVENTIONS.md`) and reviewed by at least
  one other team member before sprint planning.
- Documentation workflow — no code here. Instructional `.md` files ≤ 300 code lines.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the design doc
  `API-US###-<descriptor>.md` under `src/13-API-DESIGN/`, linked to its `US###`.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
