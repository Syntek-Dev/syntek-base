# Security Posture Assessment (Plan) — US006 The deployment-posture guard

| Field          | Value                                                                                                |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| **Story**      | US006 — The destructive dev scripts read the deployment posture, and refuse to run above development |
| **Date**       | 05/09/2026                                                                                           |
| **Author**     | Claude Code — `security` skill, Fable tier · reviewed by <%DEVELOPER_NAME%>                          |
| **Sprint**     | SPRINT-04 — opened by this story; not yet written at the time of this assessment                     |
| **Status**     | Reviewed                                                                                             |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC)                                   |

> This assessment establishes the security **baseline** for the story before any code is
> written. It synthesises the story's STRIDE threat model and maps overall posture against
> OWASP Top 10 and NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or
> HIGH finding — those are release blockers.

---

## 1. Summary

**The story ships a security control, so the assessment is of the control itself, and its posture
at the planning stage is sound but not yet complete.** Eighteen findings were raised across all
six STRIDE categories — **0 CRITICAL, 0 HIGH, 9 MEDIUM, 7 LOW, 2 INFO** — so nothing gates sprint
planning and no vulnerability record is written.

That zero needs its reason stated, because it is a fact about the tree and not about the design:
**this project's posture is `development` and no surface is live**, so a control that fails open
harms nothing today. Section 3a of the threat model names the event that promotes each finding,
and **five promote to `HIGH`** — four at the first `staging` surface, one at the first
`migrate.sh fake` against a deployed database. Per `code/docs/GATE-REPORTING.md` this is not
reported as "the security gate passed".

**Risk concentrates in one place and it is not an attacker.** Twelve of the eighteen have no
adversary at all: they are the control mis-reading its own inputs, or standing down when it should
not. The single failure direction that matters is _failing open_, and the four findings that reach
it — a commented carrier key (TM-02), a stray root `copier.yml` (TM-05), an exported shell
variable (TM-04), and a deleted call site nothing notices (TM-03) — are all closed by constraints
in Section 7 rather than by anything the story already said.

## 2. Scope

| Dimension  | Coverage                                                                                                                                       |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Story      | US006 — the deployment-posture guard                                                                                                           |
| User flow  | **None** — the story adds no screen, route or journey; `05-USER-FLOW/` has nothing to reference                                                |
| Schema     | **None** — no model, no migration, no PII. The DB flag reads `N/A`                                                                             |
| Decisions  | `ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026` · `ADR-US006-OVERRIDE-NAMES-THE-LIVE-POSTURE-05-09-2026` (both authored at `15-decisions`) |
| Frameworks | STRIDE · OWASP Top 10 · NIST CSF 2.0                                                                                                           |

**Deviation, stated rather than silently absent:** Step 1 of `10-security-checks` reviews user
flows and wireframes. This story has neither and can have neither — its surface is a shell helper
and five developer scripts. The trust boundaries in the threat model were derived from the scripts
themselves instead. Nothing is pending re-validation on landing.

## 3. Threat models referenced

- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` — 18 findings,
  6 trust boundaries (TB1 operator shell · TB2 repository checkout · TB3 ambient environment ·
  TB4 guard→destructive operation · TB5 CI runner · TB6 Copier upstream)

Its trust boundaries and severities are adopted here unchanged.

## 4. OWASP Top 10 — baseline coverage

| ID       | Category                              | Status  | Notes (open findings, controls relied on)                                                                                                                     |
| -------- | ------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | Partial | The dominant category here — the posture **is** the authorisation input. TM-01, TM-04, TM-05, TM-09, TM-15 open; all closed by Section 7 constraints          |
| A02:2025 | Security Misconfiguration             | Partial | TM-02, TM-03, TM-08 — the carrier read and the control's own presence. Closed by the anchored-match and presence-assertion constraints                        |
| A03:2025 | Software Supply Chain Failures        | N/A     | The story adds no dependency. The helper is first-party shell sourced from within the repository                                                              |
| A04:2025 | Cryptographic Failures                | N/A     | No secret, key or credential is read, written or compared. The carrier holds one posture string                                                               |
| A05:2025 | Injection                             | Partial | TM-10, TM-11 — a committed override literal and a cwd-relative probe. Neither is injection in the classical sense; both are input resolved from ambient state |
| A06:2025 | Insecure Design                       | Partial | TM-06, TM-07, TM-13, TM-14 — the fail-closed direction failing the wrong way. TM-07 is the sharpest: as designed, a damaged carrier is unrecoverable          |
| A07:2025 | Authentication Failures               | N/A     | No principal is authenticated and none can be — a developer script has no session. Stated as residual scope in the threat model, not as coverage              |
| A08:2025 | Software and Data Integrity Failures  | Partial | TM-12 — `migrate.sh fake` and `fake-initial` rewrite the schema's record of itself, contradicting the premise warn-only rests on                              |
| A09:2025 | Security Logging & Alerting Failures  | Open    | TM-16, TM-18 — the override is the authorisation and it is written nowhere. Accepted residual: the audit trail does not reach a developer script              |
| A10:2025 | Mishandling of Exceptional Conditions | Partial | TM-06, TM-13, TM-17 — a closed stdin, a wrapped call site and an under-specified firing point each turn a refusal into a success                              |

## 5. NIST CSF 2.0 — function summary

| Fn  | Function | Design-stage posture                                                                                                                                            |
| --- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | Strong. `.claude/CLAUDE.md` Section 0 states the policy; this story is the first thing that enforces any of it below the model's own compliance                 |
| ID  | Identify | Strong. Six trust boundaries named, the authorisation input identified as one carrier, and the residual scope written rather than implied                       |
| PR  | Protect  | The story's whole subject, and **Partial** until Section 7 lands — four of the eleven constraints close a fail-open path that the design as written leaves open |
| DE  | Detect   | **Weakest function.** TM-03: nothing detects the control's own removal. The presence assertion is what moves this off Open                                      |
| RS  | Respond  | Adequate. Exit 4 plus the `posture-guard: refused —` prefix makes a refusal greppable by a CI job or a human                                                    |
| RC  | Recover  | **Open until TM-07 lands.** A damaged carrier refuses every bound script and the only override cannot name a posture that does not exist — no recovery path     |

## 6. Findings

Grouped by severity. All eighteen are carried from the threat model unchanged; see it for the full
mitigation text and the promotion triggers.

| ID    | STRIDE | OWASP | NIST  | Trust Boundary | Threat Description                                                        | Severity | Planned Mitigation                                         |
| ----- | ------ | ----- | ----- | -------------- | ------------------------------------------------------------------------- | -------- | ---------------------------------------------------------- |
| TM-01 | S      | A01   | PR.PS | TB3            | Guard authenticates the repository; the `DROP` follows ambient Docker     | MEDIUM   | Assert the compose target is the local stack (§7.1)        |
| TM-02 | T      | A02   | PR.DS | TB2            | A commented carrier key reads as a live posture                           | MEDIUM   | Anchored, comment-rejecting match (§7.2)                   |
| TM-03 | T      | A02   | DE.CM | TB4            | No presence test — deleting the guard call is unnoticed                   | MEDIUM   | Assert the call site, not only the function (§7.8)         |
| TM-05 | E      | A01   | PR.AA | TB2            | A stray root `copier.yml` silently disables the whole control             | MEDIUM   | Carrier evaluated first (§7.4)                             |
| TM-06 | D      | A06   | PR.PS | TB1            | Closed stdin turns an authorised run into a silent `exit 0`               | MEDIUM   | No tty above `development` refuses at 4 (§7.6)             |
| TM-07 | D      | A06   | RC.RP | TB2            | A damaged carrier has no statable recovery                                | MEDIUM   | Validate the flag before reading the carrier (§7.5)        |
| TM-08 | T      | A02   | PR.DS | TB6            | A `copier update` conflict duplicates the key; the design assumes absence | MEDIUM   | Conflicted carrier is its own refuse state (§7.2)          |
| TM-09 | E      | A01   | PR.AA | TB1            | `up --seed` unbound; `seed-dev.sh` advertises staging                     | MEDIUM   | Bind both (§7.9)                                           |
| TM-10 | E      | A05   | PR.PS | TB5            | CI commits a standing override behind `\|\| true`                         | MEDIUM   | Drop `\|\| true`; name the literal's owner (§7.10)         |
| TM-04 | S      | A01   | PR.PS | TB3            | An exported shell variable shadows the carrier                            | LOW      | Carrier-only read, asserted with the variable set (§7.1)   |
| TM-11 | S      | A05   | PR.PS | TB2            | A cwd-relative probe reads the operator's directory                       | LOW      | `$PROJECT_ROOT`-anchored test (§7.3)                       |
| TM-12 | S      | A08   | PR.DS | TB2            | `migrate.sh fake` is not non-destructive                                  | LOW      | Recorded against N-003's premise; warn-only held knowingly |
| TM-13 | D      | A06   | PR.PS | TB4            | A wrapped call site suspends `set -e`                                     | LOW      | Explicit branch and exit in every caller (§7.7)            |
| TM-14 | D      | A06   | PR.PS | TB1            | Three unguarded routes wipe the test volumes                              | LOW      | Residual — test volumes are disposable by design           |
| TM-15 | I      | A01   | PR.DS | TB2            | Five scripts gain a read of every generation answer                       | LOW      | Extract one key; never echo the file (§7.11)               |
| TM-17 | I      | A09   | DE.CM | TB4            | "Before the preflight" is vacuous in two of the five scripts              | LOW      | Restate as "before the first destructive command"          |
| TM-16 | R      | A09   | DE.AE | TB1            | The override is the authorisation and is written nowhere                  | INFO     | Accepted residual, named rather than assumed               |
| TM-18 | R      | A09   | DE.AE | TB4            | Refusal and operator-decline distinguishable only by exit code            | INFO     | Exit 4 plus a greppable message prefix                     |

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/PLANNING/`, and that
absence is a recorded outcome rather than an unrun check.

