# apps/core/management — The Command Base

One module: the base class every management command in this project subclasses. It exists
because a command has no HTTP status to carry the three error classes, so the mapping onto
what an operator reads and what a scheduler acts on has to be made **once**, somewhere.

**Last Updated**: <%DATE%>

## Directory Tree

```text
apps/core/management/
├── __init__.py   ← package marker
├── base.py       ← ManagementCommand + EXIT_TEMPFAIL
├── CONTEXT.md    ← this file
└── CLAUDE.md     ← operating rules
```

**No `commands/` package, deliberately.** Django discovers commands at
`<app>/management/commands/*.py`, and `core` owns no domain — a command that belongs to
nothing would have nothing to do. A project's commands live in the app whose data they touch.

## What `base.py` decides

| Raised inside the command | Operator sees                      | Exit | Class             |
| ------------------------- | ---------------------------------- | ---- | ----------------- |
| `ServiceError` subclass   | one line on stderr                 | 1    | user error        |
| `DependencyUnavailable`   | one line on stderr                 | 75   | environment error |
| `InvariantViolation`      | the traceback, and a tracker event | 1    | programmer error  |

`InvariantViolation` is the one the base class does **not** touch. Catching it to print
something tidier would be the friendly-4xx failure in a different medium.

`EXIT_TEMPFAIL` is 75, from BSD `sysexits.h` — the only code anything downstream treats
differently, because a scheduler retries on it and must not retry on the other two.

## Cross-references

- `code/docs/MANAGEMENT-COMMANDS.md` — the rule this module implements, and why the direct
  `BaseCommand` import is banned
- `code/docs/NEGATIVE-SPACE.md` → The error taxonomy — the three classes being mapped
- `code/docs/PROCESS-MODEL.md` — the connection rule `execute()` satisfies on entry and exit
- `code/docs/TASK-AUTHORING.md` — the sibling surface: the same taxonomy, expressed as retry
  classification rather than exit codes
