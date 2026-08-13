# Template Gaps — syntek-base's own open items

**Last Updated**: 11/08/2026 | **Maintained By**: Syntek Studio

Open items belonging to **`syntek-base` itself** — the template repository, not any project
generated from it.

> **Why this file exists, and why it is here.** The root `GAPS.md` is a **shipped template
> file**: `copier.yml` does not exclude it, so whatever it contains is rendered into every
> generated project. Recording the template's own gaps there leaked syntek-base's internal
> state into unrelated projects, where the entries were meaningless and misleading. `GAPS.md`
> is therefore kept as an empty stub, and the template's own items live here — in
> `TEMPLATE-GUIDE/`, which **is** excluded, so it is durable in git yet never ships.
>
> The same reasoning that put ADR-era design rationale in `02-STACK.md` and `11-CUSTOMISING.md`
> rather than in `14-DECISIONS/`. See `.claude/MEMORY.md` → _Template-development reasoning
> lives in `TEMPLATE-GUIDE/`_.

**Format** matches the root `GAPS.md` so entries can move either way:

```text
## DD/MM/YYYY — <title>

**Type:** <Infrastructure gap | Planned feature | Active gap>
**Summary:** …
**Blocked by / Action:** …
```

---

## 12/08/2026 — N-014's two drafting-guide folders may already exist as the skills themselves

**Type:** Active gap — one decision, blocking 13 of N-014's 38 conversions
**Summary:** The N-014 plan's `D2` folds the 13 document-writer agents into `legal-documents`
and `msp-scp-documents`, migrating their conventions to two **new** guide folders,
`project-management/docs/legal-drafting/` and `policy-drafting/`. Measured 12/08/2026, the
content those folders would hold **already exists in the two skills**:
`msp-scp-documents/` is already an index over six `Required Sections` sub-documents covering all
nine policy types — the progressive-disclosure shape `how-to/docs/skill-authoring/FORK-DECISION.md`
prefers to a split; `legal-documents/SKILL.md` carries `## Required Sections` for all six legal
types inside the 300-line cap. Spot-checking one writer against its skill section found the two
required-sections lists to be near-duplicates **already drifting** — the agent splits out
special-category data and automated decision-making, the skill does not. Creating the folders
would therefore make a **third** home for one rule, which is the defect the epic exists to
remove.
**Blocked by / Action:** Sam's call. **Recommendation: do not create the folders** — fold the 13
writers into the two existing skills, reconcile each per-type required-sections list into the
skill's, and add the genuinely additive per-type material the skills lack: the **regulatory
attention flags** (the Article 9 condition, the transfer mechanism, the Legitimate Interests
Assessment, PECR consent for non-essential cookies). Nothing else in N-014 is blocked on this.
Follow-up either way: `legal-documents/SKILL.md` § _Clarifying questions_ still says the
per-document question set lives "in its own agent file", which is true at commit 1 and false at
commit 2.

---

## 11/08/2026 — The agent tier is being retired, so half of N-015's routing is deferred

**Type:** Planned feature — the deferred half of a resolved node
**Summary:** `MAP-NEGATIVE-SPACE.md` N-015 was chartered to add routing clauses to **the agents
and the stack skills**. Sam settled on 11/08/2026 that **all agents are being removed** and the
skill set rewritten to absorb them, so only the skill half shipped: `stack-django`,
`stack-htmx-templates`, `stack-react-native` and `stack-fastmcp`. The agent half was **not
attempted** rather than attempted and skipped — routing 56 files that are due for deletion is
work thrown away twice.

**What is unrouted, and why it matters.** The deferral's reason is now discharged — the agent
tier was deleted on 13/08/2026 (`73414cf`) and the replacement skills exist — so the survey was
re-run against the converted roster. **The substance survives, narrowed and with real owners:**

> **Survey re-run 13/08/2026** (`grep -rl` over `.claude/skills/`), and the picture has split
> three ways:
>
> | Guide                                                    | Cited by                                                                      |
> | -------------------------------------------------------- | ----------------------------------------------------------------------------- |
> | `NEGATIVE-SPACE.md`                                      | `stack-django`, `stack-htmx-templates`, `stack-fastmcp`, `stack-react-native` |
> | `audits/negative-space.sh`                               | `stack-django`, `stack-htmx-templates`, `stack-react-native`                  |
> | `how-to/src/INVARIANTS.md`                               | `stack-django`, `stack-fastmcp`                                               |
> | `MANAGEMENT-COMMANDS.md` · `MOBILE-CODING-PRINCIPLES.md` | `stack-django` · `stack-react-native`                                         |
> | `DISCOVERABILITY.md`                                     | `seo` — **newly routed**, was cited by no agent and no skill                  |
> | `OBJECT-STORAGE.md`                                      | **nothing. Still unrouted.**                                                  |

