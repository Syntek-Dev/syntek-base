# audits/fixtures/render-slop

The ground truth `render-slop.sh --self-test` measures itself against: one screen that is
deliberately wrong in exactly one way, and one that is deliberately right. They exist because
this template ships **no consolidated wireframes of its own**, so without them the rendered gate
would be a script nobody had ever watched fire — and a gate whose green result has never been
earned is believed exactly as much as one that has.

## Directory Tree

```text
code/src/scripts/audits/fixtures/render-slop/
├── CONTEXT.md                    ← this file
├── CLAUDE.md                     ← operating rules
├── positive-three-up.html        ← KNOWN POSITIVE — three cards into a 3-column grid
└── negative-lead-and-two.html    ← KNOWN NEGATIVE — the same three into a 2-column grid
```

## Why a pair and not one file

A detector that only ever sees a wrong screen proves it can say "wrong"; it proves nothing about
whether it can say "right". The expensive failure for this clause is the **false positive** — a
gate that fails correct work is inherited by every generated project — so the negative is the more
important of the two.

The pair differs in **the grid and nothing else**: `repeat(3, 1fr)` against `repeat(2, 1fr)`, same
three cards, same styling, same content shape. Two fixtures differing in several ways at once
would tell you the detector separated them without telling you what it saw.

## Where the numbers come from

Both screens are measured at **1280 × 800**, and that is the whole argument for rendering at all:
the same markup is a one-, two- or three-column device depending on width, and CSS text has no
viewport. At 375 px and 768 px both fixtures read clean, including the positive.

The negative reproduces the composition workflow `17`'s gate shipped in the wireframe template —
three cards into a two-column grid, reading 2 + 1 — so the fixture and the real artefact agree
about what "right" looks like.

## Not a scan scope

This directory is **never scanned by the audit it serves**. A deliberately-slop screen inside a
real scope would put `render-slop.sh` — and, if it lived in the wireframe tree, `css-slop.sh` and
`template-slop.sh` — permanently amber against a finding nobody intends to fix. It is reached only
through `--self-test`.

## Cross-references

- `../../render-slop.sh` — the audit these prove
- `code/docs/VISUAL-DESIGN.md` Section 4.1 — the repetition clause, and Section 6 for its tier
- `project-management/src/08-WIREFRAMES/SHARED/wireframe.css` — the real stylesheet, which these
  fixtures deliberately do **not** depend on
