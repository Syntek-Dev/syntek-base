---
name: grill-me
description: >-
  Grill an idea and write nothing down — a relentless interview in frontier rounds that
  sharpens a plan, design or half-formed thought and leaves **no trace in the repository**.
  Invoke by typing /grill-me, or whenever someone asks to be grilled, interviewed, challenged
  or stress-tested on something they are still thinking through, or says explicitly not to
  record it. The whole distinction from `grill-with-docs` is the artefact: that one settles a
  design and writes each decision into the repo as it resolves; this one is a conversation that
  ends when it ends.
---

# Skill: grill-me (<%PROJECT_SLUG%>)

Run a grilling session and save nothing. Load `.claude/skills/grilling/SKILL.md` and follow
it exactly — **it owns the round shape, the question format and the recommendation rule; do
not restate them here.** Grill until the design is settled and <%DEVELOPER_NAME%> confirms
shared understanding.

Use this when the interview itself is the point — sharpening thinking in conversation — and
there is no repo artifact to update yet. For a session that records its decisions as plan
updates, ADRs, glossary terms, or story acceptance criteria, use `/grill-with-docs` instead.

Nothing is written to the repo. The sharpened design lives in the conversation and feeds
whatever you build next.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/15-decisions/` — stress-test the options before an ADR is written
- `project-management/workflows/17-story-plans/` — stress-test approach and phasing

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the engine this runs.
- `.claude/skills/grill-with-docs/SKILL.md` — the stateful twin that leaves a paper trail.
