@./CONTEXT.md

# CLAUDE.md — workflows/17-story-plans/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, inputs, key decisions, quality gates — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

The final decide-&-plan workflow before code — turn a sprint-slotted, ADR-grounded story
into `STORY-PLAN-US###-<descriptor>.md` in `src/17-STORY-PLANS/`: the single master
reference a developer codes from.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `planner` skill (Fable). The hard
  gates — `src/17-STORY-PLANS/CLAUDE.md` and the canonical
  `STORY-PLAN-US000-TEMPLATE.md` — must be read before Step 1. Inputs: the story's sprint
  plan (`src/16-SPRINT-PLANS/`), any ADRs it rests on (`src/15-DECISIONS/`), and every
  relevant 02–14 spec.
- **Model:** Fable for the plan's substance (approach, decisions table, dependency DAG,
  test strategy, risks); Opus for mechanical touches (status flips, Plans Index updates).
- **Concrete steps:** grill <%DEVELOPER_NAME%> on scope and phasing (`.claude/skills/grill-with-docs`) →
  copy `STORY-PLAN-US000-TEMPLATE.md` → gather the sprint plan, ADRs, and every 02–14 spec
  in scope → fix the technical approach and key decisions → break the story into phased
  implementation tasks mapped to `19-backend-code` → `20-api-code` → `21-frontend-code` →
  define the test strategy → carry in GDPR/security/QA constraints from their source specs
  → write `STORY-PLAN-US###-<descriptor>.md` into `src/17-STORY-PLANS/` → add its row to
  the Plans Index → satisfy `CHECKLIST.md`.
- **Definition of done:** every state-changing endpoint the plan introduces carries an
  explicit permission check and ownership verification (OWASP A01, no IDOR); the GDPR,
  security and QA constraints from the `02`–`13` specs are present and traced back to their
  source; a test strategy is defined per layer; the `Blocked by` / `Blocks` /
  `Can be done now` callout is accurate, because the parallel-worktree DAG depends on it;
  and one adversarial pass has looked for missing layers, wrong references and
  dependency-order errors. The plan is then what a developer codes from, and it unlocks
  `workflows/19-backend-code/`.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`skills`/`model` frontmatter — read it first (see
  `.claude/CLAUDE.md` Section 2.5).

## Guardrails

- **A story is not codeable until this plan exists** — `19-backend-code` reads this plan,
  not the raw story or sprint plan.
- **Every mutation the plan introduces carries an explicit permission check and ownership
  verification** — no IDOR, no implicit allow (OWASP A01).
- **GDPR, security, and QA constraints are carried in from the 02–14 specs, not
  re-derived** — keep them consistent with `code/docs/SECURITY.md` and
  `project-management/docs/GDPR-GUIDE.md`.
- **Keep the dependency callout honest** — a plan marked anything other than `Blocked`
  asserts its blockers are cleared; the parallel-worktree DAG depends on it.
- Documentation workflow — no code here. Instructional `.md` files ≤ 300 code lines (the
  produced `STORY-PLAN-US###-*.md` itself is exempt — see `src/17-STORY-PLANS/CLAUDE.md`).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the plan
  `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` under `src/17-STORY-PLANS/`, cross-linked
  to its `US###`, its sprint plan (16), and the ADRs it rests on (15).
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
