# ADR-US006: The posture carrier is `.copier-answers.yml`, and every state but two fails closed

**Status:** Accepted
**Date:** 05/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US006

---

## Context

`.claude/CLAUDE.md` Section 0 is the strictest rule set in this repository. Every sharpened bullet
beyond `development` — no destructive migration and a deploy in one change, nothing dropped
without a named recovery path, never a raw `manage.py` shell against a live environment — rests on
the model reading it and complying. **The script layer enforces none of it.**
`how-to/src/DEPLOYMENT-POSTURE.md:86-88` says so in as many words about `reset.sh`: "a rule
`.claude/CLAUDE.md` Section 0 binds Claude to, not yet a guard the script itself enforces".

US006 makes that sentence false. Six scripts gain a guard — `database/reset.sh`,
`database/restore.sh`, `database/seed-dev.sh`, `development/server.sh` and `tests/server.sh` refuse
above `development`; `database/migrate.sh` warns. Before any of that can be written, one question
has to be settled: **where does a shell script learn the posture, and what does it do when it
cannot?**

**There is exactly one machine-parseable carrier.** `copier.yml:408-419` asks
`DEPLOYMENT_POSTURE` with the stated rationale that a later gate can read it, and
`.copier-answers.yml` ships tracked into a generated project — copier's `_exclude` does not name
it. Every other statement of the posture in the tree is prose: the table in `.claude/CLAUDE.md`
Section 0, the per-surface register in `how-to/src/DEPLOYMENT-POSTURE.md`. Prose is what the guard
exists to stop depending on.

**The constraint that makes this hard is the template's own answers file.** In `syntek-base`,
`.copier-answers.yml` holds seven comment lines and one unrendered Jinja expression —
`_copier_answers` piped through `to_nice_yaml` — so a grep for the posture key exits 1 with no
output. **That observable is byte-for-byte identical to a generated project whose posture key has
been lost**: deleted by a `copier update` merge, or never written because the project predates
7.5.0. The template must run all six scripts unimpeded. The deployed project with a damaged
carrier must not. And the naive read cannot tell them apart.

Two further facts arrived from `10-security-checks` and bound the answer further. **TM-05**: any
`copier.yml` at a generated project's root — a nested sub-template, a scratch file, an agent
writing one — is an unauthenticated file test that silently disables the whole control. **TM-08**: a
three-way merge more usually **duplicates** a key between conflict markers than removes it, so an
enumeration built around "the key is absent" does not cover the state a `copier update` actually
produces.

## Options considered

### Option A — default to `development` when the posture cannot be read

- **Summary:** absent file, absent key or unparseable value all resolve to `development`, and the
  guard permits.
- **Pros:** the template runs unimpeded with no special case, and no existing project is broken by
  the guard's arrival. Simplest possible read path.
- **Cons:** **it disarms the guard in exactly the project it exists for.** The states that produce
  an unreadable carrier — a merge conflict, a truncated write, a pre-7.5.0 checkout — are more
  likely on a long-lived deployed project than on a fresh one, so the control is weakest precisely
  where the blast radius is largest. A security control whose failure mode is permitting is not a
  control.

### Option B — fail closed everywhere, with no template exemption

- **Summary:** anything the guard cannot positively read as `development` refuses. `syntek-base`
  included.
- **Pros:** one rule, no exemption to attack, and the enumeration is trivially complete.
- **Cons:** the template's own destructive scripts stop working, which is where they are used most.
  Working around it means an operator typing `--force-posture development` several times a day
  against a repository that is not deployed anywhere — and an override typed by habit is an
  override that has stopped meaning anything. It would also have to be committed into the CI
  workflow, which is the shape TM-10 already warns about.

### Option C — fail closed, and prove the template positively by `copier.yml` at the root

- **Summary:** the guard refuses on every state it cannot read as `development`, with one
  exemption: the repository root holds `copier.yml`, which no generated project has.
- **Pros:** the exemption is a **positive proof of a different thing** rather than an inference
  from a missing answer, so the two identical observables stop being identical. `copier.yml` is
  the file copier consumes and never renders, so its presence is exact rather than heuristic. The
  same test is already load-bearing three times in the tree — `.claude/hooks/pre-pr-check.sh:80`,
  `.claude/hooks/template-docs-readonly.sh:35`, `lefthook.yml:137` — so it is an idiom a reader
  already knows.
- **Cons:** the exemption is a file test, and a file can be created. Left unqualified it is TM-05:
  one stray `copier.yml` disables the control across a whole project. It also needs an anchor —
  the three existing spellings resolve their root three different ways (`BASH_SOURCE`,
  `git rev-parse --show-toplevel`, and cwd-relative), and a cwd-relative test is trivially
  satisfied from the wrong directory.

### Option D — sniff for an unrendered Jinja delimiter in the answers file

- **Summary:** the template's carrier contains a delimiter; a rendered one does not. Test for it.
- **Pros:** reads the same file the posture comes from, so no second artefact enters the decision.
- **Cons:** **the helper itself is rendered.** `copier.yml` sets `_templates_suffix: ""`, so a
  literal delimiter written into `posture-guard.sh` is substituted at generation rather than
  matched at runtime — the test would be edited out of existence by the act of generating the
  project it is meant to distinguish. It also tests a formatting artefact rather than a fact about
  the repository.

### Option E — a second file, or an environment variable, stating the posture for scripts

