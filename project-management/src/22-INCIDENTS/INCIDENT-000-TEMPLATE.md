# INCIDENT — {ONE-LINE PLAIN-ENGLISH TITLE}

_Template — copy to `INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md` (the **declaration** date), replace every `{PLACEHOLDER}`, delete the `[EXAMPLE]` rows. One declared incident, recorded so that someone who was not there can tell what happened and how it ended._

> **PII-free, without exception.** No personal data, no credentials, no log excerpts, no stack
> traces, no user identifiers, no record counts that identify anyone. This file is in git and it
> ships. The substance goes to `<%INCIDENT_TRACKER%>` — § 7 records where. A project with no
> tracker keeps the substance **outside the repository**; the rule is never relaxed to fit a
> report in. Full rules: [`CLAUDE.md`](CLAUDE.md).

> **Blameless.** Address process, systems and controls — never an individual, by name or by
> implication. "The deploy step had no confirmation prompt", not "{name} deployed the wrong tag".

| Field                      | Value                                                                      |
| -------------------------- | -------------------------------------------------------------------------- |
| **Severity**               | P1 / P2 / P3 / P4 — the **highest** it reached                             |
| **Status**                 | 🔴 Open / 🟡 Monitoring / 🟢 Resolved / ⚫ Closed                          |
| **Declared**               | {DD/MM/YYYY HH:MM}                                                         |
| **Stood down**             | {DD/MM/YYYY HH:MM} — or `—` while open                                     |
| **Environment**            | staging / production                                                       |
| **Outcome**                | Fixed / Rolled back / Workaround / No fault found / Provider resolved      |
| **Personal data involved** | Yes / No / Under assessment — **if Yes, see § 2**                          |
| **Tracker ref**            | {reference in `<%INCIDENT_TRACKER%>`} — or `—` where this project has none |
| **Last Updated**           | {DD/MM/YYYY}                                                               |

Severity is defined by the project's incident-response policy, not here.

---

## 1. Summary

Two sentences: what broke, who it affected, how long. Plain English — written for someone reading
this in a year with no memory of the system's internals.

_[EXAMPLE] The public site returned 503 for roughly 40 minutes on the evening of {date} because a
dependency of the readiness check became unavailable. Signed-in users could not load any page;
no data was lost or exposed._

## 2. Impact

| Aspect               | Value                                                    |
| -------------------- | -------------------------------------------------------- |
| **Surfaces**         | {which user-facing surfaces — pages, API, admin, mobile} |
| **Duration**         | {first symptom → stand-down}                             |
| **Who was affected** | {by role or category — never by identity}                |
| **Data**             | {lost / altered / exposed — or "none"}                   |

**If personal data was or may have been involved**, the regulatory assessment and any
notification live with the project lead per
[`code/docs/security/MONITORING-AND-INCIDENT.md`](../../../code/docs/security/MONITORING-AND-INCIDENT.md).
Record here only **that** the assessment happened and its outcome — never its contents.

## 3. Timeline

From the running notes, in outline. Times, not prose. Redact anything identifying.

| Time (HH:MM)      | Event                                   |
| ----------------- | --------------------------------------- |
| _[EXAMPLE] 21:04_ | _First alert — readiness check failing_ |
| _[EXAMPLE] 21:09_ | _P2 declared, status page updated_      |
| _[EXAMPLE] 21:31_ | _Cause identified_                      |
| _[EXAMPLE] 21:46_ | _Service restored; monitoring_          |
| _[EXAMPLE] 22:15_ | _Stood down_                            |

**Detection gap:** {time between the problem starting and anyone knowing} — state it even when it
is zero. It is the number that decides whether the follow-up is a fix or a monitoring change.

## 4. Root cause

The cause, **and** the reason it reached a live environment without being caught. Two questions,
both answered — an entry that answers only the first produces follow-ups that prevent nothing.

- **Cause:** {what actually broke}.
- **Why it was not caught:** {the gate, test, review or alert that would have caught it and did
  not exist, did not run, or did not fail}.

_Diagnosis itself is not recorded here — it lives in `code/workflows/09-debugging-with-logs/`
output and, where it produced a defect, in `../20-BUGS/`._

## 5. What went well

Genuinely, and specifically. Anything that limited the damage belongs on this list so that it does
not get quietly refactored away by someone who never knew it was load-bearing.

- _[EXAMPLE] The readiness endpoint failed closed, so the edge stopped routing traffic before
  users saw partial data._

## 6. Follow-up actions

**At least one, always.** An incident that produces no follow-up action was not investigated
thoroughly. Each one names an owner and a **home outside this folder** — a follow-up recorded only
here is a follow-up that will not happen.

| Action            | Owner            | Home                                          | Status |
| ----------------- | ---------------- | --------------------------------------------- | ------ |
| _[EXAMPLE] {fix}_ | _{agent / role}_ | _`../20-BUGS/BUG-<DESCRIPTOR>-DD-MM-YYYY.md`_ | _Open_ |
| _[EXAMPLE] {gap}_ | _{agent / role}_ | _`GAPS.md`_                                   | _Open_ |

Homes: a defect → `../20-BUGS/` · an architectural gap or blocker → `GAPS.md` · work deferred to a
named future story → `DEFERRED.md` · a missing security control → `code/docs/security/` · a
missing operational script → the relevant `code/src/scripts/` area.

**If the outcome was `Workaround`,** the real fix is the first row above and the status stays
🟡 Monitoring until it ships.

## 7. Where the substance lives

This entry is the summary. The investigation — log excerpts, identifiers, counts, screenshots, and
the full postmortem where it touches personal data — lives at the tracker reference in the
metadata table above.

- **Tracker:** {`<%INCIDENT_TRACKER%>` reference}, or `— none; substance held outside the
repository at {where, described without a path that leaks anything}`.

## 8. Sign-off

- [ ] Every `{PLACEHOLDER}` replaced and every `[EXAMPLE]` row deleted
- [ ] **Re-read for PII, credentials and log excerpts** — none present
- [ ] Blameless: no individual named or implied
- [ ] Severity matches the project's incident-response policy
- [ ] Root cause answers **both** questions in § 4
- [ ] At least one follow-up action, each with an owner and a home outside this folder
- [ ] Row added to [`INCIDENT-INDEX.md`](INCIDENT-INDEX.md) with a matching status
- [ ] `⚫ Closed` set only once **every** follow-up has landed

---

## Cross-references

- [`INCIDENT-INDEX.md`](INCIDENT-INDEX.md) — add the row; keep its status in step with this file
- [`how-to/docs/INCIDENT-PRACTICE.md`](../../../how-to/docs/INCIDENT-PRACTICE.md) — the practice
  that produced this entry: declare, run, hand over, stand down, write up
- `.claude/skills/incident/SKILL.md` — `/incident`, which runs that practice with you
- [`../20-BUGS/`](../20-BUGS/CONTEXT.md) — where a defect the incident surfaced is recorded
- [`code/docs/security/MONITORING-AND-INCIDENT.md`](../../../code/docs/security/MONITORING-AND-INCIDENT.md)
  — the security controls and the breach-notification duty
- `GAPS.md` · `DEFERRED.md` — homes for follow-up actions that are not defects
