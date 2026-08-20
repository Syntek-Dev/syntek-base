# code/src/scripts/syntax

Code quality scripts for linting, type-checking, and formatting — across every surface the
project has, not just the Django one.

**Execution context.** The Python tools — ruff and basedpyright — run in the `django` container,
which mounts the Django source. Everything else runs on the **host**: Prettier, markdownlint-cli2
and ESLint via `pnpm exec`, because no dev container mounts the whole tree (the `django` container
only mounts `code/src/django`, so it cannot see `project-management/`, `how-to/`, or the root
docs); and the mobile and Rust toolchains because those are pinned on the host by design. This
mirrors the lefthook pre-commit gate, which also runs Prettier, markdownlint and ESLint on the
host. The host therefore needs the workspace `pnpm`/Node (already required to commit).

**These three scripts aggregate; they do not reimplement.** For the mobile and Rust surfaces they
delegate to that surface's own owner — `scripts/mobile/*.sh` and `scripts/rust/*.sh` — which
remain what CI and lefthook invoke directly. The aggregate exists so one command covers every
surface a project has; the owner exists so a surface can be driven alone, with its own flags.

## Directory Tree

```text
code/src/scripts/syntax/
├── check.sh                 ← type-check Python (basedpyright), TypeScript (tsc), Rust (cargo check)
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── format.sh                ← format Python (ruff), JS/TS/CSS/Markdown/JSON (Prettier), Rust (rustfmt)
├── lint.sh                  ← lint Python (ruff), Markdown (markdownlint-cli2), JS/TS (ESLint), Rust (clippy)
└── reports/                 ← generated report output (all gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script      | Tool(s)                                          | Purpose                                             |
| ----------- | ------------------------------------------------ | --------------------------------------------------- |
| `lint.sh`   | ruff check · markdownlint-cli2 · ESLint · clippy | Lint Python, Markdown, JavaScript, TypeScript, Rust |
| `check.sh`  | basedpyright · tsc · cargo check                 | Type-check Python, TypeScript, Rust                 |
| `format.sh` | ruff format · Prettier · rustfmt                 | Format Python, JS, TS, CSS, Markdown, JSON, Rust    |

## File types — one token per language

`--file-type` names a **language**, and each script applies whatever tooling that language has
here. Repeat the flag for more than one.

| Token        | Surface                                         | `lint.sh`              | `check.sh`     | `format.sh` |
| ------------ | ----------------------------------------------- | ---------------------- | -------------- | ----------- |
| `python`     | Django (`code/src/django/`)                     | ruff                   | basedpyright   | ruff format |
| `javascript` | **Web** — Alpine and enhancement scripts        | ESLint (root config)   | — not typed    | Prettier    |
| `typescript` | **Mobile** — `code/src/mobile/`                 | ESLint (mobile config) | `tsc --noEmit` | Prettier    |
| `rust`       | **Native** — `code/src/rust/`, desktop included | rustfmt + clippy       | `cargo check`  | rustfmt     |
| `markdown`   | repo-wide                                       | markdownlint-cli2      | — not typed    | Prettier    |
| `css`        | repo-wide — **`format.sh` only**                | — rejected, see below  | — not typed    | Prettier    |

**`lint.sh` rejects `--file-type css`.** No CSS linter is configured, so a `css` lint token
could only ever print an informational line and pass — which reads as a clean result over a
population nothing examined. `format.sh` owns CSS and still takes the token.

`javascript` and `typescript` name **different surfaces and never overlap**: the root ESLint
config ignores `code/src/mobile/`, and TypeScript exists nowhere else in the tree. `check.sh`
rejects `javascript` outright rather than accepting it as a no-op — the web surface has no
type-checker, and saying so is more useful than an empty pass.

**A bare run covers exactly the surfaces present.** `typescript` joins the default set only when
`code/src/mobile/` exists, and `rust` only when `code/src/rust/` does, so the same unscoped
command is correct on a web-only project and on one carrying all three. Naming an absent surface
explicitly exits `2`: a check that could not run is never reported as a check that came back
clean.

The one asymmetry, and it is deliberate. `format.sh`'s `typescript` is **not** gated on the mobile
surface, because Prettier — unlike ESLint and `tsc` — needs nothing from that workspace, and
TypeScript ships outside it in one place: the four audit self-test specimens under
`audits/fixtures/`. Those ship to a web-only project too, since `dict-discipline.sh` and
`negative-space.sh` both refuse to `--self-test` without them. Gating the token would leave those
four formatted by nothing here.

`--path` scopes the tools that can be scoped. The delegated owners lint their workspace as a
unit, so a `--path` run drops `typescript` and `rust` and **names what it dropped**; combining
`--path` with an explicit `--file-type typescript` or `rust` is an error rather than a silent
narrowing.

## Common Flags

| Flag                 | Description                                                            |
| -------------------- | ---------------------------------------------------------------------- |
| `--fix`              | Apply safe automatic fixes (lint/format) or print fix guidance (check) |
| `--unsafe-fix`       | Apply safe + unsafe fixes — ruff only (`lint.sh`)                      |
| `--file-type TYPE`   | Restrict to one or more languages — see the table above                |
| `--output FORMAT`    | Write a report file: `md` `txt` `json` `html`                          |
| `--output-file PATH` | Override the default report output path                                |
| `--quiet`            | Suppress terminal output — requires `--output`                         |
| `--path PATH`        | Restrict to a specific file or directory                               |
| `--help`             | Print usage                                                            |

## Exit Codes

- `0` — clean / all formatted / no changes
- `1` — issues found / formatting needed / type errors
- `2` — script error (bad arguments, containers not running, an absent surface named explicitly)
- `3` — **every leg that ran was clean, and at least one leg could not run.** Not a pass. The
  summary names which legs and why, and every `--output` report carries the same verdict plus an
  `unrun` field. Non-zero deliberately, so a caller treating any non-zero as failure fails
  closed. Rule: `code/docs/GATE-REPORTING.md`

## Reports

Generated reports are written to `reports/` and gitignored by default.

**Every report carries the same verdict the terminal shows, plus what the run did not cover** —
`unrun` (legs that could not run), `dropped_by_path` (types `--path` could not scope) and
`surfaces_absent` (types left out because the project has no such surface). The scope a run
actually had is a property of the artefact, not only of the screen: a persisted report naming
`file_types` alone states the post-drop set as though it were the set asked for.
Default filenames: `lint-report.<FORMAT>`, `check-report.<FORMAT>`, `format-report.<FORMAT>`.

## Dependencies

The Python steps run inside the `django` container and skip with a warning when it is down, so a
run with the stack stopped is partial rather than broken. Starting the stack:

```bash
bash code/src/scripts/development/server.sh up
```

Prettier, markdownlint and ESLint run on the host, so a run that excludes `python` works with the
stack down — it only needs the workspace `pnpm`. `--path` accepts a file, a glob, or a directory
(directories are widened to a recursive glob for Prettier/markdownlint).

The delegated surfaces carry their own prerequisites and fail hard rather than skipping: the
mobile scripts require `code/src/mobile/node_modules` (`scripts/mobile/install.sh`), and the Rust
scripts require `cargo` on the host, pinned by `code/src/rust/rust-toolchain.toml`.

**The Rust leg's prerequisite is the one that cannot be checked in advance**, and all three
scripts treat it accordingly. A container is up or it is not and `pnpm` is on `PATH` or it is not,
but a Cargo workspace cannot be known to build without building it — cargo on `PATH` says nothing
about the system libraries its dependencies link against. So the precondition here is the owner's
**exit code**: `scripts/rust/lint.sh` and `scripts/rust/build.sh` both exit `2` when they produced
no result at all (cargo absent, rustfmt missing from the pinned toolchain, or a workspace that
would not build), the aggregate files that leg as could-not-run and the whole run becomes `3`,
quoting the owner's own error line so the summary names the missing dependency rather than saying
"rust lint failed".

`check.sh`'s Rust leg is the one that inverts. `cargo check` **is** the type gate, so a rustc
diagnostic against `code/src/rust/` is this leg's finding and exits `1` — it is a run that never
reached our crates that produces no result and becomes `3`. Reading it the other way round would
either hide a real type error or report an absent system library as broken code. The owner draws
that distinction; the aggregate only reads the code it chose.

## Cross-references

- `code/src/scripts/mobile/CONTEXT.md` — the mobile owner these delegate to
- `code/src/scripts/rust/CONTEXT.md` — the Rust owner these delegate to
- `project-management/docs/git/COMMITS.md` — the pre-commit gate that invokes them
