# QA Plan — US012 A seeded file that never lands is reported, and the gate's header claim becomes true

| Field         | Value                                                                                                                       |
| ------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Story**     | US012 — A seeded file that never lands is reported, and the gate's header claim becomes true                                |
| **Date**      | 21/09/2026                                                                                                                  |
| **Sprint**    | SPRINT-07 — admitted as its `Must`, 2 SP taking the record to 10 / 11; the record itself is written by `03-sprint-planning` |
| **Wireframe** | N/A — this story edits one bash script under `.github/scripts/`, not a screen                                               |
| **Status**    | Signed off · **corrected in place 30/09/2026** — see below                                                                  |

<!-- STEP 1's GRILLING PASS IS THE 21/09/2026 MAP-SCRIPT-GUARDS INTERVIEW ROUND, not a second one.
     Q1 settled that this story owns both the check-4 `SEEDED` loop and the seeded-deletion probe,
     and that US010 keeps only the growing of `SEEDED`; Q2 settled `Must`, 2 SP, SPRINT-07; the
     FLAGS reading — QA carries the value, Security N/A — was Claude's call and was accepted. The
     gate's own scope questions (test scope, the highest-risk area) were answered from that round
     and from the story's QA flag, not re-asked. Every gap below is a precision or testability
     repair INSIDE that settled scope: none moves the loop, the probe's existence, the priority or
     the estimate. Sign-off is <%DEVELOPER_NAME%>'s, which is why Status reads Reviewed.

     FOUR GAPS RESTED ON A CALL, AND <%DEVELOPER_NAME%> SETTLED ALL FOUR ON 21/09/2026, answering
     three questions this pass and SPRINT-07's admission of the story left with him — the
     follow-up round, Q1 to Q3, distinct from the MAP-SCRIPT-GUARDS interview round earlier that
     day. Q2 settled AC-GAP-4 and Q3 settled AC-GAP-6; this pass's calls on AC-GAP-2 and AC-GAP-5
     were put in the same round and stand. Q1 closed SPRINT-07 to further admission, and is that
     record's to carry rather than this plan's. Each settlement is written beneath its gap's
     resolution and in the story; none moves the loop, the probe, the priority or the estimate.
     Settling four gaps is not signing the plan off, so Status still reads Reviewed.

     STEP 2 HAS NO WIREFRAME TO REVIEW. The scenarios are derived from the story's Gherkin and the
     script, as QA-PLAN-US004 and QA-PLAN-US009 derived theirs.

     STEP 3 — THE qa-tester DISPATCH. Run as a forked skill on 21/09/2026, twice: the first
     returned no text, the second returned twelve items (3 high, 5 medium, 4 low). Nine are folded
     into the gaps below and credited where they land; one becomes EC-08; two are recorded in
     Section 8 as not taken. Three findings are this pass's own and the dispatch did not raise
     them: AC-GAP-3's wrong-reason red, AC-GAP-4's missing home for the runs, and the
     unsubscripted-array defect behind AC-GAP-5.

     METHOD. Measured by executing, never by reading — the QA-PLAN-US004 lesson. No generated tree
     exists on this host, and none may be made with a raw `uvx copier copy`
     (`.claude/CLAUDE.md` Section 6), so every run in Section 7 is against a MINIMAL FIXTURE under
     /tmp: the four pair-only trees, every `NAMED_SHIPPED` file, one file per `SHIPPED_GLOBS`
     pattern and the seed, read by a scratch copy of the script whose `../../copier.yml` is a copy
     of the real one (the script resolves it from its own location, `:66-68`). Nothing was written
     into the repository and the fixture was deleted afterwards. Fixture readings are indicative;
     the proof of record is CI's generated tree (AC-GAP-4). Every citation the story makes into
     the script, `copier.yml`, `audit-template.yml`, the two maps and SPRINT-07 was re-opened the
     same day, and every one holds.

     SIGNED OFF 30/09/2026 by <%DEVELOPER_NAME%> (settled 30/09/2026, 16-sprint-plans grilling
     round 3 Q9), against the tree at a18db0b with that gate's corrections applied. The Status row
     read "Reviewed — all nine gaps resolved into the story; AC-GAP-2,
     -4, -5 and -6 settled by <%DEVELOPER_NAME%>, all 21/09/2026" until then, and the two sentences
     above that say Status reads Reviewed are the record of 21/09/2026, kept as written. -->

