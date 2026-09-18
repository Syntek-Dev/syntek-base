# Security Posture Assessment (Plan) — US009 The git hooks arm on purpose at install

| Field          | Value                                                                                                   |
| -------------- | ------------------------------------------------------------------------------------------------------- |
| **Story**      | US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true |
| **Date**       | 17/09/2026                                                                                              |
| **Author**     | Claude Code — `security` skill, Opus · **not yet reviewed by <%DEVELOPER_NAME%>**                       |
| **Sprint**     | SPRINT-05 — this story is its stretch `Should`, 3 of 11 SP                                              |
| **Status**     | Draft                                                                                                   |
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

---

## 1. Summary

**The story is right about the defect and incomplete about the fix.** `.copier/README.md:441`
promises that `install.sh` "runs `lefthook install`"; it does not, and US009 makes the claim true.
That half is sound and cheaply verified. Twelve findings were raised across five STRIDE
categories: **0 CRITICAL, 0 HIGH, 7 MEDIUM, 4 LOW, 1 INFO**. Nothing gates sprint planning and no
vulnerability record is written.

**The principal finding is that the story's own user story is not delivered by the story's own
change.** US009 asks for hooks that never arm "at a moment I did not choose", and ST02 keeps
`package.json:11`'s `prepare` script byte-identical. `--ignore-scripts` suppresses that script on
the three `install-frontend.sh` lines the story asserts — and on **no others**. A repo-wide sweep
on 17/09/2026 found **eleven** further `pnpm install` invocations without it: one in
`.claude/hooks/lib/check-lockfiles.sh:147`, which fires when a pull request is raised, and ten
across five GitHub workflow files. Each runs `prepare`, and `prepare` runs `lefthook install`.
**The evidence is in the working tree**: `.git/hooks/pre-commit` exists on this machine, is
lefthook's, dated 16/09/2026, in a repository whose `install.sh` has never written it. After
US009 ships as specified, that path is still open (TM-01, threat model Section 3b).

**A second finding is about what `--ignore-scripts` is claimed to be.** `N-019` calls it "a
deliberate supply-chain control" and ST01 asserts it on three lines, in wording that reads as a
posture. It is not a posture — it is three lines, and the same lockfile installs eleven times
without it, on CI runners holding workflow secrets and on the developer's own host. That gap is
**pre-existing and outside US009's scope**, and it is recorded here rather than escalated
precisely so that a story asserting three lines of it is not read as having covered all sixteen
(TM-02).

**Three smaller findings are concrete defects in the step as specified**, and each is cheap to fix
before it is written rather than after: the `.git` guard is false in a git worktree, which is how
this project runs parallel story work (TM-03); `lefthook` is **not on `PATH`** and the resolution
mechanism is unspecified, where the house idiom at 23 sites is `pnpm exec` (TM-04); and a hard
fail at the new step abandons the four later Phase 1 steps that create `.env.*`, the dev secrets,
the executable bits and the machine spec (TM-05).

## 2. Scope

| Dimension  | Coverage                                                                                                                          |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Story      | US009 — one new `install.sh` step, one guard, three read-only assertions, two probes                                              |
| User flow  | **None** — the story adds no screen, route or journey                                                                             |
| Wireframe  | **None**, and none is possible — the surface is bash                                                                              |
| Schema     | **None** — no model, no migration, no PII. `Backend` and `GDPR` both read `N/A`                                                   |
| Decisions  | **None.** The story states so explicitly: `N-019` was settled 27/08/2026 on the map, and the `S-11` slice split is a charting act |
| Frameworks | STRIDE · OWASP Top 10 (2025) · NIST CSF 2.0                                                                                       |

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

