---
name: incident
description: >-
  Run a live incident alongside <%DEVELOPER_NAME%> — keep the timestamped notes, hold the clock,
  produce the seven-field handover when he has to stop, and write the blameless postmortem and the
  PII-free register entry at stand-down. Invoke by typing /incident, or when something is broken in
  staging or production and the response needs a scribe rather than another pair of hands on the
  keyboard. The practice it executes is `how-to/docs/INCIDENT-PRACTICE.md`.
---

# Skill: Incident (<%PROJECT_SLUG%>)

Something is broken in a live environment. This skill makes Claude the **scribe and the
timekeeper** while <%DEVELOPER_NAME%> stays commander — because the two things nobody remembers
afterwards are **what time it started** and **what was ruled out**, and both are cheap to capture
while expensive to reconstruct.

**The doctrine is not here.** It lives in
[`how-to/docs/INCIDENT-PRACTICE.md`](../../../how-to/docs/INCIDENT-PRACTICE.md) — what counts as
an incident, the two hats, the handover fields, the stand-down conditions, the postmortem shape.
This file is how Claude executes it with a human. Read the guide first; do not restate it.

> **Not `/handoff`.** That skill compacts a Claude session so a fresh agent resumes the work,
> writing to `handoffs/`. This one briefs a **human** mid-incident. Different reader, different
> urgency, different fields — and `/handoff` may still be needed here if the context window fills
> before the incident ends.

Locale: <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>.

## What this skill must never do

Read this before step 1. An incident is the worst possible moment for an agent to act
autonomously, because the blast radius is live and the human is under load.

- **Never change a live environment.** No deploy, no restart, no migration, no manual write, no
  configuration edit against staging or production — not even when the fix is obvious. Propose it,
  name the command, and wait. <%DEVELOPER_NAME%> executes.
- **Never write personal data, credentials, log excerpts or stack traces into the repository.**
  The register is PII-free by rule (`project-management/src/22-INCIDENTS/CLAUDE.md`). Where an
  excerpt matters, describe its shape and put the excerpt in `<%INCIDENT_TRACKER%>`.
- **Never decide the severity, the comms, or the stand-down.** Those are the commander's, and the
  regulatory ones are the project lead's. Claude recommends; the human decides.
- **Never name an individual** in any artefact this skill produces. Blameless is a property of the
  written record, not a sentiment.
- **Never guess a timestamp.** If a time is unknown, write `unknown` — a plausible invented time
  in a timeline is worse than a gap, because nobody can tell it is wrong later.

## Steps

### 1. Establish state, then help declare

Find out what is actually known before asking anything. Look it up — `code-review-graph`
(structure) → Read/Grep/Glob → `.claude/plugins/*.py` — and for dev, the logs via
`bash code/src/scripts/development/logs.sh`. Staging and production observability is
`code/workflows/09-debugging-with-logs/`; server access is the `<%DEPLOY_REPO%>` runbooks.

Then state, in three lines: what is broken, which surfaces, and what is already ruled out by what
you found. Recommend a severity against the project's incident-response policy and say why —
**<%DEVELOPER_NAME%> sets it.**

Open the running notes immediately, in the conversation, as a timestamped list. Do not create a
file yet: an entry started mid-outage is invariably abandoned half-finished, and the register is
written at stand-down (`INCIDENT-PRACTICE.md` § 6).

**Done when:** a severity is set by <%DEVELOPER_NAME%>, and the notes have a first line carrying a
real timestamp and a one-line statement of the symptom.

### 2. Keep the notes and hold the clock

This is the whole job for as long as the incident runs.

- **Append a timestamped line for every finding, action and dead end.** Never rewrite an earlier
  line — append a correction with its own timestamp.
- **Mark every dead end explicitly as `Ruled out: <theory> — <evidence>`.** This is the field the
  handover turns on; a theory dismissed in conversation and not written down will be retried.
- **Every 20 minutes, interrupt.** State the elapsed time, the current theory, and ask whether it
  is still worth pursuing. That prompt is the deliverable, not a courtesy — the commander's job is
  the one that degrades first when the responder's head is in a log file.
- **Track what is still in flight** — anything started that has not finished, and what it will do.

**Done when:** the notes' last line is never more than 20 minutes older than the conversation.

### 3. Investigate under direction

Route diagnosis to `code/workflows/09-debugging-with-logs/`, cheapest signal upward. Read freely;
propose freely. Restrict yourself to read-only inspection of anything live, and hand every
state-changing command to <%DEVELOPER_NAME%> with what it will do and what it cannot be undone by.

Before any manual database write is proposed, name the backup first:
`bash code/src/scripts/database/backup.sh`. Taking it afterwards is not an option.

**Done when:** each proposal names the command, its effect, and its reversal — and no live change
has been made by Claude.

### 4. Produce the handover the moment it is asked for

<%DEVELOPER_NAME%> is stopping and it is not fixed. Assemble the seven fields from
`INCIDENT-PRACTICE.md` § 3 — state now, severity and declaration time, what is confirmed, **what
is ruled out and how**, what is still running, what is being said publicly, and the next thing you
would try. Attach the running notes whole; never summarise them.

