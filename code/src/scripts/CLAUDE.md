@./CONTEXT.md

# CLAUDE.md — code/src/scripts/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(tree + subdirectory map, imported above) → this file → the target
subdirectory's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The single sanctioned entry point for **every** development operation — dev-stack
lifecycle, migrations, scaffolding, syntax, tests, audits, backups — each
grouped into a functional subdirectory of `*.sh` scripts.

## How to work here

- **Routing:** these scripts _are_ the routing target for the whole repo — every
  guide and skill points here. **Never invoke `python`, `pnpm`, `pytest`, or
  `docker` directly; always call the matching `*.sh`.** Most Django scripts
  run inside Docker via `docker compose exec`; `audits/` and the two repo-spanning
  formatters (`syntax/format.sh`, `syntax/lint.sh`) run on the host.
- **Model:** Opus to author or change a script (control flow, flags, exit codes)
  and to run an existing one.
- **Concrete steps:** find the right subdirectory (`development/`, `database/`,
  `syntax/`, `tests/`, `audits/`, `deployment/`) → read its `CONTEXT.md` for flags →
  if no script exists for the task, **create one there before proceeding**, never a
  one-off host command → keep flags, exit codes, and report conventions consistent
  with siblings.
- **Definition of done:** script is idempotent where sensible, honours the common
  `--output`/`--quiet`/`--help` conventions, containerised work stays containerised,
  and the subdirectory `CONTEXT.md` is updated.

## Guardrails

- **Scripts are the only interface** — any doc that reaches for a raw `pnpm`/`pip`/
  `python manage.py`/`docker` command is a bug; wrap it in a script instead.
- Secrets via environment only — never hardcode a credential in a script.
- `reports/` output under every subdirectory is gitignored — never commit generated
  reports or backups.
- Scripts are shell, exempt from the 750-line source limit, but keep each focused;
  every new subdirectory under `src/` (including a new script group) needs a
  `CONTEXT.md`.

## Output & naming

- **Hand-written:** all `*.sh` scripts and their `CONTEXT.md` files.
- **Generated / gitignored:** everything under each `reports/` folder.
- Script files `kebab-case.sh`; the internal helper library is `_lib/` (underscore
  prefix, sourced never called); documentation `SCREAMING-SNAKE-CASE.md`.
