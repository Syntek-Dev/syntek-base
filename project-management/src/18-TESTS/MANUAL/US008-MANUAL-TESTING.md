# US008 — Manual Testing Guide

_The manual testing guide for US008 — the checks and the one browser journey a tester follows step by step, and, once walked, whether each passed. Authored from the specs at `17-story-plans` Step 7.2 as a backfill on 30/09/2026; walked at `22-implementation-documentation` Step 4._

**Last Updated**: 30/09/2026 · **Story**: US008 · **Status**: Authored — not yet walked

- **Story:** `../../02-STORIES/US008.md` — cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule
- **Story plan:** `../../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` — the code master this guide was authored beside
- **Branch:** `us008/host-only-cookies`
- **Surface:** CLI — the gates, the advisory dry run and the preview proof are commands run in a terminal, their outcome what they print. One journey, _Dev-stack cookie walk_, is Browser and uses that vocabulary
- **Authored from:** `../../02-STORIES/US008.md` (Acceptance Criteria and its seven scenarios, Backend and Security Acceptance Criteria, QA Acceptance Criteria — Manual, QA Tasks — Manual, Verification Checks, Definition of Done); `../../11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` (Sections 1 to 8); `../../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` (Approach P0 to P5, the three gate clauses, the owner and its deferrals, the edge precondition, the preview repair, the two migration entries and the key, Quality Gates, Testing); `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` (Section 7); `../../10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` (TM-04); `../../15-DECISIONS/ADR-US008-FORWARDED-PROTO-IS-A-PRECONDITION-17-09-2026.md` (Options, Decision, Consequences); `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` (Decision); `../../16-SPRINT-PLANS/05-SPRINT-PLAN-05.md` (the lane, Phase 4, Sprint Verification Checklist); `../../03-SPRINTS/SPRINT-05.md` (QA Acceptance Criteria — Manual, QA Tasks — Manual). No `04`–`09`, `12`–`14` artefact exists for this story: those flags read `N/A`. Never code.

> **Authored before code, walked after it.** Which workflow writes which part of this file, and
> when, is `../CLAUDE.md` → _The record lifecycle_. Every rule for filling it — authoring, open
> questions, row IDs, the two citation columns, the build captures, marking, amendments and the
> browser contract — is this folder's `CLAUDE.md`. Neither is restated here.
>
> **What this file is, and is not.** This records **executing** the manual tests and their outcome.
> Whether the story met its specified scenarios is `../../11-QA/IMPLEMENTATION/`; whether the flow
> exists as designed is `../../05-USER-FLOW/IMPLEMENTATION/`. Three records, three questions.

---

## Preconditions and environment

- **Stack:** for _Dev-stack cookie walk_ only — `bash code/src/scripts/development/server.sh up`.
  Every other journey needs no stack
- **Base URL:** the live URL `server.sh up` printed — never quoted from memory
- **Seed data:** a dev superuser, created by `bash code/src/scripts/database/seed-dev.sh` from
  `.env.dev` — its credentials are never copied into this file
- **Accounts / roles:** the seeded superuser, to sign in at `/control/`. The story adds no role
  boundary in the web sense: its boundary is the browser's cookie jar (QA plan Section 2 →
  _Permission and access_)
- **The baseline:** captured at the plan's P0, **before the first edit** — the whole-tree
  `doc-references.sh` set by identity, the detector's `git hash-object`, HEAD and the index state,
  and the `--path code/docs` reading — and pasted into _Recorded during the build_ below at capture
- **A scratch copy of this tree:** a separate checkout of the story branch, never this working
  tree, for the rows that plant or remove a setting or a fixture. Each such row is walked on a
  fresh copy, or the copy is restored before the next. How the copy was made is recorded beside
  the result
- **A scratch generated project:** for _Preview proof_ only — generated from a ref below `v3.0.0`,
  committed so `template-update.sh`'s clean-tree guard passes, the edited `template-update.sh`
  copied in (plan P4). No project script makes it and a raw copier invocation is barred by
  `.claude/CLAUDE.md` Section 6 (QA plan Section 6); the route taken is recorded beside the result
