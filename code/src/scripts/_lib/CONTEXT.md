# code/src/scripts/\_lib

Internal bash helper library. Files here are **sourced** by other scripts — do not call them directly.

The underscore prefix is the signal: `_lib/` sorts first and reads as private, which is what
keeps a helper from being mistaken for a runnable script in a directory listing.

## Directory Tree

```text
code/src/scripts/_lib/
├── CLAUDE.md            ← operating rules
├── CONTEXT.md           ← this file
├── wizard.sh            ← interactive-wizard helpers — staged prompts, secret entry, .env upserts
└── worktree-detect.sh   ← git worktree detection and setup utilities
```

## Files

| File                 | Purpose                                                                                              |
| -------------------- | ---------------------------------------------------------------------------------------------------- |
| `worktree-detect.sh` | Git worktree detection and setup utilities                                                           |
| `wizard.sh`          | Interactive-wizard helpers — staged prompts, secret entry, `.env` upserts (`.claude/skills/wizard/`) |
