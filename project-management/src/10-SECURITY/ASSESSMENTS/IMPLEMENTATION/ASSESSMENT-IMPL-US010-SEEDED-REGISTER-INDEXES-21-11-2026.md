# Security Posture Assessment (Implementation) — US010 The seven register indexes are born seeded

| Field           | Value                                                                                                                                                                                                                |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US010 — The seven register indexes are born seeded, and the map index leaves the file that ships (re-cut 19/11/2026: the decisions, findings and bugs boards)                                                        |
| **Date**        | 21/11/2026                                                                                                                                                                                                           |
| **Verified by** | Claude Code — independent recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                                                                                |
| **Sprint**      | SPRINT-06                                                                                                                                                                                                            |
| **Plan doc**    | `../PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (signed off 28/09/2026, Section 7 re-mapped 19/11/2026)                                                                                               |
| **Outcome**     | **PASS with deferred items** — 7.1 to 7.8 and 7.13 closed; 7.9 and 7.10 superseded; 7.11, 7.14 and 7.15 closed in substance, their `GAPS.md` entries written by this gate 21/11/2026 (F-019 to F-021); 7.12 to US012 |

---

## 1. Scope

The shipped surface and its evidence are the audit's
(`../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md`, Section 1) and
the threat-model review's
(`../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md`),
both consumed here, at `testing` `7d54df26`, with CI runs `44949084218`, `44949241651`,
`44949241388` and `44950192371` (all success). **Addition to the plan's scope:** the gate
enforcement layer — `template-integrity.sh`, `lefthook.yml`'s pre-push leg, `template-hooks.sh`,
`copier-commands.py`, `register-index-routes.sh`, `.github/CODEOWNERS` — and the repository's merge
settings, set by Sam 21/11/2026.

| File                                                                                              | Purpose                                           |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `copier.yml` `:1138-1158`                                                                         | The copy-gated seed task (7.1, 7.2, 7.8)          |
| `.github/scripts/shipped-boards.sh` · `shipped-boards-words.sh` · `copier-commands.py`            | Checks 1 to 5 (7.3, 7.4, 7.6, 7.8)                |
| `.github/scripts/shipped-ai.py`                                                                   | The update probe (7.7)                            |
| `.github/scripts/shipped-artefacts.sh` `:123-133`                                                 | `SEEDED` (7.12)                                   |
| `.github/scripts/template-integrity.sh` · `.github/workflows/audit-template.yml`                  | Where the self-tests run (7.5)                    |
| `project-management/src/00-ASSETS/scripts/pm-board.sh` · `pm-lib.sh` · `pm-archive.sh`            | Boards, `--check`, the archive freeze (7.9, 7.11) |
| `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md` · `14-UPDATING.md` · `how-to/src/TEMPLATE-TOKENS.md` | 7.13, 7.14, 7.15                                  |

## 2. OWASP Top 10 — coverage

| ID       | Category                              | Status  | Evidence / Notes                                                                                                                                                                                           |
| -------- | ------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | N/A     | No principal or ownership check on the surface. On the repository: the admin bypass (audit F-001) and CODEOWNERS binding no one (F-005), both accepted residuals                                           |
| A02:2025 | Security Misconfiguration             | PASS    | TM-16 caught twice: CI `[1/4]` token self-test, `[3/4]` "0 unrendered tokens". `_exclude` carries no board negation                                                                                        |
| A03:2025 | Software Supply Chain Failures        | PARTIAL | TM-15 promoted to MEDIUM (its trigger fired five times); controls are pre-push plus required CI jobs (`template-integrity.sh:87-97`). Residual: workflow diffs review's (F-004); CI Copier unnamed (F-011) |
| A04:2025 | Cryptographic Failures                | N/A     | No secret, key or credential read, written or compared (audit C5)                                                                                                                                          |
| A05:2025 | Injection                             | N/A     | No untrusted input reaches a renderer. Check 2 matches by pattern, never `eval` (`seed_word`, `shipped-boards-words.sh:25`)                                                                                |
| A06:2025 | Insecure Design                       | PARTIAL | TM-09 (`SEEDED` an allowlist, presence US012's); TM-14 documented, migration in `GAPS.md` (written 21/11/2026, F-020)                                                                                      |
| A07:2025 | Authentication Failures               | N/A     | No principal is authenticated                                                                                                                                                                              |
| A08:2025 | Software and Data Integrity Failures  | PASS    | TM-01 to TM-04 mitigated by check 1, check 2, check 4 and the byte-identity update probe, all green in CI; TM-18 documented; residuals F-002, F-003, F-006, F-007                                          |
| A09:2025 | Security Logging & Alerting Failures  | PARTIAL | TM-17 accepted, narrowed (no `Updated` column; generated boards)                                                                                                                                           |
| A10:2025 | Mishandling of Exceptional Conditions | PASS    | Every failure is loud: `rmdir .copier` last (`copier.yml:1157`); the reader refuses what it cannot read; the crash guard exits 2 (`self-test-ledger.sh`); empty roots exit 2. Residual F-009, F-010        |

## 3. NIST CSF 2.0 — coverage

| Fn  | Function | Status  | Evidence                                                                                                                                                                                                    |
| --- | -------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | PASS    | The one-way door now covers eight boards (`copier.yml` comment above `:1138`); one ADR records the re-cut; vocabularies have one owner (`.claude/skills/completion/SKILL.md`); merge-method rule documented |
| ID  | Identify | PASS    | Ten review rounds re-attacked the gates; every residual is written down with its evidence. Gaps: actionlint and the CI Copier version unmeasured                                                            |
| PR  | Protect  | PASS    | Checks 1, 2, 4 and 5 over eight boards; archive freeze in required `[1/4]` at full depth (`audit-template.yml:49`, `:84`)                                                                                   |
| DE  | Detect   | PASS    | Moved off **Weakest**: the update probe is proved red by mutation in CI, check 2 sees the task's gate, and `--check` sees a stale board. Residual: shape probe narrow, run-time names review's              |
| RS  | Respond  | PASS    | Every failure mode fails the build and names its cause                                                                                                                                                      |
| RC  | Recover  | PARTIAL | TM-14 and TM-18 documented without a fix; their complete fixes are `GAPS.md` entries this gate still owes. A recopy still loses uncommitted register edits                                                  |

## 4. Findings

The findings raised on the shipped code are the audit's F-001 to F-011 (threat-model TM-N1 to
TM-N7), restated here by severity only:

| ID    | STRIDE | OWASP    | NIST CSF | Severity | Finding                                                                   | Recommendation                               | Status   |
| ----- | ------ | -------- | -------- | -------- | ------------------------------------------------------------------------- | -------------------------------------------- | -------- |
| F-001 | E      | A01:2025 | PR.AA    | LOW      | Admin bypass (`always`) skips every required check, can force-push `main` | Accepted; revisit if a second admin is added | Residual |
| F-002 | T      | A08:2025 | PR.PS    | LOW      | Only `main` is protected; hooks skippable                                 | CI is the record                             | Residual |
| F-003 | T      | A08:2025 | DE.CM    | LOW      | Check 2 blind to run-time-built names and Jinja in commands               | Review                                       | Residual |
| F-004 | T      | A03:2025 | DE.CM    | LOW      | CI shape probe misses quoted keys, overrides, skipped `needs:`            | Review every workflow diff                   | Residual |
| F-005 | E      | A01:2025 | GV.RR    | INFO     | CODEOWNERS without required code-owner review                             | Accepted                                     | Residual |
| F-006 | T      | A08:2025 | PR.PS    | LOW      | Merge-only settings outside the tree, re-read by no gate                  | Read back on any settings change             | Residual |
| F-007 | T      | A08:2025 | PR.DS    | INFO     | A squash pushed directly to an unprotected branch                         | Documented rule; CI fails it                 | Residual |
| F-008 | T      | A08:2025 | DE.CM    | INFO     | Memory seed blind case (pre-existing)                                     | `GAPS.md` entry                              | Deferred |
| F-009 | —      | A10:2025 | ID.AM    | LOW      | Landing and export-provenance captures missed                             | Record as missed at the walk                 | Residual |
| F-010 | —      | A10:2025 | PR.PS    | INFO     | `shipped-boards.sh` at 750 lines; load-sensitive timing probes            | Split before the next probe                  | Residual |
| F-011 | —      | A03:2025 | ID.AM    | INFO     | actionlint and CI Copier version unmeasured                               | Pin or print the Copier version              | Residual |

**No CRITICAL or HIGH finding was identified.** Nothing is escalated to
`../../VULNERABILITIES/IMPLEMENTATION/`.

## 5. Planning-phase findings — status update

| Plan finding | Status                    | Evidence / Notes                                                               |
| ------------ | ------------------------- | ------------------------------------------------------------------------------ |
| TM-01        | Resolved                  | Copy-gated task, check 2, the ungated mutation red in CI `44949084218` `[3/4]` |
| TM-02        | Resolved                  | Check 1, decoded entries, tags and Jinja refused                               |
| TM-03        | Resolved                  | Check 4 byte-identity                                                          |
| TM-04        | Resolved                  | Seeds changed between tags, byte-identity, proved red                          |
| TM-05        | Resolved                  | Fixture creates parents; no `mkdir -p`                                         |
| TM-06        | Resolved                  | One-line form; check 2's plain-`mv` step rule                                  |
| TM-07        | Resolved                  | `rmdir .copier` last                                                           |
| TM-08        | Resolved                  | Check 4                                                                        |
| TM-09        | Residual                  | Allowlist; presence US012's                                                    |
| TM-10        | Residual                  | Window narrowed by `--check`; `GAPS.md` entry written 21/11/2026 (F-019)       |
| TM-11, TM-12 | Resolved (superseded)     | Plain status lines; 7.7.0 map vocabulary                                       |
| TM-13        | Resolved                  | No count at any site                                                           |
| TM-14, TM-18 | Residual                  | Documented; `GAPS.md` entries written 21/11/2026 (F-020, F-021)                |
| TM-15        | Residual, promoted MEDIUM | Trigger fired five times; controls and residuals in the threat-model review    |
| TM-16        | Resolved                  | Token gates                                                                    |
| TM-17        | Residual                  | Accepted, narrowed                                                             |
| TM-N1 to N7  | New                       | Audit F-001 to F-011                                                           |

Section 6's count moves from 0 / 0 / 4 / 12 / 2 (CRITICAL / HIGH / MEDIUM / LOW / INFO) to
**0 / 0 / 5 / 16 / 4** with TM-15's promotion and the seven new threats; the four planned MEDIUMs
are resolved, so the one open MEDIUM is TM-15.

## 6. Plan gaps closed & deferred items

Section 7 as re-mapped 19/11/2026 (the plan's re-cut note).

| Item                                                  | Status                | Evidence / Blocked by                                                                                                                                                                                                                                           |
| ----------------------------------------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.1 — moves in the copy-gated task (ST01)             | Closed                | `copier.yml:1148-1155` in `:1138-1158`; check 2 (`shipped-boards.sh:33`); ungated mutation red in CI                                                                                                                                                            |
| 7.2 — ahead of `rmdir`, which stays `rmdir` (ST02)    | Closed                | `copier.yml:1157`                                                                                                                                                                                                                                               |
| 7.3 — blankness proved (ST03, superseded by check 4)  | Closed                | Check 4 (`shipped-boards.sh:76`); R4's red recorded; CI `[2/4]` "current, empty PM boards"                                                                                                                                                                      |
| 7.4 — no syntek-base literal (ST04)                   | Closed                | Check 4; the maps seed rendered from the seeded map; no literal grep built (re-cut round 3 Q4)                                                                                                                                                                  |
| 7.5 — no network, no credential, the allowlist (ST05) | Closed with deviation | No fetch or credential read. 39 paths outside the re-cut allowlist, each under a ruling of Sam's (audit Section 7). Existing probes rewritten to write a ledger (`bf6440cb`), each a pass at HEAD. Export provenance for `US010-CLIENT.md` not captured (F-009) |
| 7.6 — no negation re-includes a board (ST06)          | Closed                | `negation_matches` (`shipped-boards-words.sh:119`); `copier-commands.py` `exclude_entry` `:403`; probes for literal, glob, slash-less, folder, escaped, block, flow, tagged and Jinja forms                                                                     |
| 7.7 — the update probe (ST07)                         | Closed                | `shipped-ai.py:262-265`, `:270-278`, `:320-333`; R6 `4119d6fa` → `6e35c080`; CI "8 edited boards are byte-identical" on both paths. Plan Section 8 item 3 is **closed**: the Copier reading is now a measurement, of an unnamed version (F-011)                 |
| 7.8 — one-line form (ST08)                            | Closed                | `copier.yml:1148-1155`; R9-4 (`606f51ea`)                                                                                                                                                                                                                       |
| 7.9 — one read rule                                   | Superseded            | Plain `**Status:**` lines, vocabulary in `.claude/skills/completion/SKILL.md`; `--check` green with no Unrecognised                                                                                                                                             |
| 7.10 — map status header                              | Superseded            | 7.7.0, 31/10/2026                                                                                                                                                                                                                                               |
| 7.11 — the TM-10 window                               | Deferred              | Narrowed by `--check` in `[1/4]`; the `GAPS.md` entry was written at **this** gate 22, 21/11/2026 (F-019; absent at `7d54df26`)                                                                                                                                 |
| 7.12 — `SEEDED` an allowlist, presence US012's        | Deferred              | `shipped-artefacts.sh:123-133`, check 5; US012 `Pending`                                                                                                                                                                                                        |
| 7.13 — count sites name the task                      | Closed                | `04-QUICKSTART.md:21-25`, `14-UPDATING.md:39-41`, `TEMPLATE-TOKENS.md:549`                                                                                                                                                                                      |
| 7.14 — TM-14 documented                               | Closed; entry written | `14-UPDATING.md:48-59`; seed-if-absent migration to `GAPS.md`, written 21/11/2026 (F-020)                                                                                                                                                                       |
| 7.15 — TM-18 documented                               | Closed; entry written | `14-UPDATING.md:61-65`; existing-target guard to `GAPS.md`, written 21/11/2026 (F-021)                                                                                                                                                                          |
| Plan Section 8 item 4 — memory-survival blind case    | Deferred              | Unchanged in `shipped-ai.py:258-259`; `GAPS.md` entry written 21/11/2026 (F-022)                                                                                                                                                                                |
| The 72-case matrix (approved remediation 09/10/2026)  | Deferred              | Moved to `../../../01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md` S-01 (re-cut round 4 Q1); unmeasured here                                                                                                                                                        |

## 7. Deviations from plan

- **The re-cut, 19/11/2026.** Three generated boards replaced seven hand-written index files;
  Section 7 was re-mapped in the plan's own dated note, and the story's Security Acceptance
  Criteria carry the same mapping. No severity moved at the re-cut.
- **The gate-enforcement layer was built, then rebuilt.** The planned-red allowance (Sam's D4) was
  added for this story's red-first discipline and removed under his Q1 after four rounds found
  narrower bypasses of it; its replacement is the pre-push leg and required CI. It carries no
  acceptance criterion and no points (`../../../02-STORIES/US010.md` → _Re-cut — 19/11/2026_), but
  it is where TM-15 fired and where the new residuals sit.
- **GitHub settings changed outside the change.** Merge commits only, squash and rebase off, strict
  checks on `main` — set by Sam on 21/11/2026, read back the same day; never by the build.
- **The four `GAPS.md` entries** the plan routes through gate 22 are this gate's to write; they are
  not in the tree this record reads.

## 8. Sign-off

| Reviewer                             | Role                          | Date       |
| ------------------------------------ | ----------------------------- | ---------- |
| Claude Code — `security` skill, Opus | Independent recorder, gate 22 | 21/11/2026 |
| Sam                                  | Developer — review owed       | —          |

**Overall verdict:** the story meets the posture targets its baseline set — DE moved off
**Weakest**, A08 to PASS — and introduced no CRITICAL or HIGH; it closes with one open MEDIUM
(TM-15, at design state) and its `GAPS.md` entries written by this gate on 21/11/2026 (F-019 to F-023).

---

## Cross-references

- `../PLANNING/ASSESSMENT-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the baseline answered here
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md` · `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md` — the audit and threat-model review consumed
- `../../VULNERABILITIES/IMPLEMENTATION/` — nothing escalated
- `../../../02-STORIES/US010.md` — the source story
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP, and NIST CSF standards
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the enforcement side these claims must stay consistent with
