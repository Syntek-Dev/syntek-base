---
workflow: 08-security-hardening
phase: harden
skills: [security, stack-django, stack-htmx-templates]
model: opus
---

# Security Hardening — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                                              |
| ---- | -------------------------------------------------------------------------------------------------------------------- |
| 1–2  | **Guides in code/docs/** → SECURITY.md, CODING-PRINCIPLES.md                                                         |
| 1–2  | **External — Security & Standards** → OWASP Top 10 (2025), OWASP REST Security Cheat Sheet, Django security overview |
| 3    | **External — Testing** → pytest, pytest-django                                                                       |

---

## Steps

### Step 1 — Security Review

```text
security [scope to review]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `security` · **Model:** opus · **MCP:** code-review-graph

### Step 2 — Address Findings

Address all `security` findings in severity order (critical first).
Commit after each group of fixes.

### Step 3 — QA Verification

```text
qa-tester [verify security fixes]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `qa-tester` · **Model:** opus · **MCP:** none

### Step 4 — Log Audit

Save a security audit summary to `project-management/src/10-SECURITY/AUDITS/`.

### Step 5 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

### Step 6 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
