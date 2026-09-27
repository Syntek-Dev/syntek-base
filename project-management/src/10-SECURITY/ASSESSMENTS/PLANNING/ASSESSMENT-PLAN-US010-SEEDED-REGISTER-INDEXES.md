# Security Posture Assessment (Plan) — US010 The seven register indexes are born seeded

| Field          | Value                                                                                                                                                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**      | US010 — The seven register indexes are born seeded, and the map index leaves the file that ships                                                                                                                  |
| **Date**       | 21/09/2026                                                                                                                                                                                                        |
| **Author**     | Claude Code — `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**                                                                                                                                 |
| **Sprint**     | SPRINT-06 — this story is its sole member, 8 of 11 SP, holding a 5 SP reservation for US009's carry (13 / 11 SP at grace if it lands; `project-management/src/03-SPRINTS/SPRINT-06.md:30-34`, as read 21/09/2026) |
| **Status**     | Draft                                                                                                                                                                                                             |
| **Frameworks** | STRIDE · OWASP Top 10 (A01–A10, 2025) · NIST CSF 2.0 (GV/ID/PR/DE/RS/RC)                                                                                                                                          |

> This assessment establishes the security **baseline** for the story before any code is
> written. It synthesises the story's STRIDE threat model and maps overall posture against
> OWASP Top 10 and NIST CSF 2.0. No sprint slice may proceed with an unresolved CRITICAL or
> HIGH finding — those are release blockers.

<!-- STEP 1's GRILLING PASS RAN on 21/09/2026 — two rounds with <%DEVELOPER_NAME%>, frontier empty.
     This baseline cites its answers as settled and re-opens none; the threat model's Section 4a
     maps each answer to the finding it closes. Section 8 lists what the pass did not reach.

     STEP 4's INDEPENDENT PASS RAN on 21/09/2026: a separate adversarial verifier, dispatched by the
     workflow, read this baseline, its threat model and the tree. It returned four material and
     eleven minor findings; each was re-read against its cited lines and applied, none declined. The
     threat model's Section 4d lists every disposition. It added one threat, TM-18, and moved no
     severity above MEDIUM. Status stays Draft until <%DEVELOPER_NAME%> has read it.

     GRILLING ROUND 3 RAN on 27/09/2026 with <%DEVELOPER_NAME%>, after CUT-PLAN.md P8 left S-03
     with no sprint. Four of its answers land here, each cited where it lands as "settled
     27/09/2026, grilling round 3 Qn": Q14 (7.5, 7.13, Section 8 item 1), Q15 (7.14, 7.15, Section
     8 items 2 and 5), Q16 (7.7, Section 8 items 4 and 6) and Q21 (TM-10, 7.11). No severity moves.
     Settling these is not signing the baseline off, so Status still reads Draft.

     GRILLING ROUND 6 RAN on 27/09/2026, with calls announced to <%DEVELOPER_NAME%> the same day and
     not objected to. AMENDED 27/09/2026 to carry them, each cited where it lands as "settled
     27/09/2026, grilling round 6 Q31" or "call recorded 27/09/2026 with round 6". Q31, with round 3
     Q18, lands on 7.10 and the Section 6 TM-12 row. The calls land on 7.5, 7.13 and Section 8
     item 1 (Q14 covers the 24 index sites and the seven TM-13 count sites, the --trust disclosure
     among the seven, not the 24) and on 7.11 and the Section 6 TM-10 row (the GAPS.md entry is
     written at US011's gate-22 pass, and TM-10's promotion to MEDIUM is retired by Q21). 7.12 is
     re-pointed to US011's amended line. No severity moves, and Status still reads Draft.

     AMENDED 27/09/2026 AT THE FINAL PASS. Grilling round 7 Q34 was answered that day (option 1):
     the third shipped-registers.sh family gains one clause, the map-index seed's one row read
     under the read rule string-equalling the scale-planning seed's own Status header, with its
     own --self-test probe. It lands on 7.3, 7.4 and the Section 6 TM-08 row; it is a clause in
     the settled family, not a second family, so round 2 Q12's trigger is not reached, and it
     resolves the QA plan's AC-GAP-2. A call recorded the same day reconciles round 3 Q24 with
     round 6 Q31 for wayfinder's chart step, and lands on 7.10. Round 4 Q27's qualifier now rides
     every statement that the two ADRs are accepted (Section 2, Cross-references). 7.11 cites the
     US011 task and Definition-of-Done line that carry TM-10's GAPS.md entry. Every US010 and
     US011 citation here was re-measured 27/09/2026 against the final pre-commit text of both
     stories, which do not change again; a 21/09/2026 citation that locates text as it stood then
     is marked "as read 21/09/2026" rather than re-pointed, the Sprint row's SPRINT-06 citation
     with them. No severity moves, and Status still reads Draft. -->

---

## 1. Summary

**The story's mechanism is right, and it holds by construction on `update` today; what it lacked
was a proof of it.** Eighteen findings were raised across all six STRIDE categories — seventeen by
the `security` skill and one, TM-18, by the independent pass: **0 CRITICAL, 0 HIGH, 4 MEDIUM,
12 LOW, 2 INFO**. Nothing gates sprint planning and no vulnerability record is written.

**Two of the story's own security rationales were wrong, in opposite directions.** ST01 says an
ungated `mv` overwrites a filled index "on every `copier update`"; read in Copier's source, an
overwrite is then replayed over by the project's own diff. So it is invisible when the seed is
unchanged between versions; when the seed has changed, the register is either altered in silence
— the seed's change merged into the project's rows — or left with conflict markers (TM-01). ST02
says an `mv` placed after `rmdir .copier` "silently no-ops"; measured, `rmdir` exits 1 on a
non-empty directory and generation fails loudly (TM-07). Both criteria stand. Their reasons are
corrected, not rewritten.

**The principal finding is a leak the existing generated-tree gate cannot see.** An `_exclude`
negation re-including an index path would ship this repository's filled index to every project on
`update` — where the copy-gated `mv` never runs — while `copy` stays clean, because the `mv`
overwrites the rendered file and `shipped-artefacts.sh` admits the path by name from `SEEDED`
(TM-02). The story's own stated shape precedent, the incident index, ships by exactly such a
negation (`copier.yml:186`). The grilling pass closed it with a no-negation clause in the new
`shipped-registers.sh` family (settled 21/09/2026, grilling round 1 Q2), which is why it is `MEDIUM`
and not more. That check matches negations with `_exclude`'s own glob semantics, because a
glob-form negation leaks exactly as a literal one does (7.6).

**The second is that nothing would notice TM-01, and the obvious probe cannot fail** (TM-04).
`shipped-registers.sh` greps the whole `_tasks` block, so it cannot tell a gated task from an
ungated one; and an update probe whose template never changes a seed passes with or without the
gate, because the replay restores what the overwrite took. ST07 is written to that shape: seeds
change between tags, the assertion is byte-identity, and removing the gate must turn it red.

**Three findings sat outside the settled scope and were raised, not decided, at this gate;
grilling round 3 decided all three on 27/09/2026** (Section 8). Seven shipped guide sites —
including the text an operator reads before granting Copier `--trust` — count the seed task's files
as nine (TM-13); the allowlist widens a second time to reach them, and US010 corrects the shipped
sites (settled 27/09/2026, grilling round 3 Q14). A project generated before US010 receives the
instructions that route to the seven indexes but never the files (TM-14); and `copier recopy`, or
`copier copy` into an existing project, runs as `copy` and so moves every blank seed over the
project's own file — pre-existing for nine files, widened by seven (TM-18). US010 documents both
in the updating guide, and their complete fixes go to `GAPS.md` through gate 22 (settled
27/09/2026, grilling round 3 Q15).

## 2. Scope

| Dimension  | Coverage                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Story      | US010 — seven index files, seven seeds, seven `mv` lines, one grown allowlist, one new check family, one extended update probe, a map-status header across 15 maps                                                                                                                                                                                                                                                                                       |
| User flow  | **None** — the story adds no screen, route or journey                                                                                                                                                                                                                                                                                                                                                                                                    |
| Wireframe  | **None**, and none is possible — the surface is Markdown, YAML and bash                                                                                                                                                                                                                                                                                                                                                                                  |
| Schema     | **None** — no model, no migration, no PII. `DB` and `GDPR` both read `N/A`                                                                                                                                                                                                                                                                                                                                                                               |
| Decisions  | Two ADRs under US010: the map-status enum prefix (writer format) and the index-status read rule (reader). Both `Proposed`, and accepted in the 27/09/2026 write-back pass, after an independent review and before the US010 commit (settled 27/09/2026, grilling round 4 Q27); each Status line reads `Proposed` until that review is done. AMENDED 27/09/2026 at the final pass: this read "both `Proposed` until signed off". The debt line earns none |
| Frameworks | STRIDE · OWASP Top 10 (2025) · NIST CSF 2.0                                                                                                                                                                                                                                                                                                                                                                                                              |

**Deviation, stated rather than silently absent.** `10-security-checks` Step 1 reviews user flows
and wireframes. This story has neither and can have neither. The trust boundaries were derived from
`copier.yml`, the `.copier/` seeds, the three CI gate scripts, Copier's own source and the
template guides instead. Step 1's grilling pass and Step 4's independent pass **both** ran on
21/09/2026, and neither is a deviation this time.

**Why this story has a Security flag at all, restated because it is unusual.** The slice manifest
for `S-01` names QA only, with Security recorded as added at `02-story-creation`
(`project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md:349`). The story fills the flag on
the US006 rule it quotes (`project-management/src/02-STORIES/US010.md:102-112`, as read
21/09/2026): _"a manifest written for one kind of slice must not skip the only gate able to check
what the story actually ships. QA proves the states it was told to prove; Security asks whether
the state list is right."_
**That reasoning is vindicated here.** The manifest's QA states are "seed-lands, seed-blank"; the
negation leak (TM-02), the unfailable probe (TM-04) and both corrected rationales (TM-01, TM-07)
are outside that list, and none would have surfaced from `11-qa-checks` alone. The flag's value
**widens** at this gate — the replacement text is returned to the story as data, because a
concurrent session holds uncommitted edits to it.

## 3. Threat models referenced

- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md`
  — 18 findings, 8 trust boundaries (TB1 in-tree registers to the seeds · TB2 the seeds to a
  generated project on `copy` · TB3 a later template version to a project on `update` · TB4
  `_exclude` and its negations to the render set · TB5 the CI gates to the merge decision · TB6
  the in-tree indexes to their readers · TB7 the shipped guides to the operator granting `--trust`
  · TB8 an operator re-running generation over an existing project)

