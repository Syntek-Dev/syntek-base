---
name: grill-me
description: >-
  Start a stateless grilling session — a relentless, one-question-at-a-time interview to
  sharpen a plan, design, or idea, saving nothing to the repo. Invoke by typing /grill-me,
  or when the user asks to be grilled or interviewed about a plan without recording it.
---

# Skill: grill-me ({{PROJECT_SLUG}})

Run a grilling session and save nothing. Load `.claude/skills/grilling/SKILL.md` and follow
it exactly: one question at a time via the `AskUserQuestion` tool, each carrying your
recommended answer, looking facts up yourself and putting only genuine decisions to {{DEVELOPER_NAME}},
until the design is settled and {{DEVELOPER_NAME}} confirms shared understanding.

Use this when the interview itself is the point — sharpening thinking in conversation — and
there is no repo artifact to update yet. For a session that records its decisions as plan
updates, ADRs, glossary terms, or story acceptance criteria, use `/grill-with-docs` instead.

Nothing is written to the repo. The sharpened design lives in the conversation and feeds
whatever you build next.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/13-decisions/` — stress-test the options before an ADR is written
- `project-management/workflows/15-story-plans/` — stress-test approach and phasing

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the engine this runs.
- `.claude/skills/grill-with-docs/SKILL.md` — the stateful twin that leaves a paper trail.
