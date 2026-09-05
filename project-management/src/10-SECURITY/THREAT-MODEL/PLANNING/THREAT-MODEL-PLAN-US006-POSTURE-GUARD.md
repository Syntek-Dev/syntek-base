# Threat Model Plan — US006 The deployment-posture guard

| Field               | Value                                                                                                                                     |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **Story**           | US006 — The destructive dev scripts read the deployment posture, and refuse to run above development                                      |
| **Date**            | 05/09/2026                                                                                                                                |
| **Author**          | Claude Code — `security` skill, Fable tier · reviewed by <%DEVELOPER_NAME%>                                                               |
| **Status**          | Reviewed                                                                                                                                  |
| **Feature surface** | No runtime surface. One sourced shell helper, five developer scripts, one CI workflow line — the guard itself **is** the security control |

---

## 1. Scope

This model covers **a security control, not a feature**. US006 adds no model, no endpoint, no
screen, no personal-data path and no log line; eleven of its thirteen flags read `N/A`. What is
modelled is the guard's own failure modes — because a control whose single failure direction is
_failing open_ is threat-modelled against itself, and because the four scripts it stands in front
of destroy data by design.

The unusual shape is worth stating plainly: **there is no attacker in most of these rows.** The
dominant threat class is the control mis-reading its own inputs, or standing down when it should
not, with no adversary present at all.

### Surface under review

- **The helper** — `code/src/scripts/_lib/posture-guard.sh` (new), sourced by five callers
- **The bound set** — `code/src/scripts/database/reset.sh`, `database/restore.sh`,
  `development/server.sh` (`down --volumes`), `tests/server.sh` (`down --volumes`) refuse;
  `database/migrate.sh` warns
- **The carrier** — `.copier-answers.yml`, tracked and shipped into every generated project
- **The template proof** — `copier.yml` at the repository root
- **The one CI caller** — `.github/workflows/test-e2e.yml:133`

### Inputs actually read

| Input                         | Source                | Trusted?                                                          |
| ----------------------------- | --------------------- | ----------------------------------------------------------------- |
| `DEPLOYMENT_POSTURE`          | `.copier-answers.yml` | **Yes** — the only authorisation input; N-002 sanctioned the read |
| Presence of `copier.yml`      | repository root       | **Yes**, and this model argues it is trusted too far (TM-09)      |
| `--force-posture <posture>`   | operator argv         | **Yes**, but only when it names the live posture                  |
| `--yes`                       | operator argv         | No longer trusted above `development` — inert by design           |
| `DOCKER_HOST` etc.            | ambient process env   | **Not read, and not checked** — see TM-01                         |
| Exported `DEPLOYMENT_POSTURE` | ambient process env   | **Must not be read** — see TM-04                                  |

### Severity scale

| Level      | Definition                                                                |
| ---------- | ------------------------------------------------------------------------- |
| `CRITICAL` | Exploitable without authentication, or full compromise / credential theft |
| `HIGH`     | Exploitable with low-privilege access; significant data or integrity risk |
| `MEDIUM`   | Exploitable under specific conditions; moderate impact                    |
| `LOW`      | Minor impact; defence-in-depth measure                                    |

Only **CRITICAL** and **HIGH** block sprint planning
(`project-management/docs/SECURITY-GUIDE.md`). **This model produced none of either** — see
Section 4, and read that section together with Section 3a rather than alone.

## 2. Trust boundaries

| ID  | From                        | To                        | Data crossing                                                    |
| --- | --------------------------- | ------------------------- | ---------------------------------------------------------------- |
| TB1 | Operator shell              | Guarded script            | `--force-posture`, `--yes`, subcommand, stdin tty state          |
| TB2 | Repository checkout         | The guard                 | `.copier-answers.yml` contents; presence of root `copier.yml`    |
| TB3 | Ambient process environment | Guarded script            | `DOCKER_HOST`, `DOCKER_CONTEXT`, `COMPOSE_PROJECT_NAME`, exports |
| TB4 | The guard                   | The destructive operation | The permit/refuse verdict, and the exit code carrying it         |
| TB5 | CI runner                   | Guarded script            | A committed `--force-posture` literal, and `\|\| true`           |
| TB6 | Copier upstream             | The carrier               | `copier update` rewriting or conflicting `.copier-answers.yml`   |

