# project-management/src/14-LOGGING/PLANNING

The **pre-implementation** logging plan for one user story — the log surface decided before any
code is written, so the fields are chosen deliberately rather than added under incident pressure.

## Directory Tree

```text
project-management/src/14-LOGGING/PLANNING/
├── CONTEXT.md                        ← this file
├── CLAUDE.md                         ← operating rules for this folder
├── LOGGING-PLAN-US000-TEMPLATE.md    ← copy this per story
└── LOGGING-PLAN-US###-<DESCRIPTOR>.md  ← one plan per story
```

## What a plan states

Which named loggers the story adds, one row per logged event with its level and exact field
list, the safe-field allowlist, every excluded `[enc]` and PII attribute, and the retention
expectation per channel.

Its post-implementation counterpart is `../IMPLEMENTATION/`.

**Last Updated**: <%DATE%>
