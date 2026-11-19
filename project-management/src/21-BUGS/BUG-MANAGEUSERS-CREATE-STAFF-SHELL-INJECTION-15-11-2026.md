# BUG: `manageusers.sh create-staff` interpolates its arguments into a `manage.py shell -c` string

| Field            | Value                                                                                                          |
| ---------------- | -------------------------------------------------------------------------------------------------------------- |
| **Story**        | N/A — cross-cutting (surfaced by US006)                                                                        |
| **Story doc**    | N/A — surfaced in the env-print audit during workflow 23 of `../02-STORIES/US006.md`                           |
| **Story plan**   | N/A — cross-cutting                                                                                            |
| **Severity**     | Low                                                                                                            |
| **Date found**   | 15/11/2026                                                                                                     |
| **Last Updated** | 15/11/2026                                                                                                     |
| **Found during** | Review — the env-print audit run under workflow `23-pr-and-review` for US006                                   |
| **Reporter**     | Claude, on the developer's behalf; finding F-029 in `../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` |

**Status:** Open
**Status note:** not fixed in US006

**Pre-existing, not introduced by US006.** The interpolation dates from `ee5c2bb` (01/08/2026),
and US006 does not edit `manageusers.sh`. The audit that found it was looking for env-file values
in script output; this is a different defect in a script it read, so it is filed here, not fixed
on the US006 branch.

**Severity Low.** The arguments come from the developer running the script, against the dev
stack, whose data `.claude/CLAUDE.md` Section 0 calls disposable. Code run this way executes in a
container the developer already controls, so it is not an escalation. The practical harm is
narrower: a legitimate value containing a quote (a username such as `o'brien`, or a password with
a `'`) breaks the command or changes its meaning, and a `--password` value is visible in the
process list. **Re-grade if anything ever feeds the script from input the developer did not type**
— a seed file, a CI job, an AI session passing values on.

---

## 1. Summary

`bash code/src/scripts/database/manageusers.sh create-staff --email E --username U [--password P]`
builds a Python snippet by pasting `$EMAIL`, `$USERNAME` and `$PASSWORD` between single quotes and
passes it to `python manage.py shell -c` inside the Django container. A single quote in any of the
three ends the Python string early, so whatever follows runs as Python. The password also travels
as a command-line argument, to the script and then to `docker compose exec`, where any local user
can read it in the process list. `promote` interpolates `$EMAIL` the same way.

## 2. Environment

| Aspect      | Value                                                                                   |
| ----------- | --------------------------------------------------------------------------------------- |
| **Surface** | Tooling — `code/src/scripts/database/manageusers.sh`                                    |
| **Route**   | N/A — CLI                                                                               |
| **Env**     | local, the dev stack (the script requires the `django` container to be running)         |
| **Build**   | `us006/posture-guard` at `4ba6e12`; the interpolation dates from `ee5c2bb` (01/08/2026) |

## 3. Reproduction steps

Not executed: reproducing it needs a running dev stack, and the steps below are read from the
script (`code/docs/GATE-REPORTING.md`). Confirm them on a disposable stack before fixing.

1. Start the dev stack: `bash code/src/scripts/development/server.sh up`.
2. Run `manageusers.sh create-staff` with `--email a@example.invalid`, `--username "o'brien"`
   and `--password x`.
3. Observe: the snippet `User.objects.create_user(username='o'brien', …)` is not valid Python, so
   the command fails with a `SyntaxError` and no user is created.
4. With a value such as `--username "x', email='y', password='z', is_superuser=True) #"`, the
   quote closes the string and the rest of the line becomes keyword arguments the script never
   meant to pass. The account is created as a superuser.
5. While step 2 runs, `ps -eo args` on the host shows `--password x` in the script's arguments.

## 4. Expected vs Actual

|              | Behaviour                                                                                                                 |
| ------------ | ------------------------------------------------------------------------------------------------------------------------- |
| **Expected** | Every argument reaches Django as data, whatever characters it holds; a password never appears in a process list           |
| **Actual**   | Each argument is spliced into Python source, so a quote changes the code; the password is a visible command-line argument |

## 5. Root-cause analysis

The script builds code from data. Shell single quotes inside a double-quoted string do not escape
anything: they are literal characters in the Python source, so the boundary between code and value
is whatever characters the value contains. The password exposure has a separate cause: the
interface takes the secret as a flag.

| File                                       | Lines   | Issue                                                                |
| ------------------------------------------ | ------- | -------------------------------------------------------------------- |
| `code/src/scripts/database/manageusers.sh` | 91      | `--password PASSWORD` accepted as an argument                        |
| `code/src/scripts/database/manageusers.sh` | 118-125 | `$EMAIL`, `$USERNAME`, `$PASSWORD` pasted into the `shell -c` source |
| `code/src/scripts/database/manageusers.sh` | 128-137 | The no-password fallback does the same with `$EMAIL` and `$USERNAME` |
| `code/src/scripts/database/manageusers.sh` | 149-165 | `promote` pastes `$EMAIL` into its two snippets                      |

## 6. The fix

Not written. The direction, to be settled when it is scheduled:

- Pass the values as **data**, never as source: through the container's environment
  (`docker compose exec -e`) read by `os.environ` in a fixed snippet, or, better, through a
  `ManagementCommand` that takes them as parsed arguments (`code/docs/MANAGEMENT-COMMANDS.md`).
- Read the password from a prompt or from standard input, never from a flag, so it reaches neither
  the process list nor the shell history.
- The help text says the password is "prompted interactively if omitted"; the script actually
  creates the account with an unusable password. The fix makes the help and the behaviour agree.

## 7. Regression test (write the failing test FIRST — TDD)

| Test                         | Location | Asserts                                                                   |
| ---------------------------- | -------- | ------------------------------------------------------------------------- |
| A username containing `'`    | TBD      | The account is created with exactly that username; no other field changes |
| An injection-shaped username | TBD      | No superuser is created; the value is stored as typed or rejected         |
| No `--password` flag         | TBD      | The script never accepts a password on the command line                   |

The self-test's behavioural tier (`st_behavioural` in
`code/src/scripts/database/_migrate-self-test.sh`) already runs database scripts against a
recording `docker`, and can assert on the recorded `exec` arguments without a stack.

## 8. Impact & related stories

- **Impact:** a developer creating a staff account with a quote in a value gets a failure or the
  wrong account; a password given as a flag is visible to other local users. No deployed
  environment runs this script.
- **Related stories:** US006 (surfaced it in the env-print audit; not fixed there).
- **Related records:** `../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` F-029 ·
  `../19-REVIEWS/REVIEW-US006-POSTURE-GUARD.md` R-011.

## 9. Verification

- Not yet fixed, so nothing has been verified.

**Sign-off:**

- [ ] Regression check seen to fail before the fix, then pass
- [ ] Root cause identified (symptom fix rejected)
- [ ] Fix merged under its story branch; **Status** flipped to `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US006.md` — the story whose review surfaced it
- `../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` — F-029
- `code/src/scripts/database/manageusers.sh` — the script
- `code/docs/MANAGEMENT-COMMANDS.md` — where arguments are treated as untrusted input
- `code/workflows/10-debug/` — the TDD debug procedure
