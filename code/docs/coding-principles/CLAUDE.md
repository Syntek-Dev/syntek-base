@./CONTEXT.md

# CLAUDE.md — code/docs/coding-principles/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(file table, imported above) → this file.

## Purpose (one line)

The split-out detail for the coding-principles standard — high-level design
principles, concrete practical rules, and code style/security/dependency/process —
behind the `code/docs/CODING-PRINCIPLES.md` entry point.

## How to work here

- **Routing:** `doc-writer` (Opus) to author; every coding task reads the
  parent guide before writing a line, so keep this the single source of the rules.
- **Model:** Opus for substantive guidance and typos or re-indexing.
- **Concrete steps:** edit the relevant sub-doc (`DESIGN-PRINCIPLES.md`,
  `PRACTICAL-RULES.md`, `STYLE-AND-PROCESS.md`) → keep `CODING-PRINCIPLES.md` a thin
  index and update the `CONTEXT.md` file table on any change → verify length with
  `code/src/scripts/audits/docs-length.sh`.
- **Definition of done:** rules are actionable and match the shipped code; each file
  ≤ 300 lines; cross-references resolve; British English.

## Guardrails

- **300-line instructional limit** per file — split rather than overflow.
- Keep the **750-line source-file limit (800 grace)** stated here consistent with
  `code/CONTEXT.md`; this folder is where that rule and the file-length policy live.
- Language/framework-specific rules belong in `BACKEND-CODING-PRINCIPLES.md` /
  `FRONTEND-CODING-PRINCIPLES.md`; keep the global principles here framework-neutral.

## Output & naming

- **Hand-written** sub-docs only; nothing generated here.
- Files `SCREAMING-SNAKE-CASE.md`; parent guide is `code/docs/CODING-PRINCIPLES.md`.