## 3. STRIDE threat table

**Status is `Proposed` at planning time.** Re-assessed against shipped code in the
`../IMPLEMENTATION/` counterpart.

| ID    | STRIDE | OWASP      | NIST CSF | TB  | Threat description                                                                                                                                                                                                        | Severity | Status   | Mitigation (proposed control)                                                                                                                                                        |
| ----- | ------ | ---------- | -------- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| TM-01 | S      | `A01:2025` | `PR.PS`  | TB3 | The guard authenticates the **repository**; the `DROP` lands on whatever Docker is pointed at. `DOCKER_HOST`/`DOCKER_CONTEXT` select the daemon and `COMPOSE_PROJECT_NAME` outranks the compose file's `name:`            | MEDIUM   | Proposed | The guard asserts the resolved compose target is the local dev/test stack and refuses if Docker is pointed elsewhere. Settled at this gate (Q1)                                      |
| TM-02 | T      | `A02:2025` | `PR.DS`  | TB2 | A `grep`-based read is flipped by a **commented** key. `.copier-answers.yml:1-7` already ships seven comment lines, so `# DEPLOYMENT_POSTURE: development (until cutover)` reads as `development` on a production project | MEDIUM   | Proposed | Anchored match on `^DEPLOYMENT_POSTURE:`, quote-tolerant, rejecting inline comments; a duplicate key is a refuse state, not a first-match win                                        |
| TM-03 | T      | `A02:2025` | `DE.CM`  | TB4 | **The control has no presence test.** Deleting the guard call is a one-line change nothing notices — no audit inspects script-to-helper wiring, and `--self-test` proves the guard's behaviour, never its presence        | MEDIUM   | Proposed | An assertion that each bound script invokes the guard before its first destructive command, and that `migrate.sh` warns. A tested function is not an enforced control                |
| TM-04 | S      | `A01:2025` | `PR.PS`  | TB3 | An **exported** `DEPLOYMENT_POSTURE` shadows the carrier. The house idiom two lines away (`reset.sh:24-25`, `restore.sh:23-24`) is `"${VAR:-$(grep …)}"` — environment wins — which re-opens the channel the design bans  | LOW      | Proposed | The guard reads the carrier **only**. No `${DEPLOYMENT_POSTURE:-…}` construction anywhere in it, asserted by the self-test with the variable exported                                |
| TM-05 | E      | `A01:2025` | `PR.AA`  | TB2 | The template exemption is **one unauthenticated file test that silently disables the whole control**. Any `copier.yml` at a generated project's root — a nested sub-template, a scratch file, an agent — turns it off     | MEDIUM   | Proposed | Carrier evaluated **first**: a legal posture is honoured even when `copier.yml` is present, so the exemption is unreachable in any project that has an answer. Settled here (Q2)     |
| TM-06 | D      | `A06:2025` | `PR.PS`  | TB1 | Inert `--yes` plus a **closed stdin** is a silent `exit 0` no-op. `reset.sh:98-103` does `read -r REPLY \|\| true` then aborts at 0 on EOF, so a correctly authorised scripted caller reports success having done nothing | MEDIUM   | Proposed | Above `development`, absence of a tty is a refusal at exit 4 with the guard prefix — never an abort at 0. Settled here (Q3)                                                          |
| TM-07 | D      | `A06:2025` | `RC.RP`  | TB2 | **A damaged carrier has no statable recovery.** Four states refuse, the refusal must name "the live posture", and `--force-posture` must name it too — but there is no live posture to name                               | MEDIUM   | Proposed | `--force-posture` validated against the literal set before the carrier is consulted, so it stays satisfiable in all four damaged states; damaged-carrier refusal is its own message  |
| TM-08 | T      | `A02:2025` | `PR.DS`  | TB6 | The six-state enumeration is **not exhaustive**. A `copier update` three-way merge more usually **duplicates** the key with conflict markers than removes it — the class `_lib/conflict-markers.sh` exists for            | MEDIUM   | Proposed | A conflicted carrier is its own refuse state, detected with the existing helper. US006's claim that merge damage lands in the absent-key state is corrected                          |
| TM-09 | E      | `A01:2025` | `PR.AA`  | TB1 | **`server.sh up --seed` is unbound**, and `--force-posture` is inert on unguarded subcommands. It shells to `database/seed-dev.sh`, whose own header (`:3`) advertises "dev and staging" — a posture the guard refuses at | MEDIUM   | Proposed | `up --seed` and `seed-dev.sh` join the bound set. Section 0 names a fixture load against a live environment explicitly. Settled here (Q4)                                            |
| TM-10 | E      | `A05:2025` | `PR.PS`  | TB5 | The CI caller commits a **standing override** into a file that ships everywhere, behind `\|\| true` that hides its failure. A project whose posture rises past the literal gets a silently green, skipped teardown        | MEDIUM   | Proposed | `\|\| true` dropped from the guarded call so a stale literal fails loudly; the story names who updates it when the posture rises                                                     |
| TM-11 | S      | `A05:2025` | `PR.PS`  | TB2 | Three spellings of the `copier.yml` probe exist and disagree on resolution — `[ -f copier.yml ]` is **cwd-relative** and reads the operator's directory, not the script's repository                                      | LOW      | Proposed | `$PROJECT_ROOT`-anchored test only, resolved from `BASH_SOURCE` as every `_lib` caller already does                                                                                  |
| TM-12 | S      | `A08:2025` | `PR.DS`  | TB2 | **`migrate.sh fake` and `fake-initial` are not non-destructive.** They rewrite the schema's record of itself, which is the premise N-003 rested warn-only on                                                              | LOW      | Proposed | Recorded as a correction to N-003's premise, not acted on here — `<%DEVELOPER_NAME%>` held warn-only at round 2 Q7 knowing the disposition. Section 3a carries its promotion trigger |
| TM-13 | D      | `A06:2025` | `PR.PS`  | TB4 | A **wrapped call site suspends `set -e`** inside the helper, so a fail-closed guard can fall through to success — `if guard; then` and `guard \|\| …` both disarm the exit-on-error the design leans on                   | LOW      | Proposed | The helper returns a status and every caller branches on it explicitly and exits; the self-test asserts the caller's exit code, not only the helper's verdict                        |
| TM-14 | D      | `A06:2025` | `PR.PS`  | TB1 | **Three unguarded routes wipe the test volumes** on every test run; only the documented one is bound, so the guard's coverage of `tests/server.sh` is narrower than it reads                                              | LOW      | Proposed | Residual, recorded not closed — test volumes are disposable by design (`MAP-SCRIPT-GUARDS` N-001 rules the teardown traps out of scope)                                              |
| TM-15 | I      | `A01:2025` | `PR.DS`  | TB2 | The feature gives five scripts a read of the file holding **every generation answer**, widening what a bug in any of them can disclose                                                                                    | LOW      | Proposed | The guard extracts one key and never echoes the file; the refusal prints the posture and nothing else from it                                                                        |
| TM-16 | R      | `A09:2025` | `DE.AE`  | TB1 | **The override is the authorisation, and it is written nowhere.** A destructive run above `development` leaves shell history as its only trace                                                                            | INFO     | Proposed | Stated as accepted residual: `code/docs/security/AUDIT-TRAIL.md` covers the application, not a developer script. Named rather than left to be assumed                                |
| TM-17 | I      | `A09:2025` | `DE.CM`  | TB4 | **"Before the preflight" is vacuous in the two `server.sh` scripts**, which have no container preflight — so the placement clause under-specifies where the guard fires in two of the four bound scripts                  | LOW      | Proposed | The clause is restated as "before the first destructive command", which is well-defined in all five                                                                                  |
| TM-18 | R      | `A09:2025` | `DE.AE`  | TB4 | **Refusal and operator-decline are distinguishable only by exit code**, and the decline path exits 0 — so a log shows a permitted-then-declined run identically to a success                                              | INFO     | Proposed | Exit 4 plus the `posture-guard: refused —` prefix makes the refusal greppable; the decline path is unchanged and out of scope                                                        |