Its trust boundaries and severities are adopted here unchanged. Its Section 3b — the update seam
read from Copier 9.18.2's source — is the reasoning behind 7.1, 7.7 and 7.15.

## 4. OWASP Top 10 — baseline coverage

| ID       | Category                              | Status   | Notes (open findings, controls relied on)                                                                                                                                                        |
| -------- | ------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| A01:2025 | Broken Access Control (incl. SSRF)    | N/A      | No principal, role or ownership check exists on this surface. The seed-once gate decides what content a project receives, not who may act — it is mapped to A08                                  |
| A02:2025 | Security Misconfiguration             | Partial  | TM-16 (INFO) — seeds render, in-tree indexes do not. The `_exclude` list is the configuration whose one wrong line is TM-02; that finding is filed under its consequence, A08                    |
| A03:2025 | Software Supply Chain Failures        | Partial  | TM-15 — the change edits the CI gates that judge it. CI's unpinned Copier is pre-existing and out of scope; 7.7 is the behavioural guard against a change in it                                  |
| A04:2025 | Cryptographic Failures                | N/A      | No secret, key or credential is read, written or compared                                                                                                                                        |
| A05:2025 | Injection                             | N/A      | No untrusted input reaches a renderer. The seeds are maintainer-authored and take the same render pass as every shipped file; TM-06's line form is parse robustness, not injection               |
| A06:2025 | Insecure Design                       | Partial  | TM-09 — an allowlist read as a control; TM-14 — seed-once files added after generation never reach a project that already exists                                                                 |
| A07:2025 | Authentication Failures               | N/A      | No principal is authenticated; a generation task has no session                                                                                                                                  |
| A08:2025 | Software and Data Integrity Failures  | **Open** | **The dominant category, and the story's own subject.** TM-01 to TM-04 (all four `MEDIUM`s), TM-06, TM-08, TM-10 to TM-13, TM-18 — what a project's registers hold, and whether a gate proves it |
| A09:2025 | Security Logging & Alerting Failures  | **Open** | TM-17 (INFO) — nothing records who changed an index row. Accepted residual                                                                                                                       |
| A10:2025 | Mishandling of Exceptional Conditions | Partial  | TM-05, TM-07 — both failures are **loud** today (`TaskError`, `rmdir` exit 1, `[3/4]` red); 7.2 and 7.8 exist to keep them loud                                                                  |