- **The tester:** someone other than the author of the story's edits
- **Out of scope:**
  - **PA-01 and PA-02** — a host under the apex writing a cookie the apex holds, after the change
    and before it. Both need two hosts and a real browser, and this repository has neither (QA
    plan Section 2; plan → _Testing_). The settings assertions are a proxy for them, and no record
    may report them as run
  - **ES-06** — a `__Host-` name beside a `Domain` reaching a browser. That needs a TLS-serving
    environment: dev keeps plain names over HTTP by design, and this template repository deploys
    nothing (story → _Security Acceptance Criteria_)
  - **EC-12, the tag half** — that the keyed entry's key names a tag that exists. The key is
    written at `24-release` in the same act as the tag (plan → _The migration key_), after this
    guide is walked. The entry-order half is ADVISORY-06
  - **EC-13** — two reports from an update that crosses the key while carrying a `Domain` line.
    There is no key to cross until `24-release`
  - **Permission and access** — section dropped: no endpoint, screen or protected action (QA plan
    Section 2). The two scenarios that behave like `PA` rows are above
  - **Accessibility** — section dropped: no rendered screen or interactive component (QA plan
    Section 3). The cookie walk is a cookie-attribute check, not a UI walk-through (SPRINT-05 →
    _QA Tasks — Manual_)
  - **Responsive behaviour** — section dropped: no rendered screen (QA plan Section 4)
  - **The automated criteria** — `--self-test`, the discriminating comparison, ShellCheck,
    `lint.sh`, `check.sh` and `tests/all.sh` are the automated record's (story → _QA Acceptance
    Criteria — Automated_)
- **Open questions** — each awaits the developer's answer, and every row it holds carries
  `Awaiting answer` in `Notes` until it is answered and the row rewritten from it:
  1. **The form and the HTMX write — COOKIE-02, COOKIE-03.** `HP-04`, the story and the plan say
     "POST a form" and "fire an HTMX write" and name neither. Which form under `/control/`, and
     which page of this template issues an HTMX write carrying the template-injected header?
  2. **The failed update — PREVIEW-04.** `ES-08` needs "a scratch update that fails on the copy"
     and says nothing of how the failure is made. What makes it fail, so the failure tail — not a
     guard ahead of it — is what the row reads?

---

## Recorded during the build

The figures and the readings the rows below point at. The implementer pastes the baseline half
here at the plan's P0, before the first edit — never reconstructed afterwards
(`../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-AFTER-TESTS-SPLIT-30-09-2026.md`,
which supersedes `../../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`, puts it in this file);
the walker pastes the close half at the walk. Each captured set is a fenced block beneath this
table. Every figure carries its date. Nothing here carries a `Result`.

| Evidence                                                                         | Baseline — P0 | Close — the walk | Read by                    |
| -------------------------------------------------------------------------------- | ------------- | ---------------- | -------------------------- |
| Whole-tree `doc-references.sh` set by identity, detector hash, HEAD, index state |               |                  | CITE-01 to CITE-03         |
| `doc-references.sh --path code/docs` — exit code and count                       |               |                  | CITE-04                    |
| The seven bystander guides and the Wagtail note                                  | —             |                  | DOCS-08, DOCS-09           |
| Advisory output, each state                                                      | —             |                  | ADVISORY-01 to ADVISORY-05 |
| The route taken to the scratch generated project, and the preview output         | —             |                  | PREVIEW-01 to PREVIEW-04   |

---

## Journeys

One `###` section per journey **area**, rows in the order a person moves through the product.

Each row: `ID` · `Action` · `Expected outcome` · `Flow` · `QA` · `Result` · `Notes`. What each
column holds is this folder's `CONTEXT.md`; how each is filled is its `CLAUDE.md`.

### Citation gate

