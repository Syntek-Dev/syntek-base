---
skills: [code-reviewer, frontend, doc-writer]
model: opus
---

# code/src/scripts/audits/slop-family

Why the AI-slop audit is four scripts and not one. The four — `css-slop.sh`, `template-slop.sh`,
`copy-slop.sh` and `render-slop.sh` — live one level up and are registered in `../CONTEXT.md`;
this folder holds no script. It exists because the argument for the split is the register's
most valuable orientation and its longest: here it is measured as a file in its own right, and
no longer competes for the register's lines with the three rows every new audit adds.

## Directory Tree

```text
code/src/scripts/audits/slop-family/
├── CONTEXT.md    ← this file — the split, the second axis, the design-time scope, the annotation
└── CLAUDE.md     ← operating rules
```

## Why four scripts and not one

`css-slop.sh`, `template-slop.sh`, `copy-slop.sh` and `render-slop.sh` enforce **one** doctrine
(`code/docs/VISUAL-DESIGN.md` Section 4–Section 6 and `how-to/src/BRAND-VOICE.md` Section 4) and
are split by **input language**, not by topic. Of the clauses those guides mark machine-checkable,
roughly ten read CSS, three read templates, one reads Slint build config and the rest read prose —
and a CI path filter is a file glob, so one script spanning three languages would fire on every
CSS, HTML and Rust change alike. The desktop leg lives in `../../desktop/style-check.sh` for the
same reason.

### The fourth member splits on a second axis, and saying so is the honest version

`render-slop.sh` reads the **same HTML** `template-slop.sh` reads. By input language alone it
would belong inside that script, so the family's own rule does not place it — and pretending
otherwise would make the rule quietly false. What separates it is that its clause cannot be
decided from the input **as text at all**: the same `.wf-grid` markup is a one-, two- or
three-column device depending on width, `wireframe.css` turns it to three columns at 64rem and
nowhere below, and **CSS text has no viewport**. At 375 px and 768 px a known three-up reads
clean. So the axis is: split by input language, **plus one member split by whether the input must
be rendered before the clause exists**.

That is also why it is a separate script rather than a leg inside the markup half. It needs a
browser and a downloaded Chromium — a dependency class nothing else in the family carries — and
folding it in would put that cost on every template change and take `template-slop.sh` from
`find` + `awk` with no dependencies to something that can fail on a missing binary. It stays
**self-guarding** instead: no browser, no consolidated wireframes, exit 0 with a note.

### One scope is design-time, and that is the same rule

`css-slop.sh` and `template-slop.sh` also read
`project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS`, and `css-slop.sh` additionally reads
that folder's sibling `SHARED/`. A consolidated wireframe is a styled HTML screen over a shared
stylesheet, so by input language it belongs to these two legs — placing it anywhere else would be
the topic-split the family exists to avoid.

**`render-slop.sh` has that folder as its _only_ scope**, because it is the only one where a
rendered judgement is both possible and cheap: the screens open over `file://` with no Docker, no
nginx and no Django. The code-time counterpart was considered and declined — a rendered check over
Django pages needs the whole dev stack, and it would re-decide at code time what the consolidated
set already settled before any code existed.

**`SHARED/` is named explicitly because it is not a stage.** `wireframe.css` is the single
stylesheet every screen links, and it lives beside the stage folders rather than inside one. A
CSS scope covering only `CONSOLIDATED-IDEAS` would gate the markup while leaving the styling it
depends on unread — the gate would report green having measured nothing, which is the failure
`docs-length.sh` was written to close in its own domain.

**Stage 1 (`USER-STORY-IDEAS/`) is deliberately out of scope, for all four.** It holds one screen
per story and is frozen once workflow `18` runs, while the clauses that matter most here — Section
4.1's repetition tell and Section 4.2's rhythm clause — are properties of a page **set**. The
consolidated folder is the only place the whole set exists at once, and it exists there before any
code, which is the one point where a page-set judgement is cheap. That closes the gap
`.claude/skills/code-reviewer/SKILL.md` names and cannot reach from a diff — the rhythm half
statically, in `css-slop.sh`, and the repetition half only once rendered, in `render-slop.sh`.

`06-BRAND-GUIDE` and `07-COMPONENTS` get no scope for the same input-language reason: they hold
`.tex`, `.py` and `.pdf`, which none of these scripts reads.

## The `slop-allow` annotation, by member

Every script in the family reads the same annotation. Its three scopes — a line, a file naming the
clause, the screen set — and the tiers, the qualified form and why a warning is annotatable at all
are `code/docs/VISUAL-DESIGN.md` Section 6's, and are not repeated here. What this family adds is
which member takes which scope, for which clauses:

| Member             | A line            | A file, naming the clause                        | The screen set       |
| ------------------ | ----------------- | ------------------------------------------------ | -------------------- |
| `css-slop.sh`      | every line clause | the four ratios                                  | —                    |
| `template-slop.sh` | every line clause | `pill-above-heading`, `undifferentiated-buttons` | —                    |
| `copy-slop.sh`     | every line clause | `exclamation-count`                              | —                    |
| `render-slop.sh`   | —                 | `repeated-device`, in the screen that carries it | `repeated-signature` |

`render-slop.sh` takes no line scope — a rendered finding has no line. The desktop leg uses
`style-allow`, its own name, because it has exactly one clause (`../../desktop/CONTEXT.md`).

## Cross-references

- `../CONTEXT.md` — the audit register: each member's inventory row, dependencies and report name
- `code/docs/VISUAL-DESIGN.md` Section 4–Section 6 — the doctrine, and the tier each clause carries
- `how-to/src/BRAND-VOICE.md` Section 4 — the prose half's doctrine
- `../fixtures/render-slop/CONTEXT.md` — the pair `render-slop.sh --self-test` proves itself on
- `../../desktop/CONTEXT.md` — the fifth leg, Slint build config, and why it lives there
