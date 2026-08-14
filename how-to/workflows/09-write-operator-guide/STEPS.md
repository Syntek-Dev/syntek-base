---
workflow: 09-write-operator-guide
phase: document
skills: [runbook, global-workflow]
model: opus
---

# Write an Operator Guide — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                               |
| ---- | --------------------------------------------------------------------- |
| 1    | **Context files** → `how-to/src/CONTEXT.md`, `how-to/docs/CONTEXT.md` |
| 2    | **Reference guides** → the guide nearest your subject                 |
| 3    | **Cross-layer references** → `code/src/scripts/CONTEXT.md`            |
| 4–5  | **Reference guides** → CLI-TOOLING.md (verifying every command)       |

---

## Step 1 — Grill, then place it

> **↳ New dispatch:** `general-purpose` · **Skill:** `runbook` · **Model:** opus

**Grill first** (`.claude/CLAUDE.md` §10): load `.claude/skills/grill-with-docs` and settle —

1. **Who is the reader, and what has just gone wrong for them?** An operator guide is read
   under time pressure by someone with a problem, not browsed.
2. **Does this belong in an existing guide?** A new file that duplicates half of
   `DEVELOPMENT.md` is worse than three added paragraphs there.
3. **Which home:** `how-to/docs/` (instructional, ≤ 300 lines, split when it grows) or
   `how-to/src/` (human-facing, full length, exempt)?
4. **Is it a reference or a runbook?** A reference is read in fragments; a runbook is
   executed top to bottom. They have different shapes.
5. **What is out of scope**, and which document owns that instead?

Check the boundary before writing: server provisioning lives in `<%DEPLOY_REPO%>`, not
here — `how-to/src/NIXOS-SETUP.md` is a pointer stub on purpose, and this repo specifies
the contract rather than implementing it.

---

## Step 2 — Draft against the spine

> **Model:** opus · **Skill:** `runbook`

Load `.claude/skills/runbook/SKILL.md` and follow the shape it defines: purpose →
prerequisites → steps with expected output → failure modes → rollback → verification.

Two rules that decide whether the guide is any good:

- **Every command is copy-pasteable and cites a script.** No placeholder a reader must
  guess at; where a value genuinely varies, say where to find it.
- **Every step states what success looks like.** "Run X" is not a step — "Run X; you should
  see `Y`; if you see `Z`, go to Failure modes" is.

Match the house voice: British English, second person, no filler. A reader in a hurry
should be able to skim the headings and find their step.

---

## Step 3 — Resolve every command to a script

> **Model:** opus

Walk the draft and confirm each command exists:

```bash
ls code/src/scripts/*/
bash code/src/scripts/<area>/<script>.sh --help
```

Where no script exists, you have found a gap, and you have three honest options — write the
script (then document it), record the gap in `GAPS.md`, or state plainly in the guide that
the operation is manual and why. **Documenting a raw `docker`/`pnpm`/`uv`/`manage.py`
command as the sanctioned route is not one of them**, and the audits will flag it.

---

## Step 4 — Execute it on a clean environment

> **Model:** opus

This is the step that separates an operator guide from an essay. Run the procedure from a
state that matches your stated prerequisites — a fresh worktree, a reset database, a
rebuilt image, whichever the guide claims to start from.

Fix what you find, in the guide rather than in your shell:

- A step that only worked because your environment already had something → **a missing
  prerequisite.**
- Output that does not match what you wrote → **correct the guide, not your memory.**
- A step you had to think about → **it is under-specified.**
- A failure you recovered from by instinct → **that belongs in Failure modes.**

---

## Step 5 — Wire it in and close out

> **Model:** opus

- Add the file to its folder `CONTEXT.md` tree **and** the relevant table in
  `how-to/REFERENCES.md`; a guide nothing links to will not be found.
- Cross-reference the workflows and guides that should route to it, and check the reverse
  direction resolves too.
- Verify length: `bash code/src/scripts/audits/docs-length.sh`. Over 300 code lines in
  `how-to/docs/` means split it and leave a thin index; `how-to/src/` is exempt, bar its
  `CONTEXT.md`/`CLAUDE.md` pair. (`audits/cloc.sh` cannot answer this — it enforces the
  750/800 limit on source files and excludes Markdown.)
- Run the Markdown gates — `pnpm exec markdownlint-cli2` and Prettier — via
  workflow `06-quality-gates`.
- Update `**Last Updated**` on every `CONTEXT.md` you touched, and refresh the
  code-review-graph so the docs and the graph stay in lockstep.
