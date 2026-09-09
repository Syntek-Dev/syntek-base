# ADR-US008: The cookie advisory is keyed where it ships, and that key is the first minor one

**Status:** Accepted
**Date:** 09/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US008 · `project-management/src/15-DECISIONS/ADR-US008-SCOPED-CITATION-BASELINE-09-09-2026.md` (the story's second record, on the scoped citation baseline; decides nothing argued here)

---

## Context

This record fixes Q5 and Q11 of the grilling pass of 08/09/2026, confirmed by
<%DEVELOPER_NAME%> that day; it is to be checked, not re-opened, at US008's own `15-decisions`
pass. Every line anchor in it was read at `ff24084`, the commit US008 was cut against, and
describes the tree before the story's own edits land.

US008 lands the cookie doctrine the map's cookie spine settled on 01/09/2026 (N-004 to N-008,
`project-management/src/01-FEATURE-MAPS/MAP-SUBDOMAIN-ROUTING.md:206-240`): cookies are host-only,
`SESSION_COOKIE_DOMAIN` and `CSRF_COOKIE_DOMAIN` are never set, both cookies take `__Host-` names
in `staging.py` and `production.py`, and `CSRF_COOKIE_HTTPONLY = True` ships (`:216`, `:240`) —
its placement in `base.py` rather than the environment modules is Q2 of 08/09/2026, on
`code/src/django/config/settings/CLAUDE.md:39-41`, not the map's. It also reverses the `_DOMAIN`
mandate at `code/docs/URL-STRATEGY.md:149-150`, which until this story told a project heading for
subdomains to set both settings to the leading-dot apex. The rest of that bullet is **not**
reversed: `:151`'s security-review precondition stands, and `:152-153`'s `CORS_ALLOWED_ORIGINS`
explicit-allowlist rule is a `.claude/CLAUDE.md` Section 6 non-negotiable that survives the
rewrite verbatim. **The `_DOMAIN` text was a mandate, and a generated project may have obeyed
it.**

An update three-way merges the template's own edits into the project
(`how-to/src/TEMPLATE-GUIDE/14-UPDATING.md:15`) — the five rewritten guides and the three settings
modules alike. What it cannot reach is a line the project wrote on the old doctrine's
instruction. A `SESSION_COOKIE_DOMAIN = ".example.com"` the project added beside its own settings
and the `__Host-` names the template adds are different lines, so the merge can succeed without a
conflict — and the result is a `__Host-` cookie carrying a `Domain` attribute, which the browser
rejects by the prefix's own definition (N-005 confirmed it at spec level). Every login in that
environment then fails, with no conflict, no error, and `copier update` reporting success. Two
smaller things are equally the operator's alone: the rename invalidates every live session and
every open CSRF token at first deploy, so **when** is a decision; and anything matching the
cookie by name — an edge rule, a monitor, a test — must be repointed.

That is the class `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md:195-199` gives `_migrations` to:
the one thing copier's merge cannot do on its own. Every entry so far answered a path or a value
copier itself moved, split, deleted or overwrote — two renumbers (`v7.0.0`, `v2.0.0`), four
renames (`v6.0.0`), a split guide (`v5.0.0`, keyed twice), a deleted ".claude/agents/" directory
(`copier.yml:829-835`; quoted rather than backticked because the path no longer exists and the
`.claude/` tree is one the citation gate checks, `code/src/scripts/audits/doc-references.sh:875`)
and a rewritten `pyproject.toml` `[project] name` (`:840-854`); this is the first to answer a
reversed doctrine, where nothing moves at all, and `06-GENERATION.md`'s own test at `:217-220`
sends it to the advisory side — the right answer depends on what the project meant, and a
machine guessing between "delete the line" and "this project really does share cookies across
hosts" produces a confident sentence that is wrong.

**One question had to be proved rather than assumed.** `copier.yml:814` carries seven entries,
keyed `v7.0.0`, `v2.0.0`, `v3.0.0`, `v4.0.0` twice, `v5.0.0` and `v6.0.0`. Every key this file
has ever held is MAJOR — `git log --all -p -- copier.yml` yields six distinct `version:` values,
all `.0.0`. US008 ships at 7.6.0, and nothing in-repo says whether copier fires on a minor key.
It does, and `Template.migration_tasks()` in copier's `_template.py` is what says so:

- `current = parse(migration["version"])` is `packaging.version.parse` — a plain PEP 440 parse,
  no component of which is inspected. The leading `v` is admitted; the six existing keys already
  carry it.
