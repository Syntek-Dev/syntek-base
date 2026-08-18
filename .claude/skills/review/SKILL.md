---
name: review
description: >-
  Run a review pass over work in progress for <%PROJECT_NAME%> — sequence the content review,
  the hostile QA pass and, where auth, permissions, PII or a new state-changing endpoint are in
  scope, the security pass. Load when a change needs checking before it is proposed, or when
  someone asks how a branch is looking. Not the read-only content review itself
  (`code-reviewer`), not the adversarial breaker pass itself (`qa-tester`), not raising or
  merging the pull request (`pr`), and not the architectural-depth sweep
  (`improve-codebase-architecture`).
model: opus
metadata:
  skills: codebase-design global-workflow grilling
---

# Review a Change (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — what to review, and how deep, is settled in the conversation;
the passes themselves are dispatched).

**This skill does not write.** Its pre-flight runs `lint.sh` and `format.sh` **bare**, and both
are dry-run by default — `format.sh` reports what would change and modifies nothing without
`--fix`. Read their exit codes rather than assuming the tree was corrected: `0` clean, `1` issues
found, `2` script error, `3` clean but a leg could not run (`code/docs/GATE-REPORTING.md`).

---

## Pre-flight

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/format.sh
```

Both are **read-only here**. Add `--fix` deliberately if the review is to correct formatting;
without it these report and change nothing. An exit of `3` means a leg could not run and is not
a clean result — resolve it before reading the diff, or the review rests on a check that
never happened.

Then trace the change structurally before reading it file by file: the code-review-graph
**review playbook** (`.claude/skills/review-changes.md`; guide
`code/docs/CODE-REVIEW-GRAPH.md`) runs `detect_changes` → `get_affected_flows` → `query_graph`
tests_for → `get_impact_radius`. That is what tells the review dispatch where to look.

## The passes

Each is a separate Agent tool call to `general-purpose`, naming the skill to load. **They
dispatch separately so that no pass checks its own output** — a convention this skill holds,
not something the runtime enforces.

1. **Content review** — the `code-reviewer` skill. Security, PII, DRY, performance and style
   against `code/workflows/07-review/`. **Not a dispatch that wrote the code being reviewed.**
2. **QA** — the `qa-tester` skill. Hostile, adversarial, looking for the edge case the
   implementation forgot. **A separate dispatch from the reviewer.**
3. **Security — conditional.** Run the `security` skill when any of these is in scope: auth,
   permissions, PII handling, or a new state-changing Django Ninja endpoint. Always a separate
   dispatch.

**An architectural-depth pass is optional and separate.** Where the change is structural rather
than behavioural, `/improve-codebase-architecture` surfaces deepening opportunities as a report
before the PR; the vocabulary a review comment about depth is written in — module, interface,
seam, depth, leverage, the deletion test, "the interface is the test surface" — belongs to the
`codebase-design` skill.

## Definition of done

Every pass that was in scope ran as its own dispatch; every finding is either fixed, or recorded
with an owner; a security finding is routed to `code/workflows/08-security-hardening/` rather
than patched inside the review; the change is lint-clean and formatted — **verified by an exit
of `0` from both pre-flight commands**, never inferred from having run them.

## Handoff

Report what was reviewed, which passes ran, and the findings by severity with their owners.
Findings that will not be fixed in this change go to `project-management/src/19-FINDINGS/` via
`21-implementation-documentation`, which owns them; this skill does not write the register.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `code/workflows/07-review/` — **the procedure of record** for the content of a change
- `code/workflows/08-security-hardening/` — where a security finding raised here is fixed
- `project-management/workflows/22-pr-and-review/` — the PR process, its approvals and merge gates
- `project-management/workflows/21-implementation-documentation/` — owns findings and records

## Cross-references

- `code/docs/CODE-REVIEW-GRAPH.md` — the review playbook and its tool sequence
- `code/docs/SECURITY.md` · `code/docs/TESTING.md` · `code/docs/CODING-PRINCIPLES.md`
- `project-management/docs/QA-GUIDE.md` — the QA standard the hostile pass is judged against
