@./CONTEXT.md

# CLAUDE.md — code/docs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(guide index + tree, imported above) → this file → the target guide's sub-folder
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The coding reference guides — the standards that govern everything in `code/src/`:
principles, testing, security, accessibility, API design, architecture, data,
rendering, performance, encryption, RLS, design tokens, URL strategy, and the
Cloudinary SDK docs. Read the relevant guide _before_ touching the code it governs.

## How to work here

- **Routing:** documentation, not source — no stack skill. Reach for
  `doc-writer` (Opus) when authoring or restructuring a guide. A change
  here almost always trails a code change under `code/src/`: update the guide in the
  same PR so standard and implementation never drift.
- **Model:** Opus for writing or reworking a guide's substance and
  mechanical touches (typo fixes, header/version bumps, re-indexing a moved file).
- **Concrete steps:** edit the `SCREAMING-SNAKE-CASE.md` guide → if it would exceed
  the 300-line limit, split the detail into a `kebab-case/` sub-folder and leave the
  top-level file a thin index that cross-references the parts → keep each sub-folder's
  `CONTEXT.md` file table in step → verify length with
  `code/src/scripts/audits/docs-length.sh` (or the lefthook pre-commit hook — it is not one
  of the eight pre-PR gates).
- **Definition of done:** every instructional `.md` ≤ 300 code lines; entry-point
  guide is an index, not a monolith; cross-references resolve; British English; the
  `CONTEXT.md` index and any parent `REFERENCES.md` list the same set of files.
- **Routing frontmatter:** every guide here carries `type`/`agent`/`skills`/`model` frontmatter — read it first and route to the named agent, skills, and model (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **300-line instructional limit** (`cloc --include-lang=Markdown`) applies to every
  file here — oversized guides must be split, entry point becomes the index.
- **These guides are the source of the non-negotiables** they describe (an explicit
  permission check on every state-changing Django Ninja endpoint, no IDOR, token-first
  CSS, `DEBUG=False`, no `CORS *`, secrets via env, Django's built-in admin at
  `/control/` and never `/admin/`). Keep them consistent with the repository's global
  rules — never let a guide contradict them.
- **Reference scripts, never raw tools:** guides cite `code/src/scripts/**/*.sh`,
  never bare `pnpm`, `pytest`, `python`, `uv`, or `docker` invocations.
- Fenced code blocks carry a language (MD040).

## Output & naming

- **Hand-written:** all guides and sub-docs here.
- **Vendored (do not author):** `cloudinary/*.md` are LLM-context copies installed via
  the skills tool and recorded in `skills-lock.json` — refresh, don't rewrite.
- Guides `SCREAMING-SNAKE-CASE.md`; sub-folders `kebab-case/`; each carries a
  `CONTEXT.md` index and a `CLAUDE.md`.
