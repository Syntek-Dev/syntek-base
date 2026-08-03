@./CONTEXT.md

# CLAUDE.md — workflows/10-debug/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(when to use, debug concepts, prerequisites — imported above) → this file.

## Purpose (one line)

The code-logic debugging procedure — isolate a reproducible fault, pin it with a
failing regression test, then apply the minimal fix. Distinct from operational
debugging (`how-to/workflows/08-debugging/`) and log-based debugging (workflow `09`).

## How to work here

- **Routing:** execute via `STEPS.md`, typically with the `debug` or `bugfix`
  skill/agent (Opus). Confirm the environment is healthy first via
  `how-to/workflows/08-debugging/`, then fix the logic here. Trace the fault with the
  code-review-graph **debug playbook** (`.claude/skills/debug-issue.md`; guide
  `code/docs/CODE-REVIEW-GRAPH.md`).
- **Model:** Opus for root-cause analysis and the fix and mechanical
  edits to the workflow files.
- **Concrete steps:** confirm containers up and the bug reproducible → bisect to the
  smallest failing case → write a failing regression test **before** the fix → apply
  the minimal fix → run the suite via `code/src/scripts/tests/*.sh` → complete
  `CHECKLIST.md`.
- **Definition of done:** regression test now green, no unrelated code touched,
  behaviour corrected, bug artefact updated under `project-management/src/20-BUGS/`.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry `agent`/`skills`/`model` frontmatter — read it first (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **Failing test first** — it pins the bug and becomes the regression guard.
- **Keep the fix minimal** — do not refactor surrounding code in the same commit; if
  the fix reveals a design problem, open a separate task for workflow `11`.
- No mandatory pre-reads (debugging is reactive), but never invoke `pytest`
  `python`, or `docker` directly — only the shell scripts.

## Output & naming

- **Hand-written:** these workflow files; the fix and its regression test land beside
  the code under `code/src/`.
- Bug reports `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` under `project-management/src/20-BUGS/`;
  workflow files `SCREAMING-SNAKE-CASE.md`.
