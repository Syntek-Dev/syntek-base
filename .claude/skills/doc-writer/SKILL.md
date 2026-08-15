---
name: doc-writer
description: >-
  Write and maintain <%PROJECT_NAME%>'s developer documentation — docstrings and code comments,
  `CONTEXT.md` + `CLAUDE.md` pairs, the reference guides under `code/docs/`, workflow files, and
  README sections. Load when code has to be documented, a directory's context refreshed after
  files moved, or a developer guide authored. Not the guides a human executes to run the system
  (`runbook`), not end-user help for the product (`support-articles`), not generating the
  documentation shell itself (`scaffold`), and not a legal or compliance document
  (`legal-documents`, `msp-scp-documents`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling domain-modelling
---

# Write Developer Documentation (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable authoring task whose output is documentation).

**Developer-facing only.** The operator guides under `how-to/` belong to `runbook`: a different
reader — someone _running_ the system, usually mid-incident — and a different length standard,
since `how-to/src/` is exempt from the 300-line cap.

---

## The brief arrives settled

A fork cannot ask, so the brief must name **the document or the directory**, **its audience**,
and **what it must cover.** Where the shape of a non-trivial guide is genuinely open, that is a
`grilling` pass run inline first. A `CONTEXT.md` tree refresh or a docstring pass is mechanical
and needs neither.

## Two audiences, two rules — and this is the one most often broken

- **Markdown carries everything** — the what, the who, the how, the when, the where, and the
  history.
- **A comment or docstring inside a code file carries the _why_ only.** The code states the
  what; a **comment is one line** about why that line is there, a **docstring runs as long as
  its why needs** about why the unit exists; and **nothing points outward** — no story, sprint,
  ticket, PR, commit, `docs/` path, person, date, `TODO` or `FIXME`. Lengths and the full ban
  list: `code/docs/coding-principles/STYLE-AND-PROCESS.md`.

**A docstring pass that adds an `Args:` block or a documentation cross-reference is a
regression**, not an improvement: the typed signature already carries the arguments, and the
outward reference rots the moment the thing it names moves. Standard:
`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 4.

The one exception is **published interface text** — a Django Ninja endpoint's docstring and
`summary` render on the OpenAPI page, and a FastMCP tool's docstring is the prompt the model
reads. Both state the full what.

## The `CONTEXT.md` + `CLAUDE.md` pair

**Read `code/docs/DOCUMENTATION-PAIRING.md` before writing either file** — the test that
separates the two, the headings banned from an orientation file, and the route-don't-restate
rule. **Do not copy the shape of a sibling that may predate the guide.**

- **`CONTEXT.md`** — what the directory is **and why it exists**; a `## Directory Tree` fence
  with a `←` annotation on every top-level row; a what-is-here table where those annotations
  are too short to hold the meaning; `## Cross-references`.
- **`CLAUDE.md`** — opens with `@./CONTEXT.md` (plus `@./REFERENCES.md` where one exists), then
  a `Read order:` line, then four H2s: **Purpose (one line)** · **How to work here** ·
  **Guardrails** · **Output & naming**, scaled to the folder. **Never a bare import stub, and
  never a directory tree.**
- **Anything imperative is an operating rule wherever you found it** — a gate, a prerequisite, a
  reading order, a naming rule, a model tier. Verify with `audits/docs-pairing.sh`.

## How to work

1. **Read the target files and the folder's existing pair** before changing either.
2. **Confirm the real directory contents with Glob** before writing any tree or file table.
   **Never document a structure you have not verified on disk** — a wrong tree is worse than no
   tree, because it is believed.
3. Write or update, matching the surrounding style and the governing `code/docs/` guide. Refresh
   the tree, the `Last Updated` date, and any new pattern worth recording.
4. **A new concept gets its name recorded** in the nearest `CONTEXT.md` glossary as it settles
   (`domain-modelling`) — a name only in the conversation is re-derived differently next time.
5. Keep every instructional `.md` within **300 code lines** (`audits/docs-length.sh`, never
   `cloc.sh`, which excludes Markdown by design). Split an oversized file into focused
   sub-documents and leave the entry point a thin index. Root-level `*.md` and `**/src/*.md` are
   exempt — though a `CONTEXT.md` inside an exempt tree is still bound.

## Guardrails

- **Documentation is a hard gate.** The implementation records and every affected `CONTEXT.md`
  must be complete **before** any commit, with the code-review-graph refreshed alongside them.
- **Scripts, never raw commands** — every dev operation in documentation resolves to
  `code/src/scripts/**/*.sh`.
- Documentation files `SCREAMING-SNAKE-CASE.md`; source directories `kebab-case/`.
- **British English**, DD/MM/YYYY dates, <%TIMEZONE%>, <%CURRENCY%>.

## Definition of done

Every touched directory carries a present, consistent pair; trees and tables match disk;
cross-references resolve; no raw command appears; `docs-length.sh` and `docs-pairing.sh` clean;
British English throughout.

## Handoff

Report what was written and which trees were refreshed. Then name what is owed:
`code-reviewer` where the documented code looks wrong or stale, `test-writer` where a docstring
implies coverage that does not exist, `planner` where an architectural decision needs recording
rather than describing, `scaffold` where a whole new structure is needed, and `git` to commit.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/21-implementation-documentation/` — the closeout: the records,
  the findings, the `CONTEXT.md`/`CLAUDE.md` updates, and the graph refresh
- `code/workflows/07-review/` — documentation is a hard gate before review hands to the PR

## Cross-references

- `code/docs/DOCUMENTATION-PAIRING.md` — **the owning guide** for the pair
- `code/docs/CODING-PRINCIPLES.md` — the style and error-handling rules a docstring reflects
- `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` — Section 4, the comment and docstring rule
- `.claude/CLAUDE.md` Section 5 · Section 8 — the naming conventions and the length limits
- `code/docs/CODE-REVIEW-GRAPH.md` — the refresh that ships alongside a documentation change
- `how-to/docs/SKILL-AUTHORING.md` — the standard for the one documentation class this does not own
- `how-to/docs/AI-DICTIONARY.md` — the glossary a term is checked against before it is coined again
