# code/src/scripts/\_lib

Internal bash helper library. Files here are **sourced** by other scripts — do not call them directly.

The underscore prefix is the signal: `_lib/` sorts first and reads as private, which is what
keeps a helper from being mistaken for a runnable script in a directory listing.

## Directory Tree

```text
code/src/scripts/_lib/
├── CLAUDE.md              ← operating rules
├── CONTEXT.md             ← this file
├── conflict-markers.sh    ← the one conflict-marker pattern, shared by its audit and template-update
├── env-file.sh            ← read a compose env file without executing it — env_value, env_export
├── frontmatter-skills.sh  ← the one reader for a routing `skills:` list, shared by the two skill audits
├── wizard.sh              ← interactive-wizard helpers — staged prompts, secret entry, .env upserts
└── worktree-detect.sh     ← git worktree detection and setup utilities
```

## Files

| File                    | Purpose                                                                                                                         |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `worktree-detect.sh`    | Git worktree detection and setup utilities                                                                                      |
| `wizard.sh`             | Interactive-wizard helpers — staged prompts, secret entry, `.env` upserts (`.claude/skills/wizard/`)                            |
| `conflict-markers.sh`   | The pattern for an unresolved git conflict marker, raw and Prettier-mangled, plus the scan honouring `conflict-markers: ignore` |
| `frontmatter-skills.sh` | The reader for a routing `skills:` list — all three YAML forms, emitting the key's line number with each name                   |
| `env-file.sh`           | `env_value KEY FILE` and `env_export FILE` — a compose env file read as data, never executed as a script                        |

**`env-file.sh` was extracted after the same disagreement, in the other direction.** Four
scripts read the same `.env` files with `set -a; source`, which hands the file to bash — and
docker compose, reading the very same file, uses its own parser in which a value is a literal
string. The two disagree on any value carrying a shell metacharacter, and bash then aborts
the source at that line, leaving every LATER assignment unset without saying so. In this
template `POSTGRES_USER=<%PROJECT_SLUG%>` triggered it, so `server.sh up` exited 2 with the
stack already running. One parser, one home, and it never executes what it reads.

**Why `conflict-markers.sh` is shared rather than inlined.** Two callers detect the same defect
— `audits/conflict-markers.sh` across the tree and `development/template-update.sh` across the
copier scratch directory — and they used to disagree: the second carried its own line-anchored
pattern, which misses the form Prettier leaves behind. That disagreement is how a committed
conflict marker survived two releases. One pattern, one home.

**`frontmatter-skills.sh` is the same story, found the same way.** Two audits read a guide's
routing `skills:` key and ask opposite questions of it — `routing-skills.sh` asks whether each
name **resolves**, `skill-conformance.sh` clause 14 asks whether the named skill **cites the
guide back**. Each carried its own parser, and they disagreed about which files have the key at
all: clause 14 read a wrapped array, `routing-skills.sh` required the opening bracket on the
key's own line. Prettier wraps a long array past its print width, so one shipped guide wrote
one — and its eight names were skipped whole while the audit reported a confident count of
everything else. Two readers of one key, and the weaker was the one guarding the gate.

The pattern generalises past both cases: **the copy that is wrong is believed exactly as much as
the one that is right**, so the second enforcer of any rule belongs here rather than beside its
caller. Adding a third caller means sourcing the helper, never reproducing it.
