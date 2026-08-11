---
workflow: 09-gdpr-compliance
phase: compliance
agent: gdpr
skills: [global-workflow]
model: fable
---

# GDPR Compliance Review — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                                                     |
| ---- | --------------------------------------------------------------------------------------------------------------------------- |
| 1–3  | **Internal — Guides** → project-management/docs/gdpr/DATA-RIGHTS.md (lawful basis, data subject rights, consent management) |
| 1–3  | **Internal — Guides** → project-management/docs/gdpr/COMPLIANCE.md (retention, encryption at rest, breach notification)     |
| 1–3  | **External — Compliance & Legal** → UK GDPR (ICO), UK GDPR legislation, PECR (ICO)                                          |
| 4    | **Internal — Live Artefacts** → src/09-GDPR/                                                                                |

---

## Steps

### Step 1 — Grill, then Identify Data Flows

> **Model:** opus

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> about the personal data collected, its lawful basis,
retention, and data subject rights before documenting the data flows.

Document what personal data is collected, why, and how it is stored.

### Step 2 — GDPR Agent Review

```text
gdpr [describe the feature and its data flows]
```

> **↳ New agent:** `gdpr` · **Model:** fable · **MCP:** none

### Step 3 — Address Findings

For each finding:

- Confirm lawful basis for processing
- Confirm retention period is defined
- Confirm data subject rights can be exercised (access, erasure, portability)

### Step 4 — Update GDPR Documentation

Update or create files in `project-management/src/09-GDPR/`.

### Step 5 — Commit

```text
git
```

> **↳ New agent:** `git` · **Model:** opus · **MCP:** none

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
