---
workflow: 03-sprint-planning
phase: design
skills: [sprint, global-workflow]
model: fable
---

# Sprint Planning — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                                                   |
| ---- | ------------------------------------------------------------------------------------------------------------------------- |
| 2–3  | **External — Agile & Project Management** → MoSCoW prioritisation, Story point estimation (Fibonacci), Definition of Done |
| 1    | **Internal — Live Artefacts** → src/02-STORIES/                                                                           |
| 4    | **Internal — Live Artefacts** → src/03-SPRINTS/                                                                           |

---

## Steps

### Step 1 — Grill, then Review the Backlog

> **Model:** opus

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> about the sprint goal, capacity, and candidate
stories before reviewing the backlog and identifying candidates.

Read open stories in `project-management/src/02-STORIES/` and identify candidates.

### Step 2 — Generate Sprint Plan

```text
sprint [describe sprint goal and available stories]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `sprint` · **Model:** fable · **MCP:** none

### Step 3 — Review and Balance

Check the generated sprint for:

- Realistic scope given the sprint length
- MoSCoW prioritisation applied
- Dependencies between stories noted

### Step 4 — Save

Save to `project-management/src/03-SPRINTS/SPRINT-##.md`.

### Step 5 — Commit

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