## 5. NIST CSF 2.0 — function summary

| Fn  | Function | Design-stage posture                                                                                                                                                                                                                                                                                                                        |
| --- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GV  | Govern   | **Improved.** The one-way-door rule `copier.yml:967-972` states for three registers now covers ten, and the two hard-to-reverse calls are ADRs. Weak spot: the `--trust` disclosure (TM-13)                                                                                                                                                 |
| ID  | Identify | **Strong, and the strongest part of this gate.** The three update renders were read rather than assumed, the masking path located, and 47 tracked instances and 12 of 15 maps measured                                                                                                                                                      |
| PR  | Protect  | **Partial until 7.3, 7.6 and 7.8 land.** The gate holds by construction; blankness and the absence of a negation are asserted only once the new family exists                                                                                                                                                                               |
| DE  | Detect   | **Weakest today.** No gate sees the gate's position, `SEEDED` admits by name, and the obvious update probe cannot fail. 7.7's shape is what moves this off Open                                                                                                                                                                             |
| RS  | Respond  | **Adequate.** Every failure mode on this surface is loud and fails the build; 7.2 and 7.8 are the constraints that keep it so                                                                                                                                                                                                               |
| RC  | Recover  | **Open for TM-14 and TM-18.** Today a pre-US010 project has no stated path to the seven files, and a recopy loses uncommitted register edits outright. US010 documents both in the updating guide; the complete fixes are `GAPS.md` entries (settled 27/09/2026, grilling round 3 Q15). For TM-01 the recovery is the project's own history |

## 6. Findings

Grouped by severity. All eighteen are carried from the threat model unchanged — TM-18, added by the
independent pass, sits with the other `LOW`s — see it for the full mitigation text and the
promotion triggers.

