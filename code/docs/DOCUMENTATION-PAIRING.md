---
type: guide
skills: [doc-writer, global-workflow, domain-modelling]
model: opus
---

# CONTEXT.md and CLAUDE.md — the pairing standard

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

Every directory in this repository that orients Claude carries two files. This guide owns the
line between them. `.claude/CLAUDE.md` §8 states the rule in one bullet and routes here for the
decision procedure; the `scaffold` and `doc-writer` skills generate against it, and
`code/src/scripts/audits/docs-pairing.sh` enforces the mechanical half.

## 1. The split, in one sentence

**`CONTEXT.md` says what is here and why it is here. `CLAUDE.md` says how to work here.**

Orientation is a description of a place. Operating rules are instructions to whoever arrives.
A reader who wants to know whether they are in the right directory reads `CONTEXT.md`; a reader
who has decided to work reads `CLAUDE.md`.

## 2. The decision test

Ask of any sentence: **would it still be true if nobody ever worked in this directory again?**

- **Yes** — it describes the place. It belongs in `CONTEXT.md`. _"`audits/` holds the host-run
  health checks; each covers its full scope on every invocation."_
- **No** — it constrains an actor. It belongs in `CLAUDE.md`. _"Fix real findings in source,
  never by loosening a threshold."_

Two reliable tells that a sentence has landed in the wrong file:

- **Modal verbs** — _must_, _never_, _always_, _do not_. A description does not need them.
  Rewrite as a fact or move it.
- **A second person, stated or implied** — _read X first_, _run Y before Z_. Reading order is
  an instruction, however useful it is on arrival.

The test is about the sentence, not the subject. "The numbers here are frozen identifiers,
never renumbered" is a rule; "these numbers are identifiers, not a running order" is the same
knowledge as orientation, and is what `CONTEXT.md` should carry.

## 3. What `CONTEXT.md` holds

Four things, in this order. Only the first two are mandatory.

1. **An opening statement of what this directory is and why it exists.** Prose, one short
   paragraph. The _why_ is not optional — a directory whose reason for existing is unrecorded
   gets merged away or duplicated by the next person who cannot see the point of it. Free
   placement: the opening paragraph is the usual home, but a directory whose rationale is
   genuinely per-entry may carry it in the tree annotations instead.
2. **A `## Directory Tree`** — a fenced ` ```text ` block whose first line is the directory path
   with a trailing `/`. Every top-level row carries a `←` annotation saying what that entry is.
   The fence format is load-bearing: `code/src/scripts/development/sync-trees.sh` reconciles
   membership against disk and only recognises a block in this shape.
3. **A what-is-here table** where the tree annotations are too short to carry the meaning — a
   `## Files`, `## Sub-layers`, or `## Subdirectories` table with a purpose column.
4. **`## Cross-references`** — the sibling and parent documents a reader continues to.

Sections that explain **why the structure is the way it is** are welcome and encouraged —
`## Why three scripts and not one`, `## Where the mobile surface sits, and why`. Rationale is
orientation of the highest value.

## 4. What `CLAUDE.md` holds

A fixed shape, scaled to the folder — a leaf stays short, a layer root is fuller:

```text
@./CONTEXT.md
@./REFERENCES.md          ← only where a REFERENCES.md exists in this directory

# CLAUDE.md — <path>/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(<what it gives you>, imported above) → this file → <what comes next>.

## Purpose (one line)
## How to work here      ← routing, model allocation, concrete steps, definition of done
## Guardrails
## Output & naming
```

The `@./CONTEXT.md` import is what keeps the tree auto-loading on navigation. **Never leave a
bare import stub** — a `CLAUDE.md` that is only an import is the convention retired on
03/07/2026. **Never put a directory tree in a `CLAUDE.md`**: it is imported from the file that
owns it, and a second copy drifts.

## 5. The sections that must not appear in a `CONTEXT.md`

Each of these is an instruction wearing an orientation heading. The right-hand column is where
it goes instead.

| Heading in a `CONTEXT.md`                                     | Move it to                                                                   |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `## Rules` · `## Guardrails` · `## Constraints`               | `CLAUDE.md` → **Guardrails**                                                 |
| `## Requirements` · `## Prerequisites` · `## Quality gates`   | `CLAUDE.md` → **How to work here** (as the entry condition of the procedure) |
| `### Hard gates — read before executing Step 1`               | `CLAUDE.md` → **How to work here** (reading order is an instruction)         |
| `## Standards` · `## Global constraints`                      | `CLAUDE.md` → **Guardrails**, or the owning `docs/` guide (§6)               |
| `## Conventions` · `## Naming conventions` · `## File naming` | `CLAUDE.md` → **Output & naming**                                            |
| `## How to work here` · `## Definition of done`               | `CLAUDE.md` → the section of that name                                       |
| `**Claude Model:** <tier>` metadata line                      | `CLAUDE.md` → **How to work here**, the `**Model:**` bullet                  |

