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

The audits under `code/src/scripts/audits/` are the second kind: one path-filtered workflow each,
none of them a required check. That is what lets them be cheap and specific. Dropping a path
filter makes a workflow **eligible** to be required and nothing more: `syntax-markdown.yml` and
`syntax-js-ts.yml` are unfiltered and required, `syntax-python.yml` unfiltered since 16/08/2026
and not yet required. Which jobs are in the set is the next section's table, and this sentence
deliberately keeps no second copy of it — a membership list written twice drifts once.

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

The second is not a new idea here, only a newly stated one: `jest-expo + coverage` has been
required on exactly that basis, with `test.yml` recording the reason — _"a skipped job and a
passing job look different to branch protection, and 'never ran' is not the same claim as
'nothing to run'."_ A guarded job is required at **step** level, never job level, or it skips
rather than reports and the check never arrives.

**Read a green guarded check as "not applicable", never as "passing".** That does not weaken the
case for requiring a guarded job: the claim being protected is about the guard, not the tests.

**The backend suites are no longer an instance of this, and the change is recent.** They guarded
to success here while `uv.lock` was absent; the lock was committed on 16/08/2026 and they now
execute against the two shipped apps. What a green run here does and does not prove is
`TEMPLATE-GAPS.md` SL-1 — a narrower claim than "not applicable", and a different one.

**The table below is the promotion target as of 3.2.2, not a census of everything unfiltered.**
Each row is a deliberate switch to flip, not a backlog to clear, and flipping one is a
**repository-settings change that no file in this repository can make**; the half that lives here
is done. A job being unfiltered and absent from this table means only that nothing has yet argued
it belongs — `Unresolved conflict-marker audit` is the open case, and `audit-conflict-markers.yml`
records the argument and defers the decision to N-029.

| Check name — branch protection matches this string exactly | Workflow                   | Note                      |
| ---------------------------------------------------------- | -------------------------- | ------------------------- |
| `pytest + coverage`                                        | `test.yml`                 | Guarded — criterion 2     |
| `Audit JS + Python dependencies`                           | `audit-deps.yml`           |                           |
| `Citations resolve`                                        | `audit-doc-references.yml` |                           |
| `Routing skills resolve`                                   | `audit-routing-skills.yml` | **Hold — see below**      |
| `Ruff — Lint`                                              | `syntax-python.yml`        | Eligible since 16/08/2026 |
| `Ruff — Format`                                            | `syntax-python.yml`        | Eligible since 16/08/2026 |
| `basedpyright — Typecheck`                                 | `syntax-python.yml`        | Eligible since 16/08/2026 |
| `[1/4] Template Tokens`                                    | `audit-template.yml`       | syntek-base only          |
| `[2/4] Shipped Documentation`                              | `audit-template.yml`       | syntek-base only          |
| `[3/4] Template Generation`                                | `audit-template.yml`       | syntek-base only          |
| `[4/4] Parser Probes`                                      | `audit-template.yml`       | syntek-base only          |

- **Copy the names, never retype them.** The three `syntax-python.yml` rows carry an em dash, not
  a hyphen, and a check is matched by string — a retyped `Ruff - Lint` is a required check that
  never arrives, which is the pending-forever failure this section opened with.
- **`Routing skills resolve` waits for a parser fix.** `routing-skills.sh` selects a frontmatter
  array with a regex needing the opening bracket on the key's own line, so a multi-line `skills:`
  array is skipped whole and its names are never validated: the gate reports every name resolving
  while never having opened the file. Requiring a green that means nothing is the instrument
  outrunning the rule. Flip it once the parser reads both forms.
- **The four `audit-template.yml` rows protect syntek-base and nothing else.** That workflow and
  `.github/scripts/` are both `_exclude`d, so these checks do not exist in a generated project —
  do not carry them into one's own protection rules.

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
