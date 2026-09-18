# ADR-US008: The cookie advisory is gated on project state as well as on a version key, and the key is derived at release

**Status:** Accepted
**Date:** 17/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026.md`
**Superseded by:** —
**Related:** US008 · `project-management/src/15-DECISIONS/ADR-US008-MITIGATION-OWNS-ITS-CHANNEL-17-09-2026.md` (the channel the advisory prints into) · `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US008-HOST-ONLY-COOKIES.md` Section 3b (the measurement that opened this) · `project-management/src/11-QA/PLANNING/QA-PLAN-US008-HOST-ONLY-COOKIES.md` AC-GAP-1

---

## Context

**The record this supersedes was right about the mechanism and wrong about the number, and the
reason it went wrong is not a mistake anyone made.** `ADR-US008-FIRST-MINOR-MIGRATION-KEY-09-09-2026`
proved on copier's own `Template.migration_tasks()` that a `_migrations:` key may name a MINOR
release, fixed the cookie advisory at `v7.6.0` because that was the release the doctrine was then
going to ship in, and stated the governing rule plainly: **a key names the release the change
shipped in, whatever that release's semver tier.** That rule survives this record intact. What did
not survive is the premise that US008 would ship in 7.6.0.

**What moved, measured 17/09/2026:**

| Reading                                | Value                                                                      |
| -------------------------------------- | -------------------------------------------------------------------------- |
| `VERSION` on `pm/story-creation`       | **7.6.0**, bumped at `16aac54` on 14/09/2026 by the shared-AI / Codex work |
| `VERSION` on `main` and `origin/main`  | **7.5.0**                                                                  |
| `git tag \| wc -l` · newest tag        | **77** · **`v7.5.0`**. There is no `v7.6.0` tag                            |
| `CHANGELOG.md`                         | `## [7.6.0] - 14/09/2026`, describing the Codex release and nothing else   |
| Commits on this branch above `16aac54` | Two — `fff578f` (scrapling) and `1e00a4b` (PM), in no CHANGELOG entry      |

Two things follow, and they point in opposite directions.

**The damage is prospective, not shipped.** `Template.version` is read by dunamai from git tags.
There is no `v7.6.0` tag and the version state is not even on `main`, so **no generated project can
ever have resolved to 7.6.0**. The stranding AC-GAP-1 describes — a project at `from_template.version
== 7.6.0` for which `7.6.0 < 7.6.0` is false, taking the `__Host-` names with its old `Domain` line
intact and failing every login behind a successful update — has no population yet. It acquires one
the moment `v7.6.0` is tagged for a release that does not carry the doctrine.

**And the mechanism that produced it will produce it again.** This is the second time in this
repository that a `_migrations:` key has been falsified by a release moving underneath it. The first
is on the record at `copier.yml:929-932`: _"This repository has mis-keyed a migration by tagging a
batch retroactively, which strands every project that updated in between."_ The superseded record
cited that line as the rule it was obeying, and was falsified by the same class of event eight days
later. **A rule that is obeyed correctly and still fails is not a rule that needs restating more
firmly — it is a rule with a missing half.** The missing half is that a key is a claim about the
future, written at design time, and nothing keeps it true between then and the release.

**The constraint the advisory actually has to satisfy** is narrower than "fire at the right
version". The state it warns about — a `__Host-` cookie name shipped alongside a `Domain`
attribute — is wrong **whenever** it occurs, by the prefix's own definition (N-005, RFC 6265bis).
It is not a one-time crossing. The other half of the advisory, that the rename invalidates every
live session and open CSRF token so the cutover timing is the operator's decision, genuinely **is**
a one-time crossing and needs a version to hang on.

**The file already contains the answer to half of it.** `copier.yml:827-828` carries an
unversioned entry — `shared-ai-symlinks.sh` — with the reason stated in its own comment:
_"Ungated by version so this also reaches a project upgrading from an unreleased ref."_ That is this
failure mode, named and solved once already, three months before the superseded record was written
and never considered by it. `copier.yml:945` carries a second unversioned entry on a different
ground. The precedent for two keys covering two populations is also in the file, at `:889` and
`:903`, where one script is deliberately keyed twice because _"Two keys cover both populations and
one cannot, whichever single version it names."_

