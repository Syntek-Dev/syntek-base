---
name: scaffold
description: >-
  Build <%PROJECT_NAME%>'s organisational layer — the `CONTEXT.md` + `CLAUDE.md` pairs that
  route Claude to the right context, numbered `NN-name/` workflow folders with their `STEPS.md`
  and `CHECKLIST.md`, the routing and index surfaces that make them discoverable, and the
  `GAPS.md` rows for what is left unfinished. Load when a new workflow, documentation directory
  or layer sub-tree has to exist. Never touches source code. Not the Django app, view or config
  scaffolding (`setup`), not authoring a guide's substance (`doc-writer`), and not an operator
  procedure a human executes (`runbook`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling
---

# Scaffold the Organisational Layer (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable generation task whose output is documentation
structure).

**Never touch source code.** No `.py`, `.html`, `.css` or `.js`. Structure and documentation
only.

---

## The brief arrives settled

A fork cannot ask, so the brief must name **exactly what to create** — a workflow folder, a
documentation directory, a layer sub-tree, a whole domain — and **exactly where in the tree it
lands.** A guessed location is a routing surface nobody finds. Where that is open, the pass is
`grilling`, run inline first.

## Read the closest sibling before generating anything

**The structure is defined by the project, not by any external template.** An adjacent workflow
folder, a domain `CONTEXT.md`, a layer `CLAUDE.md` — that is the pattern source. **Match its
shape, depth and tone; do not improvise a format.**

Then map the target area (Glob `**/CONTEXT.md`, the relevant `workflows/` tree) and list every
file to be created or touched. **Never overwrite a populated file blind — read it and extend.**

## The pairing rule

`code/docs/DOCUMENTATION-PAIRING.md` is the **owning guide** and the first thing to read: the
test that separates orientation from operating rules, the headings banned from a `CONTEXT.md`
and where each moves, and the two exceptions.

In brief — and the guide is what settles an edge case:

- **`CONTEXT.md` is what is here and why it is here.** An annotated `## Directory Tree` fence
  with every top-level row explained, plus a what-is-here table.
- **`CLAUDE.md` is how to work here.** It opens with `@./CONTEXT.md` (plus `@./REFERENCES.md`
  where one exists), then a `Read order:` line, then four H2s — **Purpose (one line)** · **How
  to work here** · **Guardrails** · **Output & naming** — scaled to the folder: a leaf stays
  short, a layer root is fuller.
- **A gate, a prerequisite, a reading order or a naming rule is never orientation**, however
  useful it is on arrival. It belongs in `CLAUDE.md`.
- **Never leave a bare `@./CONTEXT.md` import stub.** That is an unpaired directory wearing a
  file.

## A new numbered workflow

Create `NN-short-name/` carrying `CONTEXT.md` (the trigger conditions, what it is and is not
for, the outputs, the skills it routes to), `STEPS.md` (the procedure), and `CHECKLIST.md`
where the sibling workflows carry one. **Copy the shape from the adjacent folder.**

**Workflow numbers are a running order and may be renumbered; the `project-management/src/`
artefact folders are frozen and append-only.** Confuse the two and a `copier update` silently
orphans a developer's work.

## Then make it discoverable, and record what is missing

**A structure nothing indexes is a structure nobody reaches.** Update the parent `CONTEXT.md`
tree and its index table, the layer `REFERENCES.md` guide or workflow table, and — only where
routing genuinely changes — `.claude/CLAUDE.md`. Bump `Last Updated` on any file whose body
changed.

Then scan every folder created or touched: where a `STEPS.md` or `CHECKLIST.md` is missing, or
a file is a placeholder needing customisation, add a `GAPS.md` row. **Read `GAPS.md` first —
never duplicate an existing row.** An empty gaps table is the correct end state.

## Verify

```bash
bash code/src/scripts/audits/docs-length.sh    # the 300-line instructional cap
bash code/src/scripts/audits/docs-pairing.sh   # the CONTEXT.md / CLAUDE.md split
```

## Definition of done

Every new `CONTEXT.md` has its paired `CLAUDE.md`; every `CLAUDE.md` opens with the import and
carries the four H2s; no bare stubs; the routing surfaces updated so the new structure is
reachable; cross-references resolve; British English; nothing over the limit.

**Preserve the non-negotiables carried in the documentation you write** — the permission check
on every mutation, no IDOR, the admin path, token-first CSS, secrets via environment,
scripts-only dev operations. Do not dilute one in a reword.

## Handoff

Report the tree created and every `GAPS.md` row added. Then name what is owed: `git` to commit
it, `doc-writer` for a guide's substance rather than its shell, `runbook` where the procedure is
one a human executes under pressure, `setup` for Django app or configuration scaffolding, and
`backend`, `frontend` or `database` for anything that fills the structure.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/CONTEXT.md` — the PM workflow index and its numbering
- `code/workflows/CONTEXT.md` — the code workflow index and its four families
- `how-to/workflows/CONTEXT.md` — the operational workflow index
- `how-to/workflows/09-write-operator-guide/` — where a `how-to/` procedure's content comes from

## Cross-references

- `code/docs/DOCUMENTATION-PAIRING.md` — **the owning guide.** Read before generating either file
- `code/docs/DOCUMENTATION-LENGTH.md` — the 300-line limit every file scaffolded here is born
  under, and the ratchet that treats a file **born** at 270 as growth
- `.claude/CLAUDE.md` Section 5 — the naming conventions for documents, directories and workflows
- `.claude/CLAUDE.md` Section 8 — the same pairing rule in one bullet, and the length limits
- `project-management/src/CONTEXT.md` — why the artefact folder numbers are frozen
- `.claude/plugins/project-tool.py` — read-only project shape
