# ADR-US004: A registered path may name a class, not only an instance

**Status:** Accepted
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US004

---

## Context

`how-to/src/PROJECT-PATHS.md` is the register of paths a document may cite that this repository
does not hold, each row naming **what creates it** and **when**. `code/src/scripts/audits/doc-references.sh`
reads the first backticked cell of every row under `## Registered paths` and passes any citation
that matches. The rule it serves is `code/docs/FORWARD-VOICE.md` Section 3.

US004 adds a `project-management/src/*` arm to Check 1's checkable-tree case, which makes the PM
artefact tree verifiable for the first time. Measured by executing a patched copy of the script,
that arm alone takes `project-management/src` from **16 dangling-path findings to 38**. **All 22
additions are forward references to `project-management/src/18-TESTS/US###-MANUAL-TESTING.md` and
`US###-TEST-STATUS.md`** — files `project-management/workflows/22-implementation-documentation/`
writes after the story that cites them exists. They are correct as intent and absent as of today,
which is precisely what the register was built for.

**The register cannot express them.** `is_registered()` is

```bash
[ -n "$REGISTERED" ] && printf '%s\n' "$REGISTERED" | grep -qxF "$1"
```

— fixed-string, whole-line — and all three existing rows are literal paths
(`code/src/django/apps/marketing/`, `code/src/django/config/api.py`,
`code/src/django/components/`). A row written
`project-management/src/18-TESTS/US###-MANUAL-TESTING.md` matches no concrete citation, so under
exact matching the 22 need 22 rows, and every future story needs one more.

The register's own doctrine bounds the answer. It states that a row must never answer an open
decision in passing, and warns at length about rows that promise more than the thing creating
them delivers. Whatever mechanism is chosen has to stay narrow enough to survive that.

Surfaced at `11-qa-checks` as AC-GAP-2 of
`project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`, which overturned
US004's own written premise that patterned rows already worked.

## Options considered

### Option A — one literal row per story

- **Summary:** keep `is_registered()` exact; add
  `project-management/src/18-TESTS/US001-MANUAL-TESTING.md` and its siblings, one row at a time.
- **Pros:** no mechanism change; every row is exactly as narrow as the register's doctrine wants;
  a dead citation to a story that never existed is still caught.
- **Cons:** unbounded — two rows per story, forever, added by a workflow with no reason to
  remember. The register becomes a ledger of instances rather than a statement of what creates
  what, and the first story that forgets reddens the gate for a correct citation.

### Option B — patterned rows, `###` translated before matching

- **Summary:** `is_registered()` rewrites `###` to three digit classes, so a row may name
  `US###-MANUAL-TESTING.md` and match `US001-`, `US002-` and every successor.
- **Pros:** one row binds a class; a new story owes no register edit. `###` is the spelling
  `US000-TEMPLATE.md`, the folder naming rules and the script's own `is_naming_row` already use, so
  the register keeps reading like every other document here.
- **Cons:** a patterned row is broader than a literal one, so the doctrine against answering in
  passing bites harder. The register can now under-report: a citation of
  `US999-MANUAL-TESTING.md`, for a story that does not exist, passes.

### Option C — real shell globs in the row

- **Summary:** write `US*-MANUAL-TESTING.md` and match with bash `case`.
- **Pros:** no translation step; the matching semantics are the shell's and need no explaining.
- **Cons:** `*` would be the only place in this repository where a story number is written as a
  glob, against `###` everywhere else. Broader than Option B — `US*` matches `USER-…` — and the
  breadth is invisible to a reader skimming the table.

### Option D — a `doc-references: ignore` marker on each of the 22 sites

- **Summary:** suppress line by line, no mechanism change.
- **Pros:** explicit at the point of use; the register stays literal.
- **Cons:** 22 edits across nine files, two of them owned by a concurrent session. It **suppresses
  the check rather than answering it** — the marker's documented meaning is "a path belonging to
  another repository", which is false here — and it leaves the next story to add two more markers
  with no rule telling it to.

## Decision

**We will take Option B.** The deciding factor is that the register is read by a human before it
is read by a script, and `###` is how this repository writes a story number everywhere else —
in `US000-TEMPLATE.md`, in each folder's naming rules, and inside `is_naming_row` itself. A form
the reader already knows costs nothing to learn and cannot be misread as a wildcard wider than it
is.

Option A is correct and unbounded; the register would accumulate two rows per story and fail
closed the first time one was missed. Option C buys nothing over B and introduces the only shell
glob in a repository of `###`. Option D writes a false justification into 22 lines.

The translation is **exactly three digits**, not `[0-9]+`. `US1234-MANUAL-TESTING.md` and
`USxyz-MANUAL-TESTING.md` still report, which keeps the row a statement about a naming convention
rather than a hole.

## Consequences

- **Positive:** one row binds a whole artefact class. The 22 forward references pass, and the next
  story's two pass without a register edit.
- **Positive:** the register stops being a place where a mechanism limit dictates the doctrine —
  before this, "what may a document promise" was answered by what `grep -qxF` could match.
- **Negative / trade-off:** the register can under-report. A citation of a per-story artefact whose
  story does not exist now passes, where a literal row would have caught it. Accepted because the
  story number in such a citation is itself the error, and `US###.md` is checkable by Check 1's new
  arm — the wrong story number is caught one hop away.
- **Negative / trade-off:** a patterned row is a broader promise, so the register's guardrail
  against answering in passing needs restating rather than assuming. `code/docs/FORWARD-VOICE.md`
  Section 3 must say a row may be patterned **and** that one is written only for a class something
  actually cites.
- **Follow-on:** US004 writes exactly two rows —
  `project-management/src/18-TESTS/US###-MANUAL-TESTING.md` and `US###-TEST-STATUS.md`. **No
  `17-STORY-PLANS` row**, measured: nothing in the repository cites a story plan that does not
  exist, and a row for it would be the register answering in passing.
- **Follow-on:** `code/docs/FORWARD-VOICE.md` Section 3 and the register's own header gain the
  pattern form and the duty to add a row when a citation first needs one. The duty is stated
  there once and in no workflow `CHECKLIST.md`.
- **Follow-on:** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
  retires by its own terms when US004 lands — recorded here and in the sibling record rather than
  by a status change, because its reasoning was never overturned.
