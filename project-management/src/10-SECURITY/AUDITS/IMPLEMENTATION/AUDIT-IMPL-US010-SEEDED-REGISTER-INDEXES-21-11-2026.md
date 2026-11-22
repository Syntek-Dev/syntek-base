# Security Audit — US010 The seven register indexes are born seeded

| Field          | Value                                                                                                                                                                                                                                                                                                          |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**      | US010 — The seven register indexes are born seeded, and the map index leaves the file that ships (re-cut 19/11/2026: the decisions, findings and bugs boards)                                                                                                                                                  |
| **Date**       | 21/11/2026                                                                                                                                                                                                                                                                                                     |
| **Audited by** | Claude Code — independent recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                                                                                                                                                                          |
| **Plan doc**   | **None.** No `AUDIT-PLAN-US010-*` was written at gate 10. This audit answers the threat-model plan's Section 4b constraints (ST01 to ST08, as re-cut 19/11/2026); the assessment plan's 7.1 to 7.15 are closed in the assessment record (Section 7 below)                                                      |
| **Verdict**    | **Pass with notes** — no CRITICAL or HIGH; every planned control is in the shipped code at `testing` and green in CI; eleven residuals recorded (Section 2), TM-15's promotion trigger fired five times (Section 5), and the `GAPS.md` entries it named were written by gate 22 on 21/11/2026 (F-019 to F-023) |

---

## 1. Scope audited

Walked at `testing` `7d54df26` (the merge of PR 38 at `7e88b9b3`, first parent `b5fcede`, second
parent `6554cf9e`; the merge base is `b5fcede`, the P0 commit). The diff `b5fcede..7e88b9b3`
touches 256 paths over 180 commits. The review-round findings are quoted from the manual guide's
build records (`../../../18-TESTS/MANUAL/US010-MANUAL-TESTING.md` → _Recorded during the build_,
fix rounds 1 to 10, the final fix pass and the countersignature). Nothing under the working tree
was executed by this audit; it read the shipped code and three CI runs with read-only `gh`:

- push `44949084218` (`Audit — Template Integrity`, `us010/seeded-register-indexes` at
  `6554cf9e`): `[1/4]` to `[4/4]` success;
- pull request `44949241651` (the same workflow, `6554cf9e`): `[1/4]` to `[4/4]` success;
- pull request `44949241388` (`PM Boards`, `6554cf9e`): "Boards current, archive frozen" and
  "Stale statuses (advisory)" success;
- and, after the merge, push `44950192371` (`Audit — Template Integrity`, `testing` at
  `7d54df26`): `[1/4]` to `[4/4]` success.

