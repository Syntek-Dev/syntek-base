# Threat Model Review — US008 Host-only cookies under `__Host-` names

| Field           | Value                                                                                                                                                                                                                                                       |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule                                                                                                                                              |
| **Date**        | 16/11/2026                                                                                                                                                                                                                                                  |
| **Verified by** | Claude Code — independent tester/recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                                                                                                                |
| **Plan doc**    | `../PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` (frozen; corrected in place 28/09/2026; security clarification approved 09/10/2026)                                                                                                              |
| **Outcome**     | PASS with deferred items — all fifteen planned threats closed (eleven mitigated, four tracked residuals); three new items, none CRITICAL or HIGH. Two runtime browser checks (QA EC-17, HP-04 write path) remain **unmeasured**, not passed — see Section 5 |

---

## 1. Scope

**What shipped is the surface the plan modelled, on branch `us008/host-only-cookies` at `43acdf5`.**
No endpoint, model, migration, template or log line changed. Every `file:line` below is read on
HEAD `43acdf5`. The surface widened in one place the plan did not foresee: the cookie clauses
moved out of `negative-space.sh` into a sourced library (ruling Q11, commit `82f72db`), and the
copier advisory carries a byte-identical twin of the gate's scanner (rulings Q10–Q13).

**Commands run by this review, 16/11/2026, from the repository root on the host:**

| Command                                                                                                                                                                                                                                      | Result                                                                                                                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bash code/src/scripts/audits/negative-space.sh --self-test`                                                                                                                                                                                 | exit 0 — "Self-test passed — broken/ trips 14 clauses, clean/ trips none." (the cookie half, `cookie_self_test`, runs inside it)                                                                                                          |
| `bash code/src/scripts/audits/negative-space.sh`                                                                                                                                                                                             | exit 0 — "15 fail, 1 warn" clauses registered; skip notes only `htmx-handler-absent` and `mcp-*`, **no cookie clause skipped**; "Register and code agree."                                                                                |
| Scratch copy: `tmp=$(mktemp -d /tmp/us008-sec.XXXX); git archive HEAD \| tar -x -C "$tmp"`, then `cookie-domain-conflict.sh` clean, a `SESSION_COOKIE_DOMAIN` line appended to `staging.py`, the migration and the gate re-run; copy removed | Clean: silent, exit 0. Planted: the advisory named `staging.py:50  SESSION_COOKIE_DOMAIN`, **printed no value**, "Nothing was changed", exit 0; the gate reported `cookie-scope-widened: …/staging.py:50 — assigns SESSION_COOKIE_DOMAIN` |

The independent automated pass (`project-management/src/18-TESTS/AUTOMATED/US008-TEST-STATUS.md`)
re-ran the self-test under gawk 5.4.1, mawk 1.3.4 and busybox 1.37 awk (exit 0 under each; BSD awk
unmeasured, not on the host). The manual walk (`project-management/src/18-TESTS/MANUAL/US008-MANUAL-TESTING.md`)
marked 50 Pass, 1 Fail, 3 Unmeasured; row IDs are cited below.

| File                                                     | Purpose                                                                                                                                    |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `code/src/django/config/settings/base.py`                | `CSRF_COOKIE_HTTPONLY = True` at `:161`; the SECURE-absent-in-dev note at `:162`                                                           |
| `code/src/django/config/settings/staging.py`             | `SECURE_PROXY_SSL_HEADER` `:19`, `SECURE_SSL_REDIRECT` `:20`, both `*_COOKIE_SECURE = True` `:21-22`, both `__Host-` names `:23-24`        |
| `code/src/django/config/settings/production.py`          | The same block at `:19-24`, byte-identical to staging's                                                                                    |
| `code/src/scripts/audits/_lib/negative-space-cookies.sh` | `COOKIE_AWK` scanner `:36`, `COOKIE_WIDE` `:92`, `run_cookie_clauses` `:108-181`, `cookie_self_test*` `:185-581`                           |
| `code/src/scripts/audits/negative-space.sh`              | `SETTINGS_DIR` `:99`, header clause list `:23-25`, `source` of the library `:481`, `run_cookie_clauses` call `:487`, `EXPECTED` `:530-533` |
| `.copier/migrations/cookie-domain-conflict.sh`           | The state-gated advisory; scanner twin `:58` / `:112`; unreadable-module lines `:129-131`; findings `:136-139`; `exit 0` `:159`            |
| `.copier/migrations/host-only-cookies.sh`                | The pending cutover notice (unversioned filename until release); four-point advice `:49-66`; `exit 0` `:74`                                |
| `copier.yml`                                             | Helper excluded `:55`; state-gated entry `:1061-1062`; pending entry `when: false` `:1080-1081`                                            |
| `code/src/scripts/development/template-update.sh`        | Full update-log replay on the success path `:193-212`; failure tail `:151-162`                                                             |
| `code/docs/security/CRYPTO-AND-DATA.md`                  | Owner guide: rule `:122-132`, preconditions `:133-136`, three limits `:137-142`, cookie scope `:146-222`                                   |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`    | Strip-and-set scheme-header clause `:144-153`; origin-hop verification row `:346`; status row 6 `:360`                                     |
| `project-management/workflows/24-release/CHECKLIST.md`   | Activate-pending-entries line `:28` (template-only)                                                                                        |

