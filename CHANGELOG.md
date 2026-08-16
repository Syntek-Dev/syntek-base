# Changelog

**Last Updated**: <%DATE%> **Version**: 4.1.1 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [4.1.1] - 16/08/2026

### Added

- **`THIRD-PARTY-NOTICES.md` gains the matching _why no notice_ row for the methodology the layering came from.** CC BY 4.0 binds sharing and adapting; this template does neither — it takes facts and method — and the working note that quotes the paper is syntek-base's own and untracked, so no quotation is redistributed and no notice is owed. Written as a row rather than left implicit, because "nothing is owed here" is a conclusion, and a conclusion nobody records is one the next person re-derives from scratch or gets backwards.
- **One licence carve-out is stated outright, because the repository badge is misleading.** The protocol repository is MIT at its root, but its bundled `workspaces/*/skills/pptx/` and `skills/frontend-design/` carry `(c) 2025 Anthropic, PBC. All rights reserved` and are governed by the reader's own Anthropic terms — not MIT, and not vendorable onward. `.claude/CLAUDE.md` Section 6 requires the licence column to be checked **before** deriving, not after; this is the case where the column and the files underneath it disagree, so the column on its own would have returned the wrong answer.

### Changed

- **The Influences entry for the layering stops being a name and two profile links and names the primary sources it actually came from** — Interpretable Context Methodology (Van Clief & McDermott, arXiv:2603.16021v2, CC BY 4.0) and the two MIT repositories beside it — in `README.md` and `.copier/README.md` in the same change, the shipped README being the one a generated project reads. It also states what the paper says that the old row only implied: a five-layer hierarchy in which the **stage contract**, not the root file, is the control point.
- **The row carries the evidence caveat with it.** A citation that omits one invites the claims to be borrowed as measured, and the paper is candid in its Section 4.6 that its figures are practitioner self-report and that no controlled comparison against monolithic prompting has been run.

### Fixed

- **The template had not generated a project since `8050ac7`, and the cause was seven characters in an audit script.** `conflict-markers.sh` builds its markers rather than writing them out, because a file that greps for conflict markers must contain none or it flags itself on the first run — that instinct is right and stays. The expression it reached for put Copier's own variable-opening delimiter in the file, so Jinja opened an expression, never found the closer, and `copier copy` died with `TemplateSyntaxError` before writing a single file. `%.0s` consumes its `seq` argument and prints nothing, so the literal sits on either side with identical output: `printf '%.0s<'` builds the same seven characters and carries no delimiter. Equivalence was proven byte-for-byte on all three builders before the edit rather than argued from the format-string rules.
- **All three builders were reordered though only the first was at risk.** `CLOSE` and `MANGLED_CLOSE` build from `>` and were always safe, but leaving them bracket-first leaves the next person a template to copy, and the copy is what reintroduces the class. The escape spelling `printf '\x3c%.0s'` was declined: it works, and it hides the character behind a hex code from a reader who then cannot see what the script builds. The comment above the builders is the durable half instead — it names the constraint, why it exists, that this script shipped the defect, and which gate catches it.
- **Proven four ways, and the generation is the one that counts.** `check-template-tokens.sh` at **1986** well-formed tokens, exit 0; its `--self-test` at 8 probes with the unclosed-variable check still firing; `conflict-markers.sh --self-test` 6/6, including _fires on all 4 known-bad forms_, which is what proves the reordered builders still emit real markers; and a full `copier copy` at exit 0, five tasks, `name = "gen-probe"`, a `uv.lock` naming the generated project with zero `syntek-base` occurrences, and the generated copy's own self-test passing inside the probe. Thirteen audits green after, and no `CONTEXT.md` touched — behaviour, flags and output are identical, so the inventory row still describes it.
- **What none of that fixes is why it shipped.** `check-template-tokens.sh` was exiting 1 and naming the file, the line and the remedy the whole time. `audit-template.yml` runs only on `main`, `staging`, `dev` and `testing`, so on a feature branch it had not run once in **seventeen commits** — the gap the next release closes.
- **`http://localhost:8000` appeared in seventeen places and was never an address a browser could reach.** `docker-compose.dev.yml` publishes `127.0.0.1:81:80` from nginx and the django service carries no `ports:` block at all, so 8000 is the container's internal port and nothing else. The correct address is the one `server.sh up` already prints and that `tests/e2e/conftest.py` and `e2e-py.sh` already default to — `http://dev.<%PROJECT_SLUG%>.localhost:81`, host 81 rather than 80 because a local router commonly holds `127.0.0.1:80`, which the compose file said and nothing else did. Swept through `CLI-TOOLING.md`, `DEVELOPMENT.md` (right host, wrong port, five times), `01-first-time-setup`'s `STEPS`/`CHECKLIST`/`CONTEXT`/`CLAUDE`, `08-debugging/STEPS.md` and the four `code/src/tests` surfaces.
- **Two of the seventeen were doing more than misleading.** `tests/api/environments/local.{bru,json}` set `api_url` to an unreachable host, so the one environment documented as _the Bruno desktop app against a running dev stack_ could not reach one — its siblings were both already right, `host` on the test nginx at `:83` and `docker` in-network on `:8000`, which is what makes this drift rather than a convention. And `settings/dev.py` listed `localhost:8000` and `127.0.0.1:8000` as `CSRF_TRUSTED_ORIGINS`: not a break, since a same-origin POST never consults the list, but two entries no request could ever match, which is worse than absent because it reads as coverage. Six occurrences are correct and deliberately untouched — the two Dockerfile `HEALTHCHECK`s, the two compose healthchecks and the CI `docker compose exec` all run inside the container, where 8000 is exactly right.
- **The same sweep found the stale assumption wearing other clothes.** `01-first-time-setup` promised "the Dockerised backend (8000) and frontend (3000)" and a mail UI on `:1080`; there is no frontend process, no port 3000 and no mail service — the dev stack is db, cache, django, nginx, and dev mail goes to the console backend. Corrected alongside, because a reader who has just been given the right URL should not meet the wrong topology two lines later. Left standing deliberately: `DEVELOPMENT.md` tells the reader to leave `TRUSTED_PROXIES` unset in local dev on the premise that there is no nginx, which `nginx/dev.conf` disproves by setting `X-Forwarded-For` and `X-Real-IP` — but whether to trust a forwarded header is a security decision, not a typo, and it is not being taken in a documentation sweep.
- **`A03` named two different categories depending on which guide you opened.** Two OWASP editions were live in one repository: `code/docs/security/OWASP-AND-CHECKLIST.md` and the root `REFERENCES.md` carried 2025, while the PM layer, both assessment templates, three workflow reading lists and every Opengrep rule's `owasp:` field still carried 2021. The editions renumber differently, so this is not cosmetic — `A03` is Injection on the 2021 list and Software Supply Chain Failures on the 2025 one, and a finding filed as "A03" could not be resolved without knowing which document the filer had open. The assessment templates are the acute case: they are what a generated project fills in, and they shipped the stale numbering as a blank form. Harmonised to 2025 across fifteen files, the edition the owning guide already used, and both templates now carry the year inside the ID column (`A05:2025`) so a filled-in assessment is self-describing a year from now.
- **The tables were re-derived rather than moved, because the re-slotting is not a rename.** SSRF is no longer its own category — 2025 consolidates it into A01, so what would have been A10:2021 is A01:2025; A06:2021 Vulnerable and Outdated Components becomes A03:2025 Software Supply Chain Failures; and A10:2025 Mishandling of Exceptional Conditions has no 2021 counterpart at all, so its _Common in this project_ cell is new text rather than a carried one. Seventeen `owasp:` values across the five rule files moved with them — injection `A03:2021` to `A05:2025`, secrets `A07:2021` to `A07:2025`, key material `A02:2021` to `A04:2025` — metadata only, with no rule id, pattern, sanitiser or fixture changed, so `static-analysis.sh --self-test` reads the same expectations out of `rules/*.yml` as before. It could not be run in the same pass, opengrep being absent on the host; `audit-static-analysis.yml` remains the half that enforces it.
- **A worked example handed the caller the lookup as well as the value.** `code/docs/api-design/CLIENT-PATTERNS.md`'s partial endpoint read `PortfolioItem.objects.filter(**filters_from(request))`, which expands caller-supplied keys into ORM lookups: `?category__owner__email__contains=@` traverses a relation the view never meant to expose, and `__gt` on a hidden column reads it a character at a time. Replaced with a `_FILTERS` map from an accepted query-string name to a lookup we wrote, everything else dropped, and the rule stated for `order_by()`, `values()` and `annotate()` too — they take field names, and a field name from a caller is a read of whatever it resolves to.
- **`.copier/README.md` had stopped describing the repository a generated project receives.** Four nodes each shipped a gate and none registered it, so the shipped README was missing two audit scripts (`conflict-markers.sh`, `dict-discipline.sh`), three CI workflows (`audit-conflict-markers.yml`, `audit-dict-discipline.yml`, `audit-static-analysis.yml`) and one code guide (`code/docs/DOCUMENTATION-LENGTH.md`). `shipped-readme.sh` had been exiting 1 and naming all six; nothing ran it. Every row is written from the script's or workflow's own header rather than inferred, because a plausible-but-wrong description passes this gate and fails the only reader it exists for, and the Project Tree gains the `planning/` sub-folder block it had never carried alongside the `gdpr/` and `git/` ones.

## [4.1.0] - 15/08/2026

### Added

- **Six guides under `code/docs/data-structures/` state the standard the template had been enforcing by anti-pattern alone.** `ANTI-PATTERNS.md` already carried eleven patterns, four of them this one seen from the other end, and `NEGATIVE-SPACE.md` routed "no god dictionaries" and "no stringly-typed data" to it — but the rule itself was nowhere: when a dictionary is wrong, when it is right, what a reviewer checks, and how each surface spells it. The 300-line cap forces the split and the entry point stays a thin index: `TYPES-OVER-DICTIONARIES` (the principle, parse-at-the-boundary, the enum test, the migration backlog, the PR checklist), `TYPES-EXCEPTIONS` (the seven legitimate uses, the confinement policy, the `DICT-OK:` escape hatch), `TYPES-PYTHON`, `TYPES-TYPESCRIPT` (mobile-only), `TYPES-RUST` (rust-only) and `TYPES-BROWSER`. Three of the five surfaces describe code that **does not exist yet** — Alpine ships zero `x-data`, HTMX only `observability.js`, serde is not a workspace dependency — so each carries a standing banner saying so, the alternative being prose that reads as description and is actually invention. The two surface guides route to gated skills, so `copier.yml` excludes each with its tree exactly as `MOBILE-CODING-PRINCIPLES.md` and `RUST.md` already are.
- **`code/src/scripts/audits/dict-discipline.sh` — seven fail clauses across the three code surfaces, plus clause M, the one clause nothing can suppress because it _is_ the suppression check** (a `DICT-OK:` with no reason). It ships with `--self-test` and fixtures, and that is not ceremony here: this repository holds so little application code that an ordinary run is green having measured nothing — the exact false green `docs-length.sh` was written to close. The self-test separates **11 findings from 0**. The fixtures carry a scoped `ruff.toml`, following the static-analysis precedent, because clause P3's target is `typing.Dict` and ruff's `UP035` would delete the thing being detected.
- **`code/docs/coding-principles/PRACTICAL-RULES.md` — name the axis of change before abstracting, or do not abstract.** A pattern is applied to make future change cheap along the axis where change is actually expected, never for tidiness, and it earns its place when it converts an invasive edit into an additive one: adding the next variant means writing new code rather than editing existing code in three places. "It's cleaner" is not a justification, it is the absence of one, and it is what tells you when to stop. The trigger rule is two statements before any abstracting refactor — the axis, with evidence it varies, and the pattern by name, or that none applies and plain extraction is enough, which is the honest answer more often than not. The when-**not**-to half is load-bearing: Rule of Three unchanged, incidental duplication stays duplicated, and things are unified by **reason to change** rather than by shape, since two services that both build a six-field structure today diverge the moment one gains a seventh. The smell-to-pattern map is 14 rows with the three genuinely ambiguous in this stack disambiguated — Strategy is chosen by the caller and stays put where State replaces itself as the object transitions; a Proxy is a per-object concern where Django middleware is a per-request one; and Django's `Manager` and `QuerySet` **are** the repository, so a separate repository class over the ORM is a second abstraction across the same seam. Policy is not a fifteenth row: it is Strategy whose axis is a business rule rather than an algorithm. Every chosen pattern carries a decision record naming the pattern, the axis, **and what would have to become true to remove it again** — that third clause is the only thing that lets a future reader delete an abstraction whose axis has gone away. Attribution lands in the same change, as the rule requires: the GoF catalogue for names and intents (vocabulary only, no text reproduced, every row re-authored against this stack) and Sandi Metz's _The Wrong Abstraction_ behind the second half.
- **`code/docs/DOCUMENTATION-LENGTH.md` and `.claude/CLAUDE.md` Section 3.2 — the lookup order, stated for the first time.** Internal `**/docs/` first, `context7` second, web search last, stopping at the first tier that answers it, because an internal guide is a **decision** and an external doc is a menu of possibilities. It answers the case nothing covered: a technically correct answer read off an external document that this project has already rejected, for a reason no external document could have known. The new guide takes the 300-line limit, the bound and exempt sets, the ratchet and the dated allowance out of the root config; `docs-length.sh` had declared `.claude/CLAUDE.md` Section 8 its owner, so the header is repointed and the guide registered in the three indexes that list `code/docs/`.
- **`docs-length.sh` gains the warn-tier ratchet: at or above 270 code lines a file may not get _longer_ without a dated reason.** Warn was never a category to file — it was an instrument nobody had built, and the node was made worse by three others in a single day. `stack-django` 281 to 290, `audits/CONTEXT.md` 270 to 279 and `.claude/CLAUDE.md` entering the band outright were three different nodes, none of them this one, each spending someone else's headroom with nothing obliging them to notice. So the obligation is the crosser's, expressed as a ratchet rather than an owner: below 270 nothing changes, and a file **born** in the band is held to the same bar or anything could enter at 299 and never be seen again. One flag, `--since <ref>`, two baselines — lefthook passes `HEAD` for immediate local feedback, CI the merge-base — and the second is what makes it real, since a `HEAD` baseline alone would reproduce the very creep this closes, one commit at a time. The CI job needs `fetch-depth: 0`, because a shallow clone has no merge-base and the audit then dies loudly rather than skipping quietly. The allowance is `docs-length-allow: <reason> (expires DD/MM/YYYY)`, both halves mandatory by format: the parser refuses a marker without a date, so the entries that actually rot cannot be written here at all. `--self-test` proves seven cases in both directions and cannot use a fixture directory like its siblings, because what it reads is git **history** — it builds a throwaway repository and drives a copy of the script through it, and the three negatives carry as much weight as the positives, a ratchet that fired on a file that had shrunk being reverted within a day.
- **`docs-pairing.sh` check 10 enumerates directories, and five source directories gain their pair.** The node was charted as three missing mobile pairs; enumeration found **17** tracked source directories carrying neither `CONTEXT.md` nor `CLAUDE.md`, five of them the Rust and desktop crates — the same defect, never mentioned, because the node was written from whichever surface someone happened to be looking at. Worse, the audit was blind by construction: its two existing loops iterate over the `CONTEXT.md` and `CLAUDE.md` files that **exist**, so a directory holding neither was unreachable rather than overlooked — a gate that can only ever find a half-pair. The rule now turns on **who works there** rather than on what created it, with five exempt classes: three share a reason, that their contents are remade rather than authored (generated output, synthetic audit fixtures where a pair becomes live input to the audit reading it, and the root), and the other two are already oriented by something that is not a `CONTEXT.md` — a skill folder by its own `SKILL.md`, a single-purpose leaf by its parent's pair. Scope was chosen on measurement: repo-wide the check ships **red on 95 directories, 62 of them skill folders**; scoped to `code/src/**`, where "a directory someone works in" is decidable, it is green on 9 real cases once 5 are paired. The leaf exemption is arithmetic rather than a path list — one tracked file at any depth, no tracked sub-directory — so it lapses at two files, when there is a relationship between them worth describing.
- **`code/src/scripts/audits/conflict-markers.sh`, its shared regex in `_lib/`, and a CI job — a guard that sees the form Prettier leaves behind.** The charted question named the wrong axis: it asked which existing audit owns the check, and none is a candidate, because every other audit is scoped by **surface** while this defect is scoped by **file** — a marker can land in any text file in the tree. Placement was cheaper than charted, since `check-audits.sh` globs the audits directory and a new script joins the pre-PR gate with no wiring at all. The three mangled forms were recovered from `3bd49e8` rather than assumed, and one changed the design: `=======` does not survive Prettier, which reads it as a setext H1 underline, rewrites the line above as `# ...` and consumes the marker; the open marker survives **indented** and the close becomes a nested blockquote. So the detector matches the open and the close only — not a compromise, because every conflict writes all three, and `^={7}` was simultaneously the one pattern with a measured false positive here, an `====` rule inside a Django comment. The exemption is the house `conflict-markers: ignore` directive, accepted on the line, on the nearest line with content above, or on a code fence's opener, because an HTML comment inside a fence renders to the reader. Unfiltered in CI, deliberately: a path list for this defect is a list of the places it would still be missed.
- **`skill-conformance.sh` clause 14 — a guide's `skills:` claim is answered in the skill body.** The field is read by whoever opens the **guide**, but skills fire on description match, so the dominant traffic is skill to guide and the field cannot prevent the decay it was blamed for. The obligation is therefore relocated rather than strengthened: the field keeps its name and its one-way meaning, `routing-skills.sh` still owns "does the name resolve", and the reciprocal duty moves to the skill body where the practice already existed unenforced — all six skills carrying the breaches already cited 4 to 15 guides each. The scope figure was corrected in the process: **26 of 77** silently assumed `code/docs/*.md` alone, and the same rule over all three top-level trees is **52 of 116**. Widening it surfaced the finding that reshaped the clause — 11 of the extra 26 are `global-workflow`, named second in nearly every how-to guide's list for its **conventions** rather than as that guide's subject, and it already routes to those trees by glob — so a directory glob discharges the obligation, which is what made the wider scope affordable and killed the incoherent "code guides reciprocate, PM guides do not" alternative. Clause 14 was watched failing at **24** before any repair — not 26, because an existing `project-management/docs/*` glob already discharged two, proving the allowance before anything relied on it — and 41 citations across 13 skills then took it to 0.

### Changed

- **The comment rule is recut by _kind_ rather than by scope level, and it now has one home.** `apps/core/schemas.py`'s 24-line module docstring was charted as the defect; it is not an outlier — **13 of 22** module docstrings in the template's own Python are multi-line, so the rule lost to the practice 13 to 9 and the rule was wrong. A docstring says why the **unit** exists and runs as long as that needs; a comment is one line about why **that line** is there. One is about a thing, the other about a position in it. The separate outside-reference ban went the other way, to absolute with no exceptions: a pointer is not a reason and it rots at a different rate from the code around it, so anything under `code/src/` must be understandable without opening anything else. Ten source files were made self-contained, three of them outside the node's stated scope because the rule covers `.ts` and `.rs` too; the single carve-out is a note on placeholder copy the project replaces at first-time setup, where the document governing the replacement is the whole point of the note. The rule had two homes each claiming to be canonical — one called the other canonical and "mirrored in" the second — and a mirror is a second home, so ownership settles on the code guide with four other statements demoted to routing. `doctrine-drift.sh` cannot hold this one: its claims table matches fenced-code lines only and this rule is prose with no anchor a regex could bind to, so the table's boundary is stated rather than a dead row shipped.
- **`.claude/CLAUDE.md` falls to 208 code lines, clear of both the 300 cap and the 270 ratchet, so the dated allowance written for it hours earlier is deleted rather than renewed.** Nothing was cut without landing somewhere first. Grilling **stays** Section 10 and the `GAPS.md` register folds into Section 9, which is the inverse of the obvious move and the cheap one: `Section 10` is cited 63 times across the repository and almost every one means grilling, so one citation moved instead of sixty. Section 10 also gains the ceiling it never had — above one sitting, `/wayfinder` charts the frontier and dispatches batches back to grilling. Section 1 keeps every instruction and loses the one working against itself: "sacrifice grammar for concision, fragments are fine" licensed telegraphic output costing the reader more than it saved, and is now "cut filler, not grammar", with "lists over paragraphs" gaining the escape it needed, a forced list reading as badly as the wall it replaced.
- **The two document skills keep their asymmetric shapes, because the shapes are the honest answer.** `msp-scp-documents` covers 12 document types and would run about **644** raw lines unsplit, well past the 300 gate; `legal-documents` covers 6 at **226** and fits with headroom. The counter-measurement kills the temptation to make them match: per single-document task the split form loads **more** — 101 lines of `SKILL.md`, plus the always-needed 137-line standards document, plus one thematic doc at 57 to 135 — against a flat 226. What the measuring did find is that both still carried a `## Clarifying questions` section, the last two in the repository, against Section 10's project-wide supersession by grilling. Compressed rather than deleted, because the section owned a decision grilling does not: these two use the stateless `/grill-me` and never `/grill-with-docs`, the output going to professional review rather than into the repository.
- **The baseline stops violating the standard it now ships.** `SCAN_PROJECTS` was `dict[str, dict[str, object]]` in a module that already modelled `Suppression` as a `TypedDict` — one file, two answers — and `VIEWPORTS` was the same defect one file over. Both now build from the value objects in the new `tests/e2e/browser_types.py`, and the `page.__dict__["_scan_project"]` stash is gone: the fixture yields a frozen `ScannedPage`, and Playwright's mapping survives at exactly one marked boundary, `Viewport.to_playwright()`. These are the dictionaries every generated project inherits, so documenting them without converting them would have shipped the anti-pattern alongside its own prohibition. Two taught examples went with them — `rendering/TEMPLATES-AND-INTERACTIVITY.md`'s inline `x-data` literal and `rendering/PITFALLS-AND-EXAMPLES.md`'s bare `"itemSaved"` HX-Trigger — with the single boolean toggle left inline as a stated carve-out at a threshold of one property or any method. Three things were deliberately **not** done and each says why: `ANTI-PATTERNS.md` keeps its patterns, branded ID types stay declined on a trigger settled elsewhere, and `ServiceError.code` is backlogged rather than converted, its spelling having been settled four days ago and re-opening a just-settled cross-cutting surface in the same week being how a decision gets re-litigated.
- **`code/src/scripts/audits/CONTEXT.md` becomes an index**, with no exemption for a register that grows by design. It gains a row per script by its own `CLAUDE.md` rule, and a register nobody finishes reading is exactly what the cap exists to prevent.

### Fixed

- **The code-review graph was systematically missing the files the session had just written.** Measured on a live probe: an untracked `.py` file was absent from the graph after an incremental pass and present after `git add` plus the same pass — so staging is the fix, and the ordering now sits in `.claude/CLAUDE.md` Section 6 where the hard gate lives rather than only in the guide, because a citation is not an ordering and a reader who opens the guide to learn the order has already used the wrong one. The `PostToolUse` hook was blind by construction, running incrementally on every `Edit`/`Write`/`Bash`, so the graph looked continuously fresh while missing exactly those files; it is now wrapped in `.claude/hooks/graph-update.sh`, which reports on change only, via a JSON `systemMessage` because `PostToolUse` stdout is discarded, and **never stages** — a hook that ran `git add` would commit work nobody chose. Two findings arrived uncharted: `full_rebuild` is not the rival it was charted as, having outlived the 120s MCP timeout twice and run past 11 minutes with nothing else touching the store, while the CLI route dies on `database is locked` because the MCP server holds it; and an aborted full build does not roll back, leaving the graph partially rebuilt — measured **177 files down to 171** — while `status` still reports success.
- **Four hook timeouts were written in milliseconds against a seconds field** — `900000`, `5000`, `30000`, `5000`, which is 10.4 days, 83 minutes, 8.3 hours and 83 minutes. Every `bash -c` hook was wrong and every bare command right, which is exactly how it survived.
- **Two conflict-marker detectors existed for one defect class, they disagreed, and the weaker one was the one running where it mattered.** `template-update.sh` already grepped for markers with an anchored pattern that would have missed the real defect on both counts. They now share the single regex in `_lib/`. The new audit also caught its own author twice — first on its self-test fixtures, then on a comment describing the old pattern — so the markers in both are built from repeated characters rather than written out, and it ships green rather than red.
- **`.claude/CLAUDE.md` Section 7 asserted the dev stack answers on `http://localhost:8000`.** It does not and cannot: `docker-compose.dev.yml` publishes `127.0.0.1:81:80` and the django service has no `ports` block at all, so `8000` is the container's internal port, reachable only from the healthcheck inside it. The correct address is the one `server.sh` prints. Fixed here only — seventeen further documentation hits and a functionally broken Bruno `local.json` are left standing rather than swept into a documentation commit.
- **Two statements contradicted the lookup order the moment it was written.** The `context7` row claimed "any library docs" with no precedence at all, and `research/SKILL.md` called `context7` "the first and only stop", which is now "the stop, once the internal docs have come up short".

## [4.0.0] - 15/08/2026

### Added

