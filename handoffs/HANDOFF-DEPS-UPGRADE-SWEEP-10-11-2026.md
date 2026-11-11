# Handoff — dependency upgrade sweep, stopped mid group E

## Goal

Bring every toolchain, image and package to its current release under Sam's rulings D1 to D12
(all of the research's recommendations), with two new audits proving the result, then raise a PR
into `testing`. Sam stopped the sweep on 10/11/2026 and asked for the progress to be saved.

## Done

Branch `deps/upgrade-sweep-09-11-2026`, cut from `origin/testing` at `7ad0cb8`. **16 commits, not
pushed** (`git log --oneline 7ad0cb8..HEAD`). The working tree is clean.

- **New audits, `ca973ff`:** `code/src/scripts/dependencies/audit.sh` (one entry point for the
  Python, JS and Rust audits plus the lockfile-in-step checks) and
  `code/src/scripts/audits/toolchain-pins.sh` (Node, Python, uv, pnpm and Rust pins must agree,
  docs tables included). Both were red on the old tree by design.
- **Group A:** `95e901b` `Cargo.lock` refresh, which clears the yanked `async-executor 1.14.0`;
  `2844bc9` Django 6.1.2 → 6.1.3 and the stale 6.0 doc versions.
- **Group B:** `82b7b7d` the same-major Python set; `c2abb54` the root JS dev tools; `5997f74`
  pyo3 0.30.1, with `extension-module` dropped and the maturin floor raised.
- **Group C:** `b0f23a4` celery 5.7 + redis 8.1 and the redis-cap doctrine rewrite; `01cd45b`
  django-ninja `>=1.8`; `6fb03fd` ruff 0.17.4 with the tree reformatted; `7dd2d8a` basedpyright
  1.40.2; `2f9c7be` markdownlint-cli2 0.24 with three overrides pruned.
- **Group D:** `997a325` action SHA bumps past the 7-day cooldown; `864cc91` uv 0.13.7 at every
  version pin; `59cd4e8` pnpm 11.28.9; `5ea9bff` Opengrep 1.33.1; `ef5eb85` the `install.sh`
  requirements line.
- **US004:** PR #24 and the closeout PR #25 are both merged into `testing`. US004 is Accepted and
  SPRINT-03 is Done.

## In-flight

- **Group E, Expo SDK 58 — stopped mid-change, NOT committed, gates NOT run.** Saved as
  `stash@{0}` ("deps sweep group E (Expo 58) WIP, stopped 10/11/2026") and as
  `/home/sam-desktop/.claude/tmp/deps-sweep-save/group-E-expo58-wip.patch`. It touches 13 files.
  After `git stash pop`:
  - `code/src/mobile/package.json:17` `expo ~58.0.23`, `:23` `react-native 0.88.1`, `:34`
    `jest-expo ~58.0.14`, plus `app.json`, the mobile changelogs and `__tests__/app.test.tsx`;
  - `pnpm-lock.yaml` and `pnpm-workspace.yaml` regenerated, and
    `patches/decode-uri-component@0.2.2.patch` deleted;
  - `CONTEXT.md` (its `patches/` tree row removed), `.copier/README.md`,
    `how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md` and
    `project-management/src/01-FEATURE-MAPS/MAP-UPSTREAM-TRACKING.md`.
  - **Unverified:** `mobile/lint.sh`, `typecheck.sh`, `test.sh`, `bundle.sh`, and
    `audits/security.sh --js-only` with and without the `audit.ignore` key. Deleting the patch and
    its ignores is valid only if that audit stays clean.
- **Group F, Node 26 — not started.** `.nvmrc:1` reads `24`, and `package.json:7` reads
  `"node": ">=24"`. Sam's dev-shell `node` is 24.22.0 on PATH and must switch to 26. nix-config
  already gives its tools `nodejs_26`.
- **Group G, records — not started.** Dated `GAPS.md` rows for D12 (the abandoned deps), D10
  (the FastMCP 4 docs) and the held upgrades with their trigger conditions.

## Next

Pop `stash@{0}` and finish group E: run the four mobile scripts and `security.sh --js-only`, fix or
drop what fails, then commit `feat(mobile)`.

## Next skills

`cicd` + `stack-react-native` (group E), `cicd` (F), `doc-writer` (G), then `review`
(`code-reviewer` + `qa-tester`) and `git`/`pr`.

## After E to G

1. Independent review of `7ad0cb8..HEAD`, a verifier for each finding, then a red-first fix round.
2. Merge `origin/testing` (which has #25) into the branch. Re-run both new audits and the workflow
   07 Step 4 gate.
3. Push, and Sam raises the PR to `testing`. The pre-PR hook blocks on `doc-references.sh`'s 28
   known survivors, so Sam overrides it as for #24 and #25.

To resume by workflow instead: edit group E's prompt in the script below to say "resumed from
`stash@{0}`", then relaunch with `resumeFromRunId`. Groups A to D replay from the cache.

## Artefacts

- Workflow script: `/home/sam-desktop/.claude/projects/-home-sam-desktop-Repos-syntek-syntek-base/cf75812c-0164-426e-bcff-6e5b1d9ea57f/workflows/scripts/deps-upgrade-sweep-wf_5d831715-e41.js`,
  run `wf_5d831715-e41`. Each group's report is in that run's `journal.jsonl`. The script also
  holds the D1 to D12 rulings verbatim.
- Research matrix: `/home/sam-desktop/.claude/tmp/deps-research-09-11-2026.json`.
- Procedure: `how-to/workflows/07-dependency-updates/STEPS.md`.
- **Held, by ruling:** Python 3.15, Postgres 19, TypeScript 7, mobile ESLint 10, django-prometheus
  2.5, Playwright (Nix bundle), django-valkey 0.5, Valkey 9, the Rust toolchain until 1.100, pnpm
  12, and the pin hardening that belongs to PIN S-01.

## Open items outside this sweep

- US004: F-068 (round 3 never independently reviewed); the F-059 record still says the CI
  generation job has not run, but it ran and passed on #24; Sam's reviewer approval and walk
  countersignature.
- F-076 and F-077 are open `GAPS.md` entries.
