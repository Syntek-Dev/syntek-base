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
  Claims, a Sources list, and the `ADR-###`/`STORY-PLAN-US###` it Feeds → the consuming ADR or PLAN links
  back to the note by path.
- **Definition of done:** every claim cites a primary source; the note is wired to its decision.

## Guardrails

- **Cite the primary source for every claim.** Blogs and threads are scouts that lead to the
  primary — the citation kept is always the primary.
- **Never quote a source that grants no licence.** Check the licence before writing a verbatim
  line: a source with no `LICENSE` upstream grants nothing, so quoting it here **publishes**
  text there is no permission to publish. Take the fact, re-author the wording, cite the URL.
  A share-alike source (CC-BY-SA) is read as a checklist of concerns and never quoted either
  (`.claude/CLAUDE.md` Section 6). Permissive sources — MIT, Apache-2.0, CC BY — may be quoted
  with attribution, which lands in `README.md` → _Influences_ in the same change.

  > **Why it bites in this folder specifically.** Notes here are committed, so they sync
  > across devices — which means that if the repository is public, a quotation in a note is
  > a quotation published to the world. Reading a source and republishing it are different
  > acts needing different permissions, and the licence check is what separates them.
  > `THIRD-PARTY-NOTICES.md` records the position for every source read.

- **A durable fact not tied to a decision** belongs in `.claude/MEMORY.md`, not a note here.
- **British English (en_GB)**; external primaries indexed in `REFERENCES.md`.

## Output & naming

- **Hand-written** via `/research`; nothing generated.
- Files `<TOPIC>.md` (SCREAMING-KEBAB topic).
