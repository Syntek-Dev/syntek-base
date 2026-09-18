# ADR-US008: A story that specifies a mitigation owns the channel that delivers it, so US008 repairs the preview it was going to print into

**Status:** Accepted
**Date:** 17/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US008 · `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md` (the advisory this one delivers) · `project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` AC-GAP-2 · `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` TM-03, TM-04

---

## Context

**US008 specified a control into a channel its own evidence says is suppressed, and then specified
a test to prove the suppression.** That is not a wording defect. It is the shape
`code/docs/GATE-REPORTING.md` exists to name, arrived at by a story that documented every step of
its own reasoning honestly and still ended somewhere it should not have.

The chain, as the story leaves it:

1. TM-03 is the merge hazard — a project that obeyed the old `URL-STRATEGY.md` mandate and wrote
   `SESSION_COOKIE_DOMAIN` itself takes the template's `__Host-` names on a clean three-way merge,
   with no conflict and no error, and every browser then discards the cookie by the prefix's own
   definition. Every login in that environment fails.
2. **The advisory is TM-03's only mitigation.** Nothing else in the story tells that operator
   anything.
3. `code/src/scripts/development/template-update.sh` is the update path
   `how-to/src/TEMPLATE-GUIDE/14-UPDATING.md:49` leads with — _"Preview it first. Always."_ It runs
   copier at `:143-144` with stdout and stderr redirected wholesale to `$UPDATE_LOG`, tails that log
   at `:151` **only** when the exit code is non-zero, and its `cleanup` at `:122` deletes the log
   unconditionally, even under `--keep-scratch`. A print-only advisory exiting 0 therefore never
   reaches the preview's report. At `:275` the preview prints _"Preview only — your project is
   unchanged."_ over an advisory that fired and was swallowed.
4. The story's own manual QA criterion says: _"The preview blindness is reproduced and recorded as
   the Q11 `GAPS.md` row's evidence."_

**So the story plans to demonstrate that its mitigation does not reach its operator, and ships
anyway.** A reviewer ticking that criterion is ticking a proof that the control does not work.

**The superseded record considered fixing it and declined, on a cost that was not measured.**
`ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026`'s Option E is exactly this repair, refused as _"a
behaviour change to a 295-line script with its own contract — the failure tail, the
`--keep-scratch` cleanup, the orphan and dependency audits it sequences — inside an 8 SP story
flagged Security for a cookie doctrine."_

**Measured 17/09/2026, that description does not hold.** The script is 295 lines, and the repair
touches none of the machinery named:

- The failure tail at `:151` is inside `if [[ $UPDATE_RC -ne 0 ]]`, and the repair is on the
  success path. It is untouched.
- The `cleanup` trap at `:122` fires at exit; the repair prints before exit. It is untouched.
- The orphan audit at `:196` and the dependency audit after it are separate sections in a script
  that is already a sequence of report blocks. The repair adds a block; it reorders nothing.
- **A report section for exactly this already exists.** `:162` opens `── What this update does ──`
  and prints counts of modified, deleted, added and conflicted files. The repair is a sibling block
  that greps the migration banner lines out of `$UPDATE_LOG` and prints them — roughly eight lines,
  additive, in a script whose whole structure is additive report blocks.

The 09/09 refusal weighed **"a behaviour change to a script with a contract"** against the cost of
leaving it. The thing actually on offer is an additional report block on a success path that
already reports four other things. The conclusion was reasonable given the description; the
description was wrong.

**Three print-only advisories have already shipped blind** — `v3.0.0`, `v5.0.0`, and the
report-only third of `v6.0.0` — and `14-UPDATING.md:144` claims _"The update tells you, because
v3.0.0 ships a migration that reports it"_, which is true of the apply at `:280` and false of the
preview the same guide tells you to run first. **US008 does not create the blindness. It is the
first story whose mitigation depends on it not existing.**

## Options considered

### Option A — accept it, and delete the criterion that would have proved it

- **Summary:** keep the `GAPS.md` row, drop the manual QA criterion, ship the advisory into a
  channel a previewing operator cannot see.
- **Pros:** US008's scope is untouched; three advisories already live this way; the apply does
  print.
- **Cons:** it removes the evidence of the defect rather than the defect, which is worse than
  leaving the criterion in — the criterion at least made the problem visible to a reviewer. The
  mitigation for the story's highest-consequence threat remains one an operator following the
  guide's own instruction does not receive.

### Option B — a second channel that leaves the wrapper alone

- **Summary:** the advisory also writes a file into the project, which the operator finds after the
  update.