- **Summary:** introduce a purpose-built carrier the guard owns.
- **Pros:** no ambiguity about what it means, and it can be formatted for cheap parsing.
- **Cons:** two sources of truth for one fact, which drift. `N-003` on
  `MAP-SCRIPT-GUARDS.md` sanctioned the posture read from the answers file specifically, and
  rejected the dated-annotation idiom on the grounds that a security guard with two ways in is
  the wrong shape. An environment variable is worse still: it is the override channel the design
  bans, wearing a different name.

## Decision

**We will take Option C, with the exemption ordered and bounded.**

The guard reads `DEPLOYMENT_POSTURE` from `$PROJECT_ROOT/.copier-answers.yml`, `$PROJECT_ROOT`
resolved from `BASH_SOURCE`, and **fails closed on every state but two**: a rendered carrier
naming `development`, and a proven template checkout. Everything else refuses at exit `4` —
`staging` and `production` without an override, an unrecognised value, an absent key, a commented
or duplicated key, a conflict-marked key, an unreadable file, and an absent file. **No state
defaults to `development`.**

The deciding factor is that **an absent answer and a damaged answers file are the same
observable**, so any design that infers the template from what is missing is a design that
mistakes a broken deployed project for the template. Option C is the only one that answers a
different question — _is this the template?_ — with evidence that does not overlap.

Three qualifications make it survive the security gate, and each closes a way Option C fails open:

1. **The carrier is read first.** A legal posture beats a present `copier.yml`, so the exemption is
   reachable only from a carrier holding no legal posture. That is what stops a stray `copier.yml`
   at a generated project's root disabling the control (TM-05). The exemption is the fallback, not
   the first question.
2. **The `copier.yml` test is anchored at `$PROJECT_ROOT` from `BASH_SOURCE`, never cwd-relative,**
   and so is the carrier read. The three spellings in the tree disagree on resolution and a
   cwd-relative test is satisfied by running from the wrong directory (TM-11).
3. **The match is anchored on `^DEPLOYMENT_POSTURE:`,** quote-tolerant, comment-rejecting, and a
   duplicate or conflict-marked key is its own refuse state detected through
   `code/src/scripts/_lib/conflict-markers.sh`. The shipped answers file already carries seven
   comment lines, so a commented key is likely rather than exotic (TM-02), and a merge more usually
   duplicates than deletes (TM-08).

Option A was the tempting one and is rejected outright: it is the only option whose failure mode is
permitting. Option B is correct and unusable. Option D fails on a fact about the build.
Option E reopens the channel `N-003` closed.

## Consequences

- **Positive:** the rule that `.claude/CLAUDE.md` Section 0 states in prose is enforced by the
  thing that does the damage. `how-to/src/DEPLOYMENT-POSTURE.md:86-88` becomes false in the same
  change, and its already-dead `GAPS.md` citation goes with it.
- **Positive:** `.copier-answers.yml` becomes a **read** interface rather than only a Copier
  implementation detail, on the rationale `copier.yml:408-419` already recorded. The precedent is
  narrow by design: `N-003` sanctions the posture read, not a general licence for scripts to read
  the answers file.
- **Negative / trade-off:** **a damaged carrier has no override.** Because the permit rule compares
  against "the posture the project is at now" and a damaged carrier has no such value, an override
  in that state would be unconstrained — `--force-posture development` would permit a destructive
  run on a `production` project, and TM-08 says the disturbed carrier is exactly when that
  happens. So the recovery path is **repairing the carrier**, not overriding past it, and the
  refusal says so rather than promising a posture it cannot name. An operator with a conflicted
  answers file and an urgent restore has one more step than they would like. Accepted: the
  alternative is a control that is weakest immediately after the thing that damages it.
- **Negative / trade-off:** the template exemption is a file test and remains one. Ordering the
  carrier first bounds it to projects holding no legal answer, which is the smallest set it can be
  bounded to without abandoning Option C, but a generated project whose carrier is damaged **and**
  which has acquired a `copier.yml` is exempted. That conjunction is TM-05's promotion trigger and
  is re-assessed at the first staging surface.
- **Negative / trade-off:** the guard reads one project-wide posture — the highest any surface has
  reached — while all six scripts are hard-wired to local stacks. The posture therefore says
  nothing about what the command in front of it will actually reach, which is TM-01 and is answered
  separately by the compose-target assertion in criterion 7.12, not by this record.
- **Follow-on:** `code/src/scripts/_lib/posture-guard.sh` is a **new return contract for `_lib/`** —
  0 to permit, 4 to refuse, refusal on stderr, never calls `exit`. Only `env-file.sh` and
  `wizard.sh` return meaningful codes today; `conflict-markers.sh:63` and `frontmatter-skills.sh:45`
  each document always returning 0. `_lib/CLAUDE.md` gains the contract, and `_lib/CONTEXT.md` the
  helper, in the same change.
- **Follow-on:** the proof is `database/migrate.sh --self-test`, dispatched ahead of that script's
  command validator and its `container_running` check so it runs with the stack down. The helper is
  aimed at a fixture root through the entry point's first positional argument — never an
  environment variable, which criterion 7.1 bans.
- **Follow-on:** a later story that adds a fourth posture, or a per-surface posture, supersedes
  this record rather than editing it. The enumeration is exhaustive by construction — every state
  but two refuses — so a new legal value is a change to what "positively readable" means.
