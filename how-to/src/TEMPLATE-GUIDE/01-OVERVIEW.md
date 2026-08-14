# Overview — What syntek-base Is

**Last Updated**: 14/08/2026

Read this before generating anything. It explains the bets the template makes, so you can decide
whether they are bets you want to take.

---

## The premise

Most templates hand you a directory layout. The interesting problems — how work gets specified,
where architectural decisions are recorded, what an AI coding agent may touch, when a feature is
allowed to be called done — are left to you, and get reinvented badly on every project.

`syntek-base` inverts that. The application skeleton is thin on purpose. What the template
actually carries is:

1. **A documentation system** that an agent can navigate deterministically.
2. **A process** — numbered workflows for charting, specifying, building, reviewing and releasing.
3. **A skill set** — the Claude Code skills, scoped and routed by description. No total is
   quoted: the roster differs between two correct projects once the optional surfaces are in
   play. `.claude/skills/CONTEXT.md` is the registry.
4. **Gates** — CI, pre-commit hooks and hard documentation requirements that stop drift.

The stack is real and production-shaped, but you could swap Django out and most of the value
would survive. That is the point.

---

## The five bets

### 1. Documentation is layered, and every directory declares itself

Every directory that matters carries two files:

- **`CONTEXT.md`** — orientation. The directory tree, what lives here, what not to use it for.
- **`CLAUDE.md`** — operating rules. How to work here, guardrails, output and naming.

An agent entering any directory reads its way in from the root, and the context it loads is
scoped to the work. There is no single 5,000-line instruction file, and no guessing.

The cost: adding a directory means adding two files. This is enforced, not suggested.

### 2. Instructional documents are capped at 300 lines

Any `.md` that instructs Claude Code — `**/docs/*.md`, `**/workflows/**/*.md`, `.claude/**/*.md`,
every `CONTEXT.md` — must stay under 300 lines. Over that, it splits into a sub-directory and the
entry point becomes a thin index.

This is a context-window budget expressed as a lint rule. Guides that sprawl get skimmed, and a
skimmed guide is a guide that does not change behaviour. Operator guides for humans
(`**/src/*.md`, including everything in this directory) are exempt.

### 3. The PM layer specifies; the code layer builds

Work does not start in an editor — and it does not start with a story either. It starts with a
**feature map**: `project-management/workflows/01-feature/` charts the feature's open decisions
into `project-management/src/01-FEATURE/MAP-<FEATURE>.md` before a single story exists. Stories
are then _cut from_ the resolved map, move through the design and compliance gates (schema, user
flow, GDPR, security, QA, SEO, API contract), become a decision record and a plan, and only then
reach implementation.

```text
chart (01)  →  specify (02–13)  →  decide & plan (14–16)  →  consolidate (17)  →  implement (18–20)  →  record & ship (21–23)
```

**Charting is what the `wayfinder` skill is for.** `/wayfinder chart <feature>` draws the
frontier and deliberately settles nothing; `/wayfinder resolve <map>` then settles it a batch at
a time across later sessions, each resolved node **graduating** to the ADR, plan, story or
register entry it became. The map keeps only a link — it is an index, never a vault.
`/wayfinder suggest` mines `GAPS.md` and `DEFERRED.md` for what is worth charting next. Node
types and the grilling-versus-wayfinder split: `08-CLAUDE-CODE.md`.

The map comes first because everything from `02` to `14` is a **per-story loop**. Without one,
each story rediscovers the same cross-cutting questions — the auth model, the tenancy boundary,
where state lives — and answers them slightly differently, because each story sees only its own
slice. Charting asks them once. Stories may begin as soon as every **blocking** node is resolved;
fog of war may stay open, because a feature that must be fully known before any story is written
is a feature that never starts.

Specify through plan then runs **one story at a time** — a story goes all the way to
`14-decisions` before the next one starts, so each story is planned against everything the
previous ones established. When the open sprint fills, `15-sprint-plans` and `16-story-plans` run
for that sprint before planning resumes. Once every story is planned,
`17-consolidate-design-work` unifies the per-story design and schema work into one coherent
whole, and only then does implementation begin.

A code workflow is never entered directly from a design gate. If that sounds heavy for a
throwaway prototype, it is — use the `/prototype` skill instead, which exists precisely so the
process is not the only option.

### 4. Work routes to a skill; skills dispatch rather than freelance

Everything Claude does here is a **skill**, selected by matching your request against its
description. A task skill — `feature`, `bugfix`, `review`, `security`, `refactor`, `story`, `pr`,
`release` — routes to the matching workflow and pulls in the scoped skills each phase needs:
`backend`, `frontend`, `database`, `test-writer`, `qa-tester` and the rest, each loading only
what its remit requires.

No skill reviews its own work — review and QA are dispatched separately, into a fresh context.
Every task skill that ships code has an explicit documentation phase as a hard gate before its
commit phase.

### 5. Design gets interrogated before it gets built

Substantial work opens with a **grilling pass**: an interview in rounds, each question carrying a
recommended answer, facts looked up rather than asked, no action until you confirm. This applies to
design, code, tests, QA, refactors and migrations — not just planning. The exact shape lives in
`.claude/skills/grilling/SKILL.md` and nowhere else.

Grilling sharpens **one** surface in one sitting. When the work spans several stories, wayfinder
(bet 3) charts the frontier and dispatches grilling per node — cartographer and engine.

It is the single most opinionated thing in the template, and the one most likely to feel like
friction on day one. It exists because the expensive failure mode of agentic coding is not bad
code — it is confidently building the wrong thing.

---

## What you are also signing up for

Honest list of the costs:

- **The stack is fixed.** No React, no GraphQL, no second frontend process. Changing it is an
  ADR-level decision, and the docs argue against it in several places.
- **British English throughout.** All prose, all documentation, regardless of the application's
  configured locale.
- **Ceremony on small changes.** A one-line copy fix still passes through the documentation gate.
- **It assumes Claude Code.** The skills, hooks and settings are Claude Code specific. The
  documentation system is useful without it; the automation is not.
- **Docker for everything.** No running `python` or `pytest` on the host — every operation goes
  through a script in `code/src/scripts/`.

---

## Who this suits

**A good fit if** you run several projects that should work the same way, you use Claude Code
seriously, you have compliance obligations (UK GDPR, security review, accessibility), and you
value being able to fix something once and propagate it everywhere with `copier update`.

**A poor fit if** you want a minimal starting point, your stack differs materially, you are
building a one-off spike, or the process overhead outweighs the coordination benefit for a solo
short-lived project.

---

## Next

- The stack in detail, component by component → `02-STACK.md`
- What you need installed → `03-PREREQUISITES.md`
- Generate something → `04-QUICKSTART.md`
