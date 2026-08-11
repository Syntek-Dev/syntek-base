# project-management/src/22-INCIDENTS

The **PII-free incident register** — that an incident happened, how bad it was, and how it ended.
The base repo ships this folder as a scaffold: an index and one template a project copies per
incident. Nothing else lives here until an incident is declared.

**The practice this folder records is not here.** It lives on the operate side, in
[`how-to/docs/INCIDENT-PRACTICE.md`](../../../how-to/docs/INCIDENT-PRACTICE.md) — declaring,
running, handing over, standing down, and writing the postmortem. This folder is the residue that
survives in the repository afterwards.

## Directory Tree

```text
project-management/src/22-INCIDENTS/
├── CONTEXT.md                ← this file (orientation + the index rules)
├── CLAUDE.md                 ← operating rules
├── INCIDENT-INDEX.md         ← the scannable table: every incident, one row
└── INCIDENT-000-TEMPLATE.md  ← copy this to record an incident
```

## The rule that governs everything here

**No personal data, ever. No credentials, ever. No log excerpts.**

This folder is in git, it is visible to everyone with repository access, and it ships. A register
row says an incident happened and how it ended; the substance — log excerpts, user identifiers,
affected record counts, the full postmortem where it touches personal data — lives in the
project's incident tracker (`<%INCIDENT_TRACKER%>`), which has access control this folder does not.

A project with no tracker keeps the substance **outside the repository**. The rule is never
relaxed to make a report fit.

## Where this sits — a record, but not a per-story one

The `src/` folders run in three tiers, and `17-TESTS` … `21-REFACTORING` are all **per-story**
records: written after code ships, to close the loop on the story plan (16) a developer coded
from.

This folder is a record too, and deliberately **not** anchored to a story. An incident is not
caused by one story, is not scoped to one story, and frequently has no story behind it at all —
a certificate expiring, a disk filling, a provider outage. Where an incident does surface a
defect, that defect gets its own report in `20-BUGS/` and the two cross-reference.

It takes number **22** because the numbers here are frozen and append-only — see
[`../CONTEXT.md`](../CONTEXT.md) → _The numbers here are frozen_. It breaks the
workflow↔`src` mirroring, and that is expected: there is no workflow `22-incidents`, because an
incident is unplanned and its procedure is a guide plus the `/incident` skill, not a gated
workflow.

## What a register entry captures

Metadata (severity, declared, resolved, status, environment), a one-line summary written for
someone who was not there, the timeline in outline, the outcome decision, the follow-up actions
with their homes, and the tracker reference. It does **not** capture the investigation.

## The index

[`INCIDENT-INDEX.md`](INCIDENT-INDEX.md) carries one row per incident, ordered most recent first.
Status and severity lead the columns, because the first question anyone opens it with is _what is
on fire now_. Add the row when the incident is declared — not when it is resolved — and update
the status in place as it moves.

## When to write it

At **stand-down**, from the running notes — while the notes are still fresh. Not during the
incident: writing the register entry is not an incident-response activity, and an entry started
mid-outage is invariably abandoned half-finished.

## Cross-references

- [`INCIDENT-000-TEMPLATE.md`](INCIDENT-000-TEMPLATE.md) — the per-incident template
- [`INCIDENT-INDEX.md`](INCIDENT-INDEX.md) — the scannable index
- [`how-to/docs/INCIDENT-PRACTICE.md`](../../../how-to/docs/INCIDENT-PRACTICE.md) — the practice
- `.claude/skills/incident/SKILL.md` — `/incident`, which runs the practice with you
- [`../20-BUGS/`](../20-BUGS/CONTEXT.md) — where a defect surfaced by an incident is recorded
- [`code/docs/security/MONITORING-AND-INCIDENT.md`](../../../code/docs/security/MONITORING-AND-INCIDENT.md)
  — the build-side controls and the breach-notification duty
- `GAPS.md` · `DEFERRED.md` — where follow-up actions go when they are not defects

**Last Updated**: <%DATE%>
