---
workflow: 01-feature
phase: discovery
agent: planner
skills: [wayfinder, grill-with-docs, codebase-design, global-workflow]
model: fable
---

# Feature — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Every box must be ticked before `02-story-creation/` may begin.

---

## Entry conditions

- [ ] The feature is larger than one story — otherwise go straight to `02-story-creation`
- [ ] `.claude/skills/wayfinder/SKILL.md` read
- [ ] No stories exist for this feature yet

## Ground truth loaded

- [ ] `CONTEXT.md` → `CLAUDE.md` read from the root down to the areas in play
- [ ] The relevant `**/docs/` guides read for binding constraints
- [ ] **The whole of `project-management/src/`** read — including `IMPLEMENTATION/` records, so
      the map reflects what shipped rather than what was once intended
- [ ] The codebase explored via the `code-review-graph` playbook

## CHART

- [ ] Destination written in one or two lines and confirmed by <%DEVELOPER_NAME%>
- [ ] Out-of-scope bounds written — what is consciously ruled out, and why
- [ ] Frontier mapped **breadth-first**; no branch followed to the bottom at the expense of others
- [ ] Everything in scope but not yet sharp is in **fog of war**, not forced into a node
- [ ] Every frontier node names its blockers, or "none"
- [ ] At least one node is unblocked — a frontier with no takeable edge is mis-wired
- [ ] Every node tagged research / tracer / grilling / task
- [ ] `MAP-<FEATURE>.md` created from the template and added to the `src/01-FEATURE/` index
- [ ] Research nodes dispatched
- [ ] **Nothing else settled in the charting session**

## Facts vs decisions

- [ ] Every question answerable from the repo was **looked up**, not asked
- [ ] Only genuine trade-offs were put to <%DEVELOPER_NAME%>

## RESOLVE

- [ ] Every **blocking** node is resolved — fog and non-blocking nodes may remain open
- [ ] Each node was settled by its type (grilling / research / tracer / task)
- [ ] Every resolved node **graduated** to its real home — ADR, `GAPS.md`, `DEFERRED.md`, or a
      glossary term
- [ ] No answer lives only on the map
- [ ] The frontier was redrawn after each resolution; no resolved node still sits on it
- [ ] Fog sharpened by an outcome was promoted to a node

## Close-out

- [ ] The map reads as a low-resolution route, not a storage vault
- [ ] No story has been written — that is `02-story-creation`
- [ ] `src/01-FEATURE/CONTEXT.md` index current
- [ ] Instructional `.md` files ≤ 300 code lines
- [ ] British English throughout; dates DD/MM/YYYY
