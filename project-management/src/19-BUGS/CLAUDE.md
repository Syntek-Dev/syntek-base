@./CONTEXT.md

# CLAUDE.md — src/19-BUGS/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(naming, record-tier position, report anatomy — imported above) → this file.

## Purpose (one line)

Bug reports — one `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md` per defect found while closing a
story, each carrying reproduction, root cause, the fix, a test-first regression test, and
verification, cross-linked to the `US###` it belongs to.

## How to work here

- **Routing:** file a report here from `code/workflows/07-debug/` when a defect is isolated,
  or during `project-management/workflows/20-pr-and-review/` / `10-qa-checks/` review, or
  from a production incident. Trace elusive defects through structured logs with
  `code/workflows/10-debugging-with-logs/`. The record is written during the code/PR phase;
  the fix itself lands in `code/` under the story's own branch — this folder records the
  defect, not the patch.
- **Model:** Opus — diagnosing a root cause, writing up the report, and flipping the status
  to `Fixed`/`Verified` are implementation-phase touches, not planning.
- **Concrete steps:** copy `BUG-US000-TEMPLATE.md` → `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`
  (or the story-less fallback for a cross-cutting defect) → fill metadata, summary,
  environment, numbered repro, Expected vs Actual, root cause, and the fix → **write the
  regression test first and watch it fail before the fix** (TDD, per `07-debug`) → link the
  story (`../01-STORIES/US###.md`) and its plan (`../15-STORY-PLANS/STORY-PLAN-US###-*.md`) →
  verify with `bash code/src/scripts/tests/all.sh`.
- **Definition of done:** report named to convention with a real `DD/MM/YYYY` discovery date,
  reproducible steps, a severity, a named target story, and a regression test seen to fail
  then pass; the full suite green; British English throughout.

## Guardrails

- **Documentation only — no code, diffs, secrets, `.env` content, or stack traces with
  credentials.** Redact any PII or token that appears in a repro.
- **Fix the root cause, not the symptom** — a report whose fix only masks the symptom is not
  done.
- **Never rename or back-date a filed report** — the date is the discovery date and is
  load-bearing for the audit trail; supersede with a new report if needed.
- **Every developer command is a project script** under `code/src/scripts/**/*.sh` — never
  raw pytest / pnpm / docker / python.
- One defect per file; do not append unrelated bugs to an existing report. This is not a
  memory or gaps store — active blockers go to `GAPS.md`, patterns to `.claude/MEMORY.md`.
  Every new directory needs a `CONTEXT.md` + `CLAUDE.md`; instructional files stay ≤ 300
  code lines (this template is exempt).

## Output & naming

- **Hand-written:** every `BUG-*.md` in this folder, from `BUG-US000-TEMPLATE.md`.
- **Generated:** none — any client-facing PDF is regenerated one level up in
  `project-management/export/`, never hand-edited here.
- Filename `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md` (story-anchored, primary) or
  `BUG-<DESCRIPTOR>-DD-MM-YYYY.md` (cross-cutting fallback); descriptor in
  `SCREAMING-KEBAB-CASE`; stories `US###`; dates DD/MM/YYYY.
