# Mutation testing — which tools fit each surface, what they cannot reach, and how results should gate

**Written**: 15/10/2026; **Driver**: the 15/10/2026 mutation-testing research (`MAP-MUTATION-TESTING`,
charted after this note); **Read at**: `d16de16`

**Method.** Two reading legs (Python; then Rust, mobile and the gating papers) read the primaries, and the
writer re-opened every load-bearing one on 15/10/2026. The `context7` and Perplexity tiers were
unauthenticated this session and were **not consulted** (`code/docs/GATE-REPORTING.md`: could not look,
not looked-and-clean); `WebFetch` was not used. Source, docs and issues were read with `gh api` at the tags
named per claim; web pages (mutants.rs, the PyO3 FAQ, PyPI feeds, arXiv abstract pages) with the
`scrapling` MCP `make_request` and `bulk_get`, which answered every request. The four papers were
downloaded and read as text extracted by poppler `pdftotext`, so no figure or table was read. **Nothing
was executed**: _(reasoned)_ marks an inference from source. An earlier brief served as leads only;
**Corrects the lead** marks where the primary differs. A fixer pass the same day re-opened the primary
behind every claim it changed. **Nothing is quoted** — identifiers, flags and figures appear as facts, and
the prose was checked for shared five-word runs against every source it rewords (none with a source that
grants no licence). The note is committed, so it is published wherever this repository is; it never
reaches a generated project, because `copier.yml:146` excludes `/research/**` and `:147-148` re-include
only `CONTEXT.md` and `CLAUDE.md`.

**Citation keys.** `mm7:`/`mm8:` = `boxed/mutmut@3.7.0:`/`@3.8.0:`, under `src/mutmut/` unless a root
file; `cr:` = `sixty-north/cosmic-ray@caf9a319:` (tag `release/v8.7.0`); `cm:` =
`sourcefrog/cargo-mutants@v27.1.0:`; `sj:` = `stryker-mutator/stryker-js@v10.0.0:`; `pd:` =
`pytest-dev/pytest-django@v4.14.0:`. A bare path is this repository at `d16de16`.

---

## Question

Which mutation-testing tools fit each surface of this stack, what can and cannot they reach, and how
should their results gate?

## Verdict

**Python:** mutmut 3, already locked (3.7.0; a fresh lock takes 3.8.0), is the only maintained in-process
candidate; it reaches only undecorated function bodies, and `mutmut run` exits 0 however many mutants
survive. cosmic-ray and poodle, each paying a subprocess per mutant, also mutate decorated bodies and
module-level code and can drop a decorator; cosmic-ray alone negates a bare guard, and its local runs
edit the working copy in place. **Rust:** cargo-mutants v27.1.0 alone exits non-zero on a miss in a diff,
but an empty diff exits 0 having tested nothing. **Mobile:** StrykerJS on jest-expo is held by two open
upstream bugs unless coverage analysis is off; Kotlin and Swift were outside the first pass and are
read in the Addendum (N-012 on MAP-MUTATION-TESTING). **Reach:**
decorated handlers, module-level code and, _(reasoned)_, the HTTP suites are out of mutmut's reach but
not of cosmic-ray's or poodle's. A constraint changed only on the model, shell gates, the PyO3 boundary,
Slint and zeroisation are beyond every tool read; each has another instrument that reaches it.
**Gating:** the industrial evidence is survivors on changed lines raised as review findings that need
not be resolved, with no score; no tool read ships a ratchet. **Here**, the wrapper cannot complete a
run, its exit contract is false, and three doctrine passages claim what mutmut 3 cannot do.

---

## Claims

### PY — Python: mutmut 3

1. 3.8.0 (12/09/2026) is the latest release, after 3.7.0 (31/07/2026); BSD-3-Clause; Python >=3.10,
   classifiers to 3.14 (3.7.0) and 3.15 (3.8.0). `run` takes only `--max-children` (default the CPU count)
   and mutant-name globs, no path option at either tag; Click 8.4.2 rejects an unknown option with exit 2.
   (PyPI feed; `mm8:pyproject.toml:9-24`; `mm7:pyproject.toml:9-23`; `mm8:__main__.py:936-949`; `mm7:__main__.py:1359-1375`; `pallets/click@8.4.2:src/click/exceptions.py:68-77,232`)
2. Config is read from `[tool.mutmut]` in the working directory's `pyproject.toml`, else `setup.cfg`
   `[mutmut]`, never a parent; without `source_paths` it tries `lib/`, `src/`, then a directory or `.py`
   named after the working directory, then raises `FileNotFoundError`. Mutant names derive from paths
   relative to it, so it must be the import root. (`mm8:configuration.py:61-135`; `mm8:utils/format_utils.py:61-68`)
3. The source is copied into `mutants/`, first on `sys.path`, and pytest runs in-process there with
   `-x -q -p no:randomly` added; each mutated function becomes a trampoline keyed on the active mutant. The
   default isolation gives every mutant a child of its own, forked from a parent that has already run the
   suite; 3.8.0 adds `forkserver`; both need `os.fork`. (`mm8:utils/file_utils.py:50-92`;
   `mm8:runners/harness.py:125-173`; `mm8:mutation/trampoline.py:29-58,85-120`; `mm8:README.rst:239-276`)
4. Only top-level functions and methods directly in a top-level class get trampolines; class-body
   statements (model fields, `class Meta`) and module-level code are copied unchanged, and the README
   points to mutmut 2 for code outside functions. (`mm8:mutation/file_mutation.py:363-436`; `mm8:README.rst:28-29`)
5. A decorated function is skipped whole unless its only decorator is a bare `@staticmethod` or
   `@classmethod` — so every `@router.*`, `@transaction.atomic`, `@property`, `@receiver` and decorated
   view or tag. Decorated classes differ: 3.7.0 skips the class and its methods; 3.8.0 recurses and skips
   only the decorator. (`mm8:mutation/file_mutation.py:303-342`; `mm7:mutation/file_mutation.py:281-293`)
6. The full operator set: a number gains 1 (or `1j`); a plain string literal, not triple-quoted, is
   wrapped in `XX` or case-folded either way; `True`/`False` flip and `deepcopy` becomes `copy`; an
   assigned value becomes `None` (`None` becomes `""`); an augmented assignment becomes a plain one;
   `not`/`~` is removed; a `dict(...)` keyword gains an `XX` suffix; each call argument becomes `None` or,
   with two or more, is dropped; paired string methods swap (`lower`/`upper` and the like); a lambda body
   becomes `None` (or `0`); `is`/`in` flip to their negations; `break` becomes `return` and `continue`
   becomes `break`; unary sign, arithmetic, shift, bitwise, augmented, comparison and `and`/`or`
   operators swap; one `match` case is dropped; and, in 3.8.0 only, a ternary's condition is forced each
   way. The 3.8.0 README says `break` and `continue` swap with each other, and names a file absent at the
   tag. (`mm8:mutation/mutators.py:24-290`; `mm7:mutation/mutators.py:24-268`; `mm8:README.rst:600-605`)
7. No operator deletes a statement or a `raise`, or negates an `if`/`while` condition; inside a condition,
   comparisons, `is`/`in`, `and`/`or` and `not` are mutable, as are a `raise` call's arguments.
   _(Reasoned)_ `if user.is_anonymous:` gets no condition mutant and `return user.attr` gets none — the
   documented `MFARequiredDeletionPolicy.permits` is such a body, while its caller's `if not ...` is
   mutable. (`mm8:mutation/mutators.py:161-207,273-290`; `code/docs/BACKEND-CODING-PRINCIPLES.md:95-106`)
8. Verdicts: pytest exits 1 and 3 count as **killed**, 0 survived, 5 and 33 no tests, 2 interrupted, 34
   skipped, 37 type check, 36/24/-24/152/255 timeout, -11/-9 segfault, anything else suspicious. pytest
   marks a test failed when its setup raises, as when it fails in the call, and any failed report makes
   the session exit 1, so a child whose fixture fails scores killed _(reasoned)_. **Corrects the
   lead:** PR #565 only removed a duplicate `-24` key; Python keeps the last value, so 3.7.0 already
   scored SIGXCPU as timeout. (`mm8:stats.py:15-36`; `mm7:__main__.py:82-104`;
   `pytest-dev/pytest@9.1.1:doc/en/reference/exit-codes.rst:6-15`, `src/_pytest/reports.py:384-437`,
   `src/_pytest/main.py:386-387,698-700`; `gh api repos/boxed/mutmut/pulls/565`)
9. `run` exits 0 however many mutants survive, and 1 only on setup failures (stats or listing failed,
   nothing covered, a mismatch caught by the association check between the module path the tests use
   for the source and the one mutmut derives, a failed clean or forced-fail run, Windows). **Corrects the
   lead:** Ctrl-C exits 0 only inside the mutant loop; earlier, Click aborts with exit 1.
   (`mm8:__main__.py:14-18,319-357,820-865,945-1088`; `mm8:workers/isolation.py:900-905`; `pallets/click@8.4.2:src/click/core.py:1501-1503,1529-1533`)
10. `export-cicd-stats`, a separate command, writes nine fields (`killed`, `survived`, `total`,
    `no_tests`, `skipped`, `suspicious`, `timeout`, `check_was_interrupted_by_user`, `segfault`) to
    `mutants/mutmut-cicd-stats.json`; with no results it writes nothing and exits 0. `total` also counts
    two unexported verdicts, so the nine reconcile only when both are zero _(reasoned)_.
    (`mm8:__main__.py:701-751`; `mm7:__main__.py:1174-1216`; `mm8:stats.py:55-77`)
11. No command enforces a score: `badge` (3.8.0 only) computes (killed + timeout) / (total - skipped) for
    a shields.io file, and `results` lists non-killed mutants without one. `apply` writes into the original
    source file. Suppression is `# pragma: no mutate`, with `block` and `start`/`end` forms, at both tags.
    (`mm8:__main__.py:754-786,1101-1111`; `mm8:mutation/diff_apply.py:164-186`; `mm8:README.rst:370-377`; `mm7:README.rst:268-270`)
12. Timeouts at the defaults: CPU (estimate + 1.0) x 15.0 x 2, wall (estimate + 1.0) x 15.0, neither with
    a term for concurrent children; #544 made 3.8.0 time only the `call` phase, so setup is outside the
    estimate _(reasoned)_. #545 is **open**: a DB-bound Django and Postgres suite on six cores logged 616
    timeouts at default parallelism and 366 at `--max-children 2`. **Corrects the lead:** 3.8.0 does not
    address it; cached timeouts reset only when the timeout settings change _(reasoned)_. (`mm8:__main__.py:1046`;
    `mm8:workers/isolation.py:873-876`; `mm8:configuration.py:203-204,257-278`; `gh api repos/boxed/mutmut/issues/544`, `/545`)

### PA — Python: the alternatives

