@./CONTEXT.md

# CLAUDE.md — code/docs/desktop/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/docs/CONTEXT.md` →
`code/docs/DESKTOP.md` → this folder's `CONTEXT.md` (which document, when — imported above) →
this file.

## Purpose (one line)

The two sub-documents behind `code/docs/DESKTOP.md` — the Slint licence obligation, and the UI,
state, threading and accessibility conventions of the desktop crate.

## How to work here

- **Routing:** reference guides, not code. The `stack-slint` skill reads them; `security` cites
  `LICENSING.md` at release time; `doc-writer` maintains the prose.
- **Model:** Opus for substantive changes and mechanical touches alike.
- **Concrete steps:** change the sub-document → check `DESKTOP.md`'s sub-document table still
  describes it → check the `stack-slint` skill has not drifted → update this `CONTEXT.md` if a
  file is added or removed.
- **Definition of done:** routing frontmatter present; each file ≤ 300 code lines;
  cross-references resolve; British English.

## Guardrails

- **Never soften the attribution rule into a suggestion.** It is a condition of the licence grant,
  enforced by `package.sh`. Prose that reads as advice invites someone to delete the widget.
- **Never state the licence position more confidently than the text supports.** These documents
  read the licence; they are not legal advice, and they say so. Keep that caveat.
- **Keep the two exclusions prominent** — embedded systems, and redistributing anything exposing
  Slint's APIs. The second is the reason desktop UI is not in the shared package layer; losing it
  loses the rationale for a whole architectural boundary.
- **Do not present accessibility as optional or as scanned.** AccessKit is why two advisories are
  accepted; verification is manual, with a screen reader.
- Commands cite `code/src/scripts/**/*.sh` — never raw `cargo` or `slint-viewer`.

## Output & naming

- **Hand-written:** every file here. Nothing is generated.
- Documentation `SCREAMING-SNAKE-CASE.md`; this is the `desktop/` sub-document family of
  `code/docs/DESKTOP.md`.
