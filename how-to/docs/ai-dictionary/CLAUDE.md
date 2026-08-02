@./CONTEXT.md

# CLAUDE.md — how-to/docs/ai-dictionary/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/docs/CONTEXT.md` →
`how-to/docs/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

The themed sub-documents behind `how-to/docs/AI-DICTIONARY.md` — one file per theme, each a
set of plain-English AI-coding term definitions.

## How to work here

- **Routing:** reference material, not a procedure — glossary edits go through the
  `doc-writer` agent on Opus, loading the `global-workflow` skill. The entry-point index
  (`../AI-DICTIONARY.md`) carries the `type: guide` routing frontmatter; these sub-docs do not.
- **Model:** Opus for adding, rewording, or resplitting a term.
- **Concrete steps:** edit the relevant theme file → keep each term a tight definition plus
  a `**Why it matters:**` line → reference related terms in _italics_, never as hyperlinks
  (they would break) → keep each file ≤ 300 code lines → if a theme outgrows the cap, split
  it and add a row to the index table in `../AI-DICTIONARY.md`.
- **Definition of done:** the term reads clearly in en_GB; every italicised cross-reference
  resolves to a term defined somewhere in the dictionary; the index table lists every file.

## Guardrails

- **≤ 300 code lines** per file (`cloc`); split an oversized theme.
- British English (en_GB); no hyperlinked cross-references between terms (italics only).
- Vendor-neutral reference — no <%PROJECT_SLUG%> secrets, paths, or commands beyond the occasional
  `.claude/` illustration.

## Output & naming

- **Hand-written:** each theme's `SCREAMING-SNAKE-CASE.md`. The index lives one level up.
- Files `SCREAMING-SNAKE-CASE.md`; the folder is `kebab-case/`.