| ID    | STRIDE | OWASP | NIST  | TB  | Threat Description                                                                    | Severity | Planned Mitigation                                                                                                                                                                                                                                                                                                                                                      |
| ----- | ------ | ----- | ----- | --- | ------------------------------------------------------------------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TM-01 | T      | A08   | PR.DS | TB3 | An ungated `mv` stops the file being seed-once; the damage depends on the seed        | MEDIUM   | All seven lines in the one copy-gated chain (7.1)                                                                                                                                                                                                                                                                                                                       |
| TM-02 | I      | A08   | PR.DS | TB4 | A negation leaks this repository's rows on `update`, masked on `copy`                 | MEDIUM   | No negation matches an index path by glob; probes plant both forms (7.6)                                                                                                                                                                                                                                                                                                |
| TM-03 | I      | A08   | PR.DS | TB1 | A seed cut from a populated in-tree index is a one-way door                           | MEDIUM   | Blank seeds, emptiness proved by the new family (7.3)                                                                                                                                                                                                                                                                                                                   |
| TM-04 | T      | A08   | DE.CM | TB5 | Nothing would notice TM-01, and the obvious probe cannot fail                         | MEDIUM   | Seed-changing, byte-identity update probe, proved red (7.7)                                                                                                                                                                                                                                                                                                             |
| TM-05 | D      | A10   | DE.CM | TB5 | The fixture lacks six folders; `[3/4]` goes red and invites a silent fix              | LOW      | The fixture creates them; no `mkdir -p` in `copier.yml` (7.7)                                                                                                                                                                                                                                                                                                           |
| TM-06 | T      | A08   | PR.PS | TB2 | Three parsers read the `mv` line; a flag breaks two; `\|\| true` hides a missing seed | LOW      | The one-line form, no flag, no quoting, no split (7.8)                                                                                                                                                                                                                                                                                                                  |
| TM-07 | D      | A10   | RC.RP | TB2 | An `mv` after `rmdir` fails loudly — the story said silently                          | LOW      | Lines ahead of `rmdir`, which stays `rmdir` (7.2)                                                                                                                                                                                                                                                                                                                       |
| TM-08 | I      | A08   | PR.DS | TB1 | One syntek-base literal in a seed ships permanently                                   | LOW      | No instance literal and no debt line in any seed; the seed row's `Status` held equal to the seeded map's header by one clause in 7.3's family, with its own probe (settled 27/09/2026, grilling round 7 Q34) (7.4)                                                                                                                                                      |
| TM-09 | S      | A06   | DE.CM | TB5 | `SEEDED` is an allowlist already read as a control                                    | LOW      | Presence to US012; content to 7.6 (7.12)                                                                                                                                                                                                                                                                                                                                |
| TM-10 | T      | A08   | DE.CM | TB6 | Four indexes ship incomplete; after US011 nothing keeps them complete                 | LOW      | Debt line; the no-gate window runs from US011 shipping until S-03 is cut, and S-03 is unscheduled (CUT-PLAN.md P8, map-order row 10); tracked in `GAPS.md` through gate 22. Stays `LOW` (settled 27/09/2026, grilling round 3 Q21). The entry is written at US011's gate-22 pass, and the promotion to MEDIUM is retired (call recorded 27/09/2026 with round 6) (7.11) |
| TM-11 | T      | A08   | DE.CM | TB6 | Three answers to "what is a row's Status"; two carriers never asked                   | LOW      | One read rule, its own ADR (7.9)                                                                                                                                                                                                                                                                                                                                        |
| TM-12 | T      | A08   | PR.DS | TB6 | The map header becomes gate-read; a status can be written to look finished            | LOW      | The enum-prefix ADR, five values, each tested from the map's own counts and derived by measurement; `Blockers clear` wins the one overlap (7.10)                                                                                                                                                                                                                        |
| TM-13 | E      | A08   | ID.AM | TB7 | The `--trust` disclosure counts nine files; the task will move sixteen                | LOW      | Allowlist widened a second time; US010 corrects the shipped sites (settled 27/09/2026, grilling round 3 Q14) (7.13)                                                                                                                                                                                                                                                     |
| TM-14 | D      | A06   | ID.AM | TB3 | Pre-US010 projects get the routes to the indexes but never the files                  | LOW      | Documented in the updating guide by US010; a seed-if-absent migration to `GAPS.md` through gate 22 (settled 27/09/2026, grilling round 3 Q15) (7.14)                                                                                                                                                                                                                    |
| TM-15 | T      | A03   | PR.PS | TB5 | The change edits the gates that judge it                                              | LOW      | Existing probes unchanged; new probes seen red first (7.5)                                                                                                                                                                                                                                                                                                              |
| TM-18 | T      | A08   | PR.DS | TB8 | Recopy, or copy into an existing project, hands back every blank seed                 | LOW      | Documented in the updating guide by US010; a guard refusing an existing target to `GAPS.md` through gate 22 (settled 27/09/2026, grilling round 3 Q15) (7.15)                                                                                                                                                                                                           |
| TM-16 | I      | A02   | PR.PS | TB1 | Seeds render and in-tree indexes do not                                               | INFO     | None beyond the existing gates — caught twice                                                                                                                                                                                                                                                                                                                           |
| TM-17 | R      | A09   | DE.AE | TB6 | Nothing records who changed an index row                                              | INFO     | Accepted residual, named rather than assumed                                                                                                                                                                                                                                                                                                                            |

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/PLANNING/`, and that
absence is a recorded outcome rather than an unrun check — the threat model's Section 4 gives the
reason, and its Section 3a names the three events that promote a finding to `HIGH`. **TM-02's
severity is not its importance**: it is `MEDIUM` because the grilling pass closed it before a line
was written, and it is the finding most worth reading first, because it is the one the existing
gate is structurally unable to report.

## 7. Security tasks & open gaps

Eight constraints become US010's Security acceptance criteria, checkable by reading the shipped diff
and running the named self-tests; the implementation assessment closes each with evidence. **The
story's `ST01`–`ST05` are carried, not replaced** — `ST01` becomes 7.1 with its consequence
corrected, `ST02` 7.2 with its rationale corrected, `ST03` 7.3 with its host named, `ST04` 7.4 with
its one permitted row settled, `ST05` 7.5 with its allowlist widened. `ST06`–`ST08` are new as
7.6–7.8. No `ST` number is reused or renumbered.

- [ ] **7.1** All seven `mv` lines sit inside the one existing `_tasks` entry at
      `copier.yml:973-984`, under its `when:` key keyed on `_copier_operation == 'copy'` (`:984`) —
      no second task. Asserted statically by 7.3's copy-gated-chain clause and behaviourally by 7.7.
      **Consequence corrected**: an ungated line would run in all three update renders; the
      project's own diff is replayed over the overwrite, so the result is invisible when the seed is
      unchanged between versions, and when it has changed the register is either altered in silence
      or left with conflict markers. Holds by construction **on `update`** today; `copier recopy`
      opens the gate whatever the chain looks like, and is 7.15, not this criterion (A08, TM-01) —
      _`ST01`_
- [ ] **7.2** All seven lines land **ahead of** `rmdir .copier` (`copier.yml:983`), and that line
      stays `rmdir`, never `rm -rf`: it is what makes a seed without its `mv` line fatal.
      **Rationale corrected**: a line after it does not silently no-op — `rmdir` exits 1 on a
      non-empty directory (measured 21/09/2026), the chain aborts, Copier raises `TaskError` and
      deletes a fresh destination (A10, TM-07) — _`ST02`_
- [ ] **7.3** Every seed is authored blank, and the blankness is **proved**:
      `.github/scripts/shipped-registers.sh` gains a third family for the seven index seeds — seed
      exists; its `mv` line present **in the copy-gated chain**, not merely somewhere in `_tasks`
      (`:149-154` today cannot tell the two apart); the `## The register` canvas marker; no instance
      row bar the empty-register placeholder and the map-index seed's single row; and, **added
      27/09/2026** (settled 27/09/2026, grilling round 7 Q34, option 1), that single row's
      `Status`, read under the read rule, string-equal to the scale-planning seed's own
      `**Status**` header (`.copier/MAP-SCALE-PLANNING.md:4`), read under the same rule. Each check
      ships a `--self-test` probe; the seed-row clause's is a mutated seed pair, yielding exactly
      one finding. More than one new family plus its probes sends US010 to 13 SP and back to
      `01-feature-map` (settled 21/09/2026, grilling round 2 Q12); the seed-row clause is a clause
      in this family, not a second family, so that trigger is not reached. ST03 as it now stands is
      at `project-management/src/02-STORIES/US010.md:757-773` (A08, TM-03, TM-04, TM-08) —
      _`ST03`_
