---
type: guide
skills: [runbook, global-workflow]
model: opus
---

# Incident Practice — Running One, Handing It Over, Writing It Up

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — the operator's half of incident response: declare, run, hand over,
stand down, write up

## Purpose

What you do while a live environment is broken, and what you write down afterwards. Reach for
this the moment something is wrong in staging or production and you are the one dealing with it.

Type `/incident` to have Claude run this with you — `.claude/skills/incident/SKILL.md`.

## What this does not cover

| Not here                                             | Owner                                                                              |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------- |
| The incident-response **policy** — P1–P4, ICO duties | `.claude/skills/msp-scp-documents/INCIDENT-CONTINUITY.md`                          |
| **Detecting** that something is wrong                | `code/docs/logging/HEALTH-CONTRACT.md` — Gatus, the public status page, Prometheus |
| **Diagnosing** the cause                             | `code/workflows/09-debugging-with-logs/`, then `code/workflows/10-debug/`          |
| The **defect** record and its regression test        | `project-management/src/20-BUGS/`                                                  |
| Security controls, and the breach-notification duty  | `code/docs/security/MONITORING-AND-INCIDENT.md`                                    |

This guide owns one thing the others do not: **the human process around the outage** — who
declares it, what gets said, what is written down when you stop, and what survives afterwards.

## Prerequisites

- [ ] You can reach the environment's logs — `bash code/src/scripts/development/logs.sh` on dev;
      the `<%DEPLOY_REPO%>` runbooks for staging and production
- [ ] You know the severity scale — read the project's incident-response policy **before** you
      need it, not during
- [ ] You know where `<%INCIDENT_TRACKER%>` lives, or that this project has none and the register
      is the whole record

---

## 1. Declare

**Declaring is free; not declaring is expensive.** The cost of declaring an incident that turns
out to be nothing is a register row. The cost of not declaring one is that nobody else knows it
is happening and nothing is written down.

Declare when **any** of these is true:

- A user-facing surface is down, erroring, or serving wrong data in staging or production.
- Personal data, credentials, or the audit trail may have been exposed or altered.
- You are about to take a manual, irreversible action against a live database.

Assign a severity from the project's incident-response policy — **P1–P4**, defined there and
nowhere else. Two operator consequences follow from it, and only these two live here:

| Severity  | What it obliges you to do                                                               |
| --------- | --------------------------------------------------------------------------------------- |
| **P1–P2** | Update the public status page. A **handover is mandatory** if you stop before it is out |
| **P3–P4** | No status-page duty. Register entry at stand-down is still required                     |

**Suspected personal-data breach? Stop and read** `code/docs/security/MONITORING-AND-INCIDENT.md`
first. The clock on the regulatory duty starts at discovery, not at resolution, and it is shorter
than most incidents.

**Success looks like:** a severity, a one-line statement of what is broken, and a timestamp — in
your running notes, before you start fixing anything.

## 2. Run it

Two hats, even when one person is wearing both. Name which one you have on when you switch.

- **Commander** — decides, communicates, keeps time. Does not have their head in a log file.
- **Responder** — investigates and fixes. Does not answer questions from outside.

Solo? You are commander first. Set a timer for every 20 minutes and use it to step back out of
the logs and ask whether the current theory is still worth pursuing.

**Keep running notes from the first minute.** Not prose — a timestamped list, appended to, never
rewritten:

```text
14:02  P2 declared. /health/ready/ returning 503, database component
14:06  Ruled out: connection pool exhaustion. Pool at 4/20
14:11  Restored read traffic by ...
```

Timestamps make the postmortem timeline free. Writing it up afterwards from memory does not work,
and the two things you will not remember are **what time it started** and **what you ruled out**.

Diagnosis itself belongs to `code/workflows/09-debugging-with-logs/` — follow it from the cheapest
signal upward, and come back here when you have a cause or you have to stop.

**Success looks like:** a running note whose last line is never more than 20 minutes old.

## 3. Hand over

You are stopping and it is not fixed — end of the day, an escalation, or you have been at it too
long to be useful. **The handover is the deliverable, not a courtesy.**

> **Not the same as `/handoff`.** That skill compacts a Claude session so a fresh agent resumes
> the work (`.claude/skills/handoff/SKILL.md`, written to `handoffs/`). This is one human briefing
> another human mid-incident. Different reader, different urgency, different fields.

Write these seven, in this order:

1. **State now** — is it still degraded, and which surfaces?
2. **Severity** and when it was declared.
3. **What is confirmed** — what you know, with the evidence.
4. **What is ruled out**, and how. _This is the load-bearing field._
5. **What is running** — anything you started that is still in flight, and what it will do.
6. **What is being said** — the status-page wording, and who outside has been told.
7. **The next thing you would try**, and why.

Field 4 is why this format exists. Everything else the next person can rediscover in ten minutes.
A ruled-out theory costs them the same hour it cost you, and they will retry it, because it is the
obvious one — that is what made you try it too.

Hand over the running notes with it. Do not summarise them.

**Success looks like:** the person taking over does not ask you a question you already answered in
writing.

## 4. Stand down

Stand down when all three hold, not before:

- The user-facing symptom is gone, and you have verified it from **outside** the system — load
  the affected page, hit the affected endpoint. Not "the error stopped appearing".
- Whatever you changed by hand is either reverted or recorded (see _Rollback_).
- The status page says it is resolved, if it ever said it was not.

State the stand-down time in the running notes. That timestamp is the end of the timeline.

