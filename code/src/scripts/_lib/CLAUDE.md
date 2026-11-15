@./CONTEXT.md

# CLAUDE.md — scripts/\_lib/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(helper inventory, imported above) → this file.

## Purpose (one line)

The internal bash helper library — shared utilities that other scripts **source**, never
invoke directly. Full inventory: `CONTEXT.md`.

## How to work here

- **Model:** Opus to author or change a helper (it is shared control flow that every
  sibling script depends on); Opus for a trivial rename.
- **Concrete steps:** add functions to an existing helper or a new `*.sh` here →
  callers pull it in with `source` → keep helpers side-effect-free at load time (no
  work on source, only on function call) so sourcing stays cheap and safe.
- **Definition of done:** helper is idempotent when sourced twice, exposes functions
  not top-level statements, and the `CONTEXT.md` inventory lists it.

## Guardrails

- **Sourced, never executed** — nothing here is a user-facing entry point; do not add
  a `main`-style script to `_lib/`.
- Changing a helper touches every script that sources it — check callers before
  altering a function signature or return convention.
- **A pattern with two enforcers belongs here, not copied into both.** `conflict-markers.sh`
  exists because the two detectors for one defect class had drifted apart, and the weaker copy
  was the one running where it mattered. Adding a third caller means sourcing it, never
  reproducing the regex.
- **`posture-guard.sh` is the one caller contract here that returns a verdict, not output.**
  `posture_guard ROOT MODE OVERRIDE COMPOSE_NAME [INVOCATION...]` returns `0` to permit and `4`
  to refuse, writes any refusal to stderr prefixed `posture-guard: refused —`, and never calls
  `exit` — a new return contract for `_lib/`, whose other helpers return `0` and signal on
  stdout. Its contract block in the file header is authoritative; these are the caller's duties:
  - **The policy is the helper's.** A caller declares `refuse` or `warn` and passes its parsed
    `--force-posture` value; what refuses at which posture, and what the override may waive, is
    never restated or re-decided in a caller.
  - **Branch on the status and terminate** — `posture_guard ... || exit "$?"`, then
    `posture_docker_bind || exit "$?"`. No call site discards the status or continues past `4`.
    A `warn` caller never sees `4`, and binds only when `posture_target_valid` is `1`.
  - **The repository root is the first positional argument** — the caller's
    `BASH_SOURCE`-derived root. It is the test seam (`database/migrate.sh --self-test` aims it at
    a fixture tree); never add an environment variable for it.
  - **Docker calls on a guarded path go through the validated binding** — `posture_docker` from
    `posture_docker_bind`, never a bare `docker`, so the target cannot be re-resolved after the
    check; across a shell-out the child gets `posture_endpoint` as its only Docker selection.
  - **`COMPOSE_NAME` comes from `posture_compose_name`** over the caller's full compose set.
  - **A new guarded caller joins the self-test's wiring assertions** in
    `database/_migrate-self-test.sh`, and `migrate.sh --self-test` must stay green.
- Secrets via environment only.

## Output & naming

- **Hand-written:** the `*.sh` helpers only.
- Files `kebab-case.sh`; the `_lib/` name (underscore prefix) deliberately marks the
  folder as internal.
