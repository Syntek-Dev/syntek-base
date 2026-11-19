# BUG: US009 — `install.sh`'s host-profile probes abort the whole install when one probe fails

| Field            | Value                                                                                                                                                 |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**        | US009 — the git hooks arm on purpose at install, and the README claim that they already do becomes true                                               |
| **Story doc**    | `../02-STORIES/US009.md`                                                                                                                              |
| **Story plan**   | `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md`                                                                                                |
| **Severity**     | Medium                                                                                                                                                |
| **Date found**   | 17/11/2026                                                                                                                                            |
| **Last Updated** | 17/11/2026                                                                                                                                            |
| **Found during** | QA — the US009 probe runner (EC-07 red on every full run until the fix)                                                                               |
| **Reporter**     | Claude (US009 build), recorded at `22-implementation-documentation` Step 5; finding F-002 in `../20-FINDINGS/FINDING-US009-HOOK-ARMING-17-11-2026.md` |

**Status:** Fixed

---

## 1. Summary

`generate_machine_spec` in the root `install.sh` aborted the script under `set -euo pipefail`
whenever any host probe failed, was absent, or fed a `grep` that matched nothing. Both
`bash install.sh --spec` and a full `bash install.sh` (which calls it at Step 8) died before
writing the host profile, so the install never reached US009's Step 9.

**Pre-existing:** the defect predates US009. `git log -S` puts the function's introduction at
`fc905eb` (01/08/2026); whether every host since then was affected is TODO(verify). US009 found it
because its install-failure fixture has to get past Step 8.

## 2. Environment

| Aspect      | Value                                                                                            |
| ----------- | ------------------------------------------------------------------------------------------------ |
| **Surface** | Developer tooling — the root `install.sh` (no Django surface)                                    |
| **Route**   | `bash install.sh --spec`; `bash install.sh` Phase 1 Step 8                                       |
| **Env**     | local (this host: a stale gvfs FUSE mount); any CI runner or headless server (no display device) |
| **Build**   | `us009/hook-arming` before `fd11604`                                                             |

## 3. Reproduction steps

Reproduced by the `machine-spec` fixture in a scratch copy, with fake host probes placed first on
`PATH`. Never run the root `install.sh` beyond `--help` in a working tree to reproduce this.

1. Run `bash code/src/scripts/tests/hook-arming.sh --fixture machine-spec` against `6dc794b`
   (the fixture commit, before the fix).
2. The fixture runs `bash install.sh --spec` once per case, each case breaking exactly one probe:
   `df` exiting 1, `lspci` printing no display device, `lscpu`, `nproc`, `free`, `nvidia-smi`
   or `uname` failing or absent.
3. Observe: 12 cases red. `install.sh --spec` exits non-zero and writes no `MACHINE-SPEC.md`.
   The baseline case and the already-guarded `docker` probe are the green controls.

## 4. Expected vs Actual

|              | Behaviour                                                                                                                                                                                                 |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Expected** | The host profile is best-effort, as the function's own header comment said: a failing probe leaves its field as the placeholder, `--spec` exits 0, and a full install carries on to Step 9                |
| **Actual**   | The first failing probe exits the script with its status. On this host, `df -h` exiting 1 on a stale FUSE mount was enough; on a headless host, `lspci \| grep` for a display matching nothing was enough |

## 5. Root-cause analysis

Each field was captured as `x="$(probe 2>/dev/null | filter)"`. Under `pipefail`, the pipeline's
status is the first non-zero stage's status; an assignment from a command substitution takes that
status; and `errexit` then exits the script. `2>/dev/null` silenced the probe's message but not its
exit status, so the header's "every probe is guarded" was true of stderr only. A `grep` that
matches nothing exits 1, which makes an empty result — the normal case for `lspci` on a CI runner
— a fatal error. The `nvidia-smi` fallback was a `[[ ... ]] && cmd && gpu="$(...)"` chain, whose
inner assignment was unguarded in the same way.

| File         | Lines (before `fd11604`)              | Issue                                                                                                          |
| ------------ | ------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `install.sh` | `generate_machine_spec`, Linux branch | `kernel`, `cpu_*`, `mem_*`, `gpu` and `disk_table` assignments unguarded; `/etc/os-release` sourcing unguarded |
| `install.sh` | Darwin and Windows branches           | The same pattern on every `sysctl`, `system_profiler`, `df` and PowerShell probe                               |

## 6. The fix

**Approach:** every probe assignment in the Linux, macOS and Windows branches ends `|| true`, so
a field keeps whatever the probe printed or falls back to the existing placeholder. The
`nvidia-smi` chain became an `if` block, and a failing `/etc/os-release` falls back to `Linux`.
Healthy-host output is unchanged.

**Files touched:**

- `install.sh` — `generate_machine_spec`, and its header comment explaining why each probe ends
  `|| true` (`fd11604`)

## 7. Regression test (write the failing test FIRST — TDD)

| Test                           | Location                                                                                                                      | Asserts                                                                                                        |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `machine-spec` fixture (EC-07) | `code/src/scripts/tests/hook-arming.sh` → `fx_machine_spec`; CI step in `.github/workflows/audit-hook-arming.yml` (`6dc794b`) | With any one probe broken, `install.sh --spec` exits 0, writes a non-empty `MACHINE-SPEC.md`, and arms nothing |

- **Red:** at `6dc794b`, 12 cases failed; EC-07 was the one failure in every earlier full run
  (141/1/1 to 328/1/1).
- **Green:** at `fd11604`, `machine-spec` 42/42 and the full run 371 passed, 0 failed,
  1 unmeasured (ES-01, CI-only).

## 8. Impact & related stories

- **Impact:** every developer whose host had a failing probe, and every CI runner or headless
  server, could not complete `bash install.sh` or `--spec`. For US009 it would have killed the
  install-failure job at Step 8, before the step under test.
- **Related stories:** US009 — the install-failure fixture depends on reaching Step 9.
- **Related records:** `../20-FINDINGS/FINDING-US009-HOOK-ARMING-17-11-2026.md` F-002 and F-017
  (the macOS and Windows branches were guarded but not exercised).

## 9. Verification

- `bash code/src/scripts/tests/hook-arming.sh --fixture machine-spec` — 42/42 at `fd11604`.
- `bash code/src/scripts/tests/hook-arming.sh` — 371 passed, 0 failed, 1 unmeasured at `fd11604`.
- `bash code/src/scripts/tests/all.sh` — **unmeasured** for this record: the story ships no
  Python or Django code, and its evidence is the probe runner.
- ShellCheck 0.11.0 on `install.sh`: only the 8 pre-existing info-level findings.

**Sign-off:**

- [x] Regression test written **first** (`6dc794b`), seen to fail, now passing (`fd11604`)
- [ ] `bash code/src/scripts/tests/all.sh` green — not run for this record
- [x] Root cause identified (symptom fix rejected)
- [ ] Fix merged under the story branch; **Status** flipped to `Fixed`, then `Verified` post-merge —
      `Fixed` on the branch; `Verified` waits on the merge and on the CI run of
      `audit-hook-arming.yml`, which has not run yet

---

## Cross-references

- `../02-STORIES/US009.md` — the story this defect was found in
- `../17-STORY-PLANS/09-STORY-PLAN-US009-HOOK-ARMING.md` — the code master the fix closes the loop on
- `../20-FINDINGS/FINDING-US009-HOOK-ARMING-17-11-2026.md` — F-002
- `code/workflows/10-debug/` — the TDD debug procedure (failing test first)
- `../18-TESTS/MANUAL/` · `../18-TESTS/AUTOMATED/` — the story's manual guide and automated record
