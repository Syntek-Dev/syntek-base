---
name: grilling
description: >-
  The grilling technique for <%PROJECT_NAME%> — a relentless Socratic interview, asked in
  frontier rounds, that sharpens a plan, schema, API contract, or story before any code is
  written. Load when starting architecture, database, API, or user-flow/story design, when
  the user types /grill-me or /grill-with-docs, or when anyone asks to be grilled,
  interviewed, or stress-tested on a design. Cited by the planner, database, backend and
  story skills and the design workflows.
---

# Skill: Grilling (<%PROJECT_NAME%>)

Grilling is how this project interrogates a design **before** building it. It flips the
default posture in `.claude/CLAUDE.md` Section 10 — _make reasonable calls and proceed_ — into
_interrogate first_: Claude interviews <%DEVELOPER_NAME%> until the design is sharp
enough to implement without further clarification. For design work (architecture, database,
API, user flow, story) this is the opening move, not an optional extra.

This skill is the shared **engine**, and it owns the interview's shape. Two entry points wrap
it: `/grill-me` (stateless — interview only, save nothing) and `/grill-with-docs` (stateful —
interview and record decisions as it goes). The `planner`, `database`, `backend` and
`story` skills load this skill as the first step of design work.

> **Everything else routes here and never restates the shape.** A workflow or skill
> that opens a grilling pass names its **subject matter** — what must be settled — and leaves
> the round mechanics, the question format and the recommendation rule to this file. A
> restatement drifts the moment this file changes; that has already happened once in this
> repository.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## The one rule: predictability

A grilling session runs the **same process every time** — that is the point, not the same
output. Every rule below serves that predictability.

## How to grill

### 1. Map the design as a decision tree

Decisions hang off other decisions. Before asking anything, work out which ones are
**unblocked** — everything they rest on is already settled — and which are still waiting on
an answer you have not heard yet. The unblocked set is the **frontier**.

### 2. Ask the whole frontier in one round

Put the entire frontier in a single message, numbered. Then **stop and wait**. Two failure
modes to avoid:

- **Trickling** — one question per message. It turns a ten-decision design into ten exchanges.
- **Front-loading** — including a question that is still blocked by another one in the same
  round. Its answer would be a guess. Hold it for the next round.

### 3. Let the answers redraw the tree

Each round's answers settle decisions, which pushes the frontier outward and unblocks
questions that were previously unanswerable. Recompute the frontier and ask the next round.

### 4. Stop when the frontier is empty

Every branch visited, nothing silently assumed. Summarise the settled design and get an
explicit "yes" before any downstream work (writing a plan, schema, endpoint, or story).
**Do not act on a design <%DEVELOPER_NAME%> has not confirmed.**

## Question format — exact

Ask in the chat as prose. **Never the `AskUserQuestion` tool** — it is denied in
`.claude/settings.json`, because a multiple-choice widget makes the interview stilted and
grilling depends on <%DEVELOPER_NAME%> answering, countering, or redirecting freely.

Every question is numbered, titled, and carries brief options and a recommendation:

```text
**Q1 — <question title>**

<one line of context, only if the title is not self-explanatory>

1. **<Option title>** — <explanation, one line>
2. **<Option title>** — <explanation, one line>
3. **<Option title>** — <explanation, one line>

➡️ **Claude recommends 2** — <the reason, one line>
```

Rules for the format:

- **Options are brief.** One line each. If an option needs a paragraph, it is two options.
- **Two to four options.** One is not a question; five means the question is unscoped.
- **Always recommend, always justify.** Name the option number and the reason in one line.
  Grilling is collaborative decision-making, not a blank-page interrogation.
- **Open-ended is allowed** where options would be invented — drop the list, keep the title
  and the recommendation.
- <%DEVELOPER_NAME%> answers by number, or overrides freely. Both are normal.

## Facts you look up; decisions you ask

If something is discoverable from the codebase or environment, **find it yourself** — never
ask <%DEVELOPER_NAME%> for it.

- Look up facts with the `code-review-graph` MCP first (structural context), then
  Read/Grep/Glob, then `.claude/plugins/*.py` (`project`/`db`/`env`) for project facts.
- Dispatch a sub-agent for anything wider than a couple of lookups.
- Do **not** ask "does a `Customer` model exist?" — check. **Do** ask "should a booking
  belong to a `Customer` or a `User`?" — that is a decision with a real trade-off.

**Never block a round on a lookup.** Treat a lookup still in flight exactly as you treat an
unanswered question: it blocks whatever depends on it and nothing else. Send the rest of the
round immediately.

## What to grill (by design surface)

Draw questions from the surface the work touches — these mirror the planning skills' own
remits, so grilling and the skill stay in step:

- **Architecture (`planner`)** — scope (must / nice-to-have / out), roles affected,
  MVP-now vs incremental, dependencies, success criteria, non-functional limits
  (performance, security, scale), and the seams each phase is tested at.
- **Database (`database`)** — entities and their real-world meaning, relationships and
  cardinality, ownership/tenancy (RLS scope), constraints and invariants, PII fields and
  lawful basis, retention, and the expected query shapes.
- **API (`backend`)** — each Django Ninja endpoint (operation), inputs and outputs, the
  named Policy guarding every state-changing endpoint (OWASP A01), ownership checks (no
  IDOR), error shapes, and idempotency.
- **Story / user flow (`story`)** — the specific role, the measurable benefit, the
  happy path plus at least one edge/error case, the MoSCoW split, and dependencies.

## Anti-patterns

- **Trickling and front-loading** — the two round failures in step 2.
- Asking questions whose answers are discoverable.
- Accepting a vague answer — restate it precisely and confirm before moving on.
- **Sycophancy** — never soften a recommendation because <%DEVELOPER_NAME%> leaned the other
  way; phrase questions neutrally and give your honest best answer (see
  `how-to/docs/AI-DICTIONARY.md`).
- Grilling trivia. Escalate only decisions with real scope or architectural consequence;
  make reasonable calls on minor details and note them as you go.
- Essay-length options. The format is a scan, not a briefing (`.claude/CLAUDE.md` Section 1).

## Where the answers go

`/grill-me` records nothing — the sharpened design lives in the conversation and flows into
whatever the skill produces next. `/grill-with-docs` persists each decision the moment it
resolves — see that skill for exactly which artefact receives it.

## Authoritative cross-references

- `.claude/CLAUDE.md` Section 10 — the question-asking policy grilling overrides for design work.
- `.claude/CLAUDE.md` Section 1 — the concision standard the question format obeys.
- `how-to/docs/AI-DICTIONARY.md` — _grilling_, _sycophancy_, _human-in-the-loop_, _design concept_.
- `.claude/skills/grill-me/SKILL.md` · `.claude/skills/grill-with-docs/SKILL.md` — the entry points.
- `.claude/skills/{planner,database,backend,story}/SKILL.md` — the skills that grill.
- `THIRD-PARTY-NOTICES.md` — the frontier-round method derives from `mattpocock/skills` (MIT);
  the wording here is our own.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/02-story-creation/` — story scope and acceptance criteria
- `project-management/workflows/04-database-schema/` — schema shape
- `project-management/workflows/13-api-design/` — the API contract
- `project-management/workflows/15-decisions/` — the options behind an ADR
- `project-management/workflows/17-story-plans/` — approach and phasing
- `code/workflows/01-implement-story/` — before decomposing a feature
- `code/workflows/11-refactor/` — before restructuring
