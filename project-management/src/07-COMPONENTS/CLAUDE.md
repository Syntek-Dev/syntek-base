@./CONTEXT.md

# CLAUDE.md — src/07-COMPONENTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the three stages over one deliverable, imported above) → this file → the target sub-folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The component store — per-story component needs (`USER-STORY-IDEAS/`), the unified set they are
merged into (`CONSOLIDATED-IDEAS/`), the per-story record of what shipped (`IMPLEMENTATION/`),
and the one cumulative PDF deliverable in `component-build/`.

## How to work here

- **Routing:** stage 1 from `workflows/07-component-designs/`, stage 2 from
  `workflows/17-consolidate-design-work/`, stage 3 from
  `workflows/21-implementation-documentation/`. Build mechanics: `component-build/CLAUDE.md`.
- **Model:** Fable for component and variant decisions and for consolidation; Opus for
  mechanical touches — running the generator, a wording fix, a rename.
- **Concrete steps:** pick the stage → copy that folder's template → record the components →
  **at consolidation only**, edit the palette in `component-build/components.py` or a
  `section-<name>.tex` partial, run `python3 components.py`, check `--check` passes, and commit
  the `.py`, `section-*.tex`, `.tex`, and `.pdf` together.
- **Definition of done:** the artefact is in the right stage folder and named to convention;
  every component has all states; WCAG 2.2 AA met; palette in step with the brand guide.

## Guardrails

- **The PDF is regenerated at consolidation, not per story.** A stage-1 record states a need; it
  does not touch `component-build/`.
- **Reuse before design.** Check `code/src/django/components/` and the consolidated set first —
  a token override on an existing component beats a new one.
- **Every component carries all states** — default, hover, focus, disabled, error, success,
  empty. A component designed only in its resting state is not designed.
- **WCAG 2.2 AA is a gate.** Focus indicators, contrast, and target size are part of the design,
  not a later pass (`code/docs/ACCESSIBILITY.md`).
- **Never edit `USER-STORY-IDEAS/` once `17` has run.**
- **Keep the palette identical to `../06-BRAND-GUIDE/`** — consolidate the two together.
- **Generated artefacts are never hand-edited** — change `components.py` or a partial and re-run;
  a hand-edit breaks `--check`.
- **Section macros only** — add a new macro to the preamble rather than scattering raw
  `tcolorbox` options through sections.
- **Documentation only** — no application code or secrets. `CONTEXT.md`/`CLAUDE.md` ≤ 300 code
  lines; the generator and its outputs are exempt.

## Output & naming

- **Hand-written:** the stage records from their templates; `component-build/components.py` and
  the `section-<name>.tex` partials.
- **Templates:** `COMP-IDEA-US000-TEMPLATE.md`, `COMP-CONSOLIDATED-000-TEMPLATE.md`,
  `COMP-IMPL-US000-TEMPLATE.md` — the copy sources; do not delete or repurpose.
- **Generated (never hand-edit):** `component-build/components.tex` and `components.pdf`.
- `COMP-IDEA-US###-<DESCRIPTOR>.md` · `COMP-CONSOLIDATED-<FAMILY>.md` ·
  `COMP-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`; stories `US###`; dates DD/MM/YYYY.