| ID       | Category                              | Status    | Notes (open findings, controls relied on)                                                                                                                                  |
| -------- | ------------------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A01:2025 | Broken Access Control (incl. SSRF)    | Partial   | TM-06 — the new step runs immediately downstream of `install-frontend.sh:79-81`, a live `sudo rm -rf` with two unvalidated arguments, and asserts against that same file   |
| A02:2025 | Security Misconfiguration             | Partial   | TM-10 — `usage()` numbers Phase 2 as steps 7 and 8, colliding with Phase 1's own 7 and 8; the story's renumbering task names only Phase 1                                  |
| A03:2025 | Software Supply Chain Failures        | **Open**  | **The dominant category, and the story's own subject.** TM-01, TM-02, TM-04, TM-08, TM-11 — the lifecycle channel, the eleven unsuppressed installs, the unresolved binary |
| A04:2025 | Cryptographic Failures                | N/A       | No secret, key or credential is read, written or compared by the new step                                                                                                  |
| A05:2025 | Injection                             | N/A       | No user-supplied value reaches a shell expansion the story introduces                                                                                                      |
| A06:2025 | Insecure Design                       | Addressed | The design — an explicit, reported step rather than a lifecycle side-effect — is right, and `N-019` rejected a copier `_task` for a stated reason. No finding of its own   |
| A07:2025 | Authentication Failures               | N/A       | No principal is authenticated; a setup script has no session                                                                                                               |
| A08:2025 | Software and Data Integrity Failures  | Partial   | TM-07 — `lefthook install` overwrites `.git/hooks/pre-commit` unconditionally, and `lefthook.yml:66-69` records a second tool that writes there                            |
| A09:2025 | Security Logging & Alerting Failures  | **Open**  | TM-12 — nothing persists whether the hooks were armed for a given commit. Accepted residual                                                                                |
| A10:2025 | Mishandling of Exceptional Conditions | Partial   | TM-03, TM-05, TM-09 — a guard false in a worktree, a hard fail that abandons four steps, and a proof specified into a job that cannot run it                               |

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

| ID    | STRIDE | OWASP | NIST  | TB  | Threat Description                                                      | Severity | Planned Mitigation                                          |
| ----- | ------ | ----- | ----- | --- | ----------------------------------------------------------------------- | -------- | ----------------------------------------------------------- |
| TM-01 | T      | A03   | PR.PS | TB3 | The silent-arming channel stays open through 11 unsuppressed installs   | MEDIUM   | Settle `prepare`'s fate, or state the precedence (§7.1)     |
| TM-02 | E      | A03   | PR.PS | TB6 | `--ignore-scripts` is three lines, asserted as though it were a posture | MEDIUM   | Narrow ST01's wording; raise the wider gap (§7.2)           |
| TM-03 | D      | A10   | PR.PS | TB1 | `[ -d .git ]` is false in a worktree — every parallel-story checkout    | MEDIUM   | Test for a repository, not a directory (§7.3)               |
| TM-04 | S      | A03   | PR.PS | TB2 | `lefthook` is not on `PATH`; resolution is unspecified                  | MEDIUM   | `pnpm exec lefthook install` — the house idiom (§7.4)       |
| TM-05 | D      | A10   | RC.RP | TB1 | A hard fail abandons four later Phase 1 steps                           | MEDIUM   | Move the step, or justify the abandonment (§7.5)            |
| TM-06 | E      | A01   | PR.PS | TB1 | The step sits downstream of a live `sudo rm -rf` with stray arguments   | MEDIUM   | Make "neither depends on nor masks it" a criterion (§7.6)   |
| TM-09 | D      | A10   | DE.CM | TB5 | The automated proof is specified into a job that cannot run it          | MEDIUM   | Grep in the generation job; execution gets its own (§7.9)   |
| TM-07 | T      | A08   | PR.DS | TB4 | `.git/hooks/pre-commit` is overwritten unconditionally, in silence      | LOW      | The step reports what it wrote and replaced (§7.7)          |
| TM-08 | T      | A03   | PR.PS | TB2 | The "pinned" devDependency is a caret range Step 4 may move             | LOW      | Correct ST03's wording: the lockfile pins (§7.8)            |
| TM-10 | T      | A02   | PR.PS | TB1 | `usage()`'s Phase 2 steps 7–8 collide with Phase 1's 7–8                | LOW      | Renumbering names Phase 2, or leaves it and says so (§7.10) |
| TM-11 | S      | A03   | PR.PS | TB5 | A generated project's `.git` has no commits; the case is untested       | LOW      | Cover it, or record the assumption (§7.11)                  |
| TM-12 | R      | A09   | DE.AE | TB4 | Nothing records whether the hooks were armed for a commit               | INFO     | Accepted residual, named rather than assumed                |

