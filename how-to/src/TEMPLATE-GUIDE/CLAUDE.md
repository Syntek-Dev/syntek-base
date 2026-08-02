@./CONTEXT.md

# CLAUDE.md — how-to/src/TEMPLATE-GUIDE/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` →
`how-to/src/CONTEXT.md` → this folder's `CONTEXT.md` (tree + reading order, imported
above) → this file.

## Purpose (one line)

The human-facing guides for using this repository as a template — generation, the token
contract in prose, orientation in a generated project, customisation, extension, updating,
and troubleshooting.

## How to work here

- **Routing:** documentation edits → `global-workflow` skill, `doc-writer` agent. A change
  to what the template _does_ (a new token, a changed `_task`, a moved file) must land in
  `copier.yml` first and be reflected here second — never the reverse.
- **Model:** Opus for authoring and restructuring these guides and for mechanical touches
  (link fixes, command corrections, tree updates).
- **Concrete steps:** edit the guide → verify every command by running it → update this
  folder's `CONTEXT.md` tree and reading-order table if you add or remove a file → update
  the pointer table in the root `README.md`, which indexes all fourteen.
- **Definition of done:** every command in the guide has been executed and its output
  matches what is documented; cross-references resolve; British English; the root README
  index and this `CONTEXT.md` both list the file.

## Guardrails

- **These files are excluded from generation** (`copier.yml` → `_exclude`). They are
  written in literal prose and never contain live `<%TOKEN%>` substitutions. Quoting token
  syntax as an example is exactly what they are for — but if you ever move one of these
  files out of this directory, its examples become live template code.
- **Never document a flow you have not run.** These guides are the first thing a new user
  trusts; a wrong command here costs more than a wrong command anywhere else in the repo.
  Generate into `/tmp` and check.
- **`copier.yml` is the source of truth for behaviour**, `../TEMPLATE-TOKENS.md` for the
  token vocabulary. This directory explains and sequences them — it does not redefine them.
  Where a fact belongs to one of those two, link rather than restate.
- **Script-first.** Every operational command resolves to `code/src/scripts/**/*.sh` — never
  a raw `pnpm`/`uv`/`docker`/`python manage.py` invocation. The exceptions are `copier`
  itself, `uvx`, and `install.sh`, which necessarily run before the scripts exist.
- Keep each guide focused and comfortably readable; split rather than sprawl.

## Output & naming

- **Hand-written:** every file here. Nothing is generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`; one topic per file.
- Dates DD/MM/YYYY. Commands in fenced blocks with an explicit language.