> **Corrected in place, 30/09/2026, at the `16-sprint-plans` gate, and signed off by
> <%DEVELOPER_NAME%>**: gate 11 closes when a QA plan reads `Signed off`, as gate 10 does (settled
> 30/09/2026, 16-sprint-plans grilling round 3 Q9), and this plan's sign-off closes it for US012.
> One citation is corrected in the same pass, a call made 30/09/2026 while applying round 3, not
> one of its answers. <%DEVELOPER_NAME%> reviewed every change made under this sign-off, that call
> and its dated comment in Section 7 among them, and accepted them all (settled 30/09/2026,
> 16-sprint-plans grilling round 5 Q16):
>
> - **Every line citation was re-measured on 30/09/2026**, against the tree committed together
>   with the 18-TESTS split, and holds or is re-pointed. Two had moved, both in `copier.yml`, which
>   the split changes above the seed task: AC-GAP-6's `:973-984` sits at `:994-1005` and Section 5's
>   `:967-972` at `:988-993`, each old number kept in a dated comment beside it. The split also
>   rewrites two `NAMED_SHIPPED` entries of `.github/scripts/shipped-artefacts.sh` in place, moving
>   none of its lines; every other file this plan cites by line is unchanged since `71a32d7`, where
>   it was measured (Section 7). It cites none of the story's lines, so the story's correction on
>   30/09/2026 moves nothing here. The copier 9.18.2 source it cites, `_main.py:441-445`, was
>   re-read in the local cache.
> - **One citation named the story as a bare filename**, which the citation audit reads as an
>   unresolvable instance citation. Section 7's lead now gives the full path; the reading it
>   records is unchanged.
>
> No gap, finding or scenario moved. The superseded wording is kept in a dated comment beside the
> text that replaced it.

---

## 1. Acceptance criteria gaps

**Nine gaps found — five material, four minor, none blocking. All nine are
`[RESOLVED] 21/09/2026`:** each was fed back into `project-management/src/02-STORIES/US012.md` as
a Gherkin line, a QA criterion or a task, in the same pass, before `16-sprint-plans` could read the
story. The story's premise survives intact: on the fixture, deleting the seed from a generated tree
produced **zero findings and exit 0** from both the full run and `--self-test` (Section 7). What
the gaps repair is how the fix is proven, and two places where the script would go on giving the
wrong advice after it. **Four of the nine — AC-GAP-2, -4, -5 and -6 — rested on a call, and
<%DEVELOPER_NAME%> settled all four the same day;** each carries its settlement after its
resolution.