1. **cosmic-ray** 8.7.0 (09/08/2026); MIT; Python >=3.9, classifiers only to 3.13. Per mutation it rewrites
   the module on disk, runs the test command as a subprocess and restores; any non-zero exit, timeouts
   included, is a kill. Local runs edit the working copy in place, serially; parallel workers are depth-1
   git clones. (`cr:pyproject.toml:7-24`; `cr:src/cosmic_ray/testing.py:34-79`; `cr:docs/source/concepts.rst:37-51,173-189`)
2. Its `AddNot` negates `if`, `while` and `assert` conditions and ternaries — so a bare guard — and it adds
   `RemoveDecorator`, `ExceptionReplacer` and `ZeroIterationForLoop`; its docs never mention Django. Work
   items are seeded from every node of each module, with no exception for a decorated function, so the
   bodies of decorated functions and module-level statements are mutated too.
   (`cr:src/cosmic_ray/operators/boolean_replacer.py:45-80`; `cr:src/cosmic_ray/operators/remove_decorator.py:8-26`;
   `cr:src/cosmic_ray/commands/init.py:47-61`; `cr:src/cosmic_ray/ast/__init__.py:19-30,48-61`)
3. `cr-filter-git` marks mutations outside the diff as skipped; `cr-rate --fail-over N` exits 1 above N%
   survival but counts skipped results as killed, diluting a diff-scoped rate, and treats `--fail-over 0`
   as unset. (`cr:src/cosmic_ray/tools/filters/git.py:27-99`; `cr:src/cosmic_ray/tools/survival_rate.py:13-75`)
4. **pytest-gremlins** 1.11.4 (11/10/2026); MIT; "3 - Alpha"; Python >=3.11; run as `pytest --gremlins`.
   Its Django cookbook assumes in-memory SQLite; its config has no score threshold, while its GitHub Action
   enforces a default of 80 by parsing console output. (`mikelane/pytest-gremlins@v1.11.4:pyproject.toml:3-29`,
   `docs/cookbook/django.md:127-131`, `src/pytest_gremlins/config.py:30-58`, `docs/cookbook/github-action.md:5-19`)
5. **poodle** 1.3.4 (05/04/2026) followed a two-year gap; MIT; Python >=3.10. Each trial copies the source
   folder, mutates the copy and runs a command via `subprocess.run` with the copy first on `PYTHONPATH`;
   the default command blanks pytest's `pythonpath` ini. Each of its twelve built-in mutators walks the
   whole parsed module. `Return` turns a returned value into `None` (or `None` into `""`), and
   `Decorator` drops one decorator at a time from a plain `def` (its visitor has no `async def` case).
   `--fail_under` exits 1 when the score falls below the given value.
   (`WiredNerd/poodle@v1.3.4:docs/source/runners.md:17-49`, `docs/source/mutators.md:17-30,332-369`,
   `src/poodle/mutators/calls.py:71-115`, `src/poodle/mutators/operators.py:96-100`,
   `src/poodle/cli.py:37,63-67`, `src/poodle/core.py:47-50`)
6. Ruled out by age or licence: mutatest 3.1.0 (2022, MIT), MutPy 0.6.1 (2019, Apache-2.0, classifiers to
   Python 3.7), xmutant 0.3 (2017, GPLv3), mutahunter 1.3.2 (17/04/2025, LLM-based, AGPL-3.0).
   (PyPI release feeds and version JSON; `gh api` repository metadata)

### DJ — Django, pytest-django and Postgres

1. _(Reasoned)_ Concurrent children share one test database: each starts its own pytest session,
   pytest-django suffixes the name only under xdist or tox, and Django 6.1.2 with autoclobber drops and
   recreates an existing test database, exiting 2 if it cannot. So contention becomes score — a child
   failing database setup exits 1, a kill (PY 8), with setup outside the budget (PY 12) — the shape #545
   reports; the README warns that forked children inherit open connections. (`mm8:workers/isolation.py:848-871`;
   `pd:docs/database.rst:190-201`; `django/django@6.1.2:django/db/backends/base/creation.py:217-262`; `mm8:README.rst:239-276`)
2. pytest-django builds the test schema by running migrations unless `--no-migrations`, so _(reasoned)_ a
   constraint deleted from a model but not from a migration leaves it unchanged. (`pd:docs/database.rst:123-129`)
3. Settings precedence is `--ds`, then the environment variable, then the ini.
   (`pd:docs/configuring_django.rst:49-60`)
4. An ini `pythonpath` resolves against the ini's directory and goes to `sys.path[0]`, as does the nearest
   ancestor holding `manage.py` under pytest-django; mutmut's association check names a `pythonpath`
   setting as a cause and stops with exit 1 when tests import originals.
   (`pytest-dev/pytest@9.1.1:src/_pytest/config/__init__.py:1371-1374,1786-1793`;
   `pd:pytest_django/plugin.py:196-230`; `mm8:__main__.py:815-865`)
5. _(Reasoned; mutmut only)_ A mutmut mutant is live only in a process importing `mutants/` with the
   selector set — mutmut's own children; a separately running server never executes one. cosmic-ray and
   poodle write each mutant to a file instead (PA 1, PA 5), which a server started by their test command
   would load. (`mm8:mutation/trampoline.py:85-120`; `cr:src/cosmic_ray/mutating.py:169-192`)

### RS — Rust: cargo-mutants

