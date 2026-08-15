@./CONTEXT.md

# CLAUDE.md — crates/desktop/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the licence obligation, the house-constant constraint — imported above) → this file →
`code/docs/DESKTOP.md`.

## Purpose (one line)

The native Slint application — a separate deployable consuming this project's JSON API, with
its own release cycle inside the shared Rust workspace.

## How to work here

- **Routing:** `stack-slint` skill (Opus). **Read the licence terms before anything else** —
  what the app must disclose decides what it may ship.
- **Model:** Opus.
- **Concrete steps:** edit `ui/app.slint` for markup and the design globals → wire behaviour
  in `src/main.rs` → run and package through `code/src/scripts/desktop/*.sh` → keep the tree
  in `CONTEXT.md` matching disk.
- **Definition of done:** the AboutSlint attribution is present; no panicking path in
  hand-written code; the window is reachable through AccessKit; `cargo-deny` clean.

## Guardrails

- **The AboutSlint attribution stays.** It is the disclosure the Royalty-free tier requires
  in exchange for free commercial use. Removing it moves the project to a paid licence.
- **Never panic in hand-written code.** A panic kills the user's window with nothing they can
  act on. The crate's lint table denies `unwrap`, `expect`, `panic!` and slice indexing.
- **The generated-code allow stays scoped to the module that holds it.** `include_modules!()`
  pastes machine-generated code that uses `unwrap()` freely; confining it to its own module
  is what keeps the strict table live for code we wrote. Moving that allow to crate root
  silently disarms the lint everywhere.
- **Keep AccessKit enabled.** It is the accessibility layer Slint ships; turning it off makes
  the app unreadable to a screen reader with no visible symptom.
- **Never rename the `[[bin]]` to a template token** — `rustc` validates it as an identifier,
  and a token makes the entire workspace uncompilable. Branding happens at packaging time.
- **Never invoke `cargo` or `slint` tooling directly** — use `code/src/scripts/desktop/*.sh`.
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** `src/main.rs`, `ui/app.slint`, `build.rs`, `Cargo.toml`.
- **Generated (never hand-edit):** the Rust produced from `.slint` by `build.rs`, and
  `target/`.
- The crate and binary name is the house constant `desktop`; Slint components `PascalCase`,
  Rust functions `snake_case`.
