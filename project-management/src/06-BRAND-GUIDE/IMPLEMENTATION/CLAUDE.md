@./CONTEXT.md

# CLAUDE.md — src/06-BRAND-GUIDE/IMPLEMENTATION/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `src/06-BRAND-GUIDE/CONTEXT.md` →
this folder's `CONTEXT.md` (stage-3 scope, the literal check — imported above) → this file.

## Purpose (one line)

Stage-3 per-story records — one `BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` confirming the
tokens a story consumed exist in the token layer and match `../CONSOLIDATED-IDEAS/`.

## How to work here

- **Routing:** written during `workflows/22-implementation-documentation/` by the `doc-writer`
  skill against the consolidated set and the shipped CSS.
- **Model:** Opus — verifying tokens landed is mechanical. Escalate to `frontend` (Fable) only
  where a deviation needs judging.
- **Concrete steps:** copy `BRAND-IMPL-US000-TEMPLATE.md` →
  `BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` → confirm each consumed token exists in the
  DB-canonical token layer (`code/docs/DESIGN-TOKENS.md`) and resolves in the token CSS → **run
  `bash code/src/scripts/audits/css-tokens.sh` and record the result** → justify any deviation.
- **Definition of done:** every consumed token verified present and resolving; the token audit
  recorded clean (or its failures routed); deviations justified; British English.

## Guardrails

- **Record the audit result, do not assert it.** "Token-first observed" without
  `css-tokens.sh` output is a claim, not evidence.
- **A raw literal in component CSS is a defect**, not a shortcut — route it to
  `../../21-BUGS/` and fix it in `code/`.
- **A token used but absent from the consolidated set is a deviation.** Say whether the
  consolidation missed it or the build invented it: consolidation gap → `../../20-FINDINGS/`,
  invented token → `../../21-BUGS/`.
- **Record, never fix** — corrections land in `code/`, not here.
- **Never rename or back-date a filed record.**
- **Documentation only** — no CSS, no secrets.
- One record per story.

## Output & naming

- **Hand-written:** one `BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per story, from the
  template.
- **Template:** `BRAND-IMPL-US000-TEMPLATE.md` — the copy source; do not delete.
- **Generated:** none — `../guide-build/` is not touched at this stage.
- Descriptor `SCREAMING-KEBAB-CASE` (reuse the stage-1 one); story `US###`; date `DD-MM-YYYY`.
