# Security Posture Assessment (Plan) — US009 The git hooks arm on purpose at install

| Field          | Value                                                                                                   |
| -------------- | ------------------------------------------------------------------------------------------------------- |
| **Story**      | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true |
| **Date**       | 17/09/2026                                                                                              |
| **Author**     | Claude Code — `security` skill, Opus · reviewed by <%DEVELOPER_NAME%>                                   |
| **Sprint**     | SPRINT-05 — this story is its stretch `Should`, 5 of 13 SP                                              |
| **Status**     | Signed off · **corrected in place 28/09/2026** — see below                                              |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10, 2025) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC)                                |

> This assessment establishes the security **baseline** for the story before any code is
> written. It synthesises the story's STRIDE threat model and maps overall posture against
> OWASP Top 10 and NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or
> HIGH finding — those are release blockers.

<!-- STEP 1's GRILLING PASS DID NOT RUN. <%DEVELOPER_NAME%> directed on 17/09/2026 that gates 10
     and 11 be written for both SPRINT-05 members first and the decisions taken afterwards. This
     baseline reports what was measured in the tree on 17/09/2026 and names, in Section 8, the
     three questions it could not settle — the first of which the story does not currently ask.
     Status is Draft. code/docs/GATE-REPORTING.md. -->

<!-- AMENDED 28/09/2026 at sign-off. The three Section 8 questions the comment above calls
     unsettled were settled at `15-decisions` on 17/09/2026: Q1 by
     project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md,
     Q2 as an acceptance criterion, Q3 as ST07. The story now asks Q1 itself, under its Decisions
     section. Status read "Draft" and the Author row "not yet reviewed by <%DEVELOPER_NAME%>"
     until today. Read the comment above as the record of 17/09/2026. -->

> **Corrected in place, 28/09/2026, at sign-off.** <%DEVELOPER_NAME%> signed this baseline off at
> `16-sprint-plans`, with its stale text corrected in place rather than superseded (settled
> 28/09/2026, 16-sprint-plans grilling round 1 Q1 and round 2 Q5). It was written on 17/09/2026.
> `15-decisions` settled the three Section 8 questions that day, and `17-story-plans` settled three
> more choices Section 7 offered on 18/09/2026. What moved:
>
> - **Section 1** described the story "as specified", meaning as it stood on 17/09/2026. It is now
>   dated, and closes on what was settled.
> - **Section 2's Decisions row** read "None". The story has carried one ADR since 17/09/2026.
> - **Section 6** said `11-qa-checks` carries TM-01 as a blocking gap. AC-GAP-1 was resolved on
>   17/09/2026.
> - **Section 7** opened "Eleven constraints" over a list of fourteen, and mapped `ST06` to 7.14
>   although `ST06` has been retired. Each constraint whose either/or has since been chosen (7.1,
>   7.3, 7.5, 7.9, 7.10 and 7.11) now says where. 7.2 now says its register entry is owed, not
>   written.
> - **Section 8** said three questions are open. All three were settled on 17/09/2026.
>
> Corrected rather than superseded because no finding, severity or constraint moved: twelve
> findings, **0 CRITICAL, 0 HIGH, 7 MEDIUM, 4 LOW, 1 INFO**, before and after, and fourteen
> constraints. **The tables in Sections 4 to 6 stay the baseline of 17/09/2026.** Each note there
> names a finding against the story as it then stood, and Section 7 carries the settlement. Only
> Section 6's closing paragraph is re-tensed, because it said AC-GAP-1 was still open. Each
> superseded wording is kept in a dated comment beside its correction.
>
> **Re-measured 30/09/2026, before the sign-off was committed.** Every `path:line` citation into
> this repository was re-measured against the tree committed together with the 18-TESTS split,
> one commit (settled 30/09/2026, 16-sprint-plans grilling round 4 Q13 and Q14), with this gate's
> corrections applied. Three had moved, the text unchanged in each. Two moved by `f045aac`
> (18/09/2026): `.copier/README.md:441` is now `:442`, and `lefthook.yml:66-69` is now `:73-76`.
> The third moves with the split, which adds 21 lines to `copier.yml` above its `git init` task:
> 7.11's `copier.yml:1025` is now `:1046`. Each is re-pointed where it is cited, the number it
> replaces kept in a dated comment; every other citation still locates its text. The same day 7.6
> records the criterion US009 gained for it, `ST08` (settled 30/09/2026, 16-sprint-plans grilling
> round 3 Q11), and Section 7's opening maps it. 7.2 dates the owed
> register entry the day it is written, never backdated, and Section 6's constraint references
> lose the section sign, a writing-convention fix that moves no finding. 7.5's settlement and
> Section 8's Q2 sentence are scoped to Phase 1: under `install.sh --full` the hard fail still
> stops Phase 2. That scoping is a call made 30/09/2026 while applying round 3, not one of its
> answers, the same call as the threat model's Section 4a; <%DEVELOPER_NAME%> reviewed it with
> every other change made under the gate-10 and gate-11 signatures and accepted it (settled
> 30/09/2026, 16-sprint-plans grilling round 5 Q16).

