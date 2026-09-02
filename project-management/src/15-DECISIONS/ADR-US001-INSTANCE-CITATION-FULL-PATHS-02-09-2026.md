# ADR-US001: PM artefacts cite instance artefacts by full repo-relative path

**Status:** Superseded
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** `project-management/src/15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md`
**Related:** US001

---

## Context

`code/src/scripts/audits/doc-references.sh` Check 2 bans a **shipped** file from citing a
per-project instance artefact — a story, sprint, ADR, map or plan — on the reasoning that the
reader of a generated project has no such file. The check does not test whether the citing file
ships. `copier.yml` <!-- doc-references: template-only --> line 152 excludes `/project-management/src/**`, re-including only `CONTEXT.md`,
`CLAUDE.md` and `*TEMPLATE*` files, so a story, a QA plan, a sprint record and an ADR are all
copier-excluded and none of them ships. The rule is therefore being applied to a tree it was not
written for.

It bites in practice. US001's first draft produced seven findings; the QA plan written for it
produced nine. Both times the citation was correct, resolvable, and to a file sitting a few
directories away.

The check has an existing escape that changes the answer: at `:677` it records a finding only
when the token does not resolve — `[ ! -e "$token" ]`. A bare `project-management/src/02-STORIES/US001.md` does not resolve from
the repository root and is flagged; the same citation written as
`project-management/src/02-STORIES/US001.md` resolves, and passes. The previous session did not
find this and worked around the gate by removing the backticks, which silences the check by
making the text stop being a citation at all.

## Options considered

### Option A — Strip the backticks

- **Summary:** Write the artefact name as plain prose so the gate never tokenises it.
- **Pros:** Immediate; no other file changes.
- **Cons:** The citation stops being a citation — not clickable, not machine-checkable, and not
  broken when the target moves. It also silences the gate on the whole class rather than routing
  around it, so the next reader cannot tell a deliberate suppression from an oversight.

### Option B — Cite by full repo-relative path

- **Summary:** Always write `project-management/src/02-STORIES/US001.md`, never `project-management/src/02-STORIES/US001.md`.
- **Pros:** Passes legitimately through the gate's own existence test rather than by evading it.
  The citation stays clickable and machine-verified, so a moved or renamed artefact **breaks the
  gate** — which is what a citation is for. Costs nothing but characters.
- **Cons:** More verbose in running prose. Leaves the underlying over-application in place, so the
  convention is load-bearing: a contributor who writes the short form still reddens the gate.

### Option C — Exempt `project-management/src/**` in the script

- **Summary:** Add an arm beside the existing `01-FEATURE-MAPS/*` exemption at `:333`.
- **Pros:** The correct fix — it makes the rule match its own stated reasoning.
- **Cons:** `doc-references.sh` is owned by `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> slice `S-06`, which is blocked on
  a RESOLVE sitting. Editing it here pre-empts that slice and creates a second, unreviewed editor
  of a file whose ownership is the very thing being settled.

### Option D — Do nothing

- **Summary:** Accept a red gate on every story, QA plan and ADR.
- **Pros:** None.
- **Cons:** A gate that is always red stops being read, which costs more than the citations do.

## Decision

**We will take Option B now, and Option C later through the slice that owns the script.** The
deciding factor is that B is the only option that keeps the citation doing its job: A destroys it
and C is not ours to write yet. B is also not wasted work if C lands — a full path passes the
exemption too, and reads better regardless.

Option C is recorded as an open gap on the same day as this record, so the interim does not
quietly become the permanent answer.

## Consequences

- **Positive:** Every PM artefact citation is resolvable and gate-checked. A renamed story breaks
  the build instead of leaving a dead reference. The convention is uniform across stories, QA
  plans, sprint records and ADRs.
- **Negative / trade-off:** Longer citations, and a convention enforced by a gate whose message
  does not explain it — a contributor writing a bare story filename is told they may not cite an instance,
  not that they should lengthen the path. That confusion persists until Option C lands.
- **Follow-on:** A `GAPS.md` entry dated 02/09/2026 records the script's over-application and
  routes the fix to `project-management/src/01-FEATURE-MAPS/MAP-RULE-OWNERSHIP.md` <!-- doc-references: template-only --> `S-06`. This record is superseded, not edited, if that
  slice resolves the rule differently.