**A dependency list is not a requirement.** "`cloc.sh` needs `wc` and `find`" is still true if
nobody ever runs it — it describes the script. Head that table `## Dependencies`, which is not
banned, rather than `## Requirements`, which invites the entry-gate content the ban is aimed at.

Three headings that look like rules and are not, so they stay:

- **`## When to use this` / `## When to read this`** — a statement of what the directory is for,
  which is the "why" in §3.1 written as a trigger. Keep it descriptive: _"use this workflow when
  reviewing code before a PR"_, not _"you must run this before every PR"_.
- **`## Do not use for`** — the boundary of the directory. It describes what is **not** here and
  routes elsewhere, which is orientation. It is not a prohibition on conduct.
- **`## Dependencies`** — what the things in this directory need in order to work, as above.

`## Key concepts` is the common trap. Domain facts belong there — _"OWASP A01–A10 are the
security baseline"_, _"the coverage floor is 75% line and branch, 90% auth"_. The moment a bullet
acquires _must_ or _never_ it is a guardrail, and a guardrail stated twice in two wordings is the
drift this standard exists to prevent.

## 6. Route, do not restate

Where a rule already has an owner — a `docs/` guide, a workflow's `STEPS.md`, `.claude/CLAUDE.md`
§6 — the `CLAUDE.md` **cites the owner and does not repeat the substance**. A coverage floor
written into forty `CLAUDE.md` files is forty things to change when the floor moves, and
thirty-nine of them will be missed.

- **Good** — _"coverage floors met (`code/docs/testing/COVERAGE.md`)"_.
- **Bad** — _"coverage floors met: 75% line and branch, 90% auth"_ in a file that does not own
  the number.

Restate only where the rule has **no other owner** and this directory is where it is decided.
That is the test for whether a `CLAUDE.md` bullet is carrying its own weight.

## 7. The two exceptions to the pairing

- **The repository root.** `/CLAUDE.md` is gitignored — `code-review-graph install` generates one
  there. `.claude/CLAUDE.md` is the root's operating-rules counterpart to the root `CONTEXT.md`.
- **Generated-output directories.** The `reports/` folders under `code/src/scripts/**` carry a
  `CONTEXT.md` and no `CLAUDE.md`: their only operating rule is _generated, never hand-edit_, and
  the `CONTEXT.md` already says so. A `CLAUDE.md` there would hold one sentence.

Every other directory carrying a `CONTEXT.md` carries a `CLAUDE.md`, and every `CLAUDE.md` has a
`CONTEXT.md` beside it.

## 8. How it is enforced

| Check                                                                | Tool                                            | Tier |
| -------------------------------------------------------------------- | ----------------------------------------------- | ---- |
| Pairing present both ways; the two exceptions honoured               | `audits/docs-pairing.sh`                        | fail |
| `CLAUDE.md` opens with `@./CONTEXT.md`, has `Read order:` + four H2s | `audits/docs-pairing.sh`                        | fail |
| No directory tree inside a `CLAUDE.md`                               | `audits/docs-pairing.sh`                        | fail |
| `CONTEXT.md` has a `## Directory Tree` fence                         | `audits/docs-pairing.sh`                        | fail |
| No banned heading from §5 in a `CONTEXT.md`                          | `audits/docs-pairing.sh`                        | fail |
| Tree membership matches disk                                         | `development/sync-trees.sh`                     | fail |
| Every top-level tree row annotated, no `TODO` left behind            | `development/sync-trees.sh` · `docs-pairing.sh` | fail |
| The opening _why_ paragraph is present and says something            | reviewer judgement                              | —    |

The last row is deliberately not mechanical. A script can prove a paragraph exists; only a reader
can tell whether it explains anything. Treat a `CONTEXT.md` whose opening restates the directory
name as unwritten.

## Governing procedures (route here — do not restate at length)

- `project-management/workflows/21-implementation-documentation/` — the closeout that updates
  every touched `CONTEXT.md`/`CLAUDE.md` pair and refreshes the graph
- `how-to/workflows/09-write-operator-guide/` — the operator-doc counterpart for `how-to/`

## Cross-references

- `.claude/CLAUDE.md` §8 — the one-bullet statement that routes here
- `.claude/skills/scaffold/SKILL.md` · `.claude/skills/doc-writer/SKILL.md` — the skills that
  generate pairs
- `code/src/scripts/audits/docs-pairing.sh` — the mechanical gate
- `code/src/scripts/development/sync-trees.sh` — tree membership and annotation reconciliation
- `.claude/skills/domain-modelling/SKILL.md` — recording a new term in the nearest `CONTEXT.md`
