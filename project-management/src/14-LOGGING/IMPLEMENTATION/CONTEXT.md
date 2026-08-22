# project-management/src/14-LOGGING/IMPLEMENTATION

The **post-implementation** logging record for one user story — what the shipped code actually
emits, measured against the plan, with the leak checks evidenced rather than asserted.

## Directory Tree

```text
project-management/src/14-LOGGING/IMPLEMENTATION/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
├── LOGGING-IMPL-US000-TEMPLATE.md    ← copy this per story
└── LOGGING-IMPL-US###-<DESCRIPTOR>.md  ← one record per story
```

## What a record proves

Each planned event confirmed present at the planned level with the planned fields; every
divergence from the plan stated with its reason; and the exclusion check run against a real log
file after exercising the story's flows — the command, and its output.

Its pre-implementation counterpart is `../PLANNING/`.

**Last Updated**: <%DATE%>