- **`.github/scripts/check-template-parsers.sh` and the `[4/4] Parser Probes` job — the fault class is now caught by definition rather than by a list.** The charted plan was to teach `check-template-tokens.sh` "the handful of positions that qualify", and the evidence killed it before it was written: pnpm parses `<%PROJECT_SLUG%>` in `package.json`'s `name` without complaint, in both the root and mobile manifests, while uv rejects the identical token in the identical position. Same position, opposite verdict — so it is not statically decidable, and a hand-maintained register of safe positions is only the same rule one level up, still carried by whoever remembers to read it. The probe therefore asks each toolchain's own parser and requires success: `uv lock --dry-run`, `cargo metadata`, `pnpm ls`, `docker compose config`. It catches the case a position list never could — `70fc963`'s `--health-cmd` broke because `<` and `>` are shell **redirects**, not because a name was invalid, and that is now its own row in the rule, separated from the identifier rows because the delimiters there are legal and **active** rather than illegal.
- **The probe ships with `--self-test`, and its compose leg proved something nobody asked it to.** A gate nobody has watched fail is not known to work, so the self-test builds a synthetic tokenised manifest and asserts uv rejects it. The compose leg passes each file its matching `.env.<env>.example`, without which compose fails on unset variables rather than on anything to do with tokens — and the side-effect is that every example env file is now proven complete enough to render its own compose file.
- **`audit-template.yml` gains the assertion only it can make.** A generated project's manifest must carry its **own** name, and its `uv.lock` must not pin the template's. That pair is what proves the branding task ran **before** the lock rather than after it, which no check inside this repository can observe.
- **`.copier/migrations/v4.0.0-manifest-name.sh`, the migration this MAJOR owes.** `CONTRIBUTING.md` requires a `_migrations:` entry per MAJOR because an existing project has to be carried across the break rather than left on the old contract, and here the break is silent: `copier update` rewrites a live project's `[project] name` to `syntek-base`, cleanly, raising no conflict and reporting success. This one **acts** rather than advising, because the restore is mechanical with exactly one correct value — `PROJECT_SLUG`, read back out of `.copier-answers.yml`, which Copier has just rewritten with the project's own answers. It is anchored to the exact literal `name = "syntek-base"` rather than `^name =`, since `[project]` is not the only table in that file that could carry a `name` key and a loose pattern would rewrite the first one it met. Idempotent, and it exits 0 whatever happens: a migration that fails an update leaves the project half-upgraded, which is worse than a manifest it prints instructions for.
- **`.opengrep-version` and `audit-static-analysis.yml` — the engine arrives pinned and signature-verified, or not at all.** The version is pinned at `1.27.1` in a root dotfile; CI installs it and verifies its Sigstore signature with cosign against the exact upstream workflow identity. This is the first downloaded binary in the repository, so the verification is not optional. The contract is `render-slop.sh`'s, which had already solved this shape: optional on a laptop, mandatory in CI.
- **`static-analysis.sh --self-test`, which runs before the scan and exits 2 where the ordinary scan exits 0** — on exactly the reasoning the gate exists for, that an unrunnable proof reports green and is believed. Its expectation is read out of `rules/*.yml` rather than listed in the script, so a rule added without a fixture fails it. The fixture pair under `fixtures/static-analysis/` carries a `ruff.toml`, which is what scopes ruff's silence over deliberately-broken sample code.
- **`code/src/rust/.cargo-deny-version` — the supply-chain gate's own tool is pinned at `0.20.2`**, read by both the CI job and `code/src/scripts/rust/audit.sh` so there is one source of truth rather than two that drift. It joins the repository's other three toolchain pins — `.nvmrc`, `.python-version` and `rust-toolchain.toml` — and `code/docs/rust/SUPPLY-CHAIN.md` gains the section saying why bumping it is a reviewed change rather than a housekeeping one.
- **`project-management/docs/GIT-GUIDE.md` gains _What earns a place in the required set_ and a _Toolchain pins_ table.** Being unfiltered makes a job **eligible**, which the guide already explained; what had never been written down is what earns membership once eligible. Two things do, and the second is the one that is easy to miss: a job whose **step-level guard** is worth protecting from regression. `jest-expo + coverage` has been required on exactly that basis for months, unstated — a skipped job and a passing job look different to branch protection, and "never ran" is not the claim "nothing to run". Hence the reading rule: **a green guarded check is "not applicable", never "passing"**, and a guarded job is required at step level, never job level, or it skips rather than reports and the check never arrives. Four unfiltered jobs sit outside the set — `pytest + coverage`, `Audit JS + Python dependencies`, `Citations resolve` and `Routing skills resolve` — each a deliberate switch to flip, and flipping one is a repository setting no file here can make. The matching audit clause was declined on precedent: write the rule, watch it hold, ship the gate afterwards.

### Changed

- **`pyproject.toml`'s `[project] name` is the house constant `syntek-base` and no longer a token.** It is restored to the project's slug by a `copier.yml` `_task` ordered ahead of `uv lock`, so a generated project locks under its own name. Cheap, because `[tool.uv] package = false` — this is a virtual project, so the field is metadata uv reads and nothing builds or publishes. The `_task` is anchored to the exact literal rather than `^name =`, because `[project]` is not the only table in that file that could ever carry a `name` key and a loose pattern would rewrite the first one it met. The cost is written in the file where it bites: **`copier update` never runs `_tasks`**, so this literal now travels — which is precisely what the `v4.0.0` migration above exists to undo, and why this MAJOR ships one rather than printing an instruction.
- **Every lockfile-presence guard is gone; the lock now chooses the sync _mode_ — `--frozen` or not — rather than whether the gate runs at all.** Unguarded and verified green **before** being unguarded, not after: basedpyright `0 errors, 0 warnings, 0 notes`; pip-audit `No known vulnerabilities found`; `ruff check .` all checks passed; `ruff format --check .` **811 files already formatted**; `ruff check --select S .` all checks passed.
- **The rule now written beside `audit.ignore` in `pnpm-workspace.yaml`: an ignore whose advisory has a published fix is a suppression, not a decision.** Ignore on **availability**, never on inertia. The surviving `image-size` pair is the contrast that makes the rule legible — no patched release exists, `>=2.0.3` is unpublished, and an override floor of `>=2.0.3` fails the install outright. `GHSA-jxxr-4gwj-5jf2` stays on a third and different ground: it matches no package in this tree, an ignore that matches nothing costs nothing, and the advisory can return through a different consumer.

### Fixed

- **`uv lock` had never once succeeded here, and one unparseable line was the entire cause.** uv validates `[project] name` as a package name and `<`, `%` and `>` are not legal in one, so the lock failed while **parsing**: `Not a valid package or extra name`. The node was costed at basedpyright plus pip-audit; measured rather than assumed, it was the sole cause of **every** Python gate the template has. No lockfile could exist, so basedpyright, pip-audit, ruff-via-`uv run` and the whole test tree were guarded off — each standing down politely and reporting success on every run.
- **Three further legs had never executed their Python halves, and announced it every time.** `claude.yml`'s `[3/8] Format`, `[4/8] Lint` and `[8/8] Security` printed `Running Prettier only`, `Running ESLint only` and `Auditing the JS dependency tree only` on every template run, which nobody read as a defect because it was phrased as a scope. `audits/security.sh` needed no change whatsoever: it was never guarded, it simply could not work.
- **The Opengrep rules had never once run.** `static-analysis.sh` exits 0 when the engine is absent, and the engine is absent everywhere — not on PyPI, no official Action, no image, and the npm package of that name an unrelated placeholder stuck at `1.0.0`. So for the whole life of the in-house rule set, the gate reported success without ever loading a rule.
- **The Rust supply-chain gate was a different tool on every run.** `cargo install --locked cargo-deny` pins cargo-deny's **own dependency tree**, not cargo-deny, and `--locked` is the part that misleads. A cargo-deny release can add a check, change a default or regrade an advisory, so a gate whose verdict moves without the code moving cannot be trusted in either direction: a new failure reads as a regression, a vanished one as a fix.

### Removed

- **The `CORE_APP` Copier question is retired — this is the breaking change.** `CONTRIBUTING.md` Section _syntek-base's public API_ declares that API to be the template contract — the `copier.yml` questions and tokens, the shape of the generated tree, and the `.claude/` routing contract a generated project inherits — and removing a question is MAJOR by its own table. Unlike its five siblings, which name apps a story has yet to create, `apps/core/` **already ships**: a literal directory, `name = "apps.core"` in its `apps.py`, `apps.core` in `INSTALLED_APPS`, literal imports throughout, a dozen guides naming it. The question could therefore never be honoured — answering `CORE_APP=shared` produced a project whose documentation disagreed with its own code — and a token whose referent is hardcoded everywhere else is not a choice, it is a claim that a choice exists. Thirty-eight tokens to thirty-seven; the count in `how-to/src/TEMPLATE-TOKENS.md` was stale the moment the question went, and `shipped-readme.sh` does not check counts. A project generated before this release is unaffected — its `apps/core/` was always literal — but an answers file carrying `CORE_APP` will see it ignored on `copier update`.
- **Two `@grpc/grpc-js` advisory ignores, deleted rather than documented.** `GHSA-5375-pq7m-f5r2` and `GHSA-99f4-grh7-6pcq`, reached through `. > @usebruno/cli > @usebruno/requests`, had sat in the list unannotated since `fc905eb`, and `git log -S` confirms a rationale never existed for either. The remedy was smaller than either charted option: a patch existed the whole time they sat there — vulnerable `>=1.14.0 <1.14.4`, fixed in `1.14.4` — and `@usebruno/requests` declares `^1.14.3`, so the fix already satisfied the range and the lockfile was merely stale. `pnpm update @grpc/grpc-js` cleared both with no override and no forced resolution, at four lockfile sites. Re-proven at the new count by the **report line** rather than the exit code: with `audit.ignore`, `2 high (2 ignored)` clean; with neither key, `2 high` VULNERABLE.

## [3.2.2] - 14/08/2026

### Added

- **`code/docs/rls/MIDDLEWARE-AND-NINJA.md` gains a _Row locking_ section: under row-level security a `select_for_update()` only ever covers rows the `SELECT` policy already makes visible.** PostgreSQL applies the policy's `USING` clause when it chooses the rows and `FOR UPDATE` locks what is left, so a lock taken before the scope variable is set is taken on **zero rows** and the query returns `None` — no error and no warning. The one loud failure, `TransactionManagementError`, fires only when there is no transaction at all, which is the case where the ordering was never the fault. `SET LOCAL` and `FOR UPDATE` each live for exactly one transaction, so both end up inside the same `atomic()` block doing two jobs, and only one of them is visible in the code. The section carries the order, both spellings, and the guard.
- **The guard is the point, not the ordering.** "No row" has two causes that look identical — the row is genuinely absent, or the scope was never set — and only one of them is a user's problem. Treating the result as a benign not-found is how a missing scope variable ships silently, so a row that must exist raises `InvariantViolation` rather than returning; which invariant class that is and how it must surface stays `code/docs/NEGATIVE-SPACE.md`'s to say.
- **`code/docs/data-structures/ANTI-PATTERNS.md` gains _The ID-or-Instance Parameter_** — the signature that accepts `Order | UUID` and opens with an `isinstance` branch. The union costs more than the convenience returns: the two paths have **different query counts** and **different failure modes**, so no caller can reason about either without reading the body, and every test doubles. Passing an identifier **instead of** an instance is the separate and often-right thing — across a process boundary the instance is stale by construction, which is why a task takes the primary key and re-reads it (`code/docs/TASK-AUTHORING.md`). That is one choice made deliberately, not a signature that accepts both.
- **`how-to/src/INVARIANTS.md` names its second limit, and it is the one that looks like proof.** A fully green register says nothing about whether any row is _exercised_: `audits/negative-space.sh` correlates names and coverage counts executed lines, and neither would fail if a constraint were dropped from the model or a guard's `raise` deleted, provided the row and the name still line up. The proof is mutation testing — `bash code/src/scripts/tests/mutmut.sh run` — which removes the enforcement and asks whether a test notices. It stays local-only and outside CI deliberately, because it is slow: an act someone chooses for a row worth being right about, rather than a gate that arrives.

### Changed

- **`code/docs/BACKEND-CODING-PRINCIPLES.md`'s `transaction.atomic()` rule now points at the locking order**, because that is where someone is standing when they write the block. The rule already said to wrap a multi-step write; it did not say that inside the wrapper the order of two lines decides whether the lock exists at all.

### Fixed

- **`.copier/README.md` had not learned about `doctrine-drift.sh`.** 3.2.1's successor commit added the audit and its workflow but not the two rows describing them to the README a generated project actually receives — the audit-script register and the Project Tree's CI list. `shipped-readme.sh` is the gate that catches exactly this, and it did; the fix is the two rows, in the shipped README rather than the root one, which `copier.yml` excludes.
- **The pre-PR audit gate ran `dependency-drift.sh` bare, where it can only ever fail.** `check-audits.sh` is deliberately directory-scoped rather than list-scoped — a list drifts the moment an audit is added, and silently. But every other script in `code/src/scripts/audits/` answers "is this tree correct" from the tree alone, while `dependency-drift.sh` answers "what would an update change", which needs an incoming tree: `--incoming DIR` is required and it dies without one. There is no bare invocation that can pass, so running it there tested nothing and failed always. It is now excluded by name, alongside `cloc.sh` and `security.sh` but **for a different reason** — those two are owned by a dedicated gate, this one is a `copier update` helper shelved among the scans — and both reasons are written down, because a shared exclusion list with one unstated rationale is how the next person removes the wrong entry.

## [3.2.1] - 14/08/2026

### Fixed

- **The `template-docs-readonly` lefthook job never ran, so the human half of 3.2.0's read-only guard was decorative in every generated project.** Its `glob:` used brace expansion — `how-to/src/{TEMPLATE-GUIDE/**,TEMPLATE-TOKENS.md}` — and lefthook does not expand braces, so the pattern matched nothing and the job was skipped on every commit. The Claude half, the `PreToolUse` hook, worked throughout. That asymmetry is exactly what hid it: one write path was guarded and the other silently was not, and a guard that fails open is worse than no guard at all, because it is believed.
- **The fix takes the glob dialect out of the trust chain rather than correcting the pattern.** A working brace glob would still have left the job's scope expressed in a dialect nobody verifies until it fails silently again. The job is now unglobbed and selects its own paths inside the `run` block — `git diff --cached --name-only` filtered by `^how-to/src/(TEMPLATE-GUIDE/|TEMPLATE-TOKENS\.md$)`, with an early `exit 0` when nothing matches, so an unrelated commit costs one `grep`. Both stand-down conditions are untouched: `[ -f copier.yml ]`, which keeps the guides editable in syntek-base where they are the product, and a staged `.copier-answers.yml`, which is what keeps `copier update` usable.
- **`audit-template.yml`'s two path lists still asserted the guides were template-only.** `how-to/src/TEMPLATE-GUIDE` and `how-to/src/TEMPLATE-TOKENS.md` move from the leak list, which demanded their **absence** from a generated project, to the completeness list, which now demands `TEMPLATE-TOKENS.md`, `GUIDE-TO-SKILLS.md` and `14-UPDATING.md` are **present**. Only `TEMPLATE-GAPS.md` stays named as template-only, which is what 3.2.0 actually excluded. This file is itself template-only and reaches no generated project.
- **Both were caught by CI rather than locally, and for one reason.** The failing step was reproduced on its own instead of the whole job, so the next assertion in the same job was never exercised and failed on the next run instead. Verification this time replayed all eight steps of Template Generation locally across both render paths, and exercised the lefthook guard inside a generated project: it blocks a hand edit and lets through a commit that restages `.copier-answers.yml`.
- **`v3.2.0` stays tagged at `e93b00c`, red CI and all.** `VERSIONING-GUIDE.md`'s recovery table is explicit — a broken build under a correct number is recovered by releasing a patch, and a published tag is never moved or deleted. The version that went out is a fact about the world; `3.2.1` is the first green commit on the 3.2 line.

## [3.2.0] - 14/08/2026

### Added

- **`how-to/src/TEMPLATE-GUIDE/` and `how-to/src/TEMPLATE-TOKENS.md` now ship into every generated project.** They leave `copier.yml`'s `_exclude` because most of what they answer is asked long **after** generation, not before it: what am I looking at (`07-REPO-TOUR`), which skill does this (`GUIDE-TO-SKILLS`), which project-management folder (`09-PROJECT-MANAGEMENT`), how do I pull upstream fixes (`14-UPDATING`), why did that break (`15-TROUBLESHOOTING`). Excluding them meant the answers existed and were unreachable from the only place the question actually gets asked. The pre-generation half travels with them rather than being split off, because `14-UPDATING` is unreadable without `06-GENERATION`'s vocabulary.
- **`how-to/src/TEMPLATE-GUIDE/GUIDE-TO-SKILLS.md` — the human index the roster never was.** It answers **what do I type**; `.claude/skills/CONTEXT.md` answers **when does Claude load this**. The page says so and defers to it rather than forking a second roster. Sixty-four skills is too many to meet at once, so it opens by saying you do not have to: description match is the normal path and naming a skill is an override.
- **`.claude/hooks/template-docs-readonly.sh` and the `template-docs-readonly` lefthook job — read-only, in two halves.** A file a project receives and does not own is one whose edits change no behaviour and guarantee a conflict at the next `copier update`, because upstream owns those lines. The hook is the Claude half (`PreToolUse` on `Edit|Write|NotebookEdit`, exit 2); the pre-commit job is the human half. One without the other is no guard at all.
- **Neither of the two obvious alternatives can express this.** A `permissions.deny` entry would apply in syntek-base too, where these files **are** the maintained product and must stay writable — `settings.json` ships, and a deny rule cannot tell the two repositories apart. `chmod 444` would block `copier update` itself from refreshing them, which is the whole mechanism keeping them current. Read-only to a human, writable to the updater, is what a hook expresses and a file mode cannot.
- **Both halves stand down on the presence of `copier.yml`**, which lists itself in its own `_exclude` and therefore exists in syntek-base and in no generated project — exact, not a heuristic, and the same trick as lefthook's `[ -f uv.lock ]` leg. The pre-commit half also exempts a commit that restages `.copier-answers.yml`: an update legitimately rewrites these guides and always touches that file alongside them, and a hand edit never looks like that.
- **A `Writing conventions` block in `.claude/CLAUDE.md` Section 5**, whose first rule bans U+00A7. Write `Section 3.2`, or just `3.2` where the context already says it is a section; the doubled form for a range goes with it, so `Sections 4 to 7`. Two clauses sit alongside: prefer plain ASCII punctuation generally, with the em dash as the deliberate exception (house style throughout the prose here, banned by `copy-emdash.sh` only in public marketing copy); and a disambiguation, that the same codepoint appearing as mojibake or mid-word is an encoding fault rather than a style one, fixed as corruption.

### Changed

- **The shipped guides are rendered like any other template file now**, so every guide that quotes token or delimiter syntax wraps it in `raw` blocks. This is the cost of shipping them, and it is paid once per guide.
- **`how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` is excluded by name** — syntek-base's own open items, meaningless in a generated project. It is the same test the root `GAPS.md` passes by shipping as an empty stub.
- **The section sign leaves the vocabulary and the 289 files it was in.** It is not wrong — it is the scholarly and legal shorthand for "section", absorbed from the RFCs, specs, statutes and standards this repository cites all day, and every use of it here was correct. It is denser than this project wants, which is the actual complaint: these files are read under time pressure by people who are not lawyers, and a glyph that has to be decoded is a tax on every reading, paid so the writer can save six characters once.
- **The rule is written without the character it bans, deliberately.** That is what makes zero occurrences an invariant anything can check: `grep -rIP '\xc2\xa7' .` returning nothing is the pass condition, and it stays the pass condition only if no file — including the rule's own — is allowed to be an exception. A rule that has to spell its banned character cannot be enforced by counting.
- **The sweep itself is mechanical.** Most occurrences took `Section N`; the ones pointing at a named heading rather than a number took `→` instead, because "Section Required status checks" reads worse than the glyph did. Five of those land in shell scripts — two in audit failure messages, which now print `FRONTMATTER.md → Three claims` — and every remaining shell edit is inside a comment. One wireframe template needed rewrapping, the substitution being four characters longer than what it replaced.
- **`.claude/hooks/CONTEXT.md` and `CLAUDE.md` gain the new hook** — the tree, the file table, the hand-written list, a guardrail against dropping the `copier.yml` check, and a short section on why the pairing exists.

### Fixed

- **The guides' own facts, re-checked against `copier.yml`.** Shipping them made their staleness everyone's problem rather than ours, so the question counts, the derived defaults and validators, and a `--vcs-ref` example still pinned to `v0.12.0` were all corrected before they travelled.
- **The two template-integrity guards that shipping the guides broke.** Both assumed the documentation was excluded, and both are now scoped by path. `audit-template.yml`'s _No token may survive rendering_ demanded zero tokens in a generated project; three now survive on purpose, inside the `raw` blocks that make the delimiter table and the "a token survived" entry readable at all. A leaked token and a quoted one are byte-identical, so no content test separates them and the path is the only honest discriminator — every other file in the tree stays under the strict check, which is where a real rendering failure would show. `shipped-readme.sh` required every token in a shipping file to appear in the contract, which turned the troubleshooting heading's stand-in placeholder into an undocumented token; its scope now skips the two documentation paths outright, exclusion alone having stopped being the thing that separates "a token this project uses" from "prose quoting token syntax".
- **The same bug in the guides' own verification commands.** `04-QUICKSTART` and `06-GENERATION` both told you to grep a fresh project for surviving tokens and expect `0`. After the move they would have reported `3` on a perfectly healthy generation and sent you to file a template bug — they now carry the same two exclusions, and `04-QUICKSTART` says why.

### Known limitations

- **The section-sign invariant is not yet gated.** It is stated and cheaply checkable, but nothing runs it — worth wiring into an audit before it drifts back in one file at a time.

## [3.1.1] - 14/08/2026

### Changed

- **`wait-what` now routes a knowledge gap somewhere, instead of leaving it where it found it.** The skill already sorts the failed reply into one of four causes, and two of them are not delivery problems: _missing context_ and _unshared vocabulary_ are gaps in what the reader knows, which a re-pitch closes for one reply and leaves open for the next. On those two — and only those two, because _too dense_ and _buried answer_ are fixed by the re-pitch itself — the skill now offers the durable fix: a handoff into `/teach`. An offer attached to all four would arrive on replies whose only fault was density, and an offer that arrives every time is one nobody reads.
- **The lesson is carried across rather than re-derived.** Naming the one concept at the edge of the current level is `teach` step 2's job, and `wait-what` has just done it by identifying what failed to land. The offer therefore names three things — the kebab-case `learning/<topic>/` slug, whether that folder already exists (so it reads _resume_, not _start_), and the opening lesson — and it is made **after** the re-pitch, never before it, where it would read as a deflection. Asked once per topic per session; declined means dropped.
- **The detour crosses a session boundary on a marked handoff.** Written in full as `.claude/skills/handoff/SKILL.md` defines it — that skill owns the shape and `wait-what` does not restate it — plus three markers: the `HANDOFF-TEACH-<TOPIC>-DD-MM-YYYY.md` descriptor, a `Teaching detour` line naming the topic and the concept that missed, and `teach` named first under **Next skills**. The work's own state is still recorded in full, so the same file resumes the work after the lesson rather than being spent on it.
- **`teach` and `handoff` each gain one reciprocal cross-reference**, so the route is findable from both ends rather than only from the skill that starts it.

### Fixed

- **`wait-what`'s `## Governing procedures` note no longer claims the skill produces no artefact.** It can now lead to one — written by `handoff`, not here. The rest of the claim stands: still a conversational mechanic, still gating nothing.

## [3.1.0] - 14/08/2026

### Added

- **`code/src/scripts/audits/dependency-drift.sh` — the second quiet-failure guard, and the one nothing had ever covered.** `template-orphans.sh` catches the update that silently loses the files you wrote; this catches the update that silently changes what you build against. A template release routinely moves a floor, a toolchain pin or an action ref, and `copier update` applies each one like any other file change — no conflict, no error, success reported — so the next `uv sync` resolves a graph the suites have never run against, and the failure surfaces later, somewhere else, looking like your own bug. It compares what the incoming tree **declares** against what the project currently **resolves** and splits the result: **BLOCKING** where the lockfile cannot satisfy a new floor or a pin moves by enough to break a build on its own, **informational** where the declaration moved but the resolved versions already satisfy it. Read-only, and surface-gated, so a web-only project hears nothing about Rust crates.
- **The split is the design, not a convenience.** Floors move in nearly every release; blocking on all of them would make `--force-deps` muscle memory inside a month, and an override nobody reads protects nothing. For the pins with no lockfile to compare against, "enough to break a build on its own" is stated per ecosystem rather than assumed uniform — a **minor** move for the Rust channel (Rust has one major, so its minor is the real one, and new clippy lints arrive denied) and for uv (0.x, where breakage lives in the minor); a **major** move for pnpm, Node and Python; and for a GitHub Action, a major or any move off a branch ref onto a release.
- **`code/src/scripts/dependencies/` — the one place a dependency moves, with its `CONTEXT.md`/`CLAUDE.md` pair and a row in the scripts registry.** `update.sh` puts a single command and one exit-code contract over three ecosystems that each mean something different by "update": `--check` (the default — report only), `--apply`, `--package NAME` for the narrowest upgrade that solves the problem, `--ecosystem python|javascript|rust`, plus `--output md|txt` and `--quiet`. It **ships**, so it runs on both sides of the template boundary, and the two sides genuinely differ: in syntek-base there is no `uv.lock` — absent by design — so the Python leg reports declared floors against PyPI and stops, while Rust and JavaScript re-resolve normally; in a generated project every lockfile exists and `--apply` re-resolves for real.

