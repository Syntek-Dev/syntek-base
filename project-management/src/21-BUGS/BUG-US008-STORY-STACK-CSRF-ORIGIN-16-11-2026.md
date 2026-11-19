# BUG: US008 — a per-story dev stack on `:3080` cannot submit any form

| Field            | Value                                                                                                                     |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **Story**        | US008 — host-only `__Host-` cookies (surfaced by its walk; **not caused by it** — no Django setting was changed by US008) |
| **Story doc**    | `../02-STORIES/US008.md`                                                                                                  |
| **Story plan**   | `../17-STORY-PLANS/08-STORY-PLAN-US008-HOST-ONLY-COOKIES.md`                                                              |
| **Severity**     | Medium — every state-changing request on every worktree dev stack fails; dev-only                                         |
| **Date found**   | 16/11/2026                                                                                                                |
| **Last Updated** | 16/11/2026                                                                                                                |
| **Found during** | Manual walk — the dev-stack cookie rows of `../18-TESTS/MANUAL/US008-MANUAL-TESTING.md`, on a us008 story stack           |
| **Reporter**     | Claude (`22-implementation-documentation` Step 5), from finding F-034                                                     |

**Status:** Verified
**Status note:** 16/11/2026 — fixed in `40ce928` on `us008/story-stack-csrf-origin`, merged `8d6a5ac`; live sign-in on `127.0.0.8:3080` 302

---

## 1. Summary

`code/src/django/config/settings/dev.py` trusts only the three `:81` origins, so a per-story
worktree stack — published on `127.0.0.NNN:3080` by design — rejects every form POST with CSRF 403
"Origin checking failed".

## 2. Environment

| Aspect      | Value                                                                                        |
| ----------- | -------------------------------------------------------------------------------------------- |
| **Surface** | Django CSRF middleware behind dev nginx, on a worktree stack                                 |
| **Route**   | Any POST — observed on `/control/` (admin sign-in and password change)                       |
| **Env**     | local — a `us###` worktree stack from `code/src/docker/docker-compose.usXXX.dev.yml.example` |
| **Build**   | `us008/host-only-cookies` at `43acdf5`; stack `project_slug-dev-us008` on `127.0.0.8:3080`   |

## 3. Reproduction steps

From the walk's _Walk provenance_ paragraph (16/11/2026):

1. Create a worktree stack from `docker-compose.usXXX.dev.yml.example` with NNN = 008, which
   publishes nginx on `127.0.0.8:3080`; bring it up with `bash code/src/scripts/development/server.sh up --build`.
2. Open the stack at `http://127.0.0.8:3080/control/` and submit the sign-in form.
3. Observe: every admin POST returns 403 "Origin checking failed" (the walk's record; the full
   message text was not captured).
4. Move the publish to `127.0.0.8:80` (what the walk did to proceed): the admin POSTs succeed
   (COOKIE-01 and COOKIE-02 Pass at `http://127.0.0.8/`), with no Django setting changed.

## 4. Expected vs Actual

|              | Behaviour                                                                         |
| ------------ | --------------------------------------------------------------------------------- |
| **Expected** | A worktree stack accepts a same-origin form POST at the URL `server.sh up` prints |
| **Actual**   | Every POST on `:3080` is refused with CSRF 403 "Origin checking failed"           |

## 5. Root-cause analysis

The trusted-origin list is a hard-coded literal for the main stack; the worktree overlay changes
the published host and port without any matching setting.

| File                                                   | Lines   | Issue                                                                                                  |
| ------------------------------------------------------ | ------- | ------------------------------------------------------------------------------------------------------ |
| `code/src/django/config/settings/dev.py`               | 14-20   | `CSRF_TRUSTED_ORIGINS` lists only the `:81` origins (`dev.<slug>.localhost`, `127.0.0.1`, `localhost`) |
| `code/src/docker/docker-compose.usXXX.dev.yml.example` | 16, 31  | Worktree stacks publish `127.0.0.NNN:3080:80` and advertise `dev-usNNN.<slug>.localhost:3080`          |
| `code/src/scripts/development/server.sh`               | 210-215 | Prints the worktree URL on `:3080` — the origin the browser then sends                                 |

