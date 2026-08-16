@./CONTEXT.md

# CLAUDE.md — how-to/src/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` → this folder's
`CONTEXT.md` (tree + what-is-here, imported above) → this file → the target sub-folder's
`CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The human-facing operator guides that do not fit the instructional-doc limits — the contributing
and code-quality standard (`CONTRIBUTING.md`), the base-template contract and its guide set
(`TEMPLATE-TOKENS.md`, `TEMPLATE-GUIDE/`), the two `/scale-planning` snapshots, and the
`NIXOS-SETUP.md` pointer stub.

## How to work here

- **Routing:** contributing-standard edits and every other operator guide here → the
  `runbook` skill (`.claude/skills/runbook/`); procedure of record is
  `how-to/workflows/09-write-operator-guide/`. (Not `doc-writer`, whose own remit is
  `code/docs/*` — operator guides are a different audience and a different length standard.) The
  template contract and guides → see `TEMPLATE-GUIDE/CLAUDE.md`. The two architecture snapshots →
  the `scale-planning` skill via `/scale-planning` (each has its own `CLAUDE.md`). Server
  provisioning → the `<%DEPLOY_REPO%>` repository.
- **Model:** Opus for substantive guide edits and for mechanical touches (renames, command and
  link fixes); Fable where the snapshot directories say so.
- **Concrete steps:** edit the guide → keep every developer command aligned with
  `code/src/scripts/**/*.sh` and the coverage floors (75 % / 90 % auth) → keep branch and commit
  rules in step with `project-management/docs/GIT-GUIDE.md` → update this folder's `CONTEXT.md`
  tree if the structure changed.
- **Definition of done:** commands verified against the scripts and Compose files; cross-references
  resolve; British English; docs hard gate satisfied before any commit.

## Guardrails

- **These are `**/src/\*.md`operator guides — the sanctioned exception to the 300-line
  instructional limit.** Write them for humans, in full. The`CONTEXT.md`/`CLAUDE.md` pairs here
  and in each sub-directory still keep within it.
- **`TEMPLATE-TOKENS.md` and `TEMPLATE-GUIDE/` ship, and are therefore rendered.** `copier.yml`
  `_exclude`s exactly one file in this tree — `TEMPLATE-GUIDE/TEMPLATE-GAPS.md` — so everything
  else lands in a generated project and Copier runs it through Jinja like any other file. A
  literal token or block delimiter written into their prose is **live template code**: it renders
  to nothing, or kills generation outright. Wrap any region that must show the syntax in a Jinja
  `raw` block, and generate into `/tmp` before committing. Per-file detail, including which four
  guides are wrapped today: `TEMPLATE-GUIDE/CLAUDE.md`.
- **Never commit secrets or real credentials** — dev accounts live in the gitignored
  `code/src/docker/.env.dev`; reference `.env.*.example` templates only.
- **Licence compatibility:** this project is licensed <%LICENCE%>. Do not introduce dependencies
  incompatible with it — where that licence is commercial or proprietary, GPL/AGPL needs prior
  written approval (per the Licensing section of `CONTRIBUTING.md`).
- **Script-first.** Every operational command resolves to `code/src/scripts/**/*.sh`. The one
  sanctioned exception is the template guide set, which necessarily documents `copier`, `uvx` and
  `install.sh` — they run before the scripts exist.

## Output & naming

- **Hand-written:** every file here. Nothing is generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`; sub-directories `SCREAMING-SNAKE-CASE/`.
- **Template discipline:** project-specific values are double-angle tokens drawn from
  `TEMPLATE-TOKENS.md`; the standard stack and house engineering standards stay literal.

  > **This file is rendered by Copier.** Writing a token's delimiters literally in prose here
  > makes Jinja try to parse them, and generation fails with `TemplateSyntaxError`. If you must
  > show the syntax, wrap the example in a `raw` block — or describe it in words, as above.
  > **There is nowhere in this tree that is free of this.** `TEMPLATE-GUIDE/` is rendered too;
  > the one file `copier.yml` excludes is `TEMPLATE-GUIDE/TEMPLATE-GAPS.md`, and it is a
  > maintainer's register rather than a place to write examples.
