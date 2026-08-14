---
type: guide
skills: [export, stack-django]
model: opus
---

# File Exports

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus (the formatter contract, the library per format, PII gating and audit)

**Status: declared, not wired.** No formatter ships at baseline and none of the libraries below
is a declared dependency — the first story that needs a download adds the one format it needs
through the dependency procedure, not the whole set. What exists today is this contract.

An **export** is a query result turned into a file a person downloads: a CSV of rows, an invoice
PDF, a subject's own data under Article 15. It is the far end of the surface the reporting
services shape (`code/docs/architecture/SERVICE-AND-MIDDLEWARE.md`) — reporting decides _what the
numbers are_, export decides _what the file looks like_ — and the split matters because the
second is where personal data leaves the system.

## The library per format, and why each

The choice is recorded here rather than left to the implementer, because two formatters written
against two PDF libraries is two rendering models, two sets of brand CSS, and two failure modes.

| Format    | Library       | Why this one                                                                      |
| --------- | ------------- | --------------------------------------------------------------------------------- |
| **CSV**   | stdlib `csv`  | Streamed through a generator `HttpResponse` — no size ceiling and no dependency   |
| **Excel** | `openpyxl`    | Styled headers, auto-sized columns and multiple sheets without a native toolchain |
| **PDF**   | `weasyprint`  | A Django template renders to HTML, then to A4 — the brand CSS is already written  |
| **JSON**  | stdlib `json` | Pretty for a human reader, compact for a machine one                              |

**The PDF choice is the load-bearing one.** `weasyprint` makes a PDF a _template_, so an invoice
is authored the same way a page is and inherits `code/src/django/static/css/tokens/` rather than
a second set of literals. A drawing-primitive library would put the brand in two places, which
is the drift `code/docs/DESIGN-TOKENS.md` exists to prevent. The cost is honest and worth
stating: `weasyprint` pulls native libraries (Pango, cairo), so it lands in the image as well as
the lockfile.

A dependency is added through the procedure in `how-to/workflows/07-dependency-updates/` — never
a raw `pip` or `uv` call.

## The formatter contract

One orchestrator, one formatter per format, and the orchestrator is the only thing that knows
which formats exist:

- Exports live **beside the data** they serialise: `apps/<app>/services/export/`, with an
  `export_service.py` orchestrator and one module per format. PDF templates sit under that app's
  `templates/exports/pdf/`.
- **A formatter takes rows plus an options dataclass and returns bytes or a stream, a
  content-type, and a content-disposition.** Nothing else. It does not read the request, check a
  permission, or decide who may see a column — all three belong to the caller, and a formatter
  that reaches for them is a formatter that cannot be tested with a list of dictionaries.
- **The service routes by requested format** and streams CSV above the row threshold in
  `code/docs/PERFORMANCE.md`. Below it, buffering is simpler and the difference is unmeasurable.
- **The download entrypoint is an ordinary endpoint** and obeys `code/docs/API-DESIGN.md` — the
  file being a file changes nothing about the permission check.

### Which format for which data

| Data                          | Format             |
| ----------------------------- | ------------------ |
| Tabular, for analysis         | CSV / Excel        |
| A formatted report or invoice | PDF                |
| An API or integration payload | JSON               |
| A large bulk dataset          | CSV, streamed      |
| Subject data access (DSAR)    | JSON, full decrypt |

## Personal data is the whole risk

An export is a **bulk read with a filename**, which is what makes it a different security problem
from the endpoint that returns one record. Four rules, and none of them is the formatter's:

- **Permission check on every entrypoint** via a named Policy class (OWASP A01). There is no
  unguarded download route.
- **No IDOR.** Every user-supplied record ID is verified against the caller's ownership **before
  a single row is serialised** — not after, because a partially written stream has already
  disclosed.
- **PII is permission-gated.** Decrypt and include a Fernet column only for a reader holding the
  export permission; otherwise mask it or omit it. Never emit ciphertext raw — it is not a
  redaction, it is a copy of the ciphertext. The pipeline is `code/docs/ENCRYPTION-GUIDE.md`.
- **Every PII export is audited**, with the exporter's user ID, the data source, whether PII was
  included, the record count, and a hashed IP. Schema and write path:
  `code/docs/security/AUDIT-TRAIL.md`.

**A subject exporting their own data is the deliberate exception.** Under UK GDPR Article 15 the
reader _is_ the data subject, so the export full-decrypts, emits machine-readable JSON, and
carries a metadata block naming the export timestamp and the request type. Whether a given export
discharges the obligation is a data-protection question, not an implementation one —
`project-management/docs/GDPR-GUIDE.md` owns it.

## Localisation is part of the output

A file outlives the session that produced it and is read without the interface around it, so it
carries its own locale rather than inheriting one: <%LOCALE%> spelling in every header and label,
`DD/MM/YYYY` dates, <%CURRENCY%> amounts, and **A4** paper for PDF. A US-Letter invoice is a
visible defect in a British business and nothing in the test suite catches it.

## Cross-references

- `code/docs/API-DESIGN.md` — the endpoint the download is served from
- `code/docs/ENCRYPTION-GUIDE.md` — the Fernet pipeline, and what a decrypt costs
- `code/docs/security/AUDIT-TRAIL.md` — the audit record every PII export writes
- `code/docs/PERFORMANCE.md` — the row threshold above which CSV streams
- `project-management/docs/GDPR-GUIDE.md` — whether a DSAR export satisfies the law

_Part of the `code/docs/` documentation family._