Where the incident is P1 or P2, this is **mandatory** before stopping, not optional.

**Done when:** all seven fields are written, field 4 lists every dead end from the notes, and the
notes are attached in full.

### 5. Check the stand-down conditions

When <%DEVELOPER_NAME%> proposes standing down, check all three from `INCIDENT-PRACTICE.md` § 4 and
say plainly which hold: symptom verified gone **from outside**, manual changes reverted or
recorded, status page current. Say so when one does not — a premature stand-down is a second
incident with a worse start.

If the resolution is a workaround, state that the outcome is `Workaround`, the status stays
🟡 Monitoring, and the real fix becomes follow-up action one.

**Done when:** each of the three conditions is explicitly held or explicitly waived by
<%DEVELOPER_NAME%>, and the stand-down time is in the notes.

### 6. Write it up

Now, while the notes are fresh — not tomorrow.

1. **Draft the postmortem** to the six sections in `INCIDENT-PRACTICE.md` § 5. The root cause
   answers **two** questions: what broke, and why it reached a live environment uncaught.
2. **Create the register entry** — copy
   `project-management/src/22-INCIDENTS/INCIDENT-000-TEMPLATE.md` to
   `INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md` using the **declaration** date. Fill it from the notes.
3. **Re-read it for PII, credentials, identifiers and log excerpts before writing the file.** This
   is a distinct pass, not a habit of mind. Anything that fails it goes to `<%INCIDENT_TRACKER%>`
   and the entry references it.
4. **Add the row** to `INCIDENT-INDEX.md`, most recent first, status matching the file.
5. **Route every follow-up to a real home** — a defect to `project-management/src/20-BUGS/`, an
   architectural gap to `GAPS.md`, deferred work to `DEFERRED.md`, a missing control to
   `code/docs/security/`. At least one, always.

**Done when:** the entry exists, the index row matches it, the PII pass has been run explicitly,
and every follow-up names an owner and a home outside `22-INCIDENTS/`.

## Reference

### Who decides what

| Decision                                       | Whose                                        |
| ---------------------------------------------- | -------------------------------------------- |
| Severity, comms, stand-down                    | <%DEVELOPER_NAME%> as commander              |
| Regulatory notification, personal-data verdict | The project lead — never Claude, never alone |
| Any change to a live environment               | <%DEVELOPER_NAME%>, executed by him          |
| The timeline, the ruled-out list, the drafting | Claude                                       |

### When this skill is the wrong tool

- **Nothing is live yet** — a failing test or broken build is `how-to/workflows/08-debugging/`.
- **The cause is known and it is a defect** — go straight to `code/workflows/10-debug/` and file
  in `project-management/src/20-BUGS/`.
- **Writing the incident-response _policy_** — that is the `incident-response-plan-writer` agent
  with `.claude/skills/msp-scp-documents/`. This skill runs an incident; that one documents what
  the organisation promises about them.
- **The context window fills mid-incident** — use `/handoff` as well, for the Claude half.

## Governing procedures (route here — do not restate at length)

**No governing workflow, deliberately.** An incident is unplanned, so its procedure is a guide
plus this skill rather than a gated `workflows/NN-…/` triad — the same class as `handoff`,
`prototype` and `teach`. Giving a person under pressure three places to look is the failure the
guide exists to prevent.

Two procedures are reached _from_ an incident and keep their own gates:

- `code/workflows/09-debugging-with-logs/` — finding the cause, cheapest signal upward
- `code/workflows/10-debug/` — fixing a defect the incident surfaced, failing test first

## Cross-references

- [`how-to/docs/INCIDENT-PRACTICE.md`](../../../how-to/docs/INCIDENT-PRACTICE.md) — the doctrine
  this skill executes; the guide owns every rule, this file owns the interaction
- `project-management/src/22-INCIDENTS/` — the PII-free register, its index and its template;
  `CLAUDE.md` there carries the writing rules
- `code/docs/security/MONITORING-AND-INCIDENT.md` — the build-side controls, what must be logged,
  and the breach-notification duty
- `code/docs/logging/HEALTH-CONTRACT.md` — what reports the system unhealthy, and the status page
- `.claude/skills/handoff/SKILL.md` — the other handover: Claude session continuity
- `.claude/skills/runbook/SKILL.md` — the craft `INCIDENT-PRACTICE.md` is written to
- `.claude/agents/incident-response-plan-writer.md` · `.claude/skills/msp-scp-documents/INCIDENT-CONTINUITY.md`
  — the policy side, which owns the P1–P4 scale this skill routes to
- `code/src/scripts/development/logs.sh` · `code/src/scripts/database/backup.sh` ·
  `code/src/scripts/database/restore.sh` · `code/src/scripts/database/verify-db-security.sh` —
  the scripts an incident actually reaches for
- `GAPS.md` · `DEFERRED.md` · `project-management/src/20-BUGS/` — where follow-ups land
