# ADR-US006: The override names the live posture, and buys nothing else

**Status:** Accepted
**Date:** 05/09/2026 · corrected in place 05/09/2026, before first commit — see _Errata_
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US006

---

## Context

`ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` settles what the guard reads and when it
refuses. This record settles the other half: **how an operator who genuinely needs to run a
destructive command above `development` says so.**

The requirement is not "let me through". A guard with no escape hatch is a guard that gets
commented out the first time someone needs it not to be there, and there are legitimate runs above
`development` — a rehearsal against staging, a restore from backup, the CI teardown at
`.github/workflows/test-e2e.yml:133` that ships into every generated project. The requirement is
that the escape hatch **costs something proportionate to the risk**, and that its cost cannot decay
to zero over time.

Three facts bound the design:

- **A committed override goes stale silently.** `.github/workflows/test-e2e.yml:133` runs
  `bash code/src/scripts/development/server.sh down --volumes || true` and ships into every
  generated project. Whatever override form it carries is written once and read by nobody
  afterwards, so a form that stays valid as the posture rises is a form that stops meaning
  anything. That is TM-10.
- **The house parses flags space-separated.** `database/restore.sh:71`,
  `development/server.sh:92` and `database/migrate.sh:113-116` are all space-separated; no
  `=`-form value flag is parsed anywhere under `code/src/scripts/**`. The repository's one
  `=`-form parser sits outside that tree, at
  `project-management/src/00-ASSETS/scripts/export-pm-files.sh:97-105`.
  **`MAP-SCRIPT-GUARDS.md` S-01 nonetheless charted the override as `--force-posture=<posture>`.**
- **The existing confirmation prompts already have a bypass.** `reset.sh` and `restore.sh` take
  `--yes`, and each aborts at **exit 0** when `read` returns empty (`reset.sh:98-103`,
  `restore.sh:100-105`). So a scripted caller that reaches the prompt without a tty reports
  success having done nothing — TM-06, and the reason the override's interaction with `--yes` and
  with the terminal has to be stated rather than left to fall out.

One more thing needed settling, and the map got it wrong. S-01 charted an unreadable carrier as
dying at **exit 2** — one failure state, and the code this repository reserves for a script error.
The carrier ADR's fail-closed set has five damaged states, an unrecognised value and two refusing
postures — **eight** — and none of them is a script error: the script ran correctly and the command
was well formed.

## Options considered

### Option A — a boolean `--force`

- **Summary:** one flag, no argument. It means "I know, do it anyway".
- **Pros:** shortest to type and impossible to get wrong. Matches `--yes`, which is the flag
  sitting next to it.
- **Cons:** **it never expires.** Once written into the CI workflow, or into a shell history, or
  into a runbook, it stays valid as the project moves from `staging` to `production` — so the one
  thing that most needs re-examining when the posture rises is the one thing that silently does
  not. It also proves nothing about the operator: `--force` is typed by someone who read the
  refusal and by someone who did not, identically.

### Option B — `--force-posture=<posture>`, as charted

- **Summary:** name the posture, `=`-separated, per `MAP-SCRIPT-GUARDS.md` S-01.
- **Pros:** the naming half is right, and it is what the map already says.
- **Cons:** the spelling is wrong for this tree. Every value flag under `code/src/scripts/**` is
  space-separated, and introducing the repository's second `=`-form parser — in a security control,
  where a parse quirk is a bypass — buys nothing. A reader who types the house form gets an
  unknown-option `die` rather than a refusal.

### Option C — `--force-posture <posture>`, naming the posture the project is at now

- **Summary:** space-separated, and the value must equal the posture the carrier currently reports.
  Any other value refuses.
- **Pros:** **it expires by construction.** An invocation pasted from history, or committed into a
  workflow, dies the moment the posture rises — which converts TM-10 from a silent staleness
  problem into a loud one, provided `|| true` is also removed from the CI call. It proves the
  operator has read the current posture rather than merely wanting past the guard. And it matches
  the house parsing idiom, so it needs no new argument-handling shape.
- **Cons:** more to type, and it makes the override useless in exactly the states where the carrier
  cannot be read — there is no live posture to name. It also puts a literal into a committed CI
  file that someone must update, which is a maintenance obligation rather than a mechanism.

### Option D — an environment variable, `POSTURE_GUARD_OVERRIDE`

- **Summary:** set it in the environment rather than passing a flag.
- **Pros:** crosses a shell-out for free, which would have answered the `server.sh` →
  `seed-dev.sh` forwarding problem without an explicit forward.
- **Cons:** a second way in. `N-003` rejected the dated-annotation idiom on precisely that
  reasoning, and criterion 7.1 bans reading the posture from the environment at all — an override
  channel that reuses the banned mechanism is the control's own bypass in a different hat. An
  environment variable also persists across commands in a shell, so it is `--force` with a longer
  lifetime.

### Option E — keep `--yes` as the override above `development`

- **Summary:** no new flag; the existing confirmation bypass doubles as the posture override.
- **Pros:** nothing new to learn or document.
- **Cons:** it conflates two different questions — "are you sure?" and "do you know where this is
  pointed?" — and it inverts the safer answer: the operator who most wants to skip the prompt is
  the one running scripted, which is the case the guard most wants to slow down. It would also make
  every existing scripted `reset.sh --yes` in the world a posture override, retroactively.

## Decision

**We will take Option C.** The override is `--force-posture <posture>`, space-separated, and it
must name the posture the project is at **now**.

