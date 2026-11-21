# Code Review — US008 Host-only `__Host-` cookies, an httpOnly CSRF cookie, and one owner guide

**Last Updated**: 16/11/2026 · **Story**: US008 · **Status**: In Review

| Field        | Value                                                                                                                                                                |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**    | US008 — cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule                                                       |
| **Branch**   | `us008/host-only-cookies` (base `6fb7824`; merges `us008/dev-static-404` and `us008/story-stack-csrf-origin`)                                                        |
| **PR**       | Raised by Sam after this record · target `testing`                                                                                                                   |
| **Reviewer** | Two independent Claude agents at workflow 23 — `qa-tester` (Step 1) and `review` / `code-reviewer` (Step 2) — neither of whom authored the edits; recorded by Claude |
| **Date**     | 16/11/2026                                                                                                                                                           |
| **Verdict**  | Approve-with-nits                                                                                                                                                    |

**Codes from:** `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` — the implementation
master this review closes the loop on.
**Story:** `../02-STORIES/US008.md` — the acceptance criteria the code must satisfy.

---

## 1. Scope & files reviewed

The whole branch against `6fb7824`, weighted on the twelve commits after `43acdf5` — the story
itself had already passed three review and QA rounds (findings record F-007 to F-027). After
`43acdf5` the branch gained two dev-stack fixes its walk surfaced, each test-first on its own
`us008/` branch and PR'd here on Sam's ruling: the dev `/static/` 404 and the story-stack CSRF 403.

| File                                                                                           | Change                                                                                       |
| ---------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `code/src/django/config/settings/{base,staging,production}.py`                                 | US008 — `__Host-` names under TLS, CSRF cookie `HttpOnly`, no cookie `Domain`                |
| `code/src/scripts/audits/negative-space.sh` · `_lib/negative-space-cookies.sh`                 | US008 — three fail-closed cookie clauses and their self-test                                 |
| `code/docs/security/CRYPTO-AND-DATA.md` (+ four deferring guides)                              | US008 — the one owner guide for cookie scope                                                 |
| `.copier/migrations/{cookie-domain-conflict,host-only-cookies}.sh` · `copier.yml`              | US008 — the state-gated conflict check and the `when: false` cutover migration               |
| `code/src/docker/nginx/dev.conf` · `docker-compose.dev.yml` · `django/entrypoint.dev.sh`       | Static fix — dev nginx proxies `/static/` to Django; the empty mount is gone                 |
| `code/src/scripts/audits/dev-static.sh` · `fixtures/dev-static/` (23) · `audit-dev-static.yml` | Static fix — the regression gate, hardened over two QA rounds, Copier-safe at `e34b4be`      |
| `code/src/django/config/settings/dev.py` · `docker-compose.usXXX.dev.yml.example`              | CSRF fix — `DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA`, set by the worktree overlay, parsed strictly |
| `code/src/django/config/tests/` · `audits/worktree-overlay.sh` · `audit-worktree-overlay.yml`  | CSRF fix — 21 settings tests (fresh interpreter each) and the overlay gate                   |
| `CONTEXT.md`/`CLAUDE.md` pairs, `audits/CONTEXT.md`, `.copier/README.md`, `.prettierignore`    | Registers and docs for all of the above                                                      |
| `project-management/src/**` US008 records                                                      | Records — guide re-walked 54/54 Pass, QA off Blocked, findings F-001 to F-039                |

---

## 2. Findings

Workflow 23's two passes (`QA4-*` from Step 1, `M-*`/`L-*` from Step 2), most severe first. Under
ruling Q15 every finding below Medium is a documented limit; the cheap record fixes were made.

| ID    | Severity | File:line                                                                                           | Issue                                                                                                                                            | Resolution/Status                                                                                                                           |
| ----- | -------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| R-001 | Medium   | `../18-TESTS/MANUAL/US008-MANUAL-TESTING.md:315` · `../18-TESTS/AUTOMATED/US008-TEST-STATUS.md:147` | A quoted link in DOCS-06 dangled from the PM folder (`doc-references.sh` 19th finding), and the automated record claimed the docs gates exited 0 | Fixed at workflow 23 — the link is quoted as code; the row names the gates that exited 0 and the 18 citations already dangling at `6fb7824` |
| R-002 | Medium   | `../18-TESTS/MANUAL/US008-MANUAL-TESTING.md:362`                                                    | COOKIE-05's amendment carried no before-text                                                                                                     | Fixed at workflow 23 — `was:` / `why:` / `evidence:` / `ruling:` / `finding: F-036`                                                         |
| R-003 | Low      | `code/src/scripts/audits/dev-static.sh:196-216`                                                     | A `/static`-matching or regex location with no `proxy_pass`, or `return`/`rewrite` inside `/static/`, 404s assets while the gate reads clean     | Documented limit (Q15) — dev only, visible on first load                                                                                    |
| R-004 | Low      | `code/src/scripts/audits/worktree-overlay.sh:42`                                                    | Checks both origins are present, not that the value is exactly the two; no `--self-test`; the `.env.dev.example` check passes on a comment       | Documented limit (Q15) — a widened value is still a valid origin `dev.py` accepts                                                           |
| R-005 | Low      | `code/src/django/config/settings/dev.py:27-56`                                                      | Upper case, a leading-zero port or octet, or an empty `?`/`#` pass the parser yet can never match — a silent 403, not a startup error            | Documented limit (Q15) — fails closed; recorded in the security addendum                                                                    |
| R-006 | Low      | `how-to/docs/GIT-WORKTREES.md:69`                                                                   | Per-story overlays already committed downstream keep the 403; nothing tells their owners to add the variable                                     | Documented limit — for `24-release`'s changelog entry                                                                                       |
| R-007 | Low      | `../10-SECURITY/AUDITS/IMPLEMENTATION/AUDIT-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md:12`          | The audit's scope stopped at `43acdf5`, before the CSRF control merged                                                                           | Fixed at workflow 23 — dated addendum; the stale "observed" bullet struck                                                                   |
| R-008 | Low      | `.github/workflows/audit-{dev-static,worktree-overlay}.yml`                                         | Actions pinned by tag, not SHA (`code/docs/security/SUPPLY-CHAIN.md`); three earlier workflows do the same and the `cicd` skill allows tags      | Documented limit — the doctrine conflict is the owner's to settle                                                                           |
| R-009 | Low      | `code/src/scripts/audits/dev-static.sh:323`                                                         | A crashed detector exits 2 with no report                                                                                                        | Documented limit — already stated in `audits/CONTEXT.md` _Reports_                                                                          |
| R-010 | Info     | `../21-BUGS/archive/BUG-US008-STORY-STACK-CSRF-ORIGIN-16-11-2026.md` Section 6                      | Pre-fix approach text and an open `TODO(verify)` read as current                                                                                 | Fixed at workflow 23 — marked superseded                                                                                                    |
| R-011 | Info     | `handoffs/HANDOFF-US008-STATIC-404-THEN-PR-16-11-2026.md`                                           | The handoff is consumed                                                                                                                          | Removed at workflow 23                                                                                                                      |

