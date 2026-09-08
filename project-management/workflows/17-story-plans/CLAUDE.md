@./CONTEXT.md

# CLAUDE.md — workflows/17-story-plans/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, inputs, key decisions, quality gates — imported above) → this file →
`STEPS.md` then `CHECKLIST.md`.

## Purpose (one line)

<!-- 08/09/2026: the naming convention gained an `<exec-order>-` prefix throughout this file.
     Superseded text, preserved rather than deleted: the purpose line named
     `STORY-PLAN-US###-<descriptor>.md`; the gates named "STORY-PLAN-US000-TEMPLATE.md"; the
     concrete steps read "copy "STORY-PLAN-US000-TEMPLATE.md"" and "write
     `STORY-PLAN-US###-<descriptor>.md` into `src/17-STORY-PLANS/`"; the length carve-out named
     `STORY-PLAN-US###-*.md`; Output & naming named
     `STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`. -->

<!-- 08/09/2026, later the same day: the two "Plans Index" mentions were rewritten, and a
     guardrail added. Superseded text, preserved rather than deleted — Model read "Opus for
     mechanical touches (status flips, Plans Index updates)"; Concrete steps ended "→ add its
     row to the Plans Index → satisfy `CHECKLIST.md`". Both pre-date today. Why: no Plans Index
     exists, and `src/17-STORY-PLANS/CONTEXT.md` → _The plans index_ records its absence as a
     decision — that file ships, so an index row would put a per-project citation in it. The
     job the step did is re-pointed at where a plan is indexed today: its sprint plan's
     _Story Plans — the code master_ table in `src/16-SPRINT-PLANS/`. The folder-level index is
     deferred to the register-index work charted in `src/01-FEATURE-MAPS/`; no file is named
     for it because none exists yet. -->

The final decide-&-plan workflow before code — turn a sprint-slotted, ADR-grounded story
into `<exec-order>-STORY-PLAN-US###-<descriptor>.md` in `src/17-STORY-PLANS/`: the single
master reference a developer codes from.

## How to work here

- **Routing:** run `STEPS.md` in order; drive with the `planner` skill (Fable). The hard
  gates — `src/17-STORY-PLANS/CLAUDE.md` and the canonical
  `00-STORY-PLAN-US000-TEMPLATE.md` — must be read before Step 1. Inputs: the story's sprint
  plan (`src/16-SPRINT-PLANS/`), any ADRs it rests on (`src/15-DECISIONS/`), and every
  relevant 02–14 spec.
- **Model:** Fable for the plan's substance (approach, decisions table, dependency DAG,
  test strategy, risks); Opus for mechanical touches (status flips, the story's row in its
  sprint plan's _Story Plans — the code master_ table).
- **Concrete steps:** grill <%DEVELOPER_NAME%> on scope and phasing (`.claude/skills/grill-with-docs`) →
  copy `00-STORY-PLAN-US000-TEMPLATE.md` → gather the sprint plan, ADRs, and every 02–14 spec
  in scope → fix the technical approach and key decisions → break the story into phased
  implementation tasks mapped to `19-backend-code` → `20-api-code` → `21-frontend-code` →
  define the test strategy → carry in GDPR/security/QA constraints from their source specs
  → compute `<exec-order>` (`STEPS.md` Step 2) → write
  `<exec-order>-STORY-PLAN-US###-<descriptor>.md` into `src/17-STORY-PLANS/` → point the
  story's row in its sprint plan's _Story Plans — the code master_ table
  (`src/16-SPRINT-PLANS/`) at it, replacing any reserved-number placeholder → satisfy
  `CHECKLIST.md`.
- **Definition of done:** the plan is named
  `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`, the prefix 2-digit zero-padded
  and matching the story's position in the settled backlog build order; every state-changing
  endpoint the plan introduces carries an
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
- **`<exec-order>` tracks build order, and is renumbered when build order changes.** It is
  the story's position across the whole backlog, not its sprint and not a per-sprint counter.
  **Do not read the sprint-plan guardrail across.** `src/16-SPRINT-PLANS/CLAUDE.md` holds
  that a sprint plan's prefix diverging from its `<sprint-number>` suffix is deliberate and
  must not be "corrected" — that protects a **pair** of numbers whose disagreement is the
  information. A story plan has one number and no pair, so a prefix out of step with build
  order is not information, it is a stale claim. Rule and derivation: `STEPS.md` Step 2.
- **No index row goes into `src/17-STORY-PLANS/CONTEXT.md`.** That file ships, and its
  _The plans index_ section records that it holds no index by decision. A plan is indexed
  against its sprint in the sprint plan's _Story Plans — the code master_ table, a reserved
  number is recorded in the owning story, and the folder-level index is deferred to the
  register-index work charted in `src/01-FEATURE-MAPS/`, which names its own file when it lands.
- Documentation workflow — no code here. Instructional `.md` files ≤ 300 code lines (the
  produced `<exec-order>-STORY-PLAN-US###-*.md` itself is exempt — see
  `src/17-STORY-PLANS/CLAUDE.md`).

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`; the plan
  `<exec-order>-STORY-PLAN-US###-<SCREAMING-KEBAB-DESC>.md` under `src/17-STORY-PLANS/`,
  cross-linked to its `US###`, its sprint plan (16), and the ADRs it rests on (15).
- **Template:** `00-STORY-PLAN-US000-TEMPLATE.md` — `00-` is reserved for it, mirroring
  `00-SPRINT-PLAN-00-TEMPLATE.md`, so no real plan takes that number.
- Documentation `SCREAMING-SNAKE-CASE.md`; workflow folders `NN-kebab-case/`; dates
  DD/MM/YYYY.
