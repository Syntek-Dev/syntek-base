@./CONTEXT.md

# CLAUDE.md — code/docs/rust/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/docs/CONTEXT.md` →
`code/docs/RUST.md` → this folder's `CONTEXT.md` (which document, when — imported above) → this
file.

## Purpose (one line)

The three sub-documents behind `code/docs/RUST.md` — the PyO3 boundary, memory hygiene for secret
material, and the crate supply-chain gate.

## How to work here

- **Routing:** reference guides, not code. The `rust` agent reads them; `security` cites
  `SUPPLY-CHAIN.md` and `MEMORY-HYGIENE.md` at audit time; `doc-writer` maintains the prose.
- **Model:** Opus for substantive changes and mechanical touches alike.
- **Concrete steps:** change the sub-document → check `RUST.md`'s sub-document table still
  describes it accurately → check the `stack-rust` skill has not drifted from it → update this
  `CONTEXT.md` if a file is added or removed.
- **Definition of done:** every file carries the `type`/`agent`/`skills`/`model` routing
  frontmatter; each stays ≤ 300 code lines; cross-references resolve; British English.

## Guardrails

- **Do not soften the three rules into advice.** "Never panic across the boundary", "secrets
  zeroize and never render", and "every dependency is a supply-chain decision" are enforced by
  lint tables and `deny.toml` — the prose must match what the tooling actually does.
- **Keep the limits honest.** `MEMORY-HYGIENE.md` states what zeroize does _not_ cover (copies,
  swap, core dumps). Never trim that section to make the guarantee look stronger; overstating it
  stops people reaching for the real mitigation.
- **Never restate the workflow.** Procedure lives in `code/workflows/12-rust-extension/`; these
  documents explain the reasoning it depends on.
- Commands cite `code/src/scripts/rust/*.sh` — never raw `cargo`, `maturin` or `clippy`.

## Output & naming

- **Hand-written:** every file here. Nothing is generated.
- Documentation `SCREAMING-SNAKE-CASE.md`; this folder is the `rust/` sub-document family of
  `code/docs/RUST.md`.
