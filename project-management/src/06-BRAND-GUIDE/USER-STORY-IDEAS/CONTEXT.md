# project-management/src/06-BRAND-GUIDE/USER-STORY-IDEAS

**Stage 1** — per-story token needs. One short record per user story, written during that
story's pass through `workflows/06-brand-guides/`, stating which brand tokens the story
**reuses** and which (if any) it needs that do not exist yet.

## Directory Tree

```text
project-management/src/06-BRAND-GUIDE/USER-STORY-IDEAS/
├── CONTEXT.md                          ← this file
├── CLAUDE.md                           ← operating rules for this folder
├── BRAND-IDEA-US000-TEMPLATE.md        ← copy this to record a story's token needs
└── BRAND-IDEA-US###-<DESCRIPTOR>.md    ← one record per story
```

**Naming:** `BRAND-IDEA-US###-<DESCRIPTOR>.md` — story number zero-padded, descriptor in
`SCREAMING-KEBAB-CASE`.

## "Reused existing" is the good answer

These records are deliberately small. Most stories need no new brand token at all, and a record
that says so in three lines is doing its job.

The value is in the exceptions. When a story genuinely needs a colour, weight, or spacing step
that does not exist, this is where that ask is captured **without** anyone yet deciding whether
it should join the palette. That decision belongs to `18-consolidate-design-work`, looking at
every story's asks together — because the fourth grey only looks unreasonable next to the other
three.

**Do not edit `../guide-build/`.** A story states a need; the generator is re-run once, at
consolidation.

## Frozen at consolidation

Once `18-consolidate-design-work` runs, every file here is frozen. The decided token set lives
in `../CONSOLIDATED-IDEAS/`.

## When to write one

- During a story's pass through `workflows/06-brand-guides/`, before it reaches `15-decisions`
- Every story that renders UI writes one, even if it is entirely "reused existing"

## Cross-references

- `BRAND-IDEA-US000-TEMPLATE.md` — the per-story record template
- `../CONSOLIDATED-IDEAS/` — where these asks are decided
- `../guide-build/` — the cumulative deliverable, regenerated at consolidation
- `../CONTEXT.md` — the folder overview and the three stages
- `code/docs/DESIGN-TOKENS.md` — the DB-canonical token layer

**Last Updated**: <%DATE%>
