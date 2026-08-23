# crates/desktop — The Native Slint Application

**Desktop-only.** A native binary the user runs on their own OS, talking to the Django Ninja
API at `/api/` exactly as any third-party client would. It is a **peer of the web surface,
not a layer on it** — it never renders a Django template.

It lives inside the Rust workspace rather than in a tree of its own because it is Rust: it
shares the toolchain pin, the `deny.toml` supply-chain policy, and the clippy config. A
separate _surface_ (its own delivery target and release cycle) inside a shared _workspace_.

**Last Updated**: <%DATE%>

## Directory Tree

```text
desktop/
├── Cargo.toml    ← crate manifest, the `slint` pin, and the strict lint table
├── build.rs      ← compiles ui/app.slint into Rust at build time, and pins the style
├── src/          ← the crate source — Cargo's own layout
│   └── main.rs   ← the entry point, and the walled-off module holding generated UI code
├── ui/           ← Slint markup, compiled into Rust by build.rs rather than shipped as data
│   └── app.slint ← the window: markup, plus the Palette and StyleMetrics globals
├── CONTEXT.md    ← this file
└── CLAUDE.md     ← operating rules
```

## The licence is the first fact, not a footnote

Slint's Royalty-free tier permits free commercial use **in exchange for a disclosure** — the
AboutSlint attribution shipped in the UI. Removing it is a licensing decision, not a design
one, and it moves the project onto a paid tier. Read the licensing terms before shipping or
selling anything built here.

## Why `desktop` is a house constant

`rustc` validates a crate name as an **identifier**, and `<`, `%` and `>` are not legal in
one. A template token here would not merely read oddly before generation — it would make the
whole workspace uncompilable, so `cargo clippy --workspace` could never be proven in the
template itself. The branded executable is still produced: the packaging script renames the
artefact after the build, where the name is a filename rather than a grammar.

## Cross-references

- `code/src/rust/CONTEXT.md` — the Rust surface: workspace layout, house constants
- `code/docs/DESKTOP.md` — the licence obligation, the generated-code lint boundary,
  threading, and AccessKit accessibility
