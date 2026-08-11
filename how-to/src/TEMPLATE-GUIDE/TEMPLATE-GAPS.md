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

## 09/08/2026 — ✅ CLOSED 09/08/2026 — The Rust CI gate cannot pass in syntek-base: a token sits in a crate name

**Type:** Infrastructure gap — **fixed by option 1 below, same day**

> **Closed.** `[[bin]] name` is now the house constant `desktop`; `package.sh` copies the built
> artefact to `<%PROJECT_SLUG%>-desktop` afterwards, so the deliverable is unchanged and no token
> sits in the compiler's path. `lint.sh`, `test.sh` and `package.sh` all now run green in the
> template repository for the first time.
>
> **The fix surfaced a second defect the first one had been masking.** With the crate finally
> compiling, `clippy::todo` fired on Slint's **own generated code** — `slint-build` emits
> `todo!("Components written in Rust can not get embedded yet.")` into `out/app.rs`. The
> generated-code lint boundary in `main.rs` already existed and already explained itself; it
> simply had not been extended when the three lints were added hours earlier. `clippy::todo`,
> `clippy::unimplemented` and `clippy::unreachable` were added to the scoped `#[allow]` on
> `mod ui`, and to the four documents that carry a copy of that list
> (`code/docs/desktop/UI-AND-STATE.md`, `code/docs/DESKTOP.md`, `.claude/skills/stack-slint`,
> `.claude/skills/stack-rust`). **The standing rule now stated in `UI-AND-STATE.md`: deny a lint
> in the crate's `[lints.clippy]` and allow it on the generated module in the same change.**
>
> **The class is closed too** — `how-to/src/TEMPLATE-TOKENS.md` gained _Position matters as much
> as shape — never tokenise a validated identifier_, with the position table and this crate as
> the worked example.
>
> The original entry follows, unedited.

**Summary:** `code/src/rust/crates/desktop/Cargo.toml:21` declares
`[[bin]] name = "<%PROJECT_SLUG%>-desktop"`. rustc validates a crate name as an **identifier**,
and rejects `<`, `%` and `>` in one, so the crate cannot compile until Copier renders the token:

```text
error: invalid character '<' in crate name: `<%PROJECT_SLUG%>_desktop`
error: could not compile `desktop` (bin "<%PROJECT_SLUG%>-desktop") due to 3 previous errors
```

`scripts/rust/lint.sh` runs `cargo clippy --workspace --all-targets`, so **every** workspace-wide
cargo command fails here — lint, test and `cargo-deny` alike. `.github/workflows/syntax-rust.yml`
runs all three unguarded on any push touching `code/src/rust/**`, so that job is red on `main`
today. `nativecore` is unaffected and checks clean on its own.

**Generated projects are fine.** The token renders to a valid slug and the crate compiles, which
is exactly why this has stayed invisible: the only place it breaks is the one repository whose CI
nobody generates.

**It is a single instance, not a pattern — and that is the useful part.** Every other token in the
Rust tree sits in a position the compiler never parses as code:

| Position                            | Example                                               | Validated? |
| ----------------------------------- | ----------------------------------------------------- | ---------- |
| Comment                             | `# Cargo workspace for <%PROJECT_NAME%>.`             | no         |
| `description` / `authors` free text | `description = "Native desktop application for …"`    | no         |
| `license` string                    | `license = "<%LICENCE%>"`                             | no¹        |
| Rust doc comment                    | `//! Native desktop client for \`<%PROJECT_NAME%>\`.` | no         |
| Slint string literal                | `title: "<%DESKTOP_APP_NAME%>";`                      | no         |
| **`[[bin]] name`**                  | `name = "<%PROJECT_SLUG%>-desktop"`                   | **yes**    |

¹ `<%LICENCE%>` is not a valid SPDX expression either — the workaround is already in place and
documented, `deny.toml` → `private.ignore`, with the reasoning in `nativecore/Cargo.toml`. That is
the same class of defect caught once and worked around rather than named, which is why the class
is worth naming now.

**The token contract has no rule for this.** `how-to/src/TEMPLATE-TOKENS.md` classifies tokens by
prose shape (`phrase · cell`, `reverse-domain`) and has a _Derived forms_ section for tokens that
**compose** into larger identifiers — but nothing that asks whether the resulting string has to
satisfy a **grammar**. A slug composes into `<%PROJECT_SLUG%>_dev` (a database name, unvalidated
until runtime) and into `<%PROJECT_SLUG%>-desktop` (a crate name, validated at compile time), and
the contract cannot currently tell those apart.

