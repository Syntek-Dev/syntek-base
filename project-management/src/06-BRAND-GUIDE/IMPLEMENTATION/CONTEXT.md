# project-management/src/06-BRAND-GUIDE/IMPLEMENTATION

**Stage 3** — tokens as shipped. One record per user story, written during
`workflows/21-implementation-documentation/`, confirming that the tokens the story consumed
exist in the DB-canonical token layer and match `../CONSOLIDATED-IDEAS/`.

## Directory Tree

```text
project-management/src/06-BRAND-GUIDE/IMPLEMENTATION/
├── CONTEXT.md                                    ← this file
├── CLAUDE.md                                     ← operating rules for this folder
├── BRAND-IMPL-US000-TEMPLATE.md                  ← copy this to record a story's tokens
└── BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md   ← one record per story
```

**Naming:** `BRAND-IMPL-US###-<DESCRIPTOR>-DD-MM-YYYY.md`. Reuse the stage-1 descriptor.

## What it holds

Per story: each consolidated token the story consumed, confirmed present in the DB-canonical
token layer (`code/docs/DESIGN-TOKENS.md`) and resolving in the token CSS; confirmation that no
raw literal was used in component CSS; and any deviation from the consolidated set.

## The literal check is the one that matters

The token-first rule is only real if somebody looks. `code/src/scripts/audits/css-tokens.sh`
enforces that component CSS consumes `var(--token)` and that the name resolves — this record is
where the story states it ran clean, with the audit output as evidence.

## Cross-references

- `BRAND-IMPL-US000-TEMPLATE.md` — the per-story record template
- `../CONSOLIDATED-IDEAS/` — the decided token set these records verify against
- `../USER-STORY-IDEAS/` — the frozen ask, for tracing intent
- `code/docs/DESIGN-TOKENS.md` — the DB-canonical token layer
- `code/src/scripts/audits/css-tokens.sh` — the audit this record cites
- `../../19-FINDINGS/` — where a divergence worth carrying forward is recorded

**Last Updated**: <%DATE%>
