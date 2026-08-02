---
name: teach
description: >-
  Open a safe learning space to practise a new skill without changing the codebase — reads the
  real code and docs freely as reference, writes only inside learning/. Invoke by typing
  /teach <topic>, or when <%DEVELOPER_NAME%> asks to learn, practise, or be taught something — a stack
  technique (HTMX, Django, CSS, testing) or a PM/process convention (stories, sprints, plans,
  ADRs) — in a throwaway workspace.
---

# Skill: Teach (<%PROJECT_NAME%>)

Teach opens a **learning workspace** where <%DEVELOPER_NAME%> practises a new skill without touching the
product. The posture is the inverse of a normal task: the goal is not a shipped artefact but a
durable skill, built through **lessons** pitched at the learner's **zone of proximal
development**, drilled by **retrieval practice**, and consolidated on a **spaced repetition**
schedule. Read the real code and docs freely as reference; every draft, example, and note lands
in `learning/` only.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%> · dates DD/MM/YYYY.

## The one rule: the codebase is read-only

A learning session reads the real `code/src/`, `project-management/src/`, and every doc as
reference, and writes only inside `learning/`. Practice code, throwaway drafts, and notes live
under `learning/<topic>/`; the live tree, migrations, commits, and ship gates stay untouched by a
session. Every step below serves that.

## Workspace layout

`learning/` is committed — <%DEVELOPER_NAME%> learns across devices and needs it to sync. The caller scaffolds
`learning/CONTEXT.md` + `learning/CLAUDE.md`; this skill creates the per-topic folder on first run:

```text
learning/<topic>/
├── MISSION.md    ← why <%DEVELOPER_NAME%> is learning this, the real goal, and the family (process | coding)
├── RESOURCES.md  ← curated primary + house-convention pointers (looked up, not guessed)
├── PROGRESS.md   ← retrieval-practice + spacing log; each lesson's next-review date
└── LESSONS/      ← worked practice — throwaway drafts, runnable examples, recall notes
```

## How to teach

1. **Clarify the mission.** Read `learning/<topic>/MISSION.md` if it exists; if it is missing or
   thin, ask why <%DEVELOPER_NAME%> wants this skill and what "can do it" looks like — one question at a time,
   each with a recommended answer (the `grilling` posture). Record the goal and the **family**:
   **process/PM** (agile, stories, sprints, plans, ADRs) or **stack/coding** (HTMX, Alpine, vanilla
   CSS, Django, django-ninja, django-components, architecture, security, testing).
   Done when `MISSION.md` states the goal and the family in <%DEVELOPER_NAME%>'s words.
2. **Assess the level, set the next lesson.** Read `PROGRESS.md` for what is already consolidated,
   and look up the real subject with `code-review-graph` → Read/Grep/Glob → `.claude/plugins/*.py`
   (`project`/`db`/`env`). Pick the one next **lesson** at the edge of the current level — the
   **zone of proximal development**: a step <%DEVELOPER_NAME%> cannot yet do alone but can with support.
   Done when the next lesson is named as a single, tightly-scoped concept.
3. **Gather resources.** Populate `RESOURCES.md` from primary sources (`context7` for library
   docs, the linked specs) and the **house** sources for the family (below) — the conventions <%DEVELOPER_NAME%>
   will practise in the real format. Cite, do not paraphrase from memory.
   Done when `RESOURCES.md` points at a primary source and the house convention for this lesson.
4. **Run the lesson — recall, then build.** Teach the concept, then close the loop:
   - **Retrieval practice** — pose a short recall question, wait for <%DEVELOPER_NAME%>'s answer, then confirm or
     correct. Effortful recall is what builds retention; a re-read is not.
   - **Build to learn** — <%DEVELOPER_NAME%> drafts a small throwaway artefact under `LESSONS/`: a **process**
     sample (a practice `US###` or `PLAN`) or a **coding** example run through the real task-runner
     scripts (`code/src/scripts/development|tests/*.sh`) so the skill transfers.
     Done when <%DEVELOPER_NAME%> has both recalled the concept unaided and produced a worked artefact in `LESSONS/`.
5. **Capture the lesson, schedule the review.** Append the lesson to `PROGRESS.md`: what was
   learned, the recall result, and the next-review date on a **spaced repetition** curve —
   widening intervals (e.g. +1 day, +3 days, +7 days, DD/MM/YYYY). Note any misconception to
   re-drill. Done when `PROGRESS.md` holds a dated entry with a next-review date.
