# Threat Model Review — US010 The seven register indexes are born seeded

| Field           | Value                                                                                                                                                                                                                                 |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**       | US010 — The seven register indexes are born seeded, and the map index leaves the file that ships (re-cut 19/11/2026: the decisions, findings and bugs boards)                                                                         |
| **Date**        | 21/11/2026                                                                                                                                                                                                                            |
| **Verified by** | Claude Code — independent recorder (wrote none of the story's code), `security` skill, Opus, `22-implementation-documentation` Step 3                                                                                                 |
| **Plan doc**    | `../PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` (signed off 28/09/2026, corrected in place 19/11/2026 at the re-cut)                                                                                                 |
| **Outcome**     | **PASS with deferred items** — no CRITICAL or HIGH; TM-01 to TM-04 mitigated; TM-15 promoted to MEDIUM by its trigger firing; the four `GAPS.md` entries written by this gate 21/11/2026 (F-019 to F-022); seven new LOW/INFO threats |

---

## 1. Scope

The surface that shipped is the plan's as re-cut 19/11/2026: no runtime surface, three new board
seeds and their `mv` lines in the one copy-gated task beside the five 7.7.0 built, the generator
and archive tool for three more kinds, and the gates over them. **It is wider than the plan in
one place:** the commit-hook and CI enforcement of the gates themselves (the planned-red allowance,
built under Sam's D4 and removed under his Q1, and its replacement pre-push leg) became part of
TM-15's surface, and the repository's merge settings (Sam, 21/11/2026) part of TB5's. Reviewed at
`testing` `7d54df26`; evidence from CI runs `44949084218` (push, `6554cf9e`), `44949241651` and
`44949241388` (pull request 38), and `44950192371` (push to `testing`, `7d54df26`), all success.

| File                                                                                              | Purpose                                                                                                  |
| ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `copier.yml`                                                                                      | The seed task `:1138-1158` (gate `:1158`), board moves `:1148-1155`, `rmdir .copier` `:1157`; `_exclude` |
| `.copier/DECISIONS-BOARD.md` · `FINDINGS-BOARD.md` · `BUGS-BOARD.md`                              | The three new seeds, beside the five from 7.7.0                                                          |
| `.github/scripts/shipped-boards.sh` · `shipped-boards-words.sh` · `copier-commands.py`            | Checks 1 to 5 over eight boards, and the YAML reader check 1 and check 2 rest on                         |
| `.github/scripts/shipped-ai.py`                                                                   | The board update probe and its ungated-seed-task mutation                                                |
| `.github/scripts/shipped-artefacts.sh`                                                            | `SEEDED` `:123-133`                                                                                      |
| `.github/scripts/template-integrity.sh` · `lefthook.yml` · `.github/workflows/audit-template.yml` | Where each self-test runs: pre-push and the required `[n/4]` jobs                                        |
| `project-management/src/00-ASSETS/scripts/pm-board.sh` · `pm-lib.sh` · `pm-archive.sh`            | The generator, `--check` and the archive freeze                                                          |
| `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md` · `14-UPDATING.md` · `how-to/src/TEMPLATE-TOKENS.md` | The `--trust` disclosure and the TM-14 and TM-18 statements                                              |

## 2. Trust boundaries — confirmed

| ID  | Boundary                                                      | Change since plan                                                                                                                                        |
| --- | ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TB1 | In-tree registers → the `.copier/` seeds                      | **Altered:** a seed is no longer authored; it is the generator's seed-only render, and check 4 holds it byte-identical                                   |
| TB2 | The seeds → a generated project, on `copy`                    | Unchanged — eight board moves in the one `&&` chain ending `rmdir .copier`                                                                               |
| TB3 | A later template version → a project, on `update`             | Unchanged; **now measured**: the ungated mutation turns the byte-identity probe red in CI's Copier (version unrecorded, TM-N7)                           |
| TB4 | `_exclude` and its negations → the render set                 | Unchanged; the reader now decodes every entry and refuses tags, Jinja and non-`\n` line breaks                                                           |
| TB5 | The CI gates → the merge decision                             | **Altered:** self-tests run at pre-push and in required jobs on every branch; only `main` is protected; merge commits only, set 21/11/2026; admin bypass |
| TB6 | The boards → their human and agent readers                    | **Altered:** generated boards with plain status lines, never hand-edited; `--check` fails a stale one                                                    |
| TB7 | The shipped template guides → the operator granting `--trust` | Unchanged — the guides name the copy-gated task as the list                                                                                              |
| TB8 | An operator re-running generation → an existing project       | Unchanged — no guard ships; documented                                                                                                                   |

## 3. STRIDE threat re-assessment

| ID    | STRIDE | OWASP    | NIST CSF | TB  | Threat description                                                         | Severity                       | Status    | Mitigation (as shipped)                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ----- | ------ | -------- | -------- | --- | -------------------------------------------------------------------------- | ------------------------------ | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | T      | A08:2025 | PR.DS    | TB3 | An `mv` outside the copy gate stops the file being seed-once               | MEDIUM                         | Mitigated | All eight board moves inside `copier.yml:1138-1158`, gate `:1158`, no second task. Statically: check 2 binds each move to that task and reads every other task's and migration's decoded command (`shipped-boards.sh:33`; R8-2, R9-4). Behaviourally: `shipped-ai.py:320-333`, CI `44949084218` `[3/4]` "detector rejects ungated-seed-task". Section 3b's reading is now a measurement                                                     |
| TM-02 | I      | A08:2025 | PR.DS    | TB4 | A `!` negation re-including a board leaks this repository's rows           | MEDIUM                         | Mitigated | Check 1: `negation_matches` with gitignore semantics (`shipped-boards-words.sh:119`) over decoded entries (R10-2, `72357977`); string tags (F1, `4a60b1ad`) and Jinja (F2, `1d450d19`) refused. No negation in `copier.yml` names a board. CI `[2/4]`, 100 probes. The incident index's negation (`copier.yml:220`) is untouched: shape precedent only                                                                                      |
| TM-03 | I      | A08:2025 | PR.DS    | TB1 | A seed cut from a populated board is a one-way door                        | MEDIUM                         | Mitigated | Check 4: each seed byte-identical to `pm-board.sh`'s seed-only render (`shipped-boards.sh:76`); a populated board cannot pass. CI `[2/4]` "current, empty PM boards"                                                                                                                                                                                                                                                                        |
| TM-04 | T      | A08:2025 | DE.CM    | TB5 | Nothing would notice TM-01, and the obvious probe cannot fail              | MEDIUM                         | Mitigated | Every board seed changes between the fixture's tags (`shipped-ai.py:262-265`); byte-identity after `run_update` (`:270-278`); the mutation dropping `when:` is red on the byte-identity message (R6 `4119d6fa` → `6e35c080`). The probe edits boards only: the other ten seeded files share the gate it proves, not a per-file probe (TM-N6)                                                                                                |
| TM-05 | D      | A10:2025 | DE.CM    | TB5 | The fixture lacked the target folders; the easy fix weakens the chain      | LOW                            | Mitigated | The fixture's copy creates parents (`shipped-ai.py:77`); no `mkdir -p` in `copier.yml` (`git grep`); CI `[3/4]` passes both optional-skill paths                                                                                                                                                                                                                                                                                            |
| TM-06 | T      | A08:2025 | PR.PS    | TB2 | Three parsers read the `mv` line; a flag or `\|\| true` breaks or hides it | LOW                            | Mitigated | One-line form at `copier.yml:1148-1155`; check 2 requires each board move to be exactly one plain `mv` step of the decoded command (R9-4, `606f51ea`). Its promotion trigger (an `mv` gaining a flag) **did not fire**                                                                                                                                                                                                                      |
| TM-07 | D      | A10:2025 | RC.RP    | TB2 | An `mv` after `rmdir .copier` fails generation loudly                      | LOW                            | Mitigated | Every move ahead of `copier.yml:1157`, which stays `rmdir`; R9-4 requires `rmdir .copier` last                                                                                                                                                                                                                                                                                                                                              |
| TM-08 | I      | A08:2025 | PR.DS    | TB1 | One syntek-base literal in a seed ships permanently                        | LOW                            | Mitigated | Check 4 (as TM-03); the seed-row clause is subsumed — the feature-maps seed is rendered from the seeded `MAP-SCALE-PLANNING.md` by the same generator                                                                                                                                                                                                                                                                                       |
| TM-09 | S      | A06:2025 | DE.CM    | TB5 | `SEEDED` is an allowlist already read as a control                         | LOW                            | Residual  | `SEEDED` lists all eight boards (`shipped-artefacts.sh:123-133`), asserted by check 5; it stays an allowlist. The presence loop is US012's (`Pending`)                                                                                                                                                                                                                                                                                      |
| TM-10 | T      | A08:2025 | DE.CM    | TB6 | Indexes read complete with no gate                                         | LOW                            | Residual  | The window narrows: a board is regenerated and `--check` fails a stale one in required `[1/4]` (`audit-template.yml:84`). The `GAPS.md` entry stating what S-03 has left to assert was written at **this** gate 22, 21/11/2026 (F-019) (absorbed from US011, re-cut round 2 Q1) and **not yet written at `7d54df26`**                                                                                                                       |
| TM-11 | T      | A08:2025 | DE.CM    | TB6 | Three answers to "what is a row's Status"                                  | LOW                            | Mitigated | Superseded control: every ADR, finding and bug status is a plain `**Status:**` from the vocabulary in `.claude/skills/completion/SKILL.md`, prose moved to `**Status note:**`; `--check` reports no instance Unrecognised (CI `[1/4]`)                                                                                                                                                                                                      |
| TM-12 | T      | A08:2025 | PR.DS    | TB6 | The map header becomes gate-read; a status written to look finished        | LOW                            | Mitigated | Superseded by 7.7.0 (map vocabulary the completion skill's, advance tests wayfinder's); US010 writes no map status. Residual unchanged in kind: a status set in a live commit and archived later is review's (fix round 5 item 9)                                                                                                                                                                                                           |
| TM-13 | E      | A08:2025 | ID.AM    | TB7 | The `--trust` disclosure goes stale                                        | LOW                            | Mitigated | No site counts the seeded files: `04-QUICKSTART.md:21-25`, `14-UPDATING.md:39-41`, `TEMPLATE-TOKENS.md:549` name the task as the list. "The four at the bottom of `copier.yml`" counts tasks, true today (`:1138`, `:1188`, `:1195`, `:1199`), held by no gate                                                                                                                                                                              |
| TM-14 | D      | A06:2025 | ID.AM    | TB3 | A project generated before the boards gets the routes, never the files     | LOW                            | Residual  | Documented, promising no fix (`14-UPDATING.md:48-59`). Seed-if-absent migration routed to `GAPS.md` through gate 22 — written 21/11/2026 (F-020)                                                                                                                                                                                                                                                                                            |
| TM-15 | T      | A03:2025 | PR.PS    | TB5 | The change edits the gates that judge it                                   | **MEDIUM** (promoted from LOW) | Residual  | **Trigger fired** — probes edited in the commit of the check they prove: `3d136347`, `cca66558`, `0e4fde5b`, `c0de1427`, and `c641e5e7` deliberately (Section 3a below). Shipped controls: no hook runs a self-test at commit; pre-push and required CI jobs run all nine (`template-integrity.sh:87-97`); a replay command; red-first and never-weaken as review rules (`code/workflows/02-tdd-cycle/STEPS.md`). Residuals: TM-N1 to TM-N4 |
| TM-16 | I      | A02:2025 | PR.PS    | TB1 | Seeds render; in-tree boards do not                                        | INFO                           | Mitigated | CI `[1/4]` token self-test (10 probes); `[3/4]` "0 unrendered tokens" on both renders                                                                                                                                                                                                                                                                                                                                                       |
| TM-17 | R      | A09:2025 | DE.AE    | TB6 | Nothing records who changed a row                                          | INFO                           | Residual  | Accepted. Narrowed: the boards carry no `Updated` column (re-cut round 3 Q3) and are generated, so a row changes only with its record, whose git history is the trail                                                                                                                                                                                                                                                                       |
| TM-18 | T      | A08:2025 | PR.DS    | TB8 | Recopy, or copy into an existing project, hands every blank seed back      | LOW                            | Residual  | Documented, promising no fix (`14-UPDATING.md:61-65`). Guard routed to `GAPS.md` through gate 22 — written 21/11/2026 (F-021)                                                                                                                                                                                                                                                                                                               |

### 3a. Promotion triggers, read against the shipped state

| Threat       | Trigger                                                                                         | Fired?                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------ | ----------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01        | The chain split, reordered or given a second task, in a release a filled project updates across | **No.** Lines were added inside the one task; `shipped-ai.py` refuses a second seed task ("found 2", CI). No release carries US010 yet                                                                                                                                                                                                                                                                                                             |
| TM-03        | A seed refreshed from its in-tree sibling                                                       | **No** — check 4 makes it impossible to pass                                                                                                                                                                                                                                                                                                                                                                                                       |
| TM-04        | The first generated project fills an index                                                      | **Unmeasured** — no generated project is visible from this repository. The control it would demand (byte-identity, proved red) is already shipped, so a firing changes no disposition                                                                                                                                                                                                                                                              |
| TM-02        | The negation clause goes                                                                        | **No** — check 1 stands and was strengthened in rounds 6, 10 and the final pass                                                                                                                                                                                                                                                                                                                                                                    |
| TM-10        | Retired 27/09/2026 (grilling round 3 Q21)                                                       | —                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| TM-14, TM-18 | A pre-change project updates; a filled project is recopied                                      | **Unmeasured**, as TM-04                                                                                                                                                                                                                                                                                                                                                                                                                           |
| TM-06        | An `mv` line gains a flag                                                                       | **No**                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| TM-15        | A probe edited in the same commit as the check it proves                                        | **Yes, five times.** `3d136347` (R4's red taken locally, committed with its green); `cca66558` (`seed_task()` fix also edited the ungated probe); `0e4fde5b`, `c0de1427` (existing `planned-red.sh` probes, in `code/src/scripts/tests/`, removed 21/11/2026, rewritten with their check); `c641e5e7` (probes deleted with the mechanism, Sam's Q1). Adjacent, not firing: `bf6440cb`, `685f28a9`. Rounds 6 to 10 and the final pass: did not fire |

**TM-15 is read at its design state, MEDIUM**, from 21/11/2026. TM-06 shares its Section 3a row in
the plan but has its own trigger, which did not fire; it stays LOW. Fix round 3 item 6 asked for
both at MEDIUM; this record separates them because the triggers differ.

## 4. New threats identified during implementation

- **TM-N1 (LOW) — the admin bypass bounds every control** (E · A01:2025 · PR.AA · TB5). Ruleset
  `20221742`'s bypass actor (RepositoryRole 5, `always`) can merge or push past the 27 required
  checks and force-push or delete `main`. Accepted by Sam's ruling (R7-3, R7-4); stated in
  `template-integrity.sh:44-46`. Design state MEDIUM once a second principal holds admin.
- **TM-N2 (LOW) — only `main` is protected** (T · A08:2025 · PR.PS · TB5). A red or weakened tip
  reaches `dev`, `staging` or `testing` by direct push; hooks can be skipped; a commit can edit the
  workflow or `SELF_TESTS` that judges it. CI on the tip is the record.
- **TM-N3 (LOW) — check 2 reads literal words only** (T · A08:2025 · DE.CM · TB3). A seed name built
  at run time, or Jinja in a command, is review's alone (R8-2, R9-1). The behavioural probe still
  catches an ungated board move.
- **TM-N4 (LOW) — the CI shape probe is narrow** (T · A03:2025 · DE.CM · TB5). It misses a quoted
  `if:`, a `shell:` or `defaults:` override, `needs:` on a skipped job and a second shallow checkout
  (R8-4). Workflow diffs are review's.
- **TM-N5 (LOW) — merge settings live outside the tree** (T · A08:2025 · PR.PS · TB5). Merge-only
  and squash/rebase off (set 21/11/2026) are what keep a squash from locking `--check`; nothing in
  CI re-reads them, so a settings change silently re-opens it. "Update with rebase" unmeasured.
- **TM-N6 (INFO) — the memory seed's blind case persists** (T · A08:2025 · DE.CM · TB3).
  `shipped-ai.py:258-259` changes the template's memory, never `.copier/MEMORY.md`; the board probe
  proves the shared gate, not each file. Plan Section 3b's pre-existing case, routed to `GAPS.md`.
- **TM-N7 (INFO) — CI's Copier is unpinned and unnamed** (T · A03:2025 · ID.AM · TB3).
  `shipped-ai.sh:35` runs `uvx --offline --from copier`; the version is not printed, so the 3b
  measurement is of an unnamed release.

None is CRITICAL or HIGH; nothing is escalated to `../../VULNERABILITIES/IMPLEMENTATION/`.

## 5. Residual & deferred items

| Item                                                                 | Threat IDs            | Severity     | Tracked in / when                                                   |
| -------------------------------------------------------------------- | --------------------- | ------------ | ------------------------------------------------------------------- |
| What S-03 has left to assert once the boards are gated               | TM-10                 | LOW          | `GAPS.md`, this gate 22 — written 21/11/2026 (F-019)                |
| Seed-if-absent update migration for a pre-change project             | TM-14                 | LOW          | `GAPS.md`, this gate 22 — written 21/11/2026 (F-020)                |
| A guard refusing an existing target on recopy / copy-over            | TM-18                 | LOW          | `GAPS.md`, this gate 22 — written 21/11/2026 (F-021)                |
| The memory-survival probe's blind case                               | TM-N6                 | INFO         | `GAPS.md`, this gate 22 — written 21/11/2026 (F-022)                |
| `SEEDED`'s presence loop and deletion probe                          | TM-09                 | LOW          | US012 (`../../../02-STORIES/US012.md`, `Pending`)                   |
| The 72-case generation matrix                                        | TM-01, TM-04          | —            | `../../../01-FEATURE-MAPS/MAP-GENERATION-COVERAGE.md` S-01, uncut   |
| Gates bending to pass their own change; bypass; unprotected branches | TM-15, TM-N1 to TM-N5 | MEDIUM / LOW | This record; review rules in `code/workflows/02-tdd-cycle/STEPS.md` |
| CI Copier version, actionlint                                        | TM-N7                 | INFO         | This record, unmeasured                                             |

## 6. Sign-off

| Reviewer                             | Role                          | Date       |
| ------------------------------------ | ----------------------------- | ---------- |
| Claude Code — `security` skill, Opus | Independent recorder, gate 22 | 21/11/2026 |
| Sam                                  | Developer — review owed       | —          |

**Overall verdict:** no CRITICAL or HIGH was planned, built or found; the four MEDIUM integrity
threats are mitigated by shipped, CI-green controls, and TM-15's promotion and the seven new
threats are known, tracked residuals, not regressions — with the four `GAPS.md` entries this
gate owed written 21/11/2026 (F-019 to F-022).

<!-- Corrected 22/11/2026 (gate-23 return R-005): the verdict read "subject to the four `GAPS.md`
     entries this gate still owes", a residual from before Step 5; the Outcome row already records
     them written 21/11/2026. -->

---

## Cross-references

- `../PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the model re-assessed here (frozen; this record is additive)
- `../../AUDITS/IMPLEMENTATION/AUDIT-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md` — F-001 to F-011, the same residuals as audit findings
- `../../ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US010-SEEDED-REGISTER-INDEXES-21-11-2026.md` — the posture assessment that consumes this review
- `../../VULNERABILITIES/IMPLEMENTATION/` — nothing escalated
- `../../../02-STORIES/US010.md` — the story reviewed, its re-cut and Security Acceptance Criteria
- `../../../18-TESTS/MANUAL/US010-MANUAL-TESTING.md` — the TM-15 firings and fix-round records
- `../../../15-DECISIONS/ADR-US010-REGISTER-INDEXES-ARE-GENERATED-BOARDS-19-11-2026.md` — the re-cut decision
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `code/docs/SECURITY.md` — the code-side enforcement these claims must stay consistent with
