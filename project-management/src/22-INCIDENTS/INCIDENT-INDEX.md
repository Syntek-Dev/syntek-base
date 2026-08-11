# Incident Index

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> | **Language**: British English (en_GB)

One row per declared incident, **most recent first**. Add the row when the incident is
**declared**, not when it is resolved, and update the status in place as it moves.

> **PII-free, like every file in this folder.** A row says an incident happened and how it ended.
> Log excerpts, user identifiers and affected record counts go to `<%INCIDENT_TRACKER%>` — never
> here. Full rules: [`CLAUDE.md`](CLAUDE.md).

## The register

| Status                   | Sev | Incident | Summary | Raised | Resolved | Outcome | Tracker |
| ------------------------ | --- | -------- | ------- | ------ | -------- | ------- | ------- |
| _No incidents recorded._ |     |          |         |        |          |         |         |

## How to read a row

The first two columns lead deliberately — the question anyone opens this file with is _what is on
fire right now_, and both answers should be visible without reading a word of prose.

| Column       | Holds                                                                                                         |
| ------------ | ------------------------------------------------------------------------------------------------------------- |
| **Status**   | `🔴 Open` · `🟡 Monitoring` · `🟢 Resolved` · `⚫ Closed` (resolved **and** every follow-up landed)           |
| **Sev**      | `P1`–`P4`, from the project's incident-response policy. Record the **highest** it reached                     |
| **Incident** | A Markdown link to the entry file, labelled with its descriptor — e.g. `SEARCH-OUTAGE`                        |
| **Summary**  | One line, plain English, written for someone who was not there. No jargon, no component names alone           |
| **Raised**   | Declaration date, `DD/MM/YYYY`                                                                                |
| **Resolved** | Stand-down date, `DD/MM/YYYY`, or `—` while open                                                              |
| **Outcome**  | The decision that closed it — `Fixed` · `Rolled back` · `Workaround` · `No fault found` · `Provider resolved` |
| **Tracker**  | Reference in `<%INCIDENT_TRACKER%>`, or `—` where this project has none                                       |

## Two rules that keep the index honest

**`🟢 Resolved` is not `⚫ Closed`.** An incident is resolved when the symptom is gone; it is
closed when every follow-up action from its postmortem has landed somewhere real. The gap between
those two states is where the actual learning sits, and collapsing them into one status is how a
register stops being worth reading.

**`Workaround` as an outcome obliges a follow-up.** Standing down on a workaround is legitimate
and common — but the row stays `🟡 Monitoring` until the real fix ships, and the follow-up must
name where it is tracked. A `Workaround` row sitting at `⚫ Closed` is a filing error.

## Cross-references

- [`CONTEXT.md`](CONTEXT.md) — what this folder is and the PII rule behind it
- [`INCIDENT-000-TEMPLATE.md`](INCIDENT-000-TEMPLATE.md) — copy this per incident
- [`how-to/docs/INCIDENT-PRACTICE.md`](../../../how-to/docs/INCIDENT-PRACTICE.md) — declaring,
  running, handing over, standing down, writing up
