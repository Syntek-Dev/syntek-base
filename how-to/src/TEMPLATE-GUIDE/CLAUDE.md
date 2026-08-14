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

- **Routing:** documentation edits → `global-workflow` skill, `doc-writer` skill. A change
  to what the template _does_ (a new token, a changed `_task`, a moved file) must land in
  `copier.yml` first and be reflected here second — never the reverse.
- **Model:** Opus for authoring and restructuring these guides and for mechanical touches
  (link fixes, command corrections, tree updates).
- **Concrete steps:** edit the guide → verify every command by running it → update this
  folder's `CONTEXT.md` tree and reading-order table if you add or remove a file → update
  the pointer table in the root `README.md`, which indexes all fifteen numbered guides plus
  `GUIDE-TO-SKILLS.md`. `TEMPLATE-GAPS.md` is deliberately **not** in that index: it is a
  maintainer's register, not a guide for someone using the template, and the only file here
  that `copier.yml` excludes.
- **Counts are claims, and they rot.** Any number written here — questions, workflows, CI
  jobs, folders, scripts — must be re-counted on disk in the same pass that touches the
  sentence around it. A stale count is the failure mode this directory is most prone to,
  because nothing lints prose.
- **Definition of done:** every command in the guide has been executed and its output
  matches what is documented; cross-references resolve; British English; the root README
  index and this `CONTEXT.md` both list the file.

## Guardrails

- **These files ship, and are therefore rendered.** Everything here except
  `TEMPLATE-GAPS.md` lands in a generated project, so Copier runs it through Jinja like any
  other file. **A literal token or delimiter in the prose is live template code** — it
  renders to nothing, or kills generation. Where a guide must quote the syntax, wrap the
  region in a `raw` block, and remember `raw` **cannot nest**: a passage that shows `raw`
  itself has to describe it in words (`15-TROUBLESHOOTING.md` does exactly that).
  Four guides are wrapped today — `04-QUICKSTART`, `06-GENERATION`, `11-CUSTOMISING`,
  `15-TROUBLESHOOTING`. **Generate into `/tmp` after touching any of them.**
- **Never document a flow you have not run.** These guides are the first thing a new user
  trusts; a wrong command here costs more than a wrong command anywhere else in the repo.
  Generate into `/tmp` and check.
- **`copier.yml` is the source of truth for behaviour**, `../TEMPLATE-TOKENS.md` for the
  token vocabulary. This directory explains and sequences them — it does not redefine them.
  Where a fact belongs to one of those two, link rather than restate.
- **The template's own open items go in `TEMPLATE-GAPS.md`, never in the root `GAPS.md`.**
  `GAPS.md` is a **shipped** file — `copier.yml` does not exclude it — so anything written
  there is rendered into every generated project, where syntek-base's internal state is
  meaningless. The root `GAPS.md` stays an empty stub. The same test applies to any
  register: check `_exclude` before writing repo-specific state into a tracked file.
- **Script-first.** Every operational command resolves to `code/src/scripts/**/*.sh` — never
  a raw `pnpm`/`uv`/`docker`/`python manage.py` invocation. The exceptions are `copier`
  itself, `uvx`, and `install.sh`, which necessarily run before the scripts exist.
- Keep each guide focused and comfortably readable; split rather than sprawl.

## Output & naming

- **Hand-written:** every file here. Nothing is generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`; one topic per file.
- Dates DD/MM/YYYY. Commands in fenced blocks with an explicit language.