- [ ] **7.4** No seed names a syntek-base map, story, sprint, decision, plan, finding or bug, and
      none carries the `Backfill owed` line. The one permitted literal is the map-index seed's row
      for the seeded scale-planning map: `Status` `Not started`, `Instance` linking the seeded map,
      `Summary` a generic one-liner naming nothing syntek-base-specific or `TBD`, `Updated` `TBD`
      (settled 21/09/2026, grilling round 1 Q4). **Host**: 7.3's family checks row shape, and the
      one row's `Status` below, so a literal in seed **prose** — a worked example in a reading
      rule, the debt line — is caught by the QA generated-tree grep for `US###`, `SPRINT-##`,
      `ADR-US###` and `MAP-<FEATURE>` (`project-management/src/02-STORIES/US010.md:427-428`, as
      read 21/09/2026), and anything those four patterns miss is checked at review. **The row's
      `Status`, settled 27/09/2026** (grilling round 7 Q34, option 1): it string-equals, under the
      read rule, the scale-planning seed's own `**Status**` header
      (`.copier/MAP-SCALE-PLANNING.md:4`), asserted at template time by one clause in 7.3's family
      with its own `--self-test` probe, a mutated seed pair yielding exactly one finding — so an
      edit to one seed and not the other cannot ship. A clause in the settled family, not a second
      family, so round 2 Q12's trigger is not reached. This resolves the QA plan's AC-GAP-2, which
      proposed that host for this criterion, and HP-03's Status agreement is automated by it
      rather than read by hand in a generated tree. It lands at
      `project-management/src/02-STORIES/US010.md:765-773` (ST03), `:636-637` (the seed-family
      scenario), `:608` (the generated-project scenario) and `:1118-1129` (the Security Task).
      AMENDED 27/09/2026 at the final pass: this criterion had read that 7.3's family "checks row
      shape only" (A08, TM-08) — _`ST04`_
- [ ] **7.5** The change introduces no new network fetch, no new credential read, and no write
      outside `project-management/src/`, `.copier/`, `copier.yml`,
      `.github/scripts/shipped-artefacts.sh`, `.github/scripts/shipped-registers.sh`,
      `.github/scripts/shipped-ai.py`, `.github/workflows/audit-template.yml`,
      `.claude/skills/wayfinder/SKILL.md`, `project-management/workflows/`,
      `how-to/src/TEMPLATE-GUIDE/` and `how-to/src/TEMPLATE-TOKENS.md`. **Widened a second time**
      by those last three (settled 27/09/2026, grilling round 3 Q14), so that US010 corrects the
      24 index sites the QA plan inventories (`QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md` Section 7
      and AC-GAP-1) and the seven TM-13 count sites, including the `--trust` disclosure at
      `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:22` (7.13) — Q14 covers both inventories (call
      recorded 27/09/2026 with round 6). **Merge order**: US015 (provisional,
      RULE-OWNERSHIP S-02) edits other lines of `06-GENERATION.md`, `15-TROUBLESHOOTING.md` and
      `TEMPLATE-TOKENS.md`; US010 (SPRINT-06) lands first and US015 rebases. Every existing
      self-test probe passes **unchanged** — 9 / 5 / 2 in `shipped-registers.sh` /
      `shipped-artefacts.sh` / `shipped-ai.py` as measured 21/09/2026; US012 may add to the second
      first, and whichever lands second counts what it finds — and each new probe is seen red
      before it is seen green (A03, TM-15) — _`ST05`, widened twice_
