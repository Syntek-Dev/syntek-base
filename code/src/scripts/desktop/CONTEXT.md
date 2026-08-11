# code/src/scripts/desktop

The operations that are genuinely specific to the **desktop surface** — launching a window,
producing a release binary, and the one design gate no other group can answer. Present only when
the project was generated with `INCLUDE_DESKTOP`.

**There is no lint, test or dependency-audit script here.** The desktop crate is a member of the
Rust workspace, so `code/src/scripts/rust/lint.sh`, `test.sh` and `audit.sh` already cover it.
Adding desktop-specific duplicates would give two ways to run the same check and one of them would
rot.

**`style-check.sh` is the sole exception, and a principled one.** It asks a question about
**Slint build configuration**, not about Rust: has a style been chosen at compile time, or does
the app ship the stock Fluent default? The Rust group's scripts do not read `build.rs` for a
design decision and should not start; `audits/` is the wrong home because its input is neither
CSS, markup nor prose. Splitting the AI-slop audit by input language put this leg here
(`code/src/scripts/audits/CONTEXT.md` → _The AI-slop family_).

**These run on the HOST, not in Docker** — the third such group, after `mobile/` and `rust/`. A
desktop application needs a display server, which the app container does not have.
`style-check.sh` reads three files and needs no toolchain at all.

## Directory Tree

```text
code/src/scripts/desktop/
├── CONTEXT.md    ← this file
├── CLAUDE.md     ← operating rules
├── _common.sh    ← shared setup — sourced, never called
├── run.sh        ← build and launch the app
├── package.sh    ← release binary, gated on the Slint attribution check
└── style-check.sh ← the desktop leg of the AI-slop audit (a style must be chosen)
```

## Scripts

| Script           | Purpose                                                            | Key flags                     |
| ---------------- | ------------------------------------------------------------------ | ----------------------------- |
| `run.sh`         | Build and launch; warns if no display is available                 | `--release`                   |
| `package.sh`     | Release binary — **fails if `AboutSlint` is gone**                 | —                             |
| `style-check.sh` | A Slint style is chosen in a committed build file, never inherited | `--output` `--quiet` `--path` |

Exit codes follow the house contract: `0` success, `1` the tool reported failure, `2` script error.
`style-check.sh` adds the two-tier reading the slop family uses: a `[gate: warn]` finding is
printed and still exits 0, and an absent desktop surface exits 0 with a note.

## Why `style-check.sh` accepts any style but not an ambient one

From Slint 1.16 the default style is Microsoft Fluent on **every** platform, so an app that
configures nothing ships a stock vendor look on macOS and Linux too. The clause is that a choice
was **made**, not which one — Fluent passes, chosen deliberately in `build.rs`. What does not pass
is a `SLINT_STYLE` exported in a shell or set in a CI job: a look that depends on the environment
of whoever ran the build is precisely the deferral the gate exists to stop. A project that
genuinely ships the platform default on purpose says so with a `style-allow` comment and a reason.

Rule: `code/docs/visual-design/DESKTOP.md`. Compile-step mechanism: `code/docs/desktop/UI-AND-STATE.md`.

## Why `package.sh` checks for `AboutSlint`

The app ships under Slint's **Royalty-free** licence, which permits proprietary and commercially
sold desktop applications at no cost **provided the use of Slint is disclosed**. The `AboutSlint`
widget is that disclosure. Shipping without it is a licence breach, so the check is a build gate
rather than a review note.

The check matches the widget **instantiation** (`AboutSlint {`) after stripping `//` comments —
not the bare word. Both near-misses it guards against leave the string in the file while the
widget is gone: the comment above it explaining the obligation, and the `import { ..., AboutSlint }`
line. Matching the bare word passes in both cases, which is the bug this shape fixes.

It still cannot prove the widget is **reachable** in the running UI, only that it is instantiated
somewhere. After restructuring the UI, confirm by eye. Detail: `code/docs/desktop/LICENSING.md`.

## Cross-references

- `code/src/rust/crates/desktop/` — the crate these scripts drive
- `code/src/scripts/rust/CONTEXT.md` — the workspace-wide lint, test, audit and build
- `code/docs/DESKTOP.md` — the guide

**Last Updated**: <%DATE%>
