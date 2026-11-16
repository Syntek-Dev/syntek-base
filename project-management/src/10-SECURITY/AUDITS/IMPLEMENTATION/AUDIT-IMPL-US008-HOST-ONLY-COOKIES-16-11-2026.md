# Security Audit — US008 Host-only cookies under `__Host-` names

| Field          | Value                                                                                                                                                                               |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**      | US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule                                                                      |
| **Date**       | 16/11/2026                                                                                                                                                                          |
| **Audited by** | Claude Code — independent tester/recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                                        |
| **Plan doc**   | **None** — no `AUDIT-PLAN-US008-*` was written at gate 10. The audit answers the threat-model plan's constraints 4b.1–4b.11 and the assessment plan's 7.1–7.13 instead (Section 7)  |
| **Verdict**    | **Pass with notes** — no CRITICAL or HIGH; every bypass the three review rounds found is closed with a self-test case; the scanner's remaining blind spots are documented residuals |

---

## 1. Scope audited

Walked at HEAD `43acdf5` (`git diff --stat 6fb7824 43acdf5`: 54 files). Commands run by this audit,
16/11/2026: `negative-space.sh --self-test` (exit 0, "broken/ trips 14 clauses, clean/ trips none"),
`negative-space.sh` unscoped (exit 0, no cookie clause skipped), and a scratch copy made with
`tmp=$(mktemp -d /tmp/us008-sec.XXXX); git archive HEAD | tar -x -C "$tmp"` in which
`cookie-domain-conflict.sh` was run clean (silent, exit 0) and with a `SESSION_COOKIE_DOMAIN` line
appended to `staging.py` (named by file, line and setting, value absent, exit 0; the gate reported
`cookie-scope-widened` on the same line). The copy was removed. ShellCheck and the multi-awk runs
are the automated record's (`project-management/src/18-TESTS/AUTOMATED/US008-TEST-STATUS.md`).

| File                                                                | Verdict         | Notes                                                                                                              |
| ------------------------------------------------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------ |
| `code/src/django/config/settings/base.py`                           | Pass            | `CSRF_COOKIE_HTTPONLY = True` `:161`; no SECURE line in dev (`:162` note)                                          |
| `code/src/django/config/settings/staging.py`                        | Pass            | `:19-24`; no Domain or Path                                                                                        |
| `code/src/django/config/settings/production.py`                     | Pass            | `:19-24`, identical cookie block                                                                                   |
| `code/src/scripts/audits/_lib/negative-space-cookies.sh`            | Pass with notes | Fail-closed scanner; blind spots documented (F-003)                                                                |
| `code/src/scripts/audits/negative-space.sh`                         | Pass with notes | Header lists fifteen clauses (`:10-25`); its register row elsewhere still says twelve (F-002)                      |
| `.copier/migrations/cookie-domain-conflict.sh`                      | Pass            | Names only (`:122`, `:136-139`, `:155`); unreadable module named (`:129-131`); `exit 0` (`:159`)                   |
| `.copier/migrations/host-only-cookies.sh`                           | Pass            | Advisory text `:49-66`; `exit 0` `:74`; pending, unversioned until release                                         |
| `copier.yml`                                                        | Pass            | `:55` excludes the preview helper; `:1061-1062` state-gated entry; `:1080-1081` pending entry `when: false`        |
| `code/src/scripts/development/template-update.sh`                   | Pass with notes | Full replay `:193-212`; replays any future migration's output too (F-001)                                          |
| `code/src/scripts/tests/cookie-preview-fixture.sh`                  | Pass            | Test-only, excluded from generation; unexpected failure exits 2 via its ERR trap (review R2, `82f72db`)            |
| `code/docs/security/CRYPTO-AND-DATA.md`                             | Pass            | Owner guide `:122-222`                                                                                             |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`               | Pass            | Strip-and-set clause `:144-153`; origin-hop verification `:346`                                                    |
| `.github/workflows/audit-negative-space.yml` · `audit-template.yml` | Pass            | Path filters cover the new library; template audit asserts the helper does not leak (commits `82f72db`, `9afb389`) |

## 2. Findings

### 2a. This audit

| ID    | STRIDE | OWASP    | NIST CSF | Trust boundary          | Finding                                                                                                                                                  | Severity | Mitigation / fix                                                                            | Status   |
| ----- | ------ | -------- | -------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------- | -------- |
| F-001 | I      | A09:2025 | PR.DS    | TB6 template → project  | The preview replays the entire update log; a future migration that printed a value would now reach the terminal. US008's two scripts print names only    | INFO     | State "never print a value" for every `.copier/migrations/` script                          | Residual |
| F-002 | T      | A02:2025 | DE.CM    | TB7 future edit → gate  | `code/src/scripts/audits/CONTEXT.md` → _Scripts_, the `negative-space.sh` row, says "Twelve `[gate: fail]`" and omits the cookie clauses (planned TM-09) | LOW      | The story's named cost; correct when that file has headroom                                 | Residual |
| F-003 | T      | A02:2025 | DE.CM    | TB5/TB7 settings → gate | The line scanner cannot see the forms listed in Section 6 (TM-08)                                                                                        | MEDIUM   | Documented in the owner guide; accepted                                                     | Residual |
| F-004 | —      | —        | DE.CM    | —                       | Runtime checks COOKIE-03 / COOKIE-06 (QA EC-17: rendered `X-CSRFToken` write, missing-header 403) unmeasured — dev `/static/` 404 (COOKIE-05 Fail)       | —        | Bug to `21-BUGS/` against `code/src/docker/nginx/dev.conf` and `entrypoint.dev.sh`; re-walk | Deferred |

**No new CRITICAL or HIGH.** Nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`.

