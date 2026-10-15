# Handoff — Docker image scanning, and the dependency sweep's loose ends — 14/10/2026

## Goal

Add Docker image vulnerability scanning: the one tooling gap from the 14/10/2026 dependency
audit that was deliberately deferred to its own branch. Then close the three small follow-ups
that the sweep and the `main` → `pm/story-creation` merge left behind.

## Done (this session)

- **PR #15 merged to `main`** (`4eb3c59`, branch `pm/dependency-advisory-sweep`):
  - 85 advisories down to 0 open, with 6 annotated ignores in `pnpm-workspace.yaml` `audit.ignore`.
  - The tooling fixes:
    - `code/src/scripts/dependencies/update.sh`
    - `code/src/scripts/development/install-frontend.sh`
    - `code/src/scripts/audits/security.sh`
    - `code/src/scripts/audits/dependency-drift.sh`
    - `.claude/hooks/lib/check-security.sh`
    - `.github/workflows/audit-deps.yml`, which gains a Rust leg
    - `.github/workflows/claude.yml`
    - `code/src/docker/django/Dockerfile.test`, now `--frozen`
  - All 145 `uses:` pinned to commit SHAs, with `# vX.Y.Z` comments.
  - Two gate false failures fixed: `.prettierignore` and `.github/scripts/check-template-parsers.sh`.
- **`main` merged into `pm/story-creation` and pushed** (`d16de16`).
  - Conflicts resolved in `code/src/scripts/audits/CONTEXT.md` and
    `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md`.
  - `uv.lock` verified with `install-backend.sh --check`.
- **Host set up:** `install.sh --full` ran (Sam), so `code/src/docker/.env.dev` exists and the dev
  stack runs. The pre-PR gate passes on `main`'s content.

## In-flight

No code is mid-change. Four threads are open:

- **Image scanning: not started.** Research recommends **Grype** (Apache-2.0):
  - It refuses to scan on a stale database (`validate-age`).
  - Its ignore rules carry a `reason`.
  - It has no compromise on record. Trivy had two supply-chain compromises in 2026: on 28/02,
    and on 19/03, when `trivy-action` and `setup-trivy` tags were force-pushed. Docker Scout fails
    the licence test.
  - **Proposed shape:**
    - A new `code/src/scripts/audits/image-vulns.sh`, a sibling of `security.sh`.
    - Root ignore file `.grype.yaml`; every rule names its re-check trigger.
    - A pin file `.grype-version` holding version and SHA-256, installed and cosign-verified the
      way `audit-static-analysis.yml` installs opengrep.
    - A nightly images leg in `.github/workflows/audit-deps.yml`, inserted before `:226`
      (`Fail the run if advisories were found`), following the Rust leg's pattern at `:133`.
    - Possibly a path-filtered `audit-images.yml`.
  - Also narrow `code/docs/security/SECRETS-AND-TRANSPORT.md:68`, which still says "trivy, grype,
    or Docker Scout".
- **The MAP-SCRIPT-GUARDS reconciliation awaits Sam.**
  - Where: `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md:8` (status note) and `:82`
    (the `S-01 (ext.)` row).
  - The issue: main's 14/10 extension (N-006, with N-007 and N-008 blocking) was charted against an
    uncut S-01, which is already US006 on `pm/story-creation`. Either it amends US006 or it becomes
    a new slice.
- **A `GAPS.md` entry to close.** `GAPS.md:298` ("a RUSTSEC advisory against an unchanged
  `Cargo.lock` is invisible") is retired by #15's Rust leg in `audit-deps.yml:133`. Close it through
  `project-management/workflows/22-implementation-documentation/` (the owner of `GAPS.md` closes).
- **`pm/story-creation` carries 526 dangling citations** that `audits/doc-references.sh` reports
  (188 in `03-SPRINTS`, 128 in `02-STORIES`, 44 in `GAPS.md`). They predate the merge, and they
  will block that branch's own PR.

## Next

Branch from `main` and open the grilling round on the image-scanning policy questions below,
before writing any code.

## Next skills

- `grilling` (open the round)
- then `cicd` + `security` (build it)
- `doc-writer` for the `audits/CONTEXT.md` row and the `SECRETS-AND-TRANSPORT.md` edit
- `git` / `pr` to ship
- Procedure of record: `how-to/workflows/06-quality-gates/` and `how-to/workflows/07-dependency-updates/`.

## Open Questions (image scanning, for the grilling round)

1. **Fail threshold:** High and Critical with a fix available, or match pnpm's `--audit-level low`?
   Debian slim images carry many unfixed Low/Medium findings; measure on the first run.
2. **Required check:** should images join the required `[8/8]` check, at the cost of an image build
   and a database download on every PR?
3. **Which images can fail the run:** prod only, or staging too? Should postgres, valkey and nginx
   (dev-only) be report-only?
4. **Scope:** OS packages only, or language packages too? Python would then be reported twice
   alongside pip-audit.
5. **`.grype.yaml`:** ship it with entries, or seed it blank through `.copier/`?
6. **Grype missing locally:** exit 2 (the `docs-length.sh` precedent), or exit 0 with a note and
   mandatory in CI (the `static-analysis.sh` precedent)?
7. **Pin upkeep:** a pin-register row and a Renovate watch for `.grype-version`, and how long to wait
   before adopting a new scanner release.
8. **Live findings:** once a surface is live, does a nightly finding go to the `incident` skill
   instead of the tracking issue (`.claude/CLAUDE.md` Section 0)?

## Artefacts

- PR #15: <https://github.com/Syntek-Dev/syntek-base/pull/15>. Commits `1973308` to `dafc22d` on
  `main`; the merge is `4eb3c59`.
- Story-branch merge commit: `d16de16` on `pm/story-creation`.
- Settled pinning decisions: `project-management/src/01-FEATURE-MAPS/MAP-UPSTREAM-TRACKING.md`.
  - N-015 (SHA pins), N-016 (image digests vs tags).
  - Slices S-02 (Renovate, unbuilt) and S-03 (action half delivered by #15; image digests, the
    `uv` pin and MCP pins remain).
- Pinning rule and the version-comment rule: `code/docs/security/SUPPLY-CHAIN.md`.
- Gate-reporting rule every new audit must follow: `code/docs/GATE-REPORTING.md`.
- Audit-authoring rules (inventory row, `--path`, self-guard register):
  `code/src/scripts/audits/CLAUDE.md`.
- Unmeasured items, still open:
  - The host typecheck leg: `basedpyright` is in `.venv/bin`, not on PATH.
  - An iOS prebuild.
  - Bruno API tests.
  - Pre-existing bash warnings in `.claude/hooks/lib/check-lockfiles.sh:28` and `:95`.