## Options considered

### Option A — re-key to a bigger number and ship the same single entry

- **Summary:** supersede on the number alone; the advisory becomes one entry keyed at whichever
  release US008 lands in.
- **Pros:** the smallest possible change, and the superseded record's rule is preserved verbatim.
- **Cons:** **it fixes this instance and not the class.** The new number is a claim about the
  future made at design time, exactly as `v7.6.0` was, and SPRINT-05 is not the last thing that
  will land before release. It also leaves the security-critical half — the always-wrong
  combination — behind a number that has already been wrong once, in a repository whose own
  `copier.yml` records the same failure a second time at `:929-932`.

### Option B — drop the version key entirely; one unversioned, state-gated entry

- **Summary:** the entry always runs, greps the project's settings for `SESSION_COOKIE_DOMAIN` and
  `CSRF_COOKIE_DOMAIN`, and reports only when it finds one. No key can be wrong because there is no
  key.
- **Pros:** immune to every key-timing failure — a retroactive tag, an unreleased ref, a release
  that shifts under a design. Precedented in the same file at `:827-828` with the reason already
  written down. Self-limiting: it stops reporting once the project fixes the line.
- **Cons:** **it cannot carry the cutover notice.** A project that never set `_DOMAIN` still takes
  the `__Host-` rename and still has every session and open CSRF token invalidated at first deploy
  — it needs telling once, and a state gate that keys on `_DOMAIN` will never tell it. Detecting
  "this update is the crossing" without a version means comparing before and after across two
  migration stages, which is a second mechanism to keep true.

### Option C — two entries, each gated on what it is actually about (the decision)

- **Summary:** an **unversioned, state-gated** entry for the broken combination, and a
  **version-keyed** entry for the one-time cutover notice, with the key derived at release rather
  than at design time.
- **Pros:** each half is gated on the thing that makes it true — state for a condition that is
  wrong whenever it holds, a version for an event that happens once. The security-critical half can
  no longer be mis-keyed, because it has no key. Both precedents are already in the file.
- **Cons:** two scripts and two register rows instead of one, and an update that crosses the key
  while carrying a `_DOMAIN` line prints two reports. `copier.yml:893-896` already accepted that
  exact cost for the git-guide advisory — _"Accepted rather than guarded … a `when:` narrow enough
  to suppress it would be a third thing to keep true."_

### Option D — hold the doctrine until the next MAJOR

- **Summary:** ship the settings and guides now, hold the advisory for `v8.0.0`.
- **Pros:** every key stays `.0.0` and the first-minor-key question disappears.
- **Cons:** the superseded record refuted this at length as its own Option C, and nothing in the
  measurement changes that refutation — every project updating between the doctrine's release and
  8.0.0 crosses the change and never sees the report. It is the mis-keying at `:929-932` chosen
  deliberately rather than by accident.

## Decision

**We will take Option C: the cookie advisory ships as two `_migrations:` entries, gated on
different things, and the version key is derived at release rather than at design time.**

The deciding factor is that **the two halves of the advisory are true for different reasons, and a
single gate can only be correct about one of them.** A `__Host-` name beside a `Domain` attribute is
a broken state, not an event — it is wrong on the day it arrives and every day after, whatever
version produced it, and gating it on a version means a project that reaches that state by any path
the key did not anticipate is never told. The session invalidation is the opposite: an event that
happens exactly once, at one crossing, and a state gate has nothing to read. The superseded record
put both behind one version key because it was reasoning about **where the advisory goes**, not
about **what makes each of its two claims true**.

Four things follow. They are the shape of the decision, not build instructions — the scripts, the
entries and the register rows are US008's tasks, executed and ticked there.

- **The unversioned entry is `.copier/migrations/cookie-domain-conflict.sh`**, named without a
  version prefix on `shared-ai-symlinks.sh`'s convention, because a filename recording "the release
  it was written for" is meaningless for an entry that is not keyed to one. It greps the project's
  settings modules for `SESSION_COOKIE_DOMAIN` and `CSRF_COOKIE_DOMAIN`, reports each hit with file,
  line and setting name, **never a value**, and exits 0 always. **It is silent when it finds
  nothing** — a deviation from the two shipped advisories, which banner unconditionally, and a
  deliberate one: an entry that runs on every update forever must cost nothing on the updates where
  it has nothing to say.
