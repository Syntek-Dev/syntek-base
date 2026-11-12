# Security Audit — US005 Exactly one layer decides to retry

| Field          | Value                                                                                                                                                                                                                              |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**      | US005 — Exactly one layer decides to retry, and every budget says how long it may take                                                                                                                                             |
| **Date**       | 12/11/2026                                                                                                                                                                                                                         |
| **Audited by** | Claude Code — `security` skill, Opus, `22-implementation-documentation` Step 3                                                                                                                                                     |
| **Plan doc**   | **None — no `AUDIT-PLAN-US005-*` exists, by decision.** Audited against `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md` and `../../ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` |
| **Verdict**    | Pass with notes                                                                                                                                                                                                                    |

---

## Why an audit exists at all

**Both planning artefacts said `AUDITS/` does not fire for this story** (threat model Section 4,
assessment Section 6): a code audit reads shipped code, and US005 ships none. Two things changed
that, and the deviation is recorded rather than glossed:

1. `22-implementation-documentation` Step 3 makes the audit **the** post-build security record
   for a story that ships a security surface, and US005's Security section is live.
2. **The branch carries executable changes after all** — three side changes Sam added: the
   `format.sh` `yaml`/`json` legs (11/11/2026), a tightened `doc-references.sh` with a
   `[template artefact]` class, and a `copier.yml` exclusion plus `shipped-artefacts.sh` check 6
   closing a ClickUp export leak (12/11/2026). None is retry code; each is tooling a generated
   project inherits.

So this record audits **two populations**: the shipped doctrine, for whether a developer
following it would build something unsafe; and the side-change scripts and config, as code. It
is still not an audit of a retry implementation — there is none. The trigger for that audit is
unchanged: the first story that wires a client (TM-01's trigger).

## 1. Scope audited

| File                                                              | Verdict         | Notes                                                                                                                  |
| ----------------------------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `code/docs/reliability/RETRIES.md`                                | Pass with notes | Worked examples safe as written; F-002 (the `expires` the example does not show)                                       |
| `code/docs/reliability/BUDGETS.md`                                | Pass            | All three worst cases recomputed by hand and match; counted-down caps below the 3600 s redelivery bound                |
| `code/docs/RELIABILITY.md`                                        | Pass            | Breaker deferral with both triggers                                                                                    |
| `code/docs/TASK-AUTHORING.md`                                     | Pass            | `RetriesExhausted` terminal and outside every `autoretry_for`                                                          |
| `code/docs/api-design/WEBHOOKS.md`                                | Pass            | SSRF check before each send kept; re-signing does not weaken inbound replay protection (de-dup on `id`, `:117-120`)    |
| `code/docs/mcp-server/TOOL-DESIGN.md`                             | Pass            | Inverse statement repaired                                                                                             |
| `code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`                | Pass with notes | _Retry_ column still prescriptive (`:252-258`); acknowledged in place and owned by slice `S-04`                        |
| `code/docs/NEGATIVE-SPACE.md`                                     | Pass            |                                                                                                                        |
| `code/docs/logging/OBSERVABILITY.md`                              | Pass            | `include_local_variables=False` (`:60`)                                                                                |
| `project-management/docs/gdpr/COMPLIANCE.md`                      | Pass            | Catches `DatabaseError` only; raises `PurgeFailed` after the block, `from None`; locals hold no payload (`:41-58`)     |
| `code/docs/performance/API-AND-MONITORING.md`                     | Pass with notes | Not edited by this branch; F-003 (checklist line `:119`)                                                               |
| `copier.yml` (`_exclude`, `:106-121`)                             | Pass            | F-001 resolved: unconditional `/project-management/export/clickup/**` at `:118`, three negations for the documentation |
| `.github/scripts/shipped-artefacts.sh` (check 6, self-test probe) | Pass            | Read, not run — see Section 3 C9 and the open items                                                                    |
| `code/src/scripts/syntax/format.sh`                               | Pass            | Two file-type tokens added; no `eval`, no new deletion path in the added lines                                         |
| `code/src/scripts/audits/doc-references.sh`                       | Pass            | No `eval`; read-only. Self-test figure is the orchestrator's (below)                                                   |

**Dropped from scope, with the reason:** nothing under `code/src/django/` beyond
`apps/core/services/CLAUDE.md` changed (`git diff --stat -- code/src/django`, 12/11/2026), so
there is no Python, endpoint, model or template to walk.

## 2. Findings

**No CRITICAL or HIGH finding. Nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`.**
Checked for escalation: the diff's added lines for credential shapes (API keys, AWS access-key
IDs, private-key headers, `secret=`/`password=`/`token=` assignments) — none; the side-change
scripts for `eval` and new deletion paths — none; the ClickUp leak's content class (F-001).

| ID    | STRIDE | OWASP    | NIST CSF | Trust boundary                         | Finding                                                                                                                                                                                                                                                                                                                                              | Severity | Mitigation / fix                                                                                                                                                                                                                                               | Status                        |
| ----- | ------ | -------- | -------- | -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| F-001 | I, T   | A02:2025 | PR.DS-01 | Template to generated project (Copier) | **Pre-existing, found and fixed on this branch.** The `INCLUDE_CLICKUP` gate excluded the ClickUp export folder only from a project that declined the sync, so a project that took it received syntek-base's own `US###-CLIENT.md` exports, and its first sync would push them to its client's board                                                 | LOW      | `copier.yml:118` unconditional exclusion, README and pair negated back in; `shipped-artefacts.sh` check 6 plus a self-test probe. LOW, not higher: the exports are this template's planning text, no credentials or personal data, and no attacker is involved | Resolved                      |
| F-002 | T      | A10:2025 | PR.DS-01 | TB1 / TB6                              | `RETRIES.md:137-139` requires a counted-down attempt be scheduled with `expires = first_attempt_at + T - t`; the worked example (`:166-183`) shows the task body only, and whether `Task.retry` carries the first message's `expires` into the retry message was **not verified** (context7's Celery 5.6.3 docs are silent; the source was not read) | INFO     | Verify against Celery's `Task.retry` source; if it does not carry forward, show `expires` in the example. Recorded, not fixed — the shipped doctrine is not this record's to edit                                                                              | Deferred — `src/20-FINDINGS/` |
| F-003 | T      | A06:2025 | GV.PO-01 | TB3                                    | `performance/API-AND-MONITORING.md:119` reads "Background jobs are idempotent with retries and back-off", implying every job retries; the shipped retention purge deliberately does not                                                                                                                                                              | INFO     | Reword to route to `RELIABILITY.md`; candidate for slice `S-04`                                                                                                                                                                                                | Deferred — `src/20-FINDINGS/` |