**No CRITICAL or HIGH finding.** Nothing escalates to `../../VULNERABILITIES/PLANNING/`, and that
absence is a recorded outcome rather than an unrun check — see Section 1 and the threat model's
Section 3a for what promotes it. **TM-01's severity is not its importance**: it is a `MEDIUM`
because there is no adversary and one developer, and it is the most consequential row in the
table because it says the story does not achieve its stated goal. `11-qa-checks` carries it as a
blocking acceptance-criteria gap, which is the correct instrument for a scope defect.

## 7. Security tasks & open gaps

Eleven constraints, each checkable by reading the shipped script. Each becomes a US009 acceptance
criterion; the implementation assessment closes it with evidence. **The story's existing
US009/ST01–ST06 are absorbed rather than replaced** — `ST01` becomes 7.2, `ST02` is subsumed
by 7.1, `ST03` by 7.4 and 7.8, `ST04` stands as 7.12, `ST05` as 7.13, `ST06` as 7.14.

- [ ] **7.1** **`package.json:11`'s `prepare` script is settled, not merely preserved.** Either it
      is removed as redundant now that an explicit step exists, or the story states which of the
      two arming owners wins, why both are kept, and what happens when they disagree. ST02's
      "byte-identical" is a _non-decision_ about the channel the story exists to close
      (A03, TM-01)
- [ ] **7.2** `--ignore-scripts` remains on `install-frontend.sh:67`, `:84` and `:93` — asserted,
      not assumed — **and the assertion states its scope**: three lines in one script, not a
      repo-wide posture. The eleven unsuppressed invocations are raised as their own register
      entry rather than left to be read as covered (A03, TM-02)
- [ ] **7.3** The guard tests for a **git repository**, not for a directory. A `git worktree add`
      checkout has `.git` as a **file**, so `[ -d .git ]` skips there — in exactly the checkouts
      `how-to/workflows/02-worktree-setup/` tells this project to create for parallel story work
      (A10, TM-03)
- [ ] **7.4** The binary is resolved from the project's own `node_modules` by the house `pnpm exec`
      idiom — used at 23 sites in this repository — and **never** from `PATH`. Measured
      17/09/2026: `lefthook` is not on `PATH`; `node_modules/.bin/lefthook` exists (A03, TM-04)
- [ ] **7.5** The step's **position** is justified against its failure mode. Inserted after Step 4
      and exiting 2, a transient failure abandons Steps 5–8: `.env.*` files, generated dev secrets,
      script executable bits and the machine spec. Either it moves to the end of Phase 1, where
      hard-fail is cheap, or the abandonment is accepted in writing (A10, TM-05)
- [ ] **7.6** The three `--ignore-scripts` assertions **neither depend on nor mask**
      `install-frontend.sh:79-81`'s live `sudo rm -rf "$PROJECT_ROOT/node_modules" log Removed.` —
      and this is a **criterion**, not a sentence in the Dependencies section. `:84` sits inside
      that block, so a QA pass reading the asserted lines walks past the defect (A01, TM-06)
- [ ] **7.7** The step **reports what it wrote** into `.git/hooks/` and what it replaced, rather
      than overwriting in silence. `install.sh` writes nothing under `.git/` today, and
      `lefthook.yml:66-69` records `code-review-graph install` appending its own hook to the same
      file (A08, TM-07)
- [ ] **7.8** ST03's wording is corrected: `package.json:22` is `"^2.1.10"`, a **range**;
      `pnpm-lock.yaml:54-56` is what pins `2.1.10`. `install-frontend.sh:84` is plain
      `pnpm install`, not `--frozen-lockfile`, so Step 4 may resolve higher and Step 5 then arms
      with whatever it resolved (A03, TM-08)