| ID      | Action                                                                                                                                                                                                                                 | Expected outcome                                                                                                                                                                                                             | Flow | QA    | Result | Notes |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| CITE-01 | Open _Recorded during the build_ → the baseline half, and read its date against the story branch's first edit                                                                                                                          | Captured before the first edit: the whole-tree set as `(file, kind, token)` with the line number dropped and multiplicity kept, the detector's `git hash-object` beside it, HEAD and the index state                         | —    | —     |        |       |
| CITE-02 | Re-take `git hash-object code/src/scripts/audits/doc-references.sh` and compare it with the capture                                                                                                                                    | It matches. Had it differed, the close diff is reported **detector-confounded**, never as this story's                                                                                                                       | —    | —     |        |       |
| CITE-03 | With the untracked files added to the index (`git add -N`, plan P0), run `bash code/src/scripts/audits/doc-references.sh`, normalise it the same way and `diff` it against the baseline                                                | Every `>` line is classified by whether its file is in the story's edit set, and anything outside it is named with its owner. A count is never the test, and the gate is never reported as passing while the baseline stands | —    | —     |        |       |
| CITE-04 | Run `bash code/src/scripts/audits/doc-references.sh --path code/docs`                                                                                                                                                                  | Exit 0 and "Clean — every citation resolves." — the story's criterion, a plain pass. Its exit code and count are recorded beside the P0 reading                                                                              | —    | HP-07 |        |       |
| CITE-05 | In a scratch copy, break one backticked path in a guide under `code/docs/`, then run `bash code/src/scripts/audits/doc-references.sh --path code/docs`                                                                                 | Exit 1, naming the broken citation — the scoped criterion is a plain pass or a plain fail                                                                                                                                    | —    | ES-07 |        |       |
| CITE-06 | Run `bash code/src/scripts/audits/doc-references.sh --path <file>` for each shipped file edited outside `code/docs/`: `negative-space.sh`, the settings `CONTEXT.md`, `06-GENERATION.md`, `template-update.sh`, `EDGE-REQUIREMENTS.md` | Exit 0 for each of the five                                                                                                                                                                                                  | —    | —     |        |       |

### The gate over the settings

| ID          | Action                                                                                        | Expected outcome                                                                                                                                                                                        | Flow | QA    | Result | Notes |
| ----------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| SETTINGS-01 | Open `code/src/django/config/settings/base.py` and every environment module beside it         | `CSRF_COOKIE_HTTPONLY = True` is assigned exactly once, in `base.py`, beside `SESSION_COOKIE_HTTPONLY` and `SESSION_COOKIE_SAMESITE`; no environment module re-assigns it                               | —    | HP-02 |        |       |
| SETTINGS-02 | Open `staging.py` and `production.py`                                                         | Each assigns `SESSION_COOKIE_NAME = "__Host-sessionid"` and `CSRF_COOKIE_NAME = "__Host-csrftoken"` beside its `SESSION_COOKIE_SECURE = True` and `CSRF_COOKIE_SECURE = True` lines, in the same module | —    | HP-03 |        |       |
| SETTINGS-03 | Run `bash code/src/scripts/audits/negative-space.sh`                                          | Exit 0, and none of `csrf-cookie-httponly-absent`, `cookie-host-prefix-absent` or `cookie-scope-widened` in the skip notes — the three ran, they did not skip                                           | —    | HP-01 |        |       |
| SETTINGS-04 | In the same run's output, look for `dev.py` and `test.py`                                     | Neither is named by any of the three clauses — no presence claim is made of them, and there is no `Domain` in them to find                                                                              | —    | EC-04 |        |       |
| SETTINGS-05 | Read `base.py`'s comment beside the cookie settings, then the same run's result for `base.py` | The comment names both `SESSION_COOKIE_SECURE` and `CSRF_COOKIE_SECURE` as intentionally absent, and the run reports nothing from it — prose is neither a finding nor a pass                            | —    | EC-02 |        |       |
| SETTINGS-06 | In the same run, look for the settings `CONTEXT.md`, whose table names these settings         | No finding — the clause reads `*.py`, not every file in the directory                                                                                                                                   | —    | EC-03 |        |       |
| SETTINGS-07 | In the same run, look for `__init__.py`, which is empty                                       | No finding, and no error                                                                                                                                                                                | —    | EC-05 |        |       |

