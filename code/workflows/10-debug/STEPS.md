---
workflow: 10-debug
phase: verify
skills: [bugfix, stack-django, stack-htmx-templates]
model: opus
---

# Debug — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `code/REFERENCES.md` as you work through these steps:

| Step        | Section                                                                    |
| ----------- | -------------------------------------------------------------------------- |
| 1–4         | **External — Testing** → pytest, pytest-django                             |
| 2           | **Guides in code/docs/** → LOGGING.md                                      |
| Bug reports | **Internal → Workflow CONTEXT files** → code/workflows/10-debug/CONTEXT.md |

---

## Prerequisites

- [ ] Containers running
- [ ] Bug is reproducible

---

## Steps

### Step 1 — Reproduce with a Failing Test

Write the smallest possible test that demonstrates the incorrect behaviour.
Do not attempt a fix until this test exists and is failing.

**Tight feedback loop — hard gate (the debugger's first move).** Before reading code to
form any theory, build a single command that is (a) **red-capable** — asserts the exact
reported symptom on the real code path, (b) **deterministic**, (c) **fast** (seconds),
and (d) **agent-runnable** via a `code/src/scripts/**/*.sh` script. Run it once, capture
the output, and confirm it is **red**. This failing command _is_ the regression test — it
must exist and fail before any fix or wider investigation.

> **Model:** opus · **MCP:** none

```bash
bash code/src/scripts/tests/backend.sh -k "test_<bug_name>" -v
```

### Step 2 — Isolate the Scope

Narrow the failing case to the smallest unit. Use the Django shell for backend
data inspection, or the browser DevTools network panel for an HTMX swap that returned the wrong fragment.

Before probing, generate **3–5 ranked, falsifiable hypotheses and show them** (the
interrogate-before-acting posture of `.claude/CLAUDE.md` §10); then test them **one
variable at a time**. Tag every probe or debug log with a unique prefix such as
`[DEBUG-a4f2]` so cleanup is a single grep.

> **Model:** opus · **MCP:** code-review-graph (debug playbook — `.claude/skills/debug-issue.md`)

```bash
bash code/src/scripts/development/shell.sh
```

### Step 3 — Implement the Fix

Apply the minimal fix. Do not refactor surrounding code in the same commit —
if a design problem is evident, note it and open a separate refactoring task.

Dispatch the scoped phase below to confirm the cause and the recommended fix; it hands
back a finding, and the fix is applied here. Verification is Step 4 and the commit Step 6
— never the dispatch.

```text
bugfix [describe the bug and the isolated scope]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `bugfix` (`## Root cause` phase only) · **Model:** opus · **MCP:** none

### Step 4 — Verify No Regressions

Run the full test suite to confirm the fix does not break anything else.

```bash
bash code/src/scripts/tests/backend.sh
```

### Step 5 — Update Context and Documentation

**Hard gate — complete before committing.** If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it
5. Refresh the code-review-graph so its flows match the updated docs: `code-review-graph update` (or the `build_or_update_graph_tool` MCP tool) — keeps the graph and the layered docs in lockstep

---

### Step 6 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
