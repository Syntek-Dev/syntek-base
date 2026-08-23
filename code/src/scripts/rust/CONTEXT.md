# code/src/scripts/rust

Every development operation for the **Rust surface**. Present only when the project was generated
with `INCLUDE_RUST`; one `_exclude` entry removes the whole group, so no orphan script can survive
a rename.

**These scripts run on the HOST, not in Docker** — the second deliberate exception to the
containerised-everything rule, after `mobile/`. The toolchain is pinned by
`code/src/rust/rust-toolchain.toml`, so a host run and the image's build stage compile with the
same compiler. Containerising `cargo` would add a rebuild to every edit for no isolation gain,
because the artefact is a native module the local interpreter has to load anyway. `rustup` is
therefore an explicit host prerequisite on a Rust project.

## Directory Tree

```text
code/src/scripts/rust/
├── CONTEXT.md   ← this file
├── CLAUDE.md    ← operating rules
├── _common.sh   ← shared setup + the cargo-result classifier — sourced, never called
├── build.sh     ← compile the workspace; install the extension into the venv
├── test.sh      ← the Rust-side test suite
├── lint.sh      ← rustfmt + clippy at -D warnings (--fmt-only for rustfmt alone)
└── audit.sh     ← cargo-deny: advisories, licences, bans, sources
```

## Scripts

| Script     | Purpose                                                | Key flags             |
| ---------- | ------------------------------------------------------ | --------------------- |
| `build.sh` | Compile and install the extension into the venv        | `--release` `--check` |
| `test.sh`  | Run the workspace's Rust tests                         | `--path NAME`         |
| `lint.sh`  | `cargo fmt --check` and clippy with warnings as errors | `--fix` `--fmt-only`  |
| `audit.sh` | Supply-chain gate against `code/src/rust/deny.toml`    | `--update`            |

Exit codes follow the house contract: `0` success, `1` the tool reported failure, `2` script
error. Each script hard-fails with an install hint when a toolchain binary is missing, rather than
letting `cargo` emit a bare "not found".

**`2` also covers a workspace that would not build**, and `lint.sh` and `build.sh` both depend on
it: cargo spends one exit code (`101`) on a diagnostic it raised and on a build script that
panicked over a missing system library, and those are not the same result — the first is a finding
about the code, the second is no finding at all. Both tell them apart with the shared classifier in
`_common.sh` (`_cargo` captures the output, `_workspace_was_diagnosed` asks whether anything in
_this_ workspace was diagnosed, `_no_build_reason` names the cause), and both report the second as
`2` with that cause, so `syntax/lint.sh`, `syntax/format.sh` and `syntax/check.sh` can file the leg
as COULD NOT RUN.

**What each does with the answer differs, and that is the point.** For `lint.sh` a workspace that
will not build is never a lint finding — clippy read nothing. For `build.sh` the opposite holds:
`cargo check` _is_ the type gate, so rustc diagnosing our own code is exactly the result asked for
and exits `1`. One shared question, two verdicts, one home for the question. Rule:
`code/docs/GATE-REPORTING.md`; the reasoning is in each script's header.

## Two test suites, both required

`test.sh` runs the **Rust** tests. The tests that exercise the extension _through its PyO3
boundary_ are pytest tests and run through `code/src/scripts/tests/`. Both must pass: a crate can
be entirely correct in Rust and still expose a broken boundary — wrong signature, a panic that
should have been a `PyResult`, a `__repr__` that leaks a secret.

## Why a stack-keyed directory

The scripts tree is otherwise organised **by operation** (`syntax/`, `tests/`, `development/`).
This is the second directory keyed by **stack**, after `mobile/`, and for the same reason: a
per-operation split needs a `rust-*` glob across four directories and fails silently the day
someone misses one, whereas a single directory is removed wholesale by one `_exclude` entry, so an
orphan is structurally impossible.

## Cross-references

- `code/src/rust/CONTEXT.md` — the workspace these scripts drive
- `code/src/scripts/CONTEXT.md` — the full scripts tree and the containerisation rule
- `code/docs/rust/SUPPLY-CHAIN.md` — what `audit.sh` is defending against, and why

**Last Updated**: <%DATE%>