### Breaking the settings

Each row is walked in a scratch copy. Run `bash code/src/scripts/audits/negative-space.sh` there
after the change the row names.

| ID       | Action                                                                                                                 | Expected outcome                                                                                                                   | Flow | QA    | Result | Notes |
| -------- | ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| BREAK-01 | Delete the `CSRF_COOKIE_HTTPONLY = True` line from `base.py`                                                           | `csrf-cookie-httponly-absent` fires                                                                                                | —    | ES-01 |        |       |
| BREAK-02 | Delete the `__Host-` session-name line from `staging.py`                                                               | `cookie-host-prefix-absent` fires, naming `staging.py`                                                                             | —    | ES-02 |        |       |
| BREAK-03 | Delete `SESSION_COOKIE_SECURE = True` from `production.py`, keeping its `__Host-` names                                | `cookie-host-prefix-absent` fires — a prefix without its precondition                                                              | —    | ES-03 |        |       |
| BREAK-04 | Add a `SESSION_COOKIE_DOMAIN` assignment to any settings module                                                        | `cookie-scope-widened` fires                                                                                                       | —    | ES-04 |        |       |
| BREAK-05 | Add `CSRF_COOKIE_PATH = "/app"` to any settings module; then change it to `CSRF_COOKIE_PATH = "/"`                     | `cookie-scope-widened` fires for `"/app"`, and does not fire for `"/"`                                                             | —    | ES-05 |        |       |
| BREAK-06 | Add the commented line `# SESSION_COOKIE_DOMAIN = ".example.com"` to any settings module                               | No finding — a match is anchored to an assignment at the start of a line                                                           | —    | EC-01 |        |       |
| BREAK-07 | Remove `staging.py`                                                                                                    | Its presence clause **skips with a note** naming the modules it read — an absent surface reported as such, never reported as clean | —    | EC-06 |        |       |
| BREAK-08 | Remove one fixture file under `code/src/scripts/audits/fixtures/negative-space/`, then run the gate with `--self-test` | Exit 2 with the missing-fixture message — never a silent pass                                                                      | —    | EC-08 |        |       |

### The gate's fixtures

| ID         | Action                                                                                                                                                          | Expected outcome                                                                                                                                                    | Flow | QA    | Result | Notes |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| FIXTURE-01 | Run `bash code/src/scripts/audits/negative-space.sh --self-test` here and in a checkout of the recorded pre-edit SHA, and compare the clause names each reports | The eleven clause names that predate the story behave exactly as before; only the three new names change the result                                                 | —    | EC-07 |        |       |
| FIXTURE-02 | Check `register-absent` by hand against the five new fixture modules under `broken/settings/` and `clean/settings/`                                             | None of the five would trip it — the fixtures are inert for every clause but the three they exist for, and this is the one clause the `--self-test` does not assert | —    | —     |        |       |

### The owner guide and the four deferrals

