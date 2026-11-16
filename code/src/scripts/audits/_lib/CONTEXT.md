# code/src/scripts/audits/\_lib

Files an audit in `../` **sources** to stay under the 750-line source limit — a split of one
audit's own clauses, never a helper shared between scripts. Nothing here is run directly.

It sits beside the audits rather than in `code/src/scripts/_lib/` because that library holds
helpers with **more than one caller**, kept in one home so two enforcers of a rule cannot drift.
A file here has exactly one caller and moves with it; putting it in the shared library would
advertise a reuse that does not exist.

## Directory Tree

```text
code/src/scripts/audits/_lib/
├── CLAUDE.md                   ← operating rules
├── CONTEXT.md                  ← this file
└── negative-space-cookies.sh   ← the US008 cookie clauses and their self-test half, for negative-space.sh
```

## Files

| File                        | Caller              | Purpose                                                                                                                                                                                                                                         |
| --------------------------- | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `negative-space-cookies.sh` | `negative-space.sh` | `run_cookie_clauses` (`csrf-cookie-httponly-absent`, `cookie-host-prefix-absent`, `cookie-scope-widened`), `cookie_has`, the `COOKIE_*` patterns and `COOKIE_CLAUSES`, and `cookie_self_test` — the cookie assertions and absent-directory pass |

The caller keeps every scope variable, `SETTINGS_DIR` included, so `point_scopes_at` still
repoints the whole set in one place.