### Changed

- **The Python floors were raised for the first time since they were written** — `django>=6.0.4` → **`>=6.1`**, `redis>=5.0.0` → **`>=6.0`**, `celery[redis]>=5.3` → **`>=5.6`**, `pytest>=8.0` → **`>=9.1.1`**, `pytest-asyncio>=0.25` → **`>=1.4.0`**, `pytest-cov>=6.0` → **`>=7.1.0`**. Proven by resolution rather than by reading: `uv lock` resolves the whole set at **119 packages**.
- **The redis floor carries its own ceiling as an inline comment, because the number that looks right is wrong.** `celery[redis]` excludes `redis>=6.5`, so **6.4.x is the newest redis this project can resolve** while Celery is current — and the failure is not loud. A floor of `redis>=8` does not error; it silently drags celery back to **5.3.1** to satisfy itself, and `celery[redis]>=5.6` with `redis>=8.1.0` is unsatisfiable outright. Latest is bounded by the rest of the graph, never by what the registry calls latest, and a floor with no note beside it invites the next person to raise it to whatever PyPI shows.
- **Rust toolchain channel 1.92.0 → 1.97.1, with the MSRV deliberately left where it is.** `Cargo.toml`'s `rust-version` stays **1.85**, the edition-2024 floor. Lint, test and `cargo-deny` all clean on the new channel.
- **"The channel and `rust-version` move together" was wrong, and the rule is corrected where the toolchain declares itself.** They answer different questions: the channel is the compiler everyone actually builds with, and bumping it is a template release; `rust-version` is the floor **our source** needs, and it moves only when the code starts requiring a newer language or standard-library feature. Dragging the MSRV up with every channel bump narrows what can compile the crate and buys nothing, because the toolchain is pinned anyway. Corrected in `rust-toolchain.toml` and `code/src/rust/CLAUDE.md`.
- **`template-update.sh` runs the drift audit, gains `--force-deps`, and reports both quiet failures before either can stop the run.** The previous control flow exited on orphans before the dependency question had been asked at all, which costs a whole cycle: you resolve the orphans, re-run, and only then meet the second problem. Now both audits run, both report, and the refusal happens afterwards — `--force-orphans` and `--force-deps` are independent overrides, and exit 1 means orphans **and/or** drift. Applying with `--force-deps` prints the re-resolve command rather than leaving it to memory.
- **`14-UPDATING.md` gains _The other silent one — dependencies_** — the audit's own output, the BLOCKING/informational split and why it exists, and the three-command sequence that ends in the suites rather than in the update. It also states the limit: a guard only protects the updates that come **after** it, so an update from 3.0.0 or earlier is the last one taken unguarded.
- **`how-to/workflows/07-dependency-updates/STEPS.md` routes through `dependencies/update.sh` instead of raw `uv lock` and `pnpm install --lockfile-only`** — the Section 6 rule the workflow had been quietly breaking, since every document is meant to reference a script under `code/src/scripts/` rather than a package manager directly. The floor-is-not-a-pin rule and Celery's redis cap are stated at the point of use, where the mistake would otherwise be made.
- **Every GitHub Action moved to its current major — 11 actions, 31 workflow files, 129 uses.** `actions/checkout` v4 → v7 (48 uses), `actions/upload-artifact` v4 → v7 (24), `pnpm/action-setup` v4 → v6 (13), `actions/setup-node` v4 → v7 (13), `actions/cache` v4 → v6 (13), `astral-sh/setup-uv` v5 → v10.0.1 (12), `actions/setup-python` v5 → v7, `trufflesecurity/trufflehog` v3.95.3 → v3.96.0, `marocchino/sticky-pull-request-comment` v2 → v3.0.5. Swept together rather than one at a time, because a pipeline where some jobs run a current runtime and others do not fails in whichever half nobody looked at.
- **The two references that were not pinned at all are now pinned** — `MishaKav/pytest-coverage-comment@main` → `@v1.11.0` and `anthropics/claude-code-action@beta` → `@v1`. A floating ref is third-party code executing with the workflow's permissions, and its behaviour changes with **no commit in this repository**: two identical pushes can produce different pipelines, and a regression has no version to report against. `@beta` is worse than `@main` in one respect — it names a channel rather than a release, so there was never a number to quote at all.
- **`setup-uv` takes an exact patch, `v10.0.1`, where every other action takes a major.** Its caching behaviour is the one thing this repository has had to work around: `ignore-nothing-to-cache: true` on five jobs, added in 3.0.0 because `uv.lock` is absent by design here, with a comment citing verified v10 behaviour and its source. A major-only pin would let the behaviour that comment describes move underneath it, and the failure mode is a green check step followed by a failing post step — which is exactly how the defect presented the first time.
- **`UV_VERSION` 0.11.7 → 0.12.4** in the three workflows that set it (`claude.yml`, `syntax-python.yml`, `audit-deps.yml`), with the root `REFERENCES.md` stack row moved 0.11.x → 0.12.x **in the same change** rather than left to drift, and the `README.md` prerequisite floor with it.
- **pnpm 11.15.1 → 11.21.0 and the JS devDependency set to current** — `@usebruno/cli` 3.4.2 → **4.0.0** (a major), `eslint` 10.5.0 → 10.8.1, `globals` 17.6.0 → 17.11.0, `lefthook` 2.1.9 → 2.1.10, `markdownlint-cli2` 0.22.1 → 0.23.2, `prettier` 3.8.4 → 3.9.6. `@eslint/js` stays at `^10.0.1`, already current. Every root devDependency specifier and the lockfile move in one commit, so the `[2/8] Lockfile Alignment` gate has a single subject to check.
- **The three JS gates were run on the new toolchain rather than assumed.** Prettier 3.9.6 clean across the tree; markdownlint-cli2 0.23.2 (markdownlint 0.41.1) reporting 0 issues across 735 files; ESLint 10.8.1 exit 0. Prettier's one consequence is a reflowed nested-list continuation in `how-to/src/CLAUDE.md`, committed **with** the upgrade so it does not ambush the next unrelated PR as an unexplained formatting hunk.
- **`@usebruno/cli` crosses a major and its runner could not be exercised here.** The shipped invocation — `bru run -r <path> --cwd --env --exclude-tags --reporter-json`, in `code/src/scripts/tests/api.sh` and `test-api.yml` — matches the flags Bruno's current documentation gives, but the API suite needs the Docker test stack, which the base template cannot build (`uv.lock` absent by design, the same reason `pre-pr-check.sh` has a TEMPLATE MODE). Checked against the documentation, not against a run, and recorded that way rather than claimed as verified.
- **Two findings from closing N-013 recorded in `.claude/MEMORY.md`** — that v3.0.0 is the first tag this repository can be generated from at all, no commit in `e16b499..main` carrying both the agent files and the generation fix, so the charted proof was rebuilt deliberately rather than downgraded; and the general rule that a migration must not do work whose output has to pass a gate. `MEMORY.md` is copier-excluded as of 3.0.0, so neither reaches a generated project.

### Fixed

- **A `doc-references.sh` citation dangled the moment it was written.** The N-013 memory entry described its proof by citing the agents directory as a backticked path — and v3.0.0 had just deleted it, so `main` went red on the audit's own rule. Reworded to name the directory in prose. The audit was right and is unchanged: a path in backticks is a citation whether or not it was meant as one.
- **`.claude/hooks/pre-pr-check.sh` documented a toolchain that had not existed for some time.** Its pinned-versions comment read `uv 0.11.7  pnpm 10.33.2` — the pnpm half a full major behind the `packageManager` field in the manifest beside it, and stale before this sweep began. It is a comment, so nothing failed and nothing ever would; a version statement no gate reads is a version statement that drifts.

---

## [3.0.0] - 14/08/2026

### Removed

- **`.claude/agents/` is deleted in full — 56 files, 54 of them agent definitions plus the directory's own `CONTEXT.md`/`CLAUDE.md` pair.** The agent tier described a roster that duplicated the skills beside it: every remit it held now lives under `.claude/skills/`, reached by description match rather than by being named. This is the **breaking change** — `CONTRIBUTING.md` Section _syntek-base's public API_ declares the `.claude/` routing contract a generated project inherits, and deleting a directory that contract carries is MAJOR by its own table.
- **The conversion was not one-to-one, and the folds are the reason.** `debugger` folds into `bugfix` as a named `## Root cause` phase, so a diagnosis step dispatches a scoped remit instead of a seven-phase orchestrator that would silently authorise a commit. `user-story` folds into `story` on strict containment, and `story` loses its sprint half in full — `sprint` is now its own entry, and the duplicate `SPRINT-##.md` write is gone. `mobile`, `rust` and `desktop` fold into their paired stack skills; `scale-planner` folds into `scale-planning`.
- **Knowledge loss was audited before the delete, not after.** Every backticked token across all 54 bodies — 697 unique identifiers, paths and libraries — was checked to resolve elsewhere in the tree. Zero orphans. Five rules that existed **only** inside an agent body were rehoused first rather than lost with it: the per-route rate-limit baselines (60/min, 5/min, 3/hour, 30/min) into `INPUT-AND-API.md`, which owned the throttling rule but carried no numbers; the `pii.access`…`pii.audit` permission matrix into `AUTH-AND-AUTHZ.md`; Cyber Essentials, CE Plus, SP 800-53 and SP 800-63B into `SECURITY-GUIDE.md`, which had CSF 2.0 alone and therefore positioned a finding without saying what fails it; and the export library set into the new `code/docs/EXPORTS.md`, `weasyprint` and `openpyxl` having appeared nowhere else in the tree.
- **Two stale rules dropped rather than migrated** — `refactor` told a Django/HTMX project to extract stateful logic into React hooks, and `security` offered an ADR for a hard-to-reverse call, which the project retired on 11/08. Both had been unreachable except by routing to that agent, which is why neither was ever wrong loudly.
- **Four research notes retired with the epic they served** — `AGENT-SKILL-ECOSYSTEM.md`, `ANTI-SLOP-RULE-SOURCES.md`, `DISCOVERABILITY-SKILL-ECOSYSTEM.md` and `SKILLS-VS-SUBAGENTS.md`.

### Added

- **`.copier/migrations/v3.0.0-self-authored-agents.sh`, and the `_migrations` entry that fires it.** A MAJOR bump to the template requires a migration, because an existing project has to be carried across the break rather than left on the old contract. Copier removes the definitions **it** generated; one a project wrote **itself** was never a template file, so it is left behind in a directory nothing routes to — no conflict, no error, update reports success. That is the `14-UPDATING.md` silent-orphan failure running in reverse: there the scaffolding moved and your files stayed, here the scaffolding was deleted and your files stayed.
- **The migration is advisory by design and always exits 0.** It reports each remaining definition and its skill destination, never moves, rewrites or deletes one, and cannot fail an update. Agent → skill is a rewrite rather than a rename — a skill needs `name` and `description` frontmatter and must satisfy `skill-conformance.sh` — so a machine that moved the file would emit a skill that fails its own gate and call it a migration. It also distinguishes a stale template `CONTEXT.md`/`CLAUDE.md` from a definition worth converting, and drops the empty husk when there is nothing left.
- **`code/src/scripts/audits/routing-skills.sh` and its CI job — the routing guard.** A `skills:` key names what a document loads, and **nothing had ever validated the names**: measured at zero matches for `skills:` across `audits/*.sh`, `.claude/hooks/**` and `.github/scripts/*.sh`. A list pointing at a directory that does not exist was green everywhere and the skill simply never arrived. Two clauses over tracked and untracked-but-not-ignored Markdown: every name resolves to `.claude/skills/<name>/`, and any file naming one of the three copier-gated stack skills is itself excluded on a flag that **guarantees** that skill — otherwise the base template stays green while a web-only generated project ships an unresolvable name and fails on someone else's machine. Flag implication is parsed from `copier.yml`'s own `when:` clauses rather than hardcoded, so `INCLUDE_DESKTOP` counts as `INCLUDE_RUST`. Strict, with no allowlist. Current tree: 328 names across 233 files, all resolving.
- **`skill-conformance.sh` clause 13 — no agent definition exists**, and `.claude/agents/**` added to both path filters in `audit-skill-conformance.yml`. Without the filter the clause could never fire in CI: re-adding an agent touches no skill, no guide and no script, so the workflow would not run and the folder could return green. Clause 9 already refused a custom fork target in frontmatter; 13 refuses the folder it would live in, so the door is shut from both sides rather than only the side a skill can see. Its polarity is inverted — the absence is the pass — and it runs **before** the skills self-guard, because a project with no skills tree can still carry a re-introduced agents folder.
- **`skill-conformance.sh` clause 12 — the `metadata` namespace, closed.** `metadata` is the specification's own extension point and Claude Code acts on none of its contents, so every routing value clauses 7–11 read at the top level could be restated one indentation level down where none of them looks. A probe carrying `metadata: {agent: my-custom-agent, model: haiku, background: true}` produced **zero** findings before this change and three after. `skills` is the only child admitted, and every name in it must resolve.
- **`code/docs/EXPORTS.md`** — the downloadable-export guide, created as the home for content that had no owner outside a deleted agent body.

### Changed

- **Routing frontmatter: `agent:` folds into the existing `skills:` key across 233 files.** A fold rather than a rename, so a file loses a line instead of swapping one and `.claude/CLAUDE.md` Section 2.5 gains no new field; the owning remit leads the list. Twenty files where the fold target was already named dedupe to a plain deletion. `^agent:` now returns only two fenced illustrative examples and the forked skills whose `agent: general-purpose` is a fork target rather than routing — the distinction that makes the sweep safe, since both spellings are legal in both places and a key-matched sweep would have rewritten every fork target into a dependency list and passed every audit.
- **Dispatch markers: 89 across 34 `STEPS.md` files.** `↳ New agent: X` becomes `↳ New dispatch: general-purpose · Skill: X`. `general-purpose` is stated rather than implied, because the documented default is version-dependent behaviour. The three diagnosis-only markers name `bugfix`'s `## Root cause` phase directly, so a diagnosis step does not silently authorise a commit.
- **`.claude/CLAUDE.md` Section 2.4 and _Skill Targets_ become routing lines to `.claude/skills/CONTEXT.md`**, which already held the authoritative table; the file falls 295 → 254 cloc. Every construction that counts or tiers the roster is deleted rather than reworded — the tiering is what this release abolishes — and the `tooling-guide/` family loses its duplicated roster for the same reason.
- **Three skill descriptions stopped discriminating against things that do not exist.** `legal-documents` named `contract-writer` and `nda-writer` in both its description and its overview; neither has ever been an agent here. The description is the selection surface and sits in every turn's context, so a clause naming nothing is a discriminator pointing at nothing — and that it survived is proof the class was unguarded, since `skill-conformance.sh` validates a description's presence and length but never its content. Rewritten to discriminate on **what the request is**, which is also what makes them survive the folder going away.
- **`CRAFT.md` Section 1 prices a description, and the epic's closing measurement is why.** Measured on the identical method: 85 standing entries fell to 65, and standing context rose 27,598 → 33,216 chars (~6,900 → ~8,304 tokens, **+20.4%**). All 31 definitions converted one-to-one grew, mean +307 chars, none shrank. The cause was two decisions taken in different rounds and never measured against each other — one merged descriptions to save tokens and delivered −1,842, the next mandated sharper descriptions to close a selection collision and outspent the merge 1.3:1. The rule now carries the number and the ruling.
- **`.claude/MEMORY.md` is excluded and seeded blank from `.copier/`.** It was neither excluded nor seeded, so every generated project received eleven entries of syntek-base's own development — this repo's `.gitignore` overrides, which account may bypass branch protection, what an internal epic found. Section 2.1 has every session read that file **second, before the work**, which makes it the worst possible carrier: the template's memory arrives as the project's own and is read as authoritative. Nothing failed, because no consumer of this file exists that can fail. Seed-once matters more here than anywhere it is already used — `_tasks` never run on `update`, so a project's accumulated memory can never be handed back a blank canvas. Four entries were doctrine every project needs and had no owner; each was measured by grepping for the **content** rather than the filename before being moved.
- **Every folder that writes test artefacts now ignores its own.** A file written under `project-management/src/`, `research/`, `questionnaires/` or `learning/` while developing **this** repository is a test of the scaffolding; in a generated project the same file is the work. `project-management/src/.gitignore` is one allowlist over the whole tree rather than 22 per-folder denylists, because the failure modes are asymmetric: a denylist fails by silently shipping a local test file into every generated project, an allowlist fails by silently not shipping a new template file — which the first generation reveals.
- **`pre-pr-check.sh` gains TEMPLATE MODE.** Six of its eight checks took their authoritative half from inside the django container, which cannot be built here — no `uv.lock` by design, an unrendered token as the manifest `name`, and a gitignored dev env file — so the gate exited 2 on every PR raised from this repository. Detection is exact rather than heuristic: `copier.yml` lists itself in its own `_exclude`, so its presence at the root means this **is** the template. Nothing runnable is skipped and this is not a softened gate: the three dropped halves have no subject, and a gate that reports a failure where no subject exists trains its reader to ignore it. It adds the check that is authoritative for a template — `audits`, scoped by directory rather than by a list, because a list drifts silently.
- **Ten pnpm override floors re-floored against the audit, each bounded by its major.** A bare `>=` floor on a forced resolution drags every consumer across any major in between, silently, because the advisory clears either way — measured, bare floors would have taken nanoid 3 → 6 (ESM-only, breaks every CJS require), js-yaml 4 → 5, undici 7 → 8, linkify-it 5 → 6 and fast-uri 3 → 4. 36 advisories (19 high, 17 moderate) → 4, all ignored. `image-size` is ignored on availability rather than judgement: both its advisories name `>=2.0.3` and the newest published version is 2.0.2.
- **Ruff floor raised to `>=0.16.3` and the repository reformatted in the same change** — 35 files, 34 Markdown and 1 Python, mechanical throughout. `ruff>=0.11.0` was a constraint, not a pin: CI resolved 0.16.3 while the host ran 0.14.11, and from 0.16 ruff formats Python inside Markdown fenced blocks, so the two disagreed about what "formatted" means. Checked before applying that Prettier accepts ruff's Markdown output, so the two formatters do not fight.

### Fixed

- **A bare delimiter had broken every generation since v2.4.0, and the gate for it reported `1974 well-formed tokens`.** `sync-trees.sh:190` was Python source quoting Copier's own block opener as a string literal, in a file Copier renders — so Jinja parsed it as a tag and died with `TemplateSyntaxError` on both surface paths. The line is one edit; the three blindnesses that let it survive seventeen minor versions are the fix that matters. `check-template-tokens.sh` check 3 required a **closing** angle bracket, which Jinja does not need in order to fail; its character class policed a pipe character that is not a delimiter here and never could be, and never looked at the comment opener at all; and nothing had ever proved it discriminated, a presence test being green whether its matching rule works or not. The class is corrected to cover both real delimiters, check 4 is added for a bare opener, and `--self-test` now asserts each check fires on its own and only its own. `sync-trees.sh` builds the delimiter from its two characters rather than writing it out.
- **`shipped-readme.sh` proves its own detector.** Every check in it is a presence test against a tree that is correct today, so the ordinary run is green whether the matching rule discriminates or not — and it once did not, in two ways that both passed silently. `--self-test` deletes one required row per tree check from a copy of the README and asserts each catches its own, then proves the boundary rule on a synthetic blob, which is the part no mutation can reach because the real README holds no prefix collision. Fourteen probes. Checks 10–12 close the nested tree level nothing had ever reached — where the 09/08 sweep found `.github/workflows/` listing 11 of 28 and `code/docs/` missing eight guides that ship everywhere.
- **The block extractors now assert their scope, not merely that they returned something.** A `die` guard catches an **empty** block and cannot catch the opposite, which is the dangerous one: a section that failed to stop at its boundary and returned the whole tree leaves every nested check passing **and** still firing on every mutation, because a row deleted from the tree is deleted from an over-captured block too. Ten probes across four blocks, every anchor derived from the same globs the checks iterate.
- **`[7/8] Tests` had failed at `Initialize containers` since 03/08/2026, and the recorded hypothesis was wrong.** Postgres initialised perfectly well — the defect was the health command. Docker runs `--health-cmd` through `/bin/sh -c`, where the token's angle brackets are **redirection operators**: sh parsed `pg_isready -U <token> -d <token>_test` as `pg_isready -U -d` and never executed `pg_isready` at all. A health probe's stderr lives in `.State.Health.Log` and never in `docker logs`, which is why the container log read as truncated and sent the first diagnosis at the environment variables. Underneath sat a second defect: service containers initialise **before** the first step, so the job's step-level lockfile guard could never be reached. Both die with the block; `docker-compose.test.yml` is now the single definition of db and cache.
- **`check-security.sh` had never audited JS, in any repository.** It built `--ignore <GHSA>` arguments for `pnpm audit`, and there is no such flag — given one, pnpm prints "No new vulnerabilities were ignored" and **exits 0 having audited nothing**. `pnpm-workspace.yaml` has always carried ignore entries, so the flags were always present, so this leg reported a pass on every run it ever made. Not a weak check, a false green. Measured 13/08/2026: flagged invocation exits 0, plain invocation reports 36 advisories.
- **`setup-uv` failed its post step on five jobs because there was nothing to cache.** `uv.lock` is absent by design, so the guarded `uv sync --frozen` is skipped, uv installs nothing, and the action fails saving a cache directory that was never created — with every check step green. `ignore-nothing-to-cache: true` rather than `enable-cache: false`, because these workflows **ship**: a generated project does populate the cache and should keep it.
- **The Rust lint job was a build failure wearing a lint failure's name** — the workspace does not compile on a bare runner, because `crates/desktop` is a `members = ["crates/*"]` member and Slint links against system libraries the runner does not carry. Slint's documented Debian list is installed in one step.
- **Ruff now runs against this repository for the first time, via `uvx --from`.** Only the launcher needed the manifest; the rules never did. `uv` rejects `pyproject.toml` while **parsing** — line 2 is the unrendered project-slug token, which is not a valid PEP 508 name — so `uv run` and `uv sync` both died and every step after them was skipped, taking two of the three pre-commit legs with them silently. `basedpyright` takes the step-level lockfile guard instead, because a type-checker with no dependency set does not give a weaker answer, it gives a meaningless one.
- **`check-format.sh` counted zero on a Prettier-only failure** and printed `0\n? file(s) need formatting`: `grep -c` prints 0 **and** exits 1 when nothing matches, so the `|| echo "?"` fallback appended rather than replaced — and none of its patterns matched Prettier's actual `[warn] <path>` marker.

---

## [2.21.0] - 12/08/2026

### Added

- **The public-API declaration semver rule 1 has always required and this repository had never made.** `VERSIONING-GUIDE.md:39` said "breaking changes to the public API" without ever saying what the public API is, which leaves MAJOR undecidable — two reasonable people bump differently on the same diff, and neither can be shown wrong. The declaration now exists in **two homes, because the two audiences are different**: the shipped guide carries the rule and the surface table a **generated project** declares (the `/api/` contract, the schema as reached through it, indexed public URLs and the `/mcp/` tools are in; templates, tokens, internal signatures and operator tooling are out), while `CONTRIBUTING.md` carries **syntek-base's own** — the template contract, being the `copier.yml` questions and tokens, the generated tree's shape, and the `.claude/` routing contract `copier update` re-applies.
- **The five semver rules the guide had no answer for**, each applied to this repository's surfaces rather than restated: `0.y.z` and when to cut `1.0.0` (rules 4–5, and the trigger is **being depended on**, not shipping to production); the pre-release and build-metadata grammar with a worked precedence chain (rules 9–10, and build metadata is ignored entirely, so it can never distinguish two releases); precedence including the numeric-ranks-below-non-numeric case (rule 11); the deprecation policy — deprecate in a MINOR, leave it deprecated for at least one full minor, remove in the next MAJOR; and the recovery rule for a release that turns out to be incompatible, which is **a new MINOR restoring compatibility**, never a moved tag.
- **Breaking-change signalling in `GIT-GUIDE.md`** — the `!` shorthand, the `BREAKING CHANGE:` footer, and the mapping `fix`→PATCH, `feat`→MINOR, **any** commit carrying a breaking change→MAJOR regardless of type. The repository has used Conventional Commits on every release without ever stating how a commit declares that it breaks something; zero occurrences of either form existed in the tree.

### Changed