| ID      | Action                                                                                                                                                                                                                                                                             | Expected outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Flow | QA  | Result | Notes |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | --- | ------ | ----- |
| DOCS-01 | Open `code/docs/security/CRYPTO-AND-DATA.md` → _Browser Storage Policy_ → _Rules_, the cookie-scope bullet                                                                                                                                                                         | Cookies are host-only — `Domain` is never set — and the session and CSRF cookies take `__Host-` names in every environment that serves TLS. The three preconditions are stated — `Secure` (leaning on the existing bullet), `Path` `/`, no `Domain` — with the two N-005 limits, and **[gate: fail]** with the clause names inline. The `SameSite` and `Secure` bullets are unchanged and not restated                                                                                                          | —    | —   |        |       |
| DOCS-02 | In the same guide, find what `CSRF_COOKIE_HTTPONLY` does and does not defend                                                                                                                                                                                                       | A third limit: `HttpOnly` stops a script reading the cookie and nothing more — `{% csrf_token %}` and `hx-headers` put the token in the page, so it is no defence against XSS                                                                                                                                                                                                                                                                                                                                   | —    | —   |        |       |
| DOCS-03 | In the same guide, find which cookies the doctrine covers                                                                                                                                                                                                                          | Session and CSRF only — the `messages` cookie and any language cookie stay unprefixed and are named as not covered                                                                                                                                                                                                                                                                                                                                                                                              | —    | —   |        |       |
| DOCS-04 | In the same guide, find the edge precondition, the dev name divergence and what the gate can see                                                                                                                                                                                   | `SECURE_PROXY_SSL_HEADER` stated as a precondition beside the three; dev's plain names against the TLS environments' `__Host-` names; a green gate proves the settings directory only — not a runtime settings write, an environment-driven value or a module outside that directory                                                                                                                                                                                                                            | —    | —   |        |       |
| DOCS-05 | Open `code/docs/URL-STRATEGY.md` → the Phase 2 bullet                                                                                                                                                                                                                              | The `SESSION_COOKIE_DOMAIN` / `CSRF_COOKIE_DOMAIN` mandate is gone; one sentence routes cookie scope to the owner and says a second host gets its own host-only cookies. Verbatim still: "Admin and portal sessions remain separate — a portal login does not grant admin access"; "Implement subdomain migration only after explicit security review"; and the `CORS_ALLOWED_ORIGINS` sentence, "must be an explicit allowlist — never `*` in production". The Phase 1 and Edge contract bullets are unchanged | —    | —   |        |       |
| DOCS-06 | Open `code/docs/api-design/AUTH-STRATEGY.md` → _The schemes and when to use each_, the Session cookie row                                                                                                                                                                          | The `(SESSION_COOKIE_PATH=/)` fragment is gone; the cell defers — "cookie scope: ../security/CRYPTO-AND-DATA.md, Browser Storage Policy"                                                                                                                                                                                                                                                                                                                                                                        | —    | —   |        |       |
| DOCS-07 | Open the settings blocks in `code/docs/security/AUTH-AND-AUTHZ.md` and `code/docs/security/OWASP-AND-CHECKLIST.md`                                                                                                                                                                 | Each gains `CSRF_COOKIE_HTTPONLY = True` beside its `CSRF_COOKIE_SECURE`, neither gains the `__Host-` names, and each gains one sentence beneath routing cookie names and scope to the Browser Storage Policy                                                                                                                                                                                                                                                                                                   | —    | —   |        |       |
| DOCS-08 | Re-read the seven other cookie-mentioning guides under `code/docs/`: `api-design/AUTH-AND-ERRORS.md`, `api-design/EVENT-TRACKING.md`, `FRONTEND-CODING-PRINCIPLES.md`, `mcp-server/MOUNTING.md`, `rendering/CLAUDE.md`, `visual-design/WEB.md`, `wagtail/ADMIN-AND-PERMISSIONS.md` | None states a cookie's domain, scope, name, path or `httpOnly` against the owner; each is recorded harmless in _Recorded during the build_                                                                                                                                                                                                                                                                                                                                                                      | —    | —   |        |       |
| DOCS-09 | In `code/docs/wagtail/ADMIN-AND-PERMISSIONS.md`, read "A session obtained at the CMS login is a session everywhere"                                                                                                                                                                | Noted and left: it names no setting, and it holds under host-only cookies for as long as every surface shares one host. The note is recorded in _Recorded during the build_                                                                                                                                                                                                                                                                                                                                     | —    | —   |        |       |
| DOCS-10 | Open `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` → Section 6, then its post-deploy verification section                                                                                                                                                                  | Section 6 requires the edge to **strip** any client-supplied `X-Forwarded-Proto` and set it itself; the verification section carries a matching entry. Recorded as a contract term, not a verified control                                                                                                                                                                                                                                                                                                      | —    | —   |        |       |

### Advisory dry run

The advisories are run directly from a scratch copy's root — the working directory their headers
name.

