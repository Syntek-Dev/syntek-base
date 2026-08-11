@./CONTEXT.md

# CLAUDE.md — how-to/docs/skill-authoring/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(sub-doc list and reading order, imported above) → this file.

## Purpose (one line)

The skill-authoring sub-documents — `FORK-DECISION.md`, `FRONTMATTER.md`, `CRAFT.md` and
`SHIPPING.md` — split out of the `how-to/docs/SKILL-AUTHORING.md` index so each stays
under the instructional line limit.

## How to work here

- **Routing:** guide authoring → `global-workflow` and `runbook` skills. Always enter via
  the parent index `how-to/docs/SKILL-AUTHORING.md`; edit the sub-doc that owns the topic.
- **Model:** Opus — for substantive edits and for renames and link fixes alike.
- **Concrete steps:** edit the relevant sub-doc → keep `how-to/docs/SKILL-AUTHORING.md` a
  thin index → keep every command a `code/src/scripts/**/*.sh` reference → keep each file
  ≤ 300 code lines.
- **Definition of done:** the field set here matches what
  `code/src/scripts/audits/skill-conformance.sh` enforces; cross-references resolve;
  British English.

## Guardrails

- **The gate and this folder are two halves of one rule** — a change to the admitted field
  set is landed in the same commit as the change to `skill-conformance.sh`, or the guide
  and its enforcer contradict each other.
- **Say which claims are the specification's and which are this project's.** The spec
  defines six fields; the runtime reads more; the declines here are choices. Collapsing
  those three into one sentence is the defect this split was authored to remove.
- **No sub-doc lists its siblings** — the routing table lives once, in the index. A second
  copy drifts the moment a file is added.
- **The checklist checks; it never states.** A rule belongs to the one sub-doc that owns it;
  `SHIPPING.md`'s pre-ship list carries only its checkable form. Adding the reasoning there
  creates the second copy this split exists to prevent.
- **A measured claim keeps its number and its measurement together**, in the sub-doc that
  states the rule. A percentage quoted a second time is a percentage that will be re-measured
  once and corrected once.
- **≤ 300 code lines** per file; **script-first**, no raw `pnpm`/`uv`/`docker`/`python`.

## Output & naming

- **Hand-written:** all four sub-documents; nothing here is generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`; the folder is `kebab-case/`.
