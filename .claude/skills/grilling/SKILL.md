---
name: grilling
description: >-
  The grilling technique for {{PROJECT_NAME}} — a relentless, one-question-at-a-time
  Socratic interview that sharpens a plan, schema, API contract, or story before any code
  is written. Load when starting architecture, database, API, or user-flow/story design,
  when the user types /grill-me or /grill-with-docs, or when anyone asks to be grilled,
  interviewed, or stress-tested on a design. Cited by the planner, database, backend, and
  user-story agents and the design workflows.
---

# Skill: Grilling ({{PROJECT_NAME}})

Grilling is how this project interrogates a design **before** building it. It flips the
default posture in `.claude/CLAUDE.md` §10 — _make reasonable calls and proceed_ — into
_interrogate first_: the agent interviews {{DEVELOPER_NAME}} one decision at a time until the design is
sharp enough to implement without further clarification. For design work (architecture,
database, API, user flow, story) this is the opening move, not an optional extra.

This skill is the shared **engine**. Two entry points wrap it: `/grill-me` (stateless —
interview only, save nothing) and `/grill-with-docs` (stateful — interview and record
decisions as it goes). The `planner`, `database`, `backend`, and `user-story` agents load
this skill as the first step of design work; the governing workflow and `code/docs/`
guides own the _why_ behind each design decision.

Locale: {{LOCALE}} · {{TIMEZONE}} · {{CURRENCY}}.

## The one rule: predictability

A grilling session runs the **same process every time** — that is the point, not the same
output. Every rule below serves that predictability.

## How to grill

1. **One question at a time.** Ask a single question, wait for the answer, then ask the
   next. A wall of questions is bewildering and gets skimmed. Use the `AskUserQuestion`
   tool — one question per call — so {{DEVELOPER_NAME}} can click an option or type his own.
2. **Always offer your recommended answer.** Every question carries your own best answer
   as the first option, labelled `(Recommended)`, with a one-line rationale. Grilling is
   collaborative decision-making, not a blank-page interrogation.
3. **Facts you look up; decisions you ask.** If something is discoverable from the
   codebase or environment, find it yourself — never ask {{DEVELOPER_NAME}}.
   - Look up facts with the `code-review-graph` MCP first (structural context), then
     Read/Grep/Glob, then `.claude/plugins/*.py` (`project`/`db`/`env`) for project facts.
   - Do **not** ask "does a `Customer` model exist?" — check. **Do** ask "should a booking
     belong to a `Customer` or a `User`?" — that is a decision with a real trade-off.
4. **Walk the decision tree.** Settle a parent decision before the ones that depend on it;
   when an answer opens new questions, fold them in. Resolve, do not enumerate.
5. **Do not act until {{DEVELOPER_NAME}} confirms.** Grilling ends when the design is settled, not when
   you run out of questions. Summarise the resolved design and get an explicit "yes"
   before any downstream work (writing a plan, schema, endpoint, or story).

## What to grill (by design surface)

Draw questions from the surface the work touches — these mirror the planning agents' own
clarification checklists, so grilling and the agent stay in step:

- **Architecture (`planner`)** — scope (must / nice-to-have / out), roles affected,
  MVP-now vs incremental, dependencies, success criteria, non-functional limits
  (performance, security, scale), and the seams each phase is tested at.
- **Database (`database`)** — entities and their real-world meaning, relationships and
  cardinality, ownership/tenancy (RLS scope), constraints and invariants, PII fields and
  lawful basis, retention, and the expected query shapes.
- **API (`backend`)** — each Django Ninja endpoint (operation), inputs and outputs, the
  named Policy guarding every state-changing endpoint (OWASP A01), ownership checks (no IDOR), error
  shapes, and idempotency.
- **Story / user flow (`user-story`)** — the specific role, the measurable benefit, the
  happy path plus at least one edge/error case, the MoSCoW split, and dependencies.

## Anti-patterns

- Asking many questions at once, or asking questions whose answers are discoverable.
- Accepting a vague answer — restate it precisely and confirm before moving on.
- **Sycophancy** — never soften a recommendation because {{DEVELOPER_NAME}} leaned the other way; phrase
  questions neutrally and give your honest best answer (see `how-to/docs/AI-DICTIONARY.md`).
- Grilling trivia. Escalate only decisions with real scope or architectural consequence;
  make reasonable calls on minor details and note them as you go.

## Where the answers go

`/grill-me` records nothing — the sharpened design lives in the conversation and flows into
whatever the agent produces next. `/grill-with-docs` persists each decision the moment it
resolves — see that skill for exactly which artifact receives it.

## Authoritative cross-references

- `.claude/CLAUDE.md` §10 — the question-asking policy grilling overrides for design work.
- `how-to/docs/AI-DICTIONARY.md` — _grilling_, _sycophancy_, _human-in-the-loop_, _design concept_.
- `.claude/skills/grill-me/SKILL.md` · `.claude/skills/grill-with-docs/SKILL.md` — the entry points.
- `.claude/agents/planner.md`, `database.md`, `backend.md`, `user-story.md` — the agents that grill.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/01-story-creation/` — story scope and acceptance criteria
- `project-management/workflows/03-database-schema/` — schema shape
- `project-management/workflows/12-api-design/` — the API contract
- `project-management/workflows/13-decisions/` — the options behind an ADR
- `project-management/workflows/15-story-plans/` — approach and phasing
- `code/workflows/01-new-feature/` — before decomposing a feature
- `code/workflows/08-refactor/` — before restructuring
