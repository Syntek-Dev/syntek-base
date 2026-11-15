# BUG: `restore.sh` drops the database before discovering a relative backup path is wrong

| Field            | Value                                                                                                          |
| ---------------- | -------------------------------------------------------------------------------------------------------------- |
| **Story**        | N/A — cross-cutting (surfaced by US006)                                                                        |
| **Story doc**    | N/A — surfaced in the workflow 23 review of `../02-STORIES/US006.md`                                           |
| **Story plan**   | N/A — cross-cutting                                                                                            |
| **Severity**     | Low                                                                                                            |
| **Date found**   | 15/11/2026                                                                                                     |
| **Last Updated** | 15/11/2026                                                                                                     |
| **Status**       | Fixed — on `us006/posture-guard`, uncommitted at the time of writing                                           |
| **Found during** | Review — workflow `23-pr-and-review` for US006, finding R-004                                                  |
| **Reporter**     | Claude, on the developer's behalf; finding F-023 in `../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` |

**Pre-existing, not introduced by US006.** The defect dates from `f0681f2` (18/04/2026) and is
present on `origin/testing`; US006's posture guard does not touch the path handling, so it takes
the cross-cutting filename. **Fixed on the US006 branch at the developer's instruction**
(15/11/2026), because the review found it in a script the story edits.

**Severity Low** follows the review's verified grading: the database at risk is a development one,
whose data `.claude/CLAUDE.md` Section 0 calls disposable, and above `development` the US006 guard
refuses `restore.sh` unless the live posture is named. The effect within that scope is still the
loss of the whole database, so the fix stops it before the DROP rather than after.

---

## 1. Summary

`bash code/src/scripts/database/restore.sh <file>` with a **relative** backup path, run from a
directory other than the repository root, checked the path against the caller's working directory,
then changed directory to the repository root and read the path again only after
`DROP DATABASE`. The second read named a different file — or none — so the restore emptied the
database and then failed. Where a file of the same relative name existed under the root, it
restored that file instead of the one the operator named.

## 2. Environment

| Aspect      | Value                                                                                       |
| ----------- | ------------------------------------------------------------------------------------------- |
| **Surface** | Tooling — `code/src/scripts/database/restore.sh`                                            |
| **Route**   | N/A — CLI                                                                                   |
| **Env**     | local, the dev stack; any directory other than the repository root as the working directory |
| **Build**   | `us006/posture-guard` at `ee8caa7`; the defect dates from `f0681f2` (18/04/2026)            |

## 3. Reproduction steps

Reproduced without a daemon by the self-test's behavioural tier, which runs the real script against
a recording `docker` stub from a directory outside the fixture root.

1. Take a backup into the current directory, outside the repository root — e.g. `rel.dump`.
2. From that directory, run `bash <repo>/code/src/scripts/database/restore.sh --yes rel.dump` at
   `development`.