**The verifier remit is still the sharper loss, and it is now precisely locatable.** `code-reviewer`,
`security`, `qa-tester` and `refactor` all exist as skills (`debugger` folded into `bugfix`), and
**not one of them cites `NEGATIVE-SPACE.md`, `INVARIANTS.md` or `negative-space.sh`.** The
doctrine reaches the surface that **writes** a guard, through the four stack skills, and not the
surface that **catches** a missing one. That is the same gap as before, no longer blocked on
anything, and now addressable in four named files rather than a tier due for deletion.

**Blocked by / Action:** Nothing blocks it. Two concrete jobs: route the four verifier skills at
`NEGATIVE-SPACE.md` + `INVARIANTS.md` + `audits/negative-space.sh`, and give `OBJECT-STORAGE.md`
an owning skill or record that it has none.

---

## 11/08/2026 — Committed merge-conflict markers passed every gate for two releases

**Type:** Active gap
**Summary:** `.claude/skills/stack-fastmcp/SKILL.md` carried an unresolved stash conflict in its
`## Governing procedures` section — committed at `3bd49e8`, found at N-015 only because that
section was being edited. **Prettier had reformatted the markers into valid Markdown**: `<<<<<<<`
became an indented list continuation, `>>>>>>>` became a `> > > > > > >` blockquote, and the
duplicated line was prefixed `#`. So it lints clean, formats clean, and a grep for `^<<<<<<<`
finds nothing. `skill-conformance.sh` checks that the section is **present** — placement is a
convention, and nothing checks that the contents parse as routing.

Fixed in place at N-015 (both sides were the identical line). A repo-wide sweep for raw and
mangled markers found **one** other hit, `TEMPLATE-GUIDE/14-UPDATING.md`, which is a deliberate
worked example of what a conflict looks like.

**Blocked by / Action:** Nothing gates this — no audit, CI workflow or lefthook hook looks for
conflict markers anywhere in the tree. A cheap clause (raw markers, plus the Prettier-mangled
forms, excluding the documented example) belongs in an audit; it is not obvious which one, since
this spans every file type rather than one language.

---

## 11/08/2026 — The `/mcp/` surface has no error-taxonomy clause

**Type:** Active gap
**Summary:** `NEGATIVE-SPACE.md`'s per-surface table has five rows — rendered pages/HTMX, the
JSON API, background tasks, management commands, and mobile — and no row for the FastMCP tool
surface. `MCP-SERVER.md` and all four of its sub-docs contain **nothing** of the taxonomy:
`InvariantViolation`, `DependencyUnavailable` and "programmer error" return zero occurrences.
N-015 routed `stack-fastmcp` as **inheriting the JSON API row** — true, because a tool is a peer
adapter over the same service layer — rather than adding a sixth row pointing at a section
nobody has written.

**Blocked by / Action:** Not urgent: the surface is declared-but-unwired and `fastmcp` is not a
declared dependency. The first project to mount `/mcp/` should decide whether the API row
genuinely covers it — the open question is what a tool _returns_ when a guard fires, since an
LLM client reads a tool error as a reasoning step rather than a status code.

---

## 11/08/2026 — The ruff CI jobs believed to be this repo's only Python gate do not run either

**Type:** Active gap — **known limitation, accepted 11/08/2026** (was: a claim three shipped
files make and one command disproves)
**Summary:** `syntax-python.yml` carries a header stating its three jobs "work in the base
template and in a generated project alike. That is also why they are the only Python gate this
repository actually enforces on itself." The lockfile half of that reasoning is correct — they
run `uv sync` without `--frozen`, so no committed `uv.lock` is needed. **The conclusion is
wrong**, for a reason the header does not consider: every job runs `uv sync --only-dev` first,
and `uv` refuses to parse `pyproject.toml` at all, because line 2 is
`name = "<%PROJECT_SLUG%>"` and that is not a valid package name. Verified 11/08/2026 with
`uv sync --only-dev --dry-run` (uv 0.11.24), which fails with
_"Not a valid package or extra name"_ before dependency resolution begins. This is a **different
root cause** from the two entries already filed (02/08/2026, missing `uv.lock`; 03/08/2026,
pre-commit hooks) and is not covered by either, so all three ruff/basedpyright jobs fail at the
sync step rather than being skipped.

**What this does and does not invalidate.** The rules themselves are sound and **do** run in a
generated project, where the token is rendered to a real name. What is untrue is the claim that
they are enforced _here_: `MAP-NEGATIVE-SPACE.md` records at N-007 that ruff `S101` is "the only
Python gate that executes in the template repository", and N-008 and N-010 describe their
`TID251` bans as proved end to end. Those proofs are real but **local** — they were obtained
from the directly-installed `ruff` binary on the host, which parses no manifest and works fine.
CI has been contributing nothing. One variable is unverified: CI pins `UV_VERSION: 0.11.7` and
the local check ran 0.11.24; package-name validation is long-standing in `uv` and almost
certainly identical, but that specific version has not been tested.

