@./CONTEXT.md

# CLAUDE.md — .ai/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(shared entry points and ownership, imported above) → this file → `INSTRUCTIONS.md`.
Codex reads the imported file explicitly through `AGENTS.md`.

## Purpose (one line)

Maintain the shared AI loading contract and links to the existing project sources.

## How to work here

- **Routing:** load `doc-writer` and `global-workflow` for instructional changes; follow
  `code/docs/DOCUMENTATION-PAIRING.md` for the local pair.
- Keep `INSTRUCTIONS.md` focused on context loading and host interpretation. Route
  engineering standards to their existing manual, guides and workflows.
- Verify changed references and link targets through both `.ai/` and the provider's
  entry point. Update this folder's orientation when its contents or ownership change.
- **Definition of done:** the entry points resolve to the same sources, host-specific
  behaviour is identified, and no copy of project memory or a skill body is introduced.

## Guardrails

- Keep `.ai/MEMORY.md` and `.ai/skills/` as links during this compatibility phase.
  Respect the physical sources' own operating rules when editing through them.
- Treat provider model names and tool identifiers as runtime metadata; preserve the
  workflow's requirements when describing their interpretation in another host.
- Do not claim that adding a file activates a host feature or ports a Claude hook.
- Coordinate any ownership migration with the affected audits, discovery paths and
  template generation rules. Project memory remains specific to the receiving project.

## Output & naming

- **Hand-written:** `INSTRUCTIONS.md`, `CONTEXT.md` and this file.
- **Links:** `MEMORY.md` and `skills/`; the physical targets retain their existing names.
- Follow `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` for documentation style.
