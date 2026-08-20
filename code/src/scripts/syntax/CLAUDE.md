@./CONTEXT.md

# CLAUDE.md — scripts/syntax/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script inventory, flags, execution context — imported above) → this file →
`reports/`.

## Purpose (one line)

The code-quality entry point — `lint.sh`, `check.sh`, and `format.sh` wrap ruff,
basedpyright, markdownlint-cli2, Prettier and ESLint across the Django source and the
repo-spanning Markdown/CSS, and **delegate** to the mobile and Rust owners for those
two surfaces.

## How to work here

- **Routing:** any syntax or type fix routes through these three scripts (the
  `syntax` skill targets them); **never invoke `ruff`, `prettier`, `basedpyright`,
  `eslint`, `tsc`, `cargo` or `pnpm` directly.** The Python tools run in the `django`
  container; everything else runs on the **host** — Prettier, markdownlint and ESLint
  via workspace `pnpm`, and the mobile and Rust toolchains under their own pins.
- **One token per language, and it names the language, not the tool.** `javascript` is
  the **web** surface (Alpine and the enhancement scripts, root ESLint config);
  `typescript` is the **mobile** surface; `rust` is the Cargo workspace. They never
  overlap — the root config ignores `code/src/mobile/`. Full table:
  `CONTEXT.md` → _File types_.
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
- **Aggregate, never reimplement.** The `typescript` and `rust` legs shell out to
  `scripts/mobile/*.sh` and `scripts/rust/*.sh`, which stay canonical for CI and
  lefthook. Adding a surface here means calling its owner, never copying its tool
  invocation — two spellings of one command is the drift this split exists to prevent.
  If the owner exposes the wrong granularity, give the owner a flag (as `rust/lint.sh`
  gained `--fmt-only`) rather than reaching past it.
- **A surface that is absent is an error, not a skip.** An explicitly requested
  `--file-type` whose surface is missing exits `2`. Never warn-and-exit-`0`: "could not
  look" filed as "looked, and it was clean" is the defect these scripts exist to catch.
- **A surface that is present but unusable is a leg that could not run** — a different case,
  and it belongs in `UNRUN`, never in `OVERALL_EXIT=1`. A delegated owner says so with exit
  `2`; check that code before treating non-zero as findings, and take the **reason** from the
  owner's own error line rather than re-deriving it from its tool's output, because the
  aggregate delegates the tool's dialect along with its invocation.
- **This is not a formatting-preference dial** — mirror the lefthook pre-commit gate,
  never diverge tool config from it.
- **Exit-code contract is load-bearing: `0` clean, `1` issues, `2` script error, `3` at
  least one requested leg could not run.** Never mask a failure into `0`, and never let a
  leg that did not run reach `0` either — `3` exists so "could not look" cannot be read as
  "looked, and it was clean". It is non-zero deliberately, so a caller treating any non-zero
  as failure fails closed. Rule and rationale: `code/docs/GATE-REPORTING.md`.
  (The previous wording justified this contract with "CI depends on it". That was false when
  written and is still false: nothing automated invokes these scripts — the seven references
  across `.github/`, `.claude/hooks/` and `lefthook.yml` are advice strings and one human
  checkbox. The contract survives on its merits, which are the reader's, not CI's.)
- Shell scripts are exempt from the 750-line source limit but stay focused.

## Output & naming

- **Hand-written:** `lint.sh`, `check.sh`, `format.sh`, this file, `CONTEXT.md`.
- **Generated (gitignored):** `reports/<script>-report.<FORMAT>`.
- Script files `kebab-case.sh`; documentation `SCREAMING-SNAKE-CASE.md`.