## 2. Trust boundaries — confirmed

| ID  | Boundary                              | Change since plan                                                                                                                                                                                 |
| --- | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TB1 | Browser cookie jar ↔ apex host        | Unchanged. Names now differ by environment (dev plain, TLS `__Host-`)                                                                                                                             |
| TB2 | Sibling/sub host ↔ cookie jar         | Unchanged; closed for the two named cookies by the prefix                                                                                                                                         |
| TB3 | Page JavaScript ↔ cookie jar and DOM  | Unchanged. The CSRF cookie is no longer readable from `document.cookie` (COOKIE-04); the token remains in the DOM by design                                                                       |
| TB4 | Edge proxy ↔ Django                   | Unchanged in code; now a written contract term (`EDGE-REQUIREMENTS.md:144-153`), unverifiable from this tree                                                                                      |
| TB5 | Settings module ↔ running application | **Altered** — the gate now discovers TLS modules by content (any `SECURE_SSL_REDIRECT`/`*_COOKIE_SECURE` other than a recognised `False`/`None`), and reads `staging/` and `production/` packages |
| TB6 | Template ↔ generated project          | **Altered** — two `_migrations:` entries (one always-on, one pending), plus the preview now replays the full update log to the operator                                                           |
| TB7 | A future edit ↔ the gate's verdict    | **Altered** — the gate fails closed on unrecognised forms and has a second enforcer (the migration twin) held byte-identical by a text-parity self-test                                           |

## 3. STRIDE threat re-assessment