- [ ] **7.9** The generation job's criterion is what it can actually do — **assert the step is
      present** in the generated `install.sh` on both answer sets. Executing `install.sh` needs
      docker, uv, pnpm and `sudo tee -a /etc/hosts`, which `audit-template.yml:151-163` does not
      provide; a probe that runs it needs its own job, or the criterion is honest about being
      manual (A10, TM-09)
- [ ] **7.10** The renumbering names **Phase 2 as well as Phase 1**, or explicitly leaves the
      pre-existing collision and says so. Measured: `usage()` lists Phase 1 as steps 1–8
      (`:47-54`) and Phase 2 as 7 and 8 (`:57-58`), and the body headers agree (`:540`, `:580`)
      (A02, TM-10)
- [ ] **7.11** The generated-project case is covered or the assumption is written down:
      `copier.yml:1025` runs `git init` gated to `copy`, so `.git` exists with an **unborn HEAD**,
      and `lefthook install` succeeding against that is currently assumed (A03, TM-11)
- [ ] **7.12** The step runs **after** dependency installation, so it can never arm a hook
      referencing a toolchain not yet present — the failure mode `N-019` rejects a copier `_task`
      for (`project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md:241-244`). _(Carried from
      US009/ST04, unchanged.)_
- [ ] **7.13** The step introduces no new network fetch, no new credential read, and no new write
      outside `.git/hooks/`. _(Carried from US009/ST05, unchanged.)_
- [ ] **7.14** The `.git` guard tests for a repository and nothing else; it does not become a
      general try/ignore that would hide a real failure. _(Carried from US009/ST06, and note
      that 7.3 changes **how** the test is written while this keeps **what** it may cover.)_

**None of the fourteen is a sprint-planning blocker** — no CRITICAL or HIGH was raised. They are
design-stage constraints that must land with the code. **7.1 is the one to read first**: it is the
only constraint that may change the story's scope and therefore its 3 SP estimate, and it is the
one question the story does not currently ask itself.

## 8. What this assessment could not settle

The grilling pass did not run. Three questions are open and each changes a criterion:

1. **Does `prepare` survive?** (7.1) Keeping it leaves the channel open and the user story
   unmet; removing it is a larger change than 3 SP assumes. **Not currently a question in the
   story.**
2. **Where does the step sit, and does it hard-fail?** (7.5) The story names this as the criterion
   to change if `15-decisions` disagrees; TM-05 adds that the _position_ decides how expensive the
   answer is.
3. **What shape is the `.git` guard?** (7.3)

Recorded here rather than resolved, because a gate that invents an answer to a question it never
asked is worse than one that says it did not ask.

---

## Cross-references

- `project-management/src/10-SECURITY/ASSESSMENTS/IMPLEMENTATION/ASSESSMENT-IMPL-US000-TEMPLATE.md` — the post-implementation record that verifies this baseline
- `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` — the STRIDE model this assessment synthesises, and its Section 3b
- `project-management/src/10-SECURITY/AUDITS/PLANNING/` · `project-management/src/10-SECURITY/VULNERABILITIES/PLANNING/` — the sibling code audit and the escalated findings; this story writes to neither, and Section 6 states why
- `project-management/src/02-STORIES/US009.md` — the story being assessed, whose `ST01`–`ST06` Section 7 absorbs
- `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md` — the QA plan that exercises these constraints
- `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` — `N-019`, which settled that the step exists but not its failure mode
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE, OWASP Top 10 (2025), and NIST CSF 2.0 standards
- `project-management/workflows/10-security-checks/` — the workflow that produces this
- `code/docs/SECURITY.md` — the code-side enforcement these targets must stay consistent with
- `code/docs/GATE-REPORTING.md` — why the zero in Section 6, the missing grilling pass, and Section 8 are stated rather than left implied
