@./CONTEXT.md

# CLAUDE.md — how-to/docs/tooling-guide/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc list, imported above) → this file.

## Purpose (one line)

The internal agents & skills sub-documents — `COMMANDS.md`, `CONFIGURATION.md`, and
`WORKFLOW.md` — split out of the `how-to/docs/TOOLING-GUIDE.md` index to keep each
under the instructional line limit.

## How to work here

- **Routing:** guide authoring → `global-workflow` skill. Always enter via the parent
  index `how-to/docs/TOOLING-GUIDE.md`; edit the sub-doc that owns the topic.
- **Model:** Opus for substantive guide edits and renames and link fixes.
- **Concrete steps:** edit the relevant sub-doc → keep every command a
  `code/src/scripts/**/*.sh` reference → keep the parent index and sub-doc
  cross-links in sync → keep each file ≤ 300 code lines.
- **Definition of done:** the three sub-docs stay coherent with the index; agent and
  skill names match the internal `.claude/agents/` and `.claude/skills/`; British English.

## Guardrails

- **≤ 300 code lines** per file — this folder exists precisely to honour that limit;
  do not let a sub-doc grow back past it.
- **Script-first:** no raw `pnpm`/`uv`/`docker`/`python` commands.
- Do not add files without extending the parent index's file table.

## Output & naming

- **Hand-written:** `COMMANDS.md`, `CONFIGURATION.md`, `WORKFLOW.md`; nothing
  generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`.
