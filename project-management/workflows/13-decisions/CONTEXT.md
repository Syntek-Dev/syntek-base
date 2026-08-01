# Workflow 13 — Decisions (ADRs)

**Last Updated**: {{DATE}}

## Purpose

Capture a significant architectural or design decision as an immutable Architecture
Decision Record (ADR) — context, options considered, the decision, and its
consequences — in the decide & plan tier, before sprint and story planning lock the
decision into an execution schedule.

## When to run

- Whenever a choice is hard to reverse — a schema shape, an auth/session strategy, a
  module boundary, a stack pattern, or anything a later ADR would need to explicitly
  supersede
- After the relevant specify-tier spec (`03-database-schema`, `09-security-checks`,
  `12-api-design`, or any other 01–12 workflow) has surfaced the trade-off
- Before `workflows/14-sprint-plans/` and `workflows/15-story-plans/` — both cite the
  ADR as a constraint on the plan they produce
- Whenever an accepted decision needs to change course — raise a **new** ADR that
  supersedes the old one; never edit an Accepted record in place

## Inputs

- The driving user story (`src/01-STORIES/US###.md`) or the spec that surfaced the
  trade-off (`src/03-DATABASE/`, `src/09-SECURITY/`, `src/12-API-DESIGN/`, etc.)
- Any grilling or `.claude/skills/research/SKILL.md` primary-source-cited note that
  grounds the decision
- The ADR this record supersedes, if any

## Outputs

- `src/13-DECISIONS/ADR-###-<TITLE>.md` — one immutable record per decision

## Key decisions

1. Whether the choice is significant enough to warrant an ADR, or is a call the
   implementer should just make
2. The next free, monotonic `ADR-###` index
3. Status — `Proposed` while under discussion, `Accepted` once signed off
4. The options considered, each with its trade-offs (including "do nothing")
5. The decision itself, and the deciding factor that beat the alternatives
6. Consequences — what improves, what the project accepts as a trade-off, and any
   follow-on enforcement work `code/` must carry out
7. Supersession — which prior ADR this replaces, if any, cross-linked both ways

## Quality gates

- Every ADR has all five sections complete: Status, Context, Options considered,
  Decision, Consequences
- The index is unique and monotonic — no reused or collided numbers
- An Accepted ADR is never rewritten in place — a change of course is a new ADR that
  marks the old one `Superseded`, with both records cross-linked
- The record links the driving `US###` and/or spec document
- Filename follows `ADR-###-<TITLE>.md` — 3-digit zero-padded index, title in
  `SCREAMING-SNAKE-CASE`

## Related workflows

| Workflow             | Relationship                                                   |
| -------------------- | -------------------------------------------------------------- |
| `03-database-schema` | Upstream — schema trade-offs often need an ADR                 |
| `09-security-checks` | Upstream — auth/session/permission strategy decisions          |
| `12-api-design`      | Upstream — contract-shaping decisions (pagination, versioning) |
| `14-sprint-plans`    | Downstream — sprint plans cite the ADRs that bound their scope |
| `15-story-plans`     | Downstream — the story plan cites the ADRs it implements under |

## Cross-references

### Hard gates — read before executing Step 1

- `project-management/src/13-DECISIONS/CLAUDE.md` — ADR authoring rules: immutability,
  monotonic indices, documentation-only scope
- `project-management/src/13-DECISIONS/ADR-000-TEMPLATE.md` — the five-section scaffold
  every ADR must fill

### Soft references — consult during execution

- `project-management/src/13-DECISIONS/` — the existing ADR register; scan it for the
  next free index and for any record this decision might supersede
- `code/docs/ARCHITECTURE-PATTERNS.md` — layered architecture and module-boundary
  conventions a decision must stay consistent with
- `.claude/skills/codebase-design/SKILL.md` — the deep-module vocabulary (module,
  interface, seam, depth, leverage, locality; the deletion test) for reasoning through
  the options
- `.claude/skills/research/SKILL.md` — a primary-source-cited note to ground a
  contested decision or stack choice (ADR groundwork)
- `project-management/workflows/14-sprint-plans/` — downstream workflow; cites this
  ADR as a planning constraint
