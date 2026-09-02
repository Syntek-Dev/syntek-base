# ADR-US002: A gate whose scan scope excludes the work leaves the flag, rather than being re-scoped

**Status:** Accepted
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US002

---

## Context

A story's `QA` flag is a manifest of the gates that run for it
(`project-management/docs/planning/CADENCE.md`). US001 put four gates in its manifest and US002
inherited the same four. At `11-qa-checks` one of them was measured and found unable to see the
work at all.

**`doctrine-drift.sh` cannot open either file US002 edits.** Its scan roots at
`code/src/scripts/audits/doctrine-drift.sh:61-67` are exactly five trees — `code/docs`,
`.claude/skills`, `code/workflows`, `project-management/workflows`, `how-to/workflows`.
**`code/src/scripts/**` is in none of them.** US002 edits `code/src/scripts/audits/CONTEXT.md` and
`code/src/scripts/audits/CLAUDE.md`. The gate would have been run, would have exited 0, and would
have been ticked — having examined neither file.

**This is not the case US001 already settled.** That story met the same gate and kept it, and
`project-management/src/15-DECISIONS/ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` <!-- doc-references: template-only --> records
why: `doctrine-drift.sh` reads **fenced code only**, so it could not see US001's prose doctrine —
but it _did_ read US001's tree, and its three registered claims live in `code/docs`, which US001
was editing. Kept as a **regression guard**, it answered a real question: are the three claims
still one-homed after this change? Re-scoping was honest because the gate could still look.

US002 is a different failure. The gate is not blind to a _kind of content_ inside a tree it reads;
it is blind to the **tree**. There is no question it can answer about this story, so there is no
scope to narrow it to. `code/docs/GATE-REPORTING.md` names the resulting report exactly: a gate that
could not look, presented as a gate that looked and found nothing.

The distinction needs deciding once, because every later story inherits US001's four-gate manifest
by copying it, and the nine audit-registering stories this backlog has queued all edit
`code/src/scripts/audits/` — the tree this gate cannot see.

## Options considered

### Option A — Keep it and re-scope, as US001 did

- **Summary:** Leave `doctrine-drift.sh` in the manifest with a narrowed claim, as US001 narrowed
  it to a regression guard.
- **Pros:** One precedent instead of two; no divergence between neighbouring stories in one sprint.
- **Cons:** There is nothing to narrow **to**. US001's re-scoping worked because the gate still
  read the files under test; here the narrowed claim would be "no drift introduced elsewhere in the
  repository", which is true of any change that does not touch `code/docs` and is therefore not a
  check on this story. It reads as coverage and is not.

### Option B — Remove it from the flag, and record why

- **Summary:** Drop the gate from the story's `QA` value; state in the flag comment and the
  Verification Checks that its scan scope excludes the work, so it cannot examine either file.
- **Pros:** The manifest then lists only gates that can answer something. The reason travels with
  the story, so the next author copying this manifest inherits the measurement rather than
  repeating the mistake. Consistent with `code/docs/GATE-REPORTING.md`, which asks for the absent
  surface to be named rather than skipped silently.
- **Cons:** Two stories in one sprint now carry different manifests for the same gate, which reads
  as inconsistency until the reason is read. It also removes a cheap run — the gate costs seconds,
  and running it does no harm.

### Option C — Widen `SCAN_DIRS` to include `code/src/scripts`

- **Summary:** Fix the blindness rather than report it.
- **Pros:** The only option that produces the coverage the manifest implies.
- **Cons:** `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> slice `S-06` owns the
  first edit to the audit scripts and is blocked on its map's RESOLVE sitting. This is the third
  fix in two days routed away for that reason, and taking it here creates a second unreviewed
  editor of a file whose ownership is the thing being settled. It is also a wider change than it
  looks: `code/src/scripts/**` holds hundreds of files, and admitting the tree changes what every
  registered claim is measured against.

### Option D — Keep it, run it, and tick it

- **Summary:** Do nothing; the gate is green.
- **Pros:** None.
- **Cons:** This is the defect `code/docs/GATE-REPORTING.md` exists to prevent, written into a
  story's own criteria.

## Decision

**We will take Option B, and the rule generalises: a gate that cannot read the files under test
leaves the manifest; a gate that reads them but cannot decide part of the question stays, narrowed
to the part it can decide.**

The deciding factor is that a manifest is read as coverage. `CADENCE.md` makes the flag the gate's
entry condition, so a gate listed there is a gate a reader believes ran against this change. US001's
re-scoping preserved that meaning because the narrowed claim was still about US001's files; the same
move here would not, and a listed gate that answers nothing is worse than an absent one because it
is believed.

Option C is the correct repair and is not refused on merit — only on standing. It is already
recorded as an open gap; this record does not add a second.

**Removal is not silence.** The obligation this record creates is that the reason is written where
the gate would have been listed — in the flag comment and in the Verification Checks as an `N/A`
with its cause — never by deleting the line.

## Consequences

- **Positive:** A story's `QA` manifest becomes readable as what it claims to be: the gates that
  can answer a question about this change. The nine queued audit-registering stories inherit the
  measurement instead of re-deriving it.
- **Positive:** The line between this and US001's case is now written down, so neither record has
  to be read as overturning the other. They are the two halves of one rule.
- **Negative / trade-off:** US001 and US002 sit in one sprint with different manifests for the same
  gate. **US001 is left as it stands** — it was correct on its own measurement, and editing a
  signed-off story to match a later record would hide that the reasoning moved. This is the same
  disposition `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
  takes towards US001's flat must-pass, and for the same reason.
- **Negative / trade-off:** Nothing enforces this. No script compares a story's `QA` manifest
  against the scan scope of the gates it names, so the check is a human one at `11-qa-checks`.
- **Follow-on:** This record **retires if `SCAN_DIRS` gains `code/src/scripts`** through
  `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> slice `S-06` or its successor. At that point the gate can see the tree and belongs
  back in the manifest; a new record should supersede this one rather than editing it.
- **Follow-on:** The nine audit-registering stories all edit the tree this gate cannot read. Each
  should carry the same `N/A` with the same cause until the follow-on above lands.
