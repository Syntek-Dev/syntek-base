---
type: guide
skills: [doc-writer, scaffold, global-workflow]
model: opus
---

# Instructional file length — the 300-line limit and the ratchet

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

This guide owns the length rule for files that instruct Claude Code. `.claude/CLAUDE.md`
Section 8 states it in one bullet and routes here; `code/src/scripts/audits/docs-length.sh`
enforces it. Its sibling is `DOCUMENTATION-PAIRING.md`, which owns the shape of a
`CONTEXT.md`/`CLAUDE.md` pair rather than its size.

## 1. The limit

An instructional `.md` file must not exceed **300 code lines**, measured by
`cloc --include-lang=Markdown`. Blank lines and HTML comments do not count — the budget is on
content, not formatting, so a table that breathes is not penalised.

Past about three hundred lines such a file stops being read and starts being skimmed, which is
the same as not being there. The remedy is always the same shape: split the detail into a
`kebab-case/` sub-folder and leave the entry point a thin index that cross-references the parts.

## 2. What is bound

Instructional means it tells Claude Code how to work — a guide, a workflow step, a skill, or an
orientation/operating-rules pair.

| Bound                                        | Exempt                                                |
| -------------------------------------------- | ----------------------------------------------------- |
| Every `CONTEXT.md` and `CLAUDE.md`, anywhere | Root-level `*.md` — `README`, `CHANGELOG`, `GAPS`, …  |
| `**/docs/**/*.md`                            | `**/src/*.md` — operator guides, written for a human  |
| `**/workflows/**/*.md`                       | Vendored trees — `.agents/`, `code/docs/cloudinary/*` |
| `.claude/**/*.md`                            | Generated — `project-management/export/`              |
|                                              | Sandboxes — `learning/`, `research/`, `handoffs/`     |

**A `CONTEXT.md` or `CLAUDE.md` inside an exempt tree is still bound.** The pair is ours and
instructional wherever it lives.

## 3. The ratchet — the warn tier has teeth

From **270** code lines (90% of the limit) a file may not get **longer** without a dated reason.
`docs-length.sh --since <ref>` fails on growth at or above the tier, and on a file **born** there
— a new file is the cheapest moment to split it.

Baselines differ by venue, and the flag is the only difference: **lefthook** passes `--since HEAD`
for immediate local feedback; **CI** passes the merge-base, so cumulative branch growth cannot
creep past one commit at a time.

The warn tier used to print and oblige nobody. A file crossed 270 and sat there until somebody's
unrelated edit was refused at 300, so the pressure landed on whoever happened to be writing rather
than on whoever owned the guide.

## 4. The dated allowance

Answer the ratchet by splitting, or with a whole-line HTML comment:

```markdown
<!-- docs-length-allow: <reason> (expires DD/MM/YYYY) -->
```

**Both halves are mandatory.** An undated allowance is a permanent opt-out granted to exactly the
files that earned scrutiny; a dated one comes back. The date is what separates a deferral from an
amnesty.

It defers **the ratchet only, never the 300 limit**. A file at 301 fails whatever comment it
carries.

## 5. Nothing is exempt for growing by design

A register, an index, a roster — the argument is always that this particular file is the sort that
naturally accumulates. It is not a defence. A register that outgrows the cap becomes an index over
sub-registers, like anything else.

## 6. How it is enforced

`code/src/scripts/audits/docs-length.sh` — **never** `cloc.sh`, which passes
`--exclude-lang=Markdown` and therefore cannot see this rule at all. Several guides once routed the
check to it, which meant the check silently passed on every run. A gate that cannot fail is worse
than no gate, because it is believed.

| Exit | Meaning                                                              |
| ---- | -------------------------------------------------------------------- |
| 0    | Every file within the limit — warnings alone do not fail             |
| 1    | One or more files over the limit, or a ratchet finding               |
| 2    | Script error — bad arguments, no `cloc`, or an unmeasurable baseline |

## Governing procedures (route here — do not restate at length)

- `how-to/workflows/06-quality-gates/` — running the audit suite
- `how-to/workflows/09-write-operator-guide/` — the length standard for the exempt `**/src/*.md`
  half

## Cross-references

- `code/docs/DOCUMENTATION-PAIRING.md` — the shape of the pair this rule sizes
- `.claude/CLAUDE.md` Section 8 — the one-bullet statement that routes here
- `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` — Markdown style and writing conventions
- `code/src/scripts/audits/docs-length.sh` — the gate
