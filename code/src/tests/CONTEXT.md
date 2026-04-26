# code/src/tests — API Integration Tests

**Last Updated**: 24/04/2026
**Version**: 1.0.0
**Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Directory Tree

```text
tests/
├── CONTEXT.md      ← this file
└── api/            ← Bruno API test collection
    └── CONTEXT.md
```

---

## Purpose

Integration and contract tests that run against a live API. These are not unit tests — they require a running backend.

| Directory | Contents                                                |
| --------- | ------------------------------------------------------- |
| `api/`    | Bruno API collection (auth, users, orders, performance) |

---

## Notes

- Run via the Bruno desktop app or `bruno run` CLI.
- Always select the correct environment (`local`, `staging`, or `production`) before running.
- Never commit real credentials — use Bruno's secret variable feature or inject from CI.
- Parent: `../CONTEXT.md`
