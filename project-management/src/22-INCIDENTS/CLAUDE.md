@./CONTEXT.md

# CLAUDE.md — src/22-INCIDENTS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(naming, the PII rule, why it is not per-story, the index — imported above) → this file →
`how-to/docs/INCIDENT-PRACTICE.md` (the practice this folder records).

## Purpose (one line)

The PII-free incident register — one `INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md` per declared incident
plus the `INCIDENT-INDEX.md` table, recording that it happened, how severe, and how it ended;
never the investigation.

## How to work here

- **Routing:** entries come from `how-to/docs/INCIDENT-PRACTICE.md` Section 6, usually via the
  `/incident` skill (`.claude/skills/incident/SKILL.md`) at stand-down. There is no workflow —
  an incident is unplanned, so its procedure is a guide, not a gate.
- **Model:** Opus — writing up a settled incident is an implementation-phase touch, not planning.
- **Concrete steps:** copy `INCIDENT-000-TEMPLATE.md` →
  `INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md` (declaration date) → fill metadata, the plain-English
  summary, the outline timeline, outcome, follow-ups and the tracker reference → **add the row to
  `INCIDENT-INDEX.md`** → route every follow-up to a real home (`../20-BUGS/`, `GAPS.md`,
  `DEFERRED.md`, `code/docs/security/`) → update the status in place as it moves.
- **Definition of done:** entry named to convention with a real `DD-MM-YYYY` declaration date; a
  severity from the project's incident-response policy; an index row whose status matches the
  file; at least one follow-up action with an owner and a home outside this folder; British
  English throughout.

## Guardrails

- **No personal data. No credentials. No log excerpts. No stack traces.** This is the folder's
  reason for existing in this shape — it is in git, it is readable by everyone with repo access,
  and it ships. Substance goes to `<%INCIDENT_TRACKER%>`, or outside the repository where a
  project has no tracker. **Never relax this to make a report fit.**
- **Never restate the severity scale here.** P1–P4 are defined by the project's
  incident-response policy, drafted by the `msp-scp-documents` skill
  (`.claude/skills/msp-scp-documents/INCIDENT-CONTINUITY.md`). Two scales drift; route to the one.
- **Blameless.** Entries address process, systems and controls — never an individual, by name or
  by implication. This mirrors `code/docs/security/MONITORING-AND-INCIDENT.md` and is not
  negotiable in a register that ships.
- **Never back-date or rename a filed entry.** The declaration date is load-bearing for the audit
  trail; supersede with a new entry rather than editing history. Statuses change in place;
  timelines do not.
- **An entry is not a bug report.** A defect the incident surfaced gets its own
  `../20-BUGS/BUG-*.md` with a regression test; this folder records the outage, not the patch.
- **Every developer command is a project script** under `code/src/scripts/**/*.sh` — never raw
  pytest / pnpm / docker / python.
- Instructional files here stay ≤ 300 code lines; `INCIDENT-000-TEMPLATE.md` and the filed
  entries are artefacts and exempt.

## Output & naming

- **Hand-written:** every `INCIDENT-*.md`, from `INCIDENT-000-TEMPLATE.md`, plus the rows in
  `INCIDENT-INDEX.md`.
- **Template:** `INCIDENT-000-TEMPLATE.md` — the copy source; do not delete or repurpose.
- **Generated:** none.
- Filename `INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md`; descriptor in `SCREAMING-KEBAB-CASE`; the date
  is the declaration date; dates inside a file are written DD/MM/YYYY. There is no `US###` form.