| ID    | STRIDE | OWASP      | NIST CSF | TB  | Threat description                                                    | Severity | Status    | Mitigation (as shipped)                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ----- | ------ | ---------- | -------- | --- | --------------------------------------------------------------------- | -------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| TM-01 | S      | `A01:2025` | `PR.AA`  | TB2 | Session fixation by subdomain write                                   | MEDIUM   | Mitigated | `staging.py:23-24` / `production.py:23-24` assign `__Host-sessionid` / `__Host-csrftoken` beside `*_COOKIE_SECURE = True` (`:21-22`); no `*_COOKIE_DOMAIN`/`*_COOKIE_PATH` anywhere under `config/settings/` (grep, 16/11/2026). Enforced by `cookie-host-prefix-absent` and `cookie-scope-widened` (`negative-space-cookies.sh:142-181`); SETTINGS-02/03, BREAK-02/03/04 Pass. **Browser storage of the prefixed cookie under TLS is unmeasured** — no TLS environment exists |
| TM-02 | E      | `A01:2025` | `PR.AA`  | TB5 | A deployed module the prefix and the gate never reach                 | MEDIUM   | Mitigated | Beyond plan: any module where `SECURE_SSL_REDIRECT` or `*_COOKIE_SECURE` occurs other than a recognised `False`/`None` is held to the `__Host-` rule (`negative-space-cookies.sh:148-153`); packages read (`:142-145`); skip notes name what each clause read (`:111-114`, `:145`). Self-test R3, QA2-05, QA3-01 cases. Owner guide `CRYPTO-AND-DATA.md:170-186` states the rule for any TLS module                                                                            |
| TM-03 | T      | `A02:2025` | `RC.RP`  | TB6 | A merge leaves `Domain` beside `__Host-`; every login fails           | MEDIUM   | Mitigated | `cookie-domain-conflict.sh`, unversioned and state-gated (`copier.yml:1061-1062`), reports file, line and setting, never a value (`:122`, `:136-139`), exits 0 (`:159`). Scratch run above; ADVISORY-01/02/03/04, ADVISORY-08/09/10 Pass                                                                                                                                                                                                                                       |
| TM-04 | D      | `A10:2025` | `DE.CM`  | TB6 | The advisory is invisible in a successful preview                     | MEDIUM   | Mitigated | `template-update.sh:193-212` replays the captured update log complete and once, between named rules, before the preview-only notice; failure path unchanged (`:151-162`). PREVIEW-01/02/03/04 Pass (full body, no value, exit 0)                                                                                                                                                                                                                                               |
| TM-05 | S      | `A07:2025` | `PR.AA`  | TB4 | `SECURE_SSL_REDIRECT` trusts a client-suppliable header               | MEDIUM   | Residual  | Precondition stated in the owner guide (`CRYPTO-AND-DATA.md:158-166`) and the contract clause written (`EDGE-REQUIREMENTS.md:144-153`, verification row `:346` targets the origin hop per ruling Q5/Q6). DOCS-04/DOCS-10 Pass. The control itself lives in the deploy repo; "a contract term, not a verified control" (`EDGE-REQUIREMENTS.md:152-153`)                                                                                                                         |
| TM-06 | I      | `A03:2025` | `PR.DS`  | TB3 | `HttpOnly` does not defend the token against XSS                      | LOW      | Mitigated | `base.py:161`; the limit is stated beside the rule (`CRYPTO-AND-DATA.md:139-142`) and client code is told to read the token from the DOM (`:150-152`). COOKIE-04 Pass (`csrftoken` `HttpOnly` true), DOCS-02 Pass                                                                                                                                                                                                                                                              |
| TM-07 | T      | `A01:2025` | `PR.DS`  | TB2 | `messages` and language cookies stay unprefixed                       | LOW      | Residual  | Scoped and named: `CRYPTO-AND-DATA.md:167-169`; `django.contrib.messages` still installed (`base.py:33`, `:59`). DOCS-03 Pass. Accepted per plan Section 5                                                                                                                                                                                                                                                                                                                     |
| TM-08 | T      | `A02:2025` | `DE.CM`  | TB7 | The gate reads a directory; the rule is global                        | MEDIUM   | Residual  | Narrowed well beyond the plan (fail-closed, last-assignment-wins, string tracking, packages, symlinks, unreadable modules — Section 4 of the audit) and the remainder stated: `CRYPTO-AND-DATA.md:201-222` "A green run proves that directory, not a global rule". Listed as accepted residuals in the audit record                                                                                                                                                            |
| TM-09 | T      | `A02:2025` | `DE.CM`  | TB7 | The gate's register under-counts its clauses                          | LOW      | Residual  | As planned: `code/src/scripts/audits/CONTEXT.md` → _Scripts_, `negative-space.sh` row, still says "Twelve `[gate: fail]`" and names no cookie clause, while the script header (`negative-space.sh:10`) says fifteen. The named cost of Q3. No silencing annotation exists (fails-closed rule, `CRYPTO-AND-DATA.md:194-195`)                                                                                                                                                    |
| TM-10 | D      | `A10:2025` | `RC.RP`  | TB1 | Rollback invalidates every session a second time                      | MEDIUM   | Mitigated | `host-only-cookies.sh:49-55` (point 1: first deploy invalidates; point 2: "A rollback is not free"). ADVISORY-05, ADVISORY-09 Pass. Delivery is pending until release (Section 5)                                                                                                                                                                                                                                                                                              |
| TM-11 | D      | `A10:2025` | `PR.PS`  | TB1 | A rolling deploy serves both names at once                            | MEDIUM   | Mitigated | `host-only-cookies.sh:56-60` (point 3: "A rolling deploy is UNSAFE … Stop-start, or drain"). ADVISORY-05, ADVISORY-09 Pass                                                                                                                                                                                                                                                                                                                                                     |
| TM-12 | D      | `A10:2025` | `PR.PS`  | TB5 | Dev and production differ by cookie name; literal matches rot         | LOW      | Mitigated | Owner guide, read by every project: `CRYPTO-AND-DATA.md:153-157`; the cutover notice point 4 (`host-only-cookies.sh:61-66`). DOCS-04 Pass                                                                                                                                                                                                                                                                                                                                      |
| TM-13 | R      | `A09:2025` | `DE.AE`  | TB1 | A browser discards a malformed prefixed cookie in silence             | INFO     | Residual  | Named, not detected: `CRYPTO-AND-DATA.md:133-136` ("no error, no log, just an anonymous request"). Accepted per plan                                                                                                                                                                                                                                                                                                                                                           |
| TM-14 | E      | `A03:2025` | `PR.PS`  | TB6 | Two scripts join the `--trust` execution surface, one on every update | INFO     | Mitigated | Both advisory-only and `exit 0` always (`cookie-domain-conflict.sh:159`, `host-only-cookies.sh:74`); the always-on one exits silently when clean (`:126`) and reads only `config/settings/*.py`. Self-test QA3-05 pins the exit 0 on both paths. Counted: the surface widened by exactly these two                                                                                                                                                                             |
| TM-15 | T      | `A03:2025` | `PR.PS`  | TB6 | A design-time version key names a release without the doctrine        | MEDIUM   | Mitigated | No key written: pending entry `when: false`, no `version:` (`copier.yml:1080-1081`), unversioned filename, activation recipe in the entry comment (`:1064-1079`) and in `24-release/CHECKLIST.md:28`. The always-wrong state rides the keyless entry, so no key can strand it. ADVISORY-06/07/08 Pass                                                                                                                                                                          |