- [ ] **7.6** No `_exclude` negation re-includes any index path, asserted by 7.3's family.
      Negations are matched against each of the seven index paths **with `_exclude`'s own glob
      semantics**, never by string equality — `copier.yml:160-164` already carries glob-form
      negations, and `path_matches` at `code/src/scripts/audits/doc-references.sh:406-418` is the
      in-repository precedent for that matching. The self-test plants a literal negation and a
      **glob-form** one (one ending `**/*-INDEX.md`, say), each expecting exactly one finding, and
      no existing negation may raise one. `shipped-artefacts.sh:197` admits a
      `SEEDED` path by name, so such a negation passes the generated-tree check on `copy` and ships
      this repository's filled index into projects on `update`. The incident index is the shape
      precedent, never the mechanism precedent (A08, TM-02, TM-09) — _`ST06`, new_
- [ ] **7.7** `.github/scripts/shipped-ai.py`'s fixture creates the six register folders the new
      lines target (today it creates `01-FEATURE-MAPS/` alone, `:103-104`), and its update probe
      asserts every index edited in the generated project survives the update; no `mkdir -p`
      enters `copier.yml` (settled 21/09/2026, grilling round 1 Q3). **Added at this gate, from
      TM-04**: the assertion is **byte-identity** after `run_update` — never that a marker row
      survives, because a silently merged file and a conflict-marked one both contain it; the
      fixture **changes every index seed** between its two tags; and a self-test mutation that
      removes the seed task's copy gate must turn the probe red. The three additions are new
      `shipped-ai.py` work that grilling round 2 Q12's trigger does not measure. **All three go into
      US010, and <%DEVELOPER_NAME%> signs off knowingly that the trigger does not count them**
      (settled 27/09/2026, grilling round 3 Q16). The memory-survival probe's identical blind case
      is not this criterion's: it goes to `GAPS.md` through gate 22 (Section 8 item 4) (A08, A10,
      TM-01, TM-04, TM-05) — _`ST07`, new_
- [ ] **7.8** Every line takes the chain's existing one-line form — `mv .copier/<NOUN>-INDEX.md`
      then its `project-management/src/<REGISTER>/` target then `&&` — with no flag, no quoting, no
      `|| true` and no split across the folded scalar. A flag, a quoted path or a split makes
      `doc-references.sh:373`'s regex and `shipped-registers.sh:151-154`'s fixed-string grep miss
      the line, a false red whose easy repair is a looser parser. `|| true` breaks no parser, but
      swallows a missing seed (measured). `shipped-ai.py` reads only the memory line (`:323`), so
      it needs that line kept in the same task. A flag is **not** a leak path: `mv -n` onto an
      existing target exits 1 (measured), and a silent skip leaves the seed for `rmdir` to fail on
      (A08, TM-05, TM-06) — _`ST08`, new_

Four further constraints are carried by other instruments and are **not** `ST` criteria:

- [ ] **7.9** One `Status` read rule for all seven carriers — maps, stories, sprints, ADRs, plans,
      **findings** (a middle-dot-separated metadata line,
      `project-management/src/20-FINDINGS/FINDING-US000-TEMPLATE.md:5`) and **bugs** (a bold-key
      table row, `project-management/src/21-BUGS/BUG-US000-TEMPLATE.md:17`) — recorded as its own
      ADR under US010 (settled 21/09/2026, grilling round 1 Q5). US010's Index Tasks omit the last
      two carriers today and gain them (A08, TM-11)
- [ ] **7.10** The map `Status` header takes the settled form, with `Not started` the fifth value
      and `project-management/src/01-FEATURE-MAPS/MAP-000-TEMPLATE.md:4` carrying that value and the
      format instruction; every value derived by measurement (settled 21/09/2026, grilling round 2
      Q11 and grilling round 1 Q4), never asserted, against each value's test from the map's own
      counts: `Not started`, nothing charted (`Charted` reads `TBD`); `Charting`, charted, no node
      resolved and `Blocking open` above 0; `Resolving`, at least one node resolved and
      `Blocking open` above 0; `Blockers clear — stories may start`, `Blocking open` 0 and not
      `Complete`; `Complete`, `Frontier open` 0 and the Fog of war empty (settled 27/09/2026,
      grilling round 3 Q18). The overlap Q18 left is resolved — `Blockers clear` wins, so a charted
      map with nothing resolved and `Blocking open` 0 reads `Blockers clear — stories may start`
      (settled 27/09/2026, grilling round 6 Q31). The derivation criterion, Q31 included, is at
      `project-management/src/02-STORIES/US010.md:584` (re-measured 27/09/2026 against the final
      pre-commit text). AMENDED 27/09/2026 at the final pass: the one writer US010 instructs to
      move a map out of `Not started`, wayfinder's chart step (settled 27/09/2026, grilling round 3
      Q24), fills `Charted` and writes the value the counts give — `Charting` while
      `Blocking open` is above 0, otherwise `Blockers clear — stories may start` — and never
      asserts `Charting` (the Q24 x Q31 reconciliation, call recorded 27/09/2026;
      `project-management/src/02-STORIES/US010.md:691-695` and `:1018-1027`) (A08, TM-12)