3. The argument check passes (`rel.dump` exists in the caller's directory).
4. The script changes to the repository root, prompts, runs `DROP DATABASE` and `CREATE DATABASE`,
   then reads `rel.dump` relative to the root.
5. Observe: `rel.dump: No such file or directory`, a non-zero exit — and the database already
   dropped.

Against the pre-fix `restore.sh` (`HEAD`, everything else from the fixed tree), the self-test
fails exactly this case: `B-restore-relative-path` exits 1 with `rel.dump: No such file or
directory`, after the one `DROP` that `B-restore-relative-dropped-once` counts.

## 4. Expected vs Actual

|              | Behaviour                                                                                                        |
| ------------ | ---------------------------------------------------------------------------------------------------------------- |
| **Expected** | The path is read where the operator typed it; a missing or unreadable file stops the run with nothing dropped    |
| **Actual**   | The path is validated in one directory and read in another, after the DROP — an emptied database, then a failure |

## 5. Root-cause analysis

The script validated its input at one point and consumed it at another, with a `cd` between them
and the destructive step before the consumption. A relative path is only meaningful against the
directory it was typed in, so the `cd` silently changed what the argument named. Nothing re-checked
the input at the last point where stopping was still free.

| File                                   | Lines (pre-fix) | Issue                                                                                 |
| -------------------------------------- | --------------- | ------------------------------------------------------------------------------------- |
| `code/src/scripts/database/restore.sh` | 89-90           | The existence check runs against the caller's working directory                       |
| `code/src/scripts/database/restore.sh` | 97              | `cd "$PROJECT_ROOT"` changes what a relative path names                               |
| `code/src/scripts/database/restore.sh` | 144, 152, 155   | `DROP DATABASE` runs first; the file is read only after it, by `pg_restore` or `psql` |

## 6. The fix

**Approach:** resolve the path where it was typed, and open it at the last safe moment.

- Readability checked beside the existing existence check (`restore.sh:91`).
- The path made absolute **before** the `cd` (`restore.sh:95`, the subshell's `cd` run with
  `CDPATH=''` so an exported `CDPATH` cannot redirect it), so the argument names the same file
  after the script's own `cd` (`:102`).
- Opened immediately before the DROP (`restore.sh:150-151`): the check re-tests the file and opens
  it on fd 3, and a file that has gone or become unreadable stops the run with "nothing was
  dropped". `pg_restore` and `psql` then read that descriptor (`:163`, `:166`), not the path, so
  nothing can swap the file between the check and the read.

**Widened after an independent re-check, 15/11/2026.** The first fix re-checked the path before
the DROP but still opened it only by the redirect after it, leaving a LOW window in which the file
could vanish or change. The re-check found it (a separate agent that wrote none of the code); the fd-3 open closes it, written as an `if` so it
adds no ShellCheck note, and the `CDPATH=''` came with it. A third round found the bytes-read case did
not discriminate; the stub now deletes the backup when it sees the DROP (`ST_RM_ON_DROP`), so a
restore can succeed only through the descriptor, and a `--format plain` run was added. With `<&3`
temporarily reverted to the path, four restore cases fail.

**Files touched:** `code/src/scripts/database/restore.sh`; the regression cases in
`code/src/scripts/database/_migrate-self-test.sh`.

## 7. Regression test (write the failing test FIRST — TDD)

| Test                                                          | Location                                                              | Asserts                                                                                               |
| ------------------------------------------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `B-restore-relative-path`                                     | `st_behavioural` in `code/src/scripts/database/_migrate-self-test.sh` | A relative path given from outside the root restores: exit 0, every Docker call pinned                |
| `B-restore-relative-dropped-once`                             | the same                                                              | Exactly one `DROP DATABASE` recorded on that run                                                      |
| `B-restore-reads-the-backup`                                  | the same                                                              | `pg_restore` receives the backup's bytes from the descriptor opened before the DROP                   |
| `B-restore-plain-format` · `B-restore-plain-reads-the-backup` | the same                                                              | The same restore in `--format plain`, read through `psql` from the descriptor                         |
| `B-restore-missing-path`                                      | the same                                                              | A missing relative path stops with a non-zero exit other than 4, before any `docker` call is recorded |

- **Red:** against the pre-fix `restore.sh`, `B-restore-relative-path` fails (exit 1, the file
  not found after the DROP). Run by swapping `HEAD`'s `restore.sh` into a disposable copy of the
  fixed tree, 15/11/2026. `B-restore-missing-path` passed on the old script too — the existing
  check already stopped a path missing from the caller's directory — and pins that behaviour.
- **Green:** `bash code/src/scripts/database/migrate.sh --self-test` exits 0, 250 of 250, all
  three cases `PASS`.

## 8. Impact & related stories

- **Impact:** any developer restoring from a relative path outside the repository root lost the
  dev database and kept nothing restored. No deployed environment is affected; above `development`
  the US006 guard already refuses the script without an override.
- **Related stories:** US006 (surfaced it at review; fixed on its branch).
- **Related records:** `../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` F-023 ·
  `../11-QA/IMPLEMENTATION/QA-IMPL-US006-POSTURE-GUARD-15-11-2026.md` EC-N8 ·
  `../18-TESTS/AUTOMATED/US006-TEST-STATUS.md` _Behavioural cases_.

## 9. Verification

- The three cases above: red on the old script, green on the new.
- `bash code/src/scripts/database/migrate.sh --self-test` — exit 0, 250 of 250.
- `bash code/src/scripts/tests/all.sh` not run: the fix changes no Python, template or API path,
  so no suite covers it; the self-test is its proof.
- Not run against a live dev stack: the behavioural tier's recording `docker` stands in for the
  daemon, so the restore itself was not executed end to end (`code/docs/GATE-REPORTING.md`).

**Sign-off:**

- [x] Regression check seen to fail on the pre-fix script, now passing — the red was demonstrated
      after the fix, by swapping the old script back in, not before it: TDD's order was not kept
- [x] Root cause identified (symptom fix rejected)
- [ ] Fix merged under its story branch; **Status** flipped to `Verified` post-merge

---

## Cross-references

- `../02-STORIES/US006.md` — the story whose review surfaced it
- `../20-FINDINGS/FINDING-US006-POSTURE-GUARD-15-11-2026.md` — F-023
- `code/src/scripts/database/restore.sh` — the fixed script
- `code/src/scripts/database/_migrate-self-test.sh` — `st_behavioural`, the regression cases
- `code/workflows/10-debug/` — the TDD debug procedure