**Blocked by / Action:** Not blocked. Three options, in order of preference:

1. **Make the bin name a house constant** — `name = "desktop"` — on the precedent the sibling
   crate already sets and documents: _"`nativecore` is a HOUSE CONSTANT, not a token: like
   apps.marketing and apps.design_tokens, the name is the same in every generated project so the
   import path is stable across the estate."_ The branded filename, if wanted, is
   `scripts/desktop/package.sh`'s job — it currently stops at `target/release/` and renames
   nothing, so this is a rename plus a copy step, and it leaves **zero** compiler-validated tokens
   in the Rust tree.
2. **Keep the token, exclude the crate from the template's own Rust CI.** Cheapest to write and
   the worst outcome: Slint then never compiles in syntek-base at all, so an upstream Slint break
   ships to the first project that opts in.
3. **A Copier post-task that rewrites the name at generation time.** Another moving part, and it
   still leaves the template repo's own gate red.

Then close the class: add a **position** column or a one-line rule to `TEMPLATE-TOKENS.md` — _a
token never lands where a compiler, parser or schema validates the result as an identifier_ — and
consider teaching `check-template-tokens.sh` the handful of positions that qualify.

**Related:** _"The backend test suites never execute in this repository"_ (02/08/2026) is the same
family — a gate that cannot run in the template and therefore proves nothing before generation.
This one is narrower and has a concrete fix.

## 09/08/2026 — Epic node numbers are cited in shipped files, where the map they index does not exist

**Type:** Active gap
**Summary:** Found while landing N-027, which closed **one** instance and, on being challenged,
turned out to have closed the smaller half of a class. `code/docs/logging/OBSERVABILITY.md` had a
Deferred row reading _"N-027 adopts **OTLP**…"_ — epic paperwork in a file that ships, meaningless
in a generated project that has no N-027 and may have pruned the map entirely. That one is fixed.
**Four more remain, all in files `copier.yml` does not exclude:**

| File                                | Line | Cites                        | Shape                                 |
| ----------------------------------- | ---- | ---------------------------- | ------------------------------------- |
| `.claude/skills/grilling/SKILL.md`  | 29   | `MAP-DOCTRINE-UPGRADE` N-009 | Rationale — "this happened once here" |
| `.claude/skills/wayfinder/SKILL.md` | 112  | `N-023`/`N-024`/`N-025`      | Illustrative example of node grouping |
| `.claude/MEMORY.md`                 | 37   | `MAP-DOCTRINE-UPGRADE` N-009 | Rationale for the round-shape sweep   |
| `.claude/MEMORY.md`                 | 56   | N-030                        | Provenance of a memory entry          |

These are **weaker than the one that was fixed** — dangling citations rather than false
instructions, and each rule stands without its citation. That is why they were recorded rather
than swept during N-027: the node's scope was the tracing doctrine, and quietly widening it is how
a footprint stops being reviewable. **`.claude/MEMORY.md` raises the larger question underneath
this one** — it ships with syntek-base's own memory entries, which is a bigger inheritance problem
than the node numbers inside them, and is not this entry's to settle.
**Blocked by / Action:** Not blocked. Either strip the node numbers and keep the rationale
(_"this has happened in this repository before"_), or accept dangling citations as the cost of
provenance and say so once, somewhere binding, so the next agent stops re-finding it. The
`MEMORY.md`-ships question needs its own decision.

## 09/08/2026 — ✅ CLOSED 09/08/2026 — Prettier corrupts a token beside underscored code, unseen

**Type:** Active gap — **closed by the untracked-files fix below; they were one defect**
**Summary:** Found while landing N-028. An `OBJECT_STORE` token was written into a prose sentence
that also contained an underscored code span; `format.sh --fix` parsed the underscores as Markdown
emphasis, reflowed the paragraph, and rewrote the token's own underscore as an asterisk — a name
Copier does not recognise, so it would render as literal text into every generated project. The
formatter reported success and the token guard reported `✓ all registered`.
**The first diagnosis was wrong, and the correction is the useful part.** It read as "the guard
cannot detect this class" — but `check-template-tokens.sh` has carried a `Malformed tokens`
detector since it was written, and that detector is correct. It simply never ran on the file:
`scan()` reads `git ls-files`, and nothing in this repository is committed. **The Prettier
behaviour is real and will recur; it is now caught rather than silent.**
**Blocked by / Action:** _Done._ No new detector was needed — the fix was the file-selection
one-liner below. Prevention still applies when writing: prefer `**bold**` over `_emphasis_` near a
token, and keep a token out of a sentence carrying an underscored code span.

