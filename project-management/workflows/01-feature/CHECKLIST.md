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
- [ ] The feature is either <%DEVELOPER_NAME%>'s, or came from a Step 0 candidate <%DEVELOPER_NAME%> picked

## Ground truth loaded

- [ ] Root `CONTEXT.md` → _What this project is_ read, and it is a real brief rather than the
      raw generation-time answer
- [ ] `how-to/src/SCALE-ARCHITECTURE/` read — the size the project is designed for, and what it
      therefore does **not** need
- [ ] `CONTEXT.md` → `CLAUDE.md` read from the root down to the areas in play
- [ ] The relevant `**/docs/` guides read for binding constraints
- [ ] **`GAPS.md` and `DEFERRED.md`** read — every open entry, with the records behind it
- [ ] **The whole of `project-management/src/`** read — including `IMPLEMENTATION/` records, so
      the map reflects what shipped rather than what was once intended
- [ ] The codebase explored via the `code-review-graph` playbook

## SUGGEST — only if Step 0 was run

- [ ] Every open `GAPS.md` entry and unshipped `DEFERRED.md` row was read, not just skimmed
- [ ] Candidates clustered by shared cause, surface, or dependency — not one per entry
- [ ] Anything that is really a single story was routed to `02-story-creation`, not inflated
- [ ] Candidates put to <%DEVELOPER_NAME%> ranked, each naming what it closes and what stays open if skipped
- [ ] **Nothing written** — no map, no edit to the register

## Register triage

- [ ] Every open register entry carries one verdict: **closes** / **blocks** / **unrelated**
- [ ] Entries this feature **closes** are on the map under **Register claimed**
- [ ] Entries that **block** this feature are frontier nodes, typed and wired — not assumptions
- [ ] What the feature closes is reflected in the **destination**, not left as a footnote
- [ ] **`GAPS.md` and `DEFERRED.md` were not edited** — claiming is not closing; the close belongs
      to `21-implementation-documentation`, against shipped code

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
- [ ] An outcome that retired a further register entry added a **Register claimed** row; one that
      raised a new blocker was appended to `GAPS.md`

## Close-out

- [ ] The map reads as a low-resolution route, not a storage vault
- [ ] Every claimed register entry names the node or story that will retire it
- [ ] No story has been written — that is `02-story-creation`
- [ ] `src/01-FEATURE/CONTEXT.md` index current
- [ ] Instructional `.md` files ≤ 300 code lines — `bash code/src/scripts/audits/docs-length.sh`
- [ ] British English throughout; dates DD/MM/YYYY
