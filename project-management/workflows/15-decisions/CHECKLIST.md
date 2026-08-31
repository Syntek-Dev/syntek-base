---
workflow: 15-decisions
phase: design
skills: [planner, codebase-design]
model: fable
---

# Decisions (ADRs) — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `project-management/REFERENCES.md` → **Internal — Live Artefacts**
> (src/15-DECISIONS/) · `src/15-DECISIONS/CLAUDE.md` (authoring rules) ·
> `src/15-DECISIONS/ADR-US000-TEMPLATE.md` (the five-section scaffold) for supporting
> references.

## Execution Checklist

- [ ] A driving `US###` exists — the decision is not invented in the abstract, and no
      wayfinder map is being used as the driver
- [ ] Every ADR steps `04`–`14` wrote for this story has been listed and read
- [ ] **Each still holds** — every record's Context re-checked against what later steps
      decided; any falsified premise superseded rather than edited
- [ ] **No two clash** — the set compared pairwise on what each Decision commits to; any
      clash resolved by a new superseding record
- [ ] Every hard-to-reverse decision the story made is recorded somewhere in the set — the
      gaps grilled and written, not assumed
- [ ] Each decision was confirmed ADR-worthy (hard to reverse, or supersedes/will need
      to be superseded) rather than a call the implementer should just make
- [ ] Files are named to convention: `ADR-US###-<DECISION>-DD-MM-YYYY.md`, flat in
      `src/15-DECISIONS/`, decision in `SCREAMING-SNAKE-CASE`
- [ ] Metadata header complete: Status, Date, Deciders, Supersedes, Superseded by,
      Related (`US###`)
- [ ] Context section states the problem, constraints, and assumptions neutrally
- [ ] All realistic options are documented, each with Summary, Pros, and Cons
      (including "do nothing" where relevant)
- [ ] Decision section states the chosen option and the specific deciding factor
- [ ] Consequences section covers Positive, Negative / trade-off, and Follow-on
- [ ] Any superseded ADR is cross-linked in both directions by **full filename** (this
      record's `Supersedes`, the old record's `Superseded by` and Status)
- [ ] Driving `US###.md` (and spec document, where relevant) references every ADR in the set
- [ ] Status flipped from `Proposed` to `Accepted` only once <%DEVELOPER_NAME%> has signed off

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] The story's **whole ADR set** is committed and pushed with Status `Accepted`, and is
      internally consistent — the gate closes on the set, not on the last record written
- [ ] <%DEVELOPER_NAME%> (or the named Decider) has signed off every record
- [ ] Ready to proceed to `workflows/16-sprint-plans/` and `workflows/17-story-plans/`
