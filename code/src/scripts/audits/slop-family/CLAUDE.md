@./CONTEXT.md

# CLAUDE.md — audits/slop-family/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(why the family is four scripts, the second axis, the design-time scope — imported above) → this
file → `../CLAUDE.md` for the rules every audit in the folder obeys.

## Purpose (one line)

The rationale behind the AI-slop family's split — `css-slop.sh`, `template-slop.sh`,
`copy-slop.sh`, `render-slop.sh` — kept apart from the register that lists them.

## How to work here

- **Routing:** the scripts live in `../`, not here; a clause change is made in the script whose
  input language it reads, against the marker its guide carries (`code/docs/VISUAL-DESIGN.md`
  Section 6, `how-to/src/BRAND-VOICE.md` Section 4). Registering a member is `../CONTEXT.md`'s.
- **Model:** Opus — changing this argument changes what the family is allowed to become.
- **Concrete steps:** a new clause follows `../CLAUDE.md` → _Adding an audit_. What this folder
  adds is the placement: a clause no member's input language covers gets a sibling, and its
  placement is argued in `CONTEXT.md` here before the script is built.
- **Definition of done:** every member's placement is argued in `CONTEXT.md`, none by exception
  left unstated; `bash code/src/scripts/audits/docs-pairing.sh` exits 0.

## Guardrails

- **The argument lives here and the register routes to it.** `../CONTEXT.md` names the family,
  its members and this folder; restating the argument there reintroduces the duplication this
  folder was created to remove.
- **The family's operating rules are `../CLAUDE.md`'s Guardrails.** Cite them from here; a copy
  in this file is a second owner that drifts.
- **A member placed by anything other than input language says so.** `render-slop.sh` is the one
  today; a second exception is argued in `CONTEXT.md` before it is built, never discovered after.
- **`CONTEXT.md` here ends at or under 100 counted lines**, as `docs-length.sh` counts them — the
  ceiling `code/docs/DOCUMENTATION-LENGTH.md` Section 6 gives a receiving file. Set 03/11/2026,
  when the rationale was relocated here from `../CONTEXT.md` and the file measured 82. Text that
  would push it past is the register being absorbed again; route it back, never raise the figure.
  The ceiling is held at review — no gate enforces it, and `docs-length.sh` passes the file far
  above it.

## Output & naming

- **Hand-written:** this pair only. No script, fixture or report lives in this folder.