- [ ] **7.11** The window in which the four backfilled indexes read complete with no gate runs
      from US011 shipping until S-03 is cut, and S-03 is unscheduled (CUT-PLAN.md P8, map-order
      row 10). TM-10 stays `LOW`, and the window is tracked in `GAPS.md`, routed through gate 22
      (`project-management/workflows/22-implementation-documentation/`, the sole writer of
      `GAPS.md`) (settled 27/09/2026, grilling round 3 Q21). The entry is written at US011's
      gate-22 pass, because the window opens when US011 ships, and TM-10's promotion to MEDIUM
      ("US011 lands and S-03 has not been cut") is retired by Q21: <%DEVELOPER_NAME%> chose LOW
      knowing S-03 is unscheduled (call recorded 27/09/2026 with round 6; threat model Section 3a).
      US011 carries the entry as a task and a Definition-of-Done line
      (`project-management/src/02-STORIES/US011.md:453-460` and `:517-521`, measured 27/09/2026
      against the final pre-commit text; cited AMENDED 27/09/2026 at the final pass).
      AMENDED 27/09/2026: this criterion had read that the decision did not name which story's
      gate-22 pass writes the entry. This replaces the 21/09/2026 settlement that S-03 is
      cut into SPRINT-08 straight after these gates commit (grilling round 1 Q1 and grilling
      round 2 Q13), which P8 superseded: SPRINT-08 is RULE-OWNERSHIP's (US013, US014) (A08, TM-10)
- [ ] **7.12** `SEEDED`'s presence half is US012's check-4 loop and deletion probe; every citation
      of `SEEDED` describes it as an allowlist, including US011's, cited 21/09/2026 at
      `US011.md:73-75` and amended 27/09/2026 to read as one
      (`project-management/src/02-STORIES/US011.md:99-103`, re-measured 27/09/2026 against the
      final pre-commit text) (A06, TM-09)

Three gaps were open at this gate and were **not** settled here. Grilling round 3 settled all three
on 27/09/2026 (Section 8), and each is now a constraint the implementation assessment closes with
evidence like the rest:

- [ ] **7.13** `[RESOLVED] 27/09/2026` The seven shipped sites that count the seed task's files as
      nine sit inside 7.5's allowlist as widened a second time, and US010 corrects the shipped
      sites — the 24 index sites the QA plan inventories and the seven TM-13 count sites,
      including the `--trust` disclosure at `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:22`
      (settled 27/09/2026, grilling round 3 Q14; the seven confirmed by call recorded 27/09/2026
      with round 6, closing the detail Section 8 item 1 had left open) (A08, TM-13)
- [ ] **7.14** `[RESOLVED] 27/09/2026` The route to the seven indexes for a project generated
      before US010 is documented by US010 in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`; the
      complete fix, a seed-if-absent update migration, is routed to `GAPS.md` through gate 22 and
      stays out of US010 (settled 27/09/2026, grilling round 3 Q15) (A06, TM-14)
- [ ] **7.15** `[RESOLVED] 27/09/2026` What `copier recopy`, or `copier copy` into an existing
      project, does to every seeded file — the gate opens, and no gate value can tell it from a
      first copy — is documented by US010 in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`; the
      complete fix, a guard refusing an existing target, is routed to `GAPS.md` through gate 22 and
      stays out of US010 (settled 27/09/2026, grilling round 3 Q15) (A08, TM-18)

**None of the fifteen is a sprint-planning blocker** — no CRITICAL or HIGH was raised. **7.6 and
7.7 are the two to read first**: 7.6 closes the only leak the existing gates cannot report, and 7.7
is the only constraint whose naive implementation would pass while proving nothing.

## 8. What this assessment could not settle

The grilling pass settled every question it was asked. Six things it did not reach. Grilling round
3 settled or routed five of them on 27/09/2026; item 3 stays open, because it is a measurement owed,
not a decision:

