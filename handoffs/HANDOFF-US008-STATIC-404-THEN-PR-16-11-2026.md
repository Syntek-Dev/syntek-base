# Handoff — US008: fix the dev-stack static 404, re-walk the browser rows, then PR

**Date**: 16/11/2026 · **Story**: US008 · **Branch**: `us008/host-only-cookies` (HEAD `b0f7bc4`,
clean, not pushed)

## Goal

US008 (host-only `__Host-` cookies, CSRF cookie httpOnly, one owner guide) is built, reviewed and
documented. One pre-existing dev-stack defect blocks the QA record. By Sam's ruling Q21
(16/11/2026), fix it **on its own branch** first, then re-walk the blocked browser rows on US008
and raise US008's PR.

## Done (this session)

- **Status:** US008 Pending → In Progress (`project-management/src/02-STORIES/US008.md`, status
  history), and SPRINT-05 Planned → In Progress (`project-management/src/03-SPRINTS/SPRINT-05.md`).
- **P0 baselines** were recorded before the first edit, in
  `project-management/src/18-TESTS/MANUAL/US008-MANUAL-TESTING.md` → _Recorded during the build_.
- **P1–P5** are committed (`cd0b591`..`9afb389`, helper fix `b50787b`):
  - the gate: `code/src/scripts/audits/negative-space.sh`, with the clauses in
    `code/src/scripts/audits/_lib/negative-space-cookies.sh`;
  - the settings: `code/src/django/config/settings/{base,staging,production}.py`;
  - the owner guide `code/docs/security/CRYPTO-AND-DATA.md`, plus four guides deferring to it;
  - `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` Section 6;
  - the preview repair `code/src/scripts/development/template-update.sh`, and the test-only helper
    `code/src/scripts/tests/cookie-preview-fixture.sh`;
  - `.copier/migrations/cookie-domain-conflict.sh` (state-gated) and
    `.copier/migrations/host-only-cookies.sh` (`when: false`, activated at release);
  - the `copier.yml` entries and `_exclude`, `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` rows,
    and `project-management/workflows/24-release/CHECKLIST.md`.
- **Three review and QA rounds** with TDD fixes (`818f3a3`..`43acdf5`).
  - The gate fails closed, and its awk scanner is a byte-identical twin of the migration's.
  - The self-test passes under gawk, mawk and busybox awk. BSD awk is unmeasured.
  - Residual limits are documented in `CRYPTO-AND-DATA.md`.
- **Phase 10, PM workflow 22** (`b0f7bc4`):
  - the security records under `project-management/src/10-SECURITY/*/IMPLEMENTATION/*US008*`;
  - `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md`
    (**Blocked**);
  - `project-management/src/18-TESTS/AUTOMATED/US008-TEST-STATUS.md` (green), and the manual guide
    walked: 50 Pass, 1 Fail, 3 Unmeasured;
  - `project-management/src/20-FINDINGS/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` (35
    findings);
  - four bugs in `project-management/src/21-BUGS/BUG-US008-*`, and three dated entries in
    `GAPS.md`;
  - the code-review-graph refreshed.

## In-flight

- **`project-management/src/21-BUGS/BUG-US008-DEV-STATIC-404-16-11-2026.md:58`** (root cause) and
  **`:86`** (the fix) — Open.
  - **Cause:** dev nginx (`code/src/docker/nginx/dev.conf`) aliases `/static/` to an empty
    `/staticfiles` mount, and the dev entrypoint skips `collectstatic`.
  - **Smallest fix in the record:** proxy `/static/` to Django and drop the mount. It depends on
    `DEBUG` in the dev env, which is marked `TODO(verify)` — never read `.env.dev` to check it.
- **`project-management/src/18-TESTS/MANUAL/US008-MANUAL-TESTING.md:360-363`** — COOKIE-03 and
  COOKIE-06 are Unmeasured and COOKIE-05 is a Fail, all because of the 404.
  **`:369`** — CLOSE-01 is Unmeasured and must be re-walked now that the sign-off is filled.
- **`project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md:11`**
  — Outcome Blocked (HP-04 Fail at `:76`; the next step is listed at `:224`).

## Next action

Branch from `testing` (for example `bugfix/dev-static-404`) and run the `bugfix` skill against
`BUG-US008-DEV-STATIC-404-16-11-2026.md`: reproduce, write the failing regression test, apply the
minimal fix, then QA it, document it and raise its PR.

## After that

1. Merge the bugfix into `testing`, then merge `testing` into `us008/host-only-cookies`.
2. Re-walk COOKIE-03/05/06 and CLOSE-01. Use an independent agent, a disposable clone with its
   own stack, and Playwright, exactly as the first walk did.
   - The first walk published the clone on `127.0.0.8:80`, not `:3080`, because of
     `BUG-US008-STORY-STACK-CSRF-ORIGIN`.
   - It used the placeholder password from `.env.dev.example`, never the live env file.
   - It tore everything down afterwards.
3. Update the QA record off Blocked, and update the findings F-006 disposition.
4. Run `23-pr-and-review` (`/pr`).

## Next skills

`bugfix` (first) → `qa-tester` (re-walk) → `pr`, `git`, `completion`.

## Artefacts

- Story `project-management/src/02-STORIES/US008.md` · plan
  `project-management/src/17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` · current ADR
  `project-management/src/15-DECISIONS/ADR-US008-PENDING-MIGRATION-USES-YAML-FALSE-09-10-2026.md`
- Commits `a83e626`..`b0f7bc4` on `us008/host-only-cookies` (base `6fb7824`)
- **The settled rulings are recorded in commit messages and the findings record:** Q1–Q21.
  Notable ones:
  - fail closed on anything the gate cannot evaluate (Q14, Q18);
  - review loop bounded, so findings below medium become documented limits (Q15);
  - `audits/CONTEXT.md` is not edited in-story (story decision Q3; the gap is in `GAPS.md`);
  - the 24-release line stays generic (Q9).
- Other open bugs from this story (not blocking): `BUG-US008-LINT-PATH-NON-MARKDOWN-…`,
  `BUG-US008-STORY-STACK-CSRF-ORIGIN-…`, `BUG-US008-DOC-REFERENCES-NO-GIT-…`.