| ID          | Action                                                                                                                                       | Expected outcome                                                                                                                                                                                                                                                                                                                                                       | Flow | QA    | Result | Notes |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | ----- |
| ADVISORY-01 | Plant a `SESSION_COOKIE_DOMAIN` assignment in `staging.py`, then run the unversioned advisory ".copier/migrations/cookie-domain-conflict.sh" | It names that file, its line number and the setting, prints its two operator notes and exits 0 — and prints no value from the file                                                                                                                                                                                                                                     | —    | HP-05 |        |       |
| ADVISORY-02 | Run the same advisory against a clean scratch copy                                                                                           | It prints nothing and exits 0                                                                                                                                                                                                                                                                                                                                          | —    | HP-06 |        |       |
| ADVISORY-03 | Remove `code/src/django/config/settings/` from a scratch copy and run the same advisory                                                      | It exits 0 early and prints nothing                                                                                                                                                                                                                                                                                                                                    | —    | EC-11 |        |       |
| ADVISORY-04 | With the planted line from ADVISORY-01 treated as held deliberately, read the advisory's report and then the tree                            | It reports and changes nothing; its text leaves the operator to judge the line and dismiss it rather than deciding                                                                                                                                                                                                                                                     | —    | EC-10 |        |       |
| ADVISORY-05 | Run the keyed advisory, `v<RELEASE>-host-only-cookies.sh` in `.copier/migrations/`, against a scratch copy, clean or planted                 | It prints the one-time cutover notice — every live session and open CSRF token invalidated at the first deploy; a rollback invalidating them again; a rolling deploy unsafe, surfacing as CSRF 403s rather than a login redirect; anything matching a cookie by name to repoint — ends in the proof step `bash code/src/scripts/audits/negative-space.sh`, and exits 0 | —    | HP-10 |        |       |
| ADVISORY-06 | Open `copier.yml` → `_migrations:`                                                                                                           | Both new entries sit before the trailing unversioned staging-directory entry, which is still last; each carries the `command:` and `when:` lines the existing versioned entries carry; the keyed entry's comment says it is the first minor-keyed migration and that its key is derived at release                                                                     | —    | EC-12 |        |       |
| ADVISORY-07 | Open `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` → the per-version register                                                                 | A row for each new entry — the keyed one in declaration order, the unversioned one in the form a row with no version needs — each marked **Advisory.**                                                                                                                                                                                                                 | —    | —     |        |       |

### Preview proof

Walked in the scratch generated project. The preview is `bash code/src/scripts/development/template-update.sh`
with no `--apply`, and every plant is committed before it runs — its clean-tree guard refuses a
dirty tree (plan P4).

| ID         | Action                                                                                                                  | Expected outcome                                                                                                                                                                                                                                                                                    | Flow | QA    | Result | Notes                             |
| ---------- | ----------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| PREVIEW-01 | With each shipped print-only advisory's own trigger planted, run the preview                                            | The reports of the three already shipped — `v3.0.0`, `v5.0.0` and `v6.0.0`'s report-only third — print into the success-path report block, `v5.0.0`'s twice, being keyed at both `v4.0.0` and `v5.0.0`; exit 0. What prints is whatever the migration stage printed, never a cookie-specific string | —    | HP-09 |        |                                   |
| PREVIEW-02 | Plant a `SESSION_COOKIE_DOMAIN` assignment in `staging.py` and run the preview across the doctrine's release            | The migration report — `cookie-domain-conflict.sh` naming that file, line and setting — appears in the preview's own output, in the block beside "── What this update does ──", **before** "Preview only — your project is unchanged."; exit 0                                                      | —    | HP-08 |        |                                   |
| PREVIEW-03 | From a project at `7.6.0`, or updating from an unreleased ref, still carrying the old `Domain` mandate, run the preview | `cookie-domain-conflict.sh` fires whatever the version — it has no key to be wrong                                                                                                                                                                                                                  | —    | EC-09 |        |                                   |
| PREVIEW-04 | Make the update fail on the copy, then run the preview                                                                  | The failure tail prints once and the script exits 2, as before; the success-path block does not run; the update log is still removed on exit                                                                                                                                                        | —    | ES-08 |        | Awaiting answer — open question 2 |