1. **TM-13 — the stale `--trust` disclosure.** `[RESOLVED] 27/09/2026` Seven sites in five
   shipped files count the seed task's files as nine: `how-to/src/TEMPLATE-GUIDE/04-QUICKSTART.md:22`,
   `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md:146`, `:162` and `:167-179`,
   `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md:29-45`,
   `how-to/src/TEMPLATE-GUIDE/15-TROUBLESHOOTING.md:87` and `how-to/src/TEMPLATE-TOKENS.md:528`.
   None was inside 7.5's allowlist as widened on 21/09/2026. **Settled 27/09/2026, grilling round
   3 Q14:** the allowlist widens a second time — by `project-management/workflows/`,
   `how-to/src/TEMPLATE-GUIDE/` and `how-to/src/TEMPLATE-TOKENS.md` — and US010 corrects all 24
   index sites the QA plan inventories (`QA-PLAN-US010-SEEDED-REGISTER-INDEXES.md` Section 7 and
   AC-GAP-1) and the `--trust` disclosure at `04-QUICKSTART.md:22`. No site goes to a register
   entry. US015 (provisional, RULE-OWNERSHIP S-02) edits other lines of `06-GENERATION.md`,
   `15-TROUBLESHOOTING.md` and `TEMPLATE-TOKENS.md`; US010 (SPRINT-06) lands first and US015
   rebases. **The one detail the decision left open is closed by call** (call recorded 27/09/2026
   with round 6). The QA plan's 24 are the register-index sites, and this item's seven are a
   separate inventory, of which the decision named only `04-QUICKSTART.md:22`; this item had left
   the other six for the story's write-back to confirm. The call settles it: Q14 covers the 24
   index sites and all seven count sites, the `--trust` disclosure among the seven, not the 24.
   US010 carries the seven in its own scenario and task
   (`project-management/src/02-STORIES/US010.md:676-682` and `:1055-1065`, re-measured 27/09/2026
   against the final pre-commit text).
2. **TM-14 — projects generated before US010.** `[RESOLVED] 27/09/2026` The cheap answer is a
   sentence in the updating guide, which depended on item 1. The complete answer is a
   seed-if-absent update migration, which is a second `copier.yml` decision and meets the story's
   own 13 SP trigger (`project-management/src/02-STORIES/US010.md:207-209`, as read 21/09/2026).
   **Settled 27/09/2026, grilling round 3 Q15:** the cheap answer — US010 documents TM-14 in
   `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`, inside the allowlist item 1 widened. The migration
   is routed to `GAPS.md` through gate 22
   (`project-management/workflows/22-implementation-documentation/`, the sole writer of
   `GAPS.md`), and stays out of US010.
3. **The Copier reading is unexecuted.** Section 3b of the threat model reads Copier 9.18.2's
   source; the project rule against raw interpreter calls kept this gate from running a mutated
   fixture. 7.7's self-test is what turns the reading into a measurement.
4. **The memory-survival probe's blind case.** `[RESOLVED] 27/09/2026` By the same reading,
   `shipped-ai.py:174-175` would pass with the memory seed task ungated, because its second tag
   never changes the memory seed. Pre-existing and outside US010. **Settled 27/09/2026, grilling
   round 3 Q16:** it stays outside US010 and is routed to `GAPS.md` through gate 22, whose
   register entry it is to write (`22-implementation-documentation`).
5. **TM-18 — recopy and copy-over-existing**, raised by the independent pass.
   `[RESOLVED] 27/09/2026` Both run as `copy`, the operation type has no third value, and recopy
   runs no dirty check, so uncommitted register edits are lost outright. A warning in the updating
   guide is the cheap answer and depended on item 1; a guard that refuses an existing target is the
   complete one, a second `copier.yml` decision under the same 13 SP trigger and at odds with 7.8's
   one-line form. Pre-existing for nine files. **Settled 27/09/2026, grilling round 3 Q15:** US010
   documents TM-18 in `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md`; the guard is routed to
   `GAPS.md` through gate 22 and stays out of US010.
6. **7.7's three gate-added obligations** `[RESOLVED] 27/09/2026` are new `shipped-ai.py` work
   that grilling round 2 Q12's trigger does not count. The 8 SP is not re-opened here. **Settled
   27/09/2026, grilling round 3 Q16:** all three — seeds changed between the probe's two tags,
   byte-identity, proved red with the copy gate removed — go into US010, and <%DEVELOPER_NAME%>
   signs off knowingly that the trigger does not count them.

Recorded here rather than resolved at this gate, because a gate that invents an answer to a
question it never asked is worse than one that says it did not ask. The answers above are
<%DEVELOPER_NAME%>'s, from grilling round 3, not this gate's.

---

## Cross-references

- `project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record that verifies this baseline
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US010-SEEDED-REGISTER-INDEXES.md` — the STRIDE model this assessment synthesises, and its Sections 3b, 4a and 4d
- `project-management/src/10-SECURITY/AUDITS/PLANNING/` · `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — the sibling code audit and the escalated findings; this story writes to neither, and Section 6 states why
- `project-management/src/02-STORIES/US010.md` — the story being assessed, whose `ST01`–`ST05` Section 7 carries
- `project-management/src/01-FEATURE-MAPS/MAP-REGISTER-INDEXES.md` — `S-01`'s manifest, and `S-03`, which this story precedes
- `project-management/src/15-DECISIONS/ADR-US010-MAP-STATUS-IS-AN-ENUM-PREFIX-21-09-2026.md` · `project-management/src/15-DECISIONS/ADR-US010-INDEX-STATUS-READ-RULE-21-09-2026.md` — the two records behind 7.10 and 7.9, both `Proposed`; accepted in the 27/09/2026 write-back pass, after an independent review and before the US010 commit (grilling round 4 Q27)
- `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/ASSESSMENT-PLAN-US009-HOOK-ARMING.md` — the shape precedent for carrying a story's `ST` numbers into Section 7
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP Top 10 (2025), and NIST CSF 2.0 standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` — the code-side enforcement these targets must stay consistent with
- `code/docs/GATE-REPORTING.md` — why the zero in Section 6, the unexecuted Copier reading and Section 8 are stated rather than left implied