- **`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 1 loses its copy of the increment table** and routes to the guide instead. The two copies had already drifted — the guide said MAJOR was "breaking changes to the public API or data schema", the skill said "breaking changes" — which is the one-rule-two-homes defect in miniature, and correcting the copy would only have reset the clock on it.
- **`README.md` Section _Influences and attribution_ gains both specifications in the same change as the rules they credit**, per the standing Section 6 rule. Semantic Versioning 2.0.0 and Conventional Commits 1.0.0 are both **CC BY 3.0** — permissive, not share-alike, so the wording may be derived with credit and no obligation propagates into a generated project. The licence was verified against each specification's own page before deriving, not after. The rows-outside-the-survey count moves from two to four.

### Fixed

- **The README version badge had been stuck at 2.19.0 since the 2.20.0 release.** `VERSIONING-GUIDE.md` names the badge and the footer line as two separate updates on every root bump; 2.20.0 moved the footer and missed the badge, so the repository's most visible version statement was a release behind and nothing failed.

---

## [2.20.0] - 11/08/2026

### Added

- **`how-to/docs/skill-authoring/` — four sub-documents plus their pairing**, with `how-to/docs/SKILL-AUTHORING.md` reduced to a thin index over them. `FRONTMATTER.md` owns the field set, `FORK-DECISION.md` the reference/task split and the fork rubric, `CRAFT.md` invocation and information hierarchy, `SHIPPING.md` the pre-ship checklist. The precedent was already in the tree twice — `tooling-guide/` with three sub-documents and `ai-dictionary/` with seven — and the incoming doctrine exceeded the 58 lines the index had spare.
- **Four runtime keys admitted by `code/src/scripts/audits/skill-conformance.sh`** — `context`, `agent`, `background`, `model` — beside the two specification fields this project authors. `disable-model-invocation` is **not** adopted and a skill carrying it fails. The gate had been asserting that anything outside the six specification fields fails validation, which was never true: Claude Code accepts documented extensions of its own, and declining the rest is this project's choice rather than the format's rule.
- **Two fork assertions in the same gate.** Every skill carrying `context: fork` must carry an explicit `agent:`, and no `agent:` value may name anything outside `Explore`, `Plan` and `general-purpose`. The documented default is `general-purpose`, but `context: fork` changed behaviour at 2.1.218, so an explicit value is version-proof — and the second assertion is what keeps the custom-agent door shut in code while the doctrine records the test for reopening it.
- **Three authoring rules earned from measurement, not from taste.** One remit, one skill — a declared skill/agent pair is two roster entries for a single job. A description is a claim that it discriminates against its near neighbours, and the claim is checkable. And a `skills:` list is load-bearing rather than documentary: a reference skill shadowed by its task counterpart places second every time, so it is reached only by being named, and a task skill that omits it stops receiving the conventions with nothing failing loudly.

### Changed

- **`README.md` and `THIRD-PARTY-NOTICES.md` credit the two upstream sources in the same change as the rules they inform**, per the standing attribution rule. The Agent Skills specification is Apache-2.0 and derivable with attribution; Claude Code's documentation carries no `LICENSE`, so its facts are usable and its wording is not. Both entries carry a measured five-gram overlap, and the measurement is recorded as a step rather than a claim — the first draft of `FORK-DECISION.md` failed it.
- **`.github/workflows/audit-skill-conformance.yml` stops advertising the retired narrowing.** Its header still described a two-field gate, and the file is not copier-excluded, so every generated project would have started from a CI comment contradicting the audit beside it.
- **The registries that describe the gate were brought with it** — `code/src/scripts/audits/CONTEXT.md`, `.copier/README.md`, `.claude/skills/CONTEXT.md` and `CLAUDE.md`, the root and `how-to/` `REFERENCES.md`, and `how-to/docs/CONTEXT.md` and `CLAUDE.md`. A gate whose own inventory describes the previous version is how the next reader learns the wrong rule.

### Fixed

- **A declined frontmatter key could be smuggled past the gate by quoting it.** The key check matched unquoted keys only, so `"allowed-tools":` reported fully clean on a first-party skill. Verified by probe before and after.
- **A nine-word clause taken verbatim from documentation carrying no licence.** It reached a shipped guide by way of a research note, where it had been correctly marked as a quotation, and lost its quotation marks in transit. Re-authored, and the file now measures zero shared five-grams against both upstream sources.

## [2.19.0] - 11/08/2026

### Added

- **`code/src/scripts/audits/doc-references.sh` — the citation guard**, run on every push and pull request by `.github/workflows/audit-doc-references.yml`. Two fail clauses over tracked **and** untracked-but-not-ignored `.md`/`.sh` files: every backticked path the template owns must resolve, and no per-project instance — the `ADR-###`, `US###`, `SPRINT-##`, `MAP-*`, `PLAN-*`, `BUG-*` and `QA-*` families — may be cited as real, because a generated project has different ones at those numbers or none at all. The class kept coming back: three ADR numbers were cited as real across six files for a week before anyone noticed there was no ADR register behind them, and a manual sweep that found nine phantoms missed thirty more.
- **The exemptions and resolutions that keep it from being permanently red.** History files record what was true then; `how-to/src/TEMPLATE-GUIDE/` is copier-excluded and must be able to name a broken citation in order to log it; `handoffs/` and `.copier/` are staging; vendored docs are not this repository's to fix. `copier.yml` is parsed for the paths Copier seeds at generation, so a new seed needs no edit here. Relative citations resolve against the **citing** file rather than the repo root, and the house shorthand against `code/src/scripts/`. A naming pattern, and a row marked `e.g.` or `[EXAMPLE]`, demonstrates a convention rather than citing a document. `doc-references: ignore` on the line or the one above suppresses the case neither rule reaches — a path quoted in order to ban it, or one belonging to another repository.
- **It assembles the two Jinja delimiter pairs at runtime.** Copier renders this script into every generated project, so a literal pair anywhere in it would end generation with a `TemplateSyntaxError`. That is also why its patterns are variables rather than inline globs.
- **Three index rows in the root `REFERENCES.md`** — `code/docs/MANAGEMENT-COMMANDS.md`, `code/docs/MOBILE-CODING-PRINCIPLES.md` and `how-to/src/STORE-LISTING.md`, the guides added earlier in this cycle. All three exist on disk before the row claims them.
- **A Round 3 section in `research/SKILLS-VS-SUBAGENTS.md`**, plus the licence verdict its epic's gate needs. Inline is the documented default for a skill body; an invoked body stays in the conversation for the **session**, not the turn, and this project disables auto-compaction, so the re-attach budget never fires and bodies accumulate until `/handoff`; Anthropic publishes its own rubric for when `context: fork` is worth it; `agent:` defaults to `general-purpose`; a backgrounded fork runs on a narrower tool set and outside the session's checkpoints. On licences: the Agent Skills specification is Apache-2.0 and derivable with attribution, Claude Code's documentation carries no LICENSE file — its facts are usable, its wording must be re-authored — and nothing share-alike is involved, so nothing propagates into a generated project.

### Changed

- **The root `CONTEXT.md` describes the repository it has become.** "There is no separate frontend or mobile application" was true the day the stack became Django-only and false the day the mobile surface shipped. It now states the Django-monolith rule for the web and names the three optional surfaces — `code/src/mobile/`, `code/src/rust/`, and the Slint desktop app inside it — as separate deployables consuming the same API. The Layer Map gains the mobile row and stops calling the Django project "the single deployable".
- **The directory tree gains five rows it had drifted past** — `.copier/`, `code/src/improvement-architecture/`, `LICENSE`, `SECURITY.md` and `CONTRIBUTING.md` — and `.mcp.json` is described as the three servers it configures rather than one.
- **`how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md` records seven findings from this cycle and closes two.** The seven: the routing half deferred because the agent tier is being retired; merge-conflict markers that passed every gate for two releases after Prettier reformatted them into valid Markdown; the `/mcp/` surface having no error-taxonomy row; the ruff CI jobs below; the two research notes that cannot be deleted with their epic because `README.md` cites them as licence evidence; retiring the ADR machinery template-wide, measured at 74 actionable files; and the mobile tree's sub-directories carrying no `CONTEXT.md`/`CLAUDE.md` pair, which `docs-pairing.sh` structurally cannot see. The two closed are both citation gaps, closed by the rule the new audit now enforces.

### Fixed

- **`.github/workflows/syntax-python.yml` claimed to be the only Python gate this repository enforces on itself.** The lockfile half of that reasoning is correct — the three jobs run `uv sync` without `--frozen`, so no committed lock file is needed. The conclusion was not: in the base template the root `pyproject.toml` still carries the unrendered project-slug token as its `name`, and uv rejects that while parsing the manifest, before dependency resolution begins. All three jobs fail at the sync step and every step after it is skipped. The header now says so, notes that a generated project is unaffected, and records the contrast that makes the cause legible — pnpm skips name validation on a private package, so the identical token is harmless in `package.json` and fatal in `pyproject.toml`.
- **A dangling ADR citation in the root `REFERENCES.md`** — the `code/docs/architecture/CORE-AND-SCALING.md` row named two ADR numbers as its source, which is precisely what the new audit's second clause forbids. Dropped; the row keeps its pointer to the sizing snapshot.

## [2.18.0] - 11/08/2026

### Added

- **`code/src/django/apps/core/management/base.py` — `ManagementCommand`, the error taxonomy expressed on a command line.** A command has no HTTP status to carry the three classes, so the distinction is made in what the operator reads and what a scheduler can act on: a `ServiceError` becomes a one-line `CommandError` at exit 1, `DependencyUnavailable` exits **75** — `EX_TEMPFAIL`, from BSD `sysexits.h` — because a scheduler retries on it and must not retry on the other two, and `InvariantViolation` is deliberately not caught, so a programmer error reaches the operator as a traceback and the tracker as an event.
- **`execute()` calls `close_old_connections()` on entry and exit.** Django closes connections in `run_from_argv`, which `call_command()` never reaches, so a command invoked from a task, a test, or another command inherited whatever connection state its caller left.
- **A ruff `TID251` ban on both `BaseCommand` import paths**, `django.core.management.base.BaseCommand` and the `django.core.management.BaseCommand` re-export, because banning one would leave a one-word bypass. `pyproject.toml` exempts exactly one file — the base class itself. The ban is what makes subclassing compulsory rather than advisory: the direct base still works, and the only difference is that a broken invariant stops being distinguishable from a transient outage.
- **`code/docs/MANAGEMENT-COMMANDS.md`** — the rule the module implements. When work belongs to a person choosing the moment rather than to a queue; why argparse parses and parsing is not validation; why an identifier off the command line is as unverified as one off a URL and identity is an argument that must be verified rather than inferred; blast radius as the argument nobody passes, with `--dry-run`, declared bounds, and why the confirmation prompt is not the safety; and the four things worth asserting in a test, including the exit-75 one everybody skips.
- **`code/src/django/apps/core/management/` with its own `CONTEXT.md`/`CLAUDE.md` pair**, and no `commands/` package in it deliberately — Django discovers commands inside the app that owns their data, and `core` owns no domain.

### Changed

- **`code/docs/PROCESS-MODEL.md` records that one of its three no-request surfaces now satisfies the ORM connection rule structurally.** A command satisfies it by subclassing the base; a task and an MCP tool still carry it themselves.
- **`code/docs/TASK-AUTHORING.md` gains the taxonomy on its own surface, and its user-error class is empty on purpose.** A task has nobody to tell, so an argument it cannot act on was put there by code — a programmer error, even where the identical value arriving on an endpoint would be a 422. The two surfaces now name each other: the queue spends retry classification where the shell spends exit codes.
- **`code/src/django/apps/CONTEXT.md`, `code/src/django/apps/core/CONTEXT.md` and `code/src/django/apps/core/CLAUDE.md`** list the two sub-packages `core` now ships, `management/` and `templatetags/`, and carry the rule that `management/base.py` is the only module permitted to import Django's `BaseCommand`.
- **The `Decided by` column in `code/src/django/apps/core/CONTEXT.md` cites shipped guides.** It pointed at node IDs from a planning map that no generated project receives; it now names `code/docs/NEGATIVE-SPACE.md` and `code/docs/MANAGEMENT-COMMANDS.md`, which exist everywhere.
- **`code/REFERENCES.md`, `code/docs/CONTEXT.md` and `code/CONTEXT.md` index the guide**, together with `code/docs/discoverability/APP-STORE.md` and `code/docs/MOBILE-CODING-PRINCIPLES.md`. `code/REFERENCES.md` also adds the two external sources the base class is built on: Django's custom-management-commands howto — noting that `run_from_argv` catches `CommandError` and closes connections while `call_command()` does neither — and BSD `sysexits.h` for `EX_TEMPFAIL`.

## [2.17.0] - 11/08/2026

### Added

- **`code/src/django/templates/500.html` — the one template with a live consumer before any page exists.** Django resolves it by name with no view and no URL entry, so it works on a project that has not written a route yet. It deliberately extends no base, loads no CSS and names no internals, because Django renders it with an empty `Context` and no request — a base template that reads `request` would render blanks on the one page a user only ever reaches after something has already broken. The copy is a placeholder until first-time setup, exactly like the worked row in `how-to/src/INVARIANTS.md`.
- **`{% request_id %}`, in the new `code/src/django/apps/core/templatetags/core.py`.** The tag reads the correlation identifier from the `ContextVar` in `code/src/django/apps/core/middleware.py` rather than from the template context, which is the only mechanism that reaches the 500 page as well as HTMX error partials and ordinary views. A context processor cannot: those run only for a `RequestContext`, and there is no request. An empty string outside a request — a management command, a task, an exception raised above the middleware — is a correct answer rather than a gap, because a stale identifier resolves to the wrong tracker event.
- **`code/src/django/static/js/observability.js` — the global HTMX error handler.** One `htmx:beforeSwap` / `htmx:sendError` listener pair on `document.body`, never per element, closing the defect where a 5xx swaps nothing at all: the indicator stops, the page is unchanged, and the user re-clicks. It creates its own `role="alert"` region instead of targeting a possibly-null element, refuses to swap a complete edge-served HTML document into a `div` by testing the doctype, and leaves htmx's own `isError` alone — a handler that quietens the console while claiming to make failure visible is worse than none.
- **`CONTEXT.md` / `CLAUDE.md` pairs for `code/src/django/static/` and `code/src/django/templates/`**, retiring the two `.gitkeep` placeholders that kept both trees tracked. The static pair records that there is no client-side build, that the `htmx-handler-absent` clause in `code/src/scripts/audits/negative-space.sh` keys on the listener rather than on this file's path, and that no `css/` token layer or vendored HTMX/Alpine exists yet because no page loads them. The template pair records that `500.html` names no internals, that the identifier arrives through the tag rather than a context processor, and that `503.html` is never added there.
- **`code/src/django/apps/core/templatetags/CONTEXT.md` / `CLAUDE.md`** — the table of rendering paths showing which have a request context and which do not, plus the rules that keep the library honest: a tag here must work without a request context or it belongs in a context processor, `{% request_id %}` must never grow into a general correlation API, and the module name is load-bearing because templates carry `{% load core %}`.
- **`how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` entry 14 — the 503 page.** Django defines a handler and a template name for 400, 403, 404 and 500, and none for 503, so there is nothing to override. More decisively, the 503 that matters is returned precisely when the Django process is not answering, and a template cannot be rendered by a process that is down. The deploy repository owes a static document served from disk for `error_page 502 503 504`, carrying `Retry-After` where the window is known and `X-Request-ID` where the edge minted one, never cached, and with no asset references — the static tree is served by the same upstream that is failing.
- **`code/docs/FRONTEND-CODING-PRINCIPLES.md` Section _What is not built yet_** — the web peer of `code/docs/MOBILE-CODING-PRINCIPLES.md` Section 5, naming the base template, the `#error-region` div, the HTMX error partial, the `<script>` tag that would load the handler, and the token stylesheet, each with the reason it waits. It also states the consequence: the `htmx-handler-absent` clause is a no-op until the first template uses `hx-`, so the handler ships proven by ruff, ESLint and Prettier rather than by that gate.

### Changed

- **`code/docs/rendering/PITFALLS-AND-EXAMPLES.md` now documents the shipped handler rather than an illustrative sketch**, and gains Section _The identifier a full-page error cannot be given_: Django's own documentation on the empty `Context`, the two consequences that follow from it, and the `{% extends %}` trap on an error page. The section closes by stating there is no `503.html` and routing to the edge contract.
- **`.claude/skills/stack-htmx-templates/SKILL.md` gains Section _When a swap would show nothing_.** The per-view 200-re-render pattern it already carried is the user-error half and is complete; the other two taxonomy classes need the global listener, and the skill documents the shipped handler because that is what a frontend agent is about to edit.
- **`code/src/CONTEXT.md` and `code/src/django/CONTEXT.md` stop describing `static/` and `templates/` as empty.** Each tree now names the one file it holds, with a paragraph explaining the narrow exception — each carries a correctness rule rather than a design decision, which is why it ships before the design work exists. `code/src/CONTEXT.md` also adds `mobile/lib/` as the mobile surface's home for non-route modules, and the `core` app's one-liner widens to include the middleware and the command base.

### Fixed

- **The handler snippet the rendering guide documented reproduced the defect it was there to close.** It assigned `document.getElementById("error-region")` straight to `event.detail.target`, which is `null` on any page that has not defined the region — and a swap into `null` fails silently, leaving the user with the unchanged page the handler exists to prevent. The shipped handler creates the region.

## [2.16.0] - 11/08/2026

### Added

- **`code/docs/discoverability/APP-STORE.md`** — the fifth member of the discoverability family, and the first that governs an artefact of a **different deployable**: the App Store and Google Play listing for `code/src/mobile/`. Store search matches listing metadata inside a length budget, not a crawled page, so none of the head, schema, root-surface or body rules reach it. Carries the field-by-field limits with a `Source:` and a `Verified:` date each, and four rules: `app.json` `expo.name` is the on-device name and **not** the listing name, keywords are never spent on the app or company name, the description is plain text with no HTML, and promotional text is the field that can change without a new version. **Mobile-only** — copier-gated on the same mechanism as `code/docs/visual-design/MOBILE.md`.
- **Apple's keyword budget is 100 _bytes_, not 100 characters**, quoted from App Store Connect Help. Almost every third-party ASO source states it as characters; the two coincide for an ASCII listing, which is why the error survives. In UTF-8 an accented Latin character costs two bytes and most CJK characters three, so a localised keyword set measured at 100 characters can be rejected at a third of its apparent length. Count with `len(text.encode("utf-8"))`.
- **`how-to/src/STORE-LISTING.md`** — the per-project register the guide governs: every text field, the value this project uses, and the budget it must fit. Same rule-elsewhere/answer-here split as `how-to/src/PLATFORM-PROVIDERS.md` and `how-to/src/INVARIANTS.md`. A blank cell is an unanswered question, not a default, and only the guide carries the verification dates — if the two disagree, the guide is right.
- **A conditional store-listing gate in `project-management/workflows/23-release/`.** New Step 2 in `STEPS.md` fires **only if the release moved `code/src/mobile/`** (`app.json` `expo.version`); a root-only bump reaches no store, and a web-only project never meets the condition. It delegates to `mobile`, writes the What's New copy into App Store Connect and the Play Console, and records the same text in the register — **overwriting, never appending**, because the history already lives on the mobile sub-package's own `CHANGELOG.md` and `RELEASES.md`. Matching row in `CHECKLIST.md`, routing in `CONTEXT.md`.
- **A `How much of this a machine can check` section across the discoverability family.** `code/docs/DISCOVERABILITY.md` states the gradient — from `discoverability/STRUCTURED-DATA.md`, where nearly everything is a test, to `discoverability/CONTENT-STRUCTURE.md` and `discoverability/APP-STORE.md`, where almost nothing is — and the two consequences: no audit in `code/src/scripts/audits/` covers this family and none is planned, and a clean pipeline says nothing about whether any of it was honoured.

### Changed

- **The `mobile` agent owns the store listing, not the `seo` agent.** How a product is found in store search has no web counterpart, and `seo` is scoped to the Django marketing pages. `mobile` owns the **text fields and their limits**; the screenshots and icon stay with `code/docs/visual-design/MOBILE.md`, and the privacy nutrition labels and Data Safety declarations with `project-management/src/09-GDPR/`. Roster row in `.claude/agents/CONTEXT.md` updated to match.
- **`how-to/src/BRAND-VOICE.md` gains store-listing text as a third thing that is not a fifth register** — a separate bullet from SEO metadata rather than a clause inside it, because the constraints are not the same shape: a byte budget runs out two to three times sooner than a character count predicts.
- **`project-management/docs/SEO-CHECKLIST.md` says plainly that a green pipeline is not evidence.** `12-seo-checks` runs inside the per-story loop **before any code exists**, so it reviews the plan for a page rather than the page. Every tick is a person's judgement.
- **`STRUCTURED-DATA.md`'s `Verification` section is now `What is mechanically checkable here`**, and states the half that is not: whether the type chosen suits the page, and whether the values describe the thing honestly. A `Product` block with valid syntax and invented review counts passes every check and is a manipulation.
- **`WEB-METADATA.md` names its checkable half as the half that fails silently.** One `<title>`, one description, one canonical per route; the canonical absolute and derived from `SITE_URL`. A `Host`-derived canonical renders correctly, looks correct in a browser, and hands a proxied copy of the site the right to call itself the original.
- **`code/docs/DISCOVERABILITY.md` no longer defers the third destination.** The row that said store-listing doctrine was "not covered here yet" now names its owner, and the sub-document table and `discoverability/CONTEXT.md` read four artefacts as five.
- **Release Step 5 stops instead of printing a command that does not work.** `code/src/scripts/deployment/` is a scaffold, so the workflow now says it has no deploy entry point to give you and hands the tagged, tested release to whoever owns the target environment — rather than naming `deploy.sh` with a footnote admitting it is unwritten.
- **`how-to/REFERENCES.md` and `how-to/src/CONTEXT.md`** carry the `STORE-LISTING.md` row, flagged mobile-only.

## [2.15.0] - 11/08/2026

### Added

- **`code/src/scripts/audits/negative-space.sh`** — the CI half of `code/docs/NEGATIVE-SPACE.md`. It correlates `how-to/src/INVARIANTS.md` with the code, by name, in both directions and on both surfaces. Nine `[gate: fail]` clauses — `constraint-unregistered`, `constraint-absent`, `key-unraised`, `key-unregistered`, `key-duplicated`, `register-absent`, `htmx-handler-absent`, `request-id-middleware-absent`, `ts-flags-loosened` — and one `[gate: warn]`, `worked-row-stale`. There is **no silencing annotation**, deliberately: a comment suppressing a finding here is itself a finding, on the same reasoning that makes a `# noqa: S101` one.
- **`--self-test`, and the fixture pair under `code/src/scripts/audits/fixtures/negative-space/`.** `broken/` must trip every fail clause; `clean/` must trip none. Six known-positive files carry one violation each — `models.py` holds `constraint-unregistered` and `constraint-absent` together, `services.py` holds `key-unregistered` and `key-duplicated`, `page.html` an `hx-post` with no `htmx:responseError` handler, `settings.py` a `MIDDLEWARE` list omitting the request-ID middleware while naming it in the docstring, `tsconfig.json` a loosened compiler flag, and `INVARIANTS.md` one breach of each register clause. Missing fixtures exit 2 rather than passing having proved nothing.
- **`.github/workflows/audit-negative-space.yml`** — the self-test runs **first**, then the scan. Its path filter is deliberately broad across both `how-to/src/INVARIANTS.md` and the code the register names, because a clause landing in one half alone is the drift the audit exists to catch.
- **`code/docs/MOBILE-CODING-PRINCIPLES.md`** — the mobile peer of the backend and frontend principles guides. It owns how the mobile surface **expresses** the negative-space rules and restates none of them: the four compiler flags and what each makes un-writable, the flags deliberately declined, exhaustiveness across compile time and runtime, and the error taxonomy on a device.
- **`code/src/mobile/lib/invariant.ts`** — `InvariantViolation`, named to match the backend's exactly so one `On breach` column reads the same on both surfaces, plus `unreachable(value: never, key)`, which fails typecheck at every unhandled call site and throws a keyed error when an unseen union member arrives from the API.
- **`code/src/mobile/lib/error-classes.ts`** — `classify()` and its reporting table. `408`, `502`, `503` and `504` are carved out as **environment** errors despite three being 5xx, so a rolling deploy's restart window is not filed as a fleet of new defects; environment reports aggregate, because a phone losing connectivity is ordinary; an unrecognised failure defaults to **programmer error**, because defaulting to environment silences exactly the failures nobody has considered yet.
- **`code/src/mobile/__tests__/invariant.test.ts` and `code/src/mobile/__tests__/error-classes.test.ts`** — the classifier's table pinned status by status, the REPORTING policy and `isRetryable`, and proof that a thrown string, a `null` and a stringified status all land as programmer errors.

### Changed