### 2b. The three review rounds — bypasses found and closed

Every bypass below was reproduced red before the fix (commits `8bf1d71`, `7119eeb`, `63d73b0`) and is
pinned by a named case in `negative-space-cookies.sh`; `--self-test` exit 0 at `43acdf5` under gawk
5.4.1, mawk 1.3.4 and busybox 1.37 awk. All rated at most MEDIUM at discovery (a gate false-green on a
template that serves nothing), all **Resolved**.

| Round                           | IDs                | Bypass                                                                                                           | Closed by                                                                                                        |
| ------------------------------- | ------------------ | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| 1 — review (rulings Q10–Q13)    | QA-01              | A trailing comment quoting a root Path hid a Domain or non-root Path line                                        | Quote-aware comment cut in `COOKIE_AWK` (`:36`); fixture `broken/settings/scope_comment.py` (`0842a75`)          |
|                                 | QA-02 / R4         | A later override (`= False`, a plain name) in any module passed — first assignment won                           | Last assignment wins, any module (`cookie_state`, `:101-106`)                                                    |
|                                 | QA-03              | Combinations of the four scope settings and partial presence untested                                            | Plain cases per setting and per presence leg (`:295-299`, `:329-338`)                                            |
|                                 | R1 / QA-04         | Indented (conditional) assignments were invisible, or counted as presence                                        | Indentation recorded; indented counts for overrides and scope, never for presence (`scope_indented.py`)          |
|                                 | QA-05              | Annotated, chained and augmented assignments; a symlinked module                                                 | Recognised forms; `find -L` (`:122`)                                                                             |
|                                 | QA-06              | `Domain = None` and `r"/"` were false findings; a colon in a module name broke parsing                           | Value classes `none` / `root` (`COOKIE_WIDE` `:92`); colon-safe findings                                         |
|                                 | R3                 | A third TLS module (`uat.py`, `preview.py`) was never held to `__Host-`                                          | TLS discovery by content (`:148-153`)                                                                            |
|                                 | Q11 / R2 / R5 / R6 | Gate and migration as two drifting detectors; fixture helper exit codes; guide links; cutover-notice exemption   | One awk twin plus behavioural parity (`:549-581`); ERR trap exit 2; `AUTH-STRATEGY.md:67` link; header note      |
| Delta review                    | F4                 | `_lib/CONTEXT.md` named a helper that no longer existed                                                          | Row names `cookie_scan`, `cookie_state`, the twin (`e826242`)                                                    |
| 2 — delta (rulings Q14/Q16)     | QA2-01             | Semicolon, tuple unpacking, `del`, a read — the scanner failed **open**                                          | Any unmodelled whole-token occurrence is an `unrec` record: never presence, always override/scope (`:86`, `:96`) |
|                                 | QA2-02             | Walrus, parenthesised, `for`, `import … as`, subscript-first binding forms                                       | Same fail-closed rule; one module per form (`:416-429`)                                                          |
|                                 | QA2-03             | A one-character divergence in the migration twin escaped behavioural parity; string contents misread             | Byte-for-byte text parity (`cookie_twin_text` `:528-531`); single, triple and continued strings tracked          |
|                                 | QA2-04             | An unreadable module read as clean                                                                               | Finding "could not be read" in gate (`:117-121`) and migration (`cookie-domain-conflict.sh:129-131`)             |
|                                 | QA2-05             | `staging/` / `production/` packages escaped the presence rule                                                    | `<name>/__init__.py` stands in for `<name>.py` (`:142-145`)                                                      |
|                                 | QA2-06             | CRLF line endings                                                                                                | Trailing CR trimmed; CRLF compliant tree stays clean                                                             |
| 3 — final (rulings Q15/Q17/Q18) | QA3-01             | A module turned TLS by an **unrecognised** SECURE form (semicolon, unpacked, chained `(True)`) escaped `__Host-` | Fail-closed TLS discovery: any SECURE record other than `false`/`none` (`:150-152`, `46d97a9`)                   |
|                                 | R3-06              | The augmented-assignment flag was unpinned (`+= "/"`, `\|= True` looked compliant)                               | Pinned cases (`:517-523`)                                                                                        |
|                                 | QA3-05             | The migration's exit 0 on both paths was unpinned                                                                | Asserted in parity (`:569-571`)                                                                                  |
|                                 | Q15 / Q18          | Residual blind spots and the computed-SECURE consequence undocumented                                            | Stated in `CRYPTO-AND-DATA.md:183-186` and `:201-222` (`46d97a9`, `43acdf5`)                                     |

