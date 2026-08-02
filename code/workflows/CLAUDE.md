@./CONTEXT.md

# CLAUDE.md — code/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(the twelve numbered workflows + their purpose table, imported above) → this file →
the target workflow's `CONTEXT.md`/`CLAUDE.md`.

## Purpose (one line)

The step-by-step coding procedures (`01`–`12`) that govern how anything in
`code/src/` is designed, written, tested, reviewed, and debugged — each a numbered
folder of `CONTEXT.md` (when to use), `STEPS.md` (ordered execution), and
`CHECKLIST.md` (verification).

## How to work here

- **Routing:** pick the workflow that matches the task (`01` full-stack feature,
  `02` TDD, `03` migration, `04` API, `05` MCP tool surface, `06` GDPR, `07` review,
  `08` security hardening, `09` log-debugging, `10` debug, `11` refactor, `12` Rust
  extension). Read its `CONTEXT.md` first; enter `STEPS.md` only when explicitly
  triggered. Backend steps run through the `stack-django` skill, frontend through
  `stack-htmx-templates`, MCP tools through `stack-fastmcp`, native code through
  `stack-rust` — all Opus.
- **Grill first:** every substantial workflow — design, code, test, QA, review, refactor —
  opens with a grilling pass; the owning agent loads `.claude/skills/grill-with-docs` and
  interviews <%DEVELOPER_NAME%> one question at a time before producing the artefact (`.claude/CLAUDE.md` §10).
  Only trivial/mechanical steps skip it.
- **Model:** Opus for authoring or revising a workflow and mechanical
  touches (renumbering, fixing a broken cross-reference, version headers).
- **Editing a workflow:** keep the three-file shape intact; every developer
  operation named in `STEPS.md` must invoke a `code/src/scripts/**/*.sh` script —
  never a raw `pnpm`, `next`, `pytest`, `python`, or `docker` command. Cross-link
  the governing `code/docs/` guide as a hard gate or soft reference.
- **Definition of done:** the workflow reads coherently end-to-end, its hard gates
  point at live docs, and this folder's `CONTEXT.md` still lists it correctly.
- **Routing frontmatter:** every `STEPS.md`/`CHECKLIST.md` here carries `workflow`/`phase`/`agent`/`skills`/`model` frontmatter — read it first and route accordingly (see `.claude/CLAUDE.md` §2.5).

## Guardrails

- **These are instructional `.md` files: ≤ 300 code lines each** (`cloc`); split an
  oversized workflow, do not let `STEPS.md` sprawl.
- Never let a workflow instruct a raw toolchain command — scripts only.
- Hard gates are load-bearing: a workflow that touches mutations must cite the
  permission-check / IDOR requirement; one that touches PII must cite field
  encryption; keep those references accurate.
- Do not add a thirteenth workflow without also registering it in `CONTEXT.md`,
  `code/REFERENCES.md`, and the root `REFERENCES.md` workflow index. A workflow that
  belongs to an optional surface also needs its `_exclude` entry in `copier.yml` and a
  flagged row in every index, exactly as `12-rust-extension` has.

## Output & naming

- **Hand-written:** every `CONTEXT.md`, `STEPS.md`, `CHECKLIST.md`.
- Workflow directories carry the `NN-kebab-case/` numeric prefix; the three files are
  fixed `SCREAMING-SNAKE-CASE.md` names. Stories/sprints referenced as `US###` /
  `SPRINT-##`.