## 4. New threats identified during implementation

- **TM-N1 (LOW, closed)** — **the gate could be bypassed by assignment forms it did not model.**
  Three review rounds found and closed them (semicolons, tuple unpacking, `del`, walrus, indented,
  annotated, chained, augmented, later overrides, symlinks, packages, CRLF, unreadable modules,
  TLS turned on by an unrecognised form). Each has a named self-test case. Detailed by ID in the
  audit record, Section 2.
- **TM-N2 (LOW, closed)** — **the gate and the copier advisory could drift as two detectors of one
  rule.** Mitigated by one scanner program carried twice and held byte-identical by
  `cookie_self_test_parity` (`negative-space-cookies.sh:549-581`, text parity QA2-03 plus
  behavioural parity on both fixture trees).
- **TM-N3 (INFO, accepted)** — **the preview now replays everything the update printed.** A
  migration that printed a sensitive value would now reach the terminal on a successful preview.
  The shipped advisories print names only (scratch run above: the planted value was absent). This
  is a property of every future migration rather than of US008, and no rule yet says so outside
  this story's advisories. Recorded rather than escalated.

No new CRITICAL or HIGH. Nothing escalates to `../../VULNERABILITIES/IMPLEMENTATION/`.

## 5. Residual & deferred items

| Item                                                                                  | Threat IDs   | Severity | Tracked in / when                                                                                                                              |
| ------------------------------------------------------------------------------------- | ------------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Edge must strip a client `X-Forwarded-Proto` and set its own                          | TM-05        | MEDIUM   | `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md:144-153`, status row 6 `:360` — deploy-repo obligation                                    |
| What the line scanner cannot see (runtime writes, env values, `import *`, NFKC, …)    | TM-08, TM-N1 | MEDIUM   | `code/docs/security/CRYPTO-AND-DATA.md:201-222`; listed one by one in the audit record, Section 6                                              |
| `messages` and language cookies unprefixed                                            | TM-07        | LOW      | `code/docs/security/CRYPTO-AND-DATA.md:167-169`                                                                                                |
| Register row under-counts the gate                                                    | TM-09        | LOW      | Named cost of Q3 in the story; `code/src/scripts/audits/CONTEXT.md` row unchanged                                                              |
| Silent browser rejection of a malformed prefixed cookie                               | TM-13        | INFO     | Owner guide `:133-136`; accepted                                                                                                               |
| Cutover notice ships pending: key, filename and `when` set only in the release commit | TM-10/11/15  | —        | `copier.yml:1064-1081`; `project-management/workflows/24-release/CHECKLIST.md:28`. ADVISORY-05's versioned filename is true only at release    |
| Runtime CSRF write path and missing-header 403 control (QA EC-17)                     | TM-06        | —        | **Unmeasured** — COOKIE-03, COOKIE-06; blocked by the dev stack's `/static/` 404 (COOKIE-05 Fail, routed to `21-BUGS/`). Re-walk after the fix |
| Browser acceptance of `__Host-` names under TLS                                       | TM-01        | —        | **Unmeasured** — no TLS environment; the automated record lists it among the browser-only checks                                               |

## 6. Sign-off

| Reviewer                                                   | Role                         | Date       |
| ---------------------------------------------------------- | ---------------------------- | ---------- |
| Claude Code (independent recorder, `security` skill, Opus) | Security re-assessment       | 16/11/2026 |
| <%DEVELOPER_NAME%>                                         | Developer sign-off — pending | —          |

**Overall verdict:** no CRITICAL or HIGH introduced or outstanding; every planned threat has a final
status with shipped evidence, and each residual is named in the owner guide or the edge contract.
Two runtime browser checks are unmeasured, not passed.

---

## Cross-references

- `../PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` — the pre-implementation model re-assessed here
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md` — the posture assessment that consumes this review
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md` — the post-build audit, with the review-round bypasses by ID
- `../../VULNERABILITIES/IMPLEMENTATION/` — where new CRITICAL/HIGH findings are escalated; none from this review
- `../../../02-STORIES/US008.md` — the story reviewed
- `../../../18-TESTS/MANUAL/US008-MANUAL-TESTING.md` · `../../../18-TESTS/AUTOMATED/US008-TEST-STATUS.md` — the walked rows and the automated record cited above
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `code/docs/SECURITY.md` · `code/docs/GATE-REPORTING.md` — the code-side enforcement, and why the unmeasured rows are not reported as passes
