---
workflow: 14-logging-checks
phase: design
skills: [logging, gdpr-mechanics, global-workflow]
model: fable
---

# Logging Checks — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Every box must be ticked before `15-decisions/` may close this story's loop.

---

## Entry conditions

- [ ] The story's `Logging` flag is **not** `N/A` — otherwise this gate is skipped, and that is
      recorded in the flag row rather than left blank
- [ ] `13-api-design` complete — the endpoint list exists
- [ ] `04-database-schema` complete — the `[enc]` marks exist
- [ ] `code/docs/LOGGING.md` read

## Loggers and events

- [ ] Every module that logs has a row, with a named logger `logging.getLogger("apps.<app>")`
- [ ] No plan row permits the root logger, a bare `print()`, or a committed `console.*`
- [ ] Every event has a level, a trigger, and an **exhaustive** field list
- [ ] No field list reads "context", "the request", or any other unnamed set
- [ ] Every event has a real call site in the story's services or endpoints
- [ ] The `WARNING`/`ERROR` line is drawn where a human would actually act

## Exclusions — the point of the gate

- [ ] Every field marked `[enc]` in `DB-IDEA-US###-*.md` appears in the exclusions table
- [ ] Every PII attribute in `GDPR-PLAN-US###-*.md` appears in the exclusions table
- [ ] Each exclusion names both the **field** and the **surface** it is barred from
- [ ] The stack-trace question is answered: no reachable exception interpolates an excluded
      value into its message
- [ ] No safe-field row permits free-text user input

## Audit trail boundary

- [ ] No event that must survive, be tamper-resistant, or answer a legal request is planned as a
      log line — those are database writes (`code/docs/security/AUDIT-TRAIL.md`)

## Channels and retention

- [ ] Every channel the story writes to is listed with who can read it
- [ ] Retention is stated, or marked `TBD` **and** raised in the story's GDPR plan — never
      invented here

## Plan hygiene

- [ ] Plan copied from `LOGGING-PLAN-US000-TEMPLATE.md`, not written from scratch
- [ ] Saved to `src/14-LOGGING/PLANNING/LOGGING-PLAN-US###-<SCREAMING-KEBAB-DESC>.md`
- [ ] Every `[EXAMPLE]` row and `{PLACEHOLDER}` replaced
- [ ] Every `LOG-GAP-n` resolved, or fed back into `US###.md`
- [ ] The story's `### Logging Acceptance Criteria` matches this plan

## Nothing verified here

- [ ] **No sample log lines, no grep output, no Sentry issues** — this gate runs before the code
      exists; the evidence belongs to `22-implementation-documentation`

## Close-out

- [ ] Instructional `.md` files ≤ 300 code lines — `bash code/src/scripts/audits/docs-length.sh`
- [ ] British English throughout; dates DD/MM/YYYY