## 09/08/2026 — ✅ CLOSED 09/08/2026 — `check-template-tokens.sh` is blind to untracked files and reports a false all-clear

**Type:** Active gap — **fixed during N-028**
**Summary:** The guard scans `git ls-files`, so a file that has not been `git add`-ed is invisible
to it. Found while landing N-030: six new files and one modified guide carried **twelve
occurrences of the unregistered token `INCIDENT_TRACKER`**, and the script reported
`✓ 1831 well-formed tokens, all registered in copier.yml`. The modified guide
(`how-to/src/PLATFORM-PROVIDERS.md`) was itself untracked — nothing in this repository is
committed — so even the edit to an existing file went unseen. CI is safe, because everything is
tracked by the time it runs; **local runs are not**, and local is exactly when the file you just
wrote is the one that needs checking. Same signature as the delimiter-guard entry below: a guard
whose green means "did not look".
**Blocked by / Action:** _Done, 09/08/2026 (N-028)._ `scan()` and the token counter now read
`git ls-files` **plus** `git ls-files --others --exclude-standard`, via a shared `candidates()`
helper. Proved by planting a mangled token in an untracked file: green before, caught after — and
the first real finding was `MAP-DOCTRINE-UPGRADE.md`, which had quoted a corrupted token in prose
and ships. As predicted, the one line removed the **class** of false all-clear, not the instance:
it closed the Prettier-corruption entry above at the same time.

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
repository's contract first (`how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md`). Either write them
once that contract is settled and replace the Rollback section, or downgrade the five dangling
citations to "planned" so no guide claims a script that has never existed.

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

## 04/08/2026 — Two ADRs are cited across the template and neither exists

**Type:** Active gap
**Summary:** `ADR-016` and `ADR-019` are referenced as though they are real, accepted decisions, in
files that **ship**: `code/workflows/03-database-migration/CONTEXT.md` (ADR-016 co-location for the
`tenant_id` shard key), `code/src/scripts/audits/css-tokens.sh` and
`code/src/scripts/audits/css-gradients.sh` (ADR-019, the Django static token cascade and the
post-ADR-019 CSS surfaces), and the root `REFERENCES.md` (ADR-016/ADR-023 against
`architecture/CORE-AND-SCALING.md`). `project-management/src/14-DECISIONS/` contains only
`ADR-000-TEMPLATE.md`. Every generated project therefore inherits two shipped audit scripts and a
code workflow citing decision records that have never existed — and a third number, ADR-023, cited
in `REFERENCES.md` alone.

Same class of defect as the `BRAND-VOICE.md` entry below: the rule is enforced, the document
behind it is missing. The difference is that here the **numbering** is also at risk — the ADR
template instructs "take the next free index; never reuse a number", and a project that writes its
first real ADR as `ADR-001` will eventually collide with the reasoning these citations assume.

**Blocked by / Action:** Decide per citation whether the ADR should be **written** (the reasoning
is real and worth recording — most likely for the ADR-016 shard-key co-location and the ADR-019
token cascade, both of which have live enforcement behind them) or the **citation dropped** in
favour of pointing at the guide that actually carries the rule. Do not renumber existing
references without settling that first. Unclaimed by any node on
`project-management/src/01-FEATURE/MAP-DOCTRINE-UPGRADE.md` — found while resolving N-026.

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

## 02/08/2026 — `pytest + coverage` is not yet a required status check

**Type:** Infrastructure gap
**Summary:** Ruleset `20221742` requires eight lint/audit/template checks plus the four mobile
jobs (`jest-expo + coverage`, `Bundle export`, `ESLint (mobile surface)`,
`TypeScript (mobile surface)`). `pytest + coverage` was deliberately left out: at the time it
could never report success here, so requiring it would have blocked every pull request.
**Blocked by / Action:** The lockfile guard above now lets it report success. Add it to the
required set once it has been green on `main` for a few runs — remembering, per the entry above,
that green means "skipped, nothing to run" in this repository.

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

## 02/08/2026 — Delimiter-safety guard is one-sixth implemented

**Type:** Active gap
**Summary:** `.github/scripts/check-template-tokens.sh` scans for the unclosed
variable-opening sequence only — one of the six delimiter forms. `copier.yml` claims its
delimiter set was chosen by scanning every tracked file for zero occurrences, but that analysis
predates both the mobile epic and the TypeScript in the tree. A literal scan already missed one
site, because markdown tables write the pipe as an escaped character.
**Blocked by / Action:** Extend the script to all six sequences **including markdown-escaped
forms**, or it will keep reporting a false all-clear.

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
