@./CONTEXT.md

# CLAUDE.md — src/06-COMPONENTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what the sheet covers, build layout — imported above) → this file → the
`component-build/` sub-folder's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The component library — delivered as a PDF generated from `component-build/components.py`, which
renders an indicative UI kit from the shared token palette using LaTeX/tcolorbox.

## How to work here

- **Routing:** component work starts from `project-management/workflows/06-component-designs/`
  (`STEPS.md` + `CHECKLIST.md`). All authoring happens in `component-build/components.py` — see
  `component-build/CLAUDE.md` for the build mechanics.
- **Model:** Fable for component/token decisions (which components, variants, states); Opus for
  mechanical touches — running the generator, a version bump, a wording fix.
- **Concrete steps:** edit the palette in `component-build/components.py`, or a
  `section-<name>.tex` partial → run `python3 components.py` → visually check `components.pdf` →
  cross-link the driving `US###` → commit the `.py`, the `section-*.tex`, the `.tex`, and the
  `.pdf` together.
- **Definition of done:** the PDF compiles cleanly and reflects the current tokens;
  `components.py --check` passes; palette in step with the brand guide; British English.

## Guardrails

- **Generated artefacts are never hand-edited.** `components.tex` and `components.pdf` are
  produced from `components.py`; change the source and re-run.
- **Indicative, not production.** This sheet conveys look and feel; the real implementation lives
  in the django-components library (`code/src/django/components/`). Keep it representative, not exhaustive.
- **Token-first, shared palette.** Colours mirror the brand guide's palette and, for values that
  also live in code, the DB-canonical token layer is authoritative (`code/docs/DESIGN-TOKENS.md`).
- **Documentation only** — no application code or secrets. `CONTEXT.md`/`CLAUDE.md` files stay
  ≤ 300 code lines; the generator and its outputs are exempt. Every new directory needs a
  `CONTEXT.md` and a `CLAUDE.md`.

## Output & naming

- **Hand-written:** `component-build/components.py` (the source of truth).
- **Generated (never hand-edit):** `component-build/components.tex` and
  `component-build/components.pdf` — both committed so the deliverable is viewable without a build.
