# Bun as the package manager — the config and CLI contracts the gates would rest on

**Written**: 11/09/2026 · **Driver**: research node N-001 on
`project-management/src/01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md` · **Feeds**: that map's N-003, N-006,
N-007, N-009, N-012, N-014, N-015, N-017, N-019, N-020 and N-024 — and, through slice S-01, the
ADR its story authors (unassigned)

**Read against:** oven-sh/bun `main` at [`6b394bf`][base] (11/09/2026). The latest release is
bun-v1.4.2 (05/09/2026); every cited source file is identical to it, or differs only by
path-buffer lines outside the cited ranges. Each leg was answered by one agent and re-checked
against the same primary source by an independent refuter; all twelve survived. Nothing below is
quoted — Bun is MIT, but the wording is re-authored so no attribution row is owed.

## Question

What do Bun's configuration discovery, manifest enforcement and CLI exit contracts actually do —
the facts syntek-base's supply-chain gates would rest on once Bun replaces pnpm?

## Verdict

**Bun can carry the package-manager half, but most of the fail-loud behaviour pnpm gives this
repository for free is absent, so the repository's own gates would have to rebuild it.** Bun ignores
`engines` and `packageManager`; has no strict-peer mode and prints no deprecation warnings; takes
audit ignores on the command line only, matches them by substring, and says nothing when one is
stale; exits 1 from `bun audit` for findings **and** for a registry failure; exits 0 from
`bun outdated` and `bun pm untrusted` whatever they find; passes a frozen install that has no
lockfile at all; and never lets a project's `bunfig.toml` reach `bunx`. Age-gate excludes match
names, never versions. No release through 1.4.2 fixes the frozen-lockfile false-pass class.

**What is solid:** install-family commands find the workspace root **before** reading
`bunfig.toml`, so root `[install]` settings govern an install run from `code/src/mobile` — provided
the root `package.json` declares `workspaces`, which it does not today. An edited override, a catalog
change or a new on-disk workspace fails a frozen install. `bun ci` is exactly a frozen install. The
default trusted list, and the rule that declaring one replaces it, are fixed and documented.

---

## 1. Where configuration is read from

