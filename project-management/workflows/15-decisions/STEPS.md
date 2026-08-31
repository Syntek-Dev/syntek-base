---
workflow: 15-decisions
phase: design
skills: [planner, codebase-design]
model: fable
---

# Decisions (ADRs) — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                     |
| --------- | --------------------------------------------------------------------------- |
| All steps | **Internal — Live Artefacts** → src/15-DECISIONS/                           |
| All steps | src/15-DECISIONS/CLAUDE.md — immutability, naming, the driving-`US###` rule |
| Template  | src/15-DECISIONS/ADR-US000-TEMPLATE.md — the five-section scaffold to copy  |

---

## Prerequisites

- [ ] A driving user story (`src/02-STORIES/US###.md`) exists — the trade-off must come
      from somewhere real, not be invented in the abstract. **A wayfinder map is not a
      driver**; its decisions reach an ADR through the slice that becomes a story
- [ ] Steps `02`–`14` have run for this story, so the ADRs they authored exist to be checked
- [ ] `src/15-DECISIONS/` has been listed by `US###` prefix — this story's set, plus any
      record a decision here might supersede

---

## Steps

### Step 1 — Gather the story's ADRs

`ls src/15-DECISIONS/ADR-US###-*` for the driving story. These were written by steps
`04`–`14` as each surfaced its trade-off; this gate does not re-author them. Read every
one, and note which PM step raised it.

### Step 2 — Check each record still holds

A decision made at `04-database-schema` was made before `10-security-checks` and
`13-api-design` ran. For each ADR, re-read its **Context** against what the later steps
decided: does the problem it states still exist, and are its constraints still true? An ADR
whose premise has since been falsified is **superseded**, never edited: an edited record hides
that the reasoning moved, and the next reader re-litigates it.

### Step 3 — Check no two clash

Compare the set pairwise on what each **Decision** section commits the story to. A clash is
the finding this gate exists to make: two records that cannot both be implemented, or whose
consequences contradict. Where one is found, decide which loses and raise a new ADR
superseding it at Step 9 — never reconcile by editing an Accepted record.

### Step 4 — Grill the gaps, then confirm each is ADR-worthy

Some decisions get made in a story without anyone writing them down. **Grill first**
(`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and interview
<%DEVELOPER_NAME%> — what forces were at play, what options were realistically on the table,
what happens if we do nothing, and who owns the call. Not every choice needs an ADR: reserve
it for a decision hard to reverse, or that a later decision would need to explicitly
supersede. A call the implementer should just make does not belong here — say so and move on.

### Step 5 — Copy the template for each record this gate writes

Copy `src/15-DECISIONS/ADR-US000-TEMPLATE.md` to
`src/15-DECISIONS/ADR-US###-<DECISION>-DD-MM-YYYY.md` — the driving story, the decision in
`SCREAMING-SNAKE-CASE`, and today's date (e.g.
`ADR-US014-OPAQUE-SESSION-TOKENS-31-08-2026.md`). Flat: no per-story subdirectory. Fill the
metadata header: Status (`Proposed`), Date, Deciders, Supersedes, Superseded by, Related
(`US###`).

### Step 6 — Write the Context section

State the problem, the constraints, the requirements, and the assumptions in effect —
neutrally enough that a reader who disagrees with the eventual decision still
recognises the problem. Link the driving `US###` or the spec document that surfaced
the trade-off.

### Step 7 — Document the options considered

> **Model:** opus (drafting the option summaries once the trade-offs are settled)

For each realistic option — including "do nothing" where relevant — write a Summary,
Pros, and Cons. Consult `.claude/skills/codebase-design/SKILL.md` to reason about each
option's depth (interface simplicity vs implementation complexity) and locality before
writing the trade-offs down. Ground a contested choice with
`.claude/skills/research/SKILL.md` if a primary-source citation would settle it.

### Step 8 — Load the `planner` skill

```text
planner [state the decision under discussion, the driving US### or spec, and the
options already gathered from Steps 4–5]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `planner` · **Model:** fable · **MCP:** none

### Step 9 — Write the Decision section

State the chosen option plainly and **why** it beat the alternatives — this is the
load-bearing section. Be specific about the deciding factor (performance, security,
maintainability, team familiarity, time pressure — whatever actually tipped it).

### Step 10 — Write the Consequences section

Record what improves (**Positive**), what the project accepts as a trade-off
(**Negative / trade-off**), and any follow-on work the decision creates
(**Follow-on**) — migrations, enforcement points in `code/`, or stories it unblocks or
creates. Note any new obligation a later ADR may need to revisit.

### Step 11 — Cross-link supersession, if any

Every clash found at Step 3, and every record Step 2 found falsified, is resolved here. Set
**Supersedes** to the losing ADR's **full filename** in this record's header (there is no
`ADR-###` index — it was retired 31/08/2026), then open that ADR and set its **Superseded
by** field and Status to `Superseded`. Both records must point at each other — never leave a
one-directional link.

### Step 12 — Cross-link the driving story and set Status

Add a reference to each `ADR-US###-<DECISION>-DD-MM-YYYY.md` under a **Decisions** section
in the driving `US###.md` (and, where relevant, in the spec document that surfaced the
trade-off). Once <%DEVELOPER_NAME%> signs off, flip Status from `Proposed` to `Accepted` —
this is the point the record becomes immutable. **The gate closes when the story's whole ADR
set is Accepted and mutually consistent**, not when the last one is written.

### Step 13 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
