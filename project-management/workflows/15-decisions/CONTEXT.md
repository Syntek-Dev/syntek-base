# Workflow 14 — Decisions (ADRs)

**Last Updated**: <%DATE%>

An unrecorded decision gets re-litigated every time someone new meets it. An ADR is immutable
so the reasoning survives the change of mind, and supersession is visible rather than silent.

## Directory Tree

```text
project-management/workflows/15-decisions/
├── CHECKLIST.md   ← verification checklist before marking complete
├── CLAUDE.md      ← operating rules
├── CONTEXT.md     ← this file (when to use, key concepts, governing documents)
└── STEPS.md       ← ordered steps to execute
```

## Purpose

Capture a significant architectural or design decision as an immutable Architecture
Decision Record (ADR) — context, options considered, the decision, and its
consequences — in the decide & plan tier, before sprint and story planning lock the
decision into an execution schedule.

## When to run

- Whenever a choice is hard to reverse — a schema shape, an auth/session strategy, a
  module boundary, a stack pattern, or anything a later ADR would need to explicitly
  supersede
- After the relevant specify-tier spec (`04-database-schema`, `10-security-checks`,
  `13-api-design`, or any other 02–14 workflow) has surfaced the trade-off
- Before `workflows/16-sprint-plans/` and `workflows/17-story-plans/` — both cite the
  ADR as a constraint on the plan they produce
- Whenever an accepted decision needs to change course — raise a **new** ADR that
  supersedes the old one; never edit an Accepted record in place

## Inputs

- The driving user story (`src/02-STORIES/US###.md`) or the spec that surfaced the
  trade-off (`src/04-DATABASE/`, `src/10-SECURITY/`, `src/13-API-DESIGN/`, etc.)
- Any grilling or `.claude/skills/research/SKILL.md` primary-source-cited note that
  grounds the decision
- The ADR this record supersedes, if any

## Outputs

- `src/15-DECISIONS/ADR-###-<TITLE>.md` — one immutable record per decision

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

## Related workflows

| Workflow             | Relationship                                                   |
| -------------------- | -------------------------------------------------------------- |
| `04-database-schema` | Upstream — schema trade-offs often need an ADR                 |
| `10-security-checks` | Upstream — auth/session/permission strategy decisions          |
| `13-api-design`      | Upstream — contract-shaping decisions (pagination, versioning) |
| `16-sprint-plans`    | Downstream — sprint plans cite the ADRs that bound their scope |
| `17-story-plans`     | Downstream — the story plan cites the ADRs it implements under |

## Cross-references

### Governing documents

- `project-management/src/15-DECISIONS/CLAUDE.md` — ADR authoring rules: immutability,
  monotonic indices, documentation-only scope
- `project-management/src/15-DECISIONS/ADR-000-TEMPLATE.md` — the five-section scaffold
  every ADR must fill

### Related reading

- `project-management/src/15-DECISIONS/` — the existing ADR register; scan it for the
  next free index and for any record this decision might supersede
- `code/docs/ARCHITECTURE-PATTERNS.md` — layered architecture and module-boundary
  conventions a decision must stay consistent with
- `.claude/skills/codebase-design/SKILL.md` — the deep-module vocabulary (module,
  interface, seam, depth, leverage, locality; the deletion test) for reasoning through
  the options
- `.claude/skills/research/SKILL.md` — a primary-source-cited note to ground a
  contested decision or stack choice (ADR groundwork)
- `project-management/workflows/16-sprint-plans/` — downstream workflow; cites this
  ADR as a planning constraint
