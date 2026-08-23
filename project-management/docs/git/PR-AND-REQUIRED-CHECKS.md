---
type: guide
skills: [git, global-workflow]
model: opus
---

# Git Guide — Pull Requests and Required Checks

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — PR promotion order, required status checks, toolchain pins

The promotion order a branch travels, which CI jobs may block a merge, and the files that pin
each toolchain both CI and the developer read. Index: [`../GIT-GUIDE.md`](../GIT-GUIDE.md).

---

## PR Flow

All feature branches must travel the full promotion order. Never skip a stage.

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

| Merge step                  | Gate                                                       |
| --------------------------- | ---------------------------------------------------------- |
| `us###/feature` → `testing` | Tests pass locally; PR opened to `testing` only            |
| `testing` → `dev`           | CI passes on `testing`; QA sign-off                        |
| `dev` → `staging`           | CI passes on `dev`; lead sign-off; no regressions          |
| `staging` → `main`          | Staging sign-off; version bump and changelog entry present |

### Rules

- Feature branches always target `testing` — never `dev`, `staging`, or `main` directly
- A branch rejection at any stage goes back to the original `us###/feature` branch for fixes

---

## Required status checks and path filters

**A workflow may be path-filtered, or it may be a required status check. Never both.**

GitHub treats a required check as satisfied only when it **reports**. A path-filtered workflow
does not run at all when a pull request touches none of its paths — so it never reports, and the
check sits _Expected — waiting for status_ forever. The pull request cannot merge, and there is
nothing to re-run: the job was never queued. A documentation-only PR blocked by a required CSS
audit is the usual way this is discovered.

So each CI workflow makes one choice, and **says which in a comment at the top of the file**:

| Kind                      | Path filter   | Why                                                                     |
| ------------------------- | ------------- | ----------------------------------------------------------------------- |
| **Required status check** | **None**      | It must report on every pull request, including ones it has no work for |
| **Advisory / audit**      | Path-filtered | It runs only when its own inputs change, and never blocks a merge       |

Most audits are the second kind — **20 of the 26 `audit-*.yml` workflows carry a path filter**,
one per named surface, and that is what lets them be cheap and specific. The other six are
unfiltered. Dropping a path filter makes a workflow **eligible** to be required and nothing
more; `syntax-markdown.yml`, `syntax-js-ts.yml` and `syntax-python.yml` are unfiltered on that
same reasoning. Regenerate both counts with
`for f in .github/workflows/audit-*.yml; do grep -qE '^\s+paths:' "$f" || echo "$f"; done`.

**Which jobs are in the set is branch protection, and this guide keeps no second copy of it** —
a membership list written twice drifts once, and this file did exactly that for five days. A
workflow header may state what it is _eligible_ for, because that is a property of the file;
anything anywhere claiming what is _in_ the set is commentary, and must be re-checked against
the command below before it is believed. Read the live set:

```bash
gh api 'repos/{owner}/{repo}/rulesets' --jq '.[] | "\(.id) \(.name)"'
gh api 'repos/{owner}/{repo}/rulesets/<id>' \
  --jq '.rules[] | select(.type=="required_status_checks")
        | .parameters.required_status_checks[].context'
```

**Promoting an audit to required means deleting its path filter in the same change.** Adding it
to the branch-protection list while it still carries `paths:` is the failure above, and it will
not be obvious — the first PR to trip it will look like a GitHub outage.

### What earns a place in the required set

Being unfiltered makes a job **eligible**. It does not make it required, and the difference had
never been written down — which is how the set came to be smaller than the rule anyone would have
stated. Two things qualify a job, and the second is easy to miss:

1. **It executes here and can fail here.** The ordinary case.
2. **Its step-level guard is worth protecting from regression.** A job that guards to success —
   the mobile jobs on a web-only project — proves nothing about the code. It does prove the
   guard still works. Break the guard and the job errors instead of reporting, which a required
   check catches and an advisory one does not.

