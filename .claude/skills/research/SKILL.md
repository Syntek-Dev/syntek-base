---
name: research
description: >-
  Investigate a question against high-trust primary sources — official docs, source code,
  specs, RFCs, and standards (OWASP/NIST/ICO/WCAG) — and capture a per-claim-cited Markdown
  note that feeds a decision. Invoke by typing /research, or when ADR groundwork, a
  stack-choice comparison, or a "how does X behave per the spec" question needs synthesis
  beyond one library's API docs (those go to context7).
---

# Skill: research ({{PROJECT_SLUG}})

Research answers a question the codebase cannot — a stack choice, ADR groundwork, or how a
spec actually behaves — by reading **primary sources** and leaving a per-claim-cited **note**
that a decision builds on. It is the reading tier beneath a decision: the note is the
deliverable, and the `ADR` or `PLAN` that consumes it links back.

**Boundary with `context7`.** For one library, SDK, or framework's own API — signatures,
config, a version migration — the `context7` MCP is the first and only stop
(`resolve-library-id` → `query-docs`). Reach for research when the question needs **synthesis
across primary sources** that no single doc answers: weighing two libraries for an ADR,
grounding a decision, or establishing how X behaves per the spec.

Locale: {{LOCALE}} · {{TIMEZONE}} · {{CURRENCY}} · dates DD/MM/YYYY.

## How to research

1. **Frame one answerable question.** Reduce the ask to a single question a note can settle,
   and confirm it needs synthesis rather than a lookup `context7` owns. Look facts up first —
   `code-review-graph` (structure) → Read/Grep/Glob → `.claude/plugins/*.py` — so the question
   is only what the codebase cannot answer itself. _Completion:_ the question is one sentence,
   and it is research, not a single-library API lookup.
2. **Delegate the reading to a background agent.** Dispatch the reading to a background agent
   (the general-purpose or Explore agent) with the question and the primary-source rule, so the
   main line of work continues while it reads. _Completion:_ the background agent is running
   with the question and the source rule, and the main work carries on uninterrupted.
3. **Follow every claim to its primary source.** Read the source that _owns_ each fact —
   official documentation, the library's own source, the specification or RFC, the standard
   (OWASP, NIST, ICO, WCAG). Treat a blog or write-up as a scout that points at the primary,
   never as the authority you cite. _Completion:_ every claim traces to a primary source, and
   none rests on a secondary write-up.
4. **Capture the note.** Write one Markdown note at `research/<TOPIC>.md`, each claim carrying its
   primary-source citation — a URL with its section, or a repo path with the line. Match any
   convention already in `research/`; yours is the first note if it is empty. _Completion:_ the
   note exists at that path and every claim carries a citation.
5. **Wire the note to its decision.** The consuming `ADR-###` (next free number is `a decision record`)
   or `PLAN-US###` links back to the note by path. When the research grounds a data-model
   decision, hand the outcome to `grill-with-docs` — its glossary-into-nearest-`CONTEXT.md`
   and three-test ADR gate record it (reference: `code/docs/data-structures/DOMAIN-MODELLING.md`).
   _Completion:_ the ADR or PLAN references the note.

## What counts as a primary source

Cite the source that owns the fact:

- Official product, framework, or vendor documentation.
- The library or service's own source code.
- A specification or RFC (W3C, IETF).
- A standard — OWASP Top 10, NIST CSF, ICO UK GDPR/PECR guidance, WCAG 2.2 (the index in
  `REFERENCES.md` holds the canonical URLs).
- A first-party API response or schema.

Secondary sources — blogs, Q&A threads, tutorials — are scouts only: they lead you to the
primary, and the citation you keep is always the primary.

## The note

Give each note these parts, so a reader reaches the verdict fast and can audit every claim:

- **Question** — the single question, verbatim.
- **Verdict** — the synthesised answer in a sentence or two.
- **Claims** — each finding on its own line, ending in its primary-source citation.
- **Sources** — the primary sources consulted, listed once.
- **Feeds** — the `ADR-###` or `PLAN-US###` this note grounds, plus the date (DD/MM/YYYY).

A durable finding that is _not_ tied to a decision — a reusable fact about the stack — belongs
in `.claude/MEMORY.md`, not a note.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/13-decisions/` — ADR groundwork
- `project-management/workflows/12-api-design/` — grounding a contract decision
- `project-management/workflows/03-database-schema/` — grounding a schema or stack choice

## Cross-references

- `.claude/skills/grill-with-docs/SKILL.md` — records a decision the research grounds (glossary
  - the three-test ADR gate).
- `code/docs/data-structures/DOMAIN-MODELLING.md` — the reference when a note feeds a data model.
- `research/` — the committed, synced home for research notes (`<TOPIC>.md`).
- the project's decision register — the ADRs a note feeds; next free number is `a decision record`.
- `the project's plans folderPLAN-US000-TEMPLATE.md` — the PLAN template a note may feed.
- `project-management/src/01-STORIES/US###.md` — a story a note may inform.
- `GAPS.md` · `DEFERRED.md` — open blockers, and items deferred to a named future story.
- `.claude/plugins/pm-tool.py` — read-only PM inspection (the next ADR number, the plan list).
- `.claude/MEMORY.md` — durable stack findings that are facts, not decisions.
- `REFERENCES.md` — the project's index of external primary sources (stack docs, OWASP, ICO,
  WCAG, NIST).
