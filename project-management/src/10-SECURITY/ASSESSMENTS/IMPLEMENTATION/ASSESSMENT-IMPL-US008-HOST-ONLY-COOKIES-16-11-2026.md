# Security Posture Assessment (Implementation) — US008 Host-only cookies under `__Host-` names

| Field           | Value                                                                                                                                                                                                        |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Story**       | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule                                                                                               |
| **Date**        | 16/11/2026                                                                                                                                                                                                   |
| **Verified by** | Claude Code — independent tester/recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                                                                 |
| **Sprint**      | SPRINT-05                                                                                                                                                                                                    |
| **Plan doc**    | `../PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` (frozen; corrected in place 28/09/2026; security clarification approved 09/10/2026)                                                                 |
| **Outcome**     | PASS with deferred items — all thirteen constraints (7.1–7.13) closed with evidence at HEAD `43acdf5`; no CRITICAL or HIGH introduced. Two runtime browser checks are **unmeasured**, not passed (Section 6) |

---

## 1. Scope

The shipped surface matches the plan's — settings, gate, owner guide, four deferring guides, two
advisories, the preview channel and the edge clause — with one addition: the cookie clauses live in
a sourced library, `code/src/scripts/audits/_lib/negative-space-cookies.sh`, and the advisory carries
a byte-identical twin of its scanner (rulings Q10–Q13, 16/11/2026). Line references are on HEAD
`43acdf5`; the threat-model review lists the commands this pass ran.