## 3. Checklist results

The template's nine controls. Most have no subject in a story with no endpoint; each `N/A` says
why rather than reading as a pass.

| #   | Control                                                                        | Result | Evidence (file, symbol)                                                                                                                                                                                                        |
| --- | ------------------------------------------------------------------------------ | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| C1  | Explicit, named permission check on every state-changing Django Ninja endpoint | N/A    | No endpoint added or changed                                                                                                                                                                                                   |
| C2  | User-supplied IDs verified against the caller's ownership — no IDOR            | N/A    | No identifier accepted. The persisted-schedule sweep (`BUDGETS.md:96-121`) runs as the system on its own rows                                                                                                                  |
| C3  | `CORS_ALLOWED_ORIGINS` is an explicit allowlist — never `*` in production      | N/A    | Settings untouched                                                                                                                                                                                                             |
| C4  | `DEBUG=False` in every non-local environment                                   | N/A    | Settings untouched                                                                                                                                                                                                             |
| C5  | All secrets read from environment variables — none hardcoded                   | Pass   | Added diff lines scanned 12/11/2026 for credential shapes: none. `OBSERVABILITY.md:55-61` still reads `SENTRY_DSN` from the environment                                                                                        |
| C6  | Input validated and typed at the boundary (UUIDs, length, allowlists)          | Pass   | Doctrine: `Retry-After` parsed into `RemoteThrottled.retry_after` at the adapter, treated as untrusted (`RETRIES.md:145-147`, `:162-164`); `TASK-AUTHORING.md:177-180` classifies at the adapter                               |
| C7  | Injection defence — ORM / parameterised queries, output escaping, no raw SQL   | Pass   | The persisted schedule's claim is shown as a conditional `UPDATE` (`BUDGETS.md:109-117`) with no interpolated input; the ORM `select_for_update(skip_locked=True)` alternative is named. Illustrative, not a query in the tree |
| C8  | Sensitive data kept out of error payloads and logs                             | Pass   | Doctrine: `RETRIES.md:192-199`, `:228-241`; `OBSERVABILITY.md:60-67`; `WEBHOOKS.md:98-100`; `COMPLIANCE.md:70-77`. **Stated, not enforced** — nothing emits these logs yet (`RETRIES.md:205-207`)                              |
| C9  | Multi-write paths transactional and audit-logged where security-relevant       | Pass   | Doctrine: the first persisted attempt's row is inserted in the same transaction as its enqueue (`BUDGETS.md:98-102`). F-001's guard is a static `_exclude` rule plus a check whose self-test this audit **did not run**        |

## 4. OWASP Top 10 coverage