**The contrast that makes the cause legible, and that was verified rather than assumed.** Two
manifests here carry the same unrendered token in their `name` — the root `pyproject.toml` and
the root `package.json` — and **only one ecosystem rejects it.** `pnpm ls -r --depth -1` parses
both workspace manifests cleanly, because pnpm skips name validation on a package marked
`private: true`; uv has no such carve-out. That is why the mobile jobs genuinely run in CI here
and the Python jobs never have. Checked both ways on 11/08/2026, deliberately: **one tokenised
name is not evidence about another**, and `MAP-NEGATIVE-SPACE.md` N-011's end-to-end claim
survives only because it was tested on its own.

**Decision (Sam, 11/08/2026): option (c) — accept it and correct the record.** Three options were
weighed: (a) give the root `pyproject.toml` a literal placeholder name and have Copier rewrite
it, the same class of decision as the parked `<%CORE_APP%>` token; (b) invoke ruff without `uv`
in these three jobs — `uvx ruff` or a pinned standalone install — accepting that CI would then
no longer match what a developer runs; (c) accept it and correct the header comment plus the
three map verdicts. **(c) was chosen**, on the grounds that the rules are already enforced by a
real analyser on the host and (a) and (b) both buy CI coverage of this repository by making it
diverge from the thing it is a template _of_.

**Done, in the same change:** `syntax-python.yml`'s header rewritten to state plainly that the
jobs do not run in the base template, why the blocker sits one step earlier than the lockfile,
and that a generated project is unaffected; `MAP-NEGATIVE-SPACE.md` N-007, N-008 and N-010 each
given an inline correction withdrawing the CI claim and naming the local proof.

**Standing rule this leaves behind — the reason the entry stays open rather than closing:**
**treat every `.py` change here as verified by the host `ruff` binary and by nothing else**, and
never cite CI as evidence for a Python rule in syntek-base. That remains true indefinitely under
option (c), so the entry is an accepted limitation to be read, not a task to be finished. Revisit
only if the template contract changes for an unrelated reason and (a) becomes free.

---

## 11/08/2026 — Two of the four `research/` notes cannot be deleted with their epic

**Type:** Active gap
**Summary:** `research/` is **not** copier-excluded, so syntek-base's own research notes ship into
every generated project — where research about the _template_ is as meaningless as the template's
gaps were in `GAPS.md`. Sam settled on 11/08/2026 that these notes are epic scaffolding and get
deleted on completion, which is right for one of them and **breaks the `README.md` for the other
three**:

| Note                                 | Inbound references                                                      | Deletable |
| ------------------------------------ | ----------------------------------------------------------------------- | --------- |
| `DISCOVERABILITY-SKILL-ECOSYSTEM.md` | `CHANGELOG.md`                                                          | **yes**   |
| `SKILLS-VS-SUBAGENTS.md`             | **`README.md:188`** + **`THIRD-PARTY-NOTICES.md:218`** + `CHANGELOG.md` | **no**    |
| `ANTI-SLOP-RULE-SOURCES.md`          | **`README.md:151`** + `CHANGELOG.md`                                    | **no**    |
| `AGENT-SKILL-ECOSYSTEM.md`           | **`README.md:183`** + `CHANGELOG.md`                                    | **no**    |

`SKILLS-VS-SUBAGENTS.md` moved from deletable to load-bearing on 11/08/2026, when the
skill-authoring split cited it twice from shipped files: `README.md` names it as the per-claim
evidence behind the Claude Code docs row, and `THIRD-PARTY-NOTICES.md` names it as the one place
that quotes an unlicensed source. **Any plan that deleted it at closeout is superseded** — it now
dangles two citations and drops straight into the quotation question below.

The two `README.md` citations are the per-claim evidence behind the _Influences and attribution_
tables. `.claude/CLAUDE.md` § 6 makes the licence column binding **before** deriving; the notes are
what make that column checkable rather than an assertion. `CHANGELOG.md` references are historical
and stay regardless — a changelog naming a file that was later deleted is a correct record.

**A second question sits underneath**, surfaced by `MAP-AGENTS-TO-SKILLS` `N-002`: the shipped
notes quote **unlicensed** sources verbatim (`anthropics/claude-code`, `anthropics/skills`), while
`ANTI-SLOP-RULE-SOURCES.md` itself ends "may be read for ideas but **never quoted**". Deleting a
note retires the problem for that note only; the three survivors keep it, and
`SKILLS-VS-SUBAGENTS.md` is the sharpest case because `THIRD-PARTY-NOTICES.md` now states in
writing that it quotes an unlicensed source.
**Blocked by / Action:** Decide the lifecycle for the three survivors — either (a) narrow the
precedent's wording to "never quoted **in redistributed rule text**", so citation in a research
note stays legitimate, or (b) paraphrase their quotations, keeping every citation URL, or (c) move
the evidence into `TEMPLATE-GUIDE/` (already excluded) and repoint `README.md` — which makes the
citation dangle for a generated project reading the shipped README. (a) is cheapest and matches the
derive-and-re-author line the project already draws everywhere else.

