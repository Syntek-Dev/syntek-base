@./CONTEXT.md

# CLAUDE.md — scripts/syntax/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script inventory, flags, execution context — imported above) → this file →
`reports/`.

## Purpose (one line)

The code-quality entry point — `lint.sh`, `check.sh`, and `format.sh` wrap ruff,
basedpyright, markdownlint-cli2, and Prettier across the Django source and the
repo-spanning Markdown/CSS.

## How to work here

- **Routing:** any syntax or type fix routes through these three scripts (the
  `syntax` agent targets them); **never invoke `ruff`, `prettier`, `basedpyright`,
  or `pnpm` directly.** The Python tools run in the `django` container; the two
  repo-spanning tools (Prettier via `format.sh`, markdownlint via `lint.sh`) run on
  the **host** via workspace `pnpm`.
- **Model:** Opus to author or change a script (flags, exit codes, tool wiring)
  and to run one against the tree.
- **Concrete steps:** dev stack up (`development/server.sh up`) so containerised
  tools are reachable → `lint.sh` / `check.sh` / `format.sh`, narrowing with
  `--file-type`, `--path`, or `--fix` as needed → resolve to exit `0`. A
  Markdown-only run works with the stack down (host `pnpm` only).
- **Definition of done:** all three exit `0`; any `--output` report lands in
  `reports/`; scripts keep the shared `--fix`/`--quiet`/`--output`/`--help`
  conventions consistent with siblings.

## Guardrails

- **Keep containerised tools containerised and host tools on the host** — do not
  "simplify" a container step into a raw host command; the `django` container
  cannot see the rest of the tree, so repo-spanning Prettier/markdownlint must stay
  on the host.
- **This is not a formatting-preference dial** — mirror the lefthook pre-commit gate,
  never diverge tool config from it.
- Exit-code contract is load-bearing: `0` clean, `1` issues, `2` script error — CI
  depends on it; never mask a failure into `0`.
- Shell scripts are exempt from the 750-line source limit but stay focused.

## Output & naming

- **Hand-written:** `lint.sh`, `check.sh`, `format.sh`, this file, `CONTEXT.md`.
- **Generated (gitignored):** `reports/<script>-report.<FORMAT>`.
- Script files `kebab-case.sh`; documentation `SCREAMING-SNAKE-CASE.md`.
