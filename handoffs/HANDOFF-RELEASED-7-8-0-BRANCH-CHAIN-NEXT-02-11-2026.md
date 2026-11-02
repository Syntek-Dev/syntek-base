# Handoff — 7.8.0 released; the branch chain, then US007 — 02/11/2026

## Goal

Build the planned backlog (US001 to US014) one story at a time, under
`project-management/src/02-STORIES/CUT-PLAN.md` P14. The advisory sweep and the versioning are
done. What remains first is the `staging` / `dev` / `testing` branch chain, then US007 off
`testing` in story-plan build order.

## Done

- **PR #17** squash-merged at `7f15028`.
  - 57 advisories cleared (17 Python, 40 JS). The decode-uri-component patch is extended for
    GHSA-qr28.
  - Template Integrity, Secrets Scan and `shipped-ai.sh` are fixed.
- **PR #18** squash-merged at `47442dd`.
  - 7.8.0 is cut.
  - The `-TEMPLATE.` re-include fix (`copier.yml`, `.github/scripts/shipped-artefacts.sh`).
  - The `.copier/migrations/v7.8.0-leaked-adr.sh` migration.
  - The cut-plan migration re-run at v7.8.0.
  - `effortLevel: medium` wherever the setting is stated.
  - `.claude/skills/stack-django/` split into `SKILL.md` + `CODING-STANDARDS.md`.
- **Records rebuilt from a commit-by-commit audit** of all 128 commits since `v7.5.0`:
  - `CHANGELOG.md` and `RELEASES.md` for 7.6.0 and 7.7.0 gained their missing entries, marked
    as recorded retrospectively.
  - The three post-tag entries moved to 7.8.0.
- **Tags and GitHub releases published.** Each tag is annotated, and each release body matches
  its `RELEASES.md` block:
  - **v7.6.0** → `16aac54`
  - **v7.7.0** → `e80b9a8`
  - **v7.8.0** → `47442dd` (Latest)
- **Proven:** both v7.8.0 migrations ran on probe projects updated from `v7.7.0`, and Template
  Integrity passes all 26 steps locally.
- **`main` CI at `47442dd`:** everything green except Doc References.
- **Pruned:** `handoffs/HANDOFF-BUILD-PHASE-ADVISORY-SWEEP-02-11-2026.md`. Its open questions
  are carried below.

## In-flight

Nothing is mid-edit. The local branch is `main`, level with `origin/main`.

**Known red, and not this session's:** `Audit — Doc References` / required check
`Citations resolve`.

- 609 findings, owned by **US004**, then by each story's forward references.
- Every PR to `main` needs `--admin` until then.
- `code/src/scripts/audits/doc-references.sh:323` `is_exempt()` is where US004 starts.

## Next

**Create `staging` from `main`. This needs Sam's explicit go-ahead before it is created or
pushed.** Then create `dev` from `staging`, and `testing` from `dev`, one at a time, each with
its own go-ahead (`project-management/docs/git/BRANCHES-AND-WORKTREES.md:40`).

After that, build US007 on `us007/status-vocabulary-one-owner` off `testing`, through
`code/workflows/01-implement-story/`. Its first step re-cuts its criteria against
`.claude/skills/completion/SKILL.md` (`US007.md` → _Scope note — 31/10/2026_).

## Next skills

- **Branches:** `git`.
- **US007:**
  - `implement-story`
  - `doc-writer` and `completion`, because US007 is PM docs
  - `review`, `qa-tester` and `pr`

## Standing rules from Sam

- Push, PR and branch creation each need an explicit go-ahead.
- Stale references in a plan are fixed **when that story is built**. New ones this session:
  - Planning artefacts still quote copier's old `*TEMPLATE*` glob, which is now `*-TEMPLATE.*`:
    `US004.md`, `US007.md`, `US010.md`, `US011.md`, their QA plans, ADRs and story plans 01-,
    05- and 12-.
  - `project-management/src/01-FEATURE-MAPS/MAP-UPSTREAM-TRACKING.md:349` quotes 11
    `minimumReleaseAgeExclude` entries; there are now 2.
- **The pre-PR hook blocks `gh pr create` while `audits` is red.** Sam raises each PR himself
  from the terminal, with a _Known reds_ table.
- Another chat may share the tree. Stage explicit paths only.

## Artefacts

- Programme: `project-management/src/02-STORIES/CUT-PLAN.md` (P14). Build order is
  `project-management/src/17-STORY-PLANS/01-` to `14-`.
- The first plan:
  `project-management/src/17-STORY-PLANS/01-STORY-PLAN-US007-STATUS-VOCABULARY-ONE-OWNER.md`.
- The release record: `CHANGELOG.md` `[7.8.0]`, `RELEASES.md` `v7.8.0`, `VERSION-HISTORY.md`.
- The secrets-scan range logic: `.github/workflows/audit-secrets.yml` (step _Choose the scan
  range_).
- PR bodies: `gh pr view 17`, `gh pr view 18`.

## Open questions

Each one is Sam's call.

- **Rust leg, local only.** The host's Nix `ld-wrapper.sh` path is stale, so `syntax/check.sh`
  and `lint.sh` report the Rust leg as "could not run". This is a host fix in the nix-config, not
  in this repository.
- **ClickUp export (carried over).** The `clickup-export` lefthook leg regenerates
  `project-management/export/clickup/*-CLIENT.md` but does not stage it.
  - **Workaround:** run `bash project-management/src/00-ASSETS/scripts/export-clickup-stories.sh`
    before staging.
  - There is no `GAPS.md` row for it.
- **graphify findings (carried over, on hold):**
  - A possible split-doctrine defect between `project-management/docs/gdpr/COMPLIANCE.md` and
    `code/docs/security/AUDIT-TRAIL.md`.
  - Two weak-cohesion candidates.
  - **Markdown lint scans the gitignored `graphify-out/`**, which adds noise to every `lint.sh`
    run.