- **`how-to/src/INVARIANTS.md` gains a `Key` column, and it is a column rather than a convention because a gate cannot read a convention.** The key in the register and the string in the `raise` are one string, checked by name. A pure `db-constraint` row carries `—`, because a constraint name is already its own identifier. The file also gains a **client-enforced** section, mobile-only, and a standing rule that a client guard never re-checks what the server enforces — that is the second call site the register forbids, only harder to notice because it sits on the other side of an API.
- **`code/docs/NEGATIVE-SPACE.md` gains a _What the gate decides_ section** naming every clause and its tier inline, so the script implements against the markers rather than re-deriving what is detectable. Two things are marked `[judgement]` and belong to the reviewer: whether a named enforcement point guards the **right** thing, and whether an invariant is missing altogether. The `Mechanism` vocabulary adds `client-guard`, `RequestIDMiddleware` staying in `MIDDLEWARE` becomes a gated clause, and the per-surface table extends to background tasks, management commands and the mobile app.
- **Scope is stated, because a gate that measures the wrong thing is worse than none.** Models only, never migrations — a migration history holds every constraint ever added, including ones since dropped, so scanning it would force the register to carry dead rows to stay green. Test code is exempt on both surfaces, exactly as ruff `S101` exempts it, and `code/src/scripts/audits/fixtures/negative-space/clean/guard.test.ts` and `clean/tests/test_guard.py` construct unregistered keys on purpose so the self-test fails the day that exemption is removed.
- **`code/src/mobile/tsconfig.json` enables the four flags beyond `strict`** that neither `strict` nor `expo/tsconfig.base` implies — `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitReturns`, `noFallthroughCasesInSwitch`. Each bans a state rather than a style, which is the test for adding a fifth. `noUnusedLocals` and `noUnusedParameters` are declined and the file says why: ESLint already owns that rule, and two enforcers of one rule drift.
- **`code/src/mobile/jest.config.js` adds `lib/**/\*.{ts,tsx}`to`collectCoverageFrom`.\*\* Without the entry the new non-route modules are invisible to the coverage floor, and the run stays green having measured nothing.
- **`code/src/mobile/CONTEXT.md` and `code/src/mobile/CLAUDE.md` document the `lib/` tree and two rules.** `lib/` exists because expo-router would publish any helper placed under `app/` as a navigable screen. A new non-route module joins the coverage glob in the same change, and loosening a compiler flag to clear a build is a finding for `project-management/src/19-FINDINGS/`, never a `!` non-null assertion.
- **The three stack skills teach the taxonomy the register encodes.** `stack-django` — the three error trees, `InvariantViolation` taking its register key first, and the guard whose only exit is the `raise`. `stack-react-native` — the four flags, `unreachable()` over `assertNever`, `classify()`, and one root `ErrorBoundary` because on a phone the environment error is the ordinary case. `stack-fastmcp` — a tool inherits the JSON API's row rather than holding one of its own, and the guard stays in the service.
- **`code/src/scripts/audits/CONTEXT.md` registers the audit and its fixtures**, widens exit code 2 to cover a self-test whose fixtures are missing, and states the new rule that a warn tier is **earned rather than assumed**.
- **`how-to/workflows/06-quality-gates/` carries both invocations** — the scan and `--self-test` — in `STEPS.md` and `CHECKLIST.md`, with the audit named in `CONTEXT.md`.
- **`README.md` and `THIRD-PARTY-NOTICES.md` credit TigerStyle where the doctrine sits.** Two rows measured at **0.0% five-gram overlap** against `code/docs/NEGATIVE-SPACE.md` and `how-to/src/INVARIANTS.md`, with the note that its assertion mechanism is deliberately not adopted: Python's `assert` is stripped by `-O` and cannot carry the register key.

## [2.14.0] - 11/08/2026

### Added

- **`context7` and `mcp-mermaid` are configured in `.mcp.json`.** The `.claude/CLAUDE.md` Section 3 table listed five MCP servers as though the project supplied them; `.mcp.json` supplied one. Two more are now genuinely wired, and the table gains a **How you get it** column so the difference is visible rather than assumed: `code-review-graph`, `context7` and `mcp-mermaid` come from `.mcp.json`; `claude-in-chrome` needs the Chrome extension installed and paired, which nothing in this repository can do on your behalf. The `figma` row is gone — nothing here provides it either.
- **`.copier/MAP-SCALE-PLANNING.md`, seeded into `project-management/src/01-FEATURE/` at generation.** Six shipped files route a reader to that map, and it did not exist until `/scale-planning` wrote it — so on day one, every one of those six routes went nowhere. The seeded file is a stub: every row reads `TBD`, and the frontier is **named rather than answered**, which is the honest state before the pass has run. It rides the same seed-once `_tasks` mechanism as the root version files, on `copy` only, so `copier update` can never hand a project its blank stub back over a filled-in map.
- **Two nested `.gitignore` files, both `_exclude`d from the template.** `handoffs/.gitignore` ignores `HANDOFF-*.md`; `project-management/src/01-FEATURE/.gitignore` ignores the feature maps, bar the template they are written from. In **this** repository both are throwaway working state about the template itself and belong in no history. In a **generated** project both are real — handoffs are that project's session continuity and maps are the artefacts of `01-feature` — which is why the rule must not travel. Git honours a `.gitignore` in any directory, so a repo-local rule can live in a file copier drops at generation, leaving the root `.gitignore` shipped and therefore still updatable.

### Changed

- **A shipped file may cite only what every project is guaranteed to have.** That is the layering system — `CONTEXT.md`, `CLAUDE.md`, the `docs/` guides, the workflows, the scripts. A per-project instance is not guaranteed: a generated project has different ones at those numbers, or none at all. Naming a **pattern** stays fine — "take the next free number in `14-DECISIONS/`" describes a format, not a document. Citing a specific instance as real does not. Applied by hand across the tree in this release.
- **This project does not use ADRs, and `.claude/MEMORY.md` now records that as a project- and template-wide decision.** Decisions are recorded where the work already lives — the feature map, the story plan, the nearest `CONTEXT.md` glossary, a `research/` note. The trigger was `project-management/src/14-DECISIONS/` not being copier-excluded: an ADR about the template's own tooling would ship into every generated project as a decision that project never made. The machinery it retires is still standing and still instructs otherwise; the memory entry is read second in the Section 2.1 order and wins until the removal ships.

### Fixed

- **The phantom decision-record numbers 2.13.1 logged and deliberately left open.** They are cleared from `DESIGN.md`, `.prettierignore`, `code/workflows/03-database-migration/CONTEXT.md`, `code/src/scripts/audits/css-tokens.sh` and `code/src/scripts/audits/css-gradients.sh`. Each one described something real, so each now names that thing directly — the shard-key co-location, the Django static token cascade, the co-located django-component CSS — instead of pointing at a decision record no project has ever held.
- **Story numbers used as worked examples in a template that ships no stories** — `project-management/src/07-COMPONENTS/CONTEXT.md`, its `CONSOLIDATED-IDEAS/CONTEXT.md`, `project-management/workflows/17-consolidate-design-work/CONTEXT.md`, and the naming table in `project-management/src/CONTEXT.md`. "One story's status badge and another story's tag chip" makes the identical point and is true in every project.
- **Map names and node numbers cited as evidence** in `.claude/MEMORY.md`, `.claude/skills/grilling/SKILL.md`, `.claude/skills/wayfinder/SKILL.md`, `.claude/agents/seo.md` and three `research/` notes. A map is deleted once its epic ships, so the citation dies while the lesson it was supporting stays true. Each lesson now stands on its own wording.
- **`.claude/agents/release.md` named two paths that do not exist.** The version-bump phase listed `code/src/django/pyproject.toml`; the Django package's manifest is the root `pyproject.toml`. Phase 4 ran `code/src/scripts/deployment/production.sh`; `deployment/` is a scaffold with no runner in it. That phase now stops and reports, and says never to improvise a deploy command.
- **`.claude/agents/completion.md` was instructed to keep a story index reconciled** — a file this template does not ship, in the remit, the read list and the procedure. All three removed.
- **The pytest and coverage configuration was cited at `code/src/django/pyproject.toml`** in `code/docs/testing/BACKEND-TESTING.md` and `code/docs/testing/COVERAGE.md`. `[tool.pytest.ini_options]` and `[tool.coverage.run]` both live in the repository-root `pyproject.toml`, and the snippet headers now say so.
- **A dependency-audit script cited three times and never written.** Dependency scanning is `.github/workflows/audit-deps.yml` — `pip-audit` plus `pnpm audit` — and it runs on a schedule, not the "every PR" cadence `code/docs/testing/TAXONOMY.md` claimed. Corrected there, in `code/docs/testing/ADVANCED-TESTING.md` (which also stops pointing future load tests at a directory that does not exist), and in the pre-deploy checklist in `code/docs/security/OWASP-AND-CHECKLIST.md`.
- **`code/workflows/09-debugging-with-logs/CHECKLIST.md` pointed at `lint.sh` and `check.sh` one directory too high** — both live under `code/src/scripts/syntax/`.
- **Deploy-repository paths that read as paths in this repository.** `how-to/src/NIXOS-SETUP.md`, `how-to/src/SERVER-ARCHITECTURE/CONTEXT.md` and `how-to/src/SERVER-ARCHITECTURE/NIXOS-HANDOFF.md` cited the fork guide and the server-setup workflow bare, so each resolved here — to the wrong thing. Every one is now prefixed `<%DEPLOY_REPO%>`.
- **Counts stated in prose that had stopped being true.** `how-to/src/TEMPLATE-GUIDE/07-REPO-TOUR.md` said 11 code workflows in three families (there are four, the fourth being the opt-in surfaces) and five script groups, omitting `deployment/`, the surface-gated groups and `_lib/`. `code/workflows/13-desktop-app/CONTEXT.md` said "the two scripts".

## [2.13.1] - 11/08/2026

### Added

- **`.github/scripts/shipped-readme.sh`** — verifies that the documentation a generated project receives still describes the template that generated it. Two documents drift silently because nothing consuming them is ever run by this repository's CI: `.copier/README.md`, the README a new project actually gets, and `how-to/src/TEMPLATE-TOKENS.md`, the prose token contract `copier.yml` implements. Neither had a consumer that fails when it goes stale.
- **The four `REFERENCES.md` files index every guide added across 2.4.0–2.13.0** — `DOCUMENTATION-PAIRING`, `VISUAL-DESIGN`, `NEGATIVE-SPACE`, `DISCOVERABILITY`, `PROVIDER-NEUTRALITY`, `BUILD-OPERATE-SEAM`, `TASK-AUTHORING`, `PROCESS-MODEL`, `OBJECT-STORAGE`, `AUDIT-TRAIL`, and the sub-document folders under each.

### Fixed

- **`.copier/README.md` described a repository three surfaces out of date.** Its `code/src/` tree omitted `improvement-architecture/`, which ships everywhere; its `.github/workflows/` list named 11 of 28, only two of the omissions being surface-gated; and its `code/docs/` tree omitted eight ungated guides. The `src/` tree stopped at `21-REFACTORING` and the workflow count said 21. All corrected, plus the new attribution section and an honest _declared, not wired_ note against Celery.
- **`check-template-tokens.sh` reported green on files it had never looked at.** It scanned `git ls-files` only, so the file you had just written — the one most needing the check — was invisible. CI never noticed, because everything is tracked by the time CI runs; local runs are exactly where the blindness bit. It now scans tracked **and** untracked-but-not-ignored files.
- **`.prettierignore` pointed at directories that have not existed since the stack became Django-only** — `code/src/frontend/`, `code/src/backend/`, a Next.js build-output block and GraphQL codegen paths. Repointed at `code/src/django/`.
- **The root `CONTEXT.md` declared version 2.0.0**, three releases behind, and gave three wrong workflow ranges: code workflows as `02–14` (they are `01–13`), how-to as `01–04` (they are `01–09`), and PM as `01–22` (they are `01–23`).
- **The `README.md` footer declared v1.0.0**, and the stack table promised Celery and S3 storage as though both were wired.
- **Cross-references left dangling by the guide splits** — chiefly `CODING-PRINCIPLES.md` anchors that moved into `coding-principles/PRACTICAL-RULES.md`, and `project-management/docs/RESPONSIVE-DESIGN.md` cited as a source when it is a redirect stub.

### Known issues

- **The phantom ADR references are still open.** `ADR-016`, `ADR-019` and `ADR-023` are cited as real in `REFERENCES.md`, `DESIGN.md`, `code/workflows/03-database-migration/CONTEXT.md`, `.prettierignore` and two audit scripts, and no ADR register exists. Logged in `how-to/src/TEMPLATE-GUIDE/TEMPLATE-GAPS.md`; deciding whether to write the ADRs or drop the citations is its own change, not a sweep item.

## [2.13.0] - 11/08/2026

### Added

- **`.claude/hooks/context-threshold-handoff.sh`, registered as a `UserPromptSubmit` hook.** The model cannot read its own context usage, so a hook measures it and the rule in `.claude/CLAUDE.md` Section 2.6 reacts. **At 50%** — advise, once per session: finish the step in flight, start no new scoped work, name the stopping point and offer `/handoff`. **At 75%** — insist, on every prompt: write the handoff and stop the turn.
- **A deny-list covering every `.env` variant** — `.env`, `.env.dev`, `.env.test`, `.env.prod`, `.env.staging`, `.env.local`, `.env.probe`, `.env.backup`, `.env.bak*` and the long-form spellings — for both `Read` and `Bash`. The `.example` templates are explicitly allowed, because reading those is how an agent learns which variables exist without learning their values.

### Changed

- **The handoff trigger moved earlier, and the reason is the point.** `PreCompact` alone is too late: by the time compaction fires the window is already spent, and a handoff written under that pressure is the worst one of the session. The new hook keeps the same split as `pre-compact-handoff.sh` — a hook cannot invoke a skill or stop a turn, so the script measures and reminds while the rule carries the behaviour.
- **The window size is a constant with an environment override.** Nothing in the transcript reports it. The default is this project's observed 1M window; `CLAUDE_CONTEXT_WINDOW` overrides it for a 200k plan, and both thresholds are overridable too.
- **The hook always exits 0.** A miscounted token must never block a prompt — a warning system that can refuse input is worse than no warning system.
- **`how-to/docs/ai-dictionary/PATTERNS-OF-WORK.md`** describes the two-threshold pattern, so the vocabulary matches the behaviour.

## [2.12.0] - 11/08/2026

### Added

- **`code/src/scripts/audits/static-analysis.sh`** — pattern and taint analysis over the Django surface using Opengrep against this project's own rule files. It closes two gaps that nothing else could, because both are structural rather than a matter of configuration.
- **Django template markup is now scanned at all.** Ruff cannot parse a `.html` file, so `{% autoescape off %}`, the `|safe` filter, and a template variable interpolated into an Alpine expression or an inline script were entirely unchecked. Three rules cover them: `django-autoescape-off.yml`, `django-safe-filter.yml`, `django-template-xss.yml`.
- **Cross-file taint tracking.** `pyproject.toml` already enables ruff's `S` ruleset, which runs per file — it flags a bare `eval()`, but it cannot see that the argument arrived from a request three modules away. `request-to-sink-taint.yml` follows request data to raw SQL, shell and eval sinks.
- **`secrets-in-source.yml`** — hardcoded credential assignments, complementing the `.env` read-denials rather than duplicating them.
- **`code/src/scripts/audits/rules/` with its own `CONTEXT.md`/`CLAUDE.md` pair**, because the rules are hand-authored source and need the same orientation as anything else in the tree.

### Changed

- **`stubs.sh` now covers Rust** — `// STUB`, `// TODO`, `// FIXME`, `// HACK`. It deliberately does **not** grep `todo!()`, `unimplemented!()` or `unreachable!()`: all three are denied at lint level in every crate's `[lints.clippy]`, and clippy parses Rust, so it cannot be fooled by a macro name inside a string or a doc example, and it offers a per-site `#[allow]` carrying a reason. A `// STUB` comment is precisely what clippy cannot see, which is the division of labour.
- **The Cargo `target/` tree is excluded from the stub scan** — thousands of generated `.rs` files carrying upstream crates' markers, none of them anyone's to fix here.
- **`code/docs/rust/PYO3-BOUNDARY.md`** documents the lint-level rule and its escape hatch, so the two halves of the stub policy are described in one place.

## [2.11.0] - 11/08/2026

### Added