6. **Close the session cleanly.** Update `MISSION.md`/`RESOURCES.md` if the goal or sources
   shifted, and leave `PROGRESS.md` naming what is consolidated and what the next session should
   open on. Done when a fresh session could resume from the files alone, with nothing outside
   `learning/` changed.

## What to teach (by family)

**Process / PM.** Practise the project's _own_ conventions in the real house format, drafting a
**throwaway** sample inside `learning/<topic>/LESSONS/` — never in `project-management/src/`:

- **Stories** — `project-management/workflows/01-story-creation/`; template
  `project-management/src/01-STORIES/US000-TEMPLATE.md`.
- **Sprints & plans** — `project-management/workflows/02-sprint-planning/` and
  `14-sprint-plans/`; plan template `the project's plans folderPLAN-US000-TEMPLATE.md`.
- **ADRs** — the three-test gate and glossary discipline in
  `.claude/skills/grill-with-docs/SKILL.md`; naming `ADR-###-NAME.md` under
  the project's decision register (next free number is the project's decision register).
- **Conventions** — `project-management/docs/{GIT-GUIDE,VERSIONING-GUIDE,SPRINT-PLANNING-GUIDE}.md`.

**Stack / coding.** Learn by building small **runnable** throwaway examples under `LESSONS/`,
mirroring the real task-runner scripts so the muscle transfers, while never wiring into
`code/src/`:

- Load the matching stack skill as the reference: `.claude/skills/stack-htmx-templates/SKILL.md`
  (HTMX, Alpine, django-components, token CSS), `.claude/skills/stack-django/SKILL.md` (models,
  services, resolvers, pytest).
- Run examples through the project scripts — `code/src/scripts/development/*.sh` (e.g.
  `server.sh`, `shell.sh`) and `code/src/scripts/tests/*.sh` (e.g. `backend.sh`, `api.sh`) —
  so a practised command is the real command.
- **Domain modelling** as its own topic: the _process_ is glossary-into-nearest-`CONTEXT.md` plus
  the three-test ADR gate (`.claude/skills/grill-with-docs/SKILL.md`); the _reference_ is
  `code/docs/data-structures/DOMAIN-MODELLING.md`.

## Lesson design

- **One concept per lesson**, small enough to complete in a sitting — respect working memory.
- **Interleave** recall from earlier lessons into a new one so retrieval stays effortful.
- **Ground every lesson in the mission** — a lesson that does not move <%DEVELOPER_NAME%> toward the stated goal
  is the wrong lesson; return to step 2.
- **Quiz cleanly** — phrase recall so the answer is not given away by the shape of the question.
- **Cite the primary source** in the lesson so <%DEVELOPER_NAME%> can go deeper than parametric recall.

## Anti-patterns

- Writing outside `learning/` — a practice story into `project-management/src/`, an example into
  `code/src/`, or a stray commit. Keep it all under `learning/<topic>/`.
- Asking what the codebase already answers — look it up (step 2's lookup order).
- Re-reading in place of recall — the retrieval has to be effortful to build retention.
- Teaching ahead of the zone of proximal development — a lesson <%DEVELOPER_NAME%> cannot attempt is wasted.
- A wall of lessons at once; teach one, drill it, schedule its review, then the next.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** This skill is a session or sandbox mechanic, not a step in the
delivery chain. It is invoked directly and does not route into `code/workflows/`,
`project-management/workflows/`, or `how-to/workflows/`.

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the one-question-at-a-time posture step 1 borrows.
- `.claude/skills/grill-with-docs/SKILL.md` — the glossary + three-test ADR gate (domain-modelling process).
- `code/docs/data-structures/DOMAIN-MODELLING.md` — the domain-modelling reference.
- `.claude/skills/stack-htmx-templates/SKILL.md` · `.claude/skills/stack-django/SKILL.md` — stack references for coding lessons.
- `project-management/workflows/01-story-creation/` · `02-sprint-planning/` · `14-sprint-plans/` — house process procedures.
- `project-management/src/01-STORIES/US000-TEMPLATE.md` · `the project's plans folderPLAN-US000-TEMPLATE.md` — throwaway-sample templates.
- the project's decision register — ADR home (next free number the scale-planning contract).
- `project-management/docs/GIT-GUIDE.md` · `VERSIONING-GUIDE.md` · `SPRINT-PLANNING-GUIDE.md` — process conventions.
- `code/src/scripts/development/*.sh` · `code/src/scripts/tests/*.sh` — the task-runner scripts coding lessons mirror.
- `.claude/plugins/*.py` — read-only project inspection for step 2's lookups.
- `how-to/docs/AI-DICTIONARY.md` — glossary of the AI-coding terms used here.