- **AC-GAP-1** `[RESOLVED] 21/09/2026` · material — **the script would still send a seed finding
  to the allowlist, and the story's header scenario does not reach the lines that do it.** The
  story's cutting call is that a seed's finding must never suggest a `!` negation, because that is
  the one edit that turns a missing seed into a leak. The finding line obeys it; the full run then
  prints its closing guidance **after every finding** (`:340-343`): _"copier.yml's \_exclude is
  the ONLY thing keeping them out ... Fix the allowlist there"_. Measured on the fixture with the
  loop in place: the seed finding printed, and the paragraph beneath it told the reader to fix the
  allowlist. Three more sites describe check 4's failures as allowlist failures and nothing else —
  the exit-code line in the header (`:59-61`, "a template file is missing"), its twin in `--help`
  (`:126-127`), and the check-4 comment (`:209-214`, "dropping its `!` negation ... is the
  regression this catches"). And the too-tight paragraph (`:40-43`) was left to judgement — "edit
  it only if it still reads as covering named files alone" — when a seed that did not land is not
  a tight allowlist at all but a copy-gated move that did not happen. **Resolution:** a Then on the
  remedy scenario — the closing guidance does not direct a seed finding to the allowlist — and the
  header scenario now names the exit-code lines, the check-4 comment and the too-tight paragraph,
  the last made definite. Two tasks added and the too-tight task made unconditional. qa-tester
  items 1 and 4.
- **AC-GAP-2** `[RESOLVED] 21/09/2026` · material — **`probe()` carries one substring, so it can
  prove the seed wording and cannot prove the absence of the negation.** `probe()` (`:232-235`)
  passes on exactly one finding containing `$2`. The story's QA criterion claimed the repair
  wording is "asserted on the string, not read by eye". Half true. Measured with a string test: a
  finding reading _"<path> was seeded but did not land — add a '!' negation for it in
  copier.yml"_ **passes** a probe on _"<path> was seeded but did not land"_, while the named-file
  message for the same path correctly fails it. So the probe carries the positive half — right
  path, seed wording, not a copy of the sibling — only if the finding puts the seed wording
  **immediately after the path**, so that one contiguous substring spans both. The negative half —
  no `!` advice — has no automated carrier. **Resolution:** the task fixes the finding's shape
  (path, then seed wording); the QA criterion states which half the probe carries and that the
  negative half is read at review and recorded as read, never as asserted. A forbidden-substring
  argument to `probe()` would carry it mechanically; it is new machinery the story declined, and
  was left as a non-blocking question rather than added here. qa-tester item 2. **Settled by
  <%DEVELOPER_NAME%>, 21/09/2026** (follow-up round): the call stands, and the question is closed.
  `probe()` gains no forbidden-substring argument; the negative half stays a review read, the
  reviewer checking the fix-advice wording in the finding and in the closing guidance beneath it.
- **AC-GAP-3** `[RESOLVED] 21/09/2026` · material — **"`--self-test` exits 1" does not evidence
  the red run, because the wrong failure exits 1 too.** The script runs under `set -euo pipefail`
  (`:64`). Before the loop exists the baseline (`:253-258`) does not assert seeds, so a tree that
  lacks the seed passes it — and the new probe's `mv` then aborts the script. Measured: `mv: cannot
stat ...`, **exit 1, no cross line for the probe, and a leaked temporary directory**, because the
  `RETURN` trap at `:263` never fires on a `set -e` exit. The right red, also measured, prints the
  probe's own line — _"check 4 fires when a seeded file does not land produced 0 finding(s):
  (none);"_ — with the other five probes passing. **Resolution:** the red run is evidenced by that
  line and the five passes, taken on a tree in which every seed is present; exit 1 alone is never
  the evidence. The green run's success line reads **6 probes** (5 today, `:269`, `:274`, `:279`,
  `:284`, `:293`).
- **AC-GAP-4** `[RESOLVED] 21/09/2026` · material — **the story never says where its runs happen,
  and the obvious place is forbidden.** Every proof needs a generated tree. No project script
  makes one — `[3/4] Template Generation` is CI-only by design (`lefthook.yml:177-181`) — and a
  raw `uvx copier copy` is exactly what Section 6 bans, "whether you are running it or writing it
  into a doc". A developer following the QA tasks as written has no lawful local red run.
  **Resolution:** the red and green runs are CI runs of `[3/4]` on the pushed story branch, which
  `audit-template.yml:32-34` triggers on every branch — the probe committed and pushed alone
  first, the loop second, each run recorded by its ID in the test-status record. That order is
  also what shows "no change to the probe" between red and green. The one proof that needs no tree
  is the string one — the named-file message against the probe's substring — so the story's
  scratch-edit task becomes a string test. **Settled by <%DEVELOPER_NAME%>, 21/09/2026**
  (follow-up round, Q2): the red run is a deliberately red commit — the probe without the loop —
  pushed to the `us012/` story branch so that CI's `[3/4]` job runs it. No lawful local generation
  path exists, and none is to be improvised.
- **AC-GAP-5** `[RESOLVED] 21/09/2026` · material — **a probe on the first entry cannot see a loop
  that only reads the first entry.** Bash expands an unsubscripted array to element 0 — measured:
  `for n in "${A}"` over `A=(a b c)` iterates once, on `a`. A loop written `for n in "${SEEDED}"`
  passes the story's probe (which moved `${SEEDED[0]}`) and the full run today, and checks one
  seed of eight once US010 grows the array — silently, which is the defect class this story
  exists to close. The loop scenario's "whichever position it holds" had no carrier. **Resolution:**
  the probe moves the **last** entry, `${SEEDED[${#SEEDED[@]}-1]}` — the same file while there is
  one entry, a non-first position the moment US010 lands, in either order. The portable form is
  deliberate: `${SEEDED[-1]}` is a "bad array subscript" on bash 3.2, which macOS still ships as
  `/bin/bash`. qa-tester item 6, which proposed a second probe; one probe moved costs nothing.
  **Settled by <%DEVELOPER_NAME%>, 21/09/2026** (follow-up round): the call stands — the probe
  moves the last entry of `SEEDED`, by that index expression, and no second probe is added.
- **AC-GAP-6** `[RESOLVED] 21/09/2026` · minor — **the `Must` rationale's "no job goes red" is
  too strong for the seed it names.** The `_tasks` entry is one `&&` chain ending `rmdir .copier`
  (`copier.yml:994-1005`), and Copier raises `TaskError` on a non-zero task (read in the cached
  copier 9.18.2, `_main.py:441-445`). So a seed file removed with its `mv` kept, or an `mv` removed
  with its seed kept, fails generation at `audit-template.yml:151-163`. A seed and its `mv` removed
  together, or a retargeted `mv`, leaves `MAP-SCALE-PLANNING.md`'s citations unseeded, and
  `doc-references.sh` reports them (`is_seeded`, `:373`; `:773`) — but that gate exits 1 on the
  whole tree today and runs only against `main`, `staging`, `dev` and `testing`
  (`audit-doc-references.yml:28-32`), so the rows land in a report that is already red. **Fully
  silent:** a seed that landed and was removed by a later step, and — for US010's seven indexes,
  whose target paths are populated in-tree — a seed and its `mv` removed together. **Resolution:**
  the sentence is narrowed to that. The `Must` stands on its first reason, the header's false
  claim, which is unchanged; the priority settled at Q2 is not reopened. qa-tester item 3.
  **Settled by <%DEVELOPER_NAME%>, 21/09/2026** (follow-up round, Q3): the story stays `Must` on
  the narrowed rationale. The case no job reports is `MAP-SCALE-PLANNING.md`, which six shipped
  guides route to, plus the seven index seeds US010 adds; the story's MoSCoW comment now states it
  in those terms.
- **AC-GAP-7** `[RESOLVED] 21/09/2026` · minor — **"never by deleting the path from `SEEDED`" is
  an instruction, not an outcome, and it forbids a legitimate retirement.** Nothing observable
  distinguishes a deletion made to silence the check from a seed retired on purpose. **Resolution:**
  the scenario keeps its testable Thens — the baseline refuses, the seed finding is printed, exit 2
  (measured) — and the repair rule moves to the comment above `SEEDED`, with the carve-out: a seed
  retired on purpose loses its `.copier/` file, its `mv` line and its `SEEDED` entry in one change.
  qa-tester item 8.
- **AC-GAP-8** `[RESOLVED] 21/09/2026` · minor — **"its seed under `.copier/`" did not say whether
  the finding names a source path.** `SEEDED` holds target paths (`:105`); the source name exists
  only in the `mv` line. Computing it by basename is a convention that holds for all eight seeds
  today (US010's `.copier/<NOUN>-INDEX.md` against `<REGISTER>/<NOUN>-INDEX.md`) and is enforced
  by nothing; parsing it from `copier.yml` is new machinery. **Resolution:** the finding names the
  target path and points at "its `mv .copier/...` line" in the copy-gated `_tasks` entry, generically;
  it computes no source name and the probe asserts none. qa-tester item 7.
- **AC-GAP-9** `[RESOLVED] 21/09/2026` · minor — **two wording repairs.** The clean-generation
  scenario's Given presupposed its own Then ("every path named in `SEEDED` is present") and read
  "either" answer set where its When read "both"; it now names the two trees `[3/4]` generates.
  The ShellCheck criterion was headed "clean" while allowing "not run" — and `shellcheck` is not
  installed on this host (Section 7) — so it now reads "result recorded". qa-tester items 9 and 11.

<!-- AMENDED 30/09/2026: AC-GAP-6 cited the seed task as `copier.yml:973-984` until then, measured
     against `71a32d7` and unchanged at a18db0b. The 18-TESTS split, committed together with this
     correction, adds 21 lines above the task, which sits at :994-1005 in that tree, re-measured
     30/09/2026, the text unchanged. -->

---

## 2. Test scenarios

Derived from the story's Gherkin and the script. **Every row runs against the script; none
against a rendered surface.** "Measured" means observed on the Section 7 fixture; the rest are
executed at implementation against CI's generated tree.

### Happy path (HP-nn)

| ID    | Given                                                     | When                                      | Then                                                                                                                                                                                              |
| ----- | --------------------------------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HP-01 | The two trees `[3/4]` generates (`gen-false`, `gen-true`) | The full run, as `audit-template.yml:228` | Exit 0; no check-4 finding for any seed; check 3 admits every seed                                                                                                                                |
| HP-02 | `gen-false`, loop and probe in place                      | `--self-test`, as `:225`                  | Six probes pass and the success line reads **6 probes**. Measured                                                                                                                                 |
| HP-03 | The self-test's copy, baseline clean                      | The probe moves the last `SEEDED` entry   | Exactly one finding, check 4's, the moved path followed directly by the seed wording. Measured                                                                                                    |
| HP-04 | The seed restored after HP-03                             | The check-5 probe runs next               | It sees exactly its own one finding — no probe inherits the deletion. Measured                                                                                                                    |
| HP-05 | The seed present beside a planted map                     | Check 3's map-leak probe (`:272-275`)     | Still exactly one finding. Measured                                                                                                                                                               |
| HP-06 | The change applied                                        | The header, `--help` and comments read    | Check 4's list entry, the too-tight paragraph, `SELF-TEST`, `--help`, both exit-code lines, the check-4 comment and the `SEEDED` comment all name seeds; "What it CANNOT check" is byte-identical |

### Error states (ES-nn)

| ID    | Given                                                     | When                         | Then                                                                                                                |
| ----- | --------------------------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| ES-01 | A generated tree lacking a seeded file                    | The full run                 | One finding naming the path as a seed that did not land; exit 1. Measured                                           |
| ES-02 | The same                                                  | The closing guidance is read | It does **not** send the reader to `_exclude` or a `!` negation. **Fails today** — measured (AC-GAP-1)              |
| ES-03 | The real tree lacking a seed, loop in place               | `--self-test`                | The baseline refuses, the seed finding goes to stderr, no probe runs, exit 2. Measured                              |
| ES-04 | The probe committed without the loop; every seed present  | `--self-test` (the red run)  | The probe's own line reports 0 findings, the other five pass, exit 1. Measured                                      |
| ES-05 | The probe committed without the loop; the seed **absent** | `--self-test`                | `mv` aborts under `set -e`: exit 1, **no probe line**, a leaked temp dir. **Not red evidence** (AC-GAP-3). Measured |

### Edge cases (EC-nn)

| ID    | Given                                                              | When                                  | Then                                                                                                                                           |
| ----- | ------------------------------------------------------------------ | ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| EC-01 | `SEEDED` grown to three entries, the middle one absent             | The full run                          | Exactly one finding, naming the middle entry. Measured                                                                                         |
| EC-02 | A loop written over `"${SEEDED}"`, `SEEDED` of more than one entry | `--self-test`                         | The last-entry probe sees 0 findings and fails (AC-GAP-5)                                                                                      |
| EC-03 | The `mv` retargeted to the `project-management/src/` root          | The full run                          | Two findings — check 3's leak and check 4's seed — both true, and together the right diagnosis. Measured                                       |
| EC-04 | The seed lands as a directory                                      | The full run                          | Check 4's seed finding (`-f` is false) and check 3's leak for what it holds. Measured                                                          |
| EC-05 | `project-management/src/` absent entirely                          | The full run                          | Exactly one finding, the tree's — not one per seed, because the loop sits in check 3's `else`. Measured                                        |
| EC-06 | A path registered in both `NAMED_SHIPPED` and `SEEDED`             | That file deleted                     | Two findings with contradictory repairs; the probe fails loud. A path belongs in one array. Measured                                           |
| EC-07 | The probe's substring                                              | Tested against the named-file message | No match — the sibling's copy fails the probe. Against seed wording plus `!` advice: **match** (AC-GAP-2). Measured                            |
| EC-08 | `SEEDED` emptied                                                   | `--self-test`                         | The probe's subscript aborts under `set -u`. **Known limitation, not fixed**: retiring the last seed removes the probe in the same change      |
| EC-09 | `gen-true`                                                         | `--self-test`                         | Never read — `:225` passes `gen-false` and `:250` reads the first target only. Seeds are not mobile-gated, so the full run at `:228` covers it |

### Permission and access (PA-nn)

**N/A.** This story ships no endpoint, no view and no protected action; the script runs with the
caller's own permissions and reads a tree Copier already produced. Recorded rather than omitted,
per `code/docs/GATE-REPORTING.md`.

---

## 3. Accessibility notes (WCAG 2.2 AA)

**N/A — no rendered screen or interactive component.** The output is terminal text. The one
property worth keeping is the existing one: the failing probe line is red, but carries a cross and
the words "produced N finding(s)", so colour is never the only signal. The new probe and finding
inherit it by following the `probe()` and `finding()` idiom.

## 4. Responsive behaviour

**N/A — no layout, no breakpoint, no rendered page.**

## 5. GDPR & security constraints

**No PII and no new protected action.** The script reads file names in a generated tree and emits
paths. The `Security` flag is `N/A` with its reason in the story, and this pass found nothing to
move it.

**One QA-visible constraint has a security shape, and it is AC-GAP-1's and AC-GAP-2's reason.**
For a seed whose target path is populated in-tree — every index US010 adds — a `!` negation renders
syntek-base's own rows into a project wherever the copy-gated `mv` does not run behind it, which is
every `copier update`: the one-way door `copier.yml:988-993` names. A finding or a closing paragraph
that advises the negation is therefore not a wording fault; it is advice to open that door. ES-02
and EC-07 are the tests, and the negative half of EC-07 is read at review.

<!-- AMENDED 30/09/2026: the paragraph above cited the one-way door as `copier.yml:967-972` until
     then, measured against `71a32d7` and unchanged at a18db0b. The 18-TESTS split, committed
     together with this correction, adds 21 lines above it, and it sits at :988-993 in that tree,
     re-measured 30/09/2026, the text unchanged. -->

**The wrong-reason red leaks a temporary directory** holding a copy of the generated tree (ES-05).
A generated tree carries no secret, so this is hygiene, not exposure; it is recorded so that a
developer who sees `/tmp/tmp.*` accumulate knows where it came from.

---

## 6. Developer notes — testability

- **Commit the probe alone and push it; the red run is CI's.** It is a deliberately red commit on
  the `us012/` story branch, settled by <%DEVELOPER_NAME%> on 21/09/2026. `[3/4]` runs on push to
  every branch (`audit-template.yml:32-34`). Record the red run's ID and the probe line from its
  log, then commit the loop and record the green run's ID and its **6 probes** line. Never make a
  tree with a raw `uvx copier copy` to shortcut this (AC-GAP-4).
- **A local fixture is cheap and lawful, and it is indicative only.** Pairs in `research/`,
  `handoffs/`, `learning/` and `questionnaires/`; each `NAMED_SHIPPED` file; one file per
  `SHIPPED_GLOBS` pattern; the seed. Copy the script to `<scratch>/.github/scripts/` and `copier.yml`
  to `<scratch>/`, because `:66-68` resolves `copier.yml` two levels above the script. Run it with
  `bash`. Nothing goes into the repository.
- **Take the red run on a tree where every seed is present.** Otherwise the probe's `mv` aborts
  first and the exit 1 means nothing (ES-05).
- **Shape the finding as path, then seed wording** — for example _"`<path>` was seeded but did not
  land — ..."_ — so the probe's one substring spans both (AC-GAP-2). The wording is the
  implementer's; the shape is not.
- **Prove the string half without a tree:** evaluate the probe's substring against the named-file
  message for the same path with a bash `[[ ... == *...* ]]` test. It must not match.
- **Loop over `"${SEEDED[@]}"`, never `"${SEEDED}"`**, and put the loop beside `:215-218`, inside
  check 3's `else`, so a missing `project-management/src/` stays one finding (EC-05).
- **Address the probe as `${SEEDED[${#SEEDED[@]}-1]}`**, not `[-1]` (AC-GAP-5). Reusing
  `$tmpdir/held` is safe: the check-4 probe has already moved its file back.
- **Do not compute a `.copier/` source path in the finding** (AC-GAP-8).
- **ShellCheck is not installed on this host** (21/09/2026). Install it and record the result, or
  record "not run" with that reason — never a `lint.sh` pass, which has no shell leg.
- **Whichever of US010 and this story lands second rebases.** If US010 is first, the green run
  already covers eight seeds and the last-entry probe exercises the eighth; if this story is first,
  US010's own green run is where the last-entry probe first moves off `MAP-SCALE-PLANNING.md`.
- **No pytest, no coverage figure, no migration check.** The story marks those rows `N/A` with
  reasons; the test-status record must carry the same, not leave them blank.

## 7. Gate readings, measured 21/09/2026 — indicative, not baselines

Taken on `pm/story-creation` at `71a32d7`, with three modified PM files and
`project-management/src/02-STORIES/US012.md` untracked. The fixture rows are a minimal tree, not a
generation.

<!-- AMENDED 30/09/2026 at the sign-off (call made 30/09/2026 while applying 16-sprint-plans grilling
     round 3): the lead read "with three modified PM files and US012.md untracked", the filename
     in backticks, until then, a bare instance citation the citation audit cannot resolve
     (doc-references.sh --path over this plan, one finding, measured 30/09/2026). It carries the
     full path now; the reading is unchanged. -->

**Every citation in this plan was re-measured on 30/09/2026**, against the tree committed together
with the 18-TESTS split. `.github/workflows/audit-template.yml`, `audit-doc-references.yml` and
`lefthook.yml` are unchanged since `71a32d7`. `.github/scripts/shipped-artefacts.sh` has two
`NAMED_SHIPPED` entries rewritten in place by the split, no line moved, and `copier.yml` gains
lines above the seed task, re-pointed in Sections 1 and 5. The fixture readings below stay readings
of that day: `SEEDED` still holds one entry at `.github/scripts/shipped-artefacts.sh:105`, and the
five probes still sit at `:269`, `:274`, `:279`, `:284` and `:293`.

| Reading                                           | Value                                                                                                       |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `shipped-artefacts.sh` length · `SEEDED`          | 344 lines · one entry at `:105`                                                                             |
| `--self-test` probes today                        | **5** — `:269`, `:274`, `:279`, `:284`, `:293`                                                              |
| Fixture, today's script, seed deleted             | Full run **0 findings, exit 0**; `--self-test` **5 probes, exit 0** — the premise holds                     |
| Fixture, probe only, seed present (the right red) | Probe line "produced 0 finding(s): (none);", five passes, **exit 1**                                        |
| Fixture, probe only, seed absent (the wrong red)  | `mv: cannot stat`, **exit 1**, no probe line, one temp dir leaked                                           |
| Fixture, probe and loop, seed present             | **6 probes, exit 0**                                                                                        |
| Fixture, probe and loop, seed absent              | `--self-test` baseline refuses, **exit 2**; full run 1 finding, exit 1, allowlist advice printed beneath it |
| Fixture, three seeds, middle absent               | 1 finding, exit 1                                                                                           |
| `shellcheck` on this host                         | **Not installed**                                                                                           |
| `doc-references.sh`, whole tree                   | **Exit 1** — inherited red; CI runs it on `main`, `staging`, `dev`, `testing` only                          |
| Copier on a failing task                          | `TaskError` — cached 9.18.2, `_main.py:441-445`; CI's `uvx copier` is unpinned                              |

**One count the next reader should not re-derive:** 5 probes today, 6 after. A green run printing
5 means the probe was never added; one printing 7 means something else was.

## 8. Two candidates not taken, and why they are recorded

- **"The second role, a developer generating a project, is overclaimed — the gate never runs in a
  generated project."** True of the gate: `.github/scripts` is template-only, asserted absent at
  `audit-template.yml:201-205`. Not a gap: the role and benefit were settled on 21/09/2026, and the
  benefit is real if indirect — the developer generating a project is the person who receives the
  seed, or does not. The gate runs where the defect is introduced, which is syntek-base's CI.
- **"The `.copier/ survived generation` step already asserts the seeds."** It asserts that the
  staging directory is gone (`audit-template.yml:311-312`), not that anything arrived at its target.
  A seed and its `mv` removed together leave `.copier/` emptied and removed, and the step passes.

---

## Cross-references

- `project-management/src/02-STORIES/US012.md` — the story this plan tests; all nine gaps above are `[RESOLVED] 21/09/2026` in it
- `project-management/src/11-QA/IMPLEMENTATION/QA-IMPL-US000-TEMPLATE.md` — the post-implementation review that verifies this plan against the shipped change
- `project-management/src/03-SPRINTS/SPRINT-07.md` — the record this story is admitted to as its `Must`
- `project-management/src/01-FEATURE-MAPS/MAP-SCRIPT-GUARDS.md` — slice `S-02`, node `N-005`
- `project-management/src/02-STORIES/US010.md` — grows `SEEDED` to eight; the last-entry probe is written for that
- `project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md` — the measure-by-executing precedent
- `.github/scripts/shipped-artefacts.sh` · `.github/workflows/audit-template.yml` — the script and the job that runs it
- `code/docs/GATE-REPORTING.md` — the rule behind the `N/A` sections, the ShellCheck reading and ES-05
- `project-management/docs/QA-GUIDE.md` — the governing QA guide
- `project-management/workflows/11-qa-checks/` — the workflow that produced this plan