## 7. Security tasks & open gaps

Eleven constraints, each checkable by reading the shipped helper and its callers. Each becomes a
US006 acceptance criterion; the implementation assessment closes it with code evidence.

- [ ] **7.1** The guard reads the carrier only — no `${DEPLOYMENT_POSTURE:-…}` construction exists
      in it, and the self-test proves the exported variable is ignored (A01, TM-04)
- [ ] **7.2** The carrier match is anchored on `^DEPLOYMENT_POSTURE:`, quote-tolerant and
      comment-rejecting; a duplicate or conflict-marked key is a refuse state (A02, TM-02/TM-08)
- [ ] **7.3** `copier.yml` is tested `$PROJECT_ROOT`-anchored, resolved from `BASH_SOURCE`, never
      cwd-relative (A05, TM-11)
- [ ] **7.4** The carrier is evaluated **before** the template proof — a legal posture beats a
      present `copier.yml`, so the exemption is unreachable in any project holding an answer
      (A01, TM-05)
- [ ] **7.5** `--force-posture` is validated against the literal posture set **before** the carrier
      is consulted, so it stays satisfiable in all four damaged-carrier states (A06, TM-07)
- [ ] **7.6** Above `development`, absence of a tty is a refusal at exit 4 with the guard prefix —
      never an abort at exit 0 (A10, TM-06)
- [ ] **7.7** Every bound script branches on the guard's returned status explicitly and exits; no
      call site wraps it in a condition that suspends `set -e` (A10, TM-13)
- [ ] **7.8** Each bound script's guard call is asserted **present**, before its first destructive
      command — a tested function is not an enforced control (A02, TM-03)
- [ ] **7.9** `development/server.sh up --seed` and `database/seed-dev.sh` are bound (A01, TM-09)
- [ ] **7.10** The CI caller carries no `|| true` on the guarded call, and the story names who
      updates its `--force-posture` literal when the posture rises (A05, TM-10)
- [ ] **7.11** The refusal prints the live posture and the re-run command, and nothing else from
      the carrier (A01, TM-15)

**None of the eleven is a sprint-planning blocker** — no CRITICAL or HIGH was raised. They are
design-stage constraints that must land with the code, and the implementation assessment is where
each is closed with evidence.

---

## Cross-references

- `../IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record that
  verifies this baseline
- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US006-POSTURE-GUARD.md` — the STRIDE model this
  assessment synthesises
- `../../AUDITS/PLANNING/` · `../../VULNERABILITIES/PLANNING/` — the sibling code audit and the
  escalated findings; this story writes to neither, and Section 6 states why
- `../../../02-STORIES/` — the story being assessed
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` — the code-side enforcement these targets must stay consistent with
- `code/docs/GATE-REPORTING.md` — why the zero in Section 6 is stated with its reason