The deciding factor is **expiry**. Every other option produces an authorisation that outlives the
circumstances it was granted under, and the one committed instance of it — the CI teardown — is
written once and never read again. An override that names the live posture is the only form where
the passage of time turns a stale invocation into a loud failure rather than a quiet permission.
Option B's naming half is the same idea; only its spelling loses, and it loses on a measured fact
about how this tree parses flags.

Four consequences follow from the same principle, and each is a rule rather than a preference:

- **It does not buy silence.** `--yes` is inert above `development`: the confirmation prompt still
  runs. The override proves the operator knows the posture; it was never a licence to skip the
  question. Option E is rejected in the same breath.
- **It is the override that carries the authorisation, not the terminal.** A valid
  `--force-posture` naming the live posture satisfies the guard whether or not a tty is present.
  TM-06's hazard is a prompting script aborting at exit 0 with no tty, and that binds `reset.sh`
  and `restore.sh` — the only two scripts that prompt. Read any wider it would refuse the CI
  teardown this record exists to keep working, which is the contradiction `11-qa-checks` found and
  closed as AC-GAP-1.
- **It is not honoured when no posture can be read.** In the five damaged-carrier states there is
  nothing to name, so validation against the three literals is all that remains — and
  `--force-posture development` would permit a destructive run on a `production` project. The
  recovery path there is repairing the carrier. The flag is still validated **before** the carrier
  is consulted (criterion 7.5), so what the operator gets is a specific refusal naming the repair
  rather than an unknown-option error: the guard is refusing the run, not the flag.
- **A refusal exits `4`.** Not 1, which this tree reserves for a command that failed, and not 2,
  which it reserves for a script error. **A correct command refused on policy is neither.** The map
  charted 2 against a single failure state; the fail-closed set has eight, and every one of them is
  a policy refusal. The code is declared in each of the six guarded scripts' own header comment and
  usage heredoc — twelve lines — so an operator reading `--help` learns it without reading this
  record.

## Consequences

- **Positive:** the escape hatch cannot decay. The one committed override in the tree fails loudly
  the day the posture rises, rather than continuing to authorise a teardown nobody re-examined.
- **Positive:** exit `4` gives every caller — a human, a CI step, a future audit — a way to
  distinguish "refused on policy" from "broke". `|| true` is dropped from
  `.github/workflows/test-e2e.yml:133` in the same change, because a code nothing reads is a code
  that does not exist.
- **Negative / trade-off:** **the CI literal is a maintenance obligation, and this record names its
  owner.** <%DEVELOPER_NAME%> updates it in the same commit that raises `DEPLOYMENT_POSTURE` in
  `.copier-answers.yml`, and the owner and trigger are written as a comment beside the literal so
  they travel with the thing they govern. An obligation recorded only in an ADR is an obligation
  nobody reads at the moment it binds.
- **Negative / trade-off:** the flag must cross a shell-out. `development/server.sh:149` invokes
  `seed-dev.sh` with no arguments, and `seed-dev.sh:70-72` dies at exit 2 on an unknown option, so
  binding both ends without forwarding leaves an authorised operator refused by the inner guard
  with no way to satisfy it — a bound path with no open state at all. `server.sh` therefore
  forwards `--force-posture` verbatim, and `seed-dev.sh` parses it ahead of its own `die`.
  Option D would have got this for free; it is the one thing that option was better at, and it does
  not outweigh a second override channel.
- **Negative / trade-off:** more typing at a moment of stress. Accepted deliberately: the friction
  is the point, and it is bounded — the refusal prints the exact command to re-run with.
- **Follow-on:** `MAP-SCRIPT-GUARDS.md` S-01's two divergences — the space-separated spelling, and
  the exit-2 clause becoming the fail-closed set at exit 4 — **were already re-cut in commit
  `3d149e9`**, with both write-ups beneath the Slices table at `map:75-92`. One edit remains: S-01's
  Acceptance cell still names four bound scripts and does not carry `seed-dev.sh` or `up --seed`,
  which joined the set at gate 10. A slice row stating a contract the story cut from it contradicts
  is the drift the folder's index-not-vault rule exists to stop.
- **Follow-on:** `how-to/docs/CLI-TOOLING.md` documents `--force-posture` on the scripts it already
  lists. `database/restore.sh` and `tests/server.sh` gain no entry, having none today; they belong
  to `MAP-RULE-OWNERSHIP` slice `S-03`'s index re-cut.
- **Follow-on:** `up` is now **partially** bound — on `--seed`, not on `--build`. So
  `.github/workflows/test-e2e.yml:91` runs the same guarded script unbound and needs no override,
  and a later story binding `up` more widely **falsifies this record's CI reasoning** and
  supersedes it rather than extending it.

---

## Errata

**Corrected in place 05/09/2026, before this record reached a commit.** The `15-DECISIONS`
immutability rule protects a decision a reader may have relied on; this one had not been committed,
so nobody could have. The correction is recorded rather than made silently, on the precedent of
`ADR-US005-ONE-LAYER-DECIDES-TO-RETRY-04-09-2026.md`, whose worked clamp was corrected on the same
terms.

- **The fail-closed set is eight, not seven.** As first written this record said "five damaged
  states plus two refusing postures" and "the fail-closed set has seven". It omits the
  **unrecognised carrier value**, which
  `ADR-US006-POSTURE-CARRIER-FAILS-CLOSED-05-09-2026.md` enumerates and which refuses like the
  rest. Two Accepted records stating different sizes for the same set is exactly what gate 15's
  pairwise clash check exists to catch, and it caught it. The behavioural verdict never differed —
  an unrecognised value cannot equal any legal `--force-posture` literal, so the run refuses either
  way — but the refusal **message** did: criterion 7.11 splits on whether a posture is readable,
  and this state sat in neither branch. It takes the damaged-carrier form, naming the repair.
