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

| Step      | Section                                                                       |
| --------- | ----------------------------------------------------------------------------- |
| All steps | **Internal — Live Artefacts** → src/15-DECISIONS/                             |
| All steps | src/15-DECISIONS/CLAUDE.md — immutability, monotonic indices, authoring rules |
| Template  | src/15-DECISIONS/ADR-000-TEMPLATE.md — the five-section scaffold to copy      |

---

## Prerequisites

- [ ] A driving user story (`src/02-STORIES/US###.md`) or specify-tier spec exists —
      the trade-off must come from somewhere real, not be invented in the abstract
- [ ] The relevant specify-tier workflow has surfaced the choice (e.g.
      `04-database-schema` for a schema shape, `10-security-checks` for an
      auth/session strategy, `13-api-design` for a contract-shaping decision)
- [ ] `src/15-DECISIONS/` has been scanned for an existing ADR this one might
      supersede

---

## Steps

### Step 1 — Grill, then confirm the decision is ADR-worthy

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> — what is the forces at play, what options are
realistically on the table, what happens if we do nothing, and who owns the call —
before writing anything. Not every choice needs an ADR: reserve it for a decision that
is hard to reverse, or that a later decision would need to explicitly supersede. A
call the implementer should just make does not belong here — say so and stop.

### Step 2 — Take the next free ADR index

List `src/15-DECISIONS/` and find the highest existing `ADR-###` index. The next
record takes the following number, zero-padded to three digits. Never reuse a retired
number — gaps from an abandoned draft are acceptable, collisions are not.

### Step 3 — Copy the template

Copy `src/15-DECISIONS/ADR-000-TEMPLATE.md` to
`src/15-DECISIONS/ADR-###-<TITLE>.md`, with `TITLE` in `SCREAMING-SNAKE-CASE`
summarising the decision (e.g. `ADR-001-OPAQUE-SESSION-TOKENS.md`). Fill the metadata
header: Status (`Proposed`), Date, Deciders, Supersedes, Superseded by, Related
(`US###` / `ADR-###`).

### Step 4 — Write the Context section

State the problem, the constraints, the requirements, and the assumptions in effect —
neutrally enough that a reader who disagrees with the eventual decision still
recognises the problem. Link the driving `US###` or the spec document that surfaced
the trade-off.

### Step 5 — Document the options considered

> **Model:** opus (drafting the option summaries once the trade-offs are settled)

For each realistic option — including "do nothing" where relevant — write a Summary,
Pros, and Cons. Consult `.claude/skills/codebase-design/SKILL.md` to reason about each
option's depth (interface simplicity vs implementation complexity) and locality before
writing the trade-offs down. Ground a contested choice with
`.claude/skills/research/SKILL.md` if a primary-source citation would settle it.

### Step 6 — Load the `planner` skill

```text
planner [state the decision under discussion, the driving US### or spec, and the
options already gathered from Steps 4–5]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `planner` · **Model:** fable · **MCP:** none

### Step 7 — Write the Decision section

State the chosen option plainly and **why** it beat the alternatives — this is the
load-bearing section. Be specific about the deciding factor (performance, security,
maintainability, team familiarity, time pressure — whatever actually tipped it).

### Step 8 — Write the Consequences section

Record what improves (**Positive**), what the project accepts as a trade-off
(**Negative / trade-off**), and any follow-on work the decision creates
(**Follow-on**) — migrations, enforcement points in `code/`, or stories it unblocks or
creates. Note any new obligation a later ADR may need to revisit.

### Step 9 — Cross-link supersession, if any

If this ADR replaces a prior decision, set **Supersedes** to that ADR's number in this
record's header, then open the superseded ADR and set its **Superseded by** field and
Status to `Superseded`. Both records must point at each other — never leave a
one-directional link.

### Step 10 — Cross-link the driving story and set Status

Add a reference to `ADR-###-<TITLE>.md` under a **Decisions** section in the driving
`US###.md` (and, where relevant, in the spec document that surfaced the trade-off).
Once <%DEVELOPER_NAME%> signs off, flip Status from `Proposed` to `Accepted` — this is the point the
record becomes immutable.

### Step 11 — Commit

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