---

## 11/08/2026 — The mobile tree's sub-directories carry no `CONTEXT.md`/`CLAUDE.md` pair

**Type:** Active gap
**Summary:** `code/src/CLAUDE.md` states that **every** new directory under `src/` needs a
`CONTEXT.md` + `CLAUDE.md` pair, but `code/src/mobile/app/` and `__tests__/` have never had one,
and `lib/` (added by `MAP-NEGATIVE-SPACE` N-011) follows that precedent rather than the stated
rule. `docs-pairing.sh` does not catch it: the audit iterates over existing `CONTEXT.md` files
and checks each has a `CLAUDE.md` beside it, so a directory with **neither** is invisible to it.
The mobile tree is in practice governed as one unit by the pair at its root, which is defensible
— but the written rule says otherwise, and the audit enforces neither reading.
**Blocked by / Action:** Decide which is true and make the other match. Either scope the
`code/src/` rule to say a **surface** is paired at its root, or add pairs to the three mobile
sub-directories. Whichever way it goes, the audit only ever checks half of it — extending
`docs-pairing.sh` to flag a source directory with neither file is a separate, larger question,
because it would fire on every ordinary Python package.

---

## 11/08/2026 — `apps/core/schemas.py` breaches the comment standard it was written under

**Type:** Active gap