| File                                                                                              | Verdict         | Notes                                                                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `copier.yml`                                                                                      | Pass            | One copy-gated seed task `:1138-1158`, gate `:1158`; the eight board `mv` lines `:1148-1155` in one-line form, ahead of `rmdir .copier` `:1157`; no board negation in `_exclude`; no `mkdir -p`                  |
| `.copier/*-BOARD.md` (eight seeds, three new)                                                     | Pass            | Byte-identical to the seed-only render — CI `44949084218` `[2/4]`: "A generated project receives current, empty PM boards"                                                                                       |
| `.github/scripts/shipped-boards.sh` · `shipped-boards-words.sh`                                   | Pass with notes | Checks 1 to 5 (`:24-79`), `run_checks` `:198`, `self_test` `:331`; 100 probes green in CI. Run-time-built names are review's (F-003). The script sits at exactly 750 lines (F-010)                               |
| `.github/scripts/copier-commands.py`                                                              | Pass with notes | Standard-library YAML reader: `top_level` `:330`, `line_breaks` `:367`, `jinja_checked` `:394`, `exclude_entry` `:403`; anything outside plain top-level keys is refused. Jinja in a command is review's (F-003) |
| `.github/scripts/shipped-ai.py`                                                                   | Pass with notes | `exercise` `:233`: every board seed changed between tags (`:262-265`), byte-identity after `run_update` (`:270-278`); ungated mutation `:320-333` red in CI. Memory seed blind case remains (F-008)              |
| `.github/scripts/shipped-artefacts.sh`                                                            | Pass            | `SEEDED` `:123-133` lists all eight boards; still an allowlist (TM-09), presence loop US012's                                                                                                                    |
| `.github/scripts/template-integrity.sh` · `self-test-ledger.sh`                                   | Pass with notes | `SELF_TESTS` `:87-97`; pre-push leg; header `:44-46` states the bypass and the merge-only settings. Only `main` protected (F-002)                                                                                |
| `.github/scripts/register-index-routes.sh`                                                        | Pass            | CI `[3/4]`: self-test green ("0 is never a pass"; empty root exit 2), both renders 0 hits                                                                                                                        |
| `.github/workflows/audit-template.yml`                                                            | Pass with notes | `[1/4]` full-depth checkout `:49`, `pm-boards.sh` `:74`, `pm-board.sh --check` `:84`; `[2/4]` `shipped-boards.sh` `:124`, `:127`; `[3/4]` completeness `:287-289`, routes `:439-442`. Shape probe narrow (F-004) |
| `project-management/src/00-ASSETS/scripts/pm-board.sh` · `pm-lib.sh` · `pm-archive.sh`            | Pass            | Three new kinds; `frozen_breaches` `:395` (merge-aware since `b42b004f`, `--diff-merges=separate` since `7b91945c`); CI `[1/4]` "all 8 boards are current and archive/ is untouched"                             |
| `code/src/scripts/tests/pm-boards.sh` · `template-hooks.sh`                                       | Pass            | CI `[1/4]`: 112 probes passed; 69 passed, 0 failed                                                                                                                                                               |
| `lefthook.yml` · `code/src/scripts/development/install-hooks.sh`                                  | Pass with notes | Pre-commit runs plain checks only; pre-push runs every self-test. A skipped hook is covered only by CI (F-002)                                                                                                   |
| `.github/CODEOWNERS`                                                                              | Pass with notes | Names the gate paths; binds no one, code-owner review off by ruling (F-005)                                                                                                                                      |
| `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md` · `14-UPDATING.md` · `how-to/src/TEMPLATE-TOKENS.md` | Pass            | `--trust` disclosure `:21-25` names the task as the list; `14-UPDATING.md:29-65` the TM-14 and TM-18 statements; `TEMPLATE-TOKENS.md:549` names the list                                                         |
| `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md`                                           | Pass with notes | _Merge methods and the archive freeze_; the settings it names live outside the tree (F-006)                                                                                                                      |

**Not run by this audit:** ShellCheck, ruff and actionlint. The build's closing readings record
ShellCheck 0.11.0 clean over every edited shell script and ruff clean over `copier-commands.py`;
**actionlint is unmeasured** in every round — no `code/src/scripts/**` script runs it (F-011).

## 2. Findings

### 2a. Residuals this audit records

