---
name: runbook
description: >-
  Write or restructure operator documentation for <%PROJECT_NAME%> — the guides in
  `how-to/docs/` and `how-to/src/` that tell a human how to run this system: environment
  setup, Docker, the dev scripts, database operations, quality gates, deploys and server
  runbooks, plus the `how-to/workflows/` procedures themselves. Load when authoring or
  restructuring anything under `how-to/`, or when any request asks for a procedure a person
  will follow start to finish. Not how to write the project's code, and not end-user help
  for the product — different audiences, different registers.
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow
---

# Write an Operator Guide (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable procedure with a file as its output). The
standing conventions are **not** here: they are `how-to/docs/OPERATOR-DOC-CRAFT.md`, and the
procedure of record is `how-to/workflows/09-write-operator-guide/`. Read the craft guide first;
everything below sequences it.

**Locale:** British English (en_GB) · <%TIMEZONE%> · <%CURRENCY%>.

---

## The brief arrives settled

A fork starts with no conversation behind it, so the design questions cannot be asked from
inside this skill. Five answers must already be in the brief:

1. **Who the reader is**, and what has just gone wrong for them.
2. **Whether an existing guide should be extended** instead of a new one written.
3. **Which home** — and therefore which length standard.
4. **Reference or runbook** — read in fragments, or executed top to bottom.
5. **What is explicitly out of scope.**

**If one is missing, return and say which.** Do not invent a reader: a guide written for a
reader nobody named is a guide written for its author, and it reads as one. The caller settles
them with a grilling pass (`.claude/CLAUDE.md` §10) before dispatching this skill.

## Steps

1. **Read the craft guide.** `how-to/docs/OPERATOR-DOC-CRAFT.md` — the reader, the two homes and
   their standards, the spine, command discipline, and the scope boundaries.
2. **Confirm every script you intend to cite exists.** List `code/src/scripts/*/` and run
   `--help` on each one. A guide citing a script that does not exist is worse than no guide,
   because the reader trusts it at exactly the moment they cannot check it.
3. **Read the nearest existing guide** in the same home and match its voice and shape. Two
   guides in one folder written in two registers is a folder nobody can skim.
4. **Write to the spine** — purpose, prerequisites, steps with expected output, failure modes,
   rollback, verification. Anything destructive gets its rollback section, not a warning.
5. **Execute it, start to finish**, from a state matching your stated prerequisites.
6. **Correct it from what happened**, not from what you remember. Every surprise is an edit: a
   primed environment is a missing prerequisite; a pause to think is an under-specified step; an
   instinctive recovery belongs in Failure modes.
7. **Index it** — the folder's `CONTEXT.md` tree and `how-to/REFERENCES.md`, in this change.
8. **Run the gates:** `bash code/src/scripts/audits/docs-length.sh`,
   `bash code/src/scripts/syntax/lint.sh`, `bash code/src/scripts/syntax/format.sh`.

## Definition of done

The guide has been **executed** start to finish and corrected from what happened; every command
cites a `code/src/scripts/**/*.sh` script; failure modes and rollback are present for anything
destructive; it is listed in its `CONTEXT.md` tree and in `how-to/REFERENCES.md`;
`docs-length.sh`, markdownlint and Prettier all pass; British English throughout; every touched
`CONTEXT.md` has its `**Last Updated**` refreshed.

## Handoff

Report to the caller: the guide's path and home, whether it was executed and what that changed,
any script gap found (and whether it was written, recorded in `GAPS.md`, or documented as a
manual step), and the index entries added.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `how-to/workflows/09-write-operator-guide/` — **the procedure of record for this skill**
- `how-to/workflows/06-quality-gates/` — the Markdown, length and format gates a guide must pass
- `how-to/workflows/01-first-time-setup/` · `how-to/workflows/03-daily-development/` ·
  `how-to/workflows/08-debugging/` — the procedures most often documented against
- `code/workflows/07-review/` — when the guide documents code-level standards as well
- `project-management/workflows/21-implementation-documentation/` — owns implementation
  records; a guide is not one

## Cross-references

- `how-to/docs/OPERATOR-DOC-CRAFT.md` — the conventions this procedure applies
- `how-to/docs/SKILL-AUTHORING.md` — the sibling standard, for skills rather than guides
- `.claude/skills/global-workflow/` — British English, Markdown style, commit conventions
- `code/src/scripts/CONTEXT.md` — the scripts a guide is allowed to cite