## 3. Checklist results

| #   | Control                                                                        | Result | Evidence (file · symbol)                                                                                                                         |
| --- | ------------------------------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| C1  | Explicit, named permission check on every state-changing Django Ninja endpoint | N/A    | No endpoint added. The browser fixture's temporary POST view is in a scratch clone only and never ships (`copier.yml:55` excludes its helper)    |
| C2  | User-supplied IDs verified against the caller's ownership — no IDOR            | N/A    | No identifier accepted anywhere in the diff                                                                                                      |
| C3  | `CORS_ALLOWED_ORIGINS` is an explicit allowlist — never `*` in production      | N/A    | Untouched by the diff                                                                                                                            |
| C4  | `DEBUG=False` in every non-local environment                                   | N/A    | Untouched by the diff                                                                                                                            |
| C5  | All secrets read from environment variables — none hardcoded                   | Pass   | Cookie names and booleans only; walk evidence records no password, cookie or token value (COOKIE-02 note; 09/10/2026 clarification)              |
| C6  | Input validated and typed at the boundary (UUIDs, length, allowlists)          | Pass   | The scanner treats every unmodelled form as a finding (fail closed) and every unreadable file as a finding (`negative-space-cookies.sh:117-121`) |
| C7  | Injection defence — ORM / parameterised queries, output escaping, no raw SQL   | N/A    | No query or template output added                                                                                                                |
| C8  | Sensitive data kept out of error payloads and logs                             | Pass   | Advisory and gate print path, line and setting only (`cookie-domain-conflict.sh:122`, `:155`); scratch run: planted value absent                 |
| C9  | Multi-write paths transactional and audit-logged where security-relevant       | N/A    | No write path                                                                                                                                    |

## 4. OWASP Top 10 coverage

