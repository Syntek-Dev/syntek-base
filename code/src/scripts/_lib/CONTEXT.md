# code/src/scripts/\_lib

Internal bash helper library. Files here are **sourced** by other scripts — do not call them directly.

The underscore prefix is the signal: `_lib/` sorts first and reads as private, which is what
keeps a helper from being mistaken for a runnable script in a directory listing.

## Directory Tree

```text
code/src/scripts/_lib/
├── CLAUDE.md             ← operating rules
├── CONTEXT.md            ← this file
├── conflict-markers.sh   ← the one conflict-marker pattern, shared by its audit and template-update
├── wizard.sh             ← interactive-wizard helpers — staged prompts, secret entry, .env upserts
└── worktree-detect.sh    ← git worktree detection and setup utilities
```

## Files

| File                  | Purpose                                                                                                                         |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `worktree-detect.sh`  | Git worktree detection and setup utilities                                                                                      |
| `wizard.sh`           | Interactive-wizard helpers — staged prompts, secret entry, `.env` upserts (`.claude/skills/wizard/`)                            |
| `conflict-markers.sh` | The pattern for an unresolved git conflict marker, raw and Prettier-mangled, plus the scan honouring `conflict-markers: ignore` |

**Why `conflict-markers.sh` is shared rather than inlined.** Two callers detect the same defect
— `audits/conflict-markers.sh` across the tree and `development/template-update.sh` across the
copier scratch directory — and they used to disagree: the second carried its own line-anchored
pattern, which misses the form Prettier leaves behind. That disagreement is how a committed
conflict marker survived two releases. One pattern, one home.