**A workaround is not a fix.** Standing down on a workaround is normal and correct — but it makes
the follow-up a **P3 at minimum**, and it must be the first line of the postmortem's follow-up
actions, not a footnote.

## 5. Write the postmortem

Within two working days, while it is still recoverable from the notes.

**Blameless, and mean it.** `MONITORING-AND-INCIDENT.md` already states the rule — reports address
process, systems and controls, never people. A postmortem naming an individual is a defective
postmortem, and it will be the last honest one anybody writes.

Six sections:

| Section               | What goes in it                                                                                              |
| --------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Summary**           | Two sentences: what broke, who it affected, how long                                                         |
| **Timeline**          | Straight from the running notes — detection, declaration, key findings, stand-down                           |
| **Impact**            | Surfaces affected, duration, and whether personal data was involved                                          |
| **Root cause**        | The cause, plus the reason it was not caught before it reached a live environment                            |
| **What went well**    | Genuinely — including anything that limited the damage, so it does not get refactored away                   |
| **Follow-up actions** | Each with an owner and a home. **At least one, always** — an incident with no follow-up was not investigated |

Route each follow-up to where work actually lives — a defect to
`project-management/src/20-BUGS/`, an architectural gap to `GAPS.md`, deferred work to
`DEFERRED.md`, a missing control to `code/docs/security/`. A follow-up recorded only in the
postmortem is a follow-up that will not happen.

**Where the postmortem itself lives depends on what it contains** — see below.

## 6. Record it

Two homes, and the split is not a filing preference:

- **`project-management/src/22-INCIDENTS/`** — the **PII-free** register. That an incident
  happened, its severity, dates, outcome, status, and a reference to the tracker. It is in git,
  it is public to everyone with repo access, and it ships. Nothing sensitive goes in it, ever.
- **`<%INCIDENT_TRACKER%>`** — everything else. Log excerpts, user identifiers, affected record
  counts, screenshots, the full postmortem where it touches personal data or credentials.

Where a project has no tracker, the register is the whole record — which means the postmortem
must be written to the register's standard, or kept outside the repository entirely. Never
downgrade the PII rule to fit the report in.

Copy `INCIDENT-000-TEMPLATE.md`, add the row to `INCIDENT-INDEX.md`, and set the status. The
folder's `CLAUDE.md` carries the rules; this guide carries the reason.

---

## Failure modes

| What happens                                                | What to do                                                                                                       |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| You cannot tell whether it is really broken or just slow    | Declare P3 and start notes. Downgrade later — a downgraded incident costs a row                                  |
| Two people are both "fixing it" and changing the same thing | Stop. Name a commander. Concurrent uncoordinated fixes are how a P2 becomes a P1                                 |
| The fix worked but you cannot explain why                   | Do not stand down on it. An unexplained fix is a workaround; treat it as one (Section 4)                         |
| Notes have a 90-minute hole in them                         | Write "no notes 14:20–15:50, reconstructing" and reconstruct. Never back-fill silently                           |
| You realise mid-incident that personal data is involved     | Escalate severity immediately and go to `MONITORING-AND-INCIDENT.md`. The clock has been running since discovery |
| You are too tired to be making these decisions              | That is itself the finding. Hand over (Section 3), even to nobody — write it and stop                            |

## Rollback

**There is no deployment rollback script in this repository.** `code/src/scripts/deployment/`
ships empty — `deploy.sh`, `rollback.sh` and `health-check.sh` are named as planned in
`how-to/docs/tooling-guide/CONFIGURATION.md` and do not exist. This is recorded in
`how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`; it is a gap, not a decision.

So rollback during an incident is **manual, via the `<%DEPLOY_REPO%>` runbooks**, and this guide
will not pretend otherwise. Two things you can do here:

- **Database state** — `bash code/src/scripts/database/backup.sh` before any manual write, and
  `bash code/src/scripts/database/restore.sh` to reverse it. Take the backup _first_; you will
  not get a second chance.
- **Record every manual change as you make it**, in the running notes, with the exact command. An
  undocumented hand-edit to a live database outlives the incident by months.

## Verification

Prove it independently of the steps that got you here:

1. Load the affected surface from outside the network. Not the health endpoint — the actual page.
2. `bash code/src/scripts/database/verify-db-security.sh` if you touched the database by hand.
3. Confirm the register row exists and its status is current.
4. Confirm every follow-up action has an owner and a home outside the postmortem.

---

## Cross-references

- `.claude/skills/incident/SKILL.md` — `/incident`, which runs this guide with you
- `code/docs/security/MONITORING-AND-INCIDENT.md` — the security controls, the detection duties,
  and the breach-notification obligation
- `code/docs/logging/HEALTH-CONTRACT.md` — what reports the system is unhealthy, and to whom
- `code/workflows/09-debugging-with-logs/` · `code/workflows/10-debug/` — finding the cause,
  then fixing it with a regression test
- `project-management/src/22-INCIDENTS/` — the PII-free register and its template
- `project-management/src/20-BUGS/` — where a defect surfaced by an incident is recorded
- `.claude/skills/handoff/SKILL.md` — the _other_ handover: Claude session continuity, not this
- `.claude/skills/runbook/SKILL.md` — the craft this guide is written to

> Incident practice is the **operate** side; `code/docs/security/MONITORING-AND-INCIDENT.md` keeps
> owning the **build** side — the controls, what must be logged, and the regulatory duty. This
> guide owns what a human does while it is happening.