1. v27.1.0 (02/06/2026) is still the latest; MIT; not archived. It replaces a function body with a guessed
   value of its type (`()` for unit), swaps binary operators, deletes unary operators and wildcard-guarded
   match arms, and forces guards; tests, `#[mutants::skip]` and `unsafe` functions are excluded.
   (`gh api repos/sourcefrog/cargo-mutants/releases/latest`; https://mutants.rs/mutants.html)
2. `--in-diff FILE` tests only mutants overlapping changed Rust regions; the book says it is no substitute
   for a full run, and a diff touching only tests runs nothing. (https://mutants.rs/in-diff.html, _Caution_)
3. Exit codes: 0 every viable mutant caught; 1 usage; 2 missed; 3 timeout; 4 baseline failing; 5 diff
   does not match the tree; 6 invalid diff; 70 internal. **Corrects the lead:** precedence is baseline,
   then timeout, then missed, so a timeout and a miss together exit 3, and `--in-diff` exits **0 having
   tested nothing** for an empty diff, one changing no Rust source, or one matching no mutant.
   (https://mutants.rs/exit-codes.html; `cm:src/outcome.rs:110-125`; `cm:src/in_diff.rs:42-57`)
4. The test timeout is 5x the baseline, floor 20 s. The CI page recommends `--in-place`, which disables
   that (300 s instead), cannot combine with `--jobs` and mutates the original tree.
   (https://mutants.rs/timeouts.html; https://mutants.rs/ci.html; `cm:book/src/in-place.md:7-18`)
   (Corrected 15/10/2026 - see Addendum, N-014 on MAP-MUTATION-TESTING, item 15: the source keeps
   the multiplier in place.)
5. `#[mutants::skip]` needs the `mutants` crate as a regular dependency, and the book asks for a comment
   per skip; `exclude_re` in `.cargo/mutants.toml` needs none. (https://mutants.rs/attrs.html;
   `cm:book/src/filter_mutants.md:42-50`)
6. Limits: tests must be hermetic; integration tests `cargo test` does not run are invisible;
   macro-generated code yields few mutants; `cfg(target_os)` is not understood; the book contradicts
   itself on nextest. (https://mutants.rs/limitations.html; https://mutants.rs/nextest.html)
7. The workspace is copied to a scratch directory leaving out its top-level `target/` unless
   `--copy-target` or the `copy_target` config key is true, and the source never reads or sets
   `CARGO_TARGET_DIR`, so a host-set value is presumably shared by every scratch build _(reasoned, not
   run)_. (`cm:src/copy_tree.rs:94-113`; `cm:src/options.rs:362-363`; `cm:src/cargo.rs:47-57`)
   (Extended 15/10/2026 - see Addendum, N-014 on MAP-MUTATION-TESTING.)

### MO — Mobile

1. The surface examined is the React Native skeleton, present only where `INCLUDE_MOBILE` is answered;
   its retirement is slice S-01 on MAP-NATIVE-MOBILE-SURFACE and native testing is node N-020 on
   MAP-NATIVE-MOBILE-SURFACE, both open. Its suite runs `pnpm exec jest --passWithNoTests` under
   jest-expo: 3 files, 16 `it()` cases.
   (`copier.yml:189-195`; `project-management/src/01-FEATURE-MAPS/MAP-NATIVE-MOBILE-SURFACE.md:1,40-41,121,161`;
   `code/src/scripts/mobile/test.sh:47-51`; `code/src/mobile/jest.config.js:6`)
2. StrykerJS v10.0.0 (14/08/2026) is the latest; Apache-2.0; Node >=22. Its default `mutate` glob covers
   `{src,lib}/**`, missing `app/`; `thresholds.break` defaults to null, so by default it never fails a
   build; `coverageAnalysis` defaults to `perTest`. (`sj:docs/configuration.md:149,425,569-580`)
3. #6108 (open, filed 09/07/2026 on 9.6.1): under `perTest` or `all`, an environment that a Jest preset
   supplies, as jest-expo does, gives way without any error to Jest's Node default; `off` is unaffected.
   The responsible code is byte-identical at v10.0.0 and master `c931a93`. (`gh api .../issues/6108`;
   `sj:packages/jest-runner/src/jest-plugins/with-coverage-analysis.ts:43-52,102-110`)
4. #6253 (open, filed 11/10/2026 on 10.0.0): `perTest` keeps the realm of every test file alive; the
   reproduction's heap grows 33 to 552 MiB against 33 to 46 under `off` or `all`, and a jest-expo project
   of about 900 tests ran out of memory under `perTest`. (`gh api .../issues/6253`)
5. Fix PRs #6219 (for #6108), #6023 (cites closed #6022) and #6254 (for #6253) were open and unmerged on
   15/10/2026. _(Reasoned)_ Only `coverageAnalysis: "off"` avoids both bugs, and with it every test runs
   against every mutant.
   (`gh api repos/stryker-mutator/stryker-js/pulls/6219`, `/6023`, `/6254`)
6. **Not covered:** no JVM/Kotlin or Swift mutation tool was read; this note says nothing about whether
   one exists or fits.
   (Superseded 15/10/2026 - see Addendum, N-012 on MAP-MUTATION-TESTING and N-013 on
   MAP-MUTATION-TESTING.)

### UN — What mutation cannot reach, and what does

Items 2, 4 and 5 are limits of mutmut, not of every Python tool read.

1. **Database constraints** (`Meta.constraints`, CHECK and UNIQUE in migrations, RLS): mutmut copies class
   bodies and migrations unchanged (PY 4), and under any tool a constraint altered only on the model leaves
   the test schema as it was, since that schema is built from migrations (DJ 2). _(Reasoned, not run)_
   cosmic-ray and poodle treat a migration module like any other, so a numeric or boolean term in a
   migrated constraint is open to them; no tool read documents doing it. **Reaches it:** a test attempting
   the violating write — the taxonomy lists constraints as a model-validation target — proved by a
   hand-planted removal _in a migration_. (`code/docs/testing/TAXONOMY.md:60`)
2. **Decorated functions** under mutmut (PY 5). **Reaches it:** cosmic-ray and poodle, which mutate
   decorated bodies and can drop the decorator (PA 2, PA 5), at a subprocess per mutant; guard logic in
   an undecorated policy or service function, the documented shape, with the denial asserted at the call
   site. (`code/docs/BACKEND-CODING-PRINCIPLES.md:91-107`)
3. **Deleted statements and `raise`s, and bare-name guards** (PY 7). **Reaches it:** cosmic-ray's `AddNot`
   for bare guards (PA 2); poodle's `Return` for a returned attribute such as `return user.attr` (PA 5);
   assertions on an exception's type and arguments, which mutmut mutates; a hand-planted deletion.
4. **Module-level code** (settings, URL patterns, compiled constants) under mutmut (PY 4). **Reaches
   it:** cosmic-ray, which seeds mutations from every node of a module (PA 2), and poodle, whose
   mutators walk the whole parsed module (PA 5); a direct test of the value; a hand-planted mutant.
5. **Bruno and Playwright suites** hit a server that never executes a mutmut mutant (DJ 5). **Reaches
   it:** in-process pytest tests through Django's test client run inside the child _(reasoned)_; under
   cosmic-ray or poodle, a test command that boots its own server from the mutated files, one boot per
   mutant, or a dev server reloading cosmic-ray's in-place edits (RE 5) _(reasoned, not run)_; a
   hand-planted mutant against a running server.
6. **Shell gates** are not Python. **Reaches it:** the self-test practice already here — a known positive
   and negative per gate, the rule that a gate never seen to fail is no gate, and self-tests in which every
   check fires on its own planted mutation. (`code/src/scripts/audits/CLAUDE.md:124-130`; `CHANGELOG.md:327`; `.github/scripts/shipped-memory.sh:234`)
7. **The PyO3 boundary:** cargo-mutants mutates the Rust, but nothing tests the Python-visible side
   (RE 10), and the `extension-module` feature breaks tests needing `libpython`.
   (https://pyo3.rs/v0.29.0/faq.html; `PyO3/pyo3@v0.29.0:guide/src/faq.md:29-32`)
8. **Slint:** the UI is pasted in by `slint::include_modules!()`, generated code cargo-mutants handles
   poorly (RS 6); `.slint` markup is not Rust; the crate has no `#[test]`. No markup mutation tool was
   read, so absence is not established. (`code/src/rust/crates/desktop/src/main.rs:43`)
9. **Equivalent mutants** cannot in general be detected automatically (GA 4). **Handled by:** a reasoned
   suppression in each tool's syntax (PY 11, RS 5; Stryker's disable comments carry a reason into its
   report). (https://stryker-mutator.io/docs/stryker-js/disable-mutants/)
10. **Unobservable mutants:** cargo-mutants will replace `SecretBytes`'s `Drop::drop` body with `()`
    (RS 1), leaving the secret unwiped; no functional test sees that, yet it is not equivalent. The tool
    offers a commented skip (RS 5); no repository guide names a test of the wipe.
    (`code/src/rust/crates/nativecore/src/lib.rs:95-99`; `code/docs/rust/MEMORY-HYGIENE.md`)

### GA — Gating evidence

1. Google 2018 found an absolute mutation score infeasibly expensive at its scale, with no actionable way
   to surface one. It mutates only added or changed, covered, non-arid lines, one mutant per line at most,
   and reports survivors as code-review findings; arid-node suppression, a curated per-language rule set
   grown from feedback, is what the authors say keeps users, and 75% of the 11,049 findings given feedback
   were rated useful. (Petrovic and Ivankovic, ICSE-SEIP 2018, Sec. 2.2, 3, 4.1, 5.4)
2. TSE 2021: an author may submit with automated findings, mutants included, **still open**, except
   where a reviewer has made one compulsory; reported survivors are capped at 7 times the files in a
   changelist, set empirically to bound cognitive load; line coverage is a prerequisite; the detection
   ratio is too costly and not actionable; 10 languages, Python and Kotlin among them, Rust and Swift not.
   Both Google papers say their kill rate is not a mutation score.
   (Petrovic, Ivankovic, Fraser, Just, IEEE TSE 2021, Sec. 2, 2.1-2.4, 5.3)
3. TSE 2021: developers at first judged 85% of reported mutants unproductive, a share suppression
   brought down to 11%. Three early suppression heuristics (logging, time-related code, configuration
   flags) gave the largest gain, the productive share rising from roughly 15% to 80% and later
   refinements taking it to 89%. At the median a changelist yields 820 mutants under traditional
   generation and 7 with arid-node suppression plus one mutant per line. (Sec. 1, 3.2.5, 5.2)
4. TSE 2021: equivalent mutants cannot in general be detected automatically. (Sec. 3.2.2, 6)
5. ICSE 2021: projects opt in; analysis is change-based during review only, with no manual or
   project-level runs; more exposure correlates with more and stronger tests; 1,043 of 1,502
   high-priority bugs (70%) were coupled to a mutant that would have been reported live on the
   bug-introducing, already-covered change; on over 90% of lines every mutant shares one fate.
   (Petrovic, Ivankovic, Fraser, Just, ICSE 2021, arXiv 2103.07189v1, Sec. II, III-C, IV-C, IV-D)
6. Facebook (arXiv 2010.13464v3) scheduled mutant runs off peak, 19:00 to 07:00 Pacific time, and
   surfaced survivors alone. Against flaky tests it planted a log line in each mutant, counting a failure
   only from a test shown to have executed the mutant, and relied on the company's standing practice of
   switching off tests that stay flaky. (Beller et al., Sec. II-B, VI-E(3))
7. Native gate shapes: cargo-mutants blocks on a miss in a diff (RS 3); Stryker on an absolute score once
   `break` is set (MO 2); cosmic-ray on survival rate (PA 3); poodle via `--fail_under`; pytest-gremlins
   only through its Action; mutmut not at all (PY 11). No doc read describes a ratchet.
8. **Corrects the lead:** the `tests/` scripts' contract is 0/1/2; exit 3 ("clean, but a leg could not
   run") belongs to the `syntax/` family. The project's reporting rule counts a 0 from a run that examined
   nothing as "could not look" reported as clean; `--in-diff` exits 0 that way for an empty, non-Rust or
   unmatched diff (RS 3), and `mutmut run`'s 0 does not separate a clean run from one with survivors
   (PY 9). (`code/src/scripts/tests/CLAUDE.md:37-38`; `code/docs/GATE-REPORTING.md:12-24,53-63,117`)

### RE — This repository

1. The `test` group declares `mutmut>=3.0`, `uv.lock` pins 3.7.0, and no `[tool.mutmut]` or `setup.cfg`
   exists. `copier.yml` `_exclude` (`:40-328`) drops `/uv.lock` (`:55`) but neither `code/src/scripts/tests/`
   nor `pyproject.toml`, so the wrapper and the floor ship, and a generation-time lock now resolves 3.8.0
   _(reasoned)_. The wrapper last changed in `ee5c2bb` on 01/08/2026. (`pyproject.toml:201-208`; `uv.lock:1116-1117`)
2. **Four independent defects.** (a) **Not installed:** `uv run mutmut` runs in the dev `django` service
   (`code/src/scripts/tests/mutmut.sh:67-71`), whose image runs `uv sync` with no `--group`
   (`code/src/docker/django/Dockerfile.dev:21-22`) while `[tool.uv]` sets no `default-groups`
   (`pyproject.toml:85-107`); `code/src/scripts/tests/e2e-py.sh:88-92` records the same failure. (b) **A
   removed flag:** `run --paths-to-mutate` (`mutmut.sh:26,100`) is a usage error (PY 1). (c) **No config
   where mutmut looks:** `code/src/django` has no `pyproject.toml`, `setup.cfg`, `lib/`, `src/` or
   `django/`, so mutmut raises `FileNotFoundError` _(reasoned, PY 2)_. (d) **Wrong settings:** the dev
   service's `config.settings.dev` and `_dev` database (`code/src/docker/docker-compose.dev.yml:53-54`)
   outrank the ini's `config.settings.test` (`pyproject.toml:223`; DJ 3). (a) to (c) stop a run; (d) aims
   one that got past them at the dev configuration. Behind them _(reasoned)_, the ini `pythonpath`
   (`pyproject.toml:220`) and `manage.py` discovery put the original tree first: exit 1 (DJ 4).
3. `testpaths` is `code/src/django` and `addopts` has no `-m`; suites split only by `backend.sh -m`. Tests
   sit in `apps/` (7 files), 2 Playwright files in `code/src/django/tests/e2e/`, so _(reasoned)_ mutating
   `apps/` mutates test modules unless excluded, and the default `also_copy` brings the e2e tree.
   Measured: `apps/` has 13 functions outside tests and migrations, 3 decorated, leaving 10; its two
   `@dataclass` classes (`apps/health/checks.py:82,91`) have no methods, so PY 5's version difference
   reaches nothing today. (`pyproject.toml:221-222`; `code/src/scripts/tests/backend.sh:85`)
4. **The exit contract is false.** The header and help say 0 means every mutant killed (`mutmut.sh:18,53`)
   and `:102` prints "complete" unconditionally, but `mutmut run` exits 0 with survivors (PY 9). The 2 a
   run returns today _(reasoned, not run)_ comes from uv, not mutmut: with mutmut absent (RE 2a), `uv run`
   cannot spawn it, and uv maps that error to exit 2, which `docker compose exec` and `set -euo pipefail`
   (`:20`) carry out; it is not the wrapper's own `die`. Were mutmut installed, the removed flag (RE 2b)
   would also exit 2, through Click (PY 1). The image copies uv from the unpinned
   `ghcr.io/astral-sh/uv:latest`, read here at 0.13.1, the latest release on 15/10/2026. The scripts'
   contract forbids masking a failure; CI depends on it. (`code/src/scripts/tests/CLAUDE.md:37-38`;
   `code/src/docker/django/Dockerfile.dev:10`; `astral-sh/uv@0.13.1:crates/uv-command-support/src/lib.rs:78-84`,
   `crates/uv/src/lib.rs:3138-3170`, `crates/uv/tests/project/run.rs:3314-3324,4156-4162`)
5. `apply` (`mutmut.sh:119-126`) writes a mutant into the dev bind mount (`docker-compose.dev.yml:51`),
   which Uvicorn's reloader watches (`code/src/docker/django/entrypoint.dev.sh:27-32`), then advises
   `git checkout`, which also discards uncommitted edits to that file; a dev-container run would write
   `mutants/` inside the same watched tree _(reasoned)_. `git check-ignore -v` returns rc=1 for
   `mutants/` and `code/src/django/mutants/`, and neither `.gitignore` nor `.dockerignore` names it.
6. The test image installs `--group test` and bakes the source in, with test settings and a `_test`
   database, but `backend.sh` tears down with `down --volumes`, so _(reasoned)_ `mutants/` and mutmut's
   cache would not persist. (`code/src/docker/django/Dockerfile.test:24-27`; `code/src/docker/docker-compose.test.yml:48-49`; `backend.sh:75`)
7. **Wrong doctrine — the invariant register.** `how-to/src/INVARIANTS.md:110-117` names `mutmut.sh run`
   as the proof that removes an enforcement, with a constraint dropped from the model and a deleted `raise`
   as examples; mutmut 3 does neither (PY 4, 7), and a model-only drop never reaches the test schema (DJ 2).
   It calls the method slow, yet no file this note read records a runtime; `code/src/scripts/tests/CLAUDE.md:50-51`
   keeps it local-only and out of gates.
8. **Wrong doctrine — the testing guide and the wrapper.** `code/docs/testing/ADVANCED-TESTING.md:173`
   says no JavaScript suite exists to mutate, false wherever `INCLUDE_MOBILE` is answered (MO 1); `:175`
   and `mutmut.sh:12-13,47-48` set an 80% bar that no mutmut command enforces (PY 11).
9. The workspace enables PyO3's deprecated `extension-module` twice and floors maturin at `>=1.7,<2.0`;
   the FAQ's remedy is to drop the feature and adopt maturin 1.9.4+ (setuptools-rust 1.12 being the
   alternative). The crate already builds `cdylib` and `rlib`, as the FAQ requires for tests.
   (`code/src/rust/Cargo.toml:29`; `code/src/rust/crates/nativecore/pyproject.toml:10,29`, `Cargo.toml:26`; `PyO3/pyo3@v0.29.0:guide/src/faq.md:29-32,50-55`)
10. **Wrong doctrine — the PyO3 boundary.** `code/src/scripts/rust/test.sh:10-12` and
    `code/docs/RUST.md:122-131` describe Python-side boundary tests; `git grep -l nativecore -- '*.py'`
    returns nothing. The six Rust tests cover `constant_time_eq` and `clear`; none exercises `__repr__`,
    `expose`, `Drop::drop` or the module initialiser. (`code/src/rust/crates/nativecore/src/lib.rs:72-142`)

---

## Sources

Read at the pins in the citation keys and claims; the licence position follows each dash.

- **Permissive, reworded, nothing quoted** — mutmut (BSD-3-Clause); cosmic-ray, pytest-gremlins, poodle,
  cargo-mutants and https://mutants.rs/ (MIT); StrykerJS and https://stryker-mutator.io/docs/stryker-js/
  (Apache-2.0); the PyO3 0.29 FAQ (Apache-2.0 OR MIT); pytest 9.1.1 (MIT); pytest-django 4.14.0,
  Django 6.1.2 and Click 8.4.2 (BSD-3-Clause); uv 0.13.1 source (MIT OR Apache-2.0).
- **No grant, facts only** — mutmut #544, #545, #565 and stryker-js #6022, #6023, #6108, #6219, #6253,
  #6254 (GitHub user content); PyPI feeds and version JSON (PyPI Terms of Use); repository metadata for
  mutatest (MIT), MutPy (Apache-2.0), xmutant (GPLv3) and mutahunter (AGPL-3.0).
- **Papers, cited and never quoted, no copy committed** — Google 2018, _State of Mutation Testing at
  Google_, https://storage.googleapis.com/gweb-research2023-media/pubtools/4203.pdf (owner/authors'
  copyright; personal and classroom copying only); TSE 2021, _Practical Mutation Testing at Scale_,
  accepted manuscript, https://homes.cs.washington.edu/~rjust/publ/practical_mutation_testing_tse_2021.pdf
  (CC BY 4.0 per its footer; the published IEEE version was not read); ICSE 2021, _Does mutation testing
  improve testing practices?_, https://arxiv.org/abs/2103.07189v1, and Facebook, _What It Would Take to
  Use Mutation Testing in Industry_, https://arxiv.org/abs/2010.13464v3 (arXiv non-exclusive licence 1.0).
- **This repository at `d16de16`** — the paths cited per claim; `git check-ignore`, `git grep` and
  `git log` as measurements.

### Added 15/10/2026, for the Addendum

Read on 15/10/2026 at the pins in the Addendum's citation keys; the licence position follows each dash.

- **Permissive, reworded, nothing quoted** — PIT 1.30.1, mutflow 1.7.0, `mutation-testing-elements`
  3.8.4, `apple/swift-argument-parser` 1.6.1, `pitest-mutation-testing-elements-plugin` 0.7.1, the
  `koral--/gradle-pitest-plugin` README and releases, and the archived `pitest/pitest-kotlin` README
  (Apache-2.0); `szpak/gradle-pitest-plugin` 1.19.0 (its tree carries the Apache-2.0 text, though
  GitHub reports no licence); Muter at `7f1f2584` and at tag `16`, and `dart_mutant` 0.5.1 (MIT);
  `mutation_test` 1.8.1 (BSD-3-Clause); cargo at `c980f486` and `library/std` at Rust 1.97.1
  (`MIT OR Apache-2.0`); cargo-mutants' book at v27.1.0 and the published https://mutants.rs/timeouts.html and
  https://mutants.rs/in-place.html (MIT).
- **Metadata only, nothing derived** — Mutant-Kraken (MIT; its README's maturity line read), moco and
  Mull (Apache-2.0), `mull-xctest` (MIT), and Descartes (LGPL-3.0, weak copyleft).
- **Share-alike, read as a checklist** — https://pitest.org/faq/ (`CC-BY-NC-SA-3.0`): two facts
  restated in this note's own words (where PIT keeps its mutants; Kotlin only through Arcmutate), no
  wording or rule taken.
- **No grant, facts only** — Arcmutate's vendor pages https://docs.arcmutate.com/docs/kotlin.html,
  https://docs.arcmutate.com/docs/android.html,
  https://docs.arcmutate.com/docs/releases/kotlin-plugin.html, https://docs.arcmutate.com/licence.html
  and https://www.arcmutate.com/ (the plugins themselves sit under a proprietary EULA); Muter PR #306,
  and cargo-mutants issues #403 and #407 and PR #627, each with its comments (GitHub user content);
  `Formula/muter.rb` in `muter-mutation-testing/homebrew-formulae` (no licence); pub.dev's version API
  for `mutation_test` (pub.dev terms); GitHub repository, release, tag, compare and code-search
  metadata (GitHub terms).
- **Unavailable** — https://www.arcmutate.com/pricing answered HTTP 404 (a missing page, not a
  refusal); the home page's pricing section was read in its place.
- **This repository at `d16de16`, and this host** — `code/src/rust/` (`Cargo.toml`, `.gitignore`,
  `rust-toolchain.toml`) and `code/src/scripts/rust/test.sh` at the lines cited; `git grep` as a
  measurement; the session's environment and a listing of `~/.cargo`; the host's agent instructions
  (outside the repository, not reproduced), cited in N-014 on MAP-MUTATION-TESTING, item 18, for the
  policy only.
- **Locators only, never cited** — two WebSearch queries, which found mutflow, Mutant-Kraken,
  `mull-xctest`, `mutation_test` and `dart_mutant`.

---

## Addendum - CHART Step 7 research nodes, 15/10/2026

**Written**: 15/10/2026 | **Driver**: the three research nodes `MAP-MUTATION-TESTING` deferred to a
later Step 7 when it was charted (N-012 on MAP-MUTATION-TESTING, N-013 on MAP-MUTATION-TESTING and N-014 on MAP-MUTATION-TESTING) | **Read at**: this
repository `d16de16`; each outside source at the tag or commit its citation key names

**Method.** Two reading legs, one for N-012 on MAP-MUTATION-TESTING and N-013 on
MAP-MUTATION-TESTING, one for N-014 on MAP-MUTATION-TESTING, read the primaries, and the writer of
this addendum re-opened every load-bearing one on 15/10/2026: repository files through `gh api` at
the pinned tag or commit, and web pages through the `scrapling` MCP — `bulk_get` and `make_request`
for the Arcmutate documentation, pitest.org, mutants.rs and pub.dev, and `fetch` once, for the
Arcmutate home page, which `make_request` returned as an empty shell. `context7` and Perplexity were
unauthenticated this session and were **not consulted** (`code/docs/GATE-REPORTING.md`: could not
look, not looked-and-clean). `WebFetch` was not used, and WebSearch only located sources. **Nothing
was executed**: _(reasoned)_ marks an inference from source, and every exit status that a tool's own
code does not print is one. Where the re-read differed from a reading leg, the primary is what is
recorded (N-012 on MAP-MUTATION-TESTING, items 12, 21 and 25). **Facts only:** which tool a leg uses
and how its verdicts map onto the runner contract stay with N-019 on MAP-MUTATION-TESTING, N-020 on
MAP-MUTATION-TESTING, N-030 on MAP-MUTATION-TESTING, N-039 on MAP-MUTATION-TESTING and N-040 on
MAP-MUTATION-TESTING.

**Measured: nothing quoted.** A first count on 15/10/2026 reported 0 shared runs. A fuller
comparison later that day found three it had missed, each against a copy the first set lacked or had
cut short: a version-floor run in the `koral--/gradle-pitest-plugin` README, and two licence names,
pitest.org's in its footer's licence link and cargo's in its `Cargo.toml`. The run was reworded and
both licence names are now written as backticked SPDX expressions; two runs straddling backticked
names, shared with the mutflow README and cargo's build-cache page, were reworded too, and the count
was redone. **How it was counted.** The prose is this addendum, its entry under Sources, the Feeds
rows and the body lines that point to it. Curly apostrophes were straightened and full URLs (from
`http` to the next space) removed, and nothing else: domain-shaped words, backticked spans and
citation brackets all stayed in. It was lowercased and broken on every non-alphanumeric character
into word five-grams: 7,782 distinct. The comparison copies were raw pages taken with an
impersonating `curl` and kept whole, each read four ways (visible text; script contents; every
attribute value, meta descriptions among them; the whole page with tags stripped), plus the GitHub
files and API records through `gh api` and the earlier `scrapling` copies: 645 text copies, covering
the five Arcmutate pages, pitest.org's FAQ, the two mutants.rs pages, pub.dev's page and API record,
Muter PR #306, cargo-mutants issues #403 and #407, PR #627 and the compare record, the Homebrew
formula, the repository metadata and every source file cited. **Result.** No run of prose is shared
with any source, no-grant or permissive. 52 five-grams are shared, every one inside or touching a
backticked identifier, path or version string (source paths in PIT, Muter, StrykerJS,
`mutation_test` and the cargo-mutants book, the Stryker status names and disable syntax, mutflow's
output paths, repository names and GitHub API paths, `mutation_test` 1.8.1, and two licence
expressions, `CC-BY-NC-SA-3.0` and `MIT OR Apache-2.0`), each matching the file or record it names.
With backticked spans removed as well (5,976 distinct five-grams), **0** are shared. Identifiers,
flags, paths and version strings sit in backticks as facts.

**Citation keys.** `pit:` = `hcoles/pitest@1.30.1:`; `gpp:` =
`szpak/gradle-pitest-plugin@release/1.19.0:`; `mf:` = `anschnapp/mutflow@v1.7.0:` (`66af91a`, also
`master` on 15/10/2026); `mu:` = `muter-mutation-testing/muter@7f1f2584:` (`master`, 21/07/2026);
`mu16:` = the same repository at tag `16`; `sap:` = `apple/swift-argument-parser@1.6.1:`; `mte:` =
`stryker-mutator/mutation-testing-elements@v3.8.4:`; `mt:` = `domohuhn/mutation-test@v1.8.1:`; `dm:` =
`Nimblesite/dart_mutant@v0.5.1:`; `cg:` = `rust-lang/cargo@c980f486:` (cargo 0.98.0, the cargo Rust
1.97.1 pins); `cm:` and `sj:` as above. Long Java paths drop their shared prefix after first use.

**Questions.** N-012 on MAP-MUTATION-TESTING: which Kotlin/JVM and Swift mutation tools exist and
are maintained, under what licence, and how does each report survivors, timeouts, interruption and
exit status? N-013 on MAP-MUTATION-TESTING: what do StrykerJS and the Dart/Flutter tools report, and
how, so a mobile language beyond Kotlin and Swift could join the contract? N-014 on
MAP-MUTATION-TESTING: with `CARGO_TARGET_DIR` set outside the repository, does cargo-mutants share
one target directory across its scratch builds, and what does that do under `--jobs` or
`--in-place`?

**Verdict.** **JVM:** PIT is the one maintained open-source engine, but it handles Kotlin well only
through Arcmutate's proprietary plugin, whose licence cannot travel in a generated project; mutflow is
the only maintained open-source Kotlin-native option found, and it is young. **Swift:** Muter alone is
maintained, runs only on macOS, and its last release is three years behind the code read. **Exits:**
no mobile tool read separates "survivors over the limit" from "could not run" by exit status alone,
and several score an infrastructure failure as a kill. **Shared format:** the Stryker report schema is
the nearest thing to one. **Rust:** a host-set `CARGO_TARGET_DIR` is inherited by every scratch build,
so all of them, and the developer's own, share one directory _(reasoned, not run)_, with a lock queue,
a wrong-mutant race and a stale mutant build as the consequences.

### N-012 on MAP-MUTATION-TESTING — Kotlin/JVM and Swift: the tools, their licences, and how each reports

**Answer.** On the JVM, PIT is maintained and Apache-2.0, but it counts a timeout, an out-of-memory
fork and an unexplained run error as kills, fails on survivors only when a threshold is set, and on
its command line gives one exit status to a threshold breach and to an analysis error. Kotlin needs a
filter: the open-source one is archived, the maintained one is Arcmutate's paid plugin, and the
open-source alternative is mutflow, a compiler plugin that runs inside the JUnit suite. For Swift,
Muter is the only maintained tool: macOS only, scoring any unclassified non-zero test exit as a kill,
and exiting 0 whatever survives.

1. **PIT.** Release 1.30.1, published 14/10/2026, is the latest; Apache-2.0; not archived. It
   mutates compiled bytecode, not source. (`gh api repos/hcoles/pitest` and `/releases/latest`; https://pitest.org/faq/,
   the question on finding nothing to mutate)
2. Every mutant ends in one of ten statuses: `KILLED`, `SURVIVED`, `TIMED_OUT`, `NON_VIABLE`,
   `MEMORY_ERROR`, `NOT_STARTED`, `STARTED`, `RUN_ERROR`, `NO_COVERAGE`, `EQUIVALENT`. Six of them
   count as detected (`KILLED`, `TIMED_OUT`, `NON_VIABLE`, `MEMORY_ERROR`, `RUN_ERROR`, `EQUIVALENT`), so
   a timeout, an out-of-memory fork and an unexplained error each score as a kill; only `SURVIVED`,
   `NO_COVERAGE` and the two internal states count against the score.
   (`pit:pitest/src/main/java/org/pitest/mutationtest/DetectionStatus.java:22-75,108-110`)
3. The forked test JVM (the minion) exits 0, 11 (out of memory), 13 (unknown), 14 (timeout), 15 (a
   test-plugin problem) or -1 (it died); PIT records 11 as `MEMORY_ERROR`, 14 as `TIMED_OUT` and any
   other failure as `RUN_ERROR`. (`pit:pitest/src/main/java/org/pitest/util/ExitCode.java:19`;
   `DetectionStatus.java:91-99`)
4. A mutant times out when a test outlasts its unmutated duration times a factor, plus a constant: 1.25
   and 4,000 ms in the engine, 1.25 and 3,000 ms in the Maven goal.
   (`pit:pitest/src/main/java/org/pitest/mutationtest/build/PercentAndConstantTimeoutStrategy.java:24-25,37-38`;
   `pit:pitest-maven/src/main/java/org/pitest/maven/PitMojo.java:171-178`)
5. Survivors never fail a run by default: `mutationThreshold`, `testStrengthThreshold` and
   `coverageThreshold` default to 0, which switches each off, and `maxSurviving` to -1, likewise. A
   configured one that is breached raises `MojoFailureException` under Maven and `RuntimeException` on
   the command line. (`PitMojo.java:268-287,494-501,582-590`;
   `pit:pitest-command-line/src/main/java/org/pitest/mutationtest/commandline/MutationCoverageReport.java:48-55,95-103`;
   `pit:pitest-entry/src/main/java/org/pitest/mutationtest/config/ConfigOption.java:208`)
6. A run that finds nothing to mutate fails by default: `failWhenNoMutations` is true and raises
   `PitHelpError`; turned off, PIT logs a warning and returns empty statistics. A test that fails while
   coverage is gathered stops the run unless `skipFailingTests`, false by default, is set.
   (`ConfigOption.java:143-147`;
   `pit:pitest-entry/src/main/java/org/pitest/mutationtest/tooling/MutationCoverage.java:130-138,396-403`;
   `PitMojo.java:213-214`)
7. On the command line a malformed argument prints the help and the error, and `main` then returns
   normally, so the JVM exits 0 _(reasoned)_. A threshold breach and an analysis error both leave `main`
   as an uncaught exception, which the JVM reports as 1 _(reasoned)_, so that status cannot tell "too
   many survivors" from "PIT could not run". When the Maven goal decides to skip (`skipPitest`, for
   example), it logs its reasons at info level and succeeds. (`MutationCoverageReport.java:34-56,105-116`;
   `PitMojo.java:333-334,503-508`)
8. The machine-readable report is `mutations.xml` (HTML is the default; XML and CSV are opt-in), and
   each mutation element carries `detected` and `status` attributes. The root element opens when the
   run starts and closes only when it ends, so an interrupted run leaves the file unterminated
   _(reasoned)_. Mutants live in memory and reach disk only through the `EXPORT` feature, and then only
   under the report folder.
   (`pit:pitest-entry/src/main/java/org/pitest/mutationtest/report/xml/XMLReportListener.java:62,82-86,183-201`;
   `pit:pitest-entry/src/main/java/org/pitest/mutationtest/report/csv/CSVReportFactory.java`;
   `pit:pitest-command-line/src/main/java/org/pitest/mutationtest/commandline/OptionsParser.java:311-317`;
   https://pitest.org/faq/, the question on releasing mutated code)
9. The usual Gradle integration, `szpak/gradle-pitest-plugin` 1.19.0 (29/03/2026), runs PIT's
   command-line entry class as a Gradle `JavaExec` task and defaults to PIT 1.22.1. Gradle fails such a
   task on a non-zero JVM exit, so a threshold reaches the build only through that status _(reasoned)_.
   (`gpp:src/main/groovy/info/solidsoft/gradle/pitest/PitestTask.groovy:51,267-268`;
   `gpp:src/main/groovy/info/solidsoft/gradle/pitest/PitestPlugin.groovy:58`; `gpp:LICENSE-2.0.txt`)
10. **Kotlin.** PIT's own Kotlin plugin (Apache-2.0) is archived, last pushed 01/03/2023; its README
    declares it unmaintained and sends Kotlin users to Arcmutate's commercial plugin, and pitest.org lists Kotlin as
    supported only through that plugin. (`pitest/pitest-kotlin` README.md:1-11;
    `gh api repos/pitest/pitest-kotlin`; https://pitest.org/faq/, the question on other JVM languages)
11. Arcmutate's Kotlin plugin (newest release listed: 1.5.1; it needs PIT 1.22.0 or later) removes
    mutants in bytecode the Kotlin compiler generates with no source counterpart — coroutines,
    intrinsics, null checks and inline-function copies among the cases it lists — and merges a
    mutant's inlined copies into one result. It needs a paid licence, either an `arcmutate-licence.txt`
    file at the project root or one retrieved dynamically.
    (https://docs.arcmutate.com/docs/kotlin.html; https://docs.arcmutate.com/docs/releases/kotlin-plugin.html)
12. That licence is a proprietary EULA: clause 24 bars the licensee from distributing the software or
    granting any third party rights in it, and clause 29 ties each licence to a user count and to Java
    packages named at purchase, for the term on its certificate. _(Reasoned)_ It cannot travel inside a
    generated project, since each project would need its own. The home page prices the product per user
    per month with a free trial, and offers open-source projects a free licence on request; which tier
    includes the Kotlin plugin is not stated. (https://docs.arcmutate.com/licence.html, clauses 24 and
    29; https://www.arcmutate.com/, read with `fetch`)
13. Arcmutate's Android plugin is a beta for customers, meant to be paired with the Kotlin plugin, and
    needs PIT 1.22.0 or later. It covers only tests that share the JVM with the code being tested,
    Robolectric included when `excludeMockableAndroidJar` is false, and never instrumented device tests;
    the page says the standard Gradle plugin does not suit Android builds and points to the community
    fork. (https://docs.arcmutate.com/docs/android.html)
14. That fork, `koral--/gradle-pitest-plugin` (Apache-2.0), released v0.3.0 on 15/10/2026. It needs
    JDK 17 and version 8.5.1 of the Android Gradle Plugin at the least, and adds a pitest task per
    build variant that has unit tests switched on. (`koral--/gradle-pitest-plugin` README.md, blob
    `62e21cce`, :3-9,53-55; `gh api repos/koral--/gradle-pitest-plugin/releases`)
15. mutflow 1.7.0 (tagged 07/10/2026; Apache-2.0; repository created 17/01/2026) is the one maintained
    open-source Kotlin alternative found. A K2 compiler plugin, it compiles every mutant into the test
    build once as a switchable branch and activates each in turn during the ordinary JUnit run, leaving
    the production artefact unmutated. A release fails against a Kotlin older than the one it was built
    with (1.0.2 onward need Kotlin 2.4). It mutates only code reached inside `MutFlow.underTest { }` and
    stays silent about code the tests never reach. (`mf:README.md:13,31-37,45-50,64-78`)
16. In mutflow's default `STRICT` mode a survivor fails the test class with `MutantSurvivedException`;
    `LENIENT` reports without failing, and `DISABLED` runs only the baseline. `ACCUMULATE` moves the
    verdict into Gradle: each class writes what it saw to `build/mutflow/results/<TestClass>.json`, and
    `mutflowAccumulateReport` merges the files, writes `build/reports/mutflow/mutation-report.md` and
    fails on survivors unless `failOnSurvivors` (default true) is off. The merge scores a mutant that
    timed out under any one class as killed. (`mf:README.md:173-176,358-373,396-407`)
17. Loop checks end a mutation run after 60 s by default, and every test also has a budget of three
    times its baseline plus 1 s; either way the test fails with `MutationTimedOutException`, in every
    mode, and a test still running 10 s past its budget makes the test JVM exit. Suppression is
    `@SuppressMutations` on a class or function, or a `mutflow:ignore` or `mutflow:falsePositive` line
    comment followed by free text. Android unit suites run through a JUnit 4 runner; Kotlin/Native
    builds are published for `linuxX64` and `mingwX64` only, with no Apple target yet.
    (`mf:README.md:178-181,293-320,400,419-450,566-576,691-699`)
18. The other Kotlin candidates are not maintained ones: Mutant-Kraken (MIT, written in Rust) calls
    itself beta and last released v0.1.6 on 06/11/2025, and moco (Apache-2.0), aimed at Java Maven
    projects, last released 1.0.1 on 10/05/2021. Descartes, an alternative engine for PIT, is LGPL-3.0
    (weak copyleft) and last released on 19/09/2025. (`JosueMolinaMorales/mutant-kraken` README.md:107;
    `gh api` repository and release metadata for the three)
19. An Apache-2.0 plugin, `pitest-mutation-testing-elements-plugin` v0.7.1 (16/03/2026), writes PIT's
    results in the Stryker report schema: `KILLED` becomes Killed, `SURVIVED` Survived, `NO_COVERAGE`
    NoCoverage, `TIMED_OUT` Timeout, `MEMORY_ERROR` and `RUN_ERROR` RuntimeError, `NOT_STARTED` Pending
    and `NON_VIABLE` Ignored, while `STARTED` and every unlisted status, `EQUIVALENT` included, fall to
    RuntimeError. A mutant PIT counts as detected because it was non-viable is therefore dropped from
    the schema's score instead _(reasoned, from N-013 on MAP-MUTATION-TESTING, item 3)_.
    (`Wmaarts/pitest-mutation-testing-elements-plugin@v0.7.1:src/main/java/org/pitest/elements/models/json/JsonMutantStatus.java:15-37`)
20. **Swift.** Muter (MIT) is the only maintained Swift tool found. `master` has commits to
    21/07/2026, but the newest release is still `16`, of 16/09/2023, and the Homebrew formula builds that tag. Its manifest
    declares macOS as the one platform (12 at `master`, 10.15 at `16`), and the README's FAQ confines it
    to macOS and to projects tested with `xcodebuild`, though a README badge also names Linux.
    (`gh api repos/muter-mutation-testing/muter` and `/releases/latest`;
    `muter-mutation-testing/homebrew-formulae` `Formula/muter.rb:4`; `mu:Package.swift:8-10`;
    `mu16:Package.swift:9`; `mu:README.md:4,340-344`)
21. **Release `16` is not `master`.** Items 22 to 28 are read at `master`. Release `16` has neither the
    `timeout` outcome nor any per-mutant timeout key, and it predates PR #306 (merged 21/07/2026), which
    made Muter recognise Swift Testing failures it had been filing as `runtimeError`. It shares
    `master`'s scoring function, its exit of -1 on any thrown error, and the update check. (the two
    trees compared with `diff`: `Sources/muterCore/TestReporting/TestSuiteOutcome.swift`,
    `Configuration/MuterConfiguration.swift`, `TestReporting/mutationScoring.swift`;
    `mu16:Sources/muterCore/CLICommands/RunCommand/Run.swift:80-94`;
    `mu16:Sources/muterCore/MuterRunSteps/UpdateCheck.swift:10`;
    `gh api repos/muter-mutation-testing/muter/pulls/306`)
22. Muter builds every mutant into one shared copy of the project (mutant schemata) and turns each on
    through an environment variable. The copy is a sibling directory, the project's name with
    `_mutated` appended, and logs go to `muter_logs/<timestamp>` under the working directory. The next
    run deletes a copy left by the last one; none of the 105 files under `Sources/` installs a signal
    handler, so an interrupted run leaves the copy and writes no report _(reasoned)_.
    (`mu:README.md:288`; `mu:Sources/muterCore/MutationSteps/CreateTempDirectoryURL.swift:16-22`;
    `mu:Sources/muterCore/SourceCodeOperations/fileOperations.swift:33`;
    `mu:Sources/muterCore/MutationTesting/MutationTestObserver.swift:93-96`;
    `mu:Sources/muterCore/MutationSteps/PreviousRunCleanUp.swift:10-26`; every `Sources/` file searched
    for signal handling)
23. There are six outcomes: `passed` (survived), `failed` (killed by a test), `runtimeError` (reported
    as killed), `buildError`, `noCoverage` and `timeout`. The outcome is read from the test log: a
    timeout first, then build-error strings, then failure strings or a failure pattern; any other
    non-zero exit becomes `runtimeError`, so an infrastructure failure that exits non-zero scores as a
    kill _(reasoned)_. (`mu:Sources/muterCore/TestReporting/TestSuiteOutcome.swift:3-82`)
24. The score is `failed` plus `runtimeError` over every outcome except `buildError`, times 100, and
    -1 when there are no results; timeouts and `noCoverage` count against it.
    (`mu:Sources/muterCore/TestReporting/mutationScoring.swift:1-14`;
    `mu:Sources/muterCore/TestReporting/MuterTestReport.swift:15-18`)
25. Muter has no failure threshold (its `coverageThreshold` key filters files by coverage), so a run
    that completes exits 0 however many mutants survive. A thrown error prints a banner and exits -1,
    255 on POSIX; the thrown errors include a red baseline, five build errors in a row, no source files
    and no mutation points. An argument error leaves through swift-argument-parser, which exits with
    `EX_USAGE` (64) everywhere but Windows and WASI; `master`'s lockfile pins 1.6.1 and release `16`'s
    1.2.2 _(reasoned)_. (`mu:Sources/muter/main.swift:4-7`;
    `mu:Sources/muterCore/CLICommands/Muter.swift:19-22`;
    `mu:Sources/muterCore/CLICommands/RunCommand/RunCommand.swift:10-28`;
    `mu:Sources/muterCore/CLICommands/MuterError.swift:3-14`;
    `mu:Sources/muterCore/MutationTesting/MutationTestingAbortReason.swift:1-5`;
    `mu:Sources/muterCore/MutationSteps/PerformMutationTesting.swift:14,72-76,149-152`;
    `mu:README.md:177`; `mu:Package.resolved:40-45`;
    `sap:Sources/ArgumentParser/Utilities/Platform.swift:73-82`)
26. No per-mutant timeout applies by default. The key the configuration decoder reads is
    `mutationTestTimeout`, while the README documents `testSuiteTimeout`, so a configuration written
    from the README is ignored and runs untimed _(reasoned)_. Turning a schema on discards its error
    (`try?`), so a failed activation tests the unmutated build and records a survivor, not an error
    _(reasoned)_. (`mu:Sources/muterCore/Configuration/MuterConfiguration.swift:12,28,56-57`;
    `mu:README.md:178`; `PerformMutationTesting.swift:101-105`)
27. Unless `--skip-update-check` is passed, every run asks the GitHub releases API whether a newer
    version exists, swallowing any failure; the README's FAQ says Muter has no network access.
    (`mu:Sources/muterCore/MutationSteps/UpdateCheck.swift:30,53-73`;
    `mu:Sources/muterCore/MutationTesting/MutationTestHandler.swift:58-59,116-118`;
    `mu:README.md:237,364`)
28. Reports come as plain text (the default), JSON, HTML or Xcode issue lines. Suppression is a
    `muter:disable` and `muter:enable` comment pair or a substring `exclude` entry; neither has a place
    for a reason. (`mu:README.md:155-171,249-258,270-284`)
29. No other maintained Swift tool was found: `mull-xctest` (MIT) describes itself as experimental and
    was last pushed on 12/07/2021, and Mull (Apache-2.0, 0.34.1 of 13/09/2026) covers C and C++ only.
    (`gh api repos/kateinoigakukun/mull-xctest`; `gh api repos/mull-project/mull` and its latest release)

### N-013 on MAP-MUTATION-TESTING — StrykerJS and the Dart/Flutter tools: what a later mobile language would bring

**Answer.** StrykerJS 10.0.0 is the reference shape: each mutant takes one of the eight statuses of a
shared report schema, timeouts count as detected and errors are left out of the score, and the process
exits 1 only below a `break` threshold that is off by default — so it exits 0 by default, and also
with `break` set whenever nothing valid was examined. Dart and Flutter have two maintained tools, and both
write each mutant into the real source file. `mutation_test` (BSD-3-Clause) is language-agnostic,
judges by exit code and keeps a usage error, a processing error and a low score on separate statuses,
but reads an empty run as 100%. `dart_mutant` (MIT) writes near-Stryker JSON, gives a low score and
any error the same exit, and can only run `dart test`. The four mobile tools read share no exit
convention; a language joining the contract of N-019 on MAP-MUTATION-TESTING brings its own verdict mapping, its own could-not-run
detection and its own output folder.

1. **StrykerJS and the shared schema.** StrykerJS 10.0.0 pins `mutation-testing-elements`,
   `-metrics` and `-report-schema` at 3.8.4. (`sj:packages/core/package.json:83-85`)
2. The schema (Apache-2.0) gives each mutant one of eight statuses — `Killed`, `Survived`,
   `NoCoverage`, `CompileError`, `RuntimeError`, `Timeout`, `Ignored`, `Pending` — and an optional
   `statusReason` for the failure or error text. (`mte:packages/report-schema/src/mutation-testing-report-schema.json:88-97`)
3. The metrics package counts Killed plus Timeout as detected and Survived plus NoCoverage as
   undetected; the two together are the valid total. CompileError and RuntimeError are invalid, Ignored
   and Pending stand outside both, and the score is detected over valid, times 100, or NaN when nothing
   is valid. A disabled mutant stays in the report as Ignored and does not move the score.
   (`mte:packages/metrics/src/calculateMetrics.ts:9,224-256`; `sj:docs/disable-mutants.md:57`)
4. StrykerJS sets exit code 1 only when the final score is under `thresholds.break`, whose default,
   `null`, never fails. With no valid mutant the score is NaN, which is never under `break`, so even
   with `break` set a run that examined nothing exits 0 _(reasoned)_.
   (`sj:packages/core/src/reporters/mutation-test-report-helper.ts:202-224`;
   `sj:docs/configuration.md:567-580`)
5. Finding no input files, an initial run that executes no tests (unless `allowEmpty`) and a failing
   test in that run each raise a `ConfigError`; an error or timeout in the initial run raises a plain
   error. With `allowEmpty` and no tests, or with `dryRunOnly`, the run ends with no mutant results.
   Errors are logged and rethrown from a commander action started with `parse()`, so Node's default
   handling of the unhandled rejection exits 1, the same status as a breach _(reasoned, not run)_.
   (`sj:packages/core/src/process/1-prepare-executor.ts:110-111`;
   `sj:packages/core/src/process/3-dry-run-executor.ts:99-102,119-140`;
   `sj:packages/core/src/process/4-mutation-test-executor.ts:89-100`;
   `sj:packages/core/src/stryker.ts:102-123`; `sj:packages/core/src/stryker-cli.ts:63-73,159`)
6. On SIGABRT, SIGINT, SIGHUP or SIGTERM it runs its exit handlers and exits with 128 plus the signal
   number (130 for SIGINT); a second signal exits at once. Those handlers save the partial results to
   the incremental file when `--incremental` is on, and in `inPlace` mode put the original sources
   back. (`sj:packages/core/src/unexpected-exit-handler.ts:7-44`;
   `sj:packages/core/src/reporters/mutation-test-report-helper.ts:81-94`;
   `sj:packages/core/src/sandbox/sandbox.ts:62-64`)
7. A test run is killed after its baseline time times `timeoutFactor` (1.5), plus `timeoutMS` (5,000)
   and the measured overhead; a Timeout counts as detected (item 3). Work happens in a `.stryker-tmp`
   sandbox unless `inPlace` overwrites the real files and restores them afterwards. The default
   reporters are clear-text, progress and HTML; JSON goes to `reports/mutation/mutation.json` only when
   its reporter is on, and the incremental file to `reports/stryker-incremental.json`.
   (`sj:docs/configuration.md:368-392,484-486,522-524,582-602`)
8. Suppression is `// Stryker disable|restore [next-line] <mutators>[: reason]`, and the reason is
   carried into the report. (`sj:docs/disable-mutants.md:115-119,176-181`)
9. **Dart and Flutter.** `mutation_test` 1.8.1, published to pub.dev on 12/09/2026 for Linux, macOS
   and Windows, is BSD-3-Clause. It mutates any text file by regular-expression replacement rules defined in XML, and
   runs each configured test command as its own process. With no command configured it infers
   `flutter test` when `pubspec.yaml` names the Flutter SDK and `dart test` otherwise, each with a 60 s
   timeout and an expected exit of 0. (https://pub.dev/api/packages/mutation_test;
   `gh api repos/domohuhn/mutation-test`; `mt:bin/mutation_test.dart:188-198`;
   `mt:lib/src/configuration/configuration.dart:99-131`)
10. Its verdict compares each command's exit code with the expected value: a mismatch is Detected and a
    match Undetected, so any non-zero exit, a crash or an infrastructure failure included, counts as
    Detected _(reasoned)_. A command past its timeout is sent SIGTERM and marked Timeout; given an lcov
    file, uncovered lines are marked NotCovered without a run. Only Detected counts as found, so
    Timeout and NotCovered both lower the detected percentage.
    (`mt:lib/src/core/test_runner.dart:48-81`; `mt:lib/src/mutation_test.dart:333-337`;
    `mt:lib/src/reports/report_data.dart:92-121,151-166`)
11. It exits 0 when the detected percentage meets the failure threshold (80% when none is configured),
    -1 (255 on POSIX) below it, 1 on a processing error, the test commands failing on unmodified code
    among them, and 2 on an argument error. With no mutations the detected percentage is 100, so it
    exits 0 _(reasoned)_. (`mt:bin/mutation_test.dart:160-185,238-244`;
    `mt:lib/src/mutation_test.dart:256-266`; `mt:lib/src/reports/ratings.dart:47-58`;
    `report_data.dart:164-166,173`)
12. It writes each mutant into the real source file and writes the original back once that file is
    finished. SIGINT stops it, sends SIGTERM to the running command and lets the restore happen; a hard
    kill would leave a mutant in the tree _(reasoned)_. Reports go to `mutation-test-report/` as HTML
    (the default), xUnit or JUnit, 1.8.1 having deprecated its Markdown and XML formats. No inline
    suppression comment carries a reason: exclusions are XML token pairs, regular expressions and line
    ranges. (`mt:lib/src/mutation_test.dart:155-160,320-327,346`;
    `mt:bin/mutation_test.dart:63-82,160-163`; `mt:CHANGELOG.md`, the 1.8.1 entry; `mt:README.md:248-262`)
13. `dart_mutant` 0.5.1 (03/06/2026; MIT; written in Rust; repository created 15/12/2025) has six
    statuses: Killed, Survived, Timeout (counted as killed), NoCoverage, Error and Pending. Any non-zero
    exit of the test run is Killed, so a mutant that does not compile scores as killed _(reasoned)_;
    Error means the test process could not be started. The score is Killed plus Timeout over every
    mutant bar Error, Pending and NoCoverage, and 0 when none is left.
    (`gh api repos/Nimblesite/dart_mutant` and `/releases/latest`; `dm:LICENSE`;
    `dm:src/mutation/mod.rs:23-35`; `dm:src/runner/mod.rs:248-272`; `dm:src/report/mod.rs:74-93`)
14. Its Stryker-style JSON writes both Error and Pending as CompileError, and NoCoverage, which its own
    score leaves out, counts against the schema's score _(reasoned, from item 3)_.
    (`dm:src/report/mod.rs:460-466`)
15. It exits 1 when the score is under `--threshold`, whose default is 0, and an error leaving `main`
    exits 1 too _(reasoned)_. No Dart files is an error; no mutations returns a zero score, which the
    default threshold passes. A red baseline stops the run before any mutant.
    (`dm:src/main.rs:22,38-49,141-143,196-204,250-253,309-330`; `dm:src/cli/mod.rs:86-88`)
16. It writes each mutant into the real file behind a guard that restores it when dropped, and runs
    mutants in parallel (one job per CPU by default), serialising only mutants of the same file, so
    mutants in different files of one package are live together while each test run goes
    _(reasoned)_. It always runs `dart test --reporter=compact`: `--test-command` is declared but never
    read, so a Flutter package cannot switch to `flutter test` _(reasoned)_. Defaults: a 30 s timeout,
    reports under `./mutation-reports` (HTML; JSON, JUnit and an LLM-oriented Markdown file on
    request); git-based incremental runs; AI mutation providers off unless one is chosen.
    (`dm:src/runner/mod.rs:20-33,101-106,153-157,227-236,295-306`; `dm:src/cli/mod.rs:78-92,106-108,122-174`)
17. _(Reasoned)_ The Stryker schema is the nearest thing to a shared report format: StrykerJS writes it
    natively, PIT through the plugin in N-012 on MAP-MUTATION-TESTING, item 19, and `dart_mutant`
    approximately, while Muter, mutflow and `mutation_test` each keep their own. Exit statuses have
    nothing in common: StrykerJS and `dart_mutant` give 1 to a breach and to an error alike;
    `mutation_test` separates the two (255 and 1) but passes an empty run; Muter has no threshold and
    gives 255 to every error. (items 4, 5, 11 and 15; N-012 on MAP-MUTATION-TESTING, items 19 and 25)

### N-014 on MAP-MUTATION-TESTING — cargo-mutants with CARGO_TARGET_DIR set outside the repository

**Answer.** Yes, by inheritance rather than design _(reasoned from source, not run)_. cargo-mutants
v27.1.0 never reads, sets or clears `CARGO_TARGET_DIR` and hands every cargo child the parent's
environment, so the baseline copy, every `--jobs` copy and the developer's own `code/src/rust` build
compile into one directory. Cargo hashes a path package by where it sits under the workspace root,
so the same crate in two copies maps to the same files, and freshness falls back to mtimes. Under
`--jobs` that brings a queue on cargo's exclusive lock, a race in which a worker tests another
worker's mutant, and a final mutant build that can look fresh to the developer's next `test.sh`.
`--in-place` drops the copies, but cannot combine with `--jobs`, edits the working tree and builds into
the developer's cache. Which mitigation the Rust leg takes is N-041 on MAP-MUTATION-TESTING's to decide (opened 15/10/2026).

1. v27.1.0 (02/06/2026) is still the latest release; MIT; not archived. `main` is 26 commits ahead,
   and none of them changes target-directory handling: the edits to `src/build_dir.rs` and
   `src/copy_tree.rs` touch only the naming of temporary directories and permission tests.
   (`gh api repos/sourcefrog/cargo-mutants/releases/latest`; `/compare/v27.1.0...main`, those two
   files' patches)
2. No file under `src/` names `CARGO_TARGET_DIR` or a target-dir option; the only target logic is the
   copy filter, which leaves the workspace's top-level `target/` out of each copy unless `copy_target`
   is set. (`cm:src/`, searched; `cm:src/copy_tree.rs:94-113`)
3. Each cargo child gets the inherited environment plus `INSTA_UPDATE=no` and `INSTA_FORCE_PASS=0`, and
   `CARGO_ENCODED_RUSTFLAGS` only when `cap_lints`, off by default, is on; nothing calls `env_clear`. A
   Rust `Command` passes the parent's environment unless told not to, so a host-set `CARGO_TARGET_DIR`
   reaches every build and test, the baseline's and each job's alike _(reasoned)_.
   (`cm:src/cargo.rs:47-66,175-201`; `cm:src/process.rs:82-90`; `cm:src/options.rs:343,518`;
   `rust-lang/rust@1.97.1:library/std/src/process.rs:854-857`)
4. In cargo that variable sets the target directory, and the build directory for intermediates
   (`deps/`, `incremental/`) follows it unless `build.build-dir` or `CARGO_BUILD_BUILD_DIR` is set.
   Builds under either the `dev` or the `test` profile land in `debug/`; a user-defined profile gets
   a directory named after it. Rust 1.97.1, which `code/src/rust` pins, ships cargo 0.98.0 at
   `c980f486`.
   (`cg:src/doc/src/reference/config.md:547-575`; `cg:src/doc/src/reference/build-cache.md:1-8,26-35,67-75`;
   `gh api` contents of `src/tools/cargo` at `rust-lang/rust` 1.97.1; `cg:Cargo.toml:149`;
   `code/src/rust/rust-toolchain.toml:18`)
5. Each scratch copy is a new temporary directory named after the source directory, and cargo runs
   inside it. With `--jobs N` there are min(N, mutant count) workers: the first takes over the
   baseline's copy, each other makes its own, and every worker reuses its copy for all the mutants it
   draws from the shared queue. A mutant runs `cargo test --no-run` and then `cargo test` as separate
   processes, after which the file is reverted in the copy and nothing is rebuilt.
   (`cm:src/build_dir.rs:55-77`; `cm:src/copy_tree.rs:80-90`; `cm:src/process.rs:90`;
   `cm:src/lab.rs:90-113,232-254,272-316`; `cm:src/cargo.rs:96-122`; `cm:src/mutant.rs:296-307`)
6. The book sizes the designed layout as one Rust target per job in the temporary directory, commonly
   2 GB or more each; a host-set variable replaces that layout. (`cm:book/src/parallelism.md:39`;
   `cm:book/src/performance.md:62`)
7. Cargo derives a unit's hash, the suffix on its artefact files, from where a path package sits
   under the workspace root, never from its absolute path, and its fingerprint design keeps
   absolute paths out of every hash so that a moved workspace keeps its cache. With profile, features
   and flags equal, the copies and the real checkout therefore produce the same unit hashes for the
   workspace crates and write the same files in a shared directory _(reasoned, not run)_.
   (`cg:src/cargo/core/compiler/build_runner/compilation_files.rs:730-760`;
   `cg:src/cargo/core/source_id.rs:560-583`; `cg:src/cargo/core/compiler/fingerprint/mod.rs:67-91,298-304`)
8. For a workspace crate, freshness is decided by mtime: the unit is stale when a source file its
   dep-info lists is newer than the fingerprint's dep-info file, whose timestamp cargo sets back to the
   moment the build that wrote it began. Registry crates are hashed by registry URL and get no mtime
   check, so a shared directory builds them once for every copy and run — the variable's one gain _(reasoned)_.
   Copied files get a fresh mtime (the reflink path sets one, and the fallback writes a new file), so a
   new copy rebuilds its workspace crates on first use, as the book says of copied trees.
   (`fingerprint/mod.rs:226-252`; `source_id.rs:578-582`; `cm:src/copy_tree.rs:34-62`;
   `cm:book/src/in-place.md:29`)
9. On stable cargo at 1.97.1 a build holds an exclusive `.cargo-build-lock` in the profile's build
   directory (only the unstable fine-grain locking makes it shared) and, for every intent except
   `check`, an exclusive `.cargo-artifact-lock` in the target directory; a second cargo waits. The locks
   belong to the build runner's layout, and `cargo test` runs its binaries only after compilation has
   returned, so no lock is held while tests execute _(reasoned)_. With a shared directory under
   `--jobs`, every worker's builds therefore queue on one lock and only test execution overlaps
   _(reasoned, not run)_. (`cg:src/cargo/core/compiler/layout.rs:226-306`;
   `cg:src/cargo/core/compiler/build_runner/mod.rs:165-176,409-429`; `cg:src/cargo/ops/cargo_test.rs:67-81,104-108`;
   `cg:src/cargo/ops/cargo_compile/mod.rs:193-197`)
10. cargo-mutants times a phase from process start to exit; the test timeout is five times the
    baseline with a 20 s floor, and no build timeout is set by default. A test-phase cargo kept waiting
    on the lock therefore spends its own test budget _(reasoned)_. (`cm:src/process.rs:78,107-111`;
    `cm:src/timeouts.rs:56-96`; `cm:src/options.rs:287-291`)
11. **The wrong-mutant race.** A worker that applied its mutant before another worker's build of the
    same crate began holds sources older than that build's dep-info, so its cargo can judge the other
    build fresh and test the other worker's mutant under its own name _(reasoned, not run)_.
    (`cm:src/lab.rs:272-316`; `fingerprint/mod.rs:226-252`)
12. **The stale build left behind.** The last mutant built for a crate stays in the shared directory
    with dep-info newer than the real tree's sources, so the `cargo test --workspace` that `test.sh`
    runs may treat it as fresh and test the mutant instead of the code _(reasoned, not run)_.
    (`cm:src/lab.rs:314-316`; `code/src/scripts/rust/test.sh:34-38`; `fingerprint/mod.rs:232-252`)
13. A dedicated profile or different flags keep the leg apart from the developer's cache: the profile
    enters the unit hash and a user-defined one builds into its own directory, under its own lock, and
    the flags `cap_lints` alters enter the unit id too. `-j1` uses only the baseline's copy, so no two
    copies collide, though the overlap with the developer's cache remains unless one of those applies
    _(reasoned)_. (`compilation_files.rs:757`; `build-cache.md:26-35`; `fingerprint/mod.rs:85`;
    `cm:src/lab.rs:94-108`; `cm:book/src/performance.md:19-39`)
14. `--in-place` is refused together with `--jobs` or any copy option, and then the baseline and every
    mutant run in the canonicalised source directory. The book advises against editing, committing or
    running tests during such a run, warns that a revert can be lost to an interrupt or a panic, and
    notes that only in place are earlier build products reused. Each mutant is applied and reverted by
    rewriting the file, so afterwards the restored file is newer than the last build and the next normal
    build recompiles that crate rather than serving a mutant; with the host variable set, that build
    lands in the developer's own directory _(reasoned)_. (`cm:src/main.rs:183-190`;
    `cm:src/build_dir.rs:42-52,79-87`; `cm:book/src/in-place.md:7-29`; `cm:src/mutant.rs:296-307`)
15. **Corrects RS 4.** The book's timeouts page says the multiplier timeouts are unavailable in place
    and the 300 s test default then applies, and the published page matched the tag on 15/10/2026. The
    v27.1.0 source falls back to 300 s only if no baseline duration exists (`--baseline=skip`), and
    its own unit tests assert that `--in-place` leaves both the test and the build multiplier working.
    (`cm:book/src/timeouts.md:48-52`; https://mutants.rs/timeouts.html; `cm:src/timeouts.rs:49,56-96,119-155`)
16. There is no target-dir option at v27.1.0. Issue #407, open since 12/09/2024, asks for one, and the
    maintainer's reply names `--cargo-arg` as the workaround; PR #627, opened 10/07/2026 to add
    the option, is open and unmerged, and a commenter has asked where a relative value would resolve
    when cargo runs inside the scratch copy. Issue #403, open since 28/08/2024, records that copying
    `target/` into each copy still gave full rebuilds, for a reason not yet found.
    (`gh api repos/sourcefrog/cargo-mutants/issues/403`, `/issues/407`, `/pulls/627`, and each one's
    comments)
17. Cargo's `build.build-dir` accepts `{workspace-path-hash}`, a hash of the canonical manifest path,
    which would give each temporary copy its own intermediates; the artefact directory's lock stays
    exclusive for test builds, and every run leaves one directory behind per copy _(reasoned)_.
    (`config.md:559-575`; `cg:src/cargo/util/context/mod.rs:763-768`; `layout.rs:294-306`)
18. Locally, no tracked file names `CARGO_TARGET_DIR` (`git grep`, exit 1); `code/src/rust/.gitignore`
    ignores `target/`, and `code/src/rust` has no `.cargo/` folder. This session's shell sets the
    variable to `~/.cache/cargo-target`, and there is no `~/.cargo/config.toml`. The setting follows
    the host's agent instructions, which keep Cargo target directories outside repositories.
    (`code/src/rust/.gitignore:3`; the session environment and a listing of `~/.cargo`, 15/10/2026;
    the host's agent instructions, outside the repository, not reproduced)

### What this addendum does not settle

- **Nothing was run.** Every exit status a tool's code does not print (PIT's command-line 0 and 1,
  Gradle's `JavaExec` failure, Muter's 255 and 64, StrykerJS after an unhandled error,
  `dart_mutant`'s error exit) and every interaction in N-014 on MAP-MUTATION-TESTING (the sharing,
  the lock queue, both races, the in-place mtime effect, the in-place timeout) is reasoned. A traced
  run would settle N-014 on MAP-MUTATION-TESTING (`-j2` with the variable set and cargo's
  fingerprint logging on); that run is how N-041 on MAP-MUTATION-TESTING, opened 15/10/2026 for
  the Rust leg's target directory, is probed first.
- Whether this workspace's crates hash the same under cargo-mutants' per-package selection as under
  `cargo test --workspace` depends on feature unification, and was not checked; nor whether cargo's
  unstable fine-grain locking, if stabilised after 1.97.1, changes N-014 on MAP-MUTATION-TESTING,
  item 9.
- Muter on Linux (the badge against the manifest and FAQ), and whether a release will carry `master`'s
  fixes: on the evidence read, a Swift leg needs a macOS host with Xcode.
- Which Arcmutate tier carries the Kotlin plugin, and whether a free open-source licence could cover
  generated projects; mutflow inside an Android Gradle build beyond the JUnit 4 note (Compose,
  Robolectric), and Apple targets for its native path.
- Whether `dart test` can run a Flutter package's `flutter_test` suites, which decides whether
  `dart_mutant` is usable on Flutter at all; `mutation_test` under a hard kill; StrykerJS on a bare
  React Native preset (MO 3 to 5 stand).
- Instrumented Android tests, Flutter widget and integration tests on a device, and XCUITest sit
  outside every tool read.
- How PIT's empty statistics score against a set threshold with `failWhenNoMutations` off; whether
  the Gradle plugin passes the Maven goal's 3,000 ms constant or the engine's 4,000.
- The book's in-place timeout statement (N-014 on MAP-MUTATION-TESTING, item 15) has not been raised
  upstream.

---

## Feeds

- `MAP-MUTATION-TESTING` (charted after this note, 15/10/2026) — every section; its slices' `ADR-US###-*`
  records link back here by path. No ADR or `STORY-PLAN-US###` exists yet.
- `GAPS.md` — the 15/10/2026 `mutmut.sh` entry cites this note (RE 1-8); the 15/10/2026 side-defect
  addition rests on RE 10.
- **N-012 on MAP-MUTATION-TESTING**, **N-013 on MAP-MUTATION-TESTING** and **N-014 on
  MAP-MUTATION-TESTING** — the Addendum (15/10/2026), one section each; through them N-030 on
  MAP-MUTATION-TESTING, N-039 on MAP-MUTATION-TESTING, N-040 on MAP-MUTATION-TESTING, and the
  could-not-run state of N-019 on MAP-MUTATION-TESTING. Two nodes were opened from them the same
  day: N-041 on MAP-MUTATION-TESTING, the Rust leg's target directory, the choice the section on
  N-014 on MAP-MUTATION-TESTING routed to N-039 on MAP-MUTATION-TESTING, a build node; and N-042 on
  MAP-MUTATION-TESTING, the native legs' tools, verdict mappings and host, from the sections on
  N-012 on MAP-MUTATION-TESTING and N-013 on MAP-MUTATION-TESTING.
- **N-020 on MAP-NATIVE-MOBILE-SURFACE** (native testing) — the Addendum's section on N-012 on
  MAP-MUTATION-TESTING (Kotlin and Swift tools; MO 6 is superseded).
- `MAP-FRAMEWORK-NEUTRAL-FOUNDATION` — the per-tool exit and verdict facts (PY 8-11, PA 3-5, RS 3, MO 2)
  a language-neutral runner contract would have to normalise.