## 3a. Design-state severity and promotion triggers

**Every severity above is a present-state reading of a tree with nothing deployed.** This project's
posture is `development` and no surface is live, so a control that fails open harms nothing _today_.
Read the table with this one, or the `LOW`s will be mistaken for a verdict on the design.

| Threat       | Present state | Design state | Promotes when                                                                              |
| ------------ | ------------- | ------------ | ------------------------------------------------------------------------------------------ |
| TM-01, TM-05 | MEDIUM        | **HIGH**     | The first surface reaches `staging` — the guard then stands between a person and real data |
| TM-02, TM-08 | MEDIUM        | **HIGH**     | The first `copier update` runs against a project at `staging` or above                     |
| TM-04, TM-11 | LOW           | **MEDIUM**   | Any generated project acquires a nested `copier.yml`, or a wrapper exports the variable    |
| TM-12        | LOW           | **HIGH**     | `migrate.sh fake` is run against a deployed database — warn-only permits it today          |
| TM-03        | MEDIUM        | **HIGH**     | The first edit to a bound script by anyone who has not read this model                     |

## 4. Blocking findings & escalations

**None.** No `CRITICAL` and no `HIGH` finding was raised, so no vulnerability record is written and
sprint planning is not gated. That is a measured outcome with its reason, not an audit that found
nothing: eighteen threats were raised across six STRIDE categories and all eighteen resolve to
`MEDIUM` or below **because nothing this repository ships is deployed**. Section 3a names the event
that promotes each, and five of them promote to `HIGH`.

