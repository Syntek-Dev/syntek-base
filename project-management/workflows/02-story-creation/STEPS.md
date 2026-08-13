---
workflow: 02-story-creation
phase: design
skills: [story, global-workflow]
model: fable
---

# User Story Creation — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step      | Section                                                                   |
| --------- | ------------------------------------------------------------------------- |
| All steps | **External — Agile & Project Management** → User Story format (Connextra) |
| 3–4       | **Internal — Live Artefacts** → src/02-STORIES/                           |

---

## Steps

### Step 1 — Grill, then Generate the Story

```text
story [describe the feature and user role]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `story` · **Model:** fable · **MCP:** none

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> — the specific user role, the measurable benefit,
the success signal, constraints and dependencies, priority, and at least one edge/error
case — before drafting. Always grill when the feature touches personal data, permissions,
or money. Record the resolved behaviour straight into the story's Gherkin acceptance criteria.

### Step 2 — Review and Edit

> **Model:** opus

Review the generated story for:

- Clear "As a [role], I want [goal], so that [benefit]" format
- Specific, testable acceptance criteria
- No ambiguity in scope
- `**Status:**` header set to a valid ClickUp status — a new story starts as `Open`
  (see `project-management/docs/PLANNING-GUIDE.md` → Story Statuses for the full set)

### Step 3 — Assign Story Number

Check `project-management/src/02-STORIES/` for the next available number.
Name the file `US###.md`.

### Step 4 — Save

Save to `project-management/src/02-STORIES/US###.md`.

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