- The sole gate is `if not (self.version >= current > from_template.version): continue` — the
  inequality `copier.yml:862-863` states as `old_version < key <= new_version`.
- `Template.version` is read by dunamai from git tags (the `version` property,
  `Pattern.DefaultUnprefixed`, serialised PEP 440). This repository carries 72 tags, `v7.1.0` to
  `v7.5.0` among them, so `v7.6.0` resolves the day it is tagged.
- Worked: a project at 7.5.0 updating to 7.6.0 evaluates `7.6.0 >= 7.6.0 > 7.5.0`, true, and
  fires once. Its next update to 7.7.0 evaluates `7.7.0 >= 7.6.0 > 7.6.0`, false. A project at
  7.4.1 updating straight to 8.0.0 fires once.

**How that is cited matters, because the line moves.** The pair was read at `_template.py:457-458`
in copier **9.17.2** — the predicate on one line, `continue` on the next, so a one-line quote
merges two — and it sits at `:442-443` in 9.17.0. Nothing pins copier: `_min_copier_version:
"9.6.0"` at `copier.yml:13` is a floor, and both live invocations are bare —
`.github/workflows/audit-template.yml:154`, and
`code/src/scripts/development/template-update.sh:113-114`, which prefers a `copier` on `PATH` and
falls back to `uvx copier`. On the machine this record was written on, `uvx copier --version`
answered **9.18.2** on 09/09/2026, one minor above what the handoff cites; the region diffs
identical between the two, which is luck rather than a guarantee.
`project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md:196-199` (N-010) already records the
same hazard against a different line and says "pin exactly".

