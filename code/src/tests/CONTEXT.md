# code/src/tests — API Integration Tests

**Last Updated**: <%DATE%>
**Version**: 0.1.0
**Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Directory Tree

```text
tests/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── template-test.bru   ← annotated request template (kept outside api/ so the CLI never runs it)
└── api/                ← Bruno API test collection
    ├── CONTEXT.md
    ├── CLAUDE.md
    ├── bruno.json
    └── environments/
```

---

## Purpose

Integration and contract tests that run against a live Django Ninja API. These are not unit tests — they require a running backend.

| Entry               | Contents                                                                |
| ------------------- | ----------------------------------------------------------------------- |
| `api/`              | Bruno API collection — config and environments; **no requests yet**     |
| `template-test.bru` | Annotated Django Ninja request template — copy into an `api/` subfolder |

The collection carries no requests at baseline because the project serves no API. Domain
folders (`auth/`, `users/`, …) land here as endpoints ship;
`code/src/scripts/tests/api.sh` exits `0` without starting the stack until then.

---

## Notes

- Run via the Bruno desktop app or `bash code/src/scripts/tests/api.sh`.
- Always select the correct environment (`local`, `docker`, `staging`, or `production`) before running.
- Never commit real credentials — use Bruno's secret variable feature or inject from CI.
- Parent: `../CONTEXT.md`
