# ADR-US009: `install.sh` becomes the only thing that arms the git hooks, and the package-manager lifecycle script that also armed them is removed

**Status:** Accepted
**Date:** 17/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US009 · `project-management/src/11-QA/PLANNING/QA-PLAN-US009-HOOK-ARMING.md` AC-GAP-1 · `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md` TM-01 and Section 3b · `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` N-019

---

## Context

**US009 was written to close an absence and would have shipped without closing the silence, and the
silence is the half its own User Story leads with.** The story asks for hooks that are _"either
armed and visible from the first commit, or absent and known — never arming themselves silently at
a moment I did not choose."_ It then requires, as `ST02`, that `package.json:11` be **byte-identical
after the change** — and `package.json:11` is the moment nobody chose.

**The channel.** `"prepare": "[ -d .git ] && lefthook install || true"`. npm and pnpm run `prepare`
after any install not told to skip lifecycle scripts.

**The split, re-measured 17/09/2026 across the whole tree.** Sixteen executable `pnpm install`
invocations. Five carry `--ignore-scripts`:

| Where                                                                | Count |
| -------------------------------------------------------------------- | ----- |
| `code/src/scripts/development/install-frontend.sh` `:67` `:84` `:93` | 3     |
| `code/src/scripts/mobile/install.sh` `:33` `:41` — mobile-only       | 2     |

**Eleven do not**, and every one of them fires `prepare`:

| Where                                                             | Count | When it fires                   |
| ----------------------------------------------------------------- | ----- | ------------------------------- |
| `.claude/hooks/lib/check-lockfiles.sh:147`                        | 1     | On `gh pr create` / `gh pr new` |
| `.github/workflows/claude.yml` `:154` `:210` `:271` `:346` `:575` | 5     | On push and pull request        |
| `.github/workflows/syntax-js-ts.yml` `:47` `:74`                  | 2     | On push and pull request        |
| `.github/workflows/syntax-markdown.yml:37`                        | 1     | On push and pull request        |
| `.github/workflows/audit-deps.yml:89`                             | 1     | On push and pull request        |
| `.github/workflows/test-api.yml:90`                               | 1     | On push and pull request        |

`--frozen-lockfile` freezes resolution; it does not suppress lifecycle scripts.

**This is not a hypothesis.** `.git/hooks/pre-commit` exists on this machine, is lefthook's
generated hook, and is dated 16/09/2026 — in a repository whose `install.sh` has never written a
single byte under `.git/`. It was armed by one of the eleven, at a moment nobody chose, which is the
exact event the story was written to end.

**So the story as specified fixes the absence and leaves the silence.** After it ships, the hooks
arm at the explicit step **and** continue to arm at PR time and in CI. `.copier/README.md:441`
becomes true; the User Story does not.

**Two readings were available and the story chose neither.** Either `prepare` is now redundant and
should go — a larger change than 3 SP prices — or it is deliberate belt-and-braces, in which case
`ST06`'s observation that `|| true` _"is correct for a lifecycle script and wrong for an explicit
step"_ is the opening of an argument about two owners with different failure semantics that the
story never finishes. Neither reading is written down, and the question is not asked anywhere in
the story.

## Options considered

### Option A — `prepare` stays; the story states which owner wins

- **Summary:** keep both arming paths, document the precedence and what happens when they disagree.
- **Pros:** holds the 3 SP estimate and SPRINT-05's `11 / 11` capacity; keeps a fallback for a
  contributor who never runs `install.sh`.
- **Cons:** **it ships a story that does not deliver its own headline.** The User Story's "never
  arming themselves silently" would be documented as continuing rather than fixed, which is not a
  clarification, it is a different story. It also keeps eleven unsuppressed lifecycle-script
  invocations doing real work, so `N-019`'s "`--ignore-scripts` is a deliberate supply-chain
  control" stays true of three lines and false of the posture it reads as.

### Option B — `prepare` stays but no-ops in CI

- **Summary:** guard the lifecycle script so silent arming happens only on a developer machine.
- **Pros:** removes ten of the eleven; smaller than removal; keeps the local fallback.
- **Cons:** the one that remains — `check-lockfiles.sh:147`, on PR creation — is on a developer
  machine, which is the only place the silence matters. It removes the invocations that were
  harmless and keeps the one that was not.

### Option C — `prepare` is removed; `install.sh` is the sole arming path (the decision)

- **Summary:** delete the lifecycle script; the explicit step in `install.sh` becomes the only thing
  that writes `.git/hooks/`.
- **Pros:** delivers the User Story exactly as written — one arming path, chosen, reported. Every
  `pnpm install` in the tree becomes inert with respect to `.git/`, so the supply-chain claim and
  the arming claim stop disagreeing.
- **Cons:** breaks the 3 SP estimate; a contributor who runs only `pnpm install` now gets no hooks
  and, without more, no notice — trading silent arming for silent absence, which is half of what
  the User Story refuses.

### Option D — remove `prepare` and add `--ignore-scripts` to the other eleven