- **`/incident`** — runs a live incident alongside you: timestamped notes, the clock, the seven-field handover when you have to stop, and the blameless postmortem at stand-down. It has **no paired agent** deliberately — running an incident is a session mechanic, not a remit. Doctrine: `how-to/docs/INCIDENT-PRACTICE.md`. Register: `project-management/src/22-INCIDENTS/`, which is **PII-free** and, unlike every other record folder, **not story-anchored**.
- **`/resolving-merge-conflicts`** — recovers the intent behind both sides of a conflict, resolves every hunk, and proves the result with the project gates. Knows the file classes that must **never** be hand-merged: migrations, lockfiles, version state, and frozen PM artefacts.
- **`/wizard`** and `code/src/scripts/_lib/wizard.sh` — authors a guided bash script for the parts of a procedure a person must do by hand: provisioning a third-party service, minting credentials or CI secrets, a one-off cutover. Explicitly never for work the agent can do itself.
- **`/to-questionnaire`** and the `questionnaires/` sandbox — turns a decision the session cannot settle into a questionnaire for the person who can: a client, a data controller, a vendor, a stakeholder. It is the honest exit from a grilling pass that has stalled on somebody who is not in the room, and is never invoked by the model on its own.
- **`/wait-what`** — re-pitches a reply that did not land, in plain language, with the context it wrongly assumed. Also never self-invoked.
- **`code/src/scripts/audits/skill-conformance.sh` and its CI job.** Eight fail-tier clauses, reported in two groups because a specification breach and a house-rule breach are different problems: six checks against the [Agent Skills specification](https://agentskills.io/specification), and two house rules — no spec-optional key on a first-party skill, and a `## Governing procedures` section present. Length is deliberately **not** checked here; `docs-length.sh` owns the 300-line cap across `.claude/**`, and one rule with two enforcers drifts.
- **`how-to/docs/SKILL-AUTHORING.md`** — the standard the audit enforces, including why this project authors only `name` and `description` and declines the other four spec fields: capability and model belong to the **agent** that loads a skill, never to the skill.
- **`research/AGENT-SKILL-ECOSYSTEM.md` and `research/SKILLS-VS-SUBAGENTS.md`** — the primary-source survey behind both the five skills and the authoring standard.

### Changed

- **Vendored skills are held to the specification half only.** The Cloudinary set is a symlinked folder refreshed from upstream via `skills-lock.json`; hand-editing one to satisfy a house rule is undone by the next refresh, so clauses 7 and 8 skip them.
- **`code/docs/security/MONITORING-AND-INCIDENT.md`** routes its response half to the new incident practice rather than describing a procedure in its own words.

## [2.10.0] - 11/08/2026

### Added

- **`code/docs/TASK-AUTHORING.md`** — the enqueue boundary, idempotency, retries, limits, queue routing, and broker-free testing. `celery[redis]>=5.3` has been a declared dependency with nothing consuming it: no `config/celery.py`, no task module, no `CELERY_*` setting, and no `worker` or `beat` service in any of the four Compose files. The guide is the design of record for the day a feature needs a task.
- **`code/docs/PROCESS-MODEL.md`** — worker class, event loop, and the ORM's synchronous boundary treated as **one topic rather than three**, because deciding any of them alone decides the other two badly. Also says where a task worker sits relative to the web process family. The web half is verified against `code/src/docker/`; the task half is not, and says so.
- **`code/docs/OBJECT-STORAGE.md`** — private-document storage over the S3 API: the adapter contract, presigned URLs, upload validation, and the private/public split against Cloudinary. `boto3` is declared and unconsumed, exactly as Celery is.
- **`code/docs/security/AUDIT-TRAIL.md`** — the owning guide for the audit record, and the **record** half of OWASP A09:2025. Table schema, the atomic write path, what goes in and what must never, the PII rule, retention, and tamper resistance. `MONITORING-AND-INCIDENT.md` keeps the alerting-and-response half; the A09 row in `OWASP-AND-CHECKLIST.md` now names both.

### Changed

- **Every one of these guides opens with an explicit status line.** _Declared, not wired_ — naming the dependency, where it is declared, and precisely what does not exist yet. A guide that reads as though the subsystem is running is worse than no guide: it sends someone looking for a module that was never written.
- **`code/docs/logging/OBSERVABILITY.md` is rewritten around four interfaces** — error tracking, log aggregation, metrics, traces — each leading with the interface the code is written against and naming the default as one implementation behind it. `sentry-sdk[django]` and `django-prometheus` are declared and unconfigured, and the guide now says so rather than implying otherwise.
- **The collector side is named as server infrastructure, not application concern.** Log shipper, metrics store and dashboards do not run in the local Compose stack; they are provisioned by the deploy repository. That boundary was previously implicit and routinely misread.
- **`how-to/docs/CELERY-FIRST-RUN.md`** is reconciled with the state of the tree — it described a first run of something the template does not stand up.

## [2.9.0] - 11/08/2026

### Added

- **`code/docs/architecture/PROVIDER-NEUTRALITY.md` — the rule for deciding what a dependency actually is.** Three kinds, and they are not interchangeable: a **protocol seam** (the code is written against a published wire format or API — S3, the Prometheus exposition format), an **adapter seam** (the code is written against an interface this project defines, with an implementation behind it), and **substrate** (the code is written against the product itself, and swapping it is a rewrite). Includes the evidence a neutrality claim owes before it is allowed to stand, and the standing rule that **one adapter is a hypothetical seam; two are real**.
- **`code/docs/architecture/BUILD-OPERATE-SEAM.md` — where a fact lives when three owners each hold part of it.** The code, the server contract, and the deploy repository routinely share one infrastructure fact between them. This names which part belongs to which, gives the two bridge shapes, and states the same-change rule that keeps the three from drifting.
- **`how-to/src/PLATFORM-PROVIDERS.md` — the per-project register.** Every infrastructure dependency, the interface it sits behind, its seam kind, and whether it may be swapped. The rule is the same in every generated project; this file is the answer sheet and it is yours.
- **Eight Copier questions recording platform choices** — `HOSTING_PROVIDER`, `OBJECT_STORE`, `ERROR_TRACKING`, `LOG_AGGREGATOR`, `OBSERVABILITY_STACK`, `TRACING_BACKEND`, `ANALYTICS_PROVIDER`, `INCIDENT_TRACKER`. Each records a **choice, not a dependency**: the guides name the interface and treat the product as one implementation behind it, so a project answering differently is still on-doctrine. All eight carry defaults, so `copier update --defaults` is unaffected.
- **`code/src/scripts/audits/seam-contract.sh` and its CI job.** `how-to/src/SERVER-ARCHITECTURE/` is the contract the deploy repository implements against, so every section stating a requirement must say where that requirement came from. Two mechanical checks: every repository path named in a `**Source:**` field resolves, and every numbered section carries one.

### Changed

- **`SERVER-ARCHITECTURE/` sections now carry `**Source:**` fields**, which is what makes the audit above possible — a requirement with no source is a requirement nobody can verify or update when the thing it came from changes.
- **`LOGGING.md`, `PERFORMANCE.md`, `ARCHITECTURE-PATTERNS.md` and `CORE-AND-SCALING.md` name interfaces where they previously named products.** Structured JSON on stdout rather than a named shipper; the Prometheus exposition format rather than Prometheus; the Sentry SDK wire protocol rather than Sentry.
- **The `backend` and `planner` agents** consult the neutrality rule before writing a dependency into a design, rather than after review finds it.
- **`how-to/src/TEMPLATE-TOKENS.md` and `TEMPLATE-GUIDE/05-ANSWERS.md`** document all eight new questions, keeping the token contract complete.

## [2.8.0] - 11/08/2026

### Added

- **`code/docs/DISCOVERABILITY.md` and its four sub-documents.** `WEB-METADATA.md` owns the `build_seo()` head pipeline; `STRUCTURED-DATA.md` owns the JSON-LD block; `ROOT-SURFACE.md` owns the root and `.well-known` register; `CONTENT-STRUCTURE.md` owns the page **body**, the fourth output surface and the one nothing previously governed.
- **A clean split with `project-management/docs/SEO-CHECKLIST.md`, stated in both files.** The checklist is **what must be true per page** before a story closes. The guide is **how this stack does it**. Neither restates the other, which is the same route-don't-restate rule the pairing standard applies to directories.
- **A `_(not a gate item)_` convention in the checklist**, marking roughly nine rows that describe good practice but cannot gate a story, so the gate stays honest about what it actually blocks on.
- **`research/DISCOVERABILITY-SKILL-ECOSYSTEM.md`** — the primary-source survey the corrections below came out of.

### Removed

- **Three answer-engine myths, deleted rather than left unticked.** Google states there are **no additional requirements and no special optimisations** for AI Overviews and AI Mode, and no new machine-readable files. Removed from `SEO-CHECKLIST.md`: **content chunking for RAG**, **fan-out query coverage**, and **per-engine optimisation** — the last of which also named five specific products as a requirement, against the provider-neutrality rule this template holds elsewhere. Cited to Google's _AI features and your website_.

### Changed

- **`llms.txt` is re-justified, not removed.** `ROOT-SURFACE.md` Section 1 previously called it "the one leg of answer-engine discoverability", which is false — it is not a search or citation signal. It stays, justified honestly as **agent-facing**: for IDE agents and MCP clients that read rather than crawl, pointing at `code/docs/MCP-SERVER.md`.
- **`CONTENT-STRUCTURE.md` Section 1 states there is no separate answer-engine discipline**, cited to the primary source, so the myth cannot quietly return as a new section.
- **`.claude/agents/seo.md`** — the `llms.txt`-as-GEO-lever claim is marked in place at both occurrences. The remaining techniques in that agent are ordinary SEO and are untouched.
- **`how-to/src/BRAND-VOICE.md` Section 2 gains the reciprocal pointer** — shape is not voice. Content structure decides how a page is organised; the voice guide decides how it reads.

### Fixed

- **`WEB-METADATA.md` said content structure was "not settled doctrine here yet".** It now routes to the guide that settles it.

## [2.7.0] - 11/08/2026

### Added

- **`code/docs/NEGATIVE-SPACE.md` — the owning guide for what the code must never allow.** The governing principle, what counts as an invariant, the **enforcement-point register** in two halves, the invariant classes, the soft-delete trap, the one case where a constraint firing is not a bug, the three-class error taxonomy, and the guard clause. Every surface clause routes to the guide that already governs that surface rather than being restated here.
- **`how-to/src/INVARIANTS.md` — the per-project register.** Each invariant gets **exactly one named enforcement point**, database-enforced and service-enforced listed apart, with a worked row for shape and a section on what keeps the file true. The rule is portable; the register is yours.
- **`code/src/django/apps/core/` — the module the doctrine needs to exist.** `services/errors.py` carries `InvariantViolation` deliberately **outside** the `ServiceError` tree, because a broken invariant is a programmer error and must never be catchable as a user-facing failure. `schemas.py` provides three bases, one per API surface — `Schema` for request bodies, which is the one that carries `extra="forbid"`, plus `OutSchema` for responses and `QuerySchema` for query params, where forbidding extras would be wrong. `middleware.py` adds `RequestIDMiddleware` and `current_request_id()`.
- **`RequestIDMiddleware`, and the trust boundary it draws.** It reads the edge's `X-Request-ID` and mints a UUID4 only when one is absent or malformed. Inbound values are treated as untrusted — bounded alphabet, 200-character cap. The value lives in a `ContextVar`, not on the request object, so anything below the view can reach it without being handed a request.
- **A third invariant class enforced by the ORM's own errors.** `string_if_invalid` is set in dev and test only. Django's behaviour settles it: a non-empty value stops filters applying to invalid variables, and `{% if %}`, `{% for %}` and `{% regroup %}` read an invalid variable as `None` and never consult it. The production template surface therefore has **no loud failure by construction**, and that is recorded as an honest gap rather than papered over.

### Changed

- **`assert` is banned outside tests, and ruff now enforces it.** `S101` is no longer globally ignored; it is exempted per path for `*/tests/*` and `conftest.py` and nowhere else, and a `# noqa: S101` is a finding. Three reasons, all in the guide: an `assert` cannot carry the register key, it is indistinguishable from a failing test in the error tracker, and `python -O` strips it. Guard clauses `raise`.
- **`ninja.Schema` is banned by ruff `TID251`.** Django Ninja silently ignores unknown request-body fields by default; `extra="forbid"` fixes that and propagates by subclassing, so the only way to bypass it is to import `Schema` from `ninja` directly. `apps/core/schemas.py` is the one module allowed to.
- **`N818` yields to the taxonomy on two names.** `InvariantViolation` and `DependencyUnavailable` are not `*Error` on purpose: neither is a `ServiceError`, and the names carry that. `DependencyUnavailable` also avoids colliding with `EnvironmentError`, a built-in alias of `OSError`.
- **A breach surfaces as a 500 and a tracker event, never a friendly 4xx.** Added to `.claude/CLAUDE.md` Section 6 as a non-negotiable, alongside the existing database-level-invariants rule it completes.
- **HTMX error handling is split by taxonomy class.** HTMX swaps on 2xx only, so a 500 replaced nothing at all. User errors keep the shipped 200-re-render; 500 and 503 go to **one global `htmx:beforeSwap` listener**, never a per-element handler.
- **The Rust surface denies the three panicking macros `panic = "deny"` does not cover.** `todo`, `unimplemented` and `unreachable` all live in clippy's `restriction` group, which `all` excludes, so each is denied by name in both crates. `unreachable!()` is included deliberately: a window that vanishes is no better for being unreachable in theory. `slint-build` emits `todo!()` into generated code, so the desktop crate's generated-code allow list is extended to match — the boundary the strict table draws stays exactly where it was.

### Fixed

- **`code/src/rust/Cargo.lock` is now committed.** A workspace with binaries needs its lock file in version control; without it the desktop and native builds resolved differently on every machine.

## [2.6.0] - 11/08/2026

### Added

- **`how-to/src/BRAND-VOICE.md` — how the project speaks, settled before the first feature.** Tone, the four registers, casing, punctuation, and the machine-authored tells that are banned outright. It ships as a template: Section 1 and Section 4 are the portable core, adopted unchanged; Section 3 and Section 5 carry placeholders for this project's own voice. Six agents and the `stack-htmx-templates` skill load it for every user-facing string.
- **`code/docs/VISUAL-DESIGN.md` — the same doctrine in composition rather than copy**, with per-surface sub-documents under `code/docs/visual-design/` (`WEB.md`, `MOBILE.md`, `DESKTOP.md`). Section 3 pins a **named visual direction** on six axes, and it is what makes Section 4.2's ban list decidable at all: without a direction there is no such thing as a deviation from it. Section 4.1 bans the universal tells on every direction; Section 5 is a numeric motion standard — frequency first, duration ceilings, easing as a hierarchy rather than a preference, and reduced-motion as fewer and gentler rather than none.
- **Four deterministic slop gates, split by input.** `copy-slop.sh` takes prose, `css-slop.sh` takes stylesheets, `template-slop.sh` takes Django markup, and `render-slop.sh` takes a viewport — the last because the repeated-device clauses in Section 4.1 cannot be decided by any static scan. Each ships a CI workflow.
- **Two tiers in one run, following `cloc.sh`'s warn-at-750 / fail-at-800 precedent.** `[gate: fail]` is an unambiguous match and exits 1; `[gate: warn]` is a threshold, a ratio, or a word that is sometimes correct English, and is reported without failing. The tier scheme and its rationale live in `VISUAL-DESIGN.md` Section 6, which is also the list of what a script can and cannot decide.
- **`code/src/scripts/desktop/style-check.sh` and its CI job** — the Slint surface picks a style whether or not you name one, so the build script now names it and the gate holds it. Copier-excluded on a project without the desktop surface, because a workflow shipped without its script is a permanently red job on every web-only project.
- **`README.md` Section _Influences and attribution_ and `THIRD-PARTY-NOTICES.md`.** The design doctrine, the copy rules and the audit scripts derive from an open skill ecosystem; those sources are named with their licences. `THIRD-PARTY-NOTICES.md` is the separate, narrower obligation: the files that contain substantial portions of someone else's licensed work, carrying the notice that licence requires. It ships into every generated project, because the adapted files do and `LICENSE` is copier-excluded.
- **`research/ANTI-SLOP-RULE-SOURCES.md`** — the per-claim citations behind every derived rule, so the reasoning stays checkable.

### Changed

- **Two new non-negotiables in `.claude/CLAUDE.md` Section 6, both about attribution.** Doctrine derived from an outside source is credited in the **same change** as the rule it credits — attribution written once decays, written alongside it stays true. And: use, adapt and redistribute are three different permissions. A share-alike source may be **read** as a checklist of concerns, but its text and rule wording may never be derived into anything this template redistributes, because every generated project would inherit the obligation. The licence column is consulted **before** deriving.
- **The first-time-setup ordering now has four prerequisite passes, not two** — project brief → brand voice → visual direction → `/scale-planning`, in that order, because each depends on the one before and the later documents are themselves written in the voice the earlier one settles. All four are cheap before the first feature and expensive after the tenth.
- **`DESIGN.md` and the four design workflows (`06`, `07`, `08`, `17`)** route to the two new guides rather than describing taste in their own words.
- **The desktop surface composes its own look.** `build.rs` names Fluent explicitly — from Slint 1.16 the fallback is Fluent on every platform, so saying nothing shipped a vendor look on macOS and Linux that nobody chose — and `app.slint` reads colour and rhythm from `Palette` and `StyleMetrics` so the built-in widgets stay structural scaffolding rather than the design itself.

### Fixed

- **`copy-emdash.sh` and `css-gradients.sh` cited a section that has since split.** Both predate the four new gates and pointed at `VISUAL-DESIGN.md` Section 4, which now has two halves that mean different things. Each now names Section 4.1 — a universal tell, banned on every direction and every surface — rather than the parent section that also contains the per-direction deviations.

## [2.5.0] - 11/08/2026

### Changed

- **Grilling asks in frontier rounds, not one question per message.** The **frontier** is every question whose prerequisites are already settled. All of it goes into a single numbered message; the agent then stops and waits. The answers settle decisions, which pushes the frontier outward and unblocks questions that were previously unanswerable, and the next round is recomputed from there. The old mechanic made a ten-decision design cost ten exchanges, each carrying the full re-orientation overhead, and it is now named as an explicit anti-pattern along with its opposite — front-loading questions whose answers would only be guesses.
- **`.claude/skills/grilling/SKILL.md` owns the interview's shape, and nothing else restates it.** The round mechanics, the exact question format, and the recommendation rule live in that one file. Every agent, workflow and skill that opens a grilling pass now names **what** must be settled and routes to the skill for **how**. This is the fix for a specific failure: the mechanic was restated across dozens of files, so changing the skill alone would have left every one of them contradicting it.
- **The question format is fixed and stated once.** Numbered, titled, brief options, and an explicit `➡️ Claude recommends N` with its reason in one line. Always recommend, always justify, and never soften the recommendation because the answer leaned the other way — sycophancy is called out in the skill as a failure mode, not a courtesy.
- **A lookup in flight never blocks a round.** The rule is now explicit: treat it exactly as an unanswerable question — hold it for the next round and ask the rest immediately.
- **`.claude/CLAUDE.md` Section 10 no longer describes the interview.** It states that substantial work in every layer opens with a grilling pass, that this supersedes every static _Clarify Before Planning_ / _Required Information_ / _Clarifying questions_ checklist project-wide, and routes to the skill. A restatement drifts the moment the skill changes.

### Added

- **`AskUserQuestion` is denied in `.claude/settings.json`.** Questions are asked in the chat as prose, so an answer can be a number, a counter-proposal, or a redirect in the reader's own words — none of which a multiple-choice widget accepts. The deny entry removes the widget only: the _take no action until confirmed_ gate comes from the grilling rule, not from the tool being absent.
- **Two project-memory entries recording both decisions** and, more importantly, the standing rule they produced: route for the mechanic, never restate it.

### Fixed

- **Agents and workflows that promised an interview the skill no longer runs.** Fourteen agents, five workflow `STEPS.md` files, seven skills and two template-guide pages each described the one-question-at-a-time mechanic in their own words; all now route to the skill instead.

## [2.4.0] - 11/08/2026

### Added

- **`code/docs/DOCUMENTATION-PAIRING.md` — the owning guide for a rule that had no home.** The split was stated in three places (root `CONTEXT.md`, `.claude/CLAUDE.md`, and by example in every folder) and owned by none, which is the condition under which a rule drifts. The guide states it in one sentence — _`CONTEXT.md` says what is here and why it is here; `CLAUDE.md` says how to work here_ — then gives the decision test for a sentence that could go in either, the headings that never belong in an orientation file, and the route-don't-restate rule that keeps a fact in exactly one place.
- **`code/src/scripts/audits/docs-pairing.sh` — the mechanical half, enforced.** Checks the pairing both directions, the four required `CLAUDE.md` H2s, the `@./CONTEXT.md` import, the `Read order:` line, and the banned orientation headings. Wired into CI as _Audit — Docs Pairing_ and into `lefthook.yml` at pre-commit. Deliberately **unscoped**: the checks are cross-file, so a per-file run cannot see a `CLAUDE.md` whose `CONTEXT.md` was just deleted.
- **`code/src/scripts/audits/docs-length.sh` — the 300-line instructional cap gets its own gate.** Measured in `cloc` code lines over `**/docs/**/*.md`, `**/workflows/**/*.md`, `.claude/**/*.md` and every `CONTEXT.md`/`CLAUDE.md`. Root-level `*.md` and `**/src/*.md` are exempt — a README and an operator guide are read by humans start to finish, and capping them optimises for the wrong reader. A `CONTEXT.md` or `CLAUDE.md` inside an exempt tree is still bound. CI job: _Audit — Docs Length_.
- **`code/src/scripts/development/sync-trees.sh` — Directory Tree blocks reconciled at commit time.** Scoped to `--staged`, so a one-file commit does not walk 195 trees. It **adds** a missing row and never deletes one: a row naming something absent is usually a gated surface or a naming pattern, not drift. An added row carries `← TODO: what this is and why it is here` and **fails the commit** — the description gets written while the author still knows the answer, which is the only moment anyone ever does.

### Changed

- **`cloc.sh` no longer measures Markdown, and the rule now says so.** It excludes Markdown by design, so pointing the instructional cap at it measured nothing. `.claude/CLAUDE.md` Section 8 now names `docs-length.sh` explicitly and states the exemptions, because the previous wording sent every reader to the one script that could not answer.
- **Every `CLAUDE.md` in the tree conforms to one shape** — `@./CONTEXT.md` (plus `@./REFERENCES.md` where the directory has one), a `Read order:` line, then exactly four H2s: _Purpose (one line)_ · _How to work here_ · _Guardrails_ · _Output & naming_, scaled to the folder.
- **Every workflow `CONTEXT.md` conforms too.** _Hard gates — read before executing Step 1_ / _Soft references — consult during execution_ became **Governing documents** / **Related reading**: the old names described when to read a file rather than what it is, which is an operating rule wearing an orientation file's clothes. `Prerequisites`, `Quality gates` and `Naming` headings are gone from orientation files for the same reason — each now lives once, in the paired `CLAUDE.md` or the workflow's `CHECKLIST.md`.
- **Each orientation file opens by saying why the thing it describes exists**, rather than starting cold with a tree. A directory listing tells you what is there; it does not tell you why you would go.
- **`.markdownlint-cli2.jsonc` and `.prettierignore` exclude `**/reports/**`and`code/src/rust/target/`.** An audit run with `--output md` was capable of failing the format gate it exists to complement.

### Fixed

- **Workflow headings left stale by the 2.0.0 renumber.** `## Workflow 13 — Decisions (ADRs)` in `workflows/14-decisions/`, and its siblings across the PM layer, named the number the folder had before that release.

## [2.3.1] - 03/08/2026

### Fixed

- **`.copier/` survived an update, leaving four stray staging files in the project.** 2.3.0 began shipping the root version files from a `.copier/` staging directory that a post-generation task moves into place and removes. Those tasks run on `copier copy` and never on `copier update` — which is what makes the seeds seed-once, and is therefore the point — but it also meant an updating project received `.copier/CHANGELOG.md`, `.copier/RELEASES.md`, `.copier/VERSION` and `.copier/VERSION-HISTORY.md` and simply kept them. Harmless to the build, actively confusing to read: four files that look like the project's version state, sitting next to the real ones.
- **Fixed with a `_migrations` entry that removes `.copier/` after any update.** Deliberately not version-scoped: it must hold for every future release that stages a file this way, not only the one that introduced the problem. `rm -rf` on a normally-absent directory is a no-op, so running it on every update costs nothing.

Caught by updating a real project rather than by review — the same lesson as 2.1.1, which is that a mechanism split across `copy` and `update` needs exercising on both paths before it ships.

---

## [2.3.0] - 03/08/2026

### Fixed

- **Every generated project inherited syntek-base's version and release history.** `VERSION`, `CHANGELOG.md`, `RELEASES.md` and `VERSION-HISTORY.md` shipped from the repo root unmodified, so a brand-new project declared itself version `2.1.1` and its changelog documented twenty releases of the template's own development. Verified against the four projects generated before this release: each carried twenty `CHANGELOG.md` entries, twenty `RELEASES.md` sections and twenty `VERSION-HISTORY.md` rows, none of which were theirs.

### Changed

- **Root version state is now seeded fresh from `.copier/`.** The four files are `_exclude`d from generation and shipped from a staging directory that a post-generation task moves into place, exactly as `README.md` already worked. A new project starts at `0.1.0` with one entry describing its own scaffold.
- **Seeded once, never updated.** `_tasks` run on `copier copy` and never on `copier update`, so a template update can no longer overwrite a project's release history with the template's. The corollary is deliberate and now documented: template improvements to those four files never reach an existing project either — they are the project's own from the moment it exists.

### Added

- **Two CI assertions in `Audit — Template Integrity`.** _A generated project starts fresh at 0.1.0_ checks `VERSION`, requires exactly one entry in each of the three history files, and confirms the `.copier/` staging directory was removed. _Sub-package version files are pinned at 0.1.0_ checks that `code/src/django/` and `code/src/mobile/` version documents remain single-entry seed content.
- **The rule, written down where it cannot leak downstream.** `CONTRIBUTING.md` Section 1b: in this repository a version bump edits exactly six root files and never a versioning document elsewhere in the tree. The sub-package documents are seed content for generated projects and stay pinned at `0.1.0`; bumping them here would hand every new project a sub-package history describing the template's development. Scoped to syntek-base — a generated project has real sub-packages that legitimately release on their own tracks.
- **`VERSIONING-GUIDE.md` → _Your version history is yours_**, explaining the seed-once mechanism and its trade-off to the people who inherit it.

---

## [2.2.0] - 03/08/2026

### Added

- **`code/src/scripts/audits/template-orphans.sh` — detects artefacts a template update stranded.** When a release renumbers or moves a directory, Copier relocates the scaffolding it owns and deletes the old path, but developer-authored files were never template files, so they stay behind. No conflict is raised, nothing fails, and the update reports success. Every template-owned directory under `project-management/src/` ships a `CONTEXT.md`, which makes the signature exact: **content present, `CONTEXT.md` absent**. Wired into CI as `Audit — Template Orphans`.
- **`code/src/scripts/development/template-update.sh` — preview an update before it touches anything.** Clones the project to a scratch directory, runs the update against the copy, and reports what changes, what is deleted, what conflicts, and what would be orphaned. Refuses to `--apply` when orphans are predicted unless `--force-orphans` is given. This is `14-UPDATING.md`'s "diff in a scratch directory first" advice turned into one command, because prose nobody executes prevents nothing.
- **`copier.yml` → `_migrations`, with a v2.0.0 entry.** Copier has supported migrations since 9.0.0 and this template required 9.0.0 without using them. The new `.copier/migrations/v2.0.0-renumber-src.sh` moves developer artefacts out of the twenty folders that 2.0.0 renumbered and into their replacements, preserving sub-paths, never overwriting on a name collision, and idempotent on re-run. Anyone still on 1.x now gets their stories and ADRs carried across instead of silently stranded.

### Changed

- **`project-management/src/` folder numbers are frozen — append only.** The distinction that was missing: a `workflows/` folder is a **procedure**, wholly owned by the template, so renumbering it is a reference sweep whose worst case is a broken link. A `src/` folder is a **data store** holding work the template has never seen, so renumbering it is a schema migration Copier cannot perform. A new artefact folder now takes the next free number at the end even where that breaks the workflow↔`src` mirroring — the mirroring is a convenience, the developer's work is not. Recorded in `project-management/src/CONTEXT.md`, `src/CLAUDE.md`, `workflows/CONTEXT.md` and `workflows/CLAUDE.md`.
- **Any release that must move a directory holding developer artefacts ships a migration in the same commit.** Stated in `copier.yml` beside `_migrations` and in `12-EXTENDING.md`.

### Fixed

- **`12-EXTENDING.md` told you PM workflow numbers were not a sequence.** They are — that layer's numbers are a running order, unlike `code/workflows/` and `how-to/workflows/`, whose numbers are stable identifiers. The guide now distinguishes all four trees, including the frozen `src/` rule.
- **`14-UPDATING.md` and `15-TROUBLESHOOTING.md` documented conflicts but not the silent failure.** Both now lead with it, including a "my stories vanished after an update" entry that names the audit and the recovery.

---

## [2.1.1] - 03/08/2026

### Fixed

- **The template-integrity CI probe could not generate a project.** `PROJECT_DESCRIPTION`, added in 2.1.0, has no default, so the `Audit — Template Integrity` job's `copier copy --defaults` invocation failed with `Question "PROJECT_DESCRIPTION" is required` before any of its assertions ran. Both render paths now pass the new question, and so does the equivalent snippet in `.github/PULL_REQUEST_TEMPLATE.md`, which had the same gap and would have sent every contributor down the same dead end.
- **No effect on generated projects.** Both files are in `copier.yml` → `_exclude`, so nothing a generated project holds changes in this release; `copier update` from 2.1.0 to 2.1.1 is a no-op beyond the version metadata.

---

## [2.1.0] - 03/08/2026

### Added

- **`PROJECT_DESCRIPTION` — a Copier question for the project brief.** One or two sentences on what the project does, who it is for, and what it replaces. It opens the root `CONTEXT.md` under a new _What this project is_ heading, and because `.claude/CLAUDE.md` imports that file it becomes the first thing every agent reads in every session. It also fills the `description` field of `pyproject.toml` and `package.json` (neither had one) and the blurb in the generated `README.md`. Two validators: a 40-character floor, because a tagline is not a brief, and a rejection of double quotes, because the value lands in two manifests.
- **Describe-then-size runs before the first feature.** `how-to/workflows/01-first-time-setup/` gains Steps 7 and 8, which run once per project after the stack is up and before anything is charted: sharpen the generated brief into a real one (what it does, who for, what it replaces, what it deliberately is **not**), then run `/scale-planning`. The value of the second is not the server tier — it is forcing the sizing questions while they are still cheap, and producing the explicit **not required** list that stops the first feature carrying machinery it will never use. `01-feature` lists both as prerequisites and reads `SCALE-ARCHITECTURE/` as ground truth; neither is a hard gate, because charting without them is possible — it just surfaces every sizing question as a decision node, one feature at a time.
- **`GAPS.md` and `DEFERRED.md` are read at the discovery gate, not only written.** A new `/wayfinder suggest` mode mines the standing register for candidate features, clustering entries by shared cause, surface, or dependency — five deferrals waiting on the same missing table are one feature, not five — and puts them to the developer ranked. Charting then triages **every** open entry against the feature being planned: **closes** (recorded under a new _Register claimed_ section on the map, and part of what "done" means), **blocks** (a frontier node, not an assumption), or **unrelated** (counted, so the triage is provably exhaustive).
- **The claim/close boundary.** `01-feature` claims a register entry; `21-implementation-documentation` closes it against shipped code, and is now the only place that marks `✅ CLOSED` or removes a `DEFERRED.md` row. A claim the story did not in fact retire stays open, and the reason becomes a finding. A claim is a promise; a close is evidence.

### Changed

- **Code comments and docstrings carry the _why_ only.** The canonical standard (`.claude/skills/global-workflow/VERSIONING-AND-DOCS.md` Section 4, mirrored in `code/docs/coding-principles/STYLE-AND-PROCESS.md`) previously mandated the opposite in three places — "what it does (not how)" for docstrings, and inline comments explaining "**what** and **why**". The code states the what; a comment restating a name or a type is a duplicate fact that drifts. Docstrings are now one line on why the thing exists, with no `Args:`/`Returns:`/`Raises:` block, because the typed signature already carries them.
- **A comment never points outside its own file.** No story (`US###`), sprint, ADR, plan, bug record, ticket, PR, commit, `code/docs/*` path, URL, person, or date — the reason must travel in the comment, because a reader who cannot open the reference still has to understand why. Scope is application source that ships in a deployable; declarative configuration and `code/src/scripts/**/*.sh` are exempt, because there the reference **is** the content. The one exception is published interface text: Django Ninja endpoint docstrings and `summary` render on the OpenAPI page, and a FastMCP tool docstring is the prompt a model reads, so both state the full what.
- **`TODO`/`FIXME` are no longer permitted in committed code.** The old rule required a ticket reference, which is exactly the outward pointer now banned. Deferred work goes to `DEFERRED.md` or `GAPS.md`, which are read and triaged.

### Fixed

- **Broken token substitutions across sixteen files.** The de-tokenisation pass left three distinct defects: paths concatenated with their filename (`` `the project's plans folderPLAN-US000-TEMPLATE.md` ``), placeholder prose where a number belongs ("next free number is `` `a decision record` ``", and in `wayfinder` the doubly-garbled "a new ADR — the project's decision register (next free number is the project's decision register)"), and prose standing in for a path. All now resolve to `project-management/src/14-DECISIONS/` and `.../16-STORY-PLANS/`, verified to exist on disk.
- **Origin-project references leaking into the template.** `wayfinder` cited "the Design Studio epic … US208–US214" and `prototype` cited `PLAN-US207-DESIGN-STUDIO.md` as live worked examples; the template ships no stories, so both were dangling. `MAP-SCALE-PLANNING.md` was placed in the plans folder in four files — it is a map, so it belongs in `src/01-FEATURE/`.
- **`PLAN-US###` normalised to `STORY-PLAN-US###`** in six files, matching the naming convention the PM layer has always used.
- **Five comments in the shipped Django, mobile, Rust and Slint skeletons** pointed at `code/docs/*` paths, in breach of the standard added above. Each reworded so the reason travels in the comment.
- **Copier question counts were stale in three guides** — `TEMPLATE-TOKENS.md` claimed twenty-four tokens and `05-ANSWERS.md` twenty-four questions when the real figure was twenty-nine; `06-GENERATION.md`'s pipeline diagram still said twenty-one. All corrected to thirty (twenty-six always asked, four conditional on the optional surfaces).

---

## [2.0.0] - 03/08/2026

### Added

- **The planning cadence is now explicit: plan one story at a time, all the way through.** A story runs `02-story-creation` → `14-decisions` before the next one starts, so each story is planned against everything the previous ones settled. The rationale is recorded where the loop lives (`project-management/workflows/CONTEXT.md`): a human thinks the work through at plan time so implementation is mechanical. It assumes real PM and development knowledge — and the gate sequence is what carries someone who does not yet have it.
- **A sprint is planned when it fills, not at the end of a backlog-wide checks phase.** Each story clearing `13` is slotted into the open `SPRINT-##.md` with its points; at `SPRINT_CAPACITY_SP` (grace `SPRINT_GRACE_SP`) planning pauses while `15-sprint-plans` and `16-story-plans` run for that sprint, then resumes. Canonical rules and the ceiling: `project-management/docs/PLANNING-GUIDE.md` → _Sprint Capacity_.
- **Two Copier questions — `SPRINT_CAPACITY_SP` (11) and `SPRINT_GRACE_SP` (13)**, with a validator forcing grace above capacity. These close a real hole: `.claude/agents/sprint.md` already claimed the guide defined a point ceiling, and it never did.
- **`project-management/workflows/01-feature/` and `src/01-FEATURE/` — discovery, once per feature.** Wayfinder charts the feature's decision frontier, then each node is settled one at a time and graduated to an ADR, plan, or story. The resolved `MAP-<FEATURE>.md` is what stories are cut from, and what stops every later grilling pass re-asking the same cross-cutting questions. Its reading order is deliberate: `CONTEXT.md` → `CLAUDE.md` → the relevant `docs/` guides → **the whole of `project-management/src/`** → the codebase. Because every story closes with `IMPLEMENTATION/` records stating where the build diverged from the plan, reading `src/` shows what was actually built rather than what was once intended.
- **`how-to/src/TEMPLATE-GUIDE/09-PROJECT-MANAGEMENT.md`** — how to use `project-management/src/`: the five tiers, the workflow↔`src` mirroring, the three-stage vs two-stage folder patterns, a which-folder-when table, and the four ways people get it wrong. `09-FIRST-STORY.md` became `10-FIRST-FEATURE.md` and now opens by charting the feature, because work no longer starts with a story.
- **`project-management/docs/planning/`** — `CADENCE.md`, `STORIES.md`, `SPRINTS.md`, behind the thin `PLANNING-GUIDE.md` index, on the `GDPR-GUIDE.md` → `gdpr/` precedent. The capacity figure is stated once, in `CADENCE.md`.
- **`project-management/workflows/17-consolidate-design-work/`** — the second half of the per-story bargain. Planning per story means design arrives per story and drifts by construction; once every story is through `15`, this workflow reconciles it into one coherent design before any code. It resolves `04-DATABASE` first, because schema fragmentation is the expensive kind, and its Step 7 corrects any story plan the consolidation invalidated — otherwise the developer codes from a plan asserting a superseded design.

### Changed

- **PM workflows renumbered again, +1 across the board** (`01`–`22` → `02`–`23`) to open `01` for the feature-discovery gate, and `src/` `01`–`20` → `02`–`21` alongside it so the `01`–`16` workflow↔`src` mirroring survives. ~2,455 references across every layer. `code/workflows/` and `how-to/workflows/` numbering is untouched — those are catalogues, where numbers are stable identifiers.
- **`SPRINT-PLANNING-GUIDE.md` → `PLANNING-GUIDE.md` + `planning/`.** The old name had stopped describing its contents once the cadence — which governs `01`–`17`, not sprint planning — moved into it.
- **`12-seo-checks` is now a planning gate, not a verification one.** It sat in the specify tier but required a deployed page, which made it impossible to run in its own slot. It now sets per-dimension SEO targets before the page exists; auditing the built page, Lighthouse, and the `IMPLEMENTATION/` record moved to `21-implementation-documentation`, which already owned every other implementation record. Its model moves Opus → Fable, because choosing a schema type and an indexing posture is judgement, not measurement.

- **`src/04-DATABASE` … `src/08-WIREFRAMES` are now three-stage:** `USER-STORY-IDEAS/` → `CONSOLIDATED-IDEAS/` → `IMPLEMENTATION/`. Stage 1 is **frozen** once workflow `16` runs — it is the audit trail of what each story asked for. Stage 2 is **what gets built**. Each folder keeps one cumulative asset outside the stages (`ERD-DIAGRAMS/`, `DIAGRAMS/`, `guide-build/`, `component-build/`, `SHARED/wireframe.css`); the brand and component PDFs are regenerated once, at consolidation, not per story. `08-WIREFRAMES/SCREENS/` is absorbed into the stage folders.
- **Folders `09-GDPR` … `13-API-DESIGN` keep their two-stage `PLANNING/` + `IMPLEMENTATION/` split.** A lawful basis or an API contract is genuinely per story and does not fragment a shared system, so it needs no consolidation pass.
- **PM workflows `16`–`21` renumbered to `17`–`22`** to make room at `16`. Unlike `code/workflows/` and `how-to/workflows/` — catalogues where numbers are stable identifiers and are never reused — PM workflow numbers are a **running order**, so inserting mid-sequence is legitimate here. 413 references updated across 161 files. Historical entries in this file and `RELEASES.md` are left as written: they record what those releases actually shipped.

### Removed

- **`project-management/docs/SPRINT-PLANNING-GUIDE.md`** — replaced by `PLANNING-GUIDE.md` and `planning/{CADENCE,STORIES,SPRINTS}.md`.
- **`project-management/src/08-WIREFRAMES/SCREENS/`** — absorbed into the three-stage folders: per-story screens to `USER-STORY-IDEAS/`, the built set to `CONSOLIDATED-IDEAS/`.

### Fixed

- **Twenty `IMPLEMENTATION/` folders credited `pr-and-review` for writing their records.** Workflow `21-implementation-documentation` explicitly absorbed that duty — its own `CONTEXT.md` says the PR workflow "now only **verifies** these records". Every one now routes correctly.
- **Three workflows had no grilling pass at all** — brand guides, wireframes, and sprint plans — despite `.claude/CLAUDE.md` Section 10 making it the default for substantial work. Each now opens with one.
- `.claude/skills/wayfinder/SKILL.md` referenced the map as `` `the project's plans folderMAP-<EPIC>.md` `` — a token substitution that had lost its separator. Maps now resolve to `src/01-FEATURE/`.
- `21-implementation-documentation/CONTEXT.md` was still titled "Workflow 19".

- `PLANNING-GUIDE.md` documented sprint plans as `SPRINT-PLAN-##.md`; `src/15-SPRINT-PLANS/` has always used `{exec-order}-SPRINT-PLAN-{sprint-number}.md`. The guide now matches, and explains why the two segments diverge.
- `how-to/src/TEMPLATE-GUIDE/06-GENERATION.md` claimed twenty-one Copier questions; there were twenty-seven before this change and are now twenty-nine.

---

## [1.2.0] - 02/08/2026

### Added

- **An optional native desktop surface, gated by the new `INCLUDE_DESKTOP` question.** A **Slint** application at `code/src/rust/crates/desktop/` — a real native binary, not a webview or an Electron shell. The question is only asked when `INCLUDE_RUST` is true, because Slint is Rust, and both default to `false`.
- **It is a member of the existing Rust workspace, not a second one.** `members = ["crates/*"]` is a glob, so the workspace adapts with no edit and there stays exactly one `rust-toolchain.toml`, one `deny.toml` and one `clippy.toml`. `slint` is pinned in the crate rather than `[workspace.dependencies]`, since one member uses it. Lint, test, audit and build therefore come from the existing Rust script group — `code/src/scripts/desktop/` carries only the two genuinely desktop-specific operations, `run.sh` and `package.sh`.
- **`desktop` agent, `stack-slint` skill, `code/docs/DESKTOP.md` + two sub-docs, and `code/workflows/13-desktop-app/`** — all excluded together with the crate.

### Changed

- **`deny.toml` now carries Slint's licence exceptions and two accepted advisories.** These are unconditional, because no file in this template has conditional contents; on a project without the desktop surface they match nothing and cargo-deny reports an informational note rather than an error.
- **`code/src/` describes four surfaces.** Desktop is a distinct _surface_ (its own delivery target and release cycle) inside a shared _workspace_ — the first time those two ideas come apart in this repository, and worth reading `code/src/CONTEXT.md` for.

### Security

- **Two `quick-xml` advisories (RUSTSEC-2026-0194, -0195) are accepted, with justification and a re-check date.** Both are denial-of-service issues reached **only** through Slint's accessibility stack (`accesskit_unix` → `atspi` → `zbus_xml` → `quick-xml`), and every version pin up that chain to Slint's own `=1.17.1` blocks the patched 0.41.0. The parser handles D-Bus introspection XML from the **local** AT-SPI session bus, not network or user input; an attacker able to publish malicious XML there already owns the session. **Removing AccessKit is not the mitigation** — it is what makes the app usable with a screen reader. Re-check 02/11/2026.
- **`unmaintained` is now scoped to `workspace`.** You can act on your own direct dependency choices; you cannot act on one buried three levels inside a GUI toolkit, and a permanent ignore list of other people's transitive crates rots silently.

### Licensing — read before enabling

- **The app ships under Slint's Royalty-free tier**, which permits proprietary **and commercially sold** desktop applications at no cost, in exchange for **disclosing that you use Slint**. The `AboutSlint` widget is that disclosure and `code/src/scripts/desktop/package.sh` refuses a release build without it — a licence gate, not a lint.
- **The tier does not cover embedded systems** (an appliance screen, a POS terminal, a car dashboard), **nor redistributing anything that exposes Slint's own APIs.** The second is why desktop UI is never moved into a shared package layer, and why desktop panels are duplicated across applications rather than shared. That duplication is a deliberate, priced decision.
- This is a reading of the licence text, not legal advice.

### Fixed

- Nothing. No defect is addressed in this release.

---

## [1.1.0] - 02/08/2026

### Added

- **An optional Rust surface, gated by the new `INCLUDE_RUST` question.** A Cargo workspace at `code/src/rust/` for PyO3 extension modules, standalone binaries, CLI tools and services — with `nativecore`, a baseline PyO3 crate, as its first member. It follows the `INCLUDE_MOBILE` precedent exactly: templated `_exclude` entries are the single conditionalisation mechanism, no file gains templated contents, and the indexes list the new rows unconditionally with a **rust-only** flag. A project generated with `INCLUDE_RUST: false` gets **no new or removed files** — verified by diffing a `1.1.0` web-only generation against a `1.0.0` one. Sixteen files differ in content: the documentation indexes gaining flagged rows, the version metadata, and one comment in `pyproject.toml`. The tree is unchanged; it is not byte-identical, and that distinction matters when reviewing a `copier update` diff.
- **The flag gates authoring, not consuming.** A project that merely depends on a prebuilt PyO3 wheel installs it like any other dependency and needs no toolchain — it answers `false`. `true` means _this repository compiles Rust_, which makes `rustup` a prerequisite for `uv sync` and adds a Rust stage to the backend image. That cost is why the default is `false`, and why the distinction is stated in `TEMPLATE-TOKENS.md`, `05-ANSWERS.md`, the guide, the skill and the agent.
- **`rust` agent and `stack-rust` skill**, excluded together with the tree — a Rust agent with no Rust to work on is worse than no agent at all. Both carry the gate question as their opening move: Rust earns its place only on a guarantee Python cannot make, or a **measured** hot path.
- **`code/docs/RUST.md` and three sub-documents** — `rust/PYO3-BOUNDARY.md` (never panic across FFI, thin-boundary shape, error mapping, the GIL, `abi3`), `rust/MEMORY-HYGIENE.md` (why Python cannot erase a secret, zeroize-on-drop, constant-time comparison, and the limits it does _not_ cover — copies, swap, core dumps), and `rust/SUPPLY-CHAIN.md` (why a crate is more dangerous than a Python package, and what `deny.toml` enforces).
- **`code/workflows/12-rust-extension/`** — appended, never renumbered, per the stable-identifier rule. Entered from PM `18-backend-code`; Step 1 is a grilling pass whose first question is the gate.
- **`code/src/scripts/rust/`** — `build.sh`, `test.sh`, `lint.sh`, `audit.sh` plus `_common.sh`. The second script group keyed by stack rather than operation, and the second to run on the host rather than in Docker; the toolchain pin is what keeps a host run and the image's build stage identical.
- **`syntax-rust.yml`** — clippy at `-D warnings`, the Rust test suite, and `cargo-deny`. The workflow file is itself rust-only, so there is no job to guard on a project without the surface.
- **`code/docs/encryption/RUST-CRYPTO.md`** — the dual-path branch of the encryption guide.

### Changed

- **`code/src/` now describes three surfaces rather than two.** The native surface is the odd one: it has no separate runtime, because a PyO3 extension is loaded **into** the web surface's process and shares its address space. That is precisely why its supply chain is gated harder than any Python dependency.
- **Fernet remains canonical for field encryption.** Native crypto is a branch for what Fernet structurally cannot do — constant-time comparison, and wiping key material Python cannot erase — never a replacement. Keeping the two paths separate is deliberate: two implementations of the _same_ concern is a parity burden that drifts, whereas two covering _different_ concerns is a boundary. It also keeps `syntek-base` usable by anyone outside <%ORG_NAME%>, which a hard dependency on a private wheel would not.

### Fixed

- Nothing. No defect is addressed in this release.

---

## [1.0.0] - 02/08/2026

### Changed

- **The template is now stable.** The root version track leaves `0.x` and enters `1.0.0`. Nothing in the generated project changes as a consequence — this release is a **statement about support, not a code change**. The surface a generated project inherits is exactly the one 0.14.0 produced, and the two are functionally identical.
- **What `1.0.0` commits to.** From here the Copier answer file (`copier.yml`'s twenty-two questions, or twenty-four with the mobile surface), the three-layer directory contract (`code/` · `how-to/` · `project-management/`), the `CONTEXT.md` + `CLAUDE.md` pairing rule, and the numbered workflow identifiers are treated as the template's public interface. A breaking change to any of them now requires `2.0.0`, which is the guarantee the `0.x` track could not offer — under semver, `0.x` permits a breaking change in any minor bump, and this template used that latitude repeatedly (the workflow renumbers in 0.14.0 and the PM renumber in 0.8.0 would each have been a major bump under this policy).
- **The `0.1.0`–`0.14.0` track is reclassified as pre-release history.** Those fourteen versions are published as GitHub pre-releases; `1.0.0` is the first entry marked latest. The reclassification is presentational — the commits, the changelog entries and the release notes are unchanged.

### Removed

- **`.claude/MEMORY.md` emptied of its template-development entries.** It carried five notes accumulated while `syntek-base` itself was built — the "surface" vocabulary, the one-way optional-content gate, the Expo pin matrix, the `glob` override, and the expo-router route-collision rule. Every one is reasoning about **how the template was constructed**, which a generated project inherits as noise: it describes decisions already made, in a repository the reader is not working in. The file ships with its three headings (`Feedback`, `Project Patterns`, `Project State`) and its write-policy preamble intact, so a generated project starts recording against an empty store rather than deleting someone else's notes first. Where that reasoning is durable it already lives in the right place — `code/src/CONTEXT.md` defines _surface_, and `how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md` holds the gating rationale.

### Fixed

- Nothing. No defect is addressed in this release; `0.14.0` is the last release carrying fixes.

---

## [0.14.0] - 02/08/2026

### Added

- **`code/docs/MCP-SERVER.md` and its `mcp-server/` sub-tree** — the design of record for a FastMCP tool surface at `/mcp/`, serving LLM agent clients beside Django Ninja's `/api/`. Four sub-documents: `MOUNTING.md` (the `config/asgi.py` Starlette composition), `TOOL-DESIGN.md` (tools over the service layer), `AUTH-AND-THREATS.md` (`TokenVerifier` and the MCP threat model), `TESTING-AND-OPS.md` (in-memory `Client` tests, observability, rollout). **Nothing is mounted and `fastmcp` is not a declared dependency** — the same available-but-unwired status Django Ninja itself holds.
- **The two-adapter rule, stated once.** MCP tools and Ninja endpoints are peers over one service layer; neither calls the other and neither holds logic. Ninja alone made that seam hypothetical — a second adapter makes it real.
- **`.claude/skills/stack-fastmcp/`** — the MCP idioms, loaded on demand by `backend` (tools), `security` (the threat surface) and `test-writer` (in-memory client tests). No new agent: MCP tools are backend service-layer work, and the roster stays non-overlapping.
- **Five new `how-to/` workflows**, each mapping onto scripts that already exist: `04-database-operations` (backup, restore, reset, seed, users — 8 scripts that had no workflow), `05-testing-and-coverage` (8 runners), `06-quality-gates` (the 8 pre-PR gates + 7 audits), `07-dependency-updates`, and `09-write-operator-guide` — the meta-workflow for authoring operator documentation.
- **`.claude/agents/operator-docs.md`** — a specialist owning `how-to/docs/*` and `how-to/src/*`. Justified by three testable differences from `doc-writer`: different audience (running the system vs writing code), different length standard (`how-to/src/` is the sanctioned exemption from the 300-line cap), and different verification (a runbook is proven by executing it). Completes a three-way split with `support-articles`, which owns end-user help.
- **`.claude/skills/runbook/`** — the operator-doc craft: the fixed spine (purpose → prerequisites → steps with expected output → failure modes → rollback → verification), script-first command discipline, and the execute-to-verify rule.
- **`code/workflows/05-mcp-server/`** — the procedure, opening with a gate question (is an agent genuinely the caller, or would an HTTP client do?) and running through mount, verifier, tools, tests and hardening. Entered from PM `19-api-code`, never from a design gate.
- `/api/` and `/mcp/` documented as **machine prefixes** in `code/docs/URL-STRATEGY.md`, which previously named only the four human-facing surfaces. `/mcp/` is a sibling of `/api/`, never nested inside it.
- `fastmcp` added to the "deliberately NOT declared at baseline" register in `pyproject.toml`, with its trigger condition — an agent must carry out this project's domain operations, **not** "expose the API to AI".

### Changed

- `backend`'s remit widened from "Django Ninja endpoints" to "Django Ninja endpoints and the FastMCP tool adapter"; `security` and `test-writer` gained MCP routing lines. `code/workflows/CLAUDE.md` now describes eleven workflows, not ten.
- `config/CONTEXT.md` records that `asgi.py` is the one file an MCP surface changes, and that the mount sits outside Django's middleware chain.
- **The nine how-to workflows regrouped into four families** — set up (`01`–`02`), run (`03`–`07`), diagnose (`08`), author (`09`) — matching the shape the code layer now has. `02-daily-development` → `03`, `03-debugging` → `08`, `04-worktree-setup` → `02`; `01-first-time-setup` kept its number.
- **`doc-writer`'s remit now explicitly excludes `how-to/`**, and `how-to/src/CLAUDE.md` no longer routes there — it previously named `doc-writer` against that agent's own stated scope of `code/docs/*`, a contradiction that had gone unnoticed.
- `how-to/workflows/CLAUDE.md` corrected from "three-file shape" to four — every workflow here has carried a `CLAUDE.md` as well since the pairing rule landed.
- **The eleven code workflows renumbered into three families** — build (`01`–`06`), verify (`07`–`08`), diagnose & improve (`09`–`11`). Within build the layers now read bottom-up (`03` data → `04` `/api/` → `05` `/mcp/`); within diagnose they read in handoff order (`09` find → `10` fix → `11` improve). `01-new-feature`, `02-tdd-cycle` and `04-api-design` keep their numbers; the other eight moved. The mapping was circular (`03`→`08`, `08`→`11`, `09`→`03`), so the rename went through a temporary namespace.
- The renumber touched **282 path tokens across 117 files** plus 12 bare-number references that carry no slug (`.claude/CLAUDE.md` Section 2.4, `code/docs/CODE-REVIEW-GRAPH.md`, and two workflow `CLAUDE.md` files). Historical `CHANGELOG.md` / `RELEASES.md` entries were deliberately **not** rewritten — they record the paths as they stood at that release.
- **`09-debugging-with-logs` and `10-debug` are now adjacent**, which is the defect that motivated the change: they are two halves of one activity (`09` locates a fault, `10` fixes it and proves the fix), they reference each other five times, and `09/STEPS.md` ends by handing over to `10` — yet they previously sat three positions apart with unrelated workflows between them.
- `code/workflows/CONTEXT.md` regrouped into the three families, and now states outright that **these numbers are stable identifiers, not a sequence** — append a workflow, never renumber one. Roughly 110 files cite these paths, and a stale number in an agent definition is a silent routing failure.

### Fixed

- **`.copier/README.md` shipped a workflow table whose `#` column had decoupled from the workflow names** — row `03` pointed at `08-security-hardening/`, row `09` at `03-database-migration/`. The renumber sweep corrected every slug but had no way to know a separate hand-maintained column encoded the same number. Every generated project would have carried it. Rebuilt as a family-grouped table, along with both directory trees (`10 coding workflows` → 11, `4 operational` → 9) and the "three files" claim (workflows carry four).
- **Stale hard counts removed from `README.md`, `01-OVERVIEW.md` and `07-REPO-TOUR.md`** — "50 agents" (52), "16 skills" (23), "15 GitHub Actions workflows" (17). The 0.13.0 release deliberately removed such counts because one differs between two correct projects once the roster is conditional; that removal reached `08-CLAUDE-CODE.md` and missed these three, which had gone stale exactly as predicted. The Copier question count is now stated accurately as twenty-two, or twenty-four with the mobile surface, rather than the stale "twenty-one".
- `07-REPO-TOUR.md` described the code workflows as a **range** ending at `10-debugging-with-logs`; the sweep renumbered that token to `09`, leaving a semantically wrong but syntactically valid endpoint. A path check cannot catch this class of error.
- `12-EXTENDING.md`'s "An MCP server" section was about servers the project **consumes** via `.mcp.json`, and would now be read as covering the FastMCP surface the project **serves**. Split into two sections.

- **Six of the eight `claude.yml` quality gates failed on every push and pull request** raised against this template — `uv sync --frozen` cannot resolve without a `uv.lock`, which is absent by design here because it would pin the root project under the literal project-slug token. Each now carries the same `Detect the backend lockfile` step `test.yml` already used, guarded at **step** level so the JS half (Prettier, ESLint, `pnpm audit`) keeps gating this repository rather than being thrown away with the Python half.
- `audit-deps.yml` failed on its nightly schedule for the same reason, opening a tracking issue about a Python dependency tree that does not exist yet. The JS half is unguarded and keeps its nightly CVE scan.
- `clickup-sync.yml` failed whenever triggered: the template ships `US000-TEMPLATE.md` and no real stories, so `export/clickup/` holds no `US###-CLIENT.md` files and `sync-clickup.sh` exits 2 on preflight. Now guarded on the exports existing. This is **not** the missing-credentials case — the script already degrades to a dry run for that by itself.
- All three `syntax-python.yml` jobs failed at `astral-sh/setup-uv@v4`, a stale action pin with no explicit version while every other workflow here uses `@v5` with `UV_VERSION`. Fixed rather than skipped: these jobs run `uv sync` **without** `--frozen`, so they need no lockfile and are the one Python gate this repository genuinely enforces on itself.

---

## [0.13.0] - 02/08/2026

### Added

- **The opt-in React Native mobile surface.** `INCLUDE_MOBILE` (default `false`) gates a bootable Expo application at `code/src/mobile/` — Expo SDK 57 with Continuous Native Generation, expo-router, TypeScript, one placeholder route, and no binary assets. Answering no produces a repository functionally identical to 0.12.0's output.
- `MOBILE_APP_NAME` and `MOBILE_BUNDLE_ID` Copier questions, asked only when the mobile surface is included; the bundle ID defaults to the primary domain, label-reversed.
- `code/src/scripts/mobile/` — `install.sh`, `server.sh`, `lint.sh`, `typecheck.sh`, `test.sh` and `bundle.sh`, plus a shared `_common.sh`. Metro runs on the **host**, the one dev operation that is not containerised, because Expo Go on a physical device cannot reach a loopback alias.
- Four mobile CI jobs — `jest-expo + coverage` and `Bundle export` in `test.yml`, `ESLint (mobile surface)` and `TypeScript (mobile surface)` in `syntax-js-ts.yml` — each guarded at **step** level so a web-only project reports green rather than skipped.
- `.claude/agents/mobile.md` and `.claude/skills/stack-react-native/` — the mobile governance pair, excluded with the tree.
- `code/docs/design-tokens/MOBILE.md` — the design-token bridge: six colour forms with OKLCH canonical and five derived on write, CSS Color 4 gamut mapping, 8-digit hex for mobile, the `render_tokens_ts()` emitter, and which three preference axes collapse to BASE.
- `code/docs/accessibility/MOBILE.md` — the React Native technique set for the unchanged WCAG 2.2 AA standard, including why verification here is manual.
- `code/src/scripts/audits/mobile-tokens.sh` and `.github/workflows/audit-mobile-tokens.yml` — the mobile half of the token-first law. Self-guarding: exits 0 with a note when there is no mobile surface.
- `code/src/mobile/CHANGELOG.md`, `VERSION-HISTORY.md` and `RELEASES.md` — the mobile application is a third independent semver track, starting at 0.1.0.
- Mobile-flagged steps in `project-management/workflows/20-frontend-code/` (Step 4M), `code/workflows/01-new-feature/` (Step 7M) and `code/workflows/02-tdd-cycle/`, plus the mobile wireframe convention in `project-management/src/08-WIREFRAMES/`.

### Changed

- **Five documented invariants narrowed in scope, not in force**, to "the web surface" — `code/src/CLAUDE.md`, `code/src/CONTEXT.md`, `eslint.config.mjs`, `project-management/src/CONTEXT.md` and `code/docs/RENDERING.md`. A mobile app is a separate deployable, not a bundler for Django pages, so `RENDERING.md`'s "there is no fourth row" survives verbatim.
- **"Surface" became load-bearing vocabulary**, defined once in `code/src/CONTEXT.md` → _Surfaces_. Silence still means the web surface.
- `test-backend.yml` renamed **`test.yml`** to hold both surfaces' test jobs, and its path filters dropped — a path-filtered required check never reports and would silently stop gating mobile.
- `audit-template.yml` now runs **both** `INCLUDE_MOBILE` values through every assertion, plus two new ones: the opt-in is obeyed in both directions, and every shared file is byte-identical across the render paths.
- Jinja comment delimiters moved from the vertical-bar pair to a tilde pair, because the old opening sequence collided with TypeScript union types and would have swallowed a generated declaration. No committed file used it as a real comment, so nothing behavioural changed. The sequences themselves are quoted in `how-to/src/TEMPLATE-GUIDE/`, which is excluded from rendering and is the only place they can appear literally.
- `VERSIONING-GUIDE.md` documents the mobile track and its **two-files-one-number** rule (`package.json` and `app.json`); the `version` agent learned it, and its stale `backend`/`frontend`/`shared` sub-package list was corrected.
- `code/docs/testing/COVERAGE.md` reworded from "one floor, not one per layer" to **one standard, enforced once per runtime** — `coverage.py` and Jest share no accumulator.
- **Hard agent counts removed rather than incremented** across `.claude/CLAUDE.md`, `CONTEXT.md`, `.claude/CONTEXT.md`, `how-to/docs/TOOLING-GUIDE.md` and `TEMPLATE-GUIDE/08-CLAUDE-CODE.md` — a count differs between two correct projects once the roster is conditional, and one was already stale.
- `project-management/workflows/08-wireframes/` corrected to match the artefact folder it drives: self-contained HTML screens named `WF-###-<Screen-Name>.html`, not `WF-US###-<DESCRIPTOR>.md`, and Figma/Excalidraw are no longer offered as alternative media.

### Fixed

- `@jest/reporters>glob` repinned from `^7.1.6` to `^9.3.5`, removing `inflight@1.0.6` from the tree. The constraint is an interop shape, not a version floor: glob 10 and 11 set `__esModule` with no `default` export, so `.default.sync` is undefined and the Jest 29 coverage reporter dies. glob 9 is the newest version that still works.

### Security

- `inflight@1.0.6` — an unbounded-memory-leak package — no longer appears anywhere in the dependency tree.

---

## [0.12.0] - 02/08/2026

### Added

- `copier.yml` — the executable template contract: twenty-one questions with derived defaults and validators, custom Jinja delimiters, exclusion rules, and four post-generation tasks. Replaces `setup.sh`.
- `.copier-answers.yml` — rendered into every generated project so `copier update` can three-way-merge later template improvements into live projects.
- `.copier/README.md` — the generated project's README, moved out of the repository root so the root README can describe the template itself.
- `LICENSE` — MIT. The template no longer withholds a licence; `<%LICENCE%>` remains a token so a generated project still chooses its own.
- `SECURITY.md` — private vulnerability disclosure policy, scoped to the realistic risk of an insecure default propagating into every generated project.
- `CONTRIBUTING.md` at the root — the external contributor front door, distinct from `how-to/src/CONTRIBUTING.md` which holds the standards applying inside a generated project.
- `.github/CODEOWNERS`, `.github/PULL_REQUEST_TEMPLATE.md`, and `.github/ISSUE_TEMPLATE/` (bug report, template improvement, config).
- `.github/workflows/audit-template.yml` and `.github/scripts/check-template-tokens.sh` — two unconditional CI gates: token-syntax integrity, and a full generation smoke test asserting zero surviving tokens, no template-only leakage, and intact `${{ }}` / `[[ ]]` syntax.
- `how-to/src/TEMPLATE-GUIDE/` — fourteen numbered guides plus a `CONTEXT.md`/`CLAUDE.md` pair, covering overview, stack, prerequisites, quickstart, answers, generation, repository tour, Claude Code, first story, customising, extending, deployment, updating, and troubleshooting.
- `how-to/src/CONTRIBUTING.md` — the contributing and code-quality standard, lifted out of `how-to/src/CONTEXT.md`.
- Host platform and container-runtime detection in `install.sh` — distinguishes Linux, macOS, WSL and native Windows, accepts Docker Desktop or Colima on macOS, rejects non-WSL Windows shells, and warns on WSL 1 and on repositories living under `/mnt/c`.

### Changed

- **Token delimiters replaced** — swept across 433 files. Jinja's default double-brace delimiters collide with GitHub Actions expressions (`${{ }}`), Django template syntax, and Bruno variables; double-square-bracket was rejected in turn because it is bash test syntax. The replacement variable, block and comment delimiters were each verified absent from the tree before adoption — see `how-to/src/TEMPLATE-TOKENS.md` for the set and the reasoning.
- `README.md` rewritten template-facing and literal — 1160 lines to 140 — describing syntek-base rather than impersonating a shipped product, and indexing the guide set.
- `how-to/src/CONTEXT.md` is now a genuine orientation index rather than a 239-line guide.
- `how-to/src/TEMPLATE-TOKENS.md` rewritten as the contract `copier.yml` implements, including the delimiter rationale.
- Licence language in `how-to/src/CONTEXT.md`, `how-to/src/CLAUDE.md` and the project README now keys off `<%LICENCE%>` instead of asserting proprietary.
- `how-to/CONTEXT.md` and `how-to/REFERENCES.md` corrected — the tree had drifted, omitting every `CLAUDE.md`, `CELERY-FIRST-RUN.md`, `FEATURE-DEPLOY.md`, and `TEMPLATE-TOKENS.md`.
- Deployment documentation made provider-neutral: any Linux host with Docker will serve the application; Hetzner, NixOS and Cloudflare are named as the target the runbooks are written against, not a requirement.
- The Claude Code guide now distinguishes grilling from wayfinder, and the plan requirement (Fable tier) is stated in the README, prerequisites and Claude Code guides.

### Removed

- `setup.sh` — superseded by Copier. Its literal string substitution had no update path, which is the capability the migration exists to gain.

### Fixed

- Two tokens corrupted by Prettier's Markdown formatter, which pairs the underscore inside a token name with nearby `_emphasis_` and rewrites both. A corrupted token renders as an undefined variable and vanishes silently from every generated project.
- Literal token delimiters written in prose inside `how-to/src/CLAUDE.md`, a rendered file — Jinja parsed them and generation failed outright with `TemplateSyntaxError`.
- `_exclude` patterns anchored to the repository root. They use gitignore semantics, so an unanchored `README.md` also matched `.copier/README.md`, and `CONTRIBUTING.md` would have swallowed `how-to/src/CONTRIBUTING.md`.

### Security

- Branch protection on `main` via a repository ruleset — pull request required, conversation resolution required, force-push and deletion blocked, and eleven required status checks. Administrators may bypass, so solo merges still work.
- Private vulnerability reporting enabled on the repository, matching the disclosure route `SECURITY.md` documents.

---

## [0.11.0] - 01/08/2026

### Added

- Root `CONTEXT.md` — the project overview: directory tree, layer map, starting points, conventions, and repository state. Reinstates the orientation file retired in 0.10.0.

### Fixed

- `.claude/CLAUDE.md` line 6 imports `@../CONTEXT.md`, which resolved to nothing after 0.10.0 removed the file. The import now loads on every session as intended.

---

## [0.10.0] - 01/08/2026

### Added

- `REFERENCES.md` — the root reference index covering every layer entry point, guide, workflow, and external standard.
- `DEFERRED.md` — the register of work deliberately deferred, alongside `GAPS.md` for active blockers.
- `setup.sh` and a rewritten `install.sh` — resolve the template placeholders and prepare a scaffolded project.
- `skills-lock.json` — installed Claude Code skills with their versions and hashes.
- `.github/workflows/audit-css-tokens.yml`, `audit-css-gradients.yml`, `audit-copy-emdash.yml`, `audit-secrets.yml`, and `audit-deps.yml` — CI wiring for the audit scripts added in 0.4.0.
- `.github/workflows/claude.yml` and `clickup-sync.yml` — the Claude Code review pipeline and the ClickUp story export sync.
- `.zed/settings.json` — editor configuration shipped as part of the template's tooling surface.
- `handoffs/`, `learning/`, and `research/` — session sandboxes for the handoff, teach, and research skills, each with `CONTEXT.md` and `CLAUDE.md`.

### Changed

- Hardcoded project identifiers replaced with substitution placeholders throughout the root files — `<%PROJECT_NAME%>`, `<%PROJECT_SLUG%>`, `<%ORG_NAME%>`, `<%ORG_SLUG%>`, `<%DEVELOPER_NAME%>`, `<%LOCALE%>`, `<%TIMEZONE%>`, `<%CURRENCY%>`, `<%LICENCE%>`, and `<%DATE%>`.
- `README.md` rewritten for the Django-only monolith; the version badge and footer set to `0.10.0`.
- `DESIGN.md` and `GAPS.md` rewritten around the token-first design system and the template's open items.
- `package.json`, `pnpm-workspace.yaml`, and `pnpm-lock.yaml` reduced to the tooling dependencies that survive without a JavaScript application.
- `eslint.config.mjs`, `.prettierrc`, `.prettierignore`, `.markdownlint-cli2.jsonc`, and `.npmrc` re-scoped to the remaining file types.
- `lefthook.yml` — pre-commit hooks re-pointed at the Django tree, with a self-gating ClickUp export step and an advisory code-review-graph pass.
- The six surviving CI workflows re-pointed at `code/src/django/` and the rewritten script surface.

### Removed

- Root `CONTEXT.md` — superseded by `REFERENCES.md` as the root index.
- `LICENCE` — a base template does not choose a licence on behalf of the project scaffolded from it; the placeholder `<%LICENCE%>` is resolved at setup.
- `CONTRIBUTING.md` — superseded by the PM layer's git, PR, and review workflows.

---

## [0.9.0] - 01/08/2026

### Added

- `how-to/docs/AI-DICTIONARY.md` with `ai-dictionary/` — plain-English definitions across `THE-MODEL.md`, `SESSIONS-CONTEXT-AND-TURNS.md`, `TOOLS-AND-ENVIRONMENT.md`, `MEMORY-AND-STEERING.md`, `PATTERNS-OF-WORK.md`, `HANDOFFS.md`, and `FAILURE-MODES.md`.
- `how-to/docs/TOOLING-GUIDE.md` with `tooling-guide/` — `COMMANDS.md`, `CONFIGURATION.md`, and `WORKFLOW.md` covering the internal agents and skills.
- `how-to/docs/GIT-WORKTREES.md`, `SKILL-AUTHORING.md`, `CELERY-FIRST-RUN.md`, and `FEATURE-DEPLOY.md`.
- `how-to/workflows/04-worktree-setup/` — a complete workflow (`CONTEXT.md`, `STEPS.md`, `CHECKLIST.md`, `CLAUDE.md`) for running parallel stories in isolated worktrees and Docker stacks.
- `how-to/src/SCALE-ARCHITECTURE/` — `OVERVIEW.md`, `LOAD-PROFILES.md`, `SIZING-ENVELOPE.md`, `READINESS.md`, and `TOPOLOGY.md` for sizing a deployment against a target user count.
- `how-to/src/SERVER-ARCHITECTURE/` — `OVERVIEW.md`, `COMPUTE-ALLOCATION.md`, `EDGE-REQUIREMENTS.md`, and `NIXOS-HANDOFF.md`, the interface to the NixOS deployment repository.
- `how-to/src/NIXOS-SETUP.md`, `how-to/src/TEMPLATE-TOKENS.md`, `how-to/REFERENCES.md`, and `CLAUDE.md` operating-rules files throughout the layer.

### Changed

- `how-to/docs/DEVELOPMENT.md`, `CLI-TOOLING.md`, and the three existing workflows rewritten for the Django-only stack and the rewritten script surface.
- `how-to/CONTEXT.md` updated for the new document set and workflow `04`.

### Removed

- `how-to/docs/SYNTEK-GUIDE.md` and `how-to/docs/API-TESTING.md` — project-specific or superseded by the code-layer testing guides.
- Nine narrow contributor guides under `how-to/src/` — `BRANCH-GUIDE.md`, `COMMIT-GUIDE.md`, `PR-GUIDE.md`, `CODE-REVIEW.md`, `ISSUE-REPORTING.md`, `ENV-SETUP.md`, `GETTING-STARTED.md`, `CLAUDE-MULTILAYER.md`, and `API-TESTING.md` — each duplicated an authoritative guide in the code or PM layer.

---

## [0.8.0] - 01/08/2026

### Added

- `project-management/src/` renumbered to `00`–`20` across three tiers — specify (`02-STORIES` … `13-API-DESIGN`), decide and plan (`14-DECISIONS`, `15-SPRINT-PLANS`, `16-STORY-PLANS`), and record (`17-TESTS` … `21-REFACTORING`).
- `project-management/workflows/` extended to `01`–`21`, adding `13-api-design`, `14-decisions`, `15-sprint-plans`, `16-story-plans`, the `16`–`18` implementation phases, `21-implementation-documentation`, `22-pr-and-review`, and `23-release`.
- `project-management/docs/gdpr/` — `COMPLIANCE.md` and `DATA-RIGHTS.md`, with `GDPR-GUIDE.md` reduced to a thin index over them.
- `project-management/export/clickup/` and `clickup-task-map.json` — the read-only client export surface regenerated from source stories by the pre-commit hook.
- `project-management/src/00-ASSETS/scripts/` — the export and sync family: `export-clickup-stories.sh`, `export-design-docs.sh`, `export-pm-files.sh`, `export-wireframes.sh`, `sync-clickup.sh`, and the self-gating `precommit-clickup.sh`.
- `CLAUDE.md` operating-rules files for the layer root, `docs/`, every `src/` artefact folder, and every numbered workflow.

### Changed

- All eight PM guides rewritten for the Django-only stack — `GIT-GUIDE.md`, `VERSIONING-GUIDE.md` (now a two-tier scheme with the django sub-package), `SEO-CHECKLIST.md`, `SECURITY-GUIDE.md`, `QA-GUIDE.md`, `PLANNING-GUIDE.md`, `GDPR-GUIDE.md`, and the `RESPONSIVE-DESIGN.md` redirect stub.
- `project-management/CONTEXT.md` and `REFERENCES.md` rewritten around the three-tier structure and the cross-layer workflow pairing map.
- Story, sprint, and plan templates re-expressed with template placeholders in place of project-specific content.

### Removed

- The pre-renumbering artefact folders `00-DECISIONS/`, `00-PLANS/`, `13-SPRINT-PLANS/`, `14-TESTS/`, `15-REVIEWS/`, `16-BUGS/`, and `17-REFACTORING/` — superseded by their renumbered equivalents.
- The organisation's logo exports (`00-ASSETS/LOGOS/` at 8k, HD, and SVG) and the project's twelve ERD diagrams (`00-ASSETS/ERD-DIAGRAMS/`) — a template ships the asset pipeline, not one organisation's brand or one project's schema.

---

## [0.7.0] - 01/08/2026

### Added

- `code/docs/DATABASE.md` — scope columns, database-level invariants, lock-safe migration patterns, search, and the deferred-infrastructure register.
- `code/docs/DESIGN-TOKENS.md` with `design-tokens/` (`MODEL.md`, `CASCADE.md`, `EDITOR.md`) — the database-canonical token system that component CSS may only consume through `var(--token)`.
- `code/docs/RENDERING.md` with `rendering/` — where each interaction runs: server template, HTMX, or Alpine.
- `code/docs/VISUAL-DESIGN.md`, `BACKEND-CODING-PRINCIPLES.md`, and `FRONTEND-CODING-PRINCIPLES.md`.
- `code/docs/CODE-REVIEW-GRAPH.md` — the explore, debug, review, and refactor playbooks for the code-review-graph MCP server.
- Sub-folders splitting every oversized guide: `accessibility/`, `api-design/`, `architecture/`, `coding-principles/`, `data-structures/`, `encryption/`, `logging/`, `performance/`, `responsive/`, `rls/`, `security/`, and `testing/`.
- `code/docs/cloudinary/` — the Cloudinary Python SDK and cross-SDK reference index.
- `code/REFERENCES.md` and `CLAUDE.md` operating-rules files for the code layer root, `code/workflows/`, and all ten numbered workflows.

### Changed

- All fourteen existing `code/docs/*.md` guides rewritten for the Django-only stack and reduced to thin indexes over their sub-folders where they exceeded the 300-code-line instructional limit.
- All ten `code/workflows/` procedures re-pointed at the Django tree, the rewritten script surface, and the paired project-management workflows.
- `code/CONTEXT.md` — directory tree and layer map updated for the single-stack monolith and the 750-line source file limit.

---

## [0.6.0] - 01/08/2026

### Added

- `.claude/agents/` — 50 agent definitions in two tiers: 8 orchestrators (`bugfix`, `feature`, `pr`, `refactor`, `release`, `review`, `security`, `story`) plus the specialists and document writers they delegate to.
- `.claude/skills/` — the internalised skill library: `stack-django`, `stack-htmx-templates`, `global-workflow`, the `grilling` engine with its `grill-me` and `grill-with-docs` wrappers, `codebase-design`, `domain-modelling`, `improve-codebase-architecture`, `scale-planning`, `teach`, `wayfinder`, `handoff`, `prototype`, `research`, `legal-documents`, and `msp-scp-documents`.
- `.claude/MEMORY.md` — the project memory store that replaces the global auto-memory system.
- `.claude/CONTEXT.md` — orientation for the configuration directory.
- `.claude/hooks/pre-pr-check.sh` — the eight-gate quality check run before a pull request is marked ready; `post-pr-comment.sh` posts the structured result summary.
- `.claude/hooks/pre-compact-handoff.sh` — intercepts auto-compaction so a session writes an explicit handoff document instead of silently compacting.
- `.agents/skills/cloudinary-docs`, `cloudinary-react`, and `cloudinary-transformations` — Cloudinary SDK skill references.
- `CONTEXT.md` and `CLAUDE.md` pairs for the hooks and plugins directories.

### Changed

- `.claude/CLAUDE.md` — rewritten around the Django-only stack, the two-tier agent model, the Fable/Opus model allocation, the templatised project placeholders, and the non-negotiable rules (token-first CSS, database-enforced invariants, lock-safe migrations, and the docs hard gate).
- `.claude/settings.json` — auto-compaction disabled, dynamic workflows enabled, the Opus model and extra-high effort level pinned, and both marketplace plugins disabled.
- `.claude/hooks/lib/check-*.sh` — the eight shared check scripts re-pointed at the Django tree and the rewritten script surface.

### Removed

- `.claude/commands/` — seven slash commands (`codegen`, `dev`, `migrate`, `production`, `schema`, `staging`, `test`) superseded by the runners under `code/src/scripts/`.
- `.claude/hooks/pr-gate.sh` and `pr-comment.sh` — replaced by `pre-pr-check.sh` and `post-pr-comment.sh`.
- `.claude/plugins/chrome-tool.py`, `ddev-tool.py`, `docker-tool.py`, and `quality-tool.py` — plugins that ran dev operations; those now belong exclusively to the shell scripts.

---

## [0.5.0] - 01/08/2026

### Added

- `code/src/tests/api/environments/*.bru` — native Bruno environment files for `local`, `host`, `docker`, `staging`, and `production`, alongside the retained JSON definitions.
- `code/src/tests/api/environments/host.json` — the host-machine environment, for running the suite outside the Docker network.
- `code/src/tests/template-test.bru` — a single annotated request template that every new Bruno suite is copied from, relocated from `api/template-test.bru`.
- `code/src/improvement-architecture/` — scratch area for architecture improvement reports; contents are git-ignored, orientation files are tracked.
- `CLAUDE.md` operating-rules files for `code/src/tests/`, `code/src/tests/api/`, `code/src/tests/api/environments/`, and `code/src/logs/`.

### Changed

- `code/src/tests/api/bruno.json` and the `docker`, `staging`, `production`, and `variables` JSON environments re-pointed at the Django service and its `/api/` prefix.
- `code/src/tests/CONTEXT.md`, `api/CONTEXT.md`, and `logs/CONTEXT.md` rewritten for the template layout.

### Removed

- The illustrative Bruno collections — `api/auth/`, `api/orders/`, `api/users/`, and `api/performance/` — a template ships no domain fixtures.
- `code/src/tests/api/template-test.bru` — relocated up one level to `code/src/tests/template-test.bru`.

---

## [0.4.0] - 01/08/2026

### Added

- `code/src/scripts/_lib/` — shared shell helpers, including `worktree-detect.sh` for resolving the active worktree and its Docker project name.
- `code/src/scripts/audits/` — `css-tokens.sh` (enforces that component CSS only consumes resolvable `var(--token)` values), `css-gradients.sh`, `copy-emdash.sh`, and `security.sh`.
- `code/src/scripts/development/new-django-view.sh` — scaffolds a public page as a Django view, template, and URL entry; the only supported way to add a page route.
- `code/src/scripts/development/hosts-story-add.sh` and `hosts-story-remove.sh` — manage per-story loopback host entries for parallel worktrees.
- `code/src/scripts/development/install.sh`, `install-backend.sh`, `install-frontend.sh`, and `pnpm-update.sh` — dependency installation and update runners.
- `code/src/scripts/database/seed-dev.sh` and `verify-db-security.sh` — development seeding and a row-level-security and grant verification pass.
- `code/src/scripts/tests/e2e-py.sh` (Playwright driven from the Django tree), `server.sh`, and `mutmut.sh` for mutation testing.
- `CLAUDE.md` operating-rules files for the script root and every script sub-directory.

### Changed

- Every runner under `database/`, `deployment/`, `development/`, `syntax/`, and `tests/` re-pointed from `code/src/backend/` to `code/src/django/`.
- `code/src/scripts/CONTEXT.md` rewritten around the Django-only script inventory.

### Removed

- `code/src/scripts/tests/frontend.sh`, `frontend-coverage.sh`, `mobile.sh`, `mobile-coverage.sh`, and `e2e.sh` — superseded by `e2e-py.sh` or removed with their layer.
- `code/src/scripts/development/codegen.sh`, `new-next-route.sh`, and `new-expo-screen.sh` — scaffolding for the removed JavaScript layers.
- `code/src/scripts/tests/reports/**` — generated report directories are no longer tracked; `.gitignore` now excludes them and a single `reports/.gitignore` keeps the directory self-managing.

---

## [0.3.0] - 01/08/2026

### Added

- `code/src/django/` — the Django project bundle: `config/` (ASGI and WSGI entry points, root URL conf, and the four-environment settings split), `apps/`, `templates/`, `static/`, `tests/e2e/` with accessibility and marketing-overflow suites, plus `conftest.py`, `manage.py`, and `pyrightconfig.json`.
- `code/src/django/CHANGELOG.md`, `code/src/django/VERSION-HISTORY.md`, and `code/src/django/RELEASES.md` — sub-package version files at the `0.1.0` baseline, as required for every package manifest by `project-management/docs/VERSIONING-GUIDE.md`.
- `code/src/docker/django/` — the Django container images and entrypoints for dev, test, staging, and production.
- `code/src/docker/postgres/` — PostgreSQL container configuration, including `postgresql.dev.conf`.
- `code/src/docker/docker-compose.usXXX.dev.yml.example` and `docker-compose.usXXX.test.yml.example` — per-worktree Compose overlays for parallel story development.
- `CLAUDE.md` operating-rules files alongside every `CONTEXT.md` in the `code/src`, `docker`, and `django` trees, per the directory pairing rule.

### Changed

- `code/src/backend/` → `code/src/django/` — the Python package root is renamed to reflect that Django now serves the entire application, not just an API.
- `code/src/docker/backend/` → `code/src/docker/django/` — image names, build contexts, and entrypoints follow the rename.
- Compose files, the Nginx dev and test configurations, and the four `.env.*.example` templates re-pointed at the `django` service.
- `pyproject.toml` — project name templatised to `<%PROJECT_SLUG%>`, version set to the django sub-package `0.1.0` baseline, and the dependency set narrowed to the Django-only stack.

### Removed

- `code/src/backend/**` — superseded in full by `code/src/django/**`.
- `code/src/shared/**` — the TypeScript package shared between the web and mobile clients, obsolete now that neither client exists.

---

## [0.2.0] - 01/08/2026

### Removed

- `code/src/frontend/**` — the Next.js/React web application (34 files), including its App Router pages, components, hooks, and TypeScript configuration.
- `code/src/mobile/**` — the Expo React Native application (45 files), including its screens, navigation, native configuration, and Expo tooling.
- `code/src/docker/frontend/**` — the frontend container images and configuration for dev, test, staging, and production (5 files).
- `code/src/docker/mobile/Dockerfile.test` — the React Native test image.
- `.github/workflows/test-frontend.yml` and `.github/workflows/test-mobile.yml` — the CI pipelines for the two removed layers.

---

## [0.1.0] - 01/08/2026

### Added

- Initial scaffold from the base template — Django · Django Ninja · django-components · HTMX · Alpine · vanilla token CSS · Celery · PostgreSQL · Valkey · Nginx · Docker.
- `.gitignore` rules for the template surface — generated test reports under `code/src/scripts/tests/reports/`, the resolved Python lockfile, git worktree checkouts under `.claude/worktrees/`, and local Claude Code overrides.

### Changed

- Root version track reset from `1.11.0` to `0.1.0` — this repository is now the reusable base template rather than a single delivered project.
- `CHANGELOG.md`, `RELEASES.md`, and `VERSION-HISTORY.md` truncated to the template baseline; the pre-template 1.x history is retained in git history only and is not back-filled.

### Removed

- `uv.lock` — the resolved Python lockfile is no longer tracked. The template's `pyproject.toml` carries unsubstituted placeholders, so the lockfile is resolved per scaffolded project rather than shipped.