**Each addition is cheap and the total is what costs — so name the total when you add one.**
Every promotion is argued on its own merits, and every one of them is right; what nobody argues
is the twenty-first, because no single change is where the cost lands. This is the same shape
`code/docs/DOCUMENTATION-LENGTH.md` gives the line budget, and it deliberately does **not** get
the same mechanism: a ratchet needs a measured per-change number and a baseline to diff, and
"how long a contributor will wait for the set" is neither. What it gets instead is this
sentence and the count in the table below — **state the size the set will be, not only the name
being added**, so the number is in front of whoever approves it. Written 23/08/2026 in place of
building a second ratchet, on the fog-of-war argument.

The second is not a new idea here, only a newly stated one: `jest-expo + coverage` is the
standing example, with `test.yml` recording the reason — _"a skipped job and a
passing job look different to branch protection, and 'never ran' is not the same claim as
'nothing to run'."_

**The guard's level matters, and only for one kind of guard.** A **surface-presence** guard — _is
there a mobile app in this project at all?_ — belongs at **step** level, never job level: a
job-level one makes the whole job skip rather than report, and the check never arrives. An
**event-type** guard is a different thing and is safe at job level, because a pull request is one
of the events it admits, so the job always reports on the event that matters. All eight `[n/8]`
jobs in `claude.yml` are guarded that way (`grep -cE '^    if: github.event_name'
.github/workflows/claude.yml`), and every one of them still reports on a pull request.

**Read a green guarded check as "not applicable", never as "passing".** That does not weaken the
case for requiring a guarded job: the claim being protected is about the guard, not the tests.

**The backend suites are no longer an instance of this, and the change is recent.** They guarded
to success here while `uv.lock` was absent; the lock was committed on 16/08/2026 and they now
execute against the two shipped apps. What a green run here does and does not prove is
the root `GAPS.md` SL-1 — a narrower claim than "not applicable", and a different one. **That
entry is syntek-base's own**: `GAPS.md` is excluded and seeded blank, so a generated project has
the file but not the limitation, which is correct — its suite proves its own code.

### Changing the set

Flipping a check is a **repository-settings change that no file in this repository can make**.
This guide holds the criteria and the traps; branch protection holds the membership.

- **Copy the names, never retype them.** Several carry an em dash rather than a hyphen —
  `Ruff — Lint`, `basedpyright — Typecheck`, `TruffleHog — Secrets Scan` — and a check is
  matched by exact string, so a retyped `Ruff - Lint` is a required check that never arrives.
  That is the pending-forever failure this section opened with, reached by a second route.
- **A required check must be reachable by a `pull_request` event.** Path filters are the obvious
  way to fail this; triggers are the quiet one. A workflow running only on `schedule` and
  `workflow_dispatch` has no filter to delete and still cannot report, so it pends forever —
  `audit-deps.yml` is the standing example: it runs only on `schedule` and `workflow_dispatch`,
  so it has no filter to delete and still cannot report, and its own header says so. Its
  reporting twin, `[8/8] Security` in `claude.yml`, runs the identical two legs on every pull
  request and is the one that belongs in the set.
- **The `[n/4]` checks exist only in syntek-base.** They come from `audit-template.yml`, and
  that workflow and `.github/scripts/` are both `_exclude`d <!-- doc-references: template-only -->,
  so they do not exist in a generated project — never carry them into one's own protection
  rules.

---

## Toolchain pins

Four files pin a tool version, one per toolchain, each read by both CI and the developer rather
than restated in either:

| File                                | Pins                | Read by                                                  |
| ----------------------------------- | ------------------- | -------------------------------------------------------- |
| `.nvmrc`                            | Node                | `nvm`, `actions/setup-node`                              |
| `.python-version`                   | Python              | `uv`, `actions/setup-python`                             |
| `code/src/rust/rust-toolchain.toml` | Rust channel        | `rustup`, automatically                                  |
| `.opengrep-version`                 | The Opengrep engine | `audits/static-analysis.sh`, `audit-static-analysis.yml` |

**Two of them are read by tooling that already knows the convention, and two are ours to read.**
`rust-toolchain.toml` earns its non-matching name that way: rustup reads it and nothing else
would. A root `.rust-version` beside the other three would look tidier and be worse — it would
ship into projects generated without the Rust surface, and it would fork one number across two
files that nothing keeps in step.

`code/src/rust/.cargo-deny-version` is a fifth pin, deliberately scoped rather than promoted to
the root, for the same reason: it is meaningless without the Rust surface it is gated with
(`code/docs/rust/SUPPLY-CHAIN.md`).