### Dev-stack cookie walk

Surface: Browser. Walked on the story branch's dev stack, at the base URL `server.sh up` printed.

| ID        | Action                                                               | Expected outcome                                                                                                      | Flow | QA    | Result | Notes                             |
| --------- | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ---- | ----- | ------ | --------------------------------- |
| COOKIE-01 | Open `/control/` at the base URL and sign in as the seeded superuser | Sign-in succeeds                                                                                                      | —    | HP-04 |        |                                   |
| COOKIE-02 | Submit a form                                                        | The submission succeeds                                                                                               | —    | HP-04 |        | Awaiting answer — open question 1 |
| COOKIE-03 | Trigger an HTMX write that carries the template-injected CSRF header | The write succeeds                                                                                                    | —    | HP-04 |        | Awaiting answer — open question 1 |
| COOKIE-04 | Open the browser's cookie store for the base URL                     | Every cookie carries dev's plain name — `sessionid`, `csrftoken` — and no `Domain`; `csrftoken` is flagged `HttpOnly` | —    | HP-04 |        |                                   |
| COOKIE-05 | Open the browser console                                             | No console error                                                                                                      | —    | HP-04 |        |                                   |

### Close

| ID       | Action                                            | Expected outcome                                            | Flow | QA  | Result | Notes |
| -------- | ------------------------------------------------- | ----------------------------------------------------------- | ---- | --- | ------ | ----- |
| CLOSE-01 | Read _Tester sign-off_ against the story's author | The tester who signs is not the author of the story's edits | —    | —   |        |       |

---

## Failures

Filled at the walk. Every `Fail` above, once, with what it blocks. `None.` if the walk was clean.
A failure is **recorded here and fixed elsewhere** — route it exactly as `20-FINDINGS` routes a
finding.

| ID  | What happened | Blocks the story? | Routed to |
| --- | ------------- | ----------------- | --------- |

---

## Tester sign-off

Filled at the walk.

| Field        | Value |
| ------------ | ----- |
| **Tester**   |       |
| **Date**     |       |
| **Browsers** |       |
| **Outcome**  |       |
| **Blockers** |       |

- [ ] Every row carries a `Pass` or a `Fail`, a retired stub excepted — an empty `Result` is an unrun step, never a pass
- [ ] Every _Recorded during the build_ slot filled at its moment, or recorded as missed — never reconstructed
- [ ] Every `Fail` has a reason in `Notes` and a row in _Failures_ with somewhere to go
- [ ] Every journey area the story touches has a section, and every `Flow` cell cites a consolidated step or `—`
- [ ] Every amended row carries its trail in `Notes` and a finding in `../../20-FINDINGS/` — no row silently rewritten
- [ ] No secrets, real credentials, or personal data used or exposed during the walk
- [ ] Cross-checked against `../AUTOMATED/US008-TEST-STATUS.md` — a manual `Fail` and a green suite means a missing test

---

## Cross-references

- `../../02-STORIES/US008.md` — the story under test; its _QA Acceptance Criteria — Manual_ is the bar this guide is judged against
- `../../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md` — the implementation plan this guide was authored beside
- `../AUTOMATED/US008-TEST-STATUS.md` — the paired automated-test record; it does not exist until `22-implementation-documentation` writes it
- `../../11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` — where the `QA` column's scenario IDs are defined
- `../../11-QA/IMPLEMENTATION/` — whether the specified scenarios were met, recorded at the closeout
- `../../05-USER-FLOW/CONSOLIDATED-IDEAS/` — where the `Flow` column's step numbers would be defined; this story has no user flow, so every `Flow` cell is `—`
- `../../10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` — the thirteen security constraints the owner-guide rows read against
- `../../20-FINDINGS/` — where each amendment made at the walk is recorded
- `code/docs/GATE-REPORTING.md` — why a skipped clause, an unrunnable scenario or an inherited-red gate is never reported as a pass