| #   | Category                              | Result                                                                                |
| --- | ------------------------------------- | ------------------------------------------------------------------------------------- |
| A02 | Security Misconfiguration             | F-001 (resolved); TM-02 residual — unenforced rule, slice `S-05`                      |
| A03 | Software Supply Chain Failures        | Pass — no dependency moved; the vendor-default override is named (`RETRIES.md:34-37`) |
| A06 | Insecure Design                       | F-003; TM-08 closed                                                                   |
| A08 | Software and Data Integrity Failures  | Pass (doctrine) — `RETRIES.md:95-101`, `BUDGETS.md:89-138`                            |
| A09 | Security Logging & Alerting Failures  | Pass (content rules); alerting unenforced                                             |
| A10 | Mishandling of Exceptional Conditions | F-002; otherwise Pass (doctrine)                                                      |

A01, A04, A05 and A07 are N/A for the reasons the assessment's Section 2 gives.

## 5. Plan constraints closed

There is no audit plan, so its Section 5 has no rows. **The twelve developer constraints are
closed in `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US005-RETRY-AMPLIFICATION-12-11-2026.md`
Section 6 and are not restated here** — eleven closed with cited text, constraint 12 open.

| Plan constraint                                                     | Status   | Evidence                                                                                                                                        |
| ------------------------------------------------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Constraints 1-11 (assessment plan Section 7)                        | Closed   | Assessment record, Section 6                                                                                                                    |
| Constraint 12 — `DEFERRED.md` records the unenforced window (TM-02) | **Open** | Owned by this workflow's QA/findings phase (Step 5); `DEFERRED.md` checked 12/11/2026 and carries no such row yet. The pull request waits on it |

## 6. Deferred / residual items

- **The doctrine is unenforced** — no `retry-discipline.sh`; `doctrine-drift.sh` reads fenced code
  only and checked 4 claims (orchestrator, 12/11/2026), never prose. Slice `S-05`; constraint 12.
- **F-002 and F-003** — to `src/20-FINDINGS/` in Step 5.
- **The `S-09` register** the delegation hatch names — `RETRIES.md:68-70`. It is one of
  `doc-references.sh`'s 29 named `[dangling path]` survivors: the orchestrator measured exit 1 on
  exactly 29 on the final tree, 0 `[template artefact]`, against 28 before the first edit, the
  added one being `RETRIES.md:68` (its forward reference). `--self-test` exit 0, 228 probes. A
  re-run by this audit timed out at 300 s before its summary and is **not** a measurement.
- **`SERVICE-AND-MIDDLEWARE.md` _Retry_ column** — slice `S-04`.
- **Inbound rate limiting** and the **circuit breaker** — dependencies named in doctrine, no story.

## 7. Deviations from plan

- **This audit exists although both plans said it would not fire** — reasons in _Why an audit
  exists at all_ above.
- **Sam's decisions of 12/11/2026 changed what was audited**: webhook repeats are re-signed each
  attempt (TM-06 corrected in place); no counted-down wait outlasts the broker's visibility
  timeout, longer schedules persisted; the GDPR retention example drops automatic retry; the
  budget half split to `BUDGETS.md`; jitter only lengthens a wait. Each was audited as shipped,
  not as first planned.
- **The shipped-reference rule (12/11/2026)** — `RETRIES.md` no longer cites
  `project-management/src/15-DECISIONS/ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md`; the
  rejected options are summarised in place (`RETRIES.md:28-30`). Security consequence: none — the
  rule a developer reads is now complete in a file that ships.
- **Side changes audited as code** (F-001's fix, `format.sh`, `doc-references.sh`) — outside the
  threat model's scope, inside this branch's.

## 8. Sign-off

| Auditor                              | Role                         | Date       |
| ------------------------------------ | ---------------------------- | ---------- |
| Claude Code — `security` skill, Opus | Security audit (author)      | 12/11/2026 |
| <%DEVELOPER_NAME%>                   | Developer — countersignature | _pending_  |

**Independent peer audit outstanding** — the `security` skill's phase 1 is a separate dispatch,
and none reviewed this record. Reported open, not met (`.ai/INSTRUCTIONS.md`).

---

## Cross-references

- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US005-RETRY-AMPLIFICATION.md`, `../../ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US005-RETRY-AMPLIFICATION.md` — the plans this audit answers in place of an audit plan
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US005-RETRY-AMPLIFICATION-12-11-2026.md` — the posture assessment this audit feeds
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US005-RETRY-AMPLIFICATION-12-11-2026.md` — the re-assessed STRIDE model
- `../../VULNERABILITIES/IMPLEMENTATION/` — nothing escalated; Section 2 says what was checked
- `../../../02-STORIES/US005.md` — the story audited
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/GATE-REPORTING.md` — why a timed-out run and an unrun self-test are not reported as passes
- `code/docs/SECURITY.md` — the code-side controls these findings must stay consistent with
