@./CONTEXT.md

# CLAUDE.md — src/04-DATABASE/ERD-DIAGRAMS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(diagram naming, imported above) → this file.

## Purpose (one line)

Rendered entity-relationship diagram images — one `erd-<domain>.png` per schema domain,
exported from the `## ERD (Mermaid)` section of a `DB-<FEATURE>-DD-MM-YYYY.md` design doc.

## How to work here

- **Model:** Opus — this is a re-export step, not design work. The modelling decisions
  belong one level up in the `DB-<FEATURE>-DD-MM-YYYY.md` schema-design doc.
- **To update a diagram:** change the Mermaid source in the design doc one level up, then
  re-export the affected `erd-<domain>.png` here. **Never edit a PNG directly** — the
  image is a derived artefact and must match its source.

## Guardrails

- **Generated only** — no hand-drawn images; every PNG traces back to a Mermaid source.
  If a diagram and the schema disagree, the schema doc wins; re-render.
- Re-export only the domains a schema change touches; leave unrelated PNGs untouched.
- Filename must match the domain it depicts — a stale or mislabelled `erd-*.png` misleads
  readers about the model.

## Output & naming

- **Generated:** `erd-<domain>.png` — kebab-case domain slug (e.g. `erd-users-auth.png`).
  Nothing here is hand-authored.