**Summary:** `code/docs/coding-principles/STYLE-AND-PROCESS.md` § _Comments and Documentation_ is
unambiguous on two points for `.py` source: **no outside references** ("never cite … a
`code/docs/*` path, URL, person, or date") and **docstrings are one line**. It grants exactly two
exemptions — declarative configuration and `code/src/scripts/**/*.sh` — and `schemas.py` is
neither. Its module docstring runs 24 lines and closes by citing
`code/docs/api-design/NINJA-CONVENTIONS.md` and `code/docs/NEGATIVE-SPACE.md`. Shipped by
`MAP-NEGATIVE-SPACE` N-008 on 09/08/2026; surfaced by N-009 on 11/08/2026 while writing
`middleware.py` to the same standard.

**Blocked by / Action:** Needs a decision, not a patch, because the honest reading may be that the
**standard** is wrong rather than the file. A module docstring explaining why three schema bases
exist is genuinely useful, and the reasoning has nowhere better to live at the point of use. Three
options: trim `schemas.py` to conform and move the reasoning wholly into
`NINJA-CONVENTIONS.md`; or carve a third exemption for **module** docstrings (distinct from
function and class ones) and keep the no-outside-references half absolute; or narrow the
one-line rule to functions and classes explicitly. Whichever wins, `middleware.py` was written to
the standard as it currently stands, so the two files will not match until this is settled.

---

## 11/08/2026 — The code-review-graph incremental update is blind to untracked files

**Type:** Active gap

**Summary:** `build_or_update_graph_tool` defaults to an incremental update that diffs against a
git ref (`HEAD~1`). Files that are **new and not yet committed** are therefore never parsed, and
the tool reports success. On 11/08/2026 a refresh re-parsed 391 files, reported no errors, and
left both `apps/core/schemas.py` (N-008) and `apps/core/middleware.py` (N-009) entirely absent —
`file_summary` on either returned zero nodes. This matters because `.claude/CLAUDE.md` § 6 makes
refreshing the graph a **hard gate alongside the docs**, and the whole point of that rule is that
the layered docs and the graph stay in lockstep. A green refresh that silently skipped the new
code is exactly the false all-clear the closed `check-template-tokens.sh` entry (09/08/2026)
described — the same defect class, a second tool.

**Blocked by / Action:** Workaround today is `full_rebuild=True`, which does pick them up but
re-parses the whole repository and can exceed a two-minute tool timeout. Decide whether § 6 should
name the full rebuild explicitly when a change adds files, or whether the refresh should simply
run after staging rather than before. The second is cheaper and closes it properly: `git add`
makes the file visible to the diff, so the ordinary incremental path would then be correct.

---

## 09/08/2026 — `<%CORE_APP%>` is a registered token the template cannot use

**Type:** Active gap

**Summary:** `copier.yml` registers `CORE_APP` ("App owning shared primitives", default `core`) and
`TEMPLATE-TOKENS.md` documents it, but **no file uses it** and `MAP-NEGATIVE-SPACE` N-008 concluded
none safely can. A Django app directory is a Python **package name**, which
`TEMPLATE-TOKENS.md` § _Position matters as much as shape_ puts in the **never tokenise** row — the
same defect class as the Rust `[[bin]] name` incident closed on 09/08. `apps/<%CORE_APP%>/` would be
unimportable in the template repository, so `apps/core/` ships as a house constant.

The inconsistency that remains: the sibling tokens (`<%AUDIT_APP%>`, `<%IDENTITY_APP%>`, …) name apps
a **project** scaffolds, so they only ever appear in prose, where they are legal. `CORE_APP` names an
app the **template** ships, so it has nowhere legal to appear. If a project answers `CORE_APP:
shared`, copier renames nothing and the docs would then disagree with the code.

**Blocked by / Action:** Decide one of — (a) retire `CORE_APP` from `copier.yml` and
`TEMPLATE-TOKENS.md`, documenting `core` as a house constant beside `config/`; (b) keep the token but
mark it prose-only and never render it into a path, accepting the docs/code divergence above. (a) is
the honest one. Either way, add the "an app the template ships cannot be tokenised" case to
`TEMPLATE-TOKENS.md` § _Position matters as much as shape_, which currently reasons about compilers
rather than about who creates the directory.

---

## 09/08/2026 — `ruff check .` is red on `main`, in the two PM build scripts

**Type:** Active gap

**Summary:** `syntax-python.yml` runs `uv run ruff check .` and it fails with **4 errors**, all
pre-existing and all in the LaTeX build scripts:

```text
project-management/src/06-BRAND-GUIDE/guide-build/brand_guide.py:410:101  E501 Line too long (107 > 100)
project-management/src/06-BRAND-GUIDE/guide-build/brand_guide.py:574:22   S603 subprocess call: check for execution of untrusted input
project-management/src/07-COMPONENTS/component-build/components.py:310:22 S603 subprocess call: check for execution of untrusted input
project-management/src/07-COMPONENTS/component-build/components.py:321:101 E501 Line too long (102 > 100)
```

Surfaced by `MAP-NEGATIVE-SPACE` N-007, which switched the ruff `S101` gate on in `pyproject.toml`
and ran the full check to prove it green — `S101` **passes**; these four are unrelated and were
already failing. The job is path-filtered on `**/*.py` and `pyproject.toml`, so it fires on any push
touching either.

`ruff format --check .` also wants to reformat `components.py`, so the sibling `ruff-format` job is
red for the same file.

**A second, larger debt sits behind this.** `apps/core/` now ships (N-008) but `code/docs/` names a
dozen further `apps.core` modules that do not exist: `utils.get_client_ip` (documented in
`security/INPUT-AND-API.md` as **the only module permitted to read `X-Forwarded-For`** — a rule with
no implementation), `crypto`, `encryption`, `api_auth`, `views/seo`, `mcp_auth`, request logging
in `middleware`, `observability`, `db.get_or_cache`, `conf.get_setting`, `validators`, and
`models`. Each lands with the decision that governs it; the list is mirrored in
`code/src/django/apps/core/CONTEXT.md`. **`middleware.py` itself shipped at N-009** (the
correlation identifier), so request logging joins it as a second class in that module rather
than the `middleware/request_log.py` path the docs used to name.

**Blocked by / Action:** The two `E501`s are a mechanical wrap. The two `S603`s are not: both call
`xelatex` through `subprocess`, so the fix is either a justified `# noqa: S603` naming why the
argument vector is trusted, or restructuring the scripts not to shell out. N-007 deliberately did
not absorb this — it is out of that node's scope and needs a decision, not a patch. Note the
interaction with the new rule: a bare `# noqa` is a finding under `NEGATIVE-SPACE.md`
§ _The guard clause_ **for `S101` only**; an `S603` suppression with a stated reason is normal.

---

## 09/08/2026 — Two guides mandate different JSON error envelopes, and the example wins

**Type:** Active gap

**Summary:** `code/docs/coding-principles/PRACTICAL-RULES.md` § _Error Handling_ states the rule:
every HTTP API error returns `{ "error": { "code": "…", "message": "…" } }`. The shipped Ninja
exception handlers in `code/docs/logging/DJANGO-LOGGING.md` § _Ninja exception handler_ return
`{"detail": …}` — Ninja's native shape — on both the 422 and the 500, and
`code/docs/api-design/REST-CONVENTIONS.md` carries a third copy of the same handler. So a generated
project has a stated rule and a copy-pasteable example that contradict it. The example is the one
that gets used.

**Blocked by / Action:** Surfaced by `MAP-NEGATIVE-SPACE` N-005, which **deliberately did not
resolve it** — picking an envelope means editing three guides, and that epic ruled a consolidation
pass out. N-005 routed around it instead: its correlation identifier goes in an `X-Request-ID`
response header rather than the body, so no node in that epic depends on the answer, and the fix
stays a free-standing change. Resolve by picking one envelope, amending whichever two guides carry
the other, and checking whether `api-design/AUTH-AND-ERRORS.md` needs the same edit.

---

## 09/08/2026 — `scripts/deployment/` ships empty, so an incident has no scripted rollback

**Type:** Infrastructure gap
**Summary:** `code/src/scripts/deployment/` contains only its `CONTEXT.md`, `CLAUDE.md` and
`reports/` — no `deploy.sh`, no `rollback.sh`, no `health-check.sh`. All three are named as
"planned" in `how-to/docs/tooling-guide/CONFIGURATION.md`, and two further docs cite
`deployment/deploy.sh` and `deployment/production.sh` as though they exist. The consequence
surfaced while writing `how-to/docs/INCIDENT-PRACTICE.md` (N-030): the runbook spine requires a
**Rollback** section, and there is nothing script-first to put in it. The guide states the gap
outright and routes rollback to the `<%DEPLOY_REPO%>` runbooks rather than documenting a raw
command as the sanctioned route — the honest third option in `.claude/skills/runbook/SKILL.md`,
but the weakest of the three.
**Blocked by / Action:** The scripts cannot be written against nothing — they need the deploy
repository's contract first (`how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md`). **The citation
half is done (11/08/2026):** no guide claims a script that has never existed — the `release`
procedure (now `.claude/skills/release/SKILL.md`) and `23-release/STEPS.md` Step 4 stop and
report rather than offering a command that cannot run. What remains is the scripts themselves,
and the Rollback section that depends on them.

---

## 09/08/2026 — Four security-specific incident runbooks are still unwritten

**Type:** Active gap
**Summary:** `code/docs/security/MONITORING-AND-INCIDENT.md` has named the same four missing
recoveries since it was written — account compromise (admin token revocation via `admin_db`),
audit-log tampering, Valkey cache compromise, and emergency key rotation. N-030 delivered the
**general** practice (`how-to/docs/INCIDENT-PRACTICE.md`: declare, run, hand over, stand down,
postmortem) and the PII-free register (`project-management/src/22-INCIDENTS/`), which is
deliberately not the same thing: those four need concrete Django shell commands against a live
system, and writing them from imagination is precisely what the execute-to-verify rule forbids.
**Blocked by / Action:** Each needs to be performed once against a non-production environment
before it can be documented. They belong in `how-to/docs/` beside `INCIDENT-PRACTICE.md`, which
now carries the forward reference rather than the old "no operator playbook exists" claim.

---

## 04/08/2026 — `BRAND-VOICE.md` was routed to by ten references but did not exist

**Type:** Active gap — **artefact written 04/08/2026, awaiting register closure**
**Summary:** `BRAND-VOICE.md` was named as a context-loading target by **ten** references, not the
five first recorded here: six agents (`frontend`, `mobile`, `desktop`, `seo`, `notifications`,
`support-articles`), the `stack-htmx-templates` skill, the root `DESIGN.md` standards table, and
`code/src/scripts/audits/copy-emdash.sh`, which cites it as the source of the copy rule the script
enforces. **No such file existed**, and none ever had: the reference was dangling in the template
itself, so every generated project inherited agents routing to nothing and one shipped audit
enforcing a rule whose doctrine was missing.

This is the copy half of the same defect the visual guides cover: `code/docs/VISUAL-DESIGN.md` § 4
bans the em dash as a machine-authored tell and defers the voice rules to `BRAND-VOICE.md`, which
never arrived. The audit worked; the standard behind it was absent.

**Resolution (04/08/2026, node N-011):** written as **`how-to/src/BRAND-VOICE.md`** — not in
`06-BRAND-GUIDE/` as first proposed. It is a **prerequisite artefact**, in the same class as the
project brief and the two architecture snapshots, and it is settled **before** planning or code
because every other prerequisite document is written in the voice it defines. Wired into
`how-to/workflows/01-first-time-setup/` as **Step 8**, between the brief (Step 7, which names the
reader it is written for) and `/scale-planning` (Step 9). All ten references repointed; portable
core in § 1 and § 4, per-project placeholders in § 3 and § 5, on the same split
`VISUAL-DESIGN.md` uses.

**Blocked by / Action:** Closure belongs to
`project-management/workflows/21-implementation-documentation/`, against shipped code — not to the
map or to this edit. The prose-tell detector that would enforce § 4 beyond the em-dash clause is
**N-012** on `project-management/src/01-FEATURE/MAP-DOCTRINE-UPGRADE.md`.

---

## 03/08/2026 — The Python pre-commit hooks cannot run in syntek-base itself

**Type:** Infrastructure gap
**Summary:** `lefthook.yml` runs `ruff-lint`, `ruff-format` and `basedpyright` on `glob: "*.py"`
via `uv run`. In a **generated** project that works. In syntek-base it cannot: the repo's own
`pyproject.toml` legitimately contains `name = "<%PROJECT_SLUG%>"`, which is not a valid PEP 508
name, so `uv` fails to resolve the project before any linter starts:

```text
error: Failed to parse: `pyproject.toml`
  Not a valid package or extra name: "<%PROJECT_SLUG%>"
```

Any commit in this repository that stages a `.py` file therefore fails pre-commit — including a
pure rename, since the glob matches the path rather than the diff. The v2.0.0 release commit hit
exactly this: `brand_guide.py` and `components.py` moved with their folders and carried no content
change at all. Markdown, Prettier, ClickUp-export and code-review-graph hooks all passed.

**The blast radius is wider than the hooks.** Two further instances of the same root cause are
already on record — `pip-audit` cannot parse the manifest either (see the `pnpm audit` entry),
and **`MAP-DOCTRINE-UPGRADE` N-016 hit it a third time (09/08/2026)**: a Playwright spike could
not run under plain `uv run` in this repository. It ran under
`uv run --no-project --with playwright`, which is the general escape hatch and is worth knowing —
but the pattern is now established rather than incidental. **Any template-level tooling that
shells out to `uv run` fails in the base repo and works in a generated project**, which is the
worst shape of bug: it cannot be caught by using the template, only by developing it.

**Blocked by / Action:** Guard the three Python hooks the same way the CI jobs are guarded for the
missing `uv.lock` — skip when `pyproject.toml` still contains an unrendered token. Something like
a `skip:` predicate testing `grep -q '<%' pyproject.toml`. Until then, template-repo commits that
touch a `.py` file need `--no-verify`, which is a blunt instrument: it also skips the Markdown and
Prettier gates that _do_ work here, so run `code/src/scripts/syntax/lint.sh` and `format.sh`
manually first. **Apply the same predicate to any new script that calls `uv run`**, or prefer
`uv run --no-project --with <dep>` where the work does not need the project's own environment.

---

## 02/08/2026 — Two accepted Rust advisories have a re-check date but no mechanism

**Type:** Active gap — **decision debt**
**Summary:** `code/src/rust/deny.toml` ignores `RUSTSEC-2026-0194` and `-0195` (denial-of-service
in `quick-xml` 0.38.4), reached only through Slint's Linux/BSD accessibility stack
(`accesskit_unix` → `atspi` → `zbus_xml`). The acceptance is sound — the chain is target-gated
away from Windows and macOS, the input is the local AT-SPI session bus rather than network data,
and both are DoS rather than code execution. It is also **not fixable downstream**: every version
pin from `accesskit_unix` up to Slint's own `=1.17.1` blocks the patched `quick-xml` 0.41.0.

The gap is not the decision, it is the **expiry**. cargo-deny ignores do not expire, so the
"re-check 02/11/2026" written in the TOML comment is enforced by nothing. Left alone, the entry
outlives its justification silently — which is exactly the failure `SUPPLY-CHAIN.md` warns about
when it says an ignore list of other people's transitive crates rots.

**Blocked by / Action:** On or before **02/11/2026**, or sooner if Slint releases a version
bumping `accesskit`: re-run `bash code/src/scripts/rust/audit.sh` with the two `ignore` entries
removed. If they no longer fire, delete them. If they do, extend the date **with a fresh
justification** rather than renewing the old one unread. Consider whether the template should
carry a CI step that fails when an `ignore` entry's stated re-check date has passed — that would
make this class of decay self-reporting rather than needing a register entry at all.

---

## 02/08/2026 — The five new how-to workflows have never been executed

**Type:** Active gap — **verification debt**
**Summary:** `04-database-operations`, `05-testing-and-coverage`, `06-quality-gates`,
`07-dependency-updates` and `09-write-operator-guide` were written against the real scripts and
their real flags, and every command in them was confirmed to exist. But they have not been **run
start to finish on a clean environment**, which is precisely the rule the `runbook` skill and
workflow `09` impose on every operator guide. They are currently verified by review only, and
review does not find a missing prerequisite.

The same root cause as the entry below applies to two of them: without `uv.lock` the Django image
cannot build here, so `04` and `05` cannot execute in this repository at all.
**Blocked by / Action:** Execute all five in a freshly generated project — `04` and `05` require
it — and correct each from what actually happens rather than from what was intended. Until then,
treat their step-by-step commands as reviewed, not proven.

---

## 02/08/2026 — The backend test suites never execute in this repository

**Type:** Active gap — **known limitation, accepted**
**Summary:** `uv.lock` is absent by design in the base template: it would pin the root project
under the literal project-slug token, so Copier generates it at generation time. Every
Dockerfile builds with `COPY pyproject.toml uv.lock ./`, so the Django image cannot build here
at all. `test.yml`, `test-api.yml` and `test-e2e.yml` now guard at **step** level on `uv.lock`
and report success with an explanatory log line instead of failing.

That is honest — there is genuinely nothing to run — but the consequence must be stated: **the
template never verifies its own backend, API or browser suites.** They are exercised for the
first time in a generated project. Before the guard they failed on every pull request, which was
worse: a permanently red check nobody could act on, and one that could never be made required.
**Blocked by / Action:** None to fix here. The realistic verification is the generation smoke
test in `audit-template.yml`, plus running the suites once in a freshly generated project after
any change to `code/src/django/`, the Dockerfiles, or the compose files. Treat a green
`pytest + coverage` in this repository as "not applicable", never as "passing".

---

## 09/08/2026 — `static-analysis.sh` has never actually executed, and has no CI workflow

**Type:** Infrastructure gap
**Summary:** N-029 authored 17 in-house Opengrep rules in `code/src/scripts/audits/rules/`, and
the script that runs them is correct — but **Opengrep is not installed** on the development host
or in CI, and `static-analysis.sh` is deliberately optional: without `opengrep` on PATH it prints
a note and exits 0. So every green run of it to date, including the "all audits pass" sweeps of
05/08 and 09/08, took the **skip** path. The rules have never been evaluated against a single
file, and their correctness is currently unevidenced rather than verified. N-008 wired the other
five audits into CI and deliberately did **not** wire this one: a workflow that installs nothing
would report a green security job having scanned nothing, which is worse than no job at all.

**Blocked by / Action:** Decide how the engine is obtained and pinned — a GitHub release binary
at a fixed tag with a checksum is the shape the supply-chain doctrine implies
(`code/docs/rust/SUPPLY-CHAIN.md` is the nearest precedent), not a `curl | bash` install script.
Then add `.github/workflows/audit-static-analysis.yml` with a step that **fails when the engine is
absent after install**, so a broken install is loud instead of silently green. Until then, treat a
clean `static-analysis.sh` as "did not run".

---

## 02/08/2026 — `pytest + coverage` is not yet a required status check

**Type:** Infrastructure gap
**Summary:** Ruleset `20221742` requires eight lint/audit/template checks plus the four mobile
jobs (`jest-expo + coverage`, `Bundle export`, `ESLint (mobile surface)`,
`TypeScript (mobile surface)`). `pytest + coverage` was deliberately left out: at the time it
could never report success here, so requiring it would have blocked every pull request.
**Blocked by / Action:** The lockfile guard above now lets it report success. Add it to the
required set once it has been green on `main` for a few runs — remembering, per the entry above,
that green means "skipped, nothing to run" in this repository.

---

## 02/08/2026 — Expo SDK tracking has no owner and no trigger

**Type:** Active gap
**Summary:** The mobile surface pins Expo SDK 57 exactly, and the template's own commitment to
track SDK releases has no named owner and no trigger condition. The first evidence of how fast
the set moves: the epic's research was done against SDK 55 and every "obvious" version choice
turned out wrong — Expo pins TypeScript ~6 (not 7), jest-expo 57 is on the **Jest 29** line (not
30), expo-router 57 needs React Native Testing Library **13** (not 14), and `eslint-config-expo`
is not ESLint 10 compatible. Each was found only by running the toolchain.
**Blocked by / Action:** Decide a cadence and an owner. An SDK bump is a versioned template
release that flows downstream through `copier update`, not a routine dependency bump.

---

## 02/08/2026 — Delimiter-safety guard is one-sixth implemented

**Type:** Active gap
**Summary:** `.github/scripts/check-template-tokens.sh` scans for the unclosed
variable-opening sequence only — one of the six delimiter forms. `copier.yml` claims its
delimiter set was chosen by scanning every tracked file for zero occurrences, but that analysis
predates both the mobile epic and the TypeScript in the tree. A literal scan already missed one
site, because markdown tables write the pipe as an escaped character.
**Blocked by / Action:** Extend the script to all six sequences **including markdown-escaped
forms**, or it will keep reporting a false all-clear.

---

## 02/08/2026 — `pnpm audit` is red for pre-existing reasons

**Type:** Active gap
**Summary:** The scheduled `audit-deps.yml` sweep runs `pnpm audit --audit-level low` and
reports roughly 20 advisories, almost all `axios` reached through `@usebruno/cli` — dev-only
API-test tooling. Separately, `pip-audit` cannot parse the root `pyproject.toml` here, because
the project name is an unrendered token rather than a valid package name, so the Python half of
`security.sh` never reports usefully while working on the template.
**Blocked by / Action:** Either bump or replace `@usebruno/cli`, or add the advisories to
`auditConfig.ignoreGhsas` with a written rationale. Consider making `security.sh` skip the Python
half with a clear message when the manifest is an unrendered template, mirroring the CI guards.