| #   | Category                              | Result                                   |
| --- | ------------------------------------- | ---------------------------------------- |
| A01 | Broken Access Control                 | Pass (TM-01 closed; TM-07 residual)      |
| A02 | Security Misconfiguration             | F-002, F-003 (residual)                  |
| A03 | Software Supply Chain Failures        | Pass (TM-14, TM-15)                      |
| A07 | Authentication Failures               | Pass with residual — TM-05 edge contract |
| A09 | Security Logging & Alerting Failures  | F-001; TM-13 accepted residual           |
| A10 | Mishandling of Exceptional Conditions | Pass (TM-04, TM-10, TM-11, TM-12)        |

A04, A05, A06 and A08 are N/A or covered without finding (`ASSESSMENT-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md`, Section 2).

## 5. Plan constraints closed

The threat-model plan's Section 4b developer constraints (no audit plan exists).

| Plan constraint                                              | Status | Evidence                                                                                                             |
| ------------------------------------------------------------ | ------ | -------------------------------------------------------------------------------------------------------------------- |
| 4b.1 Prefix preconditions in the same module                 | Closed | `staging.py:21-24`, `production.py:21-24`; per-module check `negative-space-cookies.sh:154-168`                      |
| 4b.2 No `*_COOKIE_DOMAIN`, no non-root `*_COOKIE_PATH`       | Closed | Grep 16/11/2026: none under `config/settings/`; `cookie-scope-widened` `:170-181`                                    |
| 4b.3 Assignment-anchored; a comment neither finds nor passes | Closed | Quote-aware comment cut (`COOKIE_AWK` `:36`); BREAK-06 Pass. Widened to fail-closed (rulings Q14/Q16)                |
| 4b.4 Skip with a note when the module is absent              | Closed | `:110-115`, `:145`; BREAK-07 Pass                                                                                    |
| 4b.5 `SETTINGS_FILE` and the scope move together             | Closed | `SETTINGS_DIR` beside it (`negative-space.sh:99`), repointed with it (`:501`)                                        |
| 4b.6 Three limits in the owner guide                         | Closed | `CRYPTO-AND-DATA.md:137-142`                                                                                         |
| 4b.7 What the gate can and cannot see                        | Closed | `CRYPTO-AND-DATA.md:170-222`                                                                                         |
| 4b.8 Never a value                                           | Closed | `cookie-domain-conflict.sh:122`, `:155`; scratch run                                                                 |
| 4b.9 Invalidation both ways; cutover shape                   | Closed | `host-only-cookies.sh:49-60`                                                                                         |
| 4b.10 No silencing annotation                                | Closed | None in the library or the migration; "There is no suppression annotation, by design" (`CRYPTO-AND-DATA.md:194-195`) |
| 4b.11 Two entries; key derived at release                    | Closed | `copier.yml:1061-1062`, `:1080-1081`; `24-release/CHECKLIST.md:28`                                                   |

## 6. Deferred / residual items

**Accepted residuals — the scanner's documented limits** (`code/docs/security/CRYPTO-AND-DATA.md`,
_What the gate can and cannot see_, `:201-222`; F-003). A green run proves the settings directory,
not the global rule; these remain invisible or misread:

1. A runtime write to `django.conf.settings` — an `AppConfig.ready()` is the canonical place.
2. An environment-driven value — `env("X")` reads as "not compliant", never as what it holds.
3. Any settings module outside `code/src/django/config/settings/`, and anything reaching it through
   `from … import *`, `setattr`, `globals()`, `exec` or a runtime-built name.
4. Fullwidth or other NFKC-equivalent identifiers, and a name inside an f-string's braces.
5. A multi-line, concatenated or variable-built value — a false finding, never a false pass.
6. A keyword argument on its own line inside a call (`NAME=True,`), read as an assignment.
7. Control flow — an unconditional line after an `if` block wins whether or not the block ran.
8. An unreadable sub-directory under `settings/` is skipped, not reported (files are reported).
9. `staging.py` beside a `staging/` package (or the production pair): the gate reads the `.py`,
   Python imports the package.
10. A Python 3.12+ f-string reusing its own quote inside its braces can desynchronise string
    tracking and hide the rest of the module.
