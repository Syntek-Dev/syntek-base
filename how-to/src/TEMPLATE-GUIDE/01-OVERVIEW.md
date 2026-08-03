# Overview — What syntek-base Is

**Last Updated**: 02/08/2026

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
2. **A process** — numbered workflows for specifying, building, reviewing and releasing.
3. **An agent configuration** — the Claude Code agents and skills, tool-scoped and routed. No
   total is quoted: the roster differs between two correct projects once the mobile surface is
   optional. `.claude/agents/CONTEXT.md` and `.claude/skills/CONTEXT.md` are the registries.
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

Work does not start in an editor. It starts as a user story, moves through design and compliance
gates (schema, user flow, GDPR, security, QA, SEO, API contract), becomes a decision record and a
plan, and only then reaches implementation.

```text
specify (02–13)  →  decide & plan (14–16)  →  consolidate (16)  →  implement (18–20)  →  record (21–23)
```

Specify through plan runs **one story at a time** — a story goes all the way to `14-decisions`
before the next one starts, so each story is planned against everything the previous ones
established. When the open sprint fills, `14` and `15` run for that sprint before planning
resumes. Once every story is planned, `16` unifies the per-story design and schema work into one
coherent whole, and only then does implementation begin.

A code workflow is never entered directly from a design gate. If that sounds heavy for a
throwaway prototype, it is — use the `/prototype` skill instead, which exists precisely so the
process is not the only option.

### 4. Agents delegate; they do not freelance

Eight orchestrators (`feature`, `bugfix`, `review`, `security`, `refactor`, `story`, `pr`,
`release`) are the entry points. They route to the matching workflow and delegate scoped work to
specialists — `backend`, `frontend`, `database`, `gdpr`, `test-writer`, `qa-tester` and the rest —
each of which is tool-scoped and loads only the skills its remit needs.

No agent reviews its own work. Every orchestrator has an explicit documentation phase as a hard
gate before its commit phase.

### 5. Design gets interrogated before it gets built

Substantial work opens with a **grilling pass**: a one-question-at-a-time interview, each question
carrying a recommended answer, facts looked up rather than asked, no action until you confirm.
This applies to design, code, tests, QA, refactors and migrations — not just planning.

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
- **It assumes Claude Code.** The agents, skills, hooks and settings are Claude Code specific. The
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
