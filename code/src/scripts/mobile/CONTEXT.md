# code/src/scripts/mobile

Every development operation for the **mobile surface**. Present only when the project was
generated with the mobile app; a web-only project has no such directory, and one `_exclude` entry
removes the whole group so no orphan script can survive a rename.

**These scripts run on the HOST, not in Docker.** That is a deliberate exception to the
containerised-everything rule, and it is forced rather than chosen: Expo Go runs on a physical
device, and a device on the LAN cannot reach a `127.0.0.N` loopback alias. Metro must therefore be
reachable on the network, which containerising fights rather than helps. "The stack" is Docker
plus this one host process, so Node and pnpm are explicit host prerequisites.

## Directory Tree

```text
code/src/scripts/mobile/
├── CONTEXT.md      ← this file
├── CLAUDE.md       ← operating rules
├── _common.sh      ← shared setup — sourced, never called
├── install.sh      ← install workspace dependencies / verify the lockfile
├── server.sh       ← start Metro for Expo Go (host process)
├── lint.sh         ← ESLint the mobile tree
├── typecheck.sh    ← tsc --noEmit
├── test.sh         ← jest-expo + React Native Testing Library
└── bundle.sh       ← export the JS bundles — where CI stops
```

## Scripts

| Script         | Purpose                                           | Key flags                            |
| -------------- | ------------------------------------------------- | ------------------------------------ |
| `install.sh`   | Install dependencies; `--check` verifies the lock | `--check`                            |
| `server.sh`    | Start Metro and print the Expo Go QR code         | `--clear` `--tunnel` `--port N`      |
| `lint.sh`      | ESLint with the mobile config                     | `--fix`                              |
| `typecheck.sh` | TypeScript type-check                             | `--watch`                            |
| `test.sh`      | Run the suite; enforce the coverage floors        | `--coverage` `--watch` `--path PATH` |
| `bundle.sh`    | Export iOS and Android JS bundles                 | `--platform ios\|android`            |

Exit codes follow the house contract: `0` success, `1` the tool reported failure, `2` script
error.

## Why a stack-keyed directory

The scripts tree is otherwise organised **by operation** (`syntax/`, `tests/`, `development/`).
This is the first directory keyed by **stack**, and the exception is deliberate. The per-operation
alternative needs a `mobile-*` glob across four directories and fails silently the day someone
misses one; a single directory is removed wholesale by one `_exclude` entry, so an orphan is
structurally impossible.

## Metro ports and parallel worktrees

Metro joins each story's **existing** reserved port block rather than inventing a second isolation
scheme: port `8081` on `main`, and `8081 + <story number>` inside a `us###` worktree. Parallel
worktrees therefore never collide on Metro any more than they do on nginx. Override with
`--port` when needed. Worktree conventions: `how-to/docs/GIT-WORKTREES.md`.

## Where the aggregates delegate

`syntax/check.sh` and `tests/all.sh` both **guard on this directory existing** and delegate to it
when present, so "check everything" and "test everything" stay honest on a mobile project without
either script gaining templated contents. On a web-only project the guard is false and nothing
changes.

## Cross-references

- `code/src/mobile/CONTEXT.md` — the application these scripts drive
- `code/src/scripts/CONTEXT.md` — the full scripts tree and the containerisation rule
- `how-to/docs/GIT-WORKTREES.md` — the per-story isolation scheme Metro's port joins

**Last Updated**: <%DATE%>
