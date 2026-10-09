# ADR-US008: Complete preview reports and an inactive pending cutover migration

**Status:** Superseded
**Date:** 09/10/2026
**Deciders:** <%DEVELOPER_NAME%> — approved remediation in this conversation
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md`; `project-management/src/15-DECISIONS/ADR-US008-MIGRATION-KEY-DUAL-GATED-17-09-2026.md`
**Superseded by:** `project-management/src/15-DECISIONS/ADR-US008-PENDING-MIGRATION-USES-YAML-FALSE-09-10-2026.md`
**Related:** US008 · `project-management/src/02-STORIES/US008.md` · `project-management/src/17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`

## Context

The accepted channel decision describes selecting migration banners from the preview log.
A banner alone omits the file, line, setting and operator guidance that the advisory promises.
The dual-gated decision also leaves the cutover entry without a version until release.
[Copier runs a migration without a version on every update](https://copier.readthedocs.io/en/stable/configuring/#migrations),
so a pending key must not accidentally create a second active unversioned advisory.
The adversarial review found both defects; the user authorised their remediation on 09/10/2026.

## Options considered

### Option A — banners and an executable entry awaiting its key

- **Summary:** retain the earlier implementation shape.
- **Pros:** smallest edit.
- **Cons:** loses the report body and repeatedly prints a notice intended for one release crossing.

### Option B — complete output and explicit inactivity until atomic activation

- **Summary:** replay the complete captured update output on success; keep the pending cutover entry disabled.
- **Pros:** works for existing advisories without new banner parsing; no unkeyed cutover execution.
- **Cons:** includes Copier progress output in the preview and requires release activation checks.

### Option C — introduce a separate advisory stream

- **Summary:** add framing or a dedicated report channel to every migration.
- **Pros:** can display only advisory bodies.
- **Cons:** expands the repair across shipped migrations and adds another protocol to maintain.

## Decision

Take Option B. P4 prints the complete captured stdout/stderr once in a labelled success block,
before the preview-only notice and before cleanup. It never selects only banners or truncates
advisory bodies. The existing failure branch still prints its tail once, exits 2 and removes the
log; the success block does not execute on failure. Advisories retain their no-values contract.

Keep the always-active, state-gated Domain advisory. P5 writes the cutover script and an entry
whose `when` is the literal false condition `"{{ false }}"`, with no placeholder version or
executable placeholder command. This disabled entry precedes staging cleanup. At release,
assign the actual version, rename/bind the script, and replace the false condition with the
normal after-stage predicate in one release commit. Tag that commit; do not tag a partially
activated state. Registry text labels the entry inactive until this activation.

The release proof checks: pending update emits no cutover notice; an activated crossing emits
it once; an update from at/above the release does not emit it again; the state advisory remains
independent. Prove these against disposable fixture refs before tagging and record the real tag
at release. Existing setting, edge, no-value and reporting-only decisions remain in force. The superseded
channel record's general rule remains binding: a story specifying a mitigation owns the channel
that delivers it. This successor changes the report selection and pending-entry lifecycle, not
that ownership rule.

## Consequences

- **Positive:** preview users receive complete remediation guidance; pending releases cannot repeat a cutover notice.
- **Negative / trade-off:** success output includes progress lines and release work must activate the entry explicitly.
- **Follow-on:** align the story, QA/security specs, plan and manual rows; carry the activation rule into the future release checklist edit. Runtime outcomes stay unmeasured until executed.
