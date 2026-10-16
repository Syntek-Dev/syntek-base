# Handoff — Thread A charted and its blockers cleared; Step 8a is next — 16/10/2026

## Goal

Thread A is now a feature map, `MAP-PIN-DETECT-MOVE`. It covers Docker image scanning with Grype,
widened by Sam into one pin-detect-move rule:

- **Pin:** every dependency surface is pinned exactly where the repo controls it.
- **Detect:** scanners report when a pinned version becomes vulnerable.
- **Move:** routine moves wait out a 7-day cooldown; security moves go through a named exception.

The map's frontier holds no blocking node. What remains is to re-cut and specify the two slices
and cut them into stories. This is PM work only: nothing is to be implemented.

## Done (this session, all uncommitted on `pm/story-creation`, HEAD `73fd24d`)

- **The new map.** `project-management/src/01-FEATURE-MAPS/MAP-PIN-DETECT-MOVE.md`
  - 25 nodes resolved: Q1 to Q19 as N-001 to N-017; research nodes N-018 to N-021; the batch
    N-022 and N-025 to N-027.
  - Two provisional slices (`:205-206`): S-01 pin-and-move, then S-02 detect.
  - Status "Blockers clear — stories may start". No `CONTEXT.md` index row, declined as precedent
    does.
- **The evidence note.** `research/IMAGE-SCANNING-AND-PINNING.md`: 89 cited claims, independently
  verified and fixed, with 0 shared prose five-grams. Its sources row is in
  `THIRD-PARTY-NOTICES.md`.
- **`GAPS.md`.**
  - New entry `:949`: issue #14, which publishes advisory detail and never closes.
  - Two drifted citations into `MAP-UPSTREAM-TRACKING` re-pointed (`:704`, `:707`).
  - Last Updated set to 16/10/2026.
- **Edge notes on other maps.** Each was written inline, plus one session row, so as few cited
  lines as possible shift:
  - `MAP-UPSTREAM-TRACKING.md`: the Edge paragraph below Slices and annotations in the S-03 row.
  - `MAP-NATIVE-MOBILE-SURFACE.md`: the N-004 cell.
  - `MAP-BUN-TOPOLOGY.md`: the `pnpm-update.sh` register row.
  - `MAP-GATE-PARITY.md`: the N-010 bullet.
- **`project-management/src/02-STORIES/CUT-PLAN.md`.** Line citations re-pointed at `:234` and
  `:413`.
- **The Thread A brief.** `handoffs/HANDOFF-IMAGE-SCANNING-14-10-2026.md` gained Q9 (`:94-105`).
  The map now supersedes the brief.
- **Checks.**
  - Format and lint are clean on every edited file.
  - The change adds no `doc-references` findings; the branch total is still 529.
  - One three-lens independent review (54 findings) and one fix verification were done.

## In-flight

- **`MAP-PIN-DETECT-MOVE.md:226-227`.** The build nodes N-023 and N-024 are open but not blocking.
  `:229` says Step 8a re-cuts the slices first.
- **Nothing is committed.** Sam has not yet said to commit. The changed files are those listed
  under Done, plus the untracked `handoffs/HANDOFF-THREAD-B-CLOSED-IMAGE-SCANNING-NEXT-15-10-2026.md`.
- **Prune candidates, awaiting Sam.** The Thread B handoff above, and the 14/10 Thread A brief.
- **Scratch to delete.** `/tmp/imgscan-measure-cqmT` holds a 3.1 GB Grype database from the
  measurement and can be removed.
- **Loose ends carried from earlier handoffs, still open.**
  - `GAPS.md:303`, the RUSTSEC entry, is retired by PR #15 and awaits a close through workflow 22.
  - `MAP-SCRIPT-GUARDS.md:82`, the `S-01 (ext.)` row, awaits Sam: amend `US006`, or make it a new
    slice.
- **The branch's PR is blocked.** `pm/story-creation` carries 529 dangling citations. An admin can
  bypass the check.

## Next

Ask Sam whether to commit the chart. Then run `workflows/01-feature-map/STEPS.md` Step 8a
(`:191`) on `MAP-PIN-DETECT-MOVE` to re-cut S-01 and S-02 and specify N-023 and N-024 into their
rows.

## Next skills

- `wayfinder`, for RESOLVE and Step 8a.
- `git`, for the commit.
- `story`, then `workflows/02-story-creation/`, for cutting `US###` from each slice row.
- `grill-with-docs`, only if Step 8a opens a node.

## Artefacts

- **Map:** `project-management/src/01-FEATURE-MAPS/MAP-PIN-DETECT-MOVE.md`.
- **Evidence:** `research/IMAGE-SCANNING-AND-PINNING.md`.
- **Owners across maps:**
  - S-02 and S-03 on `MAP-UPSTREAM-TRACKING` (Renovate; MCP pins).
  - N-010 on `MAP-GATE-PARITY` (copier).
  - N-004 on `MAP-NATIVE-MOBILE-SURFACE` (audit headroom).
  - `MAP-BUN-TOPOLOGY` (`pnpm-update.sh`).
- **Gap:** `GAPS.md:949`.
- **Procedures:** `project-management/workflows/01-feature-map/` and `02-story-creation/`.

## Session facts the next agent should not re-derive

- **Cross-session messaging works on this branch.** Peers were `syntek-media-5f` and
  `syntek-author-33`, connected and idle. On `main`, `SendMessage` is denied, because `57c1d1e` has
  not reached it.
- **Some tools are unavailable.**
  - context7 and Perplexity fail authentication: `CONTEXT7_API_KEY` and `PERPLEXITY_API_KEY` are
    unset.
  - The `claude-design` MCP returns 403.
- **This host runs Grype 0.120.0, from nixpkgs.** The repo pin is `0.120.1` (N-027). Packaging
  Grype in nix-config at the pin, as `pkgs/opengrep.nix` does for opengrep, is Sam's own work in
  another repository.