Per `code/docs/GATE-REPORTING.md` this is never reported as "the security gate passed".

## 4a. Developer constraints carried forward

Checkable by reading the shipped helper and its callers. These become US006 acceptance criteria.

1. The guard reads the carrier only — no `${DEPLOYMENT_POSTURE:-…}` construction exists in it
2. The carrier match is anchored, quote-tolerant, comment-rejecting; a duplicate or conflicted key refuses
3. `copier.yml` is tested `$PROJECT_ROOT`-anchored, never cwd-relative
4. The carrier is evaluated before the template proof; a legal posture beats a present `copier.yml`
5. `--force-posture` is validated against the literal posture set before the carrier is read
6. Above `development`, no tty is a refusal at exit 4, never an abort at 0
7. Every bound script branches on the guard's status explicitly and exits; no wrapped call site
8. Each bound script's guard call is asserted present, not merely functional
9. `up --seed` and `seed-dev.sh` are bound
10. The CI caller carries no `|| true` on the guarded call
11. The refusal prints the posture and the re-run command, and nothing else from the carrier

## 5. Out of scope

- **Posture enforcement outside the script layer** — Django settings and CI itself
  (`MAP-SCRIPT-GUARDS` _Out of scope_); a new register entry, not scope creep here
- **The test-teardown `down --volumes` traps** — destructive by design on every run (N-001)
- **`template-update.sh`** — already refuses without its own `--force-*` flags (N-001)
- **The superuser `psql` shell** — an operator with it needs no bypass; the guard raises the cost
  of a mistake, and was never a boundary against a determined operator
- **A general sanction for scripts reading `.copier-answers.yml`** — N-003 sanctioned the posture
  read only

---

## Cross-references

- `../IMPLEMENTATION/THREAT-MODEL-IMPL-US000-TEMPLATE.md` — the post-implementation review that
  re-assesses this model
- `../../ASSESSMENTS/PLANNING/` — the posture assessment that consumes this model
- `../../VULNERABILITIES/PLANNING/` — where blocking findings escalate; none from this model
- `../../../02-STORIES/` — the story being modelled
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `project-management/workflows/10-security-checks/` — the workflow that produces this model
- `code/docs/SECURITY.md` — the code-side enforcement these controls specify
- `code/docs/GATE-REPORTING.md` — why Section 4's absence is stated rather than left implied
