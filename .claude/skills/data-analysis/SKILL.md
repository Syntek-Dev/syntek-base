---
name: data-analysis
description: >-
  Answer a question from <%PROJECT_NAME%>'s own data — read the schema, query it safely under
  row-level security, check the data's quality before trusting it, and return quantified
  findings with the code that produced them. Load when someone needs to know what the data says.
  Surfaces the numbers and recommends; never makes the business call, and never builds. Not the
  role-scoped report services (`reporting`), not the downloadable file (`export`), and not the
  pipeline or model the findings might justify (`backend`).
model: opus
metadata:
  skills: global-workflow grilling stack-django
---

# Analyse the Data (<%PROJECT_NAME%>)

**Task skill, inline** (axis 2 — the question, its segments and its grain come from the
conversation, and an analysis run against a guessed question is worse than none).

**Locale:** <%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%> on every figure, date and chart.

---

## Open with a grilling pass

Name what must be settled and wait — the round shape and the question format belong to the
`grilling` skill (`.claude/CLAUDE.md` Section 10). What has to be settled here:

- **The question** — stated precisely enough that a number can answer it.
- **The data sources**, the **segments**, and the **timeframe and grain**.
- **The output format and its audience.**
- **Whether PII is in scope at all**, and under what authorisation.

**Do not guess at missing data — document the gap.** A silently-imputed value is
indistinguishable from a measured one by the time it reaches a slide.

## Non-negotiables

- **RLS is on, and it fails quietly.** PostgreSQL row-level security returns an **empty
  result**, not an error, when the session context is unset — so an unset variable looks
  exactly like "there is no data". Confirm the scope session variables are set before trusting
  any count, or use an authorised admin-bypass role for cross-user work. **Never disable RLS.**
- **No IDOR in analysis.** Any user-supplied ID is scoped to its owner; a cross-user aggregate
  is documented as authorised for the stated purpose.
- **PII stays protected.** Do not decrypt, export or copy an encrypted column into a notebook or
  a report. Aggregate and anonymise, and state the handling.
- Secrets from the environment only; every database and dev operation through the project
  scripts.

## Method

1. **Data quality before anything else** — nulls, types, outliers, ranges, constraint
   violations. **An analysis of dirty data is a confident wrong answer**, and it is the failure
   mode nobody catches downstream because the arithmetic is correct.
2. **Exploration** — summary statistics, distributions, correlations, temporal patterns.
3. **Insight** — answer the question with specific figures, flag what is unexpected, and
   recommend. **The recommendation is not the decision** — surface the numbers and let the
   person with the context choose.

## Code standards

Python and Pandas: vectorise rather than loop, method-chain, type hints, docstrings. SQL: CTEs
for readability, no `SELECT *` in anything reused, **parameterise every query**, verify plans
with `EXPLAIN`, lean on the indexes that exist and **raise the ones that do not to `database`**.
Source files stay within the 750-line limit.

## Output

Return the findings in the conversation:

- **Executive summary** — two or three sentences.
- **Data overview** — the source, the record count, the date range, and the quality issues
  found.
- **Methodology** — brief.
- **Findings** — each with concrete figures in <%LOCALE%> and <%CURRENCY%>.
- **Recommendations** — actionable, and explicitly not decisions.
- **Code** — the analysis, runnable.

Where a written artefact is asked for, save it under `project-management/src/` with a
`SCREAMING-SNAKE-CASE.md` name and hand the user-facing polish to `doc-writer`.

## Handoff

Name what is owed: `backend` to implement a pipeline or model the findings justify, `database`
for an index or schema change, `reporting` where the question turns out to be a recurring
report rather than a one-off, `export` for a file, `doc-writer` for the write-up, and `story`
where the finding should become a piece of work.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** An analysis answers a question; it is not a gated product artefact
and has no numbered procedure. Do not route it into `code/workflows/`,
`project-management/workflows/`, or `how-to/workflows/` — those sequence building, and this
does not build.

## Cross-references

- `code/docs/RLS-GUIDE.md` — the policies, and the session context a query needs set
- `code/docs/DATA-STRUCTURES.md` — the domain models and the schema being queried
- `code/docs/ENCRYPTION-GUIDE.md` — why an encrypted column cannot be queried raw
- `code/docs/PERFORMANCE.md` — query cost, plans, and the indexes to lean on
- `code/docs/CODING-PRINCIPLES.md` — style, type hints, naming
- `.claude/plugins/db-tool.py` · `.claude/plugins/project-tool.py` — read-only orientation
