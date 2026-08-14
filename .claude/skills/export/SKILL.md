---
name: export
description: >-
  Implement downloadable file exports for <%PROJECT_NAME%> — the formatter and service layer
  that turns query results into a CSV, Excel, PDF or JSON download, with PII gated on the
  reader's permissions and every export audited. Load when a story needs data out of the system
  as a file, including a UK GDPR Article 15 subject data-access export. Not shaping the query
  or the report itself (`reporting`), not the button that triggers the download (`frontend`),
  and not whether a DSAR export satisfies data-protection law (`gdpr-mechanics`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow stack-django
---

# File Exports (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable procedure whose output is code). You slot a
formatter and service layer into an **existing** app; you do not own the surrounding feature.

The conventions are **not** here. `code/docs/EXPORTS.md` owns the library chosen per format, the
formatter contract, the PII rules and the localisation standard — read it first. This skill is
the order the work happens in.

---

## The brief arrives settled

A fork has no conversation behind it, so five answers must already be in it: the **format(s)**,
the **data scope** (which model, which rows), the **PII columns** and who may see them, the
**expected volume**, and **who may export at all**. If one is missing, return and say which — an
export that leaks is worse than an export that is late, and guessing the PII answer is how it
leaks. The caller settles them with a grilling pass (`.claude/CLAUDE.md` Section 10).

## Steps

1. **Read `code/docs/EXPORTS.md`**, then the target app's `CONTEXT.md` — its structure and its
   data sources — before writing a file into it.
2. **Locate the app.** Exports live beside the data: `apps/<app>/services/export/`, an
   `export_service.py` orchestrator plus one module per format, with PDF templates under that
   app's `templates/exports/pdf/`.
3. **Write the formatter to the contract** in `code/docs/EXPORTS.md` — rows plus an options
   dataclass in, bytes or stream plus content-type and content-disposition out. No request, no
   permission check, no PII decision inside a formatter.
4. **Gate and audit at the entrypoint.** Permission check first via a named Policy class; verify
   ownership of every supplied ID **before serialising a single row**; resolve PII visibility
   from the caller's permissions; emit the audit record on completion.
5. **Stream above the threshold** in `code/docs/PERFORMANCE.md`; buffer below it.
6. **Article 15 path**, where the reader is the subject: full decrypt, machine-readable JSON,
   and a metadata block carrying the export timestamp and request type.
7. **Localise the output** — <%LOCALE%> spelling in headers and labels, `DD/MM/YYYY`,
   <%CURRENCY%>, A4 for PDF.

## Definition of done

Every entrypoint permission-checked and ownership-verified; PII gated and audited; output
localised; a new dependency added through `how-to/workflows/07-dependency-updates/` rather than
a raw install; files within the 750-line source limit; the app's `CONTEXT.md` updated for any
new directory or module.

## Handoff

Report to the caller: the formats implemented, the PII handling applied, the files created, and
the download entrypoint. Name what still needs doing and who owns it — the trigger UI and its
accessibility, the DSAR legal check, the tests, the security and QA passes, and the story's
completion. This skill is a leaf: it does not sequence review, QA, docs or the commit.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/18-backend-code/` — the formatter and service layer
- `project-management/workflows/19-api-code/` — the download endpoint
- `project-management/workflows/09-gdpr-compliance/` — when the export is an Article 15
  data-access export
- `how-to/workflows/07-dependency-updates/` — adding the library a new format needs

## Cross-references

- `code/docs/EXPORTS.md` — the libraries, the formatter contract, PII gating, localisation
- `code/docs/API-DESIGN.md` — how the download entrypoint is exposed
- `code/docs/ENCRYPTION-GUIDE.md` — the Fernet pipeline, and decrypting only for an authorised reader
- `code/docs/security/AUDIT-TRAIL.md` — the audit record every PII export writes
- `code/docs/PERFORMANCE.md` — the row threshold above which CSV streams
