# Syntek project instructions for Codex

Read [`.ai/INSTRUCTIONS.md`](.ai/INSTRUCTIONS.md) before starting a task. Follow its
loading order, including the current project manual, project memory, root references,
and the `CONTEXT.md` / `CLAUDE.md` pair for each area being changed.

## Codex compatibility

- Read referenced files explicitly. Claude's `@` imports and folder `CLAUDE.md` files
  are instructions to load context here; do not assume Codex has already loaded them.
- Discover project skills through `.agents/skills/`. Shared access is available through
  `.ai/skills/`; both resolve to the same existing skill definitions. Load the matching
  `SKILL.md` and its relevant references before following a workflow.
  Flat graph cards and roster files are reference documents, not additional skills.
- Interpret Claude model names, tool names and skill frontmatter using the host mapping
  in `.ai/INSTRUCTIONS.md`. Use the model and tools available in the current Codex
  session; `model: opus` is not a Codex model selection.
- Codex runtime and MCP settings live in `.codex/config.toml`. Claude settings,
  permissions, hooks, plugins and browser integration do not configure Codex.
  Apply the documented project checks explicitly when the current host has no hook.
- The project config adds `CLAUDE.md` as an instruction fallback when Codex loads a
  directory's instructions. Still read the scoped pairs for the files being changed;
  launching at the repository root does not load every descendant manual.
- Keep existing user authorisation in scope. Ask only for an unresolved decision or
  permission the host actually requires; a change of coding tool does not restart
  clarification or approval already settled in this conversation.

`.ai/` is the shared entry point for this compatibility phase. The current project
manual, skill bodies and project memory retain their existing physical locations
under `.claude/`; follow the shared instructions before editing those sources.

Project settings load only when Codex trusts the project. Start a fresh session after
installing this setup so it can discover the skills and settings. The configured MCP
servers need `uvx` and `npx` on the host; Context7 receives `CONTEXT7_API_KEY` from the
launching environment, with no secret value stored in the repository.
