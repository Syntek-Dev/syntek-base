# config/tests — The Suite for the Settings Package

The `config` package holds no application behaviour, so the only thing worth testing here is a
setting whose value is computed rather than written down. Today that is one: the CSRF trusted
origins in `config/settings/dev.py`, which append `DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA` to the
three `:81` defaults so a worktree story stack on `127.0.0.NNN:3080` can accept a form POST.

The tests exist because the failure is silent in both directions. Too few origins and every
story-stack POST is a CSRF 403 (BUG-US008, F-006); too many — a wildcard, a path, a stray
userinfo — and the trusted list widens with nothing saying so. The suite pins the defaults, the
appended origins, and the refusal of anything that is not exactly an `http(s)` origin.

Each case imports `config.settings.dev` in a **fresh interpreter**, because importing it in the
test process would mutate the `TEMPLATES` list it shares with `config.settings.test`. That is
also why the module marks itself `unit` explicitly although it does not sit under `unit/`: it
touches no database, and the explicit marker overrides the path rule in `conftest.py`.

The overlay that sets the variable is outside `code/src/django/`, so the test image cannot see
it; `code/src/scripts/audits/worktree-overlay.sh` is the host-side half that checks the overlay
example still sets it.

## Directory tree

```text
config/tests/
├── __init__.py           ← package marker
├── CLAUDE.md             ← operating rules
├── CONTEXT.md            ← this file
└── test_dev_settings.py  ← dev CSRF trusted origins: defaults, story-stack extras, refusals
```

## Cross-references

- `code/src/django/config/settings/CONTEXT.md` — what each settings module overrides
- `code/src/docker/CONTEXT.md` — the worktree overlay that supplies the extra origins
- `code/src/scripts/audits/CONTEXT.md` — `worktree-overlay.sh`, the overlay's host-side guard
- `code/docs/testing/TAXONOMY.md` — which layer a given test belongs at
- `code/src/django/conftest.py` — the path-to-marker rule and its explicit-marker override
