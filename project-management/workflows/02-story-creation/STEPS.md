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

### Step 0 — Load the slice row from the map

> **Model:** opus

Stories are cut from the resolved `MAP-<FEATURE>.md` (`src/01-FEATURE-MAPS/`), not invented from
a conversation — `project-management/docs/planning/STORIES.md`. Open the map and take this
story's **Slices** row: its title and its **flag manifest**.

Two things must be true before drafting:

- Every node the map marks **"blocking a story"** is resolved. A story whose shape is still an
  open node encodes a guess in its acceptance criteria.
- The slice has a flag manifest. If it does not, the map is unfinished — go back to
  `01-feature-map/` Step 8a rather than inventing one here.

_Done when the slice row and its flags are in view._

### Step 1 — Grill, then Generate the Story

```text
story [describe the feature and user role]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `story` · **Model:** fable · **MCP:** none

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> — the specific user role, the measurable benefit,
the success signal, constraints and dependencies, priority, and at least one edge/error
case — before drafting. Always grill when the feature touches personal data, permissions,
or money. Record the resolved behaviour straight into the story's Gherkin acceptance criteria.

### Step 1a — Fill the FLAGS table

> **Model:** fable

Transcribe the slice's manifest into the story's 13-row FLAGS table, one row per gate, filling
`N/A` for every gate this story does not need. **The flag is that gate's entry condition** — a
row left blank silently skips a gate.

The manifest is a first pass, not the design: the gate owns the design, may add to a value, and
the story is updated to match when the gate closes. Sharpen a value here only where the grilling
in Step 1 settled it.

_Done when all 13 rows carry a value or a deliberate `N/A`._

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

### Step 4 — Save, and back-fill the map

Save to `project-management/src/02-STORIES/US###.md`.

Then write the allocated `US###` into the map's **Slices** row `Story` column, so the map reads
as a progress view of what has been cut. This is the one edit `02-story-creation` makes to a
wayfinder artefact; it does not touch the frontier or the resolved decisions.

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
