---
workflow: 06-quality-gates
phase: verify
skills: [syntax, global-workflow]
model: opus
---

# Quality Gates — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                             |
| ---- | ------------------------------------------------------------------- |
| 1    | **Operator guides** → `how-to/src/CONTRIBUTING.md`                  |
| 2–3  | **Reference guides** → CLI-TOOLING.md (syntax and audit runners)    |
| 4    | **Cross-layer references** → `code/docs/testing/COVERAGE.md`        |
| 5    | **Cross-layer references** → `project-management/docs/GIT-GUIDE.md` |

---

## Step 1 — Format and lint first

> **↳ New dispatch:** `general-purpose` · **Skill:** `syntax` · **Model:** opus

Cheapest gates first — a formatting failure is worth catching before a ten-minute suite.

```bash
bash code/src/scripts/syntax/format.sh
bash code/src/scripts/syntax/lint.sh
```

**Both of those report; neither writes.** `format.sh` defaults to a dry-run check — pass `--fix`
to actually reformat. Reading "all files are correctly formatted" from a bare run and assuming
the tree was rewritten is how a formatting failure reaches CI.

Fix lint findings properly rather than suppressing them — a `noqa` needs a reason beside it, and
a reviewer will ask.

---

## Step 2 — Type-check

> **Model:** opus

```bash
bash code/src/scripts/syntax/check.sh
```

basedpyright runs in **`standard`** mode — `pyproject.toml:166` and
`code/src/django/pyrightconfig.json:7` both set it, and neither says `strict`. A new `Any`, a
silenced error, or a widened type to make the checker quiet is still a change to the codebase's
guarantees, not a fix — treat it as a reviewable decision.

---

## Step 3 — Run the audits

> **Model:** opus

```bash
bash code/src/scripts/audits/cloc.sh          # source file length (≥800 = error)
bash code/src/scripts/audits/docs-length.sh   # instructional .md length (>300 = error)
bash code/src/scripts/audits/stubs.sh         # hard stubs left behind
bash code/src/scripts/audits/security.sh      # pnpm audit + pip-audit (mirrors CI [8/8])
bash code/src/scripts/audits/css-tokens.sh    # every var(--token) resolves
bash code/src/scripts/audits/css-gradients.sh # no inline gradients
bash code/src/scripts/audits/copy-emdash.sh   # marketing copy punctuation
bash code/src/scripts/audits/mobile-tokens.sh # mobile-only; exits 0 with a note otherwise
bash code/src/scripts/audits/seam-contract.sh # server-contract Source provenance resolves
bash code/src/scripts/audits/negative-space.sh # the invariant register agrees with the code
bash code/src/scripts/audits/negative-space.sh --self-test # ...and the detector still works
bash code/src/scripts/audits/docs-pairing.sh  # CONTEXT.md orients, CLAUDE.md instructs
bash code/src/scripts/audits/doc-references.sh # every citation resolves in every project
bash code/src/scripts/audits/doctrine-drift.sh # one rule, one home — catch the second copy
bash code/src/scripts/audits/skill-conformance.sh # skill frontmatter + routing section
bash code/src/scripts/audits/routing-skills.sh # every skill named in frontmatter exists
bash code/src/scripts/audits/dict-discipline.sh # a dict used as a record where a type belongs
bash code/src/scripts/audits/conflict-markers.sh # no unresolved merge marker anywhere
bash code/src/scripts/audits/template-orphans.sh # artefacts stranded by a template update
bash code/src/scripts/audits/static-analysis.sh # template XSS + cross-file taint (needs opengrep)
bash code/src/scripts/audits/css-slop.sh      # AI-slop, CSS half
bash code/src/scripts/audits/template-slop.sh # AI-slop, markup half
bash code/src/scripts/audits/copy-slop.sh     # AI-slop, prose half
bash code/src/scripts/audits/render-slop.sh   # AI-slop, rendered half (needs Chromium)
bash code/src/scripts/desktop/style-check.sh  # desktop-only; a Slint style is chosen
```

`security.sh` mirrors the CI `[8/8]` gate exactly, so a hit here is what the next PR would
see. Advisories are published continuously — a clean run last week means nothing today.

**Read the slop family's warnings; do not just count its exit code.** Those four report two tiers
in one run, and a `[gate: warn]` finding leaves the exit code at 0 by design — a threshold on
composition or vocabulary fails correct work, so the script reports and a human decides
(`code/docs/VISUAL-DESIGN.md` Section 6). An audit that exits 0 with five warnings has told you
something; treat each as a question to answer.

---

## Step 4 — Tests and coverage

> **Model:** opus

```bash
bash code/src/scripts/tests/all.sh --coverage
```

The floors and the promotion tier are `code/docs/testing/COVERAGE.md`. Depth and failure
routing are workflow `05-testing-and-coverage`.

**Check the branch you are targeting.** The floor rises on the promotion branches, so a change
that is green on a feature branch can still fail promotion. If you are heading for one, confirm
you clear the higher number before pushing.

---

## Step 5 — Run the full gate, then push

> **Model:** opus

```bash
echo '{"tool_input":{"command":"gh pr create"}}' | bash .claude/hooks/pre-pr-check.sh
```

**That pipe is required, and the script is unusable without it.** `pre-pr-check.sh` is a
Claude Code `PreToolUse` hook before it is anything else: it reads a JSON payload from stdin
(`:30`) and exits 0 immediately unless the payload's command matches `gh pr create` (`:35`).
Run bare, it has two modes and **neither runs a single gate** — with a terminal on stdin it
blocks forever inside `cat`, and with stdin closed it exits **0** having checked nothing. A
silent exit 0 from this command is the false green it exists to prevent, so treat any run that
prints nothing as a failed invocation rather than a clean tree.

This is the same eight-gate sequence CI runs, in the same order, plus `audits` as a ninth in
this template. Green here should mean green there — and when it does not, the mirroring itself
is the bug: fix the script or the workflow so they agree, rather than pushing repeatedly to
discover what CI wants.

In **this template repository** the hook runs a ninth gate, `audits`, and is otherwise the
same: `uv.lock` is committed here (16/08/2026), so the django image builds and every gate has
a subject. A gate reporting nothing to run is a defect here, not the expected state.

Only then raise the PR — `project-management/workflows/23-pr-and-review/`.

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