| Claim                                                                                                                                                                                              | Primary source                                                         |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| Bun never walks up the tree for `bunfig.toml`: the loader joins the bare filename to one directory                                                                                                 | [arguments.rs L136-233][args]                                          |
| `install`, `add` and `remove` first resolve the workspace root — the nearest `package.json`, then any parent whose `workspaces` globs claim it — change directory there, and only then load config | [PackageManager.rs L1568-1850][pm-root]                                |
| So the root `[install]` block (age gate, linker, frozen) applies to an install run from a member, and a member-level `bunfig.toml` is not read — **if** the root declares `workspaces`             | [PackageManager.rs L1568-1850][pm-root]                                |
| This repository's root `package.json` has no `workspaces` key; membership lives in `pnpm-workspace.yaml`. As things stand, Bun would treat `code/src/mobile` as its own root                       | `package.json`, `pnpm-workspace.yaml` (read 11/09/2026)                |
| `.npmrc` is read from the resolved root plus the home directory; precedence is `.npmrc` below `bunfig.toml` below the CLI                                                                          | [PackageManager.rs L1924-1962][pm-npmrc]                               |
| `bun run` reads `bunfig.toml` from the current directory only, and no global file — a root `[run]` block does not reach a script run from a member                                                 | [run_command.rs L2323-2331][run-cfg] · [bunfig docs][bunfig-doc]       |
| A walk-up for `bun run` is proposed, not shipped                                                                                                                                                   | [PR #29310][pr29310] (open) · [#4112][i4112] (open)                    |
| `bunx` loads no project `bunfig.toml`: a local `[run] bun = true` is ignored, and only `bunx --bun` (or `-b`) forces Bun's runtime                                                                 | [bunx_command.rs L82-160][bunx-parse]                                  |
| The install `bunx` spawns runs in a temporary directory and sees only the **global** `bunfig.toml` and `.npmrc` — the project's age gate and registry never reach a package `bunx` fetches         | [bunx_command.rs L1323-1371][bunx-spawn] · [PR #36696][pr36696] (open) |

## 2. What the manifest enforces

| Claim                                                                                                                                                   | Primary source                                                                                                        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `engines` is ignored — a struct slot exists, nothing reads or enforces it, and there is no `engine-strict` option                                       | [npm.rs L713-714][npm-engines] · [#5846][i5846] (open request)                                                        |
| `packageManager` is ignored — no reader exists anywhere in the install or run paths                                                                     | [#23573][i23573] (open request)                                                                                       |
| There is no strict-peer mode: an unmet or out-of-range peer produces a warning, never a failure, and no `[install]` key or `.npmrc` option changes that | [PackageManagerEnqueue.rs L1840-1849][peer-warn] · [L2551-2606][peer-incorrect] · [bunfig.rs L1352-1564][bunfig-keys] |
| **One exception:** when every version satisfying a required peer falls inside the age gate, the install exits 1 (observed on a 1.4.0 canary)            | [PR #38995][pr38995] (open, would downgrade it to a warning)                                                          |
| No deprecation warnings are printed — the manifest parser does not read the field — so pnpm's `allowedDeprecatedVersions` has nothing to map to         | [#6883][i6883] (open) · [PR #35457][pr35457] (open)                                                                   |

## 3. What `bunx` fetches and runs

| Claim                                                                                                                                                        | Primary source                                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `bunx` looks in `node_modules/.bin`, then its cache, and otherwise **auto-fetches** through a spawned `bun add`; cache entries are re-checked after 24 hours | [bunx docs][bunx-doc] · [bunx_command.rs L1323-1371][bunx-spawn]                                                                     |
| A fetched package's lifecycle scripts run only if it is on Bun's default trusted list                                                                        | [CommandLineArguments.rs L98][cla-help] · [lifecycle docs][lifecycle-doc] · [PR #19637][pr19637] (open, would trust `bunx` packages) |
| `bunx` has no `--ignore-scripts`; an unknown flag before the package name is dropped silently; `npm_config_ignore_scripts` is read nowhere                   | [bunx_command.rs L82-160][bunx-parse]                                                                                                |
| Only a **global** `ignoreScripts` in `bunfig.toml`, or `ignore-scripts` in the home `.npmrc`, reaches the spawned install                                    | [ini lib.rs L1446-1448][ini-scripts]                                                                                                 |
| `--no-install` exists though the `bunx` page omits it: with nothing cached, `bunx` exits 1 rather than fetching                                              | [bunx.test.ts L415-512][bunx-test]                                                                                                   |

## 4. The CLI contracts a gate would read

### `bun audit`

| Claim                                                                                                                                                                  | Primary source                                                                                             |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `--audit-level` takes `low`, `moderate`, `high` or `critical`, in either the `=` or the space form; an invalid value exits 1                                           | [CLI args L351-361][audit-flags] · [L1505-1525][audit-level] · [clap L99-111][clap-eq]                     |
| `--ignore` is repeatable and **CLI-only** — no `bunfig.toml`, `package.json` or config key exists                                                                      | [audit docs L31-67][audit-doc] · [PR #21833][pr21833]                                                      |
| An ignore matches the numeric advisory id exactly, **or any substring of the advisory URL** — so a GHSA id works, a CVE id does not, and a short token over-suppresses | [audit_command.rs L995-1016][audit-keep]                                                                   |
| An ignore that matches nothing is a silent no-op — no warning, no error                                                                                                | [audit_command.rs L995-1016][audit-keep]                                                                   |
| `--json` prints the registry's raw response, **unfiltered** by level or ignore; the GHSA id exists only inside `url`; a clean result prints an empty object            | [audit_command.rs L171-234][audit-json] · [tests L428-509][audit-test-json] · [#31009][i31009] (open)      |
| The ignored count appears only on the clean summary line; the findings summary carries severity counts alone                                                           | [audit_command.rs L60-85][audit-clean] · [L1123-1233][audit-summary]                                       |
| Exit 1 means surviving findings **or** a default-registry failure **or** a missing lockfile; a scoped registry that fails is skipped with a warning at exit 0          | [audit_command.rs L691-791][audit-send] · [tests L800-846][audit-test-reg] · [L585-599][audit-test-scoped] |

### `bun outdated`

| Claim                                                                                                                         | Primary source                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| Exit 0 whether or not anything is outdated; exit 1 only for a missing manifest or lockfile, or a failed required fetch        | [outdated_command.rs L56-116][outdated-missing] · [L163-198][outdated-exit] · [tests L8605-8700][outdated-test]  |
| The default scope is the **current workspace only**; `-r` covers all, `-F`/`--filter` is repeatable, and there is no `--json` | [CLI args L337-349][outdated-flags] · [L1004-1016][outdated-help] — the filter docs claim otherwise; source wins |

### `bun pm untrusted` and `bun pm trust`

| Claim                                                                                                                                                  | Primary source                                                              |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- |
| `untrusted` exits 0 whether or not scripts were blocked; findings go to stdout, and there is no `--json`                                               | [pm_trusted_command.rs L44-206][untrusted] · [dispatcher L549-557][pm-exit] |
| It reads scripts from `node_modules`, so an absent tree or package reports zero — a **false clean**                                                    | [lifecycle tests L3799-3838][untrusted-test]                                |
| The install summary itself reports how many postinstalls were blocked — a second signal a gate can read                                                | [lifecycle tests L3799-3838][untrusted-test]                                |
| `trust` runs the blocked scripts and **writes** `package.json` and the lockfile, exiting 1 when there is nothing to trust — it is never a gate command | [pm_trusted_command.rs L217-329][trust]                                     |

### `bun ci` and the frozen install

| Claim                                                                                                                                                                                 | Primary source                                                                                                                                                                      |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bun ci` is exactly `bun install --frozen-lockfile`; `CI=1` does not imply frozen, `--production` does                                                                                | [mod.rs L997-999][ci-alias] · [CLI args L1294-1295][ci-frozen] · [registry tests L961-1045][frozen-reg-test]                                                                        |
| With **no** `bun.lock`, a frozen install resolves from `package.json`, installs, writes no lockfile and exits 0                                                                       | [install_with_manager.rs L787-829][frozen-check] · [install docs L167-179][install-doc]                                                                                             |
| With a foreign lockfile such as `pnpm-lock.yaml` and no `bun.lock`, it migrates and **writes** `bun.lock`, even when frozen                                                           | [install_with_manager.rs L2164-2196][frozen-migrate]                                                                                                                                |
| Fails at exit 1, lockfile untouched: an edited dependency, an added, edited or trimmed override, a catalog change, a missing listed workspace, a new on-disk workspace a glob matches | [install tests L7437-7548][frozen-test] · [overrides tests L137-161][overrides-test] · [missing-workspace tests L33-70][missing-ws-test] · [pruned tests L1237-1272][pruned-new-ws] |
| Passes: a workspace in `bun.lock` that is absent on disk (with a note), and adding or removing `patchedDependencies` or `trustedDependencies`                                         | [pruned tests L451-597][pruned-test]                                                                                                                                                |
| Known false passes on stock Bun: a same-version dependency added to a second workspace, a retyped range that resolves the same, a dependency moved between groups                     | [#22689][i22689] (open) · [PR #41931][pr41931] (open)                                                                                                                               |

## 5. The age gate, and what no release has fixed

| Claim                                                                                                             | Primary source                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| The age gate affects new resolution only; entries already in `bun.lock` are untouched — **documented**, not a bug | [install docs L300][age-doc] · [#30525][i30525] (closed, nothing merged) · [PR #30526][pr30526] (closed unmerged) |
| `bun update --latest` bypassing the gate for transitive dependencies is unfixed                                   | [#25305][i25305] (open)                                                                                           |
| Excludes compare the package name only; a `name@version` entry never matches                                      | [npm.rs L1559-1568][age-exclude] · [#28967][i28967] (open) · [PR #37909][pr37909] (open)                          |
| `bun ci` re-applying the gate to an already-locked version, and failing, is open against 1.4.0                    | [#40031][i40031] (open)                                                                                           |
| The frozen false-pass report was closed as a duplicate; its fix was closed unmerged; the replacement is open      | [#24223][i24223] · [PR #33632][pr33632] · [PR #41931][pr41931]                                                    |

## 6. The lockfile, and the names it records

| Claim                                                                                                                                                          | Primary source                                                            |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `lockfileVersion` runs 0 to 3: v2 exists only on the 1.4 line (stricter integrity and git-tag rules); v3 means scoped override rules are present               | [bun.lock.rs L97-119][lock-enum] · [PR #38333][pr38333]                   |
| A loaded lockfile below v3 without scoped overrides keeps its version; a fresh one is walked down to v2 or v1; v3 is written only while scoped overrides exist | [bun.lock.rs L227-298][lock-write]                                        |
| Bun older than 1.4 cannot read v3, and Turborepo rejected v3 when it shipped                                                                                   | [PR #38333][pr38333]                                                      |
| `bun.lock` records the root package's `name` and every member's — so a root named with the `<%PROJECT_SLUG%>` token is written into the lockfile as-is         | [bun.lock.rs L1254-1284][lock-names]                                      |
| The root name is not validated at install; only folder-safety rules apply to package entries — **accepted per source, unproven until run**                     | [Package.rs L2205-2214][pkg-name] · [dependency.rs L537-553][safe-folder] |

## 7. The trust list, and the release line

| Claim                                                                                                                                                              | Primary source                                                           |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| The default trusted list has 367 entries, unchanged across 1.3.14, 1.4.0 and 1.4.2; it holds esbuild, lefthook, msw and sharp, but not protobufjs or unrs-resolver | [default-trusted-dependencies.txt][trusted-list]                         |
| Declaring `trustedDependencies` **replaces** the default list; an empty array disables it                                                                          | [lifecycle docs L58-62][lifecycle-replace] · [PR #31027][pr31027]        |
| Auto-trust was narrowed to npm-registry packages in **1.3.5**, not 1.4                                                                                             | [PR #25163][pr25163] · [1.3.5 release post][blog135]                     |
| Bun 1.4.0 shipped 20/08/2026; the latest release is bun-v1.4.2 (05/09/2026), with no 1.5 tag                                                                       | [bun-v1.4.0][rel140] · [bun-v1.4.2][rel142] · [1.4 release post][blog14] |

---

## What only a run can settle

These are tracer legs, not research; each is folded into the map node named.

- A root `package.json` named with the token installs, and a fresh `bun.lock` is written as v2 — **N-007**.
- Once `workspaces` is declared, an install from `code/src/mobile` applies the root age gate and linker — **N-007**.
- `bunx` ignores a local `[run] bun = true`, and does not run a non-trusted package's postinstall — **N-012**.
- `bun audit` returns the same findings as `pnpm audit` on the same graph — **N-006**.
- Whether 1.4's transitive re-resolution honours the age gate ([#25305][i25305]) — **N-009**.

## Sources

All source, test and docs paths are in oven-sh/bun at [`6b394bf`][base], fetched 11/09/2026.
Issues, pull requests and releases were read through the GitHub API the same day.

- **Source** — `src/bunfig/`, `src/install/` (PackageManager, lockfile, npm, dependency),
  `src/runtime/cli/` (audit, outdated, bunx, pm, run), `src/ini/`, `src/clap/`
- **Tests** — `test/cli/install/`: bun-audit, bun-install, bun-install-registry, overrides,
  frozen-lockfile-pruned, frozen-lockfile-missing-workspace, bun-install-lifecycle-scripts, bunx
- **Docs** — `docs/runtime/bunfig.mdx`; `docs/pm/`: cli/install, cli/audit, bunx, lifecycle
- **Issues and pull requests** — as linked in each table
- **Releases** — bun-v1.4.0, bun-v1.4.2, and the 1.3.5 and 1.4 release posts

## Feeds

`project-management/src/01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md` — research node **N-001**, resolved
11/09/2026 by this note. Its findings reshape N-003 (four controls to rebuild), N-006, N-007, N-009,
N-012, N-014, N-015, N-017, N-019, N-020 and N-024. The ADR that slice S-01's story authors links
back here.

[base]: https://github.com/oven-sh/bun/tree/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf
[args]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/bunfig/arguments.rs#L136-L233
[pm-root]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager.rs#L1568-L1850
[pm-npmrc]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager.rs#L1924-L1962
[run-cfg]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/run_command.rs#L2323-L2331
[bunfig-doc]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/docs/runtime/bunfig.mdx
[pr29310]: https://github.com/oven-sh/bun/pull/29310
[i4112]: https://github.com/oven-sh/bun/issues/4112
[bunx-parse]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/bunx_command.rs#L82-L160
[bunx-spawn]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/bunx_command.rs#L1323-L1371
[pr36696]: https://github.com/oven-sh/bun/pull/36696
[npm-engines]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/npm.rs#L713-L714
[i5846]: https://github.com/oven-sh/bun/issues/5846
[i23573]: https://github.com/oven-sh/bun/issues/23573
[peer-warn]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/PackageManagerEnqueue.rs#L1840-L1849
[peer-incorrect]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/PackageManagerEnqueue.rs#L2551-L2606
[bunfig-keys]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/bunfig/bunfig.rs#L1352-L1564
[pr38995]: https://github.com/oven-sh/bun/pull/38995
[i6883]: https://github.com/oven-sh/bun/issues/6883
[pr35457]: https://github.com/oven-sh/bun/pull/35457
[bunx-doc]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/docs/pm/bunx.mdx
[cla-help]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/CommandLineArguments.rs#L98
[lifecycle-doc]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/docs/pm/lifecycle.mdx
[pr19637]: https://github.com/oven-sh/bun/pull/19637
[ini-scripts]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/ini/lib.rs#L1446-L1448
[bunx-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bunx.test.ts#L415-L512
[audit-flags]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/CommandLineArguments.rs#L351-L361
[audit-level]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/CommandLineArguments.rs#L1505-L1525
[clap-eq]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/clap/streaming.rs#L99-L111
[audit-doc]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/docs/pm/cli/audit.mdx#L31-L67
[pr21833]: https://github.com/oven-sh/bun/pull/21833
[audit-keep]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/audit_command.rs#L995-L1016
[audit-json]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/audit_command.rs#L171-L234
[audit-test-json]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bun-audit.test.ts#L428-L509
[i31009]: https://github.com/oven-sh/bun/issues/31009
[audit-clean]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/audit_command.rs#L60-L85
[audit-summary]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/audit_command.rs#L1123-L1233
[audit-send]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/audit_command.rs#L691-L791
[audit-test-reg]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bun-audit.test.ts#L800-L846
[audit-test-scoped]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bun-audit.test.ts#L585-L599
[outdated-missing]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/outdated_command.rs#L56-L116
[outdated-exit]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/outdated_command.rs#L163-L198
[outdated-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bun-install-registry.test.ts#L8605-L8700
[outdated-flags]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/CommandLineArguments.rs#L337-L349
[outdated-help]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/CommandLineArguments.rs#L1004-L1016
[untrusted]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/pm_trusted_command.rs#L44-L206
[pm-exit]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/package_manager_command.rs#L549-L557
[untrusted-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bun-install-lifecycle-scripts.test.ts#L3799-L3838
[trust]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/pm_trusted_command.rs#L217-L329
[ci-alias]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/runtime/cli/mod.rs#L997-L999
[ci-frozen]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/CommandLineArguments.rs#L1294-L1295
[frozen-reg-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bun-install-registry.test.ts#L961-L1045
[frozen-check]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/install_with_manager.rs#L787-L829
[install-doc]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/docs/pm/cli/install.mdx#L167-L179
[frozen-migrate]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/PackageManager/install_with_manager.rs#L2164-L2196
[frozen-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/bun-install.test.ts#L7437-L7548
[overrides-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/overrides.test.ts#L137-L161
[missing-ws-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/frozen-lockfile-missing-workspace.test.ts#L33-L70
[pruned-new-ws]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/frozen-lockfile-pruned.test.ts#L1237-L1272
[pruned-test]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/test/cli/install/frozen-lockfile-pruned.test.ts#L451-L597
[i22689]: https://github.com/oven-sh/bun/issues/22689
[pr41931]: https://github.com/oven-sh/bun/pull/41931
[age-doc]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/docs/pm/cli/install.mdx#L300
[i30525]: https://github.com/oven-sh/bun/issues/30525
[pr30526]: https://github.com/oven-sh/bun/pull/30526
[i25305]: https://github.com/oven-sh/bun/issues/25305
[age-exclude]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/npm.rs#L1559-L1568
[i28967]: https://github.com/oven-sh/bun/issues/28967
[pr37909]: https://github.com/oven-sh/bun/pull/37909
[i40031]: https://github.com/oven-sh/bun/issues/40031
[i24223]: https://github.com/oven-sh/bun/issues/24223
[pr33632]: https://github.com/oven-sh/bun/pull/33632
[lock-enum]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/lockfile/bun.lock.rs#L97-L119
[pr38333]: https://github.com/oven-sh/bun/pull/38333
[lock-write]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/lockfile/bun.lock.rs#L227-L298
[lock-names]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/lockfile/bun.lock.rs#L1254-L1284
[pkg-name]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/lockfile/Package.rs#L2205-L2214
[safe-folder]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/dependency.rs#L537-L553
[trusted-list]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/src/install/default-trusted-dependencies.txt
[lifecycle-replace]: https://github.com/oven-sh/bun/blob/6b394bfeb0ce69d6668a8aecb648b5c5b2fc6cbf/docs/pm/lifecycle.mdx#L58-L62
[pr31027]: https://github.com/oven-sh/bun/pull/31027
[pr25163]: https://github.com/oven-sh/bun/pull/25163
[blog135]: https://bun.com/blog/bun-v1.3.5
[rel140]: https://github.com/oven-sh/bun/releases/tag/bun-v1.4.0
[rel142]: https://github.com/oven-sh/bun/releases/tag/bun-v1.4.2
[blog14]: https://bun.com/blog/bun-v1.4
