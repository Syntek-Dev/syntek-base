# Workflow 15 — Decisions (ADRs)

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

**The coherence gate on a story's decision record.** Confirm every ADR this story raised
still holds true and that none clashes with another, author the records the loop surfaced
but nobody wrote, and hand the settled set to sprint and story planning.

**An ADR is written where the trade-off appears, not here.** Steps `04`–`14` each author
their own — a schema shape or RLS scope at `04-database-schema`, a session strategy at
`10-security-checks`, a contract shape at `13-api-design`. By the time the loop reaches this
gate most of the story's ADRs already exist, and the job is to check them against each other
rather than to write them from scratch. **This is the last gate in the per-story loop.**

## When to run

- **Once per story**, after `14-logging-checks` and before `16-sprint-plans` /
  `17-story-plans` — both cite the settled ADR set as a constraint on the plan they produce
- When a decision surfaced mid-loop was never recorded — this gate writes it
- When two of the story's ADRs disagree — raise a **new** ADR superseding the loser; never
  edit an Accepted record in place
- Whenever an accepted decision needs to change course, for the same reason

## Inputs

- The driving user story (`src/02-STORIES/US###.md`) — **mandatory**; a trade-off must
  come from somewhere real, which is why a wayfinder map reaches an ADR only through the
  slice that becomes a story
- **Every ADR already written for this story** by steps `04`–`14`
- The specs that surfaced them (`src/04-DATABASE/`, `src/10-SECURITY/`, `src/13-API-DESIGN/`, etc.)
- Any grilling or `.claude/skills/research/SKILL.md` primary-source-cited note that
  grounds a decision

## Outputs

- `src/15-DECISIONS/ADR-US###-<DECISION>-DD-MM-YYYY.md` — one immutable record per
  decision, flat, named for the driving story and the date it was made
- A confirmed, internally consistent ADR set for the story — the gate's actual product

## Key decisions

1. Whether every hard-to-reverse choice this story made is recorded, or one is missing
2. Whether any two of the story's ADRs contradict each other — and which loses
3. Whether a choice is significant enough to warrant an ADR, or is a call the
   implementer should just make
4. Status — `Proposed` while under discussion, `Accepted` once signed off
5. The options considered, each with its trade-offs (including "do nothing")
6. The decision itself, and the deciding factor that beat the alternatives
7. Consequences — what improves, what the project accepts as a trade-off, and any
   follow-on enforcement work `code/` must carry out
8. Supersession — which prior ADR this replaces, if any, cross-linked both ways

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
  the naming convention, the driving-`US###` rule, documentation-only scope
- `project-management/src/15-DECISIONS/ADR-US000-TEMPLATE.md` — the five-section scaffold
  every ADR must fill

### Related reading

- `project-management/src/15-DECISIONS/` — the existing ADR register; `ls` it by `US###`
  prefix for this story's set, and for any record a decision might supersede
- `code/docs/ARCHITECTURE-PATTERNS.md` — layered architecture and module-boundary
  conventions a decision must stay consistent with
- `.claude/skills/codebase-design/SKILL.md` — the deep-module vocabulary (module,
  interface, seam, depth, leverage, locality; the deletion test) for reasoning through
  the options
- `.claude/skills/research/SKILL.md` — a primary-source-cited note to ground a
  contested decision or stack choice (ADR groundwork)
- `project-management/workflows/16-sprint-plans/` — downstream workflow; cites this
  ADR as a planning constraint