- **Pros:** narrow; `template-update.sh` is not touched at all.
- **Cons:** it invents a delivery mechanism no migration in this template uses, and puts the report
  somewhere nothing tells the operator to look — a file in a tree they have just been told is
  unchanged. It answers "is the report emitted" and not "does the operator read it", which is the
  actual question. It also leaves `14-UPDATING.md:144` false.

### Option C — repair the preview inside US008 (the decision)

- **Summary:** surface the migration report from `$UPDATE_LOG` in the preview's own output on
  success, as a sibling of the report block at `:162`.
- **Pros:** closes the channel for **every** print-only migration at once, including the three that
  already shipped blind; puts the report where `14-UPDATING.md:49` tells the operator to make the
  decision; makes `:144`'s existing claim true instead of leaving it to be discovered as false.
- **Cons:** US008 grows, in a sprint at capacity, and a cookie-doctrine story ends up editing the
  update wrapper — a second subject in a story that already carries five guides, three settings
  modules, a gate clause and two migrations.

### Option D — repair it as its own story, blocking US008

- **Summary:** a separate 2 SP story for the wrapper, made a hard dependency of US008.
- **Pros:** one subject per story, and the repair is credited where it belongs.
- **Cons:** SPRINT-05 is `11 / 11 SP`, at capacity and closed to further admission, and US009 is
  the only donor. It buys cleanliness by dropping a story, and it serialises two things that have no
  technical reason to be serialised.

## Decision

**We will take Option C: US008 repairs the preview, and the general rule this record fixes is that
a story specifying a mitigation owns the channel that delivers it.**

The deciding factor is that **a control nobody receives is not a control, and US008 is the story
that discovered this.** The distinction the superseded record drew — the blindness "predates US008;
the story adds a fourth print-only report to a blind preview, it does not create the blindness" — is
true and is not the relevant test. Three earlier advisories reported work that was already done and
survivable: files stranded in a husk, citations pointing at a moved section. This one is the sole
defence against a silent, total authentication failure. **The same defect is load-bearing here and
was not before**, which is what makes it this story's to fix rather than a queue item it inherits.

The secondary factor is that the cost that justified declining it was overstated, and the
measurement above says by how much. A refusal that rests on a description of the work is worth
re-opening when the work is measured and found to be an additive block in a script built out of
additive blocks.

**The rule, stated so it binds beyond this story:** when a story's threat model names a mitigation,
the channel that delivers that mitigation is inside the story's scope, and a criterion that would
demonstrate the channel does not work is a blocking finding rather than evidence for a register
row. A story may still decline the repair — but it declines it by arguing the mitigation is
adequate without it, never by filing the gap and shipping the control regardless.

## Consequences

- **Positive:** TM-03's mitigation reaches the operator at the moment
  `14-UPDATING.md:49` says the decision is made, rather than after they have made it.
- **Positive:** the three print-only advisories already in the file — `v3.0.0`, `v5.0.0` and
  `v6.0.0`'s report-only third — become visible in a preview for the first time. The fix is not
  scoped to the cookie advisory and should not be.
- **Positive:** `14-UPDATING.md:144`'s existing claim becomes true of both paths. The guide is not
  edited; it stops being wrong.
- **Negative / trade-off:** US008 carries a second subject. It **holds at 8 SP** — a wide 8, said
  out loud in the story's estimate comment rather than absorbed silently — because
  `project-management/docs/planning/STORIES.md` puts 13 at the epic threshold, where a well-understood
  story would be sent back to `MAP-SUBDOMAIN-ROUTING.md` to be re-cut. That is a worse outcome than a
  stated wide 8, and the Fibonacci scale offers nothing in between.
- **Negative / trade-off:** SPRINT-05 runs to grace. With US009 re-estimated to 5 SP it stands at
  **13 / 11**, the hard ceiling, with nothing left. `.claude/skills/sprint/SKILL.md` warns that a
  sprint habitually running to grace means the ceiling is wrong; one sprint at grace is the case the
  grace exists for, and a second would be the signal.
- **Negative / trade-off:** the `GAPS.md` row of 09/09/2026 on the preview blindness closes as part
  of US008 rather than standing. Closing it is a gain; the trade is that the row never got to serve
  its purpose of holding a known defect across stories, so nothing here proves that mechanism works.
- **Follow-on:** US008's manual QA criterion inverts — it proves the advisory **is** visible in the
  preview, rather than proving it is not. The `GAPS.md` row is marked `CLOSED 17/09/2026` when the
  story lands, per `.claude/CLAUDE.md` Section 9.
- **Follow-on:** the repair is deliberately general — it surfaces whatever the migration stage
  printed, not a cookie-specific string — so no later advisory has to re-open this question.
