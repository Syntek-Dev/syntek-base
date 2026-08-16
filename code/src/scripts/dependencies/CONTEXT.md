# code/src/scripts/dependencies

The one place a dependency moves. Python (uv), JavaScript (pnpm) and Rust (cargo) each have
their own tool and their own idea of what "update" means; this group puts a single command
and a single exit-code contract over all three, so a sweep is a decision someone made rather
than three half-remembered incantations run in the wrong order.

## Directory Tree

```text
code/src/scripts/dependencies/
├── CONTEXT.md   ← this file
├── CLAUDE.md    ← operating rules
└── update.sh    ← report or apply updates across all three ecosystems
```

## Scripts

| Script      | Does                                                                      |
| ----------- | ------------------------------------------------------------------------- |
| `update.sh` | `--check` (default) reports what is out of date; `--apply` re-resolves it |

## Common flags

| Flag                 | Meaning                                                    |
| -------------------- | ---------------------------------------------------------- |
| `--check`            | Report only, change nothing — the default                  |
| `--apply`            | Re-resolve and write the lockfiles                         |
| `--ecosystem NAME`   | `python` · `javascript` · `rust` (repeatable; default all) |
| `--output FORMAT`    | Write a report: `md` · `txt`                               |
| `--output-file PATH` | Override the report path                                   |
| `--quiet`            | Suppress terminal output — requires `--output`             |
| `--help`             | Print usage                                                |

**Exit codes:** `0` up to date or applied · `1` updates available (`--check`) · `2` script error.

## A floor is not a pin

The distinction this group exists to keep straight. Raising `redis>=5.0.0` to `redis>=6.0`
does not install redis 6 — it **forbids redis 5**. What actually gets installed is decided by
the lockfile, and the two disagree more often than anyone expects. This repository has already
paid for that once: CI resolved `ruff` to latest while a developer's host ran 0.14.11, and the
two disagreed about what "formatted" meant.

So a floor is raised **deliberately**, to state the minimum the project supports, and the
re-resolve happens in the same change.

## Latest is not always reachable

A floor is bounded by what the rest of the graph tolerates, not by what the registry calls
latest. `celery[redis]` excludes `redis>=6.5`, so **redis 6.4 is the newest this project can
resolve** — and raising the floor past it does not fail loudly, it silently drags celery
backwards to satisfy the constraint.

`--check` reports the registry's latest; it cannot know what your graph will tolerate. Only a
resolve can, which is why `--apply` re-resolves rather than editing a number.

## Either side of the template boundary

`update.sh` ships, so it runs in a generated project and in syntek-base itself — and the two
differ:

| Here       | In syntek-base                                                                       | In a generated project                    |
| ---------- | ------------------------------------------------------------------------------------ | ----------------------------------------- |
| Python     | `uv.lock` is committed here too, so `--apply` re-resolves it exactly as in a project | Lockfile present; `--apply` re-resolves   |
| JavaScript | `pnpm-lock.yaml` present — behaves normally                                          | Same                                      |
| Rust       | `Cargo.lock` present when the surface exists                                         | Absent entirely on a project without Rust |

## Not what this answers

Three neighbours sit close enough to be confused with this one, and the line between them is
**install** versus **move forward** versus **predict**:

| Question                                          | Owner                                             |
| ------------------------------------------------- | ------------------------------------------------- |
| "Give me the dependencies this project declares"  | `development/install-backend.sh` · `-frontend.sh` |
| "Move the declared dependencies forward"          | **`update.sh`, here**                             |
| "Update pnpm itself and pin it"                   | `development/pnpm-update.sh`                      |
| "What would a **template** update do to my deps?" | `audits/dependency-drift.sh`                      |

The install scripts resolve what is already declared; this group changes what is declared, or
what it resolves to. The drift audit changes nothing at all — it reads an incoming template and
reports, and `template-update.sh` runs it for you before anything is applied.

## Cross-references

- `code/src/scripts/audits/dependency-drift.sh` — what an incoming template update would impose
- `code/src/scripts/development/template-update.sh` — previews an update, and runs that audit
- `how-to/workflows/07-dependency-updates/` — the procedure this script serves
- `code/src/scripts/CONTEXT.md` — the full script-group map