- **The keyed entry is `.copier/migrations/v<RELEASE>-host-only-cookies.sh`**, on the convention
  `v3.0.0-self-authored-agents.sh` and `v5.0.0-git-guide-split.sh` fix, carrying the cutover notice
  — the invalidation in both directions and the rolling-deploy hazard — and ending in the proof
  step, the unscoped `bash code/src/scripts/audits/negative-space.sh`.
- **The key is derived at release, and the tag lands in the same act.** `v7.7.0` is the expected
  value as the tree stands on 17/09/2026: `v7.6.0` is tagged at `16aac54`, which is exactly what its
  CHANGELOG entry describes, and US008 ships in the next minor. **That number is a prediction, and
  the story must re-derive it against `git tag` at the moment of release rather than carry it from
  this record** — which is the precise mistake this ADR exists to stop repeating. A key written into
  `copier.yml` before the tag it names exists is an unverified claim, and the verification is one
  command.
- **Both entries get a row in `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md`'s register.** That table
  does not currently carry one for `shared-ai-symlinks.sh` — an unversioned entry shipped without a
  register row, measured 17/09/2026 — so the row for the unversioned entry also establishes how an
  unkeyed entry is written into a table whose first column is `Version`. Repairing the missing
  `shared-ai-symlinks.sh` row is **not** US008's work; it is noted here and belongs in `GAPS.md`.

**What this record does not change.** The superseded record's rule — a key names the release the
change shipped in, whatever its tier — stands, and the first minor-keyed migration is still what
this template will carry. Its proof of the mechanism on `Template.migration_tasks()` stands, and is
not re-derived here. Its version-safe citation rule stands. Its judgement that the advisory reports
rather than acts stands, and Option B of that record — a migration that deletes the `_DOMAIN` lines
it finds — remains refuted on the same grounds.

## Consequences

- **Positive:** the half of the advisory that prevents a total login failure can no longer be
  mis-keyed, because it is not keyed. A project that reaches the broken state by a path nobody
  predicted — a hand-edited settings module, an update from an unreleased ref, a key that went wrong
  a third time — is still told, on every update, until it is fixed.
- **Positive:** the failure mode is now named rather than re-learned. `copier.yml:929-932` recorded
  the retroactive-tagging instance; this record adds the design-time instance and the rule that
  covers both: **a version key is derived at release, not at design.**
- **Negative / trade-off:** two entries and two scripts where the superseded record had one, and a
  duplicate report on the one path that crosses the key while carrying a `_DOMAIN` line. Accepted on
  `copier.yml:893-896`'s own reasoning for the identical cost.
- **Negative / trade-off:** the unversioned entry runs on every `copier update` for the life of the
  template. It is a grep over a directory that exits 0 and prints nothing in the ordinary case, and
  nothing retires it — a later record may judge the class closed once no supported project can still
  carry the old mandate, and that is a decision with no evidence available today.
- **Negative / trade-off:** a project that holds a `_DOMAIN` line deliberately — the N-005 case, with
  its two named limits — now gets that report on **every** update rather than once. That is the cost
  of a state gate over a version gate, and it is the right way round: a report it must judge and
  dismiss is cheaper than a silent total login failure.
- **Follow-on:** US008 carries both scripts, both `copier.yml` entries, both `06-GENERATION.md` rows,
  and the re-derivation of the key at release. Its acceptance criteria move from "the four version
  files move to 7.6.0" to the release the doctrine actually ships in, with the tag as the proof.
- **Follow-on:** `v7.6.0` is tagged at `16aac54` when this branch merges, and `fff578f`'s scrapling
  work, the render-slop audit change and both SPRINT-05 stories become the next minor — which owes a
  `CHANGELOG.md` entry, since `## [Unreleased]` is empty on 17/09/2026. That is release work, owned
  by the `release` and `version` skills, not by this record.
- **Follow-on:** the missing `shared-ai-symlinks.sh` row in `06-GENERATION.md`'s register is a
  `GAPS.md` entry dated 17/09/2026, not a US008 task.
