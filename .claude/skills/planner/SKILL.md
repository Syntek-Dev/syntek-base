---
name: planner
description: >-
  Architect a feature for <%PROJECT_NAME%> into a phased, independently-testable implementation
  plan before any code is written — scope, system impact, technical design, interfaces, risks
  and open questions. Load when a story needs its `STORY-PLAN-US###` written, or when a design
  has to be settled ahead of backend and frontend work. Not writing the story itself (`story`),
  not slicing stories into sprints (`sprint`), not writing the code, migrations or tests
  (`backend`, `database`, `frontend`, `test-writer`), and not sizing the deployment for a user
  count (`scale-planning`).
model: fable
metadata:
  skills: codebase-design domain-modelling global-workflow grilling stack-django stack-htmx-templates
---

# Architect a Feature (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — a plan is settled by interrogating the request, and the
grilling pass that settles it is the first half of the work).

**Model.** `model: fable` above applies to the turn that loads this skill and is not a
guarantee. The durable carrier for the planning tier is the `model: fable` routing frontmatter
on `project-management/workflows/16-story-plans/`.

You architect **within the existing stack** — never introduce a technology outside it. The plan
is the contract every later phase reads, and it lands before any implementation phase starts.

---

## Open with a grilling pass

A plan is expensive to get wrong, so this inverts the proceed-by-default posture: interrogate
first, look facts up rather than asking, and take no action until <%DEVELOPER_NAME%> confirms.
The `grilling` skill owns the round shape and the question format (`.claude/CLAUDE.md` Section 10).

What must be settled: **scope** (core, nice-to-have, explicitly out), **roles affected** (for
access control), **phasing** (MVP now or incremental), **dependencies**, **success criteria**,
and the **non-functional** constraints. Where the feature adds a route, an upload, an SSE
surface or a user-owned table, scale-readiness is a grill dimension too — statelessness, keyset
pagination, `tenant_id`, async-safe I/O, against
`code/docs/architecture/CORE-AND-SCALING.md`. **Hand sizing to `scale-planning`; never size in
the plan.**

Resolved answers go into the plan's `Requirements` and `Open Questions`. A large, ambiguous epic
is charted with the `wayfinder` skill first; an open design question worth one throwaway answer
goes to `prototype`; a stack choice needing primary sources goes to `research`.

## Planning process

1. **Requirements** — separate core from nice-to-have; list and validate every assumption.
2. **System impact** — existing code affected, new files/apps/routes, schema changes, effect on
   other features. A new Django app or marketing page is a scripted step
   (`code/src/scripts/development/new-django-app.sh`,
   `code/src/scripts/development/new-django-view.sh`) — flag it, never plan a manual one.
3. **Technical design** — independent, testable phases; defined interfaces; reusable code
   identified (check the existing django-components before proposing a new one); error handling
   and edge cases designed. Reason about **depth** here rather than at refactor time — the
   `codebase-design` vocabulary is what that reasoning is written in, and a new concept the
   design settles is recorded via `domain-modelling` in the nearest `CONTEXT.md`.
4. **Risk analysis** — unknowns to investigate, performance concerns, security implications.

Before Grep/Glob/Read for impact analysis, run the code-review-graph **explore playbook**
(`.claude/skills/explore-codebase.md`; guide `code/docs/CODE-REVIEW-GRAPH.md`) — structural
context, faster and token-cheaper. Read the `CONTEXT.md` of every directory the plan touches
before committing it to a phase.

## What the plan must carry

- **Every state-changing endpoint the plan introduces names its permission check and its
  ownership verification, per endpoint.** Downstream phases inherit this from the plan.
- **An infrastructure dependency names its interface and its verdict** — protocol seam, adapter
  seam, or substrate — and gains its row in `how-to/src/PLATFORM-PROVIDERS.md`. Apply the
  substrate test (does swapping change application code, or only configuration?) rather than
  defaulting to "swappable"; an adapter seam with one implementation is declared hypothetical,
  never claimed as neutral (`code/docs/architecture/PROVIDER-NEUTRALITY.md`).
- **A phase that would breach the 750-line source limit plans its split** rather than meeting it
  later.
- **Behaviour and interfaces, not file paths or line numbers** — those go stale the moment code
  moves. The sole exception is a decision-encoding snippet (a state machine, schema, or type
  shape) that pins a decision down more precisely than prose can.
- New environment variables documented against the `.env.*.example` templates — never a real
  secret value.

## Output

`project-management/src/16-STORY-PLANS/`, from
`STORY-PLAN-US000-TEMPLATE.md`. That template is the shape of record and is not restated here;
the naming convention is `project-management/src/CONTEXT.md`'s. Each phase must be
independently testable, sized for a focused session, with inter-phase dependencies explicit and
no premature detail that locks in a decision the implementer should own.

## Definition of done

Scope agreed and out-of-scope stated; every phase independently testable with a named
deliverable; permission and ownership checks stated per endpoint; risks tabled with mitigations;
open questions listed rather than guessed; British English, DD/MM/YYYY, <%CURRENCY%>.

## Handoff

Report the plan's path and the phases it defines, then name what each later dispatch owns —
`test-writer` for the failing tests per phase, `database` for the migration, `backend` for
models, services and endpoints, `frontend` for components and templates, and `scale-planning`
where the feature shifts a per-surface load curve. This skill plans; it does not sequence them.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/16-story-plans/` — **the procedure of record for this skill**
- `project-management/workflows/15-sprint-plans/` — the sprint sequencing a plan sits inside
- `code/workflows/01-new-feature/` — the build procedure the plan is written against

## Cross-references

- `code/docs/ARCHITECTURE-PATTERNS.md` — the service layer and module boundaries
- `code/docs/API-DESIGN.md` · `code/docs/DATA-STRUCTURES.md` — endpoint and schema conventions
- `code/docs/SECURITY.md` — the permission and IDOR controls a plan must honour
- `code/docs/architecture/CORE-AND-SCALING.md` — the phase-gate invariants a plan must not break
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore playbook used for impact analysis
- `code/docs/NEGATIVE-SPACE.md` — the invariants and error taxonomy a plan must design against