---

## 3. Dimension checklists

### 3.1 Security (OWASP)

- [x] **A01 — permission check before logic.** N/A — no endpoint added; settings, gates and docs only.
- [x] **IDOR.** N/A — no user-supplied ID is read.
- [x] **Secrets & DEBUG.** No secret in the diff; the new variable is read by `dev.py` only, and staging and production keep their own `CSRF_TRUSTED_ORIGINS`. A wildcard or malformed entry raises `ImproperlyConfigured`; a foreign origin was proved 403 live. No live env file was read.

### 3.2 GDPR / PII

- [x] N/A — no personal data processed; cookie names and attributes only.

### 3.3 Test coverage vs floors

- [x] Backend coverage meets the floor — `tests/all.sh --coverage` exit 0, whole-project 100% (no module in scope; `dev.py` is proved by subprocess tests, outside the measured `apps` tree).
- [x] Template and HTMX-partial tests — N/A, none added.
- [x] Full suite green — `tests/all.sh --coverage`: backend 71 unit + 22 integration, mobile 16, 0 failed.
- [x] Every acceptance criterion tested — the gate's self-tests prove the cookie clauses; the 21 settings tests and the two audits' red runs prove the two fixes; the manual guide walked 54/54 Pass.

### 3.4 Quality, DRY & file length

- [x] No duplication — the cookie scanner and its migration twin are byte-identical by design and parity-tested.
- [x] No new `TODO`/`FIXME`/`HACK` in shipped code.
- [x] Every source file within 750 lines — `dev-static.sh` 379, the rest smaller.
- [x] Lint clean — `syntax/lint.sh` and `syntax/format.sh` exit 0, Python legs included.

### 3.5 Performance

- [x] N/A — no query or hot path; dev static now passes through Django under `DEBUG`, which is the intended live-reload path.

### 3.6 Accessibility (WCAG 2.2 AA)

- [x] N/A — no user-facing UI in this story.

---

## 4. Required actions before merge

None — R-001 and R-002, the two Mediums, are fixed; every Low is a documented limit under Q15.

---

## 5. Verdict & status transition

- **Verdict:** Approve-with-nits.
- **Reasoning:** both passes found no Critical or High; the two Medium record defects are fixed;
  every gate is green and the manual guide walks 54/54 Pass.
- **Status transition:** `In Progress → In Review` at the PR (this workflow, Step 3); `In Review →
Accepted` is Sam's, after CI and his approval.

---

## 6. Notes

- **The PR carries three changes, by Sam's ruling** — US008 and the two dev-stack fixes its walk
  surfaced, each on its own `us008/` branch and merged here.
- **F-037 is the lesson of this round.** Two QA passes and the closeout gates missed a Copier
  block opener inside a YAML merge key; only `check-template-tokens.sh` and a real
  `template-render.sh` render catch that class, and both now ran.
- **Recorded, not fixed:** F-038 (test stacks share the CSRF gap) and F-039 (`test-record.sh`
  attributes no unit test to a story).

---

## Cross-references

- `../02-STORIES/US008.md` — the story under review
- `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` — the plan this code was written from
- `../18-TESTS/AUTOMATED/US008-TEST-STATUS.md` · `../18-TESTS/MANUAL/US008-MANUAL-TESTING.md` — the
  test records this review reads against
- `../11-QA/IMPLEMENTATION/QA-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md` — the paired QA review
- `../20-FINDINGS/archive/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` — F-001 to F-039
- `../21-BUGS/archive/BUG-US008-DEV-STATIC-404-16-11-2026.md` · `../21-BUGS/archive/BUG-US008-STORY-STACK-CSRF-ORIGIN-16-11-2026.md` — the two fixes PR'd here
- `project-management/workflows/23-pr-and-review/` — the PM workflow where this review is written
- `code/workflows/07-review/` — the code-review workflow the reviewer ran