| File                                                                                                                                                         | What was assessed here                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| `code/src/django/config/settings/base.py`                                                                                                                    | `CSRF_COOKIE_HTTPONLY = True` `:161`                                                                                           |
| `code/src/django/config/settings/staging.py`                                                                                                                 | `__Host-` names `:23-24` beside `*_COOKIE_SECURE = True` `:21-22`; proxy header `:19`                                          |
| `code/src/django/config/settings/production.py`                                                                                                              | The same `:19-24`                                                                                                              |
| `code/src/scripts/audits/_lib/negative-space-cookies.sh`                                                                                                     | The three clauses (`run_cookie_clauses` `:108-181`) and their self-test                                                        |
| `code/src/scripts/audits/negative-space.sh`                                                                                                                  | Scope `SETTINGS_DIR` `:99`, library sourced `:481`, clauses run `:487`, `EXPECTED` `:530-533`                                  |
| `.copier/migrations/cookie-domain-conflict.sh`                                                                                                               | State-gated advisory — names only, `exit 0`                                                                                    |
| `.copier/migrations/host-only-cookies.sh`                                                                                                                    | Pending cutover notice                                                                                                         |
| `copier.yml`                                                                                                                                                 | `_migrations:` entries `:1061-1062` and `:1080-1081`; helper excluded `:55`                                                    |
| `code/src/scripts/development/template-update.sh`                                                                                                            | Success-path replay `:193-212`                                                                                                 |
| `code/docs/security/CRYPTO-AND-DATA.md`                                                                                                                      | The owner guide, `:122-222`                                                                                                    |
| `code/docs/URL-STRATEGY.md` · `code/docs/api-design/AUTH-STRATEGY.md` · `code/docs/security/AUTH-AND-AUTHZ.md` · `code/docs/security/OWASP-AND-CHECKLIST.md` | The four deferring guides (`URL-STRATEGY.md:149`, `AUTH-STRATEGY.md:67`, `AUTH-AND-AUTHZ.md:145`, `OWASP-AND-CHECKLIST.md:57`) |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`                                                                                                        | Scheme-header clause `:144-153`; verification `:346`; status `:360`                                                            |

## 2. OWASP Top 10 — coverage

| ID       | Category                              | Status   | Evidence / Notes                                                                                                                                                                                                                                                   |
| -------- | ------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| A01:2025 | Broken Access Control (incl. SSRF)    | PASS     | TM-01 closed by the `__Host-` names (`staging.py:23-24`, `production.py:23-24`) and gated (`negative-space-cookies.sh:142-181`). TM-02 narrowed: any TLS-turning module is held to the rule (`:148-153`). TM-07 residual, named (`CRYPTO-AND-DATA.md:167-169`)     |
| A02:2025 | Security Misconfiguration             | PASS     | No `*_COOKIE_DOMAIN` / `*_COOKIE_PATH` in any settings module (grep 16/11/2026); `cookie-scope-widened` proves it; `negative-space.sh` unscoped exit 0. TM-08 residual stated (`CRYPTO-AND-DATA.md:201-222`); TM-09 the planned register under-count               |
| A03:2025 | Software Supply Chain Failures        | PASS     | TM-15: no design-time key — pending entry `when: false`, no `version:` (`copier.yml:1080-1081`), release obligation `24-release/CHECKLIST.md:28`. TM-14: both scripts advisory, `exit 0`. TM-06 limit stated (`CRYPTO-AND-DATA.md:139-142`)                        |
| A04:2025 | Cryptographic Failures                | N/A      | No key, secret or algorithm touched                                                                                                                                                                                                                                |
| A05:2025 | Injection                             | N/A      | Cookie names are literals; the scanner reads files and prints names, never values or input                                                                                                                                                                         |
| A06:2025 | Insecure Design                       | PASS     | Doctrine as argued on the map's cookie spine; owner guide is the single home and four guides defer (DOCS-01 to DOCS-08 Pass)                                                                                                                                       |
| A07:2025 | Authentication Failures               | PARTIAL  | TM-05: precondition stated (`CRYPTO-AND-DATA.md:158-166`) and contracted (`EDGE-REQUIREMENTS.md:144-153`); the edge control is the deploy repo's and unverifiable here                                                                                             |
| A08:2025 | Software and Data Integrity Failures  | PASS     | The gate and advisory scanner are held byte-identical by `cookie_self_test_parity` (`negative-space-cookies.sh:549-581`); `--self-test` exit 0                                                                                                                     |
| A09:2025 | Security Logging & Alerting Failures  | DEFERRED | TM-13 accepted residual — a browser's silent rejection is undetectable by the application (`CRYPTO-AND-DATA.md:133-136`)                                                                                                                                           |
| A10:2025 | Mishandling of Exceptional Conditions | PASS     | TM-04 closed by the preview replay (`template-update.sh:193-212`, PREVIEW-01 to PREVIEW-04 Pass); TM-10/TM-11 in the cutover notice (`host-only-cookies.sh:49-60`); TM-12 in the owner guide (`CRYPTO-AND-DATA.md:153-157`); unreadable module = finding, not pass |

## 3. NIST CSF 2.0 — coverage

| Fn  | Function | Status  | Evidence                                                                                                                                                         |
| --- | -------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | PASS    | One owner (`CRYPTO-AND-DATA.md:146-222`); the parent-`Domain` mandate removed from `URL-STRATEGY.md:149`; three other guides defer                               |
| ID  | Identify | PASS    | Three limits stated (`:137-142`); "what the gate can and cannot see" enumerated (`:170-222`)                                                                     |
| PR  | Protect  | PASS    | Settings `:19-24` in both TLS modules, `base.py:161`; three `[gate: fail]` clauses, fail-closed, no suppression annotation                                       |
| DE  | Detect   | PARTIAL | The gate detects settings regressions, including unrecognised forms and unreadable modules; runtime writes and browser rejection (TM-08, TM-13) remain invisible |
| RS  | Respond  | PARTIAL | The state advisory names file, line and setting with a remedy on every update; a rejected cookie in production still surfaces only as a failed login             |
| RC  | Recover  | PASS    | Rollback cost and cutover shape stated (`host-only-cookies.sh:53-60`); delivery pending until the release activates the entry                                    |

## 4. Findings

Findings raised by this review of the shipped code. **No CRITICAL or HIGH finding was identified**;
nothing escalates to `../../VULNERABILITIES/IMPLEMENTATION/`.

| ID    | STRIDE | OWASP    | NIST CSF | Severity | Finding                                                                                                                                                                          | Recommendation                                                                                | Status   |
| ----- | ------ | -------- | -------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | -------- |
| A-001 | I      | A09:2025 | PR.DS    | INFO     | The preview now replays the whole update log; a future migration printing a value would reach the terminal. US008's own advisories print names only (scratch run, value absent)  | State the never-print-a-value rule for every `.copier/migrations/` script, not only these two | Open     |
| A-002 | T      | A02:2025 | DE.CM    | LOW      | The audits register row for `negative-space.sh` (`code/src/scripts/audits/CONTEXT.md` → _Scripts_) still says twelve clauses and names no cookie clause; the script says fifteen | Already the story's named cost (TM-09); correct when that file next has headroom              | Residual |
| A-003 | —      | A02:2025 | ID.AM    | INFO     | Outside US008: story stacks on `:3080` fail every form POST — `CSRF_TRUSTED_ORIGINS` in `dev.py` lists only the `:81` origins (COOKIE-01 note). Dev-only, fails closed           | Route to the dev-stack owner; not a US008 defect                                              | Open     |

## 5. Planning-phase findings — status update

| Plan finding | Status   | Evidence / Notes                                                                                                                         |
| ------------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01        | Resolved | `staging.py:21-24`, `production.py:21-24`; `cookie-host-prefix-absent`; SETTINGS-02, BREAK-02/03 Pass. TLS browser acceptance unmeasured |
| TM-02        | Resolved | Content-based TLS discovery `negative-space-cookies.sh:148-153`, packages `:142-145`; self-test R3, QA2-05, QA3-01                       |
| TM-03        | Resolved | `cookie-domain-conflict.sh` via `copier.yml:1061-1062`; ADVISORY-01 to ADVISORY-04 Pass; scratch run reproduced                          |
| TM-04        | Resolved | `template-update.sh:193-212`; PREVIEW-01 to PREVIEW-04 Pass                                                                              |
| TM-05        | Residual | Stated and contracted; enforced only by the deploy repo (`EDGE-REQUIREMENTS.md:152-153`)                                                 |
| TM-06        | Resolved | `base.py:161`; limit `CRYPTO-AND-DATA.md:139-142`; COOKIE-04 Pass                                                                        |
| TM-07        | Residual | Named scope `CRYPTO-AND-DATA.md:167-169`                                                                                                 |
| TM-08        | Residual | Narrowed; the remainder enumerated `CRYPTO-AND-DATA.md:201-222`                                                                          |
| TM-09        | Residual | A-002                                                                                                                                    |
| TM-10        | Resolved | `host-only-cookies.sh:49-55`; ADVISORY-05, ADVISORY-09 Pass                                                                              |
| TM-11        | Resolved | `host-only-cookies.sh:56-60`; ADVISORY-05, ADVISORY-09 Pass                                                                              |
| TM-12        | Resolved | `CRYPTO-AND-DATA.md:153-157`; DOCS-04 Pass                                                                                               |
| TM-13        | Residual | Accepted, `CRYPTO-AND-DATA.md:133-136`                                                                                                   |
| TM-14        | Resolved | Both scripts `exit 0` (`cookie-domain-conflict.sh:159`, `host-only-cookies.sh:74`); self-test QA3-05                                     |
| TM-15        | Resolved | `copier.yml:1064-1081`; `24-release/CHECKLIST.md:28`; ADVISORY-06/07/08 Pass                                                             |

## 6. Plan gaps closed & deferred items

| Item                                                           | Status   | Evidence / Blocked by                                                                                                                                                                   |
| -------------------------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.1 Prefix preconditions in the same module                    | Closed   | `staging.py:21-24`, `production.py:21-24`; `cookie_state` reads per module (`negative-space-cookies.sh:154-168`); BREAK-03 Pass                                                         |
| 7.2 Every TLS module bound; clauses name what they read        | Closed   | `:148-153` (any non-`False`/`None` SECURE record); skip notes `:111-114`, `:145`; SETTINGS-04 Pass                                                                                      |
| 7.3 No Domain / non-root Path; assignment-anchored             | Closed   | `COOKIE_WIDE` `:92`; comment cut, string-aware; BREAK-04/05/06 Pass. **Superseded in part by ruling Q14/Q16**: indented forms now count for overrides and scope, not for presence       |
| 7.4 Scope moves together; skip with a note when absent         | Closed   | `SETTINGS_DIR` declared beside `SETTINGS_FILE` and repointed by `point_scopes_at` (`negative-space.sh:99`, `:501`); absent-dir skips `negative-space-cookies.sh:110-115`; BREAK-07 Pass |
| 7.5 Proxy header a stated precondition; edge strip clause      | Closed   | `CRYPTO-AND-DATA.md:158-166`; `EDGE-REQUIREMENTS.md:144-153`, `:346` (origin hop, ruling Q5/Q6); DOCS-04, DOCS-10 Pass. The control itself: deferred to the deploy repo                 |
| 7.6 Three limits                                               | Closed   | `CRYPTO-AND-DATA.md:137-142`; DOCS-02, DOCS-03 Pass                                                                                                                                     |
| 7.7 What the gate can and cannot see                           | Closed   | `CRYPTO-AND-DATA.md:170-222`; DOCS-04 Pass (amended row, see Section 7)                                                                                                                 |
| 7.8 Dev/TLS name divergence in the owner guide                 | Closed   | `CRYPTO-AND-DATA.md:153-157`                                                                                                                                                            |
| 7.9 Invalidation both ways; cutover shape                      | Closed   | `host-only-cookies.sh:49-60`; ADVISORY-05 Pass                                                                                                                                          |
| 7.10 No silencing annotation; register under-count recorded    | Closed   | No annotation exists (`CRYPTO-AND-DATA.md:194-195`); under-count is A-002                                                                                                               |
| 7.11 The advisory reaches its operator                         | Closed   | `template-update.sh:193-212`; PREVIEW-01 to PREVIEW-04 Pass; full body, not banner (09/10/2026 clarification)                                                                           |
| 7.12 Names, lines and settings — never a value                 | Closed   | `cookie-domain-conflict.sh:122`, `:155`; scratch run: planted value absent from output; PREVIEW-02 Pass                                                                                 |
| 7.13 Two entries; key derived at release                       | Closed   | `copier.yml:1061-1062` (state-gated) and `:1080-1081` (pending, `when: false`, unversioned filename); ADVISORY-08/09/10 Pass                                                            |
| QA EC-17 / HP-04 runtime write path (09/10/2026 clarification) | Deferred | **Unmeasured** — COOKIE-03, COOKIE-06: the fixture's HTMX asset 404s because dev nginx serves an empty `/static/` (COOKIE-05 Fail, routed to `21-BUGS/`). Re-walk after the fix         |
| `__Host-` acceptance in a real TLS browser session             | Deferred | **Unmeasured** — no TLS environment exists in a template at posture `development`                                                                                                       |

## 7. Deviations from plan

- **The cookie clauses moved to `_lib/negative-space-cookies.sh`** (ruling Q11): `negative-space.sh`
  was at 746/750 lines. Behaviour unchanged at the move (commit `82f72db`).
- **The gate fails closed** (rulings Q14/Q16/Q17), widening 7.3 and 7.2: any unrecognised occurrence of
  a tracked name is a finding, a read included, and any module turned TLS by a non-`False`/`None`
  SECURE record is held to `__Host-` names. Consequence stated: a computed SECURE value in `base.py`
  asks `base.py` for `__Host-` names (`CRYPTO-AND-DATA.md:183-186`).
- **The pre-change gate capture reports two presence clauses, three findings**; `cookie-scope-widened`
  is proved by fixtures only (P1 ruling Q1). BREAK-08 splits: directory exit 2, file exit 1 (Q2).
- **The cutover script ships unversioned** (`host-only-cookies.sh`), renamed at release — so its
  versioned filename in ADVISORY-05 is true only at release; ADVISORY-07 expects a pending row.
- **The edge verification targets the origin hop**, not the tunnel (rulings Q5/Q6).
- **The browser walk ran in a scratch clone from v2.3.1**, using `code/src/scripts/tests/cookie-preview-fixture.sh`,
  which `copier.yml:55` excludes from generated projects.
- Five manual rows were amended with their trail (CITE-06, FIXTURE-02, DOCS-04, ADVISORY-05,
  ADVISORY-07); their finding IDs are pending (`F-0??` in the guide).

## 8. Sign-off

| Reviewer                                                   | Role                          | Date       |
| ---------------------------------------------------------- | ----------------------------- | ---------- |
| Claude Code (independent recorder, `security` skill, Opus) | Security posture verification | 16/11/2026 |
| <%DEVELOPER_NAME%>                                         | Developer sign-off — pending  | —          |

**Overall verdict:** the story meets the baseline's posture targets — all thirteen constraints close
with shipped evidence and no CRITICAL or HIGH was introduced. Two runtime checks are unmeasured
and recorded as such, never as passes (`code/docs/GATE-REPORTING.md`).

---

## Cross-references

- `../PLANNING/ASSESSMENT-PLAN-US008-HOST-ONLY-COOKIES.md` — the baseline answered here
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md` — the re-assessed STRIDE model consumed here
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md` — the post-build audit and the review-round bypasses
- `../../VULNERABILITIES/IMPLEMENTATION/` — any newly found CRITICAL/HIGH escalated here; none
- `../../../02-STORIES/US008.md` — the source story
- `../../../18-TESTS/MANUAL/US008-MANUAL-TESTING.md` · `../../../18-TESTS/AUTOMATED/US008-TEST-STATUS.md` — row IDs and automated captures cited above
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
