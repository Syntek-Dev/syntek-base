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
> `src/15-DECISIONS/ADR-000-TEMPLATE.md` (the five-section scaffold) for supporting
> references.

## Execution Checklist

- [ ] A driving `US###` or specify-tier spec exists — the decision is not invented in
      the abstract
- [ ] The decision was confirmed ADR-worthy (hard to reverse, or supersedes/will need
      to be superseded) rather than a call the implementer should just make
- [ ] `src/15-DECISIONS/` was scanned for an existing ADR this one might supersede
- [ ] The ADR is numbered with the next free, monotonic `ADR-###` index — no reused or
      collided number
- [ ] File is named to convention: `ADR-###-<TITLE>.md`, 3-digit zero-padded index,
      title in `SCREAMING-SNAKE-CASE`
- [ ] Metadata header complete: Status, Date, Deciders, Supersedes, Superseded by,
      Related (`US###` / `ADR-###`)
- [ ] Context section states the problem, constraints, and assumptions neutrally
- [ ] All realistic options are documented, each with Summary, Pros, and Cons
      (including "do nothing" where relevant)
- [ ] Decision section states the chosen option and the specific deciding factor
- [ ] Consequences section covers Positive, Negative / trade-off, and Follow-on
- [ ] Any superseded ADR is cross-linked in both directions (this record's
      `Supersedes`, the old record's `Superseded by` and Status)
- [ ] Driving `US###.md` (and spec document, where relevant) references this ADR
- [ ] Status flipped from `Proposed` to `Accepted` only once <%DEVELOPER_NAME%> has signed off

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` inside it

---

## Definition of Done

- [ ] `ADR-###-<TITLE>.md` committed and pushed with Status `Accepted`
- [ ] <%DEVELOPER_NAME%> (or the named Decider) has signed off the record
- [ ] Ready to proceed to `workflows/16-sprint-plans/` and `workflows/17-story-plans/`
