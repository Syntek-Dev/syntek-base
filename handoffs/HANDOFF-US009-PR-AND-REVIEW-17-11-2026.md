# Handoff — US009 to workflow 23 (PR and review) — 17/11/2026

## Goal

Take US009 ("The git hooks arm on purpose at install") through
`project-management/workflows/23-pr-and-review/`: raise the PR from `us009/hook-arming` into
`testing`, read the first CI run of `.github/workflows/audit-hook-arming.yml`, close the last three
manual rows from it, write the review record, and move the story to `In Review`.

## Done (this session, branch `us009/hook-arming`, pushed, HEAD `125312b`, in sync with `origin`)

- **Build:** `code/src/scripts/development/install-hooks.sh` (new; arming mode + `--notice`),
  `install.sh` (Phase 1 Step 9; Phase 2 renumbered 10/11; `generate_machine_spec` made best-effort),
  `package.json` (`prepare` removed, `postinstall` → `install-hooks.sh --notice || true`),
  `pnpm-workspace.yaml` (comment on `allowBuilds` `lefthook: false`), `.copier/README.md`,
  `lefthook.yml:76`, setup docs (`how-to/workflows/01-first-time-setup/STEPS.md`,
  `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md`, `code/docs/CODE-REVIEW-GRAPH.md`).
- **Tests:** `code/src/scripts/tests/hook-arming.sh` (probe runner, 15 fixtures, `node_modules`
  tripwire, `--needs-install-failure` change filter), `.github/workflows/audit-hook-arming.yml`
  (probes job + path-filtered `install-failure` job), HP-07 grep in
  `.github/workflows/audit-template.yml`. Last full local run: **371 passed · 0 failed · 1
  unmeasured** (ES-01, CI-only).
- **Six TDD rounds** of review / security / QA, every finding fixed or recorded; the settled
  decisions are the dated answer sections at the end of
  `project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`.
- **Out-of-story fix on this branch:** `.github/scripts/shipped-ai.py` accepts `${KEY:-}` (commit
  `97821a8`) — Template Integrity is green again. `c8424f9` (research doc) and `2950392` (context7)
  are the developer's own and stay on this branch by decision.
- **PM:** US009 `In Progress`, re-estimated 5 → 8 SP; SPRINT-05 16 / 11 over grace, "reconciled at
  its close"; SPRINT-06 carry released (`project-management/src/03-SPRINTS/`,
  `project-management/src/16-SPRINT-PLANS/`).
- **Workflow 22 complete** (commits `cb151f3`, `6420d4a`, `e8e796f`, `125312b`): records under
  `project-management/src/10-SECURITY/{THREAT-MODEL,ASSESSMENTS,AUDITS}/IMPLEMENTATION/*US009*`,
  `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US009-HOOK-ARMING-17-11-2026.md`,
  `project-management/src/18-TESTS/AUTOMATED/US009-TEST-STATUS.md`, the walked and signed
  `project-management/src/18-TESTS/MANUAL/US009-MANUAL-TESTING.md` (33 Pass, 0 Fail),
  `project-management/src/20-FINDINGS/FINDING-US009-HOOK-ARMING-17-11-2026.md` (F-001 to F-032),
  `project-management/src/21-BUGS/BUG-US009-MACHINE-SPEC-PROBE-ABORT-17-11-2026.md`, the
  `GAPS.md` row "17/11/2026 — twelve `pnpm install` invocations…", a `.claude/MEMORY.md`
  feedback entry, and pattern rows in the `19-REVIEWS`, `20-FINDINGS` and `21-BUGS` trees (F-030).
- **Hooks are live in this checkout:** `core.hooksPath=/dev/null` was removed from `.git/config`
  this session; every commit since `e10e293` ran the lefthook legs.

## In-flight

- `project-management/src/18-TESTS/MANUAL/US009-MANUAL-TESTING.md` — rows **FAIL-01 to FAIL-03**
  blank, awaiting the first CI run of the `install-failure` job (_Tester sign-off_ → Blockers).
- `project-management/src/18-TESTS/AUTOMATED/US009-TEST-STATUS.md` — status **Partial**; update
  Sections 2–4 with the CI result once `audit-hook-arming.yml` runs.
- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US009-HOOK-ARMING-17-11-2026.md` — ES-01 to
  ES-03 and EC-13 recorded unmeasured until CI.
- `project-management/src/10-SECURITY/{THREAT-MODEL,ASSESSMENTS,AUDITS}/IMPLEMENTATION/*US009*` —
  developer sign-off fields still open (each record's sign-off section).

## Next

Read `project-management/workflows/23-pr-and-review/STEPS.md`, then raise the PR
`us009/hook-arming` → `testing` (body per `project-management/docs/GIT-GUIDE.md`, referencing US009
and its test plan) so `audit-hook-arming.yml` runs for the first time.

## Next skills

`pr` + `git` (raise and manage the PR), `code-reviewer` for the review record (dispatched, it wrote
none of this), `completion` (US009 → `In Review`, status-history row, boards).

## Watch for

- **`audit-hook-arming.yml` has never run.** First-run risks: the `changes` job's BASE expression
  (only reviewed), the `install-failure` job (docker, uv, sudo on the runner), strace on the runner,
  the timeouts. A failure there is a real finding, not noise.
- **Never share this checkout's `node_modules` into a scratch copy** (`.claude/MEMORY.md`, F-003);
  never run `install.sh` or `install-hooks.sh` arming mode against this working tree.
- **Commit identity in scratch clones:** use `GIT_AUTHOR_*` / `GIT_COMMITTER_*` env vars — this
  host has no global git identity.
- On NixOS `/etc/hosts` is read-only; host names come from the developer's
  `just dev-host-add SLUG` (F-032).

## Open questions

- Stale text in other gates' artefacts (findings F-018 to F-025): whether each owning gate adds its
  dated correction now or at its next pass — not yet ruled.

## Artefacts

- Story `project-management/src/02-STORIES/US009.md`; plan
  `project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`; ADR
  `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`.
- Specs `project-management/src/10-SECURITY/*/PLANNING/*US009*`,
  `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md`.
- Diff `git diff a0ca304..125312b` (base: `testing` at `a0ca304`).