---

<!-- 20/09/2026: this header read "3 of 11 SP" from 17/09/2026 until today. The story was
     re-estimated 3 -> 5 SP at `15-decisions` on 17/09/2026 and SPRINT-05 recomputed to 13 / 11 at
     grace the same day; the two figures here were not carried across.
     `../../../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` already recorded the divergence as
     known; this is the repair it was waiting for. Surfaced by an independent QA pass at
     `03-sprint-planning` while opening SPRINT-06 and SPRINT-07. -->

## 1. Summary

**As written on 17/09/2026, the story was right about the defect and incomplete about the fix.**
`.copier/README.md:442` promises that `install.sh` "runs `lefthook install`"; it does not, and
US009 makes the claim true. That half is sound and cheaply verified. Twelve findings were raised
across five STRIDE categories: **0 CRITICAL, 0 HIGH, 7 MEDIUM, 4 LOW, 1 INFO**. Nothing gates
sprint planning and no vulnerability record is written.

**The principal finding was that the story's own user story was not delivered by the change it
then specified.** US009 asks for hooks that never arm "at a moment I did not choose", and ST02, as
then written, kept `package.json:11`'s `prepare` script byte-identical. `--ignore-scripts`
suppresses that script on the three `install-frontend.sh` lines the story asserts — and on **no
others**. A repo-wide sweep on 17/09/2026 found **eleven** further `pnpm install` invocations
without it: one in `.claude/hooks/lib/check-lockfiles.sh:147`, which fires when a pull request is
raised, and ten across five GitHub workflow files. Each runs `prepare`, and `prepare` runs
`lefthook install`. **The evidence is in the working tree**: `.git/hooks/pre-commit` exists on
this machine, is lefthook's, dated 16/09/2026, in a repository whose `install.sh` has never
written it. Had US009 shipped as then specified, that path would still have been open (TM-01,
threat model Section 3b).

**A second finding is about what `--ignore-scripts` is claimed to be.** `N-019` calls it "a
deliberate supply-chain control" and ST01 asserts it on three lines, in wording that reads as a
posture. It is not a posture — it is three lines, and the same lockfile installs eleven times
without it, on CI runners holding workflow secrets and on the developer's own host. That gap is
**pre-existing and outside US009's scope**, and it is recorded here rather than escalated
precisely so that a story asserting three lines of it is not read as having covered all sixteen
(TM-02).

**Three smaller findings were concrete defects in the step as specified on 17/09/2026**, and each
was cheap to fix before it was written rather than after: the `.git` guard is false in a git
worktree, which is how this project runs parallel story work (TM-03); `lefthook` is **not on
`PATH`** and the resolution mechanism was unspecified, where the house idiom at 23 sites is
`pnpm exec` (TM-04); and a hard fail at the new step abandons the four later Phase 1 steps that
create `.env.*`, the dev secrets, the executable bits and the machine spec (TM-05).