**The preview cannot show it.** `template-update.sh` is the update path the guide leads with and
the one its pre-update checklist names (`how-to/src/TEMPLATE-GUIDE/14-UPDATING.md:49`, "Preview it
first. Always."; `:256-257`, "This is the step that catches the silent failure"). It is not the
only path — `:76-83` documents driving Copier directly, and a raw `copier update` that crosses
the key prints the advisory straight to the terminal — so the blindness is the wrapper's, not
Copier's. The wrapper's preview runs copier at `template-update.sh:143-144` with stdout and stderr
redirected wholesale to `$UPDATE_LOG`, tails that log at `:148-151` only when the exit code is
non-zero, and its `cleanup` at `:122` deletes the log even under `--keep-scratch`. A print-only
advisory exiting 0 therefore never reaches the preview's report — the report the guide says
decisions are made from. The `--apply` invocation at `:281-282` is unredirected, so the advisory
does print, after the operator has decided and inside copier's own output. Three shipped
migrations already live with this — the two advisories `v3.0.0` and `v5.0.0`, plus the
report-only third of `v6.0.0` (`copier.yml:899`, "ACTS on two things and only reports on the
third") — and `14-UPDATING.md:144`'s "The update tells you" is true of the apply and silent
about the preview. **The defect predates US008; the story adds a fourth print-only report to a
blind preview, it does not create the blindness.**

## Options considered

### Option A — no migration; the CHANGELOG and the rewritten guides carry the change

- **Summary:** the doctrine ships in the docs and the settings; a project reads `RELEASES.md`.
- **Pros:** nothing new in `copier.yml`; copier moves, splits, deletes and overwrites nothing of
  the project's here, which is what every entry so far answered — the rewritten guides and
  settings modules are the template's own, and the merge carries them down intact.
- **Cons:** the failure is silent and total in the environment it hits — a clean merge, a success
  message, and no login. The guide's rule at `06-GENERATION.md:222-223` is written for moved
  directories, but the class it belongs to (`:196-197`) is "what the merge cannot do on its own",
  and a project-written line the merge preserves is exactly that. A release note is read by the
  operator who already knows to look.

### Option B — an acting migration that deletes the `_DOMAIN` lines it finds

- **Summary:** grep the settings modules, strip both settings, report what was removed.
- **Pros:** closes the login failure mechanically; nobody has to read anything.
- **Cons:** fails the advisory test at `06-GENERATION.md:217-220` on its own terms. There is more
  than one correct answer — N-005 confirmed the cross-subdomain premise "with two named limits",
  so a project may hold that line deliberately — and a setting written somewhere the script does
  not look survives anyway. Deleting a security setting from a live project's configuration
  behind a success message is the `v4.0.0` failure with the sign flipped, and `.claude/CLAUDE.md`
  Section 0 lets nothing be "dropped or rewritten in place without a named recovery path" — which
  a migration deleting a security setting inside `copier update` has no way to offer. The session
  invalidation is a deploy-timing decision no script can take.

### Option C — hold the advisory for the next MAJOR key

- **Summary:** keep every key `.0.0`; ship the advisory under `v8.0.0` when that release comes.
- **Pros:** the seven-entry pattern stays unbroken, and a reader who inferred "MAJOR only" is not
  contradicted.
- **Cons:** the doctrine ships at 7.6.0. A key naming a release the change did not ship in is the
  mis-keying `copier.yml:856-867` carries a duplicate entry to remedy and `:913-916` names as the
  thing this repository has done and must not repeat — every project updating between 7.6.0 and
  8.0.0 crosses the doctrine and never sees the report. The pattern is an accident of what the
  first seven changes were, not a rule anything states or enforces.

### Option D — a print-only advisory keyed `v7.6.0` (the decision)

- **Summary:** an eighth entry at the release the doctrine ships in, on the convention the two
  shipped advisories fix: reports each `_DOMAIN` hit with file and line, names the deploy-time invalidation,
  ends with the proof step, exits 0 always.
- **Pros:** fires by the mechanism proved above; the key is honest to the release; the script
  convention is fully specified by `.copier/migrations/v3.0.0-self-authored-agents.sh` and
  `v5.0.0-git-guide-split.sh`; its proof step is the gate this same story widens.
- **Cons:** the first minor key, which must be said deliberately or it is read as a slip. It
  prints only on apply until the preview is fixed. Its citation of copier's source is dated to a
  version nothing pins.

### Option E — fix the preview in the same change

- **Summary:** surface the migration banner lines from `$UPDATE_LOG` in the preview's report on
  success, alongside D.
- **Pros:** closes the blindness for every print-only report at once; the operator sees the report
  where the guide says to decide.
- **Cons:** a behaviour change to a 295-line script with its own contract — the failure tail, the
  `--keep-scratch` cleanup, the orphan and dependency audits it sequences — inside an 8 SP story
  flagged Security for a cookie doctrine. Three print-only reports have shipped without it, the apply still
  prints, and a template clone can still run the script by hand. The cost of leaving it is bounded
  and known; the cost of taking it is a second concern in a story that already carries five
  guides, three settings modules, a gate clause and a release.

## Decision

**We will take Option D, and carry Option E as a `GAPS.md` row rather than take it.**

The deciding factor is that **a key names the release the change shipped in, whatever that
release's semver tier.** That is the rule `copier.yml:913-916` already states for `v6.0.0` and
`:856-867` pays for having broken once; the mechanism is indifferent to the tier, as proved. The
tier itself is this record's reading of rules already written, not a choice made here:
`project-management/docs/VERSIONING-GUIDE.md:58-59` places internal service signatures, the
management commands and the dev scripts outside the public surface and names no settings module
either way — and the declaration is still marked **TBD** at `:48` — so treating
`config/settings/*.py` as out of scope is an inference over that table, not the guide's text. On
that reading `:64` makes an out-of-scope change MINOR or PATCH, and `:76-77` makes a new gate
clause, a new migration and a reversed doctrine a MINOR rather than a PATCH's "bug fixes, copy
changes, documentation updates". So the first minor-keyed migration is what those rules produce
when a doctrine ships at a minor — **stated here deliberately, because nothing else in the tree
says a key may be minor, and a reader of seven `.0.0` keys would otherwise conclude it may not.**

Five things follow. Each is the consequence the key decision carries, not a build instruction —
the script's shape, the gate's widening and the register rows are US008's tasks, executed and
ticked there:

- **Print-only, exit 0 always.** The script is `.copier/migrations/v7.6.0-<slug>.sh`, on the
  convention `.copier/migrations/v3.0.0-self-authored-agents.sh` and `v5.0.0-git-guide-split.sh`
  fix — header, banner, early exit and all — and its filename records the release it was written
  for, on the latter's own terms. Its report ends in the proof step, the unscoped
  `bash code/src/scripts/audits/negative-space.sh` (`--path` is refused), so the advisory's last
  line is the same check the template runs; how far the story must widen that gate's settings
  scope for the `__Host-` half of the assertion — today it reads `base.py` alone, and its
  self-test scope must move with it — is US008's build work, not this record's.
- **The entry goes at `copier.yml` line 919/920** — after the `v6.0.0` entry at `:917-919`, before
  the comment block at `:921-928`. The unversioned `- command: rm -rf .copier` at `:929-930`
  **stays last**: declaration order is run order (`copier.yml:819`, `06-GENERATION.md:211`), and
  that entry is deliberately unscoped so it holds for every release. The comment above the new
  entry states the first-minor-key fact in the file's own register, because `copier.yml` is what
  the next author reads and this record is not. Its `command:` and `when:` lines take the form
  the seven existing version-keyed entries use, resolving the script through the template clone's
  `_copier_conf.src_path`.
- **The register row goes at `06-GENERATION.md:209`'s position**, before the `_(every)_` row —
  that table is declaration order, not version order, and its own `:211` says so. The file is
  outside `audits/docs-length.sh`'s scope — the gate reports nothing to check for it — so no
  allowance question arises.
- **Copier's source is cited version-safely.** Name `Template.migration_tasks()`, or give the
  line pair with the copier version it was read in — this record does both. A bare `:457` is a
  claim about whatever `uvx` resolved that morning.
- **The blindness is accepted, and the `GAPS.md` row is what accepting it obliges.** The row is
  the entry dated 09/09/2026 on a print-only `_migrations:` advisory being invisible in the
  `template-update.sh` preview, in the shape `GAPS.md`'s _Format_ section fixes — **Type:**
  Active gap; a **Summary:** that names the wrapper's redirect, its failure-only tail and the
  trap that unlinks the log, classes the failure **B**, false green, and names the class rather
  than the `v7.6.0` entry alone; and a **Blocked by / Action:** that nothing blocks. It is named here by date and subject rather than by a quoted title or a line, so a later
  re-wording of the register cannot falsify an immutable record. Until it closes, the operator
  relies on the apply printing the report, and on a template clone running the script by hand —
  `.copier/` never travels (`copier.yml:810-812`), so a project cannot run it from its own tree.

One document must not be cited for any of this. `project-management/docs/git/MIGRATION-GATES.md`
sounds governing and is not: it covers **database** migration review gates and contains zero
occurrences of "copier". The register of record for the key rule is `copier.yml`'s own comments;
the guide is `06-GENERATION.md:193-223`, and the operator's side is `14-UPDATING.md`.

## Consequences

- **Positive:** the one failure an update produces silently — a `__Host-` name with a `Domain`
  attribute, and no login — gets a report with file and line before the first deploy, and the
  report ends in the same gate the template enforces. The mechanism behind the key is proved on
  copier's source, not assumed from seven examples.
- **Positive:** the precedent is stated where it binds. A key follows the release, not the tier;
  the next doctrine that ships at a minor gets a minor key without re-arguing this record.
- **Negative / trade-off:** the seven-entry pattern breaks. A reader who inferred "MAJOR only"
  loses the inference; nothing enforced it, so nothing else breaks. The tag must land with the
  release: until `v7.6.0` exists `Template.version` reads `7.5.0.postN.dev0+<hash>` for an
  untagged HEAD — `7.5.0.post31.dev0+ff24084` at the commit this record was written against —
  which is below `7.6.0`, so an update pulled from HEAD between the commit and the tag
  carries the doctrine and never fires the advisory — the retroactive-tagging hazard
  `copier.yml:913-916` names, from the other direction.
- **Negative / trade-off:** the preview stays blind. An operator who previews, reads "no orphans,
  no dependency change" and applies sees the cookie report only after applying. Accepted because
  the apply does print it, the defect is three print-only reports old, and the fix is a separate concern
  with a separate blast radius — carried as the `GAPS.md` row above, not forgotten.
- **Negative / trade-off:** the citation of copier's source is dated. `_template.py:457-458` is
  true of 9.17.2 and 9.18.2 and false of 9.17.0; the name `Template.migration_tasks()` outlives
  any of them. Pinning copier is N-010's obligation on
  `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md`, not this story's.
- **Negative / trade-off:** a project that holds a `_DOMAIN` line deliberately — the N-005 case —
  gets a report it must judge and dismiss. The advisory says so rather than deciding; that is the
  cost of Option D over B, and it is the right way round.
- **Follow-on:** US008 carries the entry, the script, the `06-GENERATION.md` row, the `GAPS.md`
  row, and the 7.5.0 to 7.6.0 bump through the `version` skill — and the `v7.6.0` tag through
  `git` at release, the tag being what `Template.version` reads. `14-UPDATING.md` is not edited:
  its `:144` claim is true of the apply, and documenting the blindness there would describe a
  defect the row exists to close.
- **Follow-on:** this record decides nothing about the doctrine itself, which the map's cookie
  spine settled, nor about the gate that proves it, which the story carries. A later story that
  makes the preview show migration output closes the row and leaves this record standing; a later
  story that pins copier retires the version caveat and leaves the citation rule standing.