- **Summary:** Option C plus closing the whole lifecycle-script surface.
- **Pros:** the supply-chain posture becomes what `N-019` reads as.
- **Cons:** eleven edits across six files, for a control whose only current consumer is the line
  being deleted. `QA-PLAN-US009` AC-GAP-3 is explicit that US009 should **not** fix the other eleven
  — they are out of scope, and the gap is that the criterion must state its scope. This is scope
  creep wearing a security justification.

## Decision

**We will take Option C, with the silent-absence cost closed by a lifecycle script that announces
and arms nothing: `prepare` is deleted and replaced by a `postinstall` that prints "the hooks are
not armed — run `bash install.sh`" and writes nothing.**

The deciding factor is that **the story's User Story is a specification, not a preamble.** It asks
for one arming moment, chosen by the developer. Options A and B both ship two, and a story whose
headline promise is documented as unmet is a story that has been re-scoped without anyone deciding
to re-scope it. Between "fix it" and "write down that we did not", the first is the only one that
leaves the backlog honest.

The `postinstall` is what makes Option C's cost survivable rather than merely accepted. It keeps the
exact channel the contributor already runs through — they typed `pnpm install`, and that is where
they learn something — and converts a side effect into a notice. **It arms nothing, writes nothing
outside stdout, and fetches nothing**, so `ST05` holds unchanged and `N-019`'s supply-chain reading
is strengthened rather than weakened: a lifecycle script that can only print is not a lifecycle
script anyone needs to suppress.

Its shape, which the story's tasks express:

- **Silent when the hooks are already armed**, so a working checkout never nags.
- **Silent in CI**, so ten workflow invocations do not print a warning about a machine that will
  never commit.
- **Silent where there is no git repository** — an exported tree has nothing to arm and nothing to
  say.
- **`install-frontend.sh`'s three `--ignore-scripts` branches suppress it**, which is correct:
  `install.sh` calls that script and then arms the hooks itself, so a notice printed there would be
  false three lines before it was made false.

**`ST02` inverts and `ST06` retires.** `ST02` becomes an assertion that `prepare` is **absent** and
that no lifecycle script arms anything. `ST06` reasoned about the right shape of `|| true` in a
lifecycle script; with the lifecycle script gone it has no subject. The guard question survives only
for `install.sh`, where it is `git rev-parse --git-dir` rather than `[ -d .git ]` — a call made at
this gate rather than an ADR, because `[ -d .git ]` is simply false in a worktree and there is no
trade-off to record.

**US009 is re-estimated 3 to 5 SP**, and SPRINT-05 goes to `13 / 11 SP`, the grace ceiling, closed.
`project-management/docs/planning/STORIES.md` puts the split advisory at >8; 5 is inside the band and
the story keeps one subject.

## Consequences

- **Positive:** the hooks arm in exactly one place, on purpose, with a reported line — and the
  repository stops being able to produce the artefact this record cites as its evidence, a
  lefthook hook nobody ran a command to install.
- **Positive:** `--ignore-scripts` on the three `install-frontend.sh` branches stops being the only
  thing standing between a `pnpm install` and a write into `.git/`. After this, nothing in
  `package.json` can write anywhere.
- **Positive:** `.copier/README.md:441` becomes true without being edited, which was the story's
  original goal and is unaffected by this decision.
- **Negative / trade-off:** a contributor who runs only `pnpm install` has no hooks. They are told,
  once, by the `postinstall` — and a notice is weaker than an arming. Accepted: "absent and known"
  is what the User Story asks for, and it is the half this project can honestly deliver without
  taking the choice away again.
- **Negative / trade-off:** CI no longer has git hooks installed. Nothing is lost — every workflow
  runs its checks as workflow steps, not through `.git/hooks/` — but it is a behaviour change
  nobody will observe failing, which means nothing will tell us if that assessment was wrong.
- **Negative / trade-off:** the sprint runs to grace. `.claude/skills/sprint/SKILL.md` notes that a
  sprint habitually running to grace means the ceiling is wrong. This is the first; a second is the
  signal, not this one.
- **Negative / trade-off:** the eleven unsuppressed invocations remain. They no longer arm anything,
  because the script they ran is gone — but the surface is open for the next `prepare` anyone adds,
  and `QA-PLAN-US009` AC-GAP-3 scopes `ST01` to the three lines it actually asserts so that a tick
  stops reading as a posture.
- **Follow-on:** `.git/hooks/pre-commit` has a third claimant. `lefthook.yml:66-69` already records
  that `code-review-graph install` appends a raw hook which `lefthook install` replaces; with
  `prepare` gone, a re-run of `code-review-graph install` leaves the raw hook in place until someone
  runs `install.sh` again. US009 states the contest where it writes the step, per AC-GAP-7.
- **Follow-on:** the surface US009 does **not** close — eleven `pnpm install` invocations that still
  execute arbitrary lifecycle scripts from the dependency graph — is TM-02 of
  `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/THREAT-MODEL-PLAN-US009-HOOK-ARMING.md`,
  raised and left open deliberately rather than absorbed. A later story owns it; `GAPS.md` carries it
  from 17/09/2026.
- **Follow-on:** `project-management/src/01-FEATURE-MAPS/MAP-BUN-TOPOLOGY.md:220` (N-012) records
  that lefthook's hook template has no bun branch. Removing `prepare` removes one pnpm-shaped
  surface from that swap's path and changes nothing else about it.