| ID    | STRIDE | OWASP    | NIST CSF | Trust boundary | Finding                                                                                                                                                                                                                                                                                                                                                                                                 | Severity | Mitigation / fix                                                                                                   | Status   |
| ----- | ------ | -------- | -------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------ | -------- |
| F-001 | E      | A01:2025 | PR.AA    | TB5 CI → merge | Ruleset `20221742`'s bypass actor (RepositoryRole 5, admin, `bypass_mode: always`) can merge or push past every required check, and force-push or delete `main`. Every CI control this story adds is advisory to that role (fix round 7 R7-4, round 8 R8-5; read back under _Final fix pass_)                                                                                                           | LOW      | Accepted by Sam's ruling (R7-3, R7-4); stated in `template-integrity.sh:44-46` and `PR-AND-REQUIRED-CHECKS.md`     | Residual |
| F-002 | T      | A08:2025 | PR.PS    | TB5 CI → merge | Only `main` is protected. A red or weakened tip can reach `dev`, `staging` or `testing` by direct push; a hook can be skipped; a pushed commit can edit the workflow or `SELF_TESTS` that judges it. CI on the tip is the record (fix round 6 window paragraph, amended R7-4)                                                                                                                           | LOW      | Pre-push leg; CI runs every self-test in a required `[n/4]` job on every branch                                    | Residual |
| F-003 | T      | A08:2025 | DE.CM    | TB3 update     | Check 2 reads the literal words left after YAML decoding and shell quote removal. A name built at run time — parameter expansion, backticks, `$'…'` escapes, `eval`, a variable, a script the task runs — and Jinja in a command are review's alone (R8-2, R9-1; header `shipped-boards.sh:71`)                                                                                                         | LOW      | Stated as review's; the behavioural update probe still catches an ungated seed move of a board                     | Residual |
| F-004 | T      | A03:2025 | DE.CM    | TB5 CI → merge | The CI shape probe in `template-hooks.sh` proves each listed step present in a required job with no **unquoted** `if:` or `continue-on-error` and a full-depth `--check` checkout. It does not detect a quoted key, a `shell:` or `defaults:` override, `needs:` on a skipped job, or a second shallow checkout (R8-4)                                                                                  | LOW      | Claim narrowed to what it proves; workflow diffs are review's                                                      | Residual |
| F-005 | E      | A01:2025 | GV.RR    | TB5 CI → merge | `.github/CODEOWNERS` names the gate paths but `require_code_owner_review` stays `false` (R7-3): the sole owner cannot approve their own pull request, so the file binds no one                                                                                                                                                                                                                          | INFO     | Accepted by Sam's ruling                                                                                           | Residual |
| F-006 | T      | A08:2025 | PR.PS    | TB5 CI → merge | Merge commits only on every branch (`allow_squash_merge=false`, `allow_rebase_merge=false`) and merge-only plus strict checks on `main` were set by Sam on 21/11/2026 and read back once. They live outside the tree; no gate re-reads them, so a later settings change undoes the archive-freeze protection silently. Whether `allow_rebase_merge=false` hides "Update with rebase" is unmeasured (F3) | LOW      | Read-back commands in `PR-AND-REQUIRED-CHECKS.md`                                                                  | Residual |
| F-007 | T      | A08:2025 | PR.DS    | TB3 update     | The squash-onto-`testing` lock: a squash of a range carrying an archive move fails `--check` (measured R8-1). Repository settings now refuse squash on every pull request, but a squashed commit pushed directly to an unprotected branch is refused by nothing but CI (F-002)                                                                                                                          | INFO     | Documented rule; CI `--check` fails it loudly                                                                      | Residual |
| F-008 | T      | A08:2025 | DE.CM    | TB3 update     | Pre-existing: `shipped-ai.py`'s memory-survival assertion changes the template's `.claude/MEMORY.md` between tags (`:258-259`) but never `.copier/MEMORY.md`, so it would pass with the memory seed ungated alone. The board probe covers the shared gate, not each seeded file                                                                                                                         | INFO     | Routed to `GAPS.md` through gate 22 (settled 27/09/2026, grilling round 3 Q16) — **not yet written at `7d54df26`** | Deferred |
| F-009 | —      | A10:2025 | ID.AM    | TB2 copy       | Build-capture slots required by 7.5 and the 09/10/2026 remediation are blank in the manual guide: clean landing HEAD, post-rebase base / target / HEAD, and the export provenance of `project-management/export/clickup/US010-CLIENT.md`. A capture missed at its moment is recorded as missed                                                                                                          | LOW      | Recorded as missed; no row reading them can be marked `Pass` at the walk                                           | Residual |
| F-010 | —      | A10:2025 | PR.PS    | TB5 CI → merge | `shipped-boards.sh` is at exactly 750 lines, the source limit; its 2 s timing probes are load-sensitive (one unexplained red under 36 concurrent self-tests, fix round 10). A false red invites widening a budget, which is a probe edit                                                                                                                                                                | INFO     | Recorded; the next probe needs a split first                                                                       | Residual |
| F-011 | —      | A03:2025 | ID.AM    | TB5 CI → merge | Unmeasured: actionlint over `audit-template.yml`, `pm-boards.yml` and `lefthook.yml`; and the Copier version CI's `[3/4]` ran (`uvx --offline --from copier`, `shipped-ai.sh:35`, unpinned and not printed in the log), so 7.7's measurement is of an unnamed release                                                                                                                                   | INFO     | Recorded as unmeasured, never as a pass                                                                            | Residual |

