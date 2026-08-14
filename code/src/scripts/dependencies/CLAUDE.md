@./CONTEXT.md

# CLAUDE.md — scripts/dependencies/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(scripts, flags, the floor-is-not-a-pin rule, either side of the template boundary —
imported above) → this file.

## Purpose (one line)

The sanctioned entry point for moving a dependency in any of the three ecosystems — Python
(uv), JavaScript (pnpm), Rust (cargo).

## How to work here

- **Routing:** dependency work → the `cicd` skill; procedure of record is
  `how-to/workflows/07-dependency-updates/`. **Never run `uv`, `pnpm` or `cargo` directly to
  move a dependency** — that is what this script is for, and the ban exists because the three
  tools disagree about what "update" means.
- **Model:** Opus, for authoring the script and for running it.
- **Concrete steps:** `update.sh` (reports) → read what moved and decide → `update.sh --apply`
  → **run the suites** (`code/src/scripts/tests/all.sh`) → commit the manifest and the lockfile
  **in the same commit**, never one without the other.
- **Definition of done:** lockfile and manifest agree; the suites pass on the resolved graph;
  any floor raised deliberately carries an inline comment saying why, beside the dependency.

## Guardrails

- **A floor is not a pin, and a raise is never housekeeping.** Raising a floor forbids old
  versions; it does not install new ones. State the reason inline, and re-resolve in the same
  change — the `ruff` 0.11 → 0.16 comment in the root `pyproject.toml` is the worked example.
- **Never raise a floor to "latest" without resolving.** Latest is bounded by the rest of the
  graph. `celery[redis]` excludes `redis>=6.5`, so a floor of `redis>=8` does not fail — it
  silently drags celery back three minors to satisfy itself. Prove it with a resolve.
- **Never commit a manifest without its lockfile.** They are one change. A manifest that moved
  alone is a claim nothing verified.
- **`--apply` is not a gate pass.** It rewrites lockfiles and nothing else; the suites decide
  whether the new graph works.
- **This script never edits a version number for you.** Choosing a floor is a judgement about
  what the project supports, and a script that guessed it would be making that judgement
  silently.
- Shell scripts are exempt from the 750-line source limit; keep this one focused all the same.

## Output & naming

- **Hand-written:** `update.sh`, this file, `CONTEXT.md`.
- **Generated / gitignored:** reports under `code/src/scripts/reports/`.
- Script files `kebab-case.sh`; documentation `SCREAMING-SNAKE-CASE.md`.
