# code/src/scripts/desktop

The two operations that are genuinely specific to the **desktop surface** — launching a window and
producing a release binary. Present only when the project was generated with `INCLUDE_DESKTOP`.

**There is no lint, test or audit script here.** The desktop crate is a member of the Rust
workspace, so `code/src/scripts/rust/lint.sh`, `test.sh` and `audit.sh` already cover it. Adding
desktop-specific duplicates would give two ways to run the same check and one of them would rot.

**These run on the HOST, not in Docker** — the third such group, after `mobile/` and `rust/`. A
desktop application needs a display server, which the app container does not have.

## Directory Tree

```text
code/src/scripts/desktop/
├── CONTEXT.md    ← this file
├── CLAUDE.md     ← operating rules
├── _common.sh    ← shared setup — sourced, never called
├── run.sh        ← build and launch the app
└── package.sh    ← release binary, gated on the Slint attribution check
```

## Scripts

| Script       | Purpose                                            | Key flags   |
| ------------ | -------------------------------------------------- | ----------- |
| `run.sh`     | Build and launch; warns if no display is available | `--release` |
| `package.sh` | Release binary — **fails if `AboutSlint` is gone** | —           |

Exit codes follow the house contract: `0` success, `1` the tool reported failure, `2` script error.

## Why `package.sh` checks for `AboutSlint`

The app ships under Slint's **Royalty-free** licence, which permits proprietary and commercially
sold desktop applications at no cost **provided the use of Slint is disclosed**. The `AboutSlint`
widget is that disclosure. Shipping without it is a licence breach, so the check is a build gate
rather than a review note.

The check is deliberately crude — it greps `ui/` for the identifier. It cannot prove the widget is
reachable in the running UI, only that nobody deleted it. After restructuring the UI, confirm by
eye. Detail: `code/docs/desktop/LICENSING.md`.

## Cross-references

- `code/src/rust/crates/desktop/` — the crate these scripts drive
- `code/src/scripts/rust/CONTEXT.md` — the workspace-wide lint, test, audit and build
- `code/docs/DESKTOP.md` — the guide

**Last Updated**: <%DATE%>
