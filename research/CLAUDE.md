@./CONTEXT.md

# CLAUDE.md — research/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree + purpose, imported above) → this file → the `research` skill (`.claude/skills/research/SKILL.md`).

## Purpose (one line)

The committed home for `/research` primary-source notes that feed decisions.

## How to work here

- **Routing:** all writes here run through the `research` skill
  (`.claude/skills/research/SKILL.md`). Model: Opus.
- **Concrete steps:** `/research` writes `<TOPIC>.md` with a Question, Verdict, per-claim cited
  Claims, a Sources list, and the `ADR-###`/`PLAN-US###` it Feeds → the consuming ADR or PLAN links
  back to the note by path.
- **Definition of done:** every claim cites a primary source; the note is wired to its decision.

## Guardrails

- **Cite the primary source for every claim.** Blogs and threads are scouts that lead to the
  primary — the citation kept is always the primary.
- **A durable fact not tied to a decision** belongs in `.claude/MEMORY.md`, not a note here.
- **British English (en_GB)**; external primaries indexed in `REFERENCES.md`.

## Output & naming

- **Hand-written** via `/research`; nothing generated.
- Files `<TOPIC>.md` (SCREAMING-KEBAB topic).
