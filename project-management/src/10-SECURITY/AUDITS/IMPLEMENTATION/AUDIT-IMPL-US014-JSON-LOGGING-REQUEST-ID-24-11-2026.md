# Security Audit — US014 Structured JSON logging with a `request_id` on every entry

| Field          | Value                                                                                                                                                                                                                                                                                        |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**      | US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label                                                                                                                                                                                         |
| **Date**       | 24/11/2026                                                                                                                                                                                                                                                                                   |
| **Audited by** | Claude Code (Opus), independent recorder (wrote none of the story's code), the `security` skill read inline, `22-implementation-documentation` Step 3                                                                                                                                        |
| **Plan doc**   | **None.** No `AUDIT-PLAN-US014-*` was written at gate 10, and the story plan's _Documentation Write-Ups_ names none. This audit walks the shipped files; the threat-model plan's Section 4b constraints (= the assessment plan's 7.1 to 7.14) are closed in the assessment record, Section 6 |
| **Verdict**    | **Pass with notes** — no CRITICAL or HIGH; the review's two MEDIUMs were fixed test-first in the build; two notes (Section 2, A-01 and A-02)                                                                                                                                                 |

---

## 1. Scope audited

The working tree of `us014/structured-json-logging`, base `b1705408`, the build uncommitted,
read on 24/11/2026. The suite that pins it ran the same day: `tests/all.sh --coverage`, exit 0
(unit 227 passed, integration 22 passed, total coverage 94.50%). Nothing was executed against a
live environment.

| File                                                                                                              | Verdict         | Notes                                                                                                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `code/src/django/apps/core/observability.py`                                                                      | Pass with notes | 561 lines, under 750; standard library only; one `DICT-OK:` marker (`Payload`, the `json.dumps` boundary); every `except Exception` is inside the never-raise chain and commented. Cites an excluded PM path (A-01) |
| `code/src/django/apps/core/middleware.py`                                                                         | Pass            | `request.request_id` set from the validated inbound or a minted `uuid4().hex`, before the chain; `ContextVar` reset in `finally`; 100% line and branch                                                              |
| `code/src/django/config/settings/staging.py` · `production.py`                                                    | Pass            | Identical `LOGGING`; minimal mode; `ext://sys.stdout`; root `WARNING`; `django` handler-less; `DEBUG = False` (`:9`)                                                                                                |
| `code/src/django/config/settings/dev.py` · `test.py` · `base.py`                                                  | Pass            | Dev wide plus the existing file handler; test console, no formatter; `base.py` assigns no `LOGGING` (`test_base_assigns_no_logging`)                                                                                |
| `code/src/django/config/settings/CLAUDE.md`                                                                       | Pass with notes | The dated `LOGGING` exception; cites the story plan in prose (A-01)                                                                                                                                                 |
| `code/src/docker/django/entrypoint.{staging,prod,test}.sh`                                                        | Pass            | No `--access-logfile`; staging and production `--log-level warning`                                                                                                                                                 |
| `code/src/docker/docker-compose.dev.yml`                                                                          | Pass            | `../logs:/workspace/code/src/logs` on the dev `django` service only; the host directory gitignores `*.log`                                                                                                          |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entries 13, 15                                              | Pass            | Unconditional `X-Request-ID` overwrite; the collector contract. Contract text — the deploy repository realises it                                                                                                   |
| `code/src/django/apps/core/tests/unit/test_observability*.py` · `observability_support.py` · `test_middleware.py` | Pass            | 156 US014 cases, 0 failures; `StringIO` handlers removed in fixtures; no `dictConfig`; strict-JSON `parse_line`                                                                                                     |

## 2. Findings

The review findings of 23/11/2026 (M1, M2, L1 to L6, F1 to F7) are recorded, with their fixes,
in the assessment record's Section 4 and are not repeated here. This walk adds two notes.

| ID   | STRIDE | OWASP    | NIST CSF | Trust boundary               | Finding                                                                                                                                                                                                                                                                                                                                                                                                                | Severity | Mitigation / fix                                                                                                                 | Status                       |
| ---- | ------ | -------- | -------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| A-01 | —      | —        | GV.PO    | Template → generated project | **Shipped files cite PM artefacts a generated project does not receive.** `observability.py`:3-4 names the ADR by full path and `config/settings/CLAUDE.md`:50 cites "US014 story plan, Key Decision 9"; `copier.yml` `_exclude` drops `/project-management/src/**` bar templates and pairs, so both dangle downstream. Not a security control; a documentation defect `doc-references.sh` does not see in a docstring | INFO     | State the rule in the shipped text, or mark the cite `doc-references: template-only` (`code/docs/FORWARD-VOICE.md`, Direction B) | Open — findings record F-006 |
| A-02 | R      | A09:2025 | DE.AE    | TB4                          | **The every-handler test proves the shipped dicts, not a future one.** A project that adds a handler to one environment and runs no suite gets no warning. Inside the design: the settings test fails on the edit (ES-05), and CI runs it                                                                                                                                                                              | INFO     | None — the test is the enforcement point                                                                                         | Accepted                     |

**No CRITICAL or HIGH**; nothing escalates to `../../VULNERABILITIES/IMPLEMENTATION/`.

## 3. Checklist results

| #   | Control                                                                        | Result | Evidence (file · symbol)                                                                                                                                                  |
| --- | ------------------------------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1  | Explicit, named permission check on every state-changing Django Ninja endpoint | N/A    | No endpoint added; fixture views under `pytest.mark.urls` only                                                                                                            |
| C2  | User-supplied IDs verified against the caller's ownership — no IDOR            | N/A    | No identifier resolved to a record; the inbound `X-Request-ID` is a correlation value, validated not resolved                                                             |
| C3  | `CORS_ALLOWED_ORIGINS` an explicit allowlist — never `*`                       | N/A    | Not touched by the story                                                                                                                                                  |
| C4  | `DEBUG=False` in every non-local environment                                   | Pass   | `staging.py`:9, `production.py`:9 — unchanged                                                                                                                             |
| C5  | All secrets from environment variables — none hardcoded                        | Pass   | No new setting reads or holds a secret; no new environment variable                                                                                                       |
| C6  | Input validated and typed at the boundary                                      | Pass   | `middleware.py` · `_INBOUND_PATTERN.fullmatch`; a rejected id never reaches the line (EC-05) or `request.request_id` (EC-16)                                              |
| C7  | Injection defence — escaping                                                   | Pass   | `observability.py` · `_serialise` (`ensure_ascii=True`, `allow_nan=False`); HP-01; EC-22 non-ASCII path escaped                                                           |
| C8  | Sensitive data kept out of error payloads and logs                             | Pass   | Off dev: allowlist (`ALLOWLIST`), message-free `exc_info`, no access log. **`message` is not scrubbed, by decision** (ADR-US014 Option K) — documented, not claimed clean |
| C9  | Multi-write paths transactional and audit-logged                               | N/A    | No write path                                                                                                                                                             |

## 4. OWASP Top 10 coverage

| #   | Category                              | Result                     |
| --- | ------------------------------------- | -------------------------- |
| A02 | Security Misconfiguration             | Pass (A-02 accepted)       |
| A03 | Software Supply Chain Failures        | Pass — no dependency added |
| A05 | Injection                             | Pass                       |
| A09 | Security Logging & Alerting Failures  | Pass                       |
| A10 | Mishandling of Exceptional Conditions | Pass                       |

A01, A04, A06, A07 and A08 carry no surface here; the assessment record rates each.

## 5. Plan constraints closed

**Closed in the assessment record, not restated.** The fourteen constraints (threat model
Section 4b) are evidenced row by row in
`../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md`
Section 6: fourteen Closed, none Deferred.

## 6. Deferred / residual items

- The five accepted threats (TM-05, TM-13, TM-16, TM-17, TM-19) — threat-model record Section 5.
- A-01 — findings record F-006, smallest fix stated there.

## 7. Deviations from plan

- **No audit plan existed**, so this audit's scope is the plan's surface list (threat model
  Section 1), not a pre-agreed checklist. The precedent is US010's audit record.

## 8. Sign-off

| Auditor            | Role                                 | Date       |
| ------------------ | ------------------------------------ | ---------- |
| Claude Code (Opus) | Recorder — independent walk          | 24/11/2026 |
| <%DEVELOPER_NAME%> | Security sign-off — countersignature | 24/11/2026 |

**Countersigned 24/11/2026 by Sam**, the developer — not this record's author — with all US014 work: "I countersign, I give permission to tick the acceptance criteria on the stories." The record is `../../../18-TESTS/MANUAL/US014-MANUAL-TESTING.md` → _Countersignature — 24/11/2026_.

---

## Cross-references

- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US014-JSON-LOGGING-REQUEST-ID.md` — the surface and constraints walked
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` — the fourteen constraints evidenced
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US014-JSON-LOGGING-REQUEST-ID-24-11-2026.md` — the re-assessed STRIDE model
- `../../../02-STORIES/US014.md` — the story audited
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `code/docs/SECURITY.md` — the code-side controls these findings must stay consistent with