**All four were settled on 17/09/2026, before this baseline was signed off.** TM-01 by
`project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`:
`prepare` is removed, a `postinstall` announces the unarmed state and arms nothing, and the story
was re-estimated 3 to 5 SP. TM-03 by `ST07`'s `git rev-parse --git-dir`, TM-04 by `ST03`'s
`pnpm exec lefthook install`, and TM-05 by moving the step to the end of Phase 1 with the hard fail
kept. TM-02 is not closed, and its register entry is owed (7.2). Section 8 records each settlement.

<!-- AMENDED 28/09/2026 at sign-off. Section 1 is the baseline of 17/09/2026; only the tense of
     its claims about the story moved. Read "The story is right about the defect and incomplete
     about the fix", "The principal finding is that the story's own user story is not delivered
     by the story's own change", "ST02 keeps", "After US009 ships as specified, that path is still
     open", "Three smaller findings are concrete defects in the step as specified, and each is
     cheap to fix before it is written" and "the resolution mechanism is unspecified" until then.
     The "All four were settled" paragraph is new today. -->

<!-- AMENDED 30/09/2026: the opening paragraph cited `.copier/README.md:441` until then, the
     17/09/2026 reading. f045aac (18/09/2026) moved the sentence to :442, re-measured 30/09/2026;
     the text is unchanged. -->

## 2. Scope

| Dimension  | Coverage                                                                                                                                                                                                                                                   |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Story      | US009 — one new `install.sh` step, one guard, three read-only assertions, two probes. Since 17/09/2026 also `package.json`'s `prepare` removed and an announcing `postinstall` added, with a worktree probe and a `postinstall` probe beside the first two |
| User flow  | **None** — the story adds no screen, route or journey                                                                                                                                                                                                      |
| Wireframe  | **None**, and none is possible — the surface is bash                                                                                                                                                                                                       |
| Schema     | **None** — no model, no migration, no PII. `Backend` and `GDPR` both read `N/A`                                                                                                                                                                            |
| Decisions  | **One** — `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`, Accepted 17/09/2026. `N-019` (settled 27/08/2026 on the map) and the `S-11` slice split still earn no record                                      |
| Frameworks | STRIDE · OWASP Top 10 (2025) · NIST CSF 2.0                                                                                                                                                                                                                |

<!-- AMENDED 28/09/2026 at sign-off. The Decisions row read "**None.** The story states so
     explicitly: `N-019` was settled 27/08/2026 on the map, and the `S-11` slice split is a
     charting act" until then. The story's own Decisions section changed at `15-decisions` on
     17/09/2026, when the question of whether `prepare` survives earned the ADR. The Story row
     ended at "two probes" until then; the sentence after it is new today and removes nothing. -->

**Deviation, stated rather than silently absent.** `10-security-checks` Step 1 reviews user flows
and wireframes. This story has neither and can have neither. The trust boundaries were derived
from the install script, the pnpm lifecycle and the git hook directory instead. **A second
deviation** is the missing grilling pass — see the header.

**Why this story has a Security flag at all, restated because it is unusual.**
`project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md:464-466` declares eight flags `N/A` map-wide and the `S-03` row leaves
Security absent rather than `N/A`. The story fills it anyway, on the
`project-management/src/02-STORIES/US006.md:15-22` precedent:
_"a manifest written for one kind of slice must not skip the only gate able to check what the
story actually ships. QA proves the states it was told to prove; Security asks whether the state
list is right."_ **That reasoning is vindicated here.** The three largest findings below — TM-01,
TM-02 and TM-03 — are all outside the state list the story gave QA, and none would have surfaced
from `11-qa-checks` alone.

## 3. Threat models referenced

- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md`
  — 12 findings, 6 trust boundaries (TB1 operator shell↔`install.sh` · TB2 `install.sh`↔the
  lefthook binary · TB3 the pnpm lifecycle↔`.git/hooks/` · TB4 `install.sh`↔`.git/hooks/pre-commit`
  · TB5 template↔generated project · TB6 the npm dependency graph↔the host)

Its trust boundaries and severities are adopted here unchanged.

## 4. OWASP Top 10 — baseline coverage

_The tables in Sections 4 to 6 are the baseline of 17/09/2026, and only Section 6's closing
paragraph is re-tensed. Each note names a finding against the story as it then stood. Where the
story has since chosen, Section 7 records the choice, and no status here moves until the
implementation assessment closes the constraint with evidence._

| ID       | Category                              | Status    | Notes (open findings, controls relied on)                                                                                                                                  |
| -------- | ------------------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | Partial   | TM-06 — the new step runs immediately downstream of `install-frontend.sh:79-81`, a live `sudo rm -rf` with two unvalidated arguments, and asserts against that same file   |
| A02:2025 | Security Misconfiguration             | Partial   | TM-10 — `usage()` numbers Phase 2 as steps 7 and 8, colliding with Phase 1's own 7 and 8; the story's renumbering task names only Phase 1                                  |
| A03:2025 | Software Supply Chain Failures        | **Open**  | **The dominant category, and the story's own subject.** TM-01, TM-02, TM-04, TM-08, TM-11 — the lifecycle channel, the eleven unsuppressed installs, the unresolved binary |
| A04:2025 | Cryptographic Failures                | N/A       | No secret, key or credential is read, written or compared by the new step                                                                                                  |
| A05:2025 | Injection                             | N/A       | No user-supplied value reaches a shell expansion the story introduces                                                                                                      |
| A06:2025 | Insecure Design                       | Addressed | The design — an explicit, reported step rather than a lifecycle side-effect — is right, and `N-019` rejected a copier `_task` for a stated reason. No finding of its own   |
| A07:2025 | Authentication Failures               | N/A       | No principal is authenticated; a setup script has no session                                                                                                               |
| A08:2025 | Software and Data Integrity Failures  | Partial   | TM-07 — `lefthook install` overwrites `.git/hooks/pre-commit` unconditionally, and `lefthook.yml:73-76` records a second tool that writes there                            |
| A09:2025 | Security Logging & Alerting Failures  | **Open**  | TM-12 — nothing persists whether the hooks were armed for a given commit. Accepted residual                                                                                |
| A10:2025 | Mishandling of Exceptional Conditions | Partial   | TM-03, TM-05, TM-09 — a guard false in a worktree, a hard fail that abandons four steps, and a proof specified into a job that cannot run it                               |

<!-- AMENDED 30/09/2026: the A08 note cited `lefthook.yml:66-69` until then, the 17/09/2026
     reading. f045aac (18/09/2026) moved the four lines to :73-76, re-measured 30/09/2026; the text
     is unchanged, and no status in the table moved. -->

## 5. NIST CSF 2.0 — function summary

| Fn  | Function | Design-stage posture                                                                                                                                                     |
| --- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| GV  | Govern   | **Improved by this story.** A shipped instruction currently describes behaviour that does not exist; after this it describes behaviour that does                         |
| ID  | Identify | **Strong, and the strongest part of this gate.** The arming channel was located rather than assumed — eleven invocations enumerated, and the live hook file as evidence  |
| PR  | Protect  | **Partial.** The explicit step protects the _absence_; TM-01 leaves the _silence_ unprotected, and TM-02 shows the supply-chain control is narrower than it reads        |
| DE  | Detect   | **Weak.** Nothing detects that a hook is absent, that it was replaced, or that a commit was made without one. The step reports at install time and nothing watches after |
| RS  | Respond  | Adequate for what it is: a failure is reported in the house `err` idiom at exit 2, which is greppable and matches the script's declared code                             |
| RC  | Recover  | **Open until TM-05 lands.** A failed hook step as specified abandons four setup steps, and the recovery is re-running the whole install — which is not stated anywhere   |

## 6. Findings

Grouped by severity. All twelve are carried from the threat model unchanged; see it for the full
mitigation text and the promotion triggers.

| ID    | STRIDE | OWASP | NIST  | TB  | Threat Description                                                      | Severity | Planned Mitigation                                                 |
| ----- | ------ | ----- | ----- | --- | ----------------------------------------------------------------------- | -------- | ------------------------------------------------------------------ |
| TM-01 | T      | A03   | PR.PS | TB3 | The silent-arming channel stays open through 11 unsuppressed installs   | MEDIUM   | Settle `prepare`'s fate, or state the precedence (Section 7.1)     |
| TM-02 | E      | A03   | PR.PS | TB6 | `--ignore-scripts` is three lines, asserted as though it were a posture | MEDIUM   | Narrow ST01's wording; raise the wider gap (Section 7.2)           |
| TM-03 | D      | A10   | PR.PS | TB1 | `[ -d .git ]` is false in a worktree — every parallel-story checkout    | MEDIUM   | Test for a repository, not a directory (Section 7.3)               |
| TM-04 | S      | A03   | PR.PS | TB2 | `lefthook` is not on `PATH`; resolution is unspecified                  | MEDIUM   | `pnpm exec lefthook install` — the house idiom (Section 7.4)       |
| TM-05 | D      | A10   | RC.RP | TB1 | A hard fail abandons four later Phase 1 steps                           | MEDIUM   | Move the step, or justify the abandonment (Section 7.5)            |
| TM-06 | E      | A01   | PR.PS | TB1 | The step sits downstream of a live `sudo rm -rf` with stray arguments   | MEDIUM   | Make "neither depends on nor masks it" a criterion (Section 7.6)   |
| TM-09 | D      | A10   | DE.CM | TB5 | The automated proof is specified into a job that cannot run it          | MEDIUM   | Grep in the generation job; execution gets its own (Section 7.9)   |
| TM-07 | T      | A08   | PR.DS | TB4 | `.git/hooks/pre-commit` is overwritten unconditionally, in silence      | LOW      | The step reports what it wrote and replaced (Section 7.7)          |
| TM-08 | T      | A03   | PR.PS | TB2 | The "pinned" devDependency is a caret range Step 4 may move             | LOW      | Correct ST03's wording: the lockfile pins (Section 7.8)            |
| TM-10 | T      | A02   | PR.PS | TB1 | `usage()`'s Phase 2 steps 7–8 collide with Phase 1's 7–8                | LOW      | Renumbering names Phase 2, or leaves it and says so (Section 7.10) |
| TM-11 | S      | A03   | PR.PS | TB5 | A generated project's `.git` has no commits; the case is untested       | LOW      | Cover it, or record the assumption (Section 7.11)                  |
| TM-12 | R      | A09   | DE.AE | TB4 | Nothing records whether the hooks were armed for a commit               | INFO     | Accepted residual, named rather than assumed                       |

<!-- AMENDED 30/09/2026: until then each constraint reference in the table above was written with
     the section sign, which `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 2
     bans; each now reads "Section 7.n". A writing-convention fix: no finding, severity or planned
     mitigation moved, and the table stays the baseline of 17/09/2026. -->

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/PLANNING/`, and that
absence is a recorded outcome rather than an unrun check — see Section 1 and the threat model's
Section 3a for what promotes it. **TM-01's severity is not its importance**: it is a `MEDIUM`
because there is no adversary and one developer, and it is the most consequential row in the
table because it showed the story, as first written, did not achieve its stated goal.
`11-qa-checks` carried it as blocking AC-GAP-1, which is the correct instrument for a scope
defect, and AC-GAP-1 was resolved 17/09/2026 by
`project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`.

<!-- AMENDED 28/09/2026 at sign-off: read "because it says the story does not achieve its stated
     goal. `11-qa-checks` carries it as a blocking acceptance-criteria gap, which is the correct
     instrument for a scope defect" until then. AC-GAP-1 reads [RESOLVED] 17/09/2026 in
     project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md. -->

## 7. Security tasks & open gaps

Fourteen constraints, each checkable by reading the shipped script. Each becomes a US009
acceptance criterion; the implementation assessment closes it with evidence. **The story's
US009/ST01–ST08 and ST02b are absorbed rather than replaced** — `ST01` becomes 7.2, `ST02` and
`ST02b` are subsumed by 7.1, `ST03` by 7.4 and 7.8, `ST04` stands as 7.12, `ST05` as 7.13,
`ST07` carries 7.3 and 7.14, and `ST08`, added 30/09/2026, carries 7.6. `ST06` stood as 7.14
until it was retired on 17/09/2026.

<!-- AMENDED 28/09/2026 at sign-off: read "Eleven constraints" and "The story's existing
     US009/ST01–ST06 are absorbed rather than replaced — ... `ST05` as 7.13, `ST06` as 7.14" until
     then. The count covered 7.1 to 7.11, the eleven drawn from TM-01 to TM-11, and did not move
     when 7.12 to 7.14 were carried from the story; the closing line already read "None of the
     fourteen". The mapping predates `15-decisions`, which inverted ST02, added ST02b, retired ST06
     and added ST07. project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md
     named the count as a divergence owned by `10-security-checks`. On 30/09/2026 US009 gained
     ST08 for 7.6 (settled 30/09/2026, 16-sprint-plans grilling round 3 Q11), and the mapping above
     names it; the count stays fourteen. -->

- [ ] **7.1** **`package.json:11`'s `prepare` script is settled, not merely preserved.** Either it
      is removed as redundant now that an explicit step exists, or the story states which of the
      two arming owners wins, why both are kept, and what happens when they disagree. ST02's
      "byte-identical" is a _non-decision_ about the channel the story exists to close
      (A03, TM-01). **Settled 17/09/2026 at `15-decisions`: removed** —
      `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`,
      Option C. `install.sh` is the sole arming path, and a `postinstall` that announces the
      unarmed state and arms nothing closes the silent-absence cost (`ST02`, inverted, and
      `ST02b`)
- [ ] **7.2** `--ignore-scripts` remains on `install-frontend.sh:67`, `:84` and `:93` — asserted,
      not assumed — **and the assertion states its scope**: three lines in one script, not a
      repo-wide posture. The eleven unsuppressed invocations are raised as their own register
      entry rather than left to be read as covered (A03, TM-02). **The first limb was settled on
      17/09/2026:** `ST01` now says it proves three invocations of sixteen (AC-GAP-3). **The
      register entry is owed, not written:** `GAPS.md` holds no row for the eleven (measured
      28/09/2026, and again 30/09/2026). Opening it is a task on US009's
      `22-implementation-documentation` pass (settled 28/09/2026, 16-sprint-plans grilling round 2
      Q6), dated the day it is written and citing the 17/09/2026 claim of
      `project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md`
      as the date it was owed from — never backdated to it
- [ ] **7.3** The guard tests for a **git repository**, not for a directory. A `git worktree add`
      checkout has `.git` as a **file**, so `[ -d .git ]` skips there — in exactly the checkouts
      `how-to/workflows/02-worktree-setup/` tells this project to create for parallel story work
      (A10, TM-03). **Settled 17/09/2026 at `15-decisions`: `git rev-parse --git-dir`** (`ST07`)
- [ ] **7.4** The binary is resolved from the project's own `node_modules` by the house `pnpm exec`
      idiom — used at 23 sites in this repository — and **never** from `PATH`. Measured
      17/09/2026: `lefthook` is not on `PATH`; `node_modules/.bin/lefthook` exists (A03, TM-04)
- [ ] **7.5** The step's **position** is justified against its failure mode. Inserted after Step 4
      and exiting 2, a transient failure abandons Steps 5–8: `.env.*` files, generated dev secrets,
      script executable bits and the machine spec. Either it moves to the end of Phase 1, where
      hard-fail is cheap, or the abandonment is accepted in writing (A10, TM-05). **Settled
      17/09/2026 at `15-decisions`: it moves to the end of Phase 1 and the hard fail is kept**,
      which then abandons no Phase 1 step; under `install.sh --full` it still stops Phase 2, the
      Docker dev-stack build and the migrations (`install.sh:540`, `:580`), before either runs (the
      story's first scenario and Script Tasks; AC-GAP-5; the Phase 2 clause accepted 30/09/2026,
      16-sprint-plans grilling round 5 Q16)
- [ ] **7.6** The three `--ignore-scripts` assertions **neither depend on nor mask**
      `install-frontend.sh:79-81`'s live `sudo rm -rf "$PROJECT_ROOT/node_modules" log Removed.` —
      and this is a **criterion**, not a sentence in the Dependencies section. `:84` sits inside
      that block, so a QA pass reading the asserted lines walks past the defect (A01, TM-06).
      **Carried 30/09/2026 as `ST08`** (settled 30/09/2026, 16-sprint-plans grilling round 3 Q11)
- [ ] **7.7** The step **reports what it wrote** into `.git/hooks/` and what it replaced, rather
      than overwriting in silence. `install.sh` writes nothing under `.git/` today, and
      `lefthook.yml:73-76` records `code-review-graph install` appending its own hook to the same
      file (A08, TM-07)
- [ ] **7.8** ST03's wording is corrected: `package.json:22` is `"^2.1.10"`, a **range**;
      `pnpm-lock.yaml:54-56` is what pins `2.1.10`. `install-frontend.sh:84` is plain
      `pnpm install`, not `--frozen-lockfile`, so Step 4 may resolve higher and Step 5 then arms
      with whatever it resolved (A03, TM-08)
- [ ] **7.9** The generation job's criterion is what it can actually do — **assert the step is
      present** in the generated `install.sh` on both answer sets. Executing `install.sh` needs
      docker, uv, pnpm and `sudo tee -a /etc/hosts`, which `audit-template.yml:151-163` does not
      provide; a probe that runs it needs its own job, or the criterion is honest about being
      manual (A10, TM-09). **Settled 18/09/2026 at `17-story-plans`: its own job.** The generation
      job keeps only the grep, and a new workflow job runs the probe against the arming logic
      extracted from `install.sh`
      (`project-management/src/17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`, Key Decision 1)
- [ ] **7.10** The renumbering names **Phase 2 as well as Phase 1**, or explicitly leaves the
      pre-existing collision and says so. Measured: `usage()` lists Phase 1 as steps 1–8
      (`:47-54`) and Phase 2 as 7 and 8 (`:57-58`), and the body headers agree (`:540`, `:580`)
      (A02, TM-10). **Settled 18/09/2026 at `17-story-plans`: Phase 2 is renumbered to steps 10
      and 11** (the story plan's Key Decision 2)
- [ ] **7.11** The generated-project case is covered or the assumption is written down:
      `copier.yml:1046` runs `git init` gated to `copy`, so `.git` exists with an **unborn HEAD**,
      and `lefthook install` succeeding against that is currently assumed (A03, TM-11).
      **Settled 18/09/2026 at `17-story-plans`: covered by a probe**, not an assumption (the story
      plan's Key Decision 3)
- [ ] **7.12** The step runs **after** dependency installation, so it can never arm a hook
      referencing a toolchain not yet present — the failure mode `N-019` rejects a copier `_task`
      for (`project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md:241-244`). _(Carried from
      US009/ST04, unchanged.)_
- [ ] **7.13** The step introduces no new network fetch, no new credential read, and no new write
      outside `.git/hooks/`. _(Carried from US009/ST05, unchanged.)_
- [ ] **7.14** The `.git` guard tests for a repository and nothing else; it does not become a
      general try/ignore that would hide a real failure. _(Carried from US009/ST06, and note
      that 7.3 changes **how** the test is written while this keeps **what** it may cover.)_
      `ST06` was retired on 17/09/2026, and this constraint is now carried by `ST07`

<!-- AMENDED 30/09/2026. 7.6 read "... walks past the defect (A01, TM-06)" and ended there until
     then; the bold clause after it is new, and every word before it is the 17/09/2026 text. 7.7
     cited `lefthook.yml:66-69` until then, the 17/09/2026 reading. f045aac (18/09/2026) moved the
     four lines to :73-76, re-measured 30/09/2026; the text is unchanged. 7.11 cited
     `copier.yml:1025` until then, which located the `git init` task at a18db0b. The 18-TESTS
     split, committed with this correction, adds 21 lines above it and moves it to :1046; the text
     is unchanged. -->

**None of the fourteen is a sprint-planning blocker** — no CRITICAL or HIGH was raised. They are
design-stage constraints that must land with the code. **7.1 was the one to read first**: it was
the only constraint that could change the story's scope and therefore its 3 SP estimate, and on
17/09/2026 the story did not ask it. It changed both: settled that day by the ADR, with the story
re-estimated 3 to 5 SP and the question now answered under its Decisions section.

<!-- AMENDED 28/09/2026 at sign-off: read "7.1 is the one to read first: it is the only
     constraint that may change the story's scope and therefore its 3 SP estimate, and it is the
     one question the story does not currently ask itself" until then. -->

## 8. What this assessment could not settle

<!-- SETTLED 17/09/2026 at `15-decisions`; recorded here 28/09/2026 at sign-off. Unlike the
     threat model's Section 4a, this section was never given its settled note, so until today it
     still read as three open questions. The questions are kept as written, each with its answer
     beneath, because a question deleted once answered leaves the next reader unable to see what
     was weighed. The opening line read "The grilling pass did not run. Three questions are open
     and each changes a criterion" until then. -->

**All three are settled.** Q1 by
`project-management/src/15-DECISIONS/ADR-US009-INSTALL-IS-THE-SOLE-ARMING-PATH-17-09-2026.md` —
`prepare` is removed, `install.sh` becomes the sole arming path, and an announcing `postinstall`
closes the silent-absence cost; the story is re-estimated 3 to 5 SP. Q2 as an acceptance
criterion — the step moves to the **end of Phase 1**, keeping the hard fail, which then abandons
no Phase 1 step because none follows it in Phase 1; under `install.sh --full` it still stops
Phase 2, the Docker dev-stack build and the migrations (`install.sh:540`, `:580`), before either
runs (that Phase 2 clause accepted 30/09/2026, 16-sprint-plans grilling round 5 Q16). Q3 as
`ST07` — the guard is `git rev-parse --git-dir`.

The grilling pass did not run at the time. Three questions were open, and each changed a
criterion:

1. **Does `prepare` survive?** (7.1) Keeping it leaves the channel open and the user story
   unmet; removing it is a larger change than 3 SP assumes. **Not currently a question in the
   story.** **SETTLED 17/09/2026 at `15-decisions`: it does not survive** — the story now asks
   and answers the question under its Decisions section.
2. **Where does the step sit, and does it hard-fail?** (7.5) The story names this as the criterion
   to change if `15-decisions` disagrees; TM-05 adds that the _position_ decides how expensive the
   answer is. **SETTLED 17/09/2026 at `15-decisions`: last in Phase 1, and the hard fail is
   kept.**
3. **What shape is the `.git` guard?** (7.3) **SETTLED 17/09/2026 at `15-decisions`:
   `git rev-parse --git-dir`** (`ST07`).

Recorded here rather than resolved, because a gate that invents an answer to a question it never
asked is worse than one that says it did not ask.

---

## Cross-references

- `project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record that verifies this baseline
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` — the STRIDE model this assessment synthesises, and its Section 3b
- `project-management/src/10-SECURITY/AUDITS/PLANNING/` · `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — the sibling code audit and the escalated findings; this story writes to neither, and Section 6 states why
- `project-management/src/02-STORIES/US009.md` — the story being assessed, whose `ST01`–`ST08` and `ST02b` Section 7 absorbs (`ST06` retired 17/09/2026)
- `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md` — the QA plan that exercises these constraints
- `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` — `N-019`, which settled that the step exists but not its failure mode
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP Top 10 (2025), and NIST CSF 2.0 standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` — the code-side enforcement these targets must stay consistent with
- `code/docs/GATE-REPORTING.md` — why the zero in Section 6, the missing grilling pass, and Section 8 are stated rather than left implied

<!-- AMENDED 28/09/2026 at sign-off: the US009 entry above read "whose `ST01`–`ST06` Section 7
     absorbs" until then. `15-decisions` added ST02b and ST07 and retired ST06 on 17/09/2026, and
     ST08 was added on 30/09/2026 (16-sprint-plans grilling round 3 Q11). -->
