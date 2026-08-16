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
    ├── environments/
    └── health/         ← the only requests at baseline: the liveness/readiness contract
```

---

## Purpose

Integration and contract tests that run against a live Django Ninja API. These are not unit tests — they require a running backend.

| Entry               | Contents                                                                       |
| ------------------- | ------------------------------------------------------------------------------ |
| `api/`              | Bruno API collection — config, environments, and the `health/` contract folder |
| `template-test.bru` | Annotated request template — copy into an `api/` subfolder                     |

**`health/` is the only folder at baseline, and it is deliberately not an API test.** The
project serves no API yet; `/health/` and `/health/ready/` are plain Django views mounted at the
root precisely so they answer when `/api/` does not exist or cannot respond. They are here
because this is where HTTP-layer contract tests live, and because those two endpoints have
consumers outside this repository. Domain folders (`auth/`, `users/`, …) land beside it as
endpoints ship.

---

## Notes

- Run via the Bruno desktop app or `bash code/src/scripts/tests/api.sh`.
- Always select the correct environment (`local`, `docker`, `staging`, or `production`) before running.
- Never commit real credentials — use Bruno's secret variable feature or inject from CI.
- Parent: `../CONTEXT.md`