11. A lone CR after a comment hides the next line (CRLF is handled).

**Consequence stated, not a limit:** a computed SECURE value (`SESSION_COOKIE_SECURE = env.bool(...)`)
makes its module a TLS module and asks it for `__Host-` names; set SECURE literally per environment
module (`CRYPTO-AND-DATA.md:183-186`, ruling Q18).

**Other residuals and deferrals:**

- TM-05 edge strip-and-set — deploy-repo obligation, `EDGE-REQUIREMENTS.md:144-153`.
- TM-07 `messages` and language cookies unprefixed — `CRYPTO-AND-DATA.md:167-169`.
- TM-13 silent browser rejection — `CRYPTO-AND-DATA.md:133-136`.
- F-001, F-002 — Section 2a.
- F-004 / COOKIE-03, COOKIE-06 unmeasured; TLS browser acceptance of `__Host-` names unmeasured.
- The cutover entry is inert until the release commit activates it (`copier.yml:1064-1079`).

## 7. Deviations from plan

- **No audit plan existed** for US008; this record answers the threat-model plan's Section 4b and,
  through the assessment record, the assessment plan's Section 7.
- The gate's clauses live in `_lib/negative-space-cookies.sh` (ruling Q11) and fail closed
  (Q14/Q16/Q17) — stricter than the planned assignment-anchored design.
- The pre-change capture reports two presence clauses (three findings); `cookie-scope-widened` is
  proved by fixtures only. BREAK-08 split: directory exit 2, file exit 1.
- `template-update.sh` replays the full log once on every path, including exit 1 and `--apply`.
- The cutover migration ships `when: false`, unversioned, filename renamed at release.
- The edge scheme-header check targets the origin hop; the release checklist line is generic and
  template-only.
- Observed outside US008, not findings of this story: ~~story stacks on `:3080` fail form POSTs
  (`CSRF_TRUSTED_ORIGINS` in `dev.py` lists only `:81`)~~ — fixed after this audit, see the
  addendum below; and `doc-references.sh` exits 0 with
  "Nothing to check" outside a git repository — the second is a could-not-look reported as clean
  (`code/docs/GATE-REPORTING.md`) and belongs to the citation gate's owner.

### Addendum 16/11/2026 — the story-stack CSRF fix merged after `43acdf5`

The branch gained one CSRF control after this audit's walk: `40ce928` (merged `8d6a5ac`) adds
`DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA`, read by `config/settings/dev.py` **only**, and appends its
origins to the three `:81` defaults. A wildcard, a missing scheme, a path, a query, userinfo or a
bad port raises `ImproperlyConfigured`; `staging.py` and `production.py` are untouched and keep
their own list. Independent QA on a disposable stack at `127.0.0.8:3080`: sign-in and the admin
password change 302; a foreign origin with a valid token 403, as do port, case, `null` and
trailing-slash variants. Residual (finding record, Q15 Low): an entry that passes the parser but
can never match a browser `Origin` (upper case, a leading-zero port or octet, an empty `?`/`#`)
fails closed as a silent 403 rather than a startup error. The verdict above stands.

## 8. Sign-off

| Auditor                                                    | Role                         | Date       |
| ---------------------------------------------------------- | ---------------------------- | ---------- |
| Claude Code (independent recorder, `security` skill, Opus) | Post-build security audit    | 16/11/2026 |
| <%DEVELOPER_NAME%>                                         | Developer sign-off — pending | —          |

---

## Cross-references

- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` — the constraints answered here in place of an audit plan
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md` — the re-assessed STRIDE model
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US008-HOST-ONLY-COOKIES-16-11-2026.md` — the posture assessment this audit feeds
- `../../VULNERABILITIES/IMPLEMENTATION/` — where new CRITICAL/HIGH would be escalated; none
- `../../../02-STORIES/US008.md` — the story audited
- `../../../18-TESTS/MANUAL/US008-MANUAL-TESTING.md` · `../../../18-TESTS/AUTOMATED/US008-TEST-STATUS.md` — walked rows and automated captures
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the code-side controls these findings must stay consistent with