**No new CRITICAL or HIGH.** Nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`. F-001
is the finding most worth reading first: it does not weaken any one control, it bounds all of them.

### 2b. The review rounds' security findings — found and closed

Every round ran code-reviewer, qa-tester and security separately; each finding was fixed with an
ordinary red commit ahead of its fix, or answered. The full tables are the manual guide's; the
security-relevant lineage is:

| Round | Finding (highest severity)                                                                                          | Closed by                                                                                   |
| ----- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 3     | The planned-red allowance accepted a crash as a red; forged trailers; `norm()` erased any `archive/` (Sec-M1 to M4) | Crash guard exit 2 (`bf6440cb`); trailer token; path-only rewrite (`16fa59d3`)              |
| 4     | Relabelled probes made a gutted detector a "new" red; the archiving commit was ungated (CR-H1, Sec-M2)              | Never-weaken (`5da73663`); the freeze's move rules (`9d870761`)                             |
| 5     | `self_test()` found by text let a planned red gut a check (CR-H1, QA-H1, Sec-H1); merge commits hid archive edits   | **Allowance removed** by Sam's Q1 (`c641e5e7`); merge-aware freeze (`b42b004f`)             |
| 6     | `pm-boards.sh` was not in a required job; `log.diffMerges` hid a deletion; check 2 globs (Sec-M1)                   | `[1/4]` step (`01ae497f`); `--diff-merges=separate` (`7b91945c`); path reading (`dcf4f663`) |
| 7     | Check 2 missed a path behind `=`; a deleted self-test skipped; the freeze ran only unrequired (Sec-M1, L4)          | `4a84db5e`, `1fe4c8af`; `b3abbf94`; `--check` in `[1/4]` at full depth (`52353c90`)         |
| 8     | Squash onto `main` would lock `--check`; check 2 read no YAML layer; rewritten histories (Sec-M1, QA-M1 to M3)      | Merge-method rule (`675d7eff`); `copier-commands.py` (`a5eae71d`); `f76ddab6`               |
| 9     | Quoted, `?` or `!include` top-level keys; grafts forged ancestry (CR-M1, QA-M1, Sec-M1)                             | Plain-keys-only reader (`ac00e69a`); `origin/main` alone, no grafts (`68747533`)            |
| 10    | A NEL, U+2028, U+2029 or lone CR hid a top-level key; `_exclude` read undecoded (CR-M1, QA-M1, Sec-M1)              | Line breaks refused (`aad5c032`); decoded entries (`72357977`)                              |
| Final | A string-tagged `_exclude` entry; Jinja in `_exclude` (CR-M1, QA-M1, Sec-M1; CR-L1)                                 | Tags refused (`4a60b1ad`); Jinja refused (`1d450d19`); verified clean at `cdbcd700`         |

No CRITICAL was raised in any round; the HIGHs of rounds 4 and 5 were closed by removing the
mechanism they attacked. Sam countersigned all US010 work on 21/11/2026 (the guide's
_Countersignature — 21/11/2026_), which is not a status transition and not this gate's walk.

## 3. Checklist results

| #   | Control                                                                        | Result | Evidence (file · symbol)                                                                                                                                                                                                                           |
| --- | ------------------------------------------------------------------------------ | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| C1  | Explicit, named permission check on every state-changing Django Ninja endpoint | N/A    | No endpoint                                                                                                                                                                                                                                        |
| C2  | User-supplied IDs verified against the caller's ownership — no IDOR            | N/A    | No identifier. The analogue — what a generated project may receive — is the copy gate (`copier.yml:1158`) and check 1                                                                                                                              |
| C3  | `CORS_ALLOWED_ORIGINS` is an explicit allowlist — never `*` in production      | N/A    | Untouched                                                                                                                                                                                                                                          |
| C4  | `DEBUG=False` in every non-local environment                                   | N/A    | Untouched                                                                                                                                                                                                                                          |
| C5  | All secrets read from environment variables — none hardcoded                   | Pass   | No secret, token or `.env*` read in the diff (`git diff b5fcede 7e88b9b3` over `.github`, `code`, `lefthook.yml`, the PM scripts: no new `curl`, `wget`, `gh` or credential variable); the GitHub settings were changed by Sam, never by the build |
| C6  | Input validated and typed at the boundary (UUIDs, length, allowlists)          | Pass   | `copier-commands.py` refuses every top-level shape but plain keys (`top_level` `:330`), any non-`\n` line break (`line_breaks` `:367`), tags and Jinja in `_exclude` (`exclude_entry` `:403`); `WORD_CAP` and `BRACE_CAP` bound check 2 per word   |
| C7  | Injection defence — ORM / parameterised queries, output escaping, no raw SQL   | Pass   | Shell analogue: check 2 matches by pattern only, no `eval` (`shipped-boards-words.sh` `seed_word` `:25`); `python3 -I` for the shape parse                                                                                                         |
| C8  | Sensitive data kept out of error payloads and logs                             | Pass   | Findings print paths, patterns and line numbers only; CI logs read for the three runs carry no credential                                                                                                                                          |
| C9  | Multi-write paths transactional and audit-logged where security-relevant       | Pass   | The seed chain is one `&&` chain ending `rmdir .copier`, so any failed move aborts generation; `pm-archive.sh` moves and rewrites in one commit, which `--check` judges against the live copy                                                      |

## 4. OWASP Top 10 coverage

| #   | Category                              | Result                                                        |
| --- | ------------------------------------- | ------------------------------------------------------------- |
| A01 | Broken Access Control                 | N/A on the surface; F-001, F-005 on the repository            |
| A02 | Security Misconfiguration             | Pass — TM-16                                                  |
| A03 | Software Supply Chain Failures        | TM-15 at design state MEDIUM; F-004, F-011                    |
| A06 | Insecure Design                       | Pass — TM-09, TM-14 residuals tracked                         |
| A08 | Software and Data Integrity Failures  | Pass — TM-01 to TM-04 mitigated; F-002, F-003, F-006 to F-008 |
| A09 | Security Logging & Alerting Failures  | TM-17 accepted residual                                       |
| A10 | Mishandling of Exceptional Conditions | Pass — every failure loud; F-009, F-010                       |

A04, A05 and A07 are N/A
(`../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md`,
Section 2).

## 5. Plan constraints closed

The threat-model plan's Section 4b constraints, as re-cut 19/11/2026 (`../../../02-STORIES/US010.md`
→ _Security Acceptance Criteria_, the re-cut block). No audit plan exists.

| Plan constraint                                                 | Status                | Evidence                                                                                                                                                                                                                                                   |
| --------------------------------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ST01 — the board `mv` lines in the copy-gated task              | Closed                | `copier.yml:1148-1155` inside `:1138-1158`; check 2 binds each move to that task (`shipped-boards.sh:33`); CI `44949084218` `[3/4]`: "PASS: detector rejects ungated-seed-task — … FEATURE-MAPS-BOARD.md was not byte-identical to the project's own edit" |
| ST02 — ahead of `rmdir .copier`, which stays `rmdir`            | Closed                | `copier.yml:1157`; R9-4 requires every step a plain `mv` or, last, `rmdir .copier`                                                                                                                                                                         |
| ST03 — blankness proved (superseded: check 4)                   | Closed                | Check 4 byte-identity with the seed-only render (`shipped-boards.sh:76`); CI `[2/4]` "current, empty PM boards"; R4 red recorded in the guide                                                                                                              |
| ST04 — no syntek-base literal in a seed (check 4)               | Closed                | The same check 4; the feature-maps seed is rendered from the seeded `MAP-SCALE-PLANNING.md`                                                                                                                                                                |
| ST05 — no network, no credential read, the write allowlist      | Closed with deviation | No fetch or credential read (C5). **39 paths outside the re-cut allowlist**, each under a recorded ruling of Sam's (Section 7)                                                                                                                             |
| ST06 — no negation re-includes a board (check 1)                | Closed                | `negation_matches` (`shipped-boards-words.sh:119`, gitignore semantics); decoded entries (R10-2), tags (F1) and Jinja (F2) refused; no board negation in `copier.yml`                                                                                      |
| ST07 — the update probe: seeds changed, byte-identity, red      | Closed                | `shipped-ai.py:262-265`, `:270-278`, `:320-333`; R6 red `4119d6fa`, green `6e35c080`; CI: "8 edited boards are byte-identical" for both optional-skill paths                                                                                               |
| ST08 — one-line form                                            | Closed                | `copier.yml:1148-1155`: no flag, quoting, `\|\| true` or split; check 2 reads the decoded `&&` steps (R9-4, `606f51ea`)                                                                                                                                    |
| TM-15 — every probe red before green, existing probes unchanged | Closed with deviation | Fired at `3d136347`, `cca66558`, `0e4fde5b`, `c0de1427` and, deliberately, `c641e5e7` (guide, R4 and fix round 5 item 14). Read at design state MEDIUM — the threat-model record                                                                           |

## 6. Deferred / residual items

- **`GAPS.md` entries owed by this gate** (`22-implementation-documentation`, the sole writer),
  none present at `7d54df26`, all written 21/11/2026 (F-019 to F-023): TM-10's window (absorbed from US011, round 2 Q1), TM-14's
  seed-if-absent migration, TM-18's existing-target guard, the memory-survival blind case (F-008),
  and the sprint-plan prerequisites entry (`../../../02-STORIES/US010.md` → _Re-cut Tasks_).
- **TM-09's presence half** — US012 (`Pending`).
- **The 72-case generation matrix** —
  `../../../01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md` S-01, uncut (re-cut round 4 Q1).
- F-001 to F-007, F-009 to F-011 — accepted residuals above, no tracking entry beyond this record.

## 7. Deviations from plan

- **No audit plan.** Gate 10 wrote a threat model and an assessment only; this record answers the
  threat model's Section 4b.
- **The plan was re-cut** at the build's first step, 19/11/2026: seven hand-written index files
  became three generated boards beside the five 7.7.0 built
  (`../../../15-DECISIONS/ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md`). ST03 and
  ST04 are carried by `shipped-boards.sh` check 4, not a third `shipped-registers.sh` family.
- **ST05's reach.** `git diff --name-only b5fcede 7e88b9b3` names 39 paths outside the re-cut
  allowlist. Each sits under a recorded ruling: the planned-red allowance and its removal (D4,
  then Q1 — `template-integrity.sh`, `self-test-ledger.sh`, `lefthook.yml`, `install-hooks.sh`,
  `hook-arming.sh`, `template-hooks.sh`, `code/workflows/02-tdd-cycle/`, `code/docs/TESTING.md`,
  `project-management/docs/git/`); the archive freeze and formatter skip (`.prettierignore`,
  `.markdownlint-cli2.jsonc`, `pm-boards.yml`, `project-management/CLAUDE.md`); CODEOWNERS (round 6
  I); `.claude/MEMORY.md` (R8-1, R9-7); `pm-archive.sh` path rewrites in `GAPS.md` and
  `DEFERRED.md`; three exports beside US010's (`US005`, `US006`, `US009` → `Accepted`, Sam
  19/11/2026, `049186d6`). The board count in two shipped docs (`README.md`,
  `resolving-merge-conflicts/SKILL.md`) followed the change. None is a network fetch or a
  credential read.
- **ST05's "every existing probe unchanged".** `bf6440cb` rewrote existing probes in all five
  detectors to write the ledger, every one recording a pass at HEAD (fix round 4 item 16); the
  P0 count was 12 / 8 / 2, not the plan's 9 / 5 / 2, because 7.7.0 had landed (P0-3).
- **R4's red was taken locally**, not committed alone (fix round 1; the blob is pasted into the
  guide), which is TM-15's first firing.

## 8. Sign-off

| Auditor                              | Role                                                                                                                    | Date       |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- | ---------- |
| Claude Code — `security` skill, Opus | Independent recorder, gate 22                                                                                           | 21/11/2026 |
| Sam                                  | Developer and security — reviewed and signed off by Sam, 22/11/2026 — on the summary; residuals as ruled (ruling R-008) | 22/11/2026 |

**Signed off 22/11/2026 (ruling R-008).** Sam gives his developer review and security sign-off on
the summary presented: no Critical or High. Residuals as ruled — the admin bypass applies always;
only `main` is protected; the check-2 shell/Jinja residual is review's; the CI shape probe is
narrow; CODEOWNERS sits without required code-owner review; merge-only, with squash and rebase
off (set 21/11/2026). Recorded at
`../../../18-TESTS/MANUAL/US010-MANUAL-TESTING.md` -> _Sam's sign-offs — 22/11/2026_, sign-off 3.

This record has had no independent peer audit; `23-pr-and-review`'s re-run is where it is read.

---

## Cross-references

- `../../THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the model whose Section 4b this answers
- `../../THREAT-MODEL/IMPLEMENTATION/THREAT-MODEL-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md` — every planned threat re-assessed
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md` — 7.1 to 7.15 closed
- `../../VULNERABILITIES/IMPLEMENTATION/` — nothing escalated
- `../../../02-STORIES/US010.md` — the story audited
- `../../../18-TESTS/MANUAL/US010-MANUAL-TESTING.md` — the fix-round records quoted
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP / NIST CSF reference
- `project-management/workflows/22-implementation-documentation/` — where this record is written
- `code/docs/SECURITY.md` — the code-side controls these findings must stay consistent with
- `code/docs/GATE-REPORTING.md` — why every unmeasured reading above says so