**Confirmed live 16/11/2026** (was `TODO(verify)`): dev nginx
forwards `Host $host` (`code/src/docker/nginx/dev.conf:18`), which carries no port, so on `:3080`
the browser's `Origin` names a port the request host does not, the same-origin check fails, and the
trusted list is the only remaining way through. On `:80` the default port makes the two agree.

## 6. The fix

**Applied 16/11/2026** through the `bugfix` skill on `us008/story-stack-csrf-origin` (cut from `testing`), on Sam's ruling to use an environment value the worktree overlay sets — the `$http_host` alternative was not taken, so nginx and the edge contract are unchanged. Variable: `DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA`, comma-separated `scheme://host[:port]` origins appended to the `:81` defaults; a wildcard or any malformed entry raises `ImproperlyConfigured` naming it. The overlay example sets the advertised name and the IP on `:3080`; setting it in `.env.dev` has no effect.

**Superseded by the applied fix above — kept as the original proposal.** **Approach (smallest):** derive the trusted origins from the stack rather than a literal — read an
environment variable the worktree overlay sets (the published scheme, host and port) and append it
to the `:81` defaults in `dev.py`, so both stacks are trusted without widening to a wildcard.
`.env.dev.example` gains the variable's name with a placeholder. Alternative (not taken): have
nginx forward `$http_host` (host **with** port) so Django's same-origin check succeeds on its own;
weigh it against the staging/production edge contract before choosing.

**Files touched (expected):**

- `code/src/django/config/settings/dev.py` — trusted origins extended from an env value
- `code/src/docker/docker-compose.usXXX.dev.yml.example` — sets that value per worktree
- `code/src/docker/.env.dev.example` — documents the variable name, never a live value

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                                                                                                                                                           | Location                                                    | Asserts                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `config/tests/test_dev_settings.py` (21 cases, each importing `config.settings.dev` in a fresh interpreter) and `audits/worktree-overlay.sh` (CI `audit-worktree-overlay.yml`) | `code/src/django/config/tests/`, `code/src/scripts/audits/` | With the worktree origin set in the environment, `CSRF_TRUSTED_ORIGINS` contains it and the `:81` defaults |

- **Red:** the origin is absent from the list against the current `dev.py`.
- **Green:** present after the change; a manual POST on a `:3080` stack returns 200/302.

## 8. Impact & related stories

- **Impact:** every per-story worktree dev stack (`how-to/workflows/02-worktree-setup/`); any
  manual row that submits a form or fires an HTMX write there. The main stack is unaffected.
- **Related stories:** US008 (where it surfaced; its walk moved the publish to `:80` to proceed,
  contrary to the overlay's own rule that the host port is never 80).
- **Related records:** `../20-FINDINGS/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` F-034 ·
  `BUG-TEST-SERVER-WORKTREE-URL-PORT-15-11-2026.md` (the worktree port, on the test stack).

## 9. Verification

- `bash code/src/scripts/development/server.sh up` on a worktree stack, then sign in at `/control/` on `:3080`.
- `bash code/src/scripts/tests/all.sh` — green, including the new settings test.

**Sign-off:**

- [x] Regression test written **first**, seen to fail (16 red, overlay audit 2 violations), now passing
- [x] `bash code/src/scripts/tests/backend.sh` green on the merged branch (71 unit, 22 integration); docs, template and audit gates green
- [x] Root cause identified (symptom fix rejected) — confirmed live: portless origins pass, port-carrying ones fail unless trusted
- [x] Fix merged; **Status** `Verified` — independent QA on a disposable stack at `127.0.0.8:3080`: sign-in and admin password change 302; `Origin: http://evil.example:3080` with a valid token 403, as do port, case, `null` and trailing-slash variants

---

## Cross-references

- `../20-FINDINGS/FINDING-US008-HOST-ONLY-COOKIES-16-11-2026.md` — finding F-034
- `../18-TESTS/MANUAL/US008-MANUAL-TESTING.md` — _Walk provenance_, the dev-stack cookie walk
- `code/docs/URL-STRATEGY.md` — owner of the dev hosts and ports
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
